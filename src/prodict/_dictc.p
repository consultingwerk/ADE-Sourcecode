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

/*==========================================================================
 dict.p - PROGRESS DATA DICTIONARY main program 

NAMING CONVENTIONS:
  prefixes:
    dict* - dictionary kernal routines
    dump* - export programs
    help* - dictionary on-line help (reserved)
    list* - reporting programs
    load* - import programs
    menu* - menu programs
    os*   - opsys-specific functions
    run_* - programs compiled on-the-fly (always .i)
    tool* - tools
    user* - user interface
    xref* - cross-reference utilities (reserved)
    _*    - temporary files
  suffixes:
    *?gen - generates code
    *?get - selects objects. the ? in ?get is one of:
            f - Field
            i - Index
            s - Schema (Database)
            t - Table (File)
            v - View
            w - Workfile
  types:
    *.d  - database contents dump
    *.df - database structure dump
    *.ds - listing from load data screen
    *.e  - error files listing load errors
    *.f  - FORM statements for user interface
    *.fd - bulkload description files
    *.i  - include files or procedures compiled on-the-fly
    *.p  - procedures
    *.pl - prolib r-code library
    *.r  - compiled procedures (one per .p)

DATABASE GATEWAY (formerly DBIM):
  prefixes:
    pro_* - PROGRESS GATEWAY drivers
    sql_* - PROGRESS/SQL drivers (shares code with pro_*)
    rms_* - RMS GATEWAY drivers
    rdb_* - Rdb GATEWAY drivers
    ora_* - ORACLE GATEWAY drivers
  suffixes:
    *_dbs.p - database manager code
    *_fil.p - file manager code
    *_fld.p - field editor update code
    *_idx.p - index manager code
    *_dmp.p - df dump code
    *_lod.p - df load code

To add support for a new non-PROGRESS (foreign) database type:
  1. Select a three letter prefix, and make a subdir in prodict named that.
  2. Then add:
     ???_sys.p ???_typ.p
     The best way to write these is to copy an existing set and modify the
     settings.
  3. Then alter:
     dictgate.i
     This is to put in support for the name of the new database type.
  4. Finally, add any new special options specific to that database type.
     You will probably want to add a "??? Utilities" entry to the Admin menu.
     See usermenu.i for details.

TRANSLATION:
To translate dictionary into foreign language:
  1. Edit all *.f files to fix frame information
  2. Edit _runload.i to fix language dependencies there.
  3. Fix all *.p files.  All language-dependent text will be isolated in
     array or form definitions between the following comment markers, and
     will be near the beginning of the file:
       /* LANGUAGE DEPENDENCIES START */ /*---------------------------------*/
       /* LANGUAGE DEPENDENCIES END */ /*-----------------------------------*/

============================================================================*/


&SCOPED-DEFINE DATASERVER                 YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i NEW }
&UNDEFINE FOREIGN_SCHEMA_TEMP_TABLES
&UNDEFINE DATASERVER
{ prodict/user/uservar.i NEW }
{ prodict/user/userhue.i NEW }

DEFINE VARIABLE i       AS INTEGER              NO-UNDO.
DEFINE VARIABLE istrans AS LOGICAL INITIAL TRUE. /*UNDO (not no-undo!) */
DEFINE VARIABLE j       AS INTEGER              NO-UNDO.
DEFINE VARIABLE mode    AS CHARACTER            NO-UNDO.
DEFINE VARIABLE stat    AS LOGICAL              NO-UNDO.
DEFINE VARIABLE mti_sav AS INTEGER              NO-UNDO.
DEFINE VARIABLE sw_sav  AS LOGICAL              NO-UNDO.
/* Variables needed for Taskbar orientation check */
DEFINE VARIABLE TBOrientation AS CHARACTER NO-UNDO.
DEFINE VARIABLE TBHeight      AS INTEGER   NO-UNDO.
DEFINE VARIABLE TBWidth       AS INTEGER   NO-UNDO.
DEFINE VARIABLE AutoHide      AS LOGICAL   NO-UNDO.

DEFINE NEW SHARED VARIABLE fast_track AS LOGICAL. /* FT active? */
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
   DEFINE NEW SHARED VARIABLE win AS WIDGET-HANDLE NO-UNDO.
&ENDIF

{ prodict/user/userhdr.f NEW }


/*--- LANGUAGE DEPENDENCIES START ----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 8 NO-UNDO INITIAL [
  /* 1*/ "the PROGRESS Data Dictionary",
  /* 2*/ "PROGRESS Data Administration",
  /* 3*/ "You are not allowed to use the dictionary on a database that",
  /* 4*/ "has a logical name",
  /* 5*/ "(alias is okay, but not ldbname).",
  /* 6*/ "or",
  /* 7*/ "to select",
  /* 8*/ "Main Menu"
].

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
FORM SKIP(1)
  "You may use these facilities to set up or alter the structure of" 
               AT 2 SPACE(1) SKIP
  "your database(s) or to perform various administrative functions."
               AT 2 SPACE(1) SKIP(1)
  WITH FRAME guten-tag 
  ROW 6 CENTERED TOP-ONLY NO-ATTR-SPACE NO-LABELS OVERLAY USE-TEXT
  TITLE COLOR VALUE(IF head-bg = "MESSAGES" THEN "NORMAL" ELSE head-bg)
  " Welcome to " + new_lang[1] + " ". 
&ELSE
FORM SKIP(1)
  "You may use these facilities to set up or alter the structure of      " AT 4 SPACE(1) SKIP
  "your database(s) or to perform various administrative functions.      " AT 4 SPACE(1) SKIP(1)
  WITH FRAME guten-tag THREE-D
  ROW 6 width &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN 72 &ELSE 55 &ENDIF
  CENTERED TOP-ONLY NO-ATTR-SPACE NO-LABELS OVERLAY USE-TEXT
  TITLE COLOR VALUE(IF head-bg = "MESSAGES" THEN "NORMAL" ELSE head-bg)
  " Welcome to  " + new_lang[2] + "  ".
&ENDIF


/*--- LANGUAGE DEPENDENCIES END ------------------------------------------*/

/*===================Triggers/Internal Procedures==========================*/

/* Menu definition, triggers and internal procedures */
{prodict/user/usermenu.i NEW}

/*==========================Mainline code==================================*/

USE "" NO-ERROR.  /* resets to startup default file */
sw_sav = SESSION:SUPPRESS-WARNINGS.
SESSION:SUPPRESS-WARNINGS = YES. /* no warnings on platform specific funcs */

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
   ASSIGN
      SESSION:APPL-ALERT-BOXES = NO
      SESSION:SYSTEM-ALERT-BOXES = YES.

   /* In GUI environment create a new window. */
   CREATE WINDOW win
      ASSIGN
        X = 5
        Y = 5
               HEIGHT-CHARS = 15
               TITLE = "Data Administration"
               MENUBAR = MENU mnu_Admin_Tool:HANDLE
               STATUS-AREA = no

      TRIGGERS:
               ON WINDOW-CLOSE DO:
                  APPLY "CHOOSE" to MENU-ITEM mi_Exit IN MENU mnu_Database.
                  RETURN NO-APPLY.
               END.
               ON HELP ANYWHERE DO:
                  APPLY "CHOOSE" TO MENU-ITEM mi_Hlp_Topics IN MENU mnu_Help.
                  RETURN NO-APPLY.
               END.
      END TRIGGERS.
    IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":U THEN DO: 
       ASSIGN TBOrientation= ""
              TBHeight = 0
              TBWidth = 0.
       RUN adeshar/_taskbar.p (OUTPUT TBOrientation, OUTPUT TBHeight,
                               OUTPUT TBWIdth,       OUTPUT AutoHide).
    
       IF NOT AutoHide THEN DO:
         IF TBOrientation = "LEFT":U AND win:X <= TBWidth THEN
            ASSIGN win:X = TBWidth.
         IF TBOrientation = "TOP":U THEN DO:
            IF win:Y <= TBHeight THEN win:Y = TBHeight + 10.
         END.
         IF TBOrientation = "BOTTOM" AND win:Y + win:HEIGHT-P > SESSION:HEIGHT-P - TBHeight THEN DO:
            win:Y = win:Y - ((win:Y + win:HEIGHT-P) - (SESSION:HEIGHT-P - TBHeight)).  
         END.
         IF TBOrientation = "RIGHT" AND win:X + win:WIDTH-P > SESSION:WIDTH-P - TBWidth THEN DO:
            win:X = win:X - ((win:X + win:WIDTH-P) - (SESSION:WIDTH-P - TBWidth)).
         end.
       END. /* if NOT AutoHide */
    END. /* if SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" */

  
   
   CURRENT-WINDOW = win.
   stat = win:load-icon("adeicon/admin%").

   /* To force correct paint behavior on startup. */
   mti_sav = SESSION:MULTITASKING-INTERVAL.
   SESSION:MULTITASKING-INTERVAL = 10.
   
   &IF "{&WINDOW-SYSTEM}" = "ms-windows" &THEN
       assign win:width-chars = win:max-width + 15
              win:max-width = win:width-chars
              /*frame user_ftr:width-chars = win:max-chars */.
   &endif.
   
&ELSE
   ASSIGN
      SESSION:APPL-ALERT-BOXES = NO
      SESSION:SYSTEM-ALERT-BOXES = NO.

   /* for TTY we use the default window */
   ASSIGN
      DEFAULT-WINDOW:MENUBAR = MENU mnu_Admin_Tool:HANDLE.
&ENDIF

RUN "adecomm/_setcurs.p" ("WAIT").  

/* COLOR SETTINGS for C080-------------------------------------------*/
IF TERMINAL = "CO80" THEN ASSIGN
  menu-fg = "WHITE/MAGENTA"      menu-bg = "YELLOW/BLUE"
  dbox-fg = "WHITE/RED"          dbox-bg = "WHITE/GRAY"
  head-fg = "LIGHT-CYAN/BLUE"    head-bg = "WHITE/GRAY"
  pick-fg = "WHITE/GRAY"         pick-bg = "LIGHT-CYAN/BLUE".

/*-----
IF TERMINAL = "CO80" THEN
  DISPLAY SPACE(80)
    WITH FRAME background OVERLAY NO-BOX COLOR WHITE/BLACK NO-ATTR-SPACE
    SCREEN-LINES - 2 DOWN ROW 2 COLUMN 1.
-----*/

HIDE ALL NO-PAUSE.
ASSIGN
  drec_db    = ?
  drec_file  = ?.

/* this checks aliases that dict needs internally */
DO i = 1 TO 3:
  mode = ENTRY(i,"DICTDB,DICTDBG,DICTDB2").
  IF LDBNAME(mode) <> mode THEN NEXT.
  RUN "adecomm/_setcurs.p" ("").  
  MESSAGE new_lang[3] SKIP /* DICTDB as logical name confuses dictionary */
                new_lang[4] mode new_lang[5] /* try again. */
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

IF DBTYPE("DICTDB") = "PROGRESS" AND DBVERSION("DICTDB") < "9" THEN
  DELETE ALIAS "DICTDB".

cache_dirty = ?. /* flag to dictgues that this is first time */
RUN "prodict/_dctsget.p". /* build db cache */
IF NUM-DBS > 0
 THEN RUN "prodict/_dctgues.p". /* select initial db */
 ELSE ASSIGN
  user_dbname = (IF LDBNAME("DICTDB") = ? THEN "" ELSE LDBNAME("DICTDB"))
  user_dbtype = (IF LDBNAME("DICTDB") = ? THEN "" ELSE DBTYPE("DICTDB")).

DO ON ERROR UNDO:
  istrans = FALSE.
  UNDO,LEAVE.
END.

ASSIGN
/*  user_dbname = (IF LDBNAME("DICTDB") = ? THEN "" ELSE LDBNAME("DICTDB"))*/
/*  user_dbtype = (IF LDBNAME("DICTDB") = ? THEN "" ELSE DBTYPE("DICTDB")) */
  cache_dirty = TRUE.

/* Gray menus according to PROGRESS capabilities and database connection */
RUN Initial_Menu_Gray.

/* Initialize for first function */
ASSIGN
   dict_trans  = FALSE
   dict_dirty  = FALSE
   user_trans  = ""
   user_env    = "".

/* Display Welcome frame */
VIEW FRAME guten-tag. 

/* Display current context in header and footer lines */
{prodict/user/userhdr.i new_lang[8]}
{ prodict/user/usercon.i '' @ user_filename }

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
   SESSION:MULTITASKING-INTERVAL = mti_sav.
   WIN:HEIGHT = WIN:MAX-HEIGHT. /* put in so window ok on Japanese Windows */
&ENDIF

/* Set global active ade tool procedure handle to Admin. */
ASSIGN h_ade_tool = THIS-PROCEDURE.

/* Main WAIT-FOR.  On TTY, ENDKEY will get you out, but on GUI,
   it shouldn't.
*/
RUN "adecomm/_setcurs.p" ("").  /* Make sure wait cursor is off */
DO
   &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
   ON ERROR UNDO, RETRY  ON ENDKEY UNDO, RETRY
   &ENDIF
   ON STOP UNDO, LEAVE:
   WAIT-FOR "CHOOSE" OF MENU-ITEM mi_Exit IN MENU mnu_Database.
END.

HIDE ALL NO-PAUSE.
SESSION:SUPPRESS-WARNINGS = sw_sav.
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
   run adecomm/_adehelp.p ("dict", "QUIT", ?, ?).
   DELETE WIDGET win. 
&ENDIF

PAUSE 0.
RETURN.





