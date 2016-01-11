/*********************************************************************
* Copyright (C) 2006-2013 by Progress Software Corporation.          *
* All rights reserved.Prior versions of this work may contain        *
* portions contributed by participants of Possenet.                  *
*                                                                    *
*********************************************************************/

/* Procedure deltaconnect.p - sdash
   Created 03/13/13 Initial procedure for the MSS Incremental Df Utility
*/

{ prodict/user/uservar.i  }
{ prodict/mss/mssvar.i  }
{ prodict/misc/filesbtn.i }

DEFINE VARIABLE batch_mode    AS LOGICAL INITIAL FALSE  NO-UNDO.
DEFINE VARIABLE hasUniSupport AS LOGICAL                NO-UNDO.
DEFINE VARIABLE has2008Support AS LOGICAL               NO-UNDO.
DEFINE VARIABLE hasCompColSupport AS LOGICAL            NO-UNDO.
DEFINE VARIABLE dflt_dbname      AS CHARACTER           NO-UNDO.
DEFINE NEW SHARED VARIABLE select_dbname  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l                AS LOGICAL             NO-UNDO.
DEFINE VARIABLE l_dbnr        AS INTEGER                NO-UNDO.
DEFINE VARIABLE l_curr-db     AS INTEGER INITIAL 1      NO-UNDO.
DEFINE  SHARED VARIABLE scol      AS LOGICAL            NO-UNDO.
DEFINE  SHARED VARIABLE envshadowcol      AS CHARACTER  NO-UNDO.
DEFINE  NEW SHARED VARIABLE migshadowcol  AS LOGICAL    NO-UNDO.

batch_mode = SESSION:BATCH-MODE.

IF LDBNAME("DICTDB") <> ? THEN DO:
 FIND FIRST DICTDB._Db WHERE _Db._Db-name = mss_dbname NO-ERROR.
  IF AVAILABLE(_Db) THEN 
     l = yes.
END.

IF LDBNAME("DICTDB") <> ? THEN DO:
  FOR EACH DICTDB._DB NO-LOCK:
    IF DICTDB._Db._Db-type = "PROGRESS" THEN
      ASSIGN osh_dbname = LDBNAME ("DICTDB")
             mss_conparms = "<current working database>".
    /* If no select_dbname, select the last logical DB of schema holder with type = MSS */
    ELSE IF DICTDB._Db._Db-type = "MSS" THEN DO:
     IF l THEN DO:
      ASSIGN mss_dbname = DICTDB._Db._Db-name
             migshadowcol = (IF _Db-misc1[1] = 0 THEN TRUE ELSE FALSE)
             hasUniSupport = (DICTDB._Db._Db-xl-name = "utf-8")
             has2008Support = NO.
      /* To support computed columns, check for MSS 2005 or higher */
      IF INTEGER(SUBSTRING(ENTRY(NUM-ENTRIES(DICTDB._Db._Db-misc2[5], " ":U),_Db._Db-misc2[5], " ":U),1,2)) >= 9 THEN 
          hasCompColSupport = YES.
      /* if SQL 2008 and above and native Driver 10, let user select 2008 types */
      IF INTEGER(SUBSTRING(ENTRY(NUM-ENTRIES(DICTDB._Db._Db-misc2[5], " ":U),_Db._Db-misc2[5], " ":U),1,2)) >= 10 THEN DO:
         IF (DICTDB._Db._db-misc2[1] BEGINS "SQLNCLI") AND INTEGER(ENTRY(1,DICTDB._Db._db-misc2[2],".")) >= 10 THEN
             has2008Support = YES.
      END.
     END.
     ELSE DO:
         IF (mss_dbname <> ?) AND (mss_dbname  <> "") THEN DO:
              IF not batch_mode THEN DO:
               &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
                PUT STREAM logfile UNFORMATTED "Logical database " mss_dbname " does not exist in schema holder" osh_dbname 
                ", Default will be restored." skip(1).
               &ELSE
               MESSAGE "Logical database " mss_dbname " does not exist in schema holder" osh_dbname 
               ", Default will be restored." VIEW-AS ALERT-BOX ERROR.
               &ENDIF.
               END.      
              ELSE DO:
               PUT STREAM logfile UNFORMATTED "Logical database " mss_dbname " does not exist in schema holder" osh_dbname 
               ", Default will be restored." skip(1).
          END.
     END.
     ELSE IF (mss_dbname = ?) OR (mss_dbname  = "") THEN DO:
        IF not batch_mode THEN DO:
          &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
          PUT STREAM logfile UNFORMATTED  "Logical database cannot be left blank. Default will be restored." SKIP(1).
          &ELSE
          MESSAGE "Logical database cannot be left blank. Default will be restored." VIEW-AS ALERT-BOX ERROR.
          &ENDIF.
          END.
        ELSE DO:
          PUT STREAM logfile UNFORMATTED  "Logical database cannot be left blank. Default will be restored." SKIP(1).
        END.
     END.   
     ASSIGN mss_dbname = DICTDB._Db._Db-name
             migshadowcol = (IF _Db-misc1[1] = 0 THEN TRUE ELSE FALSE)
             hasUniSupport = (DICTDB._Db._Db-xl-name = "utf-8")
             has2008Support = NO.
         /* To support computed columns, check for MSS 2005 or higher */
          IF INTEGER(SUBSTRING(ENTRY(NUM-ENTRIES(DICTDB._Db._Db-misc2[5], " ":U),_Db._Db-misc2[5], " ":U),1,2)) >= 9 THEN 
             hasCompColSupport = YES.
         /* if SQL 2008 and above and native Driver 10, let user select 2008 types */
          IF INTEGER(SUBSTRING(ENTRY(NUM-ENTRIES(DICTDB._Db._Db-misc2[5], " ":U),_Db._Db-misc2[5], " ":U),1,2)) >= 10 THEN DO:
             IF (DICTDB._Db._db-misc2[1] BEGINS "SQLNCLI") AND INTEGER(ENTRY(1,DICTDB._Db._db-misc2[2],".")) >= 10 THEN
             has2008Support = YES.
           END.
       END.
    END.
  END.
END.

IF (migshadowcol = TRUE) AND (envshadowcol BEGINS "Y")THEN 
    ASSIGN shadowcol = TRUE
   envshadowcol = "FALSE".
 ELSE IF (migshadowcol = TRUE) AND (envshadowcol BEGINS "N") THEN 
   ASSIGN shadowcol = FALSE
    envshadowcol = "FALSE".
 ELSE IF (migshadowcol = TRUE) THEN
   ASSIGN shadowcol = TRUE
   envshadowcol = "FALSE".
ELSE IF (migshadowcol = FALSE) THEN
   ASSIGN shadowcol = FALSE
    envshadowcol = "FALSE".

