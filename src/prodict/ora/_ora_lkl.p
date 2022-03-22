/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/ora/_ora_lkl.p   THIS ROUTINE GETS CALLED ONCE PER LINK!

Description:
    gets all the LINKs from the current ORACLE-DB, allows the user to
    select the ones he'd like. If the user selects one or more, we change
    the user_path to commit the transaction and call that routine again
    
Input-Parameters:  
   none
                                     
Output-Parameters: 
    none
    
Used/Modified Shared Objects:
    DICTDBG     alias gets reset for all selected links
    s_ttb_link  creates a record for each selected link
    s_level     level of links: 0 master-slave,      a     level 0
                1 1. children-generation,...        / \
                                                   b   c   level 1
    s_master    name of parent   master(a) = "", master(b) = @a, ...
    s_ldbname   name of current ORACLE-db (usually "z_ora_links")
    
NOTE: Oracle doesn't support multi-level links yet. This code got
      written as if they would. I changed the code just a little, so
      that it doesn't loop into the recursion. If ORACLE ever starts
      to support multi-levels, we need just to de-comment some code
      and delete its "temporary" replacement. (search for: #$%$#)
      
History:
    hutegger    94/09/01    creation
    mcmann      97/11/12    Added view-as dialog-box for non TTY clients
    
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

&SCOPED-DEFINE DATASERVER YES

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

define variable   canned      as logical.
define variable   i           as integer.
define variable   l_master    as character.
define variable   l_result    as logical.
define variable   l_stri      as character.
define variable   l_text1     as character.
define variable   l_text2     as character.
define variable   l_text3     as character.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*define button     btn_presel    label "&PreSel Criteria" {&STDPH_OKBTN}.*/
&ENDIF

define query      qry_link   for   s_ttb_link.
define browse     brw_link   query qry_link
          display s_ttb_link.slctd  no-label     
                  s_ttb_link.name      label "Link-Name" format "x(42)"         
          with size 50 by 10 multiple.
          
form
  " "                                             skip /*({&VM_WIDG})*/
  "Master DB:"  at 2                              skip
  l_master      at 4 format "x(45)"  view-as text skip({&VM_WIDG})
  l_text1       at 2 format "x(50)"  view-as text skip
  l_text2       at 2 format "x(50)"  view-as text skip
  l_text3       at 2 format "x(50)"  view-as text skip({&VM_WIDG})
  brw_link      at 2   
  { prodict/user/userbtns.i
      &othergui = " "
      }
/*      &othergui = "SPACE({&HM_DBTN}) btn_presel" */
 with frame frm_link
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN view-as dialog-box 
    three-d &ENDIF 
  row 2 centered no-labels scrollable
  title "  Links to Distributed Databases  "
  default-button btn_OK cancel-button btn_Cancel.

&UNDEFINE DATASERVER



/*---------------------------  TRIGGERS  ---------------------------*/

&IF "{&WINDOW-SYSTEM}" <> "TTY"
 &THEN
  on  HELP   of             frame frm_link 
   or CHOOSE of btn_Help in frame frm_link
    RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                              INPUT {&Link_Distrib_DB_Dlg_Box},
                              INPUT ?).
 &ENDIF
   
/*----- GO or choose of OK BUTTON -----*/
on GO of frame frm_link do:

  do with frame frm_link:
  
    do i = 1 to brw_link:num-selected-rows:
      l_result = brw_link:fetch-selected-row(i).
      if available s_ttb_link then s_ttb_link.slctd = true.
      end.  /* i = 1 to brw_link:num-selected-rows */
      
    end.  /* with frame frm_link */
  
  end.
  
/*----- WINDOW-CLOSE of dialog -----*/
on window-close of frame frm_link
  apply "END-ERROR" to frame frm_link.


/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

/* Run time layout for button areas. */
{adecomm/okrun.i  
   &FRAME  = "frame frm_link" 
   &BOX    = "rect_Btns"
   &OK     = "btn_OK" 
   {&CAN_BTN}
   {&HLP_BTN}
}

/****** ask user for preselection-criteria ******/
/************* for the current link *************/

assign
  s_name  = s_name-hlp
  s_owner = s_owner-hlp
  s_qual  = s_qual-hlp
  s_type  = s_type-hlp
  s_vrfy  = s_vrfy-hlp
  l_text1 = "Below is the list of available links to further"
  l_text2 = "distributed DBs. Select the links from which you"
  l_text3 = "want to pull schema information."
  canned  = TRUE.
  
/* presel.i executes a LEAVE when the user chose CANCEL
 * so we put everything into an endless-loop and LEAVE out of it
 * either in presel.i when canceld (-> canned = TRUE) or after 
 * returning from presel.i (-> canned = FALSE).
 */
repeat while TRUE:
  {prodict/gate/presel.i
    &frame  = "frm_link"
    &link   = "s_lnkname"
    &master = "s_master"
    }
  assign canned = FALSE.
  leave.
  end.

if not canned 
 then find first s_ttb_link
  where s_ttb_link.level  = s_level
  and   s_ttb_link.master = s_master
  and   s_ttb_link.name   = s_lnkname
  no-error.
if not available s_ttb_link
 then do:
  assign user_path = "*C,_ora_lkx". /* clean-up */
  leave.
  end.

assign
  s_ttb_link.presel-n = s_name
  s_ttb_link.presel-o = s_owner
  s_ttb_link.presel-q = s_qual
  s_ttb_link.presel-t = s_type
  s_ttb_link.presel-v = s_vrfy
  s_ttb_link.srchd    = true
  l_master            = s_master + s_lnkname.

/* use presel-criteria of local db as default-values */
if l_master = ""
 then assign 
  s_owner-hlp         = s_owner
  s_name-hlp          = s_name
  s_type-hlp          = s_type
  s_qual-hlp          = s_qual.

/*** only "public" links are usefull -> get user-id of "public" ***/
/* during development we found out that ORACLE doesn't support
 * multiple layers of links. So <table>@<link1>@<link2> is illegal.
 * So we inserted an additional if-condition here to create new
 * s_ttb_link-records only if also the level < 2. If ORACLE ever
 * supports multi-level links, we just need to remove that line.
 */
find first DICTDBG.oracle_users
  where DICTDBG.oracle_users.name = "public"
  no-lock no-error.
if available DICTDBG.oracle_users
 /* and s_level < 1    / * no multi-level-links supported by ORACLE */
 then do:  /* found user "public" */

/******** create new s_ttb_link-records *********/

  for each DICTDBG.oracle_links fields(owner# name)
    where DICTDBG.oracle_links.owner# = DICTDBG.oracle_users.user#
    no-lock:
  
  /**//* if not can-find(first sysobj$@<link-name>) then next. */
  /* since we are not connected to that link-db, we can't look */
  /* at it's schema, therefore we can't make this validation   */

  /* check if there is already a link with this name, if yes skip 
   * the current, otherwise create a new s_ttb_link record
   */
    find first s_ttb_link
      where s_ttb_link.name = "@" + DICTDBG.oracle_links.name
      no-lock no-error.
    if not available s_ttb_link
     then do:
      create s_ttb_link.
      assign
        s_ttb_link.level     = s_level + 1
        s_ttb_link.master    = l_master
        s_ttb_link.name      = "@" + DICTDBG.oracle_links.name
        s_ttb_link.srchd     = false
        s_ttb_link.slctd     = false.
      end.
    end.
  end.     /* found user "public" */
  
/************* leave if no new links ************/

if can-find(first s_ttb_link
 where s_ttb_link.level  = s_level + 1
 and   s_ttb_link.master = l_master)
 then do:  /* there are links in this db */

  /********** allow user to select links **********/

  open query qry_link for each s_ttb_link
            where s_ttb_link.level  = s_level + 1
            and   s_ttb_link.master = l_master.

  assign canned  = true.

  if l_master = ""
   then display
    "<Local DB>" @ l_master
    l_text1
    l_text2
    l_text3
    with frame frm_link.
   else display
    substring(l_master
             ,max(1,length(l_master,"character") - 45)
             ,-1
             ,"character") @ l_master
    l_text1
    l_text2
    l_text3
    with frame frm_link.

  enable 
    brw_link
    btn_OK
    btn_Cancel
    {&HLP_BTN_NAME}
    with frame frm_link.
/*  &IF "{&WINDOW-SYSTEM}" <> "TTY"
 *   &THEN
 *    btn_presel
 *   &ENDIF
 *  with frame frm_link.
 */
 
  RUN adecomm/_setcurs.p ("").

  do on endkey undo, leave:
    wait-for go of frame frm_link.
    assign canned = false.
    end.
  
  RUN adecomm/_setcurs.p ("WAIT").

  hide frame frm_link.

  if canned
   then do:
    assign user_path = "*C,_ora_lkx". /* clean-up */
    leave.
    end.


  /* we want to be able to identify objects that didn't get compared
   * because the user didn't select them or because they don't exist
   
  /********* get rid of non-selected links *********/

  for each s_ttb_link
    where s_ttb_link.level  = s_level + 1
    and   s_ttb_link.master = l_master:
    if s_ttb_link.slctd = false
     then delete s_ttb_link.
    end.     /* for each s_ttb_link */
   */
   
  end.     /* there are links in this db */


/* we are done with this link, lets do the next one (srchd = false)
 * if there aren't anymore, we continue to the next step, wich is pulling the
 * object-names into the gate-work temp-table
 */

/* the following section is in comments because ORACLE doesn't support
 * multi-level links. So we don't have to ask the user for further links
 * in all of the currently new selected links, but just for their
 * preselection-criterias, which we do in the code-piece after this
 * commented-out part                                       #$%$#
find first s_ttb_link
  where s_ttb_link.slctd  = TRUE
  and   s_ttb_link.srchd  = FALSE
  no-lock no-error.
if not available s_ttb_link
 then do:  /* done with link-selection -> pull object-info */

  for each s_ttb_link:
    assign s_ttb_link.srchd  = FALSE.       /* init for next step: */
    end.                                    /*    pull object-info */

  find first s_ttb_link
    where s_ttb_link.slctd  = TRUE
    no-lock no-error.
  if available s_ttb_link
   then do:
    assign
      user_path = "*C,_ora_lkc,_ora_lkg"       /* pull object-info */
      s_level   = s_ttb_link.level
      s_master  = s_ttb_link.master
      s_lnkname = s_ttb_link.name.
    if connected(s_ldbname)
     then disconnect value(s_ldbname) /*no-error*/.
    do transaction:
      find first DICTDB._Db
        where DICTDB._Db._Db-name = s_ldbname
        and   DICTDB._Db._Db-type = "ORACLE".
      assign DICTDB._Db._Db-misc2[8] = s_master + s_lnkname.
        user_path               = "*C,_ora_lkg"       /* pull object-info */
      end.     /* transaction */
    end.
    
   else assign user_path = "*C,_ora_lkx". /* clean-up */

  end.     /* done with link-selection -> pull object-info */

 else do:  /* look for links in next selected link */

  assign
    s_level   = s_ttb_link.level
    s_master  = s_ttb_link.master
    s_lnkname = s_ttb_link.name.

  if connected(s_ldbname)
   then disconnect value(s_ldbname) /*no-error*/.

  do transaction:
    find first DICTDB._Db
      where DICTDB._Db._Db-name = s_ldbname
      and   DICTDB._Db._Db-type = "ORACLE".
    assign DICTDB._Db._Db-misc2[8] = s_master + s_ttb_link.name.
    end.     /* transaction */

  assign  user_path = "*C,_ora_lkc,_ora_lkl".  /* get next links */

  end.     /* look for links in next selected link */
 * here is the end of the commented-out part. If ORACLE ever decides
 * to support multi-levels just remove the following lines and decomment
 * the upper section                                        #$%$#
 */


/* if there are links, try to create "z_ora_links" _db */
find first s_ttb_link
  where s_ttb_link.slctd  = TRUE
  and   s_ttb_link.level  > 0
  no-error.
if available s_ttb_link
 then do:
  assign user_path = "*C".
  run prodict/ora/_ora_lkz.p.
  if user_path = ""
   then do:
    assign user_path = "*C,_ora_lkx". /* clean-up */
    leave.
    end.
  end.


/* ask for the preselection-criteria for each selected link */
for each s_ttb_link
  where s_ttb_link.slctd  = TRUE
  and   s_ttb_link.srchd  = FALSE:
  assign
    s_name  = s_name-hlp
    s_owner = s_owner-hlp
    s_qual  = s_qual-hlp
    s_type  = s_type-hlp
    canned  = TRUE.
  /* presel.i executes a LEAVE when the user chose CANCEL
   * so we put everything into an endless-loop and LEAVE out of it
   * either in presel.i when canceld (-> canned = TRUE) or after 
   * returning from presel.i (-> canned = FALSE).
   */
  repeat while TRUE:
    {prodict/gate/presel.i
      &frame  = "frm_link"
      &link   = "s_ttb_link.name"
      &master = "s_ttb_link.master"
      }
    assign canned = FALSE.
    leave.
    end.
  if not canned
   then assign
    s_ttb_link.presel-n = s_name
    s_ttb_link.presel-o = s_owner
    s_ttb_link.presel-q = s_qual
    s_ttb_link.presel-t = s_type
    s_ttb_link.presel-v = s_vrfy
    s_ttb_link.srchd    = true.
   else do:
    assign user_path = "*C,_ora_lkx". /* clean-up */
    leave.
    end.
  end.
  
for each s_ttb_link
  where s_ttb_link.slctd  = TRUE:
  assign s_ttb_link.srchd = FALSE. /* init for next step: */
  end.                             /*    pull object-info */

find first s_ttb_link
  where s_ttb_link.slctd  = TRUE
  no-lock no-error.
if available s_ttb_link
 and not canned
 then do:

  assign
    user_path = "*C,_ora_lkc,_ora_lkg"    /* pull object-info */
    s_level   = s_ttb_link.level
    s_master  = s_ttb_link.master
    s_lnkname = s_ttb_link.name.

  if s_level > 0
   then do:  /* only if s_ttb_link is for linked db */

    if connected(s_ldbname)
     then disconnect value(s_ldbname) /*no-error*/.

    do transaction:
      find first DICTDB._Db
        where DICTDB._Db._Db-name = s_ldbname
        and   DICTDB._Db._Db-type = "ORACLE".
      assign DICTDB._Db._Db-misc2[8] = s_master + s_lnkname.
      end.     /* transaction */

    end.     /* only if s_ttb_link is for linked db */

  end.
    
 else assign user_path = "*C,_ora_lkx". /* clean-up */
/* end of "temporary" replacement-code, that needs do get deleted,
 * as soon as ORACLE supports multi-level links             #$%$#
 */


/*------------------------------------------------------------------*/
