/*********************************************************************
* Copyright (C) 2000,2012-2013 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/vt/_main.p
Author:       R. Ryan/F. Chang
Created:      1/95 
Updated:      9/95
	      11/96 SLK Changed for FONT
		    Added Tooltips  
			lc/caps
		01/97 SLK Added warning Bug#97-01-09-061 dmy adte format
			Removed file history. 
		03/11/97 SLK Removed warning above
		03/97 SLK Bug#97-03-07-055 VT closing attempting to open non-kit db 
Purpose:      Visual Translator's main backbone program. 
Schema:       There are five tables that more-or-less relate to
              their counterparts in the Project Manager:
              
                XL_GlossEntry   the glossary
                XL_Instance   a combination of source/target for a
                              procedure (created from three tables:
                              XL_Original_String, XL_Translation,
                              XL_Instance).
                XL_Procedures the list of procedures copied verbatim
                              from the Project Manager.
                XL_Project    a single record with many fields that
                              describe the kit/project.  This table is
                              a superset of the one found in PM and 
                              includes many more fields.
                XL_Invalid    *not used*. Intended to be a validation
                              table that would make some translations
                              invalid (example: "Widget" wouldn't be
                              an acceptable translation but "Object" 
                              would be ok).
Triggers:     The database has a number of built-in triggers that
              update counters and/or update dates:
              
                vt/_trgcgls.p  'Create' trigger for XL_GlossEntry that
                               tracks the number of glossary entries
                               in XL_Project.GlossaryCount as well as
                               the last update in XL_Project.UpdateDate.
                vt/_trgdgls.p  'Delete' trigger fo XL_GlossEntry that
                               tracks the number of glossary entries
                               in XL_Project.GlossaryCount as well as
                               the last update in XL_Project.UpdateDate.
                vt/_trgwgls.p  'Write' trigger for XL_GlossEntry that reflects
                               the last update in XL_Project.UpdateDate.
                vt/_trgains.p  'Assign' trigger for XL_Instance that keeps
                               track of the 'CurrentStatus' in 
                               XL_Procedures.CurrentStatus.
                vt/_trgcins.p  'Create' trigger for XL_Instance that tracks
                               the number of phrases and update date in
                               XL_Project.NumberOfPhrases and 
                               XL_Project.UpdateDate.
                vt/_trgcins.p  'Delete' trigger for XL_Instance that tracks
                               the number of phrases and update date in
                               XL_Project.NumberOfPhrases and 
                               XL_Project.UpdateDate.
                vt/_trgwins.p  'Delete' trigger for XL_Instance that reflects
                               the update date in XL_Project.UpdateDate. 
                vt/_trgcprc.p  'Create' trigger for XL_Procedures that keeps
                               track of the number of procedures in XL_Project.
                vt/_trgdprc.p  'Delete' trigger for XL_Procedures that keeps
                               track of the number of procedures in XL_Project.
                
                                               
Architecture: The main components of the Visual Translator are:

                MainWindow - a handle to the Visual Translator window
                MainFrame  - a frame that covers the entire VT window
              
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
                             
                               - BtnProcedures runs hProcs (vt/_procs.w)
                               - BtnTranslation runs hTrans (vt/_trans.p)
                               - BtnGlossary runs hGloss (vt/_gloss.p)
                               - BtnStatistics runs hStats (vt/_stats.p)             
               
              Each tab folder has a single frame that is either displayed or
              hidden depending upon which button has been selected.  Each of
              these procedure procedures has at least 2 procedures:
              
                - Realize (enables widgets, sometimes opens queries, and makes
                  the frame visable).
                - HideMe (hides the frame)
                
              Note: MainFrame and each of the frames that are associated with the
              tabs are layed out in pixels - not PPUs (because of the use of the 
              underlying TabBody and TabControl images). Individual windows and dialogs
              use PPUs layout. As a button like BtnProcedures is selected, Realize is 
              run in hProcs and HideMe is run is the previous persistent procedure. O
              ther persistent procedures are:
              
                - hFind (vt/_find.w) the find 'dialog' (window)
                - hReplace (vt/_replace.w) the replace 'dialog' (window)
                - hGoto (vt/_goto.w) the goto 'dialog' (window)
                - hProps (vt/_props.w) the Property Window
                - hTrlkup (vt/_trlkup.w) the Glossary Lookup 'dialog' (window)            
                - hMeter (common/_meter.w) the meter frame 
                - hWinMgr (adecomm/_winmenu.w) the Windows/File manager for tracking
                  visual procedures and/or the last kit database.
              
Procedures:   Key internal procedures include:

              ResetMain        - when new projects are opened, ResetMain is run so that
                                 persistent procedures that are *binded* to a databases'
                                 alias can get reset.
              SetSensitivity   - sets MENU-ITEMs and button's sensitivity.
              ResetCursor      - resets the cursor back to 'arrow' once the help 
                                 button was depressed.
              WinMenuChoose    - Used by hWinMgr when a kit database and/or a visual
                                 procedure (from the Windows menu) was selected.
                               
              Key external procedures include:
              
              vt/_reset.p       -  Used to reset the kit alias to a different kit db.
              common/_k-alias   - Used to connect or reconnect to a kit database and
                                  reset the alias.
              common/_kschema.p - Used to check that the database that is being opened
                                  is a valid kit database (not a project db)
 
Variables:    Key variables include (see adetran/vt/_shrvar.i)

              CurrentMode    1=Procedures,2=Translation,3=Glossary,4=Statistics
              CurrentPointer arrow or help cursor  
              CurrentTool    always 'VT' used to tag persistent procedures
              KitDB          the ldb of the kit database
              _Kit           same as above (never changed over)  
              CurWin         current window of the visual procedure
              CurObj         current handle of the widget being translated
                                                                  
*/          

/* ************************* LICENSE CHECK *****************************/
DEFINE VARIABLE _VT_license AS INTEGER NO-UNDO.
ASSIGN _VT_license = GET-LICENSE ("VISUAL-TRANSLATOR":U).
IF _VT_license NE 0 THEN 
DO:
   MESSAGE "A license for the Visual Translator is not available."
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   STOP.
END.

RUN adecomm/_setcurs.p ("WAIT":U).
CREATE WIDGET-POOL.

{ adetran/vt/vthlp.i } /* definitions for help context strings */ 

ASSIGN SESSION:IMMEDIATE-DISPLAY = TRUE
       SESSION:APPL-ALERT-BOX    = TRUE
       SESSION:THREE-D           = TRUE.   

{adetran/vt/_shrvar.i &NEW = NEW}

/* Temporary files generated by _sort.w and _order.w.                */
/* If these are blank then the regular OpenQuery internal procedures */
/* are run, otherwise these will be run                              */
DEFINE NEW SHARED VAR TmpFl_VT_Gl AS CHARACTER              NO-UNDO.
DEFINE NEW SHARED VAR TmpFl_VT_Tr AS CHARACTER              NO-UNDO.
DEFINE NEW SHARED VAR tDispType   AS CHARACTER              NO-UNDO.
DEFINE NEW SHARED VAR _bkupExt    AS CHARACTER INITIAL ".bku":U NO-UNDO.
DEFINE NEW SHARED VAR _Lang       AS CHARACTER              NO-UNDO.

DEFINE VARIABLE TempString     AS CHARACTER                 NO-UNDO. 
DEFINE VARIABLE CurFocus       AS CHARACTER                 NO-UNDO. 
DEFINE VARIABLE CurList        AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE Result         AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE CurrentPointer AS LOGICAL                   NO-UNDO.  
DEFINE VARIABLE ErrorStatus    AS LOGICAL                   NO-UNDO. 
DEFINE VARIABLE flnm           AS CHARACTER INITIAL "status.txt"
                                                            NO-UNDO.
DEFINE VARIABLE fnt            AS INTEGER   INITIAL ?       NO-UNDO.
DEFINE VARIABLE i              AS INTEGER                   NO-UNDO.
DEFINE VARIABLE LPP            AS INTEGER   INITIAL 60      NO-UNDO.
DEFINE VARIABLE OKPressed      AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE OrigProPath    AS CHARACTER                 NO-UNDO. 
DEFINE VARIABLE PrFlag         AS INTEGER   INITIAL 0       NO-UNDO.  
DEFINE VARIABLE TransFlag      AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE GlossaryFlag   AS LOGICAL                   NO-UNDO.     
DEFINE VARIABLE ThisMessage    AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE resStatus      AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE lError         AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE UNZipDir       AS CHARACTER                 NO-UNDO.

&IF LOOKUP("{&OPSYS}","MSDOS,WIN32":U) > 0 &THEN
    &SCOPED-DEFINE SLASH ~~~\
&ELSE
    &SCOPED-DEFINE SLASH /
&ENDIF

DEFINE SUB-MENU mFile             
  MENU-ITEM mInstKit       LABEL "&Install Kit..." 
  MENU-ITEM mRetKit        LABEL "&Return Kit..."
  RULE
  MENU-ITEM mOpen          LABEL "&Open..." accelerator "F3"
  MENU-ITEM mOpenMulti     LABEL "Open &MultiUser..."
  MENU-ITEM mClose         LABEL "&Close"  accelerator "F8"
  RULE
  MENU-ITEM mImport        LABEL "&Import..." 
  MENU-ITEM mExport        LABEL "&Export..." 
  RULE
  MENU-ITEM mPrintScreen   LABEL "&Print Screen..." accelerator "CTRL-P"
  RULE                                     
  MENU-ITEM mExit          LABEL "E&xit".

DEFINE SUB-MENU mEdit 
  MENU-ITEM mCut           LABEL "Cu&t" accelerator "SHIFT-DEL"
  MENU-ITEM mCopy          LABEL "&Copy" accelerator "CTRL-INS"
  MENU-ITEM mPaste         LABEL "&Paste" accelerator "SHIFT-INS"
  RULE   
  MENU-ITEM mInsert        LABEL "I&nsert" accelerator "CTRL-N"
  MENU-ITEM mDelete        LABEL "&Delete" accelerator "CTRL-D"
  RULE
  MENU-ITEM mFind          LABEL "&Find..." accelerator "CTRL-F"
  MENU-ITEM mReplace       LABEL "&Replace..." accelerator "CTRL-R"
  MENU-ITEM mGoto          LABEL "&Goto..." accelerator "CTRL-G".
  
DEFINE SUB-MENU mView 
  MENU-ITEM mSort          LABEL "&Sort..." 
  MENU-ITEM mOrder         LABEL "&Order Columns..."
  RULE
  MENU-ITEM mView          LABEL "&View Procedure".             
 
DEFINE SUB-MENU mOptions 
  MENU-ITEM mPrefs         LABEL "&Preferences...".
  
DEFINE SUB-MENU mWindow
  MENU-ITEM mProps         LABEL "&Properties" toggle-box
  MENU-ITEM mGloss         LABEL "&Glossary" toggle-box.

DEFINE SUB-MENU m_tm-util
  MENU-ITEM mi_cln-gloss   LABEL "&Cleanup Glossaries..."
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
 
DEFINE SUB-MENU mHelp 
  MENU-ITEM mMaster        LABEL "OpenEdge &Master Help"
  MENU-ITEM mContents      LABEL "Visual Translator &Help Topics"     
  RULE
  MENU-ITEM mMsgs          LABEL "M&essages..."
  MENU-ITEM mRecentMsgs    LABEL "&Recent Messages..."
  RULE
  MENU-ITEM mAbout         LABEL "&About Visual Translator" .

DEFINE MENU MainMENUBAR MENUBAR
  SUB-MENU  mFile          LABEL "&File"  
  SUB-MENU  mEdit          LABEL "&Edit" 
  SUB-MENU  mView          LABEL "&View"   
  SUB-MENU  mOptions       LABEL "&Options"   
  SUB-MENU  mWindow        LABEL "&Window"   
  SUB-MENU  mnu_Tools      LABEL "&Tools" 
  SUB-MENU  mHelp          LABEL "&Help".

{ adecomm/toolrun.i
  &MENUBAR=MainMENUBAR
  &EXCLUDE_TRAN=YES
  &EXCLUDE_VTRAN=yes
  &PERSISTENT=PERSISTENT
}
  
  
CREATE WINDOW MainWindow ASSIGN
   HIDDEN                  = YES
   TITLE                   = "Visual Translator - Untitled"
   HEIGHT-PIXELS           = 393
   WIDTH-PIXELS            = 633  
   MAX-HEIGHT-PIXELS       = 393
   MAX-WIDTH-PIXELS        = 633
   VIRTUAL-HEIGHT-PIXELS   = 393
   VIRTUAL-WIDTH-PIXELS    = 633   
   RESIZE                  = YES
   SCROLL-BARS             = NO
   STATUS-AREA             = NO
   BGCOLOR                 = 8
   FGCOLOR                 = ?
   KEEP-FRAME-Z-ORDER      = YES
   THREE-D                 = YES
   MESSAGE-AREA            = NO  
   MENUBAR                 = MENU MainMenubar:HANDLE
   MAX-BUTTON              = NO
   SENSITIVE               = YES.  
   
/*
** The first stuff that gets setup, is the splash screen, the menu and the
** window.
*/    

DEFINE IMAGE SplashImage
  FILENAME "adetran/images/vtlogo":U
  SIZE-PIXELS 432 BY 266 BGCOLOR 8 FGCOLOR 8.
  
DEFINE FRAME SplashFrame
  SplashImage
  WITH SIZE-PIXELS 432 BY 266 NO-BOX FONT 4 BGCOLOR 8.

&SCOPED-DEFINE FRAME-NAME SplashFrame
{adetran/common/noscroll.i}

ASSIGN   
  FRAME SplashFrame:SCROLLABLE  = FALSE
  FRAME SplashFrame:PARENT      = MainWindow
  FRAME SplashFrame:HIDDEN      = FALSE 
  FRAME SplashFrame:X           = (MainWindow:WIDTH-PIXELS / 2) -
                                       (FRAME SplashFrame:WIDTH-PIXELS / 2)
  FRAME SplashFrame:Y           = (MainWindow:HEIGHT-PIXELS / 2) -
                                       (FRAME SplashFrame:HEIGHT-PIXELS / 2)
  OrigProPath                   = PROPATH
  result                        = MainWindow:LOAD-ICON("adetran/images/vt%":U)
  MainWindow:HIDDEN             = FALSE.                           

VIEW FRAME SplashFrame IN WINDOW MainWindow.

/* define the rest of the objects and variables */
DEFINE VARIABLE SettingsFile AS CHARACTER NO-UNDO.
DEFINE TEMP-TABLE PersistProcs
  FIELD hProcedure AS HANDLE.

DEFINE VARIABLE MainCombo AS CHARACTER FORMAT "X(256)":U 
   VIEW-AS COMBO-BOX INNER-LINES 5
   LIST-ITEMS " " SIZE-PIXELS 153 BY 26
   BGCOLOR 8 NO-UNDO.

 
/* Now the rest of the window and variables are defined */
DEFINE VARIABLE hStats      AS HANDLE                         NO-UNDO.
DEFINE VARIABLE hGoto       AS HANDLE                         NO-UNDO.
DEFINE VARIABLE TempLogical AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE LastKit     AS CHARACTER                      NO-UNDO.

/* Buttons on the toolbar */
DEFINE BUTTON BtnOpen 
  IMAGE FILE "adetran/images/open":U
  SIZE-PIXELS 30 BY 30
  TOOLTIP "Open"
  NO-FOCUS FLAT-BUTTON. 

DEFINE BUTTON BtnPrint 
  IMAGE FILE "adetran/images/print":U
  TOOLTIP "Print"
  LIKE BtnOpen.

DEFINE BUTTON BtnCut 
  IMAGE FILE "adetran/images/cut":U
  TOOLTIP "Cut"
  LIKE BtnOpen.

DEFINE BUTTON BtnCopy 
  IMAGE FILE "adetran/images/copy":U
  TOOLTIP "Copy"
  LIKE BtnOpen.
  
DEFINE BUTTON BtnPaste 
  IMAGE FILE "adetran/images/paste":U
  TOOLTIP "Paste"
  LIKE BtnOpen.

DEFINE BUTTON BtnInsert 
  IMAGE FILE "adetran/images/insert":U
  TOOLTIP "Insert"
  LIKE BtnOpen.
  
DEFINE BUTTON BtnDelete 
  IMAGE FILE "adetran/images/delete":U
  TOOLTIP "Delete"
  LIKE BtnOpen.
  
DEFINE BUTTON BtnFind 
  IMAGE FILE "adetran/images/find":U
  TOOLTIP "Find"
  LIKE BtnOpen.

DEFINE BUTTON BtnOrder 
  IMAGE FILE "adetran/images/order":U
  TOOLTIP "Order"
  LIKE BtnOpen.
  
DEFINE BUTTON BtnSort 
  IMAGE FILE "adetran/images/sort":U
  TOOLTIP "Sort"
  LIKE BtnOpen. 
  
DEFINE BUTTON BtnView 
  IMAGE FILE "adetran/images/view":U
  TOOLTIP "View"
  LIKE BtnOpen.

DEFINE BUTTON BtnHelp 
  IMAGE FILE "adetran/images/help":U
  TOOLTIP "Help"
  LIKE BtnOpen. 
  
  
/* Fake buttons that serve as tab labels */
DEFINE BUTTON Btnprocedures 
       IMAGE-UP FILE "adetran/labels/procs-b":U
       IMAGE-DOWN FILE "adetran/labels/procs":U
       SIZE-PIXELS 24 BY 20.

DEFINE VARIABLE TxtProcs AS CHARACTER VIEW-AS TEXT
          SIZE-PIXELS 105 BY 20 FORMAT "X(17)"            NO-UNDO.
TxtProcs = "&Procedures":L17.

DEFINE BUTTON BtnTranslations
       IMAGE-UP FILE "adetran/labels/trans":U
       IMAGE-DOWN FILE "adetran/labels/trans":U
       SIZE-PIXELS 24 BY 20.

DEFINE VARIABLE TxtTrans AS CHARACTER VIEW-AS TEXT
          SIZE-PIXELS 105 BY 20 FORMAT "X(17)"            NO-UNDO.
TxtTrans = "&Translations":L17.

DEFINE BUTTON BtnGlossary
       IMAGE-UP FILE "adetran/labels/gloss":U
       IMAGE-DOWN FILE "adetran/labels/gloss":U
       SIZE-PIXELS 24 BY 20.

DEFINE VARIABLE TxtGloss AS CHARACTER VIEW-AS TEXT
          SIZE-PIXELS 105 BY 20 FORMAT "X(17)"            NO-UNDO.
TxtGloss = "&Glossary":L17.

DEFINE BUTTON BtnStatistics
       IMAGE-UP FILE "adetran/labels/stats":U
       IMAGE-DOWN FILE "adetran/labels/stats":U
       SIZE-PIXELS 24 BY 20.

DEFINE VARIABLE TxtStats AS CHARACTER VIEW-AS TEXT
          SIZE-PIXELS 105 BY 20 FORMAT "X(17)"       NO-UNDO.
TxtStats = "&Statistics":L17.



/* Remaining objects that appear on the mainframe */
DEFINE IMAGE TabBody
   FILENAME "adetran/images/tab4body":U
   SIZE-PIXELS 622 by 350.

DEFINE IMAGE TabControl
   FILENAME "adetran/images/tab4a":U
   SIZE-PIXELS 622 by 34.

  
DEFINE TEMP-TABLE VisualProcedures
  FIELD hProcedure     AS HANDLE
  FIELD ProcedureName  AS CHARACTER. 

DEFINE FRAME MainFrame 
  TabBody    AT X 7   Y 7
  TabControl AT X 7   Y 356
  MainCombo  AT X 15  Y 16  NO-LABEL 
  
  BtnOpen    AT X 187 Y 14 
  BtnPrint   AT X 217 Y 14
  
  BtnCut     AT X 254 Y 14
  BtnCopy    AT X 284 Y 14
  BtnPaste   AT X 314 Y 14
  
  BtnInsert  AT X 351 Y 14
  BtnDelete  AT X 381 Y 14
  BtnSort    AT X 411 Y 14
  BtnOrder   AT X 441 Y 14
  BtnFind    AT X 471 Y 14
  
  BtnView    AT X 508 Y 14
  BtnHelp    AT X 538 Y 14
  BtnProcedures   AT X  13 Y 361 TxtProcs VIEW-AS TEXT NO-LABEL AT X  37 Y 361
  BtnTranslations AT X 150 Y 361 TxtTrans VIEW-AS TEXT NO-LABEL AT X 174 Y 361
  BtnGlossary     AT X 289 Y 361 TxtGloss VIEW-AS TEXT NO-LABEL AT X 313 Y 361
  BtnStatistics   AT X 426 Y 361 TxtStats VIEW-AS TEXT NO-LABEL AT X 450 Y 361

  WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY SIDE-LABELS NO-UNDERLINE 
       THREE-D AT COLUMN 1 ROW 1 SIZE-PIXELS 633 BY 393 BGCOLOR 8 FONT 4 .
 

/*         
** **************************************************************
** Triggers                                                      
** **************************************************************
*/  

/*
** File load/open/save triggers
*/  
ON CHOOSE OF MENU-ITEM mExport DO:
  DEFINE VARIABLE ExportFile AS CHARACTER                         NO-UNDO.
  
  SYSTEM-DIALOG GET-FILE ExportFile
      TITLE     "Save As"
      FILTERS   "Dump files (*.d)"  "*.d":U,
                "Text files *.txt)" "*.txt":U,
                "All files (*.*)"   "*.*":U     
      SAVE-AS USE-FILENAME ask-overwrite create-test-file update OKPressed.

    if OKPressed then DO: 
      run adecomm/_setcurs.p ("wait":U).    
      
      if CurrentMode = 2 then 
         run adetran/common/_TrsExpt.p (input ExportFile).
      else   
      if CurrentMode = 3 then 
        run adetran/common/_GlsExpt.p (input ExportFile).
        
      run adecomm/_setcurs.p ("").
    END.    
END.
ON CHOOSE OF MENU-ITEM mImport DO:
    run adetran/common/_GlsImpt.w.
END.

 
ON CHOOSE OF MENU-ITEM mInstKit DO:
  DEFINE VARIABLE ZipFile    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ZipStatus  AS LOGICAL   NO-UNDO. 
  DEFINE VARIABLE ZipComment AS CHARACTER NO-UNDO.
  DEFINE VARIABLE KitDB      AS CHARACTER NO-UNDO.
  
  run adetran/vt/_instzip.w (OUTPUT ZipFile, OUTPUT UNZipDir).
  IF ZipFile NE "" AND UNZipDir NE "" THEN DO:                
    /* Get Zipfile comment string so we can determine the database
     * being installed 
     */
    RUN adetran/common/_zipmgr.w (INPUT "GETCOMMENT",      /* Mode */
                                  INPUT ZipFile,           /* ZipFileName */
                                  INPUT "",                /* ZipDir */
                                  INPUT "",                /* BkupFile */
                                  INPUT "",                /* ItemList */
                                  INPUT 0,                 /* ZCompFactor */
                                  INPUT YES,               /* Recursive */
                                  INPUT-OUTPUT ZipComment, /* ZipComment */
                                  OUTPUT ZipStatus).       /* ZipStatus */
    IF ZipStatus THEN
    DO:
      IF ZipComment NE "" THEN
        KitDB = (IF NUM-ENTRIES(ZipComment,":") = 3 THEN TRIM(ENTRY(3,ZipComment,":")) ELSE "").  
    END.
    ELSE DO:
      MESSAGE "Error extracting zipfile comment. This zipfile may not have been created by TranMan." SKIP 
              "Unzip operation aborted." 
        VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.    
    END.
    
    IF ZipComment = "" OR NOT ZipComment BEGINS "TranMan" THEN DO:
      MESSAGE "This zip file does not appear to be created by TranMan." SKIP 
              "Unzip operation aborted." 
        VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
    END.    
    IF CONNECTED(KitDB) THEN RUN RemoveKitRef (KitDB).
    RUN adetran/common/_zipmgr.w (INPUT "UNZIP":U,         /* Mode */
                                  INPUT ZipFile,           /* ZipFileName */
                                  INPUT UNZipDir,          /* ZipDir */
                                  INPUT "",                /* BkupFile */
                                  INPUT "",                /* ItemList */
                                  INPUT 0,                 /* ZCompFactor */
                                  INPUT YES,               /* Recursive */
                                  INPUT-OUTPUT ZipComment, /* ZipComment */
                                  OUTPUT ZipStatus).       /* ZipStatus */
    IF ZipStatus THEN
    DO:
      RUN adetran/common/_dbmgmt.p (INPUT "RESTORE":U,
                                    INPUT UNZipDir + "\":U + KitDB,
                                    INPUT kitDB,
                                    INPUT UNZipDir + "\":U + KitDB,
                                    INPUT ?,
                                    OUTPUT lError).
      IF lError THEN
      DO:
         MESSAGE "Could not restore database from unzipped file." SKIP 
              "Unzip operation aborted." 
         VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
      END.
      ELSE
      DO:
         MESSAGE "Zip file was unzipped successfully."
         VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
         RUN OpenKit(UNZipDir + "\":U + KitDB, "", "", "", "", "").   
         IF CONNECTED("kit":U) THEN
         DO:
            RUN adetran/vt/_setappd.p (UNZipDir). /* Set ApplDirectory */
            IF ENTRY(1,PROPATH) = "":U THEN PROPATH = ",":U + UNZipDir + PROPATH.
            ELSE PROPATH = PROPATH + ",":U + UNZipDir.
         END.
       END. /* restored successfully */
    END. /* unzipped successfully */
    ELSE
    DO:
      MESSAGE "Zip file was not unzipped successfully."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.  
      RETURN NO-APPLY.
    END. /* failed unzipping */
  END. /* something to unzip */
END. 

ON CHOOSE OF MENU-ITEM mRetKit DO:                               
  DEFINE VARIABLE ZipFileName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE BkupFile    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ItemList    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ProjPath    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ZipStatus   AS LOGICAL   NO-UNDO.   
  DEFINE VARIABLE inp         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ZipComp     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ZipComment  AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cPrefix     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBasename   AS CHARACTER NO-UNDO.
  
  IF KitDB = "" OR KitDB = "Untitled":U THEN
  DO:
    MESSAGE "You must open a kit to be able to create a zipfile."
      VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END. /* no kit */

  GET-KEY-VALUE SECTION "Translation Manager":U key "ZipCompFactor":U value inp.
  IF inp = ? OR inp = "" OR INT(inp) < 1 OR INT(inp) > 10 THEN
    ASSIGN ZipComp = 5.
  ELSE
    ASSIGN ZipComp = INT(inp).
    
  ASSIGN ZipComment = "TranMan2 Return Kit Zipfile. " +
                      "Created on " + STRING(TODAY) +
                      " at " + STRING(TIME,"HH:MM AM") +
                      " KitDB: " + REPLACE(KitDB,".db":U,"").
                      
  RUN adetran/vt/_crzip.w (OUTPUT ZipFileName, OUTPUT BkupFile, OUTPUT ItemList, OUTPUT ProjPath).

  IF ZipFileName NE "" AND ItemList NE "" THEN
  DO:
     RUN adecomm/_setcurs.p ("WAIT":U).
     RUN RemoveKitRef (KitDB).
     /* ItemList is only the *.bku file */
     RUN adecomm/_osprefx.p (INPUT ItemList, OUTPUT cPrefix, OUTPUT cBaseName).
     cPrefix = IF SUBSTR(cPrefix, LENGTH(cPrefix), 1) = "{&SLASH}" 
                 THEN SUBSTR(cPrefix, 1, LENGTH(cPrefix) - 1) ELSE cPrefix.
     RUN adetran/common/_dbmgmt.p (INPUT "BACKUP":U,
                                INPUT cPrefix + "{&SLASH}" + KitDB + ".db":U,   
                                INPUT kitDB,
                                INPUT cPrefix + "{&SLASH}" + KitDB + ".db":U,   
                                INPUT ?,
                                OUTPUT lError).
     IF lError THEN
     DO:
        MESSAGE "Database could not be backed up successfully."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.  
        ASSIGN ZipStatus = NO.
     END. /* error in backup of kit */
     ELSE
     DO:
        RUN adetran/common/_zipmgr.w (INPUT         "ZIP":U,     /* Mode */
                                      INPUT         ZipFileName, /* ZipFileName */
                                      INPUT         ProjPath,    /* ZipDir */
                                      INPUT         BkupFile,    /* BkupFile */
                                      INPUT         ItemList,    /* ItemList */
                                      INPUT         ZipComp,     /* ZCompFactor */
                                      INPUT         NO,          /* Recursive */
                                      INPUT-OUTPUT  ZipComment,  /* ZipComment */
                                      OUTPUT        ZipStatus).  /* ZipStatus */
     END. /* Successful kit backup */
     IF ZipStatus THEN
        MESSAGE "Zip file was created successfully." 
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
     ELSE
        MESSAGE "Zip file was not created successfully."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.  

     /* Reopen the kit - to mimic prior version behaviour */
    RUN OpenKit(cPrefix + "\":U + KitDB, "", "", "", "", "").   
    IF CONNECTED("kit":U) THEN
    DO:
       RUN adetran/vt/_setappd.p (cPrefix). /* Set ApplDirectory */
       IF ENTRY(1,PROPATH) = "":U THEN PROPATH = ",":U + cPrefix + PROPATH.
       ELSE PROPATH = PROPATH + ",":U + cPrefix.
    END.
     RUN adecomm/_setcurs.p ("":U).
  END. /* something to zip */
END. 

ON CHOOSE OF MENU-ITEM mClose DO:
  DO WITH FRAME MainFrame: 
    DEFINE VARIABLE dbdisc AS CHARACTER NO-UNDO.
    
    ASSIGN dbdisc  = KitDB.
    if MainCombo:SCREEN-VALUE = "Untitled":U then return.

    if CONNECTED("KIT":U) then DO:
      RUN adetran/vt/_proccnt.p.
      IF tModFlag THEN RUN adetran/vt/_recount.p (input MainWindow).
      /* The theory is that when a kit is opened its SettingsFile is
         LOADed, when the kit is switched to its Settingsfile is USEd
         and when the kit is closed its settingsfile is unloaded.  None
         of this is in place in 8.0b.
      run adetran/common/_environ.p (OUTPUT SettingsFile).
      if SettingsFile <> "" then unload SettingsFile NO-ERROR.  */
    END.
    
    result = MainCombo:delete(KitDB).  
    if MainCombo:num-items = 0 then
      ASSIGN MainCombo              = "Untitled":U
             MainCombo:list-items   = MainCombo
             MainWindow:TITLE       = "Visual Translator - Untitled":U.
    else
      ASSIGN MainCombo = MainCombo:list-items.
      
    RUN RemoveKitRef (dbDisc).
    
    KitDB = MainCombo:entry(1).
    MainCombo:SCREEN-VALUE = KitDB.
    
    if KitDB <> "Untitled":U then DO:  
      apply "value-changed":U to MainCombo.
      LastKit = lc(pdbname("kit":U)) + ".db":U.
      run WinMenuRebuild in hWinMgr (hFileMenu, LastKit, LastKit, hMain).  
    END.  
  END.  /* DO WITH FRAME MainFrame */
  RUN ResetMain.
  PROPATH = OrigProPath.
END.  /* ON CHOOSE mClose */

ON CHOOSE OF BtnOpen in frame MainFrame
DO:
  if CurrentPointer then DO:
    run adecomm/_adehelp.p ("vt":U, "context":U,{&Open_Command}, ?).
    run ResetCursor.
    return.
  END.
  else run FileOpen.
END.      

ON CHOOSE OF MENU-ITEM mOpen
  run FileOpen.

PROCEDURE FileOpen.
  DEFINE VARIABLE KitFile AS CHARACTER NO-UNDO.
  SYSTEM-DIALOG GET-FILE KitFile
      TITLE     "Open Kit Database"
      filters   "Kit files (*.db)" "*.db":U,
                "All files (*.*)"  "*.*":U
      DEFAULT-EXTENSION "db":U
      must-exist
      use-FILENAME
      update OKPressed.

  IF OKPressed THEN DO:
    RUN adecomm/_setcurs.p ("WAIT":U).
    RUN OpenKit(KitFile, "", "", "", "", "").
    IF CONNECTED("Kit":U) THEN RUN adetran/vt/_setpp.w.
  END.
END PROCEDURE.
  
ON CHOOSE OF MENU-ITEM mOpenMulti
  run OpenMultiUser.

PROCEDURE OpenMultiUser.
  DEFINE VARIABLE KitFile  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Host     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Service  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE UsrID    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE PassWrd  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ConParms AS CHARACTER NO-UNDO.

  RUN adetran/vt/_multidb.w (
      OUTPUT KitFile,
      OUTPUT Host,
      OUTPUT Service,
      OUTPUT UsrId,
      OUTPUT PassWrd,
      OUTPUT ConParms,
      OUTPUT OKPressed).

  IF OKPressed THEN DO:
    RUN adecomm/_setcurs.p ("WAIT":U).
    RUN OpenKit(KitFile, Host, Service, UsrID, Passwrd, ConParms).
    IF CONNECTED("Kit":U) THEN RUN adetran/vt/_setpp.w.
  END.
END PROCEDURE.

/*
** Print triggers
*/
ON CHOOSE OF BtnPrint in frame MainFrame OR
  CHOOSE OF MENU-ITEM mPrintScreen
DO:
  DEFINE VARIABLE Mode AS LOGICAL                                NO-UNDO.

  IF CurrentPointer THEN DO:
    RUN adecomm/_adehelp.p ("vt":U, "context":U,{&VT_Print_Command}, ?).
    RUN ResetCursor.
    RETURN.
  END.
  ELSE DO:
    RUN adecomm/_setcurs.p ("wait":U).
    IF CurrentMode = 4 THEN DO:  /* Print statisitics Report */
      RUN adetran/common/_prtstat.w (INPUT-OUTPUT fnt,
                                     INPUT-OUTPUT flnm,
                                     INPUT-OUTPUT LPP,
                                     INPUT-OUTPUT PrFlag,
                                     OUTPUT Mode).

      IF Mode NE ? THEN    /* User didn't cancel */
        IF VALID-HANDLE (hStats) THEN
          RUN print_statistics IN hStats (INPUT flnm,
                                          INPUT fnt,
                                          INPUT LPP,
                                          INPUT PrFlag,
                                          INPUT Mode).
    END.  /* If CurrentMode = 4 (Statistics) */
    ELSE IF PROCESS-ARCHITECTURE = 32 THEN DO:
      /* Print Screen is only available in the 32-bit Windows client.
      ** When running in the 64-bit client the Print button/menu will
      ** be disabled unless CurrentMode = 4.
      */
      RUN adetran/common/_prtscrn.p.
    END.
  END.  /* Else not Help */
END.  /* On Choose of BtnPrint */

PROCEDURE FilePrint.
    run adecomm/_setcurs.p ("wait":U).
    run adetran/common/_prtscrn.p.
END PROCEDURE.

/*
** Edit menu triggers
*/
ON CHOOSE OF BtnCopy in frame MainFrame DO:
  if CurrentPointer then DO:
    run adecomm/_adehelp.p ("vt":U, "context":U,{&VT_Copy_Command}, ?).
    run ResetCursor.
    return.
  END.
  else DO:  
   run ProcCopy(tPrevh).
   apply "menu-drop":U to menu medit.
  END. 
END.  
   
ON CHOOSE OF MENU-ITEM mCopy 
  run ProcCopy(focus).
   

ON CHOOSE OF BtnCut in frame MainFrame DO: 
  if CurrentPointer then DO:
    run adecomm/_adehelp.p ("vt":U, "context":U,{&VT_Cut_Command}, ?).
    run ResetCursor.
    return.
  END.
  else DO:  
   run ProcCut(tPrevh).
   apply "menu-drop":U to menu medit.
  END.   
END.
 
ON CHOOSE OF MENU-ITEM mCut 
   run ProcCut(focus).

ON CHOOSE OF BtnPaste in frame MainFrame DO: 
  if CurrentPointer then DO:
    run adecomm/_adehelp.p ("vt":U, "context":U,{&VT_Paste_Command}, ?).
    run ResetCursor.
    return.
  END.
  else DO:     
   run ProcPaste(tPrevh).
   apply "menu-drop":U to menu medit.
  END.
END.   
    
ON CHOOSE OF MENU-ITEM mPaste 
   run ProcPaste(focus).
     
ON MENU-DROP OF MENU mFile DO:
  /* Print Screen is only available in the 32-bit Windows client.
  ** When running in the 64-bit client the Print button/menu will
  ** be disabled unless CurrentMode = 4.
  */
  IF PROCESS-ARCHITECTURE = 32 THEN DO:
    ASSIGN MENU-ITEM mPrintScreen:LABEL IN MENU mFile =
	   IF CurrentMode = 4 THEN "&Print..." ELSE "&Print Screen".
  END.
  ELSE DO:
    ASSIGN MENU-ITEM mPrintScreen:LABEL IN MENU mFile = "&Print..."
           MENU-ITEM mPrintScreen:SENSITIVE IN MENU mFile =
             IF CurrentMode = 4 THEN TRUE ELSE FALSE.
  END.
END.

on menu-drop of menu medit DO:
  IF VALID-HANDLE(FOCUS) AND CAN-QUERY(FOCUS,"SCREEN-VALUE":U) AND focus:name <> ? AND
    CONNECTED("Kit":U) AND CurrentMode NE 1 AND CurrentMode NE 4 THEN
  DO:
    IF FOCUS:SCREEN-VALUE <> ? THEN
    ASSIGN MENU-ITEM mcut:SENSITIVE in menu medit   = (length(focus:SCREEN-VALUE) > 0)
           MENU-ITEM mcopy:SENSITIVE in menu medit  = (length(focus:SCREEN-VALUE) > 0).
    ELSE
    ASSIGN MENU-ITEM mcut:SENSITIVE in menu medit   = FALSE
           MENU-ITEM mcopy:SENSITIVE in menu medit  = FALSE.
    ASSIGN
           MENU-ITEM mpaste:SENSITIVE in menu medit = (clipboard:num-formats > 0).
  END.
  ELSE
    ASSIGN  MENU-ITEM mcut:SENSITIVE in menu medit = FALSE
            MENU-ITEM mcopy:SENSITIVE in menu medit = FALSE
            MENU-ITEM mpaste:SENSITIVE in menu medit = FALSE.

  /* Now sensitize the buttons for the corresponding functions */
  ASSIGN BtnCut:SENSITIVE in frame MainFrame   = MENU-ITEM mCut:SENSITIVE in menu mEdit
         BtnCopy:SENSITIVE in frame MainFrame  = MENU-ITEM mCopy:SENSITIVE in menu mEdit
         BtnPaste:SENSITIVE in frame MainFrame = MENU-ITEM mPaste:SENSITIVE in menu mEdit.
END. 


ON CHOOSE OF BtnInsert in frame MainFrame
DO:
  if CurrentPointer then DO:
    run adecomm/_adehelp.p ("vt":U, "context":U,{&VT_Insert_Command}, ?).
    run ResetCursor.
    return.
  END.
  else run EditInsert.
END.

ON CHOOSE OF MENU-ITEM mInsert
  run EditInsert.

PROCEDURE EditInsert.
    if CurrentMode = 3 THEN
      RUN InsertRow in hGloss.
    else bell.
END PROCEDURE.


ON CHOOSE OF BtnDelete in frame MainFrame
DO:
  if CurrentPointer then DO:
    run adecomm/_adehelp.p ("vt":U, "context":U,{&VT_Delete_Command}, ?).
    run ResetCursor.
    return.
  END.
  else run EditDelete.
END.    

ON CHOOSE OF MENU-ITEM mDelete
  run EditDelete.

PROCEDURE EditDelete.
  if CurrentMode = 2 then
       run DeleteRow in hTrans.
  else if CurrentMode = 3 then
      run DeleteRow in hGloss.
  else bell.
END PROCEDURE.


ON CHOOSE OF BtnFind in frame MainFrame
DO:
  if CurrentPointer then DO:
    run adecomm/_adehelp.p ("vt":U, "context":U,{&Find_Command_Edit_Menu}, ?).
    run ResetCursor.
    return.
  END.
  else run EditFind.
END.  

ON CHOOSE OF MENU-ITEM mFind
  run EditFind.

PROCEDURE EditFind.
  run Realize in hFind.
END PROCEDURE.

ON CHOOSE OF MENU-ITEM mReplace DO:
  run Realize in hReplace ("","").
END.

ON CHOOSE OF MENU-ITEM mGoto DO:
  run Realize in hGoto.
END.   
/*
** View triggers
*/    

ON CHOOSE OF BtnOrder in frame MainFrame
DO:
  if CurrentPointer then DO:
    run adecomm/_adehelp.p
        ("vt":U, "context":U,{&Order_Columns_Command_View_Menu}, ?).
    run ResetCursor.
    return.
  END.
  else run ViewOrder.
END. 

ON CHOOSE OF MENU-ITEM mOrder
  run ViewOrder.

PROCEDURE ViewOrder.
    IF CurrentMode = 2 THEN
       run adetran/common/_order.w(hTrans,"VT":U) .
    ELSE
       run adetran/common/_order.w(hGloss,"VT":U).
END PROCEDURE.

ON CHOOSE OF BtnSort in frame MainFrame
DO:  
  if CurrentPointer then DO:
    run adecomm/_adehelp.p
        ("vt":U, "context":U,{&Sort_Rows_Command_View_Menu}, ?).
    run ResetCursor.
    return.
  END.
  else run ViewSort.
END. 

ON CHOOSE OF MENU-ITEM mSort
  run ViewSort.

PROCEDURE ViewSort.
    DEFINE VARIABLE TempFile AS CHARACTER NO-UNDO.
    /*
    ** Run the sort dialog
    */
    if CurrentMode = 2 then
      run adetran/common/_sort.w (hTrans, CurrentMode, CurrentTool).
    else
      run adetran/common/_sort.w (hGloss, CurrentMode, CurrentTool).
END PROCEDURE.

ON CHOOSE OF BtnView in frame MainFrame
DO:
  if CurrentPointer then DO:
    run adecomm/_adehelp.p ("vt":U, "context":U,{&View_Procedures_command_view_me}, ?).
    run ResetCursor.
    return.
  END.
  else run ViewProc.
END. 

ON CHOOSE OF MENU-ITEM mView
  run ViewProc.

PROCEDURE ViewProc.
    if CurrentMode = 1 THEN RUN ViewProcedure in hProcs.
    else if CurrentMode = 2 THEN RUN ViewProcedure in hTrans.
END PROCEDURE.

ON CHOOSE OF MENU-ITEM mPrefs DO:
  run adetran/vt/_prefs.w.
  IF VALID-HANDLE(hProps) THEN RUN AlwaysOnTop IN hProps. 
END.

ON CHOOSE OF MENU-ITEM mi_cln-gloss DO:
  run adecomm/_setcurs.p ("WAIT":U).
  RUN adetran/vt/_clnglos.w.
END.

ON CHOOSE OF MENU-ITEM mi_pre-trans DO:
  RUN adetran/vt/_pretran.w.
END.

ON CHOOSE OF MENU-ITEM mi_calc-stats DO:
  IF VALID-HANDLE(hStats) THEN
    RUN ViewStats IN hStats (INPUT NO).
  RUN adetran/vt/_recount.p (INPUT MainWindow).
  RUN adetran/vt/_proccnt.p.
  IF VALID-HANDLE(hStats) THEN
    RUN SetStatistics IN hStats (INPUT YES).
END.

/*
** Windows menu management
*/
on menu-drop of menu mWindow DO:    
  DEFINE VARIABLE Test1 AS LOGICAL NO-UNDO. 
  DEFINE VARIABLE h as widget-handle NO-UNDO.   
  
  /* First test: the glossary window shouldn't be sensitive if nothing has
     been selected. */  
  if connected("kit":U) THEN RUN EvaluateGloss in hTrans (output Test1).   
  if Test1 and CurrentMode = 2
    then MENU-ITEM mGloss:SENSITIVE in menu mWindow = true.
    else MENU-ITEM mGloss:SENSITIVE in menu mWindow = FALSE.
    
    
  /* Second test: the property window shouldn't be available if there isn't at
     least one translation window up.  When a translation window is around, then
     the i counter is greater than 2 */   
  ASSIGN i = 0
         h = hWinMenU:first-child.    
  do while h <> ?:  
    i = i + 1.
    h = h:next-sibling.
  END.       
  
  if i > 2 and (CurrentMode = 1 or CurrentMode = 2)
    THEN MENU-ITEM mProps:SENSITIVE in menu mWindow = true.
    ELSE MENU-ITEM mProps:SENSITIVE in menu mWindow = FALSE.
END.   

on value-changed of MENU-ITEM mProps DO:
  if MENU-ITEM mProps:checked in menu mWindow then 
    run Realize in hProps. 
  else
    run HidePropWin in hProps.
END. 

on value-changed of MENU-ITEM mGloss DO: 
  run DisplayGlossary in hTrans.
END.

/*  
** Help triggers
*/     
on help of frame MainFrame DO:
  run adecomm/_adehelp.p ("vt":U, "topics":U,{&Main_Win}, ?).
END.

ON CHOOSE OF MENU-ITEM mAbout DO:    
  run adecomm/_about.p ("Visual Translator":U,"adetran/images/vt%":U).
END.

ON CHOOSE OF MENU-ITEM mContents DO: 
  run adecomm/_adehelp.p ("vt":U, "topics":U,{&Main_Contents}, ?).
END. 

ON CHOOSE OF MENU-ITEM mMaster DO: 
  run adecomm/_adehelp.p ("mast":U, "topics":U, ?, ?).
END. 

ON CHOOSE OF MENU-ITEM mMsgs DO:
 run prohelp/_msgs.p.
END.

ON CHOOSE OF MENU-ITEM mRecentMsgs DO:
  run prohelp/_rcntmsg.p.
END.

ON CHOOSE OF BtnHelp in frame MainFrame DO:  
  ASSIGN CurrentPointer = TRUE
         result = BtnHelp:load-image("adetran/images/help-d":U)
         result = BtnOpen:load-mouse-pointer("adetran/images/help.cur":U)
         result = BtnPrint:load-mouse-pointer("adetran/images/help.cur":U)
         result = BtnCut:load-mouse-pointer("adetran/images/help.cur":U)
         result = BtnCopy:load-mouse-pointer("adetran/images/help.cur":U)
         result = BtnPaste:load-mouse-pointer("adetran/images/help.cur":U)
         result = BtnInsert:load-mouse-pointer("adetran/images/help.cur":U)
         result = BtnDelete:load-mouse-pointer("adetran/images/help.cur":U)
         result = BtnSort:load-mouse-pointer("adetran/images/help.cur":U)
         result = BtnOrder:load-mouse-pointer("adetran/images/help.cur":U)
         result = BtnFind:load-mouse-pointer("adetran/images/help.cur":U)
         result = BtnView:load-mouse-pointer("adetran/images/help.cur":U)
         result = MainCombo:load-mouse-pointer("adetran/images/help.cur":U)
         result = Btnprocedures:load-mouse-pointer("adetran/images/help.cur":U)
         result = BtnTranslations:load-mouse-pointer("adetran/images/help.cur":U)
         result = BtnGlossary:load-mouse-pointer("adetran/images/help.cur":U)
         result = BtnStatistics:load-mouse-pointer("adetran/images/help.cur":U).
END.

/* Folder control triggers */     
ON MOUSE-SELECT-CLICK OF BtnProcedures, TxtProcs IN FRAME MainFrame
OR "ALT-P" OF frame MainFrame ANYWHERE
DO:
  if CurrentPointer then DO:
    run adecomm/_adehelp.p ("vt":U, "context":U,{&VT_Procedures_Tab_Folder}, ?).
    run ResetCursor.
    return NO-APPLY.
  END.
  ELSE IF CurrentMode = 1 THEN RETURN NO-APPLY.
  else DO:
    APPLY "ENTRY":U TO MainCombo IN FRAME MainFrame.  
    ASSIGN CurrentMode = 1
           result      = TabControl:load-image("adetran/images/tab4a":U)
           result      = Btnprocedures:load-image("adetran/labels/procs-b":U)
           result      = BtnTranslations:load-image("adetran/labels/trans":U)
           result      = BtnGlossary:load-image("adetran/labels/gloss":U)
           result      = BtnStatistics:load-image("adetran/labels/stats":U).

    IF CONNECTED("KIT":U)     THEN RUN adetran/vt/_proccnt.p.
    IF VALID-HANDLE(hProcs)   THEN RUN Realize in hProcs.
    IF VALID-HANDLE(hTrans)   THEN RUN HideMe in hTrans.
    IF VALID-HANDLE(hGloss)   THEN RUN HideMe in hGloss.
    IF VALID-HANDLE(hLongStr) THEN RUN HideMe in hLongStr.
    IF VALID-HANDLE(hStats)   THEN RUN HideMe in hStats.
    IF VALID-HANDLE(hFind)    THEN RUN HideMe in hFind.
    IF VALID-HANDLE(hReplace) THEN RUN HideMe in hReplace.
    IF VALID-HANDLE(hGoto)    THEN RUN HideMe in hGoto.
    run SetSensitivity.  
  END.                                                            
END.
                                    
ON MOUSE-SELECT-CLICK OF BtnTranslations, TxtTrans IN FRAME MainFrame
OR "ALT-T" OF frame MainFrame ANYWHERE
DO:
  if CurrentPointer then DO:
    run adecomm/_adehelp.p ("vt":U, "context":U,{&Translations_Tab_Folder}, ?).
    run ResetCursor.
    return NO-APPLY.
  END.
  ELSE IF CurrentMode = 2 THEN RETURN NO-APPLY.
  else DO:
    APPLY "ENTRY":U TO MainCombo IN FRAME MainFrame.  
    ASSIGN CurrentMode = 2
           result = TabControl:load-image("adetran/images/tab4b":U)
           result = Btnprocedures:load-image("adetran/labels/procs":U)
           result = BtnTranslations:load-image("adetran/labels/trans-b":U)
           result = BtnGlossary:load-image("adetran/labels/gloss":U)
           result = BtnStatistics:load-image("adetran/labels/stats":U).

    IF VALID-HANDLE(hTrans)   THEN RUN Realize in hTrans.
    IF VALID-HANDLE(hProcs)   THEN RUN HideMe in hProcs.
    IF VALID-HANDLE(hGloss)   THEN RUN HideMe in hGloss.
    IF VALID-HANDLE(hLongStr) THEN RUN HideMe in hLongStr.
    IF VALID-HANDLE(hStats)   THEN RUN HideMe in hStats.
    run SetSensitivity.
  END.      
END.   

ON MOUSE-SELECT-CLICK OF BtnGlossary, TxtGloss IN FRAME MainFrame
OR "ALT-G" OF frame MainFrame ANYWHERE 
DO:
  if CurrentPointer then DO:
    run adecomm/_adehelp.p ("vt":U, "context":U,{&VT_Glossaries_Tab_Folder}, ?).
    run ResetCursor.
    return NO-APPLY.
  END.
  ELSE IF CurrentMode = 3 THEN RETURN NO-APPLY.
  else DO:          
    APPLY "ENTRY":U TO MainCombo IN FRAME MainFrame.  
    ASSIGN CurrentMode = 3
           result = TabControl:load-image("adetran/images/tab4c":U)
           result = Btnprocedures:load-image("adetran/labels/procs":U)
           result = BtnTranslations:load-image("adetran/labels/trans":U)
           result = BtnGlossary:load-image("adetran/labels/gloss-b":U)
           result = BtnStatistics:load-image("adetran/labels/stats":U).

    IF VALID-HANDLE(hGloss)   THEN RUN Realize in hGloss.
    IF VALID-HANDLE(hLongStr) THEN RUN HideMe in hLongStr.
    IF VALID-HANDLE(hProcs)   THEN RUN HideMe in hProcs.
    IF VALID-HANDLE(hTrans)   THEN RUN HideMe in hTrans.
    IF VALID-HANDLE(hStats)   THEN RUN HideMe in hStats.
    IF VALID-HANDLE(hFind)    THEN RUN HideMe in hFind.
    IF VALID-HANDLE(hReplace) THEN RUN HideMe in hReplace.
    run SetSensitivity.
  END.       
END.

ON MOUSE-SELECT-CLICK OF BtnStatistics, TxtStats IN FRAME MainFrame
OR "ALT-S" OF frame MainFrame ANYWHERE 
DO:
  APPLY "ENTRY":U TO SUB-MENU mFile.
  if CurrentPointer then DO:
    run adecomm/_adehelp.p ("vt":U, "context":U,{&VT_Statistics_Tab_Folder}, ?).
    run ResetCursor.
    return NO-APPLY.
  END.
  ELSE IF CurrentMode = 4 THEN RETURN NO-APPLY.
  else DO:          
    APPLY "ENTRY":U TO MainCombo IN FRAME MainFrame.  
    ASSIGN CurrentMode = 4
           result = TabControl:load-image("adetran/images/tab4d":U)
           result = Btnprocedures:load-image("adetran/labels/procs":U)
           result = BtnTranslations:load-image("adetran/labels/trans":U)
           result = BtnGlossary:load-image("adetran/labels/gloss":U)
           result = BtnStatistics:load-image("adetran/labels/stats-b":U).

    IF VALID-HANDLE(hStats)   THEN RUN Realize in hStats.
    IF VALID-HANDLE(hLongStr) THEN RUN HideMe in hLongStr.
    IF VALID-HANDLE(hProcs)   THEN RUN HideMe in hProcs.
    IF VALID-HANDLE(hTrans)   THEN RUN HideMe in hTrans.
    IF VALID-HANDLE(hGloss)   THEN RUN HideMe in hGloss.
    IF VALID-HANDLE(hFind)    THEN RUN HideMe in hFind.
    IF VALID-HANDLE(hReplace) THEN RUN HideMe in hReplace.
    IF VALID-HANDLE(hGoto)    THEN RUN HideMe in hGoto.
    run SetSensitivity.
  END.      
END.


/*
** MainCombo combo-box trigger
*/          
on mouse-select-click of MainCombo in frame MainFrame DO:
  if CurrentPointer then DO:
    run adecomm/_adehelp.p ("vt":U, "context":U,{&Current_Kit_Combo_Box}, ?).
    run ResetCursor.
    return.
  END. 
END.         

on value-changed of MainCombo in frame MainFrame DO:
  if not CurrentPointer then DO: 
    KitDB = MainCombo:SCREEN-VALUE.   

    run adetran/vt/_reset.p (output ErrorStatus).
    if ErrorStatus then DO: 
      run adecomm/_setcurs.p ("").
      return.
    END.   
    run ResetMain.        
  END.      
END. 

/*
** final run-time assignments
*/
&SCOPED-DEFINE FRAME-NAME MainFrame
{adetran/common/noscroll.i}

ASSIGN
  current-window                = MainWindow 
  this-procedure:current-window = MainWindow   
  frame MainFrame:SCROLLABLE    = FALSE
  hMain                         = this-PROCEDURE
  hWinMenu                      = SUB-MENU mWindow:HANDLE
  hFileMenu                     = SUB-MENU mFile:HANDLE
  CurrentMode                   = 1.

/*
** Read the ini file for assignments
*/
run adecomm/_winmenu.w PERSISTENT SET hWinMgr.
IF VALID-HANDLE(hWinMgr) then hWinMgr:PRIVATE-DATA = CurrentTool.
get-key-value section "Visual Translator":U key "Kit":U value LastKit.
get-key-value section "Visual Translator":U key "Language":U value CurLanguage. 

get-key-value section "Visual Translator":U key "Properties Always On Top":U value TempLogical.
PropsOnTop = TempLogical = "YES":U.    

get-key-value section "Visual Translator":U key "Glossary Always On Top":U value TempLogical.
GlossaryOnTop = TempLogical = "YES":U.    

get-key-value section "Visual Translator":U key "Automatic Translations":U value TempLogical.
AutoTrans = TempLogical = "YES":U.

get-key-value section "Visual Translator":U key "Confirm Adds":U value TempLogical.
ConfirmAdds = TempLogical = "YES":U.

get-key-value section "Visual Translator":U key "Display Fullpath":U value TempLogical.
FullPathFlag = TempLogical = "YES":U.

file-info:file-name = LastKit.
if file-info:full-pathname = ? then LastKit = "".

/*
** ***************************************************************
** Window close and main code block
** ***************************************************************
*/
ON CLOSE OF THIS-PROCEDURE DO:
  APPLY "CHOOSE" TO MENU-ITEM mClose IN MENU mFile.    
  run disable_ui.
END.

on window-close of mainwindow or choose of MENU-ITEM mExit DO:
  IF TmpFl_VT_Gl NE "" THEN OS-DELETE VALUE(TmpFl_VT_Gl).
  IF TmpFl_VT_Tr NE "" THEN OS-DELETE VALUE(TmpFl_VT_Tr).

  apply "close":U to this-PROCEDURE.
  return no-apply.
END.

on endkey, end-error of mainwindow anywhere DO:
  return no-apply.
END.  

pause 0 before-hide.

main-block:
DO ON ERROR UNDO main-block, LEAVE main-block
   ON END-KEY UNDO main-block, LEAVE main-block:  
   
  /* run the persistent procedures  */                                       
  IF CONNECTED("KIT":U) THEN DO:
    RUN adetran/vt/_recount.p (INPUT MainWindow).
    RUN adetran/vt/_procs.w   PERSISTENT SET hProcs.
    RUN adetran/vt/_trans.p   PERSISTENT SET hTrans.
    RUN adetran/vt/_gloss.p   PERSISTENT SET hGloss.
    RUN adetran/vt/_stats.w   PERSISTENT SET hStats.
    RUN adetran/vt/_props.w   PERSISTENT SET hProps.
    RUN adetran/vt/_longstr.w PERSISTENT SET hLongStr.
    RUN adetran/vt/_replace.w PERSISTENT SET hReplace.
    RUN adetran/vt/_find.w    PERSISTENT SET hFind.
    RUN adetran/vt/_goto.w    PERSISTENT SET hGoto.
    RUN adetran/vt/_trlkup.w  PERSISTENT SET hLkUp.
    RUN adetran/vt/_setpp.w.
  END.  /* IF CONNECTED */
  RUN adetran/common/_meter.w PERSISTENT SET hMeter (input MainWindow).

  ASSIGN MainCombo              = IF CONNECTED("kit":U) THEN ldbname("kit":U)
                                                        ELSE "Untitled":U
         KitDB                  = MainCombo
         MainCombo:list-items   = MainCombo
         MainCombo:SCREEN-VALUE = MainCombo.

/* HISTORY DELETE
  IF LastKit <> "" THEN
    RUN WinMenuAddItem IN hWinMgr (hFileMenu, LastKit, hMain).  
HISTORY DELETE*/

  RUN TagProcedures.
  RUN enable_ui.
  RUN SetSensitivity.

  APPLY "ENTRY":U TO MainCombo.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.
{adecomm/_adetool.i}

/*  
** **************************************************************
** Procedures
** **************************************************************
*/   
PROCEDURE disable_UI:  
  DEFINE VARIABLE h AS HANDLE NO-UNDO.
   
  h = session:first-PROCEDURE.
  do while h <> ?:
    create PersistProcs. 
    hProcedure = h.
    h          = h:next-sibling.
  END.   


  for each PersistProcs: 
    i = i + 1.
    /* message i hProcedure hProcedure:file-name hProcedure:PRIVATE-DATA. */
    IF VALID-HANDLE(hProcedure) and 
     hProcedure:PRIVATE-DATA = "VT":U THEN DELETE PROCEDURE hProcedure no-error. 
  END.   
  
  RUN WriteINI.
  delete widget-pool.
  delete widget MainWindow.   
END PROCEDURE.

PROCEDURE WriteINI:     
  DO WITH FRAME MainFrame:
    if KitDB <> "Untitled":U then
      LastKit = pdbname("kit":U) + ".db":U.    
    else 
      LastKit = "".
      
    /*
    ** Finally, write-out last databases used and preferences
    */  
    use "". /* Done to clear out any [loaded] progress.ini files */   
    put-key-value section "Visual Translator":U key "Kit":U value LastKit no-error.    
    put-key-value section "Visual Translator":U key "Language":U value CurLanguage no-error. 
    put-key-value section "Visual Translator":U key "Automatic Translations":U value STRING(AutoTrans) no-error.
    put-key-value section "Visual Translator":U key "Properties Always On Top":U value STRING(PropsOnTop) no-error.
    put-key-value section "Visual Translator":U key "Glossary Always On Top":U value STRING(GlossaryOnTop) no-error.
    put-key-value section "Visual Translator":U key "Confirm Adds":U value STRING(ConfirmAdds) no-error.
    put-key-value section "Visual Translator":U key "Display Fullpath":U value STRING(FullPathFlag) no-error.
 
    if error-status:error then DO: 
      RUN adecomm/_s-alert.p (
        input-output ErrorStatus,
        "w*":U,
        "ok":U,
       "Unable to save Visual Translator settings.^^The PROGRESS environment file may be read-only or it may be located in a directory where you do not have write permissions.").    
  END.

END.
END PROCEDURE.


PROCEDURE enable_UI : 
  DEFINE VARIABLE tMainCombo AS CHARACTER NO-UNDO.  
  DO WITH FRAME MainFrame:    
    DISPLAY MainCombo TxtProcs TxtTrans TxtGloss TxtStats
      WITH FRAME MainFrame IN WINDOW MainWindow.
    ENABLE TabBody MainCombo TabControl BtnProcedures TxtProcs 
           BtnTranslations TxtTrans BtnGlossary TxtGloss BtnStatistics TxtStats
    with frame MainFrame IN WINDOW MainWindow.

    /*
    ** Only display the frame if a real database is connected
    */              
    IF VALID-HANDLE(hProcs) then DO:
      if CurrentMode = 1 and connected("kit":U) THEN RUN Realize in hProcs.
      if CurrentMode = 2 and connected("kit":U) THEN RUN Realize in hTrans.
      if CurrentMode = 3 and connected("kit":U) THEN RUN Realize in hGloss.
      if CurrentMode = 4 and connected("kit":U) THEN RUN Realize in hStats.
    END.
                    
    MainCombo:SCREEN-VALUE = KitDB.
    MainWindow:TITLE       = "Visual Translator - ":U + KitDB.
     
    /* make it all visible  */
    view MainWindow.
    RUN adecomm/_setcurs.p ("").   
  END.
END PROCEDURE.  

PROCEDURE TagProcedures:       
    IF VALID-HANDLE(hProcs)   THEN hProcs:PRIVATE-DATA   = CurrentTool.
    IF VALID-HANDLE(hTrans)   THEN hTrans:PRIVATE-DATA   = CurrentTool.
    IF VALID-HANDLE(hGloss)   THEN hGloss:PRIVATE-DATA   = CurrentTool.
    IF VALID-HANDLE(hStats)   THEN hStats:PRIVATE-DATA   = CurrentTool.
    IF VALID-HANDLE(hLkUp)    THEN hLkup:PRIVATE-DATA    = CurrentTool.
    IF VALID-HANDLE(hFind)    THEN hFind:PRIVATE-DATA    = CurrentTool.
    IF VALID-HANDLE(hReplace) THEN hReplace:PRIVATE-DATA = CurrentTool.
    IF VALID-HANDLE(hGoto)    THEN hGoto:PRIVATE-DATA    = CurrentTool.
    IF VALID-HANDLE(hProps)   THEN hProps:PRIVATE-DATA   = CurrentTool.
    IF VALID-HANDLE(hLongStr) THEN hLongStr:PRIVATE-DATA = CurrentTool.
    IF VALID-HANDLE(hWinMgr)  THEN hWinMgr:PRIVATE-DATA  = CurrentTool.
    IF VALID-HANDLE(hMeter)   THEN hMeter:PRIVATE-DATA   = CurrentTool.
END PROCEDURE.    

PROCEDURE enable_widgets:      
  ASSIGN menu MainMENUBAR:SENSITIVE = true
         frame MainFrame:SENSITIVE  = true.
  if connected("kit":U) and CurrentMode = 1 THEN RUN Realize in hProcs.
  if connected("kit":U) and CurrentMode = 2 THEN RUN Realize in hTrans.
  if connected("kit":U) and CurrentMode = 3 THEN RUN Realize in hGloss.
  if connected("kit":U) and CurrentMode = 4 THEN RUN Realize in hStats.
END PROCEDURE. 

PROCEDURE disable_widgets:  
  if connected("kit":U) and CurrentMode = 1 THEN RUN HideMe in hProcs.
  if connected("kit":U) and CurrentMode = 2 THEN RUN HideMe in hTrans.
  if connected("kit":U) and CurrentMode = 3 THEN RUN HideMe in hGloss.
  if connected("kit":U) and CurrentMode = 4 THEN RUN HideMe in hStats.

  ASSIGN menu MainMENUBAR:SENSITIVE = FALSE 
         frame MainFrame:SENSITIVE  = FALSE. 
END PROCEDURE.

/* fhc */ 
PROCEDURE ProcCopy:
  define input parameter pWH as widget-handle NO-UNDO.
  
  if CurrentPointer THEN DO:
    RUN adecomm/_adehelp.p ("vt":U, "context":U,{&VT_Copy_Command}, ?).
    RUN ResetCursor.
    return.
  END.
  else 
  IF VALID-HANDLE(pWH) THEN DO:
    if pWH:type = "editor":U THEN
      if pWH:selection-start <> pWH:selection-end THEN
        clipboard:value = pWH:selection-text.
      else 
        clipboard:value = pWH:SCREEN-VALUE.
    else if pWH:type = "radio-set":U THEN
      clipboard:value = entry(lookup(pWH:SCREEN-VALUE,pWH:radio-buttons) - 1, 
                        pWH:radio-buttons).
    else if pWH:type = "toggle-box":U THEN
      if pWH:SCREEN-VALUE = "YES":U THEN
        clipboard:value = pWH:LABEL + " selected.".
      else
        clipboard:value = pWH:LABEL + " not selected.".
    else 
    IF CAN-QUERY(pWH,"SCREEN-VALUE":U) THEN
      clipboard:value = pWH:SCREEN-VALUE.
  END.    
END PROCEDURE.

PROCEDURE ProcPaste:
   define input parameter pWH as widget-handle NO-UNDO.
   
   if CurrentPointer THEN DO:
      RUN adecomm/_adehelp.p ("vt":U, "context":U,{&VT_Paste_Command}, ?).
      RUN ResetCursor.
      return.
   END.
   else 
   IF VALID-HANDLE(pWH) and clipboard:num-formats > 0 THEN 
   DO:
    if pWH:type = "EDITOR":U THEN DO:
      if pWH:selection-start <> pWH:selection-end THEN
        result = pWH:replace-selection-text(clipboard:value).
      else 
        result = pWH:insert-STRING(clipboard:value).
    END.
    else  
    IF CAN-QUERY(pWH,"SCREEN-VALUE":U) THEN
       pWH:SCREEN-VALUE = clipboard:value.
  END.    
END PROCEDURE.    

PROCEDURE ProcCut:   
   define input parameter pWH as widget-handle NO-UNDO.
   
   if CurrentPointer THEN DO:
    RUN adecomm/_adehelp.p ("vt":U, "context":U,{&VT_Cut_Command}, ?).
    RUN ResetCursor.
    return.
  END.
  else 
  IF VALID-HANDLE(pWH) THEN DO:      
    if pWH:type = "EDITOR":U THEN DO:
      if pWH:selection-start <> pWH:selection-end THEN DO:
        clipboard:value = pWH:selection-text.
        result = pWH:replace-selection-text("").
      END.
      else DO:  
      IF CAN-QUERY(pWH,"SCREEN-VALUE":U) THEN
         ASSIGN clipboard:value = pWH:SCREEN-VALUE
                pWH:SCREEN-VALUE = "".
      END.
    END.
    else DO:                            
    
    IF VALID-HANDLE(pWH) AND CAN-QUERY(pWH,"SCREEN-VALUE":U) THEN
       ASSIGN clipboard:value = pWH:SCREEN-VALUE
              pWH:SCREEN-VALUE = "".
    END.
  END.                 
END PROCEDURE.

PROCEDURE ResetCursor :
  CurrentPointer = FALSE.  
  DO WITH FRAME MainFrame:  
    result = BtnHelp:load-image("adetran/images/help":U).

    result = BtnOpen:load-mouse-pointer("arrow":U).
    result = BtnPrint:load-mouse-pointer("arrow":U).
    result = BtnCut:load-mouse-pointer("arrow":U).
    result = BtnCopy:load-mouse-pointer("arrow":U).
    result = BtnPaste:load-mouse-pointer("arrow":U).
    result = BtnInsert:load-mouse-pointer("arrow":U).
    result = BtnDelete:load-mouse-pointer("arrow":U).
    result = BtnSort:load-mouse-pointer("arrow":U).
    result = BtnOrder:load-mouse-pointer("arrow":U).
    result = BtnFind:load-mouse-pointer("arrow":U).
    result = BtnView:load-mouse-pointer("arrow":U). 

    result = MainCombo:load-mouse-pointer("arrow":U).
    result = Btnprocedures:load-mouse-pointer("arrow":U).
    result = BtnTranslations:load-mouse-pointer("arrow":U).
    result = BtnGlossary:load-mouse-pointer("arrow":U).
    result = BtnStatistics:load-mouse-pointer("arrow":U).  
  END.
END PROCEDURE.   


PROCEDURE SetSensitivity:
  DO WITH FRAME MainFrame:

  /* Note: cut/copy/paste are handled differently */                
  if connected("kit":U) THEN 
    RUN adetran/vt/_getcnt.p (output TransFlag, output GlossaryFlag).    
    
  ASSIGN MENU-ITEM mRetKit:SENSITIVE  in menu mFile = connected("kit":U)
         MENU-ITEM mInstKit:SENSITIVE in menu mFile = true.

  case CurrentMode:
    when 1 THEN DO:
      ASSIGN     
        BtnOpen:SENSITIVE   = true
        BtnPrint:SENSITIVE  = IF PROCESS-ARCHITECTURE = 32 THEN TRUE ELSE FALSE
        BtnInsert:SENSITIVE = FALSE
        BtnDelete:SENSITIVE = FALSE
        BtnSort:SENSITIVE   = FALSE
        BtnOrder:SENSITIVE  = FALSE
        BtnFind:SENSITIVE   = FALSE
        BtnView:SENSITIVE   = CONNECTED("KIT":U)
        BtnHelp:SENSITIVE   = true
        
        MENU-ITEM mClose:SENSITIVE in MENU mFile   = CONNECTED("KIT":U)
        MENU-ITEM mImport:SENSITIVE in menu mFile  = FALSE
        MENU-ITEM mExport:SENSITIVE in menu mFile  = FALSE
        MENU-ITEM mInsert:SENSITIVE in menu mEdit  = BtnInsert:SENSITIVE
        MENU-ITEM mDelete:SENSITIVE in menu mEdit  = BtnDelete:SENSITIVE 
        MENU-ITEM mFind:SENSITIVE in menu mEdit    = BtnFind:SENSITIVE 
        MENU-ITEM mReplace:SENSITIVE in menu mEdit = BtnFind:SENSITIVE
        MENU-ITEM mSort:SENSITIVE in menu mView    = BtnSort:SENSITIVE 
        MENU-ITEM mGoto:SENSITIVE in menu mEdit    = BtnSort:SENSITIVE
        MENU-ITEM mOrder:SENSITIVE in menu mView   = BtnOrder:SENSITIVE 
        MENU-ITEM mView:SENSITIVE in menu mView    = BtnView:SENSITIVE
        MENU-ITEM mi_cln-gloss:SENSITIVE in menu m_tm-util = BtnView:SENSITIVE
        MENU-ITEM mi_pre-trans:SENSITIVE in menu m_tm-util = BtnView:SENSITIVE
        MENU-ITEM mi_calc-stats:SENSITIVE in menu m_tm-util = FALSE.
    END.
    
    when 2 THEN DO:
      if Priv1          THEN BtnDelete:SENSITIVE = FALSE.
      else if TransFlag THEN BtnDelete:SENSITIVE  = true. 
      else                   BtnDelete:SENSITIVE  = FALSE.
               
      if not Priv3 THEN      BtnDelete:SENSITIVE  = FALSE.

      ASSIGN BtnInsert:SENSITIVE = FALSE
             BtnOpen:SENSITIVE   = true
             BtnPrint:SENSITIVE  = IF PROCESS-ARCHITECTURE = 32 THEN TRUE ELSE FALSE
             BtnSort:SENSITIVE   = CONNECTED("KIT":U) and TransFlag
             BtnOrder:SENSITIVE  = CONNECTED("KIT":U) and TransFlag
             BtnFind:SENSITIVE   = CONNECTED("KIT":U) and TransFlag
             BtnView:SENSITIVE   = CONNECTED("KIT":U)
             BtnHelp:SENSITIVE   = true

             MENU-ITEM mImport:SENSITIVE in menu mFile  = FALSE
             MENU-ITEM mExport:SENSITIVE in menu mFile  = FALSE
             MENU-ITEM mInsert:SENSITIVE in menu mEdit  = BtnInsert:SENSITIVE
             MENU-ITEM mDelete:SENSITIVE in menu mEdit  = BtnDelete:SENSITIVE 
             MENU-ITEM mFind:SENSITIVE in menu mEdit    = BtnFind:SENSITIVE 
             MENU-ITEM mReplace:SENSITIVE in menu mEdit = BtnFind:SENSITIVE
             MENU-ITEM mSort:SENSITIVE in menu mView    = BtnSort:SENSITIVE 
             MENU-ITEM mGoto:SENSITIVE in menu mEdit    = BtnSort:SENSITIVE
             MENU-ITEM mView:SENSITIVE in menu mView    = BtnView:SENSITIVE
             MENU-ITEM mOrder:SENSITIVE in menu mView   = BtnOrder:SENSITIVE
             MENU-ITEM mi_cln-gloss:SENSITIVE in menu m_tm-util = CONNECTED("KIT":U)
             MENU-ITEM mi_pre-trans:SENSITIVE in menu m_tm-util = CONNECTED("KIT":U)
             MENU-ITEM mi_calc-stats:SENSITIVE in menu m_tm-util = FALSE.
    END.
    
    when 3 THEN DO:
      if Priv1 THEN ASSIGN 
        BtnInsert:SENSITIVE = FALSE
        BtnDelete:SENSITIVE = FALSE.
      else ASSIGN
        BtnInsert:SENSITIVE = CONNECTED("KIT":U) AND Priv2
        BtnDelete:SENSITIVE = CONNECTED("KIT":U).

      if not GlossaryFlag 
        THEN BtnDelete:SENSITIVE = FALSE.
        else BtnDelete:SENSITIVE = CONNECTED("KIT":U).  
      if not Priv2 THEN BtnDelete:SENSITIVE = FALSE.
          
      ASSIGN     
        BtnOpen:SENSITIVE   = true
        BtnPrint:SENSITIVE  = IF PROCESS-ARCHITECTURE = 32 THEN TRUE ELSE FALSE
        BtnSort:SENSITIVE   = CONNECTED("KIT":U) and GlossaryFlag
        BtnOrder:SENSITIVE  = CONNECTED("KIT":U) and GlossaryFlag
        BtnFind:SENSITIVE   = CONNECTED("KIT":U) and GlossaryFlag
        BtnView:SENSITIVE   = FALSE
        BtnHelp:SENSITIVE   = true 
        
        MENU-ITEM mImport:SENSITIVE in menu mFile  = CONNECTED("KIT":U)
        MENU-ITEM mExport:SENSITIVE in menu mFile  = CONNECTED("KIT":U) and GlossaryFlag
        MENU-ITEM mInsert:SENSITIVE in menu mEdit  = BtnInsert:SENSITIVE
        MENU-ITEM mDelete:SENSITIVE in menu mEdit  = BtnDelete:SENSITIVE 
        MENU-ITEM mFind:SENSITIVE in menu mEdit    = BtnFind:SENSITIVE 
        MENU-ITEM mReplace:SENSITIVE in menu mEdit = BtnFind:SENSITIVE AND Priv2
        MENU-ITEM mSort:SENSITIVE in menu mView    = BtnSort:SENSITIVE 
        MENU-ITEM mGoto:SENSITIVE in menu mEdit    = FALSE 
        MENU-ITEM mOrder:SENSITIVE in menu mView   = BtnOrder:SENSITIVE 
        MENU-ITEM mView:SENSITIVE in menu mView    = BtnView:SENSITIVE
        MENU-ITEM mi_cln-gloss:SENSITIVE in menu m_tm-util = CONNECTED("KIT":U)
        MENU-ITEM mi_pre-trans:SENSITIVE in menu m_tm-util = CONNECTED("KIT":U)
        MENU-ITEM mi_calc-stats:SENSITIVE in menu m_tm-util = FALSE.
    END.
    
    when 4 THEN DO:
      ASSIGN     
        BtnOpen:SENSITIVE   = true
        BtnPrint:SENSITIVE  = true
        BtnInsert:SENSITIVE = FALSE
        BtnDelete:SENSITIVE = FALSE
        BtnSort:SENSITIVE   = FALSE
        BtnOrder:SENSITIVE  = FALSE
        BtnFind:SENSITIVE   = FALSE
        BtnView:SENSITIVE   = FALSE
        BtnCut:SENSITIVE    = FALSE
        BtnCopy:SENSITIVE   = FALSE
        BtnPaste:SENSITIVE  = FALSE
        BtnHelp:SENSITIVE   = true   
        
        MENU-ITEM mImport:SENSITIVE in menu mFile  = FALSE
        MENU-ITEM mExport:SENSITIVE in menu mFile  = FALSE
        MENU-ITEM mInsert:SENSITIVE in menu mEdit  = BtnInsert:SENSITIVE
        MENU-ITEM mDelete:SENSITIVE in menu mEdit  = BtnDelete:SENSITIVE 
        MENU-ITEM mFind:SENSITIVE in menu mEdit    = BtnFind:SENSITIVE 
        MENU-ITEM mReplace:SENSITIVE in menu mEdit = BtnFind:SENSITIVE 
        MENU-ITEM mSort:SENSITIVE in menu mView    = BtnSort:SENSITIVE 
        MENU-ITEM mGoto:SENSITIVE in menu mEdit    = BtnSort:SENSITIVE
        MENU-ITEM mOrder:SENSITIVE in menu mView   = BtnOrder:SENSITIVE 
        MENU-ITEM mView:SENSITIVE in menu mView    = BtnView:SENSITIVE
        MENU-ITEM mi_cln-gloss:SENSITIVE in menu m_tm-util = CONNECTED("KIT":U)
        MENU-ITEM mi_pre-trans:SENSITIVE in menu m_tm-util = CONNECTED("KIT":U)
        MENU-ITEM mi_calc-stats:SENSITIVE in menu m_tm-util = CONNECTED("KIT":U).
    END.
  end case. 
  END.
END PROCEDURE.  

PROCEDURE EvaluateProcedure:  
  /*
  ** This procedure evaluates whether or not one one has been viewed
  ** and is already in windows land.  If so, an error is returned.
  */
  define input  parameter ThisProc  AS CHARACTER     NO-UNDO.   
  define output parameter pWin      AS HANDLE   NO-UNDO.
  define output parameter pError    AS LOGICAL  NO-UNDO.
                           
  find VisualProcedures where ProcedureName = ThisProc NO-ERROR.   
  if available VisualProcedures THEN
    ASSIGN
      pWin   = VisualProcedures.hProcedure
      pError = true.
END PROCEDURE.


PROCEDURE CreateWindows: 
  /*
  ** Each time a window is created, it is added to a temp table.
  */      
 
  define input parameter pWindowHandle AS HANDLE.
  
  DEFINE VARIABLE hWin AS HANDLE NO-UNDO.
  
  if not valid-handle(pWindowHandle) THEN return.
  ASSIGN hWin = pWindowHandle:current-window.
  
  create VisualProcedures.  
  ASSIGN 
    hProcedure     = pWindowHandle  
    ProcedureName  = hWin:TITLE.  
                         
  /*
  ** Use jep's window mgr to add the entry
  */                                           
  RUN WinMenuAddItem in hWinMgr (hWinMenu, hWin:TITLE, hMain).  
  
END. 

PROCEDURE DeleteWindows:     
  /* Each time a window is 'closed', delete it from the temp table  */
  DEFINE INPUT PARAMETER pHdl AS HANDLE                       NO-UNDO.

  DEFINE VARIABLE tInt        AS INTEGER                      NO-UNDO.
  DEFINE VARIABLE WinTitle    AS CHARACTER                    NO-UNDO.
  DEFINE VARIABLE hWin        AS HANDLE                       NO-UNDO.
  DEFINE VARIABLE ProcName    AS CHARACTER                    NO-UNDO.

  ASSIGN hWin     = pHdl:CURRENT-WINDOW
         WinTitle = hWin:TITLE
         ProcName = WinTitle.

  FIND VisualProcedures WHERE ProcedureName = ProcName NO-ERROR.
  IF AVAILABLE visualprocedures THEN DELETE VisualProcedures.
  FOR EACH tTblObj WHERE tTblObj.ObjWName = ProcName:
    DELETE tTblObj.
  END.

  /* Rebuild the Window menu list  */
  CurList = "":U.
  FOR EACH VisualProcedures:
    ASSIGN CurList  = IF CurList = "":U THEN VisualProcedures.ProcedureName
                      ELSE CurList + ",":U + VisualProcedures.ProcedureName
           CurFocus = VisualProcedures.ProcedureName.
  END.
  RUN WinMenuRebuild IN hWinMgr (hWinMenu, CurList, CurFocus, hMain).
  /* Hide the property window if no .RC's are running */
  IF NOT CAN-FIND (FIRST VisualProcedures) THEN DO:
    MENU-ITEM mProps:CHECKED IN MENU mWindow = NO.
    APPLY "VALUE-CHANGED":U TO MENU-ITEM mProps IN MENU mWindow.
  END.
END PROCEDURE. /* DeleteWindows */

PROCEDURE WinMenuChoose:
  DO WITH FRAME MainFrame:
  define input parameter pWindow AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE hThisProc AS HANDLE NO-UNDO. 
  DEFINE VARIABLE Extension AS CHARACTER NO-UNDO.
        
  RUN adecomm/_osfext (pWindow,output Extension).   
  if Extension = ".db":U and KitDB = "Untitled":U THEN DO: 
    /*
    ** Note: if this kit db is read from the progress.ini file and
    ** then KitDB = "Untitled" it means that the file was last used
    ** but isn't connected right now.  This procedure reconnects to it
    */ 
    RUN adecomm/_setcurs.p ("WAIT":U). 
    KitDB = pWindow.
    RUN adetran/common/_k-alias.p (output ErrorStatus).  
    if ErrorStatus THEN DO: 
      RUN adecomm/_setcurs.p ("").
      return.
    END.  
    MainCombo = ldbname("kit":U).
    MainCombo:list-items = MainCombo. 
    
    KitDB = MainCombo.
    MainCombo:SCREEN-VALUE = KitDB. 
    RUN ResetMain.
    RUN adecomm/_setcurs.p ("").
  END. 
  
  else DO: 
    /*
    ** Note: this step is for apply focus to translation windows
    */ 
    find VisualProcedures where ProcedureName = pWindow NO-ERROR.
    if available VisualProcedures THEN DO: 
      hThisProc = hProcedure.
      RUN realize in hThisProc. 
    END. 
  END.   
  END.
END.

PROCEDURE ResetMain: 
  DO WITH FRAME MainFrame: 
    RUN adecomm/_setcurs.p ("WAIT":U).
    
    IF VALID-HANDLE(hProcs)   THEN RUN HideMe IN hProcs.
    IF VALID-HANDLE(hTrans)   THEN RUN HideMe IN hTrans.
    IF VALID-HANDLE(hGloss)   THEN RUN HideMe IN hGloss.
    IF VALID-HANDLE(hStats)   THEN RUN HideMe IN hStats.
    IF VALID-HANDLE(hFind)    THEN RUN HideMe IN hFind.
    IF VALID-HANDLE(hReplace) THEN RUN HideMe IN hReplace.
    IF VALID-HANDLE(hGoto)    THEN RUN HideMe IN hGoto.
    
    IF VALID-HANDLE(hProcs)   THEN DELETE PROCEDURE hProcs.
    IF VALID-HANDLE(hTrans)   THEN DELETE PROCEDURE hTrans.
    IF VALID-HANDLE(hGloss)   THEN DELETE PROCEDURE hGloss. 
    IF VALID-HANDLE(hStats)   THEN DELETE PROCEDURE hStats. 
    IF VALID-HANDLE(hFind)    THEN DELETE PROCEDURE hFind.  
    IF VALID-HANDLE(hReplace) THEN DELETE PROCEDURE hReplace.
    IF VALID-HANDLE(hGoto)    THEN DELETE PROCEDURE hGoto.
    IF VALID-HANDLE(hLongStr) THEN DELETE PROCEDURE hLongStr.  
    IF VALID-HANDLE(hProps)   THEN DELETE PROCEDURE hProps.  
    IF VALID-HANDLE(hLkUp)    THEN DELETE PROCEDURE hLkUp. 

    IF VALID-HANDLE(hSort)    THEN DELETE PROCEDURE hSort. 
    IF VALID-HANDLE(hResource) THEN DELETE PROCEDURE hResource. 
    
    IF CONNECTED("kit":U) THEN DO:
      RUN adetran/vt/_procs.w   PERSISTENT SET hProcs.
      RUN adetran/vt/_trans.p   PERSISTENT SET hTrans.
      RUN adetran/vt/_gloss.p   PERSISTENT SET hGloss. 
      RUN adetran/vt/_stats.w   PERSISTENT SET hStats.   
      RUN adetran/vt/_find.w    PERSISTENT SET hFind.
      RUN adetran/vt/_replace.w PERSISTENT SET hReplace.
      RUN adetran/vt/_goto.w    PERSISTENT SET hGoto.
      RUN adetran/vt/_props.w   PERSISTENT SET hProps.  
      RUN adetran/vt/_longstr.w PERSISTENT SET hLongStr.  
      RUN adetran/vt/_trlkUp.w  PERSISTENT SET hLkUp.
    END.  /* If connected */

    RUN TagProcedures.                                              
    RUN Enable_UI. 
    RUN SetSensitivity.     

  if LastKit <> "" and LastKit <> ? THEN
    RUN WinMenuRebuild in hWinMgr (hFileMenu, LastKit, LastKit, hMain).  
    
    RUN adecomm/_setcurs.p ("").
    apply "entry" to MainCombo.
  END.
END PROCEDURE.    

                                
PROCEDURE CustSensi:            
  define input parameter pWH as widget-handle NO-UNDO.
  if (valid-handle(pWH)) and (can-query(pWH,"type":U)) and 
    (pWH:type = "browse":U)  THEN ASSIGN 
    btncut:SENSITIVE  in frame MainFrame  = true
    btncopy:SENSITIVE in frame MainFrame  = true
    btnpaste:SENSITIVE in frame MainFrame = true.  
  else ASSIGN 
    btncut:SENSITIVE  in frame MainFrame  = FALSE
    btncopy:SENSITIVE in frame MainFrame  = FALSE
    btnpaste:SENSITIVE in frame MainFrame = FALSE.              

END PROCEDURE.  


PROCEDURE PropsWinState:
  DEFINE INPUT PARAMETER state AS LOGICAL NO-UNDO.  
  ASSIGN MENU-ITEM mProps:checked in menu mWindow = state.
END PROCEDURE.

PROCEDURE OpenKit:
    /* 
     * Opens a kit database. Called when user says "Open" 
     * and when a user unzips a kit 
     */
    DEFINE INPUT PARAMETER KitFile       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER Host          AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER Service       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER UsrID         AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER Passwrd       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER ConParms      AS CHARACTER NO-UNDO.

    DEFINE VARIABLE        SchemaPresent AS LOGICAL   NO-UNDO.
  
    RUN adecomm/_setcurs.p("WAIT":U).
    KitDB = KitFile.
    IF Host = "" AND Service = "" AND UsrID = "" AND
       Passwrd = "" AND ConParms = "" THEN
      RUN adetran/common/_k-alias.p (OUTPUT ErrorStatus).
    ELSE RUN adetran/vt/_k-mucon.p (Host, Service, UsrID, PassWrd, ConParms,
                                    OUTPUT ErrorStatus).  
    IF ErrorStatus THEN DO: 
      RUN adecomm/_setcurs.p ("").
      return.
    END.  

    /*
    ** Insure that this open database has the correct schema
    */ 
    RUN adetran/common/_kschema.p (output SchemaPresent).  
    if not SchemaPresent THEN DO:
      disconnect kit.
      delete alias kit. 
      ThisMessage = KitFile + "^This file is not a kit database.".
      RUN adecomm/_s-alert.p (input-output ErrorStatus, "w*":U, "ok":U, ThisMessage).    
      return.
    END. 
       
    if index(MainCombo,KitDB) = 0 THEN DO:
      If MainCombo = "Untitled":U THEN
        MainCombo = KitDB.
      else
        MainCombo = MainCombo + ",":U + KitDB.    
      
      MainCombo:list-items IN FRAME MainFrame = MainCombo.
    END. 
    RUN adetran/vt/_recount.p (input MainWindow).
    
    RUN ResetMain.
     
    LastKit = pdbname("kit":U) + ".db":U.
    RUN WinMenuRebuild in hWinMgr (hFileMenu, LastKit, LastKit, hMain).  
   
END PROCEDURE.

PROCEDURE RemoveKitRef:
  /* This procedure disconnects a kit and deletes any procedures
     which are dependent on it. Doing so will allow us to cleanly
     disconnect the database.  */
  DEFINE INPUT PARAMETER KitDB AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE h            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hh           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE dbentry      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE DelThisOne   AS LOGICAL   NO-UNDO.
  
/* *** not implemented yet (tomn 10/99)...
  /* Ensure that the "LOCKED" flag is cleared from all XL_Procedure records. */
  RUN unlockProcedure (INPUT ? /* All procedures */) IN hProcs.
*** */

  ASSIGN h = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(h):
    ASSIGN DelThisOne = NO.
    DO i = 1 TO NUM-ENTRIES(h:DB-REFERENCES):
      ASSIGN dbentry = ENTRY(i,h:DB-REFERENCES).  
      IF KitDB = dbentry THEN DO: /* this proc's got to go! */
        ASSIGN DelThisOne = YES.
        LEAVE.
      END.
    END.
    ASSIGN hh = h
            h = h:NEXT-SIBLING.
    IF DelThisOne THEN DO:
      IF CAN-DO(hh:INTERNAL-ENTRIES,"HideMe") THEN
        RUN HideMe in hh.
      DELETE PROCEDURE hh.
    END.
  END.
  DISCONNECT VALUE(KitDB) NO-ERROR.
  IF CONNECTED(KitDB) THEN MESSAGE "Could not disconnect database " KitDB
    VIEW-AS ALERT-BOX ERROR.
  ELSE DELETE ALIAS Kit.
END PROCEDURE.

PROCEDURE disableUpdate:
  /* This procedure will disable the Insert/Delete buttons and menu-items.
  ** It is called by routines (currently, only _gloss.p) that allow updates
  ** to rows in an updatable browse, that need to disable these functions
  ** while in edit mode.
  */
  IF CurrentMode = 2 THEN    /* Translation tab */
    ASSIGN
      BtnDelete:SENSITIVE IN FRAME MainFrame    = FALSE
      MENU-ITEM mDelete:SENSITIVE in menu mEdit = FALSE.
  ELSE IF CurrentMode = 3 THEN  /* Glossary Tab */
    ASSIGN
      BtnInsert:SENSITIVE IN FRAME MainFrame    = FALSE
      BtnDelete:SENSITIVE IN FRAME MainFrame    = FALSE
      MENU-ITEM mInsert:SENSITIVE in menu mEdit = FALSE
      MENU-ITEM mDelete:SENSITIVE in menu mEdit = FALSE.
END PROCEDURE.
