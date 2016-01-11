&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : _rmtsdo.p
    Purpose     : Pretend to be a SDO for HTML mapping. 

    Syntax      : run adeweb/_rmtsdo.p persistent set hdl.
                  run setSdo("d-cust", output ok) in hdl. 
                  
    Description : Used to fool AppBuilder    
                  
                  It fetches the column data and adm properties from the remote 
                  data object and uses the same signature as the real SmartObject   
                   
    Author(s)   : Haavard Danielsen
    Created     : April 1998
    Changed     : Aug   1998
                  Made more generic so new functions can be added by                      
    Changed     : April 1999
                  Added properties      
    Notes       : To add a new column<prop>                   
                   1. Add property to xcTypes list.
                   2. Add a field with the name column<prop> to the 
                      tColumn temp-table.
                   3. Create a function column<prop> (Copy one of the other) 
                  
                  To add a new <property> 
                   1. Add property to xcInstProps list.
                   
                   If the property is defined in smart and used in smart                     
                    - Edit initializeObject to use the set include to 
                      save the property.  
                   Else 
                   
                   2. Create a function get<property> that 
                        returns <data-type>(admProp()).
                   3. Create a function set<property> that 
                        returns (setAdmProp(string(<value>))).
                                      
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE VAR gSDOName     AS CHAR NO-UNDO.
DEFINE VAR gColumns     AS CHAR NO-UNDO.

/* initializeObject is called each time a procedure have called get-sdo-hdl
   Make sure it is only intialized once.
*/
      
DEFINE VAR gInitialized AS LOG NO-UNDO.

/* Delimiters */
DEFINE VAR xDel1    AS CHAR NO-UNDO.  
DEFINE VAR xDel2    AS CHAR NO-UNDO.  
DEFINE VAR xDel3    AS CHAR NO-UNDO. 

/* Delimiters returned from columnProps in the SDO */
ASSIGN 
 xDel1 = CHR(3)
 xDel2 = CHR(4).

/* Delimiters for properties */
ASSIGN  
 xDel3 = CHR(1).  

/* Column properties */ 
DEFINE VAR xcTypes  AS CHAR NO-UNDO INIT       
  "datatype,format,initial,help,Label,Mandatory,Table,ReadOnly":U.

/* Instance Properties (Some of this properties are just here to support SmartInfo)*/
DEFINE VAR xcInstProps AS CHAR NO-UNDO INIT       
"AppService,ASDivision,AsInfo,AsUsePrompt,CheckCurrentChanged,DBAware,DestroyStateless,~
DisconnectAppServer,ForeignFields,InstanceProperties,ObjectName,ObjectType,~
ObjectVersion,OpenQuery,PropertyDialog,QueryObject,RebuildOnRepos,RowsToBatch,~
ServerOperatingMode,SupportedLinks,Tables,TranslatableProperties,~
UpdatableColumns":U.
  
DEFINE TEMP-TABLE tColumn 
   FIELD ColumnName      AS CHAR
   FIELD ColumnDataType  AS CHAR
   FIELD ColumnFormat    AS CHAR
   FIELD ColumnHelp      AS CHAR
   FIELD ColumnInitial   AS CHAR
   FIELD ColumnLabel     AS CHAR
   FIELD ColumnMandatory AS CHAR  
   FIELD ColumnTable     AS CHAR
   FIELD ColumnReadOnly  AS CHAR
   INDEX ColumnName ColumnName.

DEFINE TEMP-TABLE tProperty       
   FIELD Name      AS CHAR
   FIELD PropValue AS CHAR
   INDEX Name Name.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-admProp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD admProp Procedure 
FUNCTION admProp RETURNS CHARACTER PRIVATE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-colProp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD colProp Procedure 
FUNCTION colProp RETURNS CHARACTER PRIVATE
  (pColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  ( pColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnFormat Procedure 
FUNCTION columnFormat RETURNS CHARACTER
  ( pColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnHelp Procedure 
FUNCTION columnHelp RETURNS CHARACTER
  ( pColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnInitial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnInitial Procedure 
FUNCTION columnInitial RETURNS CHARACTER
  ( pColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnLabel Procedure 
FUNCTION columnLabel RETURNS CHARACTER
  ( pColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnMandatory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnMandatory Procedure 
FUNCTION columnMandatory RETURNS LOGICAL
 ( pColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnReadOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnReadOnly Procedure 
FUNCTION columnReadOnly RETURNS LOGICAL
  ( pColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnTable Procedure 
FUNCTION columnTable RETURNS CHARACTER
  ( pColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAppService Procedure 
FUNCTION getAppService RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASDivision) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getASDivision Procedure 
FUNCTION getASDivision RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAsInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAsInfo Procedure 
FUNCTION getAsInfo RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAsUsePrompt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAsUsePrompt Procedure 
FUNCTION getAsUsePrompt RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCheckCurrentChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCheckCurrentChanged Procedure 
FUNCTION getCheckCurrentChanged RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataColumns Procedure 
FUNCTION getDataColumns RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDBAware) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDBAware Procedure 
FUNCTION getDBAware RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDestroyStateless) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDestroyStateless Procedure 
FUNCTION getDestroyStateless RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisconnectAppServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisconnectAppServer Procedure 
FUNCTION getDisconnectAppServer RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getForeignFields Procedure 
FUNCTION getForeignFields RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectName Procedure 
FUNCTION getObjectName RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOpenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOpenQuery Procedure 
FUNCTION getOpenQuery RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPropertyDialog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPropertyDialog Procedure 
FUNCTION getPropertyDialog RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryObject Procedure 
FUNCTION getQueryObject RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getReBuildOnRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getReBuildOnRepos Procedure 
FUNCTION getReBuildOnRepos RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowsToBatch Procedure 
FUNCTION getRowsToBatch RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDOName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDOName Procedure 
FUNCTION getSDOName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServerOperatingMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getServerOperatingMode Procedure 
FUNCTION getServerOperatingMode RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSupportedLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSupportedLinks Procedure 
FUNCTION getSupportedLinks RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTables Procedure 
FUNCTION getTables RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdatableColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdatableColumns Procedure 
FUNCTION getUpdatableColumns RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAdmProp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAdmProp Procedure 
FUNCTION setAdmProp RETURNS LOGICAL
  (pcValue AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAppService Procedure 
FUNCTION setAppService RETURNS LOGICAL
  (pcAppService AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASDivision) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setASDivision Procedure 
FUNCTION setASDivision RETURNS LOGICAL
  ( pcASDivision AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAsInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAsInfo Procedure 
FUNCTION setAsInfo RETURNS LOGICAL
  (pcAsInfo AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAsUsePrompt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAsUsePrompt Procedure 
FUNCTION setAsUsePrompt RETURNS LOGICAL
  (plAsUsePrompt AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCheckCurrentChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCheckCurrentChanged Procedure 
FUNCTION setCheckCurrentChanged RETURNS LOGICAL
  (plCheck AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDestroyStateless) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDestroyStateless Procedure 
FUNCTION setDestroyStateless RETURNS LOGICAL
  (plDestroy AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisconnectAppServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisconnectAppServer Procedure 
FUNCTION setDisconnectAppServer RETURNS LOGICAL
  (plDisconnect AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setForeignFields Procedure 
FUNCTION setForeignFields RETURNS LOGICAL
  (pcForeignFields AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectName Procedure 
FUNCTION setObjectName RETURNS LOGICAL
  (pcObjectName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRebuildOnRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRebuildOnRepos Procedure 
FUNCTION setRebuildOnRepos RETURNS LOGICAL
  (plRebuild AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRowsToBatch Procedure 
FUNCTION setRowsToBatch RETURNS LOGICAL
  (piRowsToBatch AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSDOName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSDOName Procedure 
FUNCTION setSDOName RETURNS LOGICAL
  (pName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServerOperatingMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setServerOperatingMode Procedure 
FUNCTION setServerOperatingMode RETURNS LOGICAL
  (pcOperatingMode AS CHAR)  FORWARD.

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
         HEIGHT             = 16.67
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/data.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose: Start a SDO remote and get the column properties 
           and put them in to the corresponding tempo table records. 
    Notes:  
------------------------------------------------------------------------------*/
 DEF VAR cProps        AS CHAR    NO-UNDO. 
 DEF VAR cColumnData   AS CHAR    NO-UNDO.
 DEF VAR cProp         AS CHAR    NO-UNDO.
 DEF VAR cAdmPropName  AS CHAR    NO-UNDO.
 DEF VAR cAdmPropValue AS CHAR    NO-UNDO.
 DEF VAR cAdmProps     AS CHAR    NO-UNDO.
 DEF VAR i             AS INTEGER NO-UNDO.
 DEF VAR j             AS INTEGER NO-UNDO.
 DEF VAR hBuff         AS HANDLE  NO-UNDO .
 DEF VAR hFld          AS HANDLE  NO-UNDO .
   
 IF gInitialized THEN RETURN.
 
 RUN adeweb/_rsdoatt.p (gSDOName,
                       "Properties":U,
                        xcInstProps,
                        OUTPUT cAdmProps).
 
 RUN adeweb/_rsdocol.p (gSDOName,
                        "*":U,
                        xcTypes,
                        OUTPUT cProps).
                         
  /* Get rid of old data */ 
 FOR EACH tColumn:
   DELETE tColumn.
 END.
 FOR EACH tProperty:
   DELETE tProperty.
 END.
 
 ASSIGN gColumns = "".
  
 DO i = 1 to NUM-ENTRIES(cProps,xDel1):
    cColumnData = ENTRY(i,cProps,xDel1).
    CREATE tColumn.     
    ASSIGN
      tColumn.ColumnName   = ENTRY(1,cColumnData,xDel2)
      hBuff                = BUFFER tColumn:HANDLE.
    
    DO j = 1 TO NUM-ENTRIES(xcTypes):     
      ASSIGN
        cProp = ENTRY(j,xcTypes)
        hFld  = hBuff:BUFFER-FIELD("column":U + cProp) 
        hFld:BUFFER-VALUE = ENTRY(j + 1,cColumnData,xDel2).    
    END.   
    gColumns = (IF gColumns = "":U 
                THEN "":U
                ELSE gColumns + ",":U) 
               + tColumn.ColumnName 
    NO-ERROR.  
    IF ERROR-STATUS:ERROR THEN RETURN ERROR.   

 END.
 
 DO i = 1 to NUM-ENTRIES(xcInstProps):
   /* xp in smart.p */
   CREATE tProperty.  
   ASSIGN   
     cAdmPropName  = ENTRY(i,xcInstProps) 
     cAdmPropValue = ENTRY(i,cAdmProps,xDel3).
  
   CASE cAdmPropName:
     /* Use set for properties that are accessed with get and set */   
     WHEN "PropertyDialog":U THEN  
       {set PropertyDialog cAdmPropValue}.
     
     WHEN "TranslatableProperties":U THEN  
       {set TranslatableProperties cAdmPropValue}.
     
     WHEN "InstanceProperties":U THEN  
       {set InstanceProperties cAdmPropValue}.
     
     WHEN "ObjectType":U THEN  
       {set ObjectType cAdmPropValue}.
     
     WHEN "ObjectVersion":U THEN  
       {set ObjectVersion cAdmPropValue}.

     OTHERWISE
       ASSIGN
         tProperty.Name      = cAdmPropName
         tProperty.PropValue = cAdmPropValue.
   END CASE.
 END.
  
 IF cProps = "" OR cAdmProps = "" THEN RETURN ERROR. 
 ELSE 
   ASSIGN gInitialized = TRUE. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-admProp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION admProp Procedure 
FUNCTION admProp RETURNS CHARACTER PRIVATE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the value of the requested property.
    Notes: Must be called from get* to find property name.  
------------------------------------------------------------------------------*/
  DEF VAR hBuff AS HANDLE NO-UNDO.
  DEF VAR hFld  AS HANDLE NO-UNDO.
  
  
  FIND tProperty WHERE tProperty.Name = 
                                  SUBSTR(ENTRY(1,program-name(2)," ":U),4) NO-ERROR. 
     
  RETURN IF AVAIL tProperty THEN tProperty.PropValue ELSE ?.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-colProp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION colProp Procedure 
FUNCTION colProp RETURNS CHARACTER PRIVATE
  (pColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the property value of the requested attribute.
    Notes: MUST be called from one of the column* Functions 
------------------------------------------------------------------------------*/
  DEF VAR hBuff AS HANDLE NO-UNDO.
  DEF VAR hFld  AS HANDLE NO-UNDO.
  
  FIND tColumn WHERE tColumn.ColumnName = pColumn NO-ERROR. 
     
  ASSIGN
    hBuff = BUFFER tColumn:HANDLE
    hFld  = hBuff:BUFFER-FIELD(ENTRY(1,program-name(2)," ":U)). 
 
  RETURN IF hBuff:AVAILABLE THEN hFld:BUFFER-VALUE ELSE "":U.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  ( pColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the format fetched from the SDO 
    Notes:  
------------------------------------------------------------------------------*/
  RETURN colProp(pColumn).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnFormat Procedure 
FUNCTION columnFormat RETURNS CHARACTER
  ( pColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the format fetched from the SDO 
    Notes:  
------------------------------------------------------------------------------*/
  RETURN colProp(pColumn).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnHelp Procedure 
FUNCTION columnHelp RETURNS CHARACTER
  ( pColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the format fetched from the SDO 
    Notes:  
------------------------------------------------------------------------------*/
  RETURN colProp(pColumn).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnInitial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnInitial Procedure 
FUNCTION columnInitial RETURNS CHARACTER
  ( pColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the format fetched from the SDO 
    Notes:  
------------------------------------------------------------------------------*/
 RETURN colProp(pColumn).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnLabel Procedure 
FUNCTION columnLabel RETURNS CHARACTER
  ( pColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the format fetched from the SDO 
    Notes:  
------------------------------------------------------------------------------*/
 RETURN colProp(pColumn).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnMandatory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnMandatory Procedure 
FUNCTION columnMandatory RETURNS LOGICAL
 ( pColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the mandatory fetched from the SDO 
    Notes:  
------------------------------------------------------------------------------*/
  RETURN CAN-DO("YES,TRUE":U,colProp(pColumn)).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnReadOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnReadOnly Procedure 
FUNCTION columnReadOnly RETURNS LOGICAL
  ( pColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the Readonly fetched from the SDO 
    Notes:  
------------------------------------------------------------------------------*/
 RETURN CAN-DO("YES,TRUE":U,colProp(pColumn)).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnTable Procedure 
FUNCTION columnTable RETURNS CHARACTER
  ( pColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the table fetched from the SDO 
    Notes:  
------------------------------------------------------------------------------*/
 RETURN colProp(pColumn).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAppService Procedure 
FUNCTION getAppService RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return the appservice name 
    Notes:  
------------------------------------------------------------------------------*/
  RETURN admProp(). 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASDivision) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getASDivision Procedure 
FUNCTION getASDivision RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN admProp().   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAsInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAsInfo Procedure 
FUNCTION getAsInfo RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return the appservice name 
    Notes:  
------------------------------------------------------------------------------*/
  RETURN admProp(). 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAsUsePrompt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAsUsePrompt Procedure 
FUNCTION getAsUsePrompt RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return the appservice name 
    Notes:  
------------------------------------------------------------------------------*/
    RETURN CAN-DO("yes,true",admProp()).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCheckCurrentChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCheckCurrentChanged Procedure 
FUNCTION getCheckCurrentChanged RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the property of the remote object.   
    Notes:  
------------------------------------------------------------------------------*/
    RETURN CAN-DO("yes,true",admProp()).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataColumns Procedure 
FUNCTION getDataColumns RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN gColumns. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDBAware) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDBAware Procedure 
FUNCTION getDBAware RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the property of the remote object.   
    Notes:  
------------------------------------------------------------------------------*/
    RETURN CAN-DO("yes,true",admProp()).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDestroyStateless) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDestroyStateless Procedure 
FUNCTION getDestroyStateless RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the property of the remote object.   
    Notes:  
------------------------------------------------------------------------------*/
    RETURN CAN-DO("yes,true",admProp()).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisconnectAppServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisconnectAppServer Procedure 
FUNCTION getDisconnectAppServer RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the property of the remote object.   
    Notes:  
------------------------------------------------------------------------------*/
    RETURN CAN-DO("yes,true",admProp()).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getForeignFields Procedure 
FUNCTION getForeignFields RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return the appservice name 
    Notes:  
------------------------------------------------------------------------------*/
  RETURN admProp(). 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectName Procedure 
FUNCTION getObjectName RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the property of the remote object.   
    Notes:  
------------------------------------------------------------------------------*/
  RETURN admProp(). 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOpenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOpenQuery Procedure 
FUNCTION getOpenQuery RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the property of the remote object.   
    Notes:  
------------------------------------------------------------------------------*/
  RETURN admProp(). 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPropertyDialog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPropertyDialog Procedure 
FUNCTION getPropertyDialog RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR cDialog AS CHAR No-UNDO.
  {get PropertyDialog cDialog}.
  RETURN cDialog.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryObject Procedure 
FUNCTION getQueryObject RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the property of the remote object.   
    Notes:  
------------------------------------------------------------------------------*/
    RETURN CAN-DO("yes,true",admProp()).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getReBuildOnRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getReBuildOnRepos Procedure 
FUNCTION getReBuildOnRepos RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the property of the remote object.    
    Notes:  
------------------------------------------------------------------------------*/
  RETURN CAN-DO("yes,true",admProp()).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowsToBatch Procedure 
FUNCTION getRowsToBatch RETURNS INTEGER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the property of the remote object.   
    Notes:  
------------------------------------------------------------------------------*/
  RETURN INT(admProp()). 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDOName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDOName Procedure 
FUNCTION getSDOName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  RETURN gSDOName.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServerOperatingMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getServerOperatingMode Procedure 
FUNCTION getServerOperatingMode RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the property of the remote object.   
    Notes:  
------------------------------------------------------------------------------*/
    RETURN admProp().
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSupportedLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSupportedLinks Procedure 
FUNCTION getSupportedLinks RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the property of the remote object.   
    Notes:  
------------------------------------------------------------------------------*/
  RETURN admProp(). 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTables Procedure 
FUNCTION getTables RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the property of the remote object.   
    Notes:  
------------------------------------------------------------------------------*/
  RETURN admProp(). 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdatableColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdatableColumns Procedure 
FUNCTION getUpdatableColumns RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the property of the remote object.   
    Notes:  
------------------------------------------------------------------------------*/
  RETURN admProp(). 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAdmProp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAdmProp Procedure 
FUNCTION setAdmProp RETURNS LOGICAL
  (pcValue AS CHAR):
/*------------------------------------------------------------------------------
  Purpose: Set the value of the requested property.
    Notes: Must be called from set* to find property name.  
------------------------------------------------------------------------------*/
  DEF VAR hBuff AS HANDLE NO-UNDO.
  DEF VAR hFld  AS HANDLE NO-UNDO.
  
  FIND tProperty WHERE tProperty.Name = 
                               SUBSTR(ENTRY(1,program-name(2)," ":U),4) NO-ERROR. 
     
  IF AVAIL tProperty THEN tProperty.PropValue = pcValue.
  
  RETURN AVAIL tProperty.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAppService Procedure 
FUNCTION setAppService RETURNS LOGICAL
  (pcAppService AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Set the instance property for the  remote object.   
    Notes: There's no need to store it in the object, because the property only 
           is used to generate code     

------------------------------------------------------------------------------*/
  RETURN setAdmProp(pcAppService).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASDivision) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setASDivision Procedure 
FUNCTION setASDivision RETURNS LOGICAL
  ( pcASDivision AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Set the instance property for the  remote object.   
    Notes: There's no need to store it in the object, because the property only 
           is used to generate code  
------------------------------------------------------------------------------*/
RETURN setAdmProp(pcASDivision).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAsInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAsInfo Procedure 
FUNCTION setAsInfo RETURNS LOGICAL
  (pcAsInfo AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Set the instance property for the  remote object.   
    Notes: There's no need to store it in the object, because the property only 
           is used to generate code     

------------------------------------------------------------------------------*/
  RETURN setAdmProp(pcAsInfo).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAsUsePrompt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAsUsePrompt Procedure 
FUNCTION setAsUsePrompt RETURNS LOGICAL
  (plAsUsePrompt AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Set the instance property for the  remote object.   
    Notes: There's no need to store it in the object, because the property only 
           is used to generate code     

------------------------------------------------------------------------------*/
  RETURN setAdmProp(STRING(plAsUsePrompt)).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCheckCurrentChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCheckCurrentChanged Procedure 
FUNCTION setCheckCurrentChanged RETURNS LOGICAL
  (plCheck AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Set the instance property for the  remote object.   
    Notes: There's no need to store it in the object, because the property only 
           is used to generate code     
------------------------------------------------------------------------------*/
  RETURN setAdmProp(STRING(plCheck)).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDestroyStateless) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDestroyStateless Procedure 
FUNCTION setDestroyStateless RETURNS LOGICAL
  (plDestroy AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Set the instance property for the  remote object.   
    Notes: There's no need to store it in the object, because the property only 
           is used to generate code     
------------------------------------------------------------------------------*/
  RETURN setAdmProp(STRING(plDestroy)).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisconnectAppServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisconnectAppServer Procedure 
FUNCTION setDisconnectAppServer RETURNS LOGICAL
  (plDisconnect AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Set the instance property for the  remote object.   
    Notes: There's no need to store it in the object, because the property only 
           is used to generate code     
------------------------------------------------------------------------------*/
  RETURN setAdmProp(STRING(plDisconnect)).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setForeignFields Procedure 
FUNCTION setForeignFields RETURNS LOGICAL
  (pcForeignFields AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Set the instance property for the  remote object.   
    Notes: There's no need to store it in the object, because the property only 
           is used to generate code     

------------------------------------------------------------------------------*/
  RETURN setAdmProp(pcForeignFields).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectName Procedure 
FUNCTION setObjectName RETURNS LOGICAL
  (pcObjectName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Set the instance property for the  remote object.   
    Notes: There's no need to store it in the object, because the property only 
           is used to generate code     
------------------------------------------------------------------------------*/
  RETURN setAdmProp(pcObjectName).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRebuildOnRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRebuildOnRepos Procedure 
FUNCTION setRebuildOnRepos RETURNS LOGICAL
  (plRebuild AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Set the instance property for the  remote object.   
    Notes: There's no need to store it in the object, because the property only 
           is used to generate code     
------------------------------------------------------------------------------*/
  RETURN setAdmProp(STRING(plRebuild)).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRowsToBatch Procedure 
FUNCTION setRowsToBatch RETURNS LOGICAL
  (piRowsToBatch AS INT) :
/*------------------------------------------------------------------------------
  Purpose: Set the instance property for the  remote object.   
    Notes: There's no need to store it in the object, because the property only 
           is used to generate code     
------------------------------------------------------------------------------*/
  RETURN setAdmProp(STRING(piRowsToBatch)).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSDOName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSDOName Procedure 
FUNCTION setSDOName RETURNS LOGICAL
  (pName AS CHAR) :
/* Purpose: set the pdo name and make the object ready for initializing.
   This must be done before initilize */     
 
 ASSIGN
   gSDOName     = pName
   gInitialized = FALSe.
 
 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServerOperatingMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setServerOperatingMode Procedure 
FUNCTION setServerOperatingMode RETURNS LOGICAL
  (pcOperatingMode AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Set the instance property for the remote object.   
    Notes: There's no need to store it in the object, because the property only 
           is used to generate code     
------------------------------------------------------------------------------*/
  RETURN setAdmProp(pcOperatingMode).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

