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
 /* a-fast.p - write res*.r fastload files */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/s-print.i }
{ prores/c-form.i }
{ prores/a-define.i }
{ prores/reswidg.i }
{ prores/resfunc.i }

DEFINE OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-c AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-e AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT 4 NO-UNDO.
DEFINE VARIABLE qbf-n AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER          NO-UNDO.

/* max number of qbf-form and qbf-join records to put in a .p */
/* 0200 for forms */
/* 0400 for joins */

DEFINE STREAM qbf-io.

ASSIGN
  qbf-t        = SUBSTRING(qbf-fastload,1,LENGTH(qbf-fastload) - 1)
  qbf-c        = SEARCH(qbf-t + "r")
  qbf-fastload = (IF qbf-c = ? THEN qbf-fastload ELSE qbf-t + "p")
  qbf-n        = (IF qbf-c = ? THEN qbf-fastload
                 ELSE SUBSTRING(qbf-c,1,LENGTH(qbf-c) - 1) + "p")
  SUBSTRING(qbf-n,LENGTH(qbf-n) - 2,1) = STRING(qbf-e).

/*message "[a-fast.p]" view-as alert-box.*/

OUTPUT STREAM qbf-io TO VALUE(qbf-n) NO-ECHO NO-MAP.

PUT STREAM qbf-io UNFORMATTED
  'DEFINE INPUT PARAMETER qbf-a        AS LOGICAL             NO-UNDO.' SKIP(1)
  'DEFINE SHARED VARIABLE qbf-l-auto   AS CHARACTER EXTENT 10 NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-q-opts   AS LOGICAL   EXTENT 21 NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-r-defs   AS CHARACTER EXTENT 32 NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-secure   AS CHARACTER           NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-u-brow   AS CHARACTER           NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-u-enam   AS CHARACTER           NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-u-expo   AS CHARACTER           NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-u-prog   AS CHARACTER           NO-UNDO.' SKIP(1)
  'DEFINE SHARED VARIABLE qbf-dhi      AS CHARACTER           NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-dlo      AS CHARACTER           NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-mhi      AS CHARACTER           NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-mlo      AS CHARACTER           NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-phi      AS CHARACTER           NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-plo      AS CHARACTER           NO-UNDO.' SKIP(1)
  'DEFINE SHARED VARIABLE qbf-pr-boff  AS CHARACTER EXTENT '
    { prores/s-limprn.i } ' NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-pr-bon   AS CHARACTER EXTENT '
    { prores/s-limprn.i } ' NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-pr-comp  AS CHARACTER EXTENT '
    { prores/s-limprn.i } ' NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-pr-dev   AS CHARACTER EXTENT '
    { prores/s-limprn.i } ' NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-pr-init  AS CHARACTER EXTENT '
    { prores/s-limprn.i } ' NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-pr-norm  AS CHARACTER EXTENT '
    { prores/s-limprn.i } ' NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-pr-perm  AS CHARACTER EXTENT '
    { prores/s-limprn.i } ' NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-pr-type  AS CHARACTER EXTENT '
    { prores/s-limprn.i } ' NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-pr-width AS INTEGER   EXTENT '
    { prores/s-limprn.i } ' NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-printer  AS CHARACTER EXTENT '
    { prores/s-limprn.i } ' NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-printer# AS INTEGER             NO-UNDO.' SKIP(1).

PUT STREAM qbf-io UNFORMATTED
  'DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.' SKIP
  'DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.' SKIP
  '/* Loading module settings */' SKIP.
qbf-l = qbf-l + 3.
DO qbf-i = 1 TO 6:
  qbf-c = ENTRY(qbf-i,"query,report,label,data,user,admin").
  ASSIGN
    qbf-t = (IF qbf-m-perm[qbf-i] = "" THEN "!*" ELSE qbf-m-perm[qbf-i])
    qbf-l = qbf-l + 1.
  PUT STREAM qbf-io UNFORMATTED
    (IF qbf-i = 1 THEN 'qbf-secure = ' ELSE '           + ')
    '(IF CAN-DO("' qbf-t '",USERID("RESULTSDB")) OR qbf-a THEN "'
      SUBSTRING(qbf-c,1,1) '" ELSE "")'
    (IF qbf-i = 6 THEN '.' ELSE '') SKIP.
END.

PUT STREAM qbf-io UNFORMATTED '/* Loading color settings */' SKIP.
qbf-l = qbf-l + 1.
DO qbf-i = 1 TO { prores/s-limtrm.i }:
  IF   qbf-t-name[qbf-i] = ""
    OR qbf-t-hues[qbf-i] = "NORMAL,MESSAGES,NORMAL,MESSAGES,NORMAL,MESSAGES"
    THEN NEXT.
  PUT STREAM qbf-io UNFORMATTED
  'IF TERMINAL = "' qbf-t-name[qbf-i] '" THEN ASSIGN' SKIP
  '  qbf-mlo = "' ENTRY(1,qbf-t-hues[qbf-i]) '"' SKIP
  '  qbf-mhi = "' ENTRY(2,qbf-t-hues[qbf-i]) '"' SKIP
  '  qbf-dlo = "' ENTRY(3,qbf-t-hues[qbf-i]) '"' SKIP
  '  qbf-dhi = "' ENTRY(4,qbf-t-hues[qbf-i]) '"' SKIP
  '  qbf-plo = "' ENTRY(5,qbf-t-hues[qbf-i]) '"' SKIP
  '  qbf-phi = "' ENTRY(6,qbf-t-hues[qbf-i]) '".' SKIP.
  qbf-l = qbf-l + 7.
END.

PUT STREAM qbf-io UNFORMATTED '/* Loading printer setup */' SKIP.
qbf-l = qbf-l + 1.
DO qbf-i = 1 TO qbf-printer#:
  PUT STREAM qbf-io UNFORMATTED
    (IF qbf-pr-perm[qbf-i] = "*" THEN '' ELSE
      'IF CAN-DO("' + qbf-pr-perm[qbf-i]
      + '",USERID("RESULTSDB")) OR qbf-a THEN ')
    'ASSIGN' SKIP
    '  qbf-printer# = qbf-printer# + 1' SKIP
    '  qbf-printer[qbf-printer#]  = "' qbf-printer[qbf-i] '"' SKIP
    '  qbf-pr-dev[qbf-printer#]   = "' qbf-pr-dev[qbf-i]  '"' SKIP
    '  qbf-pr-perm[qbf-printer#]  = "' qbf-pr-perm[qbf-i] '"' SKIP
    '  qbf-pr-type[qbf-printer#]  = "' qbf-pr-type[qbf-i] '"' SKIP
    '  qbf-pr-width[qbf-printer#] = ' qbf-pr-width[qbf-i]     SKIP
    '  qbf-pr-init[qbf-printer#]  = "' qbf-pr-init[qbf-i] '"' SKIP
    '  qbf-pr-norm[qbf-printer#]  = "' qbf-pr-norm[qbf-i] '"' SKIP
    '  qbf-pr-comp[qbf-printer#]  = "' qbf-pr-comp[qbf-i] '"' SKIP
    '  qbf-pr-bon[qbf-printer#]   = "' qbf-pr-bon[qbf-i]  '"' SKIP
    '  qbf-pr-boff[qbf-printer#]  = "' qbf-pr-boff[qbf-i] '".' SKIP.
  qbf-l = qbf-l + 11.
END.

PUT STREAM qbf-io UNFORMATTED
  '/* Loading auto-select field list for mailing labels */' SKIP
  'ASSIGN' SKIP.
qbf-l = qbf-l + 2.
DO qbf-i = 1 TO 10:
  IF qbf-l-auto[qbf-i] = "" THEN NEXT.
  PUT STREAM qbf-io CONTROL '  qbf-l-auto[' STRING(qbf-i,"ZZ") '] ='.
  EXPORT STREAM qbf-io qbf-l-auto[qbf-i].
  qbf-l = qbf-l + 1.
END.
PUT STREAM qbf-io UNFORMATTED '.' SKIP.
qbf-l = qbf-l + 1.

PUT STREAM qbf-io UNFORMATTED
  '/* Loading permissions list for query functions */' SKIP
  'ASSIGN'.
qbf-l = qbf-l + 2.
DO qbf-i = 1 TO 18:
  /* true is default */
  IF qbf-q-perm[qbf-i] = "*" OR qbf-q-perm[qbf-i] = "" THEN NEXT.
  PUT STREAM qbf-io UNFORMATTED SKIP
    '  qbf-q-opts[' qbf-i '] = CAN-DO("' qbf-q-perm[qbf-i]
      '",USERID("RESULTSDB"))'.
  qbf-l = qbf-l + 1.
END.

PUT STREAM qbf-io UNFORMATTED
  '.' SKIP
  '/* Loading user option information */' SKIP
  'ASSIGN' SKIP.
PUT STREAM qbf-io CONTROL '  qbf-u-prog = '.
EXPORT STREAM qbf-io qbf-u-prog.
PUT STREAM qbf-io CONTROL '  qbf-u-expo = '.
EXPORT STREAM qbf-io qbf-u-expo.
PUT STREAM qbf-io CONTROL '  qbf-u-enam = '.
EXPORT STREAM qbf-io qbf-u-enam.
PUT STREAM qbf-io CONTROL '  qbf-u-brow = '.
EXPORT STREAM qbf-io qbf-u-brow.
qbf-l = qbf-l + 5.
PUT STREAM qbf-io UNFORMATTED
  '  qbf-r-defs = ""'.
qbf-l = qbf-l + 2.
DO qbf-i = 1 TO 32:
  qbf-c = (IF qbf-i < 25 THEN qbf-r-head[qbf-i]
                         ELSE STRING(qbf-r-attr[qbf-i - 24])).
  IF qbf-c = "" THEN NEXT.
  IF qbf-i < 25 THEN
    RUN prores/s-quote.p (qbf-c,?,OUTPUT qbf-c).
  PUT STREAM qbf-io UNFORMATTED SKIP
    '  qbf-r-defs[' STRING(qbf-i,"ZZ") '] = "' qbf-c '"'.
  qbf-l = qbf-l + 1.
END.
PUT STREAM qbf-io UNFORMATTED '.' SKIP(1) 'RETURN.' SKIP.
qbf-l = qbf-l + 2.
OUTPUT STREAM qbf-io CLOSE.

/*--------------------------------------------------------------------------*/

DO qbf-k = 1 TO qbf-join# BY 0400:
  ASSIGN
    qbf-e = qbf-e + 1
    SUBSTRING(qbf-n,LENGTH(qbf-n) - 2,1) = STRING(qbf-e).
  OUTPUT STREAM qbf-io TO VALUE(qbf-n) NO-ECHO NO-MAP.
  PUT STREAM qbf-io UNFORMATTED
    'DEFINE INPUT PARAMETER qbf-a     AS LOGICAL NO-UNDO.' SKIP(1)
    'DEFINE SHARED TEMP-TABLE qbf-join' SKIP
    '  FIELD iIndex AS INTEGER' SKIP
    '  FIELD cValue AS CHARACTER' SKIP
    '  FIELD cWhere AS CHARACTER' SKIP
    '  FIELD cScrap AS CHARACTER' SKIP
    '  INDEX iIndex IS UNIQUE PRIMARY iIndex' SKIP
    '  INDEX cValue cValue' SKIP
    '  INDEX cScrap cScrap.' SKIP(1)
    'DEFINE SHARED VARIABLE qbf-join# AS INTEGER NO-UNDO.' SKIP
    '/* Loading list of relations */' SKIP.
  qbf-l = 0.
  DO qbf-i = qbf-k TO MINIMUM(qbf-join#,qbf-k + 0400 - 1):
    {&FIND_QBF_JOIN} qbf-i.
    PUT STREAM qbf-io UNFORMATTED
      'CREATE qbf-join.' SKIP
      'ASSIGN' SKIP
      '  qbf-join.iIndex = ' qbf-i SKIP
      '  qbf-join.cValue = '.
    EXPORT STREAM qbf-io qbf-join.cValue.
    PUT STREAM qbf-io UNFORMATTED 
      '  qbf-join.cWhere = '.
    EXPORT STREAM qbf-io qbf-join.cWhere.
    PUT STREAM qbf-io UNFORMATTED '.' SKIP.
  END.
  IF qbf-k + 0400 > qbf-join# THEN
    PUT STREAM qbf-io UNFORMATTED
      'qbf-join# = ' qbf-join# '.' SKIP.
  PUT STREAM qbf-io UNFORMATTED
    'RETURN.' SKIP.
  OUTPUT STREAM qbf-io CLOSE.
END.

/*--------------------------------------------------------------------------*/

/* return list of files to be compiled. */
DO qbf-k = 1 TO qbf-form# BY 0200:
  ASSIGN
    qbf-e                                = qbf-e + 1
    SUBSTRING(qbf-n,LENGTH(qbf-n) - 2,1) = STRING(qbf-e).

  OUTPUT STREAM qbf-io TO VALUE(qbf-n) NO-ECHO NO-MAP.
  PUT STREAM qbf-io UNFORMATTED
    'DEFINE INPUT PARAMETER qbf-a     AS LOGICAL NO-UNDO.' SKIP(1)
    'DEFINE SHARED TEMP-TABLE qbf-form' SKIP
    '  FIELD iIndex AS INTEGER' SKIP
    '  FIELD cValue AS CHARACTER' SKIP
    '  FIELD cDesc  AS CHARACTER' SKIP
    '  FIELD xValue AS CHARACTER' SKIP
    '  INDEX iIndex IS UNIQUE PRIMARY iIndex' SKIP
    '  INDEX cValue cValue.' SKIP(1)
    'DEFINE SHARED VARIABLE qbf-form# AS INTEGER NO-UNDO.' SKIP
    'DEFINE VARIABLE lCreate AS LOGICAL NO-UNDO INITIAL TRUE.' SKIP
    '/* Loading list of viewable files */' SKIP.
  IF qbf-k = 1 THEN 
    PUT STREAM qbf-io UNFORMATTED 'qbf-form# = 1.' SKIP.
  qbf-l = 0.
  DO qbf-i = qbf-k TO MINIMUM(qbf-form#,qbf-k + 0200 - 1):
    {&FIND_QBF_FORM} qbf-i.

    /* Only create form record if qbf-form.xValue = "*" or "" or contains 
       USERID or qbf-a */
    PUT STREAM qbf-io UNFORMATTED
      'IF lCreate THEN CREATE qbf-form.' SKIP
      'ASSIGN' SKIP
      '  qbf-form.iIndex = ' qbf-i ' WHEN lCreate' SKIP 
      '  qbf-form.cValue = '.
    EXPORT STREAM qbf-io qbf-form.cValue.
    PUT STREAM qbf-io UNFORMATTED
      '  qbf-form.cDesc  = '.
    EXPORT STREAM qbf-io qbf-form.cDesc.
    PUT STREAM qbf-io UNFORMATTED
      '  lCreate         = '
      (IF qbf-form.xValue = "*" OR qbf-form.xValue = "" THEN 'TRUE' ELSE
         '(IF CAN-DO("' + qbf-form.xValue +
         '",USERID("RESULTSDB")) OR qbf-a THEN TRUE ELSE FALSE)') SKIP
      '  qbf-form#       = qbf-form# + (IF lCreate THEN 1 ELSE 0).' SKIP.
  END.
  IF qbf-k + 0200 > qbf-form# THEN
    PUT STREAM qbf-io UNFORMATTED
      'qbf-form# = qbf-form# - 1.' SKIP.
  PUT STREAM qbf-io UNFORMATTED
    'RETURN.' SKIP.
  OUTPUT STREAM qbf-io CLOSE.
END.

/*--------------------------------------------------------------------------*/

/* admin stuff into special '99' file */

SUBSTRING(qbf-n,LENGTH(qbf-n) - 3,2) = "99".
OUTPUT STREAM qbf-io TO VALUE(qbf-n) NO-ECHO NO-MAP.
PUT STREAM qbf-io UNFORMATTED
  'DEFINE INPUT PARAMETER qbf-a      AS LOGICAL             NO-UNDO.' SKIP(1)
  'DEFINE SHARED VARIABLE qbf-m-perm AS CHARACTER EXTENT  6 NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-q-perm AS CHARACTER EXTENT 18 NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-r-attr AS INTEGER   EXTENT 10 NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-r-head AS CHARACTER EXTENT 24 NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-t-name AS CHARACTER EXTENT '
    { prores/s-limtrm.i } ' NO-UNDO.' SKIP
  'DEFINE SHARED VARIABLE qbf-t-hues AS CHARACTER EXTENT '
    { prores/s-limtrm.i } ' NO-UNDO.' SKIP(1)
  'DEFINE SHARED TEMP-TABLE qbf-form' SKIP
  '  FIELD iIndex AS INTEGER' SKIP
  '  FIELD cValue AS CHARACTER' SKIP
  '  FIELD cDesc  AS CHARACTER' SKIP
  '  FIELD xValue AS CHARACTER' SKIP
  '  INDEX iIndex IS UNIQUE PRIMARY iIndex' SKIP
  '  INDEX cValue cValue.' SKIP(1).
  
qbf-k = 0.
DO qbf-i = 1 TO qbf-form#:
  {&FIND_QBF_FORM} qbf-i NO-ERROR.
  IF NOT AVAILABLE qbf-form OR (AVAILABLE qbf-form AND
    (qbf-form.xValue = "*" OR qbf-form.xValue = "")) THEN NEXT.
  qbf-k = qbf-k + 1.
  PUT STREAM qbf-io UNFORMATTED SKIP
    'FIND qbf-form WHERE qbf-form.iIndex = ' qbf-i ' NO-ERROR.' SKIP
    'IF AVAILABLE qbf-form THEN' SKIP
    '  ASSIGN qbf-form.xValue = "' qbf-form.xValue '".' SKIP.
END.

PUT STREAM qbf-io UNFORMATTED 'ASSIGN' SKIP.
DO qbf-i = 1 TO 24:
  RUN prores/s-quote.p (qbf-r-head[qbf-i],?,OUTPUT qbf-c).
  PUT STREAM qbf-io UNFORMATTED SKIP
    '  qbf-r-head[' STRING(qbf-i,"ZZ") '] = "' qbf-c '"'.
END.

PUT STREAM qbf-io UNFORMATTED '.' SKIP 'ASSIGN' SKIP.
DO qbf-i = 1 TO 7:
  PUT STREAM qbf-io UNFORMATTED
    '  qbf-r-attr[' qbf-i '] = ' qbf-r-attr[qbf-i] SKIP.
END.

PUT STREAM qbf-io UNFORMATTED '.' SKIP 'ASSIGN' SKIP.
DO qbf-i = 1 TO 6:
  PUT STREAM qbf-io CONTROL '  qbf-m-perm[' qbf-i '] = '.
  EXPORT STREAM qbf-io qbf-m-perm[qbf-i].
END.

PUT STREAM qbf-io UNFORMATTED '.' SKIP 'ASSIGN' SKIP.
DO qbf-i = 1 TO 18:
  PUT STREAM qbf-io CONTROL '  qbf-q-perm[' qbf-i '] = '.
  EXPORT STREAM qbf-io qbf-q-perm[qbf-i].
END.

PUT STREAM qbf-io UNFORMATTED '.' SKIP 'ASSIGN' SKIP.
DO qbf-i = 1 TO { prores/s-limtrm.i }:
  IF qbf-t-name[qbf-i] = "" THEN NEXT.
  PUT STREAM qbf-io CONTROL '  qbf-t-name[' qbf-i '] ='.
  EXPORT STREAM qbf-io qbf-t-name[qbf-i].
  PUT STREAM qbf-io CONTROL '  qbf-t-hues[' qbf-i '] ='.
  EXPORT STREAM qbf-io qbf-t-hues[qbf-i].
  IF qbf-i MODULO 10 = 0 THEN
    PUT STREAM qbf-io UNFORMATTED '.' SKIP 'ASSIGN' SKIP.
END.
PUT STREAM qbf-io UNFORMATTED '.' SKIP 'RETURN.' SKIP.
OUTPUT STREAM qbf-io CLOSE.

/*--------------------------------------------------------------------------*/

/* After compiling, .p's are then blown away.   The calling program does both 
   the compiles and deletes. */
qbf-o = "".
DO qbf-i = 0 TO qbf-e + 1:
  ASSIGN
    qbf-i = (IF qbf-i = qbf-e + 1 THEN 99 ELSE qbf-i)
    SUBSTRING(qbf-n,LENGTH(qbf-n) - 3,2) = STRING(qbf-i,"99")
    qbf-o = qbf-o + (IF qbf-o = "" THEN "" ELSE ",") + SEARCH(qbf-n).
END.

/* This takes care of the case when we delete enough forms or joins to have 
   _fewer_ res*.[pr] files than we started with. */
qbf-c = "".
DO qbf-i = qbf-e + 1 TO 9:
  SUBSTRING(qbf-n,LENGTH(qbf-n) - 3,4) = STRING(qbf-i,"99") + ".p".
  IF SEARCH(qbf-n) <> ? THEN
    qbf-c = qbf-c + (IF qbf-c = "" THEN "" ELSE ",") + SEARCH(qbf-n).
END.
IF qbf-c <> "" THEN 
  RUN prores/a-zap.p (qbf-c).

RETURN.
