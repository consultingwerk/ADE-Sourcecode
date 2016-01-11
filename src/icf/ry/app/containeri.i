&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE ttContainer           NO-UNDO
    FIELD tAction                   AS CHARACTER
    FIELD tIsATemplateRecord        AS LOGICAL
    FIELD tContainerObj             AS DECIMAL
    FIELD tObjectName               AS CHARACTER
    FIELD tTemplateObjectName       AS CHARACTER
    FIELD tObjectDescription        AS CHARACTER
    FIELD tWindowTitle              AS CHARACTER
    FIELD tObjectTypeObj            AS DECIMAL
    FIELD tProductModuleObj         AS DECIMAL
    FIELD tDefaultMode              AS CHARACTER
    FIELD tCustomSuperProc          AS CHARACTER
    FIELD tLayoutObj                AS DECIMAL
    FIELD tTemplateContainerObj     AS DECIMAL          /* rycso obj of the SO used as a template */
    FIELD tPhysicalSmartObject      AS DECIMAL
    FIELD tMakeThisTemplate         AS LOGICAL      INITIAL NO
    .

DEFINE TEMP-TABLE ttPage            NO-UNDO     RCODE-INFORMATION
    FIELD tAction               AS CHARACTER    FORMAT "x(3)":U     COLUMN-LABEL "?":U
    FIELD tLocalSequence        AS DECIMAL                          COLUMN-LABEL "?":U
    FIELD tPageObj              AS DECIMAL                          COLUMN-LABEL "?":U
    FIELD tLayoutObj            AS DECIMAL                          COLUMN-LABEL "?":U
    FIELD tPageSequence         AS INTEGER      FORMAT "->>>>9":U   COLUMN-LABEL "Page!Seq."
    FIELD tPageLabel            AS CHARACTER    FORMAT "x(28)":U    COLUMN-LABEL "!Page Label"
    FIELD tSecurityToken        AS CHARACTER    FORMAT "x(28)":U    COLUMN-LABEL "!Security Token"
    FIELD tEnableOnCreate       AS LOGICAL                          COLUMN-LABEL "Enable!On Create?"
    FIELD tEnableOnModify       AS LOGICAL                          COLUMN-LABEL "Enable!On Modify?"
    FIELD tEnableOnView         AS LOGICAL                          COLUMN-LABEL "Enable!On View?"
    FIELD tLayoutName           AS CHARACTER    FORMAT "x(28)":U    COLUMN-LABEL "Layout!Name"
    FIELD tLayoutType           AS CHARACTER    FORMAT "x(3)":U     COLUMN-LABEL "?"
    FIELD tLayoutFilename       AS CHARACTER    FORMAT "x(70)":U    COLUMN-LABEL "?"
    FIELD tLayoutCode           AS CHARACTER    FORMAT "x(10)":U    COLUMN-LABEL "?"
    FIELD tUpdateContainer      AS LOGICAL                          COLUMN-LABEL "?":U
    FIELD tLayoutTemplateObject AS CHARACTER                        COLUMN-LABEL "?":U
    FIELD tIsPageZero           AS LOGICAL                          COLUMN-LABEL "?":U
    /* This field is only used when an existing page is deleted and then re-added to the container. */
    FIELD tReCreated            AS LOGICAL                          COLUMN-LABEL "?":U  INITIAL NO
    INDEX idxSequence   AS UNIQUE
        tLocalSequence
        tAction
    INDEX idxBrowse
        tAction
        tPageSequence
    .

DEFINE TEMP-TABLE ttPageInstance    NO-UNDO     RCODE-INFORMATION        
    /* Key (Page) Info */
    FIELD tParentKey                    AS DECIMAL                          COLUMN-LABEL "?":U
    FIELD tLocalSequence                AS DECIMAL                          COLUMN-LABEL "?":U
    FIELD tPageLabel                    AS CHARACTER    FORMAT "x(28)":U    COLUMN-LABEL "!Page Label"
    /* Page Object */
    FIELD tPOAction                     AS CHARACTER    FORMAT "x(3)":U     COLUMN-LABEL "?":U
    FIELD tPageObjectObj                AS DECIMAL                          COLUMN-LABEL "?":U    
    FIELD tPageObjectSequence           AS INTEGER      FORMAT "->>>>9":U   COLUMN-LABEL "Page Object!Sequence"
    /* Object Instance */
    FIELD tObjectTypeCode               AS CHARACTER    FORMAT "x(15)":U    COLUMN-LABEL "Object!Type"
    FIELD tOIAction                     AS CHARACTER    FORMAT "x(3)":U     COLUMN-LABEL "?":U
    FIELD tObjectInstanceObj            AS DECIMAL                          COLUMN-LABEL "?":U
    FIELD tLayoutPosition               AS CHARACTER    FORMAT "x(15)":U    COLUMN-LABEL "Layout!Position"
    FIELD tLayoutName                   AS CHARACTER    FORMAT "x(28)":U    COLUMN-LABEL "?"
    FIELD tObjectFilename               AS CHARACTER    FORMAT "x(70)":U    COLUMN-LABEL "Instance!Filename"
    FIELD tTemplateObjectFilename       AS CHARACTER    FORMAT "x(70)":U    COLUMN-LABEL "Template!Filename"
    FIELD tIsATemplateRecord            AS LOGICAL                          COLUMN-LABEL "Is!Template?"
    /* Object Instance Attributes */
    FIELD tWindowTitleField             AS CHARACTER    FORMAT "x(15)":U    COLUMN-LABEL "Title!Field":U
    FIELD tForeignFields                AS CHARACTER                        COLUMN-LABEL "?":U
    FIELD tLaunchContainer              AS CHARACTER                        COLUMN-LABEL "Launch!Container":U
    FIELD tNavigationTargetName         AS CHARACTER                        COLUMN-LABEL "?":U
    FIELD tAttributeLabels              AS CHARACTER                        COLUMN-LABEL "?":U
    FIELD tAttributeValues              AS CHARACTER                        COLUMN-LABEL "?":U
    INDEX idxSequence       AS UNIQUE
        tParentKey
        tLocalSequence
    INDEX idxObjectType
        tObjectTypeCode
    INDEX idxLocalSequence
        tLocalSequence
    .

DEFINE TEMP-TABLE ttLink            NO-UNDO         RCODE-INFORMATION    
    FIELD tAction                       AS CHARACTER    FORMAT "x(3)":U                         COLUMN-LABEL "?":U
    FIELD tLinkObj                      AS DECIMAL      FORMAT ">>>>>>>>>>>>>>>>>9.999999999"   COLUMN-LABEL "?":U
    FIELD tSourceInstanceObj            AS DECIMAL      FORMAT ">>>>>>>>>>>>>>>>>9.999999999"   COLUMN-LABEL "?":U
    FIELD tTargetInstanceObj            AS DECIMAL      FORMAT ">>>>>>>>>>>>>>>>>9.999999999"   COLUMN-LABEL "?":U
    FIELD tSourceObjectName             AS CHARACTER    FORMAT "x(40)":U                        COLUMN-LABEL "Source Procedure"
    FIELD tLinkName                     AS CHARACTER    FORMAT "x(28)":U                        COLUMN-LABEL "Link Name"
    FIELD tTargetObjectName             AS CHARACTER    FORMAT "x(40)":U                        COLUMN-LABEL "Target Procedure"
    FIELD tSourceId                     AS DECIMAL      COLUMN-LABEL "?":U
    FIELD tTargetId                     AS DECIMAL      COLUMN-LABEL "?":U
    INDEX idxFind       AS PRIMARY
        tSourceInstanceObj
        tLinkName
        tTargetInstanceObj
    INDEX idxLink
        tLinkName
        tAction
    INDEX idxSource
        tSourceInstanceObj
    INDEX idxTarget
        tTargetInstanceObj
    INDEX idxSourceName
        tAction
        tSourceObjectName
    INDEX idxTargetName
        tAction
        tTargetObjectName
    .

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


