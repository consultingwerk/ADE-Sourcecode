&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"src/adm2/support/dconsumer.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:

  Description: from viewer.w - Template for SmartDataViewer objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "src/adm2/support/dconsumer.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.destination RowObject.selector ~
RowObject.durable 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-FIELDS RowObject.destination RowObject.selector ~
RowObject.durable RowObject.subscription RowObject.unsubscribeClose 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RowObject.destination AT ROW 1 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 35 BY 1
     RowObject.selector AT ROW 2.14 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 60 BY 1
     RowObject.durable AT ROW 3.29 COL 22
          VIEW-AS TOGGLE-BOX
          SIZE 27 BY .81
     RowObject.subscription AT ROW 4.24 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 35 BY 1
     RowObject.unsubscribeClose AT ROW 5.38 COL 22
          LABEL "Unsubscribe on Session Close"
          VIEW-AS TOGGLE-BOX
          SIZE 36 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "adm2/support/dconsumer.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {src/adm2/support/dconsumer.i}
      END-FIELDS.
   END-TABLES.
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
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 5.43
         WIDTH              = 86.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.subscription IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.unsubscribeClose IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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

&Scoped-define SELF-NAME RowObject.durable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.durable vTableWin
ON VALUE-CHANGED OF RowObject.durable IN FRAME F-Main /* Durable Subscription */
DO:
  IF RowObject.durable:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "yes":U THEN DO:
    ASSIGN 
      RowObject.subscription:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
      RowObject.unsubscribeclose:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
  END.  /* if durable */
  ELSE DO:
    ASSIGN 
      RowObject.subscription:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
      RowObject.subscription:SCREEN-VALUE = "":U
      RowObject.unsubscribeclose:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
      RowObject.unsubscribeclose:SCREEN-VALUE = "no".
  END.  /* else  do - non-durable */

  {set DataModified yes}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeDomain vTableWin 
PROCEDURE changeDomain :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is run from the consumer instance properties 
               dialog when the JMS domain is changed
  Parameters:  pcDomain AS CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcDomain AS CHARACTER NO-UNDO.

  IF pcDomain = "PubSub":U THEN
    ASSIGN 
      RowObject.durable:HIDDEN IN FRAME {&FRAME-NAME} = FALSE
      RowObject.subscription:HIDDEN IN FRAME {&FRAME-NAME} = FALSE
      RowObject.unsubscribeclose:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
  ELSE ASSIGN
    RowObject.durable:HIDDEN IN FRAME {&FRAME-NAME} = TRUE
    RowObject.subscription:HIDDEN IN FRAME {&FRAME-NAME} = TRUE
    RowObject.unsubscribeclose:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable vTableWin 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcRelative).

  /* Code placed here will execute AFTER standard behavior.    */
  IF RowObject.durable:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "yes":U THEN DO:
    ASSIGN 
      RowObject.subscription:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
      RowObject.unsubscribeclose:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
  END.  /* if durable */
  ELSE DO:
    ASSIGN 
      RowObject.subscription:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
      RowObject.unsubscribeclose:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
  END.  /* else do - non-durable */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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

