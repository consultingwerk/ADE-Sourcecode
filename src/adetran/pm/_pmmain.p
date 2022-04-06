/*********************************************************************
* Copyright (C) 2000,2012 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/_pmmain.p
Author:       R. Ryan
Created:      1/95
Updated:      Added CurrentMode=6 Subset for sorting purposes
Purpose:      Translation Manager main backbone program. This is
              sometimes referred to as 'PM' which stands for
              Project Manager.

Architecture: The main components of the Translation Manager are:

                MainWindow - a handle to the Translator Mgr window
                MainFrame  - a frame that covers the entire PM window

                TabBody    - The 3D image that makes up most of the
                             MainFrame.  The toolbar buttons and combo
                             overlay TabBody
                TabControl - The tab image that give the illusion of
                             pressing individual tabs.  Each tab control
                             has a button widget placed on top that has
                             an up/down associated with it so that it
                             doesn't look like a real button.  As that
                             button is pressed, different bitmaps for the
                             TabControl are loaded, giving the illusion of
                             a tab folder being pressed:

                               - BtnProcedures runs hProcs (pm/_pmprocs.w)
                               - BtnTranslation runs hTrans (pm/_trans.p)
                               - BtnGlossary runs hGloss (pm/_gloss.p)
                               - BtnKits runs _hKits (pm/_kits.w)
                               - BtnStatistics runs hStats (pm/_pmstats.p)

              Each tab folder has a single frame that is either displayed or
              hidden depending upon which button has been selected.  Each of
              these procedure procedures has at least 2 procedures:

                - Realize (enables widgets, sometimes opens queries, and makes
                  the frame visable).
                - HideMe (hides the frame)

              Note: MainFrame and each of the frames that are associated with the
              tabs are layed out in pixels - not PPUs (because of the use of the
              underlying TabBody and TabControl images). Individual windows and dialogs
              use PPUs layout. As a button LIKE BtnProcedures is selected, Realize is
              run in hProcs and HideMe is run is the previous persistent procedure. O
              ther persistent procedures are:

                _hFind (pm/_find.w) the find 'dialog' (window)
                _hReplace (pm/_replace.w) the replace 'dialog' (window)
                _hGoto (pm/_goto.w) the goto 'dialog' (window)
                _hMeter (common/_meter.w) the meter frame
                _hWinMgr (adecomm/_winmenu.w) the Windows/File manager for tracking

Procedures:   Key internal procedures include:

              ResetMain        - when new projects are opened, ResetMain is run so that
                                 persistent procedures that are *binded* to a databases'
                                 alias can get reset.
              SetSensitivity   - sets MENU-ITEMs and button's sensitivity.
              ResetCursor      - resets the cursor back to 'arrow' once the help
                                 button was depressed.
              WinMenuChoose    - Used by hWinMgr to keep track of the last project db.

              Key external procedures include:

              pm/_reset.p      - Used to reset the proj alias to a different proj db.
              common/_alias    - Used to connect or reconnect to a project database and
                                 reset the alias.
              common/_schema.p - Used to check that the database that is being opened
                                 is a valid project database (not a project db)

Variables:    Key variables include:

              CurrentMode    1=Procedures,2=Translation,3=Glossary,4=Kits,5=Stats
                             6=Subset
              CurrentPointer arrow or help cursor
              CurrentTool    always 'PM' used to tag persistent procedure
              ProjectDB      the ldb of the project database
              s_Glossary      the currently selected glossary
              _Language      the currently selected language
              _Kit           the ldb of the current kit

*/

&GLOBAL-DEFINE Database_Connections 17

/* ************************* LICENSE CHECK *****************************/
DEFINE VARIABLE _TM_license AS INTEGER NO-UNDO.
ASSIGN _TM_license = GET-LICENSE ("TRANSLATION-MGR":U).
IF _TM_license NE 0 THEN
DO:
   MESSAGE "A license for the Translation Manager is not available."
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   STOP.
END.

RUN adecomm/_setcurs.p ("WAIT":U).
CREATE WIDGET-POOL.

{ adetran/pm/tranhelp.i } /* definitions for help context strings from tranman  */

ASSIGN SESSION:immediate-display = TRUE
       SESSION:appl-alert-box    = TRUE
       SESSION:three-d           = TRUE.

DEFINE NEW SHARED VARIABLE _MainWindow          AS WIDGET-HANDLE            NO-UNDO.
DEFINE NEW SHARED VARIABLE _hMain               AS HANDLE                   NO-UNDO.
DEFINE NEW SHARED VARIABLE CurrentMode          AS INTEGER INITIAL 1        NO-UNDO.

DEFINE NEW SHARED VARIABLE tGlss                AS ROWID                    NO-UNDO.

DEFINE NEW SHARED VARIABLE s_Glossary           AS CHARACTER                NO-UNDO.
DEFINE NEW SHARED VARIABLE _Kit                 AS CHARACTER                NO-UNDO.
DEFINE NEW SHARED VARIABLE _Lang                AS CHARACTER                NO-UNDO.
DEFINE NEW SHARED VARIABLE _FullPathFlag        AS LOGICAL INITIAL TRUE     NO-UNDO.
DEFINE NEW SHARED VARIABLE _ExtractWarnings     AS LOGICAL                  NO-UNDO.
DEFINE NEW SHARED VARIABLE _RCWarnings          AS LOGICAL                  NO-UNDO.
DEFINE NEW SHARED VARIABLE _AddProcWarnings     AS LOGICAL                  NO-UNDO.
DEFINE NEW SHARED VARIABLE _SuppressReplaceAsk  AS LOGICAL                  NO-UNDO.

DEFINE NEW SHARED VARIABLE ProjectDB            AS CHARACTER                NO-UNDO.
DEFINE NEW SHARED VARIABLE GlossaryDB           AS CHARACTER                NO-UNDO.
DEFINE NEW SHARED VARIABLE KitDB                AS CHARACTER                NO-UNDO.
DEFINE NEW SHARED VARIABLE CurrentTool          AS CHARACTER INITIAL "PM":U NO-UNDO.
DEFINE NEW SHARED VARIABLE CurLanguage          AS CHARACTER                NO-UNDO.
DEFINE NEW SHARED VARIABLE CurDataLang          AS CHARACTER                NO-UNDO.
DEFINE NEW SHARED VARIABLE StopProcessing       AS LOGICAL                  NO-UNDO.

DEFINE NEW SHARED VARIABLE _hFileMenu           AS HANDLE                   NO-UNDO.
DEFINE NEW SHARED VARIABLE _hWinMenu            AS HANDLE                   NO-UNDO.
DEFINE NEW SHARED VARIABLE _hWinMgr             AS HANDLE                   NO-UNDO.
DEFINE NEW SHARED VARIABLE _hLongStr            AS HANDLE                   NO-UNDO.
DEFINE NEW SHARED VARIABLE _hMeter              AS HANDLE                   NO-UNDO.
DEFINE NEW SHARED VARIABLE _hTrans              AS HANDLE                   NO-UNDO.
DEFINE NEW SHARED VARIABLE _hKits               AS HANDLE                   NO-UNDO.
DEFINE NEW SHARED VARIABLE _hFind               AS HANDLE                   NO-UNDO.
DEFINE NEW SHARED VARIABLE _hReplace            AS HANDLE                   NO-UNDO.
DEFINE NEW SHARED VARIABLE _hGoto               AS HANDLE                   NO-UNDO.
DEFINE NEW SHARED VARIABLE _hSort               AS HANDLE                   NO-UNDO.

DEFINE NEW SHARED VARIABLE stringROWID          AS ROWID                    NO-UNDO.
DEFINE NEW SHARED VARIABLE instanceROWID        AS ROWID                    NO-UNDO.
DEFINE NEW SHARED VARIABLE translationROWID     AS ROWID                    NO-UNDO.
DEFINE NEW SHARED VARIABLE glossDetROWID        AS ROWID                    NO-UNDO.

DEFINE NEW SHARED VARIABLE _ZipPresent          AS LOGICAL INITIAL TRUE     NO-UNDO.
DEFINE NEW SHARED VARIABLE _ZipName             AS CHARACTER                NO-UNDO.
DEFINE NEW SHARED VARIABLE _ZipCommand          AS CHARACTER INITIAL "pkzip.exe ":U
                                                                            NO-UNDO.
DEFINE NEW SHARED VARIABLE _BKUPExt             AS CHARACTER INITIAL ".bku" NO-UNDO.

/* Temporary files generated by _sort.w and _order.w.                */
/* If these are blank then the regular OpenQuery internal procedures */
/* are run, otherwise these will be run                              */
DEFINE NEW SHARED VARIABLE TmpFl_PM_Gl          AS CHARACTER                NO-UNDO.
DEFINE NEW SHARED VARIABLE TmpFl_PM_Tr          AS CHARACTER                NO-UNDO.
DEFINE NEW SHARED VARIABLE TmpFl_PM_Ss          AS CHARACTER                NO-UNDO.

{adetran/pm/vsubset.i &NEW="NEW" &SHARED="SHARED"}

DEFINE VARIABLE GlossaryList    AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE KitList         AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE ErrorStatus     AS LOGICAL                              NO-UNDO.
DEFINE VARIABLE flnm            AS CHARACTER INITIAL "status.txt"       NO-UNDO.
DEFINE VARIABLE fnt             AS INTEGER   INITIAL ?                  NO-UNDO.
DEFINE VARIABLE i               AS INTEGER                              NO-UNDO.
DEFINE VARIABLE LastProject     AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE LPP             AS INTEGER   INITIAL 60                 NO-UNDO.
DEFINE VARIABLE PrFlag          AS INTEGER   INITIAL 0                  NO-UNDO.
DEFINE VARIABLE OKPressed       AS LOGICAL                              NO-UNDO.
DEFINE VARIABLE TestName        AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE BaseName        AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE DirName         AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE CurFocus        AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE ThisMessage     AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE TempString      AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE Result          AS LOGICAL                              NO-UNDO.
DEFINE VARIABLE CurrentPointer  AS LOGICAL                              NO-UNDO.

DEFINE VARIABLE PhraseFlag      AS LOGICAL                              NO-UNDO.
DEFINE VARIABLE GlossaryFlag    AS LOGICAL                              NO-UNDO.
DEFINE VARIABLE TransFlag       AS LOGICAL                              NO-UNDO.
DEFINE VARIABLE NumProcs        AS INTEGER                              NO-UNDO.
DEFINE VARIABLE TempLogical     AS CHARACTER                            NO-UNDO.

/* Extract vars */
DEFINE NEW SHARED VARIABLE pMatchCase    AS LOGICAL                     NO-UNDO.
DEFINE NEW SHARED VARIABLE pSingleCharacterString    AS LOGICAL         NO-UNDO.
DEFINE NEW SHARED VARIABLE pNoAlphaCharacter    AS LOGICAL              NO-UNDO.
DEFINE NEW SHARED VARIABLE singleCharacterStringMatch AS CHARACTER INITIAL ".":U  NO-UNDO.
DEFINE NEW SHARED VARIABLE NoAlphaCharacterMatch AS CHARACTER INITIAL "":U        NO-UNDO.
DEFINE NEW SHARED VARIABLE pXREFFileName AS CHARACTER                   NO-UNDO.
DEFINE NEW SHARED VARIABLE pXREFType     AS CHARACTER INITIAL "A":U     NO-UNDO.
DEFINE NEW SHARED VARIABLE pReplaceXREF  AS LOGICAL   INITIAL TRUE      NO-UNDO.
DEFINE NEW SHARED VARIABLE pDeleteXREF   AS LOGICAL                     NO-UNDO.

DEFINE NEW SHARED VARIABLE RunFile       AS CHARACTER                   NO-UNDO.
DEFINE NEW SHARED VARIABLE Mode2         AS CHARACTER  NO-UNDO INITIAL
  "(None),Source Phrase,Procedure Name,Occurrences,Line Number,Length,Statement,Item,Comments":U.
DEFINE NEW SHARED VARIABLE Mode3         AS CHARACTER  NO-UNDO INITIAL
  "(None),Source Phrase,Target Phrase,Modified By Translator,Type":U.
DEFINE NEW SHARED VARIABLE Mode6         AS CHARACTER  NO-UNDO INITIAL
  "(None),File Name,Directory":U.
DEFINE NEW SHARED VARIABLE OrdMode2      AS CHARACTER                   NO-UNDO.
DEFINE NEW SHARED VARIABLE OrdMode3      AS CHARACTER                   NO-UNDO.
DEFINE NEW SHARED VARIABLE tModFlag      AS LOGICAL                     NO-UNDO.



DEFINE SUB-MENU mFile
  MENU-ITEM mNew           LABEL "&New..."  ACCELERATOR "SHIFT-F3"
  MENU-ITEM mOpen          LABEL "&Open..." ACCELERATOR "F3"
  MENU-ITEM mClose         LABEL "&Close"   ACCELERATOR "F8"
  RULE
  MENU-ITEM mConnect       LABEL "&Database Connections"
  RULE
  MENU-ITEM mImport        LABEL "&Import..."
  MENU-ITEM mExport        LABEL "&Export..."
  RULE
  MENU-ITEM mPrintScreen   LABEL "&Print Screen..." ACCELERATOR "CTRL-P"
  RULE
  MENU-ITEM mExit          LABEL "E&xit".


DEFINE SUB-MENU mEdit
  MENU-ITEM mCut           LABEL "Cu&t"    ACCELERATOR "SHIFT-DEL"
  MENU-ITEM mCopy          LABEL "&Copy"   ACCELERATOR "CTRL-INS"
  MENU-ITEM mPaste         LABEL "&Paste"  ACCELERATOR "SHIFT-INS"
  RULE
  MENU-ITEM mInsert        LABEL "&Insert Row"
  MENU-ITEM mDelete        LABEL "&Delete Row"
  RULE
  MENU-ITEM mDeleteTarget  LABEL "Delete Target P&hrase"
  RULE
  MENU-ITEM mFind          LABEL "&Find..."    ACCELERATOR "CTRL-F"
  MENU-ITEM mReplace       LABEL "&Replace..." ACCELERATOR "CTRL-R"
  MENU-ITEM mGoto          LABEL "&Goto..."    ACCELERATOR "CTRL-G"
.

DEFINE SUB-MENU mView
  MENU-ITEM mSort          LABEL "&Sort..."
  MENU-ITEM mOrder         LABEL "&Order Columns...".

DEFINE SUB-MENU mBuild
  MENU-ITEM mCompile       LABEL "&Compile..."
  MENU-ITEM mRun           LABEL "&Run...".

DEFINE SUB-MENU m_tm-util
  MENU-ITEM mi_cln-gloss   LABEL "&Cleanup Glossaries..."
  RULE
  MENU-ITEM mi_exp-filtr   LABEL "&Export Filters..."
  MENU-ITEM mi_imp-filtr   LABEL "&Import Filters..."
  RULE
  MENU-ITEM mi_pre-trans   LABEL "&PreTranslation..."
  RULE
  MENU-ITEM mi_calc-stats  LABEL "Calculate &Statistics".

/* Make the tools menu using the ade standards */
  { adecomm/toolmenu.i
    &CUSTOM_TOOLS =
      " SUB-MENU m_tm-util LABEL ""&TranMan Utilities""
      RULE "
  }

DEFINE SUB-MENU mOptions
  MENU-ITEM mPrefs         LABEL "&Preferences..." .

DEFINE SUB-MENU mHelp
  MENU-ITEM mMaster        LABEL "OpenEdge &Master Help"
  MENU-ITEM mContents      LABEL "Translation Manager &Help Topics"
  RULE
  MENU-ITEM mMsgs          LABEL "M&essages..."
  MENU-ITEM mRecentMsgs    LABEL "&Recent Messages..."
  RULE
  MENU-ITEM mAbout         LABEL "&About Translation Manager" .

DEFINE MENU MainMenuBar MENUBAR
  SUB-MENU  mFile          LABEL "&File"
  SUB-MENU  mEdit          LABEL "&Edit"
  SUB-MENU  mView          LABEL "&View"
  SUB-MENU  mBuild         LABEL "&Build"
  SUB-MENU  mnu_Tools      LABEL "&Tools"
  SUB-MENU  mOptions       LABEL "&Options"
  SUB-MENU  mHelp          LABEL "&Help".

  { adecomm/toolrun.i
    &MENUBAR=MainMenuBar
    &EXCLUDE_TRAN=yes
    &PERSISTENT=PERSISTENT
  }


CREATE WINDOW _MainWindow ASSIGN
   HIDDEN                = YES
   TITLE                 = "Translation Manager - Untitled":U
   HEIGHT-PIXELS         = 393
   WIDTH-PIXELS          = 633
   MAX-HEIGHT-PIXELS     = 393
   MAX-WIDTH-PIXELS      = 633
   VIRTUAL-HEIGHT-PIXELS = 393
   VIRTUAL-WIDTH-PIXELS  = 633
   RESIZE                = YES
   SCROLL-BARS           = NO
   STATUS-AREA           = NO
   BGCOLOR               = ?
   FGCOLOR               = ?
   KEEP-FRAME-Z-ORDER    = YES
   THREE-D               = YES
   MESSAGE-AREA          = no
   MENUBAR               = menu MainMenuBar:HANDLE
   MAX-BUTTON            = NO
   SENSITIVE             = YES.

/* The first stuff that gets setup, is the splash screen, the menu and the
   window.                                                                        */

DEFINE IMAGE SplashImage
  FILENAME "adetran/images/tranlogo":U
  SIZE-PIXELS 432 BY 266.

DEFINE FRAME SplashFrame
  SplashImage
  WITH SIZE-PIXELS 432 BY 266 NO-BOX FONT 4 BGCOLOR 8.

/* Now the rest of the window and variables are defined */
DEFINE VARIABLE _hProcs            AS HANDLE                             NO-UNDO.
DEFINE NEW SHARED VARIABLE _hGloss AS HANDLE                             NO-UNDO.
DEFINE VARIABLE _hStats            AS HANDLE                             NO-UNDO.


/* Buttons on the toolbar */
DEFINE BUTTON BtnNew
  IMAGE FILE "adetran/images/new":U
  TOOLTIP "New"
  SIZE-PIXELS 30 BY 30
  NO-FOCUS FLAT-BUTTON.

DEFINE BUTTON BtnOpen
  IMAGE FILE "adetran/images/open":U
  TOOLTIP "Open"
  LIKE BtnNew.

DEFINE BUTTON BtnPrint
  IMAGE FILE "adetran/images/print":U
  TOOLTIP "Print"
  LIKE BtnNew.

DEFINE BUTTON BtnCut
  IMAGE FILE "adetran/images/cut":U
  TOOLTIP "Cut"
  LIKE BtnNew.

DEFINE BUTTON BtnCopy
  IMAGE FILE "adetran/images/copy":U
  TOOLTIP "Copy"
  LIKE BtnNew.

DEFINE BUTTON BtnPaste
  IMAGE FILE "adetran/images/paste":U
  TOOLTIP "Paste"
  LIKE BtnNew.

DEFINE BUTTON BtnInsert
  IMAGE FILE "adetran/images/insert":U
  TOOLTIP "Insert"
  LIKE BtnNew.

DEFINE BUTTON BtnDelete
  IMAGE FILE "adetran/images/delete":U
  TOOLTIP "Delete"
  LIKE BtnNew.

DEFINE BUTTON BtnImport
  IMAGE FILE "adetran/images/import":U
  TOOLTIP "Import"
  LIKE BtnNew.

DEFINE BUTTON BtnExport
  IMAGE FILE "adetran/images/export":U
  TOOLTIP "Export"
  LIKE BtnNew.

DEFINE BUTTON BtnConnect
  IMAGE FILE "adetran/images/connect":U
  TOOLTIP "Connect"
  LIKE BtnNew.

DEFINE BUTTON BtnVT
  IMAGE FILE "adetran/images/launchvt":U
  TOOLTIP "Visual Translator"
  LIKE BtnNew.

DEFINE BUTTON BtnCompile
  IMAGE FILE "adetran/images/compile":U
  TOOLTIP "Compile"
  LIKE BtnNew.

DEFINE BUTTON BtnHelp
  IMAGE FILE "adetran/images/help":U
  TOOLTIP "Help"
  LIKE BtnNew.


/* Fake buttons that serve as tab labels */
DEFINE BUTTON BtnProcedures
     IMAGE-UP FILE "adetran/labels/procs-b":U
     IMAGE-DOWN FILE "adetran/labels/procs":U
     SIZE-PIXELS 23 BY 20.

DEFINE VARIABLE TxtProc AS CHARACTER FORMAT "X(14)"
                VIEW-AS TEXT SIZE-PIXELS 91 BY 20                 NO-UNDO.
TxtProc = "&Procedures":L14.

DEFINE BUTTON BtnData
     IMAGE-UP FILE "adetran/labels/data":U
     IMAGE-DOWN FILE "adetran/labels/data":U
     SIZE-PIXELS 23 BY 20.
DEFINE VARIABLE TxtData AS CHARACTER FORMAT "X(14)"
                VIEW-AS TEXT SIZE-PIXELS 92 BY 20                 NO-UNDO.
TxtData = "&Data":L14.

DEFINE BUTTON BtnGlossary
     IMAGE-UP FILE "adetran/labels/gloss":U
     IMAGE-DOWN FILE "adetran/labels/gloss":U
     SIZE-PIXELS 23 BY 20.
DEFINE VARIABLE TxtGloss AS CHARACTER FORMAT "X(14)"
                VIEW-AS TEXT SIZE-PIXELS 92 BY 20                 NO-UNDO.
TxtGloss = "&Glossary":L14.

DEFINE BUTTON BtnKit
     IMAGE-UP FILE "adetran/labels/kits":U
     IMAGE-DOWN FILE "adetran/labels/kits":U
     SIZE-PIXELS 23 BY 20.
DEFINE VARIABLE TxtKits AS CHARACTER FORMAT "X(14)"
                VIEW-AS TEXT SIZE-PIXELS 92 BY 20                 NO-UNDO.
TxtKits = "&Kits":L14.

DEFINE BUTTON BtnStatistics
     IMAGE-UP FILE "adetran/labels/stats":U
     IMAGE-DOWN FILE "adetran/labels/stats":U
     SIZE-PIXELS 23 BY 20.
DEFINE VARIABLE TxtStats AS CHARACTER FORMAT "X(14)"
                VIEW-AS TEXT SIZE-PIXELS 92 BY 20                 NO-UNDO.
TxtStats = "&Statistics":L14.



/*
** Remaining objects that appear on the mainframe
*/
DEFINE VARIABLE MainCombo AS CHARACTER FORMAT "X(256)":U
   VIEW-AS COMBO-BOX INNER-LINES 5
   LIST-ITEMS " ":U SIZE-PIXELS 153 BY 26
   NO-UNDO.

DEFINE IMAGE TabBody
   FILENAME "adetran/images/tab5body":U
   SIZE-PIXELS 622 by 350.

DEFINE IMAGE TabControl
   FILENAME "adetran/images/tab5a":U
   SIZE-PIXELS 622 by 34.

DEFINE TEMP-TABLE PersistProcs
  FIELD hProcedure AS HANDLE
  INDEX PKey IS PRIMARY UNIQUE hProcedure.

DEFINE FRAME MainFrame
  TabBody    AT X 7   Y 7
  TabControl AT X 7   Y 356
  MainCombo  AT X 15  Y 16 NO-LABEL

  BtnNew     AT X 184 Y 14
  BtnOpen    AT X 214 Y 14
  BtnImport  AT X 244 Y 14
  BtnExport  AT X 274 Y 14
  BtnPrint   AT X 304 Y 14
  BtnConnect AT X 334 Y 14

  BtnCut     AT X 371 Y 14
  BtnCopy    AT X 401 Y 14
  BtnPaste   AT X 431 Y 14
  BtnInsert  AT X 461 Y 14
  BtnDelete  AT X 491 Y 14

  BtnCompile AT X 528 Y 14
  BtnVT      AT X 558 Y 14
  BtnHelp    AT X 588 Y 14

  BtnProcedures AT X 13  Y 361  TxtProc  NO-LABEL AT X  34 Y 361
  BtnData       AT X 132 Y 361  TxtData  NO-LABEL AT X 153 Y 361
  BtnGlossary   AT X 254 Y 361  TxtGloss NO-LABEL AT X 275 Y 361
  BtnKit        AT X 374 Y 361  TxtKits  NO-LABEL AT X 395 Y 361
  BtnStatistics AT X 496 Y 361  TxtStats NO-LABEL AT X 517 Y 361

  WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY SIDE-LABELs NO-UNDERLINE
       THREE-D AT COL 1 ROW 1 SIZE-PIXELS 633 BY 393 FONT 4.


/*
** **************************************************************
** Triggers
** **************************************************************
*/

/* File open/save triggers */
ON CHOOSE OF BtnNew IN FRAME MainFrame or
  CHOOSE OF MENU-ITEM mNew DO:
  IF CurrentPointer AND SELF:HANDLE = BtnNew:HANDLE THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U,{&new_command_file_menu}, ?).
    RUN ResetCursor.
    RETURN.
  END.
  ELSE DO:
    RUN adecomm/_setcurs.p ("WAIT":U).
    RUN adetran/pm/_newproj.w (OUTPUT OKPressed, OUTPUT ErrorStatus).

    IF NOT OKPressed THEN RETURN.
    IF ErrorStatus THEN RETURN.

    IF INDEX(MainCombo,ProjectDB) = 0 THEN DO:
      IF MainCombo = "Untitled":U THEN MainCombo = ProjectDB.
      ELSE MainCombo = MainCombo + ",":U + ProjectDB.

      MainCombo:LIST-ITEMS = MainCombo.
    END.

    RUN ResetMain.

    ASSIGN LastProject        = PDBNAME("xlatedb":U) + ".db":U
           FILE-INFO:FILENAME = LastProject
           LastProject        = FILE-INFO:FULL-PATHNAME.

    RUN WinMenuRebuild IN _hWinMgr (_hFileMenu, LastProject, LastProject, _hMain).
  END.
END.

ON CHOOSE OF MENU-ITEM mClose DO:
  DO WITH FRAME MainFrame:
    IF MainCombo:SCREEN-VALUE = "Untitled":U THEN RETURN.

    result = MainCombo:DELETE(ProjectDB).
    IF MainCombo:num-items = 0 THEN
      ASSIGN MainCombo            = "Untitled":U
             MainCombo:LIST-ITEMS = MainCombo
             _MainWindow:TITLE    = "Translation Manager - Untitled":U.
    ELSE MainCombo = MainCombo:LIST-ITEMS.

    IF VALID-HANDLE(_hProcs) THEN
      RUN saveSubset IN _hProcs.

    ASSIGN ProjectDB              = MainCombo:ENTRY(1)
           MainCombo:SCREEN-VALUE = ProjectDB
           _MainWindow:TITLE      = "Translation Manager - ":U + ProjectDB
           s_Glossary = ""
           _Lang      = ""
           _kit       = "".

    IF CONNECTED("xlatedb":U) THEN DISCONNECT xlatedb.

    IF ProjectDB <> "Untitled":U THEN DO:
      RUN destroy-objects.
      CREATE ALIAS xlatedb FOR DATABASE VALUE(ProjectDB).
      RUN ResetMain.
      ASSIGN LastProject        = PDBNAME("xlatedb":U) + ".db":U
             FILE-INFO:FILENAME = LastProject
             LastProject        = FILE-INFO:FULL-PATHNAME.

       RUN WinMenuRebuild IN _hWinMgr (_hFileMenu, LastProject, LastProject, _hMain).
    END.

    ELSE DO: /* No more projects are open */
      ASSIGN MENU-ITEM mClose:SENSITIVE IN MENU mFile = FALSE.
      IF VALID-HANDLE(_hReplace)
         OR VALID-HANDLE(_hFind)
         OR VALID-HANDLE(_hGoto)
      THEN DO:
        /* Make sure these are running because they may have been stopped
           elsewhere, like in ON CHOOSE OF MENU-ITEM mConnect               */
        RUN HideMe IN _hFind.
        RUN HideMe IN _hReplace.
        RUN HideMe IN _hGoto.
        RUN HideMe IN _hProcs.
        RUN HideMe IN _hTrans.
        RUN HideMe IN _hGloss.
        RUN HideME IN _hLongStr.
        RUN HideMe IN _hKits.
        RUN HideMe IN _hStats.

        DELETE PROCEDURE _hFind.
        DELETE PROCEDURE _hReplace.
        DELETE PROCEDURE _hGoto.
        DELETE PROCEDURE _hProcs.
        DELETE PROCEDURE _hTrans.
        DELETE PROCEDURE _hGloss.
        DELETE PROCEDURE _hLongStr.
        DELETE PROCEDURE _hKits.
        DELETE PROCEDURE _hStats.
        IF VALID-HANDLE(_hSort) THEN DELETE PROCEDURE _hSort.

        RUN WinMenuRebuild IN _hWinMgr (_hFileMenu, "","", _hMain).
      END.  /* If they are still running */
    END. /* Else do when there are no more projects open */
  END.  /* Do with MainFrame */
END.  /* On choose of mClose */

ON CHOOSE OF BtnOpen IN FRAME MainFrame OR
  CHOOSE OF MENU-ITEM mOpen DO:
  IF CurrentPointer AND SELF:HANDLE = BtnOpen:HANDLE THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U,{&open_project_command_file_menu}, ?).
    RUN ResetCursor.
    RETURN.
  END.
  ELSE DO:
    DEFINE VARIABLE ExistingProject AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE SchemaPresent   AS LOGICAL                      NO-UNDO.

    SYSTEM-DIALOG GET-FILE ExistingProject
      TITLE     "Open Project Database"
      FILTERS   "Project files (*.db)" "*.db":U,
                "All files (*.*)"  "*.*":U
      DEFAULT-EXTENSION "db":U
      MUST-EXIST
      USE-FILENAME
      UPDATE OKPressed.

    IF OKPressed THEN DO:
      RUN adecomm/_setcurs.p ("WAIT":U).
      ProjectDB = ExistingProject.
      RUN adetran/common/_alias.p (OUTPUT ErrorStatus).
      IF ErrorStatus THEN DO:
        RUN adecomm/_setcurs.p ("").
        RETURN.
      END.

      /* Insure that this open database has the correct schema  */
      RUN adetran/common/_schema.p (OUTPUT SchemaPresent).
      IF NOT SchemaPresent THEN DO:
        DISCONNECT xlatedb.
        DELETE ALIAS xlatedb.
        ASSIGN ThisMessage =  ExistingProject + ": This file is not a project database."
               ProjectDB = "".
        RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w*":U, "ok":U, ThisMessage).
        APPLY "VALUE-CHANGED":U TO MainCombo IN FRAME MainFrame.
        RETURN NO-APPLY.
      END.

      IF INDEX(MainCombo,ProjectDB) = 0 THEN DO:
        IF MainCombo = "Untitled":U THEN MainCombo = ProjectDB.
        ELSE MainCombo = MainCombo + ",":U + ProjectDB.

        MainCombo:LIST-ITEMS = MainCombo.
      END.

      RUN ResetMain.
      IF VALID-HANDLE(_hProcs) THEN
        RUN checkSeqInst IN _hProcs.  /* Correct pre-9.1A project databases */

      ASSIGN LastProject        = PDBNAME("xlatedb":U) + ".db":U
             FILE-INFO:FILENAME = LastProject
             LastProject        = FILE-INFO:FULL-PATHNAME.

      RUN WinMenuRebuild IN _hWinMgr (_hFileMenu, LastProject, LastProject, _hMain).
    END.
  END.
END.

ON MOUSE-SELECT-CLICK OF MainCombo IN FRAME MainFrame DO:
  IF CurrentPointer THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U, {&Current_Proj_Combobx}, ?).
    RUN ResetCursor.
    RETURN.
  END.
END.


ON VALUE-CHANGED OF MainCombo IN FRAME MainFrame DO:
  IF /*MainCombo:NUM-ITEMS = 1 OR*/ MainCombo:SCREEN-VALUE = "Untitled":U THEN RETURN.
  IF NOT CurrentPointer AND ProjectDB NE MainCombo:SCREEN-VALUE THEN DO:
    ProjectDB = MainCombo:SCREEN-VALUE.

    RUN destroy-objects.
    CREATE ALIAS xlatedb FOR DATABASE VALUE(ProjectDB).
    RUN ResetMain.
    ASSIGN LastProject        = PDBNAME("xlatedb":U) + ".db":U
           FILE-INFO:FILENAME = LastProject
           LastProject        = FILE-INFO:FULL-PATHNAME.

    RUN WinMenuRebuild IN _hWinMgr (_hFileMenu, LastProject, LastProject, _hMain).
  END.  /* IF NOT help and ProjectDB has changed */
END.



/*
** Print triggers
*/
ON CHOOSE OF BtnPrint IN FRAME MainFrame OR
  CHOOSE OF MENU-ITEM mPrintScreen DO:
  DEFINE VARIABLE Mode AS LOGICAL                            NO-UNDO.
  /* Mode is ? - Cancel, No - Printer, Yes - File                  */

  IF CurrentPointer AND SELF:HANDLE = BtnPrint:HANDLE THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U,{&print_command}, ?).
    RUN ResetCursor.
    RETURN.
  END.
  ELSE DO:
    RUN adecomm/_setcurs.p ("WAIT":U).
    IF CurrentMode = 5 THEN DO:  /* Print statisitics Report */
      RUN adetran/common/_prtstat.w (INPUT-OUTPUT fnt,
                                     INPUT-OUTPUT flnm,
                                     INPUT-OUTPUT LPP,
                                     INPUT-OUTPUT PrFlag,
                                     OUTPUT Mode).

      IF Mode NE ? THEN    /* User didn't cancel */
        RUN print_statistics IN _hStats (INPUT flnm,
                                         INPUT fnt,
                                         INPUT LPP,
                                         INPUT PrFlag,
                                         INPUT Mode).
    END.
    ELSE IF PROCESS-ARCHITECTURE = 32 THEN DO:
      /* Print Screen is only available in the 32-bit Windows client.
      ** When running in the 64-bit client the Print button/menu will
      ** be disabled unless CurrentMode = 5.
      */
      RUN adetran/common/_prtscrn.p.
    END.
  END.
END.

/*
** Edit menu triggers
*/
ON MOUSE-SELECT-DOWN OF BtnCut IN FRAME MainFrame OR
  CHOOSE OF MENU-ITEM mCut DO:
  IF CurrentPointer AND SELF:HANDLE = BtnCut:HANDLE THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U,{&cut_command}, ?).
    RUN ResetCursor.
    RETURN.
  END.
  IF NOT VALID-HANDLE(focus) THEN RETURN.
  IF FOCUS:TYPE = "EDITOR":U THEN DO:
    IF FOCUS:TEXT-SELECTED THEN DO:
      CLIPBOARD:VALUE = FOCUS:SELECTION-TEXT.
      result = FOCUS:REPLACE-SELECTION-TEXT("").
    END.
    ELSE DO:
      CLIPBOARD:VALUE = FOCUS:SCREEN-VALUE.
      FOCUS:SCREEN-VALUE = "".
    END.
  END.
  ELSE IF CAN-QUERY(FOCUS,"SCREEN-VALUE":U) THEN DO:
    CLIPBOARD:VALUE = FOCUS:SCREEN-VALUE.
    FOCUS:SCREEN-VALUE = "".
  END.
END.

ON MOUSE-SELECT-DOWN OF BtnCopy IN FRAME MainFrame OR
  CHOOSE OF MENU-ITEM mCopy DO:
  IF CurrentPointer AND SELF:HANDLE = BtnCopy:HANDLE THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U,{&copy_command}, ?).
    RUN ResetCursor.
    RETURN.
  END.
  IF NOT VALID-HANDLE(FOCUS) THEN RETURN.

  IF FOCUS:TYPE = "editor":U THEN DO:
    IF FOCUS:TEXT-SELECTED THEN
      CLIPBOARD:VALUE = FOCUS:SELECTION-TEXT.
    ELSE
      CLIPBOARD:VALUE = FOCUS:SCREEN-VALUE.
  END.
  ELSE IF FOCUS:TYPE = "radio-set":U THEN
    CLIPBOARD:VALUE = ENTRY(LOOKUP(FOCUS:SCREEN-VALUE,FOCUS:radio-buttons) - 1,
                      FOCUS:radio-buttons).
  ELSE IF FOCUS:TYPE = "toggle-box":U THEN DO:
    IF FOCUS:SCREEN-VALUE = "YES":U THEN
      CLIPBOARD:VALUE = FOCUS:LABEL + " selected.":U.
    ELSE
      CLIPBOARD:VALUE = FOCUS:LABEL + " not selected.":U.
  END.
  ELSE IF CAN-QUERY(focus, "SCREEN-VALUE":U) THEN
    CLIPBOARD:VALUE = FOCUS:SCREEN-VALUE.
END.

ON MOUSE-SELECT-DOWN OF BtnPaste IN FRAME MainFrame OR
  CHOOSE OF MENU-ITEM mPaste DO:
  IF CurrentPointer AND SELF:HANDLE = BtnPaste:HANDLE THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U,{&paste_command}, ?).
    RUN ResetCursor.
    RETURN.
  END.
  ELSE DO:
    IF NOT VALID-HANDLE(focus) THEN RETURN.
    IF FOCUS:TYPE = "EDITOR":U THEN DO:
      IF FOCUS:TEXT-SELECTED THEN
        result = FOCUS:replace-selection-text(CLIPBOARD:VALUE).
      ELSE
        result = FOCUS:insert-string(CLIPBOARD:VALUE).
    END.
    ELSE IF CAN-QUERY(focus, "SCREEN-VALUE":U) THEN
      FOCUS:SCREEN-VALUE = CLIPBOARD:VALUE.
  END.
END.

ON MENU-DROP OF MENU mFile DO:
  /* Print Screen is only available in the 32-bit Windows client.
  ** When running in the 64-bit client the Print button/menu will
  ** be disabled unless CurrentMode = 5.
  */
  IF PROCESS-ARCHITECTURE = 32 THEN DO:
    ASSIGN MENU-ITEM mPrintScreen:LABEL IN MENU mFile =
       IF CurrentMode = 5 THEN "&Print..." ELSE "&Print Screen".
  END.
  ELSE DO:
    ASSIGN MENU-ITEM mPrintScreen:LABEL IN MENU mFile = "&Print..."
           MENU-ITEM mPrintScreen:SENSITIVE IN MENU mFile =
             IF CurrentMode = 5 THEN TRUE ELSE FALSE.
  END.
END.

ON MENU-DROP OF MENU medit DO:
  IF VALID-HANDLE(FOCUS) AND CAN-QUERY(FOCUS,"SCREEN-VALUE":U) AND FOCUS:name <> ? THEN DO:
    IF FOCUS:SCREEN-VALUE <> ? THEN
    ASSIGN MENU-ITEM mcut:SENSITIVE IN MENU medit   = (length(FOCUS:SCREEN-VALUE) > 0)
           MENU-ITEM mcopy:SENSITIVE IN MENU medit  = (length(FOCUS:SCREEN-VALUE) > 0).
    ELSE
    ASSIGN MENU-ITEM mcut:SENSITIVE IN MENU medit   = FALSE
           MENU-ITEM mcopy:SENSITIVE IN MENU medit  = FALSE.
    ASSIGN
           MENU-ITEM mpaste:SENSITIVE IN MENU medit = (CLIPBOARD:num-formats > 0 ).
    IF NOT CONNECTED("xlatedb":U) OR CurrentMode = 5 THEN
      ASSIGN MENU-ITEM mcut:SENSITIVE IN MENU medit   = FALSE
             MENU-ITEM mcopy:SENSITIVE IN MENU medit  = FALSE
             MENU-ITEM mpaste:SENSITIVE IN MENU medit = FALSE.
  END.

  ELSE ASSIGN MENU-ITEM mcut:SENSITIVE IN MENU medit   = FALSE
              MENU-ITEM mcopy:SENSITIVE IN MENU medit  = FALSE
              MENU-ITEM mpaste:SENSITIVE IN MENU medit = FALSE.

  /*
  ** Now sensitize the buttons for the corresponding functions
  */
  ASSIGN
    BtnCut:SENSITIVE IN FRAME MainFrame   = MENU-ITEM mCut:SENSITIVE IN MENU mEdit
    BtnCopy:SENSITIVE IN FRAME MainFrame  = MENU-ITEM mCopy:SENSITIVE IN MENU mEdit
    BtnPaste:SENSITIVE IN FRAME MainFrame = MENU-ITEM mPaste:SENSITIVE IN MENU mEdit.


  IF CONNECTED("xlatedb":U) THEN
    RUN adetran/pm/_getcnt.p
        (OUTPUT PhraseFlag, OUTPUT GlossaryFlag,
         OUTPUT TransFlag, OUTPUT NumProcs).
  CASE CurrentMode:
    WHEN 2 THEN DO:
      IF PhraseFlag THEN ASSIGN
        MENU-ITEM mDelete:SENSITIVE IN MENU mEdit  = TRUE
        MENU-ITEM mFind:SENSITIVE    IN MENU mEdit = TRUE
        MENU-ITEM mReplace:SENSITIVE IN MENU mEdit = TRUE
        MENU-ITEM mGoto:SENSITIVE    IN MENU mEdit = TRUE
        .
      ELSE ASSIGN
        MENU-ITEM mDelete:SENSITIVE  IN MENU mEdit = FALSE
        MENU-ITEM mFind:SENSITIVE    IN MENU mEdit = FALSE
        MENU-ITEM mReplace:SENSITIVE IN MENU mEdit = FALSE
        MENU-ITEM mGoto:SENSITIVE    IN MENU mEdit = FALSE
        .
      ASSIGN
        MENU-ITEM mDeleteTarget:SENSITIVE IN MENU mEdit  =
            IF PhraseFlag AND TransFlag THEN TRUE ELSE FALSE.
      .
    END.

    WHEN 3 THEN DO:
      MENU-ITEM mDeleteTarget:SENSITIVE IN MENU mEdit  = FALSE.
      IF GlossaryFlag THEN ASSIGN
        MENU-ITEM mDelete:SENSITIVE  IN MENU mEdit = TRUE
        MENU-ITEM mFind:SENSITIVE    IN MENU mEdit = TRUE
        MENU-ITEM mReplace:SENSITIVE IN MENU mEdit = TRUE
        MENU-ITEM mGoto:SENSITIVE    IN MENU mEdit = FALSE.
      ELSE ASSIGN
        MENU-ITEM mDelete:SENSITIVE  IN MENU mEdit = FALSE
        MENU-ITEM mFind:SENSITIVE    IN MENU mEdit = FALSE
        MENU-ITEM mReplace:SENSITIVE IN MENU mEdit = FALSE
        MENU-ITEM mGoto:SENSITIVE    IN MENU mEdit = FALSE.
    END.

    OTHERWISE DO:
      ASSIGN
        MENU-ITEM mDelete:SENSITIVE  IN MENU mEdit = FALSE
        MENU-ITEM mFind:SENSITIVE    IN MENU mEdit = FALSE
        MENU-ITEM mReplace:SENSITIVE IN MENU mEdit = FALSE
        MENU-ITEM mGoto:SENSITIVE    IN MENU mEdit = FALSE
        MENU-ITEM mDeleteTarget:SENSITIVE IN MENU mEdit  = FALSE.
    END.
  END CASE.
END.


ON CHOOSE OF MENU-ITEM mFind DO:
  RUN Realize IN _hFind.
END.

ON CHOOSE OF MENU-ITEM mReplace DO:
  RUN Realize IN _hReplace ("","").
END.

ON CHOOSE OF MENU-ITEM mGoto DO:
  RUN Realize IN _hGoto.
END.


ON CHOOSE OF BtnInsert IN FRAME MainFrame OR
  CHOOSE OF MENU-ITEM mInsert DO:
  IF CurrentPointer AND SELF:HANDLE = BtnInsert:HANDLE THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U,{&insert_command}, ?).
    RUN ResetCursor.
    RETURN.
  END.
  ELSE DO:
    IF CurrentMode = 2 THEN RUN InsertRow IN _hTrans.
                       ELSE RUN InsertRow IN _hGloss.
  END.
END.


ON CHOOSE OF BtnDelete IN FRAME MainFrame OR
  CHOOSE OF MENU-ITEM mDelete DO:
  IF CurrentPointer AND SELF:HANDLE = BtnDelete:HANDLE THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U,{&delete_command}, ?).
    RUN ResetCursor.
    RETURN.
  END.
  ELSE DO:
    IF CurrentMode = 2 THEN RUN DeleteRow IN _hTrans.
                       ELSE RUN DeleteRow IN _hGloss.
  END.
END.

ON CHOOSE OF MENU-ITEM mDeleteTarget DO:
   IF CurrentMode = 2 THEN RUN DeleteTarget IN _hTrans.
END.


/* View Menu triggers */
ON MENU-DROP OF MENU mView DO:
  IF CONNECTED("xlatedb":U) THEN
    RUN adetran/pm/_getcnt.p
        (OUTPUT PhraseFlag, OUTPUT GlossaryFlag,
         OUTPUT TransFlag, OUTPUT NumProcs).

  CASE CurrentMode:
    WHEN 2 THEN DO:
      IF PhraseFlag THEN ASSIGN
        MENU-ITEM mSort:SENSITIVE IN MENU mView  = TRUE
        MENU-ITEM mOrder:SENSITIVE IN MENU mView = TRUE.
      ELSE ASSIGN
        MENU-ITEM mSort:SENSITIVE IN MENU mView  = FALSE
        MENU-ITEM mOrder:SENSITIVE IN MENU mView = FALSE.
    END.

    WHEN 3 THEN DO:
      IF GlossaryFlag THEN ASSIGN
        MENU-ITEM mSort:SENSITIVE IN MENU mView  = TRUE
        MENU-ITEM mOrder:SENSITIVE IN MENU mView = TRUE.
      ELSE ASSIGN
        MENU-ITEM mSort:SENSITIVE IN MENU mView  = FALSE
        MENU-ITEM mOrder:SENSITIVE IN MENU mView = FALSE.
    END.
  END CASE.
END.


ON CHOOSE OF MENU-ITEM mSort DO:
  RUN adecomm/_setcurs.p ("WAIT":U).
  IF CurrentMode = 2 THEN DO:
    RUN adetran/common/_sort.w (_hTrans, CurrentMode, CurrentTool).
  END.
  ELSE DO:
    RUN adetran/common/_sort.w (_hGloss, CurrentMode, CurrentTool).
  END.
END.


ON CHOOSE OF MENU-ITEM mOrder DO:
  IF CurrentMode = 2 THEN
     RUN adetran/common/_order.w(_hTrans, CurrentTool) .
  ELSE
     RUN adetran/common/_order.w(_hGloss, CurrentTool).
END.


ON CHOOSE OF BtnImport IN FRAME MainFrame OR
  CHOOSE OF MENU-ITEM mImport DO:
  IF CurrentPointer AND SELF:HANDLE = BtnImport:HANDLE THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U,{&import_command}, ?).
    RUN ResetCursor.
    RETURN.
  END.
  ELSE DO:
       RUN adecomm/_setcurs.p ("WAIT":U).
       IF CurrentMode = 3 THEN
          RUN adetran/common/_import.w.
       ELSE IF CurrentMode = 2 THEN
          RUN adetran/common/_impstr.w.
       RUN adecomm/_setcurs.p (" ":U).
  END.
END.


ON CHOOSE OF BtnExport IN FRAME MainFrame OR
  CHOOSE OF MENU-ITEM mExport DO:
  IF CurrentPointer AND SELF:HANDLE = BtnExport:HANDLE THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U,{&export_command_file_menu}, ?).
    RUN ResetCursor.
    RETURN.
  END.
  ELSE DO:
    DEFINE VARIABLE ExportFile AS CHARACTER NO-UNDO.

    IF CurrentMode = 3 THEN
    DO:
       SYSTEM-DIALOG GET-FILE ExportFile
         TITLE     "Save As"
         FILTERS   "Dump files (*.d)" "*.d":U,
                   "Text files (*.txt)" "*.txt":U,
                   "All files (*.*)"  "*.*":U
         DEFAULT-EXTENSION ".d"
         SAVE-AS USE-FILENAME ASK-OVERWRITE CREATE-TEST-FILE UPDATE OKPressed.

       IF OKPressed THEN DO:
         RUN adecomm/_setcurs.p ("WAIT":U).

         RUN adetran/common/_export.p (INPUT ExportFile).
         RUN adecomm/_setcurs.p ("").
       END.
     END. /* CurrentMode = 3 */
     ELSE
     DO:
         RUN adecomm/_setcurs.p ("WAIT":U).
         RUN adetran/common/_expstr.w.
         RUN adecomm/_setcurs.p ("").
     END.
  END.
END.


ON CHOOSE OF BtnConnect IN FRAME MainFrame OR
  CHOOSE OF MENU-ITEM mConnect DO:

  DEFINE VARIABLE was-connected AS LOGICAL NO-UNDO.
  IF CurrentPointer AND SELF:HANDLE = BtnConnect:HANDLE THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U,{&Database_Connections_Command}, ?).
    RUN ResetCursor.
    RETURN.
  END.
  ELSE DO:
    was-connected = CONNECTED("xlatedb":U).
    RUN destroy-objects.
    RUN protools/_dblist.w PERSISTENT.
    IF was-connected THEN DO:
      /* If still connected rebuild */
      IF CONNECTED("xlatedb":U) THEN RUN ResetMain.
      ELSE DO:
        MESSAGE "You have disconnected the project database.  You must" SKIP
                "reopen the project to continue working with it." SKIP
                "Any changes made to the project subset were not saved."
                VIEW-AS ALERT-BOX.
        APPLY "CHOOSE" TO MENU-ITEM mClose IN MENU mFile.
      END. /* Else DO */
    END. /* If xlatedb was-connected */
    ELSE RUN ResetMain.
  END.  /* Else looking not looking for help */
END.


ON CHOOSE OF BtnCompile IN FRAME MainFrame OR
  CHOOSE OF MENU-ITEM mCompile DO:
  IF CurrentPointer AND SELF:HANDLE = BtnCompile:HANDLE THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U,{&compile_command}, ?).
    RUN ResetCursor.
    RETURN.
  END.
  ELSE DO:
    RUN adecomm/_setcurs.p ("WAIT":U).
    RUN adetran/pm/_compdlg.w.
  END.
END.

ON CHOOSE OF MENU-ITEM mRun DO:
  RUN adecomm/_setcurs.p ("WAIT":U).
  RUN adetran/pm/_rundlg.w (INPUT THIS-PROCEDURE).
  RUN ResetMain.
END.


/* View/Option triggers */
ON CHOOSE OF BtnVT IN FRAME MainFrame DO:
  IF CurrentPointer THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U,1234, ?).
    RUN ResetCursor.
    RETURN.
  END.
  ELSE DO:
    RUN adecomm/_setcurs.p ("WAIT":U).
    /* RUN adetran/pm/_reports.w. */
    RUN _RunTool( INPUT "_vtran.p").
    RUN ResetMain.
  END.
END.


ON CHOOSE OF MENU-ITEM mi_cln-gloss DO:
  RUN adecomm/_setcurs.p ("WAIT":U).
  RUN adetran/pm/_clnglos.w.
END.


ON CHOOSE OF MENU-ITEM mi_exp-filtr DO:
  RUN adecomm/_setcurs.p ("WAIT":U).
  RUN adetran/pm/_expfltr.w.
END.


ON CHOOSE OF MENU-ITEM mi_imp-filtr DO:
  RUN adecomm/_setcurs.p ("WAIT":U).
  RUN adetran/pm/_impfltr.w.
END.


ON CHOOSE OF MENU-ITEM mi_pre-trans DO:
  RUN adetran/pm/_pretran.w.
END.


ON CHOOSE OF MENU-ITEM mi_calc-stats DO:
  IF VALID-HANDLE(_hStats) THEN
    RUN ViewStats IN _hStats (INPUT NO).
  RUN adetran/pm/_pmrecnt.p (INPUT _MainWindow).
  IF VALID-HANDLE(_hStats) THEN
    RUN SetStatistics IN _hStats (INPUT YES).
END.


ON CHOOSE OF MENU-ITEM mPrefs DO:
  RUN adetran/pm/_prefs.w.
END.


/*  Help triggers  */
ON CHOOSE OF MENU-ITEM mAbout DO:
  RUN adecomm/_about.p ("Translation Manager":U,"adetran/images/trans%":U).
END.


ON CHOOSE OF MENU-ITEM mContents OR HELP OF FRAME MainFrame DO:
  RUN adecomm/_adehelp.p ("tran":U, "topics":U,{&Main_Contents}, ?).
END.

ON CHOOSE OF MENU-ITEM mMaster DO:
  RUN adecomm/_adehelp.p ("mast":U, "topics":U,? , ?).
END.

ON CHOOSE OF MENU-ITEM mMsgs DO:
 run prohelp/_msgs.p.
END.


ON CHOOSE OF MENU-ITEM mRecentMsgs DO:
  run prohelp/_rcntmsg.p.
END.


ON CHOOSE OF BtnHelp IN FRAME MainFrame DO:
  ASSIGN CurrentPointer = TRUE
         result = BtnHelp:LOAD-IMAGE("adetran/images/help-d":U)
         result = BtnNew:LOAD-MOUSE-POINTER("adetran/images/help.cur":U)
         result = BtnOpen:LOAD-MOUSE-POINTER("adetran/images/help.cur":U)
         result = BtnPrint:LOAD-MOUSE-POINTER("adetran/images/help.cur":U)
         result = BtnCut:LOAD-MOUSE-POINTER("adetran/images/help.cur":U)
         result = BtnCopy:LOAD-MOUSE-POINTER("adetran/images/help.cur":U)
         result = BtnPaste:LOAD-MOUSE-POINTER("adetran/images/help.cur":U)
         result = BtnInsert:LOAD-MOUSE-POINTER("adetran/images/help.cur":U)
         result = BtnDelete:LOAD-MOUSE-POINTER("adetran/images/help.cur":U)
         result = BtnImport:LOAD-MOUSE-POINTER("adetran/images/help.cur":U)
         result = BtnExport:LOAD-MOUSE-POINTER("adetran/images/help.cur":U)
         result = BtnConnect:LOAD-MOUSE-POINTER("adetran/images/help.cur":U)
         result = BtnCompile:LOAD-MOUSE-POINTER("adetran/images/help.cur":U)
         result = BtnVT:LOAD-MOUSE-POINTER("adetran/images/help.cur":U)
         result = MainCombo:LOAD-MOUSE-POINTER("adetran/images/help.cur":U)
         result = BtnProcedures:LOAD-MOUSE-POINTER("adetran/images/help.cur":U)
         result = BtnData:LOAD-MOUSE-POINTER("adetran/images/help.cur":U)
         result = BtnGlossary:LOAD-MOUSE-POINTER("adetran/images/help.cur":U)
         result = BtnKit:LOAD-MOUSE-POINTER("adetran/images/help.cur":U)
         result = BtnStatistics:LOAD-MOUSE-POINTER("adetran/images/help.cur":U).
END.


/* Folder control triggers */
ON MOUSE-SELECT-CLICK OF BtnProcedures, TxtProc IN FRAME MainFrame
OR "ALT-P" OF FRAME MainFrame ANYWHERE DO:
  IF CurrentPointer THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U,{&procedures_tab_folder}, ?).
    RUN ResetCursor.
    RETURN NO-APPLY.
  END.
  ELSE IF CurrentMode = 1 THEN RETURN NO-APPLY.
  ELSE DO:
    APPLY "ENTRY":U TO MainCombo IN FRAME MainFrame.
    ASSIGN CurrentMode = 1
           result = TabControl:LOAD-IMAGE("adetran/images/tab5a":U)
           result = BtnProcedures:LOAD-IMAGE("adetran/labels/procs-b":U)
           result = BtnData:LOAD-IMAGE("adetran/labels/data":U)
           result = BtnGlossary:LOAD-IMAGE("adetran/labels/gloss":U)
           result = BtnKit:LOAD-IMAGE("adetran/labels/kits":U)
           result = BtnStatistics:LOAD-IMAGE("adetran/labels/stats":U).

    IF VALID-HANDLE(_hProcs)   THEN RUN Realize IN _hProcs.
    IF VALID-HANDLE(_hTrans)   THEN RUN HideMe  IN _hTrans.
    IF VALID-HANDLE(_hGloss)   THEN RUN HideMe  IN _hGloss.
    IF VALID-HANDLE(_hLongStr) THEN RUN HideMe  IN _hLongStr.
    IF VALID-HANDLE(_hKits)    THEN RUN HideMe  IN _hKits.
    IF VALID-HANDLE(_hStats)   THEN RUN HideMe  IN _hStats.
    IF VALID-HANDLE(_hFind)    THEN RUN HideMe  IN _hFind.
    IF VALID-HANDLE(_hReplace) THEN RUN HideMe  IN _hReplace.
    IF VALID-HANDLE(_hGoto)    THEN RUN HideMe  IN _hGoto.
    RUN SetSensitivity.
  END.
END.


ON MOUSE-SELECT-CLICK OF BtnData, TxtData IN FRAME MainFrame
OR "ALT-D" OF FRAME MainFrame ANYWHERE
DO:
  IF CurrentPointer THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U,{&data_tab_folder}, ?).
    RUN ResetCursor.
    RETURN NO-APPLY.
  END.
  ELSE IF CurrentMode = 2 THEN RETURN NO-APPLY.
  ELSE DO:
    APPLY "ENTRY":U TO MainCombo IN FRAME MainFrame.
    ASSIGN CurrentMode = 2
           result = TabControl:LOAD-IMAGE("adetran/images/tab5b":U)
           result = BtnProcedures:LOAD-IMAGE("adetran/labels/procs":U)
           result = BtnData:LOAD-IMAGE("adetran/labels/data-b":U)
           result = BtnGlossary:LOAD-IMAGE("adetran/labels/gloss":U)
           result = BtnKit:LOAD-IMAGE("adetran/labels/kits":U)
           result = BtnStatistics:LOAD-IMAGE("adetran/labels/stats":U).

    IF VALID-HANDLE(_hProcs)   THEN RUN HideMe  IN _hProcs.
    IF VALID-HANDLE(_hTrans)   THEN RUN Realize IN _hTrans.
    IF VALID-HANDLE(_hGloss)   THEN RUN HideMe  IN _hGloss.
    IF VALID-HANDLE(_hLongStr) THEN RUN HideMe  IN _hLongStr.
    IF VALID-HANDLE(_hKits)    THEN RUN HideMe  IN _hKits.
    IF VALID-HANDLE(_hStats)   THEN RUN HideMe  IN _hStats.
    IF VALID-HANDLE(_hFind)    THEN RUN HideMe  IN _hFind.
    IF VALID-HANDLE(_hReplace) THEN RUN HideMe  IN _hReplace.
    IF VALID-HANDLE(_hGoto)    THEN RUN HideMe  IN _hGoto.
    RUN SetSensitivity.
  END.
END.


ON MOUSE-SELECT-CLICK OF BtnGlossary, TxtGloss IN FRAME MainFrame
OR "ALT-G" OF FRAME MainFrame ANYWHERE
DO:
  IF CurrentPointer THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U,{&glossaries_tab_folder}, ?).
    RUN ResetCursor.
    RETURN NO-APPLY.
  END.
  ELSE IF CurrentMode = 3 THEN RETURN NO-APPLY.
  ELSE DO:
    APPLY "ENTRY":U TO MainCombo IN FRAME MainFrame.
    ASSIGN CurrentMode = 3
           result = TabControl:LOAD-IMAGE("adetran/images/tab5c":U)
           result = BtnProcedures:LOAD-IMAGE("adetran/labels/procs":U)
           result = BtnData:LOAD-IMAGE("adetran/labels/data":U)
           result = BtnGlossary:LOAD-IMAGE("adetran/labels/gloss-b":U)
           result = BtnKit:LOAD-IMAGE("adetran/labels/kits":U)
           result = BtnStatistics:LOAD-IMAGE("adetran/labels/stats":U).

    IF VALID-HANDLE(_hProcs)   THEN RUN HideMe  IN _hProcs.
    IF VALID-HANDLE(_hTrans)   THEN RUN HideMe  IN _hTrans.
    IF VALID-HANDLE(_hGloss)   THEN RUN Realize IN _hGloss.
    IF VALID-HANDLE(_hLongStr) THEN RUN HideMe  IN _hLongStr.
    IF VALID-HANDLE(_hKits)    THEN RUN HideMe  IN _hKits.
    IF VALID-HANDLE(_hStats)   THEN RUN HideMe  IN _hStats.
    IF VALID-HANDLE(_hFind)    THEN RUN HideMe  IN _hFind.
    IF VALID-HANDLE(_hReplace) THEN RUN HideMe  IN _hReplace.
    IF VALID-HANDLE(_hGoto)    THEN RUN HideMe  IN _hGoto.
    RUN SetSensitivity.
  END.
END.


ON MOUSE-SELECT-CLICK OF BtnKit, TxtKits IN FRAME MainFrame
OR "ALT-K" OF FRAME MainFrame ANYWHERE
DO:
  IF CurrentPointer THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U,{&kits_tab_folder}, ?).
    RUN ResetCursor.
    RETURN NO-APPLY.
  END.
  ELSE IF CurrentMode = 4 THEN RETURN NO-APPLY.
  ELSE DO:
    APPLY "ENTRY":U TO MainCombo IN FRAME MainFrame.
    ASSIGN CurrentMode = 4
           result = TabControl:LOAD-IMAGE("adetran/images/tab5d":U)
           result = BtnProcedures:LOAD-IMAGE("adetran/labels/procs":U)
           result = BtnData:LOAD-IMAGE("adetran/labels/data":U)
           result = BtnGlossary:LOAD-IMAGE("adetran/labels/gloss":U)
           result = BtnKit:LOAD-IMAGE("adetran/labels/kits-b":U)
           result = BtnStatistics:LOAD-IMAGE("adetran/labels/stats":U).

    IF VALID-HANDLE(_hProcs)   THEN RUN HideMe  IN _hProcs.
    IF VALID-HANDLE(_hTrans)   THEN RUN HideMe  IN _hTrans.
    IF VALID-HANDLE(_hGloss)   THEN RUN HideMe  IN _hGloss.
    IF VALID-HANDLE(_hLongStr) THEN RUN HideMe  IN _hLongStr.
    IF VALID-HANDLE(_hKits)    THEN RUN Realize IN _hKits.
    IF VALID-HANDLE(_hStats)   THEN RUN HideMe  IN _hStats.
    IF VALID-HANDLE(_hFind)    THEN RUN HideMe  IN _hFind.
    IF VALID-HANDLE(_hReplace) THEN RUN HideMe  IN _hReplace.
    IF VALID-HANDLE(_hGoto)    THEN RUN HideMe  IN _hGoto.
    RUN SetSensitivity.
  END.
END.


ON MOUSE-SELECT-CLICK OF BtnStatistics, TxtStats IN FRAME MainFrame
OR "ALT-S" OF FRAME MainFrame ANYWHERE
DO:
  IF CurrentPointer THEN DO:
    RUN adecomm/_adehelp.p ("tran":U, "context":U,{&statistics_tab_folder}, ?).
    RUN ResetCursor.
    RETURN NO-APPLY.
  END.
  ELSE IF CurrentMode = 5 THEN RETURN NO-APPLY.
  ELSE DO:
    APPLY "ENTRY":U TO MainCombo IN FRAME MainFrame.
    ASSIGN CurrentMode = 5
           result = TabControl:LOAD-IMAGE("adetran/images/tab5e":U)
           result = BtnProcedures:LOAD-IMAGE("adetran/labels/procs":U)
           result = BtnData:LOAD-IMAGE("adetran/labels/data":U)
           result = BtnGlossary:LOAD-IMAGE("adetran/labels/gloss":U)
           result = BtnKit:LOAD-IMAGE("adetran/labels/kits":U)
           result = BtnStatistics:LOAD-IMAGE("adetran/labels/stats-b":U).

    IF VALID-HANDLE(_hProcs)   THEN RUN HideMe  IN _hProcs.
    IF VALID-HANDLE(_hTrans)   THEN RUN HideMe  IN _hTrans.
    IF VALID-HANDLE(_hGloss)   THEN RUN HideMe  IN _hGloss.
    IF VALID-HANDLE(_hLongStr) THEN RUN HideMe  IN _hLongStr.
    IF VALID-HANDLE(_hKits)    THEN RUN HideMe  IN _hKits.
    IF VALID-HANDLE(_hStats)   THEN RUN Realize IN _hStats.
    IF VALID-HANDLE(_hFind)    THEN RUN HideMe  IN _hFind.
    IF VALID-HANDLE(_hReplace) THEN RUN HideMe  IN _hReplace.
    IF VALID-HANDLE(_hGoto)    THEN RUN HideMe  IN _hGoto.
    RUN SetSensitivity.
  END.
END.


/*
** ***************************************************************
** Window close and main code block
** ***************************************************************
*/
ON CLOSE OF THIS-PROCEDURE DO:
  IF tModFlag  THEN
    RUN adetran/pm/_pmrecnt.p (INPUT _MainWindow).

  RUN disable_ui.
END.


ON WINDOW-CLOSE OF _MainWindow OR
  CHOOSE OF MENU-ITEM mExit DO:

  DEFINE VARIABLE OK_Close  AS LOGICAL initial TRUE              NO-UNDO.
  DEFINE VARIABLE projs     AS INTEGER                           NO-UNDO.

  /* Wipe out temporary sort procedures */
  IF TmpFl_PM_Gl NE "" THEN OS-DELETE VALUE(TmpFl_PM_Gl).
  IF TmpFl_PM_Tr NE "" THEN OS-DELETE VALUE(TmpFl_PM_Tr).

  /* If menubar is insensitive, TM must be in a state that we cannot
     allow the user to exit TM. */
  IF MENU MainMenuBar:SENSITIVE = FALSE THEN RETURN NO-APPLY.

  /* Close all Procedure Windows belonging to TM. If it has none but
     it is the user's startup procedure, THEN PW's created by PRO*Tools
     will be closed properly. - jep
  */
  REPEAT ON STOP UNDO, LEAVE:
    RUN adecomm/_pwexit.p ( INPUT "_tran.p":U /* PW Parent ID */ ,
                            OUTPUT OK_Close ).
    LEAVE.
  END.

  /* Cancel the close event. */
  IF OK_Close <> TRUE THEN RETURN NO-APPLY.

  /* DISCONNECT from the project DBs */
  DO projs = 1 TO MainCombo:NUM-ITEMS IN FRAME MainFrame:
    IF CONNECTED(MainCombo:ENTRY(projs) IN FRAME MainFrame) THEN DO:
      CREATE ALIAS xlatedb FOR
        DATABASE VALUE(MainCombo:ENTRY(projs) IN FRAME MainFrame).
      RUN adetran/pm/_diskits.p.
      IF VALID-HANDLE(_hProcs) THEN
        RUN saveSubset IN _hProcs.
      DISCONNECT VALUE(MainCombo:ENTRY(projs) IN FRAME MainFrame).
    END.
  END.

  RUN adecomm/_adehelp.p ("tran":U, "QUIT":U, ?, ?).
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.


ON ENDKEY, END-ERROR OF _MainWindow ANYWHERE DO:
  RETURN NO-APPLY.
END.

PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

&SCOPED-DEFINE FRAME-NAME SplashFrame
{adetran/common/noscroll.i}

  ASSIGN
    FRAME SplashFrame:SCROLLABLE  = FALSE
    FRAME SplashFrame:PARENT      = _MainWindow
    FRAME SplashFrame:HIDDEN      = FALSE
    FRAME SplashFrame:X           = (_MainWindow:WIDTH-PIXELS / 2) -
                                             (FRAME SplashFrame:WIDTH-PIXELS / 2)
    FRAME SplashFrame:Y           = (_MainWindow:HEIGHT-PIXELS / 2) -
                                             (FRAME SplashFrame:HEIGHT-PIXELS / 2)
    result                        = _MainWindow:LOAD-ICON("adetran/images/trans%":U)
    _MainWindow:HIDDEN             = FALSE.

  VIEW FRAME SplashFrame IN WINDOW _MainWindow.

&SCOPED-DEFINE FRAME-NAME MainFrame
{adetran/common/noscroll.i}

  /* final run-time ASSIGNments  */
  ASSIGN FRAME MainFrame:SCROLLABLE    = FALSE
         CURRENT-WINDOW                = _MainWindow
         THIS-PROCEDURE:CURRENT-WINDOW = _MainWindow
         _hMain                        = THIS-PROCEDURE
         _hFileMenu                    = SUB-MENU mFile:HANDLE
         CurrentMode                   = 1.

  /* Read the *.ini file and populate the File menu  */
  RUN adecomm/_winmenu.w persistent  SET _hWinMgr.
  IF VALID-HANDLE(_hWinMgr) THEN _hWinMgr:PRIVATE-DATA = CurrentTool.

  GET-KEY-VALUE SECTION "Translation Manager":U key "Project":U value LastProject.
  GET-KEY-VALUE SECTION "Translation Manager":U key "Language":U value CurLanguage.
  GET-KEY-VALUE SECTION "Translation Manager":U key "Display Fullpath":U value TempLogical.
  _FullPathFlag = TempLogical = "YES".
  GET-KEY-VALUE SECTION "Translation Manager":U key "Suppress Extract Msgs":U value TempLogical.
  _ExtractWarnings = TempLogical = "YES".
  GET-KEY-VALUE SECTION "Translation Manager":U key "Suppress RC Msgs":U value TempLogical.
  _RCWarnings = TempLogical = "YES".

  IF LastProject = ? THEN LastProject = "".

  IF CONNECTED("xlatedb":U) THEN RUN adetran/pm/_find.w    PERSISTENT SET _hFind.
  IF CONNECTED("xlatedb":U) THEN RUN adetran/pm/_replace.w PERSISTENT SET _hReplace.
  IF CONNECTED("xlatedb":U) THEN RUN adetran/pm/_goto.w    PERSISTENT SET _hGoto.
  IF CONNECTED("xlatedb":U) THEN RUN adetran/pm/_pmprocs.w PERSISTENT SET _hProcs.
  IF CONNECTED("xlatedb":U) THEN RUN adetran/pm/_trans.p   PERSISTENT SET _hTrans.
  IF CONNECTED("xlatedb":U) THEN RUN adetran/pm/_gloss.p   PERSISTENT SET _hGloss.
  IF CONNECTED("xlatedb":U) THEN RUN adetran/pm/_longstr.w PERSISTENT SET _hLongStr.
  IF CONNECTED("xlatedb":U) THEN RUN adetran/pm/_kits.w    PERSISTENT SET _hKits.
  IF CONNECTED("xlatedb":U) THEN RUN adetran/pm/_pmstats.p PERSISTENT SET _hStats.

  RUN adetran/common/_meter.w PERSISTENT SET _hMeter (INPUT _MainWindow).

  IF CONNECTED("xlatedb":U) THEN MainCombo = LDBNAME("xlatedb":U).
  ELSE MainCombo = "Untitled":U.

  ASSIGN ProjectDB              = MainCombo
         MainCombo:LIST-ITEMS   = MainCombo
         MainCombo:SCREEN-VALUE = MainCombo.

  /* HISTORY DELETE
  IF LastProject <> "" THEN
    RUN WinMenuAddItem IN _hWinMgr (_hFileMenu, LastProject, _hMain).
  HISTORY DELETE */

  RUN TagProcedures.
  RUN enable_ui.
  RUN SetSensitivity.

  IF VALID-HANDLE(_hTrans) THEN RUN SetLanguages IN _hTrans.
  IF VALID-HANDLE(_hTrans) AND CurrentMode = 2 THEN RUN OpenQuery IN _hTrans.

  APPLY "ENTRY":U TO MainCombo IN FRAME MainFrame.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.  /* End of MAIN-BLOCK */



/*
** **************************************************************
** Procedures
** **************************************************************
*/
PROCEDURE disable_UI :
  DEFINE VARIABLE h AS HANDLE NO-UNDO.
  IF VALID-HANDLE(_hProcs) THEN RUN UnloadDLL IN _hProcs.

  h = SESSION:FIRST-PROCEDURE.
  DO WHILE h <> ?:
    CREATE PersistProcs.
    hProcedure = h.
    h          = h:NEXT-SIBLING.
  END.

  FOR EACH PersistProcs:
    IF VALID-HANDLE(hProcedure) AND
      hProcedure:PRIVATE-DATA = "PM":U THEN DELETE PROCEDURE hProcedure NO-ERROR.
  END.

  RUN WriteINI.

  DELETE WIDGET-POOL.
  DELETE WIDGET _MainWindow.
END PROCEDURE.


PROCEDURE enable_UI :
  DO WITH FRAME MainFrame:
    DISPLAY MainCombo TxtProc TxtData TxtGloss TxtKits TxtStats
      WITH FRAME MainFrame IN WINDOW _MainWindow.
    ENABLE TabBody BtnNew BtnOpen BtnPrint BtnCut BtnCopy BtnPaste BtnInsert BtnDelete
           BtnImport BtnConnect BtnCompile BtnVT BtnHelp MainCombo
           TabControl BtnProcedures TxtProc BtnData TxtData
           BtnGlossary TxtGloss BtnKit TxtKits BtnStatistics TxtStats
    WITH FRAME MainFrame IN WINDOW _MainWindow.

    /* run the persistent procedures */
    IF VALID-HANDLE(_hProcs) THEN DO:
      IF CurrentMode = 1 THEN RUN Realize IN _hProcs.
      IF CurrentMode = 2 THEN RUN Realize IN _hTrans.
      IF CurrentMode = 3 THEN RUN Realize IN _hGloss.
      IF CurrentMode = 4 THEN RUN Realize IN _hKits.
      IF CurrentMode = 5 THEN RUN Realize IN _hStats.
    END.

    ASSIGN MainCombo:SCREEN-VALUE = ProjectDB
           _MainWindow:TITLE      = "Translation Manager - ":U + ProjectDB.

    /* make it all visible  */
    VIEW _MainWindow.
    RUN adecomm/_setcurs.p ("").
  END.
END PROCEDURE.


PROCEDURE enable_menu_bar:
  ASSIGN menu MainMenuBar:SENSITIVE = TRUE
         frame MainFrame:SENSITIVE  = TRUE.
  RUN SetSensitivity.
END PROCEDURE.


PROCEDURE enable_widgets:
  IF CONNECTED("xlatedb":U) THEN RUN adetran/pm/_find.w    PERSISTENT SET _hFind.
  IF CONNECTED("xlatedb":U) THEN RUN adetran/pm/_replace.w PERSISTENT SET _hReplace.
  IF CONNECTED("xlatedb":U) THEN RUN adetran/pm/_goto.w    PERSISTENT SET _hGoto.
  IF CONNECTED("xlatedb":U) THEN RUN adetran/pm/_pmprocs.w PERSISTENT SET _hProcs.
  IF CONNECTED("xlatedb":U) THEN RUN adetran/pm/_trans.p   PERSISTENT SET _hTrans.
  IF CONNECTED("xlatedb":U) THEN RUN adetran/pm/_gloss.p   PERSISTENT SET _hGloss.
  IF CONNECTED("xlatedb":U) THEN RUN adetran/pm/_longstr.w PERSISTENT SET _hLongStr.
  IF CONNECTED("xlatedb":U) THEN RUN adetran/pm/_kits.w    PERSISTENT SET _hKits.
  IF CONNECTED("xlatedb":U) THEN RUN adetran/pm/_pmstats.p PERSISTENT SET _hStats.

  RUN enable_menu_bar.

  IF CONNECTED("xlatedb":U) AND CurrentMode = 1 THEN RUN Realize IN _hProcs.
  IF CONNECTED("xlatedb":U) AND CurrentMode = 2 THEN RUN Realize IN _hTrans.
  IF CONNECTED("xlatedb":U) AND CurrentMode = 3 THEN RUN Realize IN _hGloss.
  IF CONNECTED("xlatedb":U) AND CurrentMode = 4 THEN RUN Realize IN _hKits.
  IF CONNECTED("xlatedb":U) AND CurrentMode = 5 THEN RUN Realize IN _hStats.
END PROCEDURE.


PROCEDURE disable_menu_bar:
  DO WITH FRAME MainFrame:
    ASSIGN menu MainMenuBar:SENSITIVE = FALSE
           frame MainFrame:SENSITIVE  = FALSE
           BtnNew:SENSITIVE           = FALSE
           BtnOpen:SENSITIVE          = FALSE
           BtnImport:SENSITIVE        = FALSE
           BtnExport:SENSITIVE        = FALSE
           BtnPrint:SENSITIVE         = FALSE
           BtnConnect:SENSITIVE       = FALSE
           BtnCut:SENSITIVE           = FALSE
           BtnCopy:SENSITIVE          = FALSE
           BtnPaste:SENSITIVE         = FALSE
           BtnInsert:SENSITIVE        = FALSE
           BtnDelete:SENSITIVE        = FALSE
           BtnCompile:SENSITIVE       = FALSE
           BtnVT:SENSITIVE            = FALSE
           BtnHelp:SENSITIVE          = FALSE.
  END.  /* DO WITH FRAME Mainframe */
END PROCEDURE.


PROCEDURE disable_widgets:
  IF CONNECTED("xlatedb":U) and CurrentMode = 1 AND
     VALID-HANDLE(_hProcs) THEN RUN HideMe IN _hProcs.
  IF CONNECTED("xlatedb":U) and CurrentMode = 2 AND
     VALID-HANDLE(_hTrans) THEN RUN HideMe IN _hTrans.
  IF CONNECTED("xlatedb":U) and CurrentMode = 3 AND
     VALID-HANDLE(_hGloss) THEN RUN HideMe IN _hGloss.
  IF CONNECTED("xlatedb":U) and CurrentMode = 4 AND
     VALID-HANDLE(_hKits) THEN RUN HideMe IN _hKits.
  IF CONNECTED("xlatedb":U) and CurrentMode = 5 AND
     VALID-HANDLE(_hStats) THEN RUN HideMe IN _hStats.
  IF VALID-HANDLE(_hProcs)   THEN DELETE PROCEDURE _hProcs.
  IF VALID-HANDLE(_hTrans)   THEN DELETE PROCEDURE _hTrans.
  IF VALID-HANDLE(_hGloss)   THEN DELETE PROCEDURE _hGloss.
  IF VALID-HANDLE(_hLongStr) THEN DELETE PROCEDURE _hLongStr.
  IF VALID-HANDLE(_hKits)    THEN DELETE PROCEDURE _hKits.
  IF VALID-HANDLE(_hStats)   THEN DELETE PROCEDURE _hStats.
  IF VALID-HANDLE(_hFind)    THEN DELETE PROCEDURE _hFind.
  IF VALID-HANDLE(_hReplace) THEN DELETE PROCEDURE _hReplace.
  IF VALID-HANDLE(_hGoto)    THEN DELETE PROCEDURE _hGoto.
  IF VALID-HANDLE(_hSort)    THEN DELETE PROCEDURE _hSort.

  RUN disable_menu_bar.
END PROCEDURE.


PROCEDURE ResetCursor:
  CurrentPointer = FALSE.
  DO WITH FRAME MainFrame:
    result = BtnHelp:LOAD-IMAGE("adetran/images/help":U).

    result = BtnNew:LOAD-MOUSE-POINTER("arrow":U).
    result = BtnOpen:LOAD-MOUSE-POINTER("arrow":U).
    result = BtnPrint:LOAD-MOUSE-POINTER("arrow":U).
    result = BtnCut:LOAD-MOUSE-POINTER("arrow":U).
    result = BtnCopy:LOAD-MOUSE-POINTER("arrow":U).
    result = BtnPaste:LOAD-MOUSE-POINTER("arrow":U).
    result = BtnInsert:LOAD-MOUSE-POINTER("arrow":U).
    result = BtnDelete:LOAD-MOUSE-POINTER("arrow":U).
    result = BtnImport:LOAD-MOUSE-POINTER("arrow":U).
    result = BtnExport:LOAD-MOUSE-POINTER("arrow":U).
    result = BtnConnect:LOAD-MOUSE-POINTER("arrow":U).
    result = BtnCompile:LOAD-MOUSE-POINTER("arrow":U).
    result = BtnVT:LOAD-MOUSE-POINTER("arrow":U).

    result = MainCombo:LOAD-MOUSE-POINTER("arrow":U).
    result = BtnProcedures:LOAD-MOUSE-POINTER("arrow":U).
    result = BtnData:LOAD-MOUSE-POINTER("arrow":U).
    result = BtnGlossary:LOAD-MOUSE-POINTER("arrow":U).
    result = BtnKit:LOAD-MOUSE-POINTER("arrow":U).
    result = BtnStatistics:LOAD-MOUSE-POINTER("arrow":U).
  END.
END PROCEDURE.

PROCEDURE NotReady:
  MESSAGE "Option not implemented!".
END.


PROCEDURE SetSensitivity:
  DO WITH FRAME MainFrame:
  /* Note: cut/copy/paste are handled differently  */

  ASSIGN BtnVT:SENSITIVE = mnu_vtran_wh:SENSITIVE.

  IF CONNECTED("xlatedb":U) THEN
    RUN adetran/pm/_getcnt.p
        (OUTPUT PhraseFlag, OUTPUT GlossaryFlag,
         OUTPUT TransFlag, OUTPUT NumProcs).

  CASE CurrentMode:
    WHEN 1 THEN DO:
      ASSIGN
        BtnNew:SENSITIVE     = TRUE
        BtnOpen:SENSITIVE    = TRUE
        BtnPrint:SENSITIVE   = IF PROCESS-ARCHITECTURE = 32 THEN TRUE ELSE FALSE
        BtnImport:SENSITIVE  = FALSE
        BtnExport:SENSITIVE  = FALSE
        BtnInsert:SENSITIVE  = FALSE
        BtnDelete:SENSITIVE  = FALSE
        BtnConnect:SENSITIVE = TRUE
        BtnCompile:SENSITIVE = (NumProcs > 0)
        BtnHelp:SENSITIVE    = TRUE
        BtnCut:SENSITIVE    = TRUE
        BtnCopy:SENSITIVE   = TRUE
        BtnPaste:SENSITIVE  = TRUE

        MENU-ITEM mImport:SENSITIVE IN MENU mFile   = FALSE
        MENU-ITEM mExport:SENSITIVE IN MENU mFile   = FALSE
        MENU-ITEM mClose:SENSITIVE IN MENU mFile    = CONNECTED("xlatedb":U)
        MENU-ITEM mInsert:SENSITIVE IN MENU mEdit   = BtnInsert:SENSITIVE
        MENU-ITEM mDelete:SENSITIVE IN MENU mEdit   = BtnDelete:SENSITIVE
        MENU-ITEM mDeleteTarget:SENSITIVE IN MENU mEdit   = FALSE
        MENU-ITEM mFind:SENSITIVE IN MENU mEdit     = FALSE
        MENU-ITEM mReplace:SENSITIVE IN MENU mEdit  = FALSE
        MENU-ITEM mGoto:SENSITIVE IN MENU mEdit     = FALSE
        MENU-ITEM mSort:SENSITIVE IN MENU mView     = FALSE
        MENU-ITEM mOrder:SENSITIVE IN MENU mView    = FALSE
        MENU-ITEM mCompile:SENSITIVE IN MENU mBuild = BtnCompile:SENSITIVE
        MENU-ITEM mRun:SENSITIVE IN MENU mBuild     = CONNECTED("xlatedb":U)
        MENU-ITEM mi_cln-gloss:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_exp-filtr:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_imp-filtr:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_pre-trans:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_calc-stats:SENSITIVE IN MENU m_tm-util = FALSE.
     APPLY "ENTRY":U TO MainCombo IN FRAME MainFrame.
    END.

    WHEN 2 THEN DO:
      ASSIGN
        BtnNew:SENSITIVE     = TRUE
        BtnOpen:SENSITIVE    = TRUE
        BtnPrint:SENSITIVE   = IF PROCESS-ARCHITECTURE = 32 THEN TRUE ELSE FALSE
        BtnImport:SENSITIVE  = CONNECTED("xlatedb":U) and PhraseFlag
        BtnExport:SENSITIVE  = CONNECTED("xlatedb":U) and PhraseFlag
        BtnInsert:SENSITIVE  = FALSE
        BtnDelete:SENSITIVE  = CONNECTED("xlatedb":U) and PhraseFlag
        BtnConnect:SENSITIVE = TRUE
        BtnCompile:SENSITIVE = (NumProcs > 0)
        BtnHelp:SENSITIVE    = TRUE

        MENU-ITEM mImport:SENSITIVE IN MENU mFile   = BtnImport:SENSITIVE
        MENU-ITEM mExport:SENSITIVE IN MENU mFile   = BtnExport:SENSITIVE
        MENU-ITEM mClose:SENSITIVE IN MENU mFile    = CONNECTED("xlatedb":U)
        MENU-ITEM mInsert:SENSITIVE IN MENU mEdit   = BtnInsert:SENSITIVE
        MENU-ITEM mDelete:SENSITIVE IN MENU mEdit   = BtnDelete:SENSITIVE
        MENU-ITEM mDeleteTarget:SENSITIVE IN MENU mEdit = CONNECTED("xlatedb":U) AND TransFlag AND PhraseFlag
        MENU-ITEM mFind:SENSITIVE IN MENU mEdit     = CONNECTED("xlatedb":U)
        MENU-ITEM mReplace:SENSITIVE IN MENU mEdit  = CONNECTED("xlatedb":U)
        MENU-ITEM mGoto:SENSITIVE IN MENU mEdit     = CONNECTED("xlatedb":U)
        MENU-ITEM mSort:SENSITIVE IN MENU mView     = CONNECTED("xlatedb":U)
        MENU-ITEM mOrder:SENSITIVE IN MENU mView    = CONNECTED("xlatedb":U)
        MENU-ITEM mCompile:SENSITIVE IN MENU mBuild = BtnCompile:SENSITIVE
        MENU-ITEM mRun:SENSITIVE IN MENU mBuild     = CONNECTED("xlatedb":U)
        MENU-ITEM mi_cln-gloss:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_exp-filtr:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_imp-filtr:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_pre-trans:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_calc-stats:SENSITIVE IN MENU m_tm-util = FALSE.
    END.

    WHEN 3 THEN DO:
      ASSIGN
        BtnNew:SENSITIVE     = TRUE
        BtnOpen:SENSITIVE    = TRUE
        BtnPrint:SENSITIVE   = IF PROCESS-ARCHITECTURE = 32 THEN TRUE ELSE FALSE
        BtnImport:SENSITIVE  = s_Glossary <> "" and s_Glossary <> "None":U
        BtnExport:SENSITIVE  = s_Glossary <> "" and s_Glossary <> "None":U and GlossaryFlag
        BtnInsert:SENSITIVE  = CONNECTED("xlatedb":U)
        BtnDelete:SENSITIVE  = CONNECTED("xlatedb":U) and GlossaryFlag
        BtnConnect:SENSITIVE = TRUE
        BtnCompile:SENSITIVE = (NumProcs > 0)
        BtnHelp:SENSITIVE    = TRUE

        MENU-ITEM mImport:SENSITIVE IN MENU mFile   = CONNECTED("xlatedb":U)
        MENU-ITEM mExport:SENSITIVE IN MENU mFile   = CONNECTED("xlatedb":U)
        MENU-ITEM mClose:SENSITIVE IN MENU mFile    = CONNECTED("xlatedb":U)
        MENU-ITEM mInsert:SENSITIVE IN MENU mEdit   = BtnInsert:SENSITIVE
        MENU-ITEM mDelete:SENSITIVE IN MENU mEdit   = BtnDelete:SENSITIVE
        MENU-ITEM mDeleteTarget:SENSITIVE IN MENU mEdit   = FALSE
        MENU-ITEM mFind:SENSITIVE IN MENU mEdit     = CONNECTED("xlatedb":U)
        MENU-ITEM mReplace:SENSITIVE IN MENU mEdit  = CONNECTED("xlatedb":U)
        MENU-ITEM mGoto:SENSITIVE IN MENU mEdit     = FALSE
        MENU-ITEM mSort:SENSITIVE IN MENU mView     = CONNECTED("xlatedb":U)
        MENU-ITEM mOrder:SENSITIVE IN MENU mView    = CONNECTED("xlatedb":U)
        MENU-ITEM mCompile:SENSITIVE IN MENU mBuild = BtnCompile:SENSITIVE
        MENU-ITEM mRun:SENSITIVE IN MENU mBuild     = CONNECTED("xlatedb":U)
        MENU-ITEM mi_cln-gloss:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_exp-filtr:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_imp-filtr:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_pre-trans:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_calc-stats:SENSITIVE IN MENU m_tm-util = FALSE.
    END.

    WHEN 4 THEN DO:
      ASSIGN
        BtnCut:SENSITIVE     = FALSE
        BtnCopy:SENSITIVE    = FALSE
        BtnPaste:SENSITIVE   = FALSE

        BtnNew:SENSITIVE     = TRUE
        BtnOpen:SENSITIVE    = TRUE
        BtnPrint:SENSITIVE   = IF PROCESS-ARCHITECTURE = 32 THEN TRUE ELSE FALSE
        BtnImport:SENSITIVE  = FALSE
        BtnExport:SENSITIVE  = FALSE
        BtnInsert:SENSITIVE  = FALSE
        BtnDelete:SENSITIVE  = FALSE
        BtnConnect:SENSITIVE = TRUE
        BtnCompile:SENSITIVE = (NumProcs > 0)
        BtnHelp:SENSITIVE    = TRUE

        MENU-ITEM mImport:SENSITIVE IN MENU mFile   = FALSE
        MENU-ITEM mExport:SENSITIVE IN MENU mFile   = FALSE
        MENU-ITEM mClose:SENSITIVE IN MENU mFile    = CONNECTED("xlatedb":U)
        MENU-ITEM mInsert:SENSITIVE IN MENU mEdit   = FALSE
        MENU-ITEM mDelete:SENSITIVE IN MENU mEdit   = FALSE
        MENU-ITEM mDeleteTarget:SENSITIVE IN MENU mEdit   = FALSE
        MENU-ITEM mFind:SENSITIVE IN MENU mEdit     = FALSE
        MENU-ITEM mReplace:SENSITIVE IN MENU mEdit  = FALSE
        MENU-ITEM mGoto:SENSITIVE IN MENU mEdit     = FALSE
        MENU-ITEM mSort:SENSITIVE IN MENU mView     = FALSE
        MENU-ITEM mOrder:SENSITIVE IN MENU mView    = FALSE
        MENU-ITEM mCompile:SENSITIVE IN MENU mBuild = BtnCompile:SENSITIVE
        MENU-ITEM mRun:SENSITIVE IN MENU mBuild     = CONNECTED("xlatedb":U)
        MENU-ITEM mi_cln-gloss:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_exp-filtr:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_imp-filtr:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_pre-trans:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_calc-stats:SENSITIVE IN MENU m_tm-util = FALSE.
    END.

    OTHERWISE DO:
      ASSIGN
        BtnNew:SENSITIVE     = TRUE
        BtnOpen:SENSITIVE    = TRUE
        BtnPrint:SENSITIVE   = IF PROCESS-ARCHITECTURE = 32 OR CurrentMode = 5 THEN TRUE ELSE FALSE
        BtnImport:SENSITIVE  = FALSE
        BtnExport:SENSITIVE  = FALSE
        BtnInsert:SENSITIVE  = FALSE
        BtnDelete:SENSITIVE  = FALSE
        BtnConnect:SENSITIVE = TRUE
        BtnCompile:SENSITIVE = (NumProcs > 0)
        BtnHelp:SENSITIVE    = TRUE
        BtnCut:SENSITIVE    = FALSE
        BtnCopy:SENSITIVE   = FALSE
        BtnPaste:SENSITIVE  = FALSE

        MENU-ITEM mImport:SENSITIVE IN MENU mFile   = FALSE
        MENU-ITEM mExport:SENSITIVE IN MENU mFile   = FALSE
        MENU-ITEM mClose:SENSITIVE IN MENU mFile    = CONNECTED("xlatedb":U)
        MENU-ITEM mInsert:SENSITIVE IN MENU mEdit   = FALSE
        MENU-ITEM mDelete:SENSITIVE IN MENU mEdit   = FALSE
        MENU-ITEM mDeleteTarget:SENSITIVE IN MENU mEdit   = FALSE
        MENU-ITEM mFind:SENSITIVE IN MENU mEdit     = FALSE
        MENU-ITEM mReplace:SENSITIVE IN MENU mEdit  = FALSE
        MENU-ITEM mGoto:SENSITIVE IN MENU mEdit     = FALSE
        MENU-ITEM mSort:SENSITIVE IN MENU mView     = FALSE
        MENU-ITEM mOrder:SENSITIVE IN MENU mView    = FALSE
        MENU-ITEM mCompile:SENSITIVE IN MENU mBuild = BtnCompile:SENSITIVE
        MENU-ITEM mRun:SENSITIVE IN MENU mBuild     = CONNECTED("xlatedb":U)
        MENU-ITEM mi_cln-gloss:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_exp-filtr:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_imp-filtr:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_pre-trans:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U)
        MENU-ITEM mi_calc-stats:SENSITIVE IN MENU m_tm-util = CONNECTED("xlatedb":U).
    END.
  END CASE.
  END.
END PROCEDURE.


PROCEDURE CustSensi:
  DEFINE INPUT PARAMETER pWH AS WIDGET-HANDLE NO-UNDO.

  IF (VALID-HANDLE(pWH)) AND (CAN-QUERY(pWH,"type":U)) AND
     (pWH:TYPE = "browse":U)
  THEN ASSIGN
    btncut:SENSITIVE  IN FRAME MainFrame  = TRUE
    btncopy:SENSITIVE IN FRAME MainFrame  = TRUE
    btnpaste:SENSITIVE IN FRAME MainFrame = TRUE.
  ELSE ASSIGN
    btncut:SENSITIVE  IN FRAME MainFrame  = FALSE
    btncopy:SENSITIVE IN FRAME MainFrame  = FALSE
    btnpaste:SENSITIVE IN FRAME MainFrame = FALSE.
END PROCEDURE.


PROCEDURE create-objects:
  IF CONNECTED("xlatedb") THEN DO:
    RUN adetran/pm/_find.w    PERSISTENT SET _hFind.
    RUN adetran/pm/_replace.w PERSISTENT SET _hReplace.
    RUN adetran/pm/_goto.w    PERSISTENT SET _hGoto.
    RUN adetran/pm/_pmprocs.w PERSISTENT SET _hProcs.
    RUN adetran/pm/_trans.p   PERSISTENT SET _hTrans.
    RUN adetran/pm/_gloss.p   PERSISTENT SET _hGloss.
    RUN adetran/pm/_longstr.w PERSISTENT SET _hLongStr.
    RUN adetran/pm/_kits.w    PERSISTENT SET _hKits.
    RUN adetran/pm/_pmstats.p PERSISTENT SET _hStats.
  END. /* Only run these IF CONNected */
END PROCEDURE.  /* create-objects */


PROCEDURE destroy-objects:
    RUN adecomm/_setcurs.p ("WAIT":U).
    IF VALID-HANDLE(_hFind)    THEN RUN HideMe IN _hFind.
    IF VALID-HANDLE(_hReplace) THEN RUN HideMe IN _hReplace.
    IF VALID-HANDLE(_hGoto)    THEN RUN HideMe IN _hGoto.
    IF VALID-HANDLE(_hProcs)   THEN RUN HideMe IN _hProcs.
    IF VALID-HANDLE(_hTrans)   THEN RUN HideMe IN _hTrans.
    IF VALID-HANDLE(_hGloss)   THEN RUN HideMe IN _hGloss.
    IF VALID-HANDLE(_hLongStr) THEN RUN HideMe IN _hLongStr.
    IF VALID-HANDLE(_hKits)    THEN RUN HideMe IN _hKits.
    IF VALID-HANDLE(_hStats)   THEN RUN HideMe IN _hStats.

    IF VALID-HANDLE(_hProcs)   THEN DELETE PROCEDURE _hProcs.
    IF VALID-HANDLE(_hTrans)   THEN DELETE PROCEDURE _hTrans.
    IF VALID-HANDLE(_hGloss)   THEN DELETE PROCEDURE _hGloss.
    IF VALID-HANDLE(_hLongStr) THEN DELETE PROCEDURE _hLongStr.
    IF VALID-HANDLE(_hKits)    THEN DELETE PROCEDURE _hKits.
    IF VALID-HANDLE(_hStats)   THEN DELETE PROCEDURE _hStats.
    IF VALID-HANDLE(_hFind)    THEN DELETE PROCEDURE _hFind.
    IF VALID-HANDLE(_hReplace) THEN DELETE PROCEDURE _hReplace.
    IF VALID-HANDLE(_hGoto)    THEN DELETE PROCEDURE _hGoto.
    IF VALID-HANDLE(_hSort)    THEN DELETE PROCEDURE _hSort.
END PROCEDURE.  /* destroy-objects */


PROCEDURE ResetMain:
  DEFINE VARIABLE CurList AS CHARACTER NO-UNDO.
  DO WITH FRAME MainFrame:
    RUN destroy-objects.
    RUN create-objects.
    RUN TagProcedures.

    IF VALID-HANDLE(_hProcs) THEN
      RUN loadSubset IN _hProcs.

    ASSIGN s_Glossary = ""
           _Kit      = ""
           pXREFFileName = ""
           MENU MainMenuBar:SENSITIVE = TRUE
           FRAME MainFrame:SENSITIVE  = TRUE.
    RUN Enable_UI.
    RUN SetSensitivity.  /* 10/99 tomn: ??? necessary? we do this below again... */

    IF VALID-HANDLE(_hTrans) THEN DO:
      RUN SetLanguages IN _hTrans.
      IF CurrentMode = 2 THEN RUN OpenQuery IN _hTrans.
    END.

    RUN SetSensitivity.
    RUN adecomm/_setcurs.p ("").
    APPLY "ENTRY":U TO MainCombo.
  END. /* DO WITH FRAME MainFrame */
END PROCEDURE.


PROCEDURE TagProcedures:
  IF VALID-HANDLE(_hProcs)   THEN _hProcs:PRIVATE-DATA = CurrentTool.
  IF VALID-HANDLE(_hTrans)   THEN _hTrans:PRIVATE-DATA = CurrentTool.
  IF VALID-HANDLE(_hGloss)   THEN _hGloss:PRIVATE-DATA = CurrentTool.
  IF VALID-HANDLE(_hLongStr) THEN _hLongStr:PRIVATE-DATA = CurrentTool.
  IF VALID-HANDLE(_hKits)    THEN _hKits:PRIVATE-DATA = CurrentTool.
  IF VALID-HANDLE(_hStats)   THEN _hStats:PRIVATE-DATA = CurrentTool.
  IF VALID-HANDLE(_hFind)    THEN _hFind:PRIVATE-DATA = CurrentTool.
  IF VALID-HANDLE(_hReplace) THEN _hReplace:PRIVATE-DATA = CurrentTool.
  IF VALID-HANDLE(_hGoto)    THEN _hGoto:PRIVATE-DATA = CurrentTool.
  IF VALID-HANDLE(_hWinMgr)  THEN _hWinMgr:PRIVATE-DATA = CurrentTool.
  IF VALID-HANDLE(_hMeter)   THEN _hMeter:PRIVATE-DATA = CurrentTool.
END PROCEDURE.


PROCEDURE WinMenuChoose:
  DO WITH FRAME MainFrame:
  DEFINE INPUT PARAMETER pWindow AS CHARACTER                  NO-UNDO.
  DEFINE VARIABLE hThisProc      AS HANDLE                     NO-UNDO.
  DEFINE VARIABLE Extension      AS CHARACTER                  NO-UNDO.

  RUN adecomm/_osfext (pWindow,OUTPUT Extension).
  IF Extension = ".db":U AND ProjectDB = "Untitled":U THEN DO:
    /*
    ** Note: if this db is read from the progress.ini file and
    ** then ProjectDB = "Untitled" it means that the file was last used
    ** but isn't connected right now.  This procedure reconnects to it
    */
    RUN adecomm/_setcurs.p ("WAIT":U).
    ProjectDB = pWindow.
    RUN adetran/common/_alias.p (OUTPUT ErrorStatus).
    IF ErrorStatus THEN DO:
      RUN adecomm/_setcurs.p ("").
      RETURN.
    END.
    MainCombo = LDBNAME("xlatedb":U).
    MainCombo:LIST-ITEMS = MainCombo.

    ProjectDB = MainCombo.
    MainCombo:SCREEN-VALUE = ProjectDB.
    RUN ResetMain.
    RUN adecomm/_setcurs.p ("").
  END.
  END.
END.


PROCEDURE WriteINI:
  DEFINE VARIABLE ProjectName AS CHARACTER NO-UNDO.
  ASSIGN ProjectName        = PDBNAME("xlatedb":U) + ".db":U
         FILE-INFO:FILENAME = ProjectName
         ProjectName        = IF FILE-INFO:FULL-PATHNAME <> ?
                              THEN FILE-INFO:FULL-PATHNAME
                              ELSE "".

  /* Finally, write-out last databases used and preferences  */

  USE "".  /* Done to clear out [Loaded] progress.ini files. */

  PUT-KEY-VALUE SECTION "Translation Manager":U key "Project":U value ProjectName NO-ERROR.
  PUT-KEY-VALUE SECTION "Translation Manager":U key "Language":U value CurLanguage NO-ERROR.
  PUT-KEY-VALUE SECTION "Translation Manager":U key "Display Fullpath":U value string(_FullPathFlag) NO-ERROR.
  PUT-KEY-VALUE SECTION "Translation Manager":U key "Suppress Extract Msgs":U value
     string(_ExtractWarnings) NO-ERROR.
  PUT-KEY-VALUE SECTION "Translation Manager":U key "Suppress RC Msgs":U value
     string(_RCWarnings) NO-ERROR.

  IF ERROR-STATUS:ERROR THEN DO:
    RUN adecomm/_s-alert.p (
       INPUT-OUTPUT ErrorStatus,
       "w*":U,
       "ok":U,
       "Unable to save Translation Manager settings.^^The PROGRESS environment file may be read-only or it may be located in a directory where you do not have write permissions.").
  END.
END PROCEDURE.
