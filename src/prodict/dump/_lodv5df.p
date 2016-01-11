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

/**** Data dictionary Load data definitions Module ****/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

/* user_env[2] = name of .df file */
 
DEFINE NEW SHARED STREAM   loaderr.
DEFINE NEW SHARED VARIABLE errs   AS INTEGER NO-UNDO.
DEFINE NEW SHARED VARIABLE recs   AS INTEGER. /*UNDO*/
DEFINE NEW SHARED VARIABLE xpos   AS INTEGER NO-UNDO.
DEFINE NEW SHARED VARIABLE ypos   AS INTEGER NO-UNDO.

DEFINE BUFFER   idx-fld   FOR _Index-field.
DEFINE VARIABLE datatype LIKE _Data-type               NO-UNDO.
DEFINE VARIABLE flag       AS CHARACTER FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE fname      AS CHARACTER                NO-UNDO.
DEFINE VARIABLE i          AS INTEGER                  NO-UNDO.
DEFINE VARIABLE loadview   AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE no-chgs    AS LOGICAL  INITIAL TRUE    NO-UNDO.
DEFINE VARIABLE x_unique   AS CHARACTER                NO-UNDO. /* ix-nam */
DEFINE VARIABLE y_unique   AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE view-files AS CHARACTER EXTENT 3       NO-UNDO INITIAL [
  "_View", "_View-col", "_View-ref"
].

INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP.
IMPORT flag.
INPUT CLOSE.
IF NOT CAN-DO("NEW-FILE,CHG-FILE,REN-FILE,DEL-FILE,FILE",TRIM(flag))
  THEN RETURN.  /* we found a new format .df */
INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP.
user_path = "*C,9=h,_usrload".

DISPLAY "Loading data definitions for:"
  WITH FRAME namhdr ROW 3 CENTERED
  NO-ATTR-SPACE NO-BOX.

FORM fname FORMAT "x(32)"
  WITH 12 DOWN FRAME nme ROW 4 CENTERED NO-ATTR-SPACE NO-LABELS.

IF TERMINAL <> "" THEN 
  run adecomm/_setcurs.p ("WAIT").

_all1:
DO ON ERROR UNDO, LEAVE:
  ASSIGN
    cache_dirty = TRUE
    no-chgs     = FALSE.
  _fil1:
  REPEAT FOR _File TRANSACTION ON ERROR UNDO _all1, LEAVE:
    PROMPT-FOR flag _File-Name _Can-Create _Can-Read
      _Can-Write _Can-delete _File._Desc _File._Valexp _File._Valmsg
      _File._Frozen _File._Hidden _File._Db-lang _File._Dump-name
      .
    DISPLAY INPUT _File-Name @ fname WITH FRAME nme.
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      HIDE MESSAGE.
    END.
    PAUSE 0.
    DOWN WITH FRAME nme.
    flag = TRIM(INPUT flag).
    IF NOT CAN-DO("NEW-FILE,CHG-FILE,REN-FILE,DEL-FILE,FILE",flag)
      THEN DO:
      MESSAGE "An input record starting with" flag "was read,".
      MESSAGE "but a FILE, REN-FILE, NEW-FILE, CHG-FILE or DEL-FILE".
      MESSAGE "was expected.".
      MESSAGE "Processing terminated".
      UNDO _all1, LEAVE.
    END.

    DO ON ERROR UNDO, RETRY:
      IF RETRY THEN DO:
        MESSAGE "Error for file" INPUT _File-name ", process terminated"
      	        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      	user_path = "".
        UNDO _all1, LEAVE.
      END.
      IF flag = "NEW-FILE" 
        THEN DO:

          CREATE _File.
          assign 
            _File._Db-recid    = drec_db
            _File._ianum       = 6
            _File._File-Number = ?.
      END.
      ELSE  /* change, rename or delete */
        FIND _File WHERE _File-name = INPUT _File-name
                     AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN").
      IF _File._frozen THEN DO:
        MESSAGE "A CHG-FILE, REN-FILE or DEL-FILE record was read for file"
          _File-name.
        MESSAGE "But that file is frozen".
        MESSAGE "Processing terminated".
        UNDO _all1, LEAVE.
      END.
      IF flag = "DEL-FILE" THEN DO:
        FOR EACH _Index OF _File:
          FOR EACH _Index-Field OF _Index:
            DELETE _Index-Field.
          END.
          DELETE _Index.
        END.
        FOR EACH _Field OF _File:
          DELETE _Field.
        END.
        DELETE _File.
        NEXT _fil1.
      END.
      ELSE IF flag = "REN-FILE" THEN DO:
        _File-name = INPUT _can-create.
        NEXT _fil1.
      END.
      ELSE IF flag = "NEW-FILE" OR flag = "CHG-FILE" THEN DO:
        ASSIGN _File-name _Can-Create _File._Can-Read _File._Can-Write
          _Can-delete _File._Desc _File._Valexp _File._Valmsg _File._Hidden
          _File._Dump-name.
      END.

      /* To allow reordering of fields, we must temporarily change */
      /* all existing _Field._Order, otherwise we can get duplicates */
      /* during the update-process   */
      REPEAT:
        FIND FIRST _Field OF _File WHERE _Order > 0 NO-ERROR.
        IF NOT AVAILABLE _Field THEN LEAVE.
        _Field._Order = _Field._Order - 10000.
      END.
    END. /* end ON ERROR UNDO, RETRY */

    REPEAT ON ERROR UNDO _all1, LEAVE:  /* Field */
      PROMPT-FOR flag _Field-Name datatype _Decimals
        _Format FORMAT "x(60)" _Initial _Field._Label _Mandatory _Order
        _Field._Can-Read _Field._Can-Write _Extent _Field._Valexp
        _Field._Valmsg _Field._Help _Field._Desc _Col-label _Fld-case
      	.
      flag = TRIM(INPUT flag).
      IF NOT CAN-DO("NEW-FIELD,CHG-FIELD,REN-FIELD,DEL-FIELD",flag)
        THEN DO:
        MESSAGE "An input record starting with" flag "was read,".
        MESSAGE "But a NEW-FIELD, CHG-FIELD, REN-FIELD or DEL-FIELD".
        MESSAGE "record was expected".
        MESSAGE "Processing terminated".
        UNDO _all1, LEAVE.
      END.   /* Wrong record-type  */
      ASSIGN datatype.

      IF datatype = "boolean" THEN datatype = "logical".
      ELSE IF datatype = "dbkey" THEN datatype = "recid".

      IF flag = "NEW-FIELD" THEN DO:
        CREATE _Field.
        _Field._File-recid = RECID(_File).
        _Field-Name        = INPUT _Field-name.
        _data-type         = datatype.
        ASSIGN _extent.
      END.
      ELSE FIND _Field OF _File
        WHERE _Field-Name = INPUT _Field-name NO-ERROR.
      IF flag = "DEL-FIELD" THEN DO:
        FOR EACH _Index-field OF _Field:
          FIND _Index OF _Index-field.
          FOR EACH idx-fld OF _Index:
            DELETE idx-fld.
          END.
          DELETE _Index.
        END.
        DELETE _Field.
      END.
      ELSE IF flag = "REN-FIELD" THEN
        _Field-name = datatype.
      ELSE DO:   /* CHG or NEW */
        IF _Data-type <> datatype OR _Extent <> INPUT _Extent THEN DO:
          MESSAGE "You can not change data-type or extent for field"
            _File-name + "." + _Field-name.
          UNDO _all1, LEAVE.
        END.
        ASSIGN _Decimals _Format
          _Initial _Field._Label _Mandatory _Order _Field._Can-Read
          _Field._Can-Write  _Field._Valexp
          _Field._Valmsg _Field._Help _Field._Desc _Col-label _Fld-case.
      END.
    END.
    _indx1:
    REPEAT ON ERROR UNDO _all1, LEAVE:    /* Index */
      PROMPT-FOR flag _Index-Name x_Unique _Active.
      flag = TRIM(INPUT flag).
      IF NOT CAN-DO("NEW-INDEX,REN-INDEX,CHG-INDEX,DEL-INDEX,INDEX",flag)
        THEN DO:
        MESSAGE "An input record starting with" flag "was read,".
        MESSAGE "But an NEW-INDEX, REN-INDEX, CHG-INDEX or DEL-INDEX".
        MESSAGE "record was expected".
        MESSAGE "Processing terminated".
        UNDO _all1, LEAVE.
      END.

      y_unique = (INPUT x_unique = "yes").

      IF flag = "INDEX" THEN NEXT _indx1.
      ELSE IF flag = "NEW-INDEX" THEN DO:
        CREATE _Index.
        assign 
          _Index._File-recid = RECID(_File) 
          _Index._Idx-num    = ?
          _Index._ianum      = 6.
        ASSIGN _Index-Name _active.
        _unique = y_unique.
      END.
      ELSE
         FIND _Index  OF _File WHERE _Index-name = INPUT _Index-name NO-ERROR.
      IF flag = "DEL-INDEX" THEN DO:
        IF AVAILABLE _Index THEN DO:
          FOR EACH _Index-field OF _Index.
            DELETE _Index-field.
          END.
          DELETE _Index.
        END.
        NEXT _indx1.
      END.
      ELSE IF flag = "REN-INDEX" THEN DO:
        IF AVAILABLE _Index THEN _Index-name = INPUT x_unique.
        NEXT _indx1.
      END.
      ELSE IF flag = "CHG-INDEX" THEN DO:
        IF AVAILABLE _Index THEN DO:
          ASSIGN _active.
          IF _Unique <> y_Unique THEN DO:
            MESSAGE "You can not change uniqueness for index"
              _File-name + "." + _Index-name.
            UNDO _all1, LEAVE.
          END.
        END.
        NEXT _indx1.
      END.

      REPEAT FOR _Index-Field ON ERROR UNDO _all1 , LEAVE:
        PROMPT-FOR flag _Index-Seq _Field-Name _Ascending _Abbreviate.
        flag = TRIM(INPUT flag).
        FIND _Field OF _File WHERE _Field-name = INPUT _Field-name.
        IF flag <> "INDEX-FIELD" THEN DO:
          MESSAGE "An input record starting with" flag "was read,".
          MESSAGE "But an INDEX-FIELD record was expected".
          MESSAGE "Processing terminated".
          UNDO _all1, LEAVE.
        END.
        DO:
          FIND _Index-field OF _Index
            WHERE _Index-field._Field-recid  = RECID(_Field)  NO-ERROR.
          IF NOT AVAILABLE _Index-field THEN CREATE _Index-field.
        END.
        IF NEW(_Index-field) THEN DO:
          _Index-Field._Index-recid = RECID(_Index).
          _Index-Field._Field-recid = RECID(_Field).
          ASSIGN _Index-Seq _Ascending _Abbreviate.
        END.
        ELSE DO:
          IF _Index-seq <> INPUT _Index-seq OR _Ascending <> INPUT _Ascending
            OR _Abbreviate <> INPUT _Abbreviate THEN DO:
            MESSAGE "You can not change anything for index-component"
              _Index-name + "." + _Field-name.
            UNDO _all1, LEAVE.
          END.
        END.
      END.    /* end repeat for _Index-field */
    END.        /* end repeat for _Index */

    REPEAT  ON ERROR UNDO _all1, LEAVE:  /* Primary Index */
      PROMPT-FOR flag _Index-Name.
      flag = TRIM(INPUT flag).
      IF flag <> "PRIMARY" THEN DO:
        MESSAGE "An input record starting with" flag "was read,".
        MESSAGE "But a PRIMARY record was expected".
        MESSAGE "Processing terminated".
        UNDO _all1, LEAVE.
      END.
      FIND _Index OF _File WHERE _Index-Name = INPUT _Index-name.
      _File._Prime-Index = RECID(_Index).
    END.        /* end repeat for _Index */

    /* cleaning up */

    REPEAT:
      FIND FIRST _Field OF _File WHERE _Order < 0 NO-ERROR.
      IF NOT AVAILABLE _Field THEN LEAVE.
      _Field._Order = _Field._Order + 10000.
    END.

    /* must be last to avoid preventing chgs */
    IF INPUT _File._Db-lang = 1 THEN ASSIGN _File._Db-lang.
    ASSIGN _File._Frozen.

  END.    /* repeat for file transaction */

  IF SEARCH("_View.d") = "_View.d" THEN DO:
    MESSAGE "Load view-definitions?" UPDATE loadview.
    IF loadview THEN 
      viewloop:
      DO i = 1 TO 3:
	DISPLAY view-files[i] @ fname WITH FRAME nme.
	DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
	  HIDE MESSAGE.
	END.
	PAUSE 0.
	DOWN WITH FRAME nme.
	/*   message "Loading " + view-files[i] + " ...".   */
	OUTPUT STREAM loaderr TO VALUE(view-files[i] + ".e") NO-ECHO.
	INPUT FROM VALUE(view-files[i] + ".d") NO-ECHO NO-MAP.
	CREATE ALIAS "DICTDB2" FOR DATABASE VALUE(user_dbname) NO-ERROR.
	RUN "prodict/misc/_runload.i" (INPUT "n")
	  VALUE(view-files[i]) 0 100 VALUE(view-files[i]) 0.
	INPUT CLOSE.
	OUTPUT STREAM loaderr CLOSE.
	/* delete temporary files */
	IF errs = 0 THEN OS-DELETE VALUE(view-files[i] + ".e").
	IF RETURN-VALUE = "stopped" THEN LEAVE viewloop.
      END. /* do i = 1 to 3, one for each view-file */
  END. /* if _view.d exists */

  IF TERMINAL <> "" THEN 
    MESSAGE "Phase 1 of Load completed.  Working.  Please wait ...".
  ELSE
    MESSAGE "Load Data Definitions Complete.".
END. /* end _all1 loop */

IF TERMINAL <> "" THEN 
  run adecomm/_setcurs.p ("").

IF no-chgs THEN MESSAGE "No changes were made to the dictionary.".
HIDE FRAME namhdr NO-PAUSE.
HIDE FRAME nme    NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
RETURN.


