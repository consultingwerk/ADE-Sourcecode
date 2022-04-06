&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"af/obj2/gscscfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gscscviewv.w

  Description:  Security Control static SmartDataViewer

  Purpose:      Static SmartDataViewer used to maintain the gsc_security_control record

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   10/17/2001  Author:     

  Update Notes: Disable Add and Copy button if a record exists.
                Only enable Add if no record exists.

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gscscviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gscscfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.login_filename ~
RowObject.security_enabled RowObject.translation_enabled ~
RowObject.error_log_filename RowObject.help_writer_enabled ~
RowObject.default_help_filename RowObject.build_top_menus_only ~
RowObject.company_logo_filename RowObject.enable_window_positioning ~
RowObject.system_icon_filename RowObject.minimise_siblings ~
RowObject.small_icon_filename RowObject.force_unique_password ~
RowObject.product_logo_filename RowObject.scm_checks_on ~
RowObject.password_max_retries RowObject.password_history_life_time 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define DISPLAYED-FIELDS RowObject.login_filename ~
RowObject.security_enabled RowObject.translation_enabled ~
RowObject.error_log_filename RowObject.help_writer_enabled ~
RowObject.default_help_filename RowObject.build_top_menus_only ~
RowObject.company_logo_filename RowObject.enable_window_positioning ~
RowObject.system_icon_filename RowObject.minimise_siblings ~
RowObject.small_icon_filename RowObject.force_unique_password ~
RowObject.product_logo_filename RowObject.scm_checks_on ~
RowObject.password_max_retries RowObject.password_history_life_time 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject


/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.login_filename AT ROW 1.1 COL 32 COLON-ALIGNED
          LABEL "Login filename"
          VIEW-AS FILL-IN 
          SIZE 45 BY 1
     RowObject.security_enabled AT ROW 1.1 COL 91.2
          LABEL "Security enabled"
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .81
     RowObject.translation_enabled AT ROW 2.05 COL 91.2
          LABEL "Translation enabled"
          VIEW-AS TOGGLE-BOX
          SIZE 23.8 BY .81
     RowObject.error_log_filename AT ROW 2.1 COL 32 COLON-ALIGNED
          LABEL "Error log filename"
          VIEW-AS FILL-IN 
          SIZE 45 BY 1
     RowObject.help_writer_enabled AT ROW 3 COL 91.2
          LABEL "Help writer enabled"
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .81
     RowObject.default_help_filename AT ROW 3.1 COL 32 COLON-ALIGNED
          LABEL "Default help filename"
          VIEW-AS FILL-IN 
          SIZE 45 BY 1
     RowObject.build_top_menus_only AT ROW 3.95 COL 91.2
          LABEL "Build top menus only"
          VIEW-AS TOGGLE-BOX
          SIZE 25.8 BY .81
     RowObject.company_logo_filename AT ROW 4.1 COL 32 COLON-ALIGNED
          LABEL "Company logo filename"
          VIEW-AS FILL-IN 
          SIZE 45 BY 1
     RowObject.enable_window_positioning AT ROW 4.91 COL 91.2
          LABEL "Enable window positioning"
          VIEW-AS TOGGLE-BOX
          SIZE 30.8 BY .81
     RowObject.system_icon_filename AT ROW 5.1 COL 32 COLON-ALIGNED
          LABEL "System icon filename"
          VIEW-AS FILL-IN 
          SIZE 45 BY 1
     RowObject.minimise_siblings AT ROW 5.86 COL 91.2
          LABEL "Minimise siblings"
          VIEW-AS TOGGLE-BOX
          SIZE 20.8 BY .81
     RowObject.small_icon_filename AT ROW 6.1 COL 32 COLON-ALIGNED
          LABEL "Small icon filename"
          VIEW-AS FILL-IN 
          SIZE 45 BY 1
     RowObject.force_unique_password AT ROW 6.81 COL 91.2
          LABEL "Force unique password"
          VIEW-AS TOGGLE-BOX
          SIZE 27.6 BY .81
     RowObject.product_logo_filename AT ROW 7.1 COL 32 COLON-ALIGNED
          LABEL "Product logo filename"
          VIEW-AS FILL-IN 
          SIZE 45 BY 1
     RowObject.scm_checks_on AT ROW 7.76 COL 91.2
          LABEL "SCM checks on"
          VIEW-AS TOGGLE-BOX
          SIZE 20.4 BY .81
     RowObject.password_max_retries AT ROW 8.43 COL 32.2 COLON-ALIGNED
          LABEL "Password max. retries"
          VIEW-AS FILL-IN 
          SIZE 11.8 BY 1
     RowObject.password_history_life_time AT ROW 9.43 COL 32.2 COLON-ALIGNED
          LABEL "Password history life time"
          VIEW-AS FILL-IN 
          SIZE 11.8 BY 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gscscfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gscscfullo.i}
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
         HEIGHT             = 10.29
         WIDTH              = 124.2.
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
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX RowObject.build_top_menus_only IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.company_logo_filename IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.default_help_filename IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.enable_window_positioning IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.error_log_filename IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.force_unique_password IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.help_writer_enabled IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.login_filename IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.minimise_siblings IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.password_history_life_time IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.password_max_retries IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.product_logo_filename IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.scm_checks_on IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.security_enabled IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.small_icon_filename IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.system_icon_filename IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.translation_enabled IN FRAME frMain
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME frMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frMain vTableWin
ON MOUSE-SELECT-DBLCLICK OF FRAME frMain
DO:
  RUN setButtonState.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  RUN SUPER.
  
  /* ===== THOMAS TO REVISIT ===

  ASSIGN RowObject.scm_tool_code:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'RTB':U.
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord vTableWin 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.
  
  RUN setButtonState.

  /* Code placed here will execute AFTER standard behavior.    */

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
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord vTableWin 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  RUN setButtonState.
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setButtonState vTableWin 
PROCEDURE setButtonState :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will determine if the Add buttons should be 
               enabled or not.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource   AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hTableIO      AS HANDLE   NO-UNDO.
  DEFINE VARIABLE lRowAvailable AS LOGICAL  NO-UNDO.
  
  {get dataSource hDataSource}.
  {get TableIOSource hTableIO}.
  
  IF VALID-HANDLE(hDataSource) THEN DO:
    lRowAvailable = DYNAMIC-FUNCTION("rowAvailable":U IN hDataSource, "CURRENT":U).
    IF VALID-HANDLE(hTableIO) THEN DO:
      IF lRowAvailable THEN
        DYNAMIC-FUNCTION("sensitizeActions":U IN hTableIO ,"Add,Copy", FALSE).    
      ELSE
        DYNAMIC-FUNCTION("sensitizeActions":U IN hTableIO ,"Add", TRUE).    
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateMode vTableWin 
PROCEDURE updateMode :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcMode AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcMode).

  RUN setButtonState.
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord vTableWin 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.
  
  RUN setButtonState.
  
  /* Code placed here will execute AFTER standard behavior.    */

  /* Make sure our minimiseSiblings session property is in line with what it was set to here */

  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager, 
                                       INPUT "minimiseSiblings":U,
                                       INPUT rowObject.minimise_siblings:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                       INPUT YES). /* Set in client session only */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

