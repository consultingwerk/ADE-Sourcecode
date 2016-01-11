&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*   Per S Digre (pdigre@progress.com)                                *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : code.p
    Purpose     :
    Syntax      :
    Description :
    Updated     : 04/04/98 pdigre@progress.om
                    Initial version
                  04/25/01 adams@progress.com
                    WebSpeed integration
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{ src/web/method/cgidefs.i }


/**** generic object definition section  ********/
DEFINE VARIABLE hParent   AS HANDLE     NO-UNDO.
DEFINE VARIABLE cCallback AS CHARACTER  NO-UNDO.

/**** Other Object interactions  ************/
DEFINE NEW GLOBAL SHARED VARIABLE cAction     AS CHARACTER NO-UNDO.  /** HTML Command       **/
DEFINE NEW GLOBAL SHARED VARIABLE cName       AS CHARACTER NO-UNDO.  /** HTML param         **/
DEFINE NEW GLOBAL SHARED VARIABLE cPath       AS CHARACTER NO-UNDO.  /** CodePath selected  **/
DEFINE NEW GLOBAL SHARED VARIABLE cFiles      AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cDirCD      AS CHARACTER NO-UNDO. /** Current directory **/

DEFINE NEW GLOBAL SHARED VARIABLE hAnalyze    AS HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hHTML       AS HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hPlus       AS HANDLE    NO-UNDO.

DEFINE STREAM s1.
DEFINE STREAM s2.

FUNCTION fRow        RETURNS CHARACTER
  (INPUT cData   AS CHAR) IN hHTML.
FUNCTION fHRow       RETURNS CHARACTER
  (INPUT cLabels AS CHAR) IN hHTML.
FUNCTION fBeginTable RETURNS CHARACTER
  (INPUT cLabels AS CHAR) IN hHTML.
FUNCTION fTable      RETURNS CHARACTER
  ( cLabels AS CHARACTER, cData AS CHARACTER) IN hHTML.
FUNCTION fLink       RETURNS CHARACTER
  ( cMode AS CHARACTER, cValue AS CHARACTER, cText AS CHARACTER) IN hHTML.
FUNCTION fBat        RETURNS CHARACTER
  ( cCmd AS CHARACTER) IN hPlus.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fCompile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCompile Procedure 
FUNCTION fCompile RETURNS CHARACTER
  ( cFileFull AS CHARACTER,
    cAction AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fCompileResults) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCompileResults Procedure 
FUNCTION fCompileResults RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fCompileStart) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCompileStart Procedure 
FUNCTION fCompileStart RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fDoWithFiles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDoWithFiles Procedure 
FUNCTION fDoWithFiles RETURNS CHARACTER
  ( cAction AS CHARACTER,
    cFiles AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fLine) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fLine Procedure 
FUNCTION fLine RETURNS CHARACTER
  ( i1 AS INTEGER,
    i2 AS INTEGER,
    cTxt AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fRadio) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fRadio Procedure 
FUNCTION fRadio RETURNS CHARACTER
  ( cName AS CHARACTER,
    cValue AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-beautify) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beautify Procedure 
PROCEDURE beautify :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pFile AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cFile     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c1        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBeautify AS CHARACTER NO-UNDO.

  /* Initialize */
  ASSIGN
     pFile = SEARCH(pFile)
     cFile = pFile + ".beau".

  {&OUT} '<BR CLASS="page"><H2>Beautifying: ' pFile '</h2><HR><BR><PRE>' SKIP.


  IF GET-VALUE("savechg") = "o" THEN DO:
    OS-COPY VALUE(pFile) VALUE(cFile).
    ASSIGN
      c1    = cFile
      cFile = pFile
      pFile = c1.
  END.

  ASSIGN
    cBeautify = (IF GET-VALUE("expand") > ""  THEN ',pe' ELSE '')
              + (IF GET-VALUE("keyword") = "u" THEN ',pu' ELSE '')
              + (IF GET-VALUE("keyword") = "l" THEN ',pl' ELSE '')
              + (IF GET-VALUE("keyhtml") = "u" THEN ',hu' ELSE '')
              + (IF GET-VALUE("keyhtml") = "l" THEN ',hl' ELSE '').

  RUN outputLine(REPLACE('HTML|SCRP|PROG|COMM|QUOT|CR','|',CHR(2)),
                 REPLACE(' HTML | Script-Language | Progress-4GL | Progress-Comments | Progress-Text-Strings |CR','|',CHR(2))).

  /* Initialize analyze object */
  IF NOT VALID-HANDLE(hAnalyze) THEN
    RUN webtools/analyzer.p PERSISTENT SET hAnalyze.

  RUN callback IN hAnalyze (THIS-PROCEDURE,'outputLine').
  RUN beautify IN hAnalyze (cBeautify,cFile).
  RUN process  IN hAnalyze (pFile).

  DELETE PROCEDURE hAnalyze.

  IF GET-VALUE("savechg") = "o" THEN DO:
    IF OPSYS = "win32" THEN DO:
      DOS SILENT DEL VALUE(pFile).

      /* Deal with uppercasing of filenames */
      DOS SILENT VALUE("rename " + cFile + " " + ENTRY(NUM-ENTRIES(cFile,"~\"),cFile,"~\")). 
    END.
    ELSE UNIX SILENT rm VALUE(pFile).
  END.
  {&OUT} '</PRE>' SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-outputLine) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputLine Procedure 
PROCEDURE outputLine :
/*------------------------------------------------------------------------------
  Purpose:     Use with callback for the analyze object
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER cLineCmd  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER cLineData AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE i1        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i2        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cElemCmd  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cElemData AS CHARACTER  NO-UNDO.

  ASSIGN i2 = NUM-ENTRIES(cLineCmd,CHR(2)).
  IF NUM-ENTRIES(cLineData,CHR(2)) <> i2 THEN RETURN.

  IF i2 > 0 THEN DO i1 = 1 TO i2:
    ASSIGN cElemCmd  = ENTRY(i1,cLineCmd, chr(2))
           cElemData = ENTRY(i1,cLineData,chr(2)).
    CASE cElemCmd:
      WHEN "CR"   THEN {&OUT} SKIP.
      WHEN "PB"   THEN {&OUT} .
      WHEN "HTML" THEN {&OUT} '<FONT COLOR="blue">'   html-encode(cElemData) '</FONT>'.
      WHEN "SCRP" THEN {&OUT} '<FONT COLOR="brown">'  html-encode(cElemData) '</FONT>'.
      WHEN "COMM" THEN {&OUT} '<FONT COLOR="green">'  html-encode(cElemData) '</FONT>'.
      WHEN "QUOT" THEN {&OUT} '<FONT COLOR="red">'    html-encode(cElemData) '</FONT>'.
      WHEN "PROG" THEN {&OUT} '<FONT COLOR="black">'  html-encode(cElemData) '</FONT>'.
      WHEN "SCRB" THEN {&OUT} '<FONT COLOR="black"><U>'  html-encode(cElemData) '</U></FONT>'.
      OTHERWISE        {&OUT}                       html-encode(cElemData).
    END CASE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pShowFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pShowFile Procedure 
PROCEDURE pShowFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER cName AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE c1 AS CHARACTER  NO-UNDO.

  {&OUT} "<HR><PRE>" SKIP.
  INPUT STREAM s1 FROM VALUE(cName).
  REPEAT:
    ASSIGN c1 = "".
    IMPORT STREAM s1 UNFORMATTED c1.
    {&OUT} html-encode(c1) SKIP.
  END.
  INPUT STREAM s1 CLOSE.

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

&IF DEFINED(EXCLUDE-showBeautify) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showBeautify Procedure 
PROCEDURE showBeautify :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  {&OUT} fBeginTable("Beautify options:|").

  {&OUT} 
    fRow("File Action:|"
    + fRadio("savechg","")  + "View"
    + fRadio("savechg","o") + "and replace file"
    + fRadio("savechg","b") + "copy results to *b.*").

  {&OUT} 
    fRow("Progress Keywords:|"
    + fRadio("keyword","")  + "No change "
    + fRadio("keyword","u") + "Uppercase "
    + fRadio("keyword","l") + "Lowercase &nbsp;"
    + '<INPUT TYPE="checkbox" NAME="expand" VALUE="ON" '
    + (IF GET-VALUE("expand") > "" THEN "CHECKED>" ELSE ">" ) + "Keyword Expand").
  
  {&OUT} fRow("HTML Keywords:|"
    + fRadio("keyhtml","")  + "No change "
    + fRadio("keyhtml","u") + "Uppercase "
    + fRadio("keyhtml","l") + "Lowercase").

  {&OUT} "</TABLE>" SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showCode Procedure 
PROCEDURE showCode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFile     AS CHARACTER NO-UNDO.  /*** Input Filename             ***/
  DEFINE VARIABLE cFileFull AS CHARACTER NO-UNDO.  /*** Full Input filename        ***/
  DEFINE VARIABLE cFileName AS CHARACTER NO-UNDO.  /*** Just Filename              ***/
  DEFINE VARIABLE i1        AS INTEGER   NO-UNDO.

  {&OUT}
    '<BR>Perform~n'
    '<SELECT NAME="perform" SIZE="1" onChange="document.form.Do.value = document.form.perform.options[document.form.perform.selectedIndex].value;document.form.submit()">~n'
    ' <OPTION VALUE="Compile" '    IF cAction = "Compile"    THEN "SELECTED" ELSE "" '>Compile</OPTION>~n'
    ' <OPTION VALUE="Beautify" '   IF cAction = "Beautify"   THEN "SELECTED" ELSE "" '>Beautify</OPTION>~n'
    ' <OPTION VALUE="Listing" '    IF cAction = "Listing"    THEN "SELECTED" ELSE "" '>Compile Listing</OPTION>~n'
    ' <OPTION VALUE="PreCompile" ' IF cAction = "PreCompile" THEN "SELECTED" ELSE "" '>PreProcess</OPTION>~n'
    ' <OPTION VALUE="XREF" '       IF cAction = "XREF"       THEN "SELECTED" ELSE "" '>XREF-Compile</OPTION>~n'
    ' <OPTION VALUE="SXR" '        IF cAction = "SXR"        THEN "SELECTED" ELSE "" '>String X-Ref</OPTION>~n'
    ' <OPTION VALUE="Debug" '      IF cAction = "Debug"      THEN "SELECTED" ELSE "" '>Debug-list</OPTION>~n'
    ' </select> on    <small>(click on file below to perform action)</small>'
    '<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2" WIDTH="100%">~n'.

  {&OUT} 
    fHRow("Files in " + cPath).

  DO i1 = 1 TO NUM-ENTRIES(cFiles):
    ASSIGN cFile = ENTRY(i1,cFiles).
    IF cFile = "" THEN NEXT.
    ASSIGN
        cFileFull = REPLACE(REPLACE(SEARCH(cFile),"~\","/"),"./",cDirCD)  /** Full filename **/
        cFileName = ENTRY(NUM-ENTRIES(cFileFull,"/"),cFileFull,"/").      /** Filename **/

    {&OUT} 
      fRow("<A HREF=""JavaScript:fExec('" + cFile + "');"">" + cFile + "</A> &nbsp; &nbsp; ").
  END.
  {&OUT} "</TABLE>" SKIP.
  {&OUT}
       '<SCRIPT LANGUAGE="javascript">~n'
       "document.form.Name.value=''~;~n"
       "document.form.Do.value==document.form.perform.value;~n"
       "if (document.form.Do.value=='DirUtil') document.form.Do.value='Compile'~;~n"
       "if (document.form.Do.value=='') document.form.Do.value='Compile'~;~n"
       'function fExec(cFile)~{~n'
       '  document.form.Name.value=cFile~;~n'
       '  document.form.submit()~;~n'
       '~}~n'
       '</SCRIPT>~n'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fCompile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCompile Procedure 
FUNCTION fCompile RETURNS CHARACTER
  ( cFileFull AS CHARACTER,
    cAction AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Compile one file
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE i1         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSpeedFile AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOptions   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFile      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cXCode     AS CHARACTER  NO-UNDO.

  ASSIGN
    cFile      = cFileFull
    cSpeedFile = ""
    cOptions   = "". /* uncompiled webspeed object to create */

  {&OUT} "<BR>Compiling " cFileFull SKIP.

  IF cFileFull MATCHES "*.html" OR
     cFileFull MATCHES "*.htm"  THEN DO:
    ASSIGN cOptions = ENTRY(1,cFileFull,".") + ".w".
    RUN webutil/e4gl-gen.r (INPUT cFileFull, INPUT-OUTPUT cSpeedFile,
                            INPUT-OUTPUT cOptions) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
      {&OUT} "<BR>ERROR = " ERROR-STATUS:GET-MESSAGE(1) SKIP.
    ASSIGN cFileFull = cOptions.
    {&OUT} "<BR>Scripted " cFileFull SKIP.
  END.

  CASE cAction:
    WHEN "compile"    THEN DO:
      ASSIGN
        cXCode = DYNAMIC-FUNCTION('getAgentSetting' IN web-utilities-hdl,'Compile','','xcode') NO-ERROR.  
      IF cXCode > "" 
      THEN COMPILE VALUE(cFileFull) SAVE XCODE cXCode NO-ERROR.
      ELSE COMPILE VALUE(cFileFull) SAVE NO-ERROR.
    END.
    WHEN "precompile" THEN COMPILE VALUE(cFileFull) SAVE PREPROCESS  VALUE(cFile + ".pre") NO-ERROR.
    WHEN "listing"    THEN COMPILE VALUE(cFileFull) SAVE LISTING     VALUE(cFile + ".lst") NO-ERROR.
    WHEN "xref"       THEN COMPILE VALUE(cFileFull) SAVE XREF        VALUE(cFile + ".xrf") NO-ERROR.
    WHEN "sxr"        THEN COMPILE VALUE(cFileFull) SAVE STRING-XREF VALUE(cFile + ".sxr") NO-ERROR.
    WHEN "debug"      THEN COMPILE VALUE(cFileFull) SAVE DEBUG-LIST  VALUE(cFile + ".dbg") NO-ERROR.
  END CASE.

  DO i1 = 1 TO ERROR-STATUS:NUM-MESSAGES:
    {&OUT} "<BR>Message " i1 ": " ERROR-STATUS:GET-MESSAGE(i1) SKIP.
  END.
  {&OUT} "<BR>" cAction "  " cFileFull " : " STRING(COMPILER:ERROR,"ERROR/OK") SKIP.
  IF cOptions > "" THEN 
    OS-DELETE VALUE(cFileFull).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fCompileResults) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCompileResults Procedure 
FUNCTION fCompileResults RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Compile several files
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE c1  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1  AS INTEGER    NO-UNDO.

  OUTPUT STREAM WebStream CLOSE.
  OUTPUT STREAM WebStream TO "compile.lst".
  RUN webtools/fileact.w no-error.
  OUTPUT STREAM WebStream CLOSE.

  OUTPUT STREAM WebStream TO "WEB".
  {&OUT} fBeginTable("Filename|Compile Status").
  INPUT STREAM s1 FROM "compile.lst".
  REPEAT:
    ASSIGN c1 = ''.
    IMPORT STREAM s1 UNFORMATTED c1.
    i1 = INDEX(c1,"<I>").
    IF c1 MATCHES "*Generating SpeedScript*" THEN c2 = "".
    IF c1 MATCHES '*<FONT COLOR="#990000"><B>Compiling*' THEN c2 = SUBSTRING(SUBSTRING(c1,i1 + 3),1,INDEX(SUBSTRING(c1,i1 + 3),"</i>") - 1) + "|".
    IF c1 MATCHES "*<P>*" THEN c2 = c2 + c1.
    IF c1 MATCHES "*<UL>No Errors*" THEN c2 = c2 + "OK!".
    IF c1 MATCHES "*</UL>*" THEN DO:
      IF c2 > "" THEN 
        {&OUT} fRow(c2).
      ASSIGN c2 = "".
    END.
  END.
  {&OUT} "</TABLE>" SKIP.
  INPUT STREAM s1 CLOSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fCompileStart) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCompileStart Procedure 
FUNCTION fCompileStart RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  {&OUT} 
    '<INPUT TYPE="hidden" NAME="FileAction" VALUE="Compile">~n'
    '<INPUT TYPE="hidden" NAME="Filename" VALUE="' html-encode(cFiles) '">~n'
    '<H2>Please wait!</H2><P>Compilation listing will be shown after all programs have finished compiling!</p>~n'
    '<SCRIPT LANGUAGE="JavaScript">~n'
    '  document.form.Do.value="DoCompile";~n'
    '  document.form.submit()~n'
    '</SCRIPT>~n'.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fDoWithFiles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDoWithFiles Procedure 
FUNCTION fDoWithFiles RETURNS CHARACTER
  ( cAction AS CHARACTER,
    cFiles AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE i1        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFile     AS CHARACTER  NO-UNDO.  /*** Input Filename             ***/
  DEFINE VARIABLE cFileFull AS CHARACTER  NO-UNDO.  /*** Full Input filename        ***/
  DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.  /*** Just Filename              ***/

  DO i1 = 1 TO NUM-ENTRIES(cFiles):
    ASSIGN cFile = ENTRY(i1,cFiles).
    IF cFile = "" THEN NEXT.
    ASSIGN
      cFileFull = REPLACE(REPLACE(SEARCH(cFile),"~\","/"),"./",cDirCD)  /** Full filename **/
      cFileName = ENTRY(NUM-ENTRIES(cFileFull,"/"),cFileFull,"/").      /** Filename **/

    CASE cAction:
      WHEN "Beautify"   THEN RUN beautify(cFileFull).
      WHEN "Compile"    OR
      WHEN "Listing"    OR
      WHEN "XREF"       OR
      WHEN "SXR"        OR
      WHEN "Debug"      OR
      WHEN "Precompile" THEN fCompile(cFileFull,cAction).
    END CASE.
    IF CAN-DO('listing,xref,precompile,sxr,debug',cAction) THEN
      RUN pShowFile(cFileFull + "." + 
                    ENTRY(1 + LOOKUP(cAction,"listing,xref,precompile,sxr,debug,beautify"),
                                     "tmp,lst,xrf,pre,sxr,dbg")).
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fLine) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fLine Procedure 
FUNCTION fLine RETURNS CHARACTER
  ( i1 AS INTEGER,
    i2 AS INTEGER,
    cTxt AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN
    '<FONT COLOR="'
    + (IF i1 = 0 THEN "red" ELSE IF i2 = 0 THEN "green" ELSE "black")
    + '">' + STRING(i1,">>>>") + STRING(i2,">>>>") + " " + html-encode(cTxt) + '</FONT>' 
    + CHR(10).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fRadio) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fRadio Procedure 
FUNCTION fRadio RETURNS CHARACTER
  ( cName AS CHARACTER,
    cValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN 
    '<INPUT TYPE="radio" NAME="' + cName + '" VALUE="' + cValue + '"'
    + (IF GET-VALUE(cName) = cValue THEN ' CHECKED>' ELSE '>').

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

