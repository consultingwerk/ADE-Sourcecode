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
*          taj                                                          *
*********************************************************************/
/* a-write.p - write out .qc file */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/s-print.i }
{ prores/c-form.i }
{ prores/a-define.i }
{ prores/t-set.i &mod=a &set=6 }
{ prores/reswidg.i }
{ prores/resfunc.i }

DEFINE VARIABLE qbf-a AS LOGICAL     NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER   NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER     NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER     NO-UNDO.
DEFINE VARIABLE qbf-o AS CHARACTER   NO-UNDO.
DEFINE VARIABLE qbf-s AS DECIMAL     NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER   NO-UNDO.

DEFINE STREAM qbf-io.

/* It is *extremely* important that the .qc file contain the first few
   entries in a specific order.  This is because some are dependent on
   others.  The product is not guaranteed to work if this order is messed
   up in the .qc file.

   config=, version=, goodbye=, language=,
   product=, signon=, database*=, fastload=.
*/

/*message "[a-write.p]" view-as alert-box.*/

/* write out to _qbf5.d, then copy it to dbname.qc */
OUTPUT STREAM qbf-io TO VALUE(qbf-tempdir + "5.d") NO-ECHO.
PUT STREAM qbf-io UNFORMATTED
  '/*' SKIP
  '# PROGRESS RESULTS system administrator configuration file' SKIP
  'config= sysadmin' SKIP
  'version= ' qbf-vers SKIP
  'goodbye= "' (IF qbf-goodbye THEN 'quit' ELSE 'return') '"' SKIP
  'language= "' qbf-langset '"' SKIP.
PUT STREAM qbf-io CONTROL 'product= '. EXPORT STREAM qbf-io qbf-product.
PUT STREAM qbf-io CONTROL 'signon= '.  EXPORT STREAM qbf-io qbf-signon.
CREATE ALIAS "QBF$0" FOR DATABASE VALUE(LDBNAME(1)).
RUN prores/s-base.p (TRUE,OUTPUT qbf-c).
DO qbf-i = 1 TO NUM-ENTRIES(qbf-c):
  qbf-t = ENTRY(qbf-i,qbf-c).
  IF qbf-t MATCHES "*$*" THEN NEXT. /* don't check dbs with "$" in ldbname */
  RUN prores/s-lookup.p (SUBSTRING(qbf-t,1,INDEX(qbf-t,":") - 1),"","",
                         "DB:CHECKSUM",OUTPUT qbf-o).
  PUT STREAM qbf-io CONTROL 'database' STRING(qbf-i) '= '.
  EXPORT STREAM qbf-io
    SUBSTRING(qbf-t,1,INDEX(qbf-t,":") - 1)
    SUBSTRING(qbf-t,INDEX(qbf-t,":") + 1)
    DECIMAL(qbf-o).
END.

IF qbf-fastload <> "" THEN
  PUT STREAM qbf-io UNFORMATTED 'fastload= "' qbf-fastload '"' SKIP.

/* Loading module settings */
PUT STREAM qbf-io UNFORMATTED
  '#' SKIP
  'message= "' qbf-lang[1] '"' SKIP.
DO qbf-i = 1 TO 6:
  qbf-c = "module-" + ENTRY(qbf-i,"query,report,label,data,user,admin").
  PUT STREAM qbf-io CONTROL qbf-c '= '.
  EXPORT STREAM qbf-io
    (IF qbf-m-perm[qbf-i] = "" THEN "*" ELSE qbf-m-perm[qbf-i]).
END.

/* Loading color settings */
PUT STREAM qbf-io UNFORMATTED
  '#' SKIP
  'message= "' qbf-lang[2] '"' SKIP.
DO qbf-i = 1 TO { prores/s-limtrm.i }:
  IF   qbf-t-name[qbf-i] = ""
    OR qbf-t-hues[qbf-i] = "NORMAL,MESSAGES,NORMAL,MESSAGES,NORMAL,MESSAGES"
    THEN NEXT.
  PUT STREAM qbf-io CONTROL 'color-' qbf-t-name[qbf-i] '= '.
  EXPORT STREAM qbf-io
    ENTRY(1,qbf-t-hues[qbf-i]) ENTRY(2,qbf-t-hues[qbf-i])
    ENTRY(3,qbf-t-hues[qbf-i]) ENTRY(4,qbf-t-hues[qbf-i])
    ENTRY(5,qbf-t-hues[qbf-i]) ENTRY(6,qbf-t-hues[qbf-i]).
END.

/* Loading printer setup */
PUT STREAM qbf-io UNFORMATTED
  '#' SKIP
  'message= "' qbf-lang[3] '"' SKIP.
DO qbf-i = 1 TO qbf-printer#:
  PUT STREAM qbf-io CONTROL 'printer' qbf-i '= '.
  EXPORT STREAM qbf-io
    qbf-printer[qbf-i]
    qbf-pr-dev[qbf-i]
    qbf-pr-perm[qbf-i]
    qbf-pr-type[qbf-i]
    qbf-pr-width[qbf-i]
    qbf-pr-init[qbf-i]
    qbf-pr-norm[qbf-i]
    qbf-pr-comp[qbf-i]
    qbf-pr-bon[qbf-i]
    qbf-pr-boff[qbf-i].
END.

/* Loading auto-select field list for mailing labels */
PUT STREAM qbf-io UNFORMATTED
  '#' SKIP
  'message= "' qbf-lang[6] '"' SKIP.
DO qbf-i = 1 TO 10:
  PUT STREAM qbf-io CONTROL 'label-'
    ENTRY(qbf-i,"name,addr1,addr2,addr3,city,state,zip,zip+4,csz,country")
    '= '.
  EXPORT STREAM qbf-io qbf-l-auto[qbf-i].
END.

/* Loading permissions list for query functions */
PUT STREAM qbf-io UNFORMATTED
  '#' SKIP
  'message= "' qbf-lang[7] '"' SKIP.
DO qbf-i = 1 TO 20:
  qbf-c = "query-" + ENTRY(qbf-i,
          "next,prev,first,last,add,update,copy,delete,view,browse,"
        + "join,query,where,total,order,module,info,user,help,exit,").
  PUT STREAM qbf-io CONTROL qbf-c '= '.
  EXPORT STREAM qbf-io
    (IF qbf-i > 18 OR qbf-q-perm[qbf-i] = "" THEN "*" ELSE qbf-q-perm[qbf-i]).
END.

/* Loading user option information */
PUT STREAM qbf-io UNFORMATTED
  '#' SKIP
  'message= "' qbf-lang[8] '"' SKIP.
PUT STREAM qbf-io CONTROL 'user-program= '.
EXPORT STREAM qbf-io qbf-u-prog.
PUT STREAM qbf-io CONTROL 'user-export= '.
EXPORT STREAM qbf-io qbf-u-expo qbf-u-enam.
PUT STREAM qbf-io CONTROL 'user-query= '.
EXPORT STREAM qbf-io qbf-u-brow.

/* Loading system report defaults */
PUT STREAM qbf-io UNFORMATTED
  '#' SKIP
  'message= "' qbf-lang[9] '"'     SKIP
  'left-margin= '    qbf-r-attr[1] SKIP
  'page-size= '      qbf-r-attr[2] SKIP
  'column-spacing= ' qbf-r-attr[3] SKIP
  'line-spacing= '   qbf-r-attr[4] SKIP
  'top-margin= '     qbf-r-attr[5] SKIP
  'before-body= '    qbf-r-attr[6] SKIP
  'after-body= '     qbf-r-attr[7] SKIP.
DO qbf-i = 1 TO 8:
  PUT STREAM qbf-io CONTROL
    ENTRY(qbf-i,'first-only,last-only,top-left,top-center,top-right,'
    + 'bottom-left,bottom-center,bottom-right') '= '.
  EXPORT STREAM qbf-io qbf-r-head[qbf-i * 3 - 2 FOR 3].
END.

/* Loading list of viewable files */
PUT STREAM qbf-io UNFORMATTED
  '#' SKIP
  'message= "' qbf-lang[4] '"' SKIP.
DO qbf-i = 1 TO qbf-form#:
  PUT STREAM qbf-io CONTROL 'form' qbf-i '= '.
  {&FIND_QBF_FORM} qbf-i.

  ASSIGN
    qbf-t = ENTRY(1,qbf-form.cValue).
    
  IF qbf-form.cDesc = "" THEN
    RUN prores/s-lookup.p (qbf-t,"","","FILE:DESC",OUTPUT qbf-form.cDesc).
  RUN prores/s-lookup.p (qbf-t,"","","FILE:STAMP",OUTPUT qbf-o).
  qbf-j = INTEGER(qbf-o).
  RUN prores/s-lookup.p (qbf-t,"","","FILE:CRC",OUTPUT qbf-o).
  qbf-t = SUBSTRING(qbf-t,INDEX(qbf-t,".") + 1).
  IF qbf-form.cDesc = ? OR qbf-form.cDesc = "" THEN 
    qbf-form.cDesc = qbf-t.

  /* At this point qbf-t contains the database file name sans db qualifier */
  EXPORT STREAM qbf-io
    (IF ENTRY(2,qbf-form.cValue) = "" THEN SUBSTRING(qbf-t,1,8)
      ELSE ENTRY(2,qbf-form.cValue))
    ENTRY(1,qbf-form.cValue)
    (IF qbf-form.xValue = "" THEN "*" ELSE qbf-form.xValue)
    qbf-j INTEGER(qbf-o) /* _Last-change _Crc */
    qbf-form.cDesc.
END.

/* Loading list of relations */
PUT STREAM qbf-io UNFORMATTED
  '#' SKIP
  'message= "' qbf-lang[5] '"' SKIP.
DO qbf-i = 1 TO qbf-join#:
  {&FIND_QBF_JOIN} qbf-i.
  PUT STREAM qbf-io CONTROL 'join' qbf-i '= '.
  ASSIGN
    qbf-join.cWhere = (IF qbf-join.cWhere = "" 
                       THEN "OF ":U + ENTRY(1,qbf-join.cValue)
                       ELSE "WHERE ":U + qbf-join.cWhere).
  EXPORT STREAM qbf-io 
    ENTRY(1,qbf-join.cValue) ENTRY(2,qbf-join.cValue) qbf-join.cWhere.
END.

PUT STREAM qbf-io UNFORMATTED '*/' SKIP.

OUTPUT STREAM qbf-io CLOSE.

/*
1) new config file is _qbf5.d
2) if old dbname.qc exists, copy it to _qbf.d as backup
3) copy _qbf5.d over dbname.qc
*/

ASSIGN
  qbf-c = SEARCH(qbf-qcfile + ".qc")
  qbf-a = (qbf-c = ?)
  qbf-c = (IF qbf-a THEN qbf-qcfile + ".qc" ELSE qbf-c)
  qbf-t = qbf-tempdir + ".d".

IF qbf-a THEN .
ELSE
  OS-COPY VALUE(qbf-c) VALUE(qbf-t).

qbf-t = qbf-tempdir + "5.d".
OS-COPY VALUE(qbf-t) VALUE(qbf-c).

{ prores/t-reset.i }
RETURN.
