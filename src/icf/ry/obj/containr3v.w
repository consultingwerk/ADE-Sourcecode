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
{ af/sup2/afglobals.i }
{ ry/app/containeri.i }

DEFINE VARIABLE ghContainerSource            AS HANDLE                   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coSourceObject coLinkName coTargetObject ~
buAddLink 
&Scoped-Define DISPLAYED-OBJECTS coSourceObject coLinkName coTargetObject 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setInstanceObjects sObject 
FUNCTION setInstanceObjects RETURNS LOGICAL
    ( INPUT pcObjectNames       AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buAddLink 
     LABEL "&Add" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buApply 
     LABEL "Appl&y" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buDeleteLink 
     LABEL "&Delete" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE coLinkName AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Link" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 130 BY 1 NO-UNDO.

DEFINE VARIABLE coSourceObject AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Source" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 130 BY 1 NO-UNDO.

DEFINE VARIABLE coTargetObject AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Target" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 130 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     coSourceObject AT ROW 1.14 COL 7
     coLinkName AT ROW 2.14 COL 9.8
     coTargetObject AT ROW 3.19 COL 7.6
     buAddLink AT ROW 4.38 COL 101.2
     buDeleteLink AT ROW 4.38 COL 116.2
     buApply AT ROW 4.38 COL 131.2
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
         WIDTH              = 145.4.
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
/* SETTINGS FOR BUTTON buDeleteLink IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coLinkName IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX coSourceObject IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX coTargetObject IN FRAME F-Main
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

&Scoped-define SELF-NAME buAddLink
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAddLink sObject
ON CHOOSE OF buAddLink IN FRAME F-Main /* Add */
DO:
DO ON ERROR UNDO, RETURN NO-APPLY:
    RUN addLinkRecord.
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


&Scoped-define SELF-NAME buDeleteLink
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeleteLink sObject
ON CHOOSE OF buDeleteLink IN FRAME F-Main /* Delete */
DO:
DO ON ERROR UNDO, RETURN NO-APPLY:
    RUN deleteLink.
    RUN applyChanges.
END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coLinkName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coLinkName sObject
ON VALUE-CHANGED OF coLinkName IN FRAME F-Main /* Link */
, coSourceObject, coTargetObject
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addLinkRecord sObject 
PROCEDURE addLinkRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER ttLink                FOR ttLink.

    EMPTY TEMP-TABLE ttLink.

    CREATE ttLink.
    ASSIGN ttLink.tAction                                  = "NEW":U
           buApply:SENSITIVE        IN FRAME {&FRAME-NAME} = YES
           buDeleteLink:SENSITIVE   IN FRAME {&FRAME-NAME} = NO
           coSourceObject:SENSITIVE IN FRAME {&FRAME-NAME} = YES
           coTargetObject:SENSITIVE IN FRAME {&FRAME-NAME} = YES
           coLinkName:SENSITIVE     IN FRAME {&FRAME-NAME} = YES
           .
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

    DO WITH FRAME {&FRAME-NAME}:
        FIND FIRST ttLink NO-ERROR.
        IF AVAILABLE ttLink THEN
        DO:
            IF ttLink.tAction NE "DEL":U THEN
            DO WITH FRAME  {&FRAME-NAME}:            
                ASSIGN ttLink.tLinkName          = coLinkName:SCREEN-VALUE 
                       ttLink.tSourceId = coSourceObject:INPUT-VALUE
                       ttLink.tTargetId = coTargetObject:INPUT-VALUE
                       NO-ERROR.

                /* Cannot link an object to itself. */
                IF coSourceObject:INPUT-VALUE EQ coTargetObject:INPUT-VALUE THEN
                DO:
                    RUN showMessages IN gshSessionManager (INPUT  {af/sup2/aferrortxt.i 'AF' '40' '?' '?' '"The source and target cannot be the same object."' },
                                                           INPUT  "ERR",          /* error type */
                                                           INPUT  "&OK",    /* button list */
                                                           INPUT  "&OK",           /* default button */ 
                                                           INPUT  "&OK",       /* cancel button */
                                                           INPUT  "Validation Error",             /* error window title */
                                                           INPUT  YES,              /* display if empty */ 
                                                           INPUT  ghContainerSource,                /* container handle */
                                                           OUTPUT cButtonPressed       ).    /* button pressed */
                    RETURN ERROR.
                END.    /* source = target */
            END.    /* n/e DEL */
        END.    /* action not DEL */

        IF VALID-HANDLE(ghContainerSource)                                       AND
           LOOKUP("updateLinkRecord":U, ghContainerSource:INTERNAL-ENTRIES) NE 0 THEN
            RUN updateLinkRecord IN ghContainerSource (INPUT TABLE ttLink).        
    END.    /* with frame ... */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteLink sObject 
PROCEDURE deleteLink :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER ttLink            FOR ttLink.

    FIND FIRST ttLink NO-ERROR.
    ASSIGN ttLink.tAction = "DEL":U.

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

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN coSourceObject:DELIMITER = CHR(3)
               coTargetObject:DELIMITER = CHR(3)
               coLinkName:DELIMITER     = CHR(3)
               .
    END.    /* with frame ... */

    {get ContainerSource ghContainerSource}.

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
    DEFINE VARIABLE cLipString              AS CHARACTER                NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        FOR EACH ryc_smartLink_type NO-LOCK:
            ASSIGN cLipString = cLipString + (IF NUM-ENTRIES(cLipString, coLinkName:DELIMITER) EQ 0 THEN "":U ELSE coLinkName:DELIMITER)
                              + ryc_smartLink_type.link_name
                   NO-ERROR.
        END.    /* each smartLink */

        ASSIGN coLinkName:LIST-ITEMS   = cLipString
               coLinkName:SCREEN-VALUE = coLinkName:ENTRY(1)
               NO-ERROR.
    END.    /* with frame ... */
    
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
    DEFINE INPUT PARAMETER TABLE FOR ttLink.

    FIND FIRST ttLink NO-ERROR.

    IF AVAILABLE ttLink THEN
    DO WITH FRAME {&FRAME-NAME}:
        /* Source */
        ASSIGN coSourceObject:SCREEN-VALUE = STRING(ttLink.tSourceId)
               NO-ERROR.
        APPLY "VALUE-CHANGED":U TO coSourceObject.

        /* Target */
        ASSIGN coTargetObject:SCREEN-VALUE = STRING(ttLink.tTargetId)
               NO-ERROR.
        APPLY "VALUE-CHANGED":U TO coTargetObject.
        
        /* Link */
        ASSIGN coLinkName:SCREEN-VALUE = ttLink.tLinkName
               NO-ERROR.
        APPLY "VALUE-CHANGED":U TO coLinkName.
    END.    /* avail ttLink */

    ASSIGN buApply:SENSITIVE        = NO
           buDeleteLink:SENSITIVE   = (AVAILABLE ttLink)
           buAddLink:SENSITIVE      = YES
           coSourceObject:SENSITIVE = YES
           coTargetObject:SENSITIVE = YES
           coLinkName:SENSITIVE     = NO
           .
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setInstanceObjects sObject 
FUNCTION setInstanceObjects RETURNS LOGICAL
    ( INPUT pcObjectNames       AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN coSourceObject:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = pcObjectNames
           coTargetObject:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = pcObjectNames

           coSourceObject:SCREEN-VALUE IN FRAME {&FRAME-NAME} = coSourceObject:ENTRY(1)
           coTargetObject:SCREEN-VALUE IN FRAME {&FRAME-NAME} = coTargetObject:ENTRY(1)
           NO-ERROR.

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

