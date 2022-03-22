/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* _usrsdel.p - delete database 

      Modified 11/5/97 DLM Removed the check to see if any schema present
                           and will just ask if user is sure.
               07/14/98 DLM Added _Owner to _File finds
               04/24/00 DLM Added deleting of _db without user interaction so
                            the Create MSS Dataserver option can get rid of an
                            old version not supported by the dataserver.
                           
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE answer  AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE edbtyp  AS CHARACTER             NO-UNDO.
DEFINE VARIABLE msg-num AS INTEGER INITIAL 0     NO-UNDO.
DEFINE VARIABLE scrap   AS CHARACTER             NO-UNDO.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 12 NO-UNDO INITIAL [
  /*  1*/ "You cannot delete a {&PRO_DISPLAY_NAME} database through this program.",
  /*  2*/ "This is only for removing non-{&PRO_DISPLAY_NAME} data definitions from the schema holder.",
  /*  3*/ "You cannot remove non-{&PRO_DISPLAY_NAME} data definitions from a schema holder that still",
  /*  4*/ "contains table definitions.  Remove the table definitions first.",
  /*  5*/ "You do not have permission to delete data definitions from the schema holder definitions.",
  /*6,7*/ "Data definitions for database", "removed.",
  /*8,9*/ "Data definitions for database", "NOT removed.",
  /* 10*/ "The dictionary is in read-only mode - alterations not allowed.",
  /* 11*/ "Are you sure you want to remove the data definitions for the", 
  /* 12*/           "database called"
].
/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

assign
  edbtyp = { adecomm/ds_type.i
             &direction = "itoe"
             &from-type = "user_dbtype"
             }.

DO FOR DICTDB._File:
  FIND _File "_Db" WHERE _File._Owner = "PUB" NO-LOCK.
  IF NOT CAN-DO(_Can-delete,USERID("DICTDB")) THEN msg-num = 5.
  ELSE IF dict_rog THEN msg-num = 10. /* look but don't touch */
  IF msg-num > 0 THEN DO:
    MESSAGE new_lang[msg-num] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    user_path = "".
    RETURN.
  END.
END.

IF user_dbtype = "PROGRESS" AND user_env[35] <> "wrg-ver" THEN DO:
  MESSAGE new_lang[1]  /* can't delete progress db */
      	  new_lang[2]
      	  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
END.

DO:
  IF user_env[35] <> "wrg-ver" THEN DO:
    answer = FALSE.
    MESSAGE new_lang[11] SKIP /* r-u-sure */
        	  edbtyp + " " + new_lang[12] + ' "' + user_dbname + '"?' 
        	  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
  END.
  ELSE ASSIGN answer = TRUE.
  IF answer THEN DO:
    RUN "adecomm/_setcurs.p" ("WAIT").
    IF CONNECTED(user_dbname) THEN DISCONNECT VALUE(user_dbname).
    DO TRANSACTION:
      FIND _Db WHERE RECID(_Db) = drec_db.
      FOR EACH _File OF _Db:
        { prodict/dump/loadkill.i }
      END.
      FOR EACH _SEQUENCE OF _Db:
        DELETE _Sequence.
      END.
      DELETE _Db.
    END.
    RUN "adecomm/_setcurs.p" ("").
   IF user_env[35] <> "wrg-ver" THEN
        MESSAGE new_lang[6] '"' + user_dbname + '"' new_lang[7]
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   ASSIGN
      drec_db     = ?
      user_dbname = ""
      cache_dirty = TRUE.
  END.
  ELSE DO:
     user_path = "".  /* If not deleted, don't ask user to select a db */
     MESSAGE
        new_lang[8] '"' + user_dbname + '"' new_lang[9]
      	VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  END.
END.

RETURN.

