&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*---------------------------------------------------------------------------------
  File: ryvobttdef.i

  Description:  Temp Table definitions for Property Sheet

  Purpose:      Property sheet temp table definitions for defining objects and attributes

  Parameters:   <none>

  History:
  --------
       Date:   26/02/2002  Author:     Don Bulua

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes

/* ttObject is used for storing existing object information. The information is stored
   per window instance   */
DEFINE TEMP-TABLE ttObjectDPS NO-UNDO
  FIELD objectID           AS INTEGER /* Unique identifier */
  FIELD callingProc        AS HANDLE  /* Handle of calling procedure */
  FIELD containerName      LIKE ryc_smartObject.object_fileName
  FIELD containerLabel     AS CHAR
  FIELD objectName         LIKE ryc_smartObject.Object_filename
  FIELD objectLabel        AS CHARACTER
  FIELD objectClassCode    LIKE gsc_object_type.object_type_code
  FIELD groupList          AS CHARACTER
  FIELD classList          AS CHARACTER
  FIELD objectLevel        AS CHARACTER
  FIELD isDeleted          AS LOGICAL
  FIELD resultcodes        AS CHARACTER /* Comma Delimited list of supported customization result codes */
   INDEX pkMain   IS PRIMARY UNIQUE ObjectID
   INDEX akObject IS UNIQUE callingProc  containerName  objectName
   INDEX ieClass      objectClassCode
   INDEX idxLabel     objectLabel
   INDEX idxIsDeleted  IsDeleted.

/* The ttAttribute table will cache all attributes and their default values 
   for object classes  i.e.  DynFillIn, DynComboBox, DynEditor, etc.. and it will 
   also store attribute values for individual objects */
DEFINE TEMP-TABLE ttAttribute NO-UNDO
  FIELD objectID       AS INTEGER    /* FK to ttObject */
  FIELD callingProc    AS HANDLE     /* Handle of calling window */
  FIELD containerName  LIKE ryc_smartObject.object_fileName
  FIELD objectName     LIKE ryc_smartObject.Object_filename
  FIELD resultCode     AS CHARACTER
  FIELD objectClass    AS CHARACTER
  FIELD attrLabel      LIKE ryc_attribute.attribute_label
  FIELD defaultValue   AS CHARACTER
  FIELD setValue       AS CHARACTER
  FIELD dataType       AS CHARACTER
  FIELD lookupType     AS CHARACTER
  FIELD lookupValue    AS CHARACTER
  FIELD designOnly     AS LOGICAL
  FIELD narrative      AS CHARACTER
  FIELD attrGroup      AS CHARACTER
  FIELD isDisabled     AS LOGICAL
  FIELD RowModified    AS LOGICAL
  FIELD RowOverride    AS LOGICAL
  FIELD constantLevel  AS CHARACTER
    INDEX pkMain IS PRIMARY objectID resultCode attrLabel
    INDEX idxResult    resultCode
    INDEX idxattr      attrLabel
    INDEX idxClass     objectClass
    INDEX idxProc      callingProc
    INDEX idxCont      containerName
    INDEX idxObjName   objectName.
   

 /* The ttSelectedAttribute table is used for the browse query. It is refreshed
    as each object is selected.  */
DEFINE TEMP-TABLE ttSelectedAttribute NO-UNDO RCODE-INFORMATION
    FIELD override       AS CHARACTER 
    FIELD resultCode     LIKE ryc_customization_result.customization_result_Code
    FIELD objectClass    LIKE gsc_object_type.object_type_code
    FIELD attrLabel      LIKE ryc_attribute.attribute_label
    FIELD defaultValue   AS CHARACTER FORMAT "X(1024)"
    FIELD setValue       AS CHARACTER FORMAT "X(1024)"
    FIELD dataType       AS CHARACTER
    FIELD lookupType     LIKE ryc_attribute.Lookup_type
    FIELD lookupValue    LIKE ryc_attribute.Lookup_value
    FIELD narrative      LIKE ryc_attribute.attribute_narrative
    FIELD attrGroup      LIKE ryc_attribute_group.attribute_group_name
    FIELD isDisabled     AS LOGICAL
    FIELD objectList     AS CHARACTER
      INDEX pkMain IS PRIMARY resultCode attrLabel
      INDEX idxoverride Override
      INDEX idxLabel    attrLabel
      INDEX idxgroup    attrgroup.
      


/* The ttEvent table will cache all events and their default values 
   for object classes  */
DEFINE TEMP-TABLE ttEvent NO-UNDO
  FIELD objectID         AS INTEGER    /* FK to ttObject */
  FIELD callingProc      AS HANDLE     /* Handle of calling window */
  FIELD containerName    LIKE ryc_smartObject.object_fileName
  FIELD objectName       LIKE ryc_smartObject.Object_filename
  FIELD resultCode       AS CHARACTER
  FIELD objectClass      AS CHARACTER
  FIELD eventName        LIKE ryc_ui_event.event_name
  FIELD eventAction      LIKE ryc_ui_event.event_action
  FIELD eventType        LIKE ryc_ui_event.action_type
  FIELD eventTarget      LIKE ryc_ui_event.action_target
  FIELD eventParameter   LIKE ryc_ui_event.event_parameter
  FIELD eventDisabled    LIKE ryc_ui_event.event_disabled
  FIELD defaultAction    AS CHARACTER
  FIELD defaultType      AS CHARACTER
  FIELD defaultTarget    AS CHARACTER
  FIELD defaultParameter AS CHARACTER
  FIELD defaultDisabled  AS LOGICAL
  FIELD isDisabled       AS LOGICAL
  FIELD RowModified      AS LOGICAL
  FIELD RowOverride      AS LOGICAL
    INDEX pkMain IS PRIMARY objectID resultCode eventName
    INDEX idxResult    resultCode
    INDEX idxEvent     eventName
    INDEX idxClass     objectClass
    INDEX idxProc      callingProc
    INDEX idxCont      containerName
    INDEX idxObjName   objectName.
  

DEFINE TEMP-TABLE ttSelectedEvent NO-UNDO RCODE-INFORMATION
  FIELD Override         AS CHARACTER
  FIELD resultCode       AS CHARACTER
  FIELD objectClass      AS CHARACTER
  FIELD eventName        LIKE ryc_ui_event.event_name
  FIELD eventType        LIKE ryc_ui_event.action_type
  FIELD eventTarget      LIKE ryc_ui_event.action_target
  FIELD eventAction      LIKE ryc_ui_event.event_action
  FIELD eventParameter   LIKE ryc_ui_event.event_parameter
  FIELD eventDisabled    LIKE ryc_ui_event.event_disabled
  FIELD defaultType      LIKE ryc_ui_event.action_type
  FIELD defaultTarget    LIKE ryc_ui_event.action_target
  FIELD defaultAction    LIKE ryc_ui_event.action_target
  FIELD defaultParameter LIKE ryc_ui_event.event_parameter
  FIELD defaultDisabled  AS LOGICAL
  FIELD isDisabled       AS LOGICAL
  FIELD objectList       AS CHARACTER
    INDEX pkMain IS PRIMARY resultCode eventName
    INDEX idxoverride Override
    INDEX idxName     eventName
    INDEX idxType     eventType
    INDEX idxTarget   eventTarget
    INDEX idxAction   eventAction
    INDEX idxParam    eventParameter
    INDEX idxDisable  eventDisabled.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 8.86
         WIDTH              = 53.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


