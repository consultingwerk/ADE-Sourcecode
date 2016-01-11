&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2002 by Progress Software Corporation ("PSC"),       *
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
/*--------------------------------------------------------------------
    File        : database.p
    Purpose     : Database browse tools library
    Syntax      :
    Description :
    Author(s)   : Per S Digre (pdigre@progress.com)
    Updated     : 04/04/98 pdigre@progress.com
                    Initial version
                  04/24/01 adams@progress.com
                    WebSpeed integration
                  08/13/02 adams@progress.com
                    Support for filtering out PeerDirect sequences
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{ src/web/method/cgidefs.i }

&GLOBAL-DEFINE cColorHeader " bgcolor=#DEB887 "
&GLOBAL-DEFINE cColorRow1   " bgcolor=#FFFFE6 "
&GLOBAL-DEFINE cBrowseTableDef " border=1 cellpadding=0 cellspacing=0 width=90% "

/**** Data Browse control *****/
DEFINE NEW GLOBAL SHARED VARIABLE cDictdb      AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cAction      AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cIndex       AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cWhere       AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cCountString AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cFirst       AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cLast        AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cDBid        AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cTable       AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cRowID       AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cFile        AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAl SHARED VARIABLE cType        AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hDatabase    AS HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hHTML        AS HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE iCurrent     AS INTEGER   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE iCount       AS INTEGER   NO-UNDO.
DEFINE NEW GLOBAl SHARED VARIABLE lVST         AS LOGICAL   NO-UNDO.

/* generic object definition section  */
DEFINE VARIABLE hParent   AS HANDLE    NO-UNDO.
DEFINE VARIABLE cCallback AS CHARACTER NO-UNDO.

DEFINE VARIABLE lWordIdx AS LOGICAL NO-UNDO.

DEFINE STREAM sIni.

FUNCTION fRow        RETURNS CHARACTER
  (INPUT cData   AS CHARACTER) IN hHTML.
FUNCTION fHRow       RETURNS CHARACTER 
  (INPUT cLabels AS CHARACTER) IN hHTML.
FUNCTION fBeginTable RETURNS CHARACTER
  (INPUT cLabels AS CHARACTER) IN hHTML.
FUNCTION fTable      RETURNS CHARACTER
  (INPUT cLabels AS CHARACTER,
   INPUT cData   AS CHARACTER) IN hHTML.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fChoices) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fChoices Procedure 
FUNCTION fChoices RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fFieldAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fFieldAdd Procedure 
FUNCTION fFieldAdd RETURNS CHARACTER
  ( hField AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fFieldHtml) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fFieldHtml Procedure 
FUNCTION fFieldHtml RETURNS CHARACTER
  ( hField AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fFieldSave) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fFieldSave Procedure 
FUNCTION fFieldSave RETURNS CHARACTER
  ( hField AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fNumFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNumFormat Procedure 
FUNCTION fNumFormat RETURNS CHARACTER
  (INPUT cNum AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fOut) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fOut Procedure 
FUNCTION fOut RETURNS CHARACTER
  ( c1 AS CHARACTER )  FORWARD.

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

ASSIGN cDictDb = LDBNAME("DICTDB").

DYNAMIC-FUNCTION("logNote" IN web-utilities-hdl, "RUN":U, "DB:" + cDictDb) NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-dbBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dbBrowse Procedure 
PROCEDURE dbBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE q1       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hb       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hf       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE i1       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i2       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRow     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c1       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery   AS CHARACTER  NO-UNDO.
  
  CREATE BUFFER hb FOR TABLE STRING(cDBid + ".":U + cTable).

  /* Use dynamic query to find record for buffer */
  IF cAction <> 'browse' THEN 
    cWhere = get-value('where').

  fChoices().

  ASSIGN
    cQuery = (IF cAction = "count" THEN 'PRESELECT' ELSE 'FOR')
    cQuery = cQuery + ' EACH ' + cTable + ' NO-LOCK ' + cWhere
           + (IF cIndex > '' AND NOT lWordIdx THEN ' USE-INDEX ' + cIndex ELSE '')
           + ' INDEXED-REPOSITION'.

  DYNAMIC-FUNCTION("logNote" IN web-utilities-hdl, "RUN":U, "Query:" + cQuery) NO-ERROR.

  CREATE QUERY q1.
  q1:SET-BUFFERS(hb).
  q1:QUERY-PREPARE(cQuery).
  q1:QUERY-OPEN().

  CASE cAction:
    WHEN "next" THEN DO:
      iCurrent = iCurrent + 10.
      q1:REPOSITION-TO-ROWID(TO-ROWID(cFirst)).
      q1:REPOSITION-FORWARD(20).
      q1:REPOSITION-BACKWARD(10).
      q1:GET-NEXT.
    END.
    WHEN "count" THEN DO:
      ASSIGN iCount = q1:NUM-RESULTS.
      q1:REPOSITION-TO-ROWID(TO-ROWID(cFirst)).
      q1:GET-NEXT.
    END.
    WHEN "prev" THEN DO:
      iCurrent = iCurrent - 10.
      q1:REPOSITION-TO-ROWID(TO-ROWID(cFirst)).
      q1:REPOSITION-BACKWARD(10).
      q1:GET-NEXT.
    END.
    WHEN "last" THEN DO:
      iCurrent = iCount - 9.
      q1:GET-LAST.
      q1:REPOSITION-BACKWARD(10).
      q1:GET-NEXT.
    END.
    OTHERWISE do:
      q1:GET-FIRST.
      iCurrent = 1.
    END.
  END CASE.

  IF cAction = "find":U THEN 
    iCount = 0.

  IF q1:QUERY-OFF-END THEN DO:
    q1:GET-FIRST.
    iCurrent = 1.
  END.

  IF iCurrent > iCount - 10 THEN 
    iCurrent = iCount - 9.
  IF iCurrent < 1 THEN 
    iCurrent = 1.

  ASSIGN
    cCountString = (IF iCount > 0 THEN
                     " Showing " + STRING(iCurrent) + " - " + STRING(iCurrent + 9) + 
                     " of " + STRING(iCount) + " records " ELSE "")
    i2           = 0
    c1           = ''
    cFirst       = STRING(hb:ROWID).

  REPEAT i1 = 1 TO hb:NUM-FIELDS:
    hf = hb:BUFFER-FIELD(i1).
    IF NOT CAN-DO('character,integer,date,decimal',hf:DATA-TYPE) THEN NEXT.
    IF hf:EXTENT > 0 THEN NEXT.
    c1 = c1 + "|":U + hf:NAME.
    i2 = i2 + 1.
    IF i2 = 8 THEN LEAVE.
  END.
  {&OUT} fBeginTable(SUBSTRING(c1,2)) SKIP.

  DO iRow = 1 TO 10:
    IF q1:QUERY-OFF-END THEN LEAVE.
    ASSIGN i2 = 0.

    /* Only show maximum of 8 columns */
    REPEAT i1 = 1 TO MINIMUM(8,hb:NUM-FIELDS):
      hf = hb:BUFFER-FIELD(i1).
      IF NOT CAN-DO('character,integer,date,decimal',hf:DATA-TYPE) THEN NEXT.
      IF hf:EXTENT > 0 THEN NEXT.
      IF i2 = 0 THEN
        c1 = "<A HREF=~"javascript:fEdit('":U + STRING(hb:ROWID) + "')~"> &nbsp; ":U + 
          hf:STRING-VALUE + " &nbsp; </A>":U.
      ELSE 
        c1 = c1 + '|':U + html-encode(hf:BUFFER-VALUE).
      i2 = i2 + 1.
    END.
    {&OUT} fRow(c1) SKIP.
    q1:GET-NEXT.
  END.
  {&OUT} "</TR></TABLE>":U SKIP.
  ASSIGN
    cLast = STRING(hb:ROWID).

  DELETE OBJECT hb.    
  DELETE OBJECT q1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dbReport) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dbReport Procedure 
PROCEDURE dbReport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c1    AS CHARACTER NO-UNDO.

  DEFINE QUERY qList 
    FOR DICTDB._file. 
    /* FIELDS (DICTDB._file._frozen DICTDB._file._Desc DICTDB._file._file-name) */

  CASE cType:
    WHEN "std" THEN 
      OPEN QUERY qList PRESELECT EACH DICTDB._file NO-LOCK 
        WHERE NOT _frozen  BY _file-name.
    WHEN "sys" THEN 
      OPEN QUERY qList PRESELECT EACH DICTDB._file no-lock 
        WHERE     _frozen  BY _file-name.
  END CASE.

  GET FIRST qList.
  DO WHILE AVAILABLE DICTDB._file:
    IF cAction = "rep" AND get-value("F" + DICTDB._file._file-name) = '' THEN DO:
      GET NEXT qList.
      NEXT.
    END.
    {&OUT} 
      '<H2>' cDBid '.' DICTDB._file._file-name '</H2><P>' DICTDB._file._desc '</P>' SKIP
      fBeginTable('Field Name|Type|Format|Label|Col Label').

    FOR EACH DICTDB._field NO-LOCK OF DICTDB._file BY DICTDB._field._field-name:
      {&OUT} 
        fRow("<a href=dblist.w?command=getFieldInfo&ldbname=" 
        + cDBid + "&table=" + DICTDB._file._file-name
        + "&field=" + _field._field-name + "&sdbname=" + cDBid + ">"
        + _field._field-name + '</a>|' + _field._data-type + 
            (IF _field._extent > 0 THEN '[' + string(_field._extent) + ']' else '') + '|' + 
             _field._format + '|' + fOut(_field._Label) + '|' + 
             fOut(_field._col-label)).
    END.
    {&OUT} 
      "</TABLE>" SKIP
      fBeginTable('Index Name|Index Fields|Flags|Desc').
    FOR EACH DICTDB._index NO-LOCK OF DICTDB._file BY _index-name:
      {&OUT} 
        '<TR ' {&cColorRow1} '><TD><a href=dblist.w?command=getIndexInfo&ldbname=' 
        + cDBid + "&table=" + DICTDB._file._file-name
        + '&index=' + _index._index-name + '&sdbname=' + cDBid + '>'
         _index._index-name '</a></TD><TD><TABLE>' SKIP.

      FOR EACH DICTDB._index-field NO-LOCK OF _index, 
        FIRST DICTDB._field WHERE RECID(_field) = _index-field._field-recid BY _index-seq:
        {&OUT} 
          '<TR ' {&cColorRow1} '><TD> ' _index-seq '</TD><TD>' _field._field-name '</TD></TR>' SKIP.
      END.
      {&OUT} 
        '</TABLE></TD><TD>' SKIP
        STRING((IF _unique       THEN " Unique"  ELSE "") +
               (IF _file._prime-index = RECID(_index)  THEN " Primary"  ELSE "") +
               (IF _active       THEN " Active"  ELSE "") +
               (IF _wordidx <> ? THEN " WordIdx" ELSE ""))
        '</TD><TD>&nbsp;' fOut(_index._desc) '</TD></TR>' SKIP
        .
    END.
    {&OUT} '</TABLE><BR CLASS="break">' SKIP.
    GET NEXT qList.
  END.
  CLOSE QUERY qList.

  IF cAction = "repall":U OR GET-VALUE("seq":U) > '' THEN DO:
    {&OUT} 
      '<H2>' cDBid '.SEQUENCES:</h2>' SKIP
      fBeginTable('Sequence Name|Number|Min|Max').

    FOR EACH DICTDB._Sequence NO-LOCK 
      WHERE NOT _Seq-Name BEGINS "$" BY _Seq-Name :
      {&OUT} 
        fRow(_Seq-Name + '|' + STRING(_Seq-Num) + '|' + STRING(_Seq-Min) + '|' + 
             (IF _Seq-Max <> ? THEN STRING(_Seq-Max) ELSE "?")).
    END.
    {&OUT} '</TABLE>' SKIP.
  END.

  IF cAction = "repall" OR GET-VALUE("tri") > '' THEN DO:
    {&OUT} 
      '<H2>' cDBid '.TRIGGERS:</h2>' SKIP
      fBeginTable('Trigger|Event|Procedure').

    FOR EACH DICTDB._File-Trig NO-LOCK, 
      EACH DICTDB._File OF DICTDB._File-Trig BY _File-Name:
      {&OUT} 
        fRow(_File-Name + '|' + _File-Trig._Event + '|' + _File-Trig._Proc-Name).
    END.
    FOR EACH DICTDB._Field-Trig NO-LOCK, 
      EACH DICTDB._Field OF DICTDB._Field-Trig, EACH DICTDB._File OF DICTDB._Field BY _File-Name BY _Field-Name :
      {&OUT} fRow(_File-Name + '.' + _Field-Name + '|' + _Field-Trig._Event + 
                  '|' + _Field-Trig._Proc-Name).
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayRecord Procedure 
PROCEDURE displayRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE q1       AS WIDGET-HANDLE.
  DEFINE VARIABLE hb       AS HANDLE.
  DEFINE VARIABLE hf       AS HANDLE.
  DEFINE VARIABLE i1       AS INTEGER.

  CREATE BUFFER hb FOR TABLE string(cDBid + ".":U + cTable).
  
  IF get-value("recid") > "" THEN DO: /* FIND rowid from recid ****/
    /* Use dynamic query to find record for buffer */
    DYNAMIC-FUNCTION("logNote" IN web-utilities-hdl, "RUN":U, "Convert recid:" + get-value("recid")) NO-ERROR.

    CREATE QUERY q1.
    q1:SET-BUFFERS(hb).
    q1:QUERY-PREPARE('FOR EACH ' + cTable + ' NO-LOCK WHERE RECID(' + cTable + ') = ' + get-value("recid")).
    q1:QUERY-OPEN().
    q1:GET-NEXT.
    cRowid = string(hb:rowid).
    DELETE OBJECT q1.
  END.

  DYNAMIC-FUNCTION("logNote" IN web-utilities-hdl, "RUN":U, "Display Rec rowid=" + cRowid) NO-ERROR.

  hb:FIND-BY-ROWID(TO-ROWID(cRowid), NO-LOCK).
  DYNAMIC-FUNCTION("logNote" IN web-utilities-hdl, "RUN":U, "Fields=" + string(hb:NUM-FIELDS)) NO-ERROR.
  REPEAT i1 = 1 TO hb:NUM-FIELDS:
    hf = hb:BUFFER-FIELD(i1).
    fFieldHTML(hf).    /****** Display the data fields *******/
  END.
  DELETE OBJECT hb.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processRecord Procedure 
PROCEDURE processRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hb  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hf  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE i1  AS INTEGER    NO-UNDO.

  DO TRANSACTION:
    CREATE BUFFER hb FOR TABLE STRING(cDBid + ".":U + cTable).

    IF cAction = "add":U THEN DO:
      hb:BUFFER-CREATE().
      ASSIGN cRowID = STRING(hb:ROWID).
    END.
    hb:FIND-BY-ROWID(TO-ROWID(cRowid)).

    IF cAction = "del":U THEN do:
      hb:BUFFER-DELETE().
      ASSIGN cRowID = ''.
    END.

    REPEAT i1 = 1 TO hb:NUM-FIELDS:
      hf = hb:BUFFER-FIELD(i1).
      IF cAction = "add":U  THEN fFieldAdd(hf).   /**** Assign new data fields ****/
      IF cAction = "save":U THEN fFieldSave(hf).  /**** Assign the data fields ****/
    END.
  END. /** Transaction ***/
  DELETE OBJECT hb.

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
  DEFINE INPUT PARAMETER h1 AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER c1 AS CHARACTER NO-UNDO.

  ASSIGN 
    hParent   = h1
    cCallBack = c1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tableList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tableList Procedure 
PROCEDURE tableList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE c1 AS CHARACTER NO-UNDO.

  FIND FIRST DICTDB._file WHERE DICTDB._file._file-name = "_connect" NO-ERROR.
  ASSIGN lVST = AVAIL DICTDB._file.

  DEFINE QUERY qList FOR DICTDB._file 
    FIELDS (DICTDB._file._frozen DICTDB._file._Desc DICTDB._file._file-name).
  CASE cType:
    WHEN "std" THEN 
      OPEN QUERY qList PRESELECT EACH DICTDB._file NO-LOCK WHERE NOT _frozen.
    WHEN "sys" THEN
      OPEN QUERY qList PRESELECT EACH DICTDB._file NO-LOCK WHERE _frozen.
  END CASE.

  {&OUT} fBeginTable("Table|Description").
  GET FIRST qList.
  DO WHILE AVAILABLE DICTDB._file:
    ASSIGN c1 = DICTDB._file._file-name.
    {&OUT} fRow('<INPUT TYPE=checkbox NAME="f' + c1
        + (IF GET-VALUE("f" + c1) = "" THEN '" ' ELSE '" checked') + ">"
        + '<A HREF="databrw.p?db=' + cDBid + '&tb=' + DICTDB._file._file-name + '">' + DICTDB._file._file-name + '</A>'
      + '|' + IF DICTDB._file._Desc = ? THEN "?" ELSE DICTDB._file._Desc
      ).
    GET NEXT qList.
  END.
  {&OUT}
    fRow('<INPUT TYPE=checkbox NAME=seq' + (IF GET-VALUE("seq") = "" THEN ' ' ELSE ' checked') + '> # Sequences|')
    fRow('<INPUT TYPE=checkbox NAME=tri' + (IF GET-VALUE("tri") = "" THEN ' ' ELSE ' checked') + '> # Triggers|')
        + "</TABLE>".
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fChoices) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fChoices Procedure 
FUNCTION fChoices RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInput  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1      AS INTEGER    NO-UNDO.

  {&OUT} 
    '<INPUT TYPE="button" NAME="find" VALUE="Find"'
    ' onClick="document.form.Do.value=''find'';document.form.submit();"> '
    cDBid '.' cTable ' use <SELECT NAME="index" VALUE="" onChange="'
     + 'document.form.index.value=document.form.index.options[document.form.index.selectedIndex].value;document.form.submit();~">' SKIP.
  {&OUT} '<OPTION VALUE=""> - </OPTION> '.

  IF CAN-DO(" Save ,Delete",get-value("do")) THEN RETURN "".
  ELSE 
    ASSIGN 
      cWhere   = ""
      lWordIdx = FALSE.

  FOR EACH DICTDB._file NO-LOCK WHERE DICTDB._file._file-name = cTable
     ,EACH DICTDB._index NO-LOCK OF _file:

    ASSIGN 
      cFields  = ''.
    FOR EACH DICTDB._index-field NO-LOCK OF DICTDB._index
       ,EACH DICTDB._field NO-LOCK OF DICTDB._index-field:

      cFields = cFields + ",":U + DICTDB._field._field-name.


      IF DICTDB._index._index-name = cIndex THEN DO:
        ASSIGN
          i1 = i1 + 1
          cInput = (IF cInput = '' THEN ('where ' + DICTDB._field._field-name) 
                    ELSE (cInput + ' and ' + DICTDB._field._field-name)). 
        IF DICTDB._index._wordidx > 0 THEN
          ASSIGN
            cInput   = cInput + ' contains '. 
        ELSE 
        CASE DICTDB._field._data-type:
          WHEN 'character' THEN ASSIGN 
            cInput = cInput + ' begins '.
          WHEN 'integer'   THEN ASSIGN
            cInput = cInput + ' is '.
          WHEN 'decimal'   THEN ASSIGN
            cInput = cInput + ' is '.
          WHEN 'date'      THEN ASSIGN
            cInput = cInput + ' is '.
        END CASE.
        ASSIGN
          cInput = cInput + '<INPUT TYPE="text" SIZE="10" NAME="w' + STRING(i1) + '" VALUE="' + 
                   html-encode(get-value('w' + STRING(i1))) + '">':U.
      END.
      IF DICTDB._index._index-name = cIndex AND get-value('w' + STRING(i1)) > '' THEN DO:
        ASSIGN
          cWhere = (IF cWhere = '' THEN ('where ' + DICTDB._field._field-name) 
                    ELSE (cWhere + ' and ' + DICTDB._field._field-name)).

        IF DICTDB._index._wordidx > 0 THEN
          ASSIGN
            cWhere   = cWhere + ' contains "' + get-value('w' + STRING(i1)) + '"'
            lWordIdx = TRUE.
        ELSE 
        CASE DICTDB._field._data-type:
          WHEN 'character' THEN ASSIGN 
            cWhere = cWhere + ' begins "' + get-value('w' + STRING(i1)) + '"'.
          WHEN 'integer'   THEN ASSIGN
            cWhere = cWhere + ' = ' + STRING(INTEGER(get-value('w' + STRING(i1))),'>>>>>>>>9').
          WHEN 'decimal'   THEN ASSIGN
            cWhere = cWhere + ' = ' + get-value('w' + STRING(i1)).
          WHEN 'date'      THEN ASSIGN
            cWhere = cWhere + ' = date("' + get-value('w' + STRING(i1)) + '")'.
        END CASE.
      END.
    END.

    {&OUT} '<OPTION '.
    IF DICTDB._index._index-name = cIndex THEN DO:
      {&OUT} ' SELECTED'.
    END.
    {&OUT} 
      ' VALUE="' + DICTDB._index._index-name + '">' + SUBSTRING(cFields,2) +
      '</OPTION>' SKIP.
   END.
   {&OUT} '</SELECT> ' SKIP cInput SKIP.
   RETURN "".
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fFieldAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fFieldAdd Procedure 
FUNCTION fFieldAdd RETURNS CHARACTER
  ( hField AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE q1 AS WIDGET-HANDLE.
  DEFINE VARIABLE hb AS HANDLE.
  DEFINE VARIABLE h1 AS HANDLE.

  /** If field is mandatory we'll have to assign a value **/
  IF hField:BUFFER-VALUE = ? AND hField:mandatory THEN DO:
    IF hField:DATA-TYPE = "logical":U   THEN hField:BUFFER-VALUE = FALSE.
    IF hField:DATA-TYPE = "character":U THEN hField:BUFFER-VALUE = 'z'.
    IF hField:DATA-TYPE = "integer":U   THEN hField:BUFFER-VALUE = 1.
    IF hField:DATA-TYPE = "decimal":U   THEN hField:BUFFER-VALUE = 1.0.
    IF hField:DATA-TYPE = "date":U      THEN hField:BUFFER-VALUE = TODAY.
  END.

  /*** If field is part of an unique index then find a unique value to it **/
  FOR EACH DICTDB._file        NO-LOCK                 WHERE DICTDB._file._file-name   = cTable
     ,EACH DICTDB._field       NO-LOCK OF DICTDB._file WHERE DICTDB._field._field-name = hField:name
     ,EACH DICTDB._index-field NO-LOCK OF DICTDB._field
     ,EACH DICTDB._index       NO-LOCK OF DICTDB._index-field WHERE DICTDB._index._unique:

    CREATE QUERY q1.
    CREATE BUFFER hb FOR TABLE string(cDBid + "." + cTable).

    q1:SET-BUFFERS(hb).
    q1:QUERY-PREPARE('FOR EACH ' + cTable + ' NO-LOCK BY ' + hField:name).
    q1:QUERY-OPEN().
    q1:GET-LAST.
    h1 = hb:BUFFER-FIELD(hField:name).

    IF hField:DATA-TYPE = "logical"   THEN 
      hField:BUFFER-VALUE = NOT h1:BUFFER-VALUE.
    IF hField:DATA-TYPE = "character" THEN 
      hField:BUFFER-VALUE = h1:BUFFER-VALUE + 'z'.
    IF hField:DATA-TYPE = "integer"   THEN 
      hField:BUFFER-VALUE = h1:BUFFER-VALUE + 1.
    IF hField:DATA-TYPE = "decimal"   THEN 
      hField:BUFFER-VALUE = h1:BUFFER-VALUE + 1.0.
    IF hField:DATA-TYPE = "date"      THEN 
      hField:BUFFER-VALUE = h1:BUFFER-VALUE + 1.

    DELETE OBJECT hb.
    DELETE OBJECT q1.
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fFieldHtml) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fFieldHtml Procedure 
FUNCTION fFieldHtml RETURNS CHARACTER
  ( hField AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cField AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNum   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cExt   AS CHARACTER  NO-UNDO.
  
  ASSIGN iNum = hField:EXTENT.
  IF iNum = ? or iNum = 0 then iNum = 0.
  DO i1 = 0 TO iNum:
    cExt = "/" + STRING(i1).
    IF iNum > 0 and i1 = 0 THEN NEXT.
    ASSIGN
      cField = hField:NAME + cExt.

    {&OUT} 
      '<TR><TD ALIGN="right">' + (IF i1 > 0 THEN cField ELSE hField:NAME) + ':</TD><TD ALIGN="left">'.

    IF hField:DATA-TYPE = "logical":U THEN DO:
      {&OUT} 
        '<INPUT TYPE="radio" VALUE="true" NAME="' + cField + '" '.

      IF  hField:BUFFER-VALUE(i1) THEN {&OUT} " checked".

      {&OUT} 
        ">" + ENTRY(1,hField:FORMAT,"/") + 
        '<INPUT TYPE="radio" NAME="' + cField + '" VALUE="false"'.

      IF NOT hField:BUFFER-VALUE(i1) THEN {&OUT} " checked".

      {&OUT} 
        ">" + ENTRY(2,hField:FORMAT,"/") + 
        ' &nbsp; / <INPUT TYPE="radio" NAME="' + cField + '" VALUE="?"'.

      IF hField:BUFFER-VALUE(i1) = ? THEN {&OUT} " checked".
      {&OUT}   ">?".
    END.
    ELSE
    IF hField:DATA-TYPE = "character":U THEN DO:
      IF hField:WIDTH-CHARS < 40 THEN
        {&OUT} 
          '<INPUT NAME="' + cField + '" TYPE="text" SIZE="' + 
          STRING(hField:WIDTH-CHARS) + '" VALUE="' + 
          html-encode(RIGHT-TRIM(hField:BUFFER-VALUE(i1))) + '">':U.
      ELSE 
        {&OUT} 
          '<TEXTAREA ROWS="3" COLS="40" NAME="' + cField + '">' + 
          html-encode(RIGHT-TRIM(hField:BUFFER-VALUE(i1))) + 
          '</TEXTAREA>'.
    END.
    ELSE
    IF CAN-DO("decimal,integer,date":U,hField:DATA-TYPE) THEN
      {&OUT} 
        '<INPUT NAME="' + cField + '" TYPE="text" SIZE="' + 
        STRING(hField:WIDTH-CHARS) + '" VALUE="' + 
        html-encode(RIGHT-TRIM(hField:STRING-VALUE(i1))) + '">':U.
    ELSE
      {&OUT} 
        '<INPUT NAME="' + cField + '" TYPE="text" SIZE="20" VALUE="' + 
        html-encode(RIGHT-TRIM(hField:STRING-VALUE(i1))) + '">'.
           
    {&OUT} 
      "</TD></TR>" + CHR(10).
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fFieldSave) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fFieldSave Procedure 
FUNCTION fFieldSave RETURNS CHARACTER
  ( hField AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cValue  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNum    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cExt    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField  AS CHARACTER  NO-UNDO.
  
  ASSIGN iNum = hField:EXTENT.
  IF iNum = ? or iNum = 0 then iNum = 0.
  DO i1 = 0 TO iNum:
    IF iNum > 0 and i1 = 0 THEN NEXT.
    ASSIGN
      cExt    = "/" + STRING(i1)
      cField  = hField:NAME + cExt
      cValue  = get-value(cField)
      .
    CASE hField:DATA-TYPE:
      WHEN "character" THEN hField:BUFFER-VALUE(i1) = cValue NO-ERROR.
      WHEN "date"      THEN hField:BUFFER-VALUE(i1) = DATE(cValue) NO-ERROR.
      WHEN "integer"   THEN hField:BUFFER-VALUE(i1) = INTEGER(fNumFormat(cValue)) NO-ERROR.
      WHEN "decimal"   THEN hField:BUFFER-VALUE(i1) = DECIMAL(fNumFormat(cValue)) NO-ERROR.
      WHEN "logical" THEN DO:
        IF cValue = 'true'  THEN hField:BUFFER-VALUE(i1) = TRUE NO-ERROR.
        IF cValue = 'false' THEN hField:BUFFER-VALUE(i1) = FALSE NO-ERROR.
        IF cValue = '?'     THEN hField:BUFFER-VALUE(i1) = ? NO-ERROR.
      END.
    END CASE.
    IF ERROR-STATUS:ERROR THEN
      queue-message("error","UPDATE ERROR on " + (IF i1 > 0 THEN cField ELSE hField:NAME) + ":" + ERROR-STATUS:get-message(1)).
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fNumFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNumFormat Procedure 
FUNCTION fNumFormat RETURNS CHARACTER
  (INPUT cNum AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Strip character formatting off Numerical inputs
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c1   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRet AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1   AS INTEGER    NO-UNDO.
  DO i1 = 1 TO LENGTH(cNum):
    c1 = SUBSTRING(cNum,i1,1).
    IF INDEX("0123456789-.,",c1) > 0 THEN
      cRet = cRet + c1.
  END.
  
  RETURN cRet.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fOut) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fOut Procedure 
FUNCTION fOut RETURNS CHARACTER
  ( c1 AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF c1 = ? THEN c1 = "".

  RETURN c1.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

