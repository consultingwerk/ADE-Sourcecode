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

/*----------------------------------------------------------------------------

File: _dictg.p

Description:   
   This is the mainline code for the GUI version of the dictionary.
 
Author: Laura Stern

Date Created: 01/28/92 
Modified Date:  11/27/96    kkelley  Removed labels under icons in dictionary for WIN95
                                     Code commented out has WIN95 at the beginning
                05/19/99 Mario B.  Adjust Width Field browser integration.
----------------------------------------------------------------------------*/

&SCOPED-DEFINE DICTG dictg
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i      "new shared"}
{prodict/user/uservar.i "new"       }
&UNDEFINE DICTG 
{adedict/brwvar.i       "new shared"}
{adedict/capab.i                    }
{adedict/uivar.i        "new shared"}
{adedict/menu.i         "new shared"}
{adecomm/cbvar.i        "new shared"}
{adedict/DB/dbvar.i     "new shared"}
{adedict/IDX/idxvar2.i  "new shared"}
{prodict/fhidden.i}
{prodict/gui/widthvar.i "new shared"} 
/*
 *    The global var h_ade_tool is maintained in adecomm/adestds.i.
 *    This is here just as reminder because the Dictionary main
 *    routine (this one) does not directly include it. So we must
 *    define it separately here.
 *     
 * */
Define New Global Shared Var h_ade_tool as handle no-undo.

Define var capab     as char     NO-UNDO.
Define var dbnum     as integer  NO-UNDO.
Define var dbcnt     as integer         NO-UNDO.
Define var istrans   as logical  initial TRUE. /* not no-undo! */
Define var wid       as decimal  NO-UNDO.
Define var ht        as decimal  NO-UNDO.
define var wid2      as decimal  no-undo.
Define var ade_tool  as char     NO-UNDO.
Define var supw_sav  as logical  NO-UNDO.

/* Variables needed for Taskbar orientation check */
DEFINE VARIABLE TBOrientation AS CHARACTER NO-UNDO.
DEFINE VARIABLE TBHeight      AS INTEGER   NO-UNDO.
DEFINE VARIABLE TBWidth       AS INTEGER   NO-UNDO.
DEFINE VARIABLE AutoHide      AS LOGICAL   NO-UNDO.

/* For keeping track of disabled widgets on running another ADE tool. */
Define temp-table widg_list
   field h_widget as widget-handle.
   
/* For keeping track of # dbs connected on running another ADE tool. */
Define var save_numdbs as integer  NO-UNDO.


/*===========================Startup Frame Defs==============================*/

/* This stuff must be out here (scoped to .p rather than in the 
   Startup_Options internal procedure) in order to use the global
   color variable for frame's graphics.
*/
Define var choice as char NO-UNDO init "Connect"
   view-as RADIO-SET 
   RADIO-BUTTONS  "Connect to an &Existing Database",  "Connect",
                            "&Create a New Database",                "Create",
                            "Continue with &No Database",        "Continue".
                              
FORM
   SKIP({&TFM_WID})
   "There is no database connected."  at 2 view-as TEXT SKIP({&VM_WIDG})
   choice                                            at 2      
   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}
   with frame startup 
   no-labels default-button s_btn_OK cancel-button s_btn_Cancel 
   view-as DIALOG-BOX TITLE "Dictionary Startup".

/* This is the frame for the logo window that comes up to show the
   user that something's happening on startup so we can delay viewing
   of window till the last minute and avoid flashing.
*/
Define image dict_icon FILE "adeicon/dict%".
Define var loading as char NO-UNDO init "Loading..." format "x(10)".
FORM
   SKIP({&TFM_WID})
   SPACE(10) dict_icon SPACE({&HM_WIDG}) loading SPACE(9)
   SKIP({&TFM_WID})
   with frame logo no-labels.
   

/*================= Triggers (and Related Internal Procedures)===============*/

{adedict/brwtrig.i}   /* browse window triggers */
{adedict/menutrig.i}  /* menu triggers */
{prodict/gui/widttrig.i}  /* Adjust SQL Width window triggers */

/*===========================Internal Procedures=============================*/

/*------------------------------------------------------------------------ 
   Make it easy on startup when there is no current database, by prompting
   the user to create or connect a database.  Use "choice" flag instead
   of performing actions in triggers just so that the startup dialog box
   will disappear before the connect or create boxes appear.  It looks
   a bit cleaner.

   Return: If user wants to exit the dictionary return "exit" else "".
------------------------------------------------------------------------*/
PROCEDURE Startup_Options:

   Define var retval as char NO-UNDO.

   /*----- HELP -----*/
   on HELP of frame startup OR choose of s_btn_Help in frame startup
      RUN "adecomm/_adehelp.p" 
               ("dict", "CONTEXT", {&Startup_Options_Dlg_Box}, ?).


   /*----- WINDOW CLOSE -----*/
   on window-close of frame startup 
      apply "END-ERROR" to frame startup.      

   /* Adjust for standard graphic layout. */
   {adecomm/okrun.i
      &FRAME = "frame startup"
      &BOX   = s_rect_Btns
      &OK    = s_btn_OK
      &HELP  = s_btn_Help}

   retval = "exit".
   do on ERROR undo, leave  on ENDKEY undo, leave:
      update 
               choice s_btn_OK s_btn_Cancel s_btn_Help 
               with frame startup.
      retval = "".
   end.

   if retval <> "exit" then  /* user didn't close window or Cancel */
   do:
      if choice = "create" then
         run adedict/DB/_newdb.p.
      else if choice = "connect" then
         run adedict/DB/_connect.p (INPUT ?).
      /* else continue */
   end.

   return retval.
end.


/*------------------------------------------------------------------------ 
   The user has chosen a tool from the tool menu.  Before running it
   we have to make sure any transaction is completed and get out of
   the transaction block.  
------------------------------------------------------------------------*/
PROCEDURE Prepare_For_ADE_Tool_Run:

Define INPUT PARAMETER p_ProgName as char NO-UNDO.

   assign
      ade_tool = p_ProgName  /* Set a variable scoped to .p */
      s_ActionProc = "Run_ADE_Tool".

   if s_DictState = {&STATE_NO_DB_SELECTED} then
      /* We have no database so there's no transaction.  But break
               out of the wait-for anyway.  If the other tool connects
               to a database, we must be back in the repeat loop so we
               can run _dcttran.p.
      */
      apply "U1" to frame browse.
   else do:
      /* Cause transaction to break (the user can save or not)
               and then do the ADE Tool thing.
      */
      s_Trans = {&TRANS_ASK_AND_DO}.
      apply "U2" to frame browse.
   end.
END.


/*------------------------------------------------------------------------ 
   Disable the dictionary, run another ADE tool and then reenable
   myself.
------------------------------------------------------------------------*/
PROCEDURE Run_ADE_Tool:

   /*----- Disable Dictionary -----*/
   run disable_widgets.

   /*----- Run the tool -----*/
   run VALUE(ade_tool).

   /*---- Reenable Dictionary -----*/
   run enable_widgets.

END.

/*------------------------------------------------------------------------ 
   Disable the Dictionary.
------------------------------------------------------------------------*/
PROCEDURE disable_widgets:
   Define var widg           as widget-handle NO-UNDO.

   /*----- Disable the dictionary -----*/

   /* Delete property windows */
    run adedict/_delwins.p (INPUT yes).

   /* Disable menu bar.  This only does top level menu items */
   menu s_mnu_Dict:sensitive = no.

   /* Reset this to what it was when dict started */
   session:suppress-warnings = supw_sav.
   
   /* Disable any visible and enabled widgets. Keep track of the widget handles,
      so we can reenable them later.
   */
   widg = frame browse:first-child.  /* this will be a field group */
   widg = widg:first-child.
   
   /* First clear the list */
   for each widg_list:
      delete widg_list.
   end.
   
   do while widg <> ?:
      if widg:visible = yes AND widg:sensitive = yes then
      do:
         widg:sensitive = no.
         create widg_list.   
         widg_list.h_widget = widg.
      end.
      widg = widg:next-sibling.
   end.

   /* Unset global active ade tool procedure handle. */
   assign h_ade_tool = ?.
   
   /* Save # dbs connected. */
   save_numdbs = NUM-DBS.

END.


/*------------------------------------------------------------------------ 
   Enable the Dictionary.
------------------------------------------------------------------------*/
PROCEDURE enable_widgets:
   Define var widg           as widget-handle NO-UNDO.
   Define var name         as char          NO-UNDO.
   Define var all_conn  as logical       NO-UNDO init yes.
   Define var ix             as integer       NO-UNDO.

   /*---- Reenable Dictionary -----*/

   /* Set global active ade tool procedure handle to Dictionary. */
   assign h_ade_tool = this-procedure.

   /* Reenable menu bar */
   current-window = s_win_Browse.
   menu s_mnu_Dict:sensitive = yes.

   /* Reenable any disabled widgets */
   for each widg_list:
      widg_list.h_widget:sensitive = yes.
   end.
   
   /* Reset session attribute, in case the other tool clobbered it. */
   assign
      session:system-alert-boxes = yes
      session:suppress-warnings = yes.


    /* Clear the whole cache and start again. */  
    assign
         s_lst_Dbs:LIST-ITEMS in frame browse = ""
         s_DbCache_Cnt        = 0
         s_DbCache_Pname      = ""
         s_DbCache_Holder     = ""
         s_DbCache_Type       = "".

   run adedict/DB/_getdbs.p.

   /* Reset database selection to whatever DICTDB is now or the first
    * entry in the list.
    * If DICTDB is of foreign type we set DICTDB to its schemaholder
    */
   if s_lst_Dbs:NUM-ITEMS in frame browse > 0 then
   do:
      if DBTYPE("DICTDB") <> "PROGRESS"
       then do:
        assign
          dbnum = s_lst_Dbs:LOOKUP( " " 
                                  + LDBNAME("DICTDB")
                                  + "("
                                  + SDBNAME("DICTDB")
                                  + ")") in frame browse.
        CREATE ALIAS DICTDB FOR DATABASE VALUE(SDBNAME("DICTDB")).
        end.
       else assign
        dbnum = s_lst_Dbs:LOOKUP(LDBNAME("DICTDB")) in frame browse.
      if dbnum = 0 then dbnum = 1.
      name = s_lst_Dbs:entry(dbnum) in frame browse.
      s_lst_Dbs:screen-value in frame browse = name.
      display name @ s_DbFill with frame browse.
   end.
   else
      display "" @ s_DbFill with frame browse.

   /* Switch to the new database (or no database).  
      This will reset s_CurrDb, fix browse window, menu graying etc.
      If previously connected db is still connected, alot of this is
      redundant - but this is the cleanest way to do it.
   */
   s_ask_gateconn = no.
   run adedict/DB/_switch.p.
END.



/*============================= Mainline code ================================*/


do ON STOP UNDO, LEAVE:
   /* Set up triggers or gray pieces of standard tool menu.  It also checks
      to see if Dictionary is already running.
   */
   {adecomm/toolrun.i &MENUBAR               = "s_mnu_Dict"
                      &EXCLUDE_DICT          = yes 
                      &DISABLE_WIDGETS_PROC  = Prepare_For_ADE_Tool_Run
                      &DISABLE_ONLY          = yes
   }
   if tool_bomb then return.  /* Dictionary is already running so quit */

   /* Set global active ade tool procedure handle to Dictionary. */
   assign h_ade_tool = this-procedure.

   pause 0 before-hide.
   assign
      supw_sav = session:suppress-warnings /* save current value */
      session:suppress-warnings = yes /*no warnings on platform specific funcs*/
      session:system-alert-boxes = yes.
   use "" NO-ERROR.  /* resets to startup default file directory */
   
   /* Create the dictionary browse window */
   create window s_win_Browse 
      assign
         x = 0
         y = 20
         scroll-bars = no
         title = "Data Dictionary"
         menubar = MENU s_mnu_Dict:HANDLE
         status-area = no
         message-area = no
   
      triggers:
         on window-close do:
            run Do_Exit.      /* in menutrig.i */
            return no-apply.  /* to avoid beep */
         end.
      end triggers.

      IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":U THEN DO: 
         ASSIGN TBOrientation= ""
            TBHeight = 0
            TBWidth = 0.
         RUN adeshar/_taskbar.p (OUTPUT TBOrientation, OUTPUT TBHeight,
                                 OUTPUT TBWIdth,       OUTPUT AutoHide).
    
         IF NOT AutoHide THEN DO:
            IF TBOrientation = "LEFT":U AND s_win_Browse:X <= TBWidth THEN
               ASSIGN s_win_Browse:X = TBWidth.
            IF TBOrientation = "TOP":U THEN DO:
               IF s_win_Browse:Y <= TBHeight THEN s_win_Browse:Y = TBHeight.
            END.
            IF TBOrientation = "BOTTOM" AND s_win_Browse:Y + s_win_Browse:HEIGHT-P > SESSION:HEIGHT-P - TBHeight THEN DO:
               s_win_Browse:Y = s_win_Browse:Y - ((s_win_Browse:Y + s_win_Browse:HEIGHT-P) - (SESSION:HEIGHT-P - TBHeight)).
               if s_win_Browse:Y < 0 then s_win_Browse:y = 20.   
            END.
            IF TBOrientation = "RIGHT" AND s_win_Browse:X + s_win_Browse:WIDTH-P > SESSION:WIDTH-P - TBWidth THEN DO:
               s_win_Browse:X = s_win_Browse:X - ((s_win_Browse:X + s_win_Browse:WIDTH-P) - (SESSION:WIDTH-P - TBWidth)).
               if s_win_Browse:X < 0 then s_win_browse:X = 0.
            end.
         END. /* if NOT AutoHide */
      END. /* if SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" */

   assign
      frame browse:parent = s_win_Browse
      s_Res = s_win_Browse:load-icon("adeicon/dict%").
   
   /* Resize the window to fit the browse frame */
   assign
      ht = frame browse:height-chars
      wid = frame browse:width-chars
      wid2 = s_win_browse:width-chars.
   if wid > wid2 then
      assign s_win_Browse:width-chars = wid
             s_win_Browse:max-width = wid. 
   else
       assign frame browse:width-chars = wid2.
  
   assign s_win_Browse:height-char = ht
          s_win_browse:max-height = ht.
 
   create window s_win_Logo
      assign
         x = 150
         y = 100
         scroll-bars = no
         title = "Data Dictionary"
         status-area = no
         message-area = no.
 
   IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":U THEN DO: 
 
      IF NOT AutoHide THEN DO:
         IF TBOrientation = "LEFT":U AND s_win_Logo:X <= TBWidth THEN
            ASSIGN s_win_Logo:X = TBWidth + 150.
         IF TBOrientation = "TOP":U THEN DO:
            IF s_win_Logo:Y <= TBHeight THEN s_win_Logo:Y = TBHeight + 50.
         END.
         IF TBOrientation = "BOTTOM" AND s_win_Logo:Y + s_win_Logo:HEIGHT-P > SESSION:HEIGHT-P - TBHeight THEN
            s_win_Logo:Y = s_win_Logo:Y - ((s_win_Logo:Y + s_win_Logo:HEIGHT-P) + (SESSION:HEIGHT-P - TBHeight)).
         IF TBOrientation = "RIGHT" AND s_win_Logo:X + s_win_Logo:WIDTH-P > SESSION:WIDTH-P - TBWidth THEN
            s_win_Logo:X = s_win_Logo:X - ((s_win_Logo:X + s_win_Logo:WIDTH-P) - (SESSION:WIDTH-P - TBWidth)).
      END. /* IF NOT AutoHide */
   END. /* IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" */
  
 
   /* Resize the window to fit the logo frame */
   assign
      ht = frame logo:height-chars
      wid = frame logo:width-chars
      s_win_Logo:height-chars = ht
      s_win_Logo:width-chars = wid
      s_win_Logo:max-height = ht
      s_win_Logo:max-width = wid.
   
   current-window = s_win_Logo.
   session:immediate-display = yes.
   display dict_icon loading with frame logo.
   run adecomm/_setcurs.p ("WAIT").
   
   
   /* Determine if we are in read-only mode  */
   do ON ERROR UNDO:   /* do the little istrans trick */
      istrans = false.
      undo, leave.
   end.
   
   s_ReadOnly = (istrans OR (PROGRESS = "Query") OR (PROGRESS = "Run-Time")).
   
   /* Set up the browse combo boxes. This enables the fill-ins and lists. */
   {adecomm/cbdown.i &Frame  = "frame browse"
                     &CBFill = "s_DbFill"
                     &CBList = "s_lst_Dbs"
                     &CBInit = """"}
   
   {adecomm/cbdown.i &Frame  = "frame browse"
                     &CBFill = "s_TblFill"
                     &CBList = "s_lst_Tbls"
                     &CBInit = """"}
   
   {adecomm/cbdown.i &Frame  = "frame browse"
                     &CBFill = "s_SeqFill"
                     &CBList = "s_lst_Seqs"
                     &CBInit = """"}
   
   {adecomm/cbdown.i &Frame  = "frame browse"
                     &CBFill = "s_FldFill"
                     &CBList = "s_lst_Flds"
                     &CBInit = """"}
   
   {adecomm/cbdown.i &Frame  = "frame browse"
                     &CBFill = "s_IdxFill"
                     &CBList = "s_lst_Idxs"
                     &CBInit = """"}
   assign
      /* Activate remaining widgets (i.e., buttons) in the browse window. All 
         are active even though, depending on what`s selected, some may be 
               hidden.
      */ 
      s_icn_Dbs:sensitive  in frame browse = yes
      s_icn_Tbls:sensitive in frame browse = YES
      s_icn_Seqs:sensitive in frame browse = yes
      s_icn_Flds:sensitive in frame browse = yes
      s_icn_Idxs:sensitive in frame browse = yes
   
      /* Make most of things invisible to avoid flashing on startup. Leave
         table stuff visible for now until we see if we've got a database
         or not. 
      */
      
      s_SeqFill:hidden    in frame browse = yes
      s_lst_Seqs:hidden   in frame browse = yes
      s_icn_Flds:hidden   in frame browse = YES
      s_FldFill:hidden    in frame browse = yes
      s_lst_Flds:hidden   in frame browse = yes
      s_icn_Idxs:hidden   in frame browse = YES
      s_IdxFill:hidden    in frame browse = yes
      s_lst_Idxs:hidden   in frame browse = yes
   
      s_btn_Create:hidden in frame browse = yes
      s_btn_Props:hidden  in frame browse = yes
      s_btn_Delete:hidden in frame browse = yes.

   IF SESSION:PIXELS-PER-COL = 6 AND SESSION:PIXELS-PER-ROW = 21 THEN
     /* Japanese Windows */
     ASSIGN s_icn_dbs:Y in frame browse  = s_icn_dbs:Y in frame browse - 10
            s_icn_Tbls:Y in frame browse = s_icn_dbs:Y in frame browse
            s_icn_Seqs:Y in frame browse = s_icn_dbs:Y in frame browse
            s_icn_Flds:Y in frame browse = s_icn_dbs:Y in frame browse
            s_icn_Idxs:Y in frame browse = s_icn_dbs:Y in frame BROWSE .  
 
   assign s_DbLbl2:screen-value in frame browse = s_DbLbl2.
   /* Set up the menu/button graying tables. */
   run adedict/_brwgray.p (INPUT true).
   
   /* Fills the browse select list and set s_CurrDb. */
   run adedict/DB/_getdbs.p.
   dbcnt = s_lst_Dbs:NUM-ITEMS in frame browse.
   if dbcnt > 0 then
   do:
      if DBTYPE("DICTDB") <> "PROGRESS"
       then do:
        assign
          dbnum = s_lst_Dbs:LOOKUP( " " 
                                  + LDBNAME("DICTDB")
                                  + "("
                                  + SDBNAME("DICTDB")
                                  + ")") in frame browse.
        CREATE ALIAS DICTDB FOR DATABASE VALUE(SDBNAME("DICTDB")).
        end.
       else assign
        dbnum = s_lst_Dbs:LOOKUP(LDBNAME("DICTDB")) in frame browse.
      if dbnum = 0 then dbnum = 1.
      
      /* if the current schema is a schema-holder for a foreign db
         and there are no user-defined tables in it, default to the
         foreign db <hutegger 94/06> unless this module doesn't support
         that gateway (los 12/28/94) 
      */
      if    dbnum + 1 <= dbcnt
        AND s_dbcache_type[dbnum]      = "PROGRESS"
        AND s_dbcache_type[dbnum + 1] <> "PROGRESS"
        AND CAN-DO(GATEWAYS, s_dbcache_type[dbnum + 1])
        then RUN adedict/_dictfdb.p (INPUT-OUTPUT dbnum).
                                 /* ev. select schema of foreign db */  
      
      assign
         s_CurrDb = s_lst_Dbs:ENTRY(dbnum) in frame browse
         s_lst_Dbs:screen-value in frame browse = s_CurrDb.
   end.
   else 
      assign
         s_icn_Tbls:hidden in frame browse = YES
         s_TblFill:hidden  in frame browse = yes
         s_lst_tbls:hidden in frame browse = yes
         s_icn_Seqs:hidden in frame browse = yes.
   
   s_DbFill:screen-value in frame browse = s_CurrDb.
   ASSIGN fhidden = no.
   
   /* Initialize dirty flag */
   {adedict/setdirty.i &Dirty = "false"}.
   
   /* Make it very apparent that we're in read only modes so user knows why
      things are grayed out.
   */
   if s_ReadOnly then
      if istrans then
         message "Note: The dictionary is in read-only mode since" SKIP
                 "you are in the middle of a transaction."
            view-as ALERT-BOX INFORMATION buttons OK.
      else
         message "Note: Because of the version of PROGRESS you are" SKIP
                 "using, the dictionary is in read-only mode."
            view-as ALERT-BOX INFORMATION buttons OK.
   
   /* Make it easy on startup when there is no current database, by 
      prompting the user to create or connect a database. 
   */
   if s_CurrDb = "" then
   do:
      /* remove wait cursor while in dlg */
      run adecomm/_setcurs.p ("").  
      display "" @ loading with frame logo.
   
      run Startup_Options.
      if RETURN-VALUE = "exit" then
      do:
         delete widget s_win_Logo.
         delete widget s_win_Browse.
         return.
      end.
   
      display "Loading..." @ loading with frame logo.
      run adecomm/_setcurs.p ("WAIT"). 
   end.
   
   /* This causes all kinds of work to be done based on the currently
      selected database (or no database).  s_DictState will be set. */
   s_ask_gateconn = no. /* don't ask for connection (hutegger 95/05) */
   run adedict/DB/_switch.p.
   s_ActionProc = "".

   /* As long as there is no database selected, we'll hang out here.
      As soon as we connect to a database, we'll run _dcttran.p 
      which will take control for as long as we are working with that 
      database.
   */
   mainloop: 
   repeat:
      if s_DictState = {&STATE_DONE} then
         leave mainloop.
   
      if s_DictState = {&STATE_NO_DB_SELECTED} then
      do:
         if s_win_Logo <> ? then 
         do:
            /* We're in start up mode */
            run adecomm/_setcurs.p ("").
            session:immediate-display = no.
            delete widget s_win_Logo.
            s_win_Logo = ?.
            current-window = s_win_Browse.
            view frame browse.
         end.
         wait-for "U1" of frame browse.   
      end.
      else
         run adedict/_dcttran.p.
   
      /* ActionProc may switch databases or disconnect a database. 
         Either way, our state may change. */
      if s_ActionProc <> "" then
      do:
         run VALUE(s_ActionProc).
         s_ActionProc = "".
      end.
   end.         /* end repeat */
end.  /* end do ON STOP */

/* Delete all dictionary windows and help window if it's up. */
if s_win_Logo <> ? then /* this means user hit STOP before we even begun */
do:
   run adecomm/_setcurs.p ("").
   session:immediate-display = no.
   delete widget s_win_Logo.
end.

run adedict/_delwins.p (INPUT yes).
run adecomm/_adehelp.p ("dict", "QUIT", ?, ?).
if s_win_Browse <> ? then
   delete widget s_win_Browse.
session:suppress-warnings = supw_sav.  /* reset to saved value */









