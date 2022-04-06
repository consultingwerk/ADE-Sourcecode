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
       {"ry/obj/rycsoful2o.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*---------------------------------------------------------------------------------
  File: rysdfchsev.w

  Description:  Choose Existing Dynamic SDF Object

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   02/07/2003  Author:     Mark Davies (MIP)

  Update Notes: Created from Template rysttviewv.w

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

&scop object-name       rysdfchsev.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}

DEFINE VARIABLE ghSDFObject        AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcComboClasses     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLookupClasses    AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rycsoful2o.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.object_filename 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS buNew 
&Scoped-Define DISPLAYED-FIELDS RowObject.object_filename 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject


/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buNew 
     LABEL "&Create New SDF" 
     SIZE 18.6 BY 1.14
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.object_filename AT ROW 1 COL 1
          LABEL "SmartDataField Name"
          VIEW-AS FILL-IN 
          SIZE 56.6 BY 1
     buNew AT ROW 1 COL 81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rycsoful2o.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rycsoful2o.i}
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
         HEIGHT             = 1.19
         WIDTH              = 99.2.
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

/* SETTINGS FOR FILL-IN RowObject.object_filename IN FRAME frMain
   ALIGN-L EXP-LABEL                                                    */
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

&Scoped-define SELF-NAME buNew
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buNew vTableWin
ON CHOOSE OF buNew IN FRAME frMain /* Create New SDF */
DO:
  RUN sdfMaintWindow IN ghSDFObject (INPUT "NEW":U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject vTableWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  IF DYNAMIC-FUNCTION("getObjectClosing":U IN ghSDFObject) = FALSE THEN
    DYNAMIC-FUNCTION("closeObject":U IN ghSDFObject).
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainerSource  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRunAttribute     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDFType          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hWindowHandle     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cClasses          AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  {get DataSource hDataSource}.
  {get ContainerSource hContainerSource}.
  {get ContainerHandle hWindowHandle hContainerSource}.
  {get RunAttribute cRunAttribute hContainerSource}.
  
  SUBSCRIBE TO "selected" IN hContainerSource.

  IF cRunAttribute <> "":U THEN
    ghSDFObject = WIDGET-HANDLE(cRunAttribute).
  IF VALID-HANDLE(ghSDFObject) THEN
    cSDFType = DYNAMIC-FUNCTION("getSDFType":U IN ghSDFObject) NO-ERROR.
  
  IF VALID-HANDLE(hWindowHandle) AND cSDFType <> "":U THEN
    hWindowHandle:TITLE = hWindowHandle:TITLE + " (" + cSDFType + ")".
  
  ASSIGN gcComboClasses  = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "dynLookup,dynCombo")
         gcLookupClasses = ENTRY(1, gcComboClasses, CHR(3))
         gcComboClasses  = ENTRY(2, gcComboClasses, CHR(3)).

  IF LOOKUP(cSDFType,gcComboClasses) > 0 THEN
    cClasses = gcComboClasses.
  ELSE
    cClasses = gcLookupClasses.

  DYNAMIC-FUNCTION("addQueryWhere":U IN hDataSource,INPUT "LOOKUP(object_type_code,'":U + cClasses + "') > 0":U, "gsc_object_type":U, "AND":U).
  ASSIGN cWhere = "object_type_code = '":U + cSDFType + "'":U + CHR(3) + "gsc_object_type" + CHR(3) + "AND":U.
  {set manualAddQueryWhere cWhere hDataSource}.

  RUN SUPER.
  DYNAMIC-FUNCTION("openQuery":U IN hDataSource).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selected vTableWin 
PROCEDURE selected :
/*------------------------------------------------------------------------------
  Purpose:     Published from the browser when user used mouse to select a record
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN toolbar (INPUT "Select":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbar vTableWin 
PROCEDURE toolbar :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcValue AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcValue).

  /* Code placed here will execute AFTER standard behavior.    */
  IF pcValue = "Select" AND RowObject.object_filename:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "":U THEN
    RUN sdfMaintWindow IN ghSDFObject (INPUT RowObject.object_filename:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
  IF pcValue = "Select" AND RowObject.object_filename:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U THEN
    APPLY "CHOOSE":U TO buNew IN FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

