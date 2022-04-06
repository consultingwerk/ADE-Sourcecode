/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/* userblnk - prevent blank user from accessing data 

   Modified: DLM 07/13/98 Added _Owner to _File Find
             KSM 10/19/05 Skip over _aud tables - 20051019-019

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 11 NO-UNDO INITIAL [
  /* 1*/ "This function only works on {&PRO_DISPLAY_NAME} databases.",
  /* 2*/ "You may not use this function with a blank userid.",
  /* 3*/ "You must be a Security Administrator to execute this function.",
  /* 4*/ "Blank userid now has no permissions.",
  /* 5*/ "No changes needed to be made to the permissions.",
  /* 6*/ "The dictionary is in read-only mode - alterations not allowed.",
  /* 7*/ "You are about to prevent the blank userid from",
  /* 8*/ "accessing your database.  Users who are not",
  /* 9*/ "listed in the data security fields will not",
  /*10*/ "be able to compile procedures with this database.",
  /*11*/ "Do you wish to continue?"
].

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

DEFINE VARIABLE cont    AS LOGICAL           NO-UNDO.
DEFINE VARIABLE msg-num AS INTEGER INITIAL 0 NO-UNDO.

RUN "prodict/_dctadmn.p" (INPUT USERID(user_dbname),OUTPUT cont).
IF dict_rog                  THEN msg-num = 6. /* r/o mode    */
IF NOT cont                  THEN msg-num = 3. /* secu admin? */
IF USERID(user_dbname) = ""  THEN msg-num = 2. /* userid set? */
IF user_dbtype <> "PROGRESS" THEN msg-num = 1. /* dbtype okay */

IF msg-num <> 0 THEN DO:
  MESSAGE new_lang[msg-num] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

cont = FALSE.
MESSAGE new_lang[7]  SKIP
      	new_lang[8]  SKIP   
      	new_lang[9]  SKIP
        new_lang[10] SKIP(1)
      	new_lang[11]
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE cont.
IF NOT cont THEN RETURN.

run adecomm/_setcurs.p ("WAIT").
cont = FALSE.
FOR EACH _File
  WHERE _File._Db-recid = drec_db
    AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN" )
    AND (CAN-DO(_Can-read,"")   OR CAN-DO(_Can-write,"")
      OR CAN-DO(_Can-create,"") OR CAN-DO(_Can-delete,"")):
  /* If this is an auditing table, skip it. */
  IF _File-Name BEGINS "_aud" THEN DO:
    cont = TRUE.
    NEXT.
  END.

  IF CAN-DO(_Can-read,"")   THEN _Can-read   = "!," + _Can-read.
  IF CAN-DO(_Can-write,"")  THEN _Can-write  = "!," + _Can-write.
  IF CAN-DO(_Can-create,"") THEN _Can-create = "!," + _Can-create.
  IF CAN-DO(_Can-delete,"") THEN _Can-delete = "!," + _Can-delete.
  cont = TRUE.
END.
run adecomm/_setcurs.p ("").

MESSAGE new_lang[IF cont THEN 4 ELSE 5] 
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

RETURN.






