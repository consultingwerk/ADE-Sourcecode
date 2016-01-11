&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : adeuib/_abprint.p
    Purpose     : Print a procedure or section of a procedure in the 
                  AppBuilder.

    Syntax      :

    Description :

    Author(s)   : Tammy Marshall
    Created     : 04/22/99
    Notes       :
    
    Modified    : 06/16/99  tsm  Changed display of file name in header to
                                 to display an abbreviated file name and to
                                 display (Untitled) for unsaved files
                  06/16/99  tsm  Added pcSection input parameter to display
                                 the section being printed in the header when
                                 printing from the section editor
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{adecomm/adefext.i}
{adeuib/sharvars.i}

DEFINE INPUT  PARAMETER pcPrintFile AS CHARACTER NO-UNDO.  /* text file to print */
DEFINE INPUT  PARAMETER phWindow    AS WIDGET    NO-UNDO.  /* parent window */
DEFINE INPUT  PARAMETER pcProcName  AS CHARACTER NO-UNDO.  /* procedure name */
DEFINE INPUT  PARAMETER pcSection   AS CHARACTER NO-UNDO.  /* Section being printed - "" when printing entire procedure */
DEFINE OUTPUT PARAMETER plPrinted   AS LOGICAL   NO-UNDO.  /* returns TRUE if able to print */

DEFINE STREAM InStream.
DEFINE STREAM OutStream.

DEFINE VARIABLE Text_Line             AS CHARACTER FORMAT "x(255)" NO-UNDO.
DEFINE VARIABLE lPrintDialog          AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE _comp_temp_file_paged AS CHARACTER                 NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
 
  /* Point to a valid window handle. */
  ASSIGN phWindow = IF VALID-HANDLE( phWindow ) THEN
                      phWindow
                    ELSE IF VALID-HANDLE( CURRENT-WINDOW ) THEN
                      CURRENT-WINDOW
                    ELSE
                       DEFAULT-WINDOW.
                              
  RUN PrintFile.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-PrintFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PrintFile Procedure 
PROCEDURE PrintFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  INPUT  STREAM InStream  FROM VALUE(pcPrintFile) NO-ECHO NO-MAP.
  
  RUN adecomm/_tmpfile.p
        ({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB}, OUTPUT _comp_temp_file_paged).

  OUTPUT STREAM OutStream TO VALUE(_comp_temp_file_paged) PAGE-SIZE VALUE(_print_pg_length).
  
  DEFINE VARIABLE cdatetime AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFileName AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE ifont     AS INTEGER   NO-UNDO.     
  
  ASSIGN cdatetime = STRING(TODAY) + " " + STRING(TIME,"HH:MM:SS").
         
  /* Font 2 is sent to osprint if the print font preference is not part
     of the font table (it may have been removed from the registry
     or ini file by the user) */
  ASSIGN ifont = IF _print_font > (FONT-TABLE:NUM-ENTRIES - 1) 
                   THEN 2 ELSE _print_font.

  IF pcSection NE ? THEN DO:
    IF pcProcName NE ? THEN cFileName = pcProcName + pcSection.
    ELSE cFileName = "(Untitled)" + pcSection. 
  END.  /* if pcSection NE ? */
  ELSE DO:
    IF pcProcName NE ? THEN
      RUN adecomm/_ossfnam.p (INPUT pcProcName, 
                              INPUT 39,
                              INPUT ifont,
                              OUTPUT cFileName).
    ELSE cFileName = "            (Untitled)".
  END.  /* else do pcSection ? */
  
  FORM HEADER
        cdatetime FORMAT "x(17)" SPACE(4) 
        cFileName FORMAT "x(45)" 
        "Page" AT 70 PAGE-NUMBER (OutStream) FORMAT "ZZ9" SKIP(1)
        WITH FRAME pageheadwnum
        PAGE-TOP NO-LABELS NO-BOX NO-ATTR-SPACE NO-UNDERLINE USE-TEXT STREAM-IO.
  
  FORM HEADER
        cdatetime FORMAT "x(17)" SPACE(4) 
        cFileName FORMAT "x(45)" SKIP(1) 
        WITH FRAME pageheadwonum
        PAGE-TOP NO-LABELS NO-BOX NO-ATTR-SPACE NO-UNDERLINE USE-TEXT STREAM-IO.
  
  IF _print_pg_length = 0 THEN 
    VIEW STREAM OutStream FRAME pageheadwonum.
  ELSE VIEW STREAM OutStream FRAME pageheadwnum.
 
  /* Frame must be down frame, so scope to REPEAT. */
  REPEAT ON STOP UNDO, LEAVE WITH FRAME f_Print:
    IMPORT STREAM InStream UNFORMATTED Text_Line.
    DISPLAY STREAM OutStream Text_Line 
      WITH FRAME f_Print NO-LABELS STREAM-IO
      NO-BOX USE-TEXT WIDTH 255.
  END.
  
  INPUT STREAM InStream CLOSE.
  OUTPUT STREAM OutStream CLOSE.
  
  RUN adecomm/_osprint ( INPUT phWindow,
                         INPUT _comp_temp_file_paged,
                         INPUT ifont,
                         INPUT IF _print_dialog THEN 1 ELSE 0,
                         INPUT 0,
                         INPUT 0,
                         OUTPUT plPrinted).
  
  OS-DELETE VALUE(_comp_temp_file_paged).                       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

