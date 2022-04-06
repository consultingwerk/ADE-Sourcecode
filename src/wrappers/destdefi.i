/*---------------------------------------------------------------------------------
  File: destdefi.i

  Description:  template structured include

  Purpose:      template structured include

  Parameters:

  History:
  --------
  (v:010000)    Task:          29   UserRef:    
                Date:   18/12/1997  Author:     Anthony Swindells

  Update Notes: Move osm- modules to af- modules

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes

/** This table stores class-only information.
 *  ----------------------------------------------------------------------- **/
DEFINE TEMP-TABLE ttClass           NO-UNDO
    FIELD tClassName                AS CHARACTER        /* The name of the class, e.g. dynview */
    FIELD tInheritsFromClasses      AS CHARACTER        /* Stores the class names of all classes that this class inherits from */
    INDEX idxMain
        tClassName
    .

/** This table contains information about objects and object instances
 *  (ryc_smartObject and ryc_object_instance records).
 *  ----------------------------------------------------------------------- **/
DEFINE TEMP-TABLE ttObject          NO-UNDO
    FIELD tLogicalObjectName                AS CHARACTER        /* the obejct's name: OBJECT_FILENAME */
    field tObjectDescription                as character        /* the object description */
    FIELD tResultCode                       AS CHARACTER        /* result code: single value only. */
    FIELD tSmartObjectObj                   AS DECIMAL          /* Object ID of this RYC_SMARTOBJECT */
    FIELD tContainerSmartObjectObj          AS DECIMAL          /* Object ID of this RYC_SMARTOBJECT's container. Zero if this is a master. */
    FIELD tObjectInstanceObj                AS DECIMAL          /* Object ID if this is a container instance. Zero if this is a master */
    FIELD tObjectInstanceName               AS CHARACTER        /* (unique) name of this instance, if it is one. Blank if this is a master */
    FIELD tClassName                        AS CHARACTER        /* The name of this class. */
    FIELD tLayoutPosition                   AS CHARACTER        /* the layout position that of this object on a container. */
    FIELD tCustomSuperProcedure             AS CHARACTER        /* ??? */    
    FIELD tPageNumber                       AS INTEGER          /* the page this obejct appears on */
    FIELD tProductModuleCode                AS CHARACTER        /* the product module code of this object. */
    FIELD tSdoObjectName                    AS CHARACTER        /* The OBJECT_FILENAME of the design-time SDO for this object.
                                                                 * Will usually be present for viewers and browsers. */
    FIELD tObjectIsAContainer               AS LOGICAL          /* Is this object a container? */
    FIELD tPageObjectSequence               AS INTEGER          /* Equivalent to the page object sequence on the ryc_object_instance record */
    INDEX idxNameResult
        tLogicalObjectName
        tResultCode
    INDEX idxInstance
        tObjectInstanceObj
    index idxOrder
        tContainerSmartobjectObj
        tPageObjectSequence        
    .

/** This table contains the information relating to all pages that are contained
 *  by a particular object.
 *  ----------------------------------------------------------------------- **/
DEFINE TEMP-TABLE ttPage                NO-UNDO
    FIELD tSmartObjectObj           AS DECIMAL          /* Object ID of this RYC_SMARTOBJECT */
    FIELD tPageNumber               AS INTEGER          /* the page number of this page. */
    FIELD tPageReference            AS CHARACTER        /* the unique identifier (Character) of the page. */ 
    FIELD tPageLabel                AS CHARACTER        /* the displayed label of the page */
    FIELD tLayoutCode               AS CHARACTER        /* the layout code to apply to the page. */
    FIELD tPageObj                  AS DECIMAL          /* the internal object id of the page record. */
    FIELD tSecurityToken            AS CHARACTER        /* the security token for this page. */
    INDEX idxMain       AS UNIQUE
        tSmartObjectObj
        tPageNumber
    .

/** All link information is stored in this temp-table.
 *  ----------------------------------------------------------------------- **/
DEFINE TEMP-TABLE ttLink                NO-UNDO
    FIELD tSmartObjectObj           AS DECIMAL          /* Object ID of this RYC_SMARTOBJECT */
    FIELD tSourceObjectInstanceObj  AS DECIMAL
    FIELD tTargetObjectInstanceObj  AS DECIMAL
    FIELD tLinkName                 AS CHARACTER        /* the name of the link */
    INDEX idxMain
          tSmartObjectObj
          tSourceObjectInstanceObj
          tTargetObjectInstanceObj
          tLinkName
    .

/** Attribute information
 *  ----------------------------------------------------------------------- **/
DEFINE TEMP-TABLE ttClassAttribute          NO-UNDO
    FIELD tClassName            AS character
    FIELD tAttributeLabel       AS CHARACTER format 'x(35)'       /* The name of the attribute */
    FIELD tNarrative            AS CHARACTER
    FIELD tLookupType           AS CHARACTER
    FIELD tLookupValue          AS CHARACTER
    FIELD tDesignOnly           AS LOGICAL
    FIELD tRuntimeOnly          AS LOGICAL
    FIELD tGroupName            AS CHARACTER
    FIELD tGroupNarrative       AS CHARACTER
    FIELD tDataType             AS INTEGER          /* An integer indicator of the data type. Therse are defined in { af/app/afdatatypi.i } */
    /* attribute values always stored as character. The data-type field used to convert. */
    FIELD tAttributeValue       AS CHARACTER    format 'x(501)'
    FIELD tWhereConstant        AS CHARACTER        /* Equivalent to ryc_attribute.constant_level */
	/* The class at which this value is set. */
    FIELD tWhereStored          AS CHARACTER    format 'x(35)'
    FIELD tRenderTypeObj        AS DECIMAL
    INDEX idxMain       AS PRIMARY UNIQUE
        tClassName
        tAttributeLabel
    .
DEFINE temp-table ttSupportedLink  no-undo
    field ClassName        as character 
    field LinkName         as character    label 'Link Name' format 'x(28)'
    field IsLinkSource     as logical 
    field IsLinkTarget     as logical 
    field DeactivateOnHide as logical
    field WhereStored      as character format 'x(35)'
    index idxMain    as primary UNIQUE 
         ClassName
         LinkName.


DEFINE TEMP-TABLE ttObjectAttribute     NO-UNDO
    /* the first 2 fields uniquely identify to which object these attributes belong. */
    FIELD tSmartObjectObj       AS DECIMAL          /* Object ID of this RYC_SMARTOBJECT. This will be zero when a class is requested */        
    FIELD tObjectInstanceObj    AS DECIMAL          /* Object ID if this is a container instance. Zero if this is a master */   
    FIELD tAttributeLabel       AS CHARACTER        /* The name of the attribute */
    FIELD tDataType             AS INTEGER          /* An integer indicator of the data type. Therse are defined in { af/app/afdatatypi.i } */
    FIELD tAttributeValue       AS CHARACTER        /* attribute values always stored as character. The data-type field used to convert. */
    FIELD tWhereStored          AS CHARACTER        /* This will be either MASTER or INSTANCE. */
    FIELD tRenderTypeObj        AS DECIMAL            
    INDEX idxMain       AS PRIMARY UNIQUE
        tSmartObjectObj
        tObjectInstanceObj
        tAttributeLabel
    .

/** UI Event information
 *  Either the tClassName or a combination of tSmartObjectObj and tObjectInstanceObj
 *  will be used to identify the events to retrieve.
 *  ----------------------------------------------------------------------- **/
DEFINE TEMP-TABLE ttUiEvent             NO-UNDO
    FIELD tClassName                AS CHARACTER
    FIELD tSmartObjectObj           AS DECIMAL          /* Object ID of this RYC_SMARTOBJECT. This will be zero when a class is requested */
    FIELD tObjectInstanceObj        AS DECIMAL          /* Object ID if this is a container instance. Zero if this is a master */   
    FIELD tEventName                AS CHARACTER FORMAT 'x(35)'
    FIELD tActionType               AS CHARACTER FORMAT 'x(3)'
    FIELD tActionTarget             AS CHARACTER FORMAT 'x(28)'
    FIELD tEventAction              AS CHARACTER FORMAT 'x(35)'
    FIELD tEventParameter           AS CHARACTER FORMAT 'x(70)'
    FIELD tEventDisabled            AS LOGICAL
    FIELD tWhereStored              AS CHARACTER FORMAT 'x(35)'
    FIELD tRenderTypeObj            AS DECIMAL
    INDEX idxObject           AS PRIMARY  /* Use to find instances of an object. */
        tSmartObjectObj   
        tObjectInstanceObj
        tEventName        
    INDEX idxClass
        tClassName
        tEventName
     .
/* - e.o.f - */
