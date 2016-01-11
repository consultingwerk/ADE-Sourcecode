&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
    File        : rycsofetch.p
    Purpose     : Part of Repository Manager to retrieve dynamic object
                  details from ICF Repository

    Syntax      :

    Description :

    Author(s)   : Anthony Swindells
    Created     : 1999
    Notes       : Last updated August 2001
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(server-side) = 0 &THEN
  /* Only define temp-table if on client as cannot define a temp-table in an 
     internal procedure and temp-table will already be defined in this case
  */
  /* Globals */
  { src/adm2/globals.i }
  
  /* include temp-table definitions */
  {ry/app/rycsofetch.i}
&ENDIF

DEFINE INPUT  PARAMETER pcLogicalObjectName         AS CHARACTER        NO-UNDO.
DEFINE INPUT  PARAMETER phHandleObjectCache         AS HANDLE           NO-UNDO.
DEFINE INPUT  PARAMETER TABLE-HANDLE phTableObjectCache.
DEFINE OUTPUT PARAMETER TABLE FOR tt_object_instance.
DEFINE OUTPUT PARAMETER TABLE FOR tt_page.
DEFINE OUTPUT PARAMETER TABLE FOR tt_page_instance.
DEFINE OUTPUT PARAMETER TABLE FOR tt_link.
DEFINE OUTPUT PARAMETER TABLE FOR ttAttributeValue.
DEFINE OUTPUT PARAMETER TABLE FOR ttUiEvent.

DEFINE BUFFER lb_object        FOR gsc_object.

DEFINE VARIABLE cObjectName         AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE iNumberOfPages      AS INTEGER                      NO-UNDO.
DEFINE VARIABLE cPageLabels         AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE cLocalAttributes    AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE lDynamicUIContainer AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE ghBufferObjectCache AS HANDLE                       NO-UNDO.

/* Only one of the input handles will be valid. */
IF VALID-HANDLE(phHandleObjectCache) THEN
    ASSIGN ghBufferObjectCache = phHandleObjectCache:DEFAULT-BUFFER-HANDLE.
ELSE
IF VALID-HANDLE(phTableObjectCache) THEN
    ASSIGN ghBufferObjectCache = phTableObjectCache:DEFAULT-BUFFER-HANDLE.

EMPTY TEMP-TABLE tt_object_instance.
EMPTY TEMP-TABLE tt_page.
EMPTY TEMP-TABLE tt_page_instance.
EMPTY TEMP-TABLE tt_link.
EMPTY TEMP-TABLE ttAttributeValue.
EMPTY TEMP-TABLE ttUiEvent.

/* The {&AUTO-ATTACH-KEEP-ATTRIBS} pre-processor stores the attribute labels of 
 * attributes which must be taken from the underlying field.                    */
&SCOPED-DEFINE AUTO-ATTACH-KEEP-ATTRIBS FieldName,WidgetName,ROW,COLUMN,FieldOrder,InitialValue

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-AddMasterToCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD AddMasterToCache Procedure 
FUNCTION AddMasterToCache RETURNS LOGICAL
    ( INPUT pcLogicalObjectName         AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createAttributeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createAttributeValue Procedure 
FUNCTION createAttributeValue RETURNS LOGICAL
    ( INPUT        pcLogicalObjectName          AS CHARACTER,
      INPUT        plDynamicUiContainer         AS LOGICAL,
      INPUT        pdObjectInstanceObj          AS DECIMAL,
      INPUT        pcAttributeGroup             AS CHARACTER,
      INPUT        pcAttributeType              AS CHARACTER,
      INPUT        pcAttributeLabel             AS CHARACTER,
      INPUT        pcAttributeValue             AS CHARACTER,
      INPUT-OUTPUT pcLocalAttributes            AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAttributeValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAttributeValues Procedure 
FUNCTION getAttributeValues RETURNS LOGICAL
    ( INPUT        pcLogicalObjectName         AS CHARACTER,
      INPUT        pdObjectTypeObj             AS DECIMAL,
      INPUT        pdSmartObjectObj            AS DECIMAL,
      INPUT        pdObjectInstanceObj         AS DECIMAL,
      INPUT        pdContainerSmartObjectObj   AS DECIMAL,
      INPUT        plDynamicUiContainer        AS LOGICAL,
      INPUT-OUTPUT pcLocalAttributes           AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-MasterInCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD MasterInCache Procedure 
FUNCTION MasterInCache RETURNS LOGICAL
    ( INPUT pcLogicalObjectName         AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */   
/* Server-side coding to be placed into a plip for execution in a stateless server-side context */
/* Find container smartobject */
FIND FIRST ryc_smartobject WHERE
           ryc_smartobject.object_filename = pcLogicalObjectName
           NO-LOCK NO-ERROR.
IF NOT AVAILABLE ryc_smartobject THEN
    RETURN ERROR {aferrortxt.i 'RY' '01' '?' '?' pcLogicalObjectName}.

/* Find corresponding object to see what type of object it is (UI container?) */
FIND FIRST gsc_object NO-LOCK
     WHERE gsc_object.object_obj = ryc_smartobject.object_obj
     NO-ERROR.
IF NOT AVAILABLE gsc_object THEN
    RETURN ERROR {aferrortxt.i 'RY' '01' '?' '?' pcLogicalObjectName}.
IF gsc_object.physical_object_obj > 0 THEN
  FIND FIRST lb_object NO-LOCK
       WHERE lb_object.object_obj = gsc_object.physical_object_obj
       NO-ERROR.

/* Assumes dynamic UI container is called rydyncontw.w */
IF AVAILABLE lb_object AND 
   (lb_object.object_filename BEGINS "rydyncont":U OR lb_object.object_filename BEGINS "rydyntree":U) THEN
  ASSIGN lDynamicUIContainer = YES.
ELSE
  ASSIGN lDynamicUIContainer = NO.

ASSIGN cLocalAttributes = "":U.

/* Retrieve all attributes for the containing SmartObject. */
DYNAMIC-FUNCTION("createAttributeValue":U,
                 INPUT        pcLogicalObjectName,
                 INPUT        lDynamicUiContainer,
                 INPUT        0,
                 INPUT        "":U,
                 INPUT        "":U,
                 INPUT        "LogicalObjectName":U,
                 INPUT        pcLogicalObjectName,
                 INPUT-OUTPUT cLocalAttributes).

/* Determine local version number */
FIND FIRST rym_data_version WHERE
           rym_data_version.related_entity_key      = pcLogicalObjectName AND
           rym_data_version.related_entity_mnemonic = "RYCSO":U
           NO-LOCK NO-ERROR.
IF AVAILABLE rym_data_version THEN
    DYNAMIC-FUNCTION("createAttributeValue":U,
                     INPUT        pcLogicalObjectName,
                     INPUT        lDynamicUiContainer,
                     INPUT        0,
                     INPUT        "":U,
                     INPUT        "":U,
                     INPUT        "LogicalVersion":U,
                     INPUT        STRING(rym_data_version.data_version_number, "999999":U),
                     INPUT-OUTPUT cLocalAttributes).

/* Retrieve the attributes of the containing SmartObject. */
DYNAMIC-FUNCTION("getAttributeValues":U,
                 INPUT        pcLogicalObjectName,
                 INPUT        ryc_smartobject.object_type_obj,
                 INPUT        ryc_smartobject.smartobject_obj,
                 INPUT        0,
                 INPUT        0,
                 INPUT        lDynamicUiContainer,
                 INPUT-OUTPUT cLocalAttributes    ).

/* Create object instance record for container object. If a real container store info 
 * such as the attribute list for later use - to save having to read
 * back through the list of attributes                                                */
FIND FIRST gsc_object_type WHERE
           gsc_object_type.object_type_obj = ryc_smartObject.object_type_obj
           NO-LOCK.
CREATE tt_object_instance.
ASSIGN tt_object_instance.logical_object_name       = pcLogicalObjectName
       tt_object_instance.layout_position           = "":U
       tt_object_instance.object_instance_obj       = 0
       tt_object_instance.object_pathed_filename    = "":U
       tt_object_instance.object_instance_handle    = ?
       tt_object_instance.object_frame_handle       = ?
       tt_object_instance.object_type_code          = gsc_object_type.object_type_code
       tt_object_instance.db_aware                  = (gsc_object.required_db_list NE "":U)
       tt_object_instance.custom_super_procedure    = ryc_smartObject.custom_super_procedure
       tt_object_instance.instance_attribute_list   = cLocalAttributes              WHEN lDynamicUIContainer
       tt_object_instance.instance_is_a_container   = CAN-FIND(FIRST ryc_object_instance WHERE
                                                                     ryc_object_instance.container_smartObject_obj = ryc_smartObject.smartObject_obj)
       tt_object_instance.instance_object_name      = ryc_smartObject.object_filename
       .
/* Page 0 */
FIND FIRST ryc_layout WHERE
           ryc_layout.layout_obj = ryc_smartobject.layout_obj
           NO-LOCK NO-ERROR.
CREATE tt_page.
ASSIGN iNumberOfPages              = 0
       tt_page.logical_object_name = pcLogicalObjectName
       tt_page.page_number         = 0
       tt_page.page_label          = "Page 0":U
       tt_page.layout_code         = (IF AVAILABLE ryc_layout THEN ryc_layout.layout_code ELSE "00":U)
       tt_page.page_initialized    = NO
       .
/* This is a procedure which retrieves all of the 
 * attribute values, UI events and page instances for 
 * the given container smartObject. If this container
 * smartObject contains container SmartObjects, the procedure
 * will be run recursively.                                  
 *
 * If an object is a static object, then everything it contains 
 * already exists in the physical code of that object, so there is 
 * no need to retrieve any more information.                       */
IF tt_object_instance.instance_is_a_container AND
   ryc_smartObject.static_object         = NO THEN
DO:
    RUN getInstanceData ( INPUT ryc_smartObject.smartObject_obj,
                          INPUT lDynamicUiContainer,
                          INPUT pcLogicalObjectName            ).

    /** SmartLinks
     *  ----------------------------------------------------------------------- **/
    FOR EACH ryc_smartlink WHERE
             ryc_smartlink.container_smartobject_obj = ryc_smartobject.smartobject_obj
             NO-LOCK:
        CREATE tt_link.
        ASSIGN tt_link.logical_object_name        = pcLogicalObjectName
               tt_link.source_object_instance_obj = ryc_smartlink.source_object_instance_obj
               tt_link.target_object_instance_obj = ryc_smartlink.target_object_instance_obj
               tt_link.link_name                  = ryc_smartlink.link_name
               tt_link.link_created               = NO
               .
    END.    /* SmartLinks */

    /** Pages and Page Layouts 
     *  ----------------------------------------------------------------------- **/
    /* Non-zero pages */
    FOR EACH ryc_page WHERE
             ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj
             NO-LOCK
             BY ryc_page.page_sequence:

        FIND FIRST ryc_layout WHERE
                   ryc_layout.layout_obj = ryc_page.layout_obj
                   NO-LOCK NO-ERROR.

        CREATE tt_page.
        ASSIGN iNumberOfPages              = iNumberOfPages + 1
               tt_page.logical_object_name = pcLogicalObjectName
               tt_page.page_number         = iNumberOfPages         /* We do not require the page_sequence to be contiguous */
               tt_page.page_label          = ryc_page.page_label
               tt_page.layout_code         = (IF AVAILABLE ryc_layout THEN ryc_layout.layout_code ELSE "00":U)
               tt_page.page_initialized    = NO
               .    
        FOR EACH ryc_page_object WHERE
                 ryc_page_object.container_smartobject_obj = ryc_page.container_smartobject_obj AND
                 ryc_page_object.page_obj                  = ryc_page.page_obj
                 NO-LOCK:
            CREATE tt_page_instance.
            ASSIGN tt_page_instance.logical_object_name = pcLogicalObjectName
                   tt_page_instance.page_number         = iNumberOfPages
                   tt_page_instance.object_instance_obj = ryc_page_object.object_instance_obj
                   .
            CREATE tt_link.
            ASSIGN tt_link.logical_object_name        = pcLogicalObjectName
                   tt_link.source_object_instance_obj = ?                   /* The container itself */
                   tt_link.target_object_instance_obj = ryc_page_object.object_instance_obj
                   tt_link.link_name                  = "Page" + STRING(iNumberOfPages)
                   tt_link.link_created               = NO
                   .       
            /* Update page number onto object instance and instance layout if required */
            FIND FIRST tt_object_instance
                 WHERE tt_object_instance.object_instance_obj = tt_page_instance.object_instance_obj
                 NO-ERROR.
            IF AVAILABLE tt_object_instance THEN
            DO:
              ASSIGN tt_object_instance.page_number = tt_page_instance.page_number.
              /* add page to layout if not there already */
              IF tt_object_instance.page_number > 0 AND NUM-ENTRIES(tt_object_instance.layout_position) = 1 THEN
                ASSIGN tt_object_instance.layout_position = tt_object_instance.layout_position + ",":U + TRIM(STRING(tt_object_instance.page_number)).
              /* update layout position onto page instance temp-table */
              ASSIGN tt_page_instance.layout_position = tt_object_instance.layout_position.
            END.
        END.    /* page objects */
    END.    /* Pages */
END.    /* is a containr */

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.
/* EOF */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-autoAttachSdf) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE autoAttachSdf Procedure 
PROCEDURE autoAttachSdf :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves the attributes of an SDF which has been linked to 
               a DataField smartobject.
  Parameters:  pcLogicalObjectName    -
               pdObjectInstanceObj    -
               pcSdfFileName          -
               plDynamicUiContainer   -
               pcLocalAttributes      -
               buffer for tt_object_instance
  Notes:       * Create attribute values according to the SDF, except for those 
                 specified in the {&AUTO-ATTACH-KEEP-ATTRIBS} preprocessor.
               * the tt_object_instance record is passed as a buffer in case 
                 some of the details need changing, for instance the custom super
                 procedure.
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER pcLogicalObjectName       AS CHARACTER    NO-UNDO.
    DEFINE INPUT        PARAMETER pdObjectInstanceObj       AS DECIMAL      NO-UNDO.
    DEFINE INPUT        PARAMETER pcSdfFileName             AS CHARACTER    NO-UNDO.
    DEFINE INPUT        PARAMETER plDynamicUiContainer      AS LOGICAL      NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pcLocalAttributes         AS CHARACTER    NO-UNDO.
    DEFINE              PARAMETER BUFFER pbObjectInstance FOR tt_object_instance.

    DEFINE VARIABLE iAttributeCount         AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cNewAttributeList       AS CHARACTER                NO-UNDO.
    
    DEFINE BUFFER ryc_smartObject           FOR ryc_smartobject.    
    DEFINE BUFFER ryc_attribute_value       FOR ryc_attribute_value.
    DEFINE BUFFER ryc_attribute_group       FOR ryc_attribute_group.
    DEFINE BUFFER ttAttributeValue          FOR ttAttributeValue.
    DEFINE BUFFER ttUiEvent                 FOR ttUiEvent.

    FIND FIRST ryc_smartObject WHERE
               ryc_smartObject.object_filename =  pcSdfFilename
               NO-LOCK NO-ERROR.
    IF AVAILABLE ryc_smartObject THEN
    DO:
        ASSIGN pbObjectInstance.custom_super_procedure = ryc_smartObject.custom_super_procedure.

        /* Delete data for the non-SDF widget */
        IF plDynamicUiContainer THEN
        DO:
            DO iAttributeCount = 1 TO NUM-ENTRIES(pcLocalAttributes, CHR(3)):
                IF LOOKUP(ENTRY(iAttributeCount, pcLocalAttributes, CHR(3)), "{&AUTO-ATTACH-KEEP-ATTRIBS}":U) NE 0 THEN
                    ASSIGN cNewAttributeList = cNewAttributeList + (IF NUM-ENTRIES(cNewAttributeList, CHR(3)) EQ 0 THEN "":U ELSE CHR(3))
                                             + ENTRY(iAttributeCount, pcLocalAttributes, CHR(3)).
            END.    /* look through attribute pairs. */

            ASSIGN pcLocalAttributes = cNewAttributeList.
        END.    /* Dynamic UI container. */
        
        /* Attribute Values */
        FOR EACH ttAttributeValue WHERE
                 ttAttributeValue.ContainerLogicalObject = pcLogicalObjectName AND
                 ttAttributeValue.ObjectInstanceObj      = pdObjectInstanceObj    :
            IF LOOKUP(ttAttributeValue.AttributeLabel, "{&AUTO-ATTACH-KEEP-ATTRIBS}":U) EQ 0 THEN
                DELETE ttAttributeValue.
        END.    /* delete attribute values */

        /* UI Events */
        FOR EACH ttUiEvent WHERE
                 ttUiEvent.ContainerLogicalObject = pcLogicalObjectName AND
                 ttUiEvent.ObjectInstanceObj      = pdObjectInstanceObj    :
            DELETE ttUiEvent.
        END.    /* delete ui events */

        FOR EACH ryc_attribute_value WHERE
                 ryc_attribute_value.object_type_obj = ryc_smartObject.object_type_obj AND
                 ryc_attribute_value.smartobject_obj = ryc_smartObject.smartObject_obj
                 NO-LOCK,
           FIRST ryc_attribute_group WHERE
                 ryc_attribute_group.attribute_group_obj = ryc_attribute_value.attribute_group_obj
                 NO-LOCK:
            /* The {&AUTO-ATTACH-KEEP-ATTRIBS} pre-processor stores the attribute labels of 
             * attributes which must be taken from the underlying field. These are attributes
             * like row, column and fieldOrder.                                              */
            IF LOOKUP(ryc_attribute_value.attribute_label, "{&AUTO-ATTACH-KEEP-ATTRIBS}":U) EQ 0 THEN
                DYNAMIC-FUNCTION("createAttributeValue":U,
                                 INPUT        pcLogicalObjectName,
                                 INPUT        plDynamicUiContainer,
                                 INPUT        pdObjectInstanceObj,
                                 INPUT        ryc_attribute_group.attribute_group_name,
                                 INPUT        ryc_attribute_value.attribute_type,
                                 INPUT        ryc_attribute_value.attribute_label,
                                 INPUT        DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager,
                                                               INPUT ryc_attribute_value.attribute_type_TLA,
                                                               INPUT ryc_attribute_value.attribute_value),
                                 INPUT-OUTPUT pcLocalAttributes).
        END.    /* attribute values of the object instance. */
    END.    /* avail smartobject ryc_smartObject */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInstanceData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getInstanceData Procedure 
PROCEDURE getInstanceData :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves attribute value, UI event and page instance data for 
               a container. This procedure is run recursively.
  Parameters:  pdContainerSmartObjectObj - the container's logical object name
               plDynamicUiContainer      - whether the container is the Dynamic Container
                                           or Dynamic Treeview (as opposed to a Dynamic 
                                           Viewer for instance).
               pcLogicalObjectName       - the logical object name of the container
                                           SmartObject.
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE INPUT PARAMETER pdContainerSmartObjectObj    AS DECIMAL      NO-UNDO.
    DEFINE INPUT PARAMETER plDynamicUiContainer         AS LOGICAL      NO-UNDO.
    DEFINE INPUT PARAMETER pcLogicalObjectName          AS CHARACTER    NO-UNDO.
    
    DEFINE VARIABLE cLocalAttributes        AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cFieldName              AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cPathedObjectName       AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE lInstanceIsUiContainer  AS LOGICAL                  NO-UNDO.
    
    DEFINE BUFFER rycoi                 FOR ryc_object_instance.
    DEFINE BUFFER ryc_smartObject       FOR ryc_smartobject.
    DEFINE BUFFER gsc_object            FOR gsc_object.
    DEFINE BUFFER gscob                 FOR gsc_object.
    DEFINE BUFFER gsc_object_type       FOR gsc_object_type.
    DEFINE BUFFER gsc_manager_type      FOR gsc_manager_type.
    DEFINE BUFFER lbAttributeValue      FOR ttAttributeValue.
    DEFINE BUFFER tt_object_instance    FOR tt_object_instance.
    DEFINE BUFFER lb_object_instance    FOR tt_object_instance.

    FOR EACH ryc_object_instance WHERE
             ryc_object_instance.container_smartobject_obj = pdContainerSmartObjectObj
             NO-LOCK,
       FIRST ryc_smartObject WHERE
             ryc_smartObject.smartobject_obj = ryc_object_instance.smartobject_obj
             NO-LOCK,
       FIRST gsc_object WHERE
             gsc_object.object_obj = ryc_smartObject.object_obj
             NO-LOCK,
       FIRST gsc_object_type WHERE
             gsc_object_type.object_type_obj = ryc_smartObject.object_type_obj
             NO-LOCK:

        /* Clear field to store local attributes for UI containers */
        ASSIGN cLocalAttributes = "":U.

        IF gsc_object.logical_object THEN
        DO:
            DYNAMIC-FUNCTION("createAttributeValue":U,
                             INPUT        pcLogicalObjectName,
                             INPUT        plDynamicUiContainer,
                             INPUT        ryc_object_instance.object_instance_obj,
                             INPUT        "":U,
                             INPUT        "":U,
                             INPUT        "LogicalObjectName":U,
                             INPUT        ryc_smartObject.object_filename,
                             INPUT-OUTPUT cLocalAttributes).            

            FIND FIRST gscob WHERE
                       gscob.object_obj = gsc_object.physical_object_obj
                       NO-LOCK.
            ASSIGN cPathedObjectName = RIGHT-TRIM(gscob.object_path, "/~\":U)
                                     + ( IF gscob.object_path EQ "":U THEN "":U ELSE "/":U )
                                     + gscob.object_filename.        
        END.    /* Logical Object */
        ELSE
            ASSIGN cPathedObjectName = RIGHT-TRIM(gsc_object.object_path, "/~\":U)
                                     + ( IF gsc_object.object_path EQ "":U THEN "":U ELSE "/":U )
                                     + gsc_object.object_filename 
                                     + (IF gsc_object.object_extension <> "":U THEN 
                                            ".":U + gsc_object.object_extension
                                        ELSE
                                            "":U ).
        
        /* Attribute values are stored at the individual object instance level. This
         * maintenance is performed by the relevant write trigger, which cascades the
         * attribute values down to the object instance.                               */        
        DYNAMIC-FUNCTION("getAttributeValues":U,
                         INPUT        pcLogicalObjectName,
                         INPUT        gsc_object_type.object_type_obj,
                         INPUT        ryc_smartObject.smartobject_obj,
                         INPUT        ryc_object_instance.object_instance_obj,
                         INPUT        pdContainerSmartObjectObj,
                         INPUT        plDynamicUiContainer,
                         INPUT-OUTPUT cLocalAttributes                        ).

        /* UI Events. These are stored at the individual object instance level. */
        FOR EACH ryc_ui_event WHERE
                 ryc_ui_event.object_type_obj           = gsc_object_type.object_type_obj         AND
                 ryc_ui_event.smartobject_obj           = ryc_smartObject.smartobject_obj         AND
                 ryc_ui_event.object_instance_obj       = ryc_object_instance.object_instance_obj AND
                 ryc_ui_event.container_smartobject_obj = pdContainerSmartObjectObj
                 NO-LOCK:
            CREATE ttUiEvent.
            ASSIGN ttUiEvent.ContainerLogicalObject = pcLogicalObjectName
                   ttUiEvent.ObjectInstanceObj      = ryc_object_instance.object_instance_obj
                   ttUiEvent.EventName              = ryc_ui_event.event_name
                   ttUiEvent.ActionType             = ryc_ui_event.action_type
                   ttUiEvent.EventAction            = ryc_ui_event.event_action
                   ttUiEvent.EventParameter         = ryc_ui_event.event_parameter
                   ttUiEvent.EventDisabled          = ryc_ui_event.event_disabled
                   .
            IF LOOKUP(ryc_ui_event.action_target, "SELF,ANYWHERE,CONTAINER":U) EQ 0 THEN
            DO:
                FIND FIRST gsc_manager_type WHERE
                           gsc_manager_type.manager_type_code = ryc_ui_event.action_target
                           NO-LOCK NO-ERROR.
                IF AVAILABLE gsc_manager_type THEN
                    ASSIGN ttUiEvent.ActionTarget = gsc_manager_type.static_handle.
            END.    /* action target is a manager */
            ELSE
                ASSIGN ttUiEvent.ActionTarget = ryc_ui_event.action_target.
        END.    /* UI Events */

        IF gsc_object_type.object_type_code = "SmartFolder" THEN
        DO:
            /* Load folder page labels from the page */       
            FOR EACH ryc_page WHERE
                     ryc_page.container_smartobject_obj = pdContainerSmartObjectObj
                     NO-LOCK
                     BY ryc_page.page_sequence:
                ASSIGN cPageLabels = cPageLabels + (IF NUM-ENTRIES(cPageLabels, "|":U) EQ 0 THEN "":U ELSE "|":U )
                                   + ryc_page.page_label.
            END.    /* pages */

            DYNAMIC-FUNCTION("createAttributeValue":U,
                             INPUT        pcLogicalObjectName,
                             INPUT        plDynamicUiContainer,
                             INPUT        ryc_object_instance.object_instance_obj,
                             INPUT        "":U,
                             INPUT        "":U,
                             INPUT        "FolderLabels":U,
                             INPUT        cPageLabels,
                             INPUT-OUTPUT cLocalAttributes).           
        END.    /* SmartFolder */

        /* We do not store the attribute values in concatenated form, because we
         * cannot be certain that we're not going to exceed the Progress limits and
         * get Error 444. This field is not populated when we retrieve the attribute
         * values because there will be cases where we retrieve many attribute values,
         * and this may cause the limit to be exceeded. This may be the case when
         * dealing with the Dynamic Viewer, which may have many object instances,
         * each with many attribute values. For more details, see that procedure
         * and related documentation.
         *
         * In cases where we can be fairly certain that we will not exceed this limit,
         * a concatenated attribute string can be stored. The instance_attribute_list
         * field is retained for this reason, but the use thereof is at the developer's
         * discretion.
         * This is acually used still in the dynamic UI container rather than passing
         * back individual attribute records.
         */
        CREATE tt_object_instance.
        ASSIGN tt_object_instance.logical_object_name       = pcLogicalObjectName
               tt_object_instance.layout_position           = ryc_object_instance.layout_position
               tt_object_instance.object_instance_obj       = ryc_object_instance.object_instance_obj
               tt_object_instance.object_pathed_filename    = cPathedObjectName
               tt_object_instance.object_instance_handle    = ?
               tt_object_instance.object_frame_handle       = ?
               tt_object_instance.object_type_code          = gsc_object_type.object_type_code
               tt_object_instance.db_aware                  = (tt_object_instance.object_type_code = "SDO":U OR tt_object_instance.object_type_code = "SBO":U)
               tt_object_instance.custom_super_procedure    = ryc_smartObject.custom_super_procedure
               tt_object_instance.instance_attribute_list   = "":U
               tt_object_instance.page_number               = 0
               tt_object_instance.instance_is_a_container   = CAN-FIND(FIRST rycoi WHERE
                                                                             rycoi.container_smartObject_obj = ryc_object_instance.smartObject_obj)
               tt_object_instance.instance_object_name      = ryc_smartObject.object_filename
               .
        /* Get the data version */
        IF gsc_object.logical_object THEN
        DO:
            FIND FIRST rym_data_version WHERE
                       rym_data_version.related_entity_key      = gsc_object.object_filename AND
                       rym_data_version.related_entity_mnemonic = "RYCSO":U
                       NO-LOCK NO-ERROR.
            IF AVAILABLE rym_data_version THEN            
                DYNAMIC-FUNCTION("createAttributeValue":U,
                                 INPUT        pcLogicalObjectName,
                                 INPUT        plDynamicUiContainer,
                                 INPUT        ryc_object_instance.object_instance_obj,
                                 INPUT        "":U,
                                 INPUT        "":U,
                                 INPUT        "LogicalVersion":U,
                                 INPUT        STRING(rym_data_version.data_version_number, "999999":U),
                                 INPUT-OUTPUT cLocalAttributes).
        END.    /* Logical Object */

        /* FudgeIt!(tm) */
        IF tt_object_instance.object_pathed_filename = "ry/obj/rydynfoldw":U THEN
            ASSIGN tt_object_instance.object_pathed_filename = "gui/adm2/folder":U.

        IF plDynamicUiContainer THEN
        DO:
            /* Deal with defaults */
            IF tt_object_instance.layout_position                                  EQ "":U AND
               INDEX(tt_object_instance.instance_attribute_list, "ADM2Navigation") GT 0    THEN
                ASSIGN tt_object_instance.layout_position = "TOP".
            ELSE
            IF tt_object_instance.layout_position                                EQ "":U AND 
               INDEX(tt_object_instance.instance_attribute_list, "BROWSESEARCH") GT 0    THEN
                ASSIGN tt_object_instance.layout_position = "BOTTOM".
            ELSE
            IF tt_object_instance.layout_position EQ "":U THEN
               ASSIGN tt_object_instance.layout_position = "CENTRE".
            
            /* set instantiation order */
            IF INDEX(tt_object_instance.object_type_code, "sdo":U) NE 0 THEN
                ASSIGN tt_object_instance.instance_order = 1.
            ELSE
            IF INDEX(tt_object_instance.object_type_code, "toolbar":U) NE 0 THEN
            DO:
                IF tt_object_instance.layout_position BEGINS "top":U THEN
                    ASSIGN tt_object_instance.instance_order = 2.
                ELSE
                    ASSIGN tt_object_instance.instance_order = 3.
            END.    /* Not SDO */
            ELSE
            IF INDEX(tt_object_instance.object_type_code, "smartfolder":U) NE 0 THEN
                ASSIGN tt_object_instance.instance_order = 4.
            ELSE
                ASSIGN tt_object_instance.instance_order = 99.
        END.    /* Dynamic UI container */

        /* Catch those objects not assigned directly to any page and put them on page 0 */
        IF NOT CAN-FIND(FIRST ryc_page_object WHERE
                              ryc_page_object.container_smartObject_obj = ryc_object_instance.container_smartObject_obj AND
                              ryc_page_object.object_instance_obj       = ryc_object_instance.object_instance_obj           ) THEN
        DO:
            CREATE tt_page_instance.
            ASSIGN tt_page_instance.logical_object_name = pcLogicalObjectName
                   tt_page_instance.page_number         = 0
                   tt_page_instance.object_instance_obj = ryc_object_instance.object_instance_obj
                   tt_page_instance.layout_position     = tt_object_instance.layout_position
                   .
        END.    /* things on Page 0 */

        /* If an object is a static object, then everything it contains 
         * already exists in the physical code of that object, so there is 
         * no need to retrieve any more information.                       */
        IF tt_object_instance.instance_is_a_container                                     AND
           ryc_smartObject.static_object                                             = NO AND
           NOT DYNAMIC-FUNCTION("MasterInCache":U, INPUT ryc_smartObject.object_filename) THEN
        DO:
            /* Put the master in the local cache, so that we don't retrieve it more than once.
             * This object will be added to the permanent cache once the data is returned to
             * the Repository Manager.      */
            DYNAMIC-FUNCTION("AddMasterToCache":U, INPUT ryc_smartObject.object_filename).

            /* Create a master record for objects which are containers, and retrieve their attributes. */            
            CREATE lb_object_instance.
            BUFFER-COPY tt_object_instance TO lb_object_instance
                ASSIGN lb_object_instance.logical_object_name       = ryc_smartObject.object_filename
                       lb_object_instance.layout_position           = "":U
                       lb_object_instance.object_instance_obj       = 0
                       lb_object_instance.page_number               = 0
                       .
            /* Create attributes for the master */
            /* Retrieve all attributes for the containing SmartObject. */
            /* Assumes dynamic UI container is called rydyncontw.w */
            IF AVAILABLE gscob                                   AND 
               ( gscob.object_filename BEGINS "rydyncont":U OR
                 gscob.object_filename BEGINS "rydyntree":U    ) THEN
                ASSIGN lInstanceIsUiContainer = YES.
            ELSE
                ASSIGN lInstanceIsUiContainer = NO.

            /* Master attribute values. */
            DYNAMIC-FUNCTION("getAttributeValues":U,
                             INPUT        lb_object_instance.logical_object_name,
                             INPUT        gsc_object_type.object_type_obj,
                             INPUT        ryc_smartObject.smartobject_obj,
                             INPUT        0,
                             INPUT        0,
                             INPUT        lInstanceIsUiContainer,
                             INPUT-OUTPUT cLocalAttributes                        ).

            /* Assumes dynamic UI container is called rydyncontw.w */
            IF AVAILABLE gscob                                   AND 
               ( gscob.object_filename BEGINS "rydyncont":U OR
                 gscob.object_filename BEGINS "rydyntree":U    ) THEN
                ASSIGN lInstanceIsUiContainer = YES.
            ELSE
                ASSIGN lInstanceIsUiContainer = NO.

            RUN getInstanceData ( INPUT ryc_object_instance.smartObject_obj,
                                  INPUT lInstanceIsUiContainer,
                                  INPUT ryc_smartObject.object_filename     ).
        END.    /* is a container */

        /* If the object instance has an attribute of "VisualizationType" and
         * this has a value which is not "SmartDataField" and the "SDFFIleName"
         * attribute has a value, then the SmartDataField referenced in the attribute
         * value is to be used.
         *
         * All of the existing attribute values and UI events for this obejct instance 
         * will be deleted, and the attribute values and UI events for the SDF will
         * be used. The SDF becomes a temporary object instance for the dynamic viewer. */
        FIND FIRST ttAttributeValue WHERE
                   ttAttributeValue.ContainerLogicalObject = pcLogicalObjectName                     AND
                   ttAttributeValue.ObjectInstanceObj      = ryc_object_instance.object_instance_obj AND
                   ttAttributeValue.AttributeLabel         = "SdfFileName"                           AND
                   ttAttributeValue.AttributeValue        <> "":U                                    AND
                   CAN-FIND(FIRST lbAttributeValue WHERE
                                  lbAttributeValue.ContainerLogicalObject = pcLogicalObjectName                     AND
                                  lbAttributeValue.ObjectInstanceObj      = ryc_object_instance.object_instance_obj AND
                                  lbAttributeValue.AttributeLabel         = "VisualizationType":U                   AND
                                  lbAttributeValue.AttributeValue        <> "SmartDataField":U                          )
                   NO-ERROR.
        IF AVAILABLE ttAttributeValue THEN        
            RUN AutoAttachSdf ( INPUT        pcLogicalObjectName,
                                INPUT        ryc_object_instance.object_instance_obj,
                                INPUT        ttAttributeValue.AttributeValue,
                                INPUT        plDynamicUiContainer,
                                INPUT-OUTPUT cLocalAttributes,
                                BUFFER       tt_object_instance                       ).        

        /* For dynamic UI containers we do actually store the attribute values in
         * a single string. This avoids having to read through them again on the 
         * dynamic container                                                     */        
        IF plDynamicUiContainer THEN
            ASSIGN tt_object_instance.instance_attribute_list = cLocalAttributes.
    END. /* Object instances */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-AddMasterToCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION AddMasterToCache Procedure 
FUNCTION AddMasterToCache RETURNS LOGICAL
    ( INPUT pcLogicalObjectName         AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates a local entry in the cache of master objects. If an object 
            appears on a container more than once, and it does not appear in 
            the cache on the Repository Manager cache yet, it will not appear
            in the cache that has been received from the Repository Manager.
            To prevent the object from being retrieved more than once, we add
            an entry to the local version of the cache. The object will be added
            to the Repository cache once this data is returned.
  Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hFieldObjectName            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hFieldObjectInstance        AS HANDLE               NO-UNDO.

    IF VALID-HANDLE(ghBufferObjectCache) THEN
    DO TRANSACTION:
        ASSIGN hFieldObjectName     = ghBufferObjectCache:BUFFER-FIELD("logical_object_name":U)
               hFieldObjectInstance = ghBufferObjectCache:BUFFER-FIELD("object_instance_obj":U)
               .
        ghBufferObjectCache:BUFFER-CREATE().
        ASSIGN hFieldObjectName:BUFFER-VALUE     = pcLogicalObjectName
               hFieldObjectInstance:BUFFER-VALUE = 0
               .
        ghBufferObjectCache:BUFFER-RELEASE().
    END.    /* we've got a cache of masters */

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createAttributeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createAttributeValue Procedure 
FUNCTION createAttributeValue RETURNS LOGICAL
    ( INPUT        pcLogicalObjectName          AS CHARACTER,
      INPUT        plDynamicUiContainer         AS LOGICAL,
      INPUT        pdObjectInstanceObj          AS DECIMAL,
      INPUT        pcAttributeGroup             AS CHARACTER,
      INPUT        pcAttributeType              AS CHARACTER,
      INPUT        pcAttributeLabel             AS CHARACTER,
      INPUT        pcAttributeValue             AS CHARACTER,
      INPUT-OUTPUT pcLocalAttributes            AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates attribute values records, or builds a property string.
    Notes:  
------------------------------------------------------------------------------*/
    IF plDynamicUIContainer THEN
        ASSIGN pcLocalAttributes = pcLocalAttributes + (IF NUM-ENTRIES(pcLocalAttributes, CHR(3)) = 0 THEN "":U ELSE CHR(3))
                                + (pcAttributeLabel + CHR(4) + (IF pcAttributeValue EQ ? THEN "?":U ELSE pcAttributeValue)).
    CREATE ttAttributeValue.
    ASSIGN ttAttributeValue.containerLogicalObject = pcLogicalObjectName
           ttAttributeValue.ObjectInstanceObj      = pdObjectInstanceObj
           ttAttributeValue.attributeGroup         = pcAttributeGroup
           ttAttributeValue.attributeType          = pcAttributeType
           ttAttributeValue.attributeLabel         = pcAttributeLabel
           ttAttributeValue.attributeValue         = pcAttributeValue
           .
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAttributeValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAttributeValues Procedure 
FUNCTION getAttributeValues RETURNS LOGICAL
    ( INPUT        pcLogicalObjectName         AS CHARACTER,
      INPUT        pdObjectTypeObj             AS DECIMAL,
      INPUT        pdSmartObjectObj            AS DECIMAL,
      INPUT        pdObjectInstanceObj         AS DECIMAL,
      INPUT        pdContainerSmartObjectObj   AS DECIMAL,
      INPUT        plDynamicUiContainer        AS LOGICAL,
      INPUT-OUTPUT pcLocalAttributes           AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates entries in the ttAttributeValue table
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE BUFFER ryc_attribute_value       FOR ryc_attribute_value.
    DEFINE BUFFER ryc_attribute_group       FOR ryc_attribute_group.

    FOR EACH ryc_attribute_value WHERE
             ryc_attribute_value.object_type_obj           = pdObjectTypeObj          AND
             ryc_attribute_value.smartobject_obj           = pdSmartObjectObj         AND
             ryc_attribute_value.object_instance_obj       = pdObjectInstanceObj      AND
             ryc_attribute_value.container_smartobject_obj = pdContainerSmartObjectObj
             NO-LOCK,
       FIRST ryc_attribute_group WHERE
             ryc_attribute_group.attribute_group_obj = ryc_attribute_value.attribute_group_obj
             NO-LOCK:
        DYNAMIC-FUNCTION("createAttributeValue":U,
                         INPUT        pcLogicalObjectName,
                         INPUT        plDynamicUiContainer,
                         INPUT        pdObjectInstanceObj,
                         INPUT        ryc_attribute_group.attribute_group_name,
                         INPUT        ryc_attribute_value.attribute_type,
                         INPUT        ryc_attribute_value.attribute_label,
                         INPUT        DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager,
                                                       INPUT ryc_attribute_value.attribute_type_TLA,
                                                       INPUT ryc_attribute_value.attribute_value),
                         INPUT-OUTPUT pcLocalAttributes).
    END.    /* attribute values of the object instance. */

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-MasterInCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION MasterInCache Procedure 
FUNCTION MasterInCache RETURNS LOGICAL
    ( INPUT pcLogicalObjectName         AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Determines whether to cache an object or not.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lMasterInCache              AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE hQuery                      AS HANDLE               NO-UNDO.

    IF VALID-HANDLE(ghBufferObjectCache) THEN
    DO:
        CREATE QUERY hQuery.
        hQuery:ADD-BUFFER(ghBufferObjectCache).
        hQuery:QUERY-PREPARE(" FOR EACH tt_object_cache WHERE ":U
                           + " tt_object_cache.logical_object_name = '" + pcLogicalObjectName + "' AND ":U
                           + " tt_object_cache.object_instance_obj = 0 ").

        hQuery:QUERY-OPEN().
        hQuery:GET-FIRST(NO-LOCK).

        ASSIGN lMasterInCache = ghBufferObjectCache:AVAILABLE.

        hQuery:QUERY-CLOSE().

        DELETE OBJECT hQuery NO-ERROR.
        ASSIGN hQuery = ?.
    END.    /* valid buffer */
    ELSE
        ASSIGN lMasterInCache = NO.
    
    RETURN lMasterInCache.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

