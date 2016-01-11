&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2001 by Progress Software Corporation ("PSC"),       *
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
*   Per S Digre (pdigre@progress.com)                                *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : html.p
    Purpose     : Generic HTML formatting
    Syntax      :
    Description :
    Updated     : 04/04/98 pdigre@progress.com
                    Initial version
                  04/25/01 adams@progress.com
                    WebSpeed integration
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{ src/web/method/cgidefs.i }

&GLOBAL-DEFINE cColorHeader " bgcolor=#DEB887 "
&GLOBAL-DEFINE cColorRow1   " bgcolor=#FFFFE6 "
&GLOBAL-DEFINE cColorRow2   " bgcolor=#EEE1D2 "
&GLOBAL-DEFINE cBrowseTableDef " border=0 cellpadding=1 cellspacing=2 width=100% "

DEFINE VARIABLE cBgColor  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE refer-hdl AS HANDLE     NO-UNDO.

/***** Common for all objects  *******/
DEFINE VARIABLE hParent   AS HANDLE     NO-UNDO.
DEFINE VARIABLE cCallback AS CHARACTER  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hPlus     AS HANDLE NO-UNDO.

DEFINE STREAM sIni.

FUNCTION fBat        RETURNS CHARACTER 
  ( cCmd as CHARACTER) IN hPlus.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fBeginTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fBeginTable Procedure 
FUNCTION fBeginTable RETURNS CHARACTER
  ( cLabels AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fHRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fHRow Procedure 
FUNCTION fHRow RETURNS CHARACTER
  ( cLabels AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fLink Procedure 
FUNCTION fLink RETURNS CHARACTER
  ( cAction AS CHARACTER,
    cValue AS CHARACTER,
    cText AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fProcess) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fProcess Procedure 
FUNCTION fProcess RETURNS CHARACTER
  ( cCmd AS CHARACTER,
    cAvoid AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fRow Procedure 
FUNCTION fRow RETURNS CHARACTER
  ( cData AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTable Procedure 
FUNCTION fTable RETURNS CHARACTER
  ( cLabels AS CHARACTER,
    cData AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pHandle Procedure 
PROCEDURE pHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pHdl AS HANDLE NO-UNDO.

  ASSIGN refer-hdl = pHdl.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCallBack) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCallBack Procedure 
PROCEDURE setCallBack :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER h1 AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER c1 AS CHARACTER  NO-UNDO.

  ASSIGN hParent   = h1
         cCallBack = c1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fBeginTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fBeginTable Procedure 
FUNCTION fBeginTable RETURNS CHARACTER
  ( cLabels AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN "<TABLE " + {&cBrowseTableDef} + ">" + CHR(10) + fHRow(cLabels).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fHRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fHRow Procedure 
FUNCTION fHRow RETURNS CHARACTER
  ( cLabels AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  ASSIGN cBgColor = "".

  RETURN 
    (IF cLabels = "" THEN "" ELSE
     "<TR ALIGN=LEFT" + {&cColorHeader} + "><TH>" + 
     REPLACE(cLabels,"|","</TH><TH>") + "</TH></TR>" + CHR(10)).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fLink Procedure 
FUNCTION fLink RETURNS CHARACTER
  ( cAction AS CHARACTER,
    cValue AS CHARACTER,
    cText AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NOT cValue MATCHES "*(*" THEN 
    cValue = "'":U + cValue + "'":U.

  RETURN 
    "<A HREF=""JavaScript:document.form.Do.value='" + cAction
    + "';document.form.Name.value=" + cValue
    + ";document.form.submit()"">" + cText + "</A>" + CHR(10).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fProcess) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fProcess Procedure 
FUNCTION fProcess RETURNS CHARACTER
  ( cCmd AS CHARACTER,
    cAvoid AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cIn AS CHARACTER  NO-UNDO.

  {&OUT} "<pre>" CHR(0) SKIP.

  IF cAvoid = "" THEN 
    cAvoid = "&&&gh~&&&".

  IF OPSYS <> "win32" THEN 
    cCmd = REPLACE(cCmd,'"','').
  DYNAMIC-FUNCTION ("LogNote" IN web-utilities-hdl,"RUN", "CMD:" + cCmd) NO-ERROR.
  cCmd = fBat(cCmd).
  INPUT STREAM sIni THROUGH VALUE(cCmd).
  REPEAT:
    ASSIGN cIn = "".  /*  ?? why is this here? import should overwrite the line */
    IMPORT STREAM sIni UNFORMATTED cIn NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      {&OUT} "Error in command.</PRE>" CHR(0) SKIP.
      RETURN "".
    END.
    IF cIn MATCHES cAvoid THEN NEXT.
    {&OUT} html-encode(cIn) CHR(0) SKIP.
  END.
  {&OUT} "</PRE>" SKIP.
  INPUT STREAM sIni CLOSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fRow Procedure 
FUNCTION fRow RETURNS CHARACTER
  ( cData AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  ASSIGN 
    cBgColor = IF cBgColor = {&cColorRow1} THEN {&cColorRow2} ELSE {&cColorRow1}.

  RETURN 
    "<TR ":U + cBgColor + "><TD>":U + 
    REPLACE(cData,"|":U,"</TD><TD>":U) + "</TD></TR>":U + CHR(10).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTable Procedure 
FUNCTION fTable RETURNS CHARACTER
  ( cLabels AS CHARACTER,
    cData AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  This does not create an HTML table unless there is data.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cReturn AS CHARACTER NO-UNDO.

  IF cData > "" THEN
    ASSIGN cReturn = fBeginTable(cLabels) + cData + "</TABLE>" + CHR(10).

  RETURN cReturn.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

