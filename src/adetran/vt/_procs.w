&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
/* Connected Databases 
          kit              PROGRESS
*/
&Scoped-define WINDOW-NAME WINDOW-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS WINDOW-1 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/vt/_procs.w
Author:       R. Ryan/F. Chang
Created:      1/95 
Updated:      9/95
		11/96 Long Filenames - added 2 columns since calculated fields 
		can not be enabled.
		03/97 SLK Bug# 97-03-07-082 Prevention. No 2 columns should
		have the same column name
Purpose:      Visual Translator's Procedures tab folder
Background:   This is a persistent procedure that is run from
              vt/_main.p *only* after a database is connected.
              Once connected, this procedure has the browser
              associated with the procedures functions.
Procedures:   key procedures include:

                 ViewProcedures  visualizes procedures
                 UpdStatus       Sets a mod flag for the update
                                 status.
                 Realize         Enables the browse/frame
                 OpenQuery       Reopens the query
                                              
Includes:     none 
Called by:    vt/_main.p 
Calls to:     SetSensitivity in hMain
*/


{ adetran/vt/vthlp.i } /* definitions for help context strings */  

define shared var CurrentTool   as char    no-undo.
define shared var CurrentMode   as integer no-undo.
define shared var MainWindow    as handle  no-undo.
define shared var CurWin        as handle  no-undo.
define shared var CurObj        as handle  no-undo.  
define shared var hResource     as handle  no-undo.
define shared var hMain         as handle  no-undo.  
define shared var hProps        as handle  no-undo.  
define shared var pFileName     as Char    no-undo. 
define shared var FullPathFlag  as logical no-undo.

define var ErrorStatus          as logical no-undo.
define var Result               as logical no-undo.   
define var ThisMessage          as char    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME ProcFrame
&Scoped-define BROWSE-NAME ProcBrowser

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES kit.XL_Procedure

/* Definitions for BROWSE ProcBrowser                                   */
&Scoped-define FIELDS-IN-QUERY-ProcBrowser ~
if FullPathFlag then KIT.XL_Procedure.Directory + "\":u + KIT.XL_Procedure.FileName else KIT.XL_Procedure.FileName ~
KIT.XL_Procedure.ResourceFileGenerated KIT.XL_Procedure.CurrentStatus ~
KIT.XL_Procedure.Comments 
&Scoped-define ENABLED-FIELDS-IN-QUERY-ProcBrowser 
&Scoped-define FIELD-PAIRS-IN-QUERY-ProcBrowser
&Scoped-define ENABLED-TABLES-IN-QUERY-ProcBrowser 
&Scoped-define OPEN-QUERY-ProcBrowser OPEN QUERY ProcBrowser FOR EACH kit.XL_Procedure NO-LOCK.
&Scoped-define FIRST-TABLE-IN-QUERY-ProcBrowser kit.XL_Procedure
&Scoped-define TABLES-IN-QUERY-ProcBrowser kit.XL_Procedure

/* Definitions for FRAME ProcFrame                                      */
&Scoped-define OPEN-BROWSERS-IN-QUERY-ProcFrame ~
    ~{&OPEN-QUERY-ProcBrowser}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ProcBrowser 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR WINDOW-1 AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY ProcBrowser FOR 
      kit.XL_Procedure SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE ProcBrowser
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS ProcBrowser WINDOW-1 _STRUCTURED
  QUERY ProcBrowser NO-LOCK DISPLAY
      if FullPathFlag then KIT.XL_Procedure.Directory + "\":u + KIT.XL_Procedure.FileName else KIT.XL_Procedure.FileName 
FORMAT "x(256)" WIDTH 30 COLUMN-LABEL "!Procedure Name" 
      KIT.XL_Procedure.ResourceFileGenerated COLUMN-LABEL "Resource!Procedure?"
      KIT.XL_Procedure.CurrentStatus COLUMN-LABEL "Current!Status" FORMAT "x(14)"
      KIT.XL_Procedure.Comments
      KIT.XL_Procedure.Directory FORMAT "x(256)" WIDTH 30 COLUMN-LABEL "!Directory Name"
      KIT.XL_Procedure.FileName  FORMAT "x(256)" WIDTH 30 COLUMN-LABEL "!Procedure Name (scrollable)"
   ENABLE 
      KIT.XL_Procedure.ResourceFileGenerated
      KIT.XL_Procedure.Directory
      KIT.XL_Procedure.FileName 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 86 BY 12
          &ELSE SIZE-PIXELS 601 BY 299 &ENDIF
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME ProcFrame
     ProcBrowser AT Y 0 X 0
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 14 Y 52
         SIZE-PIXELS 602 BY 299
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW WINDOW-1 ASSIGN
         HIDDEN             = YES
         TITLE              = "Window 1"
         X                  = 149
         Y                  = 146
         HEIGHT-P           = 419
         WIDTH-P            = 634
         MAX-HEIGHT-P       = 419
         MAX-WIDTH-P        = 650
         VIRTUAL-HEIGHT-P   = 419
         VIRTUAL-WIDTH-P    = 650
         RESIZE             = yes
         SCROLL-BARS        = yes
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
                                                                        */
&ANALYZE-RESUME
ASSIGN WINDOW-1 = CURRENT-WINDOW.



/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW WINDOW-1
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE ProcBrowser
/* Query rebuild information for BROWSE ProcBrowser
     _TblList          = "kit.XL_Procedure"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > "_<CALC>"
"if FullPathFlag then KIT.XL_Procedure.Directory + ""\"":u + KIT.XL_Procedure.FileName else KIT.XL_Procedure.FileName" "!Procedure Name" "x(40)" "Character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > KIT.XL_Procedure.ResourceFileGenerated
"ResourceFileGenerated" "Resource!Procedure?" ? "logical" ? ? ? ? ? ? no ?
     _FldNameList[3]   > KIT.XL_Procedure.CurrentStatus
"CurrentStatus" "Current!Status" "x(14)" "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   = KIT.XL_Procedure.Comments
     _Query            is OPENED
*/  /* BROWSE ProcBrowser */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME ProcFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ProcFrame WINDOW-1
ON HELP OF FRAME ProcFrame
DO:
  RUN adecomm/_adehelp.p ("VT":U, "CONTEXT":U, {&VT_Procedures_Tab_Folder}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ProcFrame WINDOW-1
ON mouse-select-dblclick OF FRAME ProcFrame
anywhere
do:
  run ViewProcedure.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME ProcBrowser
&Scoped-define SELF-NAME ProcBrowser
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ProcBrowser WINDOW-1
ON mouse-select-dblclick OF ProcBrowser IN FRAME ProcFrame
DO:
  run ViewProcedure.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ProcBrowser WINDOW-1
ON VALUE-CHANGED OF ProcBrowser IN FRAME ProcFrame
DO:
  run adecomm/_osfmush.p
    (input  trim(kit.XL_Procedure.Directory , ".":u) ,
     input  kit.XL_Procedure.FileName,
     output pFileName).    
END.

ON ANY-KEY OF XL_Procedure.Directory IN BROWSE ProcBrowser
DO:
  IF NOT CAN-DO("CURSOR-*,END,HOME,TAB",KEYLABEL(LASTKEY)) THEN RETURN NO-APPLY.
END.
ON ANY-KEY OF XL_Procedure.FileName IN BROWSE ProcBrowser
DO:
  IF NOT CAN-DO("CURSOR-*,END,HOME,TAB",KEYLABEL(LASTKEY)) THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK WINDOW-1 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/*
** Note: all the close stuff has been excluded from processing.
*/

{adetran/common/noscroll.i}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK: 
   
  assign ProcBrowser:num-locked-columns = 2.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HideMe WINDOW-1 
PROCEDURE HideMe :
frame ProcFrame:hidden = true.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQuery WINDOW-1 
PROCEDURE OpenQuery :
do with frame {&frame-name}:
    open query ProcBrowser for each kit.XL_Procedure no-lock.      
    
    find first kit.XL_Project NO-LOCK no-error. 
    if available kit.XL_Project and kit.XL_Project.NumberOfProcedures > 0 then
      ProcBrowser:max-data-guess = kit.XL_Project.NumberOfProcedures.
  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize WINDOW-1 
PROCEDURE Realize :
assign frame ProcFrame:hidden = true.
  enable all with frame ProcFrame in window MainWindow. 
  run OpenQuery.  
  assign frame ProcFrame:hidden = false. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UpdStatus WINDOW-1 
PROCEDURE UpdStatus :
DEFINE VARIABLE num_inst  AS INTEGER                  NO-UNDO.
  DEFINE VARIABLE num_trans AS INTEGER                  NO-UNDO.
  DEFINE VARIABLE tmp_fl    AS CHARACTER                NO-UNDO.

  if (avail kit.XL_Procedure) THEN DO:
    FIND CURRENT kit.XL_Procedure EXCLUSIVE-LOCK.
    ASSIGN num_inst  = 0
           num_trans = 0
           tmp_fl    = (IF kit.XL_Procedure.directory NE "":U AND
                           kit.XL_Procedure.directory NE ".":U THEN
                          kit.XL_Procedure.directory + "~\":U ELSE "":U) + 
                          kit.XL_Procedure.FileName.
                          
    FOR EACH kit.xl_instance WHERE kit.xl_instance.ProcedureName = tmp_fl NO-LOCK:
      ASSIGN num_inst  = num_inst + 1
             num_trans = num_trans + (IF kit.xl_instance.TargetPhrase NE ? AND
                                         kit.xl_instance.TargetPhrase NE "":U
                         THEN 1 ELSE 0).
    END. /* For each instance of the procedure */
    ASSIGN kit.XL_Procedure.CurrentStatus =
                 IF num_trans = 0             THEN "Untranslated":U
                 ELSE IF num_trans = num_inst THEN "Translated":U
                 ELSE (STRING(num_trans) + " of ":U + STRING(num_inst))
           kit.XL_Procedure.CurrentStatus:screen-value in browse ProcBrowser =
                 kit.XL_Procedure.CurrentStatus.
  END. /* If the procedure record is available */           
  apply "entry":u to frame ProcFrame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ViewProcedure WINDOW-1 
PROCEDURE ViewProcedure :
do with frame ProcFrame:  
  
  run adecomm/_setcurs.p ("wait":u).   
  define var ThisProc     as char    no-undo.  
  define var xTrans       as integer no-undo.
  define var yTrans       as integer no-undo.
  define var xWidth       as integer no-undo. 
  define var hWin         as handle  no-undo.    
  define var dir          as char    no-undo.
  define var RootDir      as char    no-undo.
  define var ResourceFile as char    no-undo.  
  define var RCodeFile    as char    no-undo.
  define var BackupFile   as char    no-undo.   
  define var File_Name    as char    no-undo.
  
  if ProcBrowser:num-selected-rows < 1 then do:
    ThisMessage = "You must select a procedure first.".
    run adecomm/_s-alert.p (input-output ErrorStatus, "w":u,"ok":u, ThisMessage). 
    return.
  end.
  
  if not kit.XL_Procedure.ResourceFileGenerated then do:
    ThisMessage = "This file can't be viewed as a resource procedure.".
    run adecomm/_s-alert.p (input-output ErrorStatus, "w":u,"ok":u, ThisMessage). 
    return.
  end.      
  
  find first kit.XL_Project NO-LOCK no-error.
  if available kit.XL_Project then
    RootDir = kit.XL_Project.RootDirectory.

  assign Dir       = trim(kit.XL_Procedure.Directory , ".":u)
         File_Name = kit.XL_Procedure.FileName.

  run adecomm/_osfmush.p
    (input Dir , input File_Name, output ResourceFile).  
  run adecomm/_osfmush.p
    (input RootDir , input ResourceFile, output ResourceFile).
  run adecomm/_osfmush.p
    (input Dir , input File_Name, output ThisProc).  

  assign ResourceFile = entry(1,ResourceFile,".":u) + ".rc":u
         CurWin       = MainWindow
         CurObj       = MainWindow. 
  /* Perhaps a mapped drive situation */
  IF SEARCH(ResourceFile) = ? THEN DO:
    /* Can't find the file - look around hopfully the file is in the propath */
    IF SEARCH(ENTRY(1,kit.XL_Procedure.FileName, ".":U) + ".rc":U) NE ? THEN
      ResourceFile = SEARCH(ENTRY(1,kit.XL_Procedure.FileName, ".":U) + ".rc":U).
  END.
       
  if ResourceFile = ? then do:
    ThisMessage = "Resource procedure not found.".
    run adecomm/_s-alert.p (input-output ErrorStatus, "w":u,"ok":u, ThisMessage). 
    return.
  end.                                      

  run EvaluateProcedure in hMain (input ThisProc, output hWin, output ErrorStatus).
    
  if ErrorStatus then do:  
    run realize in hWin.
    return.
  end.           

  assign pFileName          = ThisProc
         file-info:filename = entry(1,pFileName,".":u) + ".r":u
         RCodeFile          = file-info:full-pathname
         BackupFile         = entry(1,RCodeFile,".":u) + ".bak":u.   
    
  if RCodefile <> ? then do:                                   
    os-copy value(RCodeFile) value(BackupFile).
    os-delete value (RCodeFile) no-error. 
  end.
  
  do on stop undo, next :
    run value(ResourceFile) persistent set hResource.
    if valid-handle(hResource) then hResource:private-data = CurrentTool.
    run CreateWindows in hMain (input hResource).
  end.   
  
  if RCodeFile <> ? then do:
    os-copy value(BackupFile) value(RcodeFile).
    os-delete value(BackupFile).
  end.
  run adecomm/_setcurs.p ("").   
end. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


