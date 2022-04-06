&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_newfile.w
Author:       R. Ryan
Created:      1/95 
Updated:      9/95
                12/96 SLK lc/caps
                01/97 SLK Removed check on directory already in list
Purpose:      Dialog which allows the user to add procedures to
              their project which they intend to translate.
Background:   Once a project has been defined (which assumes an
              application directory, whole directories or individual
              files can be added.  A radio-set below the filename
              fill-in indicates whether it is directory or filename.
              Subsequently, a 'leave' event determines if the file
              type is a directory or file.  If there is a conflict
              with the filetype, the user is warned, and the radio-set
              toggle is moved to the appropriate setting.
              
Notes:        If an entire directory is specified, every .w and/or .p
              is (by default) entered into the XL_Procedure table. A
              corresponding directory is added to the Directory selection
              list.  If the 'Include subdirectory' toggle is selected,
              every 1st-level subdirectory is selected (however, it is
              not recursive, it doesn't return subdirectories of
              subdirectories).

Parameters:   pDirs (input/char)           The current directory (as a default)
              pFile (output/char)          The name of the file or directory being returned
              pType (output/char)          F=File, D=Directory
              pOKPressed (output/logical)  Was the OK button pressed?

Called By:    pm/_pmprocs.w

*/
 
define input  parameter pDirs      as char no-undo.
define output parameter pFile      as char no-undo. 
define output parameter pType      as char no-undo.
define output parameter pOKPressed as log  no-undo.


{ adetran/pm/tranhelp.i }

define var ThisMessage as char  no-undo.
define var ErrorStatus as log   no-undo.
define var Source-Dir  as char  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Rect3 Rect-4 BtnOK FileName BtnFile ~
BtnCancel FileType BtnHelp IncludeSubdirs DirLabel OptionsLabel 
&Scoped-Define DISPLAYED-OBJECTS FileName FileType IncludeSubdirs DirLabel ~
OptionsLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY 
     LABEL "Cancel":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnFile 
     LABEL "Fi&les...":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnHelp 
     LABEL "&Help":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnOK AUTO-GO 
     LABEL "OK":L 
     SIZE 15 BY 1.14.

DEFINE VARIABLE DirLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Directory" 
      VIEW-AS TEXT 
     SIZE 10.6 BY .67 NO-UNDO.

DEFINE VARIABLE FileName AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN NATIVE 
     SIZE 35.2 BY 1 NO-UNDO.

DEFINE VARIABLE OptionsLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Options" 
      VIEW-AS TEXT 
     SIZE 9.6 BY .67 NO-UNDO.

DEFINE VARIABLE FileType AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "All Files In A &Directory", "D":U,
"A Specific &File", "F":U
     SIZE 34.2 BY 1.52 NO-UNDO.

DEFINE RECTANGLE Rect-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54.2 BY 1.33.

DEFINE RECTANGLE Rect3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54.4 BY 3.33.

DEFINE VARIABLE IncludeSubdirs AS LOGICAL INITIAL no 
     LABEL "Add Files In &Subdirectories" 
     VIEW-AS TOGGLE-BOX
     SIZE 46.4 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     BtnOK AT ROW 1.57 COL 58
     FileName AT ROW 2 COL 4.4 NO-LABEL
     BtnFile AT ROW 2 COL 40.4
     BtnCancel AT ROW 2.81 COL 58
     FileType AT ROW 3.1 COL 4.4 NO-LABEL
     BtnHelp AT ROW 4.05 COL 58
     IncludeSubdirs AT ROW 5.52 COL 4.6
     DirLabel AT ROW 1.24 COL 1.8 COLON-ALIGNED NO-LABEL
     OptionsLabel AT ROW 4.91 COL 2.4 COLON-ALIGNED NO-LABEL
     Rect3 AT ROW 1.52 COL 2.6
     Rect-4 AT ROW 5.19 COL 2.8
     SPACE(16.79) SKIP(0.47)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Add Procedures"
         DEFAULT-BUTTON BtnOK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN FileName IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Add Procedures */
DO:
  DEFINE VARIABLE TestName         AS CHARACTER                             NO-UNDO.
  DEFINE VARIABLE DirName          AS CHARACTER                             NO-UNDO.
  DEFINE VARIABLE BaseName         AS CHARACTER                             NO-UNDO.
  DEFINE VARIABLE DirectoryPresent AS LOGICAL                               NO-UNDO.
  DEFINE VARIABLE i                AS INTEGER                               NO-UNDO. 
  DEFINE VARIABLE ThisType         AS CHARACTER                             NO-UNDO.
  DEFINE VARIABLE InitPath         AS CHARACTER                             NO-UNDO.
  DEFINE VARIABLE AddDirs          LIKE InitPath.
  DEFINE VARIABLE start-dir        AS CHARACTER                             NO-UNDO.
  DEFINE VARIABLE Add_Type         AS CHARACTER                             NO-UNDO.

  ASSIGN FileName:SCREEN-VALUE = TRIM(FileName:SCREEN-VALUE)
         FILE-INFO:FILE-NAME   = FileName:SCREEN-VALUE
         ThisType = SUBSTRING(FILE-INFO:FILE-TYPE, 1, 1, "CHARACTER":U)
         Add_Type = IF FileType:SCREEN-VALUE = "D":U
                    THEN "Directory":U ELSE "File":U .
  
  /* It is illegal to have a filename be one of the two reserved keywords
     "Untitled" and "None".                                                 */
  IF CAN-DO("UNTITLED,NONE":U,ENTRY(1,FILE-INFO:FILE-NAME,".":U)) THEN DO:
    ASSIGN ThisMessage = ENTRY(1,FILE-INFO:FILE-NAME,".":U) + 
             " is a reserved keyword and may not be used as a filename.".
    RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"e*":U, "ok":U, ThisMessage).
    APPLY "ENTRY":U TO FileName IN FRAME Dialog-frame.
    RETURN NO-APPLY.  
  END. 
       
  /* If the entry is a relative pathname, concatenate it with the Application
     Source Code directory. Then see if the entry is a subdirectory or a file
     within the Source Code directory. If not, reject it.                      */
  IF FileName:SCREEN-VALUE <> FILE-INFO:FULL-PATHNAME THEN
    ASSIGN TestName = Source-Dir + "~\" + FileName:SCREEN-VALUE
           FILE-INFO:FILE-NAME = TestName
           ThisType = SUBSTRING(FILE-INFO:FILE-TYPE,1,1,"CHARACTER":U)
           TestName = "".

  IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
    ASSIGN ThisMessage =  FileName:SCREEN-VALUE +
                          SUBSTITUTE("^This &1 cannot be found. " +
                        "Please verify that the pathname is correct and that the &1 " +
                        "exists in source code directory &2.",
                        Add_Type, Source-Dir).
    RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w*":U, "ok":U, ThisMessage).    
    APPLY "ENTRY":U TO FileName IN FRAME Dialog-frame.
    RETURN NO-APPLY.
  END.
  
  IF ThisType = "F":U AND FileType:SCREEN-VALUE = "D":U THEN DO:
    ASSIGN ThisMessage = FileName:SCREEN-VALUE + 
                              "^This is a file rather than a directory name.".
    RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w*":U, "ok":U, ThisMessage).    
    FileType:SCREEN-VALUE = ThisType.          
    APPLY "VALUE-CHANGED" TO FileType IN FRAME Dialog-frame.
    APPLY "ENTRY":U TO FileName IN FRAME Dialog-frame.
    RETURN NO-APPLY.
  END.
  
  IF ThisType = "D":U AND FileType:SCREEN-VALUE = "F":U THEN DO:         
    ThisMessage = FileName:SCREEN-VALUE + "^This is a directory rather than a filename.".
    RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w*":U, "ok":U, ThisMessage).    
    FileType:SCREEN-VALUE = ThisType.       
    APPLY "VALUE-CHANGED" TO FileType IN FRAME Dialog-frame.
    APPLY "ENTRY":U TO FileName IN FRAME Dialog-frame.
    RETURN NO-APPLY.
  END.            

  IF (NOT FILE-INFO:FULL-PATHNAME BEGINS Source-Dir + "\":U) AND
     (Source-Dir <> FILE-INFO:FULL-PATHNAME) THEN DO:
    IF Add_Type = "Directory":U THEN
      ASSIGN ThisMessage = FileName:SCREEN-VALUE +
              SUBSTITUTE("^The specified &1 must be a subdirectory of " +
                           "source code directory &2."
                           , Add_Type, Source-Dir).
    ELSE
      ASSIGN ThisMessage = FileName:SCREEN-VALUE + 
              SUBSTITUTE("^The specified &1 must be in source code " +
                           "directory &2 or in one of its subdirectories."
                           , Add_Type, Source-Dir).
                           
    RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w*":U, "ok":U, ThisMessage).    
    APPLY "ENTRY":U TO FileName IN FRAME Dialog-frame.
    RETURN NO-APPLY.
  END.

  IF FileType:SCREEN-VALUE = "F":U THEN DO:
    RUN adecomm/_osprefx.p (FileName:SCREEN-VALUE, OUTPUT DirName, OUTPUT BaseName). 
    IF DirName = "" THEN DirName = ".".                                 

    FIND xlatedb.XL_Procedure WHERE
       xlatedb.XL_Procedure.FileName = FileName:SCREEN-VALUE AND
       xlatedb.XL_Procedure.Directory = DirName NO-LOCK NO-ERROR.
    IF AVAILABLE xlatedb.XL_Procedure THEN DO:
       ThisMessage =  FILE-INFO:FILENAME +
         "^This file is already in the project database and cannot not be added again.".
       RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w*":U, "ok":U, ThisMessage).    
       APPLY "ENTRY":U TO FileName IN FRAME Dialog-frame.
       RETURN NO-APPLY. 
    END.                
  END.

  /* File or directory is OK to add. So add it. */  
  IF IncludeSubDirs:CHECKED AND FileType:SCREEN-VALUE = "D":U THEN DO:
    /* explode the directory */
    ASSIGN FILE-INFO:FILENAME = FileName:SCREEN-VALUE
           InitPath           = FILE-INFO:FULL-PATHNAME
           start-dir          = FileName:SCREEN-VALUE.
    DO TRANSACTION:
      FIND FIRST xlatedb.XL_Project.
      IF NUM-ENTRIES(xlatedb.XL_Project.ProjectRevision,CHR(4)) < 2 THEN
        xlatedb.XL_Project.ProjectRevision =
                           ENTRY(1, xlatedb.XL_Project.ProjectRevision, CHR(4)) +
                                   CHR(4) + "NO":U + CHR(4) + "YES ":U + start-dir.
      ELSE
        xlatedb.XL_Project.ProjectRevision =
                           ENTRY(1, xlatedb.XL_Project.ProjectRevision, CHR(4)) +
                                   CHR(4) + ENTRY(2, xlatedb.XL_Project.ProjectRevision, CHR(4)) +
                                   CHR(4) + "YES ":U + start-dir.
    END.  /* EndTransaction */
    RUN adetran/pm/_subdirs.w (INPUT start-dir, OUTPUT AddDirs).
  END. /* If we need to process subdirectories */   
    
  IF FileType:SCREEN-VALUE = "F" THEN pFile = FileName:SCREEN-VALUE.
  ELSE DO:
    pFile = IF AddDirs = "":U THEN FileName:SCREEN-VALUE ELSE AddDirs.
    IF ENTRY(1, pFile,",":U) = Source-Dir THEN ASSIGN ENTRY(1, pFile,",":U) = ".":U.
  END.

  /* Strip out the Source-Dir. */
  ASSIGN pFile      = REPLACE(pfile, Source-Dir + "\":U, "":U)
         pOKPressed = TRUE
         pType      = FileType:SCREEN-VALUE.
END.  /* Go of dialog */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnFile Dialog-Frame
ON CHOOSE OF BtnFile IN FRAME Dialog-Frame /* Files... */
DO: 
  define var ThisFile   as char no-undo.
  define var OKPressed  as logical no-undo.
  define var DirName    as char no-undo.
  define var Init-Dir   as char no-undo.
  define var BaseName   as char no-undo.
  define var ThisType   as char no-undo.

  if not available (xlatedb.xl_project) then
    find first xl_project no-lock no-error.  
    
  /* Make the get-file dialog initialize to the
   * application directory.
   */
  assign init-dir = xl_project.appldirectory.
  
  if FileType:screen-value = "F":u then
  do:
    ASSIGN ThisFile = trim(FileName:screen-value)
           file-info:file-name = FileName:screen-value
           ThisType = substr(file-info:file-type,1,1,"character":u)
           .
    IF file-info:full-pathname = ? OR ThisType <> "F":u THEN
      ASSIGN ThisFile = "".
           
    SYSTEM-DIALOG GET-FILE ThisFile
       TITLE      "Get File"
       FILTERS    "All Source(*.p,*.w)" "*.p,*.w":u,
                  "All Windows(*.w)" "*.w":u,
                  "All Procedures(*.p)" "*.p":u,
                  "All Files(*.*)"  "*.*":u  
       INITIAL-DIR Init-Dir
       USE-FILENAME
       UPDATE OKpressed.
  end.
  else       
  do:
    ASSIGN ThisFile = "^":U.
    SYSTEM-DIALOG GET-FILE ThisFile
       TITLE      "Get Directory"
       FILTERS    "All Source(*.p,*.w)" "*.p,*.w":u,
                  "All Windows(*.w)" "*.w":u,
                  "All Procedures(*.p)" "*.p":u,
                  "All Files (*.*)"  "*.*":u
       INITIAL-DIR Init-Dir
       USE-FILENAME
       UPDATE OKpressed.
  end.
       
  if OKpressed = TRUE then do:
    if FileType:screen-value = "D":u then do:
      run adecomm/_osprefx.p (ThisFile, output DirName, output BaseName).                                  
        assign
          DirName               = right-trim(DirName,"\":u)
          FileName:screen-value = DirName. 
    end.  
    else
      FileName:screen-value = ThisFile.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp Dialog-Frame
ON CHOOSE OF BtnHelp IN FRAME Dialog-Frame /* Help */
or help of frame {&frame-name} do:
  run adecomm/_adehelp.p ("tran":u,"context":u,{&Add_Procedures_Dlgbx}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FileType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FileType Dialog-Frame
ON VALUE-CHANGED OF FileType IN FRAME Dialog-Frame
DO:
  if self:screen-value = "F":u then assign
    IncludeSubDirs:checked   = false
    IncludeSubDirs:sensitive = false
    DirLabel:screen-value    = "Filename".
 else assign
    IncludeSubDirs:sensitive = true
    DirLabel:screen-value    = "Directory".

 DirLabel:width = font-table:get-text-width-chars (DirLabel:screen-value,4).
 apply "leave":u to FileName.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON STOP    UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  /* Need Project Application Source Directory to be sure selected
     file or directory is 1) In the Appl Dir and 2) Can be found via
     the PROPATH.
  */
  find first xlatedb.XL_Project no-lock.
  assign Source-Dir = xlatedb.XL_Project.ApplDirectory.
  
  assign
    DirLabel:screen-value      = "Directory"
    DirLabel:width             = font-table:get-text-width-chars (DirLabel:screen-value,4)
    OptionsLabel:screen-value = "Options"
    OptionsLabel:width        = font-table:get-text-width-chars (OptionsLabel:screen-value,4).  

  RUN Realize.
  WAIT-FOR GO OF FRAME {&FRAME-NAME} FOCUS FileName.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize Dialog-Frame 
PROCEDURE Realize :
frame {&frame-name}:hidden = true. 

  display
    IncludeSubDirs
  with frame dialog-frame.
    
  enable 
    FileName
    BtnFile
    FileType
    IncludeSubDirs
    BtnOk
    BtnCancel
    BtnHelp
  with frame dialog-frame.
  
  assign
    IncludeSubDirs:checked     = false
    frame {&frame-name}:hidden = false.
                                              
  run adecomm/_setcurs.p ("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

