&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
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
/*---------------------------------------------------------------------------------
  File: contbuildp.p

  Description:  Container Prop Sheet Business Logic PLIP

  Purpose:      Container Property Sheet Business Logic PLIP

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   10/03/2001  Author:     

  Update Notes: Created from Template rytemplipp.p

  (v:010002)    Task:           0   UserRef:    
                Date:   03/18/2002  Author:     Mark Davies

  Update Notes: Added MinWidth and MinHeight properties to be copied for all object types and not just for viewers.
                This would accomodate new objects created with Dynamic Browsers.
                Fix for issue #4060 - tab folder + browser causes layout problems

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       contbuildp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{ afglobals.i }
{ ry/app/containeri.i }

DEFINE INPUT PARAMETER TABLE FOR ttContainer.
DEFINE INPUT PARAMETER TABLE FOR ttPage.
DEFINE INPUT PARAMETER TABLE FOR ttPageInstance.
DEFINE INPUT PARAMETER TABLE FOR ttLink.

DEFINE VARIABLE dContainerObj           AS DECIMAL                  NO-UNDO.
DEFINE VARIABLE dPageObj                AS DECIMAL                  NO-UNDO.
DEFINE VARIABLE dObjectInstanceObj      AS DECIMAL                  NO-UNDO.
DEFINE VARIABLE dMasterSmartObject      AS DECIMAL                  NO-UNDO.
DEFINE VARIABLE iAttributeLoop          AS INTEGER                  NO-UNDO.

/* These are attribute whose values must be taken from the Master SmartObject, and not the 
 * template object instance. This is used in ModifyObjectInstance                          */
&SCOPED-DEFINE MASTER-ATTRIBUTES-BROWSE DisplayedFields,EnabledFields
&SCOPED-DEFINE MASTER-ATTRIBUTES-VIEWER 
&SCOPED-DEFINE MASTER-ATTRIBUTES-ALL    DynamicObject,ResizeVertical,ResizeHorizontal,MinHeight,MinWidth

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
         HEIGHT             = 14.43
         WIDTH              = 58.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */
DEFINE BUFFER rycso     FOR ryc_smartObject.

{ ry/app/ryplipmain.i }

FIND FIRST ttContainer NO-ERROR.

IF AVAILABLE ttContainer THEN
DO TRANSACTION:
    /* Update the Container SmartObject */
    RUN ModifyContainer ( BUFFER ttContainer,
                          OUTPUT dContainerObj  ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    /* Object Instances. */
    FOR EACH ttPage
             BY ttPage.tPageSequence:

        RUN ModifyPage ( BUFFER ttPage,
                         INPUT  dContainerObj,
                         OUTPUT dPageObj       ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* Update the page instances */
        FOR EACH ttPageInstance WHERE
                 ttPageInstance.tParentKey = ttPage.tLocalSequence :
            /* Object Instances */
            RUN ModifyObjectInstance ( BUFFER ttPageInstance,
                                       INPUT  dContainerObj,
                                       OUTPUT dObjectInstanceObj,
                                       OUTPUT dMasterSmartObject  ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

            /* Page Object Records.
             * If an object instance is deleted, the delete trigger deletes the 
             * Page Objects too.                                                */
            IF ttPageInstance.tOIAction NE "DEL":U THEN
            DO:
                RUN ModifyPageObject ( BUFFER ttPageInstance,
                                       INPUT  dContainerObj,
                                       INPUT  dPageObj,
                                       INPUT  dObjectInstanceObj ) NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
            END.    /* not deleting the object instance. */

            /* Attribute Values.
             * The object instance will not be available idf it has been deleted. */
            FIND rycso WHERE
                 rycso.smartObject_obj = dMasterSmartObject
                 NO-LOCK NO-ERROR.
            IF AVAILABLE rycso THEN
            DO:
                /* Set any extra attributes forst. This is in case any of the following
                 * attribute have different values. We take the values which are set explicitly
                 * in the CB (as opposed to the Toolbar dialogue).                             */
                IF ttPageInstance.tAttributeLabels NE "":U AND ttPageInstance.tAttributeLabels NE ? THEN
                DO iAttributeLoop = 1 TO NUM-ENTRIES(ttPageInstance.tAttributeLabels):
                    RUN setAttributeValues ( INPUT rycso.object_type_obj,
                                             INPUT rycso.smartObject_obj,
                                             INPUT dContainerObj,           /* container */
                                             INPUT dObjectInstanceObj,
                                             INPUT ENTRY(iAttributeLoop, ttPageInstance.tAttributeLabels),
                                             INPUT ENTRY(iAttributeLoop, ttPageInstance.tAttributeValues, CHR(3)) ) NO-ERROR.
                    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
                END.    /* extra attributes */

                /* Window Title Field */
                IF ttPageInstance.tWindowTitleField NE ? AND ttPageInstance.tWindowTitleField NE "?":U THEN
                DO:
                    RUN setAttributeValues ( INPUT rycso.object_type_obj,
                                             INPUT rycso.smartObject_obj,
                                             INPUT dContainerObj,           /* container */
                                             INPUT dObjectInstanceObj,
                                             INPUT "WindowTitleField":U,
                                             INPUT ttPageInstance.tWindowTitleField ) NO-ERROR.
                    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
                END.    /* WindowTitleField */

                /* Foreign Fields */
                IF ttPageInstance.tForeignFields NE ? AND ttPageInstance.tForeignFields NE "?":U THEN
                DO:
                    RUN setAttributeValues( INPUT rycso.object_type_obj,
                                            INPUT rycso.smartObject_obj,
                                            INPUT dContainerObj,       /* container */
                                            INPUT dObjectInstanceObj,
                                            INPUT "ForeignFields":U,
                                            INPUT ttPageInstance.tForeignFields ) NO-ERROR.
                    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
                END.    /* ForeignFields  */

                /* NavigationTargetName */
                IF ttPageInstance.tNavigationTargetName NE ? AND ttPageInstance.tNavigationTargetName NE "?":U THEN
                DO:
                    RUN setAttributeValues ( INPUT rycso.object_type_obj,
                                             INPUT rycso.smartObject_obj,
                                             INPUT dContainerObj,       /* container */
                                             INPUT dObjectInstanceObj,
                                             INPUT "NavigationTargetName":U,
                                             INPUT ttPageInstance.tNavigationTargetName ) NO-ERROR.
                    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
                END.    /* NavigationTargetName */

                /* FolderWindowToLaunch */
                IF ttPageInstance.tLaunchContainer NE ? AND ttPageInstance.tLaunchContainer NE "?":U THEN
                DO:
                    RUN setAttributeValues ( INPUT rycso.object_type_obj,
                                             INPUT rycso.smartObject_obj,
                                             INPUT dContainerObj,       /* container */
                                             INPUT dObjectInstanceObj,
                                             INPUT "FolderWindowToLaunch":U,
                                             INPUT ttPageInstance.tLaunchContainer ) NO-ERROR.
                    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
                END.    /* FolderWindowToLaunch */
    
                /* TemplateObjectName */
                IF ttPageInstance.tTemplateObjectFilename EQ ? OR ttPageInstance.tTemplateObjectFilename EQ "?":U THEN
                    ASSIGN ttPageInstance.tTemplateObjectFilename = "":U.

                RUN setAttributeValues ( INPUT rycso.object_type_obj,
                                         INPUT rycso.smartObject_obj,
                                         INPUT dContainerObj,       /* container */
                                         INPUT dObjectInstanceObj,
                                         INPUT "TemplateObjectName":U,
                                         INPUT ttPageInstance.tTemplateObjectFilename ) NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.                
            END.    /* smart objectavailable */            
        END.    /* Page instances. */
    END.    /* page */

    /* Update the links. */
    RUN ModifyLinks ( INPUT dContainerObj ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
END.    /* TRANSACTION. */

RETURN.
/*- EOF -*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-CascadeMasterAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CascadeMasterAttributes Procedure 
PROCEDURE CascadeMasterAttributes :
/*------------------------------------------------------------------------------
  Purpose:     Cascades certain attributes from the master smartObject.
  Parameters:  pcObjectTypeCode    -
               pdObjectTypeObj     -
               pdSmartObjectObj    -
               pdContainerObj      -
               pdObjectInstanceObj -  
  Notes:       * There are certain attribute which must be cascaded from the Master
                 smartObject, and cannot be copied from the template object
                 instance's attribute values.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcObjectTypeCode         AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pdObjectTypeObj          AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER pdSmartObjectObj         AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER pdContainerObj           AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER pdObjectInstanceObj      AS DECIMAL          NO-UNDO.

    DEFINE VARIABLE cMasterAttributes       AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE iCascadeLoop            AS INTEGER                  NO-UNDO.

    DEFINE BUFFER rycav_template        FOR ryc_attribute_value.

    CASE pcObjectTypeCode:
        WHEN "DynBrow":U THEN ASSIGN cMasterAttributes = "{&MASTER-ATTRIBUTES-BROWSE}":U.
        WHEN "DynView":U THEN ASSIGN cMasterAttributes = "{&MASTER-ATTRIBUTES-VIEWER}":U.
        OTHERWISE             ASSIGN cMasterAttributes = "":U.
    END CASE.   /* ObjectTypeCode */

    ASSIGN cMasterAttributes = cMasterAttributes + ",":U + "{&MASTER-ATTRIBUTES-ALL}":U.
    
    IF cMasterAttributes NE "":U THEN
    DO iCascadeLoop = 1 TO NUM-ENTRIES(cMasterAttributes):
        FIND FIRST rycav_template WHERE
                   rycav_template.object_type_obj           = pdObjectTypeObj                        AND
                   rycav_template.smartObject               = pdSmartObjectObj                       AND
                   rycav_template.attribute_label           = ENTRY(iCascadeLoop, cMasterAttributes) AND
                   rycav_template.object_instance_obj       = 0                                      AND
                   rycav_template.container_smartObject_obj = 0
                   NO-LOCK NO-ERROR.
        IF AVAILABLE rycav_template THEN
        DO:
            RUN setAttributeValues ( INPUT pdObjectTypeObj,
                                     INPUT pdSmartObjectObj,
                                     INPUT pdContainerObj,
                                     INPUT pdObjectInstanceObj,
                                     INPUT rycav_template.attribute_label,
                                     INPUT rycav_template.attribute_value    ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* avail rycav_template */
    END.    /* cascade attributes */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DeletePageInstances) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeletePageInstances Procedure 
PROCEDURE DeletePageInstances :
/*------------------------------------------------------------------------------
  Purpose:     Deletes everythign associated with a page, excpet the page itself.
               This includes page objects, object instances, attribute values and
               UI events. 
  Parameters:  pdContaienrObj -
               pdPageObj      -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdContainerObj   AS DECIMAL                  NO-UNDO.
    DEFINE INPUT PARAMETER pdPageObj        AS DECIMAL                  NO-UNDO.

    DEFINE BUFFER rycoi         FOR ryc_object_instance.
    DEFINE BUFFER rycoi_delete  FOR ryc_object_instance.
    DEFINE BUFFER rycpo         FOR ryc_page_object.
    DEFINE BUFFER rycpo_delete  FOR ryc_page_object.
    DEFINE BUFFER rycso         FOR ryc_smartObject.
    DEFINE BUFFER rycsm         FOR ryc_smartLink.
    DEFINE BUFFER rycav         FOR ryc_attribute_value.
    DEFINE BUFFER rycue         FOR ryc_ui_event.    

    /* Page0 */
    IF pdPageObj EQ -1 THEN
    DO:
        FOR EACH rycoi WHERE
                 rycoi.container_smartObject_obj = pdContainerObj AND
                 NOT CAN-FIND(FIRST rycpo WHERE
                                    rycpo.container_smartObject_obj = pdContainerObj        AND
                                    rycpo.object_instance_obj       = rycoi.object_instance_obj )
                 NO-LOCK,
           FIRST rycso WHERE
                 rycso.smartObject_obj = rycoi.smartObject_obj
                 NO-LOCK:

            /* Links */
            FOR EACH rycsm WHERE
                     rycsm.container_smartObject_obj = pdContainerObj AND
                     ( rycsm.source_object_instance_obj = rycoi.object_instance_obj OR
                       rycsm.target_object_instance_obj = rycoi.object_instance_obj    )
                     EXCLUSIVE-LOCK:
                DELETE rycsm NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
            END.    /* smartlinks */
    
            /* Attribute Values */
            FOR EACH rycav WHERE
                     rycav.object_type_obj           = rycso.object_type_obj     AND
                     rycav.container_smartObject_obj = pdContainerObj            AND
                     rycav.smartObject_obj           = rycso.smartObject_obj     AND
                     rycav.object_instance_obj       = rycoi.object_instance_obj
                     EXCLUSIVE-LOCK:
                DELETE rycav NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
            END.    /* attribute values */
    
            /* UI Events */
            FOR EACH rycue WHERE
                     rycue.object_type_obj           = rycso.object_type_obj     AND
                     rycue.container_smartObject_obj = pdContainerObj            AND
                     rycue.smartObject_obj           = rycso.smartObject_obj     AND
                     rycue.object_instance_obj       = rycoi.object_instance_obj
                     EXCLUSIVE-LOCK:
                DELETE rycue NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
            END.    /* UI events */

            /* Delete the obect instance. */
            FIND rycoi_delete WHERE
                 ROWID(rycoi_delete) = ROWID(rycoi)
                 EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
            IF AVAILABLE rycoi_delete THEN
            DO:
                DELETE rycoi_delete NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
            END.    /* avail rycoi_delete */
        END.    /* object instances */
    END.    /* Page 0 */
    ELSE
    /* Other Pages. */
    IF pdPageObj GT 0 THEN
    FOR EACH rycpo WHERE
             rycpo.container_smartObject_obj = pdContainerObj AND
             rycpo.page_obj                  = pdPageObj
             NO-LOCK:

        /* Object Instances */
        FOR EACH rycoi WHERE
                 rycoi.object_instance_obj = rycpo.object_instance_obj
                 NO-LOCK,
           FIRST rycso WHERE
                 rycso.smartObject_obj = rycoi.smartObject_obj
                 NO-LOCK:
            /* Links */
            FOR EACH rycsm WHERE
                     rycsm.container_smartObject_obj = pdContainerObj AND
                     ( rycsm.source_object_instance_obj = rycoi.object_instance_obj OR
                       rycsm.target_object_instance_obj = rycoi.object_instance_obj    )
                     EXCLUSIVE-LOCK:
                DELETE rycsm NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
            END.    /* smartlinks */

            /* Attribute Values */
            FOR EACH rycav WHERE
                     rycav.object_type_obj           = rycso.object_type_obj     AND
                     rycav.container_smartObject_obj = pdContainerObj            AND
                     rycav.smartObject_obj           = rycso.smartObject_obj     AND
                     rycav.object_instance_obj       = rycoi.object_instance_obj
                     EXCLUSIVE-LOCK:
                DELETE rycav NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
            END.    /* attribute values */

            /* UI Events */
            FOR EACH rycue WHERE
                     rycue.object_type_obj           = rycso.object_type_obj     AND
                     rycue.container_smartObject_obj = pdContainerObj            AND
                     rycue.smartObject_obj           = rycso.smartObject_obj     AND
                     rycue.object_instance_obj       = rycoi.object_instance_obj
                     EXCLUSIVE-LOCK:
                DELETE rycue NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
            END.    /* UI events */

            FIND rycoi_delete WHERE
                 ROWID(rycoi_delete) = ROWID(rycoi)
                 EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
            IF AVAILABLE rycoi_delete THEN
            DO:
                DELETE rycoi_delete NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
            END.    /* avail rycoi_delete */
        END.    /* object instance */

        /* Delete the page object. */
        FIND rycpo_delete WHERE
             ROWID(rycpo_delete) = ROWID(rycpo)
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.

        IF AVAILABLE rycpo_delete THEN
        DO:
            DELETE rycpo_delete NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* avail rycpo_delete */
    END.    /* each page */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {ry/app/ryplipkill.i}
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ModifyContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ModifyContainer Procedure 
PROCEDURE ModifyContainer :
/*------------------------------------------------------------------------------
  Purpose:     Updates the container SmartObject record.
  Parameters:  buffer ttContainer
               pdContainerObj  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE PARAMETER BUFFER pbContainer FOR ttContainer.
    DEFINE OUTPUT PARAMETER pdContainerObj          AS DECIMAL          NO-UNDO.

    DEFINE VARIABLE iErrorCount         AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE cErrorText          AS CHARACTER                    NO-UNDO.

    DEFINE BUFFER gscob                 FOR gsc_object.
    DEFINE BUFFER gsc_object            FOR gsc_object.
    DEFINE BUFFER ryc_smartObject       FOR ryc_smartObject.
    DEFINE BUFFER rycso_container       FOR ryc_smartObject.    /* for the actual Container */

    /* Create container SmartObject, if needed. */
    CASE pbContainer.tAction:
        WHEN "TEMPLATE":U THEN
        DO:
            FIND FIRST ryc_smartObject WHERE
                       ryc_smartObject.smartObject_obj = pbContainer.tTemplateContainerObj
                       NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ryc_smartObject THEN
                RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_smartObject' 'object_filename' '"template SmartObject"' }.
    
            FIND FIRST gsc_object WHERE
                       gsc_object.object_obj = ryc_smartObject.object_obj
                       NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gsc_object THEN
                RETURN ERROR {aferrortxt.i 'AF' '5' 'gsc_object' 'object_obj' '"template object"'}.
    
            CREATE gscob NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    
            BUFFER-COPY gsc_object
                    EXCEPT object_obj object_filename
                TO gscob
                    ASSIGN gscob.object_filename     = pbContainer.tObjectName
                           gscob.object_description  = pbContainer.tObjectDescription
                           gscob.object_type_obj     = pbContainer.tObjectTypeObj
                           gscob.product_module_obj  = pbContainer.tProductModuleObj
                           gscob.container_object    = YES
                           gscob.DISABLED            = NO
                           gscob.security_object_obj = gscob.object_obj
                           NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
                ASSIGN cErrorText = "":U.
                DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                    ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                                      + ERROR-STATUS:GET-MESSAGE(iErrorCount).
                END.    /* loop through errors */
            
                RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
            END.    /* error */
            /* Validate later */
            
            CREATE rycso_container NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    
            BUFFER-COPY ryc_smartObject
                    EXCEPT smartObject_obj object_obj object_filename object_type_obj
                TO rycso_container
                    ASSIGN rycso_container.object_obj             = gscob.object_obj
                           rycso_container.object_filename        = gscob.object_filename
                           rycso_container.object_type_obj        = gscob.object_type_obj
                           rycso_container.product_module_obj     = gscob.product_module_obj
                           rycso_container.custom_super_procedure = pbContainer.tCustomSuperProc
                           rycso_container.template_smartObject   = pbContainer.tMakeThisTemplate
                           NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
                ASSIGN cErrorText = "":U.
                DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                    ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                                      + ERROR-STATUS:GET-MESSAGE(iErrorCount).
                END.    /* loop through errors */
            
                RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
            END.    /* error */
            /* Validate later */
    
            /* Don't create attribute values, since the replication write 
             * trigger already does this                                  */
        END.    /* TEMPLATE: create smartobject record based on a template. */
        WHEN "NEW":U THEN
        DO:
            CREATE gscob NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    
            ASSIGN gscob.object_filename     = pbContainer.tObjectName
                   gscob.object_description  = pbContainer.tObjectDescription
                   gscob.object_type_obj     = pbContainer.tObjectTypeObj
                   gscob.product_module_obj  = pbContainer.tProductModuleObj
                   gscob.container_object    = YES
                   gscob.DISABLED            = NO
                   gscob.security_object_obj = gscob.object_obj
                   gscob.logical_object      = YES
                   gscob.physical_object_obj = pbContainer.tPhysicalSmartObject
                   NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
                ASSIGN cErrorText = "":U.
                DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                    ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                                      + ERROR-STATUS:GET-MESSAGE(iErrorCount).
                END.    /* loop through errors */
            
                RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
            END.    /* error */
            /* Validate later */
    
            CREATE rycso_container NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    
            ASSIGN rycso_container.object_obj             = gscob.object_obj
                   rycso_container.object_filename        = gscob.object_filename
                   rycso_container.object_type_obj        = gscob.object_type_obj
                   rycso_container.product_module_obj     = gscob.product_module_obj
                   rycso_container.custom_super_procedure = pbContainer.tCustomSuperProc
                   rycso_container.template_smartObject   = pbContainer.tMakeThisTemplate
                   NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
                ASSIGN cErrorText = "":U.
                DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                    ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                                      + ERROR-STATUS:GET-MESSAGE(iErrorCount).
                END.    /* loop through errors */
            
                RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
            END.    /* error */
            /* Validate later */
    
            /* Don't create attribute values, since the replication write 
             * trigger already does this                                  */
        END.    /* NEW: not based on a template at all. */
        WHEN "OLD":U THEN
        DO:
            FIND FIRST rycso_container WHERE
                       rycso_container.smartObject_obj = pbContainer.tContainerObj
                       EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
            IF NOT AVAILABLE rycso_container THEN
                RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_smartObject' '?' '"SmartObject"' 'pbContainer.tObjectName' }.
            FIND gscob WHERE
                 gscob.object_obj = rycso_container.object_obj
                 EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        END.    /* OLD: modifying */
        OTHERWISE 
            RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"action"' '"Valid actions are: NEW, TEMPLATE or OLD."'}.
    END CASE.   /* tAction */    

    /* There will always be a gscob and rycso record available here. */
    ASSIGN gscob.object_description     = pbContainer.tObjectDescription
           gscob.object_type_obj        = pbContainer.tObjectTypeObj
           gscob.product_module_obj     = pbContainer.tProductModuleObj
           NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
    DO:
        ASSIGN cErrorText = "":U.
        DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
            ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                              + ERROR-STATUS:GET-MESSAGE(iErrorCount).
        END.    /* loop through errors */
    
        RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
    END.    /* error */

    VALIDATE gscob NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    ASSIGN rycso_container.object_type_obj        = gscob.object_type_obj
           rycso_container.product_module_obj     = gscob.product_module_obj
           rycso_container.custom_super_procedure = pbContainer.tCustomSuperProc
           rycso_container.template_smartObject   = pbContainer.tMakeThisTemplate
           rycso_container.layout_obj             = pbContainer.tLayoutObj
           NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
    DO:
        ASSIGN cErrorText = "":U.
        DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
            ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                              + ERROR-STATUS:GET-MESSAGE(iErrorCount).
        END.    /* loop through errors */
    
        RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
    END.    /* error */

    VALIDATE rycso_container NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    /* Make sure that some attribute values exist.  */
    IF pbContainer.tWindowTitle NE ? AND pbContainer.tWindowTitle NE "?":U THEN
    DO:    
        RUN setAttributeValues ( INPUT rycso_container.object_type_obj,
                                 INPUT rycso_container.smartObject_obj,
                                 INPUT 0,
                                 INPUT 0,
                                 INPUT "WindowName":U,
                                 INPUT pbContainer.tWindowTitle ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* window name exists */

    IF pbContainer.tDefaultMode NE ? AND pbContainer.tDefaultMode NE "?":U THEN
    DO:
        RUN setAttributeValues ( INPUT rycso_container.object_type_obj,
                                 INPUT rycso_container.smartObject_obj,
                                 INPUT 0,
                                 INPUT 0,
                                 INPUT "ContainerMode":U,
                                 INPUT pbContainer.tDefaultMode ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* default mode exists */

    RUN setAttributeValues ( INPUT rycso_container.object_type_obj,
                             INPUT rycso_container.smartObject_obj,
                             INPUT 0,
                             INPUT 0,
                             INPUT "TemplateObjectName":U,
                             INPUT pbContainer.tTemplateObjectName ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    ASSIGN pdContainerObj = rycso_container.smartObject_obj.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ModifyLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ModifyLinks Procedure 
PROCEDURE ModifyLinks :
/*------------------------------------------------------------------------------
  Purpose:     Updates SmartLinks on the container.
  Parameters:  pdContainerObj -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdContainerObj       AS DECIMAL              NO-UNDO.    

    DEFINE VARIABLE iErrorCount         AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE cErrorText          AS CHARACTER                    NO-UNDO.

    DEFINE BUFFER ttLink                FOR ttLink.
    DEFINE BUFFER ryc_smartLink_type    FOR ryc_smartLink_type.
    DEFINE BUFFER rycsm_actual          FOR ryc_smartLink.
    DEFINE BUFFER rycsm_template        FOR ryc_smartLink.

    FOR EACH ttLink :
        /* Clear the buffer. */
        FIND FIRST rycsm_actual WHERE
                   ROWID(rycsm_actual) = ?
                   NO-LOCK NO-ERROR.

        CASE ttLink.tAction:
            WHEN "TEMPLATE":U THEN
            DO:
                FIND FIRST rycsm_template WHERE
                           rycsm_template.smartLink_obj = ttLink.tLinkObj
                           NO-LOCK NO-ERROR.
                IF NOT AVAILABLE rycsm_template THEN
                    RETURN ERROR {aferrortxt.i 'AF' '5' 'rycsm_template' '?' '"SmartLink"' }.

                CREATE rycsm_actual NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

                BUFFER-COPY rycsm_template
                        EXCEPT smartLink_obj container_smartObject_obj source_object_instance_obj target_object_instance_obj
                    TO rycsm_actual
                        ASSIGN rycsm_actual.container_smartObject_obj  = pdContainerObj
                               rycsm_actual.target_object_instance_obj = ttLink.tTargetInstanceObj
                               rycsm_actual.source_object_instance_obj = ttLink.tSourceInstanceObj
                               NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
                /* validate later */
            END.    /* TEMPLATE */
            WHEN "OLD":U THEN
            DO:
                /* There is an existing SmartLink record. */
                FIND FIRST rycsm_actual WHERE
                           rycsm_actual.smartLink_obj = ttLink.tLinkObj
                           EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                IF NOT AVAILABLE rycsm_actual THEN
                    RETURN ERROR {aferrortxt.i 'AF' '5' 'rycsm_actual' '?' '"SmartLink"' }.
                /* Update and Validate later. */
            END.    /* OLD */
            WHEN "NEW":U THEN
            DO:
                /* Get link Name */
                FIND FIRST ryc_smartLink_type WHERE
                           ryc_smartLink_type.link_name = ttLink.tLinkName
                           NO-LOCK NO-ERROR.
                IF NOT AVAILABLE ryc_smartLink_type THEN
                    RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_smartLink_type' '?' '"SmartLink type"' "'Link Name: ' + ttLink.tLinkName" }.

                /* Create Link Record */
                CREATE rycsm_actual NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

                ASSIGN rycsm_actual.container_smartObject_obj  = pdContainerObj
                       rycsm_actual.smartLink_type_obj         = ryc_smartLink_type.smartLink_type_obj
                       rycsm_actual.link_name                  = ryc_smartLink_type.link_name
                       rycsm_actual.source_object_instance_obj = ttLink.tSourceInstanceObj
                       rycsm_actual.target_object_instance_obj = ttLink.tTargetInstanceObj
                       NO-ERROR.
                IF ERROR-STATUS:ERROR THEN
                DO:
                    ASSIGN cErrorText = "":U.
                    DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                        ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                                          + ERROR-STATUS:GET-MESSAGE(iErrorCount).
                    END.    /* loop through errors */

                    RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
                END.    /* error */
                /* validate later */
            END.    /* NEW */
            WHEN "DEL":U THEN
            DO:
                FIND FIRST rycsm_actual WHERE
                           rycsm_actual.smartLink_obj = ttLink.tLinkObj
                           EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                IF NOT AVAILABLE rycsm_actual THEN
                    RETURN ERROR {aferrortxt.i 'AF' '5' 'rycsm_actual' '?' '"SmartLink"' "ttLink.tLinkObj"}.

                DELETE rycsm_actual NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
            END.    /* DEL */
        END CASE.   /* Action */

        /* A rycsm record will not be availoable if the link has been deleted. */
        IF ttLink.tAction NE "DEL":U AND
           AVAILABLE rycsm_actual    THEN
        DO:
            ASSIGN rycsm_actual.target_object_instance_obj = ttLink.tTargetInstanceObj
                   rycsm_actual.source_object_instance_obj = ttLink.tSourceInstanceObj
                   NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
                ASSIGN cErrorText = "":U.
                DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                    ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                                      + ERROR-STATUS:GET-MESSAGE(iErrorCount).
                END.    /* loop through errors */
            
                RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
            END.    /* error */

            VALIDATE rycsm_actual NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* avail rycsm-actual */
    END.    /* each ttLink */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ModifyObjectInstance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ModifyObjectInstance Procedure 
PROCEDURE ModifyObjectInstance :
/*------------------------------------------------------------------------------
  Purpose:     Updates the object instance.
  Parameters:  buffer ttPageInstance -
               pdContainerObj        -
               pdObjectInstanceObj   -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE PARAMETER BUFFER pbPageInstance  FOR ttPageInstance.
    DEFINE INPUT  PARAMETER pdContainerObj          AS DECIMAL          NO-UNDO.
    DEFINE OUTPUT PARAMETER pdObjectInstanceObj     AS DECIMAL          NO-UNDO.
    DEFINE OUTPUT PARAMETER pdMasterSmartObject     AS DECIMAL          NO-UNDO.

    DEFINE VARIABLE iCascadeLoop        AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE cMasterAttributes   AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE iErrorCount         AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE cErrorText          AS CHARACTER                    NO-UNDO.

    DEFINE BUFFER rycoi_template        FOR ryc_object_instance.
    DEFINE BUFFER rycoi_actual          FOR ryc_object_instance.
    DEFINE BUFFER rycso_oi_actual       FOR ryc_smartObject.
    DEFINE BUFFER rycso_oi_template     FOR ryc_smartObject.
    DEFINE BUFFER rycav_template        FOR ryc_attribute_value.
    DEFINE BUFFER rycav_actual          FOR ryc_attribute_value.
    DEFINE BUFFER rycue_template        FOR ryc_ui_event.
    DEFINE BUFFER rycue_actual          FOR ryc_ui_event.

    CASE pbPageInstance.tOIAction:
        WHEN "TEMPLATE":U THEN
        DO:
            FIND rycoi_template WHERE
                 rycoi_template.object_instance_obj = pbPageInstance.tObjectInstanceObj
                 NO-LOCK NO-ERROR.
            IF NOT AVAILABLE rycoi_template THEN RETURN ERROR {aferrortxt.i 'AF' '5' 'rycoi_template' '?' '"object instance"' }.
        
            CREATE rycoi_actual NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        
            BUFFER-COPY rycoi_template  EXCEPT object_instance_obj container_smartObject_obj
                TO rycoi_actual
                    ASSIGN rycoi_actual.container_smartObject_obj = pdContainerObj NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
                ASSIGN cErrorText = "":U.
                DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                    ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                                      + ERROR-STATUS:GET-MESSAGE(iErrorCount).
                END.    /* loop through errors */            
                RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
            END.    /* error */
            /* Validate later. */
    
            /* Maintain Link integrity. */
            FOR EACH ttLink WHERE
                     ttLink.tSourceInstanceObj = rycoi_template.object_instance_obj OR
                     ttLink.tTargetInstanceObj = rycoi_template.object_instance_obj   :
                /* Ensure that the object instance name is correct. */
                IF ttLink.tSourceInstanceObj EQ rycoi_template.object_instance_obj THEN
                    ASSIGN ttLink.tSourceInstanceObj = rycoi_actual.object_instance_obj.
                ELSE
                    ASSIGN ttLink.tTargetInstanceObj = rycoi_actual.object_instance_obj.
            END.    /* links */
    
            /* The New SmartObject. */
            FIND FIRST rycso_oi_actual WHERE
                       rycso_oi_actual.object_filename = pbPageInstance.tObjectFilename
                       NO-LOCK NO-ERROR.
            IF NOT AVAILABLE rycso_oi_actual THEN RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_rycso_oi_actual' '?' '"SmartObject "' 'pbPageInstance.tObjectFilename' }.
            
            /* The Template SmartObject. */
            FIND FIRST rycso_oi_template WHERE
                       rycso_oi_template.object_filename = pbPageInstance.tTemplateObjectFilename
                       NO-LOCK NO-ERROR.
            IF NOT AVAILABLE rycso_oi_template THEN RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_rycso_oi_template' '?' '"SmartObject "' 'pbPageInstance.tTemplateObjectFilename' }.
    
            /* Create Attribute Values for the object instance.
             * Copy these from the template object instance.    */
            FOR EACH rycav_template WHERE
                     rycav_template.object_type_obj     = rycso_oi_template.object_type_obj  AND
                     rycav_template.smartObject_obj     = rycso_oi_template.smartObject_obj  AND
                     rycav_template.object_instance_obj = rycoi_template.object_instance_obj
                     NO-LOCK:
                RUN setAttributeValues ( INPUT rycso_oi_actual.object_type_obj,
                                         INPUT rycso_oi_actual.smartObject_obj,
                                         INPUT pdContainerObj,
                                         INPUT rycoi_actual.object_instance_obj,
                                         INPUT rycav_template.attribute_label,
                                         INPUT rycav_template.attribute_value    ) NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
            END.    /* master SmartObject attributes */

            /* Cascade any specified attributes from the Master Smartobject */
            RUN CascadeMasterAttributes ( INPUT pbPageInstance.tObjectTypeCode,
                                          INPUT rycso_oi_actual.object_type_obj,
                                          INPUT rycso_oi_actual.smartObject_obj,
                                          INPUT pdContainerObj,
                                          INPUT rycoi_actual.object_instance_obj ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

            /* Cascade UI Event records from the template object instance. */
            FOR EACH rycue_template WHERE
                     rycue_template.object_type_obj     = rycso_oi_template.object_type_obj  AND
                     rycue_template.smartObject_obj     = rycso_oi_template.smartObject_obj  AND
                     rycue_template.object_instance_obj = rycoi_template.object_instance_obj
                     NO-LOCK:
                CREATE rycue_actual NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        
                BUFFER-COPY rycue_template      EXCEPT ui_event_obj primary_smartObject_obj
                    TO rycue_actual
                            ASSIGN rycue_actual.object_instance_obj       = rycoi_actual.object_instance_obj
                                   rycue_actual.container_smartObject_obj = pdContainerObj
                                   rycue_actual.inheritted                = YES
                                   NO-ERROR.
                IF ERROR-STATUS:ERROR THEN
                DO:
                    ASSIGN cErrorText = "":U.
                    DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                        ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                                          + ERROR-STATUS:GET-MESSAGE(iErrorCount).
                    END.    /* loop through errors */                
                    RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
                END.    /* error */
        
                VALIDATE rycue_actual NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
            END.    /* master SmartObject UI events */
        END.    /* template */
        WHEN "OLD":U OR WHEN "DEL":U THEN
        DO:
            FIND FIRST rycoi_actual WHERE
                       rycoi_actual.object_instance_obj = pbPageInstance.tObjectInstanceObj
                       EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
            IF pbPageInstance.tOIAction EQ "DEL":U THEN
            /* The delete trigger deletes links. */
            FOR EACH ttLink WHERE
                     ttLink.tSourceId = pbPageInstance.tLocalSequence OR
                     ttLink.tTargetId = pbPageInstance.tLocalSequence   :
                DELETE ttLink.
            END.    /* links */
        END.    /* DEL */
        WHEN "NEW":U THEN
        DO:
            /* The 'new' SmartObject. */
            FIND FIRST rycso_oi_actual WHERE
                       rycso_oi_actual.object_filename = pbPageInstance.tObjectFilename
                       NO-LOCK NO-ERROR.
            IF NOT AVAILABLE rycso_oi_actual THEN RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_rycso_oi_actual' '?' '"SmartObject "' 'pbPageInstance.tObjectFilename' }.
    
            CREATE rycoi_actual NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    
            ASSIGN rycoi_actual.container_smartObject_obj = pdContainerObj NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
                ASSIGN cErrorText = "":U.
                DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                    ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                                      + ERROR-STATUS:GET-MESSAGE(iErrorCount).
                END.    /* loop through errors */            
                RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
            END.    /* error */
            /* Validate later. */
    
            /* Create Attribute Values for the object instance.
             * Cascade these manually from the Master SmartObject. */
            FOR EACH rycav_template WHERE
                     rycav_template.object_type_obj           = rycso_oi_actual.object_type_obj AND
                     rycav_template.smartObject_obj           = rycso_oi_actual.smartObject_obj AND
                     rycav_template.object_instance_obj       = 0                               AND
                     rycav_template.container_smartObject_obj = 0
                     NO-LOCK:
                RUN setAttributeValues ( INPUT rycso_oi_actual.object_type_obj,
                                         INPUT rycso_oi_actual.smartObject_obj,
                                         INPUT pdContainerObj,
                                         INPUT rycoi_actual.object_instance_obj,
                                         INPUT rycav_template.attribute_label,
                                         INPUT rycav_template.attribute_value    ) NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
            END.    /* master SmartObject attributes */

            /* Cascade UI Event records. */
            FOR EACH rycue_template WHERE
                     rycue_template.object_type_obj           = rycso_oi_actual.object_type_obj AND
                     rycue_template.smartObject_obj           = rycso_oi_actual.smartObject_obj AND
                     rycue_template.object_instance_obj       = 0                               AND
                     rycue_template.container_smartObject_obj = 0
                     NO-LOCK:
                CREATE rycue_actual NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        
                BUFFER-COPY rycue_template          EXCEPT ui_event_obj primary_smartObject_obj
                    TO rycue_actual
                            ASSIGN rycue_actual.object_instance_obj       = rycoi_actual.object_instance_obj
                                   rycue_actual.container_smartObject_obj = pdContainerObj
                                   rycue_actual.inheritted                = YES
                                   NO-ERROR.
                IF ERROR-STATUS:ERROR THEN
                DO:
                    ASSIGN cErrorText = "":U.
                    DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                        ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                                          + ERROR-STATUS:GET-MESSAGE(iErrorCount).
                    END.    /* loop through errors */                
                    RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
                END.    /* error */
        
                VALIDATE rycue_actual NO-ERROR.
                IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
            END.    /* master SmartObject UI events */
        END.    /* NEW: create object instance record.  */
        OTHERWISE RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"Object Instance Action"' "'Supported values are TEMPLATE,DEL,NEW and OLD.' + pbPageInstance.tOIAction + ' was used.'" }.
    END CASE.   /* pbPageInstance.tOIAction */

    IF pbPageInstance.tOIAction EQ "DEL":U THEN
    DO:
        DELETE rycoi_actual NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* DEL */
    ELSE
    DO:
        /* The SmartObject may have changed. */
        IF NOT AVAILABLE rycso_oi_actual THEN
            FIND FIRST rycso_oi_actual WHERE
                       rycso_oi_actual.object_filename = pbPageInstance.tObjectFilename
                       NO-LOCK NO-ERROR.
        IF NOT AVAILABLE rycso_oi_actual THEN RETURN ERROR {aferrortxt.i 'AF' '5' 'rycso_oi_actual' '?' '"SmartObject "' 'pbPageInstance.tObjectFilename' }.

        /* If the SmartObject has changed, cascade the Master object-specific attributes. */
        IF rycso_oi_actual.smartObject_obj NE rycoi_actual.smartObject_obj THEN
        DO:
            /* Cascade any specified attributes from the Master Smartobject */
            RUN CascadeMasterAttributes ( INPUT pbPageInstance.tObjectTypeCode,
                                          INPUT rycso_oi_actual.object_type_obj,
                                          INPUT rycso_oi_actual.smartObject_obj,
                                          INPUT pdContainerObj,
                                          INPUT rycoi_actual.object_instance_obj ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* cascade master attributes. */

        ASSIGN rycoi_actual.smartObject_obj = rycso_oi_actual.smartObject_obj
               rycoi_actual.layout_position = pbPageInstance.tLayoutPosition
               NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
        DO:
            ASSIGN cErrorText = "":U.
            DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                                  + ERROR-STATUS:GET-MESSAGE(iErrorCount).
            END.    /* loop through errors */        
            RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
        END.    /* error */
    
        VALIDATE rycoi_actual NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        /* Maintain link integrity for */
        FOR EACH ttLink WHERE
                 ttLink.tSourceId = pbPageInstance.tLocalSequence OR
                 ttLink.tTargetId = pbPageInstance.tLocalSequence   :
            /* Ensure that the object instance name is correct. */
            IF ttLink.tSourceId = pbPageInstance.tLocalSequence THEN
                ASSIGN ttLink.tSourceInstanceObj = rycoi_actual.object_instance_obj.
            ELSE
                ASSIGN ttLink.tTargetInstanceObj = rycoi_actual.object_instance_obj.
        END.    /* links */

        ASSIGN pdObjectInstanceObj = rycoi_actual.object_instance_obj
               pdMasterSmartObject = rycoi_actual.smartObject_obj
               .
    END.    /* non-DEL action */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ModifyPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ModifyPage Procedure 
PROCEDURE ModifyPage :
/*------------------------------------------------------------------------------
  Purpose:     Modify the page record.
  Parameters:  buffer pbPage
               pdContainerObj -
               pdPageObj      -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE PARAMETER BUFFER pbPage      FOR ttPage.
    DEFINE INPUT  PARAMETER pdContainerObj      AS DECIMAL              NO-UNDO.
    DEFINE OUTPUT PARAMETER pdPageObj           AS DECIMAL              NO-UNDO.

    DEFINE VARIABLE iErrorCount         AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE cErrorText          AS CHARACTER                    NO-UNDO.

    DEFINE BUFFER rycpa_actual          FOR ryc_page.
    DEFINE BUFFER rycpa_template        FOR ryc_page.
    
    /* Clear the RYCPA buffer */
    FIND FIRST rycpa_actual WHERE
               ROWID(rycpa_actual) = ?
               NO-LOCK NO-ERROR.

    /* If the page has had a new template applied, delete all existing 
     * instances on that page, as well as the links and attribute values.
     * Also delete all instances in the page has been deleted by the container
     * property sheet.
     *
     * Only do this for pbPage records where the tAction is "OLD" is greater than
     * zero, because these are existing smartobjects. We never want to touch the 
     * template objects, links, pages, etc.
     *
     * This will only happen in the case where we change an existing page's
     * layout, and page template changes.
     *
     * We also delete page objects when an existing page is deleted and recreated. */
    IF ( pbPage.tAction EQ "OLD":U AND pbPage.tUpdateContainer ) OR
       pbPage.tAction                                 EQ "DEL":U OR
       pbPage.tReCreated                                         THEN
    DO:
        RUN DeletePageInstances ( INPUT pdContainerObj,
                                  INPUT pbPage.tPageObj ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* Delete instances.  */

    /* Now update the Page itself. */
    IF pbPage.tAction EQ "DEL":U THEN
    DO:
        IF NOT pbPage.tIsPageZero AND
           pbPage.tPageObj NE 0   THEN
        DO:
            FIND rycpa_actual WHERE
                 rycpa_actual.page_obj = pbPage.tPageObj
                 EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
            IF NOT AVAILABLE rycpa_actual THEN
                RETURN ERROR {aferrortxt.i 'AF' '5' 'rycpa_actual' '?' '"Page record selected for deletion"'}.

            DELETE rycpa_actual NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* not Page0 */
    END.    /* DEL */
    ELSE
    IF NOT pbPage.tIsPageZero THEN
    DO:
        /* Update the page records and create pages where necessary. If the page is to be deleted,
         * don't attempt to create the page record. 
         *
         * We don't create a page for Page0, which always has a tPageObj of -1 */
        IF pbPage.tAction EQ "TEMPLATE":U THEN
        DO:
            FIND rycpa_template WHERE
                 rycpa_template.page_obj = pbPage.tPageObj
                 NO-LOCK NO-ERROR.
            IF NOT AVAILABLE rycpa_template THEN
                RETURN ERROR {aferrortxt.i 'AF' '5' 'rycpa_template' '?' '"page"' }.
    
            CREATE rycpa_actual NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    
            BUFFER-COPY rycpa_template
                    EXCEPT page_obj container_smartobject_obj
                TO rycpa_actual
                    ASSIGN rycpa_actual.container_smartobject_obj = pdContainerObj
                           rycpa_actual.page_sequence             = pbPage.tPageSequence
                           NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
                ASSIGN cErrorText = "":U.
                DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                    ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                                      + ERROR-STATUS:GET-MESSAGE(iErrorCount).
                END.    /* loop through errors */
            
                RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
            END.    /* error */
            /* Validation happens later. */
        END.    /* is a template page. */
        ELSE
        IF pbPage.tAction EQ "OLD":U THEN
            FIND rycpa_actual WHERE
                 rycpa_actual.page_obj = pbPage.tPageObj
                 EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        ELSE
        IF pbPage.tAction EQ "NEW":U THEN
        DO:
            CREATE rycpa_actual NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

            ASSIGN rycpa_actual.container_smartobject_obj = pdContainerObj
                   rycpa_actual.page_sequence             = pbPage.tPageSequence
                   NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
                ASSIGN cErrorText = "":U.
                DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                    ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                                      + ERROR-STATUS:GET-MESSAGE(iErrorCount).
                END.    /* loop through errors */
            
                RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
            END.    /* error */
            /* validate later */
        END.    /* new */

        /* The page record must be available here.  */    
        ASSIGN rycpa_actual.layout_obj       = pbPage.tLayoutObj
               rycpa_actual.page_label       = pbPage.tPageLabel
               rycpa_actual.security_token   = pbPage.tSecurityToken
               rycpa_actual.enable_on_create = pbPage.tEnableOnCreate
               rycpa_actual.enable_on_modify = pbPage.tEnableOnModify
               rycpa_actual.enable_on_view   = pbPage.tEnableOnView
               NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
        DO:
            ASSIGN cErrorText = "":U.
            DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                                  + ERROR-STATUS:GET-MESSAGE(iErrorCount).
            END.    /* loop through errors */
        
            RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
        END.    /* error */

        VALIDATE rycpa_actual NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

        ASSIGN pdPageObj = rycpa_actual.page_obj.
    END.    /* Not a DEL action */
    ELSE
        ASSIGN pdPageObj = 0.

    RETURN.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ModifyPageObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ModifyPageObject Procedure 
PROCEDURE ModifyPageObject :
/*------------------------------------------------------------------------------
  Purpose:     UPdate the page object records. 
  Parameters:  buffer ttpageinstance
               pdContainerObj        -
               pdPageObj             -
               pdObjectInstanceObj   -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE PARAMETER BUFFER pbPageInstance  FOR ttPageInstance.
    DEFINE INPUT PARAMETER pdContainerObj       AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdPageObj            AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdObjectInstanceObj  AS DECIMAL              NO-UNDO.
    
    DEFINE VARIABLE iErrorCount         AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE cErrorText          AS CHARACTER                    NO-UNDO.

    DEFINE BUFFER rycpo_actual      FOR ryc_page_object.
    DEFINE BUFFER rycpo_template    FOR ryc_page_object.

    CASE pbPageInstance.tPOAction:
        WHEN "TEMPLATE":U THEN
        DO:
            FIND FIRST rycpo_template WHERE
                       rycpo_template.page_object_obj = pbPageInstance.tPageObjectObj
                       NO-LOCK NO-ERROR.
            IF NOT AVAILABLE rycpo_template THEN
                RETURN ERROR {aferrortxt.i 'AF' '5' 'rycpo_template' '?' '"page object"' }.
        
            CREATE rycpo_actual NO-ERROR.
            BUFFER-COPY rycpo_template
                    EXCEPT page_object_obj page_obj container_smartobject_obj
                TO rycpo_actual
                    ASSIGN rycpo_actual.page_obj                  = pdPageObj
                           rycpo_actual.container_smartObject_obj = pdContainerObj
                           rycpo_actual.page_object_sequence      = pbPageInstance.tPageObjectSequence
                           NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
                ASSIGN cErrorText = "":U.
                DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                    ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                                      + ERROR-STATUS:GET-MESSAGE(iErrorCount).
                END.    /* loop through errors */           
                RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
            END.    /* error */
            /* validate later */
        END.    /* template */
        WHEN "OLD":U OR WHEN "DEL":U THEN
            FIND FIRST rycpo_actual WHERE
                       rycpo_actual.page_object_obj = pbPageInstance.tPageObjectObj
                       EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        WHEN "NEW":U THEN        
        DO:
            /* This is when we have created a new page, and we have used a
             * page template for the objects on this page.
             * Any pages from the template smartobject are not inherited,
             * so we need to create pages and page objects for these objects. */
            CREATE rycpo_actual NO-ERROR.
            ASSIGN rycpo_actual.page_obj                  = pdPageObj
                   rycpo_actual.container_smartObject_obj = pdContainerObj
                   rycpo_actual.page_object_sequence      = pbPageInstance.tPageObjectSequence
                   NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
                ASSIGN cErrorText = "":U.
                DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                    ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                                      + ERROR-STATUS:GET-MESSAGE(iErrorCount).
                END.    /* loop through errors */            
                RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
            END.    /* error */
            /* validate later */
        END.    /* new page. */
        WHEN "ZERO":U THEN
            /* Page Objects. Clear the buffer first, so that Page 0 objects
             * don't land up on the wrong page.                            */
            FIND FIRST rycpo_actual WHERE
                       ROWID(rycpo_actual) = ?
                       NO-LOCK NO-ERROR.
        OTHERWISE RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"Object Instance Action"' "'Supported values are TEMPLATE,DEL,NEW,ZERO and OLD.' + pbPageInstance.tPOAction + ' was used.'" }.
    END CASE.   /* tPOAction */

    /* There will be no rycpo_actual record available for Page0 object instances.*/
    IF AVAILABLE rycpo_actual THEN
    DO:
        IF pbPageInstance.tPOAction EQ "DEL":U THEN
        DO:
            DELETE rycpo_actual NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* DEL */
        ELSE
        DO:        
            ASSIGN rycpo_actual.object_instance_obj  = pdObjectInstanceObj
                   rycpo_actual.page_obj             = pdPageObj
                   rycpo_actual.page_object_sequence = pbPageInstance.tPageObjectSequence
                   NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
                ASSIGN cErrorText = "":U.
                DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                    ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                                      + ERROR-STATUS:GET-MESSAGE(iErrorCount).
                END.    /* loop through errors */        
                RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
            END.    /* error */
        
            VALIDATE rycpo_actual NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* not DEL */
    END.    /* avail rycpo_actual. */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

    ASSIGN cDescription = "Dynamics Container Property Business Logic PLIP".
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

    {ry/app/ryplipsetu.i}
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {ry/app/ryplipshut.i}
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributeValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAttributeValues Procedure 
PROCEDURE setAttributeValues :
/*------------------------------------------------------------------------------
  Purpose:     Sets attribute values.
  Parameters:  pdObjectTypeObj        -
               pdSmartObjectObj       -
               pdContainerSmartObject -
               pdObjectInstanceObj    -
               pcAttributeLabel       -
               pcAttributeValue       -   
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdObjectTypeObj          AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER pdSmartObjectObj         AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER pdContainerSmartObject   AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER pdObjectInstanceObj      AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER pcAttributeLabel         AS CHARACTER        NO-UNDO.
    DEFINE INPUT PARAMETER pcAttributeValue         AS CHARACTER        NO-UNDO.
    
    DEFINE VARIABLE iErrorCount         AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE cErrorText          AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cReturnValue        AS CHARACTER                    NO-UNDO.

    DEFINE BUFFER ryc_attribute_value           FOR ryc_attribute_value.
    DEFINE BUFFER ryc_attribute                 FOR ryc_attribute.
    
    FIND FIRST ryc_attribute_value WHERE
               ryc_attribute_value.object_type_obj           = pdObjectTypeObj          AND
               ryc_attribute_value.smartObject               = pdSmartObjectObj         AND
               ryc_attribute_value.attribute_label           = pcAttributeLabel         AND
               ryc_attribute_value.object_instance_obj       = pdObjectInstanceObj      AND
               ryc_attribute_value.container_smartObject_obj = pdContainerSmartObject
               EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
    IF NOT AVAILABLE ryc_attribute_value THEN
    DO:
        FIND FIRST ryc_attribute WHERE
                   ryc_attribute.attribute_label = pcAttributeLabel
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ryc_attribute THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' 'ryc_attribute' '?' '"attribute"' "'Attribute Label = `' + pcAttributeLabel + '`'"}.

        CREATE ryc_attribute_value NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE.

        ASSIGN ryc_attribute_value.collect_attribute_value_obj = ryc_attribute_value.attribute_value_obj
               ryc_attribute_value.object_type_obj             = pdObjectTypeObj
               ryc_attribute_value.smartObject                 = pdSmartObjectObj
               ryc_attribute_value.object_instance_obj         = pdObjectInstanceObj
               ryc_attribute_value.container_smartObject_obj   = pdContainerSmartObject
               ryc_attribute_value.attribute_label             = ryc_attribute.attribute_label
               ryc_attribute_value.attribute_group_obj         = ryc_attribute.attribute_group_obj
               ryc_attribute_value.attribute_type_TLA          = ryc_attribute.attribute_type_TLA
               NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
        DO:
            ASSIGN cErrorText = "":U.
            DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                                  + ERROR-STATUS:GET-MESSAGE(iErrorCount).
            END.    /* loop through errors */
        
            RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
        END.    /* error */
    END.    /* n/a attrib */

    /* Ensure that the attribute value conforms to this session's date and numeric format masks so that
     * the write trigger works as planned.                                                             */
    ASSIGN ryc_attribute_value.attribute_value = DYNAMIC-FUNCTION("FormatAttributeValue":U IN gshRepositoryManager,
                                                                  INPUT ryc_attribute_value.attribute_type_TLA,
                                                                  INPUT pcAttributeValue)
           NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
    DO:
        ASSIGN cErrorText = "":U.
        DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
            ASSIGN cErrorText = cErrorText + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                              + ERROR-STATUS:GET-MESSAGE(iErrorCount).
        END.    /* loop through errors */
    
        RETURN ERROR {aferrortxt.i 'AF' '40' 'rycsm_actual' '?' "cErrorText" }.
    END.    /* error */

    VALIDATE ryc_attribute_value NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

