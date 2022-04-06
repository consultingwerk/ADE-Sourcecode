/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/* usercold - file freeze/unfreeze program 

   Modified: DLM 07/13/98 Added _Owner to _File Find
   
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE before AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE hint   AS CHARACTER INITIAL ""            NO-UNDO.
DEFINE VARIABLE okay   AS LOGICAL                         NO-UNDO.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 13 NO-UNDO INITIAL [
  /* 1*/ "You do not have permission to freeze or unfreeze tables.",
  /* 2*/ "WARNING: If you make dictionary changes for", /* 32-char filename */
  /* 3*/ "you will have to recompile all procedures referencing it!",
  /* 4*/ "The dictionary is in read-only mode - alterations not allowed.",
  /* 5*/ "", /* reserved */
  /* 6*/ "Are you sure that you want to do this?",
  /* 7*/ "", /* reserved */
  /* 8*/ "Changing the VIEW structure may cause {&PRO_DISPLAY_NAME}/SQL to malfunction.",
  /* 9*/ "It is not recommended that you proceed.",
  /*10*/ "Changing FAST TRACK tables may disable FAST TRACK for this database.",
  /*11*/ "The potential exists to lose *ALL* FAST TRACK data.",
  /*12*/ "Changing the {&PRO_DISPLAY_NAME} meta-schema tables can disable",
  /*13*/ "the dictionary, FAST TRACK, and most application programs."
].

&IF "{&WINDOW-SYSTEM}" begins "MS-Win" &THEN  
&GLOBAL-DEFINE LINEUP 6
&ELSEIF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN  
&GLOBAL-DEFINE LINEUP 7
&ELSE
&GLOBAL-DEFINE LINEUP 8
&ENDIF
FORM
  SKIP({&TFM_WID})
  _File._File-Name LABEL "Table" VIEW-AS TEXT COLON {&LINEUP} 
        SKIP({&VM_WID})
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
  _File._Frozen    VIEW-AS TOGGLE-BOX LABEL "&Frozen" 
        COLON {&LINEUP} 
&ELSE
  _File._Frozen LABEL "Frozen" COLON {&LINEUP}
&ENDIF
  {prodict/user/userbtns.i}
  WITH FRAME freezing 
  CENTERED SIDE-LABELS
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE "Freeze/Unfreeze Table".

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/


/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame freezing
   or CHOOSE of btn_Help in frame freezing
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                                               INPUT {&Freeze_Unfreeze_Table_Dlg_Box},
                                               INPUT ?).
&ENDIF

ON WINDOW-CLOSE OF FRAME freezing
   APPLY "END-ERROR" TO FRAME freezing.


/*============================Mainline code===============================*/

IF dict_rog THEN DO:
  MESSAGE new_lang[4] /* look but don't touch */
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
END.

/*check runtime privileges for _file and _field */
FIND _File WHERE _File._File-name =  "_File"
             AND _File._Owner = "PUB".
FIND _Field OF _File WHERE _Field._Field-name = "_Frozen".
IF   NOT CAN-DO(_File._Can-write,USERID("DICTDB"))
  OR NOT CAN-DO(_Field._Can-write,USERID("DICTDB")) THEN DO:
  MESSAGE new_lang[1] /* no permission */
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

FIND _File WHERE _Db-recid = drec_db AND _File-name = user_env[1]
             AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN" ).

okay = TRUE.
IF _File-Number >= -6 AND _File-Number <= -1 THEN  /* meta-schema */
  MESSAGE new_lang[12] SKIP new_lang[13] SKIP new_lang[6]
    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE okay.
ELSE IF _File-Number >= -29 AND _File-Number <= -7 THEN /* fast track */
  MESSAGE new_lang[10] SKIP new_lang[11] SKIP new_lang[6]
    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE okay.
ELSE IF _File-Number >= -32 AND _File-Number <= -30 THEN /* views */
  MESSAGE new_lang[8] SKIP new_lang[9] SKIP new_lang[6]
    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE okay.
ELSE IF _File-Number > 32767 THEN
    ASSIGN okay = FALSE.    	    	    	    	/* SQL92 views. */

IF NOT okay THEN DO:
  user_path = "".
  RETURN.
END.

/* Adjust the graphical rectangle and the ok and cancel buttons */
{adecomm/okrun.i  
    &FRAME  = "FRAME freezing" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
}
before = _File._Frozen.
DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  DISPLAY _File._File-Name WITH FRAME freezing.
  UPDATE  _File._Frozen 
                btn_OK  btn_Cancel {&HLP_BTN_NAME} WITH FRAME freezing.
END.

IF before AND before <> _File._Frozen THEN DO:
  MESSAGE new_lang[2] '"' + _File-name + '"' SKIP /* change warning */
                new_lang[3]                                               /* recompile warning */
                VIEW-AS ALERT-BOX WARNING BUTTONS OK.
END.

HIDE FRAME freezing NO-PAUSE.
RETURN.
