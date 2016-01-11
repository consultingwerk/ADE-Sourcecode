/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* c-cache.p - load field cache for c-field.p and s-field.p */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/c-cache.i }
{ prores/reswidg.i }
{ prores/resfunc.i }

/*i/o:*/
DEFINE INPUT  PARAMETER qbf-f AS CHARACTER NO-UNDO. /*p_filenm*/
DEFINE INPUT  PARAMETER qbf-d AS CHARACTER NO-UNDO. /*dtype can-do*/
DEFINE INPUT  PARAMETER qbf-o AS CHARACTER NO-UNDO. /*inlist*/
DEFINE INPUT  PARAMETER qbf-v AS CHARACTER NO-UNDO. /*in vector*/
DEFINE OUTPUT PARAMETER qbf-u AS CHARACTER NO-UNDO. /*...*/
/*
qbf-f: list      - A comma-separated list of dbname.filenames means
                   load all fields of those named files into cache.
       "current" - The word "current" will load currently defined
                   fields into cache.
       "field"   - Currently defined fields, but no calc fields.
       "all"     - The word "all" will load current calc fields + all
                   fields for current files into cache.
a leading "*" on qbf-f means exclude arrays.

analysis of callers:
  c-field.p: "all"     "field" "*field" "*db.file"
  s-field.p: "current" "field" "*field" "db.file"
*/

DEFINE BUFFER qbf-c1 FOR qbf$1._Field.
DEFINE BUFFER qbf-c2 FOR qbf$2._Field.
DEFINE BUFFER qbf-c3 FOR qbf$3._Field.
DEFINE BUFFER qbf-c4 FOR qbf$4._Field.
DEFINE BUFFER qbf-c5 FOR qbf$5._Field.

/*local:*/
DEFINE VARIABLE lReturn AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-a   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-j   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-k   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-n   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-p   AS RECID      NO-UNDO EXTENT 5 INITIAL ?.
DEFINE VARIABLE qbf-s   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-t   AS CHARACTER  NO-UNDO.

/*message "[c-cache.p]" view-as alert-box.*/

ASSIGN
  qbf-d           = (IF qbf-d = "" THEN "!raw,!rowid,*" ELSE qbf-d)
  qbf-a           = NOT (qbf-f BEGINS "*")
  qbf-f           = SUBSTRING(qbf-f,IF qbf-a THEN 1 ELSE 2)
  qbf-s           = TRUE
  qbf-t           = (IF NOT CAN-DO("all,current,field",qbf-f) THEN
                      qbf-f
                    ELSE      qbf-db[1] + "." + qbf-file[1]
                          + (IF qbf-file[2] = "" THEN "" ELSE
                        "," + qbf-db[2] + "." + qbf-file[2])
                      + (IF qbf-file[3] = "" THEN "" ELSE
                        "," + qbf-db[3] + "." + qbf-file[3])
                      + (IF qbf-file[4] = "" THEN "" ELSE
                        "," + qbf-db[4] + "." + qbf-file[4])
                      + (IF qbf-file[5] = "" THEN "" ELSE
                        "," + qbf-db[5] + "." + qbf-file[5]))
  qbf-ctop        = 1
  lReturn         = getRecord("qbf-cfld":U, qbf-ctop)
  qbf-cfld.cValue = "<<>>".

/* sort array before defining cursors */
IF NUM-ENTRIES(qbf-t) > 1 THEN
  RUN prores/s-vector.p (FALSE,INPUT-OUTPUT qbf-t).

DO qbf-j = 1 TO NUM-ENTRIES(qbf-t):
  qbf-n = SUBSTRING(ENTRY(qbf-j,qbf-t),1,INDEX(ENTRY(qbf-j,qbf-t),".") - 1).
  IF SDBNAME(qbf-n) = LDBNAME("qbf$" + STRING(qbf-j)) THEN NEXT.
  CREATE ALIAS VALUE("qbf$" + STRING(qbf-j)) FOR DATABASE VALUE(SDBNAME(qbf-n)).
  qbf-s = FALSE.
END.
IF NOT qbf-s THEN DO:
  RUN prores/c-cache.p (qbf-f,qbf-d,qbf-o,qbf-v,OUTPUT qbf-u).
  RETURN.
END.

IF CAN-DO("current,all",qbf-f) THEN DO:
  DO qbf-j = 1 TO qbf-rc#:
    IF qbf-f = "all":U
      AND (qbf-rcc[qbf-j] = "" OR qbf-rcc[qbf-j] BEGINS "e") THEN NEXT.
    ASSIGN
      qbf-ctop = qbf-ctop + 1
      qbf-k    = INDEX("rpcsdnl",SUBSTRING(qbf-rcc[qbf-j],1,1))
      qbf-t    = ENTRY(1,qbf-rcn[qbf-j])
      lReturn  = getRecord("qbf-cfld":U, qbf-ctop).
      
    IF qbf-k > 0 THEN 
      qbf-t = ENTRY(qbf-k + 1,qbf-etype) + "." + qbf-t.
    qbf-k = LOOKUP(qbf-t,qbf-o).
    IF INDEX(qbf-t,".") > 0 THEN 
      SUBSTRING(qbf-t,R-INDEX(qbf-t,"."),1) = ",".
      
    qbf-cfld.cValue = qbf-t + ",,|" + qbf-rcl[qbf-j].
    IF qbf-k > 0 THEN
      OVERLAY(qbf-u,qbf-k * 5 - 4,4) = STRING(qbf-ctop - 1,"9999").
  END.
  IF qbf-f = "current" THEN 
    qbf-f = "".
END.
IF CAN-DO("field,all":U,qbf-f) THEN qbf-f =   qbf-db[1] + "." + qbf-file[1]
  + (IF qbf-file[2] = "" THEN "" ELSE "," + qbf-db[2] + "." + qbf-file[2])
  + (IF qbf-file[3] = "" THEN "" ELSE "," + qbf-db[3] + "." + qbf-file[3])
  + (IF qbf-file[4] = "" THEN "" ELSE "," + qbf-db[4] + "." + qbf-file[4])
  + (IF qbf-file[5] = "" THEN "" ELSE "," + qbf-db[5] + "." + qbf-file[5]).

IF qbf-f <> "" THEN DO:
  RUN prores/s-vector.p (FALSE,INPUT-OUTPUT qbf-f).

  DO qbf-j = 1 TO NUM-ENTRIES(qbf-f):
    RUN prores/s-lookup.p (ENTRY(qbf-j,qbf-f),"","","FILE:RECID",OUTPUT qbf-t).
    qbf-p[qbf-j] = INTEGER(qbf-t).
  END.

  /* position on first field in each buffer */
  { prores/c-cache1.i &cursor=1 }
  { prores/c-cache1.i &cursor=2 }
  { prores/c-cache1.i &cursor=3 }
  { prores/c-cache1.i &cursor=4 }
  { prores/c-cache1.i &cursor=5 }

  /*perform efficient 5-way merge of field names*/
  DO WHILE AVAILABLE qbf-c1
    OR     AVAILABLE qbf-c2
    OR     AVAILABLE qbf-c3
    OR     AVAILABLE qbf-c4
    OR     AVAILABLE qbf-c5:
    IF AVAILABLE qbf-c1
      AND (NOT AVAILABLE qbf-c2 OR qbf-c1._Field-name <= qbf-c2._Field-name)
      AND (NOT AVAILABLE qbf-c3 OR qbf-c1._Field-name <= qbf-c3._Field-name)
      AND (NOT AVAILABLE qbf-c4 OR qbf-c1._Field-name <= qbf-c4._Field-name)
      AND (NOT AVAILABLE qbf-c5 OR qbf-c1._Field-name <= qbf-c5._Field-name)
      THEN DO:
      { prores/c-cache2.i &cursor=1 }
      { prores/c-cache1.i &cursor=1 }
    END.
    ELSE
    IF AVAILABLE qbf-c2
      AND (NOT AVAILABLE qbf-c3 OR qbf-c2._Field-name <= qbf-c3._Field-name)
      AND (NOT AVAILABLE qbf-c4 OR qbf-c2._Field-name <= qbf-c4._Field-name)
      AND (NOT AVAILABLE qbf-c5 OR qbf-c2._Field-name <= qbf-c5._Field-name)
      THEN DO:
      { prores/c-cache2.i &cursor=2 }
      { prores/c-cache1.i &cursor=2 }
    END.
    ELSE
    IF AVAILABLE qbf-c3
      AND (NOT AVAILABLE qbf-c4 OR qbf-c3._Field-name <= qbf-c4._Field-name)
      AND (NOT AVAILABLE qbf-c5 OR qbf-c3._Field-name <= qbf-c5._Field-name)
      THEN DO:
      { prores/c-cache2.i &cursor=3 }
      { prores/c-cache1.i &cursor=3 }
    END.
    ELSE
    IF AVAILABLE qbf-c4
      AND (NOT AVAILABLE qbf-c5 OR qbf-c4._Field-name <= qbf-c5._Field-name)
      THEN DO:
      { prores/c-cache2.i &cursor=4 }
      { prores/c-cache1.i &cursor=4 }
    END.
    ELSE
    IF AVAILABLE qbf-c5 THEN DO:
      { prores/c-cache2.i &cursor=5 }
      { prores/c-cache1.i &cursor=5 }
    END.
  END.

END.

DO qbf-j = 5 TO LENGTH(qbf-u) + 1 BY 5:
  SUBSTRING(qbf-u,qbf-j,1) = ",":U.
END.

/* base is 2, with slot 1 reserved for caller's use */
qbf-ctop = qbf-ctop - 1.

RETURN.
