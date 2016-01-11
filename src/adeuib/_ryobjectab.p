&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*---------------------------------------------------------------------------------
  File:        adeuib/_ryobjectab.p

  Description: Supports calling code to create _RyObject "open" record for AB.

  Purpose:     To create _RYObject record used by AppBuilder for repository
               objects.  Does not perform any validation

  Parameters:   pcObjectName        Name of object in repository
                pcObjectColValues   CHR(3) delimited list of fields and their values from ryc_smartObject
                                    in the form:  table.field | value | ...
   OUTPUT       plError             YES if error occurs creating _RYObject record.             

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   04/24/2003  Author:     

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       _ryobjectab.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                           */
&IF DEFINED(UIB_is_Running) = 0 &THEN
  DEFINE INPUT  PARAMETER pcObjectName      AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectColValues AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER plError           AS LOGICAL   NO-UNDO .
    /* YES - User choose OK. NO - User choose Cancel.       */
&ELSE
  DEFINE VARIABLE pcObjectName      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE pcObjectColValues AS CHARACTER NO-UNDO.
  DEFINE VARIABLE plError           AS LOGICAL   NO-UNDO.
&ENDIF

/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}
/* Shared _RyObject and _custom temp-tables. */
{adeuib/ttobject.i}
{adeuib/custwidg.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 8.1
         WIDTH              = 64.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN createRyObject IN THIS-PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-createRYObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRYObject Procedure 
PROCEDURE createRYObject :
/*------------------------------------------------------------------------------
  Purpose:    Performs the actual creation of the _RYObject record and
              assigns all required values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE BUFFER local_custom FOR _custom.

DO ON ERROR UNDO, LEAVE:
    
  FIND _RyObject WHERE _RyObject.object_filename = pcObjectName NO-ERROR.
  IF NOT AVAILABLE _RyObject THEN 
     CREATE _RyObject.

  ASSIGN 
    _RyObject.Object_type_code          = ENTRY(LOOKUP("gsc_object_type.object_type_code":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3))
    _RyObject.Object_filename           = pcObjectName
    _RyObject.smartobject_obj           = DECIMAL(ENTRY(LOOKUP("ryc_smartobject.smartobject_obj":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3)))
    _RyObject.Object_type_obj           = DECIMAL(ENTRY(LOOKUP("ryc_smartobject.object_type_obj":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3)))
    _RyObject.product_module_obj        = DECIMAL(ENTRY(LOOKUP("ryc_smartobject.product_module_obj":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3)))
    _RyObject.product_module_code       = ENTRY(LOOKUP("gsc_product_module.product_module_code":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3))
    _RyObject.Object_description        = ENTRY(LOOKUP("ryc_smartobject.object_description":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3))
    _RyObject.Object_path               = ENTRY(LOOKUP("ryc_smartobject.object_path":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3))
    _RyObject.Object_extension          = ENTRY(LOOKUP("ryc_smartobject.object_extension":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3))
    _RyObject.runnable_from_menu        = LOGICAL(ENTRY(LOOKUP("ryc_smartobject.runnable_from_menu":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3)))
    _RyObject.disabled                  = LOGICAL(ENTRY(LOOKUP("ryc_smartobject.disabled":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3)))
    _RyObject.Run_persistent            = LOGICAL(ENTRY(LOOKUP("ryc_smartobject.run_persistent":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3)))
    _RyObject.Run_when                  = ENTRY(LOOKUP("ryc_smartobject.run_when":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3)) 
    _RyObject.security_smartObject_obj  = DECIMAL(ENTRY(LOOKUP("ryc_smartobject.security_smartobject_obj":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3)))
    _RyObject.container_object          = LOGICAL(ENTRY(LOOKUP("ryc_smartobject.container_object":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3)))
    _RyObject.static_object             = LOGICAL(ENTRY(LOOKUP("ryc_smartobject.static_object":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3)))
    _RyObject.generic_object            = LOGICAL(ENTRY(LOOKUP("ryc_smartobject.generic_object":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3)))
    _RyObject.Required_db_list          = ENTRY(LOOKUP("ryc_smartobject.required_db_list":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3))
    _RyObject.Layout_obj                = DECIMAL(ENTRY(LOOKUP("ryc_smartobject.layout_obj":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3)))
    _RyObject.design_action             = "OPEN":u
    _RyObject.design_ryobject           = YES 
    _RyObject.deployment_type           = ENTRY(LOOKUP("ryc_smartobject.deployment_type":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3))
    _RyObject.design_only               = LOGICAL(ENTRY(LOOKUP("ryc_smartobject.design_only":U, pcObjectColValues, CHR(3)) + 1, pcObjectColValues, CHR(3)))
    NO-ERROR.
    IF VALID-HANDLE(gshRepositoryManager) AND NOT ERROR-STATUS:ERROR THEN
       ASSIGN _RyObject.parent_classes = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager, INPUT _RyObject.Object_type_code) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
    DO:
      plError = YES.
      RETURN.
    END.
   
    /* Get template information */
    FIND FIRST local_custom WHERE local_custom._object_type_code = _RyObject.Object_type_code NO-ERROR.
    IF NOT AVAILABLE local_custom 
    THEN DO:
        IF LOOKUP(_RyObject.object_type_code, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "DynView":U)) > 0 THEN
            FIND FIRST local_custom WHERE local_custom._object_type_code = "SmartDataViewer":U NO-ERROR.
        ELSE
            IF LOOKUP(_RyObject.object_type_code, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "DynSDO":U)) > 0 THEN
                FIND FIRST local_custom WHERE local_custom._object_type_code = "DynSDO":U NO-ERROR.
            ELSE
                IF LOOKUP(_RyObject.object_type_code, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "DynBrow":U)) > 0 THEN
                    FIND FIRST local_custom WHERE local_custom._object_type_code = "DynBrow":U NO-ERROR.
                ELSE
                  IF LOOKUP(_RyObject.object_type_code, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "DynSBO":U)) > 0 THEN
                      FIND FIRST local_custom WHERE local_custom._object_type_code = "DynSBO":U NO-ERROR.
    END.
    IF AVAILABLE local_custom THEN
      ASSIGN
           _RyObject.design_template_file   = local_custom._design_template_file
           _RyObject.design_propsheet_file  = local_custom._design_propsheet_file
           _RyObject.design_image_file      = local_custom._design_image_file
           NO-ERROR.
    
    IF ERROR-STATUS:ERROR THEN
      plError = YES.

    RETURN.

  END.  /* DO ON ERROR */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

