&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

 {src/adm2/custom/smartdefscustom.i}
 
 /* Service Managers */
 {src/adm2/globals.i NEW GLOBAL}

 /* define the ADM Version and broker handle for all SmartObjects */
 &GLOB ADM-VERSION ADM2.2
 
  /* Note that adm-props-from-repository is documented as possible to define
     as a variable for flexible override, so it cannot be used for conditional 
     compile.  */      
   &IF DEFINED(ADM-PROPS-FROM-REPOSITORY) = 0 &THEN
 &GLOBAL-DEFINE ADM-PROPS-FROM-REPOSITORY TRUE
   &ENDIF
   
 &GLOBAL-DEFINE ADM-PROPS-DEFINED VALID-HANDLE(WIDGET-HANDLE(ENTRY(1,THIS-PROCEDURE:ADM-DATA,CHR(1))))

 DEFINE VARIABLE ghProp         AS HANDLE NO-UNDO.  /* For {get/set} */
 DEFINE VARIABLE ghADMProps     AS HANDLE NO-UNDO.  /* Handle of prop t-t */
 DEFINE VARIABLE ghADMPropsBuf  AS HANDLE NO-UNDO.  /*  and its buffer    */
 
 /* MinVersion is definded temporarily in order to global-def CompileOn91C */
&SCOPED-DEFINE MinVersion "9.1C"
/* Used for conditional compile on 9.1C in order to compile on POSSSE 9.1B */  
&GLOBAL-DEFINE CompileOn91C~
    DECIMAL(SUBSTRING(PROVERSION,1,R-INDEX(PROVERSION,".":U) + 1)) >~
    DECIMAL(SUBSTRING({&MinVersion},1,R-INDEX({&MinVersion},".":U) + 1))~
    OR~
   (DECIMAL(SUBSTRING(PROVERSION,1,R-INDEX(PROVERSION,".":U) + 1)) =~
    DECIMAL(SUBSTRING({&MinVersion},1,R-INDEX({&MinVersion},".":U) + 1))~
    AND~
    SUBSTRING(PROVERSION,R-INDEX(PROVERSION,".":U) + 1,2) >=~
    SUBSTRING({&MinVersion},R-INDEX({&MinVersion},".":U) + 1,2))
&UNDEFINE MinVersion

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectType Include 
FUNCTION getObjectType RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 5.38
         WIDTH              = 57.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

  /* Include the file which defines prototypes for all of the super
     procedure's entry points. Also, start or attach to the super procedure.
     Skip start-super-proc if we *are* the super procedure. 
     And skip including the prototypes if we are *any* super procedure. */
&IF "{&ADMSuper}":U EQ "":U &THEN
  {src/adm2/smrtprto.i}


&ENDIF

 /* These preprocessors let the get and set methods know at compile time
    which property values are located in the temp-table and which must
    be accessed through the property functions.
 */

 &GLOB xpObjectName
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
 /* for support of dynamic objects */
 &GLOBAL-DEFINE xpPhysicalObjectName    /* physical name - no path */
 &GLOBAL-DEFINE xpDynamicObject
 &GLOBAL-DEFINE xpPhysicalVersion 
 &GLOBAL-DEFINE xpChildDataKey
 &GLOBAL-DEFINE xpParentDataKey
 &GLOBAL-DEFINE xpDataLinksEnabled
  /* for support of runtime parameters passed from the menus */
 &GLOBAL-DEFINE xpRunAttribute
 &GLOBAL-DEFINE xpInstanceId 
 
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
  CREATE TEMP-TABLE ghADMProps.
  
  /* Note that adm-props-from-repository is intended to be replaced with
     a variable for flexible override, so it cannot be used for conditional 
     compile.  */      
  IF VALID-HANDLE(gshRepositoryManager) AND {&ADM-PROPS-FROM-REPOSITORY} THEN
  DO:
    IF NOT DYNAMIC-FUNC('prepareInstance':U IN gshRepositoryManager,
                        ghADMProps,
                        THIS-PROCEDURE,
                        SOURCE-PROCEDURE) THEN
      STOP.  
  END.
&ENDIF

 IF NOT {&ADM-PROPS-DEFINED} THEN
 DO:

&IF "{&ADMSuper}":U = "":U &THEN  
  ghADMProps:UNDO = FALSE.
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
 &ENDIF

  {src/adm2/custom/smrtpropcustom.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectType Include 
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

