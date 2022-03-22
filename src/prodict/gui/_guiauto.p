/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/*------------------------------------------------------------------
   _guiauto.p - Editor for auto-connect progress databases.

   Author: Tony Lavinio, Laura Stern

HISTORY:
07/13/00 by dlm - Added format x(12) to lname 20000627004
04/12/00 by dlm - Added support for long db path name
07/14/98 by dlm - Added _Owner for _file finds
06/01/95 by gfs - 94-06-29-042
07/22/94 by gfs - Added mneumonics to buttons.
07/13/94 by gfs - 94-06-28-062
07/12/94 by gfs - 94-06-28-098, 94-06-29-035, 94-06-29-076.
06/23/94 by gfs - 94-06-16-109 Disallow adding of db already connected.
-------------------------------------------------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE BUFFER xdb FOR DICTDB._Db.
DEFINE BUFFER Dbb FOR DICTDB._Db.

/* Form variables */
DEFINE VARIABLE dblist AS CHAR NO-UNDO INITIAL ""
   VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 20 INNER-LINES 6 SCROLLBAR-V.
DEFINE VARIABLE args   AS CHAR NO-UNDO.
DEFINE VARIABLE dbaddr AS CHARACTER NO-UNDO.
DEFINE VARIABLE lname  AS CHARACTER FORMAT "x(12)" NO-UNDO.

DEFINE BUTTON btn_add LABEL "&Add..."    SIZE 13 BY 1.
DEFINE BUTTON btn_mod LABEL "&Modify..." SIZE 13 BY 1.
DEFINE BUTTON btn_del LABEL "&Delete..." SIZE 13 BY 1.
{prodict/misc/filesbtn.i}

/* Miscellaneous */
DEFINE VARIABLE answer   AS LOGICAL          NO-UNDO.
DEFINE VARIABLE changed  AS LOGICAL INIT NO  NO-UNDO.
DEFINE VARIABLE stat  	 AS LOGICAL    	     NO-UNDO.
DEFINE VARIABLE can_do   AS LOGICAL EXTENT 3 NO-UNDO. /* can add/modify/write */
DEFINE VARIABLE num      AS INTEGER          NO-UNDO.
DEFINE VARIABLE ldummy   AS LOGICAL          NO-UNDO.

/* LANGUAGE DEPENDENCIES START */ /*---------------------------------------*/

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 12 NO-UNDO INITIAL [
  /* 1*/ "The dictionary is in read-only mode - alterations not allowed.",
  /* 2*/ "You do not have permission to use this option.",
  /* 3*/ "Add Auto-Connect Record", 
  /* 4*/ "Modify Auto-Connect Record",
  /* 5*/ "Are you sure that you want to remove the connect record for",
  /* 6*/ "Undo all changes made in this dialog box?",
  /* 7*/ "", /* reserved */
  /* 8*/ "You cannot delete an autoconnect record for a connected database.",
  /* 9*/ "This name is already used for a sub-schema or auto-connect record.",
  /*10*/ "Logical name may not be left blank or unknown.",
  /*11*/ "You cannot use the same logical name as the currently selected database.",
  /*12*/ "Physical name may not be left blank or unknown."
].

&GLOBAL-DEFINE COL1 17
&GLOBAL-DEFINE COL2 53
&GLOBAL-DEFINE EDCHRS 51 
&GLOBAL-DEFINE FILLCH 51
&IF "{&OPSYS}" <> "MSDOS" and "{&OPSYS}" <> "WIN32" &THEN
    &SCOPED-DEFINE SLASH /
&ELSE
    &SCOPED-DEFINE SLASH ~~~\
&ENDIF

FORM
   SKIP({&TFM_WID})
   "{&PRO_DISPLAY_NAME}"        AT 2 VIEW-AS TEXT 
   dblist            AT {&COL1}        	                 SKIP({&VM_WIDG})        
   dbaddr      AT 17 FORMAT "x({&PATH_WIDG})" 
	       	     VIEW-AS EDITOR INNER-CHARS 51 INNER-LINES 3 MAX-CHARS 255 SCROLLBAR-VERTICAL 
                 SKIP({&VM_WIDG})
   "CONNECT-"        AT  2 VIEW-AS TEXT 	     
   args              AT 17 VIEW-AS EDITOR 
                     INNER-LINES 3 INNER-CHARS {&EDCHRS} SCROLLBAR-VERTICAL
                     SKIP({&VM_WIDG})
   "NOTE:"           AT  2 VIEW-AS TEXT 
   "For Non-{&PRO_DISPLAY_NAME} databases, use the DataServer      " 
                     AT 17 VIEW-AS TEXT                  SKIP({&VM_WID})
    "utility: Edit Connection Information.      "
                     AT 17 VIEW-AS TEXT                  SKIP({&VM_WID})
   {prodict/user/userbtns.i}

   btn_add     	     AT ROW-OF dblist + 0.5 COLUMN    {&COL2} SKIP({&VM_WID})
   btn_mod     	     AT                               {&COL2} SKIP({&VM_WID})
   btn_del     	     AT                               {&COL2} SKIP({&VM_WID})

   "Databases:"	     AT ROW-OF dblist + 0.7  COLUMN 2  VIEW-AS TEXT

   "Statement"	     AT ROW-OF args   + 0.7  COLUMN 2  VIEW-AS TEXT SKIP({&VM_WID})
   "Parameters:"     AT 2  VIEW-AS TEXT
   "Physical Name:"  AT ROW-OF dbaddr + 0.2  COLUMN 2 VIEW-AS TEXT

   WITH FRAME dbauto 
   CENTERED NO-LABELS 
   DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
   VIEW-AS DIALOG-BOX TITLE "Edit Auto-Connect List".


FORM
   SKIP({&TFM_WID})
   "Logical Name:":t35   AT 2 VIEW-AS TEXT 	  SKIP({&VM_WID})
   lname       	     AT 2 {&STDPH_FILL}   SKIP({&VM_WIDG})
   "Physical Name:":t35  AT 2 VIEW-AS TEXT 	  SKIP({&VM_WID})
   Dbb._Db-addr      AT 2 {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" 
	       	          VIEW-AS FILL-IN SIZE {&FILLCH} BY 1 
   btn_File    	     	      	       	  SKIP({&VM_WIDG})
   "CONNECT-Statement Parameters:":t35  
      	       	     AT 2 VIEW-AS TEXT 	  SKIP({&VM_WID})
   Dbb._Db-comm      AT 2 VIEW-AS EDITOR 
                          SIZE 55 BY 3 SCROLLBAR-VERTICAL
   {prodict/user/userbtns.i}
   WITH FRAME db_mod
   CENTERED NO-LABELS 
   DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
   VIEW-AS DIALOG-BOX.


/* LANGUAGE DEPENDENCIES END */ /*-----------------------------------------*/

/*========================Internal Procedures=============================*/

/*--------------------------------------------------------------------
   Show information on the database selected in the information area.

   Input Parameter:
      p_Name = If ? - We've already go the record, display values 
      	       else - Get the record with this db name and 
      	       	      display the values (it may be "" if no dbs).
---------------------------------------------------------------------*/
PROCEDURE Show_Db:

   DEFINE INPUT PARAMETER p_Name AS CHAR NO-UNDO.

   /* Find db record unless we've got it already */
   IF p_Name <> ? THEN   
      FIND Dbb WHERE Dbb._Db-name = p_Name AND 
      	       	     Dbb._Db-type = "PROGRESS" AND 
      	       	     NOT Dbb._Db-local NO-ERROR.

   IF AVAILABLE Dbb THEN 
     ASSIGN dbaddr = Dbb._Db-addr
            lname  = Dbb._Db-name
            args   = Dbb._Db-comm.
   ELSE 
     ASSIGN dbaddr = ""
            lname  = ""
            args   = "".
   ENABLE dbaddr args WITH FRAME dbauto.
   ASSIGN dbaddr:READ-ONLY IN FRAME dbauto = TRUE
          args:READ-ONLY IN FRAME dbauto = TRUE.
   DISPLAY 
	     dbaddr
      	 args
	 WITH FRAME dbauto.  
   
END.


/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
/*----- HELP -----*/
on HELP of frame dbauto
   or CHOOSE of btn_Help in frame dbauto
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Edit_Auto_Connect_List_Dlg_Box},
      	       	     	     INPUT ?).
on HELP of frame db_mod
   or CHOOSE of btn_Help in frame db_mod
do: 
   IF FRAME db_mod:TITLE = new_lang[3] then
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Add_Auto_Connect_Dlg_Box},
      	       	     	     INPUT ?).
   else
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Modify_Auto_Connect_Dlg_Box},
      	       	     	     INPUT ?).
end.
&ENDIF


/*----- GO or OK in ADD/MODIFY FRAME -----*/
ON GO OF FRAME db_mod
DO:
   DEFINE VAR scr_val AS CHAR               NO-UNDO.
   DEFINE VAR i       AS INT                NO-UNDO. /* counter */
   DEFINE VAR rc      AS LOGICAL INITIAL no NO-UNDO. /* result code */
   DEFINE VAR choice  AS LOGICAL INITIAL no NO-UNDO.

   IF Dbb._Db-addr:SCREEN-VALUE = "" OR
      Dbb._Db-addr:SCREEN-VALUE = ?  THEN DO:
        MESSAGE new_lang[12] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        APPLY "ENTRY" TO Dbb._Db-addr IN FRAME db_mod.
        RETURN NO-APPLY.
   END.
   FILE-INFO:FILE-NAME = (IF SUBSTRING(Dbb._Db-addr:SCREEN-VALUE,LENGTH(Dbb._Db-addr:SCREEN-VALUE) - 2,-1,"CHARACTER":U) NE ".db" THEN 
                          Dbb._Db-addr:SCREEN-VALUE + ".db" ELSE Dbb._Db-addr:SCREEN-VALUE).
   IF FILE-INFO:FULL-PATHNAME EQ ? THEN DO:
     MESSAGE "Database:" Dbb._Db-addr:SCREEN-VALUE "was not found." skip
             "Do you want to add it anyway?" VIEW-AS ALERT-BOX QUESTION
             BUTTONS YES-NO UPDATE choice.
     IF NOT choice THEN DO:
       APPLY "ENTRY" TO Dbb._Db-addr.
       RETURN NO-APPLY.
     END.
   END.
   ASSIGN Dbb._Db-addr:SCREEN-VALUE = REPLACE(Dbb._Db-addr:SCREEN-VALUE, ".db", "")
          dbaddr = Dbb._Db-addr
          scr_val = lname:SCREEN-VALUE IN FRAME db_mod.
   IF scr_val = "" OR scr_val = "?" THEN DO:
      MESSAGE new_lang[10] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      APPLY "ENTRY" TO lname IN FRAME db_mod.
      RETURN NO-APPLY.
   END.
   IF LDBNAME(user_dbname) = lname:SCREEN-VALUE THEN DO:
      MESSAGE new_lang[11] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      APPLY "ENTRY" to lname IN FRAME db_mod.
      RETURN NO-APPLY.
   END.
END.


/*----- ON HIT of CANCEL BUTTON or ENDKEY -----*/
ON CHOOSE OF btn_Cancel IN FRAME dbauto OR ENDKEY OF FRAME dbauto
DO:
   IF NOT changed THEN RETURN.  

   answer = yes.
   MESSAGE new_lang[6] /* Are you sure */
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
   IF NOT answer THEN
      RETURN NO-APPLY.
   ELSE
      changed = no.  /* reset */
END.


/*----- VALUE-CHANGED OF DB LIST -----*/
ON VALUE-CHANGED OF dblist IN FRAME dbauto
   RUN Show_Db (INPUT SELF:SCREEN-VALUE).


/*----- DEFAULT-ACTION (DBL-CLICK) OF DB LIST -----*/
ON DEFAULT-ACTION OF dblist IN FRAME dbauto
   APPLY "CHOOSE" TO btn_mod IN FRAME dbauto.


/*----- LEAVE of LOGICAL NAME IN ADD/MODIFY FRAME -----*/
ON LEAVE OF lname IN FRAME db_mod
DO:
   /* Make sure logical name is valid */
   RUN "adecomm/_valname.p" (INPUT SELF:SCREEN-VALUE, INPUT yes, OUTPUT answer).
   IF NOT answer THEN 
      RETURN NO-APPLY.

   /* Make sure it's unique */
   FIND FIRST xdb WHERE xdb._Db-name = SELF:SCREEN-VALUE
   	       	     	AND RECID(xdb) <> RECID(Dbb) NO-ERROR.
   IF AVAILABLE xdb THEN DO:
      MESSAGE new_lang[9] /* already used */
   	      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN NO-APPLY.
   END.
END.


/*----- LEAVE of UNIX PARMS IN ADD/MODIFY FRAME -----*/
ON LEAVE OF Dbb._Db-comm IN FRAME db_mod
DO:
   IF TRIM(SELF:SCREEN-VALUE) = "?" THEN SELF:SCREEN-VALUE = "".
END.


/*----- HIT OF ADD BUTTON -----*/
ON CHOOSE OF btn_add IN FRAME dbauto 
DO:
   FRAME db_mod:TITLE = new_lang[3].
   DO ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
      CREATE Dbb.

      Dbb._Db-Comm = "".
      lname = "".
      Dbb._Db-addr = "".
      UPDATE lname Dbb._Db-addr 
             btn_File Dbb._Db-Comm
      	     btn_OK btn_Cancel {&HLP_BTN_NAME}
      	     WITH FRAME db_mod.

      ASSIGN
      	 /* Remove any line feeds (which we get on WINDOWS) */
      	 Dbb._Db-Comm = replace (Dbb._Db-Comm, CHR(13), "")
      	 Dbb._Db-type = "PROGRESS"
      	 Dbb._Db-slave = FALSE
      	 Dbb._Db-name = lname
      	 changed = yes.
   
      /* Add new Db to list and show db info */
      stat = dblist:ADD-LAST(Dbb._Db-name) IN FRAME dbauto.
      dblist:SCREEN-VALUE IN FRAME dbauto = Dbb._Db-name.
      RUN Show_Db (INPUT ?).

      ASSIGN
      	 num = num + 1
      	 btn_mod:sensitive IN FRAME dbauto = yes
      	 btn_del:sensitive IN FRAME dbauto = yes.
   END.
END.


/*----- HIT OF MODIFY BUTTON -----*/
ON CHOOSE OF btn_mod IN FRAME dbauto 
DO:
   FRAME db_mod:TITLE = new_lang[4].
   DO ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
      UPDATE lname Dbb._Db-addr btn_File Dbb._Db-comm
      	     btn_OK btn_Cancel {&HLP_BTN_NAME}
      	     WITH FRAME db_mod.

      ASSIGN
      	 /* Remove any line feeds (which we get on WINDOWS) */
      	 Dbb._Db-Comm = replace (Dbb._Db-Comm, CHR(13), "")
	 Dbb._Db-name = lname.
      	 changed = yes.

      /* Update display */
      IF lname ENTERED THEN DO:
      	 stat = dblist:REPLACE(Dbb._Db-name, 
			       dblist:SCREEN-VALUE IN FRAME dbauto).
      	 dblist:SCREEN-VALUE IN FRAME dbauto = Dbb._Db-name.  /* reset choose */
      END.
      Run Show_Db (INPUT ?).
   END.
END.


/*----- HIT OF DELETE BUTTON -----*/
ON CHOOSE OF btn_del IN FRAME dbauto 
DO:
   DEFINE VAR del_name AS CHAR     NO-UNDO. /* Name deleted */

   IF CONNECTED(dblist:screen-value) THEN DO:
      MESSAGE new_lang[8] /* can't delete connected db */
      	 VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN NO-APPLY.
   END.

   DO ON ERROR UNDO,LEAVE:
      MESSAGE new_lang[5] + ' "' + dblist:screen-value + '"?'
      	 VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
      IF answer THEN DO:
      	 ASSIGN del_name = dblist:screen-value.
         IF del_name = dbb._db-name THEN 
            ASSIGN user_dbname = "".
           
         DELETE Dbb.
      	 changed = yes.
   
      	 /* Reset choose to item above one just deleted */
      	 RUN "adecomm/_delitem.p" (INPUT dblist:HANDLE IN FRAME dbauto,
      	       	     	      	  INPUT del_name,
      	       	     	      	  OUTPUT num).
      	 IF num > 0 THEN
      	    RUN Show_Db (INPUT dblist:SCREEN-VALUE IN FRAME dbauto).
      	 ELSE DO:
      	    ASSIGN
      	       btn_mod:sensitive IN FRAME dbauto = no
      	       btn_del:sensitive IN FRAME dbauto = no.
      	    RUN Show_Db (INPUT "").
      	 END.
      END.
   END.
END.

/*----- CHOOSE of FILE BUTTON -----*/
ON CHOOSE OF btn_File in frame db_mod DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT Dbb._Db-addr:handle in frame db_mod /*Fillin*/,
        INPUT "Find Database File"  /*Title*/,
        INPUT "*.db"                /*Filter*/,
        INPUT no                    /*Must exist*/).
   Dbb._Db-addr:SCREEN-VALUE = REPLACE(Dbb._Db-addr:SCREEN-VALUE, ".db", "").
   IF lname:SCREEN-VALUE = ? OR lname:SCREEN-VALUE = "" THEN DO:
     IF R-INDEX(Dbb._Db-addr:SCREEN-VALUE,"{&SLASH}") > 0 THEN
       lname:SCREEN-VALUE = SUBSTRING(Dbb._Db-addr:SCREEN-VALUE, R-INDEX(Dbb._Db-addr:SCREEN-VALUE,"{&SLASH}") + 1, -1, "CHARACTER":U).
     ELSE lname = Dbb._Db-addr:SCREEN-VALUE.
   END.
END.


/*----- LEAVE of PHYSICAL NAME -----*/
ON LEAVE OF Dbb._Db-addr in frame db_mod DO:
   SELF:screen-value = TRIM(SELF:screen-value).
   SELF:screen-value = REPLACE(SELF:screen-value, ".db", "").
END.

/*----- WINDOW CLOSE -----*/
ON WINDOW-CLOSE OF FRAME dbauto
   APPLY "END-ERROR" to FRAME dbauto.
ON WINDOW-CLOSE OF FRAME db_mod
   APPLY "END-ERROR" to FRAME db_mod.


/*============================Mainline code===============================*/

DO FOR DICTDB._File:
   FIND _File WHERE _File._File-name = "_Db"
                AND _File._Owner = "PUB" NO-LOCK.
   IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN DO:
      MESSAGE new_lang[2] VIEW-AS ALERT-BOX ERROR BUTTONS OK. /* no permis. */
      user_path = "".
      RETURN.
   END.
  
   can_do[1] = CAN-DO(_Can-create,USERID("DICTDB")).
   can_do[2] = CAN-DO(_Can-write,USERID("DICTDB")).
   can_do[3] = CAN-DO(_Can-delete,USERID("DICTDB")).
END.

/* Adjust the graphical rectangle and the ok and cancel buttons */
{adecomm/okrun.i  
    &FRAME  = "FRAME dbauto" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
}

/* Adjust the graphical rectangle and the ok and cancel buttons */
{adecomm/okrun.i  
    &FRAME  = "FRAME db_mod" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
}

/* Fill the list of databases and remember the first to set selection.
   Don't count current db (local).
*/
num = 0.
FOR EACH Dbb WHERE Dbb._Db-type = "PROGRESS" AND NOT Dbb._Db-local:
   stat = dblist:ADD-LAST(Dbb._Db-name) IN FRAME dbauto.
   num = num + 1.
END.
FIND FIRST Dbb WHERE Dbb._Db-type = "PROGRESS" AND NOT Dbb._Db-local NO-ERROR.
IF AVAILABLE Dbb THEN 
   dblist = Dbb._Db-name.

IF dblist <> "" THEN DO:
   DISPLAY dblist WITH FRAME dbauto.
   RUN Show_Db (dblist).
END.

DO TRANSACTION ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
   ENABLE
      dblist
      btn_add when can_do[1]
      btn_mod when can_do[2] AND num > 0
      btn_del when can_do[3] AND num > 0
      btn_OK 
      btn_Cancel
      {&HLP_BTN_NAME}
      WITH FRAME dbauto.

   ASSIGN
      ldummy = btn_mod:MOVE-AFTER-TAB-ITEM(btn_add:HANDLE IN FRAME dbauto).
      ldummy = btn_del:MOVE-AFTER-TAB-ITEM(btn_mod:HANDLE IN FRAME dbauto).
   WAIT-FOR CHOOSE OF btn_OK IN FRAME dbauto OR
      GO OF FRAME dbauto
      FOCUS dblist.
END.

HIDE FRAME dbauto NO-PAUSE.
RETURN.



