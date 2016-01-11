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

batch_mode = SESSION:BATCH-MODE.

IF batch_mode THEN DO:
IF LDBNAME("DICTDB") <> ? THEN DO:
  FOR EACH DICTDB._DB NO-LOCK:
    IF DICTDB._Db._Db-type = "PROGRESS" THEN
      ASSIGN osh_dbname = LDBNAME ("DICTDB")
             mss_conparms = "<current working database>".
    /* If no select_dbname, select the last logical DB of schema holder with type = MSS */
    ELSE IF DICTDB._Db._Db-type = "MSS" THEN DO:
    IF select_dbname = "" OR select_dbname = DICTDB._Db._Db-name THEN DO:
      ASSIGN mss_dbname = DICTDB._Db._Db-name
             shadowcol = (IF _Db-misc1[1] = 0 THEN TRUE ELSE FALSE)
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
    ASSIGN dflt_dbname = mss_dbname.
   END.
  END.
 END.
END.

 if not batch_mode then do:
  IF LDBNAME("DICTDB") <> ? THEN DO:
FIND FIRST DICTDB._Db WHERE DICTDB._Db._Db-name = ?.
IF AVAILABLE(_Db) THEN DO:
     ASSIGN mss_dbname = DICTDB._Db._Db-name.
     l = yes.
  END.
END.
END.

IF LDBNAME("DICTDB") <> ? THEN DO:
FIND FIRST DICTDB._Db WHERE DICTDB._Db._Db-name = ?.
/*find first dictdb._db where dictdb._db._db-name = ?.*/
IF AVAILABLE(_Db) THEN DO:
     ASSIGN mss_dbname = DICTDB._Db._Db-name.
     l = yes.
  END.
END.


IF LDBNAME("DICTDB") <> ? THEN DO:
  FOR EACH DICTDB._DB NO-LOCK:
    IF DICTDB._Db._Db-type = "PROGRESS" THEN
      ASSIGN osh_dbname = LDBNAME ("DICTDB")
             mss_conparms = "<current working database>".
    /* If no select_dbname, select the last logical DB of schema holder with type = MSS */
    ELSE IF DICTDB._Db._Db-type = "MSS" THEN DO:
    IF select_dbname = "" OR select_dbname = DICTDB._Db._Db-name THEN DO:
     IF l THEN DO:
      ASSIGN mss_dbname = DICTDB._Db._Db-name
          shadowcol = (IF _Db-misc1[1] = 0 THEN TRUE ELSE FALSE)
          hasUniSupport = (DICTDB._Db._Db-xl-name = "utf-8")
          has2008Support = NO
	  dflt_dbname = mss_dbname.

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
        MESSAGE "Logical database" mss_dbname "does not exist in schema holder" osh_dbname VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.
   END.
  END.
 END.
END.




