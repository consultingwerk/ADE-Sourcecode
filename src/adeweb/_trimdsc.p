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
**********************************************************************

    File        : _trimdsc.p
    Purpose     : Remove HTML file description at top of file.

    Syntax      : RUN adeweb/_trimdsc.p (INPUT-OUTPUT filename).

    Description :

    Author(s)   : D.M.Adams
    Created     : 9/2/98
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT  PARAMETER pTemplate  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pConverted AS CHARACTER NO-UNDO.

DEFINE VARIABLE cNewLine    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTempfile   AS CHARACTER NO-UNDO.
DEFINE VARIABLE lFirstEnd   AS LOGICAL   NO-UNDO INITIAL TRUE.
DEFINE VARIABLE lFirstStart AS LOGICAL   NO-UNDO INITIAL TRUE.
DEFINE VARIABLE lEndDsc     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lStartDsc   AS LOGICAL   NO-UNDO.

DEFINE STREAM instream.
DEFINE STREAM outstream.

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

RUN adecomm/_tmpfile.p ("ws":U, ".tmp":U, OUTPUT pConverted).

INPUT STREAM instream FROM VALUE(pTemplate) NO-ECHO.
OUTPUT STREAM outstream TO VALUE(pConverted).

read-block:
REPEAT:
  cNewLine = "".
  IMPORT STREAM instream UNFORMATTED cNewLine.
  
  /* Only want to do this once. */
  IF cNewLine BEGINS "<!-- Procedure Description" AND lFirstStart THEN DO:
    ASSIGN
      lStartDsc   = TRUE
      lFirstStart = FALSE.
    NEXT.
  END.
    
  /* Only want to do this once. */
  IF cNewLine BEGINS "//-->" AND lFirstEnd THEN DO:
    ASSIGN
      lEndDsc   = TRUE
      lFirstEnd = FALSE.
    NEXT.
  END.
    
  IF NOT lStartDsc OR lEndDsc THEN
    PUT STREAM outstream UNFORMATTED cNewLine CHR(10).
    
END.

INPUT STREAM instream CLOSE.
OUTPUT STREAM outstream CLOSE.

pTemplate = pConverted.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


