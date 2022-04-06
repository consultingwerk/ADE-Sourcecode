&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
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
/* Copyright © 1984-2007 by Progress Software Corporation.  All rights 
   reserved.  Prior versions of this work may contain portions 
   contributed by participants of Possenet.  */   
/*---------------------------------------------------------------------------------
  File: ryrepmngrp.i

  Description:  Astra Repository Manager Code

  Purpose:      The Astra Repository Manager is a standard procedure encapsulating all
                Repository based access for the building of dynamic objects in the Astra
                environment. Examples include the retrieval of object attribute values,
                reading of toolbar bands and actions, etc.
                This include file contains the common code for both the server and client
                repository manager procedures.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/21/2002  Author:     

  Update Notes: Created from Template aftemplipp.p

  (v:010001)    Task:        5929   UserRef:    
                Date:   05/06/2000  Author:     Robin Roos

  Update Notes: Implement Repository Cache for Dynamic Objects

  (v:010002)    Task:        6030   UserRef:    
                Date:   15/06/2000  Author:     Robin Roos

  Update Notes: Activate object controller actions appropriately

  (v:010003)    Task:        6063   UserRef:    
                Date:   15/06/2000  Author:     Anthony Swindells

  Update Notes: Implement toolbar menus

  (v:010004)    Task:        6146   UserRef:    
                Date:   25/06/2000  Author:     Robin Roos

  Update Notes: Implement local attributes for dynamic containers

  (v:010006)    Task:        6205   UserRef:    
                Date:   30/06/2000  Author:     Robin Roos

  Update Notes: Dynamic Viewer

  (v:010100)    Task:    90000045   UserRef:    POSSE
                Date:   01/05/2001  Author:     Phil Magnay

  Update Notes: Logic changes for new security allocation method

  (v:020000)    Task:          45   UserRef:    
                Date:   06/04/2003  Author:     Thomas Hansen

  Update Notes: Issue 10202:
                Create API for calculateObjectPaths to retrive and calculate object and product module path information.

  (v:030000)    Task:          49   UserRef:    
                Date:   06/13/2003  Author:     Thomas Hansen

  Update Notes: Update the calculateObjectPaths API to work with the new gsm_scm_xref table.

-------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryrepmngrp.i
&scop object-version    000000

/* Astra object identifying preprocessor */
&global-define astraRepositoryManager  yes

{af/sup2/afglobals.i} /* Astra global shared variables */

/* Temp-Tables of bands/actions from repository to output to caller. These tables will always only
   pass back the selected bands / actions
*/
{src/adm2/ttaction.i}
{src/adm2/tttoolbar.i}

DEFINE TEMP-TABLE ttUser NO-UNDO LIKE gsm_user.

{af/app/afttsecurityctrl.i}

/* temp-table for translations */
{af/app/aftttranslate.i}

DEFINE VARIABLE lSecurityRestricted             AS LOGICAL      NO-UNDO.
DEFINE VARIABLE gcCurrentLogicalName            AS CHARACTER    NO-UNDO.

{launch.i    &define-only = YES}
{dynlaunch.i &define-only = YES}

/* Inlude containing the data types in integer form. */
{af/app/afdatatypi.i}

/* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{ry/app/rydefrescd.i}

/* mapping between  buffer:attr and entityfield attributes*/
&SCOPED-DEFINE BUFFER-ATTRIBUTE-MAP ~
     'INITIAL,DefaultValue,LABEL,Label,COLUMN-LABEL,ColumnLabel,HELP,Help,FORMAT,Format':U

/* This list of attributes needs to be have their applies_at_runtime set to NO for all 
 * DataField masters, since these values are stored in the Entity cache.
 */
&SCOPED-DEFINE DF-MASTER-ENTITY-ATTRS Format,Data-Type,Label,DefaultValue,ColumnLabel

/** This preprocessor contains the names of the system fields for the dynamic
 *  class attribute temp-tables. These fields track extrended information
 *  about the attributes contained in the table.
 *  ----------------------------------------------------------------------- **/
/* Temp-table definition for TT used in storeAttributeValues */
{ ry/inc/ryrepatset.i }

/* Preprocessors which resolve the STORED-AT values into the values stored
 * in the field.                                                          */
{ ry/inc/ryattstori.i }

/* Definitions for dynamic call, only defined client side, as we're only using the dynamic call to reduce Appserver hits in this instance */
&IF DEFINED(server-side) = 0 &THEN
{ src/adm2/calltables.i
    &PARAM-TABLE-TYPE = "1"
    &PARAM-TABLE-NAME = "ttSeqType"    
}
&ENDIF

/** Define generic queries here for use by all procedures. 
 *  ----------------------------------------------------------------------- **/
DEFINE VARIABLE ghQuery             AS HANDLE       EXTENT 20           NO-UNDO.

/** This pre-processor contains a CSV list of class names that are to be 
 *  treated as abstract classes. This means, for instance, that no attributes
 *  can be set against any contained object instances, regardless of the class
 *  of the instance.
 *  This preprocessor contains default values; overrides can be added using
 *  the "AbstractClassNames" session property.
 *  ----------------------------------------------------------------------- **/
&GLOBAL-DEFINE ABSTRACT-CLASS-NAMES Entity

/* Delimiter for the AttrValues field in the cacheObject temp-table. */
&SCOPED-DEFINE Value-Delimiter CHR(1)

/* cache* temp-tables. */
{ry/inc/getobjecti.i}

DEFINE VARIABLE gcClientCacheDir             AS CHARACTER                NO-UNDO.
define variable gcSessionResultCodes         as character                no-undo.
DEFINE VARIABLE glUseThinRendering           AS LOGICAL                  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-buildAttributeList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildAttributeList Procedure 
FUNCTION buildAttributeList RETURNS CHARACTER
  ( INPUT phClassAttributeBuffer        AS HANDLE,
    INPUT pdRecordIdentifier            AS DECIMAL  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cacheObjectOnClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cacheObjectOnClient Procedure 
FUNCTION cacheObjectOnClient RETURNS LOGICAL
    ( INPUT pcLogicalObjectName     AS CHARACTER,
      INPUT pcResultCode            AS CHARACTER,
      INPUT pcRunAttribute          AS CHARACTER,
      INPUT plDesignMode            AS LOGICAL    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-classHasAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD classHasAttribute Procedure 
FUNCTION classHasAttribute RETURNS LOGICAL
    ( INPUT pcClassName         AS CHARACTER,
      INPUT pcAttributeName     AS CHARACTER,
      INPUT plAttributeIsEvent  AS LOGICAL          )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-classIsA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD classIsA Procedure 
FUNCTION classIsA RETURNS LOGICAL
    ( INPUT pcClassName             AS CHARACTER,
      INPUT pcInheritsFromClass     AS CHARACTER    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createEntityCacheFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createEntityCacheFile Procedure 
FUNCTION createEntityCacheFile RETURNS character
    ( input pcEntityList            as character,
      input pcLanguageList          as character,
      input pcOutputDir             as character,
      input plDeleteExisting        as logical,
      input-output pcStatus         as character     ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deriveSuperProcedures) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deriveSuperProcedures Procedure 
FUNCTION deriveSuperProcedures RETURNS CHARACTER
    ( INPUT pcProcedureName        AS CHARACTER,
      input pdRenderTypeObj        as decimal     ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-entityDefaultValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD entityDefaultValue Procedure 
FUNCTION entityDefaultValue RETURNS CHARACTER
  ( hEntityField  AS HANDLE) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAllObjectSuperProcedures) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAllObjectSuperProcedures Procedure 
FUNCTION getAllObjectSuperProcedures RETURNS CHARACTER
    ( INPUT pcObjectName        AS CHARACTER,
      INPUT pcRunAttribute      AS CHARACTER    ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCacheClassBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCacheClassBuffer Procedure 
FUNCTION getCacheClassBuffer RETURNS HANDLE
    ( INPUT pcClassName     AS CHARACTER     )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCachedList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCachedList Procedure 
FUNCTION getCachedList RETURNS CHARACTER
  (pcEntityOrClass AS CHARACTER,
   pcDirectory AS CHARACTER,
   pcLanguageCode AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCacheEntityObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCacheEntityObject Procedure 
FUNCTION getCacheEntityObject RETURNS HANDLE
        ( INPUT pcEntityName            AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCacheLinkBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCacheLinkBuffer Procedure 
FUNCTION getCacheLinkBuffer RETURNS HANDLE
    ( /* No Parameters */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCacheObjectBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCacheObjectBuffer Procedure 
FUNCTION getCacheObjectBuffer RETURNS HANDLE
    ( INPUT pdInstanceID        AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCachePageBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCachePageBuffer Procedure 
FUNCTION getCachePageBuffer RETURNS HANDLE
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCachePageInstanceBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCachePageInstanceBuffer Procedure 
FUNCTION getCachePageInstanceBuffer RETURNS HANDLE
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCacheUiEventBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCacheUiEventBuffer Procedure 
FUNCTION getCacheUiEventBuffer RETURNS HANDLE
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getClassChildren Procedure 
FUNCTION getClassChildren RETURNS CHARACTER
    ( INPUT pcClassName     AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassChildrenFromDB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getClassChildrenFromDB Procedure 
FUNCTION getClassChildrenFromDB RETURNS CHARACTER
  (pcClasses AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassFromClientCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getClassFromClientCache Procedure 
FUNCTION getClassFromClientCache RETURNS LOGICAL
  ( pcClassNames AS CHARACTER,
    pcClassDir   AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassFromInstance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getClassFromInstance Procedure 
FUNCTION getClassFromInstance RETURNS CHARACTER
  ( INPUT pdInstance AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassParents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getClassParents Procedure 
FUNCTION getClassParents RETURNS CHARACTER
    ( INPUT pcClasses        AS CHARACTER  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassParentsFromDB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getClassParentsFromDB Procedure 
FUNCTION getClassParentsFromDB RETURNS CHARACTER
    (pcClasses AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEntityFromClientCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEntityFromClientCache Procedure 
FUNCTION getEntityFromClientCache RETURNS LOGICAL
  ( pcEntityNames AS CHARACTER,
    pcEntityDirectory AS CHARACTER,
    pcLanguageCode AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMappedFilename) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMappedFilename Procedure 
FUNCTION getMappedFilename RETURNS CHARACTER
        ( input pcObjectName        as character ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNextQueryOrdinal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNextQueryOrdinal Procedure 
FUNCTION getNextQueryOrdinal RETURNS INTEGER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectPathedName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectPathedName Procedure 
FUNCTION getObjectPathedName RETURNS CHARACTER
    ( INPUT pdSmartObjectObj     AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDOincludeFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDOincludeFile Procedure 
FUNCTION getSDOincludeFile RETURNS CHARACTER
    (   INPUT pcIncludeFile       AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSmartObjectObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSmartObjectObj Procedure 
FUNCTION getSmartObjectObj RETURNS DECIMAL
    ( INPUT pcObjectName                AS CHARACTER,
      INPUT pdCustmisationResultObj     AS DECIMAL      )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWhereConstantLevel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWhereConstantLevel Procedure 
FUNCTION getWhereConstantLevel RETURNS CHARACTER
    ( INPUT phAttributeBuffer       AS HANDLE,
      INPUT phAttributeField        AS HANDLE  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWhereStoredLevel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWhereStoredLevel Procedure 
FUNCTION getWhereStoredLevel RETURNS CHARACTER
    ( INPUT phAttributeBuffer       AS HANDLE,
      INPUT phAttributeField        AS HANDLE  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-IsA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD IsA Procedure 
FUNCTION IsA RETURNS LOGICAL
    ( INPUT pdInstanceId        AS DECIMAL,
      INPUT pcClassName         AS CHARACTER    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isObjectCached) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isObjectCached Procedure 
FUNCTION isObjectCached RETURNS LOGICAL
    ( INPUT pcLogicalObjectName AS CHARACTER,
      INPUT pdUserObj           AS DECIMAL,
      INPUT pcResultCode        AS CHARACTER,
      INPUT pcRunAttribute      AS CHARACTER,
      INPUT pdLanguageObj       AS DECIMAL,
      INPUT plDesignMode        AS LOGICAL         ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchClassObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD launchClassObject Procedure 
FUNCTION launchClassObject RETURNS HANDLE
    ( INPUT pcClassName             AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newInstance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newInstance Procedure 
FUNCTION newInstance RETURNS LOGICAL
    ( INPUT pcInstance                  AS character,
      input pcClassName                 as character,
      input pcSuperProcedure            as character,
      input pcSuperProcedureMode        as character        )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareEntityFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD prepareEntityFields Procedure 
FUNCTION prepareEntityFields RETURNS LOGICAL
      ( phObject        AS HANDLE,
        pcEntityFields  AS CHAR, 
        phBuffer        AS HANDLE,
        pcBufferOptions AS CHAR,
        pcAttributes    AS CHAR,
        pcPropertyLists AS CHAR,
        pcDelimiters    AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareInstance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD prepareInstance Procedure 
FUNCTION prepareInstance RETURNS LOGICAL
    ( INPUT pcInstance              AS CHARACTER, 
      INPUT phSource                AS HANDLE  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareRowObjectColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD prepareRowObjectColumns Procedure 
FUNCTION prepareRowObjectColumns RETURNS LOGICAL
  (phRowObjectTable         AS HANDLE,
   pcEntities               AS CHAR, 
   pcColumns                AS CHAR,
   pcColumnsByEntity        AS CHAR,
   pcRenameColumnsByEntity  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFolderDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFolderDetails Procedure 
FUNCTION setFolderDetails RETURNS LOGICAL
    ( INPUT pdInstanceId            AS DECIMAL,      
      INPUT pcFolderInstanceName    AS CHARACTER,
      INPUT pcSecuredTokens         AS CHARACTER,
      INPUT plApplyTranslations     AS LOGICAL,
      INPUT pdLanguageObj           AS DECIMAL            ) FORWARD.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 23.29
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */
DEFINE VARIABLE cClassesToCache             AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cAbstractClassNames         AS CHARACTER                NO-UNDO.
DEFINE VARIABLE hFirstProcedure             AS HANDLE                   NO-UNDO.

CREATE WIDGET-POOL NO-ERROR.
/* The ClassBuffer widget pool should only be used for ADMReposProps temp-table
   records created in prepareInstance */
CREATE WIDGET-POOL "ClassBuffer":U PERSISTENT NO-ERROR.

ON CLOSE OF THIS-PROCEDURE 
DO:
    DELETE WIDGET-POOL NO-ERROR.
    DELETE WIDGET-POOL "ClassBuffer":U NO-ERROR.

    RUN plipShutdown IN TARGET-PROCEDURE.

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

&IF DEFINED(server-side) <> 0 &THEN
    {ry/app/rymenufunc.i}
    PROCEDURE rygetmensp:         {ry/app/rygetmensp.p}     END PROCEDURE.
    PROCEDURE rygetitemp:         {ry/app/rygetitemp.p}     END PROCEDURE.
&ENDIF
 
/* Cache Objects, Classes, etc */
ASSIGN cClassesToCache = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE, INPUT "StartupCacheClasses":U).
IF cClassesToCache EQ ? THEN
    ASSIGN cClassesToCache = "":U.
If cClassesToCache NE "":U THEN
DO:
&IF DEFINED(server-side) <> 0 &THEN
RUN createClassCache (INPUT cClassesToCache) NO-ERROR.
&ELSE
IF SESSION EQ gshAstraAppserver THEN /* running client-server, just run the cache procedure */
    RUN createClassCache IN TARGET-PROCEDURE (INPUT cClassesToCache) NO-ERROR.
ELSE
DO:
    /* This event is going to be picked up in the cache PLIPP, it will then run sendLoginCache in the manager */
    ASSIGN hFirstProcedure = SESSION:FIRST-PROCEDURE.
    PUBLISH "loginGetClassCache":U FROM hFirstProcedure (INPUT THIS-PROCEDURE).
END.
&ENDIF
END.    /* there are classes to cache. */

/* Create these queries up-front. Just create 2 - more will be created if needed, but 2 should sufice. */
CREATE QUERY ghQuery[01] NO-ERROR.
CREATE QUERY ghQuery[02] NO-ERROR.

/* Determine the abstract class names and set them as class properties. */
ASSIGN cAbstractClassNames = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE, INPUT "AbstractClassNames":U).
IF cAbstractClassNames EQ ? THEN
    ASSIGN cAbstractClassNames = "":U.

/* Build a string and get rid of extra commas. */
ASSIGN cAbstractClassNames = "{&ABSTRACT-CLASS-NAMES},":U + cAbstractClassNames
       cAbstractClassNames = REPLACE(cAbstractClassNames, ",,":U, ",":U)
       cAbstractClassNames = TRIM(cAbstractClassNames, ",":U).

/* Set the property for use by other procedures */
DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                 INPUT "AbstractClassNames":U,
                 INPUT cAbstractClassNames      ).

ASSIGN glUseThinRendering = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                              INPUT "UseThinRendering":U ).

            
/* Subscribe to the event published by the configuration file
   manager on session shutdown. The Repository Manager needs
   to perform some tasks when the session shuts down, such as 
   cleaning memory and dumping the entities to disk.
 */
SUBSCRIBE TO "ICFCFM_StartSessionShutdown":U ANYWHERE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buildClassCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildClassCache Procedure 
PROCEDURE buildClassCache :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Constructs the ttClass table.
  Parameters:  pcClassCode - a class code, a CSV list of class codes or * for all.
  Notes:       * This procedure is designed to run when a DB connection is available,
                 and is solely used to build the temp-tables of the object types.
               * This procedure differs from createClassCache in that createClassCache
                 uses retrieveClassCache to ensure that objects are cached on both the
                 client and server.
               * This procedure is called from createClassCache or rygetclassp.p.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcClassCode          AS CHARACTER            NO-UNDO.

    &IF DEFINED(Server-Side) NE 0 &THEN
    DEFINE VARIABLE cClassQueryWhere                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDateFormat                     AS CHARACTER            NO-UNDO.
    define variable cNumericSeparator               as character            no-undo.
    define variable cDecimalPoint                   as character            no-undo.    
    DEFINE VARIABLE iLoopCount                      AS INTEGER              NO-UNDO.
    DEFINE VARIABLE hClassQuery                     AS HANDLE               NO-UNDO.

    DEFINE BUFFER gsc_object_type   FOR gsc_object_type.
    DEFINE BUFFER ttClass           FOR ttClass.
    
    DEFINE QUERY qryClass       FOR gsc_object_type.
    
    /* Force the date format to mdy and numeric format to American 
       This will ensure that create-like will not choke. The create-like
       statement in prepareInstance needs the temp-table created as
       american.
     */
    ASSIGN cDateFormat            = SESSION:DATE-FORMAT
           cNumericSeparator      = session:numeric-separator
           cDecimalPoint          = session:numeric-decimal-point
           SESSION:DATE-FORMAT    = "mdy":U
           SESSION:NUMERIC-FORMAT = "American":U.
    
    IF pcClassCode EQ "":U THEN
        ASSIGN pcClassCode = "*":U.
    
    /* Class Query */
    ASSIGN cClassQueryWhere = " FOR EACH gsc_object_type NO-LOCK ":U.
    IF pcClassCode NE "*":U THEN
    DO:
       DO iLoopCount = 1 TO NUM-ENTRIES(pcClassCode):
        ASSIGN cClassQueryWhere = cClassQueryWhere 
                                + (IF iLoopCount = 1 THEN ' WHERE ':U ELSE ' OR ':U) 
                                + " gsc_object_type.object_type_code = ":U 
                                + QUOTER(ENTRY(iLoopCount, pcClassCode)).
      END.    /* not all */
    END.    /* selected classes */

    ASSIGN hClassQuery = QUERY qryClass:HANDLE.
    hClassQuery:QUERY-PREPARE(cClassQueryWhere).
    hClassQuery:QUERY-OPEN().
    hClassQuery:GET-FIRST(NO-LOCK).
    DO WHILE AVAILABLE gsc_object_type:
        IF NOT CAN-FIND(FIRST ttClass WHERE ttClass.ClassName = gsc_object_type.object_type_code) THEN
        DO:
            RUN buildDenormalizedAttributes IN TARGET-PROCEDURE ( INPUT gsc_object_type.object_type_code ) NO-ERROR.
            /* This is a static query so we don't have to worry about memory leaks etc. Just return the error. */
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN 
            DO:
              /* Reset the Numerif-format and dateformat back */
              ASSIGN SESSION:DATE-FORMAT = cDateFormat.
              session:set-numeric-format(cNumericSeparator,cDecimalPoint).              
              RETURN ERROR RETURN-VALUE.
            END.    /* error building attributes */
        END.    /* error */
        hClassQuery:GET-NEXT(NO-LOCK).
    END.    /* avail class */
    hClassQuery:QUERY-CLOSE().

    /* Reset the Numeric-format and dateformat back.
       Use the set-numeric-format() method because we need
       to support non-European and non-American formats, ie
       a space as separator and $ as decimal point.      
     */
    ASSIGN SESSION:DATE-FORMAT = cDateFormat.
    session:set-numeric-format(cNumericSeparator,cDecimalPoint).        
    &ENDIF
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* buildClassCache */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildDenormalizedAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildDenormalizedAttributes Procedure 
PROCEDURE buildDenormalizedAttributes :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Build the actual denormalised class attribute TT.
  Parameters:  pcClassName - 
  Notes:       * This procedure may be called recursively from itself.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcClassName              AS CHARACTER        NO-UNDO.

&IF DEFINED(Server-Side) NE 0 &THEN
DEFINE VARIABLE lOk                             AS LOGICAL          NO-UNDO.
DEFINE VARIABLE iNumberOfAttributes             AS INTEGER          NO-UNDO.
DEFINE VARIABLE iNumberOfEvents                 AS INTEGER          NO-UNDO.
DEFINE VARIABLE iFieldLoop                      AS INTEGER          NO-UNDO.
DEFINE VARIABLE cSupportedLinks                 AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cEventString                    AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cInitialValue                   AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cFormat                         AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cDataType                       AS CHARACTER        NO-UNDO.
DEFINE VARIABLE hClassAttributeTempTable        AS HANDLE           NO-UNDO.
DEFINE VARIABLE hField                          AS HANDLE           NO-UNDO.
DEFINE VARIABLE hClassEventTempTable            AS HANDLE           NO-UNDO.

DEFINE BUFFER gsc_object_type       FOR gsc_object_type.
DEFINE BUFFER gscot                 FOR gsc_object_type.
DEFINE BUFFER parentClass           FOR ttClass.
DEFINE BUFFER ttClass                   FOR ttClass.

 FIND gsc_object_type WHERE
      gsc_object_type.object_type_code = pcClassName 
      NO-LOCK NO-ERROR.
    
 IF AVAILABLE gsc_object_type THEN
 DO:
    /* Create ttClass record for for later use. */
    CREATE ttClass.
    ASSIGN ttClass.ClassName           = gsc_object_type.object_type_code
           ttClass.ClassObj            = gsc_object_type.object_type_obj
           ttClass.InheritsFromClasses = gsc_object_type.object_type_code.
    /* Create a temp-table for storing the denormalised attribute structure */      
   CREATE TEMP-TABLE hClassAttributeTempTable.
   /* This field allows joins to the owning object. */
   hClassAttributeTempTable:ADD-NEW-FIELD("InstanceId":U, "DECIMAL":U, 0, ?, 0 ).
   
   /* This field will be used as key for each instance's record on the client. */
   hClassAttributeTempTable:ADD-NEW-FIELD("Target":U, "HANDLE":U, 0, ?, ?).

   /* Add entries for InstanceId and TargetProcedure */
   ASSIGN iNumberOfAttributes  = 2.
   
   /* If there is a custom class, include that behaviour first.
    */
    if gsc_object_type.custom_object_type_obj ne 0 then
    do:
        /** Make sure that the custom class is cached, too. */
        FIND FIRST gscot WHERE gscot.object_type_obj = gsc_object_type.custom_object_type_obj NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gscot THEN
        DO:
            /* Clean up. */
            DELETE OBJECT hClassAttributeTempTable NO-ERROR.
            RETURN ERROR {aferrortxt.i 'AF' '40' 'gsc_object_type' 'custom_object_type_obj' "'The class that customizes the ' + gsc_object_type.object_type_code + ' class could not be found' " }.            
        END. /* n/a gscot */
        
        /* parentClass represents the custom class.
         */
        FIND FIRST parentClass WHERE parentClass.className = gscot.object_type_code NO-ERROR.
        IF NOT AVAILABLE parentClass THEN
        DO:
            RUN buildDenormalizedAttributes IN TARGET-PROCEDURE ( INPUT gscot.object_type_code ) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
            DO:
                /* First clean up */
                DELETE OBJECT hClassAttributeTempTable NO-ERROR.
                /* Then return an error. */
                RETURN ERROR RETURN-VALUE.
            END.   /* error. */
            
            FIND FIRST parentClass WHERE parentClass.className = gscot.object_type_code NO-ERROR.
        END.    /* n/a parentClass */
        
        IF AVAILABLE parentClass THEN
        DO:
            /* Make sure that the SuperProcedureModes are correct for this
               class first.
             */
            IF parentClass.SuperProcedures NE "":U THEN
                ASSIGN ttClass.SuperProcedureModes = FILL(',':U + parentClass.SuperProcedureModes, NUM-ENTRIES(parentClass.SuperProcedures))
                       ttClass.SuperProcedureModes = LEFT-TRIM(ttClass.SuperProcedureModes,",":U).
            
            ASSIGN cSupportedLinks             = TRIM(parentClass.classBufferHandle:BUFFER-FIELD("SupportedLinks":U):INITIAL)
                   ttClass.InheritsFromClasses = parentClass.inheritsFromClasses + ",":U + ttClass.InheritsFromClasses
                   
                       /* Since blank are valid entries for SuperProcedureMode and the 
                          SuperProcedure need to be in synch, we deal with proper 
                          delimiters here to avoid an need to TRIM the lists later 
                          We store this class last, so they can be loaded in the order they 
                          are listed 
                        */
                   ttClass.SuperProcedureModes = parentClass.SuperProcedureModes
                   ttClass.SuperProcedures     = parentClass.SuperProcedures.
                   
            
            /* We add the inherited fields after we have this class' fields
               (The order is insignificant and can be changed if required)
             */
            DO iFieldLoop = 1 TO parentClass.classBufferHandle:NUM-FIELDS:
                ASSIGN hField = parentClass.classBufferHandle:BUFFER-FIELD(iFieldLoop).
                
                /* SupportedLinks and ClassName is not a system field but it should not be
                   inherited like a system field */
                IF CAN-DO("InstanceId,Target,SupportedLinks,ClassName":U, hField:NAME) THEN
                    NEXT.
                
                IF hClassAttributeTempTable:ADD-LIKE-FIELD(hField:NAME, hField) THEN
                DO:
                    ASSIGN iNumberOfAttributes = iNumberOfAttributes + 1.
                    IF CAN-DO(parentClass.SetList, STRING(iFieldLoop)) THEN ASSIGN ttClass.SetList = ttClass.SetList + ",":U + STRING(iNumberOfAttributes).
                    IF CAN-DO(parentClass.GetList, STRING(iFieldLoop)) THEN ASSIGN ttClass.GetList = ttClass.GetList + ",":U + STRING(iNumberOfAttributes).
                    IF CAN-DO(parentClass.RunTimeList, STRING(iFieldLoop)) THEN ASSIGN ttClass.RunTimeList = ttClass.RunTimeList + ",":U + STRING(iNumberOfAttributes).
                END.    /* added field; updated system lists */
            END.    /* field loop for buffer fields */
            
            /* Get the UI events from the parent, and add these to the event record. 
             */
            IF VALID-HANDLE(parentClass.EventBufferHandle) THEN
            DO iFieldLoop = 1 TO parentClass.EventBufferHandle:NUM-FIELDS:
                ASSIGN hField = parentClass.EventBufferHandle:BUFFER-FIELD(iFieldLoop).
                
                /* Skip the 'system' fields */
                IF CAN-DO("InstanceId,Target":U, hField:NAME) THEN
                    NEXT.
                    
                IF hClassEventTempTable:ADD-LIKE-FIELD(hField:NAME, hField) THEN
                    ASSIGN iNumberOfEvents = iNumberOfEvents + 1.
            END.    /* field loop for events */            
        END.    /* avail parentClass record for custom class */
    END.    /* there is a custom class. */
    
   /* Get all the attributes for this class. */
   FOR EACH ryc_attribute_value 
       WHERE ryc_attribute_value.object_type_obj     = gsc_object_type.object_type_obj
       AND   ryc_attribute_value.smartObject_obj     = 0
       AND   ryc_attribute_value.object_instance_obj = 0
       NO-LOCK,
     FIRST ryc_attribute WHERE
           ryc_attribute.attribute_label = ryc_attribute_value.attribute_label AND 
           ryc_attribute.derived_value = NO AND ryc_attribute.design_only = NO
           NO-LOCK
           BY ryc_attribute.attribute_label:
     /* Special case(s) - the extended classes values will be appended to 
        these values later. 
        Super procedures are stored as attribute, but the value is not 
        inherited. It is passed to the client as a system attribute with 
        the accumulated inherited values and eventually stored in ttClass */
     CASE ryc_attribute.attribute_label:
       WHEN "SuperProcedure":U THEN
           ASSIGN ttClass.SuperProcedures = ryc_attribute_value.character_value + ",":U + ttClass.SuperProcedures    
                  ttClass.SuperProcedures = right-trim(ttClass.SuperProcedures, ",":U).                  
       /* The superprocedure mode is stored as a normal attribute, but 
          passed to the client as a system attribute, with one entry for each
          SuperProcedure, stored in ttClass when used  */
       WHEN "SuperProcedureMode":U THEN
           ASSIGN ttClass.SuperProcedureModes = ryc_attribute_value.character_value + ",":U + ttClass.SuperProcedureModes
                  ttClass.SuperProcedureModes = right-trim(ttClass.SuperProcedureModes, ",":U).
       WHEN "SupportedLinks":U OR WHEN "ClassName":U THEN NEXT.       
     END CASE.  /* attribute label */
     
     /* Make sure that character attributes/fields have initial values large enough. */
     CASE ryc_attribute.data_type:
       WHEN {&CHARACTER-DATA-TYPE} THEN lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"CHARACTER",0,"x(":U + STRING(MAX(1,LENGTH(ryc_attribute_value.character_value))) + ")":U,ryc_attribute_value.character_value).
       WHEN {&LOGICAL-DATA-TYPE}   THEN lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"LOGICAL":U,0,?,ryc_attribute_value.logical_value).
       WHEN {&INTEGER-DATA-TYPE}   THEN lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"INTEGER":U,0,?,ryc_attribute_value.integer_value).
       WHEN {&HANDLE-DATA-TYPE}    THEN lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"HANDLE":U,0,?,?).
       WHEN {&DECIMAL-DATA-TYPE}   THEN lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"DECIMAL":U,0,?,ryc_attribute_value.decimal_value).
       WHEN {&ROWID-DATA-TYPE}     THEN lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"ROWID":U,0,?,TO-ROWID(ryc_attribute_value.character_value)).
       WHEN {&RAW-DATA-TYPE}       THEN lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"RAW":U,0,?,ryc_attribute_value.raw_value).
       WHEN {&DATE-DATA-TYPE}      THEN lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"DATE":U,0,?,ryc_attribute_value.date_value).
       WHEN {&RECID-DATA-TYPE}     THEN lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"RECID":U,0,?,IF ryc_attribute_value.integer_value = 0 THEN ? ELSE ryc_attribute_value.integer_value).
       OTHERWISE                        lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"CHARACTER",0,"x(":U + STRING(MAX(1,LENGTH(ryc_attribute_value.character_value))) + ")":U,ryc_attribute_value.character_value).
     END CASE.   /* DataType */
     
     IF lOk THEN
     DO:
       ASSIGN iNumberOfAttributes  = iNumberOfAttributes + 1.
       IF CAN-DO(ryc_attribute.override_type,"Get":U) THEN
            ASSIGN ttClass.GetList = ttClass.GetList + ",":U + STRING(iNumberOfAttributes).
       IF CAN-DO(ryc_attribute.override_type,"Set":U) THEN
            ASSIGN ttClass.SetList = ttClass.SetList + ",":U + STRING(iNumberOfAttributes).
       IF ryc_attribute.runtime_only THEN
            ASSIGN ttClass.RunTimeList = ttClass.RunTimeList + ",":U + STRING(iNumberOfAttributes).
     END.  /* OK? */
   END.  /* each attribute value */
                                                                                             
   /* Create a temp-table for storing the denormalised UI Event structure */
   CREATE TEMP-TABLE hClassEventTempTable.
   
   /* This field allows joins to the owning object. */
   hClassEventTempTable:ADD-NEW-FIELD("InstanceId":U, "DECIMAL":U, 0, ?, 0 ).
   
   /* This field will be used as key for each instance's record on the client. */
   hClassEventTempTable:ADD-NEW-FIELD("Target":U, "HANDLE":U, 0, ?, ?).

   /* Add entries for InstanceId and Target */
   ASSIGN iNumberOfEvents = 2.
   
   FOR EACH ryc_ui_event WHERE 
            ryc_ui_event.object_type_obj     = gsc_object_type.object_type_obj AND
            ryc_ui_event.smartObject_obj     = 0                               AND
            ryc_ui_event.object_instance_obj = 0                               AND
            ryc_ui_event.event_disabled      = NO                              AND
            ryc_ui_event.event_action       <> "":U 
            NO-LOCK:            
        ASSIGN cEventString = ryc_ui_event.action_type + {&Value-Delimiter}
                            + ryc_ui_event.action_target + {&Value-Delimiter}
                            + ryc_ui_event.event_action + {&Value-Delimiter}
                            + ryc_ui_event.event_parameter
               lOk = hClassEventTempTable:ADD-NEW-FIELD(ryc_ui_event.event_name,
                                                        "CHARACTER",0,
                                                        "x(":U + STRING(MAX(1,LENGTH(cEventString))) + ")":U,
                                                        /* Initial Value */
                                                        cEventString).
        IF lOk THEN
            ASSIGN iNumberOfEvents = iNumberOfEvents + 1.
   END.    /* UI events */
      
   IF gsc_object_type.extends_object_type_obj NE 0 THEN
   DO:
     /** Make sure that the parent class is cached, too. */
     FIND FIRST gscot WHERE gscot.object_type_obj = gsc_object_type.extends_object_type_obj NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gscot THEN
     DO:
       /* Clean up. */
       DELETE OBJECT hClassAttributeTempTable NO-ERROR.
       RETURN ERROR {aferrortxt.i 'AF' '40' 'gsc_object_type' 'extends_object_type_obj' "'The class that the ' + gsc_object_type.object_type_code + ' class extends could not be found' " }.
     END. /* n/a gscot */
     
     /* parentClass represents the parent class.
      */
     FIND FIRST parentClass WHERE parentClass.className = gscot.object_type_code NO-ERROR.
     IF NOT AVAILABLE parentClass THEN
     DO:
       RUN buildDenormalizedAttributes IN TARGET-PROCEDURE ( INPUT gscot.object_type_code ) NO-ERROR.
       IF ERROR-STATUS:ERROR THEN
       DO:
         /* First clean up */
         DELETE OBJECT hClassAttributeTempTable NO-ERROR.
         /* the return an error. */
         RETURN ERROR RETURN-VALUE.
       END.   /* error. */

       FIND FIRST parentClass WHERE parentClass.className = gscot.object_type_code NO-ERROR.
     END.    /* n/a parentClass */

     IF AVAILABLE parentClass THEN
     DO:
        /* Make sure that the SuperProcedureModes are correct for this
           class first.
         */         
       IF ttClass.SuperProcedures NE "":U THEN
       DO:
           /* If there is no value set for the SuperProcedureModes at this
              class, then inherit from this classes parent class. 
              Since the parent values are PRE-pended to a classes values, 
              take the first entry of the list. There should always be a value here.
            */
           IF ttClass.SuperProcedureModes EQ "":U THEN
               ASSIGN ttClass.SuperProcedureModes = ENTRY(1, parentClass.SuperProcedureModes).
           
           ASSIGN ttClass.SuperProcedureModes = FILL(',':U + ttClass.SuperProcedureModes, NUM-ENTRIES(ttClass.SuperProcedures))
                  ttClass.SuperProcedureModes = LEFT-TRIM(ttClass.SuperProcedureModes,",":U).
       END.    /* there are super procedures */
                           
       ASSIGN cSupportedLinks      = TRIM(parentClass.classBufferHandle:BUFFER-FIELD("SupportedLinks":U):INITIAL)
              ttClass.InheritsFromClasses = ttClass.InheritsFromClasses + ",":U + parentClass.inheritsFromClasses
              /* Since blank are valid entries for SuperProcedureMode and the 
                 SuperProcedure need to be in synch, we deal with proper 
                 delimiters here to avoid an need to TRIM the lists later 
                 We store this class last, so they can be loaded in the order they 
                 are listed 
               */
              ttClass.SuperProcedureModes = parentClass.SuperProcedureModes + ",":U + ttClass.SuperProcedureModes
              ttClass.SuperProcedures     = parentClass.SuperProcedures + ",":U + ttClass.SuperProcedures.
        
       /* We add the inherited fields after we have this class' fields
          (The order is insignificant and can be changed if required) */
       DO iFieldLoop = 1 TO parentClass.classBufferHandle:NUM-FIELDS:
         ASSIGN hField = parentClass.classBufferHandle:BUFFER-FIELD(iFieldLoop).
         /* SupportedLinks and ClassName is not a system field but it should not be
            inherited like a system field */
         IF CAN-DO("InstanceId,Target,SupportedLinks,ClassName":U, hField:NAME) THEN
             NEXT.
           
         IF hClassAttributeTempTable:ADD-LIKE-FIELD(hField:NAME, hField) THEN
         DO:
           ASSIGN iNumberOfAttributes = iNumberOfAttributes + 1.
           IF CAN-DO(parentClass.SetList, STRING(iFieldLoop)) THEN ASSIGN ttClass.SetList = ttClass.SetList + ",":U + STRING(iNumberOfAttributes).
           IF CAN-DO(parentClass.GetList, STRING(iFieldLoop)) THEN ASSIGN ttClass.GetList = ttClass.GetList + ",":U + STRING(iNumberOfAttributes).
           IF CAN-DO(parentClass.RunTimeList, STRING(iFieldLoop)) THEN ASSIGN ttClass.RunTimeList = ttClass.RunTimeList + ",":U + STRING(iNumberOfAttributes).
         END.    /* added field; updated system lists */
       END.    /* field loop */

       /* Get the UI events from the parent, and add these to the event record. 
        */
        IF VALID-HANDLE(parentClass.EventBufferHandle) THEN        
        DO iFieldLoop = 1 TO parentClass.EventBufferHandle:NUM-FIELDS:
            ASSIGN hField = parentClass.EventBufferHandle:BUFFER-FIELD(iFieldLoop).
            
            /* Skip the 'system' fields */
            IF CAN-DO("InstanceId,Target":U, hField:NAME) THEN
                NEXT.
            
            IF hClassEventTempTable:ADD-LIKE-FIELD(hField:NAME, hField) THEN
                ASSIGN iNumberOfEvents = iNumberOfEvents + 1.
        END.    /* field loop for events */
     END.    /* avail class */
   END.    /* this class extends another. */
   ELSE
       /* If this class doesn't inherit from another, make sure that the
          SuperProcedureModes property has the correct number of entries
          (it should match the number of entries in the SuperProcedures 
          field), and also that it defaults to STATELESS
        */
       ASSIGN ttClass.SuperProcedureModes = FILL(',':U + (IF ttClass.SuperProcedureModes EQ "":U THEN "Stateless":U
                                                          ELSE ttClass.SuperProcedureModes),
                                                 NUM-ENTRIES(ttClass.SuperProcedures))
              ttClass.SuperProcedureModes = LEFT-TRIM(ttClass.SuperProcedureModes, ",":U).
   
   /* SupportedLinks need to become an attribute, (currently accumulative 
      inherited from extended lasses. )  */
   FOR EACH ryc_supported_link NO-LOCK
       WHERE ryc_supported_link.Object_type_obj = gsc_object_type.object_type_obj,
     FIRST ryc_smartlink_type NO-LOCK
       WHERE ryc_smartlink_type.smartlink_type_obj = ryc_supported_link.smartlink_type_obj:
     cSupportedLinks = cSupportedLinks 
                     + ',':U
                     + (IF ryc_supported_link.link_source
                        THEN ryc_smartLink_type.link_name + '-source':U
                        ELSE '':U)
                     + (IF ryc_supported_link.link_source
                        AND ryc_supported_link.link_target THEN ',':U
                        ELSE '':U)                        
                     + (IF ryc_supported_link.link_target
                        THEN ryc_smartLink_type.link_name + '-target':U
                        ELSE '':U).
   END. /* for each link */
   
   /* SupportedLinks is used as normal attribute  */
   ASSIGN cSupportedLinks = LEFT-TRIM(cSupportedLinks,',':U)
          lOk = hClassAttributeTempTable:ADD-NEW-FIELD("SupportedLinks":U, "CHARACTER":U, 0, 
                                                      "x(":U + STRING(MAX(1,LENGTH(cSupportedLinks))) + ")":U, 
                                                      cSupportedLinks)
          /* There must always be a ClassName attribute that contains the name of the class that the
             object belongs to.
           */
          lOk = hClassAttributeTempTable:ADD-NEW-FIELD("ClassName":U, "CHARACTER":U, 0, 
                                                      "x(":U + STRING(MAX(1,LENGTH(gsc_object_type.object_type_code))) + ")":U, 
                                                      gsc_object_type.object_type_code)
          ttClass.InheritsFromClasses = LEFT-TRIM(ttClass.InheritsFromClasses,",":U)
          ttClass.GetList             = LEFT-TRIM(ttClass.GetList,",":U)
          ttClass.SetList             = LEFT-TRIM(ttClass.SetList,",":U)
          ttClass.RunTimeList         = LEFT-TRIM(ttClass.RunTimeList,",":U)
          ttClass.SuperProcedures     = TRIM(ttClass.SuperProcedures, ",":U)
          ttClass.SuperProcedureModes = TRIM(ttClass.SuperProcedureModes, ",":U).
          
    /* Add Indexes */
    /* The index on the InstanceId is a non-unique primary key. It does
     * not need to be a unique index because this table is only ever used
     * to store the class-level attributes and their values.
     */    
    hClassAttributeTempTable:ADD-NEW-INDEX("idxRecordID":U, FALSE, TRUE).  /* non-unique primary key */
    hClassAttributeTempTable:ADD-INDEX-FIELD("idxRecordID":U, "InstanceId":U).
    
    /* ADM key used for each running instance */
    hClassAttributeTempTable:ADD-NEW-INDEX("idxTargetID":U, FALSE, FALSE).
    hClassAttributeTempTable:ADD-INDEX-FIELD("idxTargetID":U, "Target":U).
    
    /* Prepare the Temp-table */
    hClassAttributeTempTable:TEMP-TABLE-PREPARE("c_":U + REPLACE(gsc_object_type.object_type_code, " ":U, "":U)).
    
    ASSIGN ttClass.ClassTableName      = hClassAttributeTempTable:NAME
           ttClass.ClassBufferHandle   = hClassAttributeTempTable:DEFAULT-BUFFER-HANDLE.
           
    /* Ui Events:
     * Check if there are more than 2 fields in the temp-table. If so, prepare the events TT.
     * If not, then delete the handle and do nothing further.
     */
    IF iNumberOfEvents GT 2 THEN
    DO:
        /* Add Indexes */
        /* The index on the InstanceId is a non-unique primary key. It does
         * not need to be a unique index because this table is only ever used
         * to store the class-level attributes and their values.
         */
        hClassEventTempTable:ADD-NEW-INDEX("idxInstanceId":U, FALSE, TRUE).  
        hClassEventTempTable:ADD-INDEX-FIELD("idxInstanceId":U, "InstanceId":U).
        
        /* ADM key used for each running instance */
        hClassEventTempTable:ADD-NEW-INDEX("idxTargetID":U, FALSE, FALSE).
        hClassEventTempTable:ADD-INDEX-FIELD("idxTargetID":U, "Target":U).
        
        /* Prepare the Temp-table */
        hClassEventTempTable:TEMP-TABLE-PREPARE("e_":U + REPLACE(gsc_object_type.object_type_code, " ":U, "":U)).
        
        ASSIGN ttClass.EventTableName    = hClassEventTempTable:NAME
               ttClass.EventBufferHandle = hClassEventTempTable:DEFAULT-BUFFER-HANDLE.              
    END.    /* there are UI events for this class. */
    ELSE
    DO:
        DELETE OBJECT hClassEventTempTable NO-ERROR.
        ASSIGN hClassEventTempTable      = ?
               ttClass.EventTableName    = ?
               ttClass.EventBufferHandle = ?.
    END.    /* no events */
  END.    /* avail gsc_object_type */
  &ENDIF
  
  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN.
END PROCEDURE.  /* buildDenormalizedAttributes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildEntityCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildEntityCache Procedure 
PROCEDURE buildEntityCache :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Creates cache records for the requested entities.
  Parameters:  pcEntityName - a CSV list of entity names.
               pcLanguageCode - language code for entity translation.  
  Notes:       * This is a server-side only API.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcEntityName            AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcLanguageCode          AS CHARACTER            NO-UNDO.
            
    &IF DEFINED(Server-Side) NE 0 &THEN
    DEFINE VARIABLE iEntityLoop                 AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iAttributeEntry             AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iNumFields                  AS INTEGER              NO-UNDO.
    DEFINE VARIABLE hEntityTable                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hBufferField                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cDataType                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFormat                     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInitial                    AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cLabel                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cColumnLabel                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cError                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cDateFormat                 AS CHARACTER            NO-UNDO.
    define variable cPropertyNames              as character            no-undo.
    define variable cPropertyValues             as character            no-undo.
    DEFINE VARIABLE cNumericSeparator           AS CHARACTER            NO-UNDO.
    define variable cDecimalPoint               as character            no-undo.
    DEFINE VARIABLE cTranslatedLabels           AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cTooltips                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cEntry                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.
    DEFINE BUFFER rycso                      FOR ryc_smartobject.
    DEFINE BUFFER gsc_object_type            FOR gsc_object_type.

    IF pcLanguageCode = ? OR pcLanguageCode = "":U THEN
       RETURN ERROR {aferrortxt.i 'AF' '1' '' '' '"Language Code"'}.
    ELSE
    DO:
        IF pcLanguageCode <> "NONE":U THEN /* NONE corresponds to <None> at the Application Login window */
        DO:
            FIND gsc_language WHERE language_code = pcLanguageCode NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gsc_language THEN
                RETURN ERROR {aferrortxt.i 'AF' '11' '' '' '"gsc_language record"' '"the specified language"'}.
        END.
    END.

    /* Force the SESSION formats to default.
       - The dictionary stores initial valuies in 'american' and 'mdy'
         formats. We keep this format in the Entities at run-time in order 
         to have a consistent format, since the same cache may be used for 
         different clients with different settings.   
       - The ADD-NEW-FIELD needs initial value in the SESSION:DATE-FORMAT format
         and SESSION:NUMERIC-FORMAT format. 
       So let us make this consistent and set SESSION attributes at the 
       start of this API change it back to original value at the end .
    */
    ASSIGN cDateFormat            = SESSION:DATE-FORMAT
           cNumericSeparator      = session:numeric-separator
           cDecimalPoint          = session:numeric-decimal-point
           SESSION:DATE-FORMAT    = "mdy":U
           SESSION:NUMERIC-FORMAT = "American":U.
    
    ENTITY-LOOP:
    DO iEntityLoop = 1 TO NUM-ENTRIES(pcEntityName):
        /* First make sure that the object exists. */
        FIND FIRST ryc_smartobject WHERE
                   ryc_smartobject.object_filename          = ENTRY(iEntityLoop, pcEntityName) AND
                   ryc_smartobject.customization_result_obj = 0
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ryc_smartobject THEN
        DO:
            assign cError = {aferrortxt.i 'AF' '5' 'ryc_smartobject' 'object_filename' '"Entity object"' "'Entity object name: ' + ENTRY(iEntityLoop, pcEntityName)"}.
            leave ENTITY-LOOP.
        END.    /* no entity object */
        
        /* Then make sure that the object inherits from the Entity class. */
        FIND FIRST gsc_object_type WHERE
                   gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj
                   NO-LOCK NO-ERROR.
        IF NOT DYNAMIC-FUNCTION("ClassIsA":U, INPUT gsc_object_type.object_type_code, INPUT "Entity":U) THEN
        DO:
            assign cError = {aferrortxt.i 'RY' '13' '?' '?' gsc_object_type.object_type_code '"Entity"' "'Object name: ' + ENTRY(iEntityLoop, pcEntityName)"}.
            leave ENTITY-LOOP.
        END.    /* object not in Entity class */
        
        /* Now we can build the temp-table. */
        assign iNumFields = 0.
        CREATE TEMP-TABLE hEntityTable.
        
        FOR EACH ryc_object_instance WHERE
                 ryc_object_instance.container_smartobject_obj = ryc_smartObject.smartobject_obj
                 NO-LOCK,
           FIRST rycso WHERE
                 rycso.smartobject_obj = ryc_object_instance.smartobject_obj
                 NO-LOCK
                 by ryc_object_instance.object_sequence:
            
            ASSIGN cPropertyNames = "":U
                   cDataType      = ?
                   cFormat        = ?
                   cInitial       = ?
                   cLabel         = ?
                   cColumnLabel   = ?.
            
            /* DATA-TYPE */
            FIND FIRST ryc_attribute_value WHERE
                       ryc_attribute_value.object_type_obj     = rycso.object_type_obj AND
                       ryc_attribute_value.smartobject_obj     = rycso.smartobject_obj AND
                       ryc_attribute_value.object_instance_obj = 0                     AND
                       ryc_attribute_value.render_type_obj     = 0                     AND
                       ryc_attribute_value.attribute_label     = "DATA-TYPE":U
                       NO-LOCK NO-ERROR.
            IF AVAILABLE ryc_attribute_value THEN
                ASSIGN cDataType = ryc_attribute_value.character_value.
            else
                assign cPropertyNames = cPropertyNames + ",Data-Type":U.
            
            /* FORMAT */
            FIND FIRST ryc_attribute_value WHERE
                       ryc_attribute_value.object_type_obj     = rycso.object_type_obj AND
                       ryc_attribute_value.smartobject_obj     = rycso.smartobject_obj AND
                       ryc_attribute_value.object_instance_obj = 0                     AND
                       ryc_attribute_value.render_type_obj     = 0                     AND
                       ryc_attribute_value.attribute_label     = "Format":U
                       NO-LOCK NO-ERROR.            
            /* If no format is found, we can default to the Class default. */                       
            IF AVAILABLE ryc_attribute_value THEN
                ASSIGN cFormat = ryc_attribute_value.character_value.
            else
                assign cPropertyNames = cPropertyNames + ",Format":U.
            
            /* DefaultValue */
            FIND FIRST ryc_attribute_value WHERE
                       ryc_attribute_value.object_type_obj     = rycso.object_type_obj AND
                       ryc_attribute_value.smartobject_obj     = rycso.smartobject_obj AND
                       ryc_attribute_value.object_instance_obj = 0                     AND
                       ryc_attribute_value.render_type_obj     = 0                     AND
                       ryc_attribute_value.attribute_label     = "DefaultValue":U
                       NO-LOCK NO-ERROR.
            IF AVAILABLE ryc_attribute_value THEN
                ASSIGN cInitial = ryc_attribute_value.character_value.
            else
                assign cPropertyNames = cPropertyNames + ",DefaultValue":U.
            
            /* LABEL */
            FIND FIRST ryc_attribute_value WHERE
                       ryc_attribute_value.object_type_obj     = rycso.object_type_obj AND
                       ryc_attribute_value.smartobject_obj     = rycso.smartobject_obj AND
                       ryc_attribute_value.object_instance_obj = 0                     AND
                       ryc_attribute_value.render_type_obj     = 0                     AND
                       ryc_attribute_value.attribute_label     = "LABEL":U
                       NO-LOCK NO-ERROR.
            IF AVAILABLE ryc_attribute_value THEN
                ASSIGN cLabel = ryc_attribute_value.character_value.
            else
                assign cPropertyNames = cPropertyNames + ",Label":U.
                    
            /* ColumnLabel */
            FIND FIRST ryc_attribute_value WHERE
                       ryc_attribute_value.object_type_obj     = rycso.object_type_obj AND
                       ryc_attribute_value.smartobject_obj     = rycso.smartobject_obj AND
                       ryc_attribute_value.object_instance_obj = 0                     AND
                       ryc_attribute_value.render_type_obj     = 0                     AND
                       ryc_attribute_value.attribute_label     = "ColumnLabel":U
                       NO-LOCK NO-ERROR.
            IF AVAILABLE ryc_attribute_value THEN
                ASSIGN cColumnLabel = ryc_attribute_value.character_value.
            else
                assign cPropertyNames = cPropertyNames + ",ColumnLabel":U.
                
            assign cPropertyNames = left-trim(cPropertyNames, ",":U).
            
            /* Check whether we need to get any properties from the object's class.
             */
            if cPropertyNames ne "":U then
            do:
                find gsc_object_type where
                     gsc_object_type.object_type_obj = rycso.object_type_obj
                     no-lock no-error.
                if not available gsc_object_type then
                do:
                    assign cError = {aferrortxt.i 'AF' '5' 'gsc_object_type' 'object_type_obj' '"object type"' "'Unable to retrieve the class for object ' + rycso.object_filename"}.
                    leave ENTITY-LOOP.
                end.    /* instance has no class */
                
                /* Get the class properties to provide default values.
                 */
                run getClassProperties in target-procedure ( input        gsc_object_type.object_type_code,
                                                             input-output cPropertyNames,
                                                                   output cPropertyValues             ) no-error.                                                                   
                IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
                do:
                    assign cError = (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
                    leave ENTITY-LOOP.
                end.    /* error finding class. */
             
                assign iAttributeEntry = LOOKUP("Data-Type":U, cPropertyNames).
                if iAttributeEntry gt 0 then
                    assign cDataType = ENTRY(iAttributeEntry, cPropertyValues, {&Value-Delimiter}) no-error.
                                    
                assign iAttributeEntry = LOOKUP("Format":U, cPropertyNames).
                if iAttributeEntry gt 0 then
                    assign cFormat = ENTRY(iAttributeEntry, cPropertyValues, {&Value-Delimiter}) no-error.
                
                assign iAttributeEntry = LOOKUP("DefaultValue":U, cPropertyNames).                
                if iAttributeEntry gt 0 then
                    assign cInitial = ENTRY(iAttributeEntry, cPropertyValues, {&Value-Delimiter}) no-error.
             
                    assign iAttributeEntry = LOOKUP("Label":U, cPropertyNames).
                if iAttributeEntry gt 0 then
                    assign cLabel = ENTRY(iAttributeEntry, cPropertyValues, {&Value-Delimiter}) no-error.
             
                    assign iAttributeEntry = LOOKUP("ColumnLabel":U, cPropertyNames).
                if iAttributeEntry gt 0 then
                    assign cColumnLabel = ENTRY(iAttributeEntry, cPropertyValues, {&Value-Delimiter}) no-error.                                     
            end.    /* get values from class. */
            
            /* There always has to be a data type.
             */
            IF cDataType EQ ? THEN
            DO:
                assign cError = {aferrortxt.i 'AF' '40' '?' '?' "'Unable to determine the DATA-TYPE for ' + ryc_object_instance.instance_name + ' on ' + ryc_smartobject.object_filename"}.
                leave ENTITY-LOOP.
            end.    /* no data type */

            IF pcLanguageCode <> "NONE":U THEN
            DO:
                IF VALID-HANDLE(gshTranslationManager) THEN
                DO:
                    RUN translateSingleObject IN gshTranslationManager 
                          ( gsc_language.language_obj, 
                           ryc_smartobject.object_filename,
                           ryc_object_instance.instance_name,
                           "DATAFIELD",
                           2, /* LABEL and COLUMN LABEL */
                           OUTPUT cTranslatedLabels, OUTPUT cTooltips).

                    IF NUM-ENTRIES(cTranslatedLabels, CHR(3)) = 2 THEN
                    DO:
                        cEntry = ENTRY(1, cTranslatedLabels, CHR(3)).
                        IF cEntry > "":U THEN
                            cLabel = cEntry.
                        cEntry = ENTRY(2, cTranslatedLabels, CHR(3)).
                        IF cEntry > "":U THEN
                            cColumnLabel = cEntry.
                    END.
                END.
            END.

            /* Add the field.
               The label, column label and format cannot be the string value of the
               unknown value. If the value is stored as "?" then the value
               used when building the temp-table needs to be ?, so that the
               4GL default inheritance works properly.
             */
            lOk = hEntityTable:ADD-NEW-FIELD( ryc_object_instance.instance_name,
                                        cDataType, 
                                        0,            /* Extents */
                                        (if cFormat eq "?" then ? else cFormat),
                                        cInitial,
                                        (if cLabel eq "?" then ? else cLabel),
                                        (if cColumnLabel eq "?" then ? else cColumnLabel) ) NO-ERROR.                                        
             IF NOT lOk THEN
             DO:
                /*Error 22 is checked for the fix of OE00100384. Show a specific message for a known error helps the user to
                  identify the problem.*/
                IF ERROR-STATUS:GET-NUMBER(1) = 22 THEN
                    ASSIGN cError = {aferrortxt.i 'AF' '40' '?' '?' "'Invalid FORMAT ' + QUOTER(cFormat) + ' for DATA-TYPE ' + QUOTER(cDataType)"}.
                ELSE
                    ASSIGN cError = {aferrortxt.i 'AF' '40' '?' '?' "'Cannot update record for ' + QUOTER(ryc_object_instance.instance_name) + ' on ' + QUOTER(ryc_smartobject.object_filename)"}.
                LEAVE ENTITY-LOOP.
             END.
            /* Count the number of fields in the temp-table,
               primarily to determine whether ther are actually any.
             */
            ASSIGN iNumFields = iNumFields + 1.                                        
        END.    /* each object instance. */

        /* If there are no fields associated with the entity, then 
           a temp-table cannot be created. Return an error.
         */
        if iNumFields eq 0 then
        do:
            assign cError = {aferrortxt.i 'AF' '40' '?' '?' "'no fields could be found for ' + ryc_smartobject.object_filename"}.
            leave ENTITY-LOOP.
        end.    /* no fields */
        
        /* Prepare the temp-table */
        hEntityTable:TEMP-TABLE-PREPARE(ryc_smartobject.object_filename).
        
        /* Create the ttEntity record */
        CREATE ttEntity.
        ASSIGN ttEntity.EntityTableName    = hEntityTable:NAME + pcLanguageCode
               ttEntity.EntityName         = hEntityTable:NAME
               ttEntity.EntityBufferHandle = hEntityTable:DEFAULT-BUFFER-HANDLE
               ttEntity.LanguageCode       = pcLanguageCode.
    END.    /* ENTITY-LOOP: */
    
    /* Reset the session:*-FORMAT before doing anything.
     */
    ASSIGN SESSION:DATE-FORMAT = cDateFormat.
    session:set-numeric-format(cNumericSeparator, cDecimalPoint).
    
    if cError ne "":U then
    do:

        DELETE OBJECT hEntityTable NO-ERROR.
        RETURN ERROR cError.
    end.    /* there was an error */
    
    ASSIGN hEntityTable = ?.
    &ENDIF
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* buildEntityCache */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cacheRepositoryObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cacheRepositoryObject Procedure 
PROCEDURE cacheRepositoryObject :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Retrieves an object from the Repository and caches it on the client.
  Parameters:  pcObjectName   - Mandatory. A string value of an InstanceId is supported.                 
               pcInstanceName - If blank, all instances (whole container) is retrieved.
               pcRunAttribute - Blanks allowed. Nulls default to current setting.
               pcResultCode   - Nulls/blanks allowed; default to current system setting.
  Notes:       * Replacement for cacheObjectOnClient().
               * Requests for pages take preference over requests for instances,
                 so if both the pcPageList and the pcInstanceName parameters are
                 specified, then only the page list will be used.
               * To specify pages, the instance name needs to begin with the word
                 "PAGE:", followed by a csv list of pages to retrieve. '*' allowed;
                 indicates all pages.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcObjectName             AS CHARACTER                NO-UNDO.
    DEFINE INPUT PARAMETER pcInstanceName           AS CHARACTER                NO-UNDO.
    DEFINE INPUT PARAMETER pcRunAttribute           AS CHARACTER                NO-UNDO.
    DEFINE INPUT PARAMETER pcResultCode             AS CHARACTER                NO-UNDO.
    
    DEFINE VARIABLE dUserObj                    AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE dLanguageObj                AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE dRenderTypeObj              AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE dInstanceId                 AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE cProperties                 AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cPageList                   AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cDataToRetrieve             AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cEntitiesReferenced         AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cClassesReferenced          AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cToolbarsReferenced         AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE hManagerHandle              AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE iPageLoop                   AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE iInstanceLoop               AS INTEGER                      NO-UNDO.    
    DEFINE VARIABLE cObjectToCacheMenusFor      AS CHARACTER                    NO-UNDO.
    DEFINE variable lGetInitialPages            as logical                      no-undo.

    IF pcObjectName EQ "":U OR pcObjectName EQ ? THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"object to cache"' "'Cache request for ' + pcObjectName"}.
        
    /* Get default values for the User, Language, Run Attribute and Result Codes */
    ASSIGN cProperties = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                          INPUT "currentUserObj,currentLanguageObj":U,
                                          INPUT YES     /* Current session? */ ).
    ASSIGN dUserObj     = DECIMAL(ENTRY(1, cProperties, CHR(3))) NO-ERROR.
    ASSIGN dLanguageObj = DECIMAL(ENTRY(2, cProperties, CHR(3))) NO-ERROR.

    /* Try to find a default value for the run attribute in run time mode */
    IF pcRunAttribute EQ ? THEN
        ASSIGN pcRunAttribute = {fnarg getSessionParam 'RunAttribute'}.
    IF pcRunAttribute EQ ? THEN
        ASSIGN pcRunAttribute = "":U.
    
    /* Get a default value for the result code */
    IF pcResultCode EQ ? OR pcResultCode EQ "":U THEN
    DO:
        ASSIGN hManagerHandle = {fnarg getManagerHandle 'CustomizationManager'}.

        IF VALID-HANDLE(hManagerHandle) THEN
            ASSIGN pcResultCode   = {fn getSessionResultCodes hManagerHandle}.
    END.    /* no result code passed in. */
    
    IF pcResultCode EQ ? OR pcResultCode EQ "":U THEN
        ASSIGN pcResultCode = "{&DEFAULT-RESULT-CODE}":U.
    
    /* Just in case the default result code hasn't been appended to the list of 
       retrieved result codes, the resolveResultCodes API will handle this. */
    RUN resolveResultCodes IN TARGET-PROCEDURE ( INPUT NO,                      /* DesignMode? */
                                                 INPUT-OUTPUT pcResultCode ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
        RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    
    /* Make sure that we have a 'good' value for the instance name parameter. */
    IF pcInstanceName EQ ? THEN
        ASSIGN pcInstanceName = "":U.
    
    /* Default getting of initial pages to no. This value will only be 
       set true in cases where no pages or instances have been passed into
       this procedure.
     */
    lGetInitialPages = no.
    
    /* Pages take preference over instances.
     * If any type of page list is input, we use that, and ignore the
     * request for an instance completely.
     */     
    IF pcInstanceName BEGINS "PAGE:":U THEN
    DO:
        ASSIGN cPageList      = ENTRY(2, pcInstanceName, ":":U)
               pcInstanceName = "":U.
        /* We should always have a 'good' value for the page list.
         */
        IF cPageList EQ ? OR cPageList EQ "":U THEN
            ASSIGN cPageList = "*":U.
    END.    /* pages. */
    ELSE
    DO:
        /* If no instances (or pages: if we get here then no pages) are specified, then look for all instances. */
        IF pcInstanceName EQ "":U THEN
            ASSIGN cPageList = "*":U
                   lGetInitialPages = yes.
        /* If there are instances to retrieve, then do not
         * specify a page - we don't care about pages when there
         * are instances.
         */
        ELSE
            ASSIGN cPageList = "":U.
    END.    /* Instance either blank or has a value that isn't for pages. */
    
    /* Check whether the container object is in the cache.  If it is, then we can return without 
       doing anything further. We can search for an object based on an InstanceId, which assists
       when retrieving containers within containers.
       
       The result code, language, user, render type are implicit in the cached object.       
     */
    FIND cacheObject WHERE
         cacheObject.InstanceId = DECIMAL(pcObjectName)
         NO-ERROR.
    
    IF NOT AVAILABLE cacheObject THEN
        FIND cacheObject WHERE
             cacheObject.ObjectName          = pcObjectName AND
             cacheObject.ContainerInstanceId = 0
             NO-ERROR.
    
    /*
     if i have the container, i am assuming that i have all cachePage records, thus know all
     instances. every container object has a page0 record (incl. viewers). this means that 
     if i have the container cached and i request a particular page i can build a list of instances
     rather than ask for a specific page. i want to do this because i might have some individual 
     instances cached on the client, and do not want to duplicate them in the cache.
     
     if i don't have the container, then i must not ask for individual instances, rather
     for the whole page. if I have already cached individual instances, then the container/page0 stuff 
     will already exist on the client. it is not possible to have an instance cached without having
     the container meta-stuff.
     
     so the first time i request anything from a container, i need to ensure that i get the pages. 
     this will happen though because of the fact that dinstanceId is passed in to the doObjectRetrieval() 
     call.
    */
    IF AVAILABLE cacheObject THEN
    DO:
        /* Set the value of pcObjectName to the actual object
           name in the cache since we may have requested a record
           using an instance id.
         */
        ASSIGN dInstanceId = cacheObject.InstanceId
               pcObjectName = cacheObject.ObjectName.
        
        /* Build a list of instance to retrieve, based on the page information.
         * There is no point in retrieving stuff that we already
         * have, so we don't ask for all instances, only those that
         * have not yet been cached.
         */
        IF cPageList EQ "*":U THEN
        FOR EACH cachePage WHERE cachePage.InstanceId = dInstanceId:
            DO iInstanceLoop = 1 TO NUM-ENTRIES(cachePage.TOC):
                FIND cacheObject WHERE
                     cacheObject.ContainerInstanceId = dInstanceId   AND
                     cacheObject.ObjectName          = ENTRY(iInstanceLoop, cachePage.TOC)
                     NO-ERROR.
                /* If this instance is not yet cached, then add it to the list of instances to retrieve. */
                IF NOT AVAILABLE cacheObject AND NOT CAN-DO(cDataToRetrieve, ENTRY(iInstanceLoop, cachePage.TOC)) THEN
                    ASSIGN cDataToRetrieve = cDataToRetrieve + ",":U + ENTRY(iInstanceLoop, cachePage.TOC).
            END.    /* an instance has been requested. */
        END.    /* all pages requested */
        ELSE
        /* If instances are requested, check whether we have them. If
         * not, then we need to retrieve them. At this stage of proceedings
         * the value of the pcInstanceName will only have a value if instances
         * were actually requested.
         */
        IF pcInstanceName NE "":U THEN
        DO iInstanceLoop = 1 TO NUM-ENTRIES(pcInstanceName):
            FIND cacheObject WHERE
                 cacheObject.ContainerInstanceId = dInstanceId   AND
                 cacheObject.ObjectName          = ENTRY(iInstanceLoop, pcInstanceName)
                 NO-ERROR.
            /* If this instance is not yet cached, then add it to the list of instances to retrieve. */
            IF NOT AVAILABLE cacheObject AND NOT CAN-DO(cDataToRetrieve, ENTRY(iInstanceLoop, pcInstanceName)) THEN
                    ASSIGN cDataToRetrieve = cDataToRetrieve + ",":U + ENTRY(iInstanceLoop, pcInstanceName).                                
        END.    /* loop through the requested instances.*/
        ELSE
        DO iPageLoop = 1 TO NUM-ENTRIES(cPageList):
            FIND FIRST cachePage WHERE
                       cachePage.InstanceId = dInstanceId   AND
                       cachePage.PageNumber = INTEGER(ENTRY(iPageLoop, cPageList))
                       NO-ERROR.
            IF AVAILABLE cachePage THEN
            DO iInstanceLoop = 1 TO NUM-ENTRIES(cachePage.TOC):
                FIND cacheObject WHERE
                     cacheObject.ContainerInstanceId = dInstanceId   AND
                     cacheObject.ObjectName          = ENTRY(iInstanceLoop, cachePage.TOC)
                     NO-ERROR.
                /* If this instance is not yet cached, then add it to the list of instances to retrieve. */
                IF NOT AVAILABLE cacheObject AND NOT CAN-DO(cDataToRetrieve, ENTRY(iInstanceLoop, cachePage.TOC)) THEN
                    ASSIGN cDataToRetrieve = cDataToRetrieve + ",":U + ENTRY(iInstanceLoop, cachePage.TOC).
            END.    /* an instance has been requested. */
        END.    /* individual pages are specified */
        
        ASSIGN pcInstanceName = LEFT-TRIM(cDataToRetrieve, ",":U).
        
        /* If there are no instances to retrieve, then we should not attempt
         * to retrieve the pages either, since we have looked through all of the pages
         * for individual instances for retrieval.
         */
        IF pcInstanceName EQ "":U THEN
            ASSIGN cPageList = "":U.
    END.    /* the container has been cached. */
    ELSE
    DO:
        /* If neither instances nor pages were requested, then get
           the set of initial pages. This initial page behaviour
           is only valid when the container is not cached.
         */
        if lGetInitialPages then
            cPageList = '[Init]'.
        else                 
        IF pcInstanceName EQ "":U AND cPageList EQ "":U THEN
            ASSIGN cPageList = "*":U.
        
        /* If the container is not yet cached, and this request is for instances, then
           make sure that page zero(the meta-information about the container) is cached.
           If this request if for pages, we must also ensure that page 0 is retrieved.
                   
           If the page list is empty, don't worry about it since an empty page list will
           retrieve the start and initial pages.
         */
        IF cPageList ne '[Init]' and
           NOT CAN-DO(cPageList, STRING(0)) THEN
            ASSIGN cPageList = "0,":U + cPageList
                   cPageList = TRIM(cPageList, ",":U).
    END.    /* object not yet cached */
    
    /* If there are individual instances, then retrieve them as such rather than
       retrieving stuff on a per-page basis.
     */
    IF pcInstanceName NE "":U THEN
        ASSIGN cPageList = "":U.
    
    /* If there are no pages and no instances to retrieve, it must
     * mean that we have everything we need. We can thus leave happy in
     * the knowledge of a good job done.
     */
    IF pcInstanceName EQ "":U AND cPageList EQ "":U THEN
        RETURN.
    
    /* Get the requested object from the Repository.
     */
    RUN doObjectRetrieval ( INPUT  pcObjectName,
                            INPUT  pcResultCode,
                            INPUT  dUserObj,
                            INPUT  dLanguageObj,
                            INPUT  pcRunAttribute,
                            INPUT  dRenderTypeObj,
                            INPUT  cPageList,
                            INPUT  dInstanceId,
                            INPUT  pcInstanceName,
                            OUTPUT cClassesReferenced,
                            OUTPUT cEntitiesReferenced,
                            OUTPUT cToolbarsReferenced) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
        RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
        
    /* Ensure that any classes and entities referenced by the objects 
       retrieved are cached.
     */         
    RUN createClassCache (INPUT cClassesReferenced) NO-ERROR.    
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
        RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    IF cEntitiesReferenced NE "":U THEN
    DO:
        RUN createEntityCache (INPUT cEntitiesReferenced, "":U) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
            RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    END.    /* cache any entities */
    
    /* Ensure any toolbars referenced are cached.  As we can function without this pre-caching having *
     * been done, we ignore any errors. */
    IF cToolbarsReferenced NE "":U THEN
    DO:
        ASSIGN cObjectToCacheMenusFor = IF pcRunAttribute NE "":U AND pcRunAttribute NE ? THEN 
                                             pcObjectName + ";" + pcRunAttribute
                                        ELSE pcObjectName.

        RUN createToolbarCache IN TARGET-PROCEDURE (INPUT cToolbarsReferenced,
                                                    INPUT cObjectToCacheMenusFor,
                                                    INPUT YES) NO-ERROR.
    END.    /* there are toolbars on this container. */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* cacheRepositoryObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calculateObjectPaths) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateObjectPaths Procedure 
PROCEDURE calculateObjectPaths :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     The purpose of this procedure is to provide a standard mechanism for 
               finding the paths associated with an object. 
               
               This procedure should be used everywhere where relative paths have 
               to be calculated for new objects, existing objects, associated files
               for objects (.e.g. include files for DynSDO's).
  Parameters:  <none>
               INPUT:
               pcObjectname   -  The name of the object to be parsed. 
                                 This can be left blank if the smartobject_obj of the 
                                 object is used instead, or the API is being used for 
                                 general path enquiries on a product module instead.
                                 
                                 The object name will be used to try and determine a valid 
                                 ryc_smartobject.smartobject_obj value to use for further 
                                 processing. If this is possible, it is assumed that a new object 
                                 or file is being created / parsed - and the name will be 
                                 as is for further processing. 
                                  
               pcObjectObj    -  The smartobject_obj of the object being parsed. 
                                 This can either be passed in as an alternative 
                                 to the object name. 
                                 If both the object name and the smartobject_obj are 
                                 passed in, then the smartobject_obj is used. 
                                 
               pcObjectType   -  The gsc-object_type.object_type_code for the object. 
                                 This is not really used at the moment, but may be 
                                 used in later versions of the API. 
                                 
              pcProductModule -  The name of the product module for the object being parsed. 
                                 This must be a valid gsc_product_module.product_module_code 
                                  value. 
                                 If a valid object name or pcObjectObj is passed in, the 
                                 product module that the object is registered under will 
                                 take precedence over the product module being passed in. 
                                
                                 If pcObjectName and pcObjectObj are both empty, and a 
                                 product module is passed in, the relative path information
                                 for the product module will still be returned from this procedure. 
                                 
             pcObjectparameter - This field is normally left blank for parsing objects 
                                 directly. If the field contains a value, then this will be used 
                                 to evaluate associated objects for the object being parsed - for 
                                 example include files for SDOs. 
                                 
                                 Current valid values are:
                                 include - calculates the file name for an include file associated 
                                 with the object found from pcObjectname or pcObjectObj
                                 clientProxy - calculates the _cl client proxy file name for the 
                                 object found from pcObjectname or pcObjectObj. 
             pcNameSpace       - This is currently reserved for future use. 
             
             OUTPUT:
             pcRootDirectory   - The calculated Root Directory for the current session. 
                                 This is evaluated using the getSessionRootDirectory API
                                 
             pcRelativeDirectory The calculated relative directory based on the product module 
                                 found from the psProductModule paramater or the product module 
                                 for an existing object. 
                                                     
             pcSCMRelativeDirectory The calculated SCM relative directory based on the product module 
                                 found from the psProductModule paramater or the product module 
                                 for an existing object. If the SCM tool is being used and SCM checks are in place, 
                                 the relative path information is retrieved from the currently used SCM tool. 
                                 
             pcFullPathName      This is the calculated full pathname which can be used for creating or accessig 
                                 physical files. The full path doe snot include the object name. It includes the 
                                 root directory + the relative path from the SCM tool if this is valid or the 
                                 relative directory from the gsc_product_module table. 
                                 
             pcOutputObjectName  This is the validated object name for valid pcObjectname or pcObjectObj values. 
                                 If the object does not exist, this parameter will always contain the truncated 
                                 name of the object as it was passed in with the pcObjectname parameter (i.e. name 
                                 of the object without any relative path information). 
                                 
                                 If the object does exist, this parameter will return the repository name of the 
                                 object i.e. ryc_smartobject.object_filename. 
             
             pcFileName          This contain the calculated physical file name based on the used input paramaters. 
                                 This can be used to create or access the physical file name of the object being parsed - 
                                 or the associated file for the object - such as an include file for an SDO. 
                      
             pcError             Any errors encountered during processing, such as invalid pcObjectobj values will 
                                 be returned with this parameter. 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectName            AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectObj             AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectType            AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcProductModule         AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectparameter       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcNameSpace             AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRootDirectory         AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRelativeDirectory     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSCMRelativeDirectory  AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFullPathName          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcOutputObjectName      AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFileName              AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcError                 AS CHARACTER  NO-UNDO.
  
  &IF DEFINED(Server-Side) EQ 0 &THEN
    RUN ry/app/ryrepcopsp.p ON gshAstraAppServer ( INPUT  pcObjectName,
                                                   INPUT  pcObjectObj,
                                                   INPUT  pcObjectType,
                                                   INPUT  pcProductModule,
                                                   INPUT  pcObjectparameter,
                                                   INPUT  pcNameSpace,
                                                   OUTPUT pcRootDirectory,
                                                   OUTPUT pcRelativeDirectory,
                                                   OUTPUT pcSCMRelativeDirectory,
                                                   OUTPUT pcFullPathName,
                                                   OUTPUT pcOutputObjectName,
                                                   OUTPUT pcFileName,
                                                   OUTPUT pcError    ) NO-ERROR.
    IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
  &ELSE    
  DEFINE VARIABLE hScmTool                        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSCMWorkspace                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ghRepositoryDesignManager       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lObjectExists                   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj                 AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cRootFile                       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRootFileExt                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectExt                      AS CHARACTER  NO-UNDO.
  
  DEFINE BUFFER b_ryc_smartobject                 FOR ryc_smartobject. 
  
  IF ghRepositoryDesignManager = ? THEN
    ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U IN TARGET-PROCEDURE, INPUT "RepositoryDesignManager":U).
  
  /* First check if the SCM tool is running - if it is, we need to take this 
     into account when calculating directories etc.  */
  ASSIGN hSCMTool = DYNAMIC-FUNCTION('getProcedureHandle':U IN THIS-PROCEDURE, "PRIVATE-DATA:SCMTool":U).
 
  /* Get the currently selected workspace - if any. This is relevant for determining the root directory */
  IF VALID-HANDLE(hSCMTool) THEN
    cSCMWorkspace = DYNAMIC-FUNCTION('getSessionParam':U IN THIS-PROCEDURE, "_scm_current_workspace":U).  
  
  /* If an object name has been passed in, we need to validate this. */
  IF pcObjectName NE "":U OR pcObjectObj NE 0 THEN
  DO:
    /* First of all make usre that we have only "/" in the file name */
    ASSIGN pcObjectname = REPLACE(pcObjectname, "~\":U, "~/":U). 
    
    /* Truncate the object name if it has been passed in with a relative path */
    IF NUM-ENTRIES(pcObjectName, "/":U) > 0 THEN
    ASSIGN pcObjectname = SUBSTRING(pcObjectName, R-INDEX(pcObjectname, "/":U) + 1). 
    
    /* If we do not have an obj value of the object, try and find one with the name */
    IF pcObjectObj = 0 AND 
       pcObjectname NE "":U THEN
    DO:
      /* Check if the object exists in the repository */
        dSmartObjectObj = DYNAMIC-FUNCTION('getSmartObjectObj':U IN ghRepositoryDesignManager, INPUT pcObjectName, INPUT 0) NO-ERROR. 
    END.
    ELSE
    IF pcObjectObj <> 0 THEN
       ASSIGN dSmartObjectObj = pcObjectObj. 
     
    IF dSmartObjectObj <> 0 THEN
    DO:
      FIND FIRST b_ryc_smartobject WHERE b_ryc_smartobject.smartobject_obj = dSmartObjectObj NO-LOCK NO-ERROR. 
      IF AVAILABLE b_ryc_smartobject THEN
      DO:
        ASSIGN 
          lObjectExists = TRUE.
        /* Make sure that the pcObjectname variable also includes the extension, if there is one. 
           This may not have been passed in for some reason*/
          
          ASSIGN pcObjectName = b_ryc_smartobject.OBJECT_filename + 
                               (IF b_ryc_smartobject.OBJECT_extension <> "":U THEN ".":U + b_ryc_smartobject.object_extension 
                                   ELSE "":U).
      END. /* IF AVAILABLE ryc_smartobject THEN */      
      ELSE
      DO:
        ASSIGN pcError = "Could not find ryc_smartobject with smartobject_obj = " + STRING(dSmartObjectObj).
        RETURN.
      END.
    END. /* IF dSmartObjectObj <> 0 THEN */
    
    /* Strip the name apart, and use the pieces to find the object. */
    IF pcObjectname <> "":U THEN
    RUN extractRootFile IN gshRepositoryManager (INPUT pcObjectName, 
                                                 OUTPUT cRootFile, 
                                                 OUTPUT cRootFileExt) NO-ERROR.
                                                 
      
    IF AVAILABLE b_ryc_smartobject THEN
      ASSIGN pcOutputObjectName   = b_ryc_smartobject.object_filename NO-ERROR. 
    ELSE 
    /*   The pcOutput object name must always be passed back - even if this is a */
    /*   new object that has not yet been created in the repository.             */       
      ASSIGN pcOutputObjectName = cRootFile. 
      
    ASSIGN pcFileName = cRootFileExt NO-ERROR. 
      
    /*   Check if we have a pcObjectparameter parameter passed in, which means we are not   */
    /*   really interested in the object itself, but rather in an object that is referenced */
    /*   by the value of pcObjectparameter.                                                 */
    IF pcObjectparameter <> "":U THEN
    DO:
      CASE pcObjectparameter: 
        WHEN "Include":U THEN
        DO:
          /* Calculate the name of the associated include file for the object - if there is one.   */
          /* This is simply done by using the base file name and adding .i to the end of it.       */
          
          /*   This makes the assumption that the include file is always located in the same place */
          /*   as the associated object.                                                           */
          /*                                                                                       */
          /*   It may be more correct to either parse the associated objects code to find the      */
          /*   include file or find a reference to this in the repository.                         */
          
          IF cRootFile <> "":U THEN
          ASSIGN pcFileName = cRootFile + ".i":U.                         
        END.
        WHEN "SuperProcedure":U THEN
        DO:
           RUN getObjectSuperProcedure IN gshRepositoryManager (INPUT pcObjectName, 
                                                                INPUT "", 
                                                                OUTPUT pcFileName).             
        END.        
        WHEN "clientProxy":U THEN
        DO:
           /* Calculate the _cl file name of the object */
          IF cRootFile <> "":U THEN
          ASSIGN pcFileName = cRootFile + "_cl.":U + SUBSTRING(pcObjectName, R-INDEX(pcObjectName, ".":U) + 1). 
        END.       
        OTHERWISE 
        DO:
          ASSIGN pcError = "Object Parameter '" + pcObjectparameter + "' not supported".             
          RETURN.
        END.
        
      END CASE.
    END. /* IF pcObjectparameter <> "":U ... */
  END. /* IF pcObjectName <> "":U THEN*/
  
  /* If the product module has been entered, validate this and work out */
  /* the relative directory for this.                                   */  
  /* NOTE: The product module specified here will override the product */
  /*       module for an existing found object. This is necessary for */
  /*       situations where the product module for an associated file */
  /*       is not intended to be the same as the product module for   */
  /*       the base object.                                           */
  /*       e.g. placing an SDO in ry-obj and the DLproc in ry-prc.    */
  
  IF pcProductModule <> "":U THEN 
    FIND FIRST gsc_product_module WHERE gsc_product_module.product_module_code = pcProductModule NO-LOCK NO-ERROR.   
    
  /*   If the product module has not been passsed in, try and work it out from the object name */
  /*   - if this exists in the repository already                                              */
  ELSE IF lObjectExists AND 
       AVAILABLE b_ryc_smartobject THEN
     FIND FIRST gsc_product_module WHERE gsc_product_module.product_module_obj = b_ryc_smartobject.product_module_obj NO-LOCK NO-ERROR.          
     
  IF AVAILABLE gsc_product_module THEN
  DO:  
    ASSIGN pcRelativeDirectory = gsc_product_module.relative_path. 
    
    IF VALID-HANDLE(hSCMTool) THEN
    DO:
      RUN scmGetModuleDir IN hSCMTool (INPUT gsc_product_module.product_module_code, 
                                       INPUT "":U, 
                                       OUTPUT pcSCMRelativeDirectory) 
                                       NO-ERROR.                      
      IF ERROR-STATUS:ERROR OR 
         RETURN-VALUE NE "":U THEN
      DO:
        ASSIGN pcError = RETURN-VALUE. 
        RETURN.
      END.
    END.
    ELSE 
      ASSIGN pcSCMRelativeDirectory = "":U. 
      
    ASSIGN 
      pcRelativeDirectory = RIGHT-TRIM(REPLACE(pcRelativeDirectory,"~\":U,"~/":U), "~/":U)
      pcSCMRelativeDirectory = RIGHT-TRIM(REPLACE(pcSCMRelativeDirectory,"~\":U,"~/":U), "~/":U).    
      
    /* Make sure the SCM Relative directory actually exists and is a writeable directory */
    FILE-INFO:FILE-NAME = pcSCMRelativeDirectory. 
    IF NOT FILE-INFO:FILE-TYPE MATCHES "D*W*":U THEN
      ASSIGN pcError = "Invalid SCM Relative Directory " + pcSCMRelativeDirectory. 

    /* Make sure the Relative directory actually exists and is a writeable directory */
    FILE-INFO:FILE-NAME = pcRelativeDirectory. 
    IF NOT FILE-INFO:FILE-TYPE MATCHES "D*W*":U THEN
      ASSIGN pcError = "Invalid Relative Directory " + pcRelativeDirectory.       
  END.
  ELSE 
  DO:
    ASSIGN pcError = "Invalid product module " + pcProductModule + ".":U.
    RETURN.
  END.
  
  /* Get the root directory.*/
  ASSIGN pcRootDirectory = DYNAMIC-FUNCTION('getSessionRootDirectory':U IN THIS-PROCEDURE)
         pcRootDirectory = RIGHT-TRIM(REPLACE(pcRootDirectory,"~\":U,"~/":U), "~/":U). 
         
  /* Make sure the root directory actually exists and is a writeable directory */
  FILE-INFO:FILE-NAME = pcRootDirectory.
  IF NOT FILE-INFO:FILE-TYPE MATCHES "D*W*":U THEN
    ASSIGN pcError = "Invalid root directory " + pcRootDirectory.
  
  /* Build the full pathname  */
  /* If the SCMRelativeDirectory contains a value, and a woirkspace is selected in the SCM tool, then we 
     can use the SCM value */
  IF pcSCMRelativeDirectory <> "":U AND cSCMWorkspace <> "":U THEN
     ASSIGN pcFullPathName = pcRootDirectory + "/":U +  pcSCMRelativeDirectory.  
  ELSE 
     ASSIGN pcFullPathName = pcRootDirectory + "/":U +  pcRelativeDirectory.  
&ENDIF
     
  ASSIGN ERROR-STATUS:ERROR = FALSE. 
  RETURN.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeObjectType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeObjectType Procedure 
PROCEDURE changeObjectType :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     This procedure will take care of changing all relevant tables 
               when the object type of a SmartObject is changed
  Parameters:  
  Notes:       * This procedure merely acts as a proxy for changeObjectType in
                 the Repository Design Manager. This procedure should not be 
                 called - support here is only for backwards compatibility.
               * Details of this API are to be found in the Repository Design
                 Manager.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdSmartObjectObj     AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdNewObjectTypeObj   AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdOldObjectTypeObj   AS DECIMAL              NO-UNDO.

    &IF DEFINED(Server-Side) EQ 0 &THEN
    {dynlaunch.i
        &PLip  = 'RepositoryManager'
        &IProc = 'changeObjectType'
        
        &mode1 = INPUT &parm1 = pdSmartObjectObj   &datatype1 = DECIMAL
        &mode2 = INPUT &parm2 = pdNewObjectTypeObj &datatype2 = DECIMAL
        &mode3 = INPUT &parm3 = pdOldObjectTypeObj &datatype3 = DECIMAL
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    &ELSE
    DEFINE VARIABLE hRDM                    AS HANDLE                   NO-UNDO.

    ASSIGN hRDM = DYNAMIC-FUNCTION("getManagerHandle":U IN TARGET-PROCEDURE, INPUT "RepositoryDesignManager":U).

    IF NOT VALID-HANDLE(hRDM) THEN
        RETURN ERROR {aferrortxt.i 'AF' '29' '?' '?' '"Repository Design Manager"' '"The handle to the Repository Design Manager is invalid. Class change failed."'}.

    FIND FIRST ryc_smartObject WHERE
               ryc_smartObject.smartObject_obj = pdSmartObjectObj
               NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ryc_smartObject THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"object"'}.

    FIND FIRST gsc_object_type WHERE
               gsc_object_type.object_type_obj = pdNewObjectTypeObj
               NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gsc_object_type THEN
        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"class"'}.

    /* Update the obect type */
    RUN changeObjectType IN hRDM ( INPUT ryc_smartObject.object_filename,
                                   INPUT gsc_object_type.object_type_code,  /* pcObjectTypeCode */
                                   INPUT NO,                                /* plRemoveDefaultAttr */
                                   INPUT YES    ) NO-ERROR.                 /* plRemoveNonOTAttr */
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    &ENDIF
          
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* changeObjectType */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearClientCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearClientCache Procedure 
PROCEDURE clearClientCache :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     To empty client cache temp-tables to ensure the database is accessed
               again to retrieve up-to-date information. This may be called when 
               repository maintennance programs have been run. The procedure prevents
               having to log off and start a new session in order to use the new
               repository data settings.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBuffer                 AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hNextBuffer             AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cTableNames             AS CHARACTER                NO-UNDO.
    
    /* Clear out menu stuff
     *-----------------------------------------------------------------------*/
    /* List the dynamically created tables to be deleted from the session buffer pool. */
    ASSIGN cTableNames = "ttBand,ttCategory,ttAction,ttBandAction,ttObjectBand,ttToolbarBand":U.

    EMPTY TEMP-TABLE ttBand.
    EMPTY TEMP-TABLE ttCategory.
    EMPTY TEMP-TABLE ttAction.
    EMPTY TEMP-TABLE ttBandAction.
    EMPTY TEMP-TABLE ttObjectBand.
    EMPTY TEMP-TABLE ttToolbarBand.

    /* Make sure that all TTs referenced by the cache_ObjectBuffer temp-tables are deleted. */
    ASSIGN hNextBuffer = SESSION:FIRST-BUFFER.

    DO WHILE VALID-HANDLE(hNextBuffer):
        ASSIGN hBuffer     = hNextBuffer
               hNextBuffer = hNextBuffer:NEXT-SIBLING
               .
        IF CAN-DO(cTableNames, hBuffer:NAME) THEN
        DO:
            IF CAN-QUERY(hBuffer, "TABLE-HANDLE":U) AND VALID-HANDLE(hBuffer:TABLE-HANDLE) THEN
                DELETE OBJECT hBuffer:TABLE-HANDLE NO-ERROR.
        END.    /* buffer to be deleted */
    END.    /* valid buffer */
    ASSIGN hNextBuffer = ?
           hBuffer     = ?.           
        
    /** Empty the Object Cache.
     *  ----------------------------------------------------------------------- **/
     EMPTY TEMP-TABLE cacheObject.
     EMPTY TEMP-TABLE cachePage.
     EMPTY TEMP-TABLE cacheLink.
          
    /** Clear out the relevant class attribute tables. There will typically
     *  not be any data in these tables, but we clear them anyway.
     *  ----------------------------------------------------------------------- **/    
    FOR EACH ttClass:
        IF VALID-HANDLE(ttClass.ClassBufferHandle) THEN
            ttClass.classBufferHandle:EMPTY-TEMP-TABLE() NO-ERROR.
        
        IF VALID-HANDLE(ttClass.EventBufferHandle) THEN
            ttClass.EventBufferHandle:EMPTY-TEMP-TABLE() NO-ERROR.
    END.    /* ttClass */
        
    /** Publish an event to tell everyone that the Repository Cache has been
     *  cleared
     *  ----------------------------------------------------------------------- **/
    PUBLISH "RepositoryCacheCleared":U.
    
    /* Make sure the entity table in the general manager has been cleared as well.           *
     * We need to do this because the entity cache is populated from the repository manager. */
    IF VALID-HANDLE(gshGenManager) THEN
        RUN refreshMnemonicsCache IN gshGenManager.
    
    /* Clear the variable used by getMappedFilename() */
    gcSessionResultCodes = ?.
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* clearClientCache */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createClassCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createClassCache Procedure 
PROCEDURE createClassCache :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Caches class attributes and UI events
  Parameters:  pcClassName  - * or a CSV list of class codes (object types)               
  Notes:       * The UI event table is always the first table returned by
                 retrieveClassCache.
------------------------------------------------------------------------------*/    
    DEFINE INPUT PARAMETER pcClassName          AS CHARACTER            NO-UNDO.
    
    DEFINE VARIABLE hClassTable                 AS HANDLE   EXTENT 32   NO-UNDO.
    DEFINE VARIABLE hClassBuffer                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hUiEventBuffer              AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hReturnedEventBuffer        AS HANDLE               NO-UNDO.
    DEFINE VARIABLE iTableLoop                  AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iQueryOrdinal               AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cNewRequest                 AS CHARACTER            NO-UNDO.
    
    /* First let us find the the Class Cache Directory */
    IF (gcClientCacheDir EQ ? OR gcClientCacheDir EQ "":U) THEN
    DO:  
       RUN getClientCacheDir (INPUT "ry-clc":U, OUTPUT gcClientCacheDir) NO-ERROR .
       ASSIGN gcClientCacheDir = RIGHT-TRIM(gcClientCacheDir, "/":U).
    END.    /* no client cache directory */
    
    /* Check if the class definitions can be found locally - cached versions */
    IF gcClientCacheDir NE ? AND gcClientCacheDir NE "":U THEN
      DYNAMIC-FUNCTION("getClassFromClientCache":U IN TARGET-PROCEDURE, pcClassName, gcClientCacheDir) NO-ERROR.
    
    /* If there is more than one class requested, only pass the request across
     * to the AppServer for those classes that aren't cached on the client. This
     * is done to avoid unnecessary extra work and additional data across the wire.
     */
    DO iTableLoop = 1 TO NUM-ENTRIES(pcClassName):
    IF NOT CAN-FIND(ttClass WHERE ttClass.ClassName = ENTRY(iTableLoop, pcClassName)) THEN
        ASSIGN cNewRequest = cNewRequest + ",":U + ENTRY(iTableLoop, pcClassName).
    END.    /* loop through entries */
        
    ASSIGN pcClassName = LEFT-TRIM(cNewRequest, ",":U).
    
    /* If there are no classes to fetch return */
    IF pcClassName EQ "":U THEN
        RETURN.
    
    /* If the ICFDB is connected, then directly get the Classes */
    IF DYNAMIC-FUNCTION("isConnected":U IN TARGET-PROCEDURE, INPUT "ICFDB":U) THEN
    DO:
        /* This populates the ttClass Temp-table. */
        RUN buildClassCache IN TARGET-PROCEDURE ( INPUT pcClassName ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* local DB connected */
    ELSE
    DO:
        RUN ry/app/rygetclassp.p ON gshAstraAppserver ( 
                                INPUT pcClassName,                   OUTPUT TABLE ttClass APPEND,
                                OUTPUT TABLE-HANDLE hClassTable[01], OUTPUT TABLE-HANDLE hClassTable[02],
                                OUTPUT TABLE-HANDLE hClassTable[03], OUTPUT TABLE-HANDLE hClassTable[04],
                                OUTPUT TABLE-HANDLE hClassTable[05], OUTPUT TABLE-HANDLE hClassTable[06],
                                OUTPUT TABLE-HANDLE hClassTable[07], OUTPUT TABLE-HANDLE hClassTable[08],
                                OUTPUT TABLE-HANDLE hClassTable[09], OUTPUT TABLE-HANDLE hClassTable[10],
                                OUTPUT TABLE-HANDLE hClassTable[11], OUTPUT TABLE-HANDLE hClassTable[12],
                                OUTPUT TABLE-HANDLE hClassTable[13], OUTPUT TABLE-HANDLE hClassTable[14],
                                OUTPUT TABLE-HANDLE hClassTable[15], OUTPUT TABLE-HANDLE hClassTable[16],
                                OUTPUT TABLE-HANDLE hClassTable[17], OUTPUT TABLE-HANDLE hClassTable[18],
                                OUTPUT TABLE-HANDLE hClassTable[19], OUTPUT TABLE-HANDLE hClassTable[20],
                                OUTPUT TABLE-HANDLE hClassTable[21], OUTPUT TABLE-HANDLE hClassTable[22],
                                OUTPUT TABLE-HANDLE hClassTable[23], OUTPUT TABLE-HANDLE hClassTable[24],
                                OUTPUT TABLE-HANDLE hClassTable[25], OUTPUT TABLE-HANDLE hClassTable[26],
                                OUTPUT TABLE-HANDLE hClassTable[27], OUTPUT TABLE-HANDLE hClassTable[28],
                                OUTPUT TABLE-HANDLE hClassTable[29], OUTPUT TABLE-HANDLE hClassTable[30],
                                OUTPUT TABLE-HANDLE hClassTable[31], OUTPUT TABLE-HANDLE hClassTable[32] ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
        
        /* Update the handles on the ttClass temp-table.
         */
        DO iTableLoop = 1 TO EXTENT(hClassTable):
            IF NOT VALID-HANDLE(hClassTable[iTableLoop]) THEN
            DO:
                /* Kill it dead, just in case. */
                DELETE OBJECT hClassTable[iTableLoop] NO-ERROR.
                NEXT.
            END.        /* not a valid handle */
            
            /* We always need the buffer handle. */
            ASSIGN hClassBuffer = hClassTable[iTableLoop]:DEFAULT-BUFFER-HANDLE.
            
            /* At this stage, the ttClass contains all of the tables referred to by the returned
               table-handles.
             */
            FIND FIRST ttClass WHERE
                       ttClass.ClassTableName = hClassTable[iTableLoop]:NAME
                       NO-ERROR.
            IF NOT AVAILABLE ttClass THEN
                FIND FIRST ttClass WHERE
                           ttClass.EventTableName = hClassTable[iTableLoop]:NAME
                           NO-ERROR.                                                      
            /* At this stage of proceedings there should always be a ttClass record available.
             * However, if there isn't delete the returned table and move on.
             */
            IF NOT AVAILABLE ttClass THEN
            DO:
                /* Clean up. */
                DELETE OBJECT hClassTable[iTableLoop] NO-ERROR.
                DELETE OBJECT hClassBuffer NO-ERROR.
            END.    /* n/a ttClass */
            ELSE
            DO:                                                            
              /* All the ttClass information has come across from the AppServer. */                   
              IF ttClass.ClassTableName EQ hClassTable[iTableLoop]:NAME THEN
                  ASSIGN ttClass.ClassBufferHandle = hClassBuffer.
              ELSE
                  ASSIGN ttClass.EventBufferHandle = hClassBuffer.
            END.    /* there is a cached class already */
            
            /* Mark the Entity as having been retrieved. */
            ASSIGN ENTRY(LOOKUP(ttClass.ClassName, pcClassName), pcClassName) = "":U.
        END.    /* loop through class attribute tables */
        
        /* First clean up. */
        ASSIGN hClassBuffer = ?
               hClassTable  = ?
               NO-ERROR.
        
        /* Check whether we got 'em all. However, we don't know this for a fact when
         * the request was for '*' so we ignore that.
         * This will ensure that the entire original request is serviced, even though
         * it may take multiple AppServer calls to do so.
         */
        ASSIGN pcClassName = "":U               WHEN pcClassName EQ "*":U.
        
        IF pcClassName NE "":U THEN
        DO WHILE INDEX(pcClassName, ",,":U) GT 0:
            ASSIGN pcClassName = REPLACE(pcClassName, ",,":U, ",":U).
        END.    /* get rid of all double commas */
        
        ASSIGN pcClassName = TRIM(pcClassName, ",":U).
        
        IF pcClassName NE "":U THEN
        DO:
            RUN createClassCache ( INPUT pcClassName ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* get left-overs. */
    END.    /* go across the AppServer */
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.   /* createClassCache */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createEntityCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createEntityCache Procedure 
PROCEDURE createEntityCache :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Manages the creation of cache records for the requested entities.
  Parameters:  pcEntityName - a CSV list of entity names.
               pcLanguageCode - language code for entity translation.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcEntityName        AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcLanguageCode      AS CHARACTER            NO-UNDO.
    
    DEFINE VARIABLE hEntityTable           AS HANDLE   EXTENT 32       NO-UNDO.
    DEFINE VARIABLE iTableLoop             AS INTEGER                  NO-UNDO.    
    define variable iNumberEntities        as integer                  no-undo.
    DEFINE VARIABLE cNewRequest            AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cEntityCacheDirectory  AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cEntity                AS CHARACTER                NO-UNDO.
    define variable cFirst32Entities       as character                no-undo.
    
    /* If there is more than one class requested, only pass the request across
       to the AppServer for those classes that aren't cached on the client. This
       is done to avoid unnecessary extra work and additional data across the wire.
     */

    IF pcLanguageCode = ? OR pcLanguageCode = "":U THEN
    DO:
        pcLanguageCode = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, "CurrentLanguageCode":U, YES).
        IF pcLanguageCode = ? OR pcLanguageCode = "":U THEN pcLanguageCode = "NONE":U.
    END.
    /* First let  us find the the EntityCacheDirectory */
    IF (gcClientCacheDir EQ ? OR gcClientCacheDir EQ "":U) THEN
    DO:  
       RUN getClientCacheDir (INPUT "ry-clc":U, OUTPUT gcClientCacheDir) NO-ERROR .
       ASSIGN gcClientCacheDir = RIGHT-TRIM(gcClientCacheDir, "/":U).
    END.    /* no client cache directory */
    
    /* Now check if the entity is on the disk */
    IF gcClientCacheDir NE ? AND gcClientCacheDir NE "":U THEN
        DYNAMIC-FUNCTION("getEntityFromClientCache":U IN TARGET-PROCEDURE, 
                         pcEntityName, 
                         gcClientCacheDir, 
                         pcLanguageCode) NO-ERROR.
    
    iNumberEntities = 0.
    DO iTableLoop = 1 TO NUM-ENTRIES(pcEntityName):
        cEntity = ENTRY(iTableLoop, pcEntityName).
        IF NOT CAN-FIND(ttEntity WHERE ttEntity.EntityName = cEntity 
                                   AND ttEntity.LanguageCode = pcLanguageCode
                                   AND LOOKUP(cEntity,cNewRequest) = 0 ) THEN
        do:
            /* Keep the first 32 entities separate. We do this because
               in an AppServer environment, only 32 entities are retrieved
               at a time.
               
               Use a separate variable since some of the entities
               in the pcEntityName list may already be cached. From
               here on, we only care about the number of entities to
               cache.
             */
            iNumberEntities = iNumberEntities + 1.
            
            if iNumberEntities gt 32 then
                cNewRequest = cNewRequest + ',' + entry(iTableLoop, pcEntityName).
            else
                cFirst32Entities = cFirst32Entities + ',' + entry(iTableLoop, pcEntityName).                
        end.    /* entity not yet cached */
    END.    /* loop through entries */
    
    assign pcEntityName = left-trim(cFirst32Entities, ',')
           cNewRequest = left-trim(cNewRequest, ',').
    
    /* If there are no entities to retrieve, then return. */
    IF iNumberEntities eq 0 then
        RETURN.
    
    /* If the ICFDB is connected, then directly get the Classes */
    IF DYNAMIC-FUNCTION("isConnected":U IN TARGET-PROCEDURE, INPUT "ICFDB":U) THEN
    DO:
        /* If there is a DB connected, then get all entities in one call.
           If there are more than 32 entities in this request, then we need
           to add the first 32 and the last n entities together.           
         */
        if iNumberEntities gt 32 then
            pcEntityName = pcEntityName + ',' + cNewRequest.
        
        /* This populates the ttEntity temp-table. */        
        RUN buildEntityCache IN TARGET-PROCEDURE ( INPUT pcEntityName, INPUT pcLanguageCode ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.    /* local DB connected */
    ELSE
    DO:
        RUN ry/app/rygetentityp.p ON gshAstraAppserver ( INPUT pcEntityName, INPUT pcLanguageCode,
                                OUTPUT TABLE-HANDLE hEntityTable[01], OUTPUT TABLE-HANDLE hEntityTable[02],
                                OUTPUT TABLE-HANDLE hEntityTable[03], OUTPUT TABLE-HANDLE hEntityTable[04],
                                OUTPUT TABLE-HANDLE hEntityTable[05], OUTPUT TABLE-HANDLE hEntityTable[06],
                                OUTPUT TABLE-HANDLE hEntityTable[07], OUTPUT TABLE-HANDLE hEntityTable[08],
                                OUTPUT TABLE-HANDLE hEntityTable[09], OUTPUT TABLE-HANDLE hEntityTable[10],
                                OUTPUT TABLE-HANDLE hEntityTable[11], OUTPUT TABLE-HANDLE hEntityTable[12],
                                OUTPUT TABLE-HANDLE hEntityTable[13], OUTPUT TABLE-HANDLE hEntityTable[14],
                                OUTPUT TABLE-HANDLE hEntityTable[15], OUTPUT TABLE-HANDLE hEntityTable[16],
                                OUTPUT TABLE-HANDLE hEntityTable[17], OUTPUT TABLE-HANDLE hEntityTable[18],
                                OUTPUT TABLE-HANDLE hEntityTable[19], OUTPUT TABLE-HANDLE hEntityTable[20],
                                OUTPUT TABLE-HANDLE hEntityTable[21], OUTPUT TABLE-HANDLE hEntityTable[22],
                                OUTPUT TABLE-HANDLE hEntityTable[23], OUTPUT TABLE-HANDLE hEntityTable[24],
                                OUTPUT TABLE-HANDLE hEntityTable[25], OUTPUT TABLE-HANDLE hEntityTable[26],
                                OUTPUT TABLE-HANDLE hEntityTable[27], OUTPUT TABLE-HANDLE hEntityTable[28],
                                OUTPUT TABLE-HANDLE hEntityTable[29], OUTPUT TABLE-HANDLE hEntityTable[30],
                                OUTPUT TABLE-HANDLE hEntityTable[31], OUTPUT TABLE-HANDLE hEntityTable[32]  ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
        
        /* Update the handles on the ttEntity temp-table.
           Assume that, unless there are errors (which are handled above),
           all of the entities requested were retrieved successfully. This
           means that we don't need to keep track of which entities were
           returned out of the original request, specified by pcEntityName.
           We simply assume that all of the entities were retrieved.
         */
        DO iTableLoop = 1 TO EXTENT(hEntityTable):
            IF NOT VALID-HANDLE(hEntityTable[iTableLoop]) THEN
            DO:
                /* Kill it dead, just in case. */
                DELETE OBJECT hEntityTable[iTableLoop] NO-ERROR.
                NEXT.
            END.        /* not a valid handle */
                                                                                    
            /* At this stage, the ttClass contains all of the tables referred to by the returned
             * table-handles.
             */
            FIND FIRST ttEntity WHERE
                       ttEntity.EntityTableName = hEntityTable[iTableLoop]:NAME + pcLanguageCode
                       NO-ERROR.
            IF AVAILABLE ttEntity THEN
            DO:
                /* If this is already cached, then don't go any further. */
                DELETE OBJECT hEntityTable[iTableLoop]:DEFAULT-BUFFER-HANDLE NO-ERROR.
                DELETE OBJECT hEntityTable[iTableLoop] NO-ERROR.
            END.    /* available ttEntity (has already been cached) */
            ELSE
            DO:                                                                                                            
                CREATE ttEntity.
                ASSIGN ttEntity.EntityTableName    = hEntityTable[iTableLoop]:NAME + pcLanguageCode
                       ttEntity.EntityName         = hEntityTable[iTableLoop]:NAME
                       ttEntity.EntityBufferHandle = hEntityTable[iTableLoop]:DEFAULT-BUFFER-HANDLE
                       ttEntity.LanguageCode       = pcLanguageCode.
            END.    /* not yet cached */
        END.    /* loop through class attribute tables */
        
        /* First clean up. */
        ASSIGN hEntityTable  = ? NO-ERROR.
        
        /* If the cNewRequest variable has a value it means that there
           were more than 32 entities requested in this call. We know (or
           at least assume) that the first 32 were successfully retrieved
           above. We now need to get the remaining entities.
         */
        IF cNewRequest NE "":U THEN
        DO:
            RUN createEntityCache ( INPUT cNewRequest, pcLanguageCode ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* get left-overs. */
    END.    /* go across the AppServer */
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* createEntityCache */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createToolbarCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createToolbarCache Procedure 
PROCEDURE createToolbarCache :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Pre-caches toolbars used on an object in one Appserver hit.
  Parameters:  pcToolbarList - Comma delimited list of toolbars to cache.
               pcObjectList  - The name of the container, used when caching 
                               object bands.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcToolbarsReferenced   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcContainerNames       AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plCacheForSingleObject AS LOGICAL    NO-UNDO.

DEFINE VARIABLE lObjectHasMenus AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hToolbarDotP    AS HANDLE     NO-UNDO.
DEFINE VARIABLE cProperty       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER  NO-UNDO.

/* We need to determine if the container has menus to extract by checking the "hasObjectMenu" *
 * attribute. */
IF plCacheForSingleObject
THEN DO:
    ASSIGN cProperty = "hasObjectMenu".
    RUN getInstanceProperties IN TARGET-PROCEDURE (INPUT ENTRY(1, pcContainerNames, ";":U),
                                                   INPUT "":U,
                                                   INPUT-OUTPUT cProperty,
                                                   OUTPUT cValue).
    ASSIGN lObjectHasMenus = LOGICAL(cValue).
    IF NOT lObjectHasMenus THEN
        ASSIGN pcContainerNames = "":U. /* We're not going to try to extract object bands */
END.

/* Now find toolbar.p.  If not running, start it. */
ASSIGN hToolbarDotP = SESSION:FIRST-PROCEDURE.
find-toolbar-blk:
DO WHILE VALID-HANDLE(hToolbarDotP):
    IF INDEX(hToolbarDotP:FILE-NAME, "/toolbar.") <> 0 THEN
        LEAVE find-toolbar-blk.
    ASSIGN hToolbarDotP = hToolbarDotP:NEXT-SIBLING.
END.

IF NOT VALID-HANDLE(hToolbarDotP) 
THEN DO:
    RUN adm2/toolbar.p PERSISTENT SET hToolbarDotP NO-ERROR.
    IF NOT VALID-HANDLE(hToolbarDotP) THEN
        RETURN.
END.

/* Preload the toolbar */
RUN preloadToolbar IN hToolbarDotP (INPUT pcToolbarsReferenced,
                                    INPUT pcContainerNames) NO-ERROR.    
ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyClassCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyClassCache Procedure 
PROCEDURE destroyClassCache :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Destroys the Temp-tables which make up the class cache
  Parameters:  <none>
  Notes:       * This is a separate clearing procedure to clearClientCache(). That
                 procedure only empties the records from the tables in the cache.
               * This is a separate API because in a runtime environment the 
                 class attributes are unlikely to change much.
------------------------------------------------------------------------------*/
    /* Get rid of all data from the static cache files. */
    RUN clearClientCache IN TARGET-PROCEDURE.
        
    FOR EACH ttClass:
        /* ATTRIBUTES */
        /* When we delete the table handle, the DEFAULT-BUFFER-HANDLE 
         * is deleted along with it.                                  */
        IF VALID-HANDLE(ttClass.classBufferHandle)                                AND
           CAN-QUERY(ttClass.classBufferHandle, "TABLE-HANDLE":U) AND
           VALID-HANDLE(ttClass.classBufferHandle:TABLE-HANDLE)   THEN
            DELETE OBJECT ttClass.classBufferHandle:TABLE-HANDLE NO-ERROR.
                
        /* Double check that the buffer handle has been deleted. */
        IF VALID-HANDLE(ttClass.classBufferHandle) THEN
            DELETE OBJECT ttClass.classBufferHandle NO-ERROR.
            
        /* EVENTS */
        /* When we delete the table handle, the DEFAULT-BUFFER-HANDLE 
         * is deleted along with it.                                  */
        IF VALID-HANDLE(ttClass.EventBufferHandle)                                AND
           CAN-QUERY(ttClass.EventBufferHandle, "TABLE-HANDLE":U) AND
           VALID-HANDLE(ttClass.EventBufferHandle:TABLE-HANDLE)   THEN
            DELETE OBJECT ttClass.EventBufferHandle:TABLE-HANDLE NO-ERROR.   
        /* Double check that the buffer handle has been deleted. */
        
        IF VALID-HANDLE(ttClass.EventBufferHandle) THEN
            DELETE OBJECT ttClass.EventBufferHandle NO-ERROR.
        
        /* ADM Props TT. This temp-table should only ever be removed when
           there are no running objects that depend on the contents of the temp-table.
           If the table associated with the InstanceBufferHandle has no records, then
           we can delete the table buffer handle without too many problems.
                   
           When the table handle is deleted, the DEFAULT-BUFFER-HANDLE 
           is deleted along with it.                                  
         */
        IF VALID-HANDLE(ttClass.InstanceBufferHandle)                AND
           CAN-QUERY(ttClass.InstanceBufferHandle, "TABLE-HANDLE":U) AND
           VALID-HANDLE(ttClass.InstanceBufferHandle:TABLE-HANDLE)   AND
           NOT ttClass.InstanceBufferHandle:TABLE-HANDLE:HAS-RECORDS THEN
            DELETE OBJECT ttClass.InstanceBufferHandle:TABLE-HANDLE NO-ERROR.
        
        /* Double check that the buffer handle has been deleted. */
        IF VALID-HANDLE(ttClass.InstanceBufferHandle) THEN
            DELETE OBJECT ttClass.InstanceBufferHandle NO-ERROR.
        
        DELETE ttClass.
    END.     /* each ttClass */
        
    /* Clear out the cached entity tables. */
    FOR EACH ttEntity:
        /* When we delete the table handle, the DEFAULT-BUFFER-HANDLE
           is deleted along with it.
         */
        IF  CAN-QUERY(ttEntity.EntityBufferHandle, "TABLE-HANDLE":U) AND
           VALID-HANDLE(ttEntity.EntityBufferHandle:TABLE-HANDLE)    THEN
            DELETE OBJECT ttEntity.EntityBufferHandle:TABLE-HANDLE NO-ERROR.
        
        /* Double check that the buffer handle has been deleted. */
        IF VALID-HANDLE(ttEntity.EntityBufferHandle) THEN
            DELETE OBJECT ttEntity.EntityBufferHandle NO-ERROR.
        
        DELETE ttEntity.
    END.    /* ttEntity */                   
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* destroyClassCache */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doObjectRetrieval) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doObjectRetrieval Procedure 
PROCEDURE doObjectRetrieval :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Retrieves Repository data for a requested object.
  Parameters:  pcObjectName       - The name of the object to retrieve
               pcResultCode       - List of result codes.
               pdUserObj          - The user performing the request.
               pdLanguageObj      - The language for this request.
               pcRunAttribute     - Menu run attribute for object request (used for
                                    security)
               pdRenderTypeObj    - Render type of the request. 
               pcPageList         - A CSV list of pages to retrieve. Optional.
               pdInstanceId       - The instanceID of the cacheObject record
                                    associated with the requested object.
               pcInstanceName     - The name of the instance to retrieve.
               
               pcClassesReferenced  - } These are CSV lists of the class and
               pcEntitiesReferenced - } entity names of those entities used
                                        by the obejcts retrieved. These are 
                                        passed back to the client request so
                                        that the client can retrieve them all in
                                        one hit, rather than try to fetch each 
                                        class or entity individually.
               pcToolbarsReferenced - } toolbar object names of toolbars used
                                        by the objects retrieved.  These are
                                        passed back to the client so they can
                                        all be cached in one hit, rather than
                                        fetching the toolbar information for each
                                        toolbar as it is rendered.
  Notes:       * Top level retrieval procedure.
               * Performs retrieval from Repository database, aggregation of
                 result codes, security, translation.
               * The pcPageList parameter must contain either a CSV list of pages
                 to retrieve, including page0 if required, or it should be '*' 
                 to retrieve all pages.
               * This API is not responsible for the returning of tables across the
                 AppServer, or of returning information for a request. It merely
                 populates then cacheObject temp-tables.
               * The pdInstanceId parameter indicates whether the requested object
                 has been cached or not. A zero value is passed in when the object
                 not cached on the client, and this results in the creation of a
                 cacheObject record for the requested object. If a value is passed
                 in, it is used as the parent key value (ContainerInstanceId) for
                 the contained pages and/or instances.
               * A request for a single instance will retrieve all of the instances
                 contained by the page that the requested instance appears on. A
                 single-instance request will only retrieve instances of the top-level
                 container - so an instance on an instance cannot be retrieved singly.
                 So a DataField instance on a viewer that has been placed on a window
                 cannot be retrieved singly (Window:Viewer:DataField), unless it is
                 retrieved as an instance of the viewer (Viewer:DataField).
               * If pdInstanceId is non-zero, then there must be a list of instances
                 to retrieve.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcObjectName            AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcResultCode            AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pdUserObj               AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER pdLanguageObj           AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER pcRunAttribute          AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pdRenderTypeObj         AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER pcPageList              AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pdInstanceId            AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER pcInstanceName          AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcClassesReferenced     AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcEntitiesReferenced    AS CHARACTER        NO-UNDO.    
    DEFINE OUTPUT PARAMETER pcToolbarsReferenced    AS CHARACTER        NO-UNDO.

    &IF DEFINED(Server-Side) EQ 0 &THEN
        RUN ry/app/rygetobjectp.p ON gshAstraAppserver ( INPUT  pcObjectName,
                                                         INPUT  pcResultCode,
                                                         INPUT  pdUserObj,
                                                         INPUT  pdLanguageObj,
                                                         INPUT  pcRunAttribute,
                                                         INPUT  pdRenderTypeObj,
                                                         INPUT  pcPageList,
                                                         INPUT  pdInstanceId,
                                                         INPUT  pcInstanceName,
                                                         OUTPUT pcClassesReferenced,
                                                         OUTPUT pcEntitiesReferenced,
                                                         OUTPUT pcToolbarsReferenced,
                                                         OUTPUT TABLE cacheObject APPEND,
                                                         OUTPUT TABLE cachePage   APPEND,
                                                         OUTPUT TABLE cacheLink   APPEND  ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
            RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
    /* Code moved to include to avoid section editor limits. */
    {ry/inc/ryrepdoori.i}
    &ENDIF
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* doObjectRetrieval */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doServerRetrieval) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doServerRetrieval Procedure 
PROCEDURE doServerRetrieval :
/*------------------------------------------------------------------------------
  Purpose:     Performs the retrieval of the object from the Repository, and
               adds the returned objects to the cache.
  Parameters:  pcLogicalObjectName -
               pdUserObj           -
               pcResultCode        -
               pdLanguageObj       -
               pcRunAttribute      -
               plDesignMode        - 
  Notes:       * This procedure is PRIVATE and may only be called from cacheObjectOnClient 
                 which is in the Repository Manager
                 
*** THIS API HAS BEEN DEPRECATED ***                 
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcLogicalObjectName         AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pdUserObj                   AS DECIMAL      NO-UNDO.
    DEFINE INPUT  PARAMETER pcResultCode                AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pdLanguageObj               AS DECIMAL      NO-UNDO.
    DEFINE INPUT  PARAMETER pcRunAttribute              AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER plDesignMode                AS LOGICAL      NO-UNDO.
    
    RETURN ERROR "*** THIS API HAS BEEN DEPRECATED ***".
END PROCEDURE.  /* doServerRetrieval */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-extractRootFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extractRootFile Procedure 
PROCEDURE extractRootFile :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Extracts the root file name from a path and provides the file
               name with an extension (if there is one) and without an extension.
  Parameters:
    INPUT pcFileName     - The Filename to parse
    OUTPUT pcRootFile    - The root file without extension
    OUTPUT pcRootFileExt - The root file with extenstion
    
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFileName    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRootFile    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRootFileExt AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPos AS INTEGER    NO-UNDO.

  /* First replace all the back slashes with forward slashes */
  ASSIGN pcFileName = REPLACE(pcFileName, "~\":U, "/":U).

  /* The root file with the extension is the last entry delimited by 
   * forward slash */
  IF NUM-ENTRIES(pcFileName,"/":U) GT 0 THEN
      ASSIGN pcRootFileExt = ENTRY(NUM-ENTRIES(pcFileName,"/":U), pcFileName, "/":U).
  
  /* If there is more than one entry delimited by ".", then we want to strip 
     off the extension */
  iPos = R-INDEX(pcRootFileExt,".":U).
  IF iPos > 0 THEN
    pcRootFile = SUBSTRING(pcRootFileExt, 1,iPos - 1).
  ELSE
    /* There is no extension, so only return the root file */
    ASSIGN
      pcRootFile    = pcRootFileExt
      pcRootFileExt = "":U
    .    
    ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchObject Procedure 
PROCEDURE fetchObject :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Retrieves all information about an object and the objects it
               contains. 
  Parameters:  
  Notes:       * This procedure is replaced by cachedObjectOnClient and other.
                 The code that remains here is purely temporary. There is no 
                 guarantee that this API will exist in the future.
               * This API only returns data in buffer form.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcLogicalObjectName         AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pdUserObj                   AS DECIMAL      NO-UNDO.
    DEFINE INPUT  PARAMETER pcResultCode                AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcRunAttribute              AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pdLanguageObj               AS DECIMAL      NO-UNDO.
    DEFINE INPUT  PARAMETER plReturnEntireContainer     AS LOGICAL      NO-UNDO.
    DEFINE INPUT  PARAMETER plDesignMode                AS LOGICAL      NO-UNDO.

    DEFINE OUTPUT PARAMETER phBufferCacheBuffer         AS HANDLE       NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phObjectTable.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phPageTable.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phPageInstanceTable.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phLinkTable.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phUiEventTable.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable01.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable02.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable03.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable04.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable05.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable06.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable07.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable08.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable09.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable10.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable11.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable12.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable13.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable14.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable15.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable16.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable17.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable18.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable19.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable20.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable21.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable22.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable23.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable24.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable25.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable26.
    
    RETURN ERROR "This API (fetchObject) is deprecated.".
END PROCEDURE.  /* fetchObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getActions Procedure 
PROCEDURE getActions :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
     Purpose: Retrieves menu actions.
  Parameters: 
       Notes: * Only used by Dynamics Web.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcCategoryList          AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcActionList            AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttAction.
DEFINE OUTPUT PARAMETER TABLE FOR ttCategory.

DEFINE VARIABLE dUserObj                        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dOrganisationObj                AS DECIMAL    NO-UNDO.


/* get the current user and organisation */
dUserObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                     INPUT "currentUserObj":U,
                                                     INPUT NO)) NO-ERROR.
dOrganisationObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                     INPUT "currentOrganisationObj":U,
                                                     INPUT NO)) NO-ERROR.

&IF DEFINED(server-side) <> 0 &THEN
  RUN rygetitemp IN TARGET-PROCEDURE (INPUT pcCategoryList,
                                      INPUT pcActionList,
                                      INPUT dUserObj,
                                      INPUT dOrganisationObj,
                                      OUTPUT TABLE ttAction,
                                      OUTPUT TABLE ttCategory).  
&ELSE
  RUN ry/app/rygetitemp.p ON gshAstraAppserver 
                 (INPUT pcCategoryList,
                  INPUT pcActionList,
                  INPUT dUserObj,
                  INPUT dOrganisationObj,
                  OUTPUT TABLE ttAction,
                  OUTPUT TABLE ttCategory).
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassChildrenProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getClassChildrenProc Procedure 
PROCEDURE getClassChildrenProc :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  This is a wrapper procedure for the getClassChildrenFromDB function
            to allow it being called using the dynamic call include seeing that
            the function needs to be run on the AppServer-side Repository Manager.
  
  Parameters:  INPUT  pcClasses   - Comma delimited list of classes to retrieve
               OUTPUT pcClassList - Function return value
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcClasses   AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcClassList AS CHARACTER  NO-UNDO.
        
  pcClassList = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN TARGET-PROCEDURE, pcClasses).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassParentsProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getClassParentsProc Procedure 
PROCEDURE getClassParentsProc :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  This is a wrapper procedure for the getClassParentFromDB function
            to allow it being called using the dynamic call include seeing that
            the function needs to be run on the AppServer-side Repository Manager.
  
  Parameters:  INPUT  pcClasses   - Comma delimited list of classes to retrieve
               OUTPUT pcClassList - Function return value
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcClasses   AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcClassList AS CHARACTER  NO-UNDO.

  pcClassList = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN TARGET-PROCEDURE, pcClasses).

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getClassProperties Procedure 
PROCEDURE getClassProperties :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Retrieves the properties for a specified class.
  Parameters:  pcClassName      - class name.
               pcPropertyNames  - a csv list of proeprties/attributes to retrieve;
                                  can be *
               pcPropertyValues - a CHR(1)-delimited string of property values.
  Notes:       * The property names and values returned include all ancestor 
                 classes.
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER pcClassName         AS CHARACTER          NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pcPropertyNames     AS CHARACTER          NO-UNDO.
    DEFINE       OUTPUT PARAMETER pcPropertyValues    AS CHARACTER          NO-UNDO.
        
    DEFINE BUFFER bClass             FOR ttClass.
    
    define variable cPropertyNames       as character                    no-undo.
    define variable iNumFields           as integer                      no-undo.
    define variable iLoop                as integer                      no-undo.
    define variable hBufferField         as handle                       no-undo.
    define variable hClassBuffer         as handle                       no-undo.
    
    IF pcPropertyNames EQ "":U OR pcPropertyNames EQ ? THEN
        ASSIGN pcPropertyNames = "*":U.
    
    FIND FIRST bClass WHERE bClass.ClassName = pcClassName NO-ERROR.

    IF NOT AVAILABLE bClass THEN
    DO:
        RUN createClassCache IN TARGET-PROCEDURE ( pcClassName ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
            RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
        
        FIND FIRST bClass WHERE bClass.ClassName = pcClassName NO-ERROR.
        IF NOT AVAILABLE bClass THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"cached class"' "'Class name: ' + pcClassName"}.
    END.      /* n/a cache class */
    
    /* The ADD-NEW-FIELD() method doesn't set the initial value correctly
     * when an unknown value is passed in; the initial value is set to the
     * default for the data type (zero for numerics) instead of to a null value.
     * 
     * This becomes an issue in numeric fields when the unknown value is a desired
     * value (cf. attributes storing colors and fonts). To ensure that we have the correct 
     * value, we need to create a record in the temp-table, so we can use the :BUFFER-VALUE 
     * instead of the :INITIAL attribute to determine the value at the class level.          
     *
     * There is no unique index on the class temp-table so we can freely create
     * a record here, without having to check for the existence of an an existing record.
     */
    
    /* Use a separate, named buffer here to avoid buffer scoping issues.
     */
    create buffer hClassBuffer for table bClass.ClassBufferHandle buffer-name "lbClass":U.
    
    hClassBuffer:BUFFER-CREATE().
    
    /* Certain of the information is stored on the ttClass record rather
       than as a pure attribute. Make sure that this information is returned.
     */
    IF CAN-DO(pcPropertyNames, "InheritsFromClasses":U) THEN
        ASSIGN cPropertyNames   = cPropertyNames + ",":U + "InheritsFromClasses":U
               pcPropertyValues = pcPropertyValues + {&Value-Delimiter} + bClass.InheritsFromClasses.
    
    IF CAN-DO(pcPropertyNames, "ClassObj":U) THEN
        ASSIGN cPropertyNames   = cPropertyNames + ",":U + "ClassObj":U
               pcPropertyValues = pcPropertyValues + {&Value-Delimiter} + STRING(bClass.ClassObj).
    
    IF CAN-DO(pcPropertyNames, "SuperProcedures":U) THEN
        ASSIGN cPropertyNames   = cPropertyNames + ",":U + "SuperProcedures":U
               pcPropertyValues = pcPropertyValues + {&Value-Delimiter} + bClass.SuperProcedures.
    
    IF CAN-DO(pcPropertyNames, "SuperProcedureModes":U) THEN
        ASSIGN cPropertyNames   = cPropertyNames + ",":U + "SuperProcedureModes":U
               pcPropertyValues = pcPropertyValues + {&Value-Delimiter} + bClass.SuperProcedureModes.
    
    IF CAN-DO(pcPropertyNames, "SuperHandles":U) THEN
        ASSIGN cPropertyNames   = cPropertyNames + ",":U + "SuperHandles":U
               pcPropertyValues = pcPropertyValues + {&Value-Delimiter} + bClass.SuperHandles.
    
    /* If all properties are requested, then loop through the entire class buffer. */
    IF pcPropertyNames EQ "*":U THEN
        ASSIGN iNumFields = bClass.ClassBufferHandle:NUM-FIELDS.
    ELSE
        ASSIGN iNumFields = NUM-ENTRIES(pcPropertyNames).
    
    DO iLoop = 1 TO iNumFields:
        IF pcPropertyNames EQ "*":U THEN
            ASSIGN hBufferField = hClassBuffer:BUFFER-FIELD(iLoop) NO-ERROR.
        ELSE
            ASSIGN hBufferField = hClassBuffer:BUFFER-FIELD(ENTRY(iLoop, pcPropertyNames)) NO-ERROR.
            
        /* Skip those fields that may have been updated already (off the ttClass
           record). In some cases these values exist in the properties record, and in 
           some not.
         */
        IF not valid-handle(hBufferField) or
           CAN-DO("SuperHandles,SuperProcedureModes,SuperProcedures,ClassObj,InheritsFromClasses":U,
                  hBufferField:NAME) THEN
            NEXT.
        
        /* We may have asked for a non-existent field, in which case
           just ignore it and go on. This is possible if we ask for one of the fields on
           the ttClass temp-table such as ClassObj.
         */
        IF NOT VALID-HANDLE(hBufferField) THEN
            NEXT.
        
        /* Get the class value */
        ASSIGN cPropertyNames   = cPropertyNames + ",":U + hBufferField:NAME
               pcPropertyValues = pcPropertyValues + {&Value-Delimiter}
                                + (IF hBufferField:BUFFER-VALUE EQ ? THEN "?":U ELSE hBufferField:BUFFER-VALUE).
    END.    /* loop through requested fields */
    
    /* Clean up. */
    hClassBuffer:BUFFER-DELETE().    
    delete object hClassBuffer no-error.
    
    ASSIGN hClassBuffer       = ?
           pcPropertyValues   = SUBSTRING(pcPropertyValues, 2)
           pcPropertyNames    = LEFT-TRIM(cPropertyNames, ",":U)
           ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.    /* getClassProperties */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClientCacheDir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getClientCacheDir Procedure 
PROCEDURE getClientCacheDir :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Based on input product module, this proc will find the full absolute 
               path to the client cache direcotry.
  Parameters:  input - product module
               output - full path name to the directory
  Notes:       First this API will check the session parameter client_cache_directory
               and if this is found it returns this value. This will also 
               reduce a AppServer hit.
               Else it goes 
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcProductModule AS CHARACTER  NO-UNDO. 
  DEFINE OUTPUT PARAMETER pcFullPathName  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cRootDir        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelPath        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullPath       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDummy          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cError          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFrameworkDir   AS CHARACTER  NO-UNDO.
  
  ASSIGN ERROR-STATUS:ERROR = FALSE.

  /* First check if the session parameter client_cache_directory has been set 
     for this session type.
     -If so, get the value and return. If this value is found then one 
      AppServer hit is avoided.
     -If not then find the relative path to the ry/clc directory and append
      the _framework_directory and calculate the path 
   */
   
  /* get the client_cache_Directory - If found - return the value*/
  ASSIGN pcFullPathName = DYNAMIC-FUNCTION('getSessionParam':U IN THIS-PROCEDURE, "client_cache_directory":U) NO-ERROR.
  IF (NOT ERROR-STATUS:ERROR AND pcFullPathName > "":U ) THEN
  DO:
    ASSIGN pcFullPathName = REPLACE(pcFullPathName, "~\":U, "/":U)
           file-info:file-name = pcFullPathName.
    /* Check for the existence of the client cache dir. */
    if file-info:full-pathname eq ? then
        pcFullPathName = ''.        
    RETURN "".
  END.
    
  /* Based on the product module - find the relative path */
  RUN calculateObjectpaths IN TARGET-PROCEDURE 
        (INPUT  "",              /* Object Name        */
         INPUT  0,               /* smartobject_obj    */
         INPUT  "",              /* Object Type        */
         INPUT  pcProductModule, /* Product Module     */
         INPUT  "":U,            /* objectParameter    */ 
         INPUT  "":U,            /* name Space         */
         OUTPUT cRootDir,        /* Root Dircetory     */
         OUTPUT cRelPath,        /* Relative Directory */
         OUTPUT cDummy,          /* SCM Relative dir   */
         OUTPUT cFullPath,       /* Full path Name     */
         OUTPUT cDummy,          /* Output Object Name */
         OUTPUT cDummy,          /* Physical file name */
         OUTPUT cError) NO-ERROR.   
  
  /* If there is a error default to ry/clc */
  IF ERROR-STATUS:ERROR OR cError > "":U THEN
    ASSIGN ERROR-STATUS:ERROR  = NO
           cRelPath = "ry/clc":U.
  
  /* get the Framework Directory */
  ASSIGN cFrameworkDir = DYNAMIC-FUNCTION('getSessionParam':U IN THIS-PROCEDURE, 
                                          "_framework_directory":U) NO-ERROR.
  
  /* If for some reason, framework root directory is not found, then use default */
  IF (ERROR-STATUS:ERROR OR cFrameworkDir = ? OR cFrameworkDir = "" ) THEN
    ASSIGN ERROR-STATUS:ERROR  = FALSE
           FILE-INFO:FILE-NAME = cRelPath
           pcFullPathName      = REPLACE(FILE-INFO:FULL-PATHNAME, "~\":U, "/":U).
  ELSE 
    ASSIGN pcFullPathName = RIGHT-TRIM(cFrameworkDir, "/":U) + "/":U + 
                            LEFT-TRIM(cRelPath, "/":U)
           pcFullPathName = REPLACE(pcFullPathName, "~\":U, "/":U).

    /* Check for the existence of the client cache dir. */
    file-info:file-name = pcFullPathName.
    if file-info:full-pathname eq ? then
        pcFullPathName = ''.
    
    error-status:error = no.
    RETURN "".
END PROCEDURE.    /* getClientCacheDir */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainedInstanceNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getContainedInstanceNames Procedure 
PROCEDURE getContainedInstanceNames :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Returns a CSV list of contained instance names for an object.
  Parameters:  pcObjectName    - objectname:runattribute:pagenumber
               pcInstanceNames - a CSV list of instance names.
  Notes:       * The instance names returned are sorted by the Object_Sequence of
                 the object instance record.
               * The pcObjectName parameter can have the following format:
                 Object or instance name ":" run attribute ":" page number.
               * If no page number is specified, all instances are returned.
               * If no run attribute is specified, the a run attribute of blank is
                 assumed.
               * By definition, the object requested is a container. If this
                 container is on another container, then this API MUST be 
                 called using an InstanceId value in the pcObjectName parameter.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcObjectName            AS CHARACTER          NO-UNDO.
    DEFINE OUTPUT PARAMETER pcInstanceNames         AS CHARACTER          NO-UNDO.    
    
    DEFINE VARIABLE cRunAttribute             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cPageNumber               AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE iPageNumber               AS INTEGER                  NO-UNDO.
    
    DEFINE BUFFER bCache         FOR cacheObject.
    DEFINE BUFFER bPage          FOR cachePage. 
    
    /* Make sure we get some default values, or the value as 
       passed in to the API.
     */
    IF NUM-ENTRIES(pcObjectName, ":":U) GE 2 THEN
        ASSIGN cRunAttribute = ENTRY(2, pcObjectName, ":":U).
    
    IF NUM-ENTRIES(pcObjectName, ":":U) GE 3 THEN
        ASSIGN cPageNumber = ENTRY(3, pcObjectName, ":":U)
               iPageNumber = INTEGER(cPageNumber)
               NO-ERROR.
    
    ASSIGN pcObjectName = ENTRY(1, pcObjectName, ":":U).
    
    /* Check whether the object is already cached. By definition, the object
       requested is a container. If this container is on another container, 
       then this API MUST be called using an InstanceId value in the pcObjectName
       parameter.
     */
    FIND bCache WHERE
         bCache.InstanceId = DECIMAL(pcObjectName)
         NO-ERROR.
    
    IF NOT AVAILABLE bCache THEN
        FIND bCache WHERE 
             bCache.ObjectName          = pcObjectName AND
             bCache.ContainerInstanceId = 0
             NO-ERROR.
    IF NOT AVAILABLE bCache THEN
    DO:
        /* Make sure the requested page is cached. */
        IF cPageNumber NE "":U THEN
            ASSIGN cPageNumber = "PAGE:":U + cPageNumber.
        
        RUN cacheRepositoryObject ( INPUT pcObjectName,
                                    INPUT cPageNumber,
                                    INPUT cRunAttribute,
                                    INPUT ?  /* result code */ ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
        
        FIND bCache WHERE
             bCache.ObjectName          = pcObjectName AND
             bCache.ContainerInstanceId = 0
             NO-ERROR.
    END.    /* n/a cache obejct */
    
    IF NOT AVAILABLE bCache THEN
        RETURN ERROR {aferrortxt.i 'AF' '15' '?' '?' "'the cache entry for ' + pcObjectName + ' could not be found.'"}.
        
    IF cPageNumber EQ "":U THEN
    DO:
        /* Retrieve instance names in page order. The instance names
           are already ordered by Object_Sequence in the TOC field.
         */
        FOR EACH bPage WHERE
                 bPage.InstanceId = bCache.InstanceId
                 BY bPage.PageNumber:
            ASSIGN pcInstanceNames = pcInstanceNames + ",":U + bPage.TOC.
        END.    /* no page required/specified. */
        
        ASSIGN pcInstanceNames = LEFT-TRIM(pcInstanceNames, ",":U).
    END.    /* all pages */
    ELSE
    DO:
        FIND FIRST bPage WHERE
                   bPage.InstanceId = bCache.InstanceId AND
                   bPage.PageNumber = iPageNumber
                   NO-ERROR.
        IF NOT AVAILABLE bPage THEN
            RETURN ERROR {aferrortxt.i 'AF' '15' '?' '?' "'page ' + STRING(iPageNumber) + ' for ' + pcObjectName + ' could not be found.'"}.
        
        ASSIGN pcInstanceNames = bPage.TOC.
    END.    /* single page chosen */
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.    /* getContainedInstanceNames */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInstanceData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getInstanceData Procedure 
PROCEDURE getInstanceData :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Retrieves the INFORMATION FOR a contained instance.
  Parameters:  pcContainerName       -
               pdContainerInstanceId -
               pcInstanceName        -
               pdObjectInstanceObj   - 
               pcLogicalObjectName   - 
               pdSmartObjectObj      -
               pdClassObj            -
               pcLayoutPosition      -
               piPageNumber          -
               piObjectSequence      -
               pdRenderTypeObj       -
               pdLanguageObj         -
               plApplyTranslations   -
               plStaticObject        -
               pcSecuredFields       - a CSV list of secured fields for this container.
               pcSecuredTokens       - a CSV list of secured tokens/actions for this container.
               pcClassesReferenced   -
               pcEntitiesReferenced  -
               pcToolbarsReferenced  - A list of toolbars referenced on the objects being extracted.
               
  Notes:       * This procedure will also check for contained instances of the
                 requested instance.
               * This API is a server-side-only API.
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER pcContainerName              AS CHARACTER            NO-UNDO.
    DEFINE INPUT        PARAMETER pdContainerInstanceId        AS DECIMAL              NO-UNDO.
    DEFINE INPUT        PARAMETER pcInstanceName               AS CHARACTER            NO-UNDO.
    DEFINE INPUT        PARAMETER pdObjectInstanceObj          AS DECIMAL              NO-UNDO.
    DEFINE INPUT        PARAMETER pcLogicalObjectName          AS CHARACTER            NO-UNDO.
    DEFINE INPUT        PARAMETER pdSmartObjectObj             AS DECIMAL              NO-UNDO.
    DEFINE INPUT        PARAMETER pdClassObj                   AS DECIMAL              NO-UNDO.
    DEFINE INPUT        PARAMETER pcLayoutPosition             AS CHARACTER            NO-UNDO.
    DEFINE INPUT        PARAMETER piPageNumber                 AS INTEGER              NO-UNDO.
    DEFINE INPUT        PARAMETER piObjectSequence             AS INTEGER              NO-UNDO.
    DEFINE INPUT        PARAMETER pdRenderTypeObj              AS DECIMAL              NO-UNDO.
    DEFINE INPUT        PARAMETER pdLanguageObj                AS DECIMAL              NO-UNDO.
    DEFINE INPUT        PARAMETER plApplyTranslations          AS LOGICAL              NO-UNDO.
    DEFINE INPUT        PARAMETER plStaticObject               AS LOGICAL              NO-UNDO.
    DEFINE INPUT        PARAMETER pcSecuredFields              AS CHARACTER            NO-UNDO.
    DEFINE INPUT        PARAMETER pcSecuredTokens              AS CHARACTER            NO-UNDO.
    DEFINE INPUT        PARAMETER pcResultCode                 AS CHARACTER            NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pcClassesReferenced          AS CHARACTER            NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pcEntitiesReferenced         AS CHARACTER            NO-UNDO.    
    DEFINE INPUT-OUTPUT PARAMETER pcToolbarsReferenced         AS CHARACTER            NO-UNDO.

    &IF DEFINED(Server-Side) NE 0 &THEN
    /* Code moved to include to avoid section editor limits. */
    {ry/inc/ryrepgeidi.i}
    &ENDIF
        
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* getInstanceData */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInstanceProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getInstanceProperties Procedure 
PROCEDURE getInstanceProperties :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Retrieves the properties for a specified object or object instance.
  Parameters:  pcObjectName     - object name: master or container name.
               pcInstanceName   - optional instance name
               pcPropertyNames  - a csv list of proeprties/attributes to retrieve;
                                  can be *
               pcPropertyValues - a CHR(1)-delimited string of property values.
  Notes:       * The property names and values returned include class, master and
                 instance values.
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER pcObjectName        AS CHARACTER          NO-UNDO.
    DEFINE INPUT        PARAMETER pcInstanceName      AS CHARACTER          NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pcPropertyNames     AS CHARACTER          NO-UNDO.
    DEFINE       OUTPUT PARAMETER pcPropertyValues    AS CHARACTER          NO-UNDO.
    
    DEFINE VARIABLE dInstanceId        AS DECIMAL                           NO-UNDO.
    DEFINE VARIABLE cEntityName        AS CHARACTER                         NO-UNDO.
    DEFINE VARIABLE cPropertyNames     AS CHARACTER                         NO-UNDO.
    DEFINE VARIABLE cFieldName         AS CHARACTER                         NO-UNDO.
    DEFINE VARIABLE iLoop              AS INTEGER                           NO-UNDO.
    DEFINE VARIABLE iAttributeEntry    AS INTEGER                           NO-UNDO.
    DEFINE VARIABLE iNumFields         AS INTEGER                           NO-UNDO.
    define variable hClassBuffer       as handle                            no-undo.    
    DEFINE VARIABLE hBufferField       AS HANDLE                            NO-UNDO.
    DEFINE VARIABLE hEntityField       AS HANDLE                            NO-UNDO.    
    DEFINE VARIABLE cInitial           AS CHARACTER                         NO-UNDO.
    DEFINE VARIABLE cFormat            AS CHARACTER                         NO-UNDO.
    DEFINE variable lHasSuperProcedure as logical                           no-undo.
    DEFINE variable lHasSuperProcMode  as logical                           no-undo.
    DEFINE VARIABLE cLanguageCode      AS CHARACTER                         NO-UNDO.
    
    DEFINE BUFFER bCache             FOR cacheObject.
    DEFINE BUFFER bEntity            FOR ttEntity.
    DEFINE BUFFER bClass             FOR ttClass.
    
    IF pcPropertyNames EQ "":U OR pcPropertyNames EQ ? THEN
        ASSIGN pcPropertyNames = "*":U.
    
    /* First make sure the object is cached.
       Check if the InstanceId has been passed in as a parameter, rather than
       the names of the objects. This will make the retrieval much faster.
     */
    FIND bCache WHERE
         bCache.InstanceId = DECIMAL(pcObjectName)
         NO-ERROR.

    IF NOT AVAILABLE bCache THEN
       FIND bCache WHERE
            bCache.ObjectName          = pcObjectName AND
            bCache.ContainerInstanceId = 0
            NO-ERROR.

    IF NOT AVAILABLE bCache THEN
    DO:
        RUN cacheRepositoryObject ( INPUT pcObjectName,
                                    INPUT pcInstanceName,
                                    INPUT ?,
                                    INPUT ?            ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
        
        FIND FIRST bCache WHERE
                   bCache.ObjectName          = pcObjectName AND
                   bCache.ContainerInstanceId = 0
                   NO-ERROR.
        IF NOT AVAILABLE bCache THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"cached object"' "'Object name: ' + pcObjectName"}.
    END.    /* not initially available */
    
    IF pcInstanceName NE "":U THEN
    DO:
        ASSIGN dInstanceId = bCache.InstanceId.
        
        FIND FIRST bCache WHERE
                   bCache.ObjectName          = pcInstanceName AND
                   bCache.ContainerInstanceId = dInstanceId
                   NO-ERROR.
        IF NOT AVAILABLE bCache THEN
        DO:
            RUN cacheRepositoryObject ( INPUT pcObjectName,
                                        INPUT pcInstanceName,
                                        INPUT ?,
                                        INPUT ?            ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
            
            FIND FIRST bCache WHERE
                       bCache.ObjectName          = pcInstanceName AND
                       bCache.ContainerInstanceId = dInstanceId
                       NO-ERROR.
            IF NOT AVAILABLE bCache THEN
                RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"cached object instance"' "'Instance name: ' + pcInstanceName"}.
        END.    /* not initially available */
    END.    /* instancename is blank */

    /* Now that we have the object, get the class. */
    FIND FIRST bClass WHERE bClass.ClassName = bCache.ClassName NO-ERROR.

    IF NOT AVAILABLE bClass THEN
    DO:
        RUN createClassCache IN TARGET-PROCEDURE ( bCache.ClassName ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
        
        FIND FIRST bClass WHERE bClass.ClassName = bCache.ClassName NO-ERROR.
        IF NOT AVAILABLE bClass THEN
            RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"cached class"' "'Class name: ' + bCache.ClassName"}.
    END.      /* n/a cache class */
    
    /* The ADD-NEW-FIELD() method doesn't set the initial value correctly
     * when an unknown value is passed in; the initial value is set to the
     * default for the data type (zero for numerics) instead of to a null value.
     * 
     * This becomes an issue in numeric fields when the unknown value is a desired
     * value (cf. attributes storing colors and fonts). To ensure that we have the correct 
     * value, we need to create a record in the temp-table, so we can use the :BUFFER-VALUE 
     * instead of the :INITIAL attribute to determine the value at the class level.          
     *
     * There is no unique index on the class temp-table so we can freely create
     * a record here, without having to check for the existence of an an existing record.
     */
    
    /* Create a separate, named buffer here to avoid buffer scoping issues.
     */
    create buffer hClassBuffer for table bClass.ClassBufferHandle buffer-name "lbClass":U.
    hClassBuffer:BUFFER-CREATE().
            
    /* In certain cases, get the entity cache.
     * Currently, the CalculatedField class inherits from the DataField class; this
     * class needs to be excluded since CalculatedFields are not 'proper' datafields.
     */
    IF CAN-DO(bClass.InheritsFromClasses, "DataField":U)            AND
       NOT CAN-DO(bClass.InheritsFromClasses, "CalculatedField":U) THEN
    DO:
        ASSIGN hBufferField = hClassBuffer:BUFFER-FIELD("LogicalObjectName":U) NO-ERROR.
        /* We can do nothing without a rendering procedure. */
        IF NOT VALID-HANDLE(hBufferField) THEN
            RETURN ERROR {aferrortxt.i 'AF' '38' '?' '?' '" LogicalObjectName attribute'}.
            
        /* This value will never be set at the class level. */
        ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), bCache.AttrOrdinals)
               cEntityName = ENTRY(iAttributeEntry, bCache.AttrValues, {&Value-Delimiter})
               /* The logical object name of DataFields is always of the format: TableName.FieldName
                   
                  We need to look for the field by its 
                  logical object name/field name rather than the instance name,
                  for occasions where a field is repeated on a object, or is
                  renamed.
                */
               cFieldName  = ENTRY(2, cEntityName, ".":U)
               cEntityName = ENTRY(1, cEntityName, ".":U).
        
        cLanguageCode = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, "CurrentLanguageCode":U, YES).
        IF cLanguageCode = ? OR cLanguageCode = "":U THEN cLanguageCode = "NONE":U.
        FIND FIRST bEntity WHERE bEntity.EntityName = cEntityName AND bEntity.LanguageCode = cLanguageCode NO-ERROR.
        IF NOT AVAILABLE bEntity THEN
        DO:
            RUN createEntityCache IN TARGET-PROCEDURE ( cEntityName, cLanguageCode ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
            
            FIND FIRST bEntity WHERE bEntity.EntityName = cEntityName AND bEntity.LanguageCode = cLanguageCode NO-ERROR.
            IF NOT AVAILABLE bEntity THEN
                RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"cached entity"' "'Entity name: ' + cEntityName"}.
        END.      /* n/a cache entity */
    END.    /* 'proper' DataField */
    ELSE
        ASSIGN cEntityName   = "":U.
    
    /* Certain of the information is stored on the cacheObject record rather
       than as a pure attribute. Make sure that this information is returned.
     */
    IF CAN-DO(pcPropertyNames, "PageNumber":U) THEN
        ASSIGN cPropertyNames   = cPropertyNames + ",":U + "PageNumber":U
               pcPropertyValues = pcPropertyValues + {&Value-Delimiter} + STRING(bCache.PageNumber).
               
    /* Create a pseudo-attribute called ObjectHasTranslation that will indicate whether
       an object actually has translations. This is taken from the value of the 
       cacheObject.ObjectTranslated field which indicates whether translation has actually taken place.
       The value of the ObjectTranslated property indicates that an attempt was made to
       translate the object, but doesn't say whether that attempt was successful of not.
     */
    IF CAN-DO(pcPropertyNames, "ObjectTranslated":U) THEN
        ASSIGN cPropertyNames   = cPropertyNames + ",":U + "ObjectHasTranslation":U
               pcPropertyValues = pcPropertyValues + {&Value-Delimiter}               
                                + (IF bCache.ObjectTranslated EQ ? THEN "?":U ELSE STRING(bCache.ObjectTranslated)).

    /* Create a pseudo-attribute called ObjectHasSecurity that will indicate whether
       an object actually has secirity. This is taken from the value of the 
       cacheObject.ObjectSecured field which indicates whether translation has actually taken place.
       The value of the ObjectSecured property indicates that an attempt was made to
       secure the object, but doesn't say whether that attempt was successful of not.
     */
    IF CAN-DO(pcPropertyNames, "ObjectSecured":U) THEN
        ASSIGN cPropertyNames   = cPropertyNames + ",":U + "ObjectHasSecurity":U
               pcPropertyValues = pcPropertyValues + {&Value-Delimiter}               
                                + (IF bCache.ObjectSecured EQ ? THEN "?":U ELSE STRING(bCache.ObjectSecured)).
    
    IF CAN-DO(pcPropertyNames, "InstanceId":U) THEN
        ASSIGN cPropertyNames   = cPropertyNames + ",":U + "InstanceId":U
               pcPropertyValues = pcPropertyValues + {&Value-Delimiter} + STRING(bCache.InstanceId).
    
    IF CAN-DO(pcPropertyNames, "Order":U) THEN
        ASSIGN cPropertyNames   = cPropertyNames + ",":U + "Order":U
               pcPropertyValues = pcPropertyValues + {&Value-Delimiter} + STRING(bCache.Order).
    
    /* If all properties are requested, then loop through the entire class buffer. */
    IF pcPropertyNames EQ "*":U THEN
        ASSIGN iNumFields = bClass.ClassBufferHandle:NUM-FIELDS.
    ELSE
        ASSIGN iNumFields = NUM-ENTRIES(pcPropertyNames).        
    
    assign lHasSuperProcedure = no
           lHasSuperProcMode  = no.
    
    DO iLoop = 1 TO iNumFields:
        IF pcPropertyNames EQ "*":U THEN
            ASSIGN hBufferField = hClassBuffer:BUFFER-FIELD(iLoop) NO-ERROR.
        ELSE
            ASSIGN hBufferField = hClassBuffer:BUFFER-FIELD(ENTRY(iLoop, pcPropertyNames)) NO-ERROR.
        
        /* We may have asked for a non-existent field, in which case
           just ignore it and go on. This is possible if we ask for one of the fields on
           the cacheObject temp-table such as PageNumber.         
         */
        IF NOT VALID-HANDLE(hBufferField) THEN
            NEXT.
        
        /* Also skip those fields that may have been updated already (off the cacheObject
           record. 
          */
        IF CAN-DO("InstanceId,Order":U, hBufferField:NAME) THEN
            NEXT.
        
        /* Is it on the cached object record? If so, use this value.
         */         
        ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), bCache.AttrOrdinals).
        IF iAttributeEntry GT 0 THEN
        do:
            ASSIGN cPropertyNames   = cPropertyNames + ",":U + hBufferField:NAME
                   pcPropertyValues = pcPropertyValues + {&Value-Delimiter} 
                                    + ENTRY(iAttributeEntry, bCache.AttrValues, {&Value-Delimiter}).
            case hBufferField:name:
                when 'SuperProcedure' then lHasSuperProcedure = yes.
                when 'SuperProcedureMode' then lHasSuperProcMode = yes.
            end case.    /* property name */
        end.    /* stored on object */
        ELSE
        /* If there is a entity buffer available, check whether we can get the value off
           the associated table.
         */
        IF AVAILABLE bEntity AND CAN-DO("{&DF-MASTER-ENTITY-ATTRS}":U, hBufferField:NAME) THEN
        DO:
            ASSIGN cPropertyNames = cPropertyNames + ",":U + hBufferField:NAME
                   hEntityField   = ?
                   hEntityField   = bEntity.EntityBufferHandle:BUFFER-FIELD(cFieldName)
                   NO-ERROR.
                   
            IF NOT VALID-HANDLE(hEntityField) THEN
                RETURN ERROR {aferrortxt.i 'AF' '11' '?' '?' "bCache.ObjectName + ' entity field'" "'for the ' + pcObjectName + ' object'" }.
            
             CASE hBufferField:NAME:
                 WHEN "FORMAT":U THEN
                 DO:                
                     ASSIGN cFormat          = hEntityField:format
                            pcPropertyValues = pcPropertyValues + {&Value-Delimiter}
                                             + (IF cFormat EQ ? THEN "?":U ELSE cFormat).
                 end. /* format */
                 WHEN "DATA-TYPE":U THEN
                     ASSIGN pcPropertyValues = pcPropertyValues + {&Value-Delimiter} + hEntityField:DATA-TYPE.
                 WHEN "DefaultValue":U THEN
                 DO:
                    /* If the date-format or numeric-format is non-matching with
                      what the entity is created with the INITIAL returns wrong 
                      values (it cannot even be referenced if it is a date) */
                   cInitial = hEntityField:INITIAL NO-ERROR.
                   IF cInitial > '':U THEN
                       cInitial = {fnarg entityDefaultValue hEntityField}.
                  
                   ASSIGN pcPropertyValues = pcPropertyValues + {&Value-Delimiter} 
                                           + (IF cInitial = ? THEN '?' ELSE cInitial).
                 END.
                 WHEN "LABEL":U THEN
                     ASSIGN pcPropertyValues = pcPropertyValues + {&Value-Delimiter} 
                                             + (IF hEntityField:LABEL EQ ? THEN "?":U ELSE STRING(hEntityField:LABEL)).
                 WHEN "ColumnLabel":U THEN
                     ASSIGN pcPropertyValues = pcPropertyValues + {&Value-Delimiter} 
                                             + (IF hEntityField:COLUMN-LABEL EQ ? THEN "?":U ELSE STRING(hEntityField:COLUMN-LABEL)).
             END CASE.    /* hBufferField:NAME */
        END.    /* on entity */
        ELSE
            /* Use the class value.
             */
            ASSIGN cPropertyNames   = cPropertyNames + ",":U + hBufferField:NAME
                   pcPropertyValues = pcPropertyValues + {&Value-Delimiter}
                                    + (IF hBufferField:BUFFER-VALUE EQ ? THEN "?":U ELSE hBufferField:BUFFER-VALUE).
    END.    /* loop through requested fields */
    
    /* Make sure that, if there is a SuperProcedure, that the
       value of the SuperProcedureMode is set. If it is blank
       or not set yet, then default to 'Stateful' since this is
       the historical default.
     */
    iAttributeEntry = lookup('SuperProcedure', cPropertyNames).
    if iAttributeEntry gt 0 then
    do:
        /* Don't return the class values.
           Only need to set the SuperProcedure value since
           without this the SuperProcedureMode will be ignored.
         */
        if not lHasSuperProcedure then
            entry(iAttributeEntry, pcPropertyValues, {&Value-Delimiter}) = ''.
        else
        do:
            iAttributeEntry = lookup('SuperProcedureMode', cPropertyNames).
            /* No value in the list. */
            if iAttributeEntry eq 0 then                
                assign cPropertyNames = cPropertyNames + ',SuperProcedureMode'
                       pcPropertyValues = pcPropertyValues + {&Value-Delimiter} + 'Stateful'.
            else
            /* Value must be one of Stateful or Stateless. */
            if not lHasSuperProcMode then
                entry(iAttributeEntry, pcPropertyValues, {&Value-Delimiter}) = 'Stateful'.
        end.    /* the object has a super procedure */
    end.    /* SuperProcedure requested. */
    
    /* Clean up. */
    hClassBuffer:BUFFER-DELETE().
    delete object hClassBuffer no-error.
    
    ASSIGN hClassBuffer       = ?
           pcPropertyValues   = SUBSTRING(pcPropertyValues, 2)
           pcPropertyNames    = LEFT-TRIM(cPropertyNames, ",":U)
           ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.    /* getInstanceProperties */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getObjectData Procedure 
PROCEDURE getObjectData :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Retrieves the meta-information about an object - pages, links, etc.
  
  Parameters:  pdContainerSmartObjectObj - The unique ID of the container, as per the
                                           Repository DB. This is used to retrieve the
                                           links, pages, etc (all container information).
               pdContainerInstanceId     - The cacheObject temp-table unique identifier
                                           for the container object.
               pcPageZeroLayoutCode      - The layout code of the container.
  Notes:       * Gets all links for the specified object only when page zero is
                 retrieved.
               * This API is a server-side-only API.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdContainerSmartObjectObj        AS DECIMAL      NO-UNDO.
    DEFINE INPUT PARAMETER pdContainerInstanceId            AS DECIMAL      NO-UNDO.
    DEFINE INPUT PARAMETER pcPageZeroLayoutCode             AS CHARACTER    NO-UNDO.
                            
    &IF DEFINED(Server-Side) NE 0 &THEN
    DEFINE VARIABLE iAttributeEntry         AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE cSourceInstanceName     AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cTargetInstanceName     AS CHARACTER                    NO-UNDO.
    
    define buffer ryc_object_instance   for ryc_object_instance.
    define buffer ryc_layout            for ryc_layout.
    define buffer ryc_smartlink         for ryc_smartlink.
       
    DEFINE BUFFER source_rycoi      FOR ryc_object_instance.
    DEFINE BUFFER target_rycoi      FOR ryc_object_instance.
    DEFINE BUFFER source_page       FOR ryc_page.
    DEFINE BUFFER target_page       FOR ryc_page.
    DEFINE BUFFER ryc_page          FOR ryc_page.    
    DEFINE BUFFER cachePage         FOR cachePage.
    DEFINE BUFFER sourcePage        FOR cachePage.
    DEFINE BUFFER targetPage        FOR cachePage.
    define buffer instancePage      for cachePage.
        
    /* Create a pseudo-page record for page zero. */
    FIND FIRST cachePage WHERE
               cachePage.InstanceId = pdContainerInstanceId AND
               cachePage.PageNumber = 0
               NO-ERROR.
    IF NOT AVAILABLE cachePage THEN
    DO:
        CREATE cachePage.
        ASSIGN cachePage.InstanceId    = pdContainerInstanceId
               cachePage.PageNumber    = 0
               cachePage.PageLabel     = "Page Zero"
               cachePage.LayoutCode    = pcPageZeroLayoutCode.
    END.    /* n/a page object */
    
    /* Build a list of all the instances on this page.
       Make sure that we don't include an object instance more than
       once. This might happen if an instance is moved as a result of
       customisation.
       
       We must check the TOC field of the cachePage record because there
       is no guarantee that this call is even retrieving any instances; 
       this means that we cannot check the cacheObject records.
     */
    FOR EACH ryc_object_instance WHERE
             ryc_object_instance.container_smartobject_obj = pdContainerSmartObjectObj AND
             ryc_object_instance.page_obj                  = 0
             NO-LOCK
             BY ryc_object_instance.object_sequence:
        
        IF NOT CAN-DO(cachePage.TOC, ryc_object_instance.instance_name) and
           not can-find( first instancePage where
                               instancePage.InstanceId = pdContainerInstanceId and
                               can-do(instancePage.TOC, ryc_object_instance.instance_name) ) then
            ASSIGN cachePage.TOC = cachePage.TOC + ",":U + ryc_object_instance.instance_name.
    END.    /* all contained instances */
    ASSIGN cachePage.TOC = LEFT-TRIM(cachePage.TOC, ",":U).
    
    /* Create page records for all pages. */
    FOR EACH ryc_page WHERE
             ryc_page.container_smartobject_obj = pdContainerSmartObjectObj
             NO-LOCK:
        FIND FIRST cachePage WHERE
                   cachePage.InstanceId    = pdContainerInstanceId   AND
                   cachePage.PageReference = ryc_page.page_reference
                   NO-ERROR.
        IF NOT AVAILABLE cachePage THEN
        DO:
            FIND FIRST ryc_layout WHERE
                       ryc_layout.layout_obj = ryc_page.layout_obj
                       NO-LOCK NO-ERROR.
            CREATE cachePage.
            ASSIGN cachePage.InstanceId    = pdContainerInstanceId
                   cachePage.PageNumber    = ryc_page.page_sequence
                   cachePage.PageReference = ryc_page.page_reference
                   cachePage.PageLabel     = ryc_page.page_label
                   cachePage.LayoutCode    = (IF AVAILABLE ryc_layout THEN ryc_layout.layout_code ELSE "00":U)
                   cachePage.SecurityToken = ryc_page.security_token.
        END.    /* n/a page object */
        
        /* Make sure that the instances are recorded on the page record.
           However, also make sure that an instance doesn't appear on more than
           one page.
         */
        FOR EACH ryc_object_instance WHERE
                 ryc_object_instance.container_smartobject_obj = pdContainerSmartObjectObj AND
                 ryc_object_instance.page_obj                  = ryc_page.page_obj
                 NO-LOCK
                 BY ryc_object_instance.object_sequence:
            IF NOT CAN-DO(cachePage.TOC, ryc_object_instance.instance_name) and
               not can-find(first instancePage where
                                  instancePage.InstanceId = pdContainerInstanceId and
                                  can-do(instancePage.TOC, ryc_object_instance.instance_name) ) then
                ASSIGN cachePage.TOC = cachePage.TOC + ",":U + ryc_object_instance.instance_name.
        END.    /* all contained instances */
        ASSIGN cachePage.TOC = LEFT-TRIM(cachePage.TOC, ",":U).
    END.    /* each page of this object. */
    
    /* Get all links when page zero is retrieved. */
    FOR EACH ryc_smartLink WHERE
             ryc_smartlink.container_smartobject_obj = pdContainerSmartObjectObj
             NO-LOCK:
        /* Find the linked instances. These will not always be here because we
         * may link an instance to the container itself.
         */
        FIND FIRST source_rycoi WHERE
                   source_rycoi.object_instance_obj = ryc_smartlink.source_object_instance_obj
                   NO-LOCK NO-ERROR.
        ASSIGN cSourceInstanceName = (IF AVAILABLE source_rycoi THEN source_rycoi.instance_name ELSE "THIS-OBJECT":U).

        FIND FIRST target_rycoi WHERE
                   target_rycoi.object_instance_obj = ryc_smartlink.target_object_instance_obj
                   NO-LOCK NO-ERROR.
        ASSIGN cTargetInstanceName = (IF AVAILABLE target_rycoi THEN target_rycoi.instance_name ELSE "THIS-OBJECT":U).
        
        IF NOT CAN-FIND(FIRST cacheLink WHERE            
                              cacheLink.InstanceId         = pdContainerInstanceId AND
                              cacheLink.SourceInstanceName = cSourceInstanceName   AND                     
                              cacheLink.TargetInstanceName = cTargetInstanceName   AND
                              cacheLink.LinkName           = ryc_smartLink.link_name   ) THEN
        DO:
            /* Get the page numbers. With customisation, the page number
               on the ryc_page record may not be the actual page number on the
               object; we need to find out which page contains the object instance.
               We need to look at the cachePage's TOC field to determine this, 
               since the link may be on the uncustomised record, and so the object
               instance that the link points to may have moved.               
             */
            CREATE cacheLink.
            ASSIGN cacheLink.InstanceId         = pdContainerInstanceId
                   cacheLink.SourceInstanceName = cSourceInstanceName
                   cacheLink.TargetInstanceName = cTargetInstanceName
                   cacheLink.LinkName           = ryc_smartLink.link_name
                   .
            find first instancePage where
                       instancePage.InstanceId = pdContainerInstanceId and
                       can-do(instancePage.TOC, cSourceInstanceName)
                       no-error.
            if available instancePage then
                assign cacheLink.SourcePage = instancePage.PageNumber.
            
            find first instancePage where
                       instancePage.InstanceId = pdContainerInstanceId and
                       can-do(instancePage.TOC, cTargetInstanceName)
                       no-error.
            if available instancePage then
                assign cacheLink.TargetPage = instancePage.PageNumber.
        END.    /* no link record available */
    END.    /* each link for the container */
    &ENDIF
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* getObjectData */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getObjectNames Procedure 
PROCEDURE getObjectNames :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC     
  Purpose:     Resolves a logical object or physical object name into logical and
               physical parts.
  Parameters:  pcObjectName   -
               pcRunAttribute -
               pcPhysicalName -
               pcLogicalName  -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcObjectName            AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcRunAttribute          AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcPhysicalName          AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcLogicalName           AS CHARACTER        NO-UNDO.

    DEFINE VARIABLE cRootFileExt            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cRootFile               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hBufferField            AS HANDLE     NO-UNDO.
    DEFINE VARIABLE iAttributeEntry         AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cThinRenderingProcedure AS CHARACTER  NO-UNDO.   
        
    DEFINE BUFFER bCache        FOR cacheObject.

    /* Remove any path information from the inputted name. */
    RUN extractRootFile IN TARGET-PROCEDURE (INPUT pcObjectName, OUTPUT cRootFile, OUTPUT cRootFileExt) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).    
        
    /* Get the object name (i.e. with or without the extension, whatever is needed to retrieve the object */
    ASSIGN cRootFileExt = (IF cRootFileExt = "":U THEN cRootFile    ELSE cRootFileExt)
           pcObjectName = (IF cRootFileExt = "":U THEN pcObjectName ELSE cRootFileExt).
    
    /* Retrieve the object from the Repository */
    FIND bCache WHERE
         bCache.InstanceId = DECIMAL(pcObjectName)
         NO-ERROR.
         
    IF NOT AVAILABLE bCache THEN
        FIND bCache WHERE 
             bCache.ObjectName          = pcObjectName AND
             bCache.ContainerInstanceId = 0
             NO-ERROR.
    
    IF NOT AVAILABLE bCache THEN
        FIND FIRST bCache WHERE 
                   bCache.ObjectName = pcObjectName 
                   NO-ERROR.
                   
    IF NOT AVAILABLE bCache THEN
    DO:
       RUN cacheRepositoryObject ( INPUT pcObjectName,
                                   INPUT "":U, /* pcInstanceName */
                                   INPUT pcRunAttribute,
                                   INPUT ?             /* pcResultCode */ ) NO-ERROR.
       IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
       
       FIND bCache WHERE
            bCache.ObjectName          = pcObjectName AND
            bCache.ContainerInstanceId = 0
            NO-ERROR.       
    END.    /* n/a bCache */
    
    IF AVAILABLE bCache THEN
    DO:
        FIND FIRST ttClass WHERE ttClass.ClassName = bCache.ClassName NO-ERROR.
        IF NOT AVAILABLE ttClass THEN
        DO:
            RUN createClassCache ( INPUT bCache.ClassName ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
            
            FIND FIRST ttClass WHERE ttClass.ClassName = bCache.ClassName NO-ERROR.            
        END.    /* n/a ttClass */
        
        IF NOT AVAILABLE ttClass THEN
            RETURN {aferrortxt.i 'AF' '15' '?' '?' "'the class for ' + pcObjectName + ' could not be found.'"}.
               
        ASSIGN 
          hBufferField = ?
          cThinRenderingProcedure = "":U.
        IF glUseThinRendering THEN
        DO:
          ASSIGN hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("ThinRenderingProcedure":U) NO-ERROR.
          IF VALID-HANDLE(hBufferField) THEN
          DO:
            ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), bCache.AttrOrdinals).
            IF iAttributeEntry EQ 0 THEN
              ASSIGN cThinRenderingProcedure = hBufferField:INITIAL.
            ELSE
              ASSIGN cThinRenderingProcedure = ENTRY(iAttributeEntry, bCache.AttrValues, {&Value-Delimiter}).
          END.  /* if valid buffer field */
        END.  /* if use thin rendering */
        /* If thin redering is not being used or it is being used and a thin rendering procedure
           has not been set then rendering procedure should be used. */
        IF NOT VALID-HANDLE(hBufferField) OR cThinRenderingProcedure = "":U THEN
          ASSIGN hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("RenderingProcedure":U) NO-ERROR.
        
        IF NOT VALID-HANDLE(hBufferField) THEN
            ASSIGN hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("PhysicalObjectName":U) NO-ERROR.
        
        /* We can do nothing without a rendering procedure. */
        IF NOT VALID-HANDLE(hBufferField) THEN
            RETURN {aferrortxt.i 'AF' '15' '?' '?' "'the rendering procedure for ' + pcObjectName + ' could not be found.'"}.
        
        ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), bCache.AttrOrdinals).
        IF iAttributeEntry EQ 0 THEN
            ASSIGN pcPhysicalName = hBufferField:INITIAL.
        ELSE
            ASSIGN pcPhysicalName = ENTRY(iAttributeEntry, bCache.AttrValues, {&Value-Delimiter}).
        
        ASSIGN pcLogicalName  = bCache.ObjectName.
    END.    /* bCache found */
    ELSE
        RETURN {aferrortxt.i 'AF' '15' '?' '?' "'the cache entry for ' + pcObjectName + ' could not be found.'"}.
        
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* getObjectNames */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectSuperProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getObjectSuperProcedure Procedure 
PROCEDURE getObjectSuperProcedure :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Returns an objects custom super procedure to a caller.
  Parameters:  pcObjectName      - the object name
               pcRunAttribute    - the run attribute for this object.
               pcCustomSuperProc - the name of the cusstom super procedure
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcObjectName        AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcRunAttribute      AS CHARACTER            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcCustomSuperProc   AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE cRootFileExt        AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cRootFile           AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE hBufferField        AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE iAttributeEntry     AS INTEGER                      NO-UNDO.
    
    DEFINE BUFFER bCache    FOR cacheObject.
    
    /* Remove any path information from the inputted name. */
    RUN extractRootFile IN TARGET-PROCEDURE (INPUT pcObjectName, OUTPUT cRootFile, OUTPUT cRootFileExt) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).    
        
    /* Get the object name (i.e. with or without the extension, whatever is needed to retrieve the object */
    ASSIGN cRootFileExt = (IF cRootFileExt = "":U THEN cRootFile    ELSE cRootFileExt)
           pcObjectName = (IF cRootFileExt = "":U THEN pcObjectName ELSE cRootFileExt).
           
    /* Retrieve the object from the Repository */
    FIND bCache WHERE
         bCache.InstanceId = DECIMAL(pcObjectName)
         NO-ERROR.
    
    IF NOT AVAILABLE bCache THEN
        FIND bCache WHERE 
             bCache.ObjectName          = pcObjectName AND
             bCache.ContainerInstanceId = 0
             NO-ERROR.
    
    IF NOT AVAILABLE bCache THEN
        FIND FIRST bCache WHERE 
                   bCache.ObjectName = pcObjectName 
                   NO-ERROR.
                   
    IF NOT AVAILABLE bCache THEN    
    DO:
        RUN cacheRepositoryObject ( INPUT pcObjectName,
                                    INPUT "":U, /* pcInstanceName */
                                    INPUT pcRunAttribute,
                                    INPUT ?             /* pcResultCode */ ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
            RETURN (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
        
        FIND bCache WHERE
             bCache.ObjectName          = pcObjectName AND
             bCache.ContainerInstanceId = 0
             NO-ERROR.
    END.    /* n/a bCache */
    
    IF AVAILABLE bCache THEN
    DO:
        FIND FIRST ttClass WHERE ttClass.ClassName = bCache.ClassName NO-ERROR.            
        IF NOT AVAILABLE ttClass THEN
        DO:
            RUN createClassCache ( INPUT bCache.ClassName ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
                                    
            FIND FIRST ttClass WHERE ttClass.ClassName = bCache.ClassName NO-ERROR.            
        END.    /* n/a ttClass */
        
        IF NOT AVAILABLE ttClass THEN
                RETURN {aferrortxt.i 'AF' '15' '?' '?' "'the class for ' + pcObjectName + ' could not be found.'"}.
        
        ASSIGN hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("SuperProcedure":U) NO-ERROR.
        
        IF VALID-HANDLE(hBufferField) THEN
        DO:
            ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), bCache.AttrOrdinals).
            /* Supers are only valid at master/instance level, not class. Class supers 
             * are started elsewhere.
             */
            IF iAttributeEntry NE 0 THEN
                ASSIGN pcCustomSuperProc = ENTRY(iAttributeEntry, bCache.AttrValues, {&Value-Delimiter}).
        END.    /* There are super procedures */
    END.    /* bCache found */
    ELSE
        RETURN {aferrortxt.i 'AF' '15' '?' '?' "'the cache entry for ' + pcObjectName + ' could not be found.'"}.
        
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* getObjectSuperProcedure */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarBandActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getToolbarBandActions Procedure 
PROCEDURE getToolbarBandActions :
/*------------------------------------------------------------------------------
  Purpose:     To return temp-tables of selected bands / actions to caller.
  Parameters:  input comma delimited list of band names
               output temp-table of bands selcted
               output temp-table of actions selected.
  Notes:       These band actions are not cached into a temp-table here as
               they are cached in the toolbar super procedure
               toolbarcustom.p for the current session anyway.
               
               The cacheToolbar property read from the SessionManager is
               essentially set from the Container Builder just for the process
               of launching a container that might have a different result code.
               In this case, the toolbar and its menu structures need to be
               removed from the cache, so that it can be rebuilt correctly
               as for the customized container. If the cacheToolbar property
               does not exist / has not been specified, the system will operate
               as normal. If any other tool requires a fresh version of a toolbar,
               the cacheToolbar property must be set to 'no'.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  pcToolbar               AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectList            AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcBandList              AS CHARACTER  NO-UNDO.

DEFINE OUTPUT PARAMETER TABLE FOR ttToolbarBand.
DEFINE OUTPUT PARAMETER TABLE FOR ttObjectBand.
DEFINE OUTPUT PARAMETER TABLE FOR ttBand.
DEFINE OUTPUT PARAMETER TABLE FOR ttBandAction.
DEFINE OUTPUT PARAMETER TABLE FOR ttAction.
DEFINE OUTPUT PARAMETER TABLE FOR ttCategory.

DEFINE VARIABLE dUserObj                        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dOrganisationObj                AS DECIMAL    NO-UNDO.

/* Get the current user and organisation */
ASSIGN dUserObj         = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,INPUT "currentUserObj":U,INPUT NO))
       dOrganisationObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,INPUT "currentOrganisationObj":U,INPUT NO)).

IF NOT TRANSACTION 
THEN DO:
    EMPTY TEMP-TABLE ttToolbarBand.
    EMPTY TEMP-TABLE ttObjectBand.
    EMPTY TEMP-TABLE ttBand.
    EMPTY TEMP-TABLE ttBandAction.
    EMPTY TEMP-TABLE ttAction.
    EMPTY TEMP-TABLE ttCategory.
END.
ELSE DO:
    FOR EACH ttToolbarBand: DELETE ttToolbarBand. END.
    FOR EACH ttObjectBand:  DELETE ttObjectBand.  END.
    FOR EACH ttBand:        DELETE ttBand.        END.
    FOR EACH ttBandAction:  DELETE ttBandAction.  END.
    FOR EACH ttAction:      DELETE ttAction.      END.
    FOR EACH ttCategory:    DELETE ttCategory.    END.
END.

&IF DEFINED(server-side) <> 0 &THEN
  RUN rygetmensp IN TARGET-PROCEDURE (INPUT pcToolbar,
                                      INPUT pcObjectList,
                                      INPUT pcBandList, 
                                      INPUT dUserObj,
                                      INPUT dOrganisationObj,
                                      OUTPUT TABLE ttToolbarBand,
                                      OUTPUT TABLE ttObjectBand,
                                      OUTPUT TABLE ttBand,
                                      OUTPUT TABLE ttBandAction,
                                      OUTPUT TABLE ttAction,
                                      OUTPUT TABLE ttCategory).  
&ELSE
  RUN ry/app/rygetmensp.p ON gshAstraAppserver (INPUT pcToolbar,
                                                INPUT pcObjectList,
                                                INPUT pcBandList, 
                                                INPUT dUserObj,
                                                INPUT dOrganisationObj,
                                                OUTPUT TABLE ttToolbarBand,
                                                OUTPUT TABLE ttObjectBand,
                                                OUTPUT TABLE ttBand,
                                                OUTPUT TABLE ttBandAction,
                                                OUTPUT TABLE ttAction,
                                                OUTPUT TABLE ttCategory).
&ENDIF

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ICFCFM_StartSessionShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ICFCFM_StartSessionShutdown Procedure 
PROCEDURE ICFCFM_StartSessionShutdown :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     This procedure deals with capture of the event ICFCFM_StartSessionShutdown.
               Based on the session property auto_dump_entity_cache, this procedure 
               will invoke the saveEntitiesClientCache procedure which will
               save the entities to the disk. Thsi will allow the entities to 
               be loaded from the disk on subsequent logins.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cStatus     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDumpEntity AS CHARACTER NO-UNDO.

  /* First check if the entities need to be dumped to disk - By default we do 
     want to dump entities unless specified */
  ASSIGN cDumpEntity = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                                  INPUT "auto_dump_entity_cache":U ) NO-ERROR.
                                                  
  IF ( cDumpEntity = ? OR cDumpEntity = "":U OR ERROR-STATUS:ERROR ) THEN
    ASSIGN ERROR-STATUS:ERROR = NO 
           cDumpEntity        = "NO".
    
  /* Save the cached entities to the disk only if auto_dump_entity_cache is YES or TRUE */
  
  IF LOOKUP(cDumpEntity, "yes,true") > 0 THEN
    RUN saveEntitiesToClientCache IN TARGET-PROCEDURE (INPUT "", INPUT "", OUTPUT cStatus).
    
        
  /* Clear the class cache to avoid memory leaks. */
  RUN destroyClassCache IN TARGET-PROCEDURE.
        
  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN.
END PROCEDURE.  /* ICFCFM_SessionShutdown */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Run on close of procedure
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iQueryLoop              AS INTEGER                  NO-UNDO.

    DO iQueryLoop = 1 TO EXTENT(ghQuery):
        DELETE OBJECT ghQuery[iQueryLoop] NO-ERROR.
        ASSIGN ghQuery[iQueryLoop] = ?.
    END.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* plipShutdown */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-putObjectInCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE putObjectInCache Procedure 
PROCEDURE putObjectInCache :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Puts objects from one buffer into the cache.
  Parameters:  phSourceObject       - }
               phSourcePage         - } these buffers corespond to the cache_Object*
               phSourcePageInstance - } buffers. This includes the build_Object*
               phSourceLink         - } buffers since they are defined LIKE the 
               phSourceUiEvent      - } cache_Object* buffers.
               pcAttributeTableNames    - CSV list containing the source table names
               pcAttributeBufferHandles - and the associated buffer handles.
  
  Notes:       * Thie procedure is private and should only be run from doServerRetrieval
                 and ry/app/ryretrobjp.p
               * The existing entries in the cache are checked so that records are not
                 duplicated.
                 
*** THIS API HAS BEEN DEPRECATED ***
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER phSourceObject           AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER phSourcePage             AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER phSourcePageInstance     AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER phSourceLink             AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER phSourceUiEvent          AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER pcAttributeTableNames    AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcAttributeBufferHandles AS CHARACTER            NO-UNDO.  
        
        RETURN ERROR "*** THIS API HAS BEEN DEPRECATED ***".

END PROCEDURE.  /* putObjectInCache */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-receiveCacheClass) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveCacheClass Procedure 
PROCEDURE receiveCacheClass :
/*------------------------------------------------------------------------------
  Purpose:     When running Appserver, all cache needed for startup is cached in
               one Appserver hit.  As the managers need it, they request it from
               the cache PLIPP.  In this case, the class cache has been
               requested, note that the manager is empty of ANY cache at this stage.
  Parameters:  <none>
  Notes:       
*** THIS API HAS BEEN DEPRECATED ***                   
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER hBufferCache   AS HANDLE     NO-UNDO.
    DEFINE INPUT  PARAMETER cTableHandles  AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE hClassAttributeTable  AS HANDLE  EXTENT 32   NO-UNDO.
    DEFINE VARIABLE hClassAttributeBuffer AS HANDLE              NO-UNDO.
    DEFINE VARIABLE hTable                AS HANDLE              NO-UNDO.
    DEFINE VARIABLE iExtentLoop           AS INTEGER             NO-UNDO.
    DEFINE VARIABLE cClassName            AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE hCacheUiEvent         AS HANDLE              NO-UNDO.
    DEFINE VARIABLE hQuery                AS HANDLE              NO-UNDO.
    DEFINE VARIABLE hBuffer               AS HANDLE              NO-UNDO.
    DEFINE VARIABLE hClassUiEventTable    AS HANDLE              NO-UNDO.
    
/** DEPRECATE??    
    /* Move the class table-handles into the hClassAttributeTable extents */
    do-blk:
    DO iExtentLoop = 1 TO NUM-ENTRIES(cTableHandles, CHR(3)):
        ASSIGN hTable = WIDGET-HANDLE(ENTRY(iExtentLoop, cTableHandles, CHR(3))) NO-ERROR.

        IF NOT VALID-HANDLE(hTable) THEN
            NEXT do-blk.

        IF hTable:NAME <> "cache_objectUIEvent":U THEN
            ASSIGN hClassAttributeTable[iExtentLoop] = hTable.
        ELSE
            ASSIGN hClassUiEventTable = hTable.
    END.

    /* We have retrieved data across an AppServer connection, now update the ttClass table */

    do-blk:
    DO iExtentLoop = 1 TO EXTENT(hClassAttributeTable) WHILE VALID-HANDLE(hClassAttributeTable[iExtentLoop]):

        IF NOT VALID-HANDLE(hClassAttributeTable[iExtentLoop]) THEN
            NEXT do-blk.

        ASSIGN cClassName = hClassAttributeTable[iExtentLoop]:NAME.
        FIND FIRST ttClass WHERE
                   ttClass.ClassTableName = cClassName
                   NO-ERROR.

        ASSIGN hClassAttributeBuffer = hClassAttributeTable[iExtentLoop]:DEFAULT-BUFFER-HANDLE.

        IF NOT AVAILABLE ttClass THEN
        DO:
            CREATE ttClass.
            ASSIGN ttClass.ClassTableName      = hClassAttributeTable[iExtentLoop]:NAME                   
                   ttClass.InheritsFromClasses = TRIM(hClassAttributeBuffer:BUFFER-FIELD("tInheritsFromClasses":U):INITIAL)
                   ttClass.ClassName           = ENTRY(1, ttClass.InheritsFromClasses)                   
                   ttClass.SuperProcedures     = TRIM(hClassAttributeBuffer:BUFFER-FIELD("tSuperProcedures":U):INITIAL)
                   ttClass.SuperProcedureModes = TRIM(hClassAttributeBuffer:BUFFER-FIELD("tSuperProcedureModes":U):INITIAL)
                   .
        END.    /* n/a ttClass record. */
        /* Always assign the bufferhandle. */
        ASSIGN ttClass.ClassBufferHandle = hClassAttributeBuffer.
    END.    /* loop through extents */

    /* Update the cache_ObjectUIEvent TT */
    ASSIGN hCacheUiEvent = BUFFER cache_ObjectUiEvent:HANDLE.

    CREATE WIDGET-POOL "RetrieveClassCache(server)":U.
    CREATE QUERY hQuery IN WIDGET-POOL "RetrieveClassCache(server)":U.
    CREATE BUFFER hBuffer FOR TABLE hClassUiEventTable:DEFAULT-BUFFER-HANDLE IN WIDGET-POOL "RetrieveClassCache(server)":U.

    hQuery:ADD-BUFFER(hBuffer).
    hQuery:QUERY-PREPARE(" FOR EACH ":U + hBuffer:NAME + " ":U).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().
    DO WHILE hBuffer:AVAILABLE:
        hCacheUiEvent:FIND-FIRST(" WHERE ":U
                                 + hCacheUiEvent:NAME + ".tClassName = '" + hBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE + "' AND ":U
                                 + hCacheUiEvent:NAME + ".tRecordIdentifier = 0 ":U ) NO-ERROR.
        IF NOT hCacheUiEvent:AVAILABLE THEN
        DO:
            hCacheUiEvent:BUFFER-CREATE().
            hCacheUIEvent:BUFFER-COPY(hBuffer).
            hCacheUiEvent:BUFFER-RELEASE().
        END.    /* n/a cache ui event */

        hQuery:GET-NEXT().
    END.    /* available buffer */
    hQuery:QUERY-CLOSE().

    DELETE WIDGET-POOL "RetrieveClassCache(server)":U.
        ****/
        
        RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-receiveCacheObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveCacheObject Procedure 
PROCEDURE receiveCacheObject :
/*------------------------------------------------------------------------------
  Purpose:     When the repository cache is supplemented from an external source,
               run this procedure.
  Parameters:  <none>
  Notes:       
*** THIS API HAS BEEN DEPRECATED ***  
------------------------------------------------------------------------------*/

/* Definitions for parameters */

DEFINE VARIABLE hObjectTable            AS HANDLE NO-UNDO.
DEFINE VARIABLE hPageTable              AS HANDLE NO-UNDO.
DEFINE VARIABLE hPageInstanceTable      AS HANDLE NO-UNDO.
DEFINE VARIABLE hLinkTable              AS HANDLE NO-UNDO.
DEFINE VARIABLE hUiEventTable           AS HANDLE NO-UNDO.

DEFINE VARIABLE hClassAttributeTable01 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable02 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable03 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable04 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable05 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable06 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable07 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable08 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable09 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable10 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable11 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable12 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable13 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable14 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable15 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable16 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable17 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable18 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable19 AS HANDLE NO-UNDO.
DEFINE VARIABLE hClassAttributeTable   AS HANDLE NO-UNDO EXTENT 19.

/* Procedure Parameters */

DEFINE INPUT PARAMETER pdUserObj       AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER pcResultCode    AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcRunAttribute  AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pdLanguageObj   AS DECIMAL    NO-UNDO.

DEFINE INPUT PARAMETER TABLE-HANDLE FOR hObjectTable.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hPageTable.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hPageInstanceTable.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hLinkTable.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hUiEventTable.

DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable01.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable02.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable03.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable04.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable05.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable06.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable07.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable08.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable09.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable10.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable11.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable12.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable13.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable14.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable15.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable16.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable17.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable18.
DEFINE INPUT PARAMETER TABLE-HANDLE FOR hClassAttributeTable19.

ASSIGN hClassAttributeTable[01] = hClassAttributeTable01
       hClassAttributeTable[02] = hClassAttributeTable02
       hClassAttributeTable[03] = hClassAttributeTable03
       hClassAttributeTable[04] = hClassAttributeTable04
       hClassAttributeTable[05] = hClassAttributeTable05
       hClassAttributeTable[06] = hClassAttributeTable06
       hClassAttributeTable[07] = hClassAttributeTable07
       hClassAttributeTable[08] = hClassAttributeTable08
       hClassAttributeTable[09] = hClassAttributeTable09
       hClassAttributeTable[10] = hClassAttributeTable10
       hClassAttributeTable[11] = hClassAttributeTable11
       hClassAttributeTable[12] = hClassAttributeTable12
       hClassAttributeTable[13] = hClassAttributeTable13
       hClassAttributeTable[14] = hClassAttributeTable14
       hClassAttributeTable[15] = hClassAttributeTable15
       hClassAttributeTable[16] = hClassAttributeTable16
       hClassAttributeTable[17] = hClassAttributeTable17
       hClassAttributeTable[18] = hClassAttributeTable18
       hClassAttributeTable[19] = hClassAttributeTable19.

/** All of the tables returned by the server need to exist in the ttClass
 *  TT. This code ensures that they are. 
 *  We will make sure that they are populated correctly in putObjectInCache.
 *  ----------------------------------------------------------------------- **/
DEFINE VARIABLE iTableLoop              AS INTEGER    NO-UNDO.
DEFINE VARIABLE hClassAttributeBuffer   AS HANDLE     NO-UNDO.
DEFINE VARIABLE cAttributeTableNames    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeBufferHandles AS CHARACTER  NO-UNDO.

DO iTableLoop = 1 TO EXTENT(hClassAttributeTable):

    IF NOT VALID-HANDLE(hClassAttributeTable[iTableLoop]) THEN
        NEXT.

    ASSIGN hClassAttributeBuffer = hClassAttributeTable[iTableLoop]:DEFAULT-BUFFER-HANDLE.

    FIND FIRST ttClass WHERE ttClass.ClassTableName = hClassAttributeTable[iTableLoop]:NAME NO-ERROR.
    IF NOT AVAILABLE ttClass THEN
    DO:
        /* Create an entry in the ttClass temp-table. The table we have just returned will
         * now be used for all the future attributes of the specified class.
         * The first entry in the InheritsFromClasses field is the class itself.        */
        CREATE ttClass.
        ASSIGN ttClass.ClassTableName      = hClassAttributeTable[iTableLoop]:NAME
               ttClass.ClassBufferHandle   = hClassAttributeBuffer
               ttClass.InheritsFromClasses = hClassAttributeBuffer:BUFFER-FIELD("InheritsFromClasses":U):INITIAL
               ttClass.ClassName           = ENTRY(1, ttClass.InheritsFromClasses)        
               ttClass.SuperProcedures     = TRIM(hClassAttributeBuffer:BUFFER-FIELD("SuperProcedures":U):INITIAL)
               ttClass.SuperProcedureModes = TRIM(hClassAttributeBuffer:BUFFER-FIELD("SuperProcedureModes":U):INITIAL)
               .

    END.    /* n/a ttClass record */

    /* We also store the names and buffer handles of these tables for use by putObjectInCache.
     * We store the value of the buffer as returned by the server call, since this contains
     * the infgormation we want to put into the cache. 
     *
     * We use lists since it is faster and easier to search through a list using a CAN-DO. */
    ASSIGN cAttributeTableNames    = cAttributeTableNames + ttClass.classTableName + ",":U
           cAttributeBufferHandles = cAttributeBufferHandles + STRING(hClassAttributeBuffer) + ",":U
           .
END.    /* loop through attribute tables. */

/* Get rid of the trailing comma. */
ASSIGN cAttributeTableNames    = RIGHT-TRIM(cAttributeTableNames,    ",":U)
       cAttributeBufferHandles = RIGHT-TRIM(cAttributeBufferHandles, ",":U)
       .
/* Now put the objects that we have retrieved into the cache. */
RUN putObjectInCache ( INPUT hObjectTable:DEFAULT-BUFFER-HANDLE,
                       INPUT hPageTable:DEFAULT-BUFFER-HANDLE,
                       INPUT hPageInstanceTable:DEFAULT-BUFFER-HANDLE,
                       INPUT hLinkTable:DEFAULT-BUFFER-HANDLE,
                       INPUT hUiEventTable:DEFAULT-BUFFER-HANDLE,
                       INPUT cAttributeTableNames,
                       INPUT cAttributeBufferHandles                   ) NO-ERROR.
IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

/** Now we must clean up: delete all the TABLE-HANDLES and other dynamic
 *  constructs we have used here.
 *  Only the DEFAULT-BUFFER-HANDLEs are used in this procedure, so
 *  there is no need to delete any buffer handles (the default buffer handles
 *  are deleted when the table is deleted).
 *  ----------------------------------------------------------------------- **/

/* We only delete the tables that have been returned which previously 
 * existed in the ttClass temp-table. We know this because the classBufferHandle
 * will be the same as the DEFAULT-BUFFER-HANDLE of the table. We keep the tables
 * created by this procedure since they will be used to store all future records
 * pertaining to this class.                                                    */
do-blk:
DO iTableLoop = 1 TO EXTENT(hClassAttributeTable):

    IF NOT VALID-HANDLE(hClassAttributeTable[iTableLoop]) THEN
        NEXT do-blk.

    ASSIGN hClassAttributeBuffer = hClassAttributeTable[iTableLoop]:DEFAULT-BUFFER-HANDLE.

    /* At this stage, the ttClass contains all of the tables referred to by the returned
     * table-handles.                                                                   */
    FIND FIRST ttClass WHERE ttClass.ClassTableName = hClassAttributeTable[iTableLoop]:NAME NO-ERROR.
    IF ttClass.classBufferHandle NE hClassAttributeBuffer THEN
    DO:
        /* Delete the returned table. The buffer associated with DEFAULT-BUFFER-HANDLE will 
         * also be deleted.                                                                 */
        DELETE OBJECT hClassAttributeTable[iTableLoop] NO-ERROR.
        ASSIGN hClassAttributeTable[iTableLoop] = ?.
    END.    /* not created by this procedure */
END.    /* loop through class attribute tables */

DELETE OBJECT hObjectTable NO-ERROR.
ASSIGN hObjectTable = ?.

DELETE OBJECT hPageTable NO-ERROR.
ASSIGN hPageTable = ?.

DELETE OBJECT hPageInstanceTable NO-ERROR.
ASSIGN hPageInstanceTable = ?.

DELETE OBJECT hLinkTable NO-ERROR.
ASSIGN hLinkTable = ?.

DELETE OBJECT hUiEventTable NO-ERROR.
ASSIGN hUiEventTable = ?.

/* The attribute tables are cleaned up individually, since some of them may
 * be needed if this is the first time that a class's attributes have been
 * requested.                                                              */
ASSIGN hClassAttributeBuffer = ?
       hClassAttributeTable  = ?
       NO-ERROR.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resolveResultCodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resolveResultCodes Procedure 
PROCEDURE resolveResultCodes :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Resolves the result code string, and ensures that it contains
               valid result codes, including the default result code. 
  Parameters:  pcResultCodes -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER plDesignMode      AS LOGICAL          NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pcResultCodes     AS CHARACTER        NO-UNDO.

    DEFINE VARIABLE cLocalResultCodes           AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cResultCode                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iResultCodeLoop             AS INTEGER              NO-UNDO.

    /** The '*' result code is only allowed in design mode. Runtime must use the 
     * session result codes.
     *  ----------------------------------------------------------------------- **/
    IF NOT plDesignMode AND LOOKUP ("*":U, pcResultCodes) NE 0 THEN
        RETURN ERROR {aferrortxt.i 'AF' '40' '?' '?' '"A result code of * is only allowed when in design mode"'}.
    ELSE
    IF plDesignMode AND LOOKUP ("*":U, pcResultCodes) NE 0 THEN
    DO:
        &IF DEFINED(Server-Side) EQ 0 &THEN
        RUN ry/app/ryreprercp.p ON gshAstraAppServer (INPUT        plDesignMode,
                                                      INPUT-OUTPUT pcResultCodes) NO-ERROR.
        IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        &ELSE        

        DEFINE BUFFER ryc_customization_result      FOR ryc_customization_result.

        IF pcResultCodes EQ "*":U THEN
        FOR EACH ryc_customization_result NO-LOCK:
            ASSIGN cLocalResultCodes = cLocalResultCodes + (IF NUM-ENTRIES(cLocalresultCodes) EQ 0 THEN "":U ELSE ",":U)
                                     + ryc_customization_result.customization_result_code.
        END.    /* customisation results */
    
        ASSIGN pcResultCodes = cLocalResultCodes.
        &ENDIF
    END.        /* Design mode and * in the result code string */

    /* Always make sure that the DEFAULT-RESULT-CODE is part of the result code string. */
    IF NOT CAN-DO(pcResultCodes, "{&DEFAULT-RESULT-CODE}":U) THEN
        ASSIGN pcResultCodes = pcResultCodes + ",{&DEFAULT-RESULT-CODE}":U
               pcResultCodes = LEFT-TRIM(pcResultCodes, ",":U).
    
    /* There should only be one of each result code in the string. */
    ASSIGN cLocalResultCodes = "":U.

    DO iResultCodeLoop = 1 TO NUM-ENTRIES(pcResultCodes):
        ASSIGN cResultCode = ENTRY(iresultCodeLoop, pcResultCodes).
        IF NOT CAN-DO(cLocalResultCodes, cResultCode) THEN
            ASSIGN cLocalResultCodes = cLocalResultCodes + cResultCode + ",":U.
    END.    /* result code loop */
    ASSIGN pcResultCodes = RIGHT-TRIM(cLocalResultCodes, ",":U).

    RETURN.
END PROCEDURE.  /* resolveResultCodes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveClassCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveClassCache Procedure 
PROCEDURE retrieveClassCache :
/*------------------------------------------------------------------------------
  Purpose:     Returns class attribute tables to a caller. 
  Parameters:  pcClassName               - a CSV of class names (object type codes) or *
               phClassUiEventTable       -
               phClassAttributeTable01  ... phClassAttributeTable31
  Notes:       * This procedure is always assumed to run in a DB-aware session.
               * This procedure is called from createClassCache.
****
THIS API IS BEING DEPRECATED.
****               
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcClassName                 AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassUiEventTable.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable01.        DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable02.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable03.        DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable04.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable05.        DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable06.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable07.        DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable08.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable09.        DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable10.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable11.        DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable12.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable13.        DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable14.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable15.        DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable16.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable17.        DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable18.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable19.        DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable20.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable21.        DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable22.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable23.        DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable24.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable25.        DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable26.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable27.        DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable28.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable29.        DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable30.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable31.

        RETURN ERROR "The retrieveClassCache() API is obselete.".
END PROCEDURE.  /* retrieveClassCache */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-returnCacheBuffers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnCacheBuffers Procedure 
PROCEDURE returnCacheBuffers :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Returns the buffer handles of the object cache temp-tables to a 
               caller.
  Parameters:  phObjectBuffer -
               phPageBuffer   -
               phLinkBuffer   -
  Notes:       * This is used by the server-side portion of doObjectRetrieval().
------------------------------------------------------------------------------*/
    define output parameter phObjectBuffer      as handle                no-undo.
    define output parameter phPageBuffer        as handle                no-undo.
    define output parameter phLinkBuffer        as handle                no-undo.
    
    assign phObjectBuffer = buffer cacheObject:handle 
           phPageBuffer   = buffer cachePage:handle
           phLinkBuffer   = buffer cacheLink:handle
           
           error-status:error = no.    
    return.
END PROCEDURE.  /* returnCacheBuffers */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveEntitiesToClientCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveEntitiesToClientCache Procedure 
PROCEDURE saveEntitiesToClientCache :
/*------------------------------------------------------------------------------
  /* PRIVATE */
  Purpose:  Saves the Entities to the disk. If the pcEntities is blank then 
            all the current entities in the memory are saved to the disk.
            This procedure is called from the cache client generation tool as well
            as the session shut down event.
    Notes: pcEntities - a Comma separated list of entities
                      - If the value is blank then all the cuurently cached entities
                        are dumped to the disk.
           pcLanguageList - a Comma separated list of language codes
           pcStatus   - Status of the entity dump process. This mainly required 
                        for the cache client tool.
                        It is not used when pcEntities is blank.
                        
    Important Note: When this API is called from session shutdown(runtime) - The 
    list of entities is blank. If pcEntities is blank then - the memory cache is 
    not cleared (due to additional AppServer hits) so any new changes to the 
    database will not be picked up. Hence for the new  changes to be pickedup, 
    a list of entities needs to be passed to this API.
    
    Note: the entity caches are always dumped to disk with the data in MDY and
          American numeric formats. This is consistent with how the database
          stores initial values.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcEntities     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcLanguageList AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcStatus       AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cError                    AS CHARACTER  NO-UNDO.

  ASSIGN ERROR-STATUS:ERROR = NO
         pcEntities         = TRIM(pcEntities, ",":U).

  /* get the directory where to save the .d - This is not a parameter as 
     the product module is fixed ry-clc and we can find the path from that */
  IF (gcClientCacheDir EQ ? OR gcClientCacheDir EQ "":U) THEN
  DO:  
      RUN getClientCacheDir (INPUT "ry-clc":U, OUTPUT gcClientCacheDir).
      ASSIGN gcClientCacheDir = RIGHT-TRIM(gcClientCacheDir, "/":U).
  END.    /* no client cache directory */
  FILE-INFO:FILENAME = gcClientCacheDir.
  
  IF FILE-INFO:FULL-PATHNAME = ? THEN
  DO:
    IF (pcEntities > '':U) THEN
        pcStatus = pcStatus + CHR(10) + "Could not find the dump directory: " + gcClientCacheDir.
    RETURN ERROR "Error finding valid dump directory: " + gcClientCacheDir.
  END.
  
  IF pcLanguageList = ? OR pcLanguageList = "":U THEN
  DO:
      pcLanguageList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, "CurrentLanguageCode":U, YES).
      IF pcLanguageList = ? OR pcLanguageList = "":U THEN pcLanguageList = "NONE":U.
  END.
  
  /* Now we clear the cache - so that the entity information will be pickedup 
     from the database and not memory  */
  IF (pcEntities > '':U) THEN
      RUN destroyClassCache IN TARGET-PROCEDURE.
  
  cError = dynamic-function('createEntityCacheFile':u in target-procedure,
                             input pcEntities,
                             input pcLanguageList,
                             input gcClientCacheDir,
                             input Yes, /* plDeleteExisting */
                             input-output pcStatus ).
  if cError ne '':u then
      return error cError.
  
  ERROR-STATUS:ERROR = FALSE.
  RETURN.
END PROCEDURE.    /* saveEntitiesToClientCache */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverFetchObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverFetchObject Procedure 
PROCEDURE serverFetchObject :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Server-side object retrieval routine.
  Parameters:  
  Notes:       * Effective 'deep' retrieval - all contained containers and their
                 contained instances are retrieved.
*** THIS API HAS BEEN DEPRECATED ***                 
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcLogicalObjectName         AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pdUserObj                   AS DECIMAL      NO-UNDO.
    DEFINE INPUT  PARAMETER pcResultCode                AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pdLanguageObj               AS DECIMAL      NO-UNDO.
    DEFINE INPUT  PARAMETER pcRunAttribute              AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER plDesignMode                AS LOGICAL      NO-UNDO.

    DEFINE OUTPUT PARAMETER TABLE-HANDLE phObjectTable.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phPageTable.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phPageInstanceTable.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phLinkTable.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phUiEventTable.

    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable01.  DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable02.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable03.  DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable04.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable05.  DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable06.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable07.  DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable08.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable09.  DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable10.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable11.  DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable12.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable13.  DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable14.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable15.  DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable16.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable17.  DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable18.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable19.  DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable20.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable21.  DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable22.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable23.  DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable24.
    DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable25.  DEFINE OUTPUT PARAMETER TABLE-HANDLE phClassAttributeTable26.    

    RETURN ERROR "*** THIS API HAS BEEN DEPRECATED ***".
END PROCEDURE.  /* serverFetchObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startDataObject Procedure 
PROCEDURE startDataObject :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Fetches the specified DataObject from the repository and
               starts the object on the client.
  Parameters:  pcDataObject   Name of Data Object
               OUTPUT phSDO   Handle of started SDO
  Notes:       If the DataObject is a dynamic SDO, the procedure constructs the 
               necessary attributes
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcDataObject          AS CHARACTER          NO-UNDO.
    DEFINE OUTPUT PARAMETER phSDO                 AS HANDLE             NO-UNDO.

    DEFINE VARIABLE hBufferField            AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cSDOFile                AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iAttributeEntry         AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cThinRenderingProcedure AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cServerFileName         AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lGeneratedObject        AS LOGICAL    NO-UNDO. 
    /* the various types */
    DEFINE VARIABLE lSDO                    AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lSBO                    AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lDynSDO                 AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lDynSBO                 AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lDataView               AS LOGICAL    NO-UNDO.
    
    DEFINE BUFFER bCache            FOR cacheObject.
    DEFINE BUFFER bClass            FOR ttClass.
    
    /* Check if this object has a mapped file. */
    cSdoFile = {fnarg getMappedFilename pcDataObject}.
    lGeneratedObject = (cSdoFile ne ?).
        
    if not lGeneratedObject then
    do:
            /* Explicitly set the RunAttribute session parameter to blank. */
            DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE, INPUT "RunAttribute":U, INPUT "":U).
            
            FIND bCache WHERE
                 bCache.InstanceId = DECIMAL(pcDataObject)
                 NO-ERROR.
            IF NOT AVAILABLE bCache THEN         
               FIND bCache WHERE
                    bCache.ObjectName          = pcDataObject AND
                    bCache.ContainerInstanceId = 0
                    NO-ERROR.
            
            IF NOT AVAILABLE bCache THEN
            DO:
               RUN cacheRepositoryObject ( INPUT pcDataObject,
                                           INPUT "":U,
                                           INPUT ?,    /* run attribute */
                                           INPUT "{&DEFAULT-RESULT-CODE}":U ) NO-ERROR.
               IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
                   RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
                
               FIND bCache WHERE
                    bCache.ObjectName          = pcDataObject AND
                    bCache.ContainerInstanceId = 0
                    NO-ERROR.         
            END.    /* bCache */
            
            IF AVAILABLE bCache THEN
            DO:
                /* At this stage there should always be an available bCache record. */
                FIND FIRST bClass WHERE bClass.ClassName = bCache.ClassName NO-ERROR.
                IF NOT AVAILABLE bClass THEN
                DO:
                    RUN createClassCache IN TARGET-PROCEDURE ( bCache.ClassName ) NO-ERROR.
                    /* Show no messages. The calling procedure needs to cater for the fact that
                       no class has been retrieved from the cache.                         */
                    FIND FIRST bClass WHERE bClass.ClassName = bCache.ClassName NO-ERROR.
                    IF NOT AVAILABLE bClass THEN
                        RETURN ERROR {aferrortxt.i 'AF' '5' '?' '?' '"cached class"' "'Class name: ' + bCache.ClassName"}.
                END.      /* n/a cache class */
                
                ASSIGN 
                  hBufferField = ?
                  cThinRenderingProcedure = "":U.
                IF glUseThinRendering THEN
                DO:
                  ASSIGN hBufferField = bClass.ClassBufferHandle:BUFFER-FIELD("ThinRenderingProcedure":U) NO-ERROR.          
                  IF VALID-HANDLE(hBufferField) THEN
                  DO:
                    ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), bCache.AttrOrdinals) NO-ERROR.
                    IF iAttributeEntry EQ 0 THEN
                      ASSIGN cThinRenderingProcedure = hBufferField:INITIAL.
                    ELSE
                      ASSIGN cThinRenderingProcedure = ENTRY(iAttributeEntry, bCache.AttrValues, {&Value-Delimiter}).
                  END.  /* if valid buffer field */
                END.  /* if use thin rendering */
                /* If thin redering is not being used or it is being used and a thin rendering procedure
                   has not been set then rendering procedure should be used. */
                IF NOT VALID-HANDLE(hBufferField) OR cThinRenderingProcedure = "":U THEN
                    ASSIGN hBufferField = bClass.ClassBufferHandle:BUFFER-FIELD("RenderingProcedure":U) NO-ERROR.
        
                IF NOT VALID-HANDLE(hBufferField) THEN
                DO:
                    ASSIGN hBufferField = bClass.ClassBufferHandle:BUFFER-FIELD("PhysicalObjectName":U) NO-ERROR.
                    
                    /* We can do nothing without a rendering procedure. */
                    IF NOT VALID-HANDLE(hBufferField) THEN
                        RETURN ERROR {aferrortxt.i 'AF' '11' '?' '?' '"rendering procedure attribute"' "'data object ' + pcDataObject"}.
                END.    /* no rendering procedure at */
                
                ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), bCache.AttrOrdinals) NO-ERROR.
                IF iAttributeEntry EQ 0 THEN
                    ASSIGN cSDOFile = hBufferField:INITIAL.
                ELSE
                    ASSIGN cSDOFile = ENTRY(iAttributeEntry, bCache.AttrValues, {&Value-Delimiter}).
                
                /* Ensure that there is a valid filename. */
                IF cSdoFile EQ "":U OR cSdoFile EQ ? THEN
                    RETURN ERROR {aferrortxt.i 'AF' '11' '?' '?' '"rendering procedure"' "'data object ' + pcDataObject"}.
                
                /* identify type from bottom up  */
                IF CAN-DO(bClass.InheritsFromClasses, "DynSDO":U)  THEN 
                  lDynSDO = TRUE.
                ELSE IF CAN-DO(bClass.InheritsFromClasses, "SDO":U)  THEN 
                  lSDO = TRUE.
                ELSE IF CAN-DO(bClass.InheritsFromClasses, "DataView":U)  THEN 
                  lDataView = TRUE.
                ELSE IF CAN-DO(bClass.InheritsFromClasses, "SBO":U)  THEN
                  lSBO = TRUE.
                ELSE IF  CAN-DO(bClass.InheritsFromClasses, "DynSBO":U)  THEN 
                  lDynSBO = TRUE.
                ELSE 
                  RETURN ERROR {aferrortxt.i 'AF' '15' '?' '?' "' the data object specified (' + pcDataObject + ') does not inherit from the correct data object class.'"}.
                    
                /* If this is not a dynamic SDO, and we are running client-side, 
                 * then we need to run the _CL proxy. */
                   &IF DEFINED(Server-Side) EQ 0 &THEN
                IF lSDO OR lSBO THEN
                  ASSIGN cSDOFile = ENTRY(1, cSDOFile, ".":U) + "_cl.r":U.
                ELSE IF NOT lDataView THEN
                  cServerFileName = bClass.ClassBufferHandle:BUFFER-FIELD("RenderingProcedure":U):INITIAL NO-ERROR.
                   &ENDIF
        end.    /* can find object in cache */
        ELSE
           RETURN ERROR {aferrortxt.i 'AF' '15' '?' '?' "'the cache entry for ' + pcDataObject + ' could not be found.'"}.
    end.    /* not a generated object */
    
    /* So that prepareInstance knows which logical object is being run. */
    ASSIGN gcCurrentLogicalName = pcDataObject.
    DO ON STOP  UNDO, LEAVE ON ERROR UNDO, LEAVE:
        RUN setReturnValue IN gshSessionManager (INPUT "").
        RUN VALUE(cSDOFile) PERSISTENT SET phSDO NO-ERROR.
    END.    /* SDO run block */

    ASSIGN gcCurrentLogicalName = "":U.

    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U OR NOT VALID-HANDLE(phSDO) THEN
        RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    
    /* We can only know what the class of the generated object is once it is 
       running, so although it's a little late, check that this is a SDO we're 
       dealing with.
     */
    if lGeneratedObject then
    do:
            if not {fnarg instanceOf 'DataQuery' phSdo} and not {fnarg InstanceOf 'SBO' phSdo} then
            do:
                run destroyObject in phSdo no-error.
                if valid-handle(phSdo) then
                    delete object phSdo no-error.
                
                phSdo = ?.
                return error {aferrortxt.i 'AF' '15' '?' '?' "' the data object specified (' + pcDataObject + ') does not inherit from the correct data object class.'"}.
            end.    /* not data object */
     
        &if defined(Server-Side) eq 0 &then
        /* Even for a generated procedure, the RenderingProcedure attribute contains
           the filename of the procedure used to render dynamic obejcts. It is not
           updated to contain the generated procedure name.
         */
        if {fnarg instanceOf 'DynSdo' phSdo} or {fnarg InstanceOf 'DynSbo' phSdo} then
            {get RenderingProcedure cServerFileName phSdo}.
        &endif
    end.    /* this is a generated object */
    
    /* So that the DynSBO know how to get its contents */
    {set LogicalObjectName pcDataObject phSDO}. 
    
    &IF DEFINED(Server-Side) EQ 0 &THEN
    {set AsDivision 'Client':U phSDO}.
    IF cServerFileName > '':U THEN
      {set ServerFileName cServerFileName phSDO}.
    &ENDIF
    
    RUN createObjects IN phSDO NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
        RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.    
END PROCEDURE.  /* startDataObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeAttributeValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE storeAttributeValues Procedure 
PROCEDURE storeAttributeValues :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Stores attribute values.
  Parameters:  INPUT ttAttributeValue
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER phAttributeValueBuffer   AS HANDLE           NO-UNDO.
    DEFINE INPUT PARAMETER TABLE-HANDLE phAttributeValueTable.

    DEFINE VARIABLE cMessageList                AS CHARACTER            NO-UNDO.
    
    &IF DEFINED(Server-Side) EQ 0 &THEN
    {dynlaunch.i
        &PLip  = 'RepositoryManager'
        &IProc = 'storeAttributeValues'
               
        &mode1 = INPUT &parm1 = phAttributeValueBuffer &datatype1 = HANDLE
        &mode2 = INPUT &parm2 = phAttributeValueTable  &datatype2 = TABLE-HANDLE
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN ASSIGN cMessageList = RETURN-VALUE.
    &ELSE
    DEFINE VARIABLE dObjectTypeObj              AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dSmartObjectObj             AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dContainerSmartObjectObj    AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dObjectInstanceObj          AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dAttributeParentObj         AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE lConstantValue              AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE cAttributeParent            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cAttributeLabel             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cAbstractClassNames         AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInheritsFrom               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iQueryOrdinal               AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iClassLoop                  AS INTEGER              NO-UNDO.
    DEFINE VARIABLE hClassCacheBuffer           AS HANDLE               NO-UNDO.

    DEFINE BUFFER ryc_attribute             FOR ryc_attribute.
    DEFINE BUFFER ryc_attribute_value       FOR ryc_attribute_value.
    DEFINE BUFFER rycav_delete              FOR ryc_attribute_value.
    DEFINE BUFFER rycav_constant            FOR ryc_attribute_value.
    DEFINE BUFFER gsc_object_type           FOR gsc_object_type.
    DEFINE BUFFER ryc_smartObject           FOR ryc_smartObject.
    DEFINE BUFFER ryc_object_instance       FOR ryc_object_instance.

    ASSIGN cAbstractClassNames = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                                  INPUT "AbstractClassNames":U ).

    IF VALID-HANDLE(phAttributeValueTable) THEN
        ASSIGN phAttributeValueBuffer = phAttributeValueTable:DEFAULT-BUFFER-HANDLE.

    IF VALID-HANDLE(phAttributeValueBuffer) AND phAttributeValueBuffer:TYPE NE "BUFFER":U THEN
        ASSIGN phAttributeValueBuffer = phAttributeValueBuffer:DEFAULT-BUFFER-HANDLE.

    ASSIGN iQueryOrdinal = DYNAMIC-FUNCTION("getNextQueryOrdinal":U IN TARGET-PROCEDURE).

    IF NOT VALID-HANDLE(ghQuery[iQueryOrdinal]) THEN
        CREATE QUERY ghQuery[iQueryOrdinal].

    ghQuery[iQueryOrdinal]:SET-BUFFERS(phAttributeValueBuffer).

    ghQuery[iQueryOrdinal]:QUERY-PREPARE(" FOR EACH ":U + phAttributeValueBuffer:NAME + " BY ":U +  phAttributeValueBuffer:NAME + ".tAttributeParentObj":U).

    ghQuery[iQueryOrdinal]:QUERY-OPEN().
    ghQuery[iQueryOrdinal]:GET-FIRST().

    STORE-ATTRIBUTE-LOOP:
    DO WHILE phAttributeValueBuffer:AVAILABLE:
        /** Find the attribute's parent record.
         *  ----------------------------------------------------------------------- **/
        IF dAttributeParentObj NE phAttributeValueBuffer:BUFFER-FIELD("tAttributeParentObj":U):BUFFER-VALUE THEN
        DO:
            ASSIGN dAttributeParentObj = phAttributeValueBuffer:BUFFER-FIELD("tAttributeParentObj":U):BUFFER-VALUE
                   cAttributeParent    = phAttributeValueBuffer:BUFFER-FIELD("tAttributeParent":U):BUFFER-VALUE.

            CASE cAttributeParent:
                WHEN "CLASS":U THEN
                DO:
                    FIND FIRST gsc_object_type WHERE
                               gsc_object_type.object_type_obj = dAttributeParentObj
                               NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE gsc_object_type THEN
                    DO:
                        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                            + {aferrortxt.i 'AF' '5' 'gsc_object_type' '?' '"class"' 'STRING(dAttributeParentObj)'}.                       
                        LEAVE STORE-ATTRIBUTE-LOOP.
                    END.     /* error */

                    ASSIGN dObjectTypeObj           = gsc_object_type.object_type_obj
                           dSmartObjectObj          = 0
                           dContainerSmartObjectObj = 0
                           dObjectInstanceObj       = 0.
                END.    /* class */
                WHEN "MASTER":U THEN
                DO:
                    FIND FIRST ryc_smartObject WHERE
                               ryc_smartObject.smartObject_obj = dAttributeParentObj
                               NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE ryc_smartObject THEN
                    DO:
                        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                            + {aferrortxt.i 'AF' '5' 'ryc_smartObject' '?' '"master smartobject"' 'STRING(dAttributeParentObj)'}.                       
                        LEAVE STORE-ATTRIBUTE-LOOP.
                    END.     /* error */

                    ASSIGN dObjectTypeObj           = ryc_smartObject.object_type_obj
                           dSmartObjectObj          = ryc_smartObject.smartObject_obj
                           dContainerSmartObjectObj = 0
                           dObjectInstanceObj       = 0.
                END.    /* master */
                WHEN "INSTANCE":U THEN
                DO:
                    FIND FIRST ryc_object_instance WHERE
                               ryc_object_instance.object_instance_obj = dAttributeParentObj
                               NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE ryc_object_instance THEN
                    DO:
                        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                            + {aferrortxt.i 'AF' '5' 'ryc_object_instance' '?' '"smartobject instance"' 'STRING(dAttributeParentObj)'}.                        
                        LEAVE STORE-ATTRIBUTE-LOOP.
                    END.     /* error */

                    FIND FIRST ryc_smartObject WHERE
                               ryc_smartObject.smartObject_obj = ryc_object_instance.smartObject_obj
                               NO-LOCK NO-ERROR.

                    ASSIGN dObjectTypeObj           = ryc_smartObject.object_type_obj
                           dSmartObjectObj          = ryc_object_instance.smartObject_obj
                           dContainerSmartObjectObj = ryc_object_instance.container_smartObject_obj
                           dObjectInstanceObj       = ryc_object_instance.object_instance_obj.

                    /* Certain classes are not allowed to have attributes stored against any contained
                     * object instances.                                                              
                     *
                     * We don't check the availability for these records since the RI
                     * ensures that there are records avaiable.                       */
                    FIND FIRST ryc_smartObject WHERE
                               ryc_smartObject.smartObject_obj = dContainerSmartObjectObj
                               NO-LOCK.
                    FIND FIRST gsc_object_type WHERE
                               gsc_object_type.object_type_obj = ryc_smartObject.object_type_obj
                               NO-LOCK.
                    ASSIGN hClassCacheBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN TARGET-PROCEDURE,
                                                                INPUT gsc_object_type.object_type_code)
                           cInheritsFrom     = hClassCacheBuffer:BUFFER-FIELD("InheritsFromClasses":U):BUFFER-VALUE.

                    DO iClassLoop = 1 TO NUM-ENTRIES(cAbstractClassNames):
                        IF CAN-DO(cInheritsFrom, ENTRY(iClassLoop, cAbstractClassNames)) THEN
                        DO:
                            ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                                +  {aferrortxt.i 'AF' '36' '?' '?' '"instance attribute values"' '"the container on which the object instance belongs is an abstract class"'}.
                            LEAVE STORE-ATTRIBUTE-LOOP.
                        END.    /* can't store instance values. */
                    END.    /* loop through abstract classes */
                END.    /* instance*/
                OTHERWISE
                DO:
                    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                        +  {aferrortxt.i 'AF' '5' '?' '?' '"attribute parent"' '"The attribute parent must be one of: CLASS, MASTER or INSTANCE."'}.                    
                    LEAVE STORE-ATTRIBUTE-LOOP.
                END.    /* error */
            END CASE.   /* attribute parent */
        END.    /* new parent */

        /** Make sure that we are allowed to update this attribute value.
         *  ----------------------------------------------------------------------- **/
        ASSIGN cAttributeLabel = phAttributeValueBuffer:BUFFER-FIELD("tAttributeLabel":U):BUFFER-VALUE.
        FIND FIRST ryc_attribute WHERE
                   ryc_attribute.attribute_label = cAttributeLabel
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ryc_attribute THEN
        DO:
            ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                +  {aferrortxt.i 'AF' '5' 'ryc_attribute' 'attribute_label' '"attribute label"' "cAttributeLabel" }.            
            LEAVE STORE-ATTRIBUTE-LOOP.
        END.    /* error */

        /* Derived attributes are not stored in the repository at all.
           Runtime attributes are only stored in the repository against
           classes.
           Return gracefully without giving an error.
         */
        IF ryc_attribute.derived_value      OR 
           (ryc_attribute.runtime_only and 
            cAttributeParent ne 'Class'   ) THEN
        DO:
            ghQuery[iQueryOrdinal]:GET-NEXT().
            NEXT STORE-ATTRIBUTE-LOOP.
        END.    /* Derived or Runtime not at class. */
        
        /* The CONSTANT_LEVEL field determines where values can be set for this attribute. */
        CASE ryc_attribute.constant_level:
            WHEN "CLASS":U THEN
                /* If set to 'CLASS', we can only set this attribute at the 'CLASS' level. */
                IF cAttributeParent NE ryc_attribute.constant_level THEN
                DO:
                    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                        +  {aferrortxt.i 'AF' '36' 'ryc_attribute_value' '?' '"attribute values can only be set at the class level"' "'Attribute: ' + cAttributeLabel" }.                    
                    LEAVE STORE-ATTRIBUTE-LOOP.
                END.    /* error */
            WHEN "MASTER":U THEN
                /* If set to 'MASTER', we can not set this attribute at the 'INSTANCE' level. */
                IF cAttributeParent EQ "INSTANCE":U THEN
                DO:
                    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                        +  {aferrortxt.i 'AF' '36' 'ryc_attribute_value' '?' '"attribute values cannot be set at the instance level"' "'Attribute: ' + cAttributeLabel" }.                    
                    LEAVE STORE-ATTRIBUTE-LOOP.
                END.    /* error */
        END CASE. /* constant level */ 

        /* If one of this attribute's parents is flagged as constant, we cannot 
         * update this value.                                                  */
        IF cAttributeParent                                                              EQ "INSTANCE":U AND
           CAN-FIND(FIRST rycav_constant WHERE
                          rycav_constant.object_type_obj           = dObjectTypeObj                AND
                          rycav_constant.smartobject_obj           = dSmartObjectObj               AND
                          rycav_constant.object_instance_obj       = 0                             AND
                          rycav_constant.attribute_label           = ryc_attribute.attribute_label AND
                          rycav_constant.container_smartObject_obj = 0                             AND
                          rycav_constant.constant_value            = YES                              ) THEN
        DO:      
            ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                +  {aferrortxt.i 'AF' '36' 'ryc_attribute_value' '?' '"the instance attribute value"' '"the parent smartobject has its constant value flag set."' }.            
            LEAVE STORE-ATTRIBUTE-LOOP.      
        END.    /* constant at MASTER level.*/

        IF cAttributeParent                                                                NE "CLASS":U AND
            CAN-FIND(FIRST rycav_constant WHERE
                           rycav_constant.object_type_obj           = dObjectTypeObj                AND
                           rycav_constant.smartobject_obj           = 0                             AND
                           rycav_constant.object_instance_obj       = 0                             AND
                           rycav_constant.attribute_label           = ryc_attribute.attribute_label AND
                           rycav_constant.container_smartObject_obj = 0                             AND
                           rycav_constant.constant_value            = YES                              ) THEN
        DO:
            ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                 +  {aferrortxt.i 'AF' '36' 'ryc_attribute_value' '?' '"the master object attribute value"' '"the class has its constant value flag set."' }.            
            LEAVE STORE-ATTRIBUTE-LOOP.      
        END.    /* constant at CLASS level */

        FIND FIRST ryc_attribute_value WHERE
                   ryc_attribute_value.object_type_obj           = dObjectTypeObj               AND
                   ryc_attribute_value.smartObject_obj           = dSmartObjectObj              AND
                   ryc_attribute_value.object_instance_obj       = dObjectInstanceObj           AND
                   ryc_attribute_value.container_smartObject_obj = dContainerSmartObjectObj     AND
                   ryc_attribute_value.attribute_label           = ryc_attribute.attribute_label
                   EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED ryc_attribute_value THEN
        DO:
            ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U)
                                +  {aferrortxt.i 'AF' '103' 'ryc_attribute_value' '?' "'update the attribute value ' + cAttributeLabel " }.            
            LEAVE STORE-ATTRIBUTE-LOOP.
        END.    /* error */

        IF NOT AVAILABLE ryc_attribute_value THEN
        DO:
            CREATE ryc_attribute_value NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
            DO:
                ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U) 
                                    + IF RETURN-VALUE <> "":U THEN RETURN-VALUE ELSE "An error occured while creating attribute value records. Please contact your System Administrator".
                LEAVE STORE-ATTRIBUTE-LOOP.
            END.    /* error */

            ASSIGN ryc_attribute_value.object_type_obj           = dObjectTypeObj
                   ryc_attribute_value.smartObject_obj           = dSmartObjectObj
                   ryc_attribute_value.object_instance_obj       = dObjectInstanceObj
                   ryc_attribute_value.container_smartObject_obj = dContainerSmartObjectObj
                   ryc_attribute_value.attribute_label           = ryc_attribute.attribute_label
                   NO-ERROR.
            /* Validation is done later. */
        END.    /* n/a attribute value */

        CASE ryc_attribute.data_type:
            WHEN {&DECIMAL-DATA-TYPE} THEN ASSIGN ryc_attribute_value.decimal_value   = phAttributeValueBuffer:BUFFER-FIELD("tDecimalValue":U):BUFFER-VALUE NO-ERROR.
            WHEN {&INTEGER-DATA-TYPE} THEN ASSIGN ryc_attribute_value.integer_value   = phAttributeValueBuffer:BUFFER-FIELD("tIntegerValue":U):BUFFER-VALUE NO-ERROR.
            WHEN {&DATE-DATA-TYPE}    THEN ASSIGN ryc_attribute_value.date_value      = phAttributeValueBuffer:BUFFER-FIELD("tDateValue":U):BUFFER-VALUE NO-ERROR.
            WHEN {&RAW-DATA-TYPE}     THEN ASSIGN ryc_attribute_value.raw_value       = phAttributeValueBuffer:BUFFER-FIELD("tRawValue":U):BUFFER-VALUE NO-ERROR.
            WHEN {&LOGICAL-DATA-TYPE} THEN ASSIGN ryc_attribute_value.logical_value   = phAttributeValueBuffer:BUFFER-FIELD("tLogicalValue":U):BUFFER-VALUE NO-ERROR.
            OTHERWISE                      ASSIGN ryc_attribute_value.character_value = phAttributeValueBuffer:BUFFER-FIELD("tCharacterValue":U):BUFFER-VALUE NO-ERROR.
        END CASE.   /* data type */

        /* There is no point in setting the constant_value flag at the instance level,
         * since the instance is the lowest level of inheritance.                     */
        IF cAttributeParent EQ "INSTANCE":U THEN
            ASSIGN ryc_attribute_value.constant_value = NO
                   NO-ERROR.
        ELSE
            ASSIGN lConstantValue                     = ryc_attribute_value.constant_value
                   ryc_attribute_value.constant_value = phAttributeValueBuffer:BUFFER-FIELD("tConstantValue":U):BUFFER-VALUE
                   NO-ERROR.
    
        /* Update the applies_at_runtime flag on the ryc_attribute_value table. The value of this
         * flag is based on the runtime_only and design_only values on the ryc_attribute table.
         * This flag is used for retrieving object master and object instance attributes, so skip
         * updating the flag for classes.
         * Since we have already skipped runtime attributes, we only need worry about design attributes.
         */
        IF cAttributeParent NE "CLASS":U THEN
            ASSIGN ryc_attribute_value.applies_at_runtime = (ryc_attribute.design_only EQ NO) NO-ERROR.
        
        /* Certain classes (DataFields in particular) have special handling of some of their 
         * attributes and the setting of the APPLIES_AT_RUNTIME flag.
         */
        IF cAttributeParent EQ "MASTER":U THEN
        DO:
            FIND FIRST gsc_object_type WHERE
                       gsc_object_type.object_type_obj = dObjectTypeObj
                       NO-LOCK.
            ASSIGN hClassCacheBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN TARGET-PROCEDURE,
                                                        INPUT gsc_object_type.object_type_code)
                   cInheritsFrom     = hClassCacheBuffer:BUFFER-FIELD("InheritsFromClasses":U):BUFFER-VALUE.
            
            IF CAN-DO(cInheritsFrom, "DataField":U)           AND
               NOT CAN-DO(cInheritsFrom, "CalculatedField":U) AND
               CAN-DO("{&DF-MASTER-ENTITY-ATTRS}":U, ryc_attribute_value.attribute_label) THEN
                ASSIGN ryc_attribute_value.applies_at_runtime = NO NO-ERROR.
        END.    /* MASTER */
        
        VALIDATE ryc_attribute_value NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
        DO:
            ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U) + RETURN-VALUE.           
            LEAVE STORE-ATTRIBUTE-LOOP.
        END.    /* validation error */

        IF ryc_attribute_value.constant_value AND
           NOT lConstantValue                 THEN
        DO:
            FOR EACH ryc_smartObject WHERE
                     ryc_smartObject.object_type_obj = dObjectTypeObj AND
                     ryc_smartObject.smartObject_obj = dSmartObjectObj
                     NO-LOCK:
                /* If the constant value is set at the class level, delete all of 
                 * the master attribute value as well as the instance attribute values. */
                IF cAttributeParent EQ "CLASS":U THEN
                FOR EACH rycav_delete WHERE
                         rycav_delete.object_type_obj           = ryc_smartobject.object_type_obj  AND
                         rycav_delete.smartObject_obj           = ryc_smartobject.smartObject_obj  AND
                         rycav_delete.object_instance_obj       = 0                                AND
                         rycav_delete.attribute_label           = ryc_attribute.attribute_label    AND
                         rycav_delete.container_smartObject_obj = 0
                         EXCLUSIVE-LOCK:
                    DELETE rycav_delete NO-ERROR.
                    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
                        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U) + RETURN-VALUE.
                END.    /* each attribute value to delete */

                /* Always delete the instance attribute values, since the constant value flag
                 * will always be set at a parent level.                                     */
                FOR EACH ryc_object_instance WHERE
                         ryc_object_instance.smartObject_obj = ryc_smartobject.smartObject_obj
                         NO-LOCK:
                    FOR EACH rycav_delete WHERE
                             rycav_delete.object_type_obj           = ryc_smartobject.object_type_obj          AND
                             rycav_delete.smartObject_obj           = ryc_smartobject.smartObject_obj          AND
                             rycav_delete.object_instance_obj       = ryc_object_instance.object_instance_obj  AND
                             rycav_delete.attribute_label           = ryc_attribute.attribute_label            AND
                             rycav_delete.container_smartObject_obj = ryc_object_instance.container_smartObject_obj
                             EXCLUSIVE-LOCK:
                        DELETE rycav_delete NO-ERROR.
                        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
                            ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) GT 0 THEN CHR(3) ELSE "":U) + RETURN-VALUE.
                    END.    /* each attribute value to delete */
                END.    /* each object instance for a smartobject. */
            END.    /* each smartobject */
        END.    /* the constant value flag is set. */
        ghQuery[iQueryOrdinal]:GET-NEXT().
    END.    /* each record */
    ghQuery[iQueryOrdinal]:QUERY-CLOSE().
    &ENDIF
       
    RETURN cMessageList.
END PROCEDURE.  /* StoreAttributeValue */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-buildAttributeList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildAttributeList Procedure 
FUNCTION buildAttributeList RETURNS CHARACTER
  ( INPUT phClassAttributeBuffer        AS HANDLE,
    INPUT pdRecordIdentifier            AS DECIMAL  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Builds a CHR(3) and CHR(4) string of attributes for an object.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cAttributeList          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE iSetLoop                AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE hBufferField            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cSetList                AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cRunTimelist            AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cSystemlist             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE iField                  AS INTEGER                  NO-UNDO.
    
    phClassAttributeBuffer:FIND-FIRST(" WHERE ":U + phClassAttributeBuffer:NAME + ".tRecordIdentifier = '" + STRING(pdRecordIdentifier) + "' ":U) NO-ERROR.
    IF phClassAttributeBuffer:AVAILABLE THEN
    DO:
      /* The attribute settings are returned in lists with field numbers */
      ASSIGN
        cSetList     = phClassAttributeBuffer:BUFFER-FIELD('tSetList'):BUFFER-VALUE
        cRunTimeList = phClassAttributeBuffer:BUFFER-FIELD('tRunTimeList'):BUFFER-VALUE NO-ERROR.

      /* Only set attributes that is specified with 'set' as override type  */
      DO iSetLoop = 1 TO NUM-ENTRIES(cSetList):        
        iField = INTEGER(ENTRY(iSetLoop,cSetList)).

        /* Skip runtime attributes also if they have force set */ 
        IF NOT CAN-DO(cRunTimeList,STRING(iField)) THEN
          ASSIGN 
            hBufferField   = phClassAttributeBuffer:BUFFER-FIELD(iField)
            cAttributeList = cAttributeList 
                           + (IF cAttributeList = "":U THEN "":U ELSE CHR(3))
                           + hBufferField:NAME + CHR(4) + (IF hBufferField:BUFFER-VALUE EQ ? THEN "?":U ELSE STRING(hBufferField:BUFFER-VALUE))
           NO-ERROR.
      END.
    END.  /* loop through fields */
    RETURN cAttributeList.
END FUNCTION.   /* buildAttributeList */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cacheObjectOnClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cacheObjectOnClient Procedure 
FUNCTION cacheObjectOnClient RETURNS LOGICAL
    ( INPUT pcLogicalObjectName     AS CHARACTER,
      INPUT pcResultCode            AS CHARACTER,
      INPUT pcRunAttribute          AS CHARACTER,
      INPUT plDesignMode            AS LOGICAL    ) :
/*------------------------------------------------------------------------------
ACESS_LEVEL=PRIVATE
  Purpose:  Retrieves an object from the REpository and stores it in the client-side
            cache.
    Notes:  
    ****
    THIS API IS DEPRECATED
    ****
------------------------------------------------------------------------------*/
    RETURN FALSE.
END FUNCTION.   /* cacheObjectOnClient */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-classHasAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION classHasAttribute Procedure 
FUNCTION classHasAttribute RETURNS LOGICAL
    ( INPUT pcClassName         AS CHARACTER,
      INPUT pcAttributeName     AS CHARACTER,
      INPUT plAttributeIsEvent  AS LOGICAL          ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Returns whether or not the specified attribute or event exists for 
            a class.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lAttributeExists            AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE hClassBuffer                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hAttributeField             AS HANDLE               NO-UNDO.

    /* This will ensure that the class is cached, if it has not been cached already. */
    ASSIGN hClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN TARGET-PROCEDURE, INPUT pcClassName).

    ASSIGN lAttributeExists = hClassBuffer:AVAILABLE.

    IF lAttributeExists THEN
    DO:
        IF plAttributeIsEvent THEN
        DO:
            ASSIGN hAttributeBuffer = hClassBuffer:BUFFER-FIELD("EventBufferHandle":U):BUFFER-VALUE.
            
            ASSIGN lAttributeExists = VALID-HANDLE(hAttributeBuffer).
            IF lAttributeExists THEN
            DO:
                ASSIGN hAttributeField = hAttributeBuffer:BUFFER-FIELD(pcAttributeName) NO-ERROR.
                ASSIGN lAttributeExists = VALID-HANDLE(hAttributeField).
            END.    /* there are events */
        END.    /* event */
        ELSE
        DO:
            ASSIGN hAttributeBuffer = hClassBuffer:BUFFER-FIELD("classBufferHandle":U):BUFFER-VALUE.
                            
            ASSIGN hAttributeField = hAttributeBuffer:BUFFER-FIELD(pcAttributeName) NO-ERROR.
            ASSIGN lAttributeExists = VALID-HANDLE(hAttributeField).
        END.    /* attribute */
    END.    /* attribute exists: class is in the cache. */

    ASSIGN hAttributeBuffer = ?
           hAttributeField  = ?
           hClassBuffer     = ?.
        
    RETURN lAttributeExists.
END FUNCTION.   /* classHasAttribute */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-classIsA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION classIsA Procedure 
FUNCTION classIsA RETURNS LOGICAL
    ( INPUT pcClassName             AS CHARACTER,
      INPUT pcInheritsFromClass     AS CHARACTER    ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Determines whether one class inherits from another.
    Notes:  * Uses temp-tables for performance.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lClassIsA               AS LOGICAL                  NO-UNDO.    
    
    DEFINE buffer ttClass        for ttClass.
    
    FIND FIRST ttClass WHERE ttClass.ClassName = pcClassName NO-ERROR.
    IF NOT AVAILABLE ttClass THEN
    DO:
        RUN createClassCache (pcClassName) NO-ERROR.
        FIND FIRST ttClass WHERE ttClass.ClassName = pcClassName NO-ERROR.
    END.    /* cache not available */
    
    if available ttClass then
        lClassIsA = can-do(ttClass.InheritsFromClasses, pcInheritsFromClass).
    else
        lClassIsA = no.
    
    RETURN lClassIsA.
END FUNCTION.   /* ClassIsA */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createEntityCacheFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createEntityCacheFile Procedure 
FUNCTION createEntityCacheFile RETURNS character
    ( input pcEntityList            as character,
      input pcLanguageList          as character,
      input pcOutputDir             as character,
      input plDeleteExisting        as logical,
      input-output pcStatus         as character     ):
/*------------------------------------------------------------------------------
  Purpose: Performs the actual dump of the entity records for the given languages.
    Notes: Called from saveEntitiesToClientCache() in this proc, and exportEntityCache()
           in the design manager.
------------------------------------------------------------------------------*/
    define variable cDateFormat                     as character            no-undo.
    define variable cNumericSeparator               as character            no-undo.
    define variable cNumericPoint                   as character            no-undo.
    define variable iLoop                           as integer              no-undo.
    define variable iLoop2                          as integer              no-undo.
    define variable cOutputFilename                 as character            no-undo.
    define variable hQuery                          as handle               no-undo.
    define variable hEntityBuffer                   as handle               no-undo.
    define variable cLanguageCode                   as character            no-undo.
    define variable cEntity                         as character            no-undo.
    define variable hBuffer                         as handle               no-undo.
    define variable cWhere                          as character            no-undo.
    define variable lWriteable                      as logical              no-undo.
    
    define buffer ttEntityDump for ttEntityDump.

    /* The formats need to be converted to American and mdy before dump so that it is consistent */
    cDateFormat = session:date-format.
    cNumericSeparator = session:numeric-separator.
    cNumericPoint = session:numeric-decimal-point.
    session:date-format = "mdy":u.
    session:numeric-format = "American":u.

    /* Make sure the directory is writable */
    file-information:file-name = pcOutputDir.
    if file-information:file-type eq ? or
       index(file-information:file-type, 'w':u) eq 0 then
        return {aferrortxt.i 'AF' '15' '?' '?' "'write permissions are not granted for ' + pcOutputDir"}.
        
    pcOutputDir = pcOutputDir + '/':u.
    if pcOutputDir eq '/':u then
        pcOutputDir = '':u.
    
    if pcLanguageList eq ? or pcLanguageList eq '':u then
        pcLanguageList = 'None':u.
    
    hEntityBuffer =  buffer ttEntity:handle.
    create query hQuery.
    hQuery:set-buffers(hEntityBuffer).
    
    do iLoop = 1 to num-entries(pcLanguageList):
        cLanguageCode = entry(iLoop, pcLanguageList).
        cWhere = 'For each ':u + hEntityBuffer:name + ' where ':U
               + hEntityBuffer:name + '.LanguageCode = ':u + quoter(cLanguageCode).
        
        /* Construct the WHERE clause used to query the cached entities.
                   
           Also delete any entity cache that's on the disk - This is necessary to 
           pick the latest changes from the database */
        if pcEntityList ne '*':u then
        do:
            pcStatus = pcStatus + CHR(10) + "Saving following Entities: " + pcEntityList.
            
            cWhere = cWhere + ' and ( false ':u.
            do iLoop2 = 1 to num-entries(pcEntityList):
                cEntity = entry(iLoop2, pcEntityList).
                cWhere = cWhere + ' or ':u 
                       + hEntityBuffer:name + '.EntityName = ':u + quoter(cEntity).                       
                
                if plDeleteExisting then
                do:
                    cOutputFilename = pcOutputdir
                                     + 'ent_':U + cEntity + '_':u + cLanguageCode + '.d':u.
                    os-delete value(cOutputFilename).
                end.    /* delete */
            end.    /* delete entity records on disk */
            cWhere = cWhere + ' ) ':u.
        end.    /* listed entities */
        
        /* Get the handle to the in memory temp-table which has pointers to the 
           cached entity tables */
        run createEntityCache in target-procedure (pcEntityList, cLanguageCode) no-error.
        if error-status:error or return-value ne '':u then
            return return-value.
        
        /* We need to re-empty this temp-table since it is
           also used in the createEntityCache() call and may have
           extra data in it.    */
        empty temp-table ttEntityDump.
        
        if hQuery:is-open then
            hQuery:query-close().
                
        hQuery:query-prepare(cWhere).
        hQuery:query-open().
            
        hQuery:get-first().
        do while hEntityBuffer:available:
            cEntity = hEntityBuffer::EntityName.
            hBuffer = hEntityBuffer::EntityBufferHandle.
                
            if valid-handle(hBuffer) and cEntity gt '':u then
            do:
                do iLoop2 = 1 to hBuffer:num-fields:
                    create ttEntityDump.
                    assign ttEntityDump.tEntityName = cEntity
                           ttEntityDump.tFieldName = hBuffer:buffer-field(iLoop2):name
                           ttEntityDump.tDataType = hBuffer:buffer-field(iLoop2):data-type
                           ttEntityDump.tFormat = hBuffer:buffer-field(iLoop2):format
                           ttEntityDump.tLabel = hBuffer:buffer-field(iLoop2):label
                           ttEntityDump.tColLabel = hBuffer:buffer-field(iLoop2):column-label
                           ttEntityDump.tHelp = hBuffer:buffer-field(iLoop2):help.
                    /* set up initial values.                       
                       If the data type is Today then dump TODAY. 
                       If the Data type is Logical then we need to right-trim as it sometimes 
                       adds a space and the later entity load dies.  */
                    if ttEntityDump.tDataType eq 'Date':u and
                        hBuffer:buffer-field(iLoop2):default-string eq 'Today':u then
                        ttEntityDump.tInitial = 'Today':u.
                    else
                    if can-do('Datetime,Datetime-TZ':u, ttEntityDump.tDataType) and
                       hBuffer:buffer-field(iLoop2):default-string eq 'Now':u then
                        ttEntityDump.tInitial = 'Now':u.
                    else
                    if ttEntityDump.tDataType eq 'Logical':u then
                        ttEntityDump.tInitial = right-trim(hBuffer:buffer-field(iLoop2):initial).
                    else
                        ttEntityDump.tInitial = hBuffer:buffer-field(iLoop2):initial.
                end.    /* loop through fields */
            end.    /* valid entity */
            
            hQuery:get-next().
        end.    /* entity available */
        hQuery:query-close().
            
        /* Now do the actual dump */
        for each ttEntityDump break by ttEntityDump.tEntityName:
            if ttEntityDump.tEntityName eq '':u then
                next.
            
            if first-of(ttEntityDump.tEntityName) then
            do:
                lWriteable = yes.
                cOutputFilename = pcOutputDir
                                + 'ent_':U + ttEntityDump.tEntityName + '_':u + cLanguageCode + '.d':u.
                file-information:file-name = cOutputFilename.
                if file-information:file-type ne ? or 
                   index(file-information:file-type, 'w':u) eq 0 then
                do:
                    lWriteable = no.
                    if pcEntityList ne '*':u then
                        pcStatus = pcStatus + chr(10) + "Entity : " + 
                                   ttEntityDump.tEntityName + 
                                   " can not be dumped to disk as the file is not writable".
                end.    /* not writable */
                else
                if pcEntityList ne '*':u then
                    pcStatus = pcStatus + CHR(10) + "Dumping entity : " + 
                               ttEntityDump.tEntityName + " to disk at: " +
                               cOutputFilename.
                
                if lWriteable then
                    output to value(cOutputFilename).
            end.    /* first-of */
            
            if lWriteable then
                export ttEntityDump.
            
            if last-of(ttEntityDump.tEntityName) then
            do:
                if lWriteable then
                    output close.
            end.    /* last-of */
        end.    /* entity dump */
    end.    /* language loop */
  
    delete object hQuery no-error.
    hQuery = ?.
    
    /* Reset the date and numeric formats */
    session:date-format = cDateFormat.
    session:set-numeric-format(cNumericSeparator, cNumericPoint).
    
    error-status:error = no.
    return '':u.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deriveSuperProcedures) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deriveSuperProcedures Procedure 
FUNCTION deriveSuperProcedures RETURNS CHARACTER
    ( INPUT pcProcedureName        AS CHARACTER,
      input pdRenderTypeObj        as decimal     ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: Returns a comma-delimited list of super procedures for an object.
    Notes: * This is a server-side only procedure. It is meant to be called from
             the object retrieval.
           * This procedure may be called recursively.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cSuperProcedures          AS CHARACTER                NO-UNDO.
    
    &IF DEFINED(Server-Side) NE 0 &THEN
    DEFINE VARIABLE cMySuperProcedures        AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE dSmartObjectObj           AS DECIMAL                  NO-UNDO.
    
    define buffer ryc_attribute_value    for ryc_attribute_value.
    define buffer ryc_smartobject        for ryc_smartObject.
    
    assign dSmartObjectObj = dynamic-function("getSmartObjectObj":U in target-procedure,
                                              input pcProcedureName, input 0 /* customisation */) no-error.
    if dSmartObjectObj eq 0 or dSmartObjectObj eq ? then
        return "":U.
    
    find first ryc_smartobject where
               ryc_smartobject.smartobject_obj = dSmartObjectObj
               no-lock no-error.
    if not available ryc_smartobject then
        return "":U.
    
    find first ryc_attribute_value where
               ryc_attribute_value.object_type_obj     = ryc_smartobject.object_type_obj and
               ryc_attribute_value.smartobject_obj     = ryc_smartobject.smartobject_obj and
               ryc_attribute_value.object_instance_obj = 0                               and
               ryc_attribute_value.render_type_obj     = pdRenderTypeObj                 and
               ryc_attribute_value.attribute_label     = "SuperProcedure":U
               no-lock no-error.
    if not available ryc_attribute_value and pdRenderTypeObj ne 0 then
      find first ryc_attribute_value where
                 ryc_attribute_value.object_type_obj     = ryc_smartobject.object_type_obj and
                 ryc_attribute_value.smartobject_obj     = ryc_smartobject.smartobject_obj and
                 ryc_attribute_value.object_instance_obj = 0                               and
                 ryc_attribute_value.render_type_obj     = 0                               and
                 ryc_attribute_value.attribute_label     = "SuperProcedure":U
                 no-lock no-error.
                   
    if available ryc_attribute_value               and
       ryc_attribute_value.character_value ne "":U and
       ryc_attribute_value.character_value ne ?    then
    do:
        assign cMySuperProcedures = dynamic-function("deriveSuperProcedures":U in target-procedure,
                                                     input ryc_attribute_value.character_value,
                                                     input pdRenderTypeObj                         ).
        assign cSuperProcedures = ryc_attribute_value.character_value
                                + (if cMySuperProcedures eq "":U then "":U else ",":U + cMySuperProcedures).
    end.    /* there is a superprocedure. */
    &ENDIF
    
    RETURN cSuperProcedures.
END FUNCTION.    /* deriveSuperProcedures */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-entityDefaultValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION entityDefaultValue Procedure 
FUNCTION entityDefaultValue RETURNS CHARACTER
  ( hEntityField  AS HANDLE):
/*------------------------------------------------------------------------------
 ACCESS_LEVEL=PRIVATE
  Purpose:  Return default value according to session settings. 
    Notes:  This function suppress errors and return the value as-is. We do not 
            really want to forgive wrong initial data though, the intention is 
            to postpone the error to it actually is used.
            PRIVATE  
            - This is a temporary workaround for limitations with the INITIAL
            attribute. It will be replaced with calls to DEFAULT-STRING
            in Version 10.
 ------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cDateFormat    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNumericSeparator AS CHARACTER  NO-UNDO.
  define variable cDecimalPoint     as character  no-undo.
  DEFINE VARIABLE deInitial      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dtInitial      AS DATE       NO-UNDO.
  DEFINE VARIABLE cDefaultValue  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lError         AS LOGICAL    NO-UNDO.

  cDefaultValue = hEntityField:INITIAL NO-ERROR.

  IF hEntityField:DATA-TYPE BEGINS "DATETIME":U THEN
      RETURN hEntityField:DEFAULT-VALUE.
  ELSE
  IF  hEntityField:DATA-TYPE = "Date":U
  AND SESSION:DATE-FORMAT <> "mdy":U
  AND cDefaultValue <> "today":U
  AND cDefaultValue <> ? THEN
  DO:
    ASSIGN 
      cDateFormat         = SESSION:DATE-FORMAT
      SESSION:DATE-FORMAT = "mdy":U.
      
      /* This assign MUST be on a separate line from 
         the assign that sets the session's date format
         otherwise it will fail to take that change into
         account and will still attempt to use the old
         format.         
       */
      assign dtInitial = DATE(hEntityField:INITIAL) NO-ERROR.
      
    ASSIGN
      lError              = ERROR-STATUS:ERROR
      SESSION:DATE-FORMAT = cDateFormat.
    
    IF NOT lError THEN
      cDefaultValue  = STRING(dtInitial).
  END.
  ELSE
  IF hEntityField:DATA-TYPE  =  "Decimal":U
  AND SESSION:NUMERIC-FORMAT <> "American":U
  AND cDefaultValue <> ?  THEN
  DO:
    ASSIGN 
      cNumericSeparator      = SESSION:NUMERIC-SEPARATOR
      cDecimalPoint          = session:numeric-decimal-point
      SESSION:NUMERIC-FORMAT = "American":U.
      
      /* This assign MUST be on a separate line from 
         the assign that sets the session's numeric format
         otherwise it will fail to take that change into
         account and will still attempt to use the old
         format.         
       */
    assign deInitial = DECIMAL(hEntityField:initial) NO-ERROR.

    ASSIGN lError = ERROR-STATUS:ERROR.
    session:set-numeric-format(cNumericSeparator, cDecimalPoint).

    IF NOT lError THEN
      cDefaultValue = STRING(deInitial).
  END.
  else
  /* If the format of a logical field is YES/NO, the 
     length of the :INITIAL will be the longest of the 
     valid values. So if the format of a field is YES/NO,
     and the initial value is NO, then the length of
     the initial value returned is 3. This causes problems
     when the temp-table is prepared, so we need to trim 
     the whitespace off the end.
   */
  if hEntityField:data-type eq "LOGICAL":U then
      assign cDefaultValue = right-trim(cDefaultValue).
  
  RETURN cDefaultValue.
END FUNCTION.    /* entityDefaultValue */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAllObjectSuperProcedures) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAllObjectSuperProcedures Procedure 
FUNCTION getAllObjectSuperProcedures RETURNS CHARACTER
    ( INPUT pcObjectName        AS CHARACTER,
      INPUT pcRunAttribute      AS CHARACTER    ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Returns a CSV list of all of a procedure's super procedures.
    Notes:  * These are the physical filenames of the procedures.
            * These super procedures are in order from left-to-right. The first
              procedure should be first in the stack, the second second, etc. 
            * This function merely returns the names of the procedures, it does 
              not start the procedures, or add them to the super procedure stack
              an object.
------------------------------------------------------------------------------*/ 
    DEFINE VARIABLE cAllSuperProcedures         AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cCustomSuperProcedure       AS CHARACTER            NO-UNDO.

    RUN getObjectSuperProcedure IN TARGET-PROCEDURE ( INPUT  pcObjectName,
                                                      INPUT  "":U,
                                                      OUTPUT cCustomSuperProcedure ) NO-ERROR.
    
    SUPER-PROCEDURE-LOOP:
    DO WHILE cCustomSuperProcedure NE "":U:
        ASSIGN cAllSuperProcedures = cAllSuperProcedures + cCustomSuperProcedure + ",":U
               pcObjectName        = cCustomSuperProcedure
               .    
        /* Get the next one */
        RUN getObjectSuperProcedure IN TARGET-PROCEDURE ( INPUT  pcObjectName,
                                                          INPUT  "":U,
                                                          OUTPUT cCustomSuperProcedure ) NO-ERROR.

        IF cCustomSuperProcedure EQ ? THEN
            ASSIGN cCustomSuperProcedure = "":U.   
    
        NEXT SUPER-PROCEDURE-LOOP.
    END.    /* SUPER-PROCEDURE-LOOP: super procedure exists. */
    
    ASSIGN cAllSuperProcedures = RIGHT-TRIM(cAllSuperProcedures, ",":U).

    RETURN cAllSuperProcedures.
END FUNCTION.   /* getAllObjectSuperProcedures */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCacheClassBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCacheClassBuffer Procedure 
FUNCTION getCacheClassBuffer RETURNS HANDLE
    ( INPUT pcClassName     AS CHARACTER     ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Returns the buffer handle of the table used to store the cached class 
            buffers.
    Notes:  * If a non-blank and non-null clæas name is passed in, the ttClass
              cache record will be repositioned to it.
            * This API will accept an asterisk '*'and will thus retrieve all classes;
              however, the record will not be correctly positioned after this 
              has been passed in.
            * In the same way, this API will receive a CSV list of class names.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBuffer                 AS HANDLE                   NO-UNDO.

    IF pcClassName NE ? AND pcClassName NE "":U THEN
    DO:
        FIND FIRST ttClass WHERE ttClass.ClassName = pcClassName NO-ERROR.
        IF NOT AVAILABLE ttClass THEN
        DO:
            RUN createClassCache IN TARGET-PROCEDURE ( INPUT pcClassName ) NO-ERROR.
            /* Show no messages. The calling procedure needs to cater for the fact that
             * no class has been retrieved from the cache.                              */
            FIND FIRST ttClass WHERE ttClass.ClassName = pcClassName NO-ERROR.
        END.    /* cache not available */
    END.    /* class name */

    ASSIGN hBuffer = BUFFER ttClass:HANDLE.

    RETURN hBuffer.
END FUNCTION.   /* getCacheClassBuffer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCachedList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCachedList Procedure 
FUNCTION getCachedList RETURNS CHARACTER
  (pcEntityOrClass AS CHARACTER,
   pcDirectory AS CHARACTER,
   pcLanguageCode AS CHARACTER) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  This function will return the list of cached classes or entities. 
    Notes:  The input parameter pcDirectory is the directory where this IP will
            look for classes or entities.
            The input parameter pcEntityOrClass can have either "CLASS" or "ENTITY" 
            as the possible values.
            The input parameter pcLanguageCode is the language code that the 
            entities should be translated into. Blank and unknown values are not
            allowed for querying entities.
            Output is the comma separated list of cached classes or entities.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRootFile   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullPath   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFlags      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturnList AS CHARACTER  NO-UNDO.

  /* Sanity check */
  IF pcDirectory = ? OR pcDirectory = "":U THEN
    RETURN "".
  IF pcEntityOrClass = "ENTITY":U AND (pcLanguageCode = ? OR pcLanguageCode = "":U) THEN
    RETURN "".
  
  /* Find the files in the directory */
  ASSIGN ERROR-STATUS:ERROR = NO.
  INPUT FROM OS-DIR(pcDirectory).
  IF ERROR-STATUS:ERROR THEN
  DO:
    ERROR-STATUS:ERROR = NO.
    RETURN "".
  END.
  
  /* Go thru each file and check */
  REPEAT:
    IMPORT cRootFile cFullPath cFlags.
    
    /* Ignore current and parent directory */
    IF ( cRootFile = ".":U OR cRootFile = "..":U ) THEN
      NEXT.
      
    /* We don't deal with nested directory so if this is a directory next */
    IF INDEX(cFlags,"D":U) <> 0 THEN
      NEXT.

    /* If this is a file, based on pcEntityOrClass find the file */
    IF INDEX(cFlags,"F":U) <> 0 THEN
    DO:
      IF NUM-ENTRIES(cRootFile,".":U) > 1 AND
         ENTRY(NUM-ENTRIES(cRootFile,".":U), cRootFile, ".":U) = "p":U AND
         pcEntityOrClass = "CLASS":U  AND
         cRootFile BEGINS "class_" THEN
        ASSIGN cReturnList = cReturnList + "," + SUBSTRING(cRootFile, INDEX(cRootFile, "_") + 1, LENGTH(cRootFile) - 8).

      IF NUM-ENTRIES(cRootFile,".":U) > 1 AND
         pcEntityOrClass = "ENTITY":U  AND
         cRootFile MATCHES ("ent_*_":U + pcLanguageCode + "~~.d":U) THEN
        ASSIGN cReturnList = cReturnList + ","
                           + SUBSTRING(cRootFile, INDEX(cRootFile, "_") + 1, LENGTH(cRootFile) - LENGTH(pcLanguageCode) - 7).
    END.
  END.
  INPUT CLOSE.
  ASSIGN cReturnList = TRIM(cReturnList, ",":U).

  RETURN cReturnList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCacheEntityObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCacheEntityObject Procedure 
FUNCTION getCacheEntityObject RETURNS HANDLE
        ( INPUT pcEntityName            AS CHARACTER ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: Returns the buffer handle to the ttEntity table. 
        Notes: * This function will ensure that the requested entity is cached.
                   * Either a single entity name (which corresponds to a ryc_smartobject record)
                     or a CSV list of such names can be passed in to this API.  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBuffer                 AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cLanguageCode           AS CHARACTER                NO-UNDO.
    
    IF pcEntityName NE ? AND pcEntityName NE "":U THEN
    DO:
        cLanguageCode = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, "CurrentLanguageCode":U, YES).
        IF cLanguageCode = ? OR cLanguageCode = "":U THEN cLanguageCode = "NONE":U.
        FIND FIRST ttEntity WHERE ttEntity.EntityName = pcEntityName AND ttEntity.LanguageCode = cLanguageCode NO-ERROR.
        IF NOT AVAILABLE ttEntity THEN
        DO:
            RUN createEntityCache IN TARGET-PROCEDURE ( INPUT pcEntityName, cLanguageCode ) NO-ERROR.
            /* Show no messages. The calling procedure needs to cater for the fact that
             * no class has been retrieved from the cache.                              */
            FIND FIRST ttEntity WHERE ttEntity.EntityName = pcEntityName AND ttEntity.LanguageCode = cLanguageCode NO-ERROR.
        END.    /* cache not available */
    END.    /* class name */
                
    ASSIGN hBuffer = BUFFER ttEntity:HANDLE.
            
    RETURN hBuffer.
END FUNCTION.   /* getCacheEntityObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCacheLinkBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCacheLinkBuffer Procedure 
FUNCTION getCacheLinkBuffer RETURNS HANDLE
    ( /* No Parameters */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Returns the buffer handle of the table used to cache Repository 
            Object Links.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBuffer                 AS HANDLE                   NO-UNDO.

    ASSIGN hBuffer = BUFFER cacheLink:HANDLE.

    RETURN hBuffer.
END FUNCTION.   /* getCacheLinkBuffer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCacheObjectBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCacheObjectBuffer Procedure 
FUNCTION getCacheObjectBuffer RETURNS HANDLE
    ( INPUT pdInstanceID        AS DECIMAL ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Returns the buffer handle of the table used to cache Repository 
            Objects.
    Notes:  * This function will attempt to find the record specified by the
              pcInstanceID. 
            * This pcInstanceID corresponds to the tRecordIdentifier which is 
              unique for each cache_Object record.
            * If a null (?) is passed in, the find is ignored.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBuffer                 AS HANDLE                   NO-UNDO.

    ASSIGN hBuffer = BUFFER cacheObject:HANDLE.

    /* If a valid ID is passed in, then we attempt to find the related record. */
    IF pdInstanceId NE ? AND pdInstanceId NE 0 THEN
        FIND FIRST cacheObject WHERE
                   cacheObject.InstanceId = pdInstanceID
                   NO-ERROR.
        
    RETURN hBuffer.
END FUNCTION.   /* getCacheObjectBuffer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCachePageBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCachePageBuffer Procedure 
FUNCTION getCachePageBuffer RETURNS HANDLE
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Returns the buffer handle of the table used to cache Repository 
            object pages.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBuffer                 AS HANDLE                   NO-UNDO.

    ASSIGN hBuffer = BUFFER cachePage:HANDLE.

    RETURN hBuffer.
END FUNCTION.   /* getCachePageBuffer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCachePageInstanceBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCachePageInstanceBuffer Procedure 
FUNCTION getCachePageInstanceBuffer RETURNS HANDLE
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Returns the buffer handle of the table used to cache Repository 
            object page instances.
    Notes:  
*** THIS API IS DEPRECATED ***        
------------------------------------------------------------------------------*/
    RETURN ?.
END FUNCTION.   /* getCachePageInstanceBuffer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCacheUiEventBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCacheUiEventBuffer Procedure 
FUNCTION getCacheUiEventBuffer RETURNS HANDLE
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Returns the buffer handle of the table used to cache Repository 
            object UI events.
    Notes:  
*** THIS API IS DEPRECATED ***    
------------------------------------------------------------------------------*/
    RETURN ?.
END FUNCTION.   /* getCacheUiEventBuffer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getClassChildren Procedure 
FUNCTION getClassChildren RETURNS CHARACTER
    ( INPUT pcClassName     AS CHARACTER ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  REturns a CSV list of class names 

    Notes:  This works on cahced data. getClassChildrenFromDB will return
            children for a given class, but read from the repository db. Therefor,
            if something was not cached, it will still be retrieved by
            getClassChildrenFromDB
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cClassNames                     AS CHARACTER    NO-UNDO.

    FOR EACH ttClass:
        IF CAN-DO(ttClass.InheritsFromClasses, pcClassName) THEN
            ASSIGN cClassNames = cClassNames + (IF NUM-ENTRIES(cClassNames) EQ 0 THEN "":U ELSE ",":U)
                               + ttClass.ClassName.
    END.    /* all classes. */

    RETURN cClassNames.
END FUNCTION.   /* getAllInheritingFrom */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassChildrenFromDB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getClassChildrenFromDB Procedure 
FUNCTION getClassChildrenFromDB RETURNS CHARACTER
  (pcClasses AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  The function will return a delimited list of all children object types
            (classes) for the specified classes (including the class itself). The
            classes can be a comma seperated list of classes that you want the
            children for. The function will return the children for the classes
            you specified in a comma seperated list, delimiting the specified
            classes with a CHR(3) in the order you specified, e.g.
            
             Pass In: SDO,MsgHandler
            Returned: SDO,DynSDOMsgHandler,XML,B2B,Router

    Notes:  This function essentially serves the same purpose as getClassChildren.
            The main difference is that getClassChildren works on cached object
            types (classes) whereas getClassChildrenFromDB will find the class
            children for a given class from the repository db.
            
            Be very careful: If a class was not cached, it will not show up in the
                             list returned from getClassChildren
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cClassList        AS CHARACTER  NO-UNDO.

  &IF DEFINED(server-side) = 0 &THEN
  {
   dynlaunch.i &PLIP              = 'RepositoryManager'
               &IProc             = 'getClassChildrenProc'
               &compileStaticCall = NO
               &mode1 = INPUT  &parm1 = pcClasses  &datatype1 = CHARACTER
               &mode2 = OUTPUT &parm2 = cClassList &datatype2 = CHARACTER
  }
  IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
  &ELSE
    DEFINE VARIABLE cCurrentClassList AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCurrentClass     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dObjectTypeObj    AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE iCounter          AS INTEGER    NO-UNDO.

    /* Localize the gsc_object_type buffer to this function. This is particularly important seeing that the function is called recursively */
    DEFINE BUFFER gsc_object_type FOR gsc_object_type.
  
    /* Ensure the value is empty */
    cClassList = "":U.
  
    /* Make sure we read through all entries of requested classes */
    DO iCounter = 1 TO NUM-ENTRIES(pcClasses):
      /* Ensure the variables are cleared */
      ASSIGN
          cCurrentClassList = "":U
          cCurrentClass     = ENTRY(iCounter, pcClasses).
  
      /* See if the given class exists */
      FIND FIRST gsc_object_type NO-LOCK
           WHERE gsc_object_type.object_type_code = cCurrentClass NO-ERROR.
  
      /* See if the specified class exists */
      IF AVAILABLE gsc_object_type THEN
      DO:
        ASSIGN
            cCurrentClassList = gsc_object_type.object_type_code
            dObjectTypeObj    = gsc_object_type.object_type_obj.
  
        /* Step through all the children of the current class */
        FOR EACH gsc_object_type NO-LOCK
           WHERE gsc_object_type.extends_object_type_obj = dObjectTypeObj
              BY gsc_object_type.object_type_code:
          
          /* For every child, see if there are any children underneath it, by recursively calling this function */
          cCurrentClassList = cCurrentClassList + ",":U
                            + DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN TARGET-PROCEDURE, gsc_object_type.object_type_code).
        END.
      END.
      ELSE
        cCurrentClassList = CHR(1). /* Assign a temporary placeholder if the specified class does not exist */
  
      /* Append the CurrentClassList to the global ClassList. The placeholder above was inserted so the correct number of entries are added to the output value */
      cClassList = cClassList
                 + (IF cClassList = "":U THEN "":U ELSE CHR(3))
                 + cCurrentClassList.
    END.
  
    /* If any temporay placeholders exist, ensure they are removed from the output value */
    IF INDEX(cClassList, CHR(1)) <> 0 THEN
      cClassList = REPLACE(cClassList, CHR(1), "":U).
  &ENDIF

  RETURN cClassList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassFromClientCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getClassFromClientCache Procedure 
FUNCTION getClassFromClientCache RETURNS LOGICAL
  ( pcClassNames AS CHARACTER,
    pcClassDir   AS CHARACTER) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: Given the class name this function will load the class from the local 
           cache.
    Notes: Input - pcClassNames - a Comma separated list of classes to be loaded.
                 If the pcClassNames is either blank or * then it checks all the files
                 on the disk and loads all the classes available on the disk.
                 
                 - pcClassDir - is the absolute path to the cache directory.
                 
                 Return value of FALSE means that class file was not found on the 
                 disk and a server request needs to be made to get the class info.
                 
                 Return value of true means that ALL class files were found on disk.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cClassName           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dClassObj            AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cClassTableName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hClassHandle         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hEventHandle         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cInheritsFromClasses AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSuperProcedures     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSuperProcedureModes AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEventTableName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSetList             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cGetList             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRuntimeList         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i                    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lRetValue            AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cDateFormat          AS CHARACTER  NO-UNDO.
  define variable cDecimalPoint        as character  no-undo.
  define variable cNumericSeparator    as character  no-undo.  

  IF pcClassDir = ? OR pcClassDir = "":U THEN
    RETURN FALSE.
    
  IF pcClassNames = "*":U OR pcClassNames = "":U THEN
    pcClassNames = DYNAMIC-FUNCTION("getCachedList":U IN TARGET-PROCEDURE, 
                                     "CLASS":U, 
                                     pcClassDir, "":U) NO-ERROR. /* The pcLanguageCode parameter is not used for a CLASS. */
  /* Sanity check */
  ASSIGN pcClassNames  = TRIM(pcClassNames, ",":U).
  
  IF pcClassNames = ? OR pcClassNames = "":U THEN
    RETURN FALSE.

  /* The formats need to be converted to American and mdy a the class cache was dumped as
     American and mdy */
  ASSIGN cDateFormat            = SESSION:DATE-FORMAT
         cNumericSeparator      = session:numeric-separator
         cDecimalPoint          = session:numeric-decimal-point
         SESSION:DATE-FORMAT    = "mdy":U
         SESSION:NUMERIC-FORMAT = "American":U
         lRetValue = TRUE.
         
  DO i = 1 TO NUM-ENTRIES(pcClassNames):

    ASSIGN cClassName = ENTRY(i, pcClassNames).

    IF cClassName = ? OR cClassName = "":U THEN
      NEXT.

    /* Sanity check */
    IF (CAN-FIND(FIRST ttClass WHERE ttClass.ClassName = cClassName)) THEN
      NEXT.
  
    /* Check if the file can be found locally on disk. 
       First look for r-code, then for the .p. This is because
       most runtime clients cannot run off source code, and so
       rcode (and only rcode) is shipped to the client. We need
       to find this rcode before looking for pcode.
     */
    file-info:file-name = pcClassDir + '/' + 'class_' + cClassName + '.r'.
    if file-info:full-pathname eq ? then
        ASSIGN FILE-INFO:FILE-NAME = pcClassDir + "/":U + "class_":U + cClassName + ".p".
    
    /* If the .p does not exist then return false which will add 
       the class to a list for getting the info from the server */
    IF (FILE-INFO:FULL-PATHNAME = ?)  THEN
    DO:
      ASSIGN lRetValue = FALSE.
      NEXT.
    END.
  
    RUN VALUE(FILE-INFO:FULL-PATHNAME) (OUTPUT cClassName, 
                                        OUTPUT dClassObj,
                                        OUTPUT cClassTableName,
                                        OUTPUT hClassHandle,
                                        OUTPUT cInheritsFromClasses,
                                        OUTPUT cSuperProcedures,
                                        OUTPUT cSuperProcedureModes,
                                        OUTPUT cEventTableName,
                                        OUTPUT hEventHandle,
                                        OUTPUT cSetList,
                                        OUTPUT cGetList,
                                        OUTPUT cRuntimeList) NO-ERROR.
  
    IF (NOT ERROR-STATUS:ERROR) AND VALID-HANDLE(hClassHandle) THEN
    DO:
      /* Create the ttClass record */
      CREATE ttClass.
      ASSIGN ttClass.ClassName           = cClassName
             ttClass.ClassObj            = dClassObj
             ttClass.ClassTableName      = cClassTableName
             ttClass.ClassBufferHandle   = hClassHandle:DEFAULT-BUFFER-HANDLE
             ttClass.InheritsFromClasses = cInheritsFromClasses
             ttClass.SuperProcedures     = cSuperProcedures
             ttClass.SuperProcedureModes = cSuperProcedureModes
             ttClass.EventTableName      = cEventTableName
             ttClass.EventBufferHandle   = (IF VALID-HANDLE(hEventHandle) THEN hEventHandle:DEFAULT-BUFFER-HANDLE ELSE ?)
             ttClass.SetList             = cSetList
             ttClass.GetList             = cGetList
             ttClass.RuntimeList         = cRuntimeList.
    END.
    ELSE 
      ASSIGN lRetValue = FALSE.
  END.

  /* Let's set the formats back to session settings. */
  ASSIGN SESSION:DATE-FORMAT = cDateFormat.
  session:set-numeric-format(cNumericSeparator, cDecimalPoint).
    
  RETURN lRetValue.
END FUNCTION.    /* getClassFromClientCache */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassFromInstance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getClassFromInstance Procedure 
FUNCTION getClassFromInstance RETURNS CHARACTER
  ( INPUT pdInstance AS DECIMAL ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Returns the class name of a known object buffer instance
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE BUFFER bCache        FOR cacheObject.
    
    FIND FIRST bCache WHERE bCache.InstanceId = pdInstance NO-ERROR.
    IF AVAILABLE bCache THEN
        RETURN bCache.ClassName.
    ELSE
        RETURN "":U.
END FUNCTION.   /* getClassFromInstance */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassParents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getClassParents Procedure 
FUNCTION getClassParents RETURNS CHARACTER
    ( INPUT pcClasses        AS CHARACTER  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: The function will return a delimited list of all parent object types
           (classes) for the specified class (including the class itself). The
           classes can be a comma seperated list of classes.
           The function will return the ancestral classes for the classes
           you specified in a comma seperated list, delimiting the specified
           classes with a CHR(3) in the order you specified, e.g.

            Pass In: Visual
           Returned: Base,AppServer,Visual

    Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cClassList        AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE iClassLoop        AS INTEGER                        NO-UNDO.
    
    DEFINE BUFFER bClass     FOR ttClass.
    
    /* First make sure allthe classes are cached. */
    RUN createClassCache (INPUT pcClasses) NO-ERROR.
    
    /* Now build the list of parent classes.  */
    DO iClassLoop = 1 TO NUM-ENTRIES(pcClasses):
        FIND FIRST bClass WHERE bClass.ClassName = ENTRY(iClassLoop, pcClasses) NO-ERROR.
        IF AVAILABLE bClass THEN
            ASSIGN cClassList = cClassList + CHR(3) + bClass.InheritsFromClasses.
        ELSE
            ASSIGN cClassList = cClassList + CHR(3) + "":U.
    END.    /* ClassLoop */
    ASSIGN cClassList = LEFT-TRIM(cClassList, CHR(3)).
                
    RETURN cClassList.
END FUNCTION.    /* getClassParents */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassParentsFromDB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getClassParentsFromDB Procedure 
FUNCTION getClassParentsFromDB RETURNS CHARACTER
    (pcClasses AS CHARACTER) :
  /*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE  
    Purpose:  The function will return a delimited list of all parent object types
              (classes) for the specified class (including the class itself). The
              classes can be a comma seperated list of classes.
              The function will return the ancestral classes for the classes
              you specified in a comma seperated list, delimiting the specified
              classes with a CHR(3) in the order you specified, e.g.

               Pass In: Visual
              Returned: Base,AppServer,Visual

      Notes:  This function essentially serves the same purpose as getClassChildren.
              ------------------------------------------------------------------------------*/
    RETURN DYNAMIC-FUNCTION("getClassParents":U IN TARGET-PROCEDURE, INPUT pcClasses).
END FUNCTION.    /* getClassParentsFromDB */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Returns the name of the object being launched. prepareInstance does
            a call-back to this API to determine the name of the logical object
            which is being launched.
    Notes:  * The value of gcCurrentLogicalName is set in
              - startDataObject
------------------------------------------------------------------------------*/
    RETURN gcCurrentLogicalName.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEntityFromClientCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEntityFromClientCache Procedure 
FUNCTION getEntityFromClientCache RETURNS LOGICAL
  ( pcEntityNames AS CHARACTER,
    pcEntityDirectory AS CHARACTER,
    pcLanguageCode AS CHARACTER) :
/*-----------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  This function loads the entities from the disk and creates 
            a temp-table 
    Notes:  Input - pcEntityNames - A comma seaparaed Names of the entities
                    If the names is either blank or * then all the 
                    entities fromthe disk will be loaded.
                    
                  - pcEntityDirectory - Directory where .d can be found.
                  
                  - pcLanguageCode - Language used for the entity translation.
                  
            Return value of FALSE means the .d file was not found on the 
            disk and a server request needs to be made to get the entity info.
                  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hEntityTable   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuff          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cEntityName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRetValue      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDateFormat    AS CHARACTER  NO-UNDO.
  define variable cNumericSeparator    as character                    no-undo.
  define variable cDecimalPoint        as character                    no-undo.
  
  IF pcEntityDirectory = ? OR pcEntityDirectory = "":U THEN
    RETURN FALSE.
  IF pcLanguageCode = ? OR pcLanguageCode = "":U THEN
    RETURN FALSE.
    
  IF pcEntityNames = "*":U OR pcEntityNames = "":U THEN
    pcEntityNames = DYNAMIC-FUNCTION("getCachedList":U IN TARGET-PROCEDURE, 
                                      "ENTITY":U,
                                      pcEntityDirectory,
                                      pcLanguageCode) NO-ERROR.
    
  /* Sanity check */
  ASSIGN pcEntityNames = TRIM(pcEntityNames, ",":U).

  IF pcEntityNames = ? OR pcEntityNames = "":U THEN
    RETURN FALSE.
  
  EMPTY TEMP-TABLE ttEntityDump.
  
  ASSIGN cDateFormat            = SESSION:DATE-FORMAT
         SESSION:DATE-FORMAT    = "mdy"
         cNumericSeparator      = session:numeric-separator
         cDecimalPoint          = session:numeric-decimal-point
         SESSION:NUMERIC-FORMAT = "American"
         lRetValue              = TRUE.
    
  DO iLoop = 1 to NUM-ENTRIES(pcEntityNames):
    ASSIGN cEntityName = ENTRY(iLoop, pcEntityNames).

    IF (CAN-FIND(FIRST ttEntity WHERE ttEntity.EntityName = cEntityName AND ttEntity.LanguageCode = pcLanguageCode)) THEN
      NEXT.
      
    /* If the entity is not cached in memory, check if .d exists */
    FILE-INFO:FILE-NAME = RIGHT-TRIM(pcEntityDirectory, "/":U) + 
                          (IF pcEntityDirectory > "":U THEN "/" ELSE "") + "ent_":U + 
                          cEntityName + "_" + pcLanguageCode + ".d".

    /* If the .d does not exist then return false which will add 
       the entity to a list for getting the info from the server and check the next */
    IF (FILE-INFO:FULL-PATHNAME = ?)  THEN
    DO:
      ASSIGN lRetValue = FALSE.
      NEXT.
    END.

  /* If the file exists then open the file and read the contents in TT */
  /* We have to read the contents in a TT as there may be some extended 
     attributes like HELP that need to be set after temp-table-prepare. 
     For that we don;t want to go back to the file so load it in a tt */

    INPUT FROM VALUE(FILE-INFO:FULL-PATHNAME).
    REPEAT:
      CREATE ttEntityDump.
      IMPORT ttEntityDump.
    END.
    INPUT CLOSE.

    /* Now create a dynamic temp-table with the contents */
    CREATE TEMP-TABLE hEntityTable.

    FOR EACH ttEntityDump
       WHERE ttEntityDump.tEntityName = cEntityName:
      hEntityTable:ADD-NEW-FIELD(ttEntityDump.tFieldName, 
                                 ttEntityDump.tDataType, 
                                 0, /* Extent */
                                 ttEntityDump.tFormat, 
                                 ttEntityDump.tInitial, 
                                 ttEntityDump.tLabel, 
                                 ttEntityDump.tColLabel).
    END.    /* loop through fields */
    hEntityTable:TEMP-TABLE-PREPARE(cEntityName).
    ASSIGN hBuff = hEntityTable:DEFAULT-BUFFER-HANDLE.

    /* Now set the extended attributes - No choice but to do two loops 
       NOTE: The help is not set in the repository yet. So we ignore this for now
       NEEDS TO BE FIXED LATER 
       
    FOR EACH ttEntityDump
       WHERE ttEntityDump.tEntityName = cEntityName:
       
      ASSIGN hBuff:BUFFER-FIELD(tFieldName):HELP = ttEntityDump.tHelp.
      
    END.
    */
    
    /* Create the ttEntity record - This is a in memory pointer table */
    CREATE ttEntity.
    ASSIGN ttEntity.EntityName         = hEntityTable:NAME
           ttEntity.EntityTableName    = hEntityTable:NAME + pcLanguageCode
           ttEntity.EntityBufferHandle = hBuff
           ttEntity.LanguageCode       = pcLanguageCode.    
  END.

   /* Reset the session FORMATs before returning */
  ASSIGN SESSION:DATE-FORMAT = cDateFormat.
  session:set-numeric-format(cNumericSeparator, cDecimalPoint).
  
  assign ERROR-STATUS:ERROR = NO.
  RETURN lRetValue.
END FUNCTION.    /* getEntityFromClientCache */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMappedFilename) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMappedFilename Procedure 
FUNCTION getMappedFilename RETURNS CHARACTER
        ( input pcObjectName        as character ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose: Returns the name of the generated file for a given logical object name.
    Notes: - Either a fully-pathed filename is returned or the unknown value is returned.
           - Only the names of r-code files are returned
           - The generated file must exist in the 'gen' subdirectory of the directory
             specified by the client_cache_directory session property (if available).
------------------------------------------------------------------------------*/
    define variable cFilename            as character                no-undo.
    define variable cCustomizedFilename  as character                no-undo.
    define variable cObjectName          as character                no-undo.
    define variable cImportValue         as character                no-undo.
    define variable cResultCodes         as character                no-undo.
    define variable cExtension           as character                no-undo.
    define variable lResultCodeFound     as logical                  no-undo.
    define variable hManagerHandle       as handle                   no-undo.
    define variable iLoop                as integer                  no-undo.
    
    /* Get path of client cache directory */
    /* First let  us find the the EntityCacheDirectory */
    if gcClientCacheDir eq ? or gcClientCacheDir eq '' then
    do:
        run getClientCacheDir (input "ry-clc":U, output gcClientCacheDir) no-error.
        gcClientCacheDir = right-trim(gcClientCacheDir, "/":U).
    end.    /* no client cache directory */
    
    /* No extensions allowed in the logical object name */
    cExtension = entry(2, pcObjectName, '.') no-error.
    if can-do('w,p', cExtension) then
        pcObjectName = entry(1, pcObjectName, '.').
    
    /* Check the session result codes */
    if gcSessionResultCodes eq ? or gcSessionResultCodes eq '' then
    do:
        /* Get the session's result codes. */
        hManagerHandle = {fnarg getManagerHandle 'CustomizationManager'}.
        
        if valid-handle(hManagerHandle) then
            gcSessionResultCodes = {fn getSessionResultCodes hManagerHandle}.
        
        if gcSessionResultCodes eq ? or gcSessionResultCodes eq '' then
            gcSessionResultCodes = "{&DEFAULT-RESULT-CODE}".
    end.    /* set session result codes */
    
    cFileName = ?.
    /* If the session has result codes, construct the filename */    
    if gcSessionResultCodes ne '{&Default-Result-Code}' then
        assign cFilename = gcClientCacheDir + '/gen/'
                         + pcObjectName + '_' + replace(gcSessionResultCodes, ',', '_')
                         + '.r'
               cFileName = search(cFilename).
    
    /* If running in a customised session, and no generated r-code was found,
       or if running without customisations, then find the default generated
       object.
     */
    if cFilename eq ? then
        assign cFilename = gcClientCacheDir + '/gen/' + pcObjectName + '.r'
               cFilename = search(cFilename).
    
    error-status:error = no.
    return cFilename.
END FUNCTION.    /* getMappedFilename */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNextQueryOrdinal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNextQueryOrdinal Procedure 
FUNCTION getNextQueryOrdinal RETURNS INTEGER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Returns the ordinal or the next query available for use.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iNextQueryOrdinal           AS INTEGER              NO-UNDO.

    DO iNextQueryOrdinal = 1 TO EXTENT(ghQuery):
        IF NOT VALID-HANDLE(ghQuery[iNextQueryOrdinal]) THEN
            LEAVE.
        IF VALID-HANDLE(ghQuery[iNextQueryOrdinal]) AND
           ghQuery[iNextQueryOrdinal]:IS-OPEN EQ NO THEN
            LEAVE.
    END.    /* iNextQueryOrdinal */

    RETURN iNextQueryOrdinal.
END FUNCTION.   /* getNextQueryOrdinal */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectPathedName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectPathedName Procedure 
FUNCTION getObjectPathedName RETURNS CHARACTER
    ( INPUT pdSmartObjectObj     AS DECIMAL ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Returns a pathed physical file name for a given object.
    Notes:  * This function will return a file which can be run, as long as
              as it exists on disk.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cPathedObjectName           AS CHARACTER            NO-UNDO.

    &IF DEFINED(Server-Side) NE 0 &THEN
    DEFINE BUFFER rycso_physical        FOR ryc_smartObject.

    FIND FIRST rycso_physical WHERE
               rycso_physical.smartObject_obj = pdSmartObjectObj
               NO-LOCK NO-ERROR.
    IF AVAILABLE rycso_physical THEN
    DO:
        IF rycso_physical.object_is_runnable THEN
            ASSIGN cPathedObjectName = REPLACE(rycso_physical.Object_Path, "~\":U, "/":U)
                   cPathedObjectName = RIGHT-TRIM(cPathedObjectName, "/":U)
                                     + ( IF rycso_physical.Object_Path EQ "":U THEN "":U ELSE "/":U )
                                     + rycso_physical.Object_Filename
                                     + (IF rycso_physical.Object_Extension <> "":U THEN ".":U + rycso_physical.Object_Extension
                                         ELSE "":U ).
        ELSE
            ASSIGN cPathedObjectName = rycso_physical.object_filename.
    END.    /* found object. */
    ELSE
        ASSIGN cPathedObjectName = "":U.
    &ENDIF
    
    RETURN cPathedObjectName.
END FUNCTION.   /* getObjectPathedName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDOincludeFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDOincludeFile Procedure 
FUNCTION getSDOincludeFile RETURNS CHARACTER
    (   INPUT pcIncludeFile       AS CHARACTER ) :   /* Include file without relative path */
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Returns a pathed physical file name given a nonpathed SDO include
            filename.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cPathedIncludeName           AS CHARACTER            NO-UNDO.
    
    &IF DEFINED(Server-Side) NE 0 &THEN
    DEFINE BUFFER ryc_smartObject       FOR ryc_smartObject.
    
    FIND ryc_smartobject WHERE ryc_smartobject.object_filename = ENTRY(1, pcIncludeFile, ".":U)
         NO-LOCK NO-ERROR.
    
    /*In older versions of dynamics the static SDO were registerd with the '.w' extension. So
     if the SDO is not found we have to check again for the SDO registered with the '.w' extension*/
    IF NOT AVAILABLE ryc_smartobject THEN
    FIND ryc_smartobject WHERE ryc_smartobject.object_filename = ENTRY(1, pcIncludeFile, ".":U) + ".w"
         NO-LOCK NO-ERROR.
     
    IF AVAILABLE ryc_smartobject THEN
        cPathedIncludeName = ryc_smartobject.object_path + "~/":U + pcIncludeFile.
    &ENDIF
    
RETURN cPathedIncludeName.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSmartObjectObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSmartObjectObj Procedure 
FUNCTION getSmartObjectObj RETURNS DECIMAL
    ( INPUT pcObjectName                AS CHARACTER,
      INPUT pdCustmisationResultObj     AS DECIMAL      ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Returns the object ID of an associated smartObject, given a 
            object name.
    Notes:  * The logic will always attempt to find the customised version
              and then a version without customisation before looking for 
              a version with an extension.
            * This function is designed to be PRIVATE to this Manager and to
              only be called from the server-side portion.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dSmartObjectObj             AS DECIMAL              NO-UNDO.

    &IF DEFINED(Server-side) <> 0 &THEN
    DEFINE VARIABLE cObjectExt                  AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cObjectFileNameWithExt      AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cObjectFileNameNoExt        AS CHARACTER                NO-UNDO.

    DEFINE BUFFER rycso_associated      FOR ryc_smartObject.

    RUN extractRootFile IN TARGET-PROCEDURE (INPUT pcObjectName, OUTPUT cObjectFileNameNoExt, OUTPUT cObjectFileNameWithExt).
    ASSIGN cObjectExt = REPLACE(cObjectFileNameWithExt, (cObjectFileNameNoExt + ".":U), "":U).

    FIND FIRST rycso_associated WHERE
               rycso_associated.object_filename          = pcObjectName AND
               rycso_associated.customization_result_obj = pdCustmisationResultObj
               NO-LOCK NO-ERROR.
    IF NOT AVAILABLE rycso_associated AND pdCustmisationResultObj NE 0 THEN
        FIND FIRST rycso_associated WHERE
                   rycso_associated.object_filename          = pcObjectName AND
                   rycso_associated.customization_result_obj = 0
                   NO-LOCK NO-ERROR.

    /* If not available then check rycso_associated with separated file extension if any */
    IF NOT AVAILABLE rycso_associated THEN
        FIND FIRST rycso_associated WHERE
                   rycso_associated.object_filename          = cObjectFileNameNoExt AND
                   rycso_associated.object_extension         = cObjectExt           AND
                   rycso_associated.customization_result_obj = pdCustmisationResultObj 
                   NO-LOCK NO-ERROR.
    
    IF NOT AVAILABLE rycso_associated AND pdCustmisationResultObj NE 0 THEN
        FIND FIRST rycso_associated WHERE
                   rycso_associated.object_filename          = cObjectFileNameNoExt AND
                   rycso_associated.object_extension         = cObjectExt           AND
                   rycso_associated.customization_result_obj = 0
                   NO-LOCK NO-ERROR.    
    
    IF AVAILABLE rycso_associated THEN
        ASSIGN dSmartObjectObj = rycso_associated.smartObject_obj.
    ELSE
        ASSIGN dSmartObjectObj = 0.
    &ENDIF  /* server-side */
    
    RETURN dSmartObjectObj.
END FUNCTION.   /* getSmartObjectObj */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWhereConstantLevel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWhereConstantLevel Procedure 
FUNCTION getWhereConstantLevel RETURNS CHARACTER
    ( INPUT phAttributeBuffer       AS HANDLE,
      INPUT phAttributeField        AS HANDLE  ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Returns a readable indication of where a n attribute is Constant.
    Notes:  * Preprocessors which resolve the Constant-AT values into the values
              Constant in the field are in { ry/inc/ryattstori.i }
              
*** THIS API HAS BEEN DEPRECATED ***
The functionality referred to in this API is no longer supported at runtime - it is
design-time functionality and has been incorporated into the Design Manager.
------------------------------------------------------------------------------*/
    RETURN "*** THIS API HAS BEEN DEPRECATED ***".
END FUNCTION.   /* getWhereConstantLevel */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWhereStoredLevel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWhereStoredLevel Procedure 
FUNCTION getWhereStoredLevel RETURNS CHARACTER
    ( INPUT phAttributeBuffer       AS HANDLE,
      INPUT phAttributeField        AS HANDLE  ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Returns a readable indication of where a n attribute is stored.  
    Notes:  * Preprocessors which resolve the STORED-AT values into the values
              stored in the field are in { ry/inc/ryattstori.i }
*** THIS API HAS BEEN DEPRECATED ***
The functionality referred to in this API is no longer supported at runtime - it is
design-time functionality and has been incorporated into the Design Manager.
------------------------------------------------------------------------------*/
    RETURN "*** THIS API HAS BEEN DEPRECATED ***".
END FUNCTION.   /* getWhereStoredLevel */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-IsA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION IsA Procedure 
FUNCTION IsA RETURNS LOGICAL
    ( INPUT pdInstanceId        AS DECIMAL,
      INPUT pcClassName         AS CHARACTER    ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Determines whether an object inherits from a particular class.
    Notes:  * This is based on the class name.
            * The null value is returned if the object cannot be found in the cache.
              This is because the decision as to whether the object belongs to a 
              class cannot be made or even guessed at unless the obejct is in the cache.
------------------------------------------------------------------------------*/
    DEFINE BUFFER isAObject        FOR cacheObject.
    
    FIND FIRST isAObject WHERE
               isAObject.InstanceId = pdInstanceId
               NO-ERROR.
    IF AVAILABLE isAObject THEN
    DO:
        /* If this is exactly the requested class, then simply return.
         * There is no need to attempt to retrieve/request the class at
         * this stage.
         */
        IF isAObject.ClassName EQ pcClassName THEN
            RETURN TRUE.
                    
        /* The existence of an object in the cache usually means that the 
         * class is also cached. However, this cannot be guaranteed, so we
         * need to attempt to get the class into the cache.
         */
        FIND FIRST ttClass WHERE ttClass.ClassName = IsAObject.ClassName NO-ERROR.
        IF NOT AVAILABLE ttClass THEN
        DO:
            RUN createClassCache ( INPUT IsAObject.ClassName ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ?.
            
            FIND FIRST ttClass WHERE ttClass.ClassName = IsAObject.ClassName NO-ERROR.
        END.
        IF NOT AVAILABLE ttClass THEN RETURN ?.
        
        RETURN CAN-DO(ttClass.InheritsFromClasses, pcClassName).
    END.    /* the object is cached. */    
    ELSE
        RETURN ?.
END FUNCTION.   /* IsA */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isObjectCached) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isObjectCached Procedure 
FUNCTION isObjectCached RETURNS LOGICAL
    ( INPUT pcLogicalObjectName AS CHARACTER,
      INPUT pdUserObj           AS DECIMAL,
      INPUT pcResultCode        AS CHARACTER,
      INPUT pcRunAttribute      AS CHARACTER,
      INPUT pdLanguageObj       AS DECIMAL,
      INPUT plDesignMode        AS LOGICAL         ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  This function indicates whether an object is in cache, or not.  It is
            used mainly where the cache is going to be supplemented from an external
            procedure.
    Notes:  * This function call also has the effect of making the cache_Object buffer
              available. This effect/consequence is important and is used by other APIs.
              These FINDs should stay as FINDs and should not ever be made into
              CAN-FINDS().
*** THIS API HAS BEEN DEPRECATED ***
------------------------------------------------------------------------------*/
    RETURN ?.
END FUNCTION.   /* isObjectCached */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchClassObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION launchClassObject Procedure 
FUNCTION launchClassObject RETURNS HANDLE
    ( INPUT pcClassName             AS CHARACTER ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Returns the handle of the running class object procedure           
    Notes:  * the procedure is laucnehd, if necessary.
    
*** THIS API HAS BEEN DEPRECATED ***
------------------------------------------------------------------------------*/
    RETURN ?.
END FUNCTION.   /* launchClassObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newInstance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newInstance Procedure 
FUNCTION newInstance RETURNS LOGICAL
    ( INPUT pcInstance                  AS character,
      input pcClassName                 as character,
      input pcSuperProcedure            as character,
      input pcSuperProcedureMode        as character        ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PROTECTED
   Purpose: Prepare an instance by defining and preparing its property table
            and set its buffer as the first entry in ADM-DATA.
Parameters: phPropTable - The admprops table UNPRPEPARED.                            
            phInstance  - The handle of the instance being instanciated. 
            phSource    - source-procedure; containr.p that constructs
                          this instance or the manager that launches it.              
     Notes: This is called as early as possible from the main block of a running
            instance (src/adm2/smrtprop.i) before it knows anything really..
            It calls this with itself as instance and source-procedure as the 
            caller. The source-procedure is then checked for information about 
            the callee. The TT is created in the scope of the instance in order 
            to be scoped to the instance.  
         -  Returns TRUE when no call back is found or CurrentLogicalProcedure is
            blank or unknown       
         -  The passed TT is destroyed if an error occurs
------------------------------------------------------------------------------*/      
    DEFINE VARIABLE hBufferField                AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hBuffer                     AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hADMPropsTable              AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hInstance                   as HANDLE     NO-UNDO.
    
    /* Super load */ 
    DEFINE VARIABLE iClass                      AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cClass                      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iSuper                      AS INTEGER    NO-UNDO.
    DEFINE VARIABLE lStoreSuper                 AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cRunName                    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cMode                       as CHARACTER  no-undo.
    DEFINE VARIABLE hClassProcedure             AS HANDLE     NO-UNDO.
    
    /* set attributes */
    DEFINE VARIABLE iSetLoop                    AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iField                      AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iAttributeLoop              AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iAttributeEntry             AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cValue                      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSuperProcedure             AS character  NO-UNDO.
    DEFINE VARIABLE cSuperProcedureMode         AS character  NO-UNDO.
    DEFINE VARIABLE cSuperHandles               as CHARACTER  no-undo.

    DEFINE VARIABLE cDateFormat                 AS CHARACTER  NO-UNDO.
    define variable cNumericSeparator           as character  no-undo.
    define variable cDecimalPoint               as character  no-undo.
    
    define buffer ttClass       for ttClass.
    
    FIND FIRST ttClass WHERE ttClass.ClassName = pcClassName NO-ERROR.
    IF NOT AVAILABLE ttClass THEN
    DO:
        RUN createClassCache ( pcClassName ) NO-ERROR.
        /* Show no messages. The calling procedure needs to cater for the fact that
           no class has been retrieved from the cache.                         */
        FIND FIRST ttClass WHERE ttClass.ClassName = pcClassName NO-ERROR.
        IF NOT AVAILABLE ttClass THEN
        DO:
            MESSAGE
                "Failed to load class:" pcClassName SKIP
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN FALSE.
        END.    /* could not cache class */
    END.      /* n/a cache class */
        
    /* The InstanceBufferHandle will only be invalid the first time any
     * object of this class is ever run in this session.
     */
    IF NOT VALID-HANDLE(ttClass.InstanceBufferHandle) THEN
    DO:
      /* The class table was created (either in buildClassCache or 
         getClassFromClientCache) with American and mdy format - as the initial
         value requires mdy format, unless the format is American and mdy, 
         the create-like statement produces wrong results (6.67 in European 
         changes to 667) hence convert to American and mdy before using 
         create-like. */
       
       ASSIGN cDateFormat            = SESSION:DATE-FORMAT
              cNumericSeparator      = session:numeric-separator
              cDecimalPoint          = session:numeric-decimal-point
              SESSION:DATE-FORMAT    = "mdy":U
              SESSION:NUMERIC-FORMAT = "American":U.
                
        CREATE TEMP-TABLE hADMPropsTable.
        /** Create and prepare the ADM Props Temp-table from Repository info */
        hADMpropsTable:CREATE-LIKE(ttClass.ClassBufferHandle,'idxTargetId':U).
        hADMPropsTable:TEMP-TABLE-PREPARE("ADMReposProps":U).
        ttClass.InstanceBufferHandle = hADMPropsTable:DEFAULT-BUFFER-HANDLE.
        
        /* Reset the values back */
        SESSION:DATE-FORMAT = cDateFormat.
        session:set-numeric-format(cNumericSeparator,cDecimalPoint).                
    END.      /* create the ADMProps TT. */
    
    hInstance = WIDGET-HANDLE(ENTRY(1, pcInstance)) NO-ERROR.
    
    /* now create an entry for this running instance. */
    ttClass.InstanceBufferHandle:BUFFER-CREATE().
    
    /* The InstanceId needs a unique value. */
    assign ttClass.InstanceBufferHandle:buffer-field('InstanceId'):buffer-value = decimal(hInstance)
           ttClass.InstanceBufferHandle:buffer-field('Target'):buffer-value = hInstance
               /* This ADM object is now open for business! (well almost, need supers and properties) 
                  The CHR(1) delimiters are for UserProperties and UserLinks.
                        */
           hInstance:ADM-DATA = STRING(ttClass.InstanceBufferHandle) + CHR(1) + CHR(1).
    
    /* Start the class super procedures. Start the class supers first
           so as to build the stack correctly.
     */
    DO iSuper = 1 TO NUM-ENTRIES(ttClass.SuperProcedures):
        ASSIGN lStoreSuper     = FALSE
               cRunName        = ENTRY(iSuper,ttClass.SuperProcedures)
               hClassProcedure = IF NUM-ENTRIES(ttClass.SuperHandles) >= iSuper
                                 THEN WIDGET-HANDLE(ENTRY(iSuper,ttClass.SuperHandles))
                                 ELSE ?.
        IF NOT VALID-HANDLE(hClassProcedure) or
           NOT CAN-QUERY(hClassProcedure, "FILE-NAME":U) or
           hClassProcedure:FILE-NAME ne cRunName THEN
        DO:        
            /* Search for a running super unless 'stateful' */
            IF NOT ENTRY(iSuper,ttClass.SuperProcedureMode) eq 'STATEFUL':U THEN
            DO:
                hClassProcedure = SESSION:FIRST-PROCEDURE.
                DO WHILE VALID-HANDLE(hClassProcedure) AND hClassProcedure:FILE-NAME NE cRunName:
                    hClassProcedure = hClassProcedure:NEXT-SIBLING.
                END.
                IF VALID-HANDLE(hClassProcedure) AND hClassProcedure:FILE-NAME NE cRunName THEN
                    ASSIGN hClassProcedure = ?.
            END.        /* super not stateful */
            
            IF NOT VALID-HANDLE(hClassProcedure) THEN 
            DO ON STOP UNDO,LEAVE:
                RUN VALUE(cRunName) PERSISTENT SET hClassProcedure.
            END.
            
            IF NOT VALID-HANDLE(hClassProcedure) THEN
            DO:
                MESSAGE
                    "Failed to start super-procedure:" cRunName SKIP
                    "  Physical Name = " hInstance:FILE-NAME    SKIP
                    "  Super Procedure Name = " cRunName        SKIP
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                RETURN FALSE.
            END.
            
            lStoreSuper = IF (ttClass.SuperProcedureMode ne 'STATEFUL':U) THEN TRUE ELSE FALSE.
        END. /* not valid (not found in ttClass - first time ) */
        
        IF VALID-HANDLE(hClassProcedure) THEN     /* stack it */
        DO:
            hInstance:ADD-SUPER-PROCEDURE(hClassProcedure, SEARCH-TARGET).
            IF lStoreSuper THEN
            DO:
                IF NUM-ENTRIES(ttClass.SuperHandles) ge iSuper THEN
                    ENTRY(iSuper,ttClass.SuperHandles) = STRING(hClassProcedure).
                ELSE 
                        ttClass.SuperHandles = ttClass.SuperHandles + (IF iSuper eq 1 THEN '':U ELSE ',':U) 
                                         + STRING(hClassProcedure).
            END.    /* store this super? */
        END. /* valid hClassProcedure */
    END. /* do i = 1 to ttCLass.superprocedures */
    
    /* Start the object supers */
    IF pcSuperProcedure ne '' then
    do:
        /* Default to Stateful, since this is the default in static code. */
        if pcSuperProcedureMode eq '' or pcSuperProcedureMode eq ? then
           pcSuperProcedureMode = 'Stateful'.
            
        /* Start the object super procedure(s) */
        DO iSuper = NUM-ENTRIES(pcSuperProcedure) to 1 by -1:
            ASSIGN hClassProcedure = ?
                   cRunName        = ENTRY(iSuper,pcSuperProcedure).
                    
            /* Search for a running super unless 'stateful' */
            IF pcSuperProcedureMode ne 'STATEFUL':U THEN
            DO:
                hClassProcedure = SESSION:FIRST-PROCEDURE.
                DO WHILE VALID-HANDLE(hClassProcedure) AND hClassProcedure:FILE-NAME NE cRunName:
                    hClassProcedure = hClassProcedure:NEXT-SIBLING.
                END.
                IF VALID-HANDLE(hClassProcedure) AND hClassProcedure:FILE-NAME NE cRunName THEN
                    ASSIGN hClassProcedure = ?.
            END.    /* super not stateful */
            
            IF NOT VALID-HANDLE(hClassProcedure) THEN 
            DO ON STOP UNDO,LEAVE:
                RUN VALUE(cRunName) PERSISTENT SET hClassProcedure.
            END.
            
            IF NOT VALID-HANDLE(hClassProcedure) THEN
            DO:
                MESSAGE
                    "Failed to start super-procedure:" cRunName SKIP
                    "  Physical Name = " hInstance:FILE-NAME    SKIP
                    "  Super Procedure Name = " cRunName        SKIP
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                RETURN FALSE.                   
            END.    /* couldn't start super */
                    
            IF VALID-HANDLE(hClassProcedure) THEN     /* stack it */
            DO:
                hInstance:ADD-SUPER-PROCEDURE(hClassProcedure, SEARCH-TARGET).
                IF pcSuperProcedureMode ne 'Stateless':U THEN
                    cSuperHandles = cSuperHandles
                                  + (IF iSuper eq 1 THEN '':U ELSE ',':U)
                                  + STRING(hClassProcedure).
            END. /* valid hClassProcedure */
        END. /* do i = 1 to  object superprocedures */
            
        /* Store the super handles */
        ttClass.InstanceBufferHandle:BUFFER-FIELD("SuperProcedureMode":U):BUFFER-VALUE = pcSuperProcedureMode.
        ttClass.InstanceBufferHandle:BUFFER-FIELD("SuperProcedureHandle":U):BUFFER-VALUE = cSuperHandles.
    end.    /* object has super procedures */
    
    /* We must set the instance props that are an integral part of the 
       object before we do the set loop, as many set functions have forced
       set for the very reason that they are setting native attributes in
       these handles  */
    ASSIGN ttClass.InstanceBufferHandle:BUFFER-FIELD('ContainerHandle'):BUFFER-VALUE
                 = ENTRY(2,pcInstance) WHEN NUM-ENTRIES(pcInstance) >= 2 
           ttClass.InstanceBufferHandle:BUFFER-FIELD('BrowseHandle'):BUFFER-VALUE
                 = ENTRY(3,pcInstance) WHEN NUM-ENTRIES(pcInstance) >= 3 NO-ERROR.
    
    /* Set 'settable' attributes for the class only. The master properties
       are set in adm-assignObjectProperties, and that API handles whether
       the property can be pushed into the ADMProps table, or whether it
       must be explicitly set.
     */
    do iSetLoop = 1 to num-entries(ttClass.SetList):
        iField = integer(entry(iSetLoop,ttClass.SetList)).
        if lookup(string(iField),ttClass.RunTimeList) eq 0 then
        do:
            assign hBufferField  = ?
                   hBufferField  = ttClass.InstanceBufferHandle:buffer-field(iField) 
                   no-error.
            if valid-handle (hBufferField) then
                dynamic-function("set":U + hBufferField:name in hInstance,
                                 hBufferField:buffer-value    ) no-error.
        end. /* not in runtimelist */
    end. /* loop through settable entries */
    
    ttClass.InstanceBufferHandle:buffer-release().
    
    /* Set the object properties. This API typically
       uses the {set} pseudo-function, which decides,
       based on the existence of an xp preprocessor, 
       whether to push the value into the context 
       table, or whether to force the set.       
     */
    {fn adm-assignObjectProperties hInstance}.
    
    RETURN TRUE.
END FUNCTION.   /* newInstance */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareEntityFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareEntityFields Procedure 
FUNCTION prepareEntityFields RETURNS LOGICAL
      ( phObject        AS HANDLE,
        pcEntityFields  AS CHAR, 
        phBuffer        AS HANDLE,
        pcBufferOptions AS CHAR,
        pcAttributes    AS CHAR,
        pcPropertyLists AS CHAR,
        pcDelimiters    AS CHAR) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
   Purpose: Prepare entity Field attributes for a RUNNING object.   
Parameters: 
      phObject        - The handle of the running instance of the object 
      pcEntityFields  - Comma separate list of column instance names, 
                        All Classes do not have DataField instances (yet), so 
                        the resolution of the entity master will be based on 
                        other information. 
                        Currently supports Data Class:
                        - Data will use call back of columnDbColumn and assume 
                          one-to-one table.field is entity name.                             
      phBuffer        - Optional buffer handle to prepare.
                        This is currently a prepared buffer, but may later 
                        be extended to also add fields to an unprepared
                        buffer.      
      pcBufferOptions - Options for the buffer preparation. 
                        The knowledge of which DataField attribute to 
                        apply to the buffer attributes is embedded in this
                        method.                                                              
                      - Comma separated list of buffer attributes to set 
                        INITIAL,LABEL,COLUMN-LABEL etc.. 
                      - ALL - set all supported buffer attributes  
                      Future option for unprepared buffer:                                   
                      - PREPARE - Prepare when done 
      pcAttributes    -  Comma separated list with attributes to that build
                         lists from, corresponding to EntityField property.  
      pcPropertyLists -  Comma separated list with list properties to set 
                         in the passed phObject with the list of values from 
                         the  corresponding attributes in pcAttributes.  
      pcDelimiters    -  Comma separated list with delimiters to use for the 
                         list properties in pcPropertyList. 
                         - no delimiter is comma  
                         - integers indicates a CHR(integer) delimiter                                                  
    Notes:  
------------------------------------------------------------------------------*/   
 &IF DEFINED(Server-Side) NE 0 &THEN
 DEFINE VARIABLE iField                  AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cEntityField            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDbFieldName            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iAttribute              AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cAttribute              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cReqAttributes          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cBufAttributes          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValue                  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hField                  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hClassBuffer            AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hClassAttributeBuffer   AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cDataType               AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValueList              AS CHARACTER  EXTENT 20 NO-UNDO.
 DEFINE VARIABLE cDelimiter              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE xcAttributeMap          AS CHARACTER  NO-UNDO INITIAL {&buffer-attribute-map}.
 DEFINE VARIABLE cObjectTypeObjs         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cClassBufferHandles     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iAttrDataType           AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cClassDefaultAttributes AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cClassAttrDefaultValues AS CHARACTER  NO-UNDO.

 DEFINE BUFFER ryc_smartobject     FOR ryc_smartobject.
 DEFINE BUFFER gsc_object_type     FOR gsc_object_type.
 DEFINE BUFFER ryc_attribute_value FOR ryc_attribute_value.
 DEFINE BUFFER ryc_Attribute       FOR ryc_Attribute.

 /* Deal with col label inheriting from label when we do not know the order
    of the attributes (this is the quick version) */  
 DEFINE VARIABLE lIsColLabelSet         AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lIsColLabelUnknown     AS LOGICAL    NO-UNDO.

 IF NUM-ENTRIES(pcAttributes) > 20 THEN
 DO:
   MESSAGE
      "The maximum number of attribute entries passed to"  PROGRAM-NAME(1) "was exceeded." SKIP(1)
      "Maximum number attributes that can be handled is 20."  
    VIEW-AS ALERT-BOX INFORMATION. 
 END.
 
 /* Requested attributes is a combination of pcAttributes and pcBufferOptions */
 ASSIGN cReqAttributes = pcAttributes.
 /* add possible additional buffer attributes to end of loop list */
 IF VALID-HANDLE(phBuffer) 
 THEN DO:
     DO iLoop = 1 TO NUM-ENTRIES(xcAttributeMap) BY 2:
         ASSIGN cAttribute = ENTRY(iLoop,xcAttributeMap).
         IF LOOKUP(cAttribute,pcAttributes) = 0 
         AND (LOOKUP('ALL':U,pcBufferOptions) > 0 OR LOOKUP(cAttribute,pcBufferOptions) > 0) THEN
           ASSIGN cReqAttributes = cReqAttributes + ENTRY(iLoop + 1,xcAttributeMap) + ",":U
                  cBufAttributes = cBufAttributes + cAttribute + ",":U. 
     END.
     ASSIGN cReqAttributes = RIGHT-TRIM(cReqAttributes, ",":U)
            cBufAttributes = RIGHT-TRIM(cBufAttributes, ",":U).
 END.

 DO iField = 1 TO NUM-ENTRIES(pcEntityFields):
   ASSIGN
     cEntityField = ENTRY(iField,pcEntityFields) 
     cDbFieldName = {fnarg columnDbColumn cEntityField phObject}
     hField       = IF VALID-HANDLE(phBuffer)
                    THEN phBuffer:BUFFER-FIELD(cEntityField)
                    ELSE ?
     /* col-label inherits from label, but we do not know the order of 
        attributes, so we keep track of whther it has been set */
     lIsColLabelUnknown = FALSE 
     lIsColLabelSet     = FALSE. 
     
   IF cDbFieldName > '':U THEN
       FIND ryc_smartobject 
            WHERE ryc_smartobject.object_filename = cDbFieldname 
              AND ryc_smartobject.customization_result_obj = 0
            NO-LOCK NO-ERROR.
   ELSE
       FIND ryc_smartobject 
            WHERE ryc_smartobject.object_filename = cEntityField        
              AND ryc_smartobject.customization_result_obj = 0
            NO-LOCK NO-ERROR.

   IF AVAIL ryc_smartobject THEN
   DO:
     DO iAttribute = 1 TO NUM-ENTRIES(cReqAttributes):
       ASSIGN
         cAttribute = ENTRY(iAttribute,cReqAttributes)
         cValue     = '':U.

       FIND ryc_attribute_value 
            WHERE ryc_attribute_value.object_type_obj     = ryc_smartobject.object_type_obj
              AND ryc_attribute_value.smartobject_obj     = ryc_smartobject.Smartobject_obj
              AND ryc_attribute_value.object_instance_obj = 0          
              AND ryc_attribute_value.attribute_label     = cAttribute 
              AND ryc_attribute_value.container_smartobject_obj = 0
            NO-LOCK NO-ERROR.

       IF AVAIL ryc_attribute_value THEN
           /* To save a read on the attribute table, see if we can find it in the hardcoded attr data type list */
           IF CAN-DO("DefaultValue,Label,ColumnLabel,Help,Format":U, cAttribute) THEN
               ASSIGN cValue = ryc_attribute_value.character_value.
           ELSE DO:
               FIND ryc_attribute NO-LOCK
                    WHERE ryc_attribute.attribute_label = cAttribute.
               CASE ryc_attribute.data_type:
                   WHEN {&CHARACTER-DATA-TYPE} THEN cValue = ryc_attribute_value.character_value.
                   WHEN {&LOGICAL-DATA-TYPE}   THEN cValue = STRING(ryc_attribute_value.logical_value).
                   WHEN {&INTEGER-DATA-TYPE}   THEN cValue = STRING(ryc_attribute_value.integer_value).
                   WHEN {&DECIMAL-DATA-TYPE}   THEN cValue = STRING(ryc_attribute_value.decimal_value).
                   WHEN {&ROWID-DATA-TYPE}     THEN cValue = ryc_attribute_value.character_value.
                   WHEN {&DATE-DATA-TYPE}      THEN cValue = STRING(ryc_attribute_value.date_value).
                   WHEN {&RECID-DATA-TYPE}     THEN cValue = STRING(ryc_attribute_value.integer_value).                                                
               END CASE.
           END.
       ELSE /* no attributevalue*/
           /* Get default value */
           CASE cAttribute:
             WHEN "DefaultValue":U THEN
             DO:
               cDataType = DYNAMIC-FUNCTION('columnDataType':U IN phObject,cEntityField).
               CASE cDataType:
                 WHEN 'CHARACTER':U THEN cValue = '':U.
                 WHEN 'DECIMAL':U   THEN cValue = '0':U.
                 WHEN 'DATE':U      THEN cValue = '?':U.
                 WHEN 'INTEGER':U   THEN cValue = '0':U.
                 WHEN 'LOGICAL':U   THEN cValue = 'no':U.
                 OTHERWISE               cValue = '?'.
               END CASE.
             END.
             WHEN "Label":U THEN
               cValue = cEntityField. 
             WHEN "ColumnLabel":U THEN
               cValue = ?.
             WHEN "Format":U THEN
             DO:
               cDataType = DYNAMIC-FUNCTION('columnDataType':U IN phObject,cEntityField).
               CASE cDataType:
                 WHEN 'CHARACTER':U THEN
                   cValue = 'x(8)':U.
                 WHEN 'DECIMAL':U THEN
                   cValue = '->>,>>9.99':U.
                 WHEN 'DATE':U THEN
                   cValue = '99/99/99':U.
                 WHEN 'INTEGER':U THEN
                   cValue = '->,>>>,>>9':U.
                 WHEN 'LOGICAL':U THEN
                   cValue = 'yes/no':U.
                 OTHERWISE 
                   cValue = ?.
               END CASE.
             END.
             OTHERWISE DO: /* get the default value from the class */
                 /* DB access is expensive.  Don't read the gsc_object_type table if we don't have to. */
                 IF LOOKUP(cAttribute, cClassDefaultAttributes, CHR(3)) <> 0 THEN
                     ASSIGN cValue = ENTRY(LOOKUP(cAttribute, cClassDefaultAttributes, CHR(3)), cClassAttrDefaultValues, CHR(3)).
                 ELSE DO:
                     IF LOOKUP(STRING(ryc_smartobject.object_type_obj), cObjectTypeObjs, CHR(3)) <> 0 THEN
                         ASSIGN hClassAttributeBuffer = WIDGET-HANDLE(ENTRY(
                                                                      LOOKUP(STRING(ryc_smartobject.object_type_obj), cObjectTypeObjs, CHR(3)
                                                                     ), cClassBufferHandles, CHR(3))).
                     ELSE DO:
                         FIND gsc_object_type NO-LOCK
                              WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj.

                         ASSIGN hClassBuffer          = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN TARGET-PROCEDURE, INPUT gsc_object_type.object_type_code)
                                hClassAttributeBuffer = hClassBuffer:BUFFER-FIELD('ClassBufferHandle':U):BUFFER-VALUE
                                cObjectTypeObjs       = cObjectTypeObjs + STRING(gsc_object_type.object_type_obj) + CHR(3)
                                cClassBufferHandles   = cClassBufferHandles + STRING(hClassAttributeBuffer) + CHR(3).
                     END.
                     ASSIGN cValue                  = hClassAttributeBuffer:BUFFER-FIELD(cAttribute):INITIAL
                            cClassDefaultAttributes = cClassDefaultAttributes + cAttribute + CHR(3)
                            cClassAttrDefaultValues = cClassAttrDefaultValues + cValue     + CHR(3).
                 END.
             END.
           END CASE.

       IF VALID-HANDLE(hField)
       AND (LOOKUP('ALL':U,pcBufferOptions) > 0 OR LOOKUP(cAttribute,cBufAttributes) > 0)
       AND CAN-DO("Label,ColumnLabel,Format":U, cAttribute) THEN
           CASE cAttribute:
             WHEN "Label":U THEN
             DO:
               hField:LABEL = IF cValue = ? THEN cEntityField ELSE cValue.
               /* We cannot set it to unknown, so we have to deal with 
                  inheritance here */
               IF lIsColLabelSet AND lIsColLabelUnknown THEN
                 hField:COLUMN-LABEL = cEntityField.
             END.

             WHEN "ColumnLabel":U THEN
               ASSIGN
                 hField:COLUMN-LABEL = (IF cValue = ? OR cValue = '?':U
                                        THEN hField:LABEL
                                        ELSE cValue)
                 lIsColLabelSet      = TRUE
                 lIsColLabelUnknown  = cValue = ?.

             WHEN "Format":U THEN
               hField:FORMAT = cValue.
           END CASE.

       IF iAttribute <= NUM-ENTRIES(pcPropertyLists) THEN
        ASSIGN
          cDelimiter             = ENTRY(iAttribute,pcDelimiters)
          cDelimiter             = IF cDelimiter >= "1":U AND cDelimiter <= "9":U
                                   THEN CHR(INT(cDelimiter))
                                   ELSE IF cDelimiter = '':U 
                                   THEN ",":U
                                   ELSE cDelimiter
          cValueList[iAttribute] = cValueList[iAttribute]
                                 + (IF iField = 1 THEN '':U ELSE cDelimiter)
                                 + (IF cValue = ? THEN '?':U ELSE cValue).
     END.
   END.
 END.
 
 DO iAttribute = 1 TO NUM-ENTRIES(pcPropertyLists):
     DYNAMIC-FUNCTION('set':U + ENTRY(iAttribute,pcPropertyLists) IN phObject,cValueList[iAttribute]).
 END.
 
 RETURN TRUE.

 &ELSE
 
 RETURN FALSE.
 
 &ENDIF
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareInstance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareInstance Procedure 
FUNCTION prepareInstance RETURNS LOGICAL
    ( INPUT pcInstance              AS CHARACTER, 
      INPUT phSource                AS HANDLE  ) :
/*------------------------------------------------------------------------------
   Purpose: Prepare an instance by defining and preparing its property table
            and set its buffer as the first entry in ADM-DATA.
Parameters: phPropTable - The admprops table UNPRPEPARED.                            
            phInstance  - The handle of the instance being instanciated. 
            phSource    - source-procedure; containr.p that constructs
                          this instance or the manager that launches it.              
     Notes: This is called as early as possible from the main block of a running
            instance (src/adm2/smrtprop.i) before it knows anything really..
            It calls this with itself as instance and source-procedure as the 
            caller. The source-procedure is then checked for information about 
            the callee. The TT is created in the scope of the instance in order 
            to be scoped to the instance.  
         -  Returns TRUE when no call back is found or CurrentLogicalProcedure is
            blank or unknown       
         -  Returns FALSE only when an error occurs in the repository retrieval.
         -  The passed TT is destroyed if an error occurs
         -  The value of the "getCurrentLogicalName" return value should be:
            - ObjectName, for containers or single objects.
            - ObjectName#CHR(1)#InstanceName for contained instances.
            In other words, the first entry in a CHR(1)-delimited list will
            ALWAYS be the container object.
------------------------------------------------------------------------------*/  
    DEFINE BUFFER bCache FOR cacheObject.
    
    DEFINE VARIABLE cLogicalObjectName          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cObjectName                 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cInstanceName               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hCaller                     AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hInstance                   AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hBufferField                AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hBuffer                     AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hADMPropsTable              AS HANDLE     NO-UNDO.
    DEFINE VARIABLE dInstanceId                 AS DECIMAL    NO-UNDO.
    /* Super load */ 
    DEFINE VARIABLE iClass                      AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cClass                      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iSuper                      AS INTEGER    NO-UNDO.
    DEFINE VARIABLE lStoreSuper                 AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cRunName                    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hClassProcedure             AS HANDLE     NO-UNDO.
    /* set attributes */
    DEFINE VARIABLE iSetLoop                    AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iField                      AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iAttributeLoop              AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iAttributeEntry             AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cValue                      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lHasSuperProcedure          AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lHasSuperProcedureMode      AS LOGICAL    NO-UNDO.

    DEFINE VARIABLE cDateFormat                 AS CHARACTER  NO-UNDO.
    define variable cNumericSeparator           as character  no-undo.
    define variable cDecimalPoint               as character  no-undo.
        
    hCaller = DYNAMIC-FUNCTION("getTargetProcedure":U IN phSource) NO-ERROR.    
    IF NOT VALID-HANDLE(hCaller) THEN
      hCaller = phSource.
    /* Get the object from the Repository Cache and reposition to that record.
       The session manager sets this before the launch (launchContainer).
       The dynamic container sets it to ContainerName#CHR(1)#InstanceName
     */
    cLogicalObjectName = DYNAMIC-FUNCTION("getCurrentLogicalName":U IN hCaller) 
                         NO-ERROR.

    /* If there is no data from a call back we use the prop file */       
    IF cLogicalObjectName EQ ? OR cLogicalObjectName EQ "":U THEN
      RETURN TRUE. 
    
    hInstance  = WIDGET-HANDLE(ENTRY(1,pcInstance)).
           
    /* Get the requested object from the cache.
     * Even of there is only one entry in the cLogicalObjectName variable,
     * the cObjectName will be correctly populated.
     */
    ASSIGN cObjectName   = ENTRY(1, cLogicalObjectName, CHR(1))
           cInstanceName = ENTRY(2, cLogicalObjectName, CHR(1))
           NO-ERROR.
    /* It is quicker to find the cache records based on an instance ID;
       particularly for instances but this is also useful for containers,
       particularly when they are themselves contained.
     */
    FIND bCache WHERE
         bCache.InstanceId = DECIMAL(cObjectName)
         NO-ERROR.
    
    /* First look if the container or master object is cached. 
     */
    IF NOT AVAILABLE bCache THEN     
       FIND bCache WHERE
            bCache.ObjectName          = cObjectName AND
            bcache.ContainerInstanceId = 0
            NO-ERROR.
    
    IF NOT AVAILABLE bCache THEN
    DO:
        /* If an instance is requested, then attempt to retrieve it in the same call.         
         */
        RUN cacheRepositoryObject ( INPUT cObjectName,
                                    INPUT cInstanceName,
                                    INPUT ?,            /* pcRunAttribute */
                                    INPUT ?             /* pcResultCode */        ) NO-ERROR.
        
        /* If we have had to go back to the DB to retrieve the object, then it will
           only exist as a container master object, and not as a contained object.
           Only check for existence as such.
         */
        FIND bCache WHERE
             bCache.ObjectName          = cObjectName AND
             bcache.ContainerInstanceId = 0
             NO-ERROR.
    END.    /* n/a cache record */
                             
    /* Could not find the object in the Repository or cache. Return an error condition. */
    IF NOT AVAILABLE bCache THEN
    DO:
        MESSAGE
            "Failed to retrieve repository object data:" SKIP
            "  Logical Name  = " cLogicalObjectName      SKIP
            "  Physical Name = " hInstance:FILE-NAME    SKIP
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN FALSE.
    END.  /* could not get object from Repository cache */
    
    ASSIGN dInstanceId = bCache.InstanceId.
            
    IF cInstanceName NE "":U THEN
    DO:
        FIND bCache WHERE
             bCache.ObjectName          = cInstanceName AND
             bCache.ContainerInstanceId = dInstanceId
             NO-ERROR.
        
        /* The instance name may not have been retrieved yet,
           so attempt to retrieve it now.
         */
        IF NOT AVAILABLE bCache THEN
        DO:
            RUN cacheRepositoryObject ( INPUT cObjectName,
                                        INPUT cInstanceName,
                                        INPUT ?,            /* pcRunAttribute */
                                        INPUT ?             /* pcResultCode */        ) NO-ERROR.
                                        
            FIND bCache WHERE
                 bCache.ObjectName          = cInstanceName AND
                 bCache.ContainerInstanceId = dInstanceId
                 NO-ERROR.
            IF NOT AVAILABLE bCache THEN
            DO:
                MESSAGE
                    "Failed to retrieve repository object data:" SKIP
                    "  Instance Name  = " cInstanceName          SKIP
                    "  Container Name = " cObjectName            SKIP
                    "  Physical Name  = " hInstance:FILE-NAME    SKIP
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                RETURN FALSE.
            END.    /* couldn't retrieve instance */
        END.    /* instance not cached */
    END.        /* this is a contained instance */
    
    /* At this stage there should always be an available bCache record. */
    FIND FIRST ttClass WHERE ttClass.ClassName = bCache.ClassName NO-ERROR.
    IF NOT AVAILABLE ttClass THEN
    DO:
        RUN createClassCache IN TARGET-PROCEDURE ( bCache.ClassName ) NO-ERROR.
        /* Show no messages. The calling procedure needs to cater for the fact that
           no class has been retrieved from the cache.                         */
        FIND FIRST ttClass WHERE ttClass.ClassName = bCache.ClassName NO-ERROR.
        IF NOT AVAILABLE ttClass THEN
        DO:
            MESSAGE
                "Failed to load class:" bCache.ClassName    SKIP
                "  Logical Name  = " cLogicalObjectName     SKIP
                "  Physical Name = " hInstance:FILE-NAME    SKIP
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN FALSE.
        END.    /* could not cache class */
    END.      /* n/a cache class */
    
    /* The InstanceBufferHandle will only be invalid the first time any
     * object of this class is ever run in this session.
     */
    IF NOT VALID-HANDLE(ttClass.InstanceBufferHandle) THEN
    DO:
      /* The class table was created (either in buildClassCache or 
         getClassFromClientCache) with American and mdy format - as the initial
         value requires mdy format, unless the format is American and mdy, 
         the create-like statement produces wrong results (6.67 in European 
         changes to 667) hence convert to American and mdy before using 
         create-like. */
         
       ASSIGN cDateFormat            = SESSION:DATE-FORMAT
              cNumericSeparator      = session:numeric-separator
              cDecimalPoint          = session:numeric-decimal-point
              SESSION:DATE-FORMAT    = "mdy":U
              SESSION:NUMERIC-FORMAT = "American":U.
       
        CREATE TEMP-TABLE hADMPropsTable.
        /** Create and prepare the ADM Props Temp-table from Repository info */
        hADMpropsTable:CREATE-LIKE(ttClass.ClassBufferHandle,'idxTargetId':U).
        hADMPropsTable:TEMP-TABLE-PREPARE("ADMReposProps":U).
        ttClass.InstanceBufferHandle = hADMPropsTable:DEFAULT-BUFFER-HANDLE.
        
        /* Reset the values back */
        ASSIGN SESSION:DATE-FORMAT = cDateFormat.
        session:set-numeric-format(cNumericSeparator,cDecimalPoint).                
    END.      /* create the ADMProps TT. */
    
    /* now create an entry for this running instance. */
    ttClass.InstanceBufferHandle:BUFFER-CREATE().
    
    ASSIGN /* This ADM object is now open for business! (well almost, need supers) 
            * The CHR(1) delimiters are for UserProperties and UserLinks.
            */            
          hInstance:ADM-DATA = STRING(ttClass.InstanceBufferHandle) + CHR(1) + CHR(1)
          /* Assign the target as the key to be  used in set and get */
          ttClass.InstanceBufferHandle:BUFFER-FIELD("Target":U):BUFFER-VALUE = hInstance
          /* We want to use this ID for refetching the object buffer from the cache, 
           * as well as being able to use it for joining to the various other 
           * cache* buffers.
           * We assign this value directly, since smart.p has not been started.
           */
          ttClass.InstanceBufferHandle:BUFFER-FIELD("InstanceID":U):BUFFER-VALUE = bCache.InstanceId.

    /* Populate from cacheObject.AttrValues. Only update the 'set' attributes later.
       
       We need to know whether there is an overridden value for the SuperProcedure
       attribute. If there is, then fine and well and we use that value. If not, then
       we need to set the value to blank so that we don't run the class super procedures
       when starting the object.
       
       Also check if there is an overridden SuperProcedureMode attribute. If not, then
       the current, historical behaviour is STATEFUL (runs once per object instance).
     */
    ASSIGN lHasSuperProcedure     = NO
           lHasSuperProcedureMode = NO.
         
    DO iAttributeLoop = 1 TO NUM-ENTRIES(bCache.AttrOrdinals):
        ASSIGN iAttributeEntry = INTEGER(ENTRY(iAttributeLoop,bCache.AttrOrdinals))
               hBufferField    = ?
               hBufferField    = ttClass.InstanceBufferHandle:BUFFER-FIELD(iAttributeEntry)
               NO-ERROR.
        
        /* The 4GL takes care of the datatype conversions. */
        IF VALID-HANDLE(hBufferField) THEN
        DO:
            /*  settable properties will be applied after the supers have been 
                loaded  */
          IF NOT CAN-DO(ttClass.SetList, STRING(iAttributeEntry)) 
          /* there should not be any runtime attributes here, but since the code 
             below that calls the set function skips runtime attributes we make 
             sure this does the opposite */  
          OR CAN-DO(ttClass.RunTimeList, STRING(iAttributeEntry))  THEN
          DO:
             CASE hBufferField:DATA-TYPE:
                 WHEN "DECIMAL":U THEN ASSIGN hBufferField:BUFFER-VALUE = DECIMAL(ENTRY(iAttributeLoop, bCache.AttrValues, {&Value-Delimiter})).
                 WHEN "INTEGER":U THEN ASSIGN hBufferField:BUFFER-VALUE = INTEGER(ENTRY(iAttributeLoop, bCache.AttrValues, {&Value-Delimiter})).
                 WHEN "DATE":U THEN ASSIGN hBufferField:BUFFER-VALUE = DATE(ENTRY(iAttributeLoop, bCache.AttrValues, {&Value-Delimiter})).
                 WHEN "LOGICAL":U THEN ASSIGN hBufferField:BUFFER-VALUE = LOGICAL(ENTRY(iAttributeLoop, bCache.AttrValues, {&Value-Delimiter})).
                 WHEN "ROWID":U THEN ASSIGN hBufferField:BUFFER-VALUE = TO-ROWID(ENTRY(iAttributeLoop, bCache.AttrValues, {&Value-Delimiter})).
                 WHEN "HANDLE":U THEN ASSIGN hBufferField:BUFFER-VALUE = ?.    /* handles are always null from the repository. */
                 OTHERWISE  ASSIGN hBufferField:BUFFER-VALUE = ENTRY(iAttributeLoop, bCache.AttrValues, {&Value-Delimiter}).
             END.    /* set the value */
          END.

            CASE hBufferField:NAME:
                WHEN "SuperProcedure":U THEN ASSIGN lHasSuperProcedure = TRUE.
                WHEN "SuperProcedureMode":U THEN ASSIGN lHasSuperProcedureMode = TRUE.                
            END.    /* buffer field name */            
        END.    /* valid buffer field */
    END.    /* attribute loop */
    
    /* Apply SuperProcedure defaults in the absence of overrides. */
    IF NOT lHasSuperProcedure THEN
        ASSIGN ttClass.InstanceBufferHandle:BUFFER-FIELD("SuperProcedure":U):BUFFER-VALUE = "":U.
    
    IF NOT lHasSuperProcedureMode THEN
    DO:
        IF lHasSuperProcedure THEN
            ASSIGN ttClass.InstanceBufferHandle:BUFFER-FIELD("SuperProcedureMode":U):BUFFER-VALUE = "STATEFUL":U.
        ELSE
            ASSIGN ttClass.InstanceBufferHandle:BUFFER-FIELD("SuperProcedureMode":U):BUFFER-VALUE = "":U.
    END.    /* has no super procedure mode override. */            
    
    DO iSuper = 1 TO NUM-ENTRIES(ttClass.SuperProcedures):
        ASSIGN lStoreSuper     = FALSE
               cRunName        = ENTRY(iSuper,ttClass.SuperProcedures)
               hClassProcedure = IF NUM-ENTRIES(ttClass.SuperHandles) >= iSuper
                                 THEN WIDGET-HANDLE(ENTRY(iSuper,ttClass.SuperHandles))
                                 ELSE ?.
        IF NOT VALID-HANDLE(hClassProcedure)
        OR NOT CAN-QUERY(hClassProcedure, "FILE-NAME":U)
        OR hClassProcedure:FILE-NAME <> cRunName THEN
        DO:
            /* Search for a running super unless 'stateful' */
            IF NOT ENTRY(iSuper,ttClass.SuperProcedureMode) = 'STATEFUL':U THEN
            DO:
                hClassProcedure = SESSION:FIRST-PROCEDURE.
                DO WHILE VALID-HANDLE(hClassProcedure) AND hClassProcedure:FILE-NAME NE cRunName:
                    hClassProcedure = hClassProcedure:NEXT-SIBLING.
                END.
                IF VALID-HANDLE(hClassProcedure) AND hClassProcedure:FILE-NAME NE cRunName THEN
                    ASSIGN hClassProcedure = ?.
            END.
            
            IF NOT VALID-HANDLE(hClassProcedure) THEN 
            DO ON STOP UNDO,LEAVE:
                RUN VALUE(cRunName) PERSISTENT SET hClassProcedure.
            END.
            
            IF NOT VALID-HANDLE(hClassProcedure) THEN
            DO:
                MESSAGE
                    "Failed to start super-procedure:" cRunName SKIP
                    "  Logical Name  = " cLogicalObjectName     SKIP
                    "  Physical Name = " hInstance:FILE-NAME    SKIP
                    "  Super Procedure Name = " cRunName        SKIP
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                RETURN FALSE.
            END.
            
            lStoreSuper = IF (ttClass.SuperProcedureMode <> 'STATEFUL':U) THEN TRUE ELSE FALSE.
        END. /* not valid (not found in ttClass - first time ) */
        
        IF VALID-HANDLE(hClassProcedure) THEN     /* stack it */
        DO:
            hInstance:ADD-SUPER-PROCEDURE(hClassProcedure, SEARCH-TARGET).
            IF lStoreSuper THEN
            DO:
                IF NUM-ENTRIES(ttClass.SuperHandles) >= iSuper THEN
                    ENTRY(iSuper,ttClass.SuperHandles) = STRING(hClassProcedure).
                ELSE 
                    ttClass.SuperHandles = ttClass.SuperHandles + (IF iSuper = 1 THEN '':U ELSE ',':U) 
                                         + STRING(hClassProcedure).
            END.    /* store this super? */
          END. /* valid hClassProcedure */
    END. /* do i = 1 to ttCLass.superprocedures */
    
    /* We must set the instance props that are an integral part of the 
       object before we do the set loop, as many set functions have forced
       set for the very reason that they are setting native attributes in
       these handles  */
    ASSIGN ttClass.InstanceBufferHandle:BUFFER-FIELD('ContainerHandle'):BUFFER-VALUE
                 = ENTRY(2,pcInstance) WHEN NUM-ENTRIES(pcInstance) >= 2 
           ttClass.InstanceBufferHandle:BUFFER-FIELD('BrowseHandle'):BUFFER-VALUE
                 = ENTRY(3,pcInstance) WHEN NUM-ENTRIES(pcInstance) >= 3 NO-ERROR.     
                 
    /* Set 'settable' attributes.
       We need to extract the field number and used this to set the attribute.
     */
    DO iSetLoop = 1 TO NUM-ENTRIES(ttClass.SetList):
      iField        = INTEGER(ENTRY(iSetLoop,ttClass.SetList)).
      IF LOOKUP(STRING(iField),ttClass.RunTimeList) = 0 THEN 
      DO:
        ASSIGN
          hBufferField  = ?
          hBufferField  = ttClass.InstanceBufferHandle:BUFFER-FIELD(iField) NO-ERROR.
        IF VALID-HANDLE(hBufferField) THEN
        DO:
          ASSIGN
            iAttributeEntry = LOOKUP(STRING(iField), bCache.AttrOrdinals)
            cValue = IF iAttributeEntry > 0 THEN
                     ENTRY(iAttributeEntry, bCache.AttrValues, {&Value-Delimiter})
                     ELSE hBufferField:BUFFER-VALUE.

          DYNAMIC-FUNCTION("set":U + hBufferField:NAME IN hInstance,cValue) NO-ERROR.
        END. /* valid-handle(hBufferField) */
      END. /* not in runtimelist */
    END. /* loop through settable entries */
    
    RETURN TRUE.
END FUNCTION.   /* prepareInstance */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareRowObjectColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareRowObjectColumns Procedure 
FUNCTION prepareRowObjectColumns RETURNS LOGICAL
  (phRowObjectTable         AS HANDLE,
   pcEntities               AS CHAR, 
   pcColumns                AS CHAR,
   pcColumnsByEntity        AS CHAR,
   pcRenameColumnsByEntity  AS CHAR) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
 Purpose   : Prepares rowbject columns from Repository, 
             returns FALSE if it fails  
 Parameters: 
   phRowObjectTable         - RowObject Temp-table handle
                               - unprepared signals a Dynamic TT
                               - prepared is a static TT.  
   pcEntities               - List of entities (PhysicalTables) 
   pcColumns                - List of Columns to add or update.
                              This decides the order of the columns in the TT. 
   pcColumnsByEntity        - The same columns as pcColumns, but grouped by 
                              Entity, where each entity's list is separated 
                              by {&adm-tabledelimiter}
   pcRenameColumnsByEntity  - Rename list for each entity separated by 
                              {&adm-tabledelimiter}. Each list is 
                              comma-separated pairs where the RowObject column
                              name is first and the entity name is second.  
 Notes    : The passed columns will be added to passed TT if the TT is not 
            prepared, otherwise this function will only assign format and 
            labels. 
          - if the passed temp-table is prepared the function will always 
            return true even if the filed is not found. calculated columns 
            will be ignored.   
------------------------------------------------------------------------------*/
 DEFINE VARIABLE iEntity               AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cEntity               AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iColumn               AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cColumn               AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDbColumn             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQualifiedColumns     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cEntityColumns        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRenameColumns        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cColumnsSortedByTable AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCacheEntities        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iPos                  AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iDbColumns            AS INTEGER    NO-UNDO.
 DEFINE VARIABLE hEntityField          AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hColumn               AS HANDLE     NO-UNDO.
 DEFINE VARIABLE lOk                   AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cEntityField          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataType             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cFormat               AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDefaultValue         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cLabel                AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cColumnLabel          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cAttributeValues      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cAttributes           AS CHARACTER  NO-UNDO
      INIT "Data-type,Format,DefaultValue,Label,ColumnLabel":U.
 DEFINE VARIABLE hRowObjectTable       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hRowObject            AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cInitial              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iNumEntities          AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cUnassignedCalc       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNewUnassigned        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iVar                  AS INTEGER    NO-UNDO.
    DEFINE variable cQualifiedCalcFields    as character         no-undo. 
 DEFINE VARIABLE cLanguageCode         AS CHARACTER  NO-UNDO.

 DEFINE BUFFER bEntity  FOR ttEntity.
 DEFINE BUFFER bEntity2 FOR ttEntity.
 

 /* Retrieve CurrentLanguageCode */
 cLanguageCode = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, "CurrentLanguageCode":U, YES).
 IF cLanguageCode = ? OR cLanguageCode = "":U THEN cLanguageCode = "NONE":U.

 /* Create a unique lookup list by replacing table delimiters with comma.  */
 ASSIGN
   cColumnsSortedByTable = REPLACE(pcColumnsByEntity,{&adm-tabledelimiter},',':U)
   iNumEntities = NUM-ENTRIES(pcEntities).

 IF NOT phRowObjectTable:PREPARED THEN
   IF NUM-ENTRIES(pcColumnsByEntity, {&adm-tabledelimiter}) > iNumEntities THEN
     cUnassignedCalc = ENTRY(iNumEntities + 1, pcColumnsByEntity, {&adm-tabledelimiter}).
 
 /* Ensure the rename list has entries for each table */
 IF pcRenameColumnsByEntity = '':U THEN
   pcRenameColumnsByEntity = FILL({&adm-tabledelimiter}, iNumEntities - 1).
 
 /* Ensure that all referenced entities are cached */
 DO iEntity = 1 TO iNumEntities:
   ASSIGN
     cEntity           = ENTRY(iEntity,pcEntities)
     cCacheEntities    = cCacheEntities 
                       + (IF NOT CAN-FIND(FIRST bEntity WHERE bEntity.EntityName = cEntity AND bEntity.LanguageCode = cLanguageCode)
                          AND LOOKUP(cEntity,cCacheEntities) = 0
                          THEN ',':U + cEntity
                          ELSE '':U).
 END.
 cCacheEntities    = LEFT-TRIM(cCacheEntities,',':U).
 IF cCacheEntities > '':U THEN
 DO:
   RUN createEntityCache IN TARGET-PROCEDURE ( cCacheEntities, cLanguageCode ) NO-ERROR.

   /* if failed return false, unless prepared, which currently is allowed to 
      work without entities  */
   IF (ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U) 
   AND phRowObjectTable:PREPARED = FALSE THEN 
   DO:
     MESSAGE  "Failed to add columns to the RowObjectTable." SKIP
              "Missing Entity/Entities:" cCacheEntities SKIP(1)
              (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE)
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
     RETURN FALSE.
   END. /* if error */
 END. /* cache missing entities */

 /* Build a list that corresponds to ColumnsByEntity where the columns are
    qualified with the entity number and the entity column name is resolved.
    (The number qualifier is used to ensure list is under 32K) */
 DO iEntity = 1 TO iNumEntities: 
   ASSIGN
     cEntity           = ENTRY(iEntity,pcEntities)
     cRenameColumns    = ENTRY(iEntity,pcRenameColumnsByEntity,{&adm-tabledelimiter})
     cEntityColumns    = ENTRY(iEntity,pcColumnsByEntity,{&adm-tabledelimiter}).
     
   /* check if any Calculated Fields belong to this Entity and if so, append them to 
      the Entity Column list */
   IF cUnassignedCalc > '' THEN
   DO:
     cNewUnassigned = cUnassignedCalc.
     FIND FIRST bEntity2 WHERE bEntity2.EntityName = cEntity AND bEntity2.LanguageCode = cLanguageCode NO-ERROR.
     IF AVAILABLE bEntity2 THEN
     DO iVar = 1 TO NUM-ENTRIES(cUnassignedCalc):
       ASSIGN
         hEntityField = ?  /* sanity (EntityBufferHandle may be invalid) */
         cEntityField = ENTRY(iVar, cUnassignedCalc)
         hEntityField = bEntity2.EntityBufferHandle:BUFFER-FIELD(cEntityField) 
                        NO-ERROR.
       IF VALID-HANDLE(hEntityField) THEN
         ASSIGN
           /* the list of qualified columns needs to match exactly the list
              of columns by table passed in to this function. In the columns by
              table list the calculated fields are at the end of the list, and 
              this needs to be true for the qualified columns. So we build a list
              of qualified calculated fields separately, and will add them
              to the list of qualified columns separately.
            */
           cQualifiedCalcFields = cQualifiedCalcFields + ',' + string(iEntity) + '.' + cEntityField
           ENTRY(LOOKUP(cEntityField,cNewUnassigned), cNewUnassigned) = ''
           cNewUnassigned = TRIM(REPLACE(cNewUnassigned, ',,', ','), ',').
     END.
     cUnassignedCalc = cNewUnassigned.
   END.
   
   cQualifiedColumns = cQualifiedColumns 
                       + (IF iEntity = 1 THEN '' ELSE ',':U) 
                       /* replace comma with comma  and table number and period 
                         (add comma before Entitycolumns so that the first 
                          column also is renamed)*/ 
                       + LEFT-TRIM(REPLACE(',':U + cEntityColumns,
                                           ',':U,
                                           ',':U + STRING(iEntity) + '.':U),
                                   ',':U).

   /* Loop through renamed columns and replace the column name in the 
      cQualifiedColumns with the dbcolumname */  
   DO iColumn = 1 TO NUM-ENTRIES(cRenameColumns) BY 2:
     ASSIGN
       cColumn    = ENTRY(iColumn,cRenameColumns)
       cDbColumn  = ENTRY(iColumn + 1,cRenameColumns)        
       /* lookup the position of this renamed column in the unique lookup list 
          and replace the corresponding qualified column with the qualified 
          db column name */ 
       ENTRY(LOOKUP(cColumn,cColumnsSortedByTable),cQualifiedColumns) 
                  = STRING(iEntity) + '.':U + cDbcolumn
     .
   END. /* do iColumn loop by 2 through cRenameColumns */
 END. /* do iEntity loop through pcEntities */       
 
    /* CalcFields are always the last entry in the columns by table list,
       and so need to be the last entry in the qualified columns list.
    */
    if cQualifiedCalcFields ne ? and cQualifiedCalcFields ne '' then
        assign cQualifiedCalcFields = left-trim(cQualifiedCalcFields, ',')
               cQualifiedColumns = cQualifiedColumns + ',' + cQualifiedCalcFields
               cQualifiedColumns = left-trim(cQualifiedColumns , ',').
               
 iDbColumns        = NUM-ENTRIES(cQualifiedColumns). 
 /* DO for bEntity to scope the entity outside the column loop, which is not 
    in entity order, as we want to avoid finding the same entity over and over  */
 DO FOR bEntity:
   IF phRowObjectTable:PREPARED THEN 
     hRowObject = phRowObjectTable:DEFAULT-BUFFER-HANDLE.   
   DO iColumn = 1 TO NUM-ENTRIES(pcColumns):
     ASSIGN
       cColumn   = ENTRY(iColumn,pcColumns)
       iPos      = LOOKUP(cColumn,cColumnsSortedByTable).
       
     /* Calculated field NOT attached to an Entity */
     IF iPos > iDbcolumns THEN 
       IF NOT phRowObjectTable:PREPARED THEN
       DO:
         MESSAGE  "Failed to add columns to the RowObjectTable." SKIP
                   "Could not create Calculated Field'" cColumn "' from Repository." SKIP(1)
                   "Calculated fields must be defined for an Entity."
         VIEW-AS ALERT-BOX ERROR.
         RETURN FALSE.
       END.
       ELSE       /* this is a calc field on a static SDO - ignore it */
         NEXT.

     ASSIGN
       cDbColumn      = ENTRY(iPos,cQualifiedColumns)
                  /* Resolve the entity name from the number qualifier */
       cEntity      = ENTRY(INT(ENTRY(1,cDBcolumn,'.':U)),pcEntities)
       cEntityField = ENTRY(2,cDBColumn,'.':U). 
   
     /* avoid finding the entity if it's the same as in the previous loop */
     IF NOT AVAIL bEntity OR bEntity.EntityName <> cEntity THEN
         FIND FIRST bEntity WHERE bEntity.EntityName = cEntity AND bEntity.LanguageCode = cLanguageCode NO-ERROR.
   
     IF AVAIL bEntity THEN
     DO:
       /* Deal with the fact that array fields are stored without brackets in Repos*/  
       IF INDEX(cEntityField,'[':U) > 0 THEN
         ASSIGN
           cEntityField = REPLACE(cEntityField,'[':U,'':U)
           cEntityField = REPLACE(cEntityField,']':U,'':U).
       ASSIGN
         hEntityField = ? /* buffer may be invalid  */
         hEntityField = bEntity.EntityBufferHandle:BUFFER-FIELD(cEntityField) NO-ERROR.
     
       IF NOT VALID-HANDLE(hEntityField) AND NOT phRowObjectTable:PREPARED THEN
       DO:
         MESSAGE 
           "Failed to add columns to the RowObjectTable." SKIP
            ERROR-STATUS:GET-MESSAGE(1) 
          VIEW-AS ALERT-BOX ERROR.
         RETURN FALSE.
       END.
  
       /* Avoid NO-ERROR, use progress default messages if the columns passed 
          does not match the rowobject or if there is data-type mismatch 
          between entities and rowobject or other ... */
       IF VALID-HANDLE(hEntityField) THEN
       DO ON ERROR UNDO,RETURN FALSE:
         IF phRowObjectTable:PREPARED = FALSE THEN
         DO:
           /* The Entity was created with native format, so we need to convert 
              to the proper format. Otherwise the INITIAL value would be wrong )
              it cannot even be referenced...so assing to variable with no-error   */
           cInitial = hEntityField:INITIAL NO-ERROR.
           IF cInitial > '' THEN
             phRowObjectTable:ADD-NEW-FIELD(cColumn,
                                            hEntityField:DATA-TYPE,
                                            0,
                                            hEntityField:FORMAT,
                                            {fnarg entityDefaultValue hEntityField},
                                            hEntityField:LABEL,
                                            hEntityField:COLUMN-LABEL). 
           ELSE 
             phRowObjectTable:ADD-LIKE-FIELD(cColumn,hEntityField).
  
         END.
         ELSE 
           ASSIGN  
             hColumn              = hRowObject:BUFFER-FIELD(cColumn)
             hColumn:FORMAT       = hEntityField:FORMAT 
             hColumn:LABEL        = hEntityField:LABEL  
             hColumn:COLUMN-LABEL = hEntityField:COLUMN-LABEL. 
       END. /* valid entityfield*/
     END. /* avail bEntity */
     ELSE 
       RETURN FALSE.
   END. /*do iColumn loop through columns */
 END. /* do for bentity */ 

 RETURN TRUE.   /* success. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFolderDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFolderDetails Procedure 
FUNCTION setFolderDetails RETURNS LOGICAL
    ( INPUT pdInstanceId            AS DECIMAL,      
      INPUT pcFolderInstanceName    AS CHARACTER,
      INPUT pcSecuredTokens         AS CHARACTER,
      INPUT plApplyTranslations     AS LOGICAL,
      INPUT pdLanguageObj           AS DECIMAL            ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Updates container and folder objects with folder-related information.
    Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cLabels                     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cTooltips                   AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cPageLabels                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cTabsEnabled                AS CHARACTER            NO-UNDO.    
    DEFINE VARIABLE cEntry                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cPageLayouts                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSecuredTokens              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iAttributeEntry             AS INTEGER              NO-UNDO.
    DEFINE VARIABLE hBufferField                AS HANDLE               NO-UNDO.
    define variable cPageTokens                 as character no-undo.

    DEFINE BUFFER cacheObject        FOR cacheObject.    /* for the container object */
    DEFINE BUFFER folderObject       FOR cacheObject.    /* for the folder object */
    DEFINE BUFFER bObject            FOR cacheObject.    /* for the child objects */    
    DEFINE BUFFER bLink              FOR cacheLink.      /* for the child links */
    
    FIND FIRST cacheObject WHERE cacheObject.InstanceId = pdInstanceId NO-ERROR.
    IF NOT AVAILABLE cacheObject THEN
        RETURN FALSE.
    /* We know that the is a ttClass record for each object,
     * otherwise an error would have been raised already.
     */
    FIND FIRST ttClass WHERE ttClass.ClassName = cacheObject.ClassName.
    
    /* The FolderLabels and TabEnabled properties should be set against the 
     * folder object, not the container. We need to find this object, so that we can set these properties. 
     */
    FIND FIRST folderObject WHERE
               folderObject.ObjectName          = pcFolderInstanceName AND
               folderObject.ContainerInstanceID = cacheObject.InstanceId
               NO-ERROR.
    IF NOT AVAILABLE folderObject THEN
        RETURN FALSE.
        
    /* Build a list of the page labels, ignoring page zero.
     * This list needs to be in order.         
     *
     * Initialise the variables first.
     */
    ASSIGN cPageLabels    = "":U
           cTabsEnabled   = "":U
           cPageLayouts   = "":U
           cSecuredTokens = "":U
           cPageTokens    = '':u.
    
    /* Renumber the pages. The existing page numbers are not necessarily
       contiguous, even though they are sequential. The page numbers need
       to be sequential and contiguous, so make them so.
       
       Determine the security settings for the pages.
       
       Also update the pagenumber of the cacheObject and cacheLink record.
           
       Use a PRESELECT because we are changing a key value.
       The iAttributeEntry variable is used for the new page number.
     */
    ASSIGN iAttributeEntry = 1.
    REPEAT PRESELECT 
        EACH cachePage WHERE
             cachePage.InstanceId  = cacheObject.InstanceId AND
             cachePage.PageNumber >= 1
             BY cachePage.PageNumber:
        FIND NEXT cachePage.
                
        /* Update the page number on any contained objects.
         */
        REPEAT PRESELECT
            EACH bObject WHERE
                 bObject.ContainerInstanceId = cachePage.InstanceId AND
                 bObject.PageNumber          = cachePage.PageNumber:
            FIND NEXT bObject.
            ASSIGN bObject.PageNumber = iAttributeEntry.
        END.    /* preselect objects */
        
        /* The links also need their page numbers updated.
           The source and target pages are done separately because
         */
        REPEAT PRESELECT
            EACH bLink WHERE
                 bLink.InstanceId = cachePage.InstanceId AND
                 bLink.SourcePage = cachePage.PageNumber:
            FIND NEXT bLink.
            ASSIGN bLink.SourcePage = iAttributeEntry.
        END.    /* source sourced on this page */
        
        REPEAT PRESELECT
            EACH bLink WHERE
                 bLink.InstanceId = cachePage.InstanceId AND
                 bLink.TargetPage = cachePage.PageNumber:
            FIND NEXT bLink.
            ASSIGN bLink.TargetPage = iAttributeEntry.
        END.    /* target sourced on this page */
        
        /* Determine the labels and layouts, strung together for the container
           and the folder objects' use.
         */
        ASSIGN cPageLabels  = cPageLabels  + "|":U + cachePage.PageLabel
               cPageLayouts = cPageLayouts + "|":U + cachePage.LayoutCode
               cPageTokens  = cPageTokens + '|':u + replace(cachePage.SecurityToken, '&':u, '':u).
        
        /* Apply security */
        IF cachePage.SecurityToken NE "":U AND cachePage.SecurityToken NE ? AND
           ( CAN-DO(pcSecuredTokens, cachePage.SecurityToken)                      OR
             CAN-DO(pcSecuredTokens, REPLACE(cachePage.SecurityToken, "&":U, "":U))   ) THEN
            ASSIGN cTabsEnabled   = cTabsEnabled + "|":U + STRING(NO)
                   cSecuredTokens = cSecuredTokens + ",":U + cachePage.SecurityToken.
        ELSE
            ASSIGN cTabsEnabled = cTabsEnabled + "|":U + STRING(YES).
        
        /* Update the page number of the cachePage record. */
        ASSIGN cachePage.PageNumber = iAttributeEntry
               iAttributeEntry      = iAttributeEntry + 1.
    END.    /* preselect */
    
    /* Clean up the strings. */
    ASSIGN cPageLabels    = LEFT-TRIM(cPageLabels,  "|":U)
           cTabsEnabled   = LEFT-TRIM(cTabsEnabled, "|":U)
           cPageLayouts   = LEFT-TRIM(cPageLayouts, "|":U)
           cSecuredTokens = LEFT-TRIM(cSecuredTokens, ",":U)
           cPageTokens    = left-trim(cPageTokens, '|':u).
    
    /* Update the SecuredTokens and SecuredFields attributes with the values of the secured fields */
    ASSIGN hBufferField = ?
           hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("SecuredTokens":U) NO-ERROR.
    IF VALID-HANDLE(hBufferField) THEN
    DO:
        ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals).
        IF iAttributeEntry EQ 0 THEN
            ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                   cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} + cSecuredTokens.
        ELSE
            ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-Delimiter}) = cSecuredTokens.
    END.    /* There is a SecuredTokens attribute */
    
    /* Update the pageTokens attribute */
    hBufferField = ?.
    hBufferField = ttClass.ClassBufferHandle:buffer-field('PageTokens':u) no-error.
    if valid-handle(hBufferField) then
    do:
        ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals).
        IF iAttributeEntry EQ 0 THEN
            ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                   cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} + cPageTokens.
        ELSE
            ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-Delimiter}) = cPageTokens.
    end.    /* there is a PageTokens property */
    
    /* Set the PageLayoutInfo attribute. */
    ASSIGN hBufferField = ?
           hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("PageLayoutInfo":U) NO-ERROR.
    IF VALID-HANDLE(hBufferField) THEN
    DO:
        ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), cacheObject.AttrOrdinals).
        IF iAttributeEntry EQ 0 THEN
            ASSIGN cacheObject.AttrOrdinals = cacheObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                   cacheObject.AttrValues   = cacheObject.AttrValues + {&Value-Delimiter} + cPageLayouts.
        ELSE
            ENTRY(iAttributeEntry, cacheObject.AttrValues, {&Value-Delimiter}) = cPageLayouts.
    END.    /* There is a TabEnabled attribute */
    
    /* Now get the folder obect's class so that we know what the relevant ordinals are.
     */    
    FIND FIRST ttClass WHERE ttClass.ClassName = folderObject.ClassName.

    /* Set the TabEnabled attribute (apply the security). */
    ASSIGN hBufferField = ?
           hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("TabEnabled":U) NO-ERROR.
    IF VALID-HANDLE(hBufferField) then
    DO:
        ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), folderObject.AttrOrdinals).
        IF iAttributeEntry EQ 0 THEN
            ASSIGN folderObject.AttrOrdinals = folderObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                   folderObject.AttrValues   = folderObject.AttrValues + {&Value-Delimiter} + cTabsEnabled.
        ELSE
            ENTRY(iAttributeEntry, folderObject.AttrValues, {&Value-Delimiter}) = cTabsEnabled.
    END.    /* There is a TabEnabled attribute */
                      
    ASSIGN hBufferField = ?
           hBufferField = ttClass.ClassBufferHandle:BUFFER-FIELD("FolderLabels":U) NO-ERROR.            
    /* At this stage the FolderLabels attribute may already have been set by the
     * attribute loop, particularly FOR the master/requested OBJECT. We need TO override
     * ANY VALUES that are stored IN the Repository.
     */
    IF VALID-HANDLE(hBufferField) then
    DO:
        /* Do the translations. If we don't need to do translations,             
         * THEN simply SET the attribute VALUE TO the list OF pages built
         * above.
         */
        IF plApplyTranslations THEN
        DO:
            RUN translateSingleObject IN gshTranslationManager ( INPUT  pdLanguageObj,
                                                                 INPUT  cacheObject.ObjectName,
                                                                 INPUT  "TAB":U, /* pcWidgetName */
                                                                 INPUT  "TAB":U, /* pcWidgetType */
                                                                 INPUT  NUM-ENTRIES(cPageLabels, "|":U), /* piWidgetEntries  */
                                                                 OUTPUT cLabels,
                                                                 OUTPUT cTooltips               ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN FALSE.

            /* We only deal with labels; tooltips are ignored. */
            IF cLabels NE "":U THEN
            DO:
                /* Loop through the returned translations and apply only those that have changed.
                 * IF there are NO translations, LEAVE the existing VALUES alone.
                 */
                DO iAttributeEntry = 1 TO NUM-ENTRIES(cLabels, CHR(3)):
                    ASSIGN cEntry = ENTRY(iAttributeEntry, cLabels, CHR(3)).
                    IF cEntry NE "":U THEN
                        ENTRY(iAttributeEntry, cPageLabels, "|":U) = cEntry.
                END.    /* loop through returned values to set only that which has changed. */
            END.    /* there are translations */
        END.    /* perform translations */
        
        /* Are these being overridden? */
        ASSIGN iAttributeEntry = LOOKUP(STRING(hBufferField:POSITION - 1), folderObject.AttrOrdinals).
        IF iAttributeEntry EQ 0 THEN
            ASSIGN folderObject.AttrOrdinals = folderObject.AttrOrdinals + ",":U + STRING(hBufferField:POSITION - 1)
                   folderObject.AttrValues   = folderObject.AttrValues + {&Value-Delimiter} + cPageLabels.
        ELSE
            ENTRY(iAttributeEntry, folderObject.AttrValues, {&Value-Delimiter}) = cPageLabels.
    END.    /* there is a FolderLabels attribute */
    
    /* If the objects contained are themselves containers, recurse. 
     */
    FOR EACH bObject WHERE
             bObject.containerInstanceId = cacheObject.InstanceId,
       FIRST bLink WHERE
             bLink.InstanceId         = bObject.InstanceId AND
             bLink.LinkName           = "Page":U           AND
             bLink.TargetInstanceName = "THIS-OBJECT":U:
        IF NOT DYNAMIC-FUNCTION("setFolderDetails":U IN TARGET-PROCEDURE,
                                 INPUT bObject.InstanceId,
                                 INPUT bLink.SourceInstanceName,
                                 INPUT pcSecuredTokens,
                                 INPUT plApplyTranslations,
                                 INPUT pdLanguageObj         ) THEN 
        RETURN FALSE.
    END.    /* each child object */
    
    RETURN TRUE.
END FUNCTION.    /* setFolderDetails */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

