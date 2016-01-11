&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME d_openso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS d_openso 
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
/*------------------------------------------------------------------------

  File: _chosobj.w

  Description: Choose dialog for custom objects 

  Input Parameters:
     p_mode (char) - defines mode for dialog: {&WT-CONTROL} OR ""
                     (i.e. OCX or non-OCX (SmartObjects)
     p_cst-attr (char) - chr(10) delimited list of options from .cst file:
                   DIRECTORY-LIST dir1,dir2,...       /* list of dirs to search */
                   FILTERS        filter1,filter2,... /* file filters to use */
                   TITLE          <string>            /* title for this dialog */
     p_newTemplate (char) - template designated for a new object of this type
                            (e.g. from .cst file: NEW-TEMPLATE <templ-name>)
     p_showOptions (char) - buttons to enable in the dialog-box in a CDL:
                            BROWSE, NEW, PREVIEW
     
  Output Parameters:
     p_fileChosen (char) - filename of object to draw in a window or dialog
     p_otherThing (char) - OCX chosen to draw (unused for SmartObjects)
     p_cancelled  (log)  - True if the user cancelled out of the dialog

  Author: Gerry Seidl 

  Created: 02/12/95 - 10:11 pm

  Modified on 7/31/95 - Moved to adecomm
  Modified on 5/3/98 HD - Added remote file management  

  Note:    Remote file management has some differences in behaviour.
           Because asynchron OCX events is used some variables and settings 
           must be treated differently. 
           Error handling is very different, because we cannot check for 
           valid files and directories in the procedures that changes 
           paths and filters.     
           
           WAIT-FOR U1 to be able to hide frame while waiting for 
           response from server.              
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/commeng.i}   /* Help String Definitions                 */

/* ***************************  Definitions  ************************** */
&GLOBAL-DEFINE WT-CONTROL               OCX
&GLOBAL-DEFINE WL-CONTROL               OCX-Controls

  
  DEFINE STREAM inStream.   
 
 /** 
 The temptable is used to store the file type for remotefiles because
 the selection list also shows directories */
     
  DEFINE TEMP-TABLE tRmtFile 
    FIELD Num      AS INTEGER 
    FIELD Name     AS CHARACTER
    FIELD FileType AS CHARACTER
    INDEX Num  Num 
    INDEX Name Name.
  
/* Parameters Definitions ---   */
  DEFINE INPUT  PARAMETER p_mode        AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER p_cst-attr    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER p_newTemplate AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER p_showOptions AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_fileChosen  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_otherThing  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_cancelled   AS LOGICAL   NO-UNDO INITIAL FALSE. 

  
/* Local global variables */  
  DEFINE VARIABLE gBrokerURL   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE gRemotefile  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE gRmtFullPath AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE gFileSearch  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE gFilter      AS CHAR       NO-UNDO.
  DEFINE VARIABLE gError       AS LOGICAL    NO-UNDO.
   
  DEFINE VARIABLE gFilters     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE gPathAdded   AS LOG       NO-UNDO.
  DEFINE VARIABLE gOldPath     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE gDirs        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE gTdirs       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE gTitle       AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE gBrowseone   AS LOGICAL   NO-UNDO INITIAL no.
  DEFINE VARIABLE gNewone      AS LOGICAL   NO-UNDO INITIAL no.

    
  DEFINE VARIABLE gHelpFile   AS INTEGER   NO-UNDO.

  DEFINE VARIABLE rc          AS LOGICAL   NO-UNDO.
  /* Used in error message set from p_mode*/
  DEFINE VARIABLE gObjectType AS CHAR      NO-UNDO.
  
  DEFINE VARIABLE DOS-SLASH   AS CHARACTER NO-UNDO INITIAL "~\":U.
  DEFINE VARIABLE UNIX-SLASH  AS CHARACTER NO-UNDO INITIAL "/":U.
  DEFINE VARIABLE OS-SLASH    AS CHARACTER NO-UNDO INITIAL "/":U.
  
  DEFINE VARIABLE xMatchClient AS CHAR      NO-UNDO INITIAL "*_cl~~.w".
           
   /* Initialized in main block. */

/*
** Patrick Tullmann's Dir DLL
*/
{adecomm/dirsrch.i}
  DEFINE VARIABLE list-mem    AS MEMPTR            NO-UNDO.
  DEFINE VARIABLE list-char   AS CHARACTER         NO-UNDO.
  DEFINE VARIABLE list-size   AS INTEGER INIT 8000 NO-UNDO. 
  DEFINE VARIABLE missed-file AS INTEGER           NO-UNDO.
  DEFINE VARIABLE DirError    AS INTEGER           NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME d_openso

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS filename s_files cb_filters cb_dirs listlbl 
&Scoped-Define DISPLAYED-OBJECTS filename cb_filters cb_dirs listlbl 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_Browse 
     LABEL "&Browse..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_New 
     LABEL "&New..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_Preview 
     LABEL "&Preview..." 
     SIZE 15 BY 1.14.

DEFINE VARIABLE cb_dirs AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE cb_filters AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE fiCurDir AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 50.4 BY .62 NO-UNDO.

DEFINE VARIABLE filename AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE listlbl AS CHARACTER FORMAT "X(256)":U INITIAL "Master File:" 
      VIEW-AS TEXT 
     SIZE 16 BY .62 NO-UNDO.

DEFINE VARIABLE s_files AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE NO-DRAG SORT SCROLLBAR-VERTICAL 
     SIZE 33 BY 5 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME d_openso
     filename AT ROW 2.76 COL 3 NO-LABEL
     s_files AT ROW 3.76 COL 5 NO-LABEL
     cb_filters AT ROW 9.91 COL 3 NO-LABEL
     cb_dirs AT ROW 11.76 COL 3 NO-LABEL
     b_Preview AT ROW 2.76 COL 39
     b_Browse AT ROW 4.14 COL 39
     b_New AT ROW 7.67 COL 39
     fiCurDir AT ROW 1.24 COL 3 NO-LABEL
     listlbl AT ROW 2.1 COL 1 COLON-ALIGNED NO-LABEL
     "File Filter:" VIEW-AS TEXT
          SIZE 14 BY .62 AT ROW 9.19 COL 3
     "Directory:" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 11.05 COL 3
     SPACE(39.56) SKIP(1.55)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Open SmartObject".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX d_openso
   NOT-VISIBLE L-To-R,COLUMNS                                           */
ASSIGN 
       FRAME d_openso:SCROLLABLE       = FALSE
       FRAME d_openso:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b_Browse IN FRAME d_openso
   NO-ENABLE                                                            */
ASSIGN 
       b_Browse:HIDDEN IN FRAME d_openso           = TRUE.

/* SETTINGS FOR BUTTON b_New IN FRAME d_openso
   NO-ENABLE                                                            */
ASSIGN 
       b_New:HIDDEN IN FRAME d_openso           = TRUE.

/* SETTINGS FOR BUTTON b_Preview IN FRAME d_openso
   NO-ENABLE                                                            */
ASSIGN 
       b_Preview:HIDDEN IN FRAME d_openso           = TRUE.

/* SETTINGS FOR COMBO-BOX cb_dirs IN FRAME d_openso
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX cb_filters IN FRAME d_openso
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiCurDir IN FRAME d_openso
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN filename IN FRAME d_openso
   ALIGN-L                                                              */
/* SETTINGS FOR SELECTION-LIST s_files IN FRAME d_openso
   NO-DISPLAY                                                           */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME d_openso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d_openso d_openso
ON ENDKEY OF FRAME d_openso /* Open SmartObject */
OR END-ERROR OF FRAME d_openso
DO:
  ASSIGN
    p_fileChosen = "":U
    p_otherThing = "":U
    p_cancelled = TRUE
  .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Browse d_openso
ON CHOOSE OF b_Browse IN FRAME d_openso /* Browse... */
DO:
  RUN adecomm/_opnfile.w
      ("Open an object":U ,
       "AppBuilder files (*.w),R-code files (*.r),All Files (*.*)":U,  
       INPUT-OUTPUT p_fileChosen).
       
  /* Did we cancel at this point? */
  IF p_fileChosen = "":U THEN RETURN NO-APPLY.
  ELSE DO:
    /* Set the flag that indicates we just browsed a file (so that
       the "GO" action won't look at the file name in the selection list) */
    gBrowseone = YES.
    APPLY "U1" TO THIS-PROCEDURE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_New
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_New d_openso
ON CHOOSE OF b_New IN FRAME d_openso /* New... */
DO:
  IF p_newTemplate <> "" OR p_newTemplate = ? THEN DO:
    FILE-INFO:FILE-NAME = p_newTemplate.
    IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
      ASSIGN FRAME {&FRAME-NAME}:HIDDEN = YES.
      RUN adeuib/_open-w.p (FILE-INFO:FULL-PATHNAME, "", "UNTITLED"). /* open from template in UIB */
      ASSIGN gNewone  = YES.
      APPLY "U1" TO THIS-PROCEDURE. /* direct path out */
    END.
  END.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Preview
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Preview d_openso
ON CHOOSE OF b_Preview IN FRAME d_openso /* Preview... */
DO:
  DEFINE VARIABLE ok_choice AS LOGICAL NO-UNDO.
  
  Run adecomm/_setcurs.p("WAIT":u).
  /* See if there is a valid choice? */
  RUN Check_Filechosen (OUTPUT ok_choice).
 
  /* If so, preview the current object in a dialog-box */
  IF ok_choice THEN 
    If p_mode = "{&WT-CONTROL}":U then 
      run adeuib/_prvcont.w(p_fileChosen, p_otherThing).
    Else 
      run adeuib/_so-prvw.w(p_fileChosen).
      
  Run adecomm/_setcurs.p("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb_dirs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb_dirs d_openso
ON VALUE-CHANGED OF cb_dirs IN FRAME d_openso
DO:
  If cb_dirs = cb_dirs:SCREEN-VALUE then 
    RETURN.    
  RUN BuildFileList. 
  ASSIGN cb_dirs.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb_filters
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb_filters d_openso
ON VALUE-CHANGED OF cb_filters IN FRAME d_openso
DO:
  If cb_filters = cb_filters:SCREEN-VALUE then 
    RETURN. 
  RUN BuildFileList.  
  ASSIGN cb_filters.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME s_files
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s_files d_openso
ON DEFAULT-ACTION OF s_files IN FRAME d_openso
DO:
  APPLY "U1" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s_files d_openso
ON ENTRY OF s_files IN FRAME d_openso
DO:
  
  IF SELF:SCREEN-VALUE <> "":U AND
     SELF:SCREEN-VALUE <> ?  AND
     SELF:SCREEN-VALUE <> "?" AND
     SELF:SCREEN-VALUE <> "<None>" THEN
       ASSIGN filename:SCREEN-VALUE = SELF:SCREEN-VALUE.
     ELSE filename:SCREEN-VALUE = "".
     
  Filename = filename:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s_files d_openso
ON VALUE-CHANGED OF s_files IN FRAME d_openso
DO:
  IF SELF:SCREEN-VALUE <> "":U AND
     SELF:SCREEN-VALUE <> ?  AND
     SELF:SCREEN-VALUE <> "?" AND
     SELF:SCREEN-VALUE <> "<None>" THEN
       ASSIGN filename:SCREEN-VALUE = SELF:SCREEN-VALUE.
     ELSE filename:SCREEN-VALUE = "":U.
  
  /*
   * Reset the user's choices
   */
  
  assign   
      filename = filename:SCREEN-VALUE
      p_fileChosen = "":U
      p_otherThing = "":U
  .
     
  RUN Set_Sensitivity.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK d_openso 


/* ***************************  Main Block  *************************** */

IF p_mode = "{&WT-CONTROL}":U THEN gHelpFile = {&Choose_VBX_Controls_Dlg_Box}.
                              ELSE gHelpFile = {&Choose_SmartObject_Dlg_Box}.

IF LOOKUP(OPSYS, "MSDOS,WIN32":u) > 0 THEN
  ASSIGN OS-SLASH = "~\":u.
ELSE
  ASSIGN OS-SLASH = "/":u.

{ adecomm/okbar.i &TOOL    = "COMM"
                  &CONTEXT = gHelpFile
                 }

                 
/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

ON GO OF FRAME {&FRAME-NAME}  
   APPLY "U1":U TO THIS-PROCEDURE.

ON U1 OF THIS-PROCEDURE DO: 
  IF NOT gNewOne THEN
  DO:
    RUN ApplyGo NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
  END.
END.    

ON RETURN OF FRAME {&FRAME-NAME} ANYWHERE 
  APPLY "U1":U TO THIS-PROCEDURE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN initGUI.
  
  RUN Setup(OUTPUT rc).
  IF NOT rc THEN DO:
    MESSAGE "Invalid parameters defined for " gObjectType + "."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.
  
  RUN BuildFileList.
 
  IF NOT gError THEN 
  DO:  
    RUN enable_UI.
    IF NOT gRemoteFile THEN VIEW FRAME {&FRAME-NAME}. 
    WAIT-FOR U1 OF THIS-PROCEDURE.
  END.  
END.
RUN destroyObject.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ApplyGo d_openso 
PROCEDURE ApplyGo :
DEFINE VARIABLE ok_choice AS LOGICAL NO-UNDO.
     
  /*
   * Make sure that the contents of the fill-in
   * are legal. This traps the problem if the
   * user types a bad filter and goes to OK
   * without hitting CR
   */
  
  IF gERROR AND GRemoteFile THEN 
  DO:
    Message 
      DYNAMIC-FUNCTION("getWSAERROrText")
      VIEW-AS ALERT-BOX.
    RETURN.
  END.
    
  IF NOT GBrowseOne THEN DO:
    RUN ChangeFilter(OUTPUT Ok_Choice).
    IF NOT ok_choice THEN RETURN ERROR.   
  END.
  
  /* See if there is a valid choice? */
   
  RUN Check_Filechosen (OUTPUT ok_choice). 
  
  IF NOT ok_choice THEN RETURN ERROR.
  
  IF NOT gRemoteFile THEN
  DO: 
    /* Make sure slashes are correct for the platform */
    IF LOOKUP(OPSYS , "MSDOS,WIN32":U) > 0 THEN
      p_fileChosen = REPLACE(p_fileChosen, UNIX-SLASH, DOS-SLASH).
    ELSE IF OPSYS = "UNIX":U THEN            
      p_fileChosen = REPLACE(p_fileChosen, DOS-SLASH, UNIX-SLASH).
  
  END.
   
  /* Lowercase the filename to make it easier to port code to Unix */
  p_fileChosen = LC(p_fileChosen).
  
  /* If a new SmartObject Master was created, then return the edvidence */
  IF gNewone THEN 
    ASSIGN p_fileChosen = "":U
           p_otherThing = "New Master":U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuildFileList d_openso 
PROCEDURE BuildFileList :
/* -----------------------------------------------------------
  Purpose:     Build the file listing in the selection list
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VARIABLE file_list AS CHARACTER NO-UNDO INITIAL "".
  DEFINE VARIABLE file_base AS CHARACTER NO-UNDO FORMAT "X(64)".
  DEFINE VARIABLE file_abs  AS CHARACTER NO-UNDO FORMAT "X(64)".
  DEFINE VARIABLE fileattr AS CHARACTER NO-UNDO FORMAT "X(10)".
  DEFINE VARIABLE pos       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE CurDir    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE CurFilter AS CHARACTER NO-UNDO.
  DEFINE VARIABLE t         AS CHARACTER NO-UNDO INITIAL "":U.
  DEFINE VARIABLE i         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE numFiles  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE Use_DLL   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE DirPrefix AS CHARACTER NO-UNDO.
  DEFINE VARIABLE DirBase   AS CHARACTER NO-UNDO.
  
  Run adecomm/_setcurs.p("WAIT":U).
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      cb_dirs
      cb_filters.
         
    IF gRemoteFile THEN 
    DO:
      /* ConnectServer is in the cihttp SUPER proc */ 
      RUN ConnectServer NO-ERROR.
      
      IF ERROR-STATUS:ERROR THEN ASSIGN gError = TRUE.
         
      /* This will trig an asynchron OCX event from the server  
         that will call the following procedure 
      -> OCX.HTTPServerConnection 
             calls GetData in SUPER which will trig another OCX event
             that will call the followin procedure 
      -> OCX.FileClosed */          
    
    END.
     
    ELSE 
    DO:  
      ASSIGN
        filename:SCREEN-VALUE  = "":U
        filename               = "":U
        s_files:LIST-ITEMS     = "":U
        pos = cb_dirs:LOOKUP(cb_dirs:SCREEN-VALUE)
        FILE-INFO:FILENAME     = ENTRY(pos,gTdirs)
        CurDir                 = LC(file-info:full-pathname).
        FiCurDir:SCREEN-VALUE  = file-info:full-pathname. 
 
     /* The DLL does not return any files if the directory passed is
      * the Root directory (e.g. "C:\"), so in that case, we'll use
      * the "slow" way.
      */  
      IF LOOKUP(OPSYS, "MSDOS,WIN32":u) > 0 THEN
      DO:
        RUN adecomm/_osprefx.p
            (INPUT CurDir, OUTPUT DirPrefix, OUTPUT DirBase).
        /* If the directory path is not the same as the directory prefix,
           then we do not have a root drive, so use the DLL. */
        ASSIGN Use_DLL = (CurDir <> DirPrefix).
      END.
    
      IF Use_DLL THEN 
      DO: /* use Windows .DLL instead of OS-DIR */
        RUN adecomm/_setcurs.p ("WAIT":U).
        ASSIGN
          SET-SIZE(list-mem)         = list-size
          CurFilter                  = "":U
          CurFilter                  = cb_filters:SCREEN-VALUE.

        RUN file_search (CurDir,CurFilter,INPUT-OUTPUT list-mem,list-size,
          OUTPUT missed-file, OUTPUT DirError).
      
        /* Error checking */
        IF DirError <> 0 THEN DO:
          RUN adecomm/_setcurs.p ("":U).
          SET-SIZE(list-mem) = 0.
          MESSAGE "Error in directory search." VIEW-AS ALERT-BOX ERROR.
          RETURN.
        END.
        IF missed-file > 0 THEN 
          MESSAGE "Too many files in your directory." skip
                  "The file list may not be inclusive."
           VIEW-AS ALERT-BOX INFORMATION. 
      
        ASSIGN 
          file_list          = LC(GET-STRING(list-mem,1))
          SET-SIZE(list-mem) = 0.
      END. /* WINDOWS .DLL version */
      ELSE DO: /* other O/S's use the slow 4GL method */  
        RUN adecomm/_setcurs.p ("WAIT":U).
        INPUT FROM OS-DIR (ENTRY(pos,gTdirs)) NO-ECHO.
        LOAD-File-List:
        REPEAT:
          IMPORT file_base file_abs fileattr.
          IF NUM-ENTRIES(file_base,"_":U) > 1 THEN DO:
            IF ENTRY(2, file_base, "_":U) = "cl.w":U THEN NEXT LOAD-File-List.
          END.
          IF file_base MATCHES REPLACE(cb_filters:SCREEN-VALUE,".","~~.") AND INDEX(fileattr,"D") = 0 THEN
             file_list = file_list + (IF file_list NE "" THEN "," ELSE "") + file_base.
        END.
        INPUT CLOSE.
        IF LOOKUP(OPSYS , "MSDOS,WIN32":u) > 0 THEN file_list = LC(file_list).
      END.    
      IF file_list NE "" THEN DO: 
        s_files:LIST-ITEMS   = file_list.
        IF gTitle MATCHES "*SmartDataObject*" OR 
           gTitle MATCHES "*SmartBusinessObject*" THEN 
        DO:
          numFiles = NUM-ENTRIES(file_list).
          /* Strip out the _cl.w files */
          DO i = numFiles TO 1 BY -1:
            IF S_files:ENTRY(i) MATCHES xMatchClient THEN
              S_files:DELETE(i).
          END.
        END.
        IF gTitle MATCHES "*SmartPanel*" THEN DO:
          numFiles = NUM-ENTRIES(file_list).
          /* Strip out panel.r and panel.w files */
          DO i = numFiles TO 1 BY -1:
            IF S_files:ENTRY(i) MATCHES "panel~.." THEN
              S_files:DELETE(i).
          END.
        END.
        s_files:SCREEN-VALUE = s_files:ENTRY(1).
      END.
      ELSE s_files:ADD-FIRST("<none>").
    END. /* else: NOT remote */
  END. /* do with frame */
  IF NOT gRemoteFile THEN
  DO:
     RUN Set_first.     
     RUN adecomm/_setcurs.p ("":U).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ChangeFilter d_openso 
PROCEDURE ChangeFilter :
/*------------------------------------------------------------------------------
  Purpose: Called on GO of the frame to see if we
           can get path or filename from filename field.     
  Parameters:  OUTPUT p_ok
  Notes:  P_ok returns FALSE to RETURN No-Apply from the GO.      
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER p_OK AS LOGICAL NO-UNDO INITIAL yes.
  
  DEFINE VARIABLE pos       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE newpath   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE newfilter AS CHARACTER NO-UNDO.
  DEFINE VARIABLE l         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE chdir     AS LOGICAL   NO-UNDO INITIAL NO.
  DEFINE VARIABLE chfilter  AS LOGICAL   NO-UNDO INITIAL NO.
  DEFINE VARIABLE chfile    AS LOGICAL   NO-UNDO INITIAL NO.
  DEFINE VARIABLE tfname    AS CHARACTER NO-UNDO.
     
  IF gRemoteFile THEN
  DO WITH FRAME {&FRAME-NAME}:
  
    ASSIGN 
      gFileSearch = FALSE
      tfName      = REPLACE(filename:SCREEN-VALUE, DOS-SLASH, UNIX-SLASH). 
   
    /* Find path if slash  */    
    IF INDEX(tfName, UNIX-SLASH) > 0 THEN 
       newpath = SUBSTR(tFname,1,R-INDEX(tfName, UNIX-SLASH) - 1).  
      
     /* Find the filter if there is a slash or not */   
    IF INDEX(tfName, "*":U) > 0 THEN
    DO:     
      newfilter = ENTRY(NUM-ENTRIES(tFname,UNIX-SLASH),tFname,UNIX-SLASH).           
      IF cb_filters:LOOKUP(newfilter) = 0 THEN 
          cb_filters:ADD-FIRST(newfilter).    
      ASSIGN 
        cb_filters:SCREEN-VALUE = newfilter
        chfilter                = TRUE
        cb_filters.           
    END.
    ELSE IF newpath <> "":U THEN gFileSearch = TRUE.
    
    /* If no wildcard and slash, check if entered name is a directory 
      (ALL directories have been read in even if they are not in the list */
    ELSE IF newpath = "":U THEN 
    DO:      
      FIND tRmtFile WHERE tRmtFile.Name     = tfName 
                    AND   tRmtFile.FileType = "D":U NO-ERROR.
                   
      IF AVAIL tRmtFile THEN 
        ASSIGN newpath = tfName.  
    END.
    IF newpath <> "" THEN
    DO:   
      IF cb_dirs:LOOKUP(newpath) = 0 THEN 
      DO:
         /* Variables used to reset combo if wrong path added. */ 
        ASSIGN 
          gPathAdded = TRUE
          gOldPath   = cb_dirs:SCREEN-VALUE.      
        cb_dirs:ADD-FIRST(newpath).
        
      END.
      ASSIGN 
        cb_dirs:SCREEN-VALUE = newpath
        chdir                = TRUE
        cb_dirs.              
    END.
    
    IF NOT (chdir OR chfilter) THEN
      gFileSearch = s_files:LOOKUP(filename:SCREEN-VALUE) = 0.
      
    ASSIGN p_ok = NOT (chdir OR chfilter OR gFileSearch). 
        
  END. /* If gremotefile */
  ELSE  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN tfname = (IF LOOKUP(OPSYS , "MSDOS,WIN32":U) > 0
                     THEN REPLACE(filename:SCREEN-VALUE, UNIX-SLASH, DOS-SLASH) 
                     ELSE REPLACE(filename:SCREEN-VALUE, DOS-SLASH, UNIX-SLASH)).
    
    IF INDEX(tfname, OS-SLASH) = 0 THEN /* add path from filter */
        FILE-INFO:FILE-NAME = cb_dirs:SCREEN-VALUE + OS-SLASH + tfname.
    ELSE
        FILE-INFO:FILE-NAME = tfname. /* assume that user is specifying dir and filename */
    
    IF FILE-INFO:FULL-PATHNAME <> ? THEN DO:
    
        IF INDEX(FILE-INFO:FILE-TYPE,"D") > 0 THEN DO: /* directory */
            ASSIGN p_OK = NO.
            IF LOOKUP(FILE-INFO:FULL-PATHNAME, gTdirs) > 0 THEN
              ASSIGN cb_dirs:SCREEN-VALUE = cb_dirs:ENTRY(LOOKUP(FILE-INFO:FULL-PATHNAME, gTdirs)). /* existing dir */
            ELSE DO: /* New dir */
              IF cb_dirs:LOOKUP(FILE-INFO:PATHNAME) = 0 THEN l = cb_dirs:ADD-FIRST(FILE-INFO:PATHNAME).
              ASSIGN cb_dirs:SCREEN-VALUE = FILE-INFO:PATHNAME
                     gDirs = cb_dirs:LIST-ITEMS
                     gTdirs = "".
              RUN Check_Dirs.  
            END.
            ASSIGN chdir = YES.
        END.        
        ELSE /* not a directory */
          ASSIGN
            p_fileChosen = FILE-INFO:PATHNAME
            chfile       = YES
           .           
    END.
    ELSE DO:
       
      /* Bad filename, but might be a new filter and/or dir */
      IF INDEX(tfname, OS-SLASH) > 0 OR INDEX(tfname, "*") > 0 THEN DO:  /* change dir and/or filter */
      
        ASSIGN p_OK = NO.
        IF INDEX(tfname, OS-SLASH) > 0 THEN DO:
          
          /* If there is no wildcard here, it's really a bad filename */
          IF INDEX(tfname, "*") = 0 THEN DO:
            MESSAGE "Invalid directory path or filename." VIEW-AS ALERT-BOX ERROR.
            RETURN.
          END.
         
          /* It's got a slash, extract new search dir */
          ASSIGN newpath = SUBSTRING(tfname, 1, R-INDEX(tfname,OS-SLASH) - 1, "CHARACTER":U).
                    
          FILE-INFO:FILE-NAME = newpath.
          
          IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
            MESSAGE "Invalid pathname: " newpath VIEW-AS ALERT-BOX ERROR.
            RETURN.
          END. 
          ELSE DO:
            IF LOOKUP(FILE-INFO:FULL-PATHNAME, gTdirs) > 0 THEN
              ASSIGN cb_dirs:SCREEN-VALUE = cb_dirs:ENTRY(LOOKUP(FILE-INFO:FULL-PATHNAME, gTdirs)). /* existing dir */
            ELSE DO:
              IF cb_dirs:LOOKUP(newpath) = 0 THEN l = cb_dirs:ADD-FIRST(newpath).
              ASSIGN cb_dirs:SCREEN-VALUE = newpath
                     gDirs = cb_dirs:LIST-ITEMS
                     gTdirs = "".
              RUN Check_Dirs.
            END.
            ASSIGN chdir = YES.
          END.          
        END.
        
        IF INDEX(tfname, "*") > 0 THEN DO: /* wildcard */
          
          IF INDEX(tfname,OS-SLASH) > 0 THEN /* contains a slash? */
            IF R-INDEX(tfname,OS-SLASH) < R-INDEX(tfname, "*") THEN DO:
              /* The slash comes before the wildcard - good */
              ASSIGN newfilter = SUBSTRING(tfname, R-INDEX(tfname,OS-SLASH) + 1,-1,"CHARACTER":U).
              IF cb_filters:LOOKUP(newfilter) = 0 THEN l = cb_filters:ADD-FIRST(newfilter).
              ASSIGN cb_filters:SCREEN-VALUE = newfilter.
            END.
            ELSE DO: /* The '*' should not come before the last slash! */
              MESSAGE "Invalid wildcard entry." VIEW-AS ALERT-BOX ERROR.
              chfilter = NO.
              p_OK = NO.
            END.
          ELSE DO: /* No slash */
            ASSIGN newfilter = filename:SCREEN-VALUE.
            IF cb_filters:LOOKUP(newfilter) = 0 THEN l = cb_filters:ADD-FIRST(newfilter).
            ASSIGN cb_filters:SCREEN-VALUE = newfilter
                   chfilter = YES.         
          END.
        END. 
      
      END. /* slash or '*' */
      ELSE DO: /* really a bad filename! */
        MESSAGE "File: " + filename:SCREEN-VALUE + " was not found." 
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        p_OK = NO.
      END.         
    END.    
  END. /* else : not gRemoteFile */ 
                           
  /* 
  If filter is changed 
  OR directory is changed 
  OR remote and filesearch (meaning there is no slash or wildcard in the filename
                            and that the filename is not in the list) 
  We must run BuildFilelist   
  */
                               
  IF chfilter OR chdir OR (gRemoteFile AND gFileSearch) THEN 
    RUN BuildFileList.  
  
  IF chfile  
  AND s_files:LOOKUP(filename:SCREEN-VALUE) > 0 THEN 
      s_files:SCREEN-VALUE = filename:SCREEN-VALUE.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Check_Dirs d_openso 
PROCEDURE Check_Dirs :
/* -----------------------------------------------------------
  Purpose:     Check to see if we can locate the dirs in the list
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VARIABLE i     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE dirs2 AS CHARACTER NO-UNDO.
  
  DO i = 1 TO NUM-ENTRIES(gDirs):
      ASSIGN FILE-INFO:FILE-NAME = ENTRY(i,gDirs).
      IF INDEX(FILE-INFO:FILE-TYPE,"D") > 0 THEN /* must be a directory */
          ASSIGN gTdirs  = gTdirs  + "," + FILE-INFO:FULL-PATHNAME
                 dirs2  = dirs2  + "," + ENTRY(i,gDirs).
      ELSE IF ENTRY(i,gDirs) NE "" AND 
              SUBSTRING(ENTRY(i,gDirs),LENGTH(ENTRY(i,gDirs)) - 1,2,"CHARACTER":U) 
              NE "PL" AND p_mode NE "{&WT-CONTROL}":U THEN
                /* Skip .pl's and null entries */
                MESSAGE "Directory: " + ENTRY(i,gDirs) + " is defined for this object" skip
                  "but does not currently exist on this system." skip(1)
                  "This directory name will be ignored."
                  VIEW-AS ALERT-BOX WARNING BUTTONS OK.
  END.
  ASSIGN gDirs  = SUBSTRING(dirs2,2,-1,"CHARACTER")
         gTdirs = SUBSTRING(gTdirs,2,-1,"CHARACTER").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Check_FileChosen d_openso 
PROCEDURE Check_FileChosen :
/*------------------------------------------------------------------------------
  Purpose: Check the value of the variable fileChosen and make sure it is valid.
           Reset filechose based on the value in the filling.    
  Parameters:  p_OK - FALSE if the file is not good
  Notes:       
------------------------------------------------------------------------------ */  
  DEFINE OUTPUT PARAMETER p_OK AS LOGICAL NO-UNDO INITIAL yes.
  DEFINE VARIABLE ocxStatus    AS INTEGER NO-UNDO.
  DEFINE VARIABLE dispMessage  AS LOGICAL NO-UNDO INITIAL no.
  
  DO WITH FRAME {&FRAME-NAME}: 
    
    IF NOT gNewone AND NOT gBrowseone THEN 
    DO:
      If p_mode = "{&WT-CONTROL}" then 
      do:
        Run processOCX(output ocxStatus).
        IF ocxStatus = 0 then
          Assign
            p_OK = no
            p_otherThing = ""
            dispMessage = yes
            .
        Else if ocxStatus = -1 then
          Assign
            p_OK = no
            p_otherThing = ""
            dispMessage = no
            . 
      end.
      else do: 
        Run processObj(output p_OK).
        If not p_OK then dispMessage = true.
      end.
 
      IF dispMessage then
        MESSAGE "Please select a file." VIEW-AS ALERT-BOX WARNING. 
    END.    
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject d_openso 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:    Kill _cihttp and this-procedure
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  RUN SUPER NO-ERROR.
  RUN disable_UI.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI d_openso  _DEFAULT-DISABLE
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
  HIDE FRAME d_openso.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI d_openso  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY filename cb_filters cb_dirs listlbl 
      WITH FRAME d_openso.
  ENABLE filename s_files cb_filters cb_dirs listlbl 
      WITH FRAME d_openso.
  {&OPEN-BROWSERS-IN-QUERY-d_openso}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initAdmGUI d_openso 
PROCEDURE initAdmGUI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
----------------------------------------------------------------------------*/
 DEF VAR RemoteStr AS CHAR NO-UNDO.
 
 DO WITH FRAME {&FRAME-NAME}:
  IF p_newTemplate = "" OR p_newTemplate = ? THEN
      b_New:HIDDEN = TRUE. /* turn it off */
 END.
 
 If p_mode = "WEB":U THEN
 DO: 
   RUN adeuib/_uibinfo.p (?,"SESSION":U,"remote", OUTPUT RemoteStr).
   ASSIGN gRemotefile = RemoteStr = "TRUE":U.
 
   IF gRemotefile THEN 
     RUN initHTTP. 
 END.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initGUI d_openso 
PROCEDURE initGUI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
 * Do the common things first ...
 */
 
 DO WITH FRAME {&FRAME-NAME}:
   ASSIGN 
     b_browse:hidden     = NOT CAN-DO(p_showoptions,"BROWSE":U)
     b_browse:sensitive  = NOT b_browse:hidden
     b_new:hidden        = NOT CAN-DO(p_showoptions,"NEW":U)
     b_new:sensitive     = NOT b_new:hidden
     b_preview:hidden    = NOT CAN-DO(p_showoptions,"PREVIEW":U)
     b_preview:sensitive = NOT b_preview:hidden
     .
   
   
   ASSIGN 
     gObjectType = IF p_mode = "WEB":U THEN "object" else p_mode.
            
   If p_mode = "{&WT-CONTROL}" then 
     RUN initOCXGUI.
   Else 
     RUN initAdmGUI.

 END.                          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initHTTP d_openso 
PROCEDURE initHTTP :
/*------------------------------------------------------------------------------
  Purpose:    Start the HTTP super procedure 
              set attributes and subscribe to events 
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR Hdl       AS HANDLE NO-UNDO.

  RUN adeuib/_uibinfo.p (?,"SESSION":U,"BrokerURL", OUTPUT gBrokerURL).
  
  RUN adeweb/_cihttp.p PERSISTENT SET Hdl.
  THIS-PROCEDURE:ADD-SUPER-PROCEDURE(Hdl).
  
  DYNAMIC-FUNCTION("setBROKERURL":U, gBrokerURL).      
  DYNAMIC-FUNCTION("setParseIncomingdata":U, true).
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initOCXGUI d_openso 
PROCEDURE initOCXGUI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OCX.FileClosed d_openso 
PROCEDURE OCX.FileClosed :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR ReadCnt  AS INTEGER    NO-UNDO.  
  DEF VAR FileCnt  AS INTEGER    NO-UNDO.    
  DEF VAR RmtFile  AS CHARACTER  NO-UNDO.  
  DEF VAR FileType AS CHARACTER  NO-UNDO.  
  DEF VAR lScrap   AS LOGICAL    NO-UNDO.  
  
  DEF VAR lError   AS LOGICAL NO-UNDO.  

  INPUT STREAM instream FROM VALUE(DYNAMIC-FUNCTION("getlocalfilename")) NO-ECHO.
  
  REPEAT WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      Rmtfile  = ""
      FileType = "".
    IMPORT STREAM instream RmtFile FileType.
    ReadCnt  = ReadCnt + 1.
  
    CASE ReadCnt:
      /* Check for line that begins <HTML> indicating an error reported by the
         web server. View the error in a web browser. */
      WHEN 1 THEN 
      DO:
        IF RmtFile BEGINS "<HTML>":U THEN DO:
          INPUT STREAM instream CLOSE.
          RUN adecomm/_s-alert.p (INPUT-OUTPUT lScrap, "error":U, "ok":U,
            "An error occured while reading the WebSpeed directory and will be displayed in your Web browser.").
          
          RUN adeweb/_abrunwb.p ("webutil/_weblist.w").
          ASSIGN lError = TRUE.
          LEAVE.
        END.
        ELSE NEXT.
      END.
      
      WHEN 2 THEN NEXT.

      /* Check for non-blank line indicating an error. */
      WHEN 3 THEN 
      DO:
        IF RmtFile <> "" THEN DO:
          MESSAGE "An error occured while reading the WebSpeed directory."
            VIEW-AS ALERT-BOX ERROR.
          ASSIGN lError = TRUE. 
          LEAVE.
        END.
        NEXT.
      END.
  
      /* Get current directory full path from 4th data line. */
      WHEN 4 THEN 
      DO: 
        IF RmtFile = ? THEN 
        DO:
          MESSAGE            
            gRmtFullPath + 
            OS-SLASH +
            /* If path was added show path and file as entered in filename */
            IF gPathAdded 
            THEN filename:SCREEN-VALUE 
            ELSE (cb_dirs:SCREEN-VALUE +
                  OS-SLASH 
                  +
                  gFilter) 
            "This path or file does not exist." SKIP
            "Make sure that the correct path is given."             
           VIEW-AS ALERT-BOX WARNING 
           TITLE FRAME {&FRAME-NAME}:TITLE.
          
          IF gPathAdded THEN 
          DO:           
            /* Remove the directory that was added when starting the filesearch */  
            cb_dirs:DELETE(cb_dirs:SCREEN-VALUE).
            ASSIGN
              cb_dirs:SCREEN-VALUE = gOldPath
              cb_dirs. 
          END.

          /*
          This is the case were the invalid directory already 
          was in the box.
          Because the path remains visible in the combo-box 
          we clear data belonging to previous path.*/ 
          ELSE
          DO:
            s_files:LIST-ITEMS = "":U.
            IF NOT gFileSearch THEN
              filename:SCREEN-VALUE = "":U.                   
          END.     
          ASSIGN lError = TRUE.
          LEAVE.          
        END.
       
        ASSIGN 
          OS-SLASH     = IF INDEX(RmtFile,DOS-SLASH) > 0 
                         THEN DOS-SLASH
                         ELSE UNIX-SLASH 
          gRmtFullPath = DYNAMIC-FUNCTION("GetHostName") 
                         + ":":U 
                         + RmtFile
        
          fiCurDir:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
               DYNAMIC-FUNCTION("getHostName") + ":":U + RmtFile.
        
        NEXT. 
      END.
      WHEN 5 THEN
      DO:
       
        /***
        Keep data in case of error 
        Don't blank current data until we are certain that the 
        first 4 lines are ok  */
        
        FOR EACH tRmtFile:
          DELETE tRmtFile. 
        END.  
        
        /* 
        We can empty the list at this stage because we know that 
        something will be displayed.
        But if gFilesearch we don't know if we found the file until 
        all files are read (Because all directories are returned)            
        */ 
        
        IF NOT gFileSearch THEN
          ASSIGN 
            s_files:LIST-ITEMS = "".
          
      END.         
    END CASE.
    
    IF ReadCnt < 5 OR RmtFile = "" THEN NEXT.
         
    CREATE tRmtFile.
    ASSIGN 
      tRmtFile.Name     = RmtFile
      tRmtFile.FileType = FileType.
     
    /*** 
    ALL directories are returned from server, 
    but should only be added to the selection list if they  
    match filter criteria and gFilesearch is false */ 
  
    IF fileType eq "F":U 
    OR (NOT gFileSearch AND RmtFile MATCHES cb_Filters:SCREEN-VALUE) THEN
    DO:
      /* only ONE if gfilesearch */
      IF gFileSearch THEN 
        s_files:LIST-ITEMS = RmtFile.
      ELSE
      IF NOT (gTitle MATCHES "*SmartDataObject*" 
              AND RmtFile MATCHES xMatchClient) THEN
        s_files:ADD-LAST(RmtFile).
      
      tRmtFile.Num   = s_files:LOOKUP(RmtFile).                  
    END.
  END.
  
  IF NOT lERROR THEN
  DO WITH FRAME {&FRAME-NAME}:    
   
    IF gFileSearch THEN
    DO: 
      IF s_files:LIST-ITEMS = gFilter THEN
      DO:
        ASSIGN filename:SCREEN-VALUE = gFilter.  
        APPLY "U1" TO THIS-PROCEDURE.
      END.
      ELSE
        MESSAGE "File: " + filename:SCREEN-VALUE + " was not found." 
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.     
    END. 
    ELSE IF s_files:NUM-ITEMS = 0 THEN 
       s_files:LIST-ITEMS = "<none>". 
    ELSE 
      RUN Set_First.          
     
  END.

  /* Blank data set in changefilter for filesearch */
  ASSIGN
    gFileSearch = FALSE
    gFilter     = "":U
    gPathAdded  = FALSE
    gOldPath    = "":U.
    
  INPUT STREAM instream CLOSE.
  
  VIEW FRAME {&FRAME-NAME}.
    
  OS-DELETE VALUE(DYNAMIC-FUNCTION("getlocalfilename")).

  RUN adecomm/_setcurs.p ("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OCX.HTTPServerConnection d_openso 
PROCEDURE OCX.HTTPServerConnection :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
  Run adecomm/_setcurs.p("WAIT":U).
  
  DO WITH FRAME {&FRAME-NAME}:
    /* 
    If both path and filename is entered as a filesearch, 
    we must use only the filename as filter */
     
    IF gFileSearch THEN 
      ASSIGN 
        gFilter = REPLACE(filename:SCREEN-VALUE,DOS-SLASH,UNIX-SLASH)
        gFilter = IF NUM-ENTRIES(gFilter,UNIX-SLASH) > 1 
                  THEN ENTRY(NUM-ENTRIES(gFilter,UNIX-SLASH),gFilter,UNIX-SLASH)
                  ELSe gFilter.    
    ELSE 
      ASSIGN
        gFilter =  cb_filters:SCREEN-VALUE.      
    
    RUN GetData
          ("webutil/_weblist.w":U,
           "directory=":U 
            + cb_dirs:SCREEN-VALUE
            + "&filter=":U 
            + gFilter).
             
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OCX.WSAError d_openso 
PROCEDURE OCX.WSAError :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pError AS INTEGER.
  
  ASSIGN gError = TRUE.
 
  APPLY "U1" TO THIS-PROCEDURE.  
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processObj d_openso 
PROCEDURE processObj :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes: Called from check_filechosen.      
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER p_OK AS LOGICAL NO-UNDO INITIAL yes.
  
  DEFINE VARIABLE tempFile  AS CHARACTER NO-UNDO. 

  DO WITH FRAME {&FRAME-NAME}:
    /* 
    Don't use ./ on web because the value is displayed in fill-ins
    We should always use UNIX-SLASH to get portable code */                              

    IF p_mode = "WEB":U THEN  
           ASSIGN p_fileChosen =
                (IF cb_dirs:SCREEN-VALUE = ".":U THEN "":U
                 ELSE cb_dirs:SCREEN-VALUE 
                      + UNIX-SLASH )
                      
                 + filename:SCREEN-VALUE. 
   ELSE 
      ASSIGN p_fileChosen = 
                 cb_dirs:SCREEN-VALUE 
                 + OS-SLASH 
                 + filename:SCREEN-VALUE.

  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processOCX d_openso 
PROCEDURE processOCX :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER OCXStatus AS INTEGER NO-UNDO INITIAL 1.

DEFINE VARIABLE pos      AS INTEGER   NO-UNDO.
define variable s        as integer   no-undo.
define variable cList    as character no-undo.
define variable fullName as character no-undo.
define variable ldummy   as logical   no-undo.


do with frame {&FRAME-NAME}:

    /*
     * If there is already a p_fileChosen and p_otherThing that
     * means that the user has come through here before (probably
     * did a ppreview). Return with the same values. This is
     * needed if there is a OCX dll with multiple OCXs. If
     * we go through the code again the user will be forced to
     * pick the dialog box again.
     */

    if p_fileChosen <> "" and p_otherThing <> "" then return.
    
    assign
        fullName = cb_dirs:SCREEN-VALUE + OS-SLASH + s_files:SCREEN-VALUE
        p_fileChosen = s_files:SCREEN-VALUE 
      .
    /*
     * The user supplied a OCX DLL. Go get the control..
     */
    
    /* Call to GetControlsOfLib moved to _getctrl.p */    
    RUN adeuib/_getctrl.p (INPUT fullName, OUTPUT cList, OUTPUT s).
    
    if s <> 0 then do:
       assign
           p_fileChosen = ""
           OCXStatus = -1
       .

        return.
    end.
    /*
     * IF there are more than 1 control in the OCX then present the
     * user with a choice.
     */
   
    if num-entries(cList, chr(10)) = 0 then do:
    
       /*
        * There is a problem. 
        */
        
       message "A problem was detected trying to access the" skip
               fullname " control." skip

               view-as alert-box.
       assign
           p_fileChosen = ""
           OCXStatus = -1
       .
       return.
    end.

    if num-entries(cList, chr(10)) > 1 then do:

        Run adecomm/_setcurs.p("WAIT").
        Run adeuib/_mulcont.w("Choose control from " + p_fileChosen,
                                          replace(cList,chr(10), ","),
                              entry(1, cList, chr(10)),
                              output p_otherThing,
                              output lDummy).
                              
        if lDummy = true then do:
           assign
               p_fileChosen = ""
               OCXStatus = -1.
           .
           return.
        end.
    end.
    else do:

        p_otherThing = entry(1, cList, CHR(10)).
    end.        
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Setup d_openso 
PROCEDURE Setup :
/* -----------------------------------------------------------
  Purpose:     Setup dialog
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER rc AS LOGICAL INITIAL yes.
DEFINE VARIABLE         i  AS INTEGER NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  IF p_cst-attr <> "" THEN DO:
    DO i = 1 TO NUM-ENTRIES(p_cst-attr,CHR(10)):
        IF ENTRY(i,p_cst-attr,CHR(10)) BEGINS "DIRECTORY-LIST" THEN
            gDirs = TRIM(SUBSTRING(TRIM(ENTRY(i,p_cst-attr,CHR(10))),15,-1,"CHARACTER")).
        ELSE IF ENTRY(i,p_cst-attr,CHR(10)) BEGINS "FILTER" THEN
            gFilters = TRIM(SUBSTRING(TRIM(ENTRY(i,p_cst-attr,CHR(10))),7,-1,"CHARACTER")).
        ELSE IF ENTRY(i,p_cst-attr,CHR(10)) BEGINS "TITLE" THEN
            gTitle = TRIM(SUBSTRING(TRIM(ENTRY(i,p_cst-attr,CHR(10))),6,-1,"CHARACTER")).
    END.
    IF gDirs = "" OR gFilters = "" THEN DO:
        rc = no.
        RETURN.
    END.
    IF gTitle = "" THEN DO:
      IF p_mode = "{&WT-CONTROL}" THEN gTitle = "Choose {&WL-CONTROL}".
                                ELSE gTitle = "Choose Object".
    END.
    
    /* 
    Don't do this for remote. We could perhaps check directories 
    after running BuildFielList, but it would cost too much if multi leveldirectories
    are used, so we leave the error messages until someone tries to use them. 
    That's also more in line with good UI standards */
            
    IF NOT gRemoteFile THEN  
      RUN Check_Dirs.
    
    ASSIGN cb_filters:LIST-ITEMS     = gFilters
           cb_dirs:LIST-ITEMS        = gDirs
           FRAME {&FRAME-NAME}:TITLE = gTitle
           cb_filters:SCREEN-VALUE   = cb_filters:ENTRY(1)
           cb_dirs:SCREEN-VALUE      = cb_dirs:ENTRY(1)
           cb_dirs                   = cb_dirs:SCREEN-VALUE
           cb_filters                = cb_filters:SCREEN-VALUE
           filename                  = ""
           p_otherThing              = ""
        .
   
    IF p_mode = "{&WT-CONTROL}" THEN listlbl = "{&WL-CONTROL}" + ":".
  END.
  ELSE rc = no.
END.         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Set_First d_openso 
PROCEDURE Set_First :
/* -----------------------------------------------------------
  Purpose:     Selects the first file in the list.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  IF s_files:NUM-ITEMS > 0 AND s_files:ENTRY(1) NE "<None>" THEN
      ASSIGN s_files:SCREEN-VALUE = s_files:ENTRY(1).
  APPLY "VALUE-CHANGED" TO s_files IN FRAME {&FRAME-NAME}.
  APPLY "ENTRY" TO s_files IN FRAME {&FRAME-NAME}.

END.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Set_Sensitivity d_openso 
PROCEDURE Set_Sensitivity :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Sensitivity of various items in the dialog-box based
               on the current situation. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    /* We cannot preview if there are no files selected. */
    b_Preview:SENSITIVE = (filename:SCREEN-VALUE ne "").
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

