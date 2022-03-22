/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*   10/10/2000 pdigre@progress.com (Per Digre)
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------
  File: databrw.p 
  Description: Main menu for file-maintenance.  Gives a list of
               database-tables to browse and edit.
  Updated: 04/24/2001 adams@progress.com (Doug Adams)

---------------------------------------------------------------------*/
{ webtools/plus.i }

DEFINE NEW GLOBAL SHARED VARIABLE cDictdb      AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hDatabase    AS HANDLE    NO-UNDO.   /**** Object handle for database func ****/
DEFINE NEW GLOBAL SHARED VARIABLE hVST         AS HANDLE    NO-UNDO.   /**** Object handle for database func ****/
DEFINE NEW GLOBAL SHARED VARIABLE cDBid        AS CHARACTER NO-UNDO.   /**** Generic DB control *****/
DEFINE NEW GLOBAL SHARED VARIABLE cTable       AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cFile        AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cRowID       AS CHARACTER NO-UNDO.   /**** Edit Record control *****/
DEFINE NEW GLOBAL SHARED VARIABLE iCount       AS INTEGER   NO-UNDO.   /**** Data Browse control *****/
DEFINE NEW GLOBAL SHARED VARIABLE iCurrent     AS INTEGER   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cIndex       AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cCountString AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cWhere       AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cFirst       AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cLast        AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE cType        AS CHARACTER NO-UNDO.   /**** Virtual System Tables ****/
DEFINE NEW GLOBAL SHARED VARIABLE lVST         AS LOGICAL   NO-UNDO.

DEFINE VARIABLE ix AS INTEGER    NO-UNDO.

ASSIGN
    cType        = IF get-value("type":U) > "" THEN 
                   get-value("type":U) ELSE "std":U
    cTable       = get-value("tb":U)
    cDBid        = get-value("db":U)
    cRowID       = get-value("rowid":U) + get-value("recid":U)
    iCount       = INTEGER(get-value("count":U))
    iCurrent     = INTEGER(get-value("current":U))
    cIndex       = get-value("index":U)
    cWhere       = get-value("where":U)
    cFirst       = get-value("first":U)
    cLast        = get-value("last":U)
    cFile        = cDBid + ".":U + cTable

    cFormTitle   = "Database Browser"
    cFormTarget  = "databrw":U
    cFormBack    = "window.open('databrw.p','_self')"
    cFormHelp    = "databrw"
    cFormRefresh = "document.form.submit()"
    .

IF cDBid <> "" THEN DO:
  CREATE ALIAS DICTDB FOR DATABASE VALUE(cDBid).

  /** Comment last to always rerun in dev **/
  IF VALID-HANDLE(hDatabase) AND cDBid <> cDictDb THEN
    DELETE PROCEDURE hDatabase.

  IF NOT VALID-HANDLE(hDatabase) THEN
    RUN webtools/util/database.p PERSISTENT SET hDatabase.

  IF (cRowid > '' AND CAN-DO('delete,save',cAction)) OR cAction = "add" THEN DO:
    RUN processRecord IN hDatabase.
    IF cAction = 'save' AND NOT available-messages(?) THEN
      cRowID = ''.
    ELSE cAction = 'edit'.
  END.

  /* record detail */
  IF cRowid > '' AND cAction <> 'vstrecid' THEN DO:
    ASSIGN
      cFormTitle   = 'Record Detail'
      cFormHelp    = "databrw" /* "dbdt" */
      cFormBack    = "document.form.RowID.value='';document.form.submit()"
      cFormRefresh = "document.form.submit()"
      .
    fHeader().

    {&OUT} 
      '<P>Record: <B>' html-encode(cDBid + '.' + cTable) + '</B>  (' + 
      cRowid + ')' '</P>~n' 
      '<TABLE><TD><TABLE><TR><TD><TABLE>~n'.

    IF available-messages(?) THEN /*** display all error-messages ***/
      {&OUT} 
        "<BR><P><STRONG><FONT COLOR=red>" 
        output-messages("all",?,"Error-Messages") "</STRONG></FONT></P>" SKIP.
    
    RUN displayRecord IN hDatabase.
    SET-USER-FIELD('RowID',cRowID).
    {&OUT} 
      ' </TABLE></TD><TD VALIGN=top>~n'
      ' <INPUT TYPE="button" NAME="Save"   VALUE=" Save " '
      'onClick="document.form.Do.value=''save''~;document.form.submit()~;"><BR>~n'
      ' <INPUT TYPE="button" NAME="Delete" VALUE="Delete" '
      'onClick="if(confirm(''Are you sure you want to delete this record''))'
      '~{document.form.Do.value=''delete''~;document.form.submit()~;~}~;"><BR><BR>~n'
      ' </P></TD></TR></TABLE><TD></TABLE>~n'
      hidden-field-list("i1,w2,w3,w4,index,count,RowID,db,tb,current,first,last")
      .
    fFooter().
  END.
  IF cTable > '' AND cRowID = '' THEN DO: /**** record browse ****/
    ASSIGN
      cFormTitle   = 'Record Browse'
      cFormHelp    = "databrw" /* "dbbr" */
      cFormBack    = "document.form.tb.value='';document.form.submit()"
      cFormRefresh = "document.form.submit()"
      .
    fHeader().

    {&OUT} 
      '<SCRIPT LANGUAGE=JavaScript>~n'
      'function fEdit(rowid)~{~n'
      '  document.form.RowID.value = rowid~;~n'
      '  document.form.Do.value    = ''Edit''~;~n'
      '  document.form.submit()~;~n'
      '~}~n'
      '</SCRIPT>~n'.

    RUN dbBrowse IN hDatabase.

    set-user-field("RowID","").

    {&OUT} 
      ' </TD></TABLE>~n'
      '<INPUT TYPE="button" NAME="first" VALUE="&lt~;&lt~;" onClick="document.form.Do.value=''first''~;document.form.submit()~;">~n'
      '<INPUT TYPE="button" NAME="prev"  VALUE="&lt~;"      onClick="document.form.Do.value=''prev''~; document.form.submit()~;">~n'
      '<INPUT TYPE="button" NAME="next"  VALUE="&gt~;"      onClick="document.form.Do.value=''next''~; document.form.submit()~;">~n'
      '<INPUT TYPE="button" NAME="last"  VALUE="&gt~;&gt~;" onClick="document.form.Do.value=''last''~; document.form.submit()~;"> &nbsp~;~n'
      
      IF cCountString > '' THEN cCountstring ELSE (
       '<INPUT TYPE="button" NAME="count"   VALUE="Count"' +
       ' onClick="document.form.Do.value=''count'' ~; document.form.submit()~;"> &nbsp~;~n')

      '<INPUT TYPE="button" NAME="add"     VALUE="Add"'
      ' onClick="document.form.Do.value=''add'' ~; document.form.submit()~;"><br>~n'
      '<INPUT TYPE="hidden" NAME="db"      VALUE="' cDBid    '">~n'
      '<INPUT TYPE="hidden" NAME="tb"      VALUE="' cTable   '">~n'
      '<INPUT TYPE="hidden" NAME="RowID"   VALUE="'          '">~n'
      '<INPUT TYPE="hidden" NAME="count"   VALUE="' iCount   '">~n'
      '<INPUT TYPE="hidden" NAME="current" VALUE="' iCurrent '">~n'
      '<INPUT TYPE="hidden" NAME="first"   VALUE="' cFirst   '">~n'
      '<INPUT TYPE="hidden" NAME="last"    VALUE="' cLast    '">~n'
      .
    fFooter().
  END.

  IF cTable = '' AND cRowID = '' OR cAction = 'vstrecid' THEN 
  CASE cAction:
    WHEN "rep" OR WHEN "repall" THEN DO:
      ASSIGN
        cFormTitle  = 'Dictionary Report'
        cFormBack   = "history.back()"
        cFormHelp   = "databrw". /* "dbrep" */

      fHeader().

      RUN dbReport IN hDatabase.

      {&OUT} "</TABLE>".

      fFooter().
    END.
    WHEN "vstinfo" OR 
    WHEN "vstusers" OR 
    WHEN 'vstlocks' OR 
    WHEN 'vstrecid' THEN DO:
      ASSIGN
        cFormTitle  = 'Promon Utility'
        cFormHelp   = "databrw". /* dbvst */

      fHeader().

      {&OUT} '<P>Database: '  cDBid  ' . .~n'
        '<INPUT TYPE="button" NAME=binfo  VALUE="Info"        onClick="document.form.Do.value=''vstinfo''~;document.form.submit()">~n'
        '<INPUT TYPE="button" NAME=busers VALUE="Connections" onClick="document.form.Do.value=''vstusers''~;document.form.submit()">~n'
        '<INPUT TYPE="button" NAME=blocks VALUE="Locks"       onClick="document.form.Do.value=''vstlocks''~;document.form.submit()">~n'
        ' &nbsp~; &nbsp~; <b>RecID:</b><input type=input name=recid value='''   get-value('recid')  ''' size=10>~n'
        '<INPUT TYPE="button" NAME=brecid VALUE="Find"        onClick="document.form.Do.value=''vstrecid''~;document.form.submit()"></P>~n'
        '<INPUT TYPE="hidden" NAME=db       VALUE="'  cDBid   '">~n'
        '<INPUT TYPE="hidden" NAME=tb       VALUE="'  cTable  '">~n'.

      /* Comment last to always rerun in dev */
      IF VALID-HANDLE(hVST) AND cDBid <> cDictDb THEN
        DELETE PROCEDURE hVST.

      IF NOT VALID-HANDLE(hVST) THEN 
        RUN webtools/vst.p PERSISTENT SET hVST.

      RUN dbVST IN hVST.

      fFooter().
    END.
    OTHERWISE DO:
      ASSIGN
        cFormTitle = 'Table List'
        cFormHelp  = 'databrw'.

      fHeader().
      {&OUT} 
        '<INPUT TYPE="button" NAME="saveexit" VALUE="View dictionary for selected items" onClick="document.form.Do.value=~'rep~';document.form.submit();">'.

      RUN tableList IN hDatabase.

      {&OUT} 
        '<INPUT TYPE="hidden" NAME="type"     VALUE="'  cType   '">~n'
        '<INPUT TYPE="hidden" NAME="db"       VALUE="'  cDBid   '">~n'
        '<INPUT TYPE="button" NAME="saveexit" VALUE="View dictionary for selected items" onClick="document.form.Do.value=~'rep~';document.form.submit();">'.

      fFooter().
    END.
  END CASE.

  RETURN.
END. /*cDBid <> "" */

ASSIGN cFormBack = "".
fHeader().
{&OUT} 
  fBeginTable("Database|Srv|Type|Ver|Rstr|Location|Browse|Options").

DO ix = 1 TO NUM-DBS:
   cDBid = LDBNAME(ix).
   {&OUT} fRow(cDBid
       + "|" + SDBNAME(ix)
       + "|" + DBType(ix)
       + "|" + DBVersion(ix)
       + "|" + DBRestrictions(ix)
       + "|" + PDBNAME(ix)
       + '|<A HREF="databrw.p?db=' + cDBid + '&type=std">Tables</a>
           <A HREF="databrw.p?db=' + cDBid + '&type=sys">Sys</a>'
       + '|<A HREF="databrw.p?db=' + cDBid + '&do=repall&type=std">Dict</a>
           <A HREF="databrw.p?db=' + cDBid + '&do=vstinfo">VST</a>'   ).
END.
{&OUT} 
  "</TABLE>" SKIP
  '<INPUT TYPE="hidden" NAME="db" VALUE="' cDBid '">~n'
  '<INPUT TYPE="hidden" NAME="tb" VALUE="' cTable '">~n'.

IF NUM-DBS = 0 THEN 
  {&OUT} '<BR>There are no connected databases for this <FONT COLOR="red">Web</FONT><B>Speed</B> Agent.~n'.

fFooter().

/* databrw.p - end of file */
