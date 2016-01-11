&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*--------------------------------------------------------------------------
    File        : _opnfile.w
    Purpose     : Run system-dialog or remote file open depending on AB 
                  preferences.
    Syntax      :
    Description : The number of filters are dynamic !  
    Parameters  : 
     INPUT        ptitle  - Title of dialog 
     INPUT        pfilter - COMMA separated string with filters.
                            MUST have the real filter in parenthesis.                                                            
                            USE Semicolon to separate filters ! 
                            Example "ALl Source(*.p;*.i;*.w),R-code files (*.r)". 
     INPUT-OUTPUT pfile   - filename, set to "" if nothing is found.
       
    Author(s)   : Haavard Danielsen
    Created     : Feb 1998
    Notes       : Currently maximum 6 filters.
                  Could easily be extended.                   
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT        PARAMETER pTitle  AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pFilter AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pFile   AS CHARACTER NO-UNDO.
  
DEFINE VAR PickedOne  AS LOGICAL   NO-UNDO.
DEFINE VAR Path       AS CHARACTER NO-UNDO.
DEFINE VAR TempFile   AS CHARACTER NO-UNDO.
DEFINE VAR I          AS INTEGER   NO-UNDO.
DEFINE VAR gDelimiter AS CHARACTER INIT ",":U NO-UNDO.
DEFINE VAR gRemoteStr AS CHARAcTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetFilter Procedure 
FUNCTION GetFilter RETURNS CHARACTER
  ( pin as int)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFilterText Procedure 
FUNCTION getFilterText RETURNS CHARACTER
  ( pin as int)  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

IF SEARCH("adeuib/_uibinfo.r":U) <> ? THEN
    RUN adeuib/_uibinfo.p
      (?, "SESSION":U, "REMOTE":U, OUTPUT gRemoteStr).
        
IF gRemoteStr <> "TRUE":U THEN 
DO:  

  /* 
  Remove slash because SYSTEM-DIALOG GET_GILE Aborts 
  if / is used in file name 
  */
  
  ASSIGN 
    pFile = REPLACE (pFile,"/":U,"~\":U).

  /* 
  getfiltertext() returns the entry from the comma separated 
  input parameter pFilter.
     
  getfilter strips the part in the parenthesis. 
     
  The use of a function makes the System dialog overlook it 
  if it is blank. (Magic ! ) 
  */  
                  
  SYSTEM-DIALOG GET-FILE pFile 
      FILTERS getfiltertext(1) getfilter(1),           
              getfiltertext(2) getfilter(2),
              getfiltertext(3) getfilter(3),
              getfiltertext(4) getfilter(4),
              getfiltertext(5) getfilter(5),
              getfiltertext(6) getfilter(6)
      
      DEFAULT-EXTENSION  getfilter(1)
      TITLE              pTitle
      MUST-EXIST
      USE-FILENAME
      UPDATE             PickedOne.  

  IF PickedOne then
     /* See if it can be located in the PROPATH */
  DO i = 1 to NUM-ENTRIES(PROPATH):
    FILE-INFO:FILE-NAME = TRIM(ENTRY(i,PROPATH)).

    IF pFile BEGINS FILE-INFO:FULL-PATHNAME 
    AND FILE-INFO:FULL-PATHNAME NE ? THEN 
    DO:       
      /* If it's there, chop off the leading part */
      pFile = SUBSTRING(pFile, LENGTH(RIGHT-TRIM(FILE-INFO:FULL-PATHNAME,"~\":U)) + 2, -1,"CHARACTER":U).
      LEAVE.
    END.
  END.
END.
ELSE      
   RUN adeweb/_webfile.w
         ("UIB":U,
          "SEARCH":U,
          pTitle,
          pFilter,
          INPUT-OUTPUT pFile,
          OUTPUT TempFile,
          OUTPUT pickedOne). 
          
IF NOT PickedOne THEN ASSIGN pFile = "":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetFilter Procedure 
FUNCTION GetFilter RETURNS CHARACTER
  ( pin as int) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  Def var a as char.
  Def var rp as int.
  Def var lp as int.
  Assign 
    a  = getFilterText(pin)
    lp = index(a,'(') + 1
    rp = index(a,')').
  
  RETURN if lp > 1 and rp > lp 
         then (substr(a,lp,rp - lp))
         else "":U.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterText Procedure 
FUNCTION getFilterText RETURNS CHARACTER
  ( pin as int) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN if num-entries(pfilter,gDelimiter) >= pin 
         then entry(pin,pfilter,gDelimiter)
         else "":U. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

