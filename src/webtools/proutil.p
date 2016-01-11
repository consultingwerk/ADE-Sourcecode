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
*  Per S Digre (pdigre@progress.com)                                 *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : proutil.p
    Purpose     : Command line-based tools for database and brokers
    Syntax      :
    Description :
    Updated     : 04/04/98 pdigre@progress.com
                    Initial version
                  04/26/01 adams@progress.com
                    WebSpeed integration
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{ src/web/method/cgidefs.i }


/* generic object definition section */
DEFINE VARIABLE hParent   AS HANDLE     NO-UNDO.
DEFINE VARIABLE cCallback AS CHARACTER  NO-UNDO.

DEFINE STREAM s1.

DEFINE NEW GLOBAL SHARED VARIABLE cLib     AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cName    AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cFiles   AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cDLCBIN  AS CHARACTER NO-UNDO. /** DLC install directory **/
DEFINE NEW GLOBAL SHARED VARIABLE hHTML    AS HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hPlus    AS HANDLE    NO-UNDO.

FUNCTION fBat        RETURNS CHARACTER 
  ( cCmd AS CHARACTER ) IN hPlus.
function fNTKill     RETURNS CHARACTER
  ( iPID AS INTEGER) IN hPlus.
FUNCTION fRow        RETURNS CHARACTER
  ( cData   AS CHARACTER ) IN hHTML.
FUNCTION fHRow       RETURNS CHARACTER
  ( cLabels AS CHARACTER ) IN hHTML.
FUNCTION fBeginTable RETURNS CHARACTER
  ( cLabels AS CHARACTER ) IN hHTML.
FUNCTION fTable      RETURNS CHARACTER
  ( cLabels AS CHARACTER, cData AS CHARACTER ) IN hHTML.
FUNCTION fLink       RETURNS CHARACTER
  ( cMode AS CHARACTER, cValue AS CHARACTER, cText AS CHARACTER ) IN hHTML.
FUNCTION fProcess    RETURNS CHARACTER
  ( cCmd AS CHARACTER, cAvoid AS CHARACTER ) IN hHTML.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fBrkAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fBrkAdd Procedure 
FUNCTION fBrkAdd RETURNS CHARACTER
  ( cUtil AS CHARACTER,
    cName AS CHARACTER,
    cName2 AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fBrkKill) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fBrkKill Procedure 
FUNCTION fBrkKill RETURNS CHARACTER
  ( cName2 AS CHARACTER,
    cPID AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fBrkStart) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fBrkStart Procedure 
FUNCTION fBrkStart RETURNS CHARACTER
  ( cUtil AS CHARACTER,
    cName AS CHARACTER,
    cName2 AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fBrkStop) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fBrkStop Procedure 
FUNCTION fBrkStop RETURNS CHARACTER
  ( cUtil AS CHARACTER,
    cName AS CHARACTER,
    cName2 AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fBrkView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fBrkView Procedure 
FUNCTION fBrkView RETURNS CHARACTER
  ( cUtil AS CHARACTER,
    cName AS CHARACTER,
    cName2 AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fCmd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCmd Procedure 
FUNCTION fCmd RETURNS CHARACTER
  ( cCmd AS CHARACTER,
    cPrm AS CHARACTER,
    cFormat AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fLibraryUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fLibraryUpdate Procedure 
FUNCTION fLibraryUpdate RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fLibraryView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fLibraryView Procedure 
FUNCTION fLibraryView RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-fBrkAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fBrkAdd Procedure 
FUNCTION fBrkAdd RETURNS CHARACTER
  ( cUtil AS CHARACTER,
    cName AS CHARACTER,
    cName2 AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  fCmd(cUtil,' -addagents 1 -name ' + cName2,"").

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fBrkKill) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fBrkKill Procedure 
FUNCTION fBrkKill RETURNS CHARACTER
  ( cName2 AS CHARACTER,
    cPID AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR cRet AS CHAR NO-UNDO.
  IF OPSYS = "win32" THEN DO:
    DYNAMIC-FUNCTION ("LogNote" IN web-utilities-hdl,
              "RUN", "Kill Agent PID=" + cPid) NO-ERROR.
    cRet = fNTKill(INTEGER(cPID)).
    DYNAMIC-FUNCTION ("LogNote" IN web-utilities-hdl,
              "RUN", "Kill:" + cRet) NO-ERROR.
    {&OUT} "<P>" html-encode(cRet) "</P>".
  END.
  ELSE 
    fCmd('kill',' -15 ' + cPID,"").

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fBrkStart) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fBrkStart Procedure 
FUNCTION fBrkStart RETURNS CHARACTER
  ( cUtil AS CHARACTER,
    cName AS CHARACTER,
    cName2 AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  fCmd(cUtil,' -start -name ' + cName2,"").

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fBrkStop) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fBrkStop Procedure 
FUNCTION fBrkStop RETURNS CHARACTER
  ( cUtil AS CHARACTER,
    cName AS CHARACTER,
    cName2 AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  fCmd(cUtil,' -stop -name ' + cName2,"").

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fBrkView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fBrkView Procedure 
FUNCTION fBrkView RETURNS CHARACTER
  ( cUtil AS CHARACTER,
    cName AS CHARACTER,
    cName2 AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE c1      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE eIn     AS CHARACTER  NO-UNDO EXTENT 20.

  {&OUT} "Using " cUtil " to view " cName "." SKIP.
  DYNAMIC-FUNCTION ("LogNote" IN web-utilities-hdl,
            "RUN", "View Broker " + cUtil + " " + cName + " " + cName2) NO-ERROR.
  INPUT STREAM s1 THROUGH VALUE(cUtil + " -query -name " + cName2).

  REPEAT:
    ASSIGN eIn = "".
    IMPORT STREAM s1 eIn NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      {&OUT} "<br><b>Unable to show status of service. Most likely not started.</b>~n".
      RETURN "".
    END.
    IF (eIn[1] = "PID" OR eIn[2] = "PID" AND eIn[1] <> "BROKER" )
     OR eIn[1] = "Application" THEN LEAVE.
  END.

  IF cUtil = "nsman" THEN
    {&OUT} 
      fBeginTable("Application Service|" + eIn[3] + "|" + eIn[4] + "|" + 
                  eIn[5] + "|" + eIn[6] + "|" + eIn[7] + "|" + eIn[8]).
  ELSE 
    {&OUT} 
      fBeginTable(eIn[1] + "|" + eIn[2] + "|" + eIn[3] + "|" + eIn[4] + "|" + 
                  eIn[5] + "|" + eIn[6] + "|" + 
                  eIn[7] + "|" + eIn[8] + " " + eIn[9] + "|" + 
                  fLink("AddBrk",cName,"Add")).
  REPEAT:
    IF cUtil = "nsman" THEN DO:
      IMPORT STREAM s1 c1 NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
        {&OUT} "<br><b>Unable to show status of service. Most likely not started.</b>~n".
        RETURN "".
      END.
      IMPORT STREAM s1 c1 NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
        {&OUT} "<br><b>Unable to show status of service. Most likely not started.</b>~n".
        RETURN "".
      END.
    END.
    IMPORT STREAM s1 eIn NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      {&OUT} "<br><b>Unable to show status of service. Most likely not started.</b>~n".
      RETURN "".
    END.
    IF eIn[1] BEGINS "==" THEN NEXT.
    IF eIn[1] > "" THEN
      IF cUtil = "nsman" THEN
        {&OUT} 
          fRow(c1 + "|" + eIn[1] + "|" + eIn[2] + "|" + eIn[3] + "|" + eIn[4] + 
               "|" + eIn[5] + "|" + eIn[6]).
      ELSE 
        {&OUT} 
          fRow(eIn[1] + "|" + eIn[2] + "|" + eIn[3] + "|" + eIn[4] + "|" + 
               eIn[5] + "|" + eIn[6] + "|" + 
               eIn[ 7] + " " + eIn[ 8] + " " + eIn[ 9] + " " + eIn[10] + "|" + 
               eIn[11] + " " + eIn[12] + " " + eIn[13] + " " + eIn[14] + "|" + 
               fLink("KillBrk" + eIn[1],cName,"Kill")).
    ASSIGN eIn = "".
  END.
  {&OUT} "</TABLE>" SKIP.
  INPUT STREAM s1 CLOSE.
  RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fCmd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCmd Procedure 
FUNCTION fCmd RETURNS CHARACTER
  ( cCmd AS CHARACTER,
    cPrm AS CHARACTER,
    cFormat AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  {&OUT} "OS-CMD: " cCmd " " cPrm ".".
  fProcess(cCmd + ' ' + cPrm,cFormat).
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fLibraryUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fLibraryUpdate Procedure 
FUNCTION fLibraryUpdate RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE i1      AS INTEGER NO-UNDO.

  ASSIGN 
    cFiles = REPLACE(REPLACE(REPLACE(REPLACE(cFiles + ",",".w,",".r "),".html,",".r "),".htm,",".r "),".p,",".r ").

  {&OUT} "<H2>Building library</H2>".
  fCmd('prolib', '"' + cLib + "~" -create","* already exists.*").

  DO i1 = 1 TO NUM-ENTRIES(cFiles," "):
    fCmd('prolib', '"' + cLib + "~" -add " + ENTRY(i1,cFiles," "),"*replace *").
    fCmd('prolib', '"' + cLib + "~" -replace " + ENTRY(i1,cFiles," "),"").
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fLibraryView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fLibraryView Procedure 
FUNCTION fLibraryView RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE c1      AS CHARACTER NO-UNDO.

  /***** Displaying library statistics *******/
  ASSIGN c1 = '"' + cDLCBIN + 'prolib" ' + '"' + cLib + '" -list'. 
  DYNAMIC-FUNCTION ("logNote" IN web-utilities-hdl,
                    "RUN", c1) NO-ERROR.
  INPUT STREAM s1 THROUGH VALUE(fBat(c1)).
  REPEAT:
    ASSIGN c1 = "".
    IMPORT STREAM s1 UNFORMATTED c1.
    IF c1 MATCHES "* Offset *" AND c1 MATCHES "* Modified *" then leave.
    {&OUT} "<P>" html-encode(c1) "</P>".
  END.
  {&OUT} "<TABLE " {&cBrowseTableDef} ">" SKIP.

  ASSIGN 
    c1 = REPLACE(REPLACE(c1,"    "," "),"    "," ")
    c1 = REPLACE(REPLACE(c1,"  "," "),"  "," ").
  {&OUT} "<TR " {&cColorHeader} "><TH>" REPLACE(c1," ","</TH><TH>") "</TH></TR>".

  IMPORT STREAM s1 UNFORMATTED c1.
  REPEAT:
    ASSIGN 
      c1 = REPLACE(REPLACE(c1,"    "," "),"    "," ")
      c1 = REPLACE(REPLACE(c1,"  "," "),"  "," ").
    IF NOT c1 BEGINS "Total of" THEN
      {&OUT} "<TR " {&cColorRow1} "><TD>" REPLACE(c1," ","</TD><TD>") "</TD></TR>".
    IMPORT STREAM s1 UNFORMATTED c1.
  END.
  {&OUT} "</TABLE><P>" html-encode(c1) "</P>".
  INPUT STREAM s1 CLOSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

