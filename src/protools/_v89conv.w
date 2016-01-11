&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          files            PROGRESS
*/
&Scoped-define WINDOW-NAME V89conv

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE Procedure NO-UNDO /* LIKE files.Procedure.            */
    FIELD Name AS CHARACTER FORMAT "X(255)"
    FIELD Stts AS CHARACTER FORMAT "X(9)" LABEL "Status" INITIAL "Not Conv"
    FIELD Extension AS CHARACTER
  INDEX Name IS PRIMARY UNIQUE Name
  INDEX Extension Extension Name.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V89conv 
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

  File:        protools/v89conv.w

  Description: Main procedure for the V8 to V9 SmartObject conversion
               utility/

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:     D. Ross Hunter

  Created:    March 1, 1998

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

{protools/ptlshlp.i}  /* help definitions        */
{adecomm/_adetool.i}  /* Register as an ADE tool */
{protools/_runonce.i} /* allow one instance      */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{adecomm/dirsrch.i}
{adecomm/cbvar.i}
DEFINE VARIABLE forget-sw   AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE list-mem    AS MEMPTR                  NO-UNDO.
DEFINE VARIABLE list-size   AS INTEGER   INITIAL 20000 NO-UNDO.
DEFINE VARIABLE missed-file AS INTEGER                 NO-UNDO.
DEFINE VARIABLE name-seq    AS INTEGER                 NO-UNDO.
DEFINE VARIABLE DirError    AS INTEGER                 NO-UNDO.
DEFINE VARIABLE FileSize    AS INTEGER                 NO-UNDO.
DEFINE VARIABLE CurFilter   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE error       AS INTEGER                 NO-UNDO.
DEFINE VARIABLE ThisMessage AS CHARACTER               NO-UNDO.

DEFINE VARIABLE abort-conv  AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE sort-mode   AS INTEGER   INITIAL 2     NO-UNDO.

DEFINE NEW SHARED TEMP-TABLE name-switch
  FIELD forget   AS LOGICAL
  FIELD seq      AS INTEGER
  FIELD old-name AS CHARACTER
  FIELD new-name AS CHARACTER
  INDEX forget-seq IS PRIMARY UNIQUE forget seq.

DEFINE NEW SHARED TEMP-TABLE method
  FIELD v8method AS CHARACTER
  FIELD v9method AS CHARACTER
  FIELD mType    AS CHARACTER
  FIELD params   AS CHARACTER
  INDEX v8method IS PRIMARY UNIQUE v8method.

DEFINE NEW SHARED TEMP-TABLE prprty
  FIELD v8prop   AS CHARACTER
  FIELD v9prop   AS CHARACTER
  INDEX v8prop IS PRIMARY UNIQUE v8prop.

DEFINE STREAM log-file.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Procedure

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 Procedure.Stts Procedure.Name 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH Procedure NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 Procedure
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 Procedure


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-4 RECT-5 Directory ~
btn_browse tog_subdir file-filter filter-btn tog_compile Btn-rebuild ~
BROWSE-1 Btn_Sort Btn_Add Btn_Remove Btn_Convert Btn_Abort Btn_Exit ~
Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS Directory tog_subdir file-filter ~
tog_compile 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR V89conv AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-rebuild 
     LABEL "Build File &List" 
     SIZE 24 BY 1.14.

DEFINE BUTTON Btn_Abort AUTO-GO 
     LABEL "&Abort Conversions" 
     SIZE 25 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Add AUTO-GO 
     LABEL "Add a &File..." 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON btn_browse 
     LABEL "&Browse..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_Convert AUTO-GO 
     LABEL "Start &Conversions" 
     SIZE 25 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Exit AUTO-GO DEFAULT 
     LABEL "&Exit" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Remove AUTO-GO 
     LABEL "&Remove" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Sort AUTO-GO 
     LABEL "&Sort ..." 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON filter-btn 
     IMAGE-UP FILE "adeicon\cbbtn":U
     LABEL "F" 
     SIZE 4 BY 1.

DEFINE VARIABLE Directory AS CHARACTER FORMAT "X(256)":U INITIAL "." 
     VIEW-AS FILL-IN 
     SIZE 44 BY 1.19 NO-UNDO.

DEFINE VARIABLE file-filter AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fi&lter" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE .2 BY 5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 63 BY 4.76.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82 BY 12.81.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82 BY .1.

DEFINE VARIABLE filter-list AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     LIST-ITEMS "*.w,*.p,*.i","*.w","*.p","*.i","*.*" 
     SIZE 19 BY 3.57 NO-UNDO.

DEFINE VARIABLE tog_compile AS LOGICAL INITIAL yes 
     LABEL "Co&mpile after Conversion" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .81 NO-UNDO.

DEFINE VARIABLE tog_subdir AS LOGICAL INITIAL yes 
     LABEL "&Include Subdirectories" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .81 NO-UNDO.

DEFINE VARIABLE srch-dir AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 44 BY .62 NO-UNDO.

DEFINE VARIABLE srch-lbl AS CHARACTER FORMAT "X(256)":U INITIAL "Searching:" 
      VIEW-AS TEXT 
     SIZE 19 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 53.4 BY 5.57.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      Procedure SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 V89conv _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      Procedure.Stts FORMAT "X(12)"
      Procedure.Name FORMAT "X(44)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 62 BY 9 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     Directory AT ROW 2.19 COL 4 COLON-ALIGNED NO-LABEL
     btn_browse AT ROW 2.19 COL 50
     tog_subdir AT ROW 3.86 COL 6
     file-filter AT ROW 3.86 COL 44 COLON-ALIGNED
     filter-btn AT ROW 3.86 COL 62
     tog_compile AT ROW 5.05 COL 6
     Btn-rebuild AT ROW 5.05 COL 41
     BROWSE-1 AT ROW 8.38 COL 6
     Btn_Sort AT ROW 10.05 COL 69.6
     Btn_Add AT ROW 11.48 COL 69.6
     Btn_Remove AT ROW 12.91 COL 69.6
     Btn_Convert AT ROW 18.14 COL 18
     Btn_Abort AT ROW 18.14 COL 47
     Btn_Exit AT ROW 1.71 COL 72
     Btn_Help AT ROW 3.14 COL 72
     filter-list AT ROW 4.81 COL 46 NO-LABEL
     RECT-1 AT ROW 1.48 COL 69
     RECT-2 AT ROW 1.71 COL 4
     RECT-4 AT ROW 7.19 COL 4
     RECT-5 AT ROW 6.71 COL 4
     "  Directory:" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 1.24 COL 5
     "Files to Convert:" VIEW-AS TEXT
          SIZE 15 BY .62 AT ROW 7.67 COL 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87 BY 19.38
         DEFAULT-BUTTON Btn_Exit.

DEFINE FRAME FRAME-A
     srch-lbl AT ROW 2.91 COL 7 COLON-ALIGNED NO-LABEL
     srch-dir AT ROW 3.86 COL 7 COLON-ALIGNED NO-LABEL
     RECT-6 AT ROW 1.14 COL 1.6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 8 ROW 10
         SIZE 55 BY 6
         BGCOLOR 4 FGCOLOR 15 .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ? T "?" NO-UNDO files Procedure
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW V89conv ASSIGN
         HIDDEN             = YES
         TITLE              = "Version 8 to Version 9 SmartObject Conversion Utility"
         HEIGHT             = 19.38
         WIDTH              = 87
         MAX-HEIGHT         = 19.38
         MAX-WIDTH          = 87
         VIRTUAL-HEIGHT     = 19.38
         VIRTUAL-WIDTH      = 87
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         MAX-BUTTON         = NO
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT V89conv:LOAD-ICON("adeicon\smoupgrd":U) THEN
    MESSAGE "Unable to load icon: adeicon\smoupgrd"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V89conv
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME FRAME-A:FRAME = FRAME DEFAULT-FRAME:HANDLE.

/* SETTINGS FOR FRAME DEFAULT-FRAME
   Custom                                                               */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME FRAME-A:MOVE-BEFORE-TAB-ITEM (Directory:HANDLE IN FRAME DEFAULT-FRAME)
/* END-ASSIGN-TABS */.

/* BROWSE-TAB BROWSE-1 Btn-rebuild DEFAULT-FRAME */
/* SETTINGS FOR SELECTION-LIST filter-list IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       filter-list:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FRAME FRAME-A
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME FRAME-A:HIDDEN           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(V89conv)
THEN V89conv:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.Procedure"
     _FldNameList[1]   > Temp-Tables.Procedure.Stts
"Procedure.Stts" ? "X(12)" "character" ? ? ? ? ? ? no ? no no ?
     _FldNameList[2]   > Temp-Tables.Procedure.Name
"Procedure.Name" ? "X(44)" "character" ? ? ? ? ? ? no ? no no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME V89conv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL V89conv V89conv
ON END-ERROR OF V89conv /* Version 8 to Version 9 SmartObject Conversion Utility */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL V89conv V89conv
ON WINDOW-CLOSE OF V89conv /* Version 8 to Version 9 SmartObject Conversion Utility */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-rebuild
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-rebuild V89conv
ON CHOOSE OF Btn-rebuild IN FRAME DEFAULT-FRAME /* Build File List */
DO:
  DEFINE VARIABLE ErrorStatus AS LOGICAL                         NO-UNDO.
  DEFINE VARIABLE i           AS INTEGER                         NO-UNDO.
  DEFINE VARIABLE tmpflnm     AS CHARACTER                       NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    RUN adecomm/_setcurs.p ("WAIT":U).

    /* Clear out the old stuff */
    FOR EACH Procedure:
      DELETE Procedure.
    END.
    
    ASSIGN Directory
           FILE-INFO:filename = RIGHT-TRIM(Directory,"~\,~/")
           Directory          = FILE-INFO:FULL-PATHNAME
           tog_subdir         = tog_subdir:CHECKED
           CurFilter          = file-filter:SCREEN-VALUE.

    RUN process_subdirectories(Directory, Directory, CurFilter).

    HIDE FRAME FRAME-A.
    SELF:LABEL = "Rebuild File &List":U.
    RUN open-browse.
    RUN adecomm/_setcurs.p ("":U).

    IF NUM-RESULTS("{&BROWSE-NAME}") = 0 THEN DO:
      ThisMessage =  "No files were found that matched your criteria. " +
                     "Try changing the file type filters.".
      RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w":U,"ok":U, ThisMessage).
      RETURN "False":U.
    END.  /* IF no files were found */
    
  END. /* DO WITH FRAME {&FRAME-NAME} */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Abort
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Abort V89conv
ON CHOOSE OF Btn_Abort IN FRAME DEFAULT-FRAME /* Abort Conversions */
DO:
  abort-conv = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Add V89conv
ON CHOOSE OF Btn_Add IN FRAME DEFAULT-FRAME /* Add a File... */
DO:
  DEFINE VARIABLE Filter_NameString AS CHARACTER EXTENT 5      NO-UNDO.
  DEFINE VARIABLE Filter_FileSpec   AS CHARACTER EXTENT 5      NO-UNDO.
  DEFINE VARIABLE File_Ext          AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE FileName          AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE NewRecid          AS RECID                   NO-UNDO.
  DEFINE VARIABLE NumEntries        AS INTEGER                 NO-UNDO.
  DEFINE VARIABLE p_ok              AS LOGICAL                 NO-UNDO.

  ASSIGN Directory
         FILE-INFO:filename = RIGHT-TRIM(Directory,"~\,~/")
         Directory          = FILE-INFO:FULL-PATHNAME
         Filter_NameString[ 1 ] = "All Source(*.w~;*.p~;*.i)"
         Filter_FileSpec[ 1 ]   = "*.w~;*.p~;*.i"
         Filter_NameString[ 2 ] = "Windows(*.w)"
         Filter_FileSpec[ 2 ]   = "*.w"
         Filter_NameString[ 3 ] = "Procedures(*.p)"
         Filter_FileSpec[ 3 ]   = "*.p"
         Filter_NameString[ 4 ] = "Includes(*.i)"
         Filter_FileSpec[ 4 ]   = "*.i"
         Filter_NameString[ 5 ] = "All Files(*.*)"
         Filter_FileSpec[ 5 ]   = "*.*".
         
  SYSTEM-DIALOG GET-FILE filename
     TITLE    "Add File Dialog" 
     FILTERS  Filter_NameString[ 1 ]   Filter_FileSpec[ 1 ],
              Filter_NameString[ 2 ]   Filter_FileSpec[ 2 ],
              Filter_NameString[ 3 ]   Filter_FileSpec[ 3 ],
              Filter_NameString[ 4 ]   Filter_FileSpec[ 4 ],
              Filter_NameString[ 5 ]   Filter_FileSpec[ 5 ]             
     MUST-EXIST
     UPDATE   p_ok IN WINDOW CURRENT-WINDOW.
  IF p_ok <> TRUE THEN RETURN.

  RUN adecomm/_setcurs.p ("WAIT":U).

  IF FileName BEGINS Directory THEN
    FileName = SUBSTRING(FileName, LENGTH(Directory, "CHARACTER":U) + 2).   
  ASSIGN FILE-INFO:FILE-NAME = FileName.
  IF FILE-INFO:FILE-TYPE = "FRW":U THEN DO:
    /* Don't allow .r's even if user asks for them */
    IF (NOT FileName MATCHES "*~~.r":U) THEN DO:
      CREATE Procedure.
      ASSIGN Procedure.name      = FileName
             NumEntries          = NUM-ENTRIES(FileName,".":U)
             Procedure.extension = IF NumEntries < 2 THEN ""
                                   ELSE ENTRY(NumEntries, FileName, ".":U)
             NewRecid            = RECID(Procedure).
      {&BROWSE-NAME}:SET-REPOSITIONED-ROW(5,"CONDITIONAL").
      RUN open-browse.
      REPOSITION {&BROWSE-NAME} TO RECID NewRecid.
    END.  /* IF not a .r */
  END.  /* IF a file */
  RUN adecomm/_setcurs.p ("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_browse V89conv
ON CHOOSE OF btn_browse IN FRAME DEFAULT-FRAME /* Browse... */
DO:
  DO WITH FRAME {&FRAME-NAME}.
    ASSIGN directory.
    RUN adeshar/_seldir.w (INPUT-OUTPUT directory).
    DISPLAY directory.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Convert
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Convert V89conv
ON CHOOSE OF Btn_Convert IN FRAME DEFAULT-FRAME /* Start Conversions */
DO:
  DEFINE VARIABLE Changes-made AS INTEGER                        NO-UNDO.
  DEFINE VARIABLE ConvRecid    AS RECID                          NO-UNDO.
  DEFINE VARIABLE dir-dirs     AS INTEGER                        NO-UNDO.
  DEFINE VARIABLE err-num      AS INTEGER                        NO-UNDO.
  DEFINE VARIABLE i            AS INTEGER                        NO-UNDO.
  DEFINE VARIABLE new-path     AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE old-path     AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE rel-name     AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE tmpDir       AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE tmpFile      AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE tmpflnm      AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE tmpfl-dirs   AS INTEGER                        NO-UNDO.
  DEFINE VARIABLE tst-line     AS CHARACTER                      NO-UNDO.

  DISABLE ALL EXCEPT Btn_abort filter-list WITH FRAME {&FRAME-NAME}.
  
  OUTPUT STREAM log-file TO "V89Conv.log".
  PUT STREAM log-file UNFORMATTED SKIP (2)
      "Converting V8 SmartObjects to V9" FILL(" ",20) TODAY " " +
      STRING(TIME,"HH:MM:SS") SKIP (1).

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN Directory
           FILE-INFO:filename = RIGHT-TRIM(Directory,"~\,~/")
           Directory          = FILE-INFO:FULL-PATHNAME
           tog_compile.

    RUN open-browse.
    GET FIRST {&BROWSE-NAME}.
    IF NOT AVAILABLE Procedure THEN DO:
      MESSAGE "The file list is empty." SKIP
              "No conversions have been done." VIEW-AS ALERT-BOX INFORMATION.
      ENABLE ALL WITH FRAME {&FRAME-NAME}.
      PUT STREAM log-file UNFORMATTED
        "The file list is empty." SKIP
         "No conversions have been done.".
      OUTPUT STREAM log-file CLOSE.
      RETURN.
    END.
    {&BROWSE-NAME}:SET-REPOSITIONED-ROW(2,"CONDITIONAL").
    {&BROWSE-NAME}:SELECT-ROW(1).
    OS-CREATE-DIR VALUE(Directory + "\V8-ADM").
    
    /* old-path is the last directory created */
    ASSIGN old-path   = Directory + "\V8-ADM"
           abort-conv = FALSE.

    CONVERSION-LOOP:
    REPEAT WHILE AVAILABLE Procedure:
  
      ASSIGN Procedure.Stts = "..."
             ConvRecid      = RECID(Procedure).

      DISPLAY Procedure.Stts Procedure.Name WITH BROWSE {&BROWSE-NAME}.
      PROCESS EVENTS.
      
      IF abort-conv THEN DO:
        MESSAGE "Conversion is aborting." SKIP
                "Check V89Conv.log for status."  VIEW-AS ALERT-BOX INFORMATION.
        ENABLE ALL WITH FRAME {&FRAME-NAME}.
        PUT STREAM log-file UNFORMATTED
           "Conversion is aborting." SKIP.
        OUTPUT STREAM log-file CLOSE.
        RETURN.
      END.
      
      /* See if the procedure is some where below the directory:
            For example: the directory might be C:\work\area but 
                         the procedure might be C:\test\myfile.w
         This can easily happen if the user pressed the "Add a File" button. */
      IF SUBSTRING(Procedure.Name,2,1) = ":" THEN DO:
        /* Here the user has choosen a file not in the directory specified. */
        ASSIGN i       = R-INDEX(Procedure.Name,"~\")
               tmpDir  = SUBSTRING(Procedure.Name,1 , i - 1, "CHARACTER":U)
               tmpFile = SUBSTRING(Procedure.Name,i + 1).
        /* Create V8-ADM subdirectory */
        OS-CREATE-DIR VALUE(tmpDir + "\V8-ADM").
      END.
      ELSE ASSIGN tmpDir  = directory
                  tmpFile = Procedure.Name.

      /* Look for a null (or trivially small) file */
      FILE-INFO:FILE-NAME = SEARCH(tmpDir + "\" + tmpFile).
      IF FILE-INFO:FILE-SIZE < 10 THEN DO:
        PUT STREAM log-file UNFORMATTED SKIP(1)
           "Procedure " + procedure.name + " is an invalid SmartObject." + CHR(10) +
           "No processing will occur." + CHR(10).
        Procedure.Stts = "Not Conv".      
      END.
      
      ELSE DO: /* Have a procedure to convert - First check to see if it is a V8 .w */
        INPUT FROM VALUE(SEARCH(tmpDir + "\" + tmpFile)) NO-ECHO.
        IMPORT UNFORMATTED tst-line.
        INPUT CLOSE.
        IF INDEX(tst-line,"AB_v9") > 0 THEN DO:
          PUT STREAM log-file UNFORMATTED SKIP(1)
             "Procedure " + procedure.name + " is already converted." + CHR(10) +
             "No processing will occur." + CHR(10).
          Procedure.Stts = "V9".
        END.
      END.  /* Else look for a V9 file */
      
      IF Procedure.Stts NE "..." THEN DO:
        DISPLAY Procedure.stts WITH BROWSE {&BROWSE-NAME}.
        PROCESS EVENTS.
        GET NEXT {&BROWSE-NAME}.
        IF NOT AVAILABLE Procedure THEN LEAVE CONVERSION-LOOP.
        {&BROWSE-NAME}:SELECT-NEXT-ROW().
        NEXT CONVERSION-LOOP.
      END.  /* If the procedure is already V9 */
 
      /* Have a procedure to convert - Copy it to sub-tree */
      tmpflnm = tmpDir + "\V8-ADM\" +
                IF INDEX(tmpFile,":\") = 2 THEN
                        ENTRY(1,tmpFile,":") + SUBSTRING(tmpFile,3)
                ELSE tmpFile.
                
      IF INDEX(tmpFile,"\") > 0 THEN DO:  /* Need to create a Directory */
        ASSIGN tmpfl-dirs = NUM-ENTRIES(tmpflnm,"\") - 1
                            /* (-1) because we don't count the filename */
               dir-dirs   = NUM-ENTRIES(tmpDir,"\") + 1
                            /* (+1) because we do count V8-ADM */
               new-path   = SUBSTRING(tmpflnm,1,R-INDEX(tmpflnm,"\") - 1,"CHARACTER").
        IF old-path NE new-path THEN DO:  /* Not the same as the last one created */
          new-path = tmpDir + "\V8-ADM".  /* Initialize at V8-ADM and work out */
          DO i = dir-dirs + 1 TO tmpfl-dirs:
            new-path = new-path + "\" + ENTRY(i,tmpflnm,"\").
            IF NOT old-path BEGINS new-path THEN DO:
               OS-CREATE-DIR VALUE(new-path).
               old-path = new-path.
            END. /* If the last path doesn't already contain the new path */
          END. /* DO i = num dirs in tmpDir + V8-ADM to tmpfl-dirs */
        END. /* If not yet created */
      END. /* If the procedure.name has a back-slash in it */

      PUT STREAM log-file UNFORMATTED SKIP (1)
           "Copying " + Procedure.Name + " to " tmpflnm + "."
           FORMAT "X(75)" SKIP.

      RUN adecomm/_relname.p (tmpDir + "\" + tmpFile, "MUST-EXIST",
                              OUTPUT rel-name).
       
      OS-COPY VALUE(SEARCH(rel-name)) VALUE(tmpflnm).
      /* Convert here */
      PUT STREAM log-file UNFORMATTED
           "Converting " + Procedure.Name + "."
           FORMAT "X(75)" SKIP.
      RUN protools/_convt89.p (INPUT tmpflnm,
                               INPUT rel-name,
                               OUTPUT changes-made).
      PUT STREAM log-file UNFORMATTED
                 "    " + STRING(changes-made) + 
                 (IF changes-made eq 1 THEN " change made." ELSE " changes made.")
           FORMAT "X(75)" SKIP.

      Procedure.Stts = IF changes-made = 0 THEN "No-change" ELSE
                       STRING(changes-made) +
                       (IF changes-made eq 1 THEN " Change" ELSE " Changes").
                       
      IF changes-made > 0 AND tog_compile:CHECKED THEN DO:
        PUT STREAM log-file UNFORMATTED
             "Compiling " + Procedure.Name + "."
             FORMAT "X(75)" SKIP.
        COMPILE VALUE(Procedure.Name) SAVE NO-ERROR.
        IF COMPILER:ERROR THEN DO:
          Procedure.Stts = "Comp. Err.".
          PUT STREAM log-file UNFORMATTED
             "    " + Procedure.Name + " did not compile." FORMAT "X(75)" SKIP.
          DO err-num = 1 TO ERROR-STATUS:NUM-MESSAGES:
            IF err-num > 10 THEN LEAVE.
            PUT STREAM log-file
               "    " + ERROR-STATUS:GET-MESSAGE(err-num) FORMAT "X(77)" SKIP.
          END.
        END.  /* If a compiler error occurred */
        ELSE PUT STREAM log-file UNFORMATTED
                 "    0 Compiler errors." FORMAT "X(75)" SKIP.
      END.
      
      DISPLAY Procedure.Stts Procedure.Name WITH BROWSE {&BROWSE-NAME}.

      GET NEXT {&BROWSE-NAME}.
      IF NOT AVAILABLE Procedure THEN LEAVE CONVERSION-LOOP.
      {&BROWSE-NAME}:SELECT-NEXT-ROW().
    END.  /* Repeat while available Procedure */

  END.  /* Do With Frame */
  BELL.
  ENABLE ALL EXCEPT filter-list WITH FRAME {&FRAME-NAME}.
  OUTPUT STREAM log-file CLOSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Exit V89conv
ON CHOOSE OF Btn_Exit IN FRAME DEFAULT-FRAME /* Exit */
DO:
  APPLY "WINDOW-CLOSE" TO {&WINDOW-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help V89conv
ON CHOOSE OF Btn_Help IN FRAME DEFAULT-FRAME /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  RUN adecomm/_adehelp.p ( "ptls", "CONTEXT":U, {&SmartObject_Upgrade_Utility_v9},?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Remove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Remove V89conv
ON CHOOSE OF Btn_Remove IN FRAME DEFAULT-FRAME /* Remove */
DO:
  DEFINE VARIABLE i       AS INTEGER     NO-UNDO.
  DEFINE VARIABLE num-sel AS INTEGER     NO-UNDO.
  
  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS < 1 THEN DO:
    MESSAGE "No procedures are selected." SKIP
            " Nothing has been deleted." VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
  END.
  ELSE DO:
    num-sel = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    DO i = num-sel to 1 BY -1:
      {&BROWSE-NAME}:FETCH-SELECTED-ROW(i).
      DELETE PROCEDURE.
    END.
    {&BROWSE-NAME}:DELETE-SELECTED-ROWS().
  END.  /* Else something was selected */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Sort
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Sort V89conv
ON CHOOSE OF Btn_Sort IN FRAME DEFAULT-FRAME /* Sort ... */
DO:
  DEFINE VARIABLE cur-sort AS INTEGER              NO-UNDO.
  cur-sort = sort-mode.
  RUN protools/sort-dia.w (INPUT-OUTPUT sort-mode).
  IF sort-mode NE cur-sort THEN RUN open-browse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Directory
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Directory V89conv
ON RETURN OF Directory IN FRAME DEFAULT-FRAME
DO:
  APPLY "TAB".
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V89conv 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* Set the combo box */
{adecomm/cbdropx.i &Frame  = "FRAME {&FRAME-NAME}"
                   &CBFill = "file-filter"
                   &CBList = "filter-list"
                   &CBBtn  = "filter-btn"
                   &CBInit = '"~*~.w"'}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  /* Load up the name-switch temp-table */
  INPUT FROM VALUE(SEARCH("protools/v89names.dat")).
  GEN-NAME-SWITCH-TABLE:
  REPEAT:
    name-seq = name-seq + 1.
    CREATE name-switch.
    ASSIGN name-switch.forget = forget-sw
           name-switch.seq    = name-seq.
    IMPORT name-switch.old-name name-switch.new-name.
    IF name-switch.old-name = "++" OR name-switch.old-name = " " THEN DO:
      IF name-switch.new-name = "Old" THEN forget-sw = FALSE.
      ELSE IF name-switch.new-name = "Remove" THEN forget-sw = TRUE.
      IF name-switch.new-name = "Method" THEN
        UNDO GEN-NAME-SWITCH-TABLE, LEAVE GEN-NAME-SWITCH-TABLE.
      DELETE name-switch.
    END.  /* IF old-name = "++" */
  END.  /* GEN-NAME-SWITCH-TABLE: REPEAT */

  GEN-METHOD-TABLE:
  REPEAT:
    CREATE method.
    IMPORT method.v8method method.v9method method.mType method.params.
    IF method.v8method = " " OR method.v8method = "++" THEN
      UNDO GEN-METHOD-TABLE, LEAVE GEN-METHOD-TABLE.
  END.  /* GEN-METHOD-TABLE */

  GEN-PRPRTY-TABLE:
  REPEAT:
    CREATE prprty.
    IMPORT prprty.v8prop prprty.v9prop.
    IF prprty.v8prop = " " OR prprty.v8prop = "++" THEN
      UNDO GEN-PRPRTY-TABLE, LEAVE GEN-PRPRTY-TABLE.
  END.  /* GEN-PRPRTY-TABLE */

  INPUT CLOSE.

  RUN enable_UI.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V89conv  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(V89conv)
  THEN DELETE WIDGET V89conv.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI V89conv  _DEFAULT-ENABLE
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
  DISPLAY Directory tog_subdir file-filter tog_compile 
      WITH FRAME DEFAULT-FRAME IN WINDOW V89conv.
  ENABLE RECT-1 RECT-2 RECT-4 RECT-5 Directory btn_browse tog_subdir 
         file-filter filter-btn tog_compile Btn-rebuild BROWSE-1 Btn_Sort 
         Btn_Add Btn_Remove Btn_Convert Btn_Abort Btn_Exit Btn_Help 
      WITH FRAME DEFAULT-FRAME IN WINDOW V89conv.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  DISPLAY srch-lbl srch-dir 
      WITH FRAME FRAME-A IN WINDOW V89conv.
  ENABLE RECT-6 srch-lbl srch-dir 
      WITH FRAME FRAME-A IN WINDOW V89conv.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-A}
  VIEW V89conv.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE open-browse V89conv 
PROCEDURE open-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  CASE sort-mode:
    WHEN 1 THEN
      OPEN QUERY BROWSE-1 FOR EACH Procedure
                                BY Procedure.Stts
                                BY Procedure.Name.
    WHEN 2 THEN
      OPEN QUERY BROWSE-1 FOR EACH Procedure.
    WHEN 3 THEN
      OPEN QUERY BROWSE-1 FOR EACH Procedure
                                BY Procedure.Extension.
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process_subdirectories V89conv 
PROCEDURE process_subdirectories :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER Org-Dir   AS CHARACTER                        NO-UNDO.
  DEFINE INPUT PARAMETER Directory AS CHARACTER                        NO-UNDO.
  DEFINE INPUT PARAMETER CurFilter AS CHARACTER                        NO-UNDO.
  
  DEFINE VARIABLE ErrorStatus      AS LOGICAL                          NO-UNDO.
  DEFINE VARIABLE i                AS INTEGER                          NO-UNDO.
  DEFINE VARIABLE newlist          AS CHARACTER                        NO-UNDO.
  DEFINE VARIABLE NumEntries       AS INTEGER                          NO-UNDO.
  DEFINE VARIABLE tmpflnm          AS CHARACTER                        NO-UNDO.

  ASSIGN SET-SIZE(list-mem) = list-size
         FILE-INFO:filename = Directory
         Directory          = FILE-INFO:FULL-PATHNAME.
  
  /* Don't process the "save" directory tree */
  IF INDEX(Directory,"V8-ADM") > 0 AND INDEX(Directory,Org-DIR) > 0
    THEN RETURN.

  /* First process any subdirectories IF tog_subdir is TRUE */
  IF tog_subdir THEN DO:
    RUN file_search(
        Directory,
        "*.*",
        INPUT-OUTPUT list-mem,
        list-size,
        OUTPUT missed-file,
        OUTPUT DirError).

      IF DirError <> 0 THEN DO:
        RUN adecomm/_setcurs.p ("":U).
        ASSIGN SET-SIZE(list-mem) = 0
               ThisMessage        = "Error in directory search. ".
        RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w":U, "ok":U, ThisMessage).
        RETURN "False":U.
      END.

      IF missed-file > 0 THEN DO:
        ThisMessage = "Too many files in your directory. " +
                      "The file list may not be inclusive.".
        RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w":U, "ok":U, ThisMessage).
      END.

      ASSIGN NewList            = GET-STRING(list-mem,1)
             SET-SIZE(list-mem) = 0.

      DO i = 1 TO NUM-ENTRIES(NewList):
        tmpflnm = ENTRY(i,NewList).
        IF tmpflnm NE "." AND tmpflnm NE ".." THEN DO:
          ASSIGN tmpflnm             = Directory + "~\":U + tmpflnm
                 FILE-INFO:FILE-NAME = tmpflnm.
          IF FILE-INFO:FILE-TYPE = "DRW" THEN
            RUN process_subdirectories(Org-Dir, tmpflnm, CurFilter).
        END.  /* If not current directory and not upper directory */
      END. /* DO i = 1 to NUM-ENTRIES of NewList */
    END. /* If the user wants recusion */

    VIEW FRAME FRAME-A.
    RECT-6:MOVE-TO-BOTTOM().
    ASSIGN srch-lbl:SCREEN-VALUE IN FRAME FRAME-A = "Searching:"
           srch-dir:SCREEN-VALUE IN FRAME FRAME-A = Directory.

    /* Now process files in this directory - recall file_search with proper filter */
    ASSIGN SET-SIZE(list-mem) = list-size.
    RUN file_search(
        Directory,
        CurFilter,
        INPUT-OUTPUT list-mem,
        list-size,
        OUTPUT missed-file,
        OUTPUT DirError).
    
    IF DirError <> 0 THEN DO:
      RUN adecomm/_setcurs.p ("":U).
      ASSIGN SET-SIZE(list-mem) = 0
             ThisMessage        = "Error in directory search. ".
      RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w":U, "ok":U, ThisMessage).
      RETURN "False":U.
    END.

    ASSIGN newlist            = GET-STRING(list-mem,1)
           SET-SIZE(list-mem) = 0.

    DO i = 1 TO NUM-ENTRIES(NewList):
      /* Don't allow directories 
       * Note that FILE-INFO can return ? for FILE-TYPE or FULL-PATHNAME
       * when there is no permission to access the file etc.
       * The ideal would have been to have file-type = F, but it screened
       * out valid files.                                                    */
      ASSIGN tmpflnm             = Directory + "~\":U + ENTRY(i,NewList)
             FILE-INFO:FILE-NAME = tmpflnm.
      IF FILE-INFO:FILE-TYPE = "FRW":U THEN DO:
        /* Don't allow .r's even if user asks for them */
        IF (NOT tmpflnm MATCHES "*~~.r":U) THEN DO:
          CREATE Procedure.
          ASSIGN Procedure.name      = SUBSTRING(tmpflnm,LENGTH(Org-Dir,"CHARACTER") + 2)
                 NumEntries          = NUM-ENTRIES(tmpflnm,".":U)
                 Procedure.extension = IF NumEntries < 2 THEN ""
                                       ELSE ENTRY(NumEntries, tmpflnm, ".":U).
        END.  /* IF not a .r */
      END.  /* IF a file */
    END. /* DO i = 1 to NUM-ENTRIES of list-char */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

