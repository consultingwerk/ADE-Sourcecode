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
    File        : config.p
    Purpose     : Configuration tools
    Syntax      :
    Description :
    Updated     :
    Notes       : 04/04/98 pdigre@progress.com
                    Initial version
                  04/25/01 adams@progress.com
                    WebSpeed integration
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{ src/web/method/cgidefs.i }

/* registry */
&GLOBAL-DEFINE ADVAPI   "advapi32"
&GLOBAL-DEFINE HKEY_CLASSES_ROOT -2147483648
&GLOBAL-DEFINE HKEY_CURRENT_USER -2147483647
&GLOBAL-DEFINE HKEY_LOCAL_MACHINE -2147483646
&GLOBAL-DEFINE HKEY_USERS -2147483645
&GLOBAL-DEFINE HKEY_PERFORMANCE_DATA -2147483644
&GLOBAL-DEFINE HKEY_CURRENT_CONFIG -2147483643
&GLOBAL-DEFINE HKEY_DYN_DATA -2147483642

&GLOBAL-DEFINE ERROR_SUCCESS 0
&GLOBAL-DEFINE ERROR_NO_MORE_ITEMS 259
&GLOBAL-DEFINE MAX_PATH 260

/********* Object for Updating status screen **********/
DEFINE NEW GLOBAL SHARED VARIABLE cDB      AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cDir     AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cLib     AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cBrk     AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cDirCD   AS CHARACTER NO-UNDO. /** Current directory **/
DEFINE NEW GLOBAL SHARED VARIABLE cProPath AS CHARACTER NO-UNDO. /** list of full paths to non progress directories ***/
DEFINE NEW GLOBAL SHARED VARIABLE cName    AS CHARACTER NO-UNDO.  /** HTML param         **/

DEFINE NEW GLOBAL SHARED VARIABLE hHTML    AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hPlus    AS HANDLE NO-UNDO.

/* generic object definition section */
DEFINE VARIABLE hParent   AS HANDLE     NO-UNDO.
DEFINE VARIABLE cCallback AS CHARACTER  NO-UNDO.

DEFINE STREAM s1.

FUNCTION fIniSave    RETURNS CHARACTER () IN hPlus.
FUNCTION fBat        RETURNS CHARACTER 
  ( cCmd as CHARACTER) IN hPlus.
FUNCTION fRow        RETURNS CHARACTER
  ( cData   AS CHARACTER ) IN hHTML.
FUNCTION fHRow       RETURNS CHARACTER
  ( cLabels AS CHARACTER) IN hHTML.
FUNCTION fBeginTable RETURNS CHARACTER
  ( cLabels AS CHARACTER) IN hHTML.
FUNCTION fTable      RETURNS CHARACTER
  ( cLabels AS CHARACTER, cData AS CHARACTER) IN hHTML.
FUNCTION fLink       RETURNS CHARACTER
  ( cMode AS CHARACTER, cValue AS CHARACTER, cText AS CHARACTER) IN hHTML.

PROCEDURE RegOpenKeyA EXTERNAL {&ADVAPI} :
  DEFINE INPUT  PARAMETER hkey       AS LONG.
  DEFINE INPUT  PARAMETER lpszSubKey AS CHAR.
  DEFINE OUTPUT PARAMETER phkResult  AS LONG.
  DEFINE RETURN PARAMETER lpResult   AS LONG.
END PROCEDURE.

PROCEDURE RegCloseKey EXTERNAL {&ADVAPI} :
  DEFINE INPUT  PARAMETER hkey     AS LONG.
  DEFINE RETURN PARAMETER lpresult AS LONG.
END PROCEDURE.

PROCEDURE RegEnumKeyA EXTERNAL {&ADVAPI} :
  DEFINE INPUT  PARAMETER hKey        AS LONG.
  DEFINE INPUT  PARAMETER iSubKey     AS LONG.
  DEFINE OUTPUT PARAMETER lpszName    AS CHAR.
  DEFINE INPUT  PARAMETER cchName     AS LONG.
  DEFINE RETURN PARAMETER lpresult    AS LONG.
END PROCEDURE.

PROCEDURE RegQueryValueExA EXTERNAL {&ADVAPI} :
  DEFINE INPUT        PARAMETER hkey         AS LONG.
  DEFINE INPUT        PARAMETER lpValueName  AS CHAR.
  DEFINE INPUT        PARAMETER lpdwReserved AS LONG.
  DEFINE OUTPUT       PARAMETER lpdwType     AS LONG.
  DEFINE INPUT        PARAMETER lpbData      AS LONG. /* memptr */
  DEFINE INPUT-OUTPUT PARAMETER lpcbData     AS LONG.
  DEFINE RETURN       PARAMETER lpresult     AS LONG.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fRecurse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fRecurse Procedure 
FUNCTION fRecurse RETURNS CHARACTER
  ( cPath AS character,
    cRelPath AS CHARACTER,
    iRec AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fRegGetKeys) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fRegGetKeys Procedure 
FUNCTION fRegGetKeys RETURNS CHARACTER
  ( iGroup AS INTEGER,
    cKey AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fRegGetValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fRegGetValue Procedure 
FUNCTION fRegGetValue RETURNS CHARACTER
  ( iGroup AS INTEGER,
    cKey AS CHARACTER,
    cName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fSaveAppCfg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSaveAppCfg Procedure 
FUNCTION fSaveAppCfg RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fSaveSysCfg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSaveSysCfg Procedure 
FUNCTION fSaveSysCfg RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fSetConfig) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSetConfig Procedure 
FUNCTION fSetConfig RETURNS CHARACTER
  ( cDo AS CHARACTER,
    cName AS CHARACTER )  FORWARD.

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

  DEFINE INPUT PARAMETER h1 AS handle    NO-UNDO.
  DEFINE INPUT PARAMETER c1 AS CHARACTER  NO-UNDO.

  ASSIGN hParent   = h1
         cCallBack = c1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showAppCfg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showAppCfg Procedure 
PROCEDURE showAppCfg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE c1       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cListed  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cChecked AS CHARACTER  NO-UNDO.

  DO i1 = 1 TO NUM-ENTRIES(cProPath):
    c1      = ENTRY(i1,cProPath).
    cListed = cListed + fRecurse(c1,'',INTEGER(cName)).
  END.

  {&OUT} "Propath " cProPath.
  {&OUT} '<BR>Recurse
    <INPUT TYPE="button" NAME="recurse1" VALUE="1 level"  onClick="document.form.Do.value=~'appCfg~';document.form.Name.value=~'1~';document.form.submit();">
  / <INPUT TYPE="button" NAME="recurse2" VALUE="2 levels" onClick="document.form.Do.value=~'appCfg~';document.form.Name.value=~'2~';document.form.submit();">
  / <INPUT TYPE="button" NAME="recurse3" VALUE="3 levels" onClick="document.form.Do.value=~'appCfg~';document.form.Name.value=~'3~';document.form.submit();">' SKIP.

  {&OUT} 
    fBeginTable("Recursing PROPATH|&nbsp;").

  ASSIGN 
    cDir    = REPLACE(cDir,cDirCD,'')
    cListed = REPLACE(cListed,cDirCD,'')
    .

  DO i1 = 1 TO NUM-ENTRIES(cListed):
    ASSIGN c1 = ENTRY(i1,cListed).
    IF LOOKUP(c1,cListed) < i1 THEN NEXT.
    {&OUT} 
      fRow('<INPUT TYPE="checkbox" NAME="dir' + (IF c1 = '' THEN cDirCD ELSE c1) + 
           (IF CAN-DO(cDir,c1) THEN '" CHECKED' ELSE '"') + '>' + (IF c1 = '' THEN cDirCD ELSE c1) + "|&nbsp;"
     + (IF c1 = '' THEN " Current_Dir " ELSE '')).
  END.
  {&OUT} 
    fHRow("Unlisted codepaths &nbsp; &nbsp; &nbsp;"
    + fLink("AddDir","prompt('CodePath:')","Add unlisted|&nbsp;")).

  DO i1 = 1 TO NUM-ENTRIES(cDir):
    ASSIGN c1 = ENTRY(i1,cDir). 
    IF CAN-DO(cListed,c1) THEN NEXT.
    {&OUT} 
      fRow('<INPUT TYPE="checkbox" NAME="dir' + c1 + 
           (IF CAN-DO(cDir,c1) THEN '" CHECKED' ELSE '"') + '>' + c1 + "|&nbsp;").
  END.

  {&OUT} 
    '</TABLE><CENTER><INPUT TYPE="button" NAME="saveexit" VALUE="  OK  " onClick="document.form.Do.value=~'saveAppCfg~';document.form.submit();"></CENTER>' SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showSysCfg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showSysCfg Procedure 
PROCEDURE showSysCfg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cRegBrk AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRegDB  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBCurr AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBrk9   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDB9    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPf     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE i1      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c3      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPath   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cListed AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKey    AS CHARACTER  NO-UNDO.

  /* Check PROCONTROL */
  IF OPSYS = "win32" THEN DO:
    ASSIGN
      cKey = "Software~\PSC~\ProService~\" + ENTRY(1,PROVERSION,' ') + "~\Databases"
      c2   = fRegGetKeys({&HKEY_LOCAL_MACHINE},cKey).

    IF c2 <> "" THEN DO:
      DYNAMIC-FUNCTION("logNote" IN web-utilities-hdl,
                       "RUN", "Key:" + cKey + " Keys:" + c2) NO-ERROR.
      DO i1 = 1 TO NUM-ENTRIES(c2):
        ASSIGN
          c1    = cKey + "~\" + ENTRY(i1,c2).
 
        DYNAMIC-FUNCTION("logNote" IN web-utilities-hdl,"RUN", c1) NO-ERROR.
        ASSIGN
          cPath = fRegGetValue({&HKEY_LOCAL_MACHINE},c1,"WorkDir")
                + "~\"
                + fRegGetValue({&HKEY_LOCAL_MACHINE},c1,"DBName")
          cPF   = fRegGetValue({&HKEY_LOCAL_MACHINE},c1,"StartupParam")
          .
        DYNAMIC-FUNCTION("logNote" IN web-utilities-hdl,
                         "RUN", "Path:" + cPath + " PF:" + cPF) NO-ERROR.

        OUTPUT STREAM s1 TO VALUE(cPath + ".pf").
        PUT    STREAM s1 UNFORMATTED cPF SKIP.
        OUTPUT STREAM s1 CLOSE.
        DYNAMIC-FUNCTION("logNote" IN web-utilities-hdl,"RUN", "Saved") NO-ERROR.
        ASSIGN cPath = cPath + ".db".
        IF NOT CAN-DO(cRegDB,cPath) THEN
          cRegDB = cRegDB + "," + cPath.
      END.
    END.
  END.

  DO:
    /* Check ubroker.properties */
    IF SEARCH("properties/ubroker.properties") > "" THEN DO:
      INPUT STREAM s1 FROM VALUE(SEARCH("properties/ubroker.properties")).
      REPEAT:
        ASSIGN c1 = "".
        IMPORT STREAM s1 UNFORMATTED c1.
        IF TRIM(c1) BEGINS "#" THEN NEXT.
        IF c1 BEGINS "[UBroker.WS." OR
           c1 BEGINS "[UBroker.AS." OR
           c1 BEGINS "[UBroker.OR." OR
           c1 BEGINS "[UBroker.OD." THEN
          ASSIGN cBrk9 = cBrk9 + "," + REPLACE(REPLACE(SUBSTRING(c1,10),".",":"),"]","").
        IF c1 BEGINS "[nameserver." THEN
          ASSIGN cBrk9 = cBrk9 + ",NS:" + REPLACE(SUBSTRING(c1,13),"]","").
      END.
      INPUT STREAM s1 CLOSE.
    END.

    /* Check conmgr.properties */
    IF SEARCH("properties/conmgr.properties") > "" THEN DO:
      INPUT STREAM s1 FROM VALUE(SEARCH("properties/conmgr.properties")).
      REPEAT:
        ASSIGN c1 = "".
        IMPORT STREAM s1 UNFORMATTED c1.
        IF TRIM(c1) BEGINS "#" THEN NEXT.
        IF TRIM(c1) BEGINS "databasename=" THEN
          ASSIGN
            cDBCurr = SUBSTRING(TRIM(c1),14)
            cDB9    = cDB9 + "," + cDBCurr
            .
      END.
      INPUT STREAM s1 CLOSE.
    END.
  END.

  ASSIGN
    cRegDB  = REPLACE(cRegDB,'~\','/')
    cDB9    = REPLACE(cDB9  ,'~\','/')
    cListed = cRegBrk + cRegDB + cBrk9 + cDB9.

  {&OUT} fBeginTable("Definitions in ProControl (Win32 Registry)").
  DO i1 = 2 TO NUM-ENTRIES(cRegDB):
    {&OUT}
      fRow('<INPUT TYPE="checkbox" NAME="db' + ENTRY(i1,cRegDB)
      + (IF CAN-DO(cDB,ENTRY(i1,cRegDB)) THEN '" CHECKED>' ELSE '">')
      + ENTRY(i1,cRegDB)).
  END.

  {&OUT} fHRow("Definitions in Progress Explorer (ubroker.properties)").
  DO i1 = 2 TO NUM-ENTRIES(cBrk9):
    {&OUT} 
      fRow('<INPUT TYPE="checkbox" NAME="brk' + ENTRY(i1,cBrk9)
      + (IF CAN-DO(cBrk,ENTRY(i1,cBrk9)) THEN '" CHECKED>' ELSE '">')
      + ENTRY(i1,cBrk9)).
  END.

  {&OUT} fHRow("Definitions in Progress Explorer (conmgr.properties)").
  DO i1 = 2 TO NUM-ENTRIES(cDB9):
    {&OUT} fRow('<INPUT TYPE="checkbox" NAME="db' + ENTRY(i1,cDB9)
      + (IF CAN-DO(cDB,ENTRY(i1,cDB9)) THEN '" CHECKED>' ELSE '">') + "DB:"
      + ENTRY(i1,cDB9)).
  END.

  {&OUT} 
    fHRow("Other Servers &nbsp; &nbsp; &nbsp; (Add "
    + fLink("AddWS","prompt('Webspeed Broker:')","WebSpeed")
    + (IF PROVERSION BEGINS "9" THEN 
       fLink("AddNS","prompt('Nameserver:')","NameServer")
       + fLink("AddAS","prompt('Application Server:')","AppServer")
       + fLink("AddOD","prompt('ODBC Dataserver:')","ODBC")
       + fLink("AddOR","prompt('Oracle Dataserver:')","Oracle") ELSE "")
    + fLink("AddDB","prompt('Path of the database (including *.db):')","DB")
    + ")|").

  DO i1 = 1 TO NUM-ENTRIES(cBrk):
    IF CAN-DO(cListed,ENTRY(i1,cBrk)) THEN NEXT.

    {&OUT} 
      fRow('<INPUT TYPE="checkbox" NAME="brk' + ENTRY(i1,cBrk) 
           + '" CHECKED>' + ENTRY(i1,cBrk)).
  END.
  DO i1 = 1 TO NUM-ENTRIES(cDB):
    IF CAN-DO(cListed,ENTRY(i1,cDB)) THEN NEXT.

    {&OUT} 
      fRow('<INPUT TYPE="checkbox" NAME="db' + ENTRY(i1,cDB) 
           + '" CHECKED>DB:' + ENTRY(i1,cDB)).
  END.
  {&OUT} 
    '</TABLE><CENTER><INPUT TYPE="button" NAME="saveexit" VALUE="  OK  "'
    + ' onClick="document.form.Do.value=~'saveSysCfg~';document.form.submit();">'
    + '</CENTER>' SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fRecurse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fRecurse Procedure 
FUNCTION fRecurse RETURNS CHARACTER
  ( cPath AS character,
    cRelPath AS CHARACTER,
    iRec AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE i1   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c3   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c4   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRet AS CHARACTER  NO-UNDO.

  IF NUM-ENTRIES(cPath,'.') > 1 THEN RETURN "".   

  ASSIGN cRet = "," + (IF cPath = cDirCD AND cRelPath > "" THEN "" ELSE cPath) + cRelPath.
  IF iRec < 1 THEN RETURN cRet.

  INPUT STREAM s1 FROM OS-DIR(cPath + cRelPath).
  REPEAT:
    ASSIGN
      c1 = ""
      c2 = ""
      c3 = "".
    IMPORT STREAM s1 c1 c2 c3.
    IF c3 = "D" AND NOT c1 BEGINS "." THEN 
      c4 = c4 + "," + cRelPath + c1 + '/'.
  END.
  DO i1 = 2 TO NUM-ENTRIES(c4):
    ASSIGN
      c1 = ENTRY(i1,c4).
      cRet = cRet + fRecurse(cPath,c1,iRec - 1).
  END.
  RETURN cRet.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fRegGetKeys) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fRegGetKeys Procedure 
FUNCTION fRegGetKeys RETURNS CHARACTER
  ( iGroup AS INTEGER,
    cKey AS CHARACTER ) :

/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hKey    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE subKey  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRet    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lth     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE reslt   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ITEM    AS INTEGER    NO-UNDO.

  RUN RegOpenKeyA (iGroup, cKey, OUTPUT hKey, OUTPUT reslt).
  /* Key not found, so return. */
  IF reslt <> 0 THEN 
    RETURN "".

  ASSIGN 
    ITEM  = 0
    reslt = 0.

  DO WHILE reslt NE {&ERROR_NO_MORE_ITEMS} :
    ASSIGN 
      lth     = {&MAX_PATH} + 1
      subKey  = FILL("x", lth).

    RUN RegEnumKeyA (hKey, ITEM, OUTPUT subkey, LENGTH(subkey), OUTPUT reslt).

    IF reslt NE {&ERROR_NO_MORE_ITEMS} THEN
      cRet = cRet + (IF cRet > '' THEN ',' ELSE '') + subkey.

    ITEM = ITEM + 1.
  END. /* do while not ERROR_NO_MORE_ITEMS */

  RUN RegCloseKey (hKey, OUTPUT reslt).

  RETURN cRet.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fRegGetValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fRegGetValue Procedure 
FUNCTION fRegGetValue RETURNS CHARACTER
  ( iGroup AS INTEGER,
    cKey AS CHARACTER,
    cName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE key-hdl    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lpBuffer   AS MEMPTR     NO-UNDO.
  DEFINE VARIABLE lth        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE reslt      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE datatype   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE icount     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRet       AS CHARACTER  NO-UNDO.

  RUN RegOpenKeyA ( {&HKEY_LOCAL_MACHINE}, cKey, OUTPUT key-hdl, OUTPUT reslt).
  IF reslt NE {&ERROR_SUCCESS} THEN DO:
    {&OUT} "key not found in registry" .
    RETURN "".
  END.

  ASSIGN 
    lth                = {&MAX_PATH} + 1
    SET-SIZE(lpBuffer) = lth.

  RUN RegQueryValueExA(key-hdl, cName, 0, OUTPUT datatype, GET-POINTER-VALUE(lpBuffer),
                       INPUT-OUTPUT lth, OUTPUT reslt).
  IF reslt NE {&ERROR_SUCCESS} THEN
    {&OUT} "value not found in registry" .
  ELSE 
  CASE datatype :
    WHEN 1 THEN cRet = GET-STRING(lpBuffer,1).
    WHEN 4 THEN cRet = STRING(GET-LONG(lpBuffer,1)).
    OTHERWISE   cRet = "unexpected datatype:" + STRING(datatype).
  END CASE.

  SET-SIZE(lpBuffer)=0.
  RUN RegCloseKey(key-hdl,OUTPUT reslt).

  RETURN cRet.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fSaveAppCfg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSaveAppCfg Procedure 
FUNCTION fSaveAppCfg RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE i1   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2   AS CHARACTER  NO-UNDO.

  ASSIGN
    cDir = ''
    c1   = get-field(?).

  DO i1 = 1 TO NUM-ENTRIES(c1):
    ASSIGN c2 = ENTRY(i1,c1).
    IF c2 BEGINS "DIR":U THEN 
      cDir  = cDir  + ",":U + SUBSTRING(c2,4).
  END.
  fIniSave().

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fSaveSysCfg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSaveSysCfg Procedure 
FUNCTION fSaveSysCfg RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE i1   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2   AS CHARACTER  NO-UNDO.

  ASSIGN
    cBrk = ''
    cDB  = ''
    c1   = get-field(?).
  DO i1 = 1 TO NUM-ENTRIES(c1):
    ASSIGN c2 = ENTRY(i1,c1).
    IF c2 BEGINS "DB"  THEN 
      cDB  = cDB  + "," + SUBSTRING(c2,3).
    IF c2 BEGINS "BRK" THEN 
      cBrk = cBrk + "," + SUBSTRING(c2,4).
  end.
  fIniSave().

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fSetConfig) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSetConfig Procedure 
FUNCTION fSetConfig RETURNS CHARACTER
  ( cDo AS CHARACTER,
    cName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE cDo:
     WHEN "AddLib" THEN clib = cName.
     WHEN "RemLib" THEN cLib = "".
     WHEN "AddDir" THEN cDir = cDir + "," + cName + 
       IF (SUBSTRING(cName,LENGTH(cName)) = "/") THEN "" ELSE "/".
     WHEN "RemDir" THEN IF LOOKUP(cName,cDir)  > 0 THEN 
       ENTRY(LOOKUP(cName,cDir),cDir) = "".
     WHEN "AddWS"  THEN cBrk = cBrk + ",WS:" + cName.
     WHEN "AddNS"  THEN cBrk = cBrk + ",NS:" + cName.
     WHEN "AddAS"  THEN cBrk = cBrk + ",AS:" + cName.
     WHEN "AddOD"  THEN cBrk = cBrk + ",OD:" + cName.
     WHEN "AddOR"  THEN cBrk = cBrk + ",OR:" + cName.
     WHEN "AddDB"  THEN cDB  = cDB  + ","    + cName.
  END CASE.
  fIniSave().

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

