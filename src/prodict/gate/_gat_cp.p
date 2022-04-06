/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/*--------------------------------------------------------------------

File: prodict/gate/_gat_cp.p

Description:
    
    Asks for the code page, chacks it's validity and 
            
Input-Parameters:
    none

Output-Parameters:
    none
    
Used/Modified Shared Objects:
    user_env[5]     code page if new-value
    user_path       set to ""                           if canceled 
                        or user_path + <reconnect>      if db connected
                        or no new value
    
Author: Tom Hutegger

History:
    D. McMann   10/17/03    Add NO-LOCK statement to _Db find in support of on-line schema add
    D. McMann   99/03/16    Added running _ora_crt.p to verify that 
                            oracle_tablespace file is included in schema holder
    gfs         94/07/25    Insert correct help context
    gfs         94/07/07    fixed text in alert boxes. The lines were
                            too wide for Windows VGA. 94-06-21-037    
    hutegger    94/04/12    creation

                            
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
/*
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }
*/

define variable l_frozen     as   logical         initial false.
define variable not-canned   as   logical no-undo initial false.
define variable cp1          as   character       initial ?.
define variable cp2          as   character       initial ?.
define variable i            as   integer.
define variable modified     as   logical         initial true.

FORM                                                SKIP({&TFM_WID})
  " "
  user_env[5] {&STDPH_FILL} FORMAT "x(80)" COLON 13 
         VIEW-AS FILL-IN SIZE 40 BY 1
	 LABEL "Code Page"
  {prodict/user/userbtns.i}
  WITH FRAME codepage 
  SIDE-LABELS ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " Change Code Page of Non-{&PRO_DISPLAY_NAME} DB ".

/*---------------------------  TRIGGERS  ---------------------------*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
/* This is the only frame used in the GUI environment */
on HELP of frame codepage
   or CHOOSE of btn_Help in frame codepage
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Change_Code_Page_Dlg_Box},
      	       	     	     INPUT ?).
&ENDIF

ON CHOOSE OF btn_cancel IN FRAME codepage
   APPLY "ENDKEY" to FRAME codepage.

ON  WINDOW-CLOSE         OF FRAME codepage
   APPLY "END-ERROR" TO FRAME codepage.

/*----- LEAVE of fill-ins: trim blanks the user may have typed in ---*/
{prodict/gate/gat_cpvl.i
  &frame    = "codepage"
  &variable = "user_env[5]"
  &adbtype  = "_Db._Db-type"
  }  /* checks if user_env[5] contains convertable code page */
  
/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

     {adecomm/okrun.i  
	&FRAME  = "FRAME codepage" 
	&BOX    = "rect_Btns"
	&OK     = "btn_OK" 
	{&CAN_BTN}
	{&HLP_BTN}
     }

find _Db
  where _Db._Db-name = user_dbname
  NO-LOCK no-error.
/* If this is a converted V8 - V9 database we need to verify that 
   oracle_tablespace is included in schema holder   */  
IF AVAILABLE _DB AND _Db._Db-type = "ORACLE" THEN DO:
  RUN "prodict/ora/_ora_crt.p" (RECID(_DB)).  
END.
  
if available _Db 
 then do on error  undo,retry 
         on endkey undo, leave:
  
  assign not-canned = false.
  if dict_rog 
   then message
      "The database is in read-only mode - alterations not allowed."
      view-as alert-box.
   else do:  /* not read-only mode */  
    find _File where _File._File-name = "_Field" 
                 and _File._Owner = "PUB" no-lock.
    if not can-do(_File._Can-Write,userid("DICTDB"))
     then message
       "You do not have permission to use this option."
       view-as alert-box.
     else do:  /* not read-only mode and write-permission*/
      assign l_frozen = false. 
      for each _file of _db where (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
        no-lock
        while not l_frozen: 
        if _file._frozen then assign l_frozen = true. 
        end.
      if l_frozen 
       then message
         "The definitions of one or more tables are frozen! No changes can be made."
         view-as alert-box.
       else not-canned = true.    
      end.     /* not read-only mode and write-permission*/
    end.     /* not read-only mode */      
    
  if not-canned
   then do:
    assign not-canned = false.
    IF connected(user_dbname)
     then message
      "Changing the code page will not convert data"   skip
      "already in the database.  If you have been"     skip
      "writing data to the database using a different" skip
      "code page, changing the code page can corrupt"  skip
      "your data. Refer to the DataServer manual"      skip
      "for additional details."                        skip(1)
      "If you change the code page, the non-"          skip
      "{&PRO_DISPLAY_NAME} database will be disconnected."        skip
      "After the change, you will be prompted"         skip
      "to reconnect it."
      view-as alert-box warning 
      buttons ok-cancel update not-canned.
     else message
      "Changing the code page will not convert data"   skip
      "already in the database.  If you have been"     skip
      "writing data to the database using a different" skip
      "code page, changing the code page can corrupt"  skip
      "your data. Refer to the DataServer manual"      skip
      "for additional details."                        skip(1)
      view-as alert-box warning 
      buttons ok-cancel update not-canned.
    end.

  if not-canned = ?
      then not-canned = false. 

  if not-canned then do:  
      if _DB._Db-type = "SYB10" or _DB._Db-type = "MSSQLSRV" then do:
         if _DB._Db-misc2[8] <> ? then
              assign user_env[5] = _DB._DB-xl-name + "/" + _DB._Db-misc2[8]. 
         else assign user_env[5] = _DB._DB-xl-name + "/".
         end. /* _DB._Db-type = "SYB10" */ 
      else
         assign user_env[5] = _DB._DB-xl-name.

    assign not-canned = FALSE. 

    update
        user_env[5]
        btn_OK 
        btn_Cancel
        {&HLP_BTN_NAME}
        with frame codepage.
  
    assign not-canned = TRUE.
 
    end.     /* not canned yet*/
  
  end.     /* _Db available: on error ... on endkey ...  */
     
hide message        no-pause.
hide frame codepage no-pause.

if user_env[5] = "<internal defaults apply>" then assign user_env[5] = ?.

if not-canned = false 
 then assign user_path = ""
             modified = false.
else if ( _DB._Db-type = "SYB10" or _DB._Db-type = "MSSQLSRV")
 then do:
    i = INDEX (user_env[5], "/").
    if i = 0 then
       assign cp1 = user_env[5]
              cp2 = ?.
    else 
      assign cp1 = SUBSTRING (user_env[5], 1, i - 1)
             cp2 = SUBSTRING (user_env[5], i + 1). 
      if cp2 = "" then cp2 = ?.       
    if cp1 = _DB._DB-xl-name and cp2 = _Db._Db-misc2[8] then
      assign user_path = ""
             modified = false.
  end.
else if user_env[5] = _DB._DB-xl-name
 then assign user_path = ""
             modified  = false.

if modified = true and connected(user_dbname)
 then do:
  disconnect value(user_dbname).
  if "{&WINDOWS-SYSTEM}" = "TTY"
   then assign user_path =  user_path + ",1=usr,_usrscon,1=new,_usrsget,*N".
   else assign user_path =  user_path + ",1=usr,_usrscon,1=new,_guisget,*N".
  end.
  
RETURN.









