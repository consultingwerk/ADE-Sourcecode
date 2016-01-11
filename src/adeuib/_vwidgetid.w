&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/***********************************************************************
* Copyright (C) 2005,2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------

  File: adeuib/_vwidgetid.w

  Description: Viewer for Widget ID preferences

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{adecomm/adestds.i}   /* Standard Definitions             */
{adeuib/uniwidg.i}    /* Universal widgt records          */
{adeuib/sharvars.i}   /* Shared variables                 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 AssignWidgetID StartID ~
IncrementID tgFileName rsFileName fiFileName 
&Scoped-Define DISPLAYED-OBJECTS AssignWidgetID StartID IncrementID ~
tgFileName rsFileName fiFileName 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiFileName AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.4 BY 1 NO-UNDO.

DEFINE VARIABLE IncrementID AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Frame widget ID increment" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE StartID AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Starting widget ID for frames" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE rsFileName AS LOGICAL 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Default (file name + .xml)", yes,
"Custom XML file", no
     SIZE 28.2 BY 1.91 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48 BY 5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48 BY 4.43.

DEFINE VARIABLE AssignWidgetID AS LOGICAL INITIAL no 
     LABEL "Automatically assign widget IDs" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE tgFileName AS LOGICAL INITIAL yes 
     LABEL "Save widget-id filename" 
     VIEW-AS TOGGLE-BOX
     SIZE 38 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     AssignWidgetID AT ROW 2.71 COL 13
     StartID AT ROW 3.81 COL 33 COLON-ALIGNED
     IncrementID AT ROW 5.1 COL 33 COLON-ALIGNED
     tgFileName AT ROW 7.67 COL 10.2 
     rsFileName AT ROW 8.62 COL 17.2 NO-LABEL
     fiFileName AT ROW 10.57 COL 15.2 COLON-ALIGNED NO-LABEL
     "Static widgets widget-id assignment" VIEW-AS TEXT
          SIZE 34.4 BY .62 AT ROW 1.71 COL 6.6
     "Runtime widget-id" VIEW-AS TEXT
          SIZE 18.2 BY .62 AT ROW 6.71 COL 6.8
     RECT-2 AT ROW 6.95 COL 5
     RECT-3 AT ROW 2.05 COL 5
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 17.71
         WIDTH              = 82.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

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

&Scoped-define SELF-NAME rsFileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsFileName V-table-Win
ON VALUE-CHANGED OF rsFileName IN FRAME F-Main
DO:
ASSIGN fiFileName:SENSITIVE = SELF:SCREEN-VALUE EQ "No" AND tgFileName:CHECKED.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgFileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgFileName V-table-Win
ON VALUE-CHANGED OF tgFileName IN FRAME F-Main /* Save widget-id filename */
DO:
ASSIGN rsFileName:SENSITIVE IN FRAME {&FRAME-NAME} = SELF:CHECKED
       fiFileName:SENSITIVE IN FRAME {&FRAME-NAME} = SELF:CHECKED.

IF SELF:CHECKED THEN
APPLY "VALUE-CHANGED":U TO rsFileName.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assign-new-values V-table-Win 
PROCEDURE assign-new-values :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:
    ASSIGN AssignWidgetID
           StartID
           IncrementID
           tgFileName
           rsFileName
           fiFileName.

    IF (StartID MODULO 2 NE 0) OR
       (IncrementID MODULO 2 NE 0) OR 
       (StartID = 0) OR 
       (IncrementID = 0) THEN
    DO:
      MESSAGE "The starting widget ID or widget ID increment is invalid.  They must be even values greater than 0."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN "Error":U.
    END.

    IF tgFileName:CHECKED AND
       rsFileName:SCREEN-VALUE = "No" AND
       (fiFileName:SCREEN-VALUE = "" OR fiFileName:SCREEN-VALUE = ?) THEN
    DO:
        MESSAGE "Custome XML file must be entered."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "Error":U.
    END.

    ASSIGN _widgetid_assign           = AssignWidgetID
           _widgetid_start            = StartID
           _widgetid_increment        = IncrementID
           _widgetid_save_filename    = tgFileName
           _widgetid_default_filename = rsFileName
           _widgetid_custom_filename  = fiFileName.

 END.  /* DO WITH FRAME {&FRAME-NAME} */
RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject V-table-Win 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY "VALUE-CHANGED":U TO tgFileName IN FRAME {&FRAME-NAME}.
  APPLY "VALUE-CHANGED":U TO rsFileName.
  
  IF rsFileName:SCREEN-VALUE = "Yes":U OR NOT tgFileName:CHECKED THEN
     ASSIGN fiFileName:SCREEN-VALUE = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-init V-table-Win 
PROCEDURE set-init :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN AssignWidgetID = _widgetid_assign
         StartID        = _widgetid_start
         IncrementID    = _widgetid_increment
         tgFileName     = _widgetid_save_filename
         rsFileName     = _widgetid_default_filename
         fiFileName     = _widgetid_custom_filename.
    DISPLAY {&DISPLAYED-OBJECTS} WITH FRAME F-Main.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

