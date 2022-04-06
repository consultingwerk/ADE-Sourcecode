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

Procedure:    adetran/pm/_loadstr.w
Author:       R. Ryan
Created:      2/95
Updated:      11/96 SLK Updated for wildcard exclusions etc.
                        Changed for FONT
                        Long filename
                        lc/caps
                01/97 SLK Fixed not including BUTTON,BROWSE Tooltip
Purpose:      Dialog box for creating a string-XREF file then load that
              file into XL_STRING_INFO and XL_INSTANCE tables
Background:   The extract routine allows the project manager to extract
              strings from the procedures in the XL_Procedures table then
              load those strings into project tables.  Some choices:

                1. The load phase can be skipped and just the extract made
                    - Normally, all procedures in XL_Procedures will be used
                    - 'Marked' procedures mean that some procedures have
                      been identified by the 'Scan' routine in the procedures
                      tab as XL_Procedures.NeedsExtracting.  Typically, scanned
                      procedures are procedures that have a newer file date in the
                      file header and/or procedures that have been added.
                    - The compiler's string XREF outputs all strings that do not
                      have the string attribute ":U" or null string "".
                2. The extract phase can be skipped and just a load from
                   an existing xref file can be made (assuming the xref file
                   is string around).

                     - The load phase implies filtering the xref against
                       the include/exclude filters that are stored in
                       XL_SelectedFilter (include) and XL_CustomFilters
                       (exclude).

Notes:        This is a complex procedure that reads the string-xref file, then
              does the following:

               It then looks at the combination of string and string attributes
                   and decides if this is:

                     a. a new string (if so, it builds a XL_STRING_INFO records and
                        a corresponding XL_INSTANCE record)
                     b. an existing string but a new instance (if so, it builds a
                        new XL_INSTANCE record).
                     c. an existing string and an update to an existing instance.

Procedures:   Key procedures include:

                 IncludeThis      as a record is being read, it looks at the
                                  XL_SelectedFilter table, and prepares to loads those
                                  records which match.  But first, it looks at...
                 ExcludeThis      as a record is being read, and it has already passed
                                  the 'IncludeThis' test, the XL_CustomFilters table
                                  is read.  If a match is made, that record is rejected,
                                  otherwise it is loaded.
                IsAlpha           determines if the string contains any 'alpha' characters. 'Alpha' currently being defined as English A-Z, a-z. To be expanded in the future to use codepage ISALPHA.
*/




{adetran/pm/tranhelp.i}
DEFINE OUTPUT       PARAMETER pOKPressed      AS LOGICAL            NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pXREFFileName   AS CHARACTER          NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pXREFType       AS CHARACTER          NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pDeleteXREF     AS LOGICAL            NO-UNDO.

DEFINE SHARED VARIABLE        _MainWindow     AS WIDGET-HANDLE      NO-UNDO.
DEFINE SHARED VARIABLE        _hMeter         AS HANDLE             NO-UNDO.
DEFINE SHARED VARIABLE        _hTrans         AS HANDLE             NO-UNDO.
DEFINE SHARED VARIABLE        CurrentMode     AS INTEGER            NO-UNDO.
DEFINE SHARED VARIABLE        StopProcessing  AS LOGICAL            NO-UNDO.
DEFINE SHARED VARIABLE        ProjectDB       AS CHARACTER          NO-UNDO.
/* Temporary files generated by _sort.w and _order.w.                */
/* If these are blank then the regular OpenQuery internal procedures */
/* are run, otherwise these will be run                              */
DEFINE SHARED VARIABLE TmpFl_PM_Ss          AS CHARACTER                NO-UNDO.
{adetran/pm/vsubset.i &NEW=" " &SHARED="SHARED"}
/* NOTE that the BUFFERs and QUERY are defined as NEW SHARED
 * because they are defined as SHARED in common/_sort.w
 */
DEFINE NEW SHARED BUFFER ThisSubsetList         FOR bSubsetList.
DEFINE NEW SHARED QUERY  ThisSubsetList         FOR ThisSubsetList SCROLLING.
DEFINE VARIABLE lOptionState  AS LOGICAL   NO-UNDO  INIT TRUE.
DEFINE VARIABLE iOrigHeight   AS INTEGER   NO-UNDO. /* Orig Window Height */
DEFINE VARIABLE iOrigWidth    AS INTEGER   NO-UNDO. /* Orig Window Width */
DEFINE VARIABLE hSubset       AS HANDLE    NO-UNDO. /* Subset Procedure Handle*/

DEFINE STREAM XREFStream.

DEFINE        VARIABLE        ThisMessage     AS CHARACTER          NO-UNDO.
DEFINE        VARIABLE        ErrorStatus     AS LOGICAL            NO-UNDO.
DEFINE        VARIABLE        InputLine       AS CHARACTER EXTENT 9.
DEFINE        VARIABLE        FoundIt         AS LOGICAL            NO-UNDO.
DEFINE        VARIABLE        msg-win         AS WIDGET-HANDLE      NO-UNDO.
DEFINE        VARIABLE        TimeDateStamp   AS DECIMAL            NO-UNDO.
DEFINE        VARIABLE        FileSize        AS INTEGER.
DEFINE        VARIABLE        TotalStrings    AS INTEGER.
DEFINE        VARIABLE        IncludedStrings AS INTEGER.
DEFINE        VARIABLE        Result          AS LOGICAL            NO-UNDO.
DEFINE        VARIABLE        i               AS INTEGER            NO-UNDO.
DEFINE        VARIABLE        cOrigTitle      AS CHARACTER          NO-UNDO.
DEFINE        VARIABLE        cTemp           AS CHARACTER          NO-UNDO.

DEFINE VARIABLE lCase         AS LOGICAL            NO-UNDO.
DEFINE VARIABLE cLine         AS CHARACTER          NO-UNDO CASE-SENSITIVE.
DEFINE VARIABLE cFilt         AS CHARACTER          NO-UNDO CASE-SENSITIVE.

/* NOTE: These are intentionally left w/out NO-UNDO
 * since we want to be able to undo the count in order
 * to know what will be stored in the DisplayType
 *      DisplayType CHR(4) sequence# CHR(4) instance#
 */
DEFINE       VARIABLE         NextInstance    AS INTEGER.
DEFINE       VARIABLE         NextString      AS INTEGER.


/* Stores the files found in an xrf file */
DEFINE TEMP-TABLE ttXREFDirFile NO-UNDO
   FIELD XREFFile  AS CHARACTER
   FIELD Directory AS CHARACTER
   FIELD FileName  AS CHARACTER
INDEX DirFile IS PRIMARY Directory FileName.

DEFINE BUFFER xXL_Instance FOR xlatedb.XL_Instance.
&IF LOOKUP("{&OPSYS}","MSDOS,WIN32":U) > 0 &THEN
    &SCOPED-DEFINE SLASH ~~~\
&ELSE
    &SCOPED-DEFINE SLASH /
&ENDIF

&SCOPED-DEFINE XREF-VER 4.0

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnOK XREFFileName BtnFile BtnCancel ~
UseFilters BtnHelp DeleteXREF BtnOptions LoadLabel RECT-1
&Scoped-Define DISPLAYED-OBJECTS XREFFileName UseFilters DeleteXREF ~
LoadLabel

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY DEFAULT
     LABEL "Cancel":L
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnFile
     LABEL "&Files...":L
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnHelp
     LABEL "&Help":L
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnOK AUTO-GO
     LABEL "OK":L
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnOptions
     LABEL "&Options >>":L
     SIZE 15 BY 1.14.

DEFINE VARIABLE LoadLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Load Options"
      VIEW-AS TEXT
     SIZE 13.6 BY .67 NO-UNDO.

DEFINE VARIABLE XREFFileName AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     SIZE 51.6 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 72.6 BY 4.48.

DEFINE VARIABLE DeleteXREF AS LOGICAL INITIAL no
     LABEL "&Delete XREF When Load Complete":L
     VIEW-AS TOGGLE-BOX
     SIZE 41.6 BY .67 NO-UNDO.

DEFINE VARIABLE UseFilters AS LOGICAL INITIAL yes
     LABEL "&Use Filters":L
     VIEW-AS TOGGLE-BOX
     SIZE 41.6 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     BtnOK AT ROW 1.71 COL 77
     XREFFileName AT ROW 2.14 COL 4.4 NO-LABEL
     BtnFile AT ROW 2.19 COL 58
     BtnCancel AT ROW 3 COL 77
     UseFilters AT ROW 3.67 COL 4.4
     BtnHelp AT ROW 4.29 COL 77
     DeleteXREF AT ROW 4.62 COL 4.4
     BtnOptions AT ROW 5.52 COL 77
     LoadLabel AT ROW 1.24 COL 4.4 NO-LABEL
     RECT-1 AT ROW 1.52 COL 2.4
     SPACE(19.79) SKIP(0.85)
    WITH VIEW-AS DIALOG-BOX
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         FONT 4
         TITLE "Load"
         DEFAULT-BUTTON BtnOK
         ROW 2 COLUMN 3.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
ASSIGN
       FRAME Dialog-Frame:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN LoadLabel IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN XREFFileName IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Load */
DO:
 APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnFile Dialog-Frame
ON CHOOSE OF BtnFile IN FRAME Dialog-Frame /* Files... */
DO:
  DEFINE VARIABLE OKPressed AS LOGICAL NO-UNDO.

  SYSTEM-DIALOG GET-FILE XREFFileName
     TITLE      "XREF Files"
     FILTERS    "XREF (*.xrf)" "*.xrf":u,
                "All Files (*.*)"       "*.*":u
     USE-FILENAME
     UPDATE OKpressed.

  IF OKpressed = TRUE THEN DO:
    XREFFileName:screen-value = XREFFileName.
    APPLY "U2":U TO XREFFileName IN FRAME Dialog-Frame.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp Dialog-Frame
ON CHOOSE OF BtnHelp IN FRAME Dialog-Frame /* Help */
OR help of frame {&frame-name} do:
  run adecomm/_adehelp.p ("TRAN":U, "CONTEXT":U, {&Load_Dialog_Box}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOK Dialog-Frame
ON CHOOSE OF BtnOK IN FRAME Dialog-Frame /* OK */
DO:
  DEFINE VAR CANCEL-FLAG   AS LOGICAL                   NO-UNDO.
  DEFINE VAR cntr          AS INTEGER                   NO-UNDO.
  DEFINE VAR err-num       AS INTEGER                   NO-UNDO.
  DEFINE VARIABLE Justify       as integer INITIAL 0         NO-UNDO.
  DEFINE VARIABLE NumProcs      as INTEGER                   NO-UNDO.
  DEFINE VARIABLE PctTaken      as decimal format ">>9.9%":u NO-UNDO.
  DEFINE VAR real-err      AS LOGICAL                   NO-UNDO.
  DEFINE VAR subst-line    AS CHARACTER                 NO-UNDO.
  DEFINE VARIABLE ThisFile      AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE ThisProc      AS CHARACTER                      NO-UNDO.

  RUN validXREFFileName.
  IF RETURN-VALUE = "NO-APPLY":U THEN RETURN NO-APPLY.

  IF VALID-HANDLE(hSubset) THEN
    APPLY "CLOSE":U TO hSubset.

/* ***** This is done when we disconnect the project db (tomn 10/99).
  /* Save XL_Invalid */
  FOR EACH xlatedb.XL_Invalid: DELETE xlatedb.XL_Invalid. END.
  FOR EACH ThisSubsetList WHERE ThisSubsetList.Project = ProjectDB
                            AND ThisSubsetList.Active  = TRUE NO-LOCK:
     CREATE xlatedb.XL_Invalid.
     ASSIGN xlatedb.XL_Invalid.GlossaryName = ThisSubsetList.Directory
            xlatedb.XL_Invalid.TargetPhrase = ThisSubsetList.FileName.
  END.
 ***** */

  RUN LoadStr (INPUT XREFFileName:SCREEN-VALUE,
               INPUT UseFilters:CHECKED,
               INPUT DeleteXREF:CHECKED).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOptions
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOptions Dialog-Frame
ON CHOOSE OF BtnOptions IN FRAME Dialog-Frame /* Options >> */
DO:
   IF lOptionState THEN
   DO:
      run adecomm/_setcurs.p("wait":U).

      /* Set to Option state and display the full dialog. */
      ASSIGN BtnOptions:LABEL = "<< &Options"
             lOptionState = NOT lOptionState.
      /* FRAME {&FRAME-NAME}:HEIGHT = <Full Height> is done in _subset.w */
      RUN VALUE("adetran/pm/_subset.w") PERSISTENT SET hSubset
               (  INPUT FRAME Dialog-Frame:HANDLE
                , INPUT THIS-PROCEDURE
               ).

      run adecomm/_setcurs.p("":U).
   END.
   ELSE
   DO:
      /* Display the shortened dialog */
      ASSIGN BtnOptions:LABEL = "&Options >>"
             lOptionState = NOT lOptionState.
      RUN shrinkDialog.
      APPLY "ENTRY":U TO XREFFileName.
   END.

END. /* CHOOSE OF BtnOptions */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME XREFFileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL XREFFileName Dialog-Frame
ON LEAVE OF XREFFileName IN FRAME Dialog-Frame
DO:
  if self:screen-value = "" then return.

  DEFINE VARIABLE DirName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE BaseName AS CHARACTER NO-UNDO.
  run adecomm/_osprefx.p (XREFFileName:screen-value,output DirName, OUTPUT BaseName).
  /* 11/96 Modified for long filenames */
  if length(BaseName,"RAW":u) > 255 then do:
    ThisMessage = XREFFileName:screen-value + "^This filename is not valid.".
    run adecomm/_s-alert.p (input-output ErrorStatus, "w":u,"ok":u, ThisMessage).
    XREFFileName:auto-zap = true.
    apply "entry":u to XREFFileName in frame Dialog-frame.
    return no-apply.
  end.
  else if self:screen-value = XREFFileName then return.
  else assign XREFFileName.

  IF VALID-HANDLE (hSubset) THEN RUN refreshSubsetScreen IN hSubset.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN ASSIGN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW
     CURRENT-WINDOW = ACTIVE-WINDOW.

/* Refresh subset lists - called when xref file is changed
 * using file open dialog.
 */
ON U2 OF XREFFileName IN FRAME Dialog-Frame DO:
  IF VALID-HANDLE (hSubset) THEN RUN refreshSubsetScreen IN hSubset.
END.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

   /*
   ** provide a default XREF filename
   */
   FIND FIRST xlatedb.XL_Project NO-LOCK NO-ERROR.
   assign
     cOrigTitle                      = FRAME {&FRAME-NAME}:TITLE
     sAppDir                         = xlatedb.XL_Project.ApplDirectory
     THIS-PROCEDURE:PRIVATE-DATA     = "LOAD":U
     LoadLabel:screen-value          = "Load Options"
     LoadLabel:width                 = font-table:get-text-width-chars (trim(LoadLabel:screen-value),4)
     cTemp					 = search(ldbname("xlatedb":u) + ".xrf":u)
     XREFFileName:screen-value       = if pXREFFileName <> "" and pXREFFileName <> ? then pXREFFileName
                                       else if cTemp <> ? then cTemp
                                       else "":U
     UseFilters:SCREEN-VALUE         = "yes":U
     DeleteXREF:screen-value         = string(pDeleteXREF)
     iOrigHeight = FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-CHARS
     iOrigWidth  = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-CHARS.

  IF lSubset THEN RUN assignTitle.

  FIND FIRST XL_customfilter
    WHERE RecType = "USER":U AND
          Filter BEGINS "X-INIT":U
    NO-LOCK NO-ERROR.
  IF AVAILABLE XL_customFilter
    THEN ASSIGN lCase = NUM-ENTRIES(Filter, "|":U) = 2.

  RUN Realize.
  WAIT-FOR GO OF FRAME {&FRAME-NAME} focus XREFFileName.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIBe-CODE-BLOCK _PROCEDURE assignTitle Dialog-Frame
PROCEDURE assignTitle :
   ASSIGN FRAME {&FRAME-NAME}:TITLE = IF lSubset THEN cOrigTitle + cSubset
                                      ELSE cOrigTitle.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIBe-CODE-BLOCK _PROCEDURE crUpdDirFileList Dialog-Frame
PROCEDURE crUpdDirFileList :
/*
 * Need to be loaded from the xrf file
 * Clean up first Directory and File Listing
 * Wait on the SubsetListing so we can maintain preexisting selections
 */
   IF VALID-HANDLE(hSubset) THEN
   DO:
      RUN deleteDirList in hSubset.
      RUN deleteFileList in hSubset.
   END.

   /*
    * get info from XREF file... will need to read it
    * stored in ttXREFDirFile
    */
   IF XREFFileName:SCREEN-VALUE IN FRAME Dialog-Frame = "":U THEN
     RETURN.
   ELSE
     RUN getXREFDirFile.
   FIND FIRST ttXREFDirFile NO-LOCK NO-ERROR.
   IF NOT AVAILABLE ttXREFDirFile THEN RETURN.

   FOR EACH ttXREFDirFile BREAK BY ttXREFDirFile.Directory:
      IF FIRST-OF (ttXREFDirFile.Directory) THEN
      DO:
         FIND FIRST bDirList WHERE bDirList.Project   = ProjectDB
                               AND bDirList.Directory = ttXREFDirFile.Directory
           NO-LOCK NO-ERROR.
         IF NOT AVAILABLE bDirList THEN
         DO:
            CREATE bDirList.
            ASSIGN bDirList.Project   = ProjectDB
                   bDirList.Directory = ttXREFDirFile.Directory.
         END.

        /* If there's already an active subset listing for the complete
         * directory, then set the directory name to not active */
        FIND FIRST bSubsetList WHERE bSubsetList.Project   = ProjectDB
                                 AND bSubsetList.Directory = bDirList.Directory
                                 AND bSubsetList.FileName  = cAllFiles
                                 AND bSubsetList.Active
          NO-LOCK NO-ERROR.

        bDirList.Active = NOT AVAILABLE bSubsetList.
      END.

      FIND FIRST bFileList WHERE bFileList.Project   = ProjectDB
                             AND bFileList.Directory = ttXREFDirFile.Directory
                             AND bFileList.FileName  = ttXREFDirFile.FileName
        NO-LOCK NO-ERROR.
      IF NOT AVAILABLE bFileList THEN
      DO:
        CREATE bFileList.
        ASSIGN bFileList.Project   = ProjectDB
               bFileList.Directory = ttXREFDirFile.Directory
               bFileList.FileName  = ttXREFDirFile.FileName.

        /* If there's already an active subset listing for the complete
         * directory or the individual file, then set filename to not active */
        FIND FIRST bSubsetList WHERE bSubsetList.Project   = ProjectDB
                                 AND bSubsetList.Directory = bFileList.Directory
                                 AND (bSubsetList.FileName = cAllFiles OR
                                      bSubsetList.FileName = bFileList.FileName)
                                 AND bSubsetList.Active
          NO-LOCK NO-ERROR.
        IF AVAILABLE bSubsetList THEN bFileList.Active = FALSE.
      END.
   END. /* FOR EACH */

   /* We are saving the SubsetList until we can compare with the list of dir/file in the xrf file
    * This way we can maintain chosen files if necessary
    */
   SubsetList:
   FOR EACH ThisSubsetList WHERE ThisSubsetList.Project = ProjectDB EXCLUSIVE-LOCK:
      IF ThisSubsetList.Active = FALSE THEN
         DELETE ThisSubsetList.
      ELSE
      DO:
         IF ThisSubsetList.FileName = cAllFiles THEN
         DO:
            FIND FIRST ttXREFDirFile WHERE ttXREFDirFile.Directory = ThisSubsetList.Directory
              NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ttXREFDirFile THEN DO:
              /* Remove files from the DirList and FileList */
              FIND FIRST bDirList WHERE bDirList.Project   = ProjectDB
                                    AND bDirList.Directory = ThisSubsetList.Directory
                EXCLUSIVE-LOCK NO-ERROR.
              IF AVAILABLE bDirList THEN bDirList.Active = FALSE.
              FOR EACH bFileList WHERE bFileList.Project   = ProjectDB
                                   AND bFileList.Directory = ThisSubsetList.Directory
                EXCLUSIVE-LOCK:
                bFileList.Active = FALSE.
              END.
              DELETE ThisSubsetList.
            END.
         END.
         ELSE
         DO:
            FIND FIRST ttXREFDirFile WHERE ttXREFDirFile.Directory = ThisSubsetList.Directory
                                       AND ttXREFDirFile.FileName  = ThisSubsetList.FileName
              NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ttXREFDirFile THEN DO:
              /* Remove files from the DirList and FileList */
              FIND FIRST bFileList WHERE bFileList.Project   = ProjectDB
                                     AND bFileList.Directory = ThisSubsetList.Directory
                                     AND bFileList.FileName  = ThisSubsetList.FileName
                EXCLUSIVE-LOCK NO-ERROR.
              IF AVAILABLE bFileList THEN bFileList.Active = FALSE.

              FIND FIRST bFileList WHERE bFileList.Project   = ProjectDB
                                     AND bFileList.Directory = ThisSubsetList.Directory
                                     AND bFileList.Active    = TRUE
                NO-LOCK NO-ERROR.
              IF NOT AVAILABLE bFileList THEN
              DO:
                 FIND FIRST bDirList WHERE bDirList.Project   = ProjectDB
                                       AND bDirList.Directory = ThisSubsetList.Directory
                   EXCLUSIVE-LOCK NO-ERROR.
                 IF AVAILABLE bDirList THEN bDirList.Active = FALSE.
              END.
              DELETE ThisSubsetList.
	      END.
         END. /* Single File */
      END. /* Active */
   END. /* Each SubsetList */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE crUpdSubsetList Dialog-Frame
PROCEDURE crUpdSubsetList :
/*
 */

/* *** No.  Leave the current subset list alone...

   /*
    * get info from XREF file... will need to read it
    * stored in ttXREFDirFile
    */
   RUN getXREFDirFile.
   FIND FIRST ttXREFDirFile NO-LOCK NO-ERROR.
   IF NOT AVAILABLE ttXREFDirFile THEN RETURN.

   FIND FIRST xlatedb.XL_Invalid NO-ERROR.
   IF AVAILABLE xlatedb.XL_Invalid THEN
   DO:
      /* Note that we are storing the subset in the XL_Invalid table */
      FOR EACH xlatedb.XL_Invalid:
         FIND FIRST ttXREFDirFile
           WHERE ttXREFDirFile.XREFFile  = pXREFFileName
             AND ttXREFDirFile.Directory = xlatedb.XL_Invalid.GLossaryName
             AND ttXREFDirFile.FileName  = xlatedb.XL_Invalid.TargetPhrase
           NO-LOCK NO-ERROR.
         FIND FIRST ThisSubsetList
           WHERE ThisSubsetList.Project   = ProjectDB
             AND ThisSubsetList.Directory = xlatedb.XL_Invalid.GLossaryName
             AND ThisSubsetList.FileName  = xlatedb.XL_Invalid.TargetPhrase
           EXCLUSIVE-LOCK NO-ERROR.
         IF     (NOT AVAILABLE ttXREFDirFile)
            AND (xlatedb.XL_Invalid.TargetPhrase <> cAllFiles) THEN
         DO:
            DELETE xlatedb.XL_Invalid.
            IF AVAILABLE ThisSubsetList THEN DELETE ThisSubsetList.
         END.
         ELSE
         DO:
            IF NOT AVAILABLE ThisSubsetList THEN
            DO:
               CREATE ThisSubsetList.
               ASSIGN ThisSubsetList.Project   = ProjectDB
                      ThisSubsetList.Directory = xlatedb.XL_Invalid.GLossaryName
                      ThisSubsetList.FileName  = xlatedb.XL_Invalid.TargetPhrase.
            END.
            ASSIGN ThisSubsetList.Active = TRUE.
         END. /* Valid XL_Invalid record */
      END. /* each XL_Invalid */
   END. /* XL_Invalid exists */

* *** */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enlargeDialog Dialog-Frame
PROCEDURE enlargeDialog :
   DEFINE INPUT PARAMETER  p-iExtraHeight    AS INTEGER        NO-UNDO.
   DEFINE INPUT PARAMETER  p-iExtraWidth     AS INTEGER        NO-UNDO.
   DEFINE OUTPUT PARAMETER p-iRow            AS INTEGER        NO-UNDO.
   DEFINE OUTPUT PARAMETER p-iColumn         AS INTEGER        NO-UNDO.

   /* Since the subset frame will be a child to procedure's frame,
    *    p-iRow should be
    *    p-iColumn should be 1
    */
   ASSIGN
      p-iRow                           = FRAME Dialog-Frame:HEIGHT-CHARS - 0.1
      p-iColumn                        = 1
      FRAME Dialog-Frame:HEIGHT-CHARS  = FRAME Dialog-Frame:HEIGHT-CHARS +
                                         p-iExtraHeight + .5
      FRAME Dialog-Frame:WIDTH-CHARS   = 1 +
         MAX(FRAME Dialog-Frame:WIDTH-CHARS, p-iExtraWidth).
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getXREFDirFile Dialog-Frame
PROCEDURE getXREFDirFile :
  DEFINE VARIABLE ThisDir       AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE ThisFile      AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE ThisProc      AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE Cancel-Flag   AS LOGICAL                        NO-UNDO.
  DEFINE VARIABLE Cntr          AS INTEGER                        NO-UNDO.
   /* re-check in case
    * ASSIGNS FILE-INFO:FILE-NAME to the XREF file
    */
  /* Clean the temp-table */
  FOR EACH ttXREFDirFile WHERE ttXREFDirFile.XREFFile = pXREFFileName:
     DELETE ttXREFDirFile.
  END.

  RUN validXREFFileName.
  IF RETURN-VALUE = "NO-APPLY":U THEN RETURN.

  /* Open the file to see how big it is  */
  /* Do not reset FILE-INFO:FILE-NAME = pXREFFileName since already set in validaXREFFileName */
  INPUT STREAM XREFStream FROM VALUE(FILE-INFO:FULL-PATHNAME).
  SEEK STREAM XREFStream TO END.
  ASSIGN FileSize = SEEK(XREFStream)
         Result   = YES.

  /* Back the file pointer to the beginning of the file  */
  SEEK STREAM XREFStream TO 0.
  IF NOT Result OR Result = ? THEN
  DO:
    INPUT STREAM XREFStream CLOSE.
    RETURN.
  END.

   IF VALID-HANDLE(_hMeter) THEN
     RUN Realize in _hMeter ("Files in XREF...").

   ASSIGN cancel-flag = FALSE.
   TRANS-LOOP:
   REPEAT TRANSACTION:
      INNER:
      REPEAT cntr = 1 TO 300 ON END-KEY UNDO inner, LEAVE TRANS-LOOP:
         InputLine = "":U.
         PROCESS EVENTS.
         IF StopProcessing THEN
         DO:
            CANCEL-FLAG = TRUE.
            RUN HideMe IN _hMeter.
            UNDO INNER, LEAVE TRANS-LOOP.
         END.

         IMPORT STREAM XREFStream InputLine NO-ERROR.
         IF InputLine[1] = "String":U AND InputLine[2] = "Xref":U THEN
         DO:
            IF InputLine[4] <> "{&XREF-VER}":U THEN
            DO:
                ThisMessage = "_prowin.exe version mismatch. Expected XREF version {&XREF-VER}; found " + InputLine[4] + ".":U.
                RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus
                                        ,"e":U,"ok":U,ThisMessage).
                RUN HideMe IN _hMeter.
                FRAME {&FRAME-NAME}:HIDDEN = FALSE.
                RETURN NO-APPLY.
            END.

            ThisProc = InputLine[5].
            RUN adecomm/_osprefx.p (ThisProc, OUTPUT ThisDir, OUTPUT ThisFile).


            ThisDir = IF ThisDir = "":U THEN ".":U      /* To match other tables */
                      ELSE RIGHT-TRIM(ThisDir, "/~\":U).  /* Remove trailing slash */

            FIND FIRST ttXREFDirFile WHERE
                   ttXREFDirFile.Directory = ThisDir
               AND ttXREFDirFile.FileName  = ThisFile
               AND ttXREFDirFile.XREFFile  = pXREFFileName NO-ERROR.
            IF NOT AVAILABLE ttXREFDirFile THEN
            DO:
               CREATE ttXREFDirFile.
               ASSIGN
                   ttXREFDirFile.XREFFile  = pXREFFileName
                   ttXREFDirFile.FileName  = ThisFile
                   ttXREFDirFile.Directory = ThisDir.

            END.
            IF VALID-HANDLE(_hMeter) THEN
              RUN SetBar IN _hMeter(FileSize, SEEK(XREFStream),ThisProc).
         END. /* If header line */
      END. /* Repeat */

   END. /* REPEAT Transaction */
   INPUT STREAM XREFStream CLOSE.
   RUN HideMe IN _hMeter.
END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize Dialog-Frame
PROCEDURE Realize :
ENABLE RECT-1 BtnOK BtnCancel
         BtnHelp
         BtnOptions
      WITH FRAME {&frame-name}.
  {&OPEN-BROWSERS-IN-QUERY-{&frame-name}}

  enable
    XREFFileName
    BtnFile
    UseFilters
    DeleteXREF
    BtnOK
    BtnCancel
    BtnHelp
  with frame {&frame-name}.

  run adecomm/_setcurs.p ("").
END PROCEDURE. /* Realize */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE shrinkDialog Dialog-Frame
PROCEDURE shrinkDialog :
   IF VALID-HANDLE(hSubset) THEN
   RUN disable_UI IN hSubset.
   ASSIGN FRAME Dialog-Frame:HEIGHT-CHARS    = iOrigHeight
          FRAME Dialog-Frame:WIDTH-CHARS     = iOrigWidth.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validXREFFileName Dialog-Frame
PROCEDURE validXREFFileName :
  DO WITH FRAME {&FRAME-NAME}:
     IF XREFFileName:SCREEN-VALUE = "":U THEN
     DO:
         ThisMessage = "You must enter a XREF filename.".
         RUN adecomm/_s-alert.p
            (INPUT-OUTPUT ErrorStatus, "w":u,"ok":u, ThisMessage).
         APPLY "ENTRY":U TO XREFFileName.
         RETURN "NO-APPLY".
      END.

      FILE-INFO:FILENAME = XREFFileName:SCREEN-VALUE.
      IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
        ThisMessage =
           XREFFileName:SCREEN-VALUE + "^does not exist or cannot be located.".
        RUN adecomm/_s-alert.p
          (INPUT-OUTPUT ErrorStatus, "w":U, "ok":U, ThisMessage).
        XREFFileName:AUTO-ZAP = TRUE.
        RETURN "NO-APPLY".
      END.

      /* ** Ok, there must a filename.  Is it valid? */
      APPLY "LEAVE":U TO XREFFileName.
   END. /* Frame */
END PROCEDURE. /* validXREFFileName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{adetran/pm/loadstr.i}
