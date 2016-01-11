&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : smrtprop.i
    Purpose     : Starts smart.p super procedure and defines general
                  SmartObject properties and other values.
    Syntax      : {src/adm2/smrtprop.i}

    Description :

    Modified    : February 4, 2000 - Version 9.1B
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
 {src/adm2/custom/smartdefscustom.i}
&ENDIF
 
 /* Service Managers */
 {src/adm2/globals.i NEW GLOBAL}

 /* define the ADM Version and broker handle for all SmartObjects */
 &GLOB ADM-VERSION ADM2.2
 
  /* Note that adm-props-from-repository is documented as possible to define
     as a variable for flexible override, so it cannot be used for conditional 
     compile.  */      
      
 /* adm-props-from-repository is supported to be defined as a variable,
    so it is not used for conditional compile */ 
    &IF DEFINED(ADM-PROPS-FROM-REPOSITORY) = 0 &THEN
 &GLOBAL-DEFINE ADM-PROPS-FROM-REPOSITORY TRUE
    &ENDIF
    
 &GLOBAL-DEFINE ADM-LOAD-FROM-REPOSITORY glADMLoadFromRepos
 
 &GLOBAL-DEFINE ADM-PROPS-DEFINED VALID-HANDLE(WIDGET-HANDLE(ENTRY(1,THIS-PROCEDURE:ADM-DATA,CHR(1))))

 DEFINE VARIABLE ghProp                AS HANDLE  NO-UNDO.  /* For {get/set} */
 DEFINE VARIABLE ghADMProps            AS HANDLE  NO-UNDO.  /* Handle of prop t-t */
 DEFINE VARIABLE ghADMPropsBuf         AS HANDLE  NO-UNDO.  /*  and its buffer    */
 DEFINE VARIABLE glADMLoadFromRepos    AS LOGICAL NO-UNDO.
 DEFINE VARIABLE glADMOk               AS LOGICAL NO-UNDO.  /* For {get/set} */
 
/* Generated objects will explicitly set the ADM-CONTAINER and ADM-CONTAINER-HANDLE 
    preprocessors.
 */ 

&IF DEFINED(ADM-LOGICALNAME-CALLBACK) EQ 0 &THEN 
   &SCOPED-DEFINE ADM-LOGICALNAME-CALLBACK SOURCE-PROCEDURE 
&ENDIF

&if defined(adm-prepare-static-object) eq 0 &then

&IF "{&ADM-CONTAINER}":U NE "":U &THEN
  &IF "{&ADM-CONTAINER}":U = "WINDOW":U &THEN
     &GLOBAL-DEFINE ADM-CONTAINER-HANDLE {&WINDOW-NAME}
  &ELSEIF "{&ADM-CONTAINER}":U = "VIRTUAL":U OR "{&FRAME-NAME}":U = "":U &THEN
          &ELSEIF "{&ADM-CONTAINER}":U = "FRAME":U OR "{&ADM-CONTAINER}":U = "DIALOG-BOX":U &THEN
     &GLOBAL-DEFINE ADM-CONTAINER-HANDLE FRAME {&FRAME-NAME}:HANDLE 
  &ENDIF 
&ELSE
  &IF "{&FRAME-NAME}":U NE "":U &THEN
     &GLOBAL-DEFINE ADM-CONTAINER-HANDLE FRAME {&FRAME-NAME}:HANDLE 
  &ENDIF
&ENDIF

&endif

 /* MinVersion is definded temporarily in order to global-def CompileOn91C */
&SCOPED-DEFINE MinVersion "9.1C"
/* Used for conditional compile on 9.1C in order to compile on POSSSE 9.1B */  
&GLOBAL-DEFINE CompileOn91C~
    INTEGER(SUBSTRING(PROVERSION,1,INDEX(PROVERSION,".":U) - 1)) >~
    INTEGER(SUBSTRING({&MinVersion},1,INDEX({&MinVersion},".":U) - 1))~
    OR~
   (INTEGER(SUBSTRING(PROVERSION,1,INDEX(PROVERSION,".":U) - 1)) =~
    INTEGER(SUBSTRING({&MinVersion},1,INDEX({&MinVersion},".":U) - 1))~
    AND~
    (INTEGER(SUBSTRING(PROVERSION,INDEX(PROVERSION,".":U) + 1,1)) >~
     INTEGER(SUBSTRING({&MinVersion},INDEX({&MinVersion},".":U) + 1,1))~
     OR~
     (INTEGER(SUBSTRING(PROVERSION,INDEX(PROVERSION,".":U) + 1,1)) =~
      INTEGER(SUBSTRING({&MinVersion},INDEX({&MinVersion},".":U) + 1,1))~
      AND~
      SUBSTRING(PROVERSION,INDEX(PROVERSION,".":U) + 1,2) >=~
      SUBSTRING({&MinVersion},INDEX({&MinVersion},".":U) + 1,2))))
&UNDEFINE MinVersion

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getObjectType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectType Method-Library 
FUNCTION getObjectType RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 14.86
         WIDTH              = 57.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

  /* Include the file which defines prototypes for all of the super
     procedure's entry points. Also, start or attach to the super procedure.
     Skip start-super-proc if we *are* the super procedure. 
     And skip including the prototypes if we are *any* super procedure. */
&IF DEFINED(ADM-EXCLUDE-PROTOTYPES) = 0 &THEN
  &IF "{&ADMSuper}":U EQ "":U &THEN
    {src/adm2/smrtprto.i}
  &ENDIF 
&ENDIF

 /* These preprocessors let the get and set methods know at compile time
    which property values are located in the temp-table and which must
    be accessed through the property functions.
 */

 &GLOB xpObjectName
 &GLOB xpLogicalObjectName
 &GLOB xpObjectVersion 
 &GLOB xpObjectType
 &GLOB xpHideOnInit 
 &GLOB xpContainerType  
 &GLOB xpPropertyDialog  
 &GLOB xpQueryObject    
 &GLOB xpContainerHandle             
 &GLOB xpInstanceProperties          
 &GLOB xpSupportedLinks              
 &GLOB xpContainerHidden          
 &GLOB xpObjectInitialized          
 &GLOB xpContainerSource           
 &GLOB xpContainerSourceEvents    
 &GLOB xpDataSourceEvents          
 &GLOB xpTranslatableProperties   
 &GLOB xpObjectPage                
 &GLOB xpDBAware                   
 &GLOB xpDesignDataObject
 &GLOB xpDataSourceNames
 &GLOB xpDataTarget
 &GLOB xpDataTargetEvents
 &GLOB xpInactiveLinks
 &GLOB xpUIBMode
 &GLOB xpRenderingProcedure
 &GLOB xpThinRenderingProcedure
 
 /* for support of dynamic objects */
 &GLOBAL-DEFINE xpPhysicalObjectName    /* physical name - no path */
 &GLOBAL-DEFINE xpDynamicObject
 &GLOBAL-DEFINE xpPhysicalVersion 
 &GLOBAL-DEFINE xpChildDataKey
 &GLOBAL-DEFINE xpParentDataKey
 &GLOBAL-DEFINE xpDataLinksEnabled
 &GLOBAL-DEFINE xpClassName
 
  /* for support of runtime parameters passed from the menus */
 &GLOBAL-DEFINE xpRunAttribute
 &GLOBAL-DEFINE xpInstanceId 
 
/* Properties for super procedure management */
&GLOBAL-DEFINE xpSuperProcedure         /* The name of the super procedure; can be a CSV list */
&GLOBAL-DEFINE xpSuperProcedureMode     /* STATELESS, STATEFUL; the mode that all supers for the object will be launched in */
&GLOBAL-DEFINE xpSuperProcedureHandle   /* Runtime property storing handles to the object's super procedures, defined in SuperProcedure. */

/* Layout support for dynamic objects */
&GLOBAL-DEFINE xpLayoutPosition        /* contains a layout position that allows an object to be laid out correctly. */

 
 /* determine if we need to create the prop fields here or from the */
 /* repository (if ICF is running ) */
 /* COMMENT THE FOLLOWING LINE TO USE THE "<class>prop.i" DEFINITIONS */
 /* This temp-table defines all the propertt fields for an object.
    This include file contributes the DEFINE statement header and
    all basic smart object properties. Each other property class include file
    adds its own fields and then the parent object ends the statement.
    Define the fields for smart objects only, not for their super procedures.
 */
   

&IF "{&ADMSuper}":U = "":U &THEN
  
  /* Note that adm-props-from-repository is intended to be replaced with
     a variable for flexible override, so it cannot be used for conditional 
     compile.  */      
  IF VALID-HANDLE(gshRepositoryManager) THEN
  DO:
    IF {&ADM-PROPS-FROM-REPOSITORY} THEN
    DO:
      &SCOPED-DEFINE ADM-INSTANCE-HANDLES  STRING(THIS-PROCEDURE)         
      &IF DEFINED(ADM-CONTAINER-HANDLE) <> 0 &THEN
          &SCOPED-DEFINE ADM-INSTANCE-HANDLES {&ADM-INSTANCE-HANDLES} + ',':U + STRING({&ADM-CONTAINER-HANDLE}) 
      &ENDIF
      &IF DEFINED(BROWSE-NAME) <> 0 &THEN
          &SCOPED-DEFINE ADM-INSTANCE-HANDLES {&ADM-INSTANCE-HANDLES} + ',':U + STRING(BROWSE {&BROWSE-NAME}:HANDLE)       
      &ENDIF
         
          /* Run static from repository. Default to no */
          &if defined(adm-prepare-static-object) eq 0 &then
                  &scoped-define adm-prepare-static-object no
          &endif
                 
          &if "{&adm-prepare-static-object}" eq "yes" &then
                  &if defined(adm-prepare-super-procedure) eq 0 &then
                      &scoped-define adm-prepare-super-procedure
                  &endif
                  &if defined(adm-prepare-super-procedure-mode) eq 0 &then
                      &scoped-define adm-prepare-super-procedure-mode
                  &endif
          &endif
      
      IF NOT 
          &if "{&adm-prepare-static-object}" eq "yes" &then
      dynamic-function('newInstance' in gshRepositoryManager,
                                   {&adm-instance-handles},
                       '{&adm-prepare-class-name}',
                       '{&adm-prepare-super-procedure}',
                       '{&adm-prepare-super-procedure-mode}' )
          &else
      DYNAMIC-FUNC('prepareInstance':U IN gshRepositoryManager,
                          {&ADM-INSTANCE-HANDLES},{&ADM-LOGICALNAME-CALLBACK}) 
          &endif
      then
      DO:
        STOP.  
      END.
      /* set the ADM buffer var */
      ASSIGN
        ghADMPropsBuf      = WIDGET-HANDLE(ENTRY(1, THIS-PROCEDURE:ADM-DATA, CHR(1))).
        glADMLoadFromRepos = VALID-HANDLE(ghADMPropsBUF).          
    END.    /* ADM-PROPS-FROM-REPOSITORY = TRUE */
  END.   /* VALID-HANDLE(gshRepositoryManager) */
&ENDIF

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
 IF NOT {&ADM-PROPS-DEFINED} THEN
 DO:

&IF "{&ADMSuper}":U = "":U &THEN  
  CREATE TEMP-TABLE ghADMProps.
  ghADMProps:UNDO    = FALSE.
  ghADMProps:ADD-NEW-FIELD('ObjectName':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ObjectVersion':U, 'CHAR':U, 0, ?,
    '{&ADM-VERSION}':U).
  ghADMProps:ADD-NEW-FIELD('ObjectType':U, 'CHAR':U, 0, ?,
    '{&PROCEDURE-TYPE}':U).
  ghADMProps:ADD-NEW-FIELD('ContainerType':U, 'CHAR':U, 0, ?,
    '{&ADM-CONTAINER}':U).
  ghADMProps:ADD-NEW-FIELD('PropertyDialog':U, 'CHAR':U, 0, ?,
    '{&ADM-PROPERTY-DLG}':U).
  ghADMProps:ADD-NEW-FIELD('QueryObject':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('ContainerHandle':U, 'HANDLE':U). 
  ghADMProps:ADD-NEW-FIELD('InstanceProperties':U, 'CHAR':U, 0, ?,
    '{&xcInstanceProperties}':U ).
  /* NOTE: Any need to support &User-Supported-Links?? */
  ghADMProps:ADD-NEW-FIELD('SupportedLinks':U, 'CHAR':U, 0, ?,
    '{&ADM-SUPPORTED-LINKS}':U).
  ghADMProps:ADD-NEW-FIELD('ContainerHidden':U, 'LOGICAL':U, 0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('ObjectInitialized':U, 'LOGICAL':U, 0, ?, no).
 /*  "hidden" is a logical concept. */
  ghADMProps:ADD-NEW-FIELD('ObjectHidden':U, 'LOGICAL':U, 0, ?, yes).
  ghADMProps:ADD-NEW-FIELD('HideOnInit':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('UIBMode':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ContainerSource':U, 'HANDLE':U). 
  /* Note that datavis adds some events that are only required for updating objects */ 
  /* isUpdateActive event is needed only for data, datavis and container classes,
     but we currently define it here.. (this simplifies the logic for datavis, 
     which may or may not inherit from container)
     confirmOk and confirmCancel only for container ans datavis */  
  ghADMProps:ADD-NEW-FIELD('ContainerSourceEvents':U, 'CHAR':U, 0, ?,
    'initializeObject,hideObject,viewObject,destroyObject,enableObject,confirmExit,confirmCancel,confirmOk,isUpdateActive':U).
  ghADMProps:ADD-NEW-FIELD('DataSource':U, 'HANDLE':U).
  /* Note that DataSourceEvents is overidden in data.i since some of these 
     events are intended for visual targets; queryPosition, fetchDataSet, 
     assignMaxdataguess and the most resent addition confirmUndo and 
     confirmCommit. These two are NOT dataSourceEvents for SDOs as the message 
     should not to be published to objects not affected by the commit/undo. */
  ghADMProps:ADD-NEW-FIELD('DataSourceEvents':U, 'CHAR':U, 0, ?,
    'dataAvailable,queryPosition,updateState,deleteComplete,fetchDataSet,confirmContinue,confirmCommit,confirmUndo,assignMaxGuess,isUpdatePending':U).
  ghADMProps:ADD-NEW-FIELD('TranslatableProperties':U, 'CHAR':U, 0, ?,
    '{&xcTranslatableProperties}':U).
  ghADMProps:ADD-NEW-FIELD('ObjectPage':U, 'INT':U, 0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('DBAware':U, 'LOGICAL':U, 0, ?,
                             &IF DEFINED (DB-AWARE) NE 0 &THEN
                          {&DB-AWARE}).
                             &ELSE
                          no).
                             &ENDIF
  ghADMProps:ADD-NEW-FIELD('DesignDataObject':U, 'CHAR':U, 0, ?,'':U).
  ghADMProps:ADD-NEW-FIELD('DataSourceNames':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('DataTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('DataTargetEvents':U, 'CHARACTER':U, 0, ?,
     'updateState,rowObjectState,fetchBatch,LinkState':U).

  ghADMProps:ADD-NEW-FIELD('LogicalObjectName':U, 'CHARACTER':U).  
  ghADMProps:ADD-NEW-FIELD('PhysicalObjectName':U, 'CHARACTER':U, ?, ?, "{&OBJECT-NAME}":U).  

  ghADMProps:ADD-NEW-FIELD('LogicalVersion':U, 'CHARACTER':U).  
  ghADMProps:ADD-NEW-FIELD('PhysicalVersion':U, 'CHARACTER':U, ?, ?, "{&OBJECT-VERSION}":U).  

  ghADMProps:ADD-NEW-FIELD('DynamicObject':U, 'LOGICAL':U).  
  ghADMProps:ADD-NEW-FIELD('RunAttribute':U, 'CHARACTER':U).    
  ghADMProps:ADD-NEW-FIELD('ChildDataKey':U, 'CHARACTER':U).  
  ghADMProps:ADD-NEW-FIELD('ParentDataKey':U, 'CHARACTER':U).  
  ghADMProps:ADD-NEW-FIELD('DataLinksEnabled':U, 'LOGICAL':U, ?, ?, YES).
  ghADMProps:ADD-NEW-FIELD('InactiveLinks':U, 'CHARACTER':U).    
  ghADMProps:ADD-NEW-FIELD('InstanceId':U, 'DECIMAL':U).    
  /* SuperProcedure management */
  ghADMProps:ADD-NEW-FIELD('SuperProcedure':U, 'CHARACTER':U).    
  ghADMProps:ADD-NEW-FIELD('SuperProcedureMode':U, 'CHARACTER':U).    
  ghADMProps:ADD-NEW-FIELD('SuperProcedureHandle':U, 'CHARACTER':U).
      
  ghADMProps:ADD-NEW-FIELD('LayoutPosition':U, 'CHARACTER':U).
  ghADMProps:ADD-NEW-FIELD('ClassName':U, 'CHARACTER':U).
  ghADMProps:ADD-NEW-FIELD('RenderingProcedure':U, 'CHARACTER':U).
  ghADMProps:ADD-NEW-FIELD('ThinRenderingProcedure':U, 'CHARACTER':U).
  ghADMProps:ADD-NEW-FIELD('Label':U, 'CHAR':U, 0, ?, ?).    

  
 &ENDIF

  {src/adm2/custom/smrtpropcustom.i}
END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getObjectType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectType Method-Library 
FUNCTION getObjectType RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Type of the SmartObject, such as "SmartDataObject", etc.
            For an ADM Super procedure, this function returns "SUPER".
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cType AS CHARACTER NO-UNDO.
  &IF "{&ADMSuper}":U NE "":U &THEN
    cType = "SUPER":U.
  &ELSE
    {get ObjectType cType} NO-ERROR.
  &ENDIF
  RETURN cType.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

