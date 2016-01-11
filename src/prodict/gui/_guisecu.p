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

/*------------------------------------------------------------------
   Editor for setting File and Field level Security.

   Author: Tony Lavinio, Laura Stern

   Input: user_env[9] - ro (read only) or rw (read/write)
   
   History:  03/25/02 Added display to be editor widget instead of fill-ins
                      to allow more characters than 63 -ISSUE 4255
                      SCC 20020225-049
-------------------------------------------------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 14 NO-UNDO INITIAL [
  /* 1*/ "You must be a Security Administrator to execute this function.",
  /* 2*/ "",  /* goes with 1 */

  /* 3*/ "You need Database Security Administrator privileges in the master",
  /* 4*/ "PROGRESS DB which contains the schema of this database to continue.",

  /* 5*/ "You may not use this function with a blank userid.  This applies to",
  /* 6*/ "both the PROGRESS DB and the specific foreign DB, if appropriate.",

  /* 7*/ "The dictionary is in read-only mode - alterations not allowed.",
  /* 8*/ "You can only alter security on SQL tables with GRANT and REVOKE.",
  /* 9*/ "", /* reserved */

  /*10*/ "You cannot change permissions to exclude yourself.",
  /*11*/ "Permissions for Table ",
  /*12*/ "", /* reserved */
  /*13*/ "There are no tables to set security on.",
  /*14*/ "Undo all changes made in this dialog box?"
].

/* use these statements to man-handle scoping */
IF FALSE THEN RELEASE _File.
IF FALSE THEN RELEASE _Field.

/* Form variables */
DEFINE VARIABLE tlist AS CHAR NO-UNDO
   VIEW-AS SELECTION-LIST SINGLE INNER-LINES 5 INNER-CHARS 32
   SCROLLBAR-V SCROLLBAR-H.
DEFINE VARIABLE flist AS CHAR NO-UNDO
   VIEW-AS SELECTION-LIST SINGLE INNER-LINES 5 INNER-CHARS 32
   SCROLLBAR-V SCROLLBAR-H LIST-ITEMS "".

DEFINE VARIABLE t_hidden AS LOGICAL NO-UNDO
   VIEW-AS TOGGLE-BOX.
 
DEFINE VARIABLE which AS CHAR NO-UNDO INITIAL "t"
   VIEW-AS RADIO-SET VERTICAL
   RADIO-BUTTONS "Permissions for Selected T&able", "t",
      	       	 "Permissions for Selected F&ield", "f".

DEFINE VARIABLE can_lbl    AS CHAR INITIAL "" NO-UNDO.
DEFINE VARIABLE can_read   AS CHAR INITIAL "" NO-UNDO.
DEFINE VARIABLE can_write  AS CHAR INITIAL "" NO-UNDO.
DEFINE VARIABLE can_create AS CHAR INITIAL "" NO-UNDO.
DEFINE VARIABLE can_delete AS CHAR INITIAL "" NO-UNDO.
DEFINE VARIABLE can_dump   AS CHAR INITIAL "" NO-UNDO.
DEFINE VARIABLE can_load   AS CHAR INITIAL "" NO-UNDO.

/* Miscellaneous */
DEFINE VARIABLE ans     AS LOGICAL               NO-UNDO.
DEFINE VARIABLE msg-num AS INTEGER INITIAL 0 	 NO-UNDO.
DEFINE VARIABLE r-o     AS LOGICAL               NO-UNDO.
DEFINE VARIABLE istrans AS LOGICAL INITIAL TRUE. /* (not no-undo!) */
DEFINE VARIABLE changed AS LOGICAL INITIAL NO    NO-UNDO.
DEFINE VARIABLE ix      AS INTEGER               NO-UNDO.
DEFINE VARIABLE stat    AS LOGICAL               NO-UNDO.
DEFINE VARIABLE tab_lbl AS CHAR INIT "&Tables:"  NO-UNDO.
DEFINE VARIABLE fld_lbl AS CHAR INIT "&Fields:"  NO-UNDO.
DEFINE VARIABLE msgSecu1 AS CHAR VIEW-AS EDITOR NO-BOX INNER-CHARS 22 INNER-LINES 1 NO-UNDO.
DEFINE VARIABLE msgSecu2 AS CHAR VIEW-AS EDITOR NO-BOX INNER-CHARS 7 INNER-LINES 5 NO-UNDO.
DEFINE VARIABLE msgSecu3 AS CHAR VIEW-AS EDITOR NO-BOX INNER-CHARS 22 INNER-LINES 5 NO-UNDO.
DEFINE VARIABLE msgSecu4 AS CHAR VIEW-AS EDITOR NO-BOX INNER-CHARS 27 INNER-LINES 3 NO-UNDO.
DEFINE VARIABLE cr AS CHAR NO-UNDO.

FORM
   SKIP({&TFM_WID})
   tab_lbl    NO-LABEL             AT 2     VIEW-AS TEXT
   fld_lbl    NO-LABEL      	   AT 41    VIEW-AS TEXT  SKIP({&VM_WID})
   tlist      NO-LABEL	      	   AT 2      	      	 
   flist      NO-LABEL	      	   AT 41      	      	  SKIP({&VM_WID})
   t_hidden   LABEL "&Show Hidden" AT 2
   which      NO-LABEL	      	   AT 25        	  SKIP({&VM_WID})
   can_lbl    NO-LABEL	      	   AT 2     FORMAT "x(73)" 
      	       	     	      	       	    VIEW-AS TEXT SKIP({&VM_WID})
   can_read   LABEL "Can-&Read"    {&STDPH_FILL} COLON 12 
    VIEW-AS EDITOR INNER-LINES 1 INNER-CHARS 28 SKIP({&VM_WID})
   can_write  LABEL "Can-&Write"   {&STDPH_FILL} COLON 12 
    VIEW-AS EDITOR INNER-LINES 1 INNER-CHARS 28 SKIP({&VM_WID})
   can_create LABEL "Can-&Create"  {&STDPH_FILL} COLON 12 
   VIEW-AS EDITOR INNER-LINES 1 INNER-CHARS 28 SKIP({&VM_WID})
   can_delete LABEL "Can-&Delete"  {&STDPH_FILL} COLON 12 
   VIEW-AS EDITOR INNER-LINES 1 INNER-CHARS 28 SKIP({&VM_WID})
   can_dump   LABEL "Can-Du&mp"    {&STDPH_FILL} COLON 12 
   VIEW-AS EDITOR INNER-LINES 1 INNER-CHARS 28 SKIP({&VM_WID})
   can_load   LABEL "Can-&Load"    {&STDPH_FILL} COLON 12 
   VIEW-AS EDITOR INNER-LINES 1 INNER-CHARS 28
   {prodict/user/userbtns.i}
   msgSecu1 NO-LABEL AT COLUMN 45 ROW-OF can_read + .1
   msgSecu2 NO-LABEL AT COLUMN 45 ROW-OF can_read + .7
   msgSecu3 NO-LABEL AT COLUMN 45 ROW-OF can_read + .7
   msgSecu4 NO-LABEL AT COLUMN 45 ROW-OF can_dump
   WITH FRAME secu THREE-D 
   CENTERED ATTR-SPACE SIDE-LABELS
   DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
   VIEW-AS DIALOG-BOX TITLE "Edit Data Security".

cr = chr(10).
ASSIGN msgSecu1:SCREEN-VALUE = 
   "Permission Examples:".

ASSIGN msgSecu2:SCREEN-VALUE = 
   "" + cr +
   "*" + cr +
   "!<u1>,*" + cr +
   "ab*" + cr +
   "".

ASSIGN msgSecu3:SCREEN-VALUE = 
   "" + cr +
   "= All Users" + cr +
   "= All Except u1" + cr +
   "= All Beginning ~"ab~"" + cr +
   "".

ASSIGN msgSecu4:SCREEN-VALUE = 
   "Note: Spaces used in the"  + cr +
   "permission string will be" + cr +
   "taken literally.".

msgSecu1:READ-ONLY = yes.
msgSecu2:READ-ONLY = yes.
msgSecu3:READ-ONLY = yes.
msgSecu4:READ-ONLY = yes.

   
/* Added to support selection list label mnemonics (tomn 8/1/95) */
ASSIGN
  tlist:SIDE-LABEL-HANDLE IN FRAME secu = tab_lbl:HANDLE
  tlist:LABEL = tab_lbl
  flist:SIDE-LABEL-HANDLE IN FRAME secu = fld_lbl:HANDLE
  flist:LABEL = fld_lbl.
  
/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

/*========================Internal Procedures=============================*/

/*--------------------------------------------------------------------
   Show security information on the selected table or field.
   The buffer _File is filled.  _Field may or may not have a record.
---------------------------------------------------------------------*/
PROCEDURE Show_Secu:

   can_lbl = new_lang[11] + 
      	     (IF AVAILABLE (_File) THEN _File._File-name ELSE "").
   if which = "t" THEN DO:
     IF AVAILABLE (_File) THEN DO:
	   IF NOT r-o THEN DO:
	     ASSIGN Can_Create:sensitive IN FRAME secu = yes
	            Can_Delete:sensitive IN FRAME secu = yes
	            Can_Dump:sensitive IN FRAME secu = yes
	            Can_Load:sensitive IN FRAME secu = yes.
    
         ASSIGN Can_read = _File._Can-Read 	 
	            Can_Write = _File._Can-Write 
		        Can_Create = _File._Can-Create	
		        Can_Delete = _File._Can-Delete	
		        Can_Dump = _File._Can-Dump 	  
		        Can_Load = _File._Can-Load.	

         DISPLAY Can_Read
		         Can_Write
		         Can_Create
		         Can_Delete
		         Can_Dump
		         Can_Load
		 WITH FRAME secu.
      END.
      ELSE
	    DISPLAY Can_Read
	            Can_Write
                Can_Create
		        Can_Delete
		        Can_Dump
		         Can_Load
		WITH FRAME secu.
     END.
   END.
   ELSE DO: /* which = "f" */
     ASSIGN can_lbl = can_lbl + "." + 
      	       	   (IF AVAILABLE _FIELD THEN _Field._Field-name ELSE "")
      	    Can_Create:sensitive IN FRAME secu = no
      	    Can_Delete:sensitive IN FRAME secu = no
      	    Can_Dump:sensitive IN FRAME secu = no
      	    Can_Load:sensitive IN FRAME secu = no.

      DISPLAY Can_Create
      	      Can_Delete
      	      Can_Dump
      	      Can_Load
      	      WITH FRAME secu.

      IF AVAILABLE _Field THEN DO:
        ASSIGN Can_read = _Field._Can-Read
               Can_write =  _Field._Can-Write.
      	DISPLAY Can_Read
      	         Can_Write
      	       	 WITH FRAME secu.
      END.
      ELSE 
      	 DISPLAY Can_Read
      	         Can_Write
      	       	 WITH FRAME secu.
   END.
   can_lbl = can_lbl + ":".
   DISPLAY can_lbl WITH FRAME secu.
END.


/*--------------------------------------------------------------------
   A new table has been chosen.  This is called after we've saved
   info for the current table to set up everything based on the new
   table chosen.

   Input Parameter:
      p_Tbl - the newly chosen table name
---------------------------------------------------------------------*/
PROCEDURE Next_Table:

   DEFINE INPUT PARAMETER p_Tbl AS CHAR NO-UNDO.

   IF t_hidden THEN
      FIND _File WHERE _File._Db-recid = drec_db AND
		       _File._File-name = p_Tbl NO-ERROR.
   ELSE
      FIND _File WHERE _File._Db-recid = drec_db AND
		       _File._File-name = p_Tbl AND
		       NOT _File._Hidden NO-ERROR.

   IF AVAILABLE(_File) THEN DO:
      user_filename = _File._File-name.
      drec_file = RECID(_File).
      DISPLAY user_filename WITH FRAME user_ftr.
   END.
   ELSE DO:
      user_filename = "".
      drec_file = ?.
   END.

   /* If setting field permissions, refill the field list for this tbl */
   IF which = "f" THEN
      RUN Get_Fields.

   RUN Show_Secu.
END.


/*--------------------------------------------------------------------
   Fill the field list.
---------------------------------------------------------------------*/
PROCEDURE Get_Fields:
   flist:LIST-ITEMS IN FRAME secu = "".  /* clear the list */
   IF drec_file = ? THEN DO:
      RELEASE _Field.
      RETURN.
   END.
   RUN "adecomm/_fldlist.p" (INPUT flist:HANDLE IN FRAME secu,
     	       	       	    INPUT drec_file,
			    INPUT true,
			    INPUT "",
      	       	     	    INPUT ?,
			    INPUT false,
			    INPUT "",
			    OUTPUT ans).
   flist = flist:ENTRY(1) IN FRAME secu.
   IF flist = ? THEN flist = "".
   flist:SCREEN-VALUE IN FRAME secu = flist.
   FIND _Field of _File WHERE _Field._Field-name = flist NO-ERROR.
END.


/*--------------------------------------------------------------------
   Save the information for this table or field in the database.
   
   Returns "error" if information is invalid, otherwise "".
   (In case of error, message is displayed here)
---------------------------------------------------------------------*/
PROCEDURE Save_Info:
   DEFINE VAR err as LOGICAL NO-UNDO INIT no.
   DEFINE VAR mod as LOGICAL NO-UNDO INIT no. 

   /* Read only - nothing to do. */
   if r-o OR NOT AVAILABLE(_File) THEN RETURN "".

   /* Side case - we're in field mode but there are no fields. Just
      don't do anything.*/
   IF which = "f" AND NOT AVAILABLE _Field THEN RETURN "".

   ASSIGN
      INPUT FRAME secu Can_Read
      INPUT FRAME secu Can_Write
      INPUT FRAME secu Can_Create
      INPUT FRAME secu Can_Delete
      INPUT FRAME secu Can_Dump
      INPUT FRAME secu Can_Load.

   /* mod will be yes if there were any modifications made */
   IF which = "t" THEN DO:
      IF Can_Read <> _File._Can-read THEN DO:
      	 mod = yes.
         IF NOT CAN-DO(Can_Read ,USERID("DICTDB")) THEN err = yes.
      END.
      IF NOT err AND Can_Write <> _File._Can-write THEN DO:
      	 mod = yes.
         IF NOT CAN-DO(Can_Write ,USERID("DICTDB")) THEN err = yes.
      END.
      IF NOT err AND Can_Create <> _File._Can-Create THEN DO:
      	 mod = yes.
         IF NOT CAN-DO(Can_Create ,USERID("DICTDB")) THEN err = yes.
      END.
      IF NOT err AND Can_Delete <> _File._Can-Delete THEN DO:
      	 mod = yes.
         IF NOT CAN-DO(Can_Delete ,USERID("DICTDB")) THEN err = yes.
      END.
      IF NOT err AND Can_Dump <> _File._Can-Dump THEN DO:
      	 mod = yes.
         IF NOT CAN-DO(Can_Dump ,USERID("DICTDB")) THEN err = yes.
      END.
      IF NOT err AND Can_Load <> _File._Can-load THEN DO:
      	 mod = yes.
         IF NOT CAN-DO(Can_Load ,USERID("DICTDB")) THEN err = yes.
      END.

      IF mod AND NOT err AND _File._Db-lang = 0 /* NOT SQL */ THEN
      	 ASSIGN
      	    _File._Can-Read   = Can_Read
      	    _File._Can-Write  = Can_Write
      	    _File._Can-Create = Can_Create
      	    _File._Can-Delete = Can_Delete
      	    _File._Can-Dump   = Can_Dump
      	    _File._Can-Load   = Can_Load.
   END.
   ELSE DO: /* which = "f" */
      IF Can_Read <> _Field._Can-read THEN DO:
      	 mod = yes.
      	 IF NOT CAN-DO(Can_Read ,USERID("DICTDB")) THEN err = yes.
      END.
      IF NOT err AND Can_Write <> _Field._Can-write THEN DO:
      	 mod = yes.
	 IF NOT CAN-DO(Can_Write ,USERID("DICTDB")) THEN err = yes.
      END.
   
      IF mod AND NOT err AND _File._Db-lang = 0 /* NOT SQL */ THEN
	 ASSIGN
	    _Field._Can-Read  = Can_Read
	    _Field._Can-Write = Can_Write.
   END.

   IF mod AND _File._Db-lang <> 0 THEN DO:
     MESSAGE new_lang[8] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
     RETURN "error".
   END.

   IF err THEN DO:
      MESSAGE new_lang[10] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN "error".
   END.

   changed = changed OR mod.
   RETURN "".
END.


/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame secu
   or CHOOSE of btn_Help in frame secu
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Edit_Data_Security_Dlg_Box},
      	       	     	     INPUT ?).
&ENDIF


/*----- ON HIT of CANCEL BUTTON or ENDKEY -----*/
ON CHOOSE OF btn_Cancel IN FRAME secu OR ENDKEY OF FRAME secu
DO:
   IF NOT changed THEN RETURN.  

   ans = yes.
   MESSAGE new_lang[14] /* Are you sure */
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE ans.
   IF NOT ans THEN
      RETURN NO-APPLY.
   ELSE
      changed = no.  /* reset */
END.


/*----- ON HIT of OK BUTTON or GO -----*/
ON CHOOSE OF btn_OK IN FRAME secu OR GO OF FRAME secu
DO:
   RUN Save_Info.
   IF RETURN-VALUE = "error" THEN RETURN NO-APPLY.
END.


/*----- ON VALUE-CHANGED of TABLE -----*/
ON VALUE-CHANGED OF tlist IN FRAME secu
DO:
   RUN Save_Info.
   IF RETURN-VALUE = "error" THEN DO:
      /* Return no-apply should prevent the value change but it 
      	 doesn't because in this case the widget already 
      	 processed the event.  So I have to do it myself.
      */
      tlist:SCREEN-VALUE IN FRAME secu = _File._File-name.
      RETURN NO-APPLY.
   END.

   RUN Next_Table (INPUT SELF:SCREEN-VALUE).
END.


/*----- ON VALUE-CHANGED of FIELD -----*/
ON VALUE-CHANGED OF flist IN FRAME secu
DO:
   RUN Save_Info.
   IF RETURN-VALUE = "error" THEN DO:
      /* Return no-apply should prevent the value change but it 
      	 doesn't because in this case the widget already 
      	 processed the event.  So I have to do it myself.
      */
      flist:SCREEN-VALUE IN FRAME secu = _Field._Field-name.
      RETURN NO-APPLY.
   END.

   FIND _Field of _File WHERE _Field._Field-name = SELF:SCREEN-VALUE.
   RUN Show_Secu.
END.


/*----- ON VALUE-CHANGED of SHOW-HIDDEN TOGGLE -----*/
ON VALUE-CHANGED OF t_hidden IN FRAME secu
DO:
   DEFINE VAR tbl AS CHAR NO-UNDO.

   RUN Save_Info. /* Save for current table selection */
   IF RETURN-VALUE = "error" THEN DO:  
      /* Return no-apply should prevent the value change but it 
      	 doesn't because in this case the widget already 
      	 processed the event.  So I have to do it myself.
      */
      t_hidden:SCREEN-VALUE IN FRAME secu = 
      	 (IF SELF:SCREEN-VALUE = "no" THEN "yes" ELSE "no").
      RETURN NO-APPLY.
   END.

   t_hidden = INPUT FRAME secu t_hidden.

   /* Re-fill the list with or without hidden tables. */
   tlist:LIST-ITEMS IN FRAME secu = "".  /* Clear first */
   run "prodict/_dctcach.p" (t_hidden).
   do ix = 1 to cache_file#:
      stat = tlist:ADD-LAST(cache_file[ix]) in frame secu.
   end.

   /* Don't try to keep the same selection they had.  Just set to 1st entry. */
   tbl = tlist:ENTRY(1) IN FRAME secu.
   tlist:SCREEN-VALUE IN FRAME secu = tbl.
   RUN Next_Table (INPUT tbl).
END.


/*----- ON VALUE-CHANGED of which (RADIO SET) -----*/
ON VALUE-CHANGED OF which IN FRAME secu
DO:
   RUN Save_Info.
   IF RETURN-VALUE = "error" THEN DO:
      /* Return no-apply should prevent the value change but it 
      	 doesn't because in this case the widget already 
      	 processed the event.  So I have to do it myself. 
      */
      which:SCREEN-VALUE IN FRAME secu = 
      	 (IF SELF:SCREEN-VALUE = "f" THEN "t" ELSE "f").
      RETURN NO-APPLY.
   END.   

   which = SELF:SCREEN-VALUE.  /* to avoid having to refer to frame value */
   IF SELF:SCREEN-VALUE = "f" THEN DO:
      flist:sensitive IN FRAME secu = yes.
      RUN Get_Fields.
   END.
   ELSE DO:
      flist:LIST-ITEMS IN FRAME secu = "". /* clear the list */
      flist:sensitive IN FRAME secu = no.
   END.

   RUN Show_Secu.
END.

/*----- ON WINDOW-CLOSE -----*/
ON WINDOW-CLOSE OF FRAME secu
   APPLY "END-ERROR" TO FRAME secu.


/*=============================Mainline Code==============================*/


DO ON ERROR UNDO:
  istrans = FALSE.
  UNDO,LEAVE.
END.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  ENABLE msgSecu1 msgSecu2 msgSecu3 msgSecu4 WITH FRAME secu.
&ENDIF

RUN "prodict/_dctadmn.p" (INPUT USERID("DICTDB"),OUTPUT ans).
IF NOT ans               THEN msg-num = 1. /* secu admin? */
IF NOT ans AND user_dbtype <> "PROGRESS"
                         THEN msg-num = 3. /* secu admn in pro db */
IF USERID("DICTDB") = "" THEN msg-num = 5. /* userid set? */

IF msg-num <> 0 THEN DO:
  MESSAGE new_lang[msg-num] SKIP
      	  new_lang[msg-num + 1] 
      	  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
END.

r-o = user_env[9] = "ro".
IF (istrans
    OR PROGRESS = "Run-Time"
    OR CAN-DO("READ-ONLY",DBRESTRICTIONS(user_dbname)) 
    OR dict_rog) THEN 
   r-o = TRUE.
/* Should we put read-only status in a status line? */

/* Fill in the cache of file names if not done already or refill if
   cache is dirty.
*/
if cache_dirty then do:
   /* if current table is schema table, then include them by default */
   t_hidden = (IF user_filename BEGINS "_" then yes else no).
   run "prodict/_dctcach.p" (t_hidden).
end.
else do: /* determine if cache contains hidden tables */
   do ix = 1 to cache_file# while NOT cache_file[ix] BEGINS "_":
   end.
   t_hidden = (cache_file[ix] BEGINS "_").
end.

/* Initialize the table select list and it's initial values. If there isn't
   already a current table, then set to first one.  
*/
IF (user_filename <> ""     AND 
    user_filename <> "SOME" AND
    user_filename <> "ALL") THEN 
DO:
   tlist = user_filename.  /* initialize to current table */
   FIND _File WHERE RECID(_File) = drec_file.
END.
ELSE DO:
   /* Set current table name */
   tlist = (if cache_file# > 0 then cache_file[1] else "").
   user_filename = tlist.
   IF user_filename <> "" THEN DO:
      FIND _File WHERE _File._File-name = user_filename AND 
      	 _File._Db-recid = drec_db.
      drec_file = RECID(_File).
      DISPLAY user_filename WITH FRAME user_ftr.
   END.
   ELSE drec_file = ?.
END.
DO ix = 1 TO cache_file#:
   stat = tlist:ADD-LAST(cache_file[ix]) IN FRAME secu.
END.

RUN "adecomm/_scroll.p" (INPUT tlist:HANDLE IN FRAME secu,
      	       	     	 INPUT user_filename).

/* Adjust the graphical rectangle and the ok and cancel buttons */
{adecomm/okrun.i  
    &FRAME  = "FRAME secu" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
}

/* Field list starts out disabled and empty. We disable it later after
   it's tab order is set by ENABLE. 
*/
flist:LIST-ITEMS IN FRAME secu = "".

RUN Show_Secu.  /* show current table info */
DISPLAY tlist flist t_hidden which WITH FRAME secu.

DO TRANSACTION ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
   ENABLE
      tlist 
      flist
      t_hidden
      which
      can_read 	  when NOT r-o
      can_write   when NOT r-o
      can_create  when NOT r-o AND which = "t"
      can_delete  when NOT r-o AND which = "t" 
      can_dump    when NOT r-o AND which = "t" 
      can_load    when NOT r-o AND which = "t" 
      btn_OK   	  when NOT r-o
      btn_Cancel
      {&HLP_BTN_NAME}
      WITH FRAME secu THREE-D.
   
   flist:sensitive IN FRAME secu = no.
   WAIT-FOR CHOOSE OF btn_OK IN FRAME secu OR GO OF FRAME secu.
END.

HIDE MESSAGE NO-PAUSE.
RETURN.



