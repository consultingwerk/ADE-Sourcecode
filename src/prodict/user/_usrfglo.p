/***********************************************************************
* Copyright (C) 2000,2006,2008 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* userfglo - Perform a global field name change 

History - 07/09/98 D. McMann Added AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") to
                             For Each statements
          12/30/98 Mario B   Changed leave trigger on field new-name to GO
	                     trigger so that GO/CANCEL could be accessed if
                             data in new-name was not valid.  Bug 98-06-29-011.
          03/28/02 D. McMann Changed size of name fields to 32 SCC 20020218-023
                             Issue 3977 
          06/10/02 D. McMann Added check for new SESSION attribute schema change.
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userpik.i NEW }

DEFINE VARIABLE answer   AS LOGICAL           NO-UNDO.
DEFINE VARIABLE canned   AS LOGICAL INIT TRUE NO-UNDO.
DEFINE VARIABLE c        AS CHARACTER         NO-UNDO.
DEFINE VARIABLE i        AS INTEGER           NO-UNDO.
DEFINE VARIABLE isfroz   AS LOGICAL           NO-UNDO.
DEFINE VARIABLE issql    AS LOGICAL           NO-UNDO.
DEFINE VARIABLE isview   AS LOGICAL           NO-UNDO.
DEFINE VARIABLE new-name AS CHARACTER         NO-UNDO.
DEFINE VARIABLE num      AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE old-name AS CHARACTER         NO-UNDO.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 20 NO-UNDO INITIAL [
  /*    1*/ "All Fields In Database",
  /*    2*/ "The given name is not in any known table.",
  /*    3*/ "The new name is already in use in some table.",
  /*    4*/ "", /* reserved */
  /*    5*/ "The dictionary is in read-only mode - alterations not allowed.",
  /*    6*/ "You do not have permission to use this option.",
  /*    7*/ "This field is used in a View - cannot rename.",
  /*    8*/ "One or more of the tables is Frozen - cannot rename.",
  /*    9*/ "This field name is used by {&PRO_DISPLAY_NAME}/SQL - cannot rename.",
  /*   10*/ "This is a schema field - it cannot be renamed.",
  /*11,12*/ "Are you sure that you want to carry out this global",
            "search and replace operation on field names?",
  /*13,14*/ "Changing", "to",
  /*15,16*/ "This field name occurs in", "tables",
  /*17,18*/ "Searching fields to be renamed...", "done.",
  /*   19*/ "There are no user-defined fields in this database.",
  /*   20*/ "SESSION:SCHEMA-CHANGE set to New Objects, changes not allowed."
].

FORM
  SKIP(1)
  "This program will let you rename a field throughout all"    SKIP
  "tables.  In order for this to work, the 'target' name (the" SKIP
  "name you change to) must not be in use in any table in the" SKIP
  "database before the rename."                                SKIP(1)
  old-name FORMAT "x(32)" LABEL "Old Field Name" SKIP(1)
  new-name FORMAT "x(32)" LABEL "New Field Name" SKIP(1)
  c        FORMAT "x(18)" LABEL "To list all fields, press this key" 
  {prodict/user/userbtns.i}
  WITH FRAME everything 
  SIDE-LABELS ROW 4 CENTERED ATTR-SPACE DEFAULT-BUTTON btn_OK
  VIEW-AS DIALOG-BOX TITLE "Global Field Name Change".

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

/*===============================Triggers=================================*/

/*----- GET of OLD NAME or NEW NAME -----*/
ON GET OF old-name IN FRAME everything, new-name IN FRAME everything 
DO:
  DEFINE BUFFER xtbl FOR _File.
  DEFINE BUFFER xfld FOR _Field.

  IF pik_count = 0 THEN
   FOR EACH xtbl WHERE xtbl._Db-recid = drec_db
                   AND (xtbl._Owner = "PUB" OR xtbl._Owner = "_FOREIGN"),
     EACH xfld OF xtbl
     WHERE xfld._Field-name < "_"
     BREAK BY xfld._Field-name:
     IF FIRST-OF(xfld._Field-name) THEN ASSIGN
       pik_count = pik_count + 1
       pik_list[pik_count] = xfld._Field-name.
   END.
  IF pik_count > 0 THEN RUN "prodict/user/_usrpick.p".
  IF pik_return > 0 THEN 
      ASSIGN SELF:SCREEN-VALUE = pik_first.            
END.

/*----- LEAVE OF OLD NAME -----*/

ON LEAVE of old-name IN FRAME everything
DO:
  DEFINE VARIABLE name AS CHARACTER    NO-UNDO.
  DEFINE BUFFER bField FOR _Field.
  DEFINE BUFFER bFile FOR _File.

  name = TRIM(Self:SCREEN-VALUE).

  /* We already know the field name exists.  Just
     make sure it's not a schema field. 
  */
  IF INPUT FRAME everything old-name BEGINS "_" THEN DO:

    FIND FIRST bField where bField._Field-Name = NAME NO-LOCK NO-ERROR.
    IF AVAILABLE bField THEN DO:
        /* if one of the encryption schema tables, act as if it doesn't exist */
        FIND FIRST bFile OF bField WHERE 
            NOT CAN-DO({&INVALID_SCHEMA_TABLES},bFile._File-name) NO-LOCK NO-ERROR.
        IF NOT AVAILABLE bFile THEN
            RELEASE bField.
    END.

    IF NOT AVAILABLE bField THEN
        MESSAGE new_lang[2]. /* unknwon name */
    ELSE
        MESSAGE new_lang[10]. /* schema field */

    BELL.
    RETURN NO-APPLY.
  END.

END.

/*----- LEAVE OF new NAME -----*/

ON LEAVE of new-name IN FRAME everything
DO:
  DEFINE VARIABLE name AS CHARACTER    NO-UNDO.
  DEFINE BUFFER bField FOR _Field.
  DEFINE BUFFER bFile FOR _File.

  name = TRIM(Self:SCREEN-VALUE).

  FIND FIRST bField where bField._Field-Name = NAME NO-LOCK NO-ERROR.
  IF AVAILABLE bField THEN DO:
      /* if one of the encryption schema tables, act as if it doesn't exist 
         It will get blocked in _valname.p (ON GO) as an invalid name due
         to the underscore at the beginning of the name
      */
      FIND FIRST bFile OF bField NO-LOCK.
      IF CAN-DO({&INVALID_SCHEMA_TABLES},bFile._File-name) THEN
          RELEASE bField.
  END.

  IF AVAILABLE bField THEN DO:
      MESSAGE new_lang[3].
      RETURN NO-APPLY.
  END.

END.

/*----- ON GO -----*/
/* Was a leave trigger, but that was preventing access to OK/CANCEL btns */
ON GO OF frame everything
DO:
  RUN "adecomm/_valname.p"
    (INPUT FRAME everything new-name,INPUT no,OUTPUT answer).
  IF NOT answer THEN
  DO:
     APPLY "ENTRY" TO new-name IN FRAME everything.
     RETURN NO-APPLY.
  END.
END.

/*============================Mainline code===============================*/

DO FOR _File:
  FIND _File WHERE _File._File-name = "_Field"
               AND _File._Owner = "PUB".
  FIND FIRST _Field WHERE _Field._Field-name < "_" 
                      AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") NO-ERROR.
  IF NOT CAN-DO(_Can-write,USERID("DICTDB"))      THEN num = 6.
  ELSE IF dict_rog                                THEN num = 5.
  ELSE IF NOT AVAILABLE _Field                    THEN num = 19.
  ELSE
    IF SESSION:SCHEMA-CHANGE = "New Objects"   THEN num = 20.
    
END.
IF num > 0 THEN DO:
  MESSAGE new_lang[num] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
END.

ASSIGN
  pik_count  = 0
  pik_column = 40
  pik_row    = 4
  pik_title  = new_lang[1] /* All Fields In Database */
  pik_wide   = FALSE
  pik_hide   = TRUE
  pik_multi  = FALSE
  pik_number = FALSE
  c          = "[" + KBLABEL("GET") + "]"
  isfroz     = FALSE
  issql      = FALSE
  isview     = FALSE.

/* Adjust the ok and cancel buttons */
{adecomm/okrun.i  
   &BOX    = "rect_Btns"
   &FRAME  = "FRAME everything"
   &OK     = "btn_OK"
   &CANCEL = "btn_Cancel"}

PAUSE 0.
DISPLAY c WITH FRAME everything.

_loop:
DO ON ERROR UNDO,NEXT ON ENDKEY UNDO,LEAVE:
  SET
    old-name
      VALIDATE(CAN-FIND(FIRST _Field
        WHERE _Field._Field-name = old-name),new_lang[2])
    new-name
    btn_OK btn_Cancel
    WITH FRAME everything.

  ASSIGN
    old-name = LC(old-name)
    new-name = LC(new-name).
  DISPLAY old-name new-name WITH FRAME everything.

  canned = FALSE.
END.

IF canned THEN DO:
  user_path = "".
  HIDE FRAME everything NO-PAUSE.
  HIDE MESSAGE NO-PAUSE.
  RETURN.
END.

MESSAGE new_lang[17]. /* Searching fields 2-B renamed... */
FOR EACH _File WHERE _File._Db-recid = drec_db
                 AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN"),
  EACH _Field OF _File
  WHERE _Field._Field-name = old-name
  WHILE NOT (isfroz OR issql OR isview):
    ASSIGN
      isfroz = _File._Frozen
      isview = CAN-FIND(FIRST _View-ref WHERE
               _View-ref._Ref-Table = _File._File-name
               AND _View-ref._Base-Col = _Field._Field-name)
      issql  = _File._Db-lang > 0
      num    = num + 1.
END.
HIDE MESSAGE NO-PAUSE.
MESSAGE new_lang[17] new_lang[18]. /* searching done */

IF isfroz OR issql OR isview THEN DO:
  IF      isview THEN MESSAGE new_lang[7] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  ELSE IF isfroz THEN MESSAGE new_lang[8] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  ELSE IF issql  THEN MESSAGE new_lang[9] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  HIDE FRAME everything NO-PAUSE.
  HIDE MESSAGE NO-PAUSE.
  RETURN.
END.

answer = TRUE.
RUN "prodict/user/_usrdbox.p" (INPUT-OUTPUT answer,?,?,
  new_lang[13] + ' "' + old-name + '" ' +
  new_lang[14] + ' "' + new-name + '".!' +
  new_lang[15] + " " + STRING(num) + " " + new_lang[16] + ".!!" +
  new_lang[11] + " " + new_lang[12]).
IF answer THEN
  FOR EACH _File WHERE _File._Db-recid = drec_db
                   AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN"),
    EACH _Field OF _File
    WHERE _Field._Field-name = old-name:
    _Field._Field-name = new-name.
  END.
ELSE
  user_path = "".

HIDE FRAME everything NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
RETURN.




