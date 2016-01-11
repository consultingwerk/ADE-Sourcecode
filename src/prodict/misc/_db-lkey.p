/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _db-lkey.p

Description:
   Enables large key support for the connected database

Input Parameters:

Author: Fernando de Souza

Date Created: 06/09/06

----------------------------------------------------------------------------*/
DEFINE SHARED VARIABLE drec_db       AS RECID       NO-UNDO.

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 12 NO-UNDO INITIAL [
  /* 1*/ "The dictionary is in read-only mode",
  /* 2*/ "This option is only available for OpenEdge databases",
  /* 3*/ "This option is not available for the working database",
  /* 4*/ "You do not have permission to use this option",
  /* 5*/ "This option only applies to databases with block sizes of 4K or 8K",
  /* 6*/ "This option is not valid for databases running on releases previous to 10.1B",
  /* 7*/ "Large key entries support for this database is already enabled",
  /* 8*/ "Large key entries support enabled successfully",
  /* 9*/ "Failed to enable large key entries support.",
  /*10*/ "If you enable large key entries support for this database, it may cause",
  /*11*/ "runtime issues to pre-10.1B clients that connect to this database.",
  /*12*/ "Do you really want to enable large keys support?"
      ].

DEFINE VARIABLE cError AS CHARACTER NO-UNDO.

IF CAN-DO(DBRESTRICTIONS(LDBNAME("DICTDB")), "Read-Only":U) THEN DO:
    MESSAGE new_lang[1]
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
END.

/* not for dataservers */
FIND FIRST _Db WHERE RECID(_Db) = drec_db NO-ERROR.
IF NOT AVAILABLE _Db OR _Db._Db-type NE "PROGRESS" THEN DO:
    MESSAGE new_lang[2]
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
END.

/* first let's check if the user has permissons to the database feature table */
FIND FIRST DICTDB._File WHERE _File-name = "_Database-feature" AND _File._db-recid = drec_db NO-LOCK.
IF NOT AVAILABLE DICTDB._File THEN DO:
    MESSAGE new_lang[6]
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
END.

/* check if user can read and write to tbl */
IF NOT CAN-DO(DICTDB._File._Can-read,USERID("DICTDB")) OR 
   NOT CAN-DO(DICTDB._File._Can-write,USERID("DICTDB")) THEN DO:
    MESSAGE new_lang[4]
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
END.

/* check if this is a 4k block size db at least */
FIND FIRST DICTDB._Dbstatus NO-ERROR.
IF AVAILABLE DICTDB._Dbstatus AND DICTDB._Dbstatus._Dbstatus-dbblksize < 4096 THEN DO:
    MESSAGE new_lang[5] 
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
END.

/* check if db knows about large keys feature */
FIND FIRST DICTDB._Database-feature where _DBFeature_Name = "Large Keys" NO-LOCK NO-ERROR.
IF NOT AVAILABLE DICTDB._Database-feature THEN DO:
    MESSAGE new_lang[6] 
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
END.

/* check if feature is already enabled */
IF DICTDB._Database-feature._DBFeature_Enabled = "1" THEN DO:
   MESSAGE new_lang[7] 
       VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN.
END.

MESSAGE new_lang[10] SKIP new_lang[11] SKIP new_lang[12]
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "Warning" UPDATE opt AS LOGICAL.

IF NOT opt THEN
    RETURN.

/* if we get here, the feature is not enabled. let's enable it */
DO TRANS ON ERROR UNDO, LEAVE:
    FIND FIRST DICTDB._Database-feature where _DBFeature_Name = "Large Keys" EXCLUSIVE-LOCK.
    DICTDB._Database-feature._DBFeature_Enabled = "1" NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
       ASSIGN cError = ERROR-STATUS:GET-MESSAGE(1).
       UNDO,LEAVE.
    END.

    /* don't want to see the message displayed by the client */
    RELEASE DICTDB._Database-feature NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
       ASSIGN cError = ERROR-STATUS:GET-MESSAGE(1).
END.

/* display a message whether we failed or not */

FIND FIRST DICTDB._Database-feature where _DBFeature_Name = "Large Keys" NO-LOCK.
IF DICTDB._Database-feature._DBFeature_Enabled = "1" THEN
    MESSAGE new_lang[8] 
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
ELSE
    MESSAGE new_lang[9] SKIP cError
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

RETURN.

