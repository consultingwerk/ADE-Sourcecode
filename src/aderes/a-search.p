/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * a-search.p - find the configuration file
 */

{ aderes/s-system.i }
{ aderes/y-define.i }

DEFINE OUTPUT PARAMETER qbf-q AS CHARACTER NO-UNDO. /* qbf-qcfile */

DEFINE VARIABLE qbf-a AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-d AS CHARACTER NO-UNDO. /* physical db sans '.db' */
DEFINE VARIABLE qbf-f AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-l AS CHARACTER NO-UNDO. /* logical db name */

/* configuration file locator: */
/* step 1. if .db reachable, then configuration file should be with it. */
ASSIGN
  qbf-c = SEARCH(REPLACE(DBNAME,".db":u,"") + ".db":u)  /* db with '.db' */
  qbf-d = REPLACE(qbf-c,".db":u,"")                     /* db sans '.db' */
  qbf-l = LDBNAME(1)                                    /* logical db */
  .

RUN aderes/s-prefix.p (qbf-c,OUTPUT qbf-f).

ASSIGN qbf-q = qbf-f + qbf-l + {&qcExt}. /* qc7 file from logical db name */

IF SEARCH(qbf-q) = ? THEN DO:
  /* Step 2: find configuration file in database directory */
  ASSIGN qbf-q = qbf-l + {&qcExt}.

  /* Step 3: if not found, find configuration file in propath */
  IF SEARCH(qbf-q) <> ? THEN 
    ASSIGN qbf-q = SEARCH(qbf-q).       
  ELSE IF qbf-f <> ? THEN
    ASSIGN qbf-q = qbf-f + qbf-l + {&qcExt}.
END.

/* strip off extension */
qbf-q = SUBSTRING(qbf-q,1,LENGTH(qbf-q,"CHARACTER":u)
                        - LENGTH({&qcExt},"CHARACTER":u),"CHARACTER":u).

/* Confusion case! .db not reachable, but configuration file of */
/* correct name local with database also local.  */
IF SEARCH(REPLACE(DBNAME,".db":u,"") + ".db":u) = ?  /* .db not reachable */
  AND SEARCH(qbf-q + {&qcExt}) <> ?                /* config file is local */
  AND SEARCH(qbf-q + ".db":u) <> ?                   /* and .db next to it */
  THEN DO:

  RUN aderes/s-prefix.p (qbf-q,OUTPUT qbf-c).

  ASSIGN
    qbf-d = SEARCH(qbf-q + ".db":u)
    qbf-d = SUBSTRING(qbf-d,1,LENGTH(qbf-d,"CHARACTER":u) - 3,"CHARACTER":u).

  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
    SUBSTITUTE("&2.db or &2{&qcUqExt} could not be found in the &1 directory.  &3{&qcUqExt} was found in the PROPATH, but it appears to belong to &3.  You must fix your PROPATH or rename/delete &3.db and {&qcUqExt}.",
      qbf-c,SUBSTRING(qbf-q,LENGTH(qbf-c,"CHARACTER":u) + 1,-1,"CHARACTER":u),
      qbf-d)).
END.

/*------------------------------------------------------------------------*/

RETURN.

/* a-search.p - end of file */
