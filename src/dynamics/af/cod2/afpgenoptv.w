&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File:        ryclcstatusv.w
               This object viewer has a editor box to display the status
               of client cache generation.
               
  Description: from SMART.W - Template for basic ADM2 SmartObject

  Author:      Edsel Garcia
  Created:     11/05/2004

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
/* ***************************  Definitions  ************************** */

&scop object-name       ryclientcachelogv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes
{src/adm2/globals.i}

DEFINE VARIABLE ghContainerSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcDelimiter       AS CHARACTER  NO-UNDO INITIAL ",":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 ~
coGenerateSuperProcedure toGenerateSecurityCallsInline ~
toGenerateThinRendering toIncludeResultCodes seAvailable seSelected buAdd ~
buUp buRemove buDown buAddAll buTop buRemoveAll buBottom ~
toGenerateTranslationInline seLanguageAvailable seLanguageSelected ~
buLanguageAdd buLanguageRemove buLanguageAddAll buLanguageRemoveAll 
&Scoped-Define DISPLAYED-OBJECTS coGenerateSuperProcedure ~
toGenerateSecurityCallsInline toGenerateThinRendering toIncludeResultCodes ~
seAvailable seSelected toGenerateTranslationInline seLanguageAvailable ~
seLanguageSelected 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buAdd 
     LABEL "Add >" 
     SIZE 15.4 BY 1.14 TOOLTIP "Add available item"
     BGCOLOR 8 .

DEFINE BUTTON buAddAll 
     LABEL "Add All >>" 
     SIZE 15.4 BY 1.14 TOOLTIP "Add all available items"
     BGCOLOR 8 .

DEFINE BUTTON buBottom 
     LABEL "Bottom" 
     SIZE 15.4 BY 1.14 TOOLTIP "Move selected item to bottom"
     BGCOLOR 8 .

DEFINE BUTTON buDown 
     LABEL "Down" 
     SIZE 15.4 BY 1.14 TOOLTIP "Move selected item down"
     BGCOLOR 8 .

DEFINE BUTTON buLanguageAdd 
     LABEL "Add >" 
     SIZE 15.4 BY 1.14 TOOLTIP "Add available item"
     BGCOLOR 8 .

DEFINE BUTTON buLanguageAddAll 
     LABEL "Add All >>" 
     SIZE 15.4 BY 1.14 TOOLTIP "Add all available items"
     BGCOLOR 8 .

DEFINE BUTTON buLanguageRemove 
     LABEL "< Remove" 
     SIZE 15.4 BY 1.14 TOOLTIP "Remove selected item"
     BGCOLOR 8 .

DEFINE BUTTON buLanguageRemoveAll 
     LABEL "<< Remove All" 
     SIZE 15.4 BY 1.14 TOOLTIP "Remove all selected items"
     BGCOLOR 8 .

DEFINE BUTTON buRemove 
     LABEL "< Remove" 
     SIZE 15.4 BY 1.14 TOOLTIP "Remove selected item"
     BGCOLOR 8 .

DEFINE BUTTON buRemoveAll 
     LABEL "<< Remove All" 
     SIZE 15.4 BY 1.14 TOOLTIP "Remove all selected items"
     BGCOLOR 8 .

DEFINE BUTTON buTop 
     LABEL "Top" 
     SIZE 15.4 BY 1.14 TOOLTIP "Move selected item to top"
     BGCOLOR 8 .

DEFINE BUTTON buUp 
     LABEL "Up" 
     SIZE 15.4 BY 1.14 TOOLTIP "Move selected item up"
     BGCOLOR 8 .

DEFINE VARIABLE coGenerateSuperProcedure AS CHARACTER FORMAT "X(90)":U INITIAL "Constructor" 
     LABEL "Super procedure" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Constructor","Property" 
     DROP-DOWN-LIST
     SIZE 19 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 106 BY 1.86.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 106 BY 7.05.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 106 BY 7.19.

DEFINE VARIABLE seAvailable AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SORT SCROLLBAR-VERTICAL 
     SIZE 35 BY 5.52
     FONT 3 NO-UNDO.

DEFINE VARIABLE seLanguageAvailable AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SORT SCROLLBAR-VERTICAL 
     SIZE 35 BY 5.52
     FONT 3 NO-UNDO.

DEFINE VARIABLE seLanguageSelected AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     SIZE 35 BY 5.52
     FONT 3 NO-UNDO.

DEFINE VARIABLE seSelected AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     SIZE 35 BY 5.52
     FONT 3 NO-UNDO.

DEFINE VARIABLE toGenerateSecurityCallsInline AS LOGICAL INITIAL no 
     LABEL "Security" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .81 NO-UNDO.

DEFINE VARIABLE toGenerateThinRendering AS LOGICAL INITIAL no 
     LABEL "Thin rendering" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .81 NO-UNDO.

DEFINE VARIABLE toGenerateTranslationInline AS LOGICAL INITIAL no 
     LABEL "Translations" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .81 TOOLTIP "Include translation in generation of static objects" NO-UNDO.

DEFINE VARIABLE toIncludeResultCodes AS LOGICAL INITIAL no 
     LABEL "Customizations" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .81 TOOLTIP "Include translation in generation of static objects" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     coGenerateSuperProcedure AT ROW 1.91 COL 43.8
     toGenerateSecurityCallsInline AT ROW 2.1 COL 4
     toGenerateThinRendering AT ROW 2.1 COL 21
     toIncludeResultCodes AT ROW 3.38 COL 3.6
     seAvailable AT ROW 4.91 COL 3 NO-LABEL
     seSelected AT ROW 4.91 COL 55.8 NO-LABEL
     buAdd AT ROW 5.14 COL 39
     buUp AT ROW 5.14 COL 91.6
     buRemove AT ROW 6.48 COL 39
     buDown AT ROW 6.48 COL 91.6
     buAddAll AT ROW 7.81 COL 39
     buTop AT ROW 7.81 COL 91.6
     buRemoveAll AT ROW 9.14 COL 39
     buBottom AT ROW 9.14 COL 91.6
     toGenerateTranslationInline AT ROW 10.91 COL 3.6
     seLanguageAvailable AT ROW 12.38 COL 3 NO-LABEL
     seLanguageSelected AT ROW 12.38 COL 55.8 NO-LABEL
     buLanguageAdd AT ROW 12.62 COL 39
     buLanguageRemove AT ROW 13.95 COL 39
     buLanguageAddAll AT ROW 15.29 COL 39
     buLanguageRemoveAll AT ROW 16.67 COL 39
     "Selected" VIEW-AS TEXT
          SIZE 20 BY .62 AT ROW 11.67 COL 56.2
     "Available" VIEW-AS TEXT
          SIZE 20 BY .62 AT ROW 11.67 COL 3
     "Available" VIEW-AS TEXT
          SIZE 20 BY .62 AT ROW 4.19 COL 3
     "Generate options" VIEW-AS TEXT
          SIZE 17 BY .62 AT ROW 1.19 COL 3.6
     "Selected" VIEW-AS TEXT
          SIZE 20 BY .62 AT ROW 4.19 COL 55.8
     RECT-1 AT ROW 1.43 COL 2
     RECT-2 AT ROW 3.71 COL 2
     RECT-3 AT ROW 11.19 COL 2
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
         HEIGHT             = 21.19
         WIDTH              = 142.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX coGenerateSuperProcedure IN FRAME F-Main
   ALIGN-L                                                              */
ASSIGN 
       coGenerateSuperProcedure:HIDDEN IN FRAME F-Main           = TRUE.

ASSIGN 
       toGenerateSecurityCallsInline:HIDDEN IN FRAME F-Main           = TRUE.

ASSIGN 
       toGenerateThinRendering:HIDDEN IN FRAME F-Main           = TRUE.

ASSIGN 
       toGenerateTranslationInline:HIDDEN IN FRAME F-Main           = TRUE.

ASSIGN 
       toIncludeResultCodes:HIDDEN IN FRAME F-Main           = TRUE.

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

&Scoped-define SELF-NAME buAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAdd sObject
ON CHOOSE OF buAdd IN FRAME F-Main /* Add > */
OR MOUSE-SELECT-DBLCLICK OF seAvailable
DO:
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSel        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPos        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumItems   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cScreenVal  AS CHARACTER  NO-UNDO.

  DO iSel = 1 to NUM-ENTRIES(seAvailable:screen-value,gcDelimiter):
     cValue = ENTRY(iSel,seAvailable:screen-value,gcDelimiter).
     seSelected:ADD-LAST(cValue).
  END.
  ASSIGN cScreenVal = seAvailable:screen-value
         iNumItems  = NUM-ENTRIES(cScreenVal,gcDelimiter).
  DO iSel = 1 to iNumItems:
     ASSIGN cValue = ENTRY(iSel,cScreenVal,gcDelimiter)
            iPos   = seAvailable:LOOKUP(cScreenVal).
     seAvailable:DELETE(cValue).
     /* select the next entry if available, else select the previous entry */
     IF isel = iNumItems THEN
     DO:
        seAvailable:screen-value = seAvailable:ENTRY(iPos) NO-ERROR.
        IF seAvailable:ENTRY(iPos) = ? THEN
           seAvailable:SCREEN-VALUE = seAvailable:ENTRY(iPos - 1) NO-ERROR.
     END.
  END.
  APPLY "VALUE-CHANGED":U TO seAvailable.
  RUN buttonSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAddAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAddAll sObject
ON CHOOSE OF buAddAll IN FRAME F-Main /* Add All >> */
DO:
  DEFINE VARIABLE isel   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.

  DO iSel = 1 to seAvailable:NUM-ITEMS:
      cValue = ENTRY(iSel ,seAvailable:LIST-ITEMS,gcDelimiter).
      seSelected:ADD-LAST(cValue).
  END.
  seAvailable:LIST-ITEMS = "".
  APPLY "VALUE-CHANGED":U TO seAvailable.
  RUN buttonsensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buBottom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buBottom sObject
ON CHOOSE OF buBottom IN FRAME F-Main /* Bottom */
DO:
   DEFINE VARIABLE iSel           AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cSelectedItems AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cEntry         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cLabel         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hSelection     AS HANDLE     NO-UNDO.

   ASSIGN cSelectedItems = seSelected:SCREEN-VALUE.

   CREATE SELECTION-LIST hSelection
        ASSIGN FRAME     = FRAME {&FRAME-NAME}:HANDLE
               DELIMITER = seSelected:DELIMITER.

   ASSIGN hSelection:LIST-ITEMS = seSelected:LIST-ITEMS.

   DO isel = 1 TO seSelected:NUM-ITEMS  :
       cEntry = ENTRY(iSel,seSelected:LIST-ITEMS,gcDelimiter).
       IF LOOKUP(cEntry,seSelected:SCREEN-VALUE,gcDelimiter) > 0 THEN
       DO:
           hSelection:DELETE(cEntry).
           hSelection:ADD-LAST(cEntry).
       END.
   END.
    
   ASSIGN seSelected:LIST-ITEMS = hSelection:LIST-ITEMS.
   DELETE WIDGET hSelection.
   ASSIGN seSelected:SCREEN-VALUE = cSelectedItems.

   APPLY "VALUE-CHANGED":U TO seSelected.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDown sObject
ON CHOOSE OF buDown IN FRAME F-Main /* Down */
DO:
   DEFINE VARIABLE iSel           AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cNewList      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cSelectedItems AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cEntry         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cSwap          AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cSwapLabel     AS CHARACTER  NO-UNDO.

   ASSIGN cSelectedItems = seSelected:SCREEN-VALUE
          cNewList       = seSelected:LIST-ITEMS.
   DO isel = seSelected:NUM-ITEMS TO 1 BY -1:
      cEntry = ENTRY(iSel,seSelected:LIST-ITEMS,gcDelimiter).
      IF LOOKUP(cEntry,seSelected:SCREEN-VALUE,gcDelimiter) > 0 THEN 
      DO:
          ASSIGN cSwap   = ENTRY(iSel + 1,cNewList,gcDelimiter).
          ENTRY(isel + 1,cNewList,gcDelimiter) = cEntry.
          ENTRY(isel ,cNewList,gcDelimiter) = cSwap.
      END.    
   END.
   ASSIGN seSelected:LIST-ITEMS = cNewList.
   ASSIGN seSelected:SCREEN-VALUE = cSelectedItems.

   APPLY "VALUE-CHANGED":U TO seSelected.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buLanguageAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buLanguageAdd sObject
ON CHOOSE OF buLanguageAdd IN FRAME F-Main /* Add > */
OR MOUSE-SELECT-DBLCLICK OF seLanguageAvailable
DO:
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSel        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPos        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumItems   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cScreenVal  AS CHARACTER  NO-UNDO.

  DO iSel = 1 to NUM-ENTRIES(seLanguageAvailable:screen-value,gcDelimiter):
     cValue = ENTRY(iSel,seLanguageAvailable:screen-value,gcDelimiter).
     seLanguageSelected:ADD-LAST(cValue).
  END.
  ASSIGN cScreenVal = seLanguageAvailable:screen-value
         iNumItems  = NUM-ENTRIES(cScreenVal,gcDelimiter).
  DO iSel = 1 to iNumItems:
     ASSIGN cValue = ENTRY(iSel,cScreenVal,gcDelimiter)
            iPos   = seLanguageAvailable:LOOKUP(cScreenVal).
     seLanguageAvailable:DELETE(cValue).
     /* select the next entry if available, else select the previous entry */
     IF isel = iNumItems THEN
     DO:
        seLanguageAvailable:screen-value = seLanguageAvailable:ENTRY(iPos) NO-ERROR.
        IF seLanguageAvailable:ENTRY(iPos) = ? THEN
           seLanguageAvailable:SCREEN-VALUE = seLanguageAvailable:ENTRY(iPos - 1) NO-ERROR.
     END.
  END.
  APPLY "VALUE-CHANGED":U TO seLanguageAvailable.
  RUN buttonLanguageSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buLanguageAddAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buLanguageAddAll sObject
ON CHOOSE OF buLanguageAddAll IN FRAME F-Main /* Add All >> */
DO:
  DEFINE VARIABLE isel   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.

  DO iSel = 1 to seLanguageAvailable:NUM-ITEMS:
      cValue = ENTRY(iSel ,seLanguageAvailable:LIST-ITEMS,gcDelimiter).
      seLanguageSelected:ADD-LAST(cValue).
  END.
  seLanguageAvailable:LIST-ITEMS = "".
  APPLY "VALUE-CHANGED":U TO seLanguageAvailable.
  RUN buttonLanguageSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buLanguageRemove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buLanguageRemove sObject
ON CHOOSE OF buLanguageRemove IN FRAME F-Main /* < Remove */
OR MOUSE-SELECT-DBLCLICK OF seLanguageSelected
DO:
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSel        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPos        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumItems   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cScreenVal  AS CHARACTER  NO-UNDO.
  DO iSel = 1 to NUM-ENTRIES(seLanguageSelected:screen-value,gcDelimiter):
     cValue = ENTRY(iSel,seLanguageSelected:screen-value,gcDelimiter).
     seLanguageAvailable:ADD-LAST(cValue).
  END.
  ASSIGN cScreenVal = seLanguageSelected:screen-value
         iNumItems  = NUM-ENTRIES(cScreenVal,gcDelimiter).
  DO iSel = 1 to iNumItems:
     ASSIGN cValue = ENTRY(iSel,cScreenVal,gcDelimiter)
            iPos   = seLanguageSelected:LOOKUP(cScreenVal).
     seLanguageSelected:DELETE(cValue).
     /* select the next entry if available, else select the previous entry */
     IF isel = iNumItems THEN
     DO:
        seLanguageSelected:screen-value = seLanguageSelected:ENTRY(iPos) NO-ERROR.
        IF seLanguageSelected:ENTRY(iPos) = ? THEN
           seLanguageSelected:SCREEN-VALUE = seLanguageSelected:ENTRY(iPos - 1) NO-ERROR.
     END.
  END.
  APPLY "VALUE-CHANGED":U TO seLanguageSelected.
  RUN buttonLanguageSensitive. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buLanguageRemoveAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buLanguageRemoveAll sObject
ON CHOOSE OF buLanguageRemoveAll IN FRAME F-Main /* << Remove All */
DO:
  RUN ClearAllLanguage.
  RUN buttonLanguageSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRemove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRemove sObject
ON CHOOSE OF buRemove IN FRAME F-Main /* < Remove */
OR MOUSE-SELECT-DBLCLICK OF seSelected
DO:
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSel        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPos        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumItems   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cScreenVal  AS CHARACTER  NO-UNDO.
  DO iSel = 1 to NUM-ENTRIES(seSelected:screen-value,gcDelimiter):
     cValue = ENTRY(iSel,seSelected:screen-value,gcDelimiter).
     seAvailable:ADD-LAST(cValue).
  END.
  ASSIGN cScreenVal = seSelected:screen-value
         iNumItems  = NUM-ENTRIES(cScreenVal,gcDelimiter).
  DO iSel = 1 to iNumItems:
     ASSIGN cValue = ENTRY(iSel,cScreenVal,gcDelimiter)
            iPos   = seSelected:LOOKUP(cScreenVal).
     seSelected:DELETE(cValue).
     /* select the next entry if available, else select the previous entry */
     IF isel = iNumItems THEN
     DO:
        seSelected:screen-value = seSelected:ENTRY(iPos) NO-ERROR.
        IF seSelected:ENTRY(iPos) = ? THEN
           seSelected:SCREEN-VALUE = seSelected:ENTRY(iPos - 1) NO-ERROR.
     END.
  END.
  APPLY "VALUE-CHANGED":U TO seSelected.
  RUN buttonSensitive. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRemoveAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRemoveAll sObject
ON CHOOSE OF buRemoveAll IN FRAME F-Main /* << Remove All */
DO:
  RUN ClearAll.
  RUN buttonSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buTop
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buTop sObject
ON CHOOSE OF buTop IN FRAME F-Main /* Top */
DO:
   DEFINE VARIABLE iSel           AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cSelectedItems AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cEntry         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cLabel         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hSelection     AS HANDLE     NO-UNDO.

   ASSIGN cSelectedItems = seSelected:SCREEN-VALUE.

   CREATE SELECTION-LIST hSelection
        ASSIGN FRAME     = FRAME {&FRAME-NAME}:HANDLE
               DELIMITER = seSelected:DELIMITER.

   ASSIGN hSelection:LIST-ITEMS = seSelected:LIST-ITEMS.
         
   DO isel = seSelected:NUM-ITEMS TO 1 BY -1:
       cEntry = ENTRY(iSel,seSelected:LIST-ITEMS,gcDelimiter).
       IF LOOKUP(cEntry,seSelected:SCREEN-VALUE,gcDelimiter) > 0 THEN
       DO:
           hSelection:DELETE(cEntry).
           hSelection:ADD-FIRST(cEntry).
       END.
    END.
    ASSIGN seSelected:LIST-ITEMS = hSelection:LIST-ITEMS.   
    DELETE WIDGET hSelection.
    ASSIGN seSelected:SCREEN-VALUE = cSelectedItems.

    APPLY "VALUE-CHANGED":U TO seSelected.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buUp sObject
ON CHOOSE OF buUp IN FRAME F-Main /* Up */
DO:
   DEFINE VARIABLE iSel           AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cNewList      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cSelectedItems AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cEntry         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cSwap          AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cSwapLabel     AS CHARACTER  NO-UNDO.

   ASSIGN cSelectedItems = seSelected:SCREEN-VALUE
          cNewList       = seSelected:LIST-ITEMS.
   DO isel = 1 TO seSelected:NUM-ITEMS:
      cEntry = ENTRY(iSel,seSelected:LIST-ITEMS,gcDelimiter).
      IF LOOKUP(cEntry,seSelected:SCREEN-VALUE,gcDelimiter) > 0 THEN 
      DO:
          ASSIGN cSwap = ENTRY(iSel - 1,cNewList,gcDelimiter).
          ENTRY(isel - 1,cNewList,gcDelimiter) = cEntry.
          ENTRY(isel ,cNewList,gcDelimiter) = cSwap.
      END.        
   END.
   ASSIGN seSelected:LIST-ITEMS = cNewList.
   ASSIGN seSelected:SCREEN-VALUE = cSelectedItems.

   APPLY "VALUE-CHANGED":U TO seSelected.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seAvailable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seAvailable sObject
ON VALUE-CHANGED OF seAvailable IN FRAME F-Main
DO:
  SeSelected:screen-value = "".
  RUN buttonSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seLanguageAvailable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seLanguageAvailable sObject
ON VALUE-CHANGED OF seLanguageAvailable IN FRAME F-Main
DO:
  SeLanguageSelected:screen-value = "".
  RUN buttonLanguageSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seLanguageSelected
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seLanguageSelected sObject
ON VALUE-CHANGED OF seLanguageSelected IN FRAME F-Main
DO:
  DEFINE VARIABLE iSel        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lMoveUp     AS LOGICAL    NO-UNDO INIT YES.
  DEFINE VARIABLE lMoveDown   AS LOGICAL    NO-UNDO INIT YES.

  seLanguageAvailable:screen-value = "".
  IF SELF:SCREEN-VALUE <> ? THEN 
  DO:
    DO isel = 1 TO NUM-ENTRIES(seLanguageSelected:screen-value,gcDelimiter):
       cValue = ENTRY(iSel,seLanguageSelected:screen-value,gcDelimiter).
       IF seLanguageSelected:LOOKUP(cValue) = 1 THEN
          lMoveUp = NO.
       IF seLanguageSelected:LOOKUP(cValue) = seSelected:NUM-ITEMS THEN
          lMoveDown = NO.
    END.
  END.
  RUN buttonLanguageSensitive.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seSelected
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seSelected sObject
ON VALUE-CHANGED OF seSelected IN FRAME F-Main
DO:
  seAvailable:screen-value = "".
  RUN buttonSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toGenerateTranslationInline
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toGenerateTranslationInline sObject
ON VALUE-CHANGED OF toGenerateTranslationInline IN FRAME F-Main /* Translations */
DO:
  RUN setTranslationSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toIncludeResultCodes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toIncludeResultCodes sObject
ON VALUE-CHANGED OF toIncludeResultCodes IN FRAME F-Main /* Customizations */
DO:
  RUN setResultCodesSensitive.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buttonLanguageSensitive sObject 
PROCEDURE buttonLanguageSensitive :
/*------------------------------------------------------------------------------
  Purpose:     Sets the sensitivity of the buttons based on the screen value
               and contents of the selection lists
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:
     ASSIGN
         buLanguageAdd:SENSITIVE         = IF seLanguageAvailable:SCREEN-VALUE  = ? THEN FALSE ELSE TRUE
         buLanguageAddAll:SENSITIVE      = IF seLanguageAvailable:LIST-ITEMS > "" THEN TRUE ELSE FALSE
         buLanguageRemove:SENSITIVE      = IF seLanguageSelected:SCREEN-VALUE = ? THEN FALSE ELSE TRUE  
         buLanguageRemoveAll:SENSITIVE   = IF seLanguageSelected:LIST-ITEMS > "" THEN TRUE ELSE FALSE
     NO-ERROR.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buttonSensitive sObject 
PROCEDURE buttonSensitive :
/*------------------------------------------------------------------------------
  Purpose:     Sets the sensitivity of the buttons based on the screen value
               and contents of the selection lists
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iSel        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lMoveUp     AS LOGICAL    NO-UNDO INIT YES.
  DEFINE VARIABLE lMoveDown   AS LOGICAL    NO-UNDO INIT YES.

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          buAdd:SENSITIVE         = IF seAvailable:SCREEN-VALUE  = ? THEN FALSE ELSE TRUE
          buAddAll:SENSITIVE      = IF seAvailable:LIST-ITEMS > "" THEN TRUE ELSE FALSE
          buRemove:SENSITIVE      = IF seSelected:SCREEN-VALUE = ? THEN FALSE ELSE TRUE  
          buRemoveAll:SENSITIVE   = IF seSelected:LIST-ITEMS > "" THEN TRUE ELSE FALSE
      NO-ERROR.

      IF seSelected:SCREEN-VALUE <> ? THEN 
      DO:
        DO isel = 1 TO NUM-ENTRIES(seSelected:screen-value,gcDelimiter):
           cValue = ENTRY(iSel,seSelected:screen-value,gcDelimiter).
           IF seSelected:LOOKUP(cValue) = 1 THEN
              lMoveUp = NO.
           IF seSelected:LOOKUP(cValue) = seSelected:NUM-ITEMS THEN
              lMoveDown = NO.
        END.
    
        ASSIGN  buTop:SENSITIVE        = lMoveUp
                buUp:SENSITIVE         = lMoveUp
                buDown:sensitive       = lMoveDown
                buBottom:sensitive     = lMoveDown.
      END.
      ELSE 
          ASSIGN  buTop:SENSITIVE        = FALSE
                  buUp:SENSITIVE         = FALSE
                  buDown:sensitive       = FALSE
                  buBottom:sensitive     = FALSE.
END.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearAll sObject 
PROCEDURE clearAll :
/*------------------------------------------------------------------------------
  Purpose:     To reset to default layout by removing all customization codes
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE isel   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel AS CHARACTER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    DO iSel = 1 to seSelected:NUM-ITEMS:
        cValue = ENTRY(iSel ,seSelected:LIST-ITEMS,gcDelimiter).
        seAvailable:ADD-LAST(cValue).
    END.
    seSelected:LIST-ITEMS = "".
    APPLY "VALUE-CHANGED":U TO seSelected.
    RUN buttonSensitive.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearAllLanguage sObject 
PROCEDURE clearAllLanguage :
/*------------------------------------------------------------------------------
  Purpose:     To reset to default layout by removing all customization codes
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE isel   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel AS CHARACTER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    DO iSel = 1 to seLanguageSelected:NUM-ITEMS:
        cValue = ENTRY(iSel ,seLanguageSelected:LIST-ITEMS,gcDelimiter).
        seLanguageAvailable:ADD-LAST(cValue).
    END.
    seLanguageSelected:LIST-ITEMS = "".
    APPLY "VALUE-CHANGED":U TO seLanguageSelected.
    RUN buttonLanguageSensitive.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLanguages sObject 
PROCEDURE getLanguages :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcLanguages AS CHARACTER NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
        IF toGenerateTranslationInline:CHECKED AND seLanguageSelected:LIST-ITEMS > "" THEN
            pcLanguages = replace(seLanguageSelected:LIST-ITEMS, gcDelimiter, ',').
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getOptions sObject 
PROCEDURE getOptions :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcOptions AS CHARACTER NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
        IF toGenerateTranslationInline:CHECKED THEN
            pcOptions = "generatetranslations":U.
        IF toGenerateSecurityCallsInline:CHECKED THEN
            pcOptions = pcOptions + ",generatesecurity":U.
        IF toGenerateThinRendering:CHECKED THEN
            pcOptions = pcOptions + ",generatethinrendering":U.
        pcOptions = TRIM(pcOptions, ",":U).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getResultCodes sObject 
PROCEDURE getResultCodes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcResultCodes AS CHARACTER NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
        IF toIncludeResultCodes:CHECKED AND seSelected:LIST-ITEMS > "" THEN
            ASSIGN pcResultCodes = REPLACE(seSelected:LIST-ITEMS, "[DEFAULT-RESULT-CODE]":U,"DEFAULT-RESULT-CODE":U)
                   pcResultCodes = REPLACE(pcResultCodes, gcDelimiter, ",").
        ELSE
            pcResultCodes = "DEFAULT-RESULT-CODE":U.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSuperProcedureLocation sObject 
PROCEDURE getSuperProcedureLocation :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcSuperProcedureLocation AS CHARACTER NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
        pcSuperProcedureLocation = coGenerateSuperProcedure:SCREEN-VALUE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeData sObject 
PROCEDURE initializeData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN coGenerateSuperProcedure:SCREEN-VALUE = "Constructor":U.

      ASSIGN toGenerateSecurityCallsInline:CHECKED = TRUE
             toGenerateThinRendering:CHECKED       = TRUE
             toIncludeResultCodes:CHECKED         = TRUE
             toGenerateTranslationInline:CHECKED   = TRUE.

      gcDelimiter = CHR(3).
      ASSIGN seAvailable:DELIMITER         = gcDelimiter
             seSelected:DELIMITER          = gcDelimiter
             seLanguageAvailable:DELIMITER = gcDelimiter
             seLanguageSelected:DELIMITER  = gcDelimiter.
      
      FOR EACH ryc_customization_result NO-LOCK BY ryc_customization_result.customization_result_code:
          seAvailable:ADD-LAST(ryc_customization_result.customization_result_code).
      END.
      seSelected:LIST-ITEMS = "[DEFAULT-RESULT-CODE]":U.

      FOR EACH gsc_language NO-LOCK BY language_code:
          seLanguageSelected:ADD-LAST(gsc_language.language_code).
      END.
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

  DO WITH FRAME {&FRAME-NAME}:
      buAddAll:LOAD-IMAGE("ry/img/bitlib.bmp",153,0,16,16).
      buAdd:LOAD-IMAGE("ry/img/bitlib.bmp",51,0,16,16).
      buRemove:LOAD-IMAGE("ry/img/bitlib.bmp",34,0,16,16).
      buRemoveAll:LOAD-IMAGE("ry/img/bitlib.bmp",187,0,16,16).
      buLanguageAddAll:LOAD-IMAGE("ry/img/bitlib.bmp",153,0,16,16).
      buLanguageAdd:LOAD-IMAGE("ry/img/bitlib.bmp",51,0,16,16).
      buLanguageRemove:LOAD-IMAGE("ry/img/bitlib.bmp",34,0,16,16).
      buLanguageRemoveAll:LOAD-IMAGE("ry/img/bitlib.bmp",187,0,16,16).
      buUp:LOAD-IMAGE("ry/img/bitlib.bmp",0,0,16,16).
      buDown:LOAD-IMAGE("ry/img/bitlib.bmp",17,0,16,16).
      buTop:LOAD-IMAGE("ry/img/bitlib.bmp",68,0,16,16).
      buBottom:LOAD-IMAGE("ry/img/bitlib.bmp",85,0,16,16).
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  RUN initializeData IN TARGET-PROCEDURE.
  
  ENABLE ALL WITH FRAME F-main.
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
           buRemove:SENSITIVE            = FALSE
           buRemoveAll:SENSITIVE         = FALSE
           buTop:SENSITIVE               = FALSE
           buUp:SENSITIVE                = FALSE
           buDown:SENSITIVE              = FALSE
           buBottom:SENSITIVE            = FALSE
           buLanguageRemove:SENSITIVE    = FALSE
           buLanguageRemoveAll:SENSITIVE = FALSE.
  END.
  RUN buttonSensitive.
  RUN buttonLanguageSensitive.

  IF VALID-HANDLE(ghContainerSource) THEN
  DO:
      SUBSCRIBE TO "getLanguages":U              IN ghContainerSource.
      SUBSCRIBE TO "getResultCodes":U            IN ghContainerSource.
      SUBSCRIBE TO "getOptions":U                IN ghContainerSource.
      SUBSCRIBE TO "getSuperProcedureLocation":U IN ghContainerSource.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkStateHandler sObject 
PROCEDURE linkStateHandler :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER phObject AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER pcLink   AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcState, INPUT phObject, INPUT pcLink).

  /* Code placed here will execute AFTER standard behavior.    */

  /* Set the handle of the container source immediately upon making the link */
  IF pcLink = "ContainerSource":U AND pcState = "Add":U THEN
     ASSIGN ghContainerSource = phObject.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject sObject 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pdHeight             AS DECIMAL          NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth              AS DECIMAL          NO-UNDO.

  DEFINE VARIABLE iCurrentPage                AS INTEGER          NO-UNDO.
  DEFINE VARIABLE lHidden                     AS LOGICAL          NO-UNDO.  

  DEFINE VARIABLE hLabelHandle                AS HANDLE           NO-UNDO.

  RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setResultCodesSensitive sObject 
PROCEDURE setResultCodesSensitive :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:
     IF toIncludeResultCodes:CHECKED THEN
     DO:
         ASSIGN seAvailable:SENSITIVE = TRUE
                seSelected:SENSITIVE  = TRUE.
         RUN buttonSensitive.
     END.
     ELSE
         ASSIGN seAvailable:SENSITIVE = FALSE
                seSelected:SENSITIVE  = FALSE
                buAdd:SENSITIVE       = FALSE
                buAddAll:SENSITIVE    = FALSE
                buRemove:SENSITIVE    = FALSE
                buRemoveAll:SENSITIVE = FALSE
                buBottom:SENSITIVE    = FALSE
                buDown:SENSITIVE      = FALSE
                buTop:SENSITIVE       = FALSE
                buUp:SENSITIVE        = FALSE.
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTranslationSensitive sObject 
PROCEDURE setTranslationSensitive :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:
     IF toGenerateTranslationInline:CHECKED THEN
     DO:
         ASSIGN seLanguageAvailable:SENSITIVE = TRUE
                seLanguageSelected:SENSITIVE  = TRUE.
         RUN buttonLanguageSensitive.
     END.
     ELSE
         ASSIGN seLanguageAvailable:SENSITIVE = FALSE
                seLanguageSelected:SENSITIVE  = FALSE
                buLanguageAdd:SENSITIVE       = FALSE
                buLanguageAddAll:SENSITIVE    = FALSE
                buLanguageRemove:SENSITIVE    = FALSE
                buLanguageRemoveAll:SENSITIVE = FALSE.
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

