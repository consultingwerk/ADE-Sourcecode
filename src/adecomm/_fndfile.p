&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f_findfile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f_findfile 
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
/*
** Program:        _fndfile.p
** Author:         Robert Ryan
**                 (Wm.T.Wood - converted this to UIB compatible file)
**
** Date:           3/10/94
** Purpose:        Supercedes SYSTEM-FILE common dialog file opens in the UIB;
**                 displays files/images simultaneously like MS Word's Find File
**
** Inputs:         pTitle
**                   Title of the dialog box. "Choose " is prepended automatically,
**                   so only pass type of file to choose. Eg, pTitle = "Image File".
**                   If pTitle already begins with "Choose ", pTitle is not changed.
**
**                 pMode
**                   TEMPLATE    Preview file as an image, then text, then
**                               full qualified image file name
**                   TEXT        Preview file as text only
**                   IMAGE       Preview file as fully-qualified image only
**
**                 pFilter
**                    Filetypes that the user can select.  The list is in 
**                    list-items-pairs format to display in the combo-box.
**                    The 1st file type is user as the initial filter.  
**                    Pipe character "|" is used as a delimeter character 
**                    (and not commas).  Commas are used to separate filetypes 
**                    as in:
**
**                        Bitmaps (*.ico, *.dib)|*.ico,*.dib|
**
** Input/Ouptut:   pFileName
**                    If available at input, that file's filetype/directory are
**                    used as the initial filter and the file is subsequently
**                    previewed.  If blank, the first pFilter is used.
**                    As an output parm, the relative path/file is provided.
**                    Backslashes are changed to forward slashes for
**                    UNIX compatibility.
**
**                 pDirList
**                    At input, the initial list of directories to search.
**                    If the user added/subtracted directories, then, at output,
**                    this list will reflects those modfications.  The list
**                    is of the form:
**                        c:\second,c:\first,src\template,.,c:\second
**                    The first item in the list will be the intial selection.
**                    It can appear in the list twice.  If so, the list will be
**                    entries 2 to n.  Therefore:
**                      "a,b,c,d"   -- List is "a,b,c,d". Initial value is "a".
**                      "c,a,b,c,d" -- list is "a,b,c,d". Initial value is "c".
**
** Output:         pAbsoluteFileName
**                    The absolute, or fully qualified path/file name.
**                    Backslashes are changed to forward slashes for
**                    UNIX compatibility.
**
**                 pOk
**                    True if Ok was pressed, False if Cancel was pressed
**
** Modified: 05/27/99  TSM  Change FileType combo to use list-item-pairs 
**                          rather than list items to support new image formats
**           06/24/99  TSM  Removed code that was stripping off ext of images to
**                          support new image formats
*/

/*
** Parameter Definitions
*/
&GLOBAL-DEFINE WIN95-BTN YES
&IF DEFINED(UIB_is_running) = 0 AND DEFINED(INCLUDED) = 0 &THEN
DEFINE INPUT        PARAMETER pTitle            AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pMode             AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pFilter           AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pDirList          AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pFileName         AS CHARACTER NO-UNDO.
DEFINE OUTPUT       PARAMETER pAbsoluteFileName AS CHARACTER NO-UNDO.
DEFINE OUTPUT       PARAMETER pOk               AS LOGICAL   NO-UNDO.
&ELSE
DEFINE VARIABLE pTitle            AS CHARACTER NO-UNDO INITIAL "Open File".
DEFINE VARIABLE pMode             AS CHARACTER NO-UNDO INITIAL "TEMPLATE".
DEFINE VARIABLE pFilter           AS CHARACTER NO-UNDO INITIAL "*.w".
DEFINE VARIABLE pDirList          AS CHARACTER NO-UNDO INITIAL "src/template,.".
DEFINE VARIABLE pFileName         AS CHARACTER NO-UNDO.
DEFINE VARIABLE pAbsoluteFileName AS CHARACTER NO-UNDO.
DEFINE VARIABLE pOk               AS LOGICAL   NO-UNDO.

/* Other UIB setup */
SESSION:THREE-D = yes.
&ENDIF

/*
** Local Variable Definitions
*/
DEFINE VARIABLE i                 AS INTEGER   NO-UNDO.
DEFINE VARIABLE ItemCnt           AS INTEGER   NO-UNDO.
DEFINE VARIABLE Result            AS LOGICAL   NO-UNDO.
DEFINE VARIABLE FileStatus        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Matched           AS LOGICAL   NO-UNDO.
DEFINE VARIABLE TempDir           AS CHARACTER NO-UNDO.
DEFINE VARIABLE DirName           AS CHARACTER NO-UNDO.
DEFINE VARIABLE FileName          AS CHARACTER NO-UNDO.
DEFINE VARIABLE FullFileName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE CurFilter         AS CHARACTER NO-UNDO.
DEFINE VARIABLE NewFilter         AS CHARACTER NO-UNDO.
DEFINE VARIABLE FileStream        AS CHARACTER NO-UNDO.
DEFINE VARIABLE ListOfFiles       AS CHARACTER NO-UNDO.
DEFINE VARIABLE pCurrentPath      AS CHARACTER NO-UNDO.
DEFINE VARIABLE PrefPreviewType   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE TestValue         AS CHARACTER NO-UNDO.
DEFINE VARIABLE ExtensionFlag     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE ByteSize          AS DECIMAL   NO-UNDO.
DEFINE VARIABLE FileContents      AS CHARACTER NO-UNDO.
DEFINE VARIABLE LeaveFlag         AS LOGICAL   NO-UNDO.

/*
** Patrick Tullmann's Dir DLL
*/
{adecomm/dirsrch.i}
DEFINE VARIABLE list-mem    AS MEMPTR.
DEFINE VARIABLE list-char   AS CHARACTER.
DEFINE VARIABLE list-size   AS INTEGER INITIAL 8000.
DEFINE VARIABLE missed-file AS INTEGER.
DEFINE VARIABLE DirError    AS INTEGER.

/*
** Pre-processor Definitions
*/
&SCOPED-DEFINE WINDOW-NAME {&FRAME-NAME}
&SCOPED-DEFINE FRAME-NAME  {&FRAME-NAME}

&IF LOOKUP(OPSYS, "MSDOS,WIN32":u) = 0 &THEN
&SCOPED-DEFINE DIR-SLASH   /
&ELSE
&SCOPED-DEFINE DIR-SLASH   ~~~\
&SCOPED-DEFINE OS-HT       1.0
&SCOPED-DEFINE SEL-HT      6.15
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f_findfile

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS TextDisplay FileNameField FileList FileType ~
PreviewType PreviewFile DirList EditPathButton BrowseButton ~
FullFileNameField FileNameLabel Container ImageDisplay 
&Scoped-Define DISPLAYED-OBJECTS TextDisplay FileNameField FileList ~
FileType PreviewType PreviewFile DirList FullFileNameField FileNameLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BrowseButton 
     LABEL "&Browse...":C13 
     SIZE 15 BY 1.14.

DEFINE BUTTON EditPathButton 
     LABEL "&Edit Path...":C13 
     SIZE 15 BY 1.14.

DEFINE VARIABLE DirList AS CHARACTER FORMAT "x(80)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 35 BY 1.

DEFINE VARIABLE FileType AS CHARACTER FORMAT "x(80)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 35 BY 1.

DEFINE VARIABLE TextDisplay AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 47.8 BY 9.86
     FONT 2 NO-UNDO.

DEFINE VARIABLE FileNameField AS CHARACTER FORMAT "x(80)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE FileNameLabel AS CHARACTER FORMAT "x(8)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE FullFileNameField AS CHARACTER FORMAT "x(80)":U 
      VIEW-AS TEXT 
     SIZE 46.6 BY 1 NO-UNDO.

DEFINE IMAGE ImageDisplay
     SIZE 47 BY 9.67.

DEFINE VARIABLE PreviewType AS LOGICAL 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "&Code", no,
"&Image", yes
     SIZE 19.6 BY 1 NO-UNDO.

DEFINE RECTANGLE Container
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 47.8 BY 9.86.

DEFINE VARIABLE FileList AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SORT SCROLLBAR-VERTICAL 
     SIZE 35 BY 6.86.

DEFINE VARIABLE PreviewFile AS LOGICAL INITIAL no 
     LABEL "&Preview" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f_findfile
     TextDisplay AT ROW 2.19 COL 39 NO-LABEL
     FileNameField AT ROW 2.24 COL 2 NO-LABEL
     FileList AT ROW 3.52 COL 2 NO-LABEL
     FileType AT ROW 11.33 COL 2 NO-LABEL
     PreviewType AT ROW 12.29 COL 52.6 NO-LABEL
     PreviewFile AT ROW 12.33 COL 39
     DirList AT ROW 13.38 COL 2 NO-LABEL
     EditPathButton AT ROW 13.38 COL 38.2
     BrowseButton AT ROW 13.38 COL 55.2
     FullFileNameField AT ROW 1 COL 37.8 COLON-ALIGNED NO-LABEL
     FileNameLabel AT ROW 1.33 COL 2 NO-LABEL
     Container AT ROW 2.14 COL 39
     ImageDisplay AT ROW 2.33 COL 39.6
     "File &Type:" VIEW-AS TEXT
          SIZE 9.2 BY .67 AT ROW 10.52 COL 2.4
     "&Directory:" VIEW-AS TEXT
          SIZE 9 BY .67 AT ROW 12.62 COL 2.4
     SPACE(75.59) SKIP(1.23)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "":C.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX f_findfile
                                                                        */
ASSIGN 
       FRAME f_findfile:SCROLLABLE       = FALSE
       FRAME f_findfile:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX DirList IN FRAME f_findfile
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FileNameField IN FRAME f_findfile
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FileNameLabel IN FRAME f_findfile
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX FileType IN FRAME f_findfile
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME f_findfile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f_findfile f_findfile
ON GO OF FRAME f_findfile
DO:
  DEFINE VARIABLE fext AS CHARACTER NO-UNDO.
  DEFINE VARIABLE xDirName AS CHARACTER NO-UNDO.
  /*
  ** LeaveFlag is set when a user has a wildcard in the FileNameField. This
  ** allows the <CR> to be trapped and to not act as the default OK button.
  */
  IF LeaveFlag THEN RETURN NO-APPLY.

  /*
  ** Upon exit, make these assigns to pass to the calling procedure.
  */
  ASSIGN xDirName = RIGHT-TRIM(DirList:SCREEN-VALUE, "~\").
  
  /* WIN95-UNC - Windows 95 UNC Pathnames support. - jep 12/18/95 */
  /* Get the filename and add in the directory. */
  ASSIGN pFileName = IF FileNameField:SCREEN-VALUE = "(None)" OR
                        FileNameField:SCREEN-VALUE = ?
                     THEN "" ELSE FileNameField:SCREEN-VALUE.
  IF (pFileName <> "") THEN
    RUN adecomm/_osfmush.p
      (INPUT xDirName, INPUT pFileName, OUTPUT pFileName).
  ASSIGN
    pDirList              = DirList:LIST-ITEMS
    pOK                   = TRUE
    FILE-INFO:FILENAME    = pFileName
    pAbsoluteFileName     = FILE-INFO:FULL-PATHNAME.

  /* If the current directory is not the first item, then add it onto the
     front. */
  ASSIGN DirList.
  IF LOOKUP(DirList, pDirList) > 1 THEN
    ASSIGN pDirList = DirList + ",":U + pDirList.

  RUN Make_Rel (INPUT-OUTPUT pFileName). /* make filename relative to PROPATH */
    
  /* Make sure the file name is valid. */
  IF SEARCH(pAbsoluteFileName) EQ ? AND pfilename NE "" THEN DO:
    MESSAGE pFileName SKIP
      "The file does not exist or cannot be located." VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
  END.
  
  /* Change backslash to forward slash for UNIX compatibility. */
  ASSIGN pFileName          = REPLACE(pFileName, "~\":U, "/":U)
         pAbsoluteFileName  = REPLACE(pAbsoluteFileName, "~\":U, "/":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f_findfile f_findfile
ON WINDOW-CLOSE OF FRAME f_findfile
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BrowseButton
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrowseButton f_findfile
ON CHOOSE OF BrowseButton IN FRAME f_findfile /* Browse... */
DO:
  DEFINE VARIABLE ProcName               AS CHARACTER NO-UNDO.
  DEFINE VARIABLE OKpressed              AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE InitFilter             AS INTEGER   NO-UNDO.
  DEFINE VARIABLE FilterNameString       AS CHARACTER NO-UNDO EXTENT 11.
  DEFINE VARIABLE StartingDir            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE WildCardFlag           AS LOGICAL   NO-UNDO.

  ASSIGN
    FILE-INFO:FILENAME = DirList:SCREEN-VALUE
    StartingDir        = FILE-INFO:FULL-PATHNAME
    ItemCnt            = FileType:NUM-ITEMS.

  /* Copy the file filters in the FileType combo-box to an array.
     Also record the initial file-filter. */
  InitFilter = 1.
  DO i = 1 TO ItemCnt:
    IF i > 10 THEN DO:
      MESSAGE "Only first ten file types will be used as filters." 
        VIEW-AS ALERT-BOX INFORMATION.
      LEAVE.
    END.

    FilterNameString[i] = FileType:ENTRY(i).
    IF FilterNameString[i] eq Filetype:SCREEN-VALUE THEN InitFilter = i.
    IF FilterNameString[i] eq "*.*":U               THEN WildCardFlag = TRUE.
  END.

  /*
  ** Add the wildcard filter ("*.*") to the list, if it is not there.
  */
  IF NOT WildCardFlag THEN DO:
    FilterNameString[10] = "*.*".
    IF FilterNameString[10] eq Filetype:SCREEN-VALUE THEN InitFilter = 10.
  END.
  
  REPEAT:
    SYSTEM-DIALOG GET-FILE ProcName
      TITLE           "Browse Files"
      FILTERS         FilterNameString[1] FilterNameString[1],
      FilterNameString[2] FilterNameString[2],
      FilterNameString[3] FilterNameString[3],
      FilterNameString[4] FilterNameString[4],
      FilterNameString[5] FilterNameString[5],
      FilterNameString[6] FilterNameString[6],
      FilterNameString[7] FilterNameString[7],
      FilterNameString[8] FilterNameString[8],
      FilterNameString[9] FilterNameString[9],
      FilterNameString[10] FilterNameString[10],
      FilterNameString[11] FilterNameString[11]
      INITIAL-FILTER  InitFilter
      INITIAL-DIR     StartingDir
      RETURN-TO-START-DIR
      MUST-EXIST
      USE-FILENAME
      UPDATE OkPressed.

    IF OkPressed THEN DO:
      ASSIGN 
        FullFileName = ProcName
        pFileName    = ProcName.
      RUN AddFileFilter.
      RUN InitpFileName (TRUE).
      IF RETURN-VALUE EQ "False" THEN
        APPLY "VALUE-CHANGED" TO DirList IN FRAME {&FRAME-NAME}.
    END. /* end OkPressed */
    LEAVE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DirList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DirList f_findfile
ON VALUE-CHANGED OF DirList IN FRAME f_findfile
DO:
  RUN PopulateFileList.
  IF RETURN-VALUE = "True" THEN
    APPLY "VALUE-CHANGED" TO FileList IN FRAME {&FRAME-NAME}.
  ELSE
    RUN adecomm/_setcurs.p ("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME EditPathButton
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EditPathButton f_findfile
ON CHOOSE OF EditPathButton IN FRAME f_findfile /* Edit Path... */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    DEFINE VARIABLE pNewList AS CHARACTER NO-UNDO.
    DEFINE VARIABLE OrigPath AS CHARACTER NO-UNDO.

    ASSIGN
      pCurrentPath = TRIM(DirList:SCREEN-VALUE)
      OrigPath     = pCurrentPath
      .

    RUN adecomm/_modpath.w (DirList:LIST-ITEMS, SESSION:THREE-D, 
                            INPUT-OUTPUT pCurrentPath, OUTPUT pNewList).
      
    /* NewList will be blank if the user cancelled. */
    IF pNewList ne "" THEN DO:
      ASSIGN
        DirList:LIST-ITEMS   = ""
        DirList:LIST-ITEMS   = pNewList
        DirList:SCREEN-VALUE = TRIM(pCurrentPath).
        
      /* Was the current item changed? */
      IF pCurrentPath ne OrigPath
      THEN APPLY "VALUE-CHANGED" TO DirList IN FRAME {&FRAME-NAME}.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FileList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FileList f_findfile
ON DEFAULT-ACTION OF FileList IN FRAME f_findfile
DO:
  /* Accept the current value. */
  APPLY "go":U TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FileList f_findfile
ON VALUE-CHANGED OF FileList IN FRAME f_findfile
DO:
  ASSIGN
    FileNameField:SCREEN-VALUE     = self:SCREEN-VALUE
    FileNameField                  = FileNameField:SCREEN-VALUE.

  RUN FullFileName.
  FullFileNameField:SCREEN-VALUE = FullFileName.
  RUN FileLoad.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FileNameField
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FileNameField f_findfile
ON LEAVE OF FileNameField IN FRAME f_findfile
DO:
  DEF VAR fname AS CHARACTER NO-UNDO.   
  DEF VAR h AS HANDLE.

  /* hdl to widget we are entering, if any */
  ASSIGN h = LAST-EVENT:WIDGET-ENTER. 
  /* If we are entering the FileList, set this fill-in to
   * to newly selected name
   */
  IF VALID-HANDLE(h) AND h:NAME = "FileList" AND
  FileList:SCREEN-VALUE NE ? THEN
    FileNameField:SCREEN-VALUE = FileList:SCREEN-VALUE.
  
  ASSIGN
    ExtensionFlag = TRUE
    FileNameField = IF FileNameField:SCREEN-VALUE = "" THEN "(None)" ELSE
                      LEFT-TRIM(FileNameField:SCREEN-VALUE)
    TestValue     = FileNameField 
    LeaveFlag     = INDEX(FileNameField,"*":U) > 0.

  /*
  ** Step 1: See if this file matches something in the file list.  If it does,
  **         you're all set and you can get out of here.
  */
  RUN MatchFileName (ExtensionFlag).

  /*
  ** Step 2: add a file type if needed
  */
  IF Matched THEN APPLY "VALUE-CHANGED" TO FileList.
  ELSE DO:
    /* 
    ** Is this a valid file at all.
    */
    IF NOT LeaveFlag AND TestValue ne "" THEN DO:
      IF SEARCH(DirList:SCREEN-VALUE + "{&DIR-SLASH}" + TestValue) eq ?
      THEN DO:
        /* It's not in the list, but maybe it's a fully qualified name */
        FILE-INFO:FILE-NAME = TestValue.
        IF FILE-INFO:FULL-PATHNAME EQ ? THEN DO:
            IF VALID-HANDLE(h) AND (h:NAME NE "btn_OK" OR h:NAME NE "btn_Help") THEN LEAVE.
            MESSAGE TestValue SKIP 
                "Cannot find this file." SKIP(1)
                "Please verify that the correct path and filename are given."
                VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
        END.
        /* If it's a directory, add a filter */
        IF INDEX(FILE-INFO:FILE-TYPE,"D") > 0 THEN DO:
          ASSIGN FileNameField = FileNameField + "{&DIR-SLASH}" + ENTRY(1,FileType:SCREEN-VALUE)
                 LeaveFlag = yes.
        END.
        ELSE LeaveFlag = no.
      END.    
    END.
    /*
    ** This is a new file spec
    */
    FullFileName = FileNameField.
    RUN AddFileFilter.

    IF DirName = "" THEN
      DirName = DirList:SCREEN-VALUE.

    RUN AddDirName.
    /* If the user entered a good filename, then use it and leave
     * the dialog
     */
    IF R-INDEX(FileNameField,"{&DIR-SLASH}") > 0                                   AND
       LENGTH(FileNameField,"CHARACTER":U) > R-INDEX(FileNameField,"{&DIR-SLASH}") AND
       INDEX(FILE-INFO:FILE-TYPE,"D") = 0                                          THEN 
    DO:
      ASSIGN fname = SUBSTRING(FileNameField,R-INDEX(FileNameField,"{&DIR-SLASH}") + 1, -1, "CHARACTER":U).
      ASSIGN leaveflag = no
             FileNameField:SCREEN-VALUE = fname
             FileNameField = fname.
      APPLY "GO" TO FRAME f_findfile.
    END.
    ELSE APPLY "VALUE-CHANGED" TO FileType.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FileType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FileType f_findfile
ON VALUE-CHANGED OF FileType IN FRAME f_findfile
DO:
  RUN PopulateFileList.
  IF RETURN-VALUE = "True" THEN
    APPLY "VALUE-CHANGED" TO FileList IN FRAME {&FRAME-NAME}.
  ELSE
    RUN adecomm/_setcurs.p ("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PreviewFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PreviewFile f_findfile
ON VALUE-CHANGED OF PreviewFile IN FRAME f_findfile /* Preview */
DO:
  ASSIGN
    PreviewFile              = SELF:CHECKED
    PreviewType              = PrefPreviewType
    PreviewType:SCREEN-VALUE = STRING(PreviewType)
    PreviewType:SENSITIVE    = (PreviewFile AND pMode = "TEMPLATE")
    TextDisplay:SCREEN-VALUE = IF SELF:CHECKED THEN TextDisplay:SCREEN-VALUE
                               ELSE "".

  /* Preview the current file, if appropriate. */
  IF PreviewFile THEN
    RUN FileLoad.
  ELSE
    RUN ClearContents.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PreviewType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PreviewType f_findfile
ON VALUE-CHANGED OF PreviewType IN FRAME f_findfile
DO:
  ASSIGN PreviewType.
  /* The user explicitly changed the preview type. Save this preference.
  (Note that the radio-set can change implicitly if, for example, an image
  file does not exist.  We don't want to save the implicit changes.) */
  PrefPreviewType = PreviewType.

  RUN FileLoad.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f_findfile 


/* ******************* Sullivan Standards & Run-time Setup ******************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Help File */
{ adecomm/commeng.i }

/* Sullivan bar standards */
DEF VAR hlp_context AS INTEGER NO-UNDO.
hlp_context = IF pMode eq "TEMPLATE" THEN {&Find_Template_Dlg_Box}
              ELSE IF pMode eq "IMAGE" THEN {&Find_Image_Dlg_Box}
              ELSE {&Find_File_Dlg_Box}
              . 
{ adecomm/okbar.i 
   &TOOL    = "COMM"
   &CONTEXT = hlp_context }


/* Fix up the screen to handle diffenences in resolution (on GUI platforms)
   1) Round off the selection-list to an integer number of lines. 
   2) Make sure image/rectangle is wide enough to hold 320 pixels
   3) Make sure the Text and Image displays just fit inside the Container 
      rectangle. */
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN FileList:INNER-LINES  = INTEGER(FileList:INNER-LINES).
  /* Check that the rectangle can hold a 320 pixel image. */
  i = 320 + (2 * Container:EDGE-PIXELS) - Container:WIDTH-P.
  IF i > 0 THEN DO:
    /* Widen the Frame and container rectangle by the value of i.
       Also widen and reposition items in the "sullivan" bar. */
    ASSIGN 
      FRAME {&FRAME-NAME}:WIDTH-P = FRAME {&FRAME-NAME}:WIDTH-P + i
      &IF {&OKBOX} &THEN
      rect_btn_bar:WIDTH-P        = rect_btn_bar:WIDTH-P + i /* Def'd in okbar.i */
      &ENDIF
      Btn_help:X                  = btn_help:X + i           /* Def'd in okbar.i */
      Container:WIDTH-P           = Container:WIDTH-P + i
      .
  END.
  ASSIGN i                     = Container:EDGE-PIXELS
         TextDisplay:WIDTH-P   = Container:WIDTH-P - (2 * i)
         TextDisplay:HEIGHT-P  = Container:HEIGHT-P - (2 * i)  
         TextDisplay:X         = Container:X + i
         TextDisplay:Y         = Container:Y + i
         ImageDisplay:WIDTH-P  = TextDisplay:WIDTH-P 
         ImageDisplay:HEIGHT-P = TextDisplay:HEIGHT-P
         ImageDisplay:X        = TextDisplay:X 
         ImageDisplay:Y        = TextDisplay:Y       
         .
END. /* DO WITH FRAME... */

/* ***************************** Main Code Block ****************************** */

/* These trigger on the ALT keys serve to make the accelerators work as expected.
   They do not because the labels are not really attached to the fields they label */
ON ALT-F OF FRAME {&FRAME-NAME}
  APPLY "ENTRY" TO FileNameField.
  
ON ALT-T OF FRAME {&FRAME-NAME}
  APPLY "ENTRY" TO FileType.
  
ON ALT-D OF FRAME {&FRAME-NAME}
  APPLY "ENTRY" TO DirList.
  
DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  /*
  ** Running InitFindFile does the main block assigns and loads the contents
  ** of the file type, directory list, and file selection/combo lists. This
  ** procedure also handles the enabling.
  */
  RUN InitFindFile.
  WAIT-FOR GO OF FRAME {&FRAME-NAME} FOCUS FileList.
END.

/*
** All done, so get out and clean-up
*/
HIDE FRAME {&FRAME-NAME}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddDirName f_findfile 
PROCEDURE AddDirName :
DO WITH FRAME {&FRAME-NAME}:
    DEFINE VARIABLE AlreadyExists AS LOGICAL NO-UNDO INITIAL FALSE.
    /*
    ** If the directory is new, add it to the directory list
    */
    IF NOT DirList:SCREEN-VALUE = DirName THEN i = 0.

    DO i = 1 TO DirList:num-items:
      IF DirList:ENTRY(i) = DirName THEN AlreadyExists = TRUE.
    END.
    IF NOT AlreadyExists THEN Result = DirList:ADD-LAST(DirName).
  
    ASSIGN
      DirList:SCREEN-VALUE       = DirName.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddFileFilter f_findfile 
PROCEDURE AddFileFilter :
DO WITH FRAME {&FRAME-NAME}:
    /*
    ** Parse the path name and strip last directory separator
    */
    RUN adecomm/_osprefx.p (FullFileName, OUTPUT DirName, OUTPUT FileName).
    ASSIGN
      DirName = RIGHT-TRIM(DirName,"~\/")
      DirName = IF (LENGTH(DirName,"CHARACTER":u) = 2
                  AND SUBSTRING(DirName,2,1,"CHARACTER":u) = ":":u) THEN
                  DirName + "~\":u ELSE DirName.
  
    /*
    ** De-construct the file type
    */
    /* Make sure there's something to de-construct */
    IF NUM-ENTRIES (FileName,".") < 2 THEN RETURN.
  
    /* WIN95-LFN - Windows 95 Long Filename support. Code below applies
       .3 extension limit. Only do this for DOS/WIN3.1. - jep 12/12/95 */
    IF OPSYS = "MSDOS":u THEN
    DO:
      IF LENGTH(ENTRY(2,FileName,".":U),"raw") > 3 THEN DO:
        MESSAGE ENTRY(2,FileName,".":U) "file filter is too long for DOS."
          VIEW-AS ALERT-BOX.
        RETURN.
      END.
    END.
  
    /* WIN95-LFN - Windows 95 Long Filename support - jep 12/12/95 */
    /* Determine file type using the extension. */
    RUN adecomm/_osfext.p
        (INPUT  FileName  /* OS File Name.   */ ,
         OUTPUT FileType  /* File Extension. */ ).
    ASSIGN FileType = "*.":u + TRIM(FileType, ".").
    /*ASSIGN FileType = "*." + ENTRY(2,FileName,".":U).*/
    
    DO i = 1 TO ItemCnt:
      CurFilter = FileType:ENTRY(i).
      IF LOOKUP(FileType,CurFilter) > 0 THEN LEAVE.
    END.
  
    /*
    ** See if the current file type is in the list of file types.
    ** if not, add it
    */
    IF LOOKUP(FileType,CurFilter) = 0 THEN
      ASSIGN
        Result                = FileType:ADD-LAST(FileType) IN FRAME {&FRAME-NAME}
        FileType:SCREEN-VALUE = FileType.
    ELSE
      FileType:SCREEN-VALUE = FileType:ENTRY(i).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ClearContents f_findfile 
PROCEDURE ClearContents :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    IF TextDisplay:SCREEN-VALUE <> "" THEN
      TextDisplay:SCREEN-VALUE = "".
    Result = ImageDisplay:LOAD-IMAGE("adeicon/blank",0,0,1,1) NO-ERROR.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EvaluateByteSize f_findfile 
PROCEDURE EvaluateByteSize :
/*
  ** Procedure to evaluate whether the small editor widget can read files
  ** that are too large
  */
  DEFINE VARIABLE LineContents AS CHARACTER NO-UNDO.
  DEFINE VARIABLE TestFileName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE CR           AS CHARACTER NO-UNDO.
  
  ASSIGN
    CR                 = CHR(10)
    FILE-INFO:FILENAME = FullFileName
    TestFileName       = FILE-INFO:FULL-PATHNAME.
  
  INPUT FROM VALUE(TestFileName).
  
  SEEK INPUT TO END.
  ByteSize = SEEK(INPUT).
  INPUT CLOSE.
  
  IF ByteSize > 20000 THEN DO:
    ASSIGN
      i            = 0
      FileContents = "".
  
    INPUT FROM VALUE(TestFileName) NO-ECHO.
    DO i = 1 TO 100.
      IMPORT UNFORMATTED LineContents.
      FileContents = FileContents + CR + LineContents.
    END.
  
    FileContents = FileContents + CR + CR +
                   "...and more..." + CR + CR +
                   "[NOTE: " + TestFileName + " was too" + CR +
                   " large to preview in its entirety." + CR +
                   " Only the first 100 lines are shown here.]"
                   .
    INPUT CLOSE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FileLoad f_findfile 
PROCEDURE FileLoad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Clear old image first */
  RUN ClearContents.

  DO WITH FRAME {&FRAME-NAME}:
    /*
    ** First, check to see if we should do anything. If not, get out
    */
    IF NOT PreviewFile:CHECKED THEN RETURN.
    IF FileNameField:SCREEN-VALUE = "(None)" OR
       FileNameField:SCREEN-VALUE = ""       OR
       FileNameField:SCREEN-VALUE = "?"      THEN 
      RETURN.

    /* 
    **  Do nothing if directory. get out
    */
    FILE-INFO:FILE-NAME = FullFileName.
    IF INDEX(FILE-INFO:FILE-TYPE,"D":U) <> 0 THEN 
        RETURN.
  
    /* Make sure we are trying to display the "Correct" preview mode. */
    IF PreviewType NE PrefPreviewType
      THEN ASSIGN PreviewType = PrefPreviewType
      PreviewType:SCREEN-VALUE = STRING(PreviewType).
  
    IF PreviewType THEN DO:
      /*
      ** load as an image: PreviewType = True 
      */
      ASSIGN Result = ImageDisplay:LOAD-IMAGE
        (FullFileName,0,0,ImageDisplay:WIDTH-P,ImageDisplay:HEIGHT-P) NO-ERROR.
      IF Result THEN ASSIGN Container:VISIBLE        = TRUE
                            ImageDisplay:VISIBLE     = TRUE
                            TextDisplay:VISIBLE      = FALSE
                            .
      ELSE DO:
        /* Report that the image could not be loaded (unless the option of showing
           text is available, in which case we will try that). */ 
        IF NOT PreviewType:SENSITIVE THEN RUN LoadImageError.
      END.
    END.
    /* Load the file contents itself if PreviewType is not Image (or if the image
       failed to load. */
    IF NOT PreviewType OR Result eq NO THEN DO:     
      /* The "small" windows editor cannot load large files. */
      IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" THEN DO:
        RUN EvaluateByteSize.
        IF ByteSize > 20000 THEN DO:
          TextDisplay:SCREEN-VALUE = FileContents.
          Result = yes.
        END.
        ELSE Result = TextDisplay:READ-FILE(FullFileName) NO-ERROR.
      END.
      ELSE Result = TextDisplay:READ-FILE(FullFileName) NO-ERROR.
      IF Result 
      THEN ASSIGN Container:VISIBLE        = FALSE
                  ImageDisplay:VISIBLE     = FALSE
                  TextDisplay:VISIBLE      = TRUE
                  PreviewType              = FALSE
                  PreviewType:SCREEN-VALUE = STRING(PreviewType).
      ELSE RUN LoadTextError.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FullFileName f_findfile 
PROCEDURE FullFileName :
DO WITH FRAME {&FRAME-NAME}:
    /* Show nothing if no file is selected. */
    IF FileNameField = "(None)":U THEN FullFileName = "":U.
    ELSE DO:
      TempDir = IF DirList:SCREEN-VALUE = "" THEN "." ELSE DirList:SCREEN-VALUE.
  
      /* If TempDir ends with a ":" then do nothing. Otherwise, add a proper
      directory slash. */
      IF TempDir NE "" AND
        SUBSTRING(TempDir,LENGTH(TempDir,"CHARACTER"),1,"CHARACTER") NE ":" THEN
          TempDir = RIGHT-TRIM (TempDir,"~\/") + "{&DIR-SLASH}":U.
      FullFileName = TempDir + FileNameField.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitDirList f_findfile 
PROCEDURE InitDirList :
DEFINE VAR tempList AS CHAR NO-UNDO.
  
  ASSIGN pDirList = REPLACE(pDirList,"/","{&DIR-SLASH}")
         tempList = pDirList
         .
  DO WITH FRAME {&FRAME-NAME}:
    IF tempList = "" THEN DO:
      ASSIGN
        DirList             = "."
        FILE-INFO:FILE-NAME = DirList
        tempList            = FILE-INFO:FULL-PATHNAME
        .
    END.
    ELSE IF NUM-ENTRIES (tempList ) eq 1 THEN DO:
      DirList = tempList.
    END.      
    ELSE DO:
      /* The first item in the list is the initial directory.  If that item
         appears twice, then remove the first item.  For example:
           "a,b,c"   --> List is "a,b,c"; initial is "a"
           "b,a,b,c" --> List is "a,b,c"; initial is "b" */
      ASSIGN DirList  = ENTRY (1, tempList)
             tempList = SUBSTRING (tempList, LENGTH(DirList,"CHARACTER":U) + 2,
                                   -1, "CHARACTER":U).
      /* Does the first item appear again in the list? If not, keep DirList
         in the List. */
      IF LOOKUP (DirList, tempList) eq 0
      THEN tempList = DirList + ",":U + tempList.
    END.
    ASSIGN
      DirList:LIST-ITEMS   = tempList 
      DirList:SCREEN-VALUE = DirList.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitFindFile f_findfile 
PROCEDURE InitFindFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    /*
    ** Initial screen assignments
    */
    ASSIGN
      pFileName                       = REPLACE(pFileName,"/","{&DIR-SLASH}")
      FRAME {&FRAME-NAME}:title       = (IF NOT pTitle BEGINS "Choose" THEN
                                          "Choose ":U ELSE "") + pTitle
      ImageDisplay:auto-resize        = FALSE
      TextDisplay:read-only           = TRUE
      pOK                             = FALSE
      FileType:delimiter              = "|"
      FileType:LIST-ITEM-PAIRS        = TRIM(pFilter)
      FileType:SCREEN-VALUE           = FileType:ENTRY(1)
      PreviewFile                     = TRUE
      PreviewFile:SCREEN-VALUE        = STRING(PreviewFile)
      PrefPreviewType                 = CAN-DO( "TEMPLATE,IMAGE", pMode)
      PreviewType                     = PrefPreviewType
      PreviewType:SCREEN-VALUE        = STRING(PreviewType)
      FileNameLabel:SCREEN-VALUE      = "&File:"
      FileNameLabel:side-label-handle = FileNameLabel:handle.

    ENABLE
        FileNameLabel
        FullFileNameField
        FileNameField
        FileList
        FileType
        DirList
        PreviewFile
        PreviewType
        EditPathButton
        BrowseButton
        Container
        ImageDisplay
        TextDisplay
      WITH FRAME {&FRAME-NAME}.
    RUN InitDirList.
    ASSIGN
      /* Don't show the radio-set unless we support two modes of Preview. */
      PreviewType:HIDDEN    = pMode ne "TEMPLATE"
      PreviewType:SENSITIVE = NOT PreviewType:HIDDEN
      FRAME {&FRAME-NAME}:hidden   = FALSE.

    /*
    ** Now initialize how FindFile will come up
    */
    IF pFileName <> "" AND pMode = "IMAGE" THEN DO:
      ASSIGN FileName = pFileName
             FullFileName = pFileName.         
      RUN InitpFileName (FALSE).
      IF RETURN-VALUE = "False" THEN
        APPLY "VALUE-CHANGED" TO DirList IN FRAME {&FRAME-NAME}.
    END.
    ELSE DO:
      APPLY "VALUE-CHANGED" TO DirList IN FRAME {&FRAME-NAME}.
    END.
    /*
    ** Now apply focus to the filelist
    */
    APPLY "ENTRY" TO FileList.
  
  END.

  /*
  Useful debug message ...
  message "pfilename" pfilename skip
  "pDirList" pdirlist skip
  "pFilter" pFilter skip
  "pMode" pMode
  view-as alert-box.
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitpFileName f_findfile 
PROCEDURE InitpFileName :
DEFINE INPUT PARAMETER pExtensionFlag AS LOGICAL NO-UNDO.
  
  DEFINE VARIABLE NewFileName   AS CHARACTER NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    RUN adecomm/_osprefx.p (pFileName, OUTPUT DirName, OUTPUT NewFileName).
    ASSIGN DirName = RIGHT-TRIM(DirName,"~\/":U) 
           FileNameField = NewFileName.
    RUN AddDirName.
    /* Note the new directory.  This will also set the File Name. */
    ExtensionFlag = pExtensionFlag.
    APPLY "VALUE-CHANGED" TO DirList.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LoadImageError f_findfile 
PROCEDURE LoadImageError :
DO WITH FRAME {&FRAME-NAME}:
    RUN ClearContents.
    BELL.
    MESSAGE TRIM(FullFileName) "could not be loaded successfully as an image." 
      VIEW-AS ALERT-BOX ERROR.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LoadTextError f_findfile 
PROCEDURE LoadTextError :
DO WITH FRAME {&FRAME-NAME}:
    RUN ClearContents.
    BELL.
    MESSAGE TRIM(FullFileName) "could not be loaded successfully."
      VIEW-AS ALERT-BOX ERROR.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Make_Rel f_findfile 
PROCEDURE Make_Rel :
/*------------------------------------------------------------------------------
  Purpose:     If file can be found in the PROPATH, return relative filename
  Parameters:  pFileName (char)
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER pFileName AS CHARACTER NO-UNDO.

DEFINE VARIABLE i AS INTEGER NO-UNDO.

DO i = 1 to NUM-ENTRIES(PROPATH):
  IF pFileName BEGINS TRIM(ENTRY(i,PROPATH))        AND
                      TRIM(ENTRY(i,PROPATH)) NE ""  THEN 
  DO:
    /* If it's there, chop off the leading part */
    ASSIGN pFileName = SUBSTRING(pFileName, LENGTH(ENTRY(i,PROPATH)) + 2, -1, "CHARACTER":U).
    LEAVE.
  END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MatchFileName f_findfile 
PROCEDURE MatchFileName :
DEFINE INPUT PARAMETER ExtensionFlag AS LOGICAL.

  DO WITH FRAME {&FRAME-NAME}:
    Matched = FALSE.

    FirstComparison:
    DO i = 1 TO FileList:num-items:
      /*
      ** this loop is necessary to compensate for a bug in Progress
      */
      IF ExtensionFlag THEN DO:
        IF FileList:ENTRY(i) = FileNameField THEN DO:
          FileList:SCREEN-VALUE = FileNameField.
          Matched = TRUE.
          LEAVE FirstComparison.
        END.
      END.
      ELSE DO:
        IF ENTRY(1,FileList:ENTRY(i),".") = FileNameField THEN DO:
          FileList:SCREEN-VALUE = Filelist:ENTRY(i).
          Matched = TRUE.
          LEAVE FirstComparison.
        END.
      END.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PopulateFileList f_findfile 
PROCEDURE PopulateFileList :
/******************************************************************************
 Procedure: PopulateFileList
 Description: Fills the file list with the contents of the current selected
              directory & filter.  NOTE that MS-WINDOWS uses a custom DLL
              to do this.  Otherwise we use the PROGRESS OS-DIR stream.
 ******************************************************************************/
  DEFINE VARIABLE CurDir    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Use_DLL   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE DirPrefix AS CHARACTER NO-UNDO.
  DEFINE VARIABLE DirBase   AS CHARACTER NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME} ON ERROR UNDO, RETURN "False":
    RUN adecomm/_setcurs.p ("WAIT":U).
    /* Standard initializations. */
    ASSIGN
      CurFilter           = ""
      FILE-INFO:FILE-NAME = IF DirList:SCREEN-VALUE = "" 
                              OR DirList:SCREEN-VALUE = "?" THEN "."
                            ELSE DirList:SCREEN-VALUE.
      CurDir               = FILE-INFO:FULL-PATHNAME 
      .
    
    /* The DLL currently has a bug which prevents it from reading
     * correctly from a root directory. In that case, the "unix"
     * style will be used below .
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
    DO:
      /*
      ** MS/DOS File processing ...
      */
      ASSIGN
        SET-SIZE(list-mem)  = list-size
        list-char           = "" /* init to blank */
        CurDir              = LC(CurDir)
        CurFilter           = IF FileType:SCREEN-VALUE = "" THEN "*.*" ELSE
                              FileType:SCREEN-VALUE
        .

      RUN file_search (CurDir,CurFilter,INPUT-OUTPUT list-mem,list-size,
                       OUTPUT missed-file, OUTPUT DirError).

      IF DirError <> 0 THEN DO:
        RUN adecomm/_setcurs.p ("":U).
        SET-SIZE(list-mem) = 0.
        MESSAGE "Error in directory search." 
          VIEW-AS ALERT-BOX ERROR.
        RETURN "False".
      END.
      
      IF missed-file > 0 THEN DO:
        MESSAGE "Too many files in your directory." SKIP
          "The file list may not be inclusive."
          VIEW-AS ALERT-BOX INFORMATION.
      END.
      
      ASSIGN
        list-char                  = GET-STRING(list-mem,1)
        SET-SIZE(list-mem)         = 0
        FileList                   = IF list-char <> "" THEN 
                                       "(None),":U + LC(list-char)
                                     ELSE "(None)":U
        .
    END.
    ELSE DO:
      /*
      ** UNIX file processing
      */
      RUN adecomm/_setcurs.p ("WAIT":U).
    
      DEFINE VARIABLE TempType AS CHARACTER NO-UNDO.
      ASSIGN
        i                          = 0
        FileList:LIST-ITEMS        = ""
        FileList:SCREEN-VALUE      = ""
        FileNameField:SCREEN-VALUE = ""
        NewFilter                  = ""
        FileStream                 = ""
        ListOfFiles                = "".
      /*
      ** First, parse the Filetype combo for multiple file types and construct 
      ** a new filter that will be used by the lookup function to compare values
      */
      DO i = 1 TO NUM-ENTRIES(FileType:SCREEN-VALUE,",":U):
        CurFilter = ENTRY(i,FileType:SCREEN-VALUE,",":U).
        IF NUM-ENTRIES(CurFilter,".") > 1 
        THEN CurFilter = ENTRY(2,CurFilter,".":U). 
        IF i = 1
        THEN NewFilter = CurFilter.
        ELSE NewFilter = NewFilter + "," + CurFilter .
      END.
    
      /*
      ** Fill up an input stream of files
      */
    
      INPUT FROM OS-DIR(CurDir) ECHO.
      REPEAT:
        IMPORT FileStream.
        FileStream = FileStream.
    
        IF NewFilter = "*.*" OR NewFilter = "*" THEN DO:
          /*
          ** For filter of "*.*" process everything except hidden files and 
          ** directories. Note: the FILE-INFO function doesn't work right and 
          ** still returns many directories
          */
          FILE-INFO:FILENAME = FileStream.
          Result = IF FILE-INFO:FILE-TYPE BEGINS "D" 
                     OR FileStream BEGINS "." THEN FALSE ELSE TRUE.
          IF Result THEN
            ListOfFiles = IF ListOfFiles = "" THEN FileStream
                          ELSE ListOfFiles + "," + FileStream.
        END.
        ELSE DO:
          /*
          ** For specific filetypes, this code screens files from the stream
          */
          /* WIN95-LFN - Windows 95 Long Filename support - jep 12/12/95 */
          RUN adecomm/_osfext.p
              (INPUT  FileStream  /* OS File Name.   */ ,
               OUTPUT TempType    /* File Extension. */ ).
          ASSIGN TempType = TRIM(TempType , ".").
    
          IF LOOKUP(TempType, NewFilter) > 0 THEN
            ListOfFiles = IF ListOfFiles = "" THEN FileStream
                          ELSE ListOfFiles + "," + FileStream.
        END.
      END.
      INPUT CLOSE.
      /*
      ** If this is Motif, the stream needs to be sorted
      */
      RUN adecomm/_sortstr.p (INPUT-OUTPUT ListOfFiles, INPUT ",").
      IF LOOKUP(OPSYS , "MSDOS,WIN32":u) > 0 THEN ListOfFiles = LC(ListOfFiles).
      FileList = IF TRIM(ListOfFiles) = "" THEN "(None)"
                 ELSE "(None)," + ListOfFiles.
      
    END.
    /*
    ** Now do some final assigns.  See if the current FileNameField matches.
    */
    Filelist:LIST-ITEMS = FileList.
    RUN MatchFileName (ExtensionFlag).
    IF NOT Matched
    THEN ASSIGN
            FileList:SCREEN-VALUE      = IF FileList:NUM-ITEMS eq 1 
                                         THEN FileList:ENTRY(1)
                                         ELSE FileList:ENTRY(2)
            FileNameField:SCREEN-VALUE = FileList:SCREEN-VALUE
            FileNameField              = FileNameField:SCREEN-VALUE.
      
    RUN adecomm/_setcurs.p ("":U).
    RETURN "True".

  END. /* DO WITH FRAME... */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

