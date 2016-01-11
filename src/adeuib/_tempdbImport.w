&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*********************************************************************
* Copyright (C) 2000,2015 by Progress Software Corporation. All      *
* rights reserved. Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:        adeuib/_tempdbImport.w

  Description: Smart Object contained in _tempdb.w used for importing 
               source files into temp-db

  Author:      Don Bulua
  Created:     05/04/2001

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE gcSelectedListItems AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDelimiter         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glDynamicsIsRunning AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glIsInPropath       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE giFileNum           AS INTEGER    NO-UNDO.
DEFINE VARIABLE growLastFile        AS ROWID      NO-UNDO.
DEFINE VARIABLE glCleanRead         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE giLongestFilename   AS INTEGER    NO-UNDO.

gcDelimiter = CHR(3).

DEFINE TEMP-TABLE ttFile NO-UNDO
    FIELD tcFileName AS CHARACTER
    FIELD tcFullPath AS CHARACTER
    FIELD tiFileNum  AS INT64
    INDEX idxFile IS PRIMARY UNIQUE tiFileNum.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECTBottom fiDir btnDir toRecurse btnFetch ~
coFilter cbSegment seAll seSelected fiAll fiSelected 
&Scoped-Define DISPLAYED-OBJECTS fiDir toRecurse coFilter cbSegment seAll ~
seSelected fiAll fiSelected 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnAllLeft 
     LABEL "<< all-Left" 
     CONTEXT-HELP-ID 0
     SIZE 15 BY 1.15 TOOLTIP "Remove all files".

DEFINE BUTTON btnAllRight 
     LABEL "all-Right >>" 
     CONTEXT-HELP-ID 0
     SIZE 15 BY 1.15 TOOLTIP "Add all files".

DEFINE BUTTON btnDir 
     IMAGE-UP FILE "adeicon/open.bmp":U
     LABEL "Button" 
     CONTEXT-HELP-ID 0
     SIZE 6 BY 1.15.

DEFINE BUTTON btnFetch 
     LABEL "Fe&tch Files" 
     CONTEXT-HELP-ID 0
     SIZE 14 BY 1.08.

DEFINE BUTTON btnLeft 
     LABEL "< Left" 
     CONTEXT-HELP-ID 0
     SIZE 15 BY 1.15 TOOLTIP "Remove selected files".

DEFINE BUTTON btnRebuild 
     LABEL "Rebuild TEMP-DB" 
     CONTEXT-HELP-ID 0
     SIZE 19 BY 1.15.

DEFINE BUTTON btnRight 
     LABEL "Right >" 
     CONTEXT-HELP-ID 0
     SIZE 15 BY 1.15 TOOLTIP "Add selected files".

DEFINE VARIABLE cbSegment AS CHARACTER FORMAT "X(256)":U 
     LABEL "Segment" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 52 BY 1
     FONT 6 NO-UNDO.

DEFINE VARIABLE coFilter AS CHARACTER INITIAL "*.i" 
     LABEL "Filter" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "*.i","*.w","*.p","*.*" 
     DROP-DOWN
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE fiAll AS CHARACTER FORMAT "X(50)":U INITIAL "Fetched Files" 
     CONTEXT-HELP-ID 0
      VIEW-AS TEXT 
     SIZE 14 BY .62 NO-UNDO.

DEFINE VARIABLE fiDir AS CHARACTER FORMAT "X(100)":U 
     LABEL "Directory" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE fiSelected AS CHARACTER FORMAT "X(50)":U INITIAL "Selected Files" 
     CONTEXT-HELP-ID 0
      VIEW-AS TEXT 
     SIZE 14 BY .62 NO-UNDO.

DEFINE RECTANGLE RECTBottom
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY .12.

DEFINE VARIABLE seAll AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS SELECTION-LIST MULTIPLE SORT SCROLLBAR-VERTICAL 
     SIZE 14 BY 3.12 NO-UNDO.

DEFINE VARIABLE seSelected AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     SIZE 19 BY 2.85 NO-UNDO.

DEFINE VARIABLE toRecurse AS LOGICAL INITIAL no 
     LABEL "Recurse subdirectories" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fiDir AT ROW 1 COL 12 COLON-ALIGNED
     btnDir AT ROW 1 COL 48.57
     toRecurse AT ROW 1 COL 57
     btnFetch AT ROW 1 COL 84.57
     coFilter AT ROW 2.19 COL 12 COLON-ALIGNED
     cbSegment AT ROW 2.19 COL 43 COLON-ALIGNED WIDGET-ID 2
     btnAllRight AT ROW 3.62 COL 18
     seAll AT ROW 4.35 COL 2 NO-LABEL
     seSelected AT ROW 4.35 COL 35 NO-LABEL
     btnRight AT ROW 4.58 COL 18
     btnLeft AT ROW 5.77 COL 18
     btnAllLeft AT ROW 6.69 COL 18
     btnRebuild AT ROW 7.19 COL 36
     fiAll AT ROW 3.62 COL 2 NO-LABEL
     fiSelected AT ROW 3.62 COL 35 COLON-ALIGNED NO-LABEL
     RECTBottom AT ROW 3.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 10.69
         WIDTH              = 98.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME  Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON btnAllLeft IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnAllRight IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnLeft IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnRebuild IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnRight IN FRAME F-Main
   NO-ENABLE                                                            */
   ASSIGN 
       cbSegment:HIDDEN IN FRAME F-Main           = TRUE.
/* SETTINGS FOR FILL-IN fiAll IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME btnAllLeft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAllLeft sObject
ON CHOOSE OF btnAllLeft IN FRAME F-Main /* << all-Left */
DO:
  /* Move all items from the Selected Selection List on the right to the 
     Fetched Selected list on the left */
  DEFINE VARIABLE i      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.

  IF seSelected:LIST-ITEM-PAIRS = ? THEN
     RETURN.
  
  DO i = 1 TO NUM-ENTRIES(seSelected:LIST-ITEM-PAIRS,gcDelimiter) BY 2:
      ASSIGN cValue = ENTRY(i + 1,seSelected:LIST-ITEM-PAIRS,gcDelimiter).
      IF seAll:LIST-ITEM-PAIRS = ? 
         OR LOOKUP(cValue,seAll:LIST-ITEM-PAIRS,gcDelimiter) = 0 THEN
         seAll:ADD-LAST (ENTRY(i,seSelected:LIST-ITEM-PAIRS,gcDelimiter), cValue).
  END.
  ASSIGN
    seSelected:LIST-ITEM-PAIRS = ?
    seAll:SCREEN-VALUE         = ENTRY(2,seAll:LIST-ITEM-PAIRS,gcDelimiter)
    btnAllRight:SENSITIVE      = TRUE
    self:SENSITIVE             = FALSE 
    btnRebuild:SENSITIVE       = FALSE NO-ERROR.   
    
  APPLY "ENTRY":U TO seAll.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnAllRight
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAllRight sObject
ON CHOOSE OF btnAllRight IN FRAME F-Main /* all-Right >> */
DO:
  /* Move all items from the Fetched Selection List on the left to the 
     Selected Selected list on the right */
  DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i      AS INTEGER    NO-UNDO.
  
  if seAll:LIST-ITEM-PAIRS = ? or seAll:LIST-ITEM-PAIRS = "" then
    return.

  DO i = 1 TO NUM-ENTRIES(seAll:LIST-ITEM-PAIRS,gcDelimiter) BY 2:
      ASSIGN cValue = ENTRY(i + 1,seAll:LIST-ITEM-PAIRS,gcDelimiter).
      IF seSelected:LIST-ITEM-PAIRS = ? OR 
            LOOKUP(cValue,seSelected:LIST-ITEM-PAIRS,gcDelimiter) = 0 THEN
         seSelected:ADD-LAST (ENTRY(i,seAll:LIST-ITEM-PAIRS,gcDelimiter), cValue).
  END.
   ASSIGN
      seAll:LIST-ITEM-PAIRS         = ?
      seSelected:SCREEN-VALUE      = ENTRY(2,seSelected:LIST-ITEM-PAIRS,gcDelimiter)
      btnAllLeft:SENSITIVE         = TRUE
      btnRebuild:SENSITIVE         = TRUE 
      self:SENSITIVE               = FALSE NO-ERROR.
   
   APPLY "ENTRY":U TO seSelected.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnDir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnDir sObject
ON CHOOSE OF btnDir IN FRAME F-Main /* Button */
DO:
    /* Use the GET-DIR system dialog to prompt for a directory */
    DEFINE VARIABLE cdir    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cInitDir AS CHARACTER  NO-UNDO.

    FILE-INFO:FILE-NAME = fiDir:SCREEN-VALUE.
    ASSIGN cInitDir = FILE-INFO:FULL-PATHNAME
           cInitDir = IF cInitDir = ? THEN "" ELSE cInitDir.

    SYSTEM-DIALOG GET-DIR cDir INITIAL-DIR cInitDir TITLE "Fetch from Directory". 
    IF cDir <> ? AND cDir <> "" THEN
    DO:
        fiDir:SCREEN-VALUE = cdir.
        APPLY "VALUE-CHANGED":U TO fiDir.
        glCleanRead = FALSE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnFetch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnFetch sObject
ON CHOOSE OF btnFetch IN FRAME F-Main /* Fetch Files */
DO:
  DEFINE VARIABLE lAbort AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLength   AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cSegments AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iSegments AS INTEGER     NO-UNDO.
  DEFINE VARIABLE iSegment  AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cSegment  AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cRelname  AS CHARACTER   NO-UNDO.

  ASSIGN seAll:LIST-ITEM-PAIRS      = ?
         seSelected:LIST-ITEM-PAIRS = ?
         cbSegment:LIST-ITEM-PAIRS  = ?
         cbSegment:HIDDEN           = TRUE
         btnAllLeft:SENSITIVE       = FALSE
         btnAllRight:SENSITIVE      = FALSE 
         btnLeft:SENSITIVE          = FALSE 
         btnRight:SENSITIVE         = FALSE.

  /* Check that the directory is contained in the Propath. Add dummy file
     to use the relname tool */
  RUN adecomm/_relname.p (INPUT REPLACE(fiDir:SCREEN-VALUE,"~\":U, "~/":U) + "~/@dummyfile.ab", 
                          INPUT "", 
                          OUTPUT cRelname).
  glIsInPropath = (NOT (cRelname BEGINS fiDir:SCREEN-VALUE)).
  IF NOT glIsInPropath THEN DO:
    IF toRecurse:CHECKED THEN
       MESSAGE "The directory and/or sub-directories you have specified are not contained in the Propath" SKIP
               "Please enter a directory that is contained in the Propath, or whose sub-directories are contained in the Propath"
        VIEW-AS ALERT-BOX WARNING.
    ELSE
       MESSAGE "The directory you have specified is not contained in the Propath" SKIP
               "Please enter a directory that is contained in the Propath."
        VIEW-AS ALERT-BOX WARNING.
    APPLY "ENTRY":U to fiDir.
    RETURN.

  END.
    /* Set the list-items for the filter */
  cValue = coFilter:SCREEN-VALUE.
  IF LOOKUP(coFilter:SCREEN-VALUE,coFilter:LIST-ITEMS) = 0  THEN
      ASSIGN coFilter:LIST-ITEMS   = coFilter:SCREEN-VALUE + 
                                     coFilter:DELIMITER    + 
                                     coFilter:LIST-ITEMS
             coFilter:SCREEN-VALUE = cValue.
  ELSE
    /* Put selected value at beginning of list-items */
    ASSIGN coFilter:LIST-ITEMS   = REPLACE(coFilter:LIST-ITEMS,"," + cValue,"")
           coFilter:LIST-ITEMS   = REPLACE(coFilter:LIST-ITEMS,cValue + ",","")
           coFilter:LIST-ITEMS   = REPLACE(coFilter:LIST-ITEMS,cValue ,"")
           coFilter:LIST-ITEMS   = cValue + (IF coFilter:LIST-ITEMS = "" THEN "" ELSE ",") + 
                                   coFilter:LIST-ITEMS  
           coFilter:SCREEN-VALUE = cValue.   

  SESSION:SET-WAIT-STATE("GENERAL").
  RUN fetchFiles ( INPUT  fiDir:SCREEN-VALUE,
                   INPUT  coFilter:SCREEN-VALUE,
                   INPUT  toRecurse:CHECKED,
                   OUTPUT iLength,
                   OUTPUT cSegments ).
  SESSION:SET-WAIT-STATE("").

  iSegments   = NUM-ENTRIES(cSegments,CHR(1)).
  IF iSegments GT 1 THEN DO:
    ASSIGN cbSegment:LIST-ITEM-PAIRS = ?
           cbSegment:HIDDEN          = FALSE
           cbSegment:VISIBLE         = TRUE
           cbSegment:SENSITIVE       = TRUE
           cbSegment:WIDTH           = giLongestFileName + 10 NO-ERROR.

    DO iSegment = 1 TO NUM-ENTRIES(cSegments,CHR(1)):
      cSegment = ENTRY(iSegment,cSegments,CHR(1)).
      IF (cSegment GT "") NE TRUE THEN LEAVE.

      cbSegment:ADD-LAST(ENTRY(1,ENTRY(1,cSegment,"|")) + " - " + ENTRY(1,ENTRY(2,cSegment,"|")),
                         ENTRY(2,ENTRY(1,cSegment,"|")) + "," + ENTRY(2,ENTRY(2,cSegment,"|"))).
    END.
      
    MESSAGE "The total length of all filenames in the selected range are too long to be " +
            "processed in one shot.~n~n"                                                  + 
            "A list of segments has been provided in the Segment combo-box.~n~n"          + 
            "Please choose a segment of files to load."
        VIEW-AS ALERT-BOX WARNING BUTTONS OK TITLE "Too many files".
  END.
  /* If the files can be loaded all at once, hide the segment combo and load them */
  ELSE DO:
    ASSIGN cbSegment:HIDDEN    = TRUE
           cbSegment:VISIBLE   = FALSE
           cbSegment:SENSITIVE = FALSE.
    RUN loadSegment ( INPUT INTEGER(TRIM(ENTRY(1,cbSegment:SCREEN-VALUE))),
                      INPUT INTEGER(TRIM(ENTRY(2,cbSegment:SCREEN-VALUE))) ).
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnLeft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnLeft sObject
ON CHOOSE OF btnLeft IN FRAME F-Main /* < Left */
DO:
  DEFINE VARIABLE i          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE k          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel     AS CHARACTER  NO-UNDO.

  IF seSelected:LIST-ITEM-PAIRS = "" OR seSelected:SCREEN-VALUE = "" THEN 
      RETURN.
  
  SV-LOOP:
  DO i = 1 TO NUM-ENTRIES(seSelected:SCREEN-VALUE,gcDelimiter):
      ASSIGN cValue = ENTRY(i,seSelected:SCREEN-VALUE,gcDelimiter).
      /* Get the label of each selected item */
      k-Loop:
      DO k = 2 TO NUM-ENTRIES(seSelected:LIST-ITEM-PAIRS,gcDelimiter) BY 2:
         IF ENTRY(k,seSelected:LIST-ITEM-PAIRS,gcDelimiter) = cValue THEN DO:
            cLabel = ENTRY(k - 1, seSelected:LIST-ITEM-PAIRS,gcDelimiter).
            LEAVE k-loop.
         END.
      END.
      IF seAll:LIST-ITEM-PAIRS = ? 
         OR LOOKUP(cValue,seAll:LIST-ITEM-PAIRS,gcDelimiter) = 0 THEN
      seAll:ADD-LAST (cLabel, cValue).
      
      
  END.

  seSelected:DELETE(seSelected:SCREEN-VALUE).
  
  ASSIGN seSelected:SCREEN-VALUE = ENTRY(k  + 4 - (2 * i) ,seSelected:LIST-ITEM-PAIRS,gcDelimiter) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
     ASSIGN seSelected:SCREEN-VALUE = ENTRY(k + 2 - (2 * i),seSelected:LIST-ITEM-PAIRS,gcDelimiter) NO-ERROR.
     
  IF seSelected:LIST-ITEM-PAIRS = ? THEN
     ASSIGN btnleft:SENSITIVE     = FALSE
            btnAllLeft:SENSITIVE  = FALSE 
            btnRebuild:SENSITIVE  = FALSE .
  
  ASSIGN btnAllRight:SENSITIVE = TRUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnRebuild
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnRebuild sObject
ON CHOOSE OF btnRebuild IN FRAME F-Main /* Rebuild TEMP-DB */
DO:
  RUN rebuildFromList IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnRight
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnRight sObject
ON CHOOSE OF btnRight IN FRAME F-Main /* Right > */
DO:
  DEFINE VARIABLE i          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE k          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel     AS CHARACTER  NO-UNDO.

  IF seAll:LIST-ITEM-PAIRS = "" OR seAll:SCREEN-VALUE = "" THEN 
      RETURN.
  
  SV-LOOP:
  DO i = 1 TO NUM-ENTRIES(seAll:SCREEN-VALUE,gcDelimiter):
      ASSIGN cValue = ENTRY(i,seAll:SCREEN-VALUE,gcDelimiter).
      /* Get the label of each selected item */
      k-Loop:
      DO k = 2 TO NUM-ENTRIES(seAll:LIST-ITEM-PAIRS,gcDelimiter) BY 2:
         IF ENTRY(k,seAll:LIST-ITEM-PAIRS,gcDelimiter) = cValue THEN 
         DO:
            cLabel = ENTRY(k - 1, seAll:LIST-ITEM-PAIRS,gcDelimiter).
            LEAVE k-loop.
         END.
      END.
      /* Check if label already exists */
      
      IF seSelected:LIST-ITEM-PAIRS = ? 
         OR LOOKUP(cValue,seSelected:LIST-ITEM-PAIRS,gcDelimiter) = 0 THEN
         seSelected:ADD-LAST (cLabel, cValue).
      
      
  END.
  seAll:DELETE(seAll:SCREEN-VALUE).
  
  ASSIGN seAll:SCREEN-VALUE = ENTRY(k  + 4 - (2 * i) ,seAll:LIST-ITEM-PAIRS,gcDelimiter) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
     ASSIGN seAll:SCREEN-VALUE = ENTRY(k + 2 - (2 * i),seAll:LIST-ITEM-PAIRS,gcDelimiter) NO-ERROR.

  IF seAll:LIST-ITEM-PAIRS = ? THEN
     ASSIGN btnright:SENSITIVE  = FALSE
            btnAllRight:SENSITIVE = FALSE NO-ERROR.
  
  ASSIGN btnAllLeft:SENSITIVE = TRUE
         btnRebuild:SENSITIVE = TRUE.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME cbSegment
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cbSegment sObject
ON VALUE-CHANGED OF cbSegment IN FRAME F-Main /* Segment */
DO:
  RUN loadSegment ( INPUT INTEGER(TRIM(ENTRY(1,cbSegment:SCREEN-VALUE))),
                    INPUT INTEGER(TRIM(ENTRY(2,cbSegment:SCREEN-VALUE))) ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coFilter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coFilter sObject
ON VALUE-CHANGED OF coFilter IN FRAME F-Main /* Filter */
DO:
  glCleanRead = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiDir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiDir sObject
ON VALUE-CHANGED OF fiDir IN FRAME F-Main /* Directory */
DO:
  /* Check whether directory is valid */
  FILE-INFO:FILE-NAME = SELF:SCREEN-VALUE NO-ERROR.
  
  IF FILE-INFO:FULL-PATHNAME = ?  THEN
    ASSIGN SELF:FGCOLOR       = 7
           btnFetch:SENSITIVE = FALSE.
  ELSE
    ASSIGN SELF:FGCOLOR       = ?
           btnFetch:SENSITIVE = TRUE.
  glCleanRead = FALSE.         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seAll sObject
ON ENTRY OF seAll IN FRAME F-Main
DO:
  IF SELF:SCREEN-VALUE = ? THEN
      RETURN NO-APPLY.
  ASSIGN btnRight:SENSITIVE      = IF SELF:SCREEN-VALUE = ? THEN FALSE ELSE TRUE
         btnLeft:SENSITIVE       = FALSE
         seSelected:SCREEN-VALUE = ""  NO-ERROR.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seAll sObject
ON MOUSE-SELECT-DBLCLICK OF seAll IN FRAME F-Main
DO:
   APPLY "CHOOSE" TO btnright.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seSelected
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seSelected sObject
ON ENTRY OF seSelected IN FRAME F-Main
DO:
  IF SELF:SCREEN-VALUE = ? THEN
     RETURN NO-APPLY.

  ASSIGN 
    btnRight:SENSITIVE    = FALSE
    btnLeft:SENSITIVE     = IF SELF:SCREEN-VALUE = ? THEN FALSE ELSE TRUE
    seAll:SCREEN-VALUE    = ""  NO-ERROR.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seSelected sObject
ON MOUSE-SELECT-DBLCLICK OF seSelected IN FRAME F-Main
DO:
   APPLY "CHOOSE" TO btnLeft.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME toRecurse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toRecurse sObject
ON VALUE-CHANGED OF toRecurse IN FRAME F-Main /* Recurse subdirectories */
DO:
  glCleanRead = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject sObject 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDelim  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE sctn    AS CHARACTER  NO-UNDO.

{adeuib/tool.i}       /* Include this 1st - Defines &TOOL */

/* Define the section. */

ASSIGN sctn = "Pro":U + CAPS("{&TOOL}":U)
       cDelim = "|":U
       cValue = fiDir:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
                        + cDelim + STRING(toRecurse:CHECKED)
                        + cDelim + coFilter:LIST-ITEMS.
  /* Code placed here will execute PRIOR to standard behavior. */
    /* Default FALSE settings */
PUT-KEY-VALUE SECTION sctn KEY "TempDBImport" VALUE cvalue.
/* Set the delimiter used to store default settings in registry */
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchFiles sObject 
PROCEDURE fetchFiles :
/*------------------------------------------------------------------------------
  Purpose:     Read the selected directory and import the names of all files
               that match the user's selection criteria into a temp-table
  Parameters:  INPUT pcDirectory  CHARACTER - Folder to start reading from
               INPUT pcFilter     CHARACTER - Filter used to ensure only select
                                              files are read and stored in the
                                              temp-table
               INPUT plRecurse    LOGICAL   - Whether to recursively search all 
                                              sub-folders of the selected folder
               OUTPUT piDirLength INTEGER   - Total length of the names of all 
                                              selected files
               OUTPUT pcSegments  CHARACTER - If piDirLength is larger than what
                                              will easily fit in a selection list
                                              to allow string manipulation of 
                                              its LIST-ITEM-PAIRS string, it is
                                              broken into segments to be read in
                                              one at a time. 
                                              {e.g. a-f, g-m, etc...}
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcDirectory  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcFilter     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plRecurse    AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER piDirLength  AS INTEGER     NO-UNDO.
DEFINE OUTPUT PARAMETER pcSegments   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDir        AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cRelname AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSegment AS CHARACTER   NO-UNDO.

DEFINE VARIABLE iSegment AS INTEGER     NO-UNDO.

/* PSC00325642- make ttFile ready to update the file list with new content */
EMPTY TEMP-TABLE ttFile.

RUN readDir  (INPUT        pcDirectory,
              INPUT        pcFilter,
              INPUT        plRecurse,
              INPUT-OUTPUT iSegment,
              OUTPUT       piDirLength,
              INPUT-OUTPUT pcSegments ).
  /* If the files have been broken into multiple segments, the last file of the segment
     is always left off.  Find the last file read and add it to the end of the segments. */
  IF NUM-ENTRIES(pcSegments,CHR(1)) GT 1  THEN DO:
    cSegment = ENTRY(NUM-ENTRIES(pcSegments,CHR(1)),pcSegments,CHR(1)).
    /* This is for the case where we read exactly the number of files deemed to be able
       to fit in the selection list.  Rare event if it ever happens*/
    IF NUM-ENTRIES(cSegment,"|") EQ 2 THEN LEAVE.

    FIND ttFile WHERE ROWID(ttFile) EQ growLastFile NO-LOCK NO-ERROR.
    IF AVAILABLE ttFile THEN
      pcSegments = pcSegments + "|" + 
                   ttFile.tcFileName + "," + 
                   STRING(ttFile.tiFileNum).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initDefaultValues sObject 
PROCEDURE initDefaultValues :
/*------------------------------------------------------------------------------
  Purpose:    Retrieves information from the Registry to be used as the
              default values. Retrieves the Directory, the Filter , the
              recurse subdirectories. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDirectory AS CHARACTER  NO-UNDO.
DEFINE VARIABLE crecurse   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cfilter    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE sctn       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDelim     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFilterStd AS CHARACTER  NO-UNDO INIT "*.i,*.p,*.w,*.*":U .


{adeuib/tool.i}       /* Include this 1st - Defines &TOOL */

/* Define the section. */
sctn = "Pro":U + CAPS("{&TOOL}":U).

/* Default FALSE settings */
GET-KEY-VALUE SECTION sctn KEY "TempDBImport" VALUE cvalue.
/* Set the delimiter used to store default settings in registry */
ASSIGN cDelim = "|":U.
IF NUM-ENTRIES(cValue,cDelim) >= 3 THEN
    ASSIGN cDirectory = ENTRY(1,cValue,cDelim)
           cRecurse   = ENTRY(2,cValue,cDelim)
           cFilter    = ENTRY(3,cValue,cDelim)
           NO-ERROR.

DO WITH FRAME {&FRAME-NAME}:
ASSIGN 
  cDirectory            = IF cDirectory = "" THEN ".":U ELSE cDirectory
  cFilter               = IF cFilter    = "" 
                          THEN cFilterStd ELSE cFilter
  fiDir:SCREEN-VALUE    = cDirectory
  toRecurse:CHECKED     = (cRecurse = "True":U OR crecurse = "Yes":U)
  coFilter:LIST-ITEMS   = cFilter
  coFilter:SCREEN-VALUE = ENTRY(1,cFilter)
  NO-ERROR.
END.
  




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
                                   
 btnAllRight:LOAD-IMAGE("adeicon/bitlib.bmp",153,0,16,16) IN FRAME {&FRAME-NAME}.
 btnRight:LOAD-IMAGE("adeicon/bitlib.bmp",51,0,16,16) IN FRAME {&FRAME-NAME}.
 btnLeft:LOAD-IMAGE("adeicon/bitlib.bmp",34,0,16,16) IN FRAME {&FRAME-NAME}.
 btnAllLeft:LOAD-IMAGE("adeicon/bitlib.bmp",187,0,16,16) IN FRAME {&FRAME-NAME}.
 
 RUN SUPER.

 RUN initDefaultValues IN THIS-PROCEDURE.
 
 /* Determine whether Dynamics is running */
 ASSIGN glDynamicsIsRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.
 IF glDynamicsIsRunning = ? THEN glDynamicsIsRunning = NO.

 ASSIGN fiSelected:SCREEN-VALUE = "Selected Files"
        fiAll:SCREEN-VALUE      = "Fetched Files"
        seALL:DELIMITER         = CHR(3)
        seALL:LIST-ITEM-PAIRS    = ?
        seSelected:DELIMITER    = CHR(3)
        seSelected:LIST-ITEM-PAIRS = ?
        cbSegment:SIDE-LABEL-HANDLE:FONT = 6. 

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadSegment sObject 
PROCEDURE loadSegment :
/*------------------------------------------------------------------------------
  Purpose:     Loads a segment of files into the selection list, to be imported
               into the db.
  Parameters:  INPUT piStartFile INTEGER - First file in the segment
               INPUT piLastFile  INTEGER - Last file in the segment
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piStartFile AS INTEGER     NO-UNDO.
  DEFINE INPUT  PARAMETER piLastFile  AS INTEGER     NO-UNDO.

  /* PSC00325642-Not a segmented load. */
  IF piStartFile EQ ? THEN
    ASSIGN piStartFile = 0
           piLastFile  = 999999999.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN seAll:LIST-ITEM-PAIRS      = ?
           seSelected:LIST-ITEM-PAIRS = ?. 

    FOR EACH ttFile WHERE ttFile.tiFileNum GE piStartFile AND
                          ttFile.tiFileNum LE piLastFile:
      seAll:ADD-LAST(ttFile.tcFileName,ttFile.tcFullPath).
    END.
  
    IF seAll:NUM-ITEMS GT 0 THEN
      ASSIGN btnAllRight:SENSITIVE = TRUE.
    ELSE                                      
      ASSIGN btnAllRight:SENSITIVE = FALSE  
             btnRIght:SENSITIVE    = FALSE. 
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readDir sObject 
PROCEDURE readDir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT        PARAMETER pcDirectory AS CHARACTER   NO-UNDO.
  DEFINE INPUT        PARAMETER pcFilter    AS CHARACTER   NO-UNDO.
  DEFINE INPUT        PARAMETER plRecurse   AS LOGICAL     NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER piSegment   AS INTEGER     NO-UNDO.
  DEFINE OUTPUT       PARAMETER piDirLength AS INTEGER     NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcSegments  AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE cFile      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cRelname   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cFileName  AS CHARACTER   NO-UNDO EXTENT 3.
  DEFINE VARIABLE cFirstFile AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cSegment   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cFilter    AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE iDirLength AS INTEGER     NO-UNDO.

  INPUT FROM OS-DIR(pcDirectory).
  REPEAT:
    IMPORT cFileName.

    IF cFileName[1] EQ "." OR
       cFileName[1] EQ ".." THEN NEXT.

    IF INDEX(cFileName[3],"D") GT 0 AND
       plRecurse EQ TRUE THEN DO:
      RUN readDir ( INPUT        cFileName[2],
                    INPUT        pcFilter,
                    INPUT        plRecurse,
                    INPUT-OUTPUT piSegment,
                    OUTPUT       iDirLength,
                    INPUT-OUTPUT pcSegments ).
      piDirLength = piDirLength + iDirLength.
      NEXT.
    END.
    
    /* Exclude files not meeting the filter */
    cFilter = REPLACE(pcFilter," ",",").
    IF NOT CAN-DO(cFilter,cFileName[2]) THEN NEXT.
    
    cFile = cFileName[2].
    RUN adecomm/_relname.p (INPUT cFile, INPUT "MUST-BE-REL", OUTPUT cRelname).

    CREATE ttFile.
    ASSIGN ttFile.tcFileName = cRelName
           ttFile.tcFullPath = cFileName[2]
           giFileNum         = giFileNum + 1
           ttFile.tiFileNum  = giFileNum
           growLastFile      = ROWID(ttFile)
           piDirLength       = piDirLength + LENGTH(cRelname) + LENGTH(cFileName[2])
           piSegment         = piSegment   + LENGTH(cRelname) + LENGTH(cFileName[2])
           giLongestFilename = (IF LENGTH(cRelname) GT giLongestFileName THEN 
                                  LENGTH(cRelname)
                                ELSE giLongestFileName).

    /* If the first entry of the last CHR(1) delimited entry is empty, this is the first file in the segment */
    IF (pcSegments GT "") NE TRUE OR
       ((pcSegments GT "") EQ TRUE AND
        (ENTRY(1,ENTRY(NUM-ENTRIES(pcSegments,CHR(1)),pcSegments,CHR(1)),"|") GT "") NE TRUE) THEN
      pcSegments = pcSegments + cRelname + "," + STRING(ttFile.tiFileNum).
    
    IF piSegment GE 18000 THEN DO:
      ASSIGN pcSegments = pcSegments   + "|" + 
                          cRelName     + "," + 
                          STRING(ttFile.tiFileNum) + CHR(1)
             piSegment  = 0.
    END.
  END.
  INPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rebuildFromList sObject 
PROCEDURE rebuildFromList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE i           AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cList       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lInclude    AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.

  {get ContainerSource hContainer}.
  GET-KEY-VALUE SECTION  "ProAB":U KEY "TempDBUseInclude":U VALUE cValue.
  lInclude = IF cValue EQ ? THEN TRUE
             ELSE CAN-DO ("true,yes,on",cValue).
  DO i = 1 TO NUM-ENTRIES(seSelected:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME},seSelected:DELIMITER) BY 2:
      cList = cList + (IF cList = "" THEN "" ELSE ",") 
                    + ENTRY(i,seSelected:LIST-ITEM-PAIRS,seSelected:DELIMITER).
  END.

  DYNAMIC-FUNCTION("setInclude":U IN hContainer,lInclude).
  RUN RebuildImport IN hContainer (cList).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject sObject 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     Changes the size of a SmartDataViewer.
  Parameters:  pdHeight AS DECIMAL -- The desired height (in rows)
               pdWidth  AS DECIMAL -- The desired width (in columns)
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pdHeight AS DECIMAL NO-UNDO.
 DEFINE INPUT PARAMETER pdWidth  AS DECIMAL NO-UNDO.

 DEFINE VARIABLE cUIB   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hFrame AS HANDLE     NO-UNDO.

 &SCOPED-DEFINE Margin-Inside 2
 &SCOPED-DEFINE Margin-Outside 1
 &SCOPED-DEFINE Button-space .25

 {get UIBMode cUIB}.
 IF cUIB BEGINS "Design":U OR PROGRAM-NAME(2) BEGINS "adm-create-object":U THEN RETURN.

 ASSIGN hFrame                = FRAME {&FRAME-NAME}:HANDLE
        hFrame:SCROLLABLE     = TRUE
        hFrame:COL            = 1
        hFrame:WIDTH          = MAX(100,pdWidth - 2)
        hFrame:HEIGHT         = MAX(10,pdHeight - 2)
        hFrame:VIRTUAL-WIDTH  = hFrame:WIDTH
        hFrame:VIRTUAL-HEIGHT = hFrame:HEIGHT
        fiDir:WIDTH           = MAX(20,(hFrame:WIDTH - fiDir:COL - 20)/ 2)
        btnDir:COL            = fiDir:COL + fiDIr:WIDTH + .1
        toRecurse:COL         = btnDir:COL + btnDir:WIDTH + 1
        btnFetch:COL          = toRecurse:COL + toRecurse:WIDTH + .5
        RectBottom:WIDTH      = hFrame:WIDTH - RectBottom:COL 
        seAll:WIDTH           = MAX(10,(pdWidth - btnAllRight:WIDTH - ({&Margin-Inside} * 2)  - ({&Margin-Inside} * 2))/ 2 )
        seAll:HEIGHT          = MAX(4,hFrame:HEIGHT - seALL:ROW - .35)
        seALL:COL             = {&Margin-Outside}    
        seSelected:WIDTH      = seAll:WIDTH
        seSelected:HEIGHT     = seALL:HEIGHT
        seSelected:COL        = seALL:COL + seALL:WIDTH + btnRight:WIDTH + ({&Margin-Inside} * 2)
        fiAll:COL             = seAll:COL
        fiSelected:COL        = seSelected:COL
        btnRight:COL          = seAll:COL + seALL:WIDTH + {&Margin-Inside}
        btnAllRight:COL       = btnRight:COL
        btnAllLeft:COL        = btnRight:COL
        btnLeft:COL           = btnRight:COL
        btnAllRight:ROW       = seAll:ROW + (seAll:HEIGHT - (btnRight:HEIGHT * 4) - ({&Button-Space} * 3)) / 2
        btnRight:ROW          = btnAllRIght:ROW + btnAllRight:HEIGHT + {&Button-Space}
        btnLeft:ROW           = btnRight:ROW + btnRight:HEIGHT + {&Button-Space}
        btnAllLeft:ROW        = btnLeft:ROW + btnLeft:HEIGHT + {&Button-Space}
        btnRebuild:COL        = seSelected:COL + (seSelected:WIDTH / 2) - (btnRebuild:WIDTH / 2)
        btnRebuild:ROW        = seSelected:ROW + seSelected:HEIGHT + .2
        hFrame:SCROLLABLE     = FALSE
        cbSegment:X           = coFilter:X + coFilter:WIDTH-PIXELS + 95
        cbSegment:SIDE-LABEL-HANDLE:X = cbSegment:X - (LENGTH(cbSegment:LABEL) + 3)
        
       NO-ERROR.

                       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

