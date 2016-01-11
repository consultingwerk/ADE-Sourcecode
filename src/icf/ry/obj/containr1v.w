&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*------------------------------------------------------------------------

  File:

  Description: from SMART.W - Template for basic ADM2 SmartObject

  Author:
  Created:

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
{ afglobals.i }
{ ry/app/containeri.i }

DEFINE VARIABLE ghContainerSource           AS HANDLE                   NO-UNDO.
DEFINE VARIABLE gcContainerObjectTypeCode   AS CHARACTER                NO-UNDO.
DEFINE VARIABLE gdRelativeLayoutObj         AS DECIMAL                  NO-UNDO.
DEFINE VARIABLE giMaxPage                   AS INTEGER                  NO-UNDO     INITIAL 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coLayout fiPageLabel buLookupPageTemplate ~
fiSecurityToken toEnableView toEnableModify toEnableCreate buAddPage 
&Scoped-Define DISPLAYED-OBJECTS coLayout fiPageSequence fiPageLabel ~
fiPageTemplate fiSecurityToken toEnableView toEnableModify toEnableCreate 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buAddPage 
     LABEL "&Add" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buApply 
     LABEL "Appl&y" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buDeletePage 
     LABEL "&Delete" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buLookupPageTemplate 
     IMAGE-UP FILE "ry/img/affind.gif":U
     LABEL "" 
     SIZE 4.8 BY 1 TOOLTIP "Lookup the container to use"
     BGCOLOR 8 .

DEFINE VARIABLE coLayout AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Page Layout" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1",0.00
     DROP-DOWN-LIST
     SIZE 47.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiPageLabel AS CHARACTER FORMAT "x(28)":U 
     LABEL "Page Label" 
     VIEW-AS FILL-IN 
     SIZE 38.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiPageSequence AS INTEGER FORMAT "->9":U INITIAL 0 
     LABEL "Page Sequence" 
     VIEW-AS FILL-IN 
     SIZE 7.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiPageTemplate AS CHARACTER FORMAT "X(70)":U 
     LABEL "Page Template" 
     VIEW-AS FILL-IN 
     SIZE 42.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiSecurityToken AS CHARACTER FORMAT "x(28)":U 
     LABEL "Security Token" 
     VIEW-AS FILL-IN 
     SIZE 38.6 BY 1 NO-UNDO.

DEFINE VARIABLE toEnableCreate AS LOGICAL INITIAL no 
     LABEL "Create" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.6 BY .81 NO-UNDO.

DEFINE VARIABLE toEnableModify AS LOGICAL INITIAL no 
     LABEL "Modify" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.2 BY .81 NO-UNDO.

DEFINE VARIABLE toEnableView AS LOGICAL INITIAL no 
     LABEL "View" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     coLayout AT ROW 1.19 COL 83 COLON-ALIGNED
     fiPageSequence AT ROW 1.29 COL 19 COLON-ALIGNED
     fiPageLabel AT ROW 2.33 COL 19 COLON-ALIGNED
     fiPageTemplate AT ROW 2.33 COL 83 COLON-ALIGNED
     buLookupPageTemplate AT ROW 2.33 COL 127.6
     fiSecurityToken AT ROW 3.43 COL 19 COLON-ALIGNED
     toEnableView AT ROW 3.48 COL 85
     toEnableModify AT ROW 3.48 COL 98.6
     toEnableCreate AT ROW 3.48 COL 113.4
     buAddPage AT ROW 4.43 COL 101
     buDeletePage AT ROW 4.43 COL 116.6
     buApply AT ROW 4.43 COL 132.2
     "Enable on:" VIEW-AS TEXT
          SIZE 11.2 BY .62 AT ROW 3.57 COL 73.2
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
         HEIGHT             = 4.57
         WIDTH              = 146.2.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON buApply IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buDeletePage IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiPageSequence IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiPageTemplate IN FRAME F-Main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME buAddPage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAddPage sObject
ON CHOOSE OF buAddPage IN FRAME F-Main /* Add */
DO:
DO ON ERROR UNDO, RETURN NO-APPLY:
    RUN addPage.
END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buApply
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buApply sObject
ON CHOOSE OF buApply IN FRAME F-Main /* Apply */
DO:
DO ON ERROR UNDO, RETURN NO-APPLY:
    RUN applyChanges.
END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeletePage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeletePage sObject
ON CHOOSE OF buDeletePage IN FRAME F-Main /* Delete */
DO:
DO ON ERROR UNDO, RETURN NO-APPLY:
    RUN deletePage.
    RUN applyChanges.
END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buLookupPageTemplate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buLookupPageTemplate sObject
ON CHOOSE OF buLookupPageTemplate IN FRAME F-Main
DO:
    DEFINE VARIABLE cObjectFilename         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE dLayoutObj              AS DECIMAL                  NO-UNDO.

    ASSIGN dLayoutObj = coLayout:INPUT-VALUE.

    RUN ry/uib/containrtd.w ( INPUT        (IF fiPageLabel:SENSITIVE THEN "PAG":U ELSE "WIN":U),
                              INPUT-OUTPUT dLayoutObj,
                              INPUT-OUTPUT cObjectFilename  ) NO-ERROR.
    IF cObjectFilename NE "":U THEN
        ASSIGN fiPageTemplate:SCREEN-VALUE = cObjectFilename
               coLayout:SCREEN-VALUE       = STRING(dLayoutObj)
               buApply:SENSITIVE           = YES
               .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coLayout sObject
ON VALUE-CHANGED OF coLayout IN FRAME F-Main /* Page Layout */
DO:    
    ASSIGN buApply:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPageSequence
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPageSequence sObject
ON VALUE-CHANGED OF fiPageSequence IN FRAME F-Main /* Page Sequence */
, fiPageLabel, fiSecurityToken, toEnableView, toEnableModify, toEnableCreate
, fiPageTemplate
DO:
    ASSIGN buApply:SENSITIVE = YES. 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addPage sObject 
PROCEDURE addPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER ttPage                FOR ttPage.

    DO WITH FRAME {&FRAME-NAME}:
        /* Get rid of the old data. */
        EMPTY TEMP-TABLE ttPage.
    
        CREATE ttPage.
        ASSIGN ttPage.tAction              = "NEW":U
               ttPage.tLocalSequence       = RANDOM(6,21) * ETIME * -1
               ttPage.tUpdateContainer     = YES
               buApply:SENSITIVE           = YES
               fiPageLabel:SENSITIVE       = YES
               fiPageSequence:SENSITIVE    = YES
               fiPageSequence:SCREEN-VALUE = IF giMaxPage EQ 0 THEN STRING(0) ELSE STRING(giMaxPage + 1)
               fiSecurityToken:SENSITIVE   = YES
               fiPageTemplate:SCREEN-VALUE = "":U
               buApply:SENSITIVE           = YES
               buDeletePage:SENSITIVE      = NO
               coLayout:SCREEN-VALUE       = STRING(gdRelativeLayoutObj)               
               .
        
        IF fiPageSequence:INPUT-VALUE EQ ? THEN
            ASSIGN fiPageSequence:SCREEN-VALUE = STRING(1).

        APPLY "ENTRY":U TO fiPageSequence IN FRAME {&FRAME-NAME}.
    END.    /* with frame ... */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyChanges sObject 
PROCEDURE applyChanges :
/*------------------------------------------------------------------------------
  Purpose:     Applies changes made in this viewer to the Page browse.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cButtonPressed          AS CHARACTER                NO-UNDO.

    FIND FIRST ttPage NO-ERROR.

    IF AVAILABLE ttPage THEN
    DO WITH FRAME {&FRAME-NAME}:
        IF NOT ttPage.tUpdateContainer THEN
            ASSIGN ttPage.tUpdateContainer = (ttPage.tLayoutTemplateObject NE fiPageTemplate:INPUT-VALUE).

        /* Validate */
        IF ttPage.tUpdateContainer                  AND
           ( fiPageTemplate:INPUT-VALUE EQ "":U OR
             fiPageTemplate:INPUT-VALUE EQ ?      ) THEN
        DO:
            RUN showMessages IN gshSessionManager (INPUT  "Please specifiy a Page Template Object.",
                                                   INPUT  "ERR",                    /* error type */
                                                   INPUT  "&OK",                    /* button list */
                                                   INPUT  "&OK",                    /* default button */ 
                                                   INPUT  "&OK",                    /* cancel button */
                                                   INPUT  "Validation Error",       /* error window title */
                                                   INPUT  YES,                      /* display if empty */ 
                                                   INPUT  ?,                        /* container handle */ 
                                                   OUTPUT cButtonPressed       ).   /* button pressed */
            RETURN ERROR.
        END.    /* no template object specified. */

        IF ttPage.tAction NE "DEL":U THEN
            ASSIGN ttPage.tPageLabel            = fiPageLabel:INPUT-VALUE
                   ttPage.tSecurityToken        = fiSecurityToken:INPUT-VALUE
                   ttPage.tLayoutObj            = coLayout:INPUT-VALUE
                   ttPage.tEnableOnView         = toEnableView:CHECKED
                   ttPage.tEnableOnModify       = toEnableModify:CHECKED
                   ttPage.tEnableOnCreate       = toEnableCreate:CHECKED
                   ttPage.tLayoutTemplateObject = fiPageTemplate:INPUT-VALUE
                   ttPage.tPageSequence         = fiPageSequence:INPUT-VALUE
                   .
        IF VALID-HANDLE(ghContainerSource)                                 AND
           LOOKUP("updatePage":U, ghContainerSource:INTERNAL-ENTRIES) NE 0 THEN
        DO:
            RUN updatePage IN ghContainerSource (INPUT TABLE ttPage) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR.
        END.
    END.    /* avail ttPage */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deletePage sObject 
PROCEDURE deletePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER ttPage            FOR ttPage.

    FIND FIRST ttPage NO-ERROR.
    IF AVAILABLE ttPage THEN
        ASSIGN ttPage.tAction = "DEL":U.

    RETURN.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    {get ContainerSource ghContainerSource}.

    ASSIGN gcContainerObjectTypeCode = DYNAMIC-FUNCTION("getContainerType":U IN ghContainerSource)
           NO-ERROR.

    /* Populate combos. */
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN coLayout:DELIMITER = CHR(3).
    END.    /* with frame ... */

    RUN SUPER.

    RUN populateCombos.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateCombos sObject 
PROCEDURE populateCombos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hCombo          AS HANDLE                           NO-UNDO.
    DEFINE VARIABLE cLipString      AS CHARACTER                        NO-UNDO.

    DEFINE BUFFER ryc_layout            FOR ryc_layout.

    /* Layout */
    ASSIGN hCombo     = coLayout:HANDLE IN FRAME {&FRAME-NAME}
           cLipString = "":U
           .
    FOR EACH ryc_layout
             NO-LOCK
             BY ryc_layout.layout_name:
        IF ryc_layout.layout_name BEGINS "RELATIVE":U THEN
            ASSIGN gdRelativeLayoutObj = ryc_layout.layout_obj.

        ASSIGN cLipString = cLipString + (IF NUM-ENTRIES(cLipString, hCombo:DELIMITER) EQ 0 THEN "":U ELSE hCombo:DELIMITER) 
                          + (ryc_layout.layout_name + hCombo:DELIMITER + STRING(ryc_layout.layout_obj)).
    END.    /* Layout */

    ASSIGN hCombo:LIST-ITEM-PAIRS = cLipString
           hCombo:SCREEN-VALUE    = hCombo:ENTRY(1)
           NO-ERROR.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RecordChange sObject 
PROCEDURE RecordChange :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR ttPage.
    
    FIND FIRST ttPage NO-ERROR.

    IF AVAILABLE ttPage THEN
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN fiPageLabel:SCREEN-VALUE     = ttPage.tPageLabel
               fiSecurityToken:SCREEN-VALUE = ttPage.tSecurityToken
               coLayout:SCREEN-VALUE        = STRING(ttPage.tLayoutObj)
               toEnableView:CHECKED         = ttPage.tEnableOnView
               toEnableModify:CHECKED       = ttPage.tEnableOnModify
               toEnableCreate:CHECKED       = ttPage.tEnableOnCreate
               fiPageTemplate:SCREEN-VALUE  = ttPage.tLayoutTemplateObject
               fiPageSequence:SCREEN-VALUE  = STRING(ttPage.tPageSequence)
               giMaxPage                    = MAX(giMaxPage, ttPage.tPageSequence)
               NO-ERROR.
        IF ttPage.tIsPageZero THEN
            ASSIGN fiPageLabel:SENSITIVE     = NO
                   fiSecurityToken:SENSITIVE = NO
                   fiPageSequence:SENSITIVE  = NO
                   .
        ELSE
            ASSIGN fiPageLabel:SENSITIVE     = YES
                   fiSecurityToken:SENSITIVE = YES
                   fiPageSequence:SENSITIVE  = YES
                   .
    END.    /* avail ttPage */

    ASSIGN buApply:SENSITIVE      = NO
           buAddPage:SENSITIVE    = YES
           buDeletePage:SENSITIVE = (AVAILABLE ttPage)
           coLayout:SENSITIVE     = NO
           .
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

