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

---------------------------------------------------------------------------*/
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
&GLOBAL-DEFINE defineCache /* Will be undefined in the include */
{src/adm2/ttaction.i}

&GLOBAL-DEFINE defineCache /* Will be undefined in the include */
{src/adm2/tttoolbar.i}

DEFINE TEMP-TABLE ttUser NO-UNDO LIKE gsm_user.

{af/app/afttsecurityctrl.i}

/* temp-table for translations */
{af/app/aftttranslate.i}

DEFINE VARIABLE lSecurityRestricted             AS LOGICAL      NO-UNDO.
DEFINE VARIABLE gcCurrentLogicalName            AS CHARACTER    NO-UNDO.

{launch.i    &define-only = YES}
{dynlaunch.i &define-only = YES}

/* Temp-table definitions for object tables, which take into account customisation */
{ ry/app/ryobjretri.i }

/* Inlude containing the data types in integer form. */
{ af/app/afdatatypi.i }

/** These are attributes whose values must be taken from the underllying 
 *  field to which the SDF is auto-attached. Entries which have an = in them
 *  denote mapped fields: the attribute name on the left is the mapped to the
 *  attribute name on the right in the SDF.
 *  ----------------------------------------------------------------------- **/
&SCOPED-DEFINE AUTO-ATTACH-KEEP-ATTRIBS FieldName,WidgetName=FieldName,Name=FieldName,ROW,COLUMN,Order,InitialValue,ENABLED=EnableField,DisplayField

/* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{ ry/app/rydefrescd.i }

&SCOPED-DEFINE DBAWARE-OBJECT-TYPES SDO,SBO

/* This pre-processor is a temporary measure until more dynamic caching happens. */
&SCOPED-DEFINE CLASSES-TO-CACHE-ON-STARTUP DataField,DynBrow,DynButton,DynCombo,~
DynComboBox,DynEditor,DynFillin,DynFold,DynImage,DynLookup,~
DynMenc,DynObjc,DynRadioSet,DynRectangle,DynSdf,DynText,DynToggle,DynTree,DynView,~
SDO,SBO,SmartToolbar,SmartFolder,staticSDV,smartViewer

/* mapping between  buffer:attr and entityfield attributes*/
&SCOPED-DEFINE BUFFER-ATTRIBUTE-MAP ~
     'INITIAL,DefaultValue,LABEL,Label,COLUMN-LABEL,ColumnLabel,HELP,Help,FORMAT,Format':U

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
{
 src/adm2/calltables.i &PARAM-TABLE-TYPE = "1"
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-areToolbarsCached) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD areToolbarsCached Procedure 
FUNCTION areToolbarsCached RETURNS LOGICAL
  (INPUT pcLogicalObjectName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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
    ( INPUT pcObjectName        AS CHARACTER,
      INPUT pcObjectPath        AS CHARACTER,
      INPUT pcObjectExtension   AS CHARACTER,
      INPUT plStaticObject     AS LOGICAL,
      INPUT pdPhysicalObjectObj AS DECIMAL          )  FORWARD.

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
    ( INPUT pcObjectName        AS CHARACTER,
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
    ( INPUT phADMProps              AS HANDLE, 
      INPUT phInstance              AS HANDLE, 
      INPUT phSource                AS HANDLE  )  FORWARD.

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
         WIDTH              = 64.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm/method/attribut.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */
DEFINE VARIABLE cClassesToCache             AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cAbstractClassNames         AS CHARACTER                NO-UNDO.

CREATE WIDGET-POOL NO-ERROR.

ON CLOSE OF THIS-PROCEDURE 
DO:
    DELETE WIDGET-POOL NO-ERROR.

    RUN plipShutdown.

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

&IF DEFINED(server-side) <> 0 &THEN
    {ry/app/rymenufunc.i}
    PROCEDURE rygetmensp:         {ry/app/rygetmensp.p}     END PROCEDURE.
    PROCEDURE rygetitemp:         {ry/app/rygetitemp.p}     END PROCEDURE.
&ENDIF

/* Cache Objects, Classes, etc */
ASSIGN cClassesToCache = DYNAMIC-FUNCTION("getSessionParam":U, INPUT "StartupCacheClasses":U).
IF cClassesToCache EQ ? THEN
    ASSIGN cClassesToCache = "":U.

ASSIGN cClassesToCache = cClassesToCache + ",{&CLASSES-TO-CACHE-ON-STARTUP}":U
       cClassesToCache = LEFT-TRIM(cClassesToCache, ",":U)
       .

&IF DEFINED(server-side) <> 0 &THEN
RUN createClassCache (INPUT cClassesToCache) NO-ERROR.
&ELSE
IF SESSION = gshAstraAppserver THEN /* running client-server, just run the cache procedure */
    RUN createClassCache (INPUT cClassesToCache) NO-ERROR.
ELSE DO:
    /* This event is going to be picked up in the cache PLIPP, it will then run sendLoginCache in the manager */

    DEFINE VARIABLE hFirstProcedure AS HANDLE     NO-UNDO.

    ASSIGN hFirstProcedure = SESSION:FIRST-PROCEDURE.
    PUBLISH "loginGetClassCache":U FROM hFirstProcedure (INPUT THIS-PROCEDURE).
END.
&ENDIF

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buildClassCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildClassCache Procedure 
PROCEDURE buildClassCache :
/*------------------------------------------------------------------------------
  Purpose:     Constructs the ttClass and cache_objectUiEvent tables.
  Parameters:  pcClassCode - a class code, a CSV list of class codes or * for all.
  Notes:       * This procedure is designed to run when a DB connection is available,
                 and is solely used to build the temp-tables of the object types
               * This procedure differs from createClassCache in that createClassCache
                 uses retrieveClassCache to ensure that objects are cached on both the
                 client and server.
               * This procedure is called from retrieveClassCache               
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcClassCode          AS CHARACTER            NO-UNDO.

    &IF DEFINED(Server-Side) NE 0 &THEN
    DEFINE VARIABLE cInitialWhereStored             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInitialWhereConstant           AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cClassQueryWhere                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cClassObjectName                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cNecessaryAttributes            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cAttributeLabel                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInheritsFromClasses            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iLoopCount                      AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iClassCount                     AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iNumberOfAttributes             AS INTEGER              NO-UNDO.
    DEFINE VARIABLE hClassTempTable                 AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hClassAttributeTempTable        AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hClassAttributeTempTableBuffer  AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hClassObject                    AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hClassQuery                     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cSetList                        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cGetList                        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cRuntimeList                    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cClassList                      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cMasterList                     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lOK                             AS LOGICAL    NO-UNDO.

    DEFINE BUFFER gsc_object_type   FOR gsc_object_type.
    DEFINE BUFFER ttClass           FOR ttClass.

    DEFINE QUERY qryClass       FOR gsc_object_type.
    
    IF pcClassCode EQ "":U THEN ASSIGN pcClassCode = "*":U.

    /* Class Query */
    ASSIGN cClassQueryWhere = " FOR EACH gsc_object_type NO-LOCK ":U.

    IF pcClassCode NE "*":U THEN
    DO:
       DO iLoopCount = 1 TO NUM-ENTRIES(pcClassCode):
        ASSIGN cClassQueryWhere = cClassQueryWhere 
                                + (IF iLoopCount = 1 THEN ' WHERE ':U ELSE ' OR ':U) 
                                + " gsc_object_type.object_type_code = ":U 
                                + QUOTER(ENTRY(iLoopCount, pcClassCode))
              .                                
      END.    /* not all */
    END.    /* selected classes */

    ASSIGN hClassQuery = QUERY qryClass:HANDLE.

    hClassQuery:QUERY-PREPARE(cClassQueryWhere).
    hClassQuery:QUERY-OPEN().

    hClassQuery:GET-FIRST(NO-LOCK).
    DO WHILE AVAILABLE gsc_object_type:
        FIND FIRST ttClass WHERE
                   ttClass.ClassName = gsc_object_type.object_type_code
                   NO-ERROR.
        IF NOT AVAILABLE ttClass THEN
        DO:        
            RUN buildDenormalizedAttributes IN TARGET-PROCEDURE ( INPUT gsc_object_type.object_type_code ) NO-ERROR.
            /* This is a static query so we don't have to worry about memory leaks etc. Just return the error. */
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* error */
        hClassQuery:GET-NEXT(NO-LOCK).
    END.    /* avail class */
    hClassQuery:QUERY-CLOSE().
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
  Purpose:     Build the actual denormalised class attribute TT.
  Parameters:  pcCLassName - 
  Notes:       * This procedure may be called recursively from itself.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcClassName              AS CHARACTER        NO-UNDO.

&IF DEFINED(Server-Side) NE 0 &THEN
DEFINE VARIABLE lOk                             AS LOGICAL          NO-UNDO.
DEFINE VARIABLE cClassObjectName                AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cGetList                        AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cSetList                        AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cMasterList                     AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cClassList                      AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cRuntimeList                    AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cWhereConstant                  AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cWhereStored                    AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cParentGetList                  AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cParentSetList                  AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cParentMasterList               AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cParentClassList                AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cParentRuntimeList              AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cParentSystemList               AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cParentWhereConstant            AS CHARACTER        NO-UNDO.
DEFINE VARIABLE iNumberOfAttributes             AS INTEGER          NO-UNDO.
DEFINE VARIABLE iFieldLoop                      AS INTEGER          NO-UNDO.
DEFINE VARIABLE cInheritsFromClasses            AS CHARACTER        NO-UNDO.
DEFINE VARIABLE hClassAttributeTempTable        AS HANDLE           NO-UNDO.
DEFINE VARIABLE hField                          AS HANDLE           NO-UNDO.
DEFINE VARIABLE hClassAttributeTempTableBuffer  AS HANDLE           NO-UNDO.

DEFINE BUFFER gsc_object_type       FOR gsc_object_type.
DEFINE BUFFER gscot                 FOR gsc_object_type.
DEFINE BUFFER ryc_smartObject       FOR ryc_smartObject.
DEFINE BUFFER ttClass               FOR ttClass.
DEFINE BUFFER cache_ObjectUiEvent   FOR cache_ObjectUiEvent.
DEFINE BUFFER parent_ObjectUiEvent  FOR cache_ObjectUiEvent.

 ASSIGN 
   cSetList              = "":U
   cGetList              = "":U
   cRunTimeList          = "":U
   cClassList            = "":U
   cMasterList           = "":U
   iNumberOfAttributes   = 0
   cInheritsFromClasses  = "":U
           .
 FIND gsc_object_type WHERE
      gsc_object_type.object_type_code = pcClassName 
      NO-LOCK NO-ERROR.
    
 IF AVAILABLE gsc_object_type THEN
 DO:
   CREATE TEMP-TABLE hClassAttributeTempTable.
   /* This field allows joins to the owning object. */
   hClassAttributeTempTable:ADD-NEW-FIELD("tRecordIdentifier":U, "DECIMAL":U, 0, ?, 0 ).
     
   /* Add an entry for tRecordindentifier */
   ASSIGN 
     iNumberOfAttributes  = iNumberOfAttributes + 1
     cWhereConstant       = "0":U
     cInheritsFromClasses = gsc_object_type.object_type_code + ",":U
   .
   IF gsc_object_type.class_smartObject_obj NE 0 THEN
   DO:
     FIND FIRST ryc_smartObject WHERE
                ryc_smartObject.smartObject_obj = gsc_object_type.class_smartObject_obj
                NO-LOCK NO-ERROR.
     IF AVAILABLE ryc_smartObject THEN
       ASSIGN cClassObjectName = DYNAMIC-FUNCTION("getObjectPathedName":U IN TARGET-PROCEDURE,
                                                   INPUT ryc_smartObject.object_filename,
                                                   INPUT ryc_smartObject.object_path,
                                                   INPUT ryc_smartObject.object_extension,
                                                   INPUT ryc_smartObject.static_object,
                                                   INPUT (IF NOT ryc_smartObject.static_object THEN ryc_smartObject.physical_smartObject_obj ELSE 0)).
   END.    /* class object is '' */
   /* Get all the attributes for this class. */
   FOR EACH ryc_attribute_value 
       WHERE ryc_attribute_value.object_type_obj     = gsc_object_type.object_type_obj
       AND   ryc_attribute_value.smartObject_obj     = 0                               
       AND   ryc_attribute_value.object_instance_obj = 0
       NO-LOCK,
     FIRST ryc_attribute 
           WHERE ryc_attribute.attribute_label = ryc_attribute_value.attribute_label 
           AND   ryc_attribute.derived_value   = FALSE
           NO-LOCK:            
       CASE ryc_attribute.data_type:
         WHEN {&CHARACTER-DATA-TYPE} THEN lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"CHARACTER",0,?,ryc_attribute_value.character_value).
         WHEN {&LOGICAL-DATA-TYPE}   THEN lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"LOGICAL":U,0,?,ryc_attribute_value.logical_value).
         WHEN {&INTEGER-DATA-TYPE}   THEN lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"INTEGER":U,0,?,ryc_attribute_value.integer_value).
         WHEN {&HANDLE-DATA-TYPE}    THEN lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"HANDLE":U,0,?,?).
         WHEN {&DECIMAL-DATA-TYPE}   THEN lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"DECIMAL":U,0,?,ryc_attribute_value.decimal_value).
         WHEN {&ROWID-DATA-TYPE}     THEN lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"ROWID":U,0,?,TO-ROWID(ryc_attribute_value.character_value)).
         WHEN {&RAW-DATA-TYPE}       THEN lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"RAW":U,0,?,ryc_attribute_value.raw_value).
         WHEN {&DATE-DATA-TYPE}      THEN lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"DATE":U,0,?,ryc_attribute_value.date_value).
         WHEN {&RECID-DATA-TYPE}     THEN lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"RECID":U,0,?,IF ryc_attribute_value.integer_value = 0 THEN ? ELSE ryc_attribute_value.integer_value).
         OTHERWISE                        lOk = hClassAttributeTempTable:ADD-NEW-FIELD(ryc_attribute_value.attribute_label,"CHARACTER",0,?,ryc_attribute_value.character_value).
       END CASE.   /* DataType */

     IF lOk THEN
     DO:
       ASSIGN iNumberOfAttributes  = iNumberOfAttributes + 1
              cWhereConstant       = cWhereConstant + (IF iNumberOfAttributes = 1 THEN "":U ELSE ",":U)
                                   + (IF ryc_attribute_value.constant_value THEN STRING("{&STORED-AT-CLASS}":U) ELSE "0":U)
             .
       IF CAN-DO(ryc_attribute.override_type,"Get":U)  THEN ASSIGN cGetList = cGetList + STRING(iNumberOfAttributes) + ",":U.
       IF CAN-DO(ryc_attribute.override_type,"Set":U)  THEN ASSIGN cSetList = cSetList + STRING(iNumberOfAttributes) + ",":U.
       IF ryc_attribute.runtime_only                   THEN ASSIGN cRunTimeList = cRunTimeList + STRING(iNumberOfAttributes) + ",":U.
       IF (ryc_attribute.constant_level EQ "Class":U)  THEN ASSIGN cClassList = cClassList + STRING(iNumberOfAttributes) + ",":U.
       IF (ryc_attribute.constant_level EQ "Master":U) THEN ASSIGN cMasterList = cMasterList + STRING(iNumberOfAttributes) + ",":U.
     END.    /* OK? */
   END.    /* each attribute value */

   FOR EACH ryc_ui_event 
            WHERE ryc_ui_event.object_type_obj     = gsc_object_type.object_type_obj 
            AND   ryc_ui_event.smartObject_obj     = 0                               
            AND   ryc_ui_event.object_instance_obj = 0
            NO-LOCK:
     /* Only build UI events where they are first found, since 
      * we are working up a heirarchy.                         */
     IF NOT CAN-FIND(cache_ObjectUiEvent 
                       WHERE cache_ObjectUiEvent.tRecordIdentifier = 0                                
                       AND   cache_ObjectUiEvent.tClassName        = gsc_object_type.object_type_code 
                       AND   cache_ObjectUiEvent.tEventName        = ryc_ui_event.event_name             ) THEN
     DO:
       CREATE cache_ObjectUiEvent.
       ASSIGN cache_ObjectUiEvent.tRecordIdentifier = 0
              cache_ObjectUiEvent.tClassName        = gsc_object_type.object_type_code
              cache_ObjectUiEvent.tEventName        = ryc_ui_event.event_name
              cache_ObjectUiEvent.tActionType       = ryc_ui_event.action_type
              cache_ObjectUiEvent.tActionTarget     = ryc_ui_event.action_target
              cache_ObjectUiEvent.tEventAction      = ryc_ui_event.event_action
              cache_ObjectUiEvent.tEventParameter   = ryc_ui_event.event_parameter
              cache_ObjectUiEvent.tEventDisabled    = ryc_ui_event.event_disabled
              .
       END.    /* not created yet */
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

       FIND FIRST ttClass WHERE ttClass.className = gscot.object_type_code NO-ERROR.
       IF NOT AVAILABLE ttClass THEN
       DO:
         RUN buildDenormalizedAttributes IN TARGET-PROCEDURE ( INPUT gscot.object_type_code ) NO-ERROR.
         IF ERROR-STATUS:ERROR THEN
         DO:
             /* First clean up */
             DELETE OBJECT hClassAttributeTempTable NO-ERROR.
             /* the return an error. */
             RETURN ERROR RETURN-VALUE.
         END.   /* error. */

         FIND FIRST ttClass WHERE ttClass.className = gscot.object_type_code NO-ERROR.
       END.    /* n/a ttClass */

       IF AVAILABLE ttClass THEN
       DO:
         ASSIGN cParentSetList       = TRIM(ttClass.classBufferHandle:BUFFER-FIELD("tSetList":U):INITIAL)
                cParentGetList       = TRIM(ttClass.classBufferHandle:BUFFER-FIELD("tGetList":U):INITIAL)
                cParentRunTimeList   = TRIM(ttClass.classBufferHandle:BUFFER-FIELD("tRunTimeList":U):INITIAL)
                cParentClassList     = TRIM(ttClass.classBufferHandle:BUFFER-FIELD("tClassList":U):INITIAL)
                cParentMasterList    = TRIM(ttClass.classBufferHandle:BUFFER-FIELD("tMasterList":U):INITIAL)
                cParentSystemList    = TRIM(ttClass.classBufferHandle:BUFFER-FIELD("tSystemList":U):INITIAL)
                cParentWhereConstant = TRIM(ttClass.classBufferHandle:BUFFER-FIELD("tWhereConstant":U):INITIAL)
                cInheritsFromClasses = cInheritsFromClasses + ttClass.inheritsFromClasses + ","
                cClassObjectName     = ttClass.classObjectName WHEN cClassObjectName EQ "":U
                .
            /* We add the inherited fields after we have this class' fields
              (The order is insignificant and can be changed if required) */
         DO ifieldLoop = 1 TO ttClass.classBufferHandle:NUM-FIELDS:
           ASSIGN hField = ttClass.classBufferHandle:BUFFER-FIELD(iFieldLoop).
           IF CAN-DO(cParentSystemList,STRING(iFieldLoop)) THEN
             NEXT.
           IF hClassAttributeTempTable:ADD-LIKE-FIELD(hField:NAME, hField) THEN
           DO:
             ASSIGN 
               iNumberOfAttributes = iNumberOfAttributes + 1.
               IF CAN-DO(cParentSetList, STRING(iFieldLoop)) THEN ASSIGN cSetList = cSetList + STRING(iNumberOfAttributes) + ",":U.
               IF CAN-DO(cParentGetList, STRING(iFieldLoop)) THEN ASSIGN cGetList = cGetList + STRING(iNumberOfAttributes) + ",":U.
               IF CAN-DO(cParentRunTimeList, STRING(iFieldLoop)) THEN ASSIGN cRunTimeList = cRunTimeList + STRING(iNumberOfAttributes) + ",":U.
               IF CAN-DO(cParentMasterList, STRING(iFieldLoop)) THEN ASSIGN cMasterList = cMasterList + STRING(iNumberOfAttributes) + ",":U.
               IF CAN-DO(cParentClassList, STRING(iFieldLoop)) THEN ASSIGN cClassList = cClassList + STRING(iNumberOfAttributes) + ",":U.
               IF CAN-DO(cParentWhereConstant, STRING(iFieldLoop)) THEN ASSIGN cWhereConstant = cWhereConstant + STRING(iNumberOfAttributes) + ",":U.
           END.    /* added field. */
         END.    /* field loop */

         /* Get the UI events from the parent */
         FOR EACH parent_ObjectUiEvent 
             WHERE parent_ObjectUiEvent.tRecordIdentifier = 0                   
             AND   parent_ObjectUiEvent.tClassName        = gscot.object_type_code :

           /* Only build UI events where they are first found, since 
             * we are working up a heirarchy.                         */
           IF NOT CAN-FIND(cache_ObjectUiEvent WHERE
                           cache_ObjectUiEvent.tRecordIdentifier = 0                                AND
                           cache_ObjectUiEvent.tClassName        = gsc_object_type.object_type_code AND
                           cache_ObjectUiEvent.tEventName        = parent_ObjectUiEvent.tEventName     ) THEN
           DO:
             CREATE cache_ObjectUiEvent.
             BUFFER-COPY parent_ObjectUiEvent EXCEPT tClassName tRecordIdentifier TO cache_ObjectUiEvent
               ASSIGN cache_ObjectUiEvent.tRecordIdentifier = 0
                      cache_ObjectUiEvent.tClassName        = gsc_object_type.object_type_code
                      .
          END.    /* not created yet */
        END.    /* UI events */
      END.    /* avail class */
    END.    /* this class extends another. */

    /* Add entries for the system fields below */
    ASSIGN cWhereConstant = cWhereConstant + ",0,0,0,0,0,0,0,0,0":U
           iNumberOfAttributes   = iNumberOfAttributes   + 9
           cInheritsFromClasses  = RIGHT-TRIM(cInheritsFromClasses, ",":U)
           /* Set the WhereStored value to class. */
           cWhereStored = FILL("{&STORED-AT-CLASS},":U , iNumberOfAttributes)
           cWhereStored = RIGHT-TRIM (cWhereStored, ",":U).
           /* This field is used to store where each attribute is stored */
           hClassAttributeTempTable:ADD-NEW-FIELD("tWhereStored":U, "CHARACTER":U, 0, "x(256)":U, RIGHT-TRIM(cWhereStored, ",":U)).
           /* This field is used to store each where attribute's constant-value is stored */
           hClassAttributeTempTable:ADD-NEW-FIELD("tWhereConstant":U, "CHARACTER":U, 0, "x(256)":U, RIGHT-TRIM(cWhereConstant, ",":U)).
           /* A CSV list of all the classes that this class inherits from are stored in this field.
            * This value will never change after the cache is built.                               */
           hClassAttributeTempTable:ADD-NEW-FIELD("tInheritsFromClasses":U, "CHARACTER":U, 0, "x(256)":U, cInheritsFromClasses).
           /* List of ordinal number of override_type get fields */ 
           hClassAttributeTempTable:ADD-NEW-FIELD("tGetList":U, "CHARACTER":U, 0, "x(256)":U, RIGHT-TRIM(cGetList, ",":U)).
           /* List of ordinal number of override_type set fields */ 
           hClassAttributeTempTable:ADD-NEW-FIELD("tSetList":U, "CHARACTER":U, 0, "x(256)":U, RIGHT-TRIM(cSetList, ",":U)).
           /* List of ordinal number of runtime fields (the number of runtime fields 
           * is currently low enough so that storing ordinal numbers takes 2 to 3 times less space) */
           hClassAttributeTempTable:ADD-NEW-FIELD("tRunTimeList":U, "CHARACTER":U, 0, "x(256)":U, RIGHT-TRIM(cRunTimeList, ",":U)).
           /* List of ordinal numbers of classlevel attributes */
           hClassAttributeTempTable:ADD-NEW-FIELD("tClassList":U, "CHARACTER":U, 0, "x(256)":U, RIGHT-TRIM(cClassList, ",":U)).
           /* List of ordinal numbers of masterlevel attributes */
           hClassAttributeTempTable:ADD-NEW-FIELD("tMasterList":U, "CHARACTER":U, 0, "x(256)":U, RIGHT-TRIM(cMasterList, ",":U)).
           /* List of system fields, which are not true attributes 
            * looks ugly, but faster than loop  */           
           hClassAttributeTempTable:ADD-NEW-FIELD("tSystemList":U, "CHARACTER":U, 0, "x(40)":U, '1,':U /* tRecordidentifer is first */
                                                  + STRING(iNumberOfAttributes - 8) + ",":U
                                                  + STRING(iNumberOfAttributes - 7) + ",":U
                                                  + STRING(iNumberOfAttributes - 6) + ",":U
                                                  + STRING(iNumberOfAttributes - 5) + ",":U
                                                  + STRING(iNumberOfAttributes - 4) + ",":U
                                                  + STRING(iNumberOfAttributes - 3) + ",":U
                                                  + STRING(iNumberOfAttributes - 2) + ",":U
                                                  + STRING(iNumberOfAttributes - 1) + ",":U
                                                  + STRING(iNumberOfAttributes)            )
           .
    /* Add Indexes */
    hClassAttributeTempTable:ADD-NEW-INDEX("idxRecordID":U, TRUE, TRUE).  /* unique primary key */
    hClassAttributeTempTable:ADD-INDEX-FIELD("idxRecordID":U, "tRecordIdentifier":U).

    /* Prepare the Temp-table */
    hClassAttributeTempTable:TEMP-TABLE-PREPARE("c_":U + REPLACE(gsc_object_type.object_type_code, " ":U, "":U)).
    
    ASSIGN hClassAttributeTempTableBuffer = hClassAttributeTempTable:DEFAULT-BUFFER-HANDLE
           hClassAttributeTempTableBuffer:BUFFER-FIELD("tRecordIdentifier":U):PRIVATE-DATA = "":U
           .
    /* Store Class for for later use. */
    CREATE ttClass.
    ASSIGN ttClass.ClassTableName      = hClassAttributeTempTable:NAME
           ttClass.ClassName           = gsc_object_type.object_type_code
           ttClass.ClassBufferHandle   = hClassAttributeTempTableBuffer
           ttClass.ClassObjectName     = cClassObjectName 
           ttClass.InheritsFromClasses = cInheritsFromClasses
           .
  END.    /* avail gsc_object_type */
  &ENDIF
  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN.
END PROCEDURE.  /* buildDenormalizedAttributes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeObjectType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeObjectType Procedure 
PROCEDURE changeObjectType :
/*------------------------------------------------------------------------------
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
           hBuffer     = ?
           .
    /** Object Stuff .
     *-----------------------------------------------------------------------*/
    FOR EACH cache_Object:
        FOR EACH cache_ObjectPage WHERE cache_ObjectPage.tRecordIdentifier = cache_Object.tRecordIdentifier:
            DELETE cache_ObjectPage.
        END.    /* pages */

        FOR EACH cache_ObjectLink WHERE cache_ObjectLink.tRecordIdentifier = cache_Object.tRecordIdentifier:
            DELETE cache_ObjectLink.
        END.    /* links */

        FOR EACH cache_ObjectUiEvent WHERE cache_ObjectUiEvent.tRecordIdentifier = cache_Object.tRecordIdentifier:
            DELETE cache_ObjectUiEvent.
        END.    /* UI events */

        /* The attribute buffers are deleted when the classes are removed. */

        /* Delete the cache record. */
        DELETE cache_Object.        
    END.    /* each cache_Object */

    /* This table should not be used, but clear it anyway. */
    EMPTY TEMP-TABLE cache_BufferCache.

    /** Clear out the relevant class attribute tables.
     *  ----------------------------------------------------------------------- **/
    FOR EACH ttClass:
        IF VALID-HANDLE(ttClass.classBufferHandle) THEN
            ttClass.classBufferHandle:EMPTY-TEMP-TABLE() NO-ERROR.
    END.    /* each ttClass */

    /** Publish an event to tell everyone that the Repository Cache has been
     *  cleared
     *  ----------------------------------------------------------------------- **/
    PUBLISH "RepositoryCacheCleared":U.

    /* Make sure the entity table in the general manager has been cleared as well.           *
     * We need to do this because the entity cache is populated from the repository manager. */
    IF VALID-HANDLE(gshGenManager) THEN
        RUN refreshMnemonicsCache IN gshGenManager.

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
  Purpose:     Caches class attributes and UI events
  Parameters:  pcClassName  - * or a CSV list of class codes (object types)               
  Notes:       * The UI event table is always the first table returned by
                 retrieveClassCache.
------------------------------------------------------------------------------*/    
    DEFINE INPUT PARAMETER pcClassName          AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE hClassAttributeTable        AS HANDLE   EXTENT 32   NO-UNDO.
    DEFINE VARIABLE hClassAttributeBuffer       AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hUiEventBuffer              AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hReturnedEventBuffer        AS HANDLE               NO-UNDO.
    DEFINE VARIABLE iTableLoop                  AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iQueryOrdinal               AS INTEGER              NO-UNDO.

    /* If the ICFDB is connected, then directly get the Classes */
    IF DYNAMIC-FUNCTION("isConnected":U, INPUT "ICFDB":U) THEN
    DO:
        /* This populates the ttClass Temp-table. */
        RUN buildClassCache ( INPUT pcClassName ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.        
    END.    /* local DB connected */
    ELSE
    DO:
        { dynlaunch.i
            &Plip  = 'RepositoryManager'
            &IProc = 'retrieveClassCache'

            &mode1  = INPUT  &parm1  = pcClassName              &datatype1 = CHARACTER
            
            &mode2  = OUTPUT &parm2  = hClassAttributeTable[01] &datatype2  = TABLE-HANDLE
            &mode3  = OUTPUT &parm3  = hClassAttributeTable[02] &datatype3  = TABLE-HANDLE
            &mode4  = OUTPUT &parm4  = hClassAttributeTable[03] &datatype4  = TABLE-HANDLE
            &mode5  = OUTPUT &parm5  = hClassAttributeTable[04] &datatype5  = TABLE-HANDLE
            &mode6  = OUTPUT &parm6  = hClassAttributeTable[05] &datatype6  = TABLE-HANDLE
            &mode7  = OUTPUT &parm7  = hClassAttributeTable[06] &datatype7  = TABLE-HANDLE
            &mode8  = OUTPUT &parm8  = hClassAttributeTable[07] &datatype8  = TABLE-HANDLE
            &mode9  = OUTPUT &parm9  = hClassAttributeTable[08] &datatype9  = TABLE-HANDLE
            &mode10 = OUTPUT &parm10 = hClassAttributeTable[09] &datatype10 = TABLE-HANDLE
            &mode11 = OUTPUT &parm11 = hClassAttributeTable[10] &datatype11 = TABLE-HANDLE
            &mode12 = OUTPUT &parm12 = hClassAttributeTable[11] &datatype12 = TABLE-HANDLE
            &mode13 = OUTPUT &parm13 = hClassAttributeTable[12] &datatype13 = TABLE-HANDLE
            &mode14 = OUTPUT &parm14 = hClassAttributeTable[13] &datatype14 = TABLE-HANDLE
            &mode15 = OUTPUT &parm15 = hClassAttributeTable[14] &datatype15 = TABLE-HANDLE
            &mode16 = OUTPUT &parm16 = hClassAttributeTable[15] &datatype16 = TABLE-HANDLE
            &mode17 = OUTPUT &parm17 = hClassAttributeTable[16] &datatype17 = TABLE-HANDLE
            &mode18 = OUTPUT &parm18 = hClassAttributeTable[17] &datatype18 = TABLE-HANDLE
            &mode19 = OUTPUT &parm19 = hClassAttributeTable[18] &datatype19 = TABLE-HANDLE
            &mode20 = OUTPUT &parm20 = hClassAttributeTable[19] &datatype20 = TABLE-HANDLE
            &mode21 = OUTPUT &parm21 = hClassAttributeTable[20] &datatype21 = TABLE-HANDLE
            &mode22 = OUTPUT &parm22 = hClassAttributeTable[21] &datatype22 = TABLE-HANDLE
            &mode23 = OUTPUT &parm23 = hClassAttributeTable[22] &datatype23 = TABLE-HANDLE
            &mode24 = OUTPUT &parm24 = hClassAttributeTable[23] &datatype24 = TABLE-HANDLE
            &mode25 = OUTPUT &parm25 = hClassAttributeTable[24] &datatype25 = TABLE-HANDLE
            &mode26 = OUTPUT &parm26 = hClassAttributeTable[25] &datatype26 = TABLE-HANDLE
            &mode27 = OUTPUT &parm27 = hClassAttributeTable[26] &datatype27 = TABLE-HANDLE
            &mode28 = OUTPUT &parm28 = hClassAttributeTable[27] &datatype28 = TABLE-HANDLE
            &mode29 = OUTPUT &parm29 = hClassAttributeTable[28] &datatype29 = TABLE-HANDLE
            &mode30 = OUTPUT &parm30 = hClassAttributeTable[29] &datatype30 = TABLE-HANDLE
            &mode31 = OUTPUT &parm31 = hClassAttributeTable[30] &datatype31 = TABLE-HANDLE
            &mode32 = OUTPUT &parm32 = hClassAttributeTable[31] &datatype32 = TABLE-HANDLE
            &mode33 = OUTPUT &parm33 = hClassAttributeTable[32] &datatype33 = TABLE-HANDLE
        }   
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

        ASSIGN hUiEventBuffer = DYNAMIC-FUNCTION("getCacheUiEventBuffer":U).
        IF VALID-HANDLE(hClassAttributeTable[01]) THEN
        DO:
            ASSIGN hReturnedEventBuffer = hClassAttributeTable[01]:DEFAULT-BUFFER-HANDLE.

            ASSIGN iQueryOrdinal = DYNAMIC-FUNCTION("getNextQueryOrdinal":U).

            IF NOT VALID-HANDLE(ghQuery[iQueryOrdinal]) THEN
                CREATE QUERY ghQuery[iQueryOrdinal].

            ghQuery[iQueryOrdinal]:SET-BUFFERS(hReturnedEventBuffer).

            /* We are only interested in the UI events which exist at the Class level. */
            ghQuery[iQueryOrdinal]:QUERY-PREPARE(" FOR EACH ":U + hReturnedEventBuffer:NAME + " WHERE ":U
                                 + hReturnedEventBuffer:NAME + ".tRecordIdentifier = 0 ":U ).
            ghQuery[iQueryOrdinal]:QUERY-OPEN().
            ghQuery[iQueryOrdinal]:GET-FIRST().
            DO WHILE hReturnedEventBuffer:AVAILABLE:
                hUiEventBuffer:FIND-FIRST(" WHERE ":U
                                          + hUiEventBuffer:NAME + ".tEventName = ":U + QUOTER(hReturnedEventBuffer:BUFFER-FIELD("tEventName":U):BUFFER-VALUE) + " AND ":U
                                          + hUiEventBuffer:NAME + ".tClassName = ":U + QUOTER(hReturnedEventBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE) + " AND ":U
                                          + hUiEventBuffer:NAME + ".tRecordIdentifier = 0 ":U  ) NO-ERROR.
                /* Put it in the cahce, if it is not yet there. */
                IF NOT hUiEventBuffer:AVAILABLE THEN
                DO:
                    hUiEventBuffer:BUFFER-CREATE().
                    hUiEventBuffer:BUFFER-COPY(hReturnedEventBuffer).
                    hUiEventBuffer:BUFFER-RELEASE().
                END.    /* not in cache yet. */

                ghQuery[iQueryOrdinal]:GET-NEXT().
            END.    /* available hReturnedEventBuffer */
            ghQuery[iQueryOrdinal]:QUERY-CLOSE().
        END.    /* UI event table was returned */

        /* Delete the table thas was returned. */
        DELETE OBJECT hClassAttributeTable[01] NO-ERROR.
        ASSIGN hClassAttributeTable[01] = ?
               hUiEventBuffer           = ?
               hReturnedEventBuffer     = ?
               .
        /* We only delete the tables that have been returned which previously 
         * existed in the ttClass temp-table. We know this because the classBufferHandle
         * will be the same as the DEFAULT-BUFFER-HANDLE of the table. We keep the tables
         * created by this procedure since they will be used to store all future records
         * pertaining to this class.                                                    */
        DO iTableLoop = 2 TO EXTENT(hClassAttributeTable):
            IF NOT VALID-HANDLE(hClassAttributeTable[iTableLoop]) THEN
                NEXT.
   
            ASSIGN hClassAttributeBuffer = hClassAttributeTable[iTableLoop]:DEFAULT-BUFFER-HANDLE.
    
            /* At this stage, the ttClass contains all of the tables referred to by the returned
             * table-handles.                                                                   */
            FIND FIRST ttClass WHERE ttClass.ClassTableName = hClassAttributeTable[iTableLoop]:NAME NO-ERROR.
            IF AVAILABLE ttClass THEN
            DO:
                /* Delete the returned table. The buffer associated with DEFAULT-BUFFER-HANDLE will 
                 * also be deleted.                                                                 */
                DELETE OBJECT hClassAttributeTable[iTableLoop] NO-ERROR.
                ASSIGN hClassAttributeTable[iTableLoop] = ?.
            END.    /* not created by this procedure */
            ELSE
            DO:
                /* Create an entry in the ttClass temp-table. The table we have just returned will
                 * now be used for all the future attributes of the specified class.               */
                CREATE ttClass.
                ASSIGN ttClass.ClassTableName      = hClassAttributeTable[iTableLoop]:NAME
                       ttClass.ClassName           = ENTRY(NUM-ENTRIES(ttClass.ClassTableName, "_":U), ttClass.ClassTableName, "_":U)
                       ttClass.ClassBufferHandle   = hClassAttributeBuffer
                       ttClass.InheritsFromClasses = hClassAttributeBuffer:BUFFER-FIELD("tInheritsFromClasses":U):INITIAL
                       .
                /* Empty out any data in this attribute table.
                 * We do this because if we are here, we know that we are passing 
                 * values across an AppServer, and that this is the first time that this
                 * class has been requested ACROSS THE APPSERVER. This is important because
                 * it allows us to infer that the class alone has been requested (i.e not as part
                 * of the object retrieval process). The creation of ttClass records as part of 
                 * the object retrieval process is done in doServerRetrieval and that procedure
                 * ensures that no data is lost.                                               */
                hClassAttributeBuffer:EMPTY-TEMP-TABLE().
            END.    /* not in cache yet. */
        END.    /* loop through class attribute tables */

        /* The attribute tables are cleaned up individually, since some of them may
         * be needed if this is the first time that a class's attributes have been
         * requested.                                                              */
        ASSIGN hClassAttributeBuffer = ?
               hClassAttributeTable  = ?
               NO-ERROR.
    END.    /* go across the AppServer */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.   /* createClassCache */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyClassCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyClassCache Procedure 
PROCEDURE destroyClassCache :
/*------------------------------------------------------------------------------
  Purpose:     Destroys the Temp-tables which make up the class cache
  Parameters:  <none>
  Notes:       * This is a separate clearing procedure to clearClientCache(). That
                 procedure only empties the records from the tables in the cache.
               * This is a separate API because in a runtime environment the 
                 class attributes are unlikely to change much.
------------------------------------------------------------------------------*/
    RUN clearClientCache.

    FOR EACH ttClass:
        /* When we delete the table handle, the DEFAULT-BUFFER-HANDLE 
         * is deleted along with it.                                  */
        IF  CAN-QUERY(ttClass.classBufferHandle, "TABLE-HANDLE":U) AND
           VALID-HANDLE(ttClass.classBufferHandle:TABLE-HANDLE)   THEN
            DELETE OBJECT ttClass.classBufferHandle:TABLE-HANDLE NO-ERROR.
    
        /* Double check that the buffer handle has been deleted. */
        IF VALID-HANDLE(ttClass.classBufferHandle) THEN
            DELETE OBJECT ttClass.classBufferHandle NO-ERROR.
    
        DELETE ttClass.
    END.     /* each ttClass */

    /* Clear out the rest of the cache. */
    EMPTY TEMP-TABLE cache_ObjectUiEvent.
    EMPTY TEMP-TABLE cache_ObjectPage.
    EMPTY TEMP-TABLE cache_ObjectLink.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* destroyClassCache */

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
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcLogicalObjectName         AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pdUserObj                   AS DECIMAL      NO-UNDO.
    DEFINE INPUT  PARAMETER pcResultCode                AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pdLanguageObj               AS DECIMAL      NO-UNDO.
    DEFINE INPUT  PARAMETER pcRunAttribute              AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER plDesignMode                AS LOGICAL      NO-UNDO.

    DEFINE VARIABLE dRecordIdentifier       AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE hObjectTable            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hPageTable              AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hPageInstanceTable      AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hLinkTable              AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hUiEventTable           AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hClassAttributeTable    AS HANDLE EXTENT 26         NO-UNDO.
    DEFINE VARIABLE hClassAttributeBuffer   AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE iTableLoop              AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cAttributeTableNames    AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cAttributeBufferHandles AS CHARACTER                NO-UNDO.     

    /** Run serverFetchObject on the AppServer. 
     *  ----------------------------------------------------------------------- **/
    { dynlaunch.i
        &Plip  = 'RepositoryManager'
        &IProc = 'serverFetchObject'
        
        &mode1  = INPUT  &parm1  = pcLogicalObjectName      &datatype1 = CHARACTER
        &mode2  = INPUT  &parm2  = pdUserObj                &datatype2 = DECIMAL
        &mode3  = INPUT  &parm3  = pcResultCode             &datatype3 = CHARACTER
        &mode4  = INPUT  &parm4  = pdLanguageObj            &datatype4 = DECIMAL
        &mode5  = INPUT  &parm5  = pcRunAttribute           &datatype5 = CHARACTER
        &mode6  = INPUT  &parm6  = plDesignMode             &datatype6 = LOGICAL
        
        &mode7  = OUTPUT &parm7  = hObjectTable             &datatype7  = TABLE-HANDLE
        &mode8  = OUTPUT &parm8  = hPageTable               &datatype8  = TABLE-HANDLE
        &mode9  = OUTPUT &parm9  = hPageInstanceTable       &datatype9  = TABLE-HANDLE
        &mode10 = OUTPUT &parm10 = hLinkTable               &datatype10 = TABLE-HANDLE
        &mode11 = OUTPUT &parm11 = hUiEventTable            &datatype11 = TABLE-HANDLE
        &mode12 = OUTPUT &parm12 = hClassAttributeTable[01] &datatype12 = TABLE-HANDLE
        &mode13 = OUTPUT &parm13 = hClassAttributeTable[02] &datatype13 = TABLE-HANDLE
        &mode14 = OUTPUT &parm14 = hClassAttributeTable[03] &datatype14 = TABLE-HANDLE
        &mode15 = OUTPUT &parm15 = hClassAttributeTable[04] &datatype15 = TABLE-HANDLE
        &mode16 = OUTPUT &parm16 = hClassAttributeTable[05] &datatype16 = TABLE-HANDLE
        &mode17 = OUTPUT &parm17 = hClassAttributeTable[06] &datatype17 = TABLE-HANDLE
        &mode18 = OUTPUT &parm18 = hClassAttributeTable[07] &datatype18 = TABLE-HANDLE
        &mode19 = OUTPUT &parm19 = hClassAttributeTable[08] &datatype19 = TABLE-HANDLE
        &mode20 = OUTPUT &parm20 = hClassAttributeTable[09] &datatype20 = TABLE-HANDLE
        &mode21 = OUTPUT &parm21 = hClassAttributeTable[10] &datatype21 = TABLE-HANDLE
        &mode22 = OUTPUT &parm22 = hClassAttributeTable[11] &datatype22 = TABLE-HANDLE
        &mode23 = OUTPUT &parm23 = hClassAttributeTable[12] &datatype23 = TABLE-HANDLE
        &mode24 = OUTPUT &parm24 = hClassAttributeTable[13] &datatype24 = TABLE-HANDLE
        &mode25 = OUTPUT &parm25 = hClassAttributeTable[14] &datatype25 = TABLE-HANDLE
        &mode26 = OUTPUT &parm26 = hClassAttributeTable[15] &datatype26 = TABLE-HANDLE
        &mode27 = OUTPUT &parm27 = hClassAttributeTable[16] &datatype27 = TABLE-HANDLE
        &mode28 = OUTPUT &parm28 = hClassAttributeTable[17] &datatype28 = TABLE-HANDLE
        &mode29 = OUTPUT &parm29 = hClassAttributeTable[18] &datatype29 = TABLE-HANDLE
        &mode30 = OUTPUT &parm30 = hClassAttributeTable[19] &datatype30 = TABLE-HANDLE
        &mode31 = OUTPUT &parm31 = hClassAttributeTable[20] &datatype31 = TABLE-HANDLE
        &mode32 = OUTPUT &parm32 = hClassAttributeTable[21] &datatype32 = TABLE-HANDLE
        &mode33 = OUTPUT &parm33 = hClassAttributeTable[22] &datatype33 = TABLE-HANDLE
        &mode34 = OUTPUT &parm34 = hClassAttributeTable[23] &datatype34 = TABLE-HANDLE
        &mode35 = OUTPUT &parm35 = hClassAttributeTable[24] &datatype35 = TABLE-HANDLE
        &mode36 = OUTPUT &parm36 = hClassAttributeTable[25] &datatype36 = TABLE-HANDLE
        &mode37 = OUTPUT &parm37 = hClassAttributeTable[26] &datatype37 = TABLE-HANDLE
    }
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

    /** All of the tables returned by the server need to exist in the ttClass
     *  TT. This code ensures that they are. 
     *  We will make sure that they are populated correctly in putObjectInCache.
     *  ----------------------------------------------------------------------- **/
    DO iTableLoop = 1 TO EXTENT(hClassAttributeTable):
        IF NOT VALID-HANDLE(hClassAttributeTable[iTableLoop]) THEN
            NEXT.

        ASSIGN hClassAttributeBuffer = hClassAttributeTable[iTableLoop]:DEFAULT-BUFFER-HANDLE.

        FIND FIRST ttClass WHERE ttClass.ClassTableName = hClassAttributeTable[iTableLoop]:NAME NO-ERROR.
        IF NOT AVAILABLE ttClass THEN
        DO:
            /* Create an entry in the ttClass temp-table. The table we have just returned will
             * now be used for all the future attributes of the specified class.               */
            CREATE ttClass.
            ASSIGN ttClass.ClassTableName      = hClassAttributeTable[iTableLoop]:NAME
                   ttClass.ClassName           = ENTRY(NUM-ENTRIES(ttClass.ClassTableName, "_":U), ttClass.ClassTableName, "_":U)
                   ttClass.ClassBufferHandle   = hClassAttributeBuffer
                   ttClass.InheritsFromClasses = hClassAttributeBuffer:BUFFER-FIELD("tInheritsFromClasses":U):INITIAL
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
    DO iTableLoop = 1 TO EXTENT(hClassAttributeTable):
        IF NOT VALID-HANDLE(hClassAttributeTable[iTableLoop]) THEN
            NEXT.

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
    RETURN.
END PROCEDURE.  /* doServerRetrieval */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-extractRootFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extractRootFile Procedure 
PROCEDURE extractRootFile :
/*------------------------------------------------------------------------------
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

    DEFINE VARIABLE hBufferCacheTable                   AS HANDLE   NO-UNDO.

    IF NOT DYNAMIC-FUNCTION("cacheObjectOnClient":U,
                            INPUT pcLogicalObjectName,
                            INPUT pcResultCode,
                            INPUT pcRunAttribute,
                            INPUT plDesignMode          ) THEN
        RETURN ERROR "+".

    CREATE TEMP-TABLE hBufferCacheTable.
    hBufferCacheTable:CREATE-LIKE(BUFFER cache_BufferCache:HANDLE).
    hBufferCacheTable:TEMP-TABLE-PREPARE("return_BufferCache":U).

    ASSIGN phBufferCacheBuffer = hBufferCacheTable:DEFAULT-BUFFER-HANDLE.

    phBufferCacheBuffer:BUFFER-CREATE().
    ASSIGN phBufferCacheBuffer:BUFFER-FIELD("tBufferHandle":U):BUFFER-VALUE          = DYNAMIC-FUNCTION("getCacheObjectBuffer":U, INPUT ?)
           phBufferCacheBuffer:BUFFER-FIELD("tBufferName":U):BUFFER-VALUE            = "return_Object":U
           phBufferCacheBuffer:BUFFER-FIELD("tIsClassAttributeTable":U):BUFFER-VALUE = NO
           .
    phBufferCacheBuffer:BUFFER-RELEASE().

    phBufferCacheBuffer:BUFFER-CREATE().
    ASSIGN phBufferCacheBuffer:BUFFER-FIELD("tBufferHandle":U):BUFFER-VALUE          = DYNAMIC-FUNCTION("getCachePageBuffer":U)
           phBufferCacheBuffer:BUFFER-FIELD("tBufferName":U):BUFFER-VALUE            = "return_ObjectPage":U
           phBufferCacheBuffer:BUFFER-FIELD("tIsClassAttributeTable":U):BUFFER-VALUE = NO
           .
    phBufferCacheBuffer:BUFFER-RELEASE().

    phBufferCacheBuffer:BUFFER-CREATE().
    ASSIGN phBufferCacheBuffer:BUFFER-FIELD("tBufferHandle":U):BUFFER-VALUE          = DYNAMIC-FUNCTION("getCachePageInstanceBuffer":U)
           phBufferCacheBuffer:BUFFER-FIELD("tBufferName":U):BUFFER-VALUE            = "return_ObjectPageInstance":U
           phBufferCacheBuffer:BUFFER-FIELD("tIsClassAttributeTable":U):BUFFER-VALUE = NO
           .
    phBufferCacheBuffer:BUFFER-RELEASE().

    phBufferCacheBuffer:BUFFER-CREATE().
    ASSIGN phBufferCacheBuffer:BUFFER-FIELD("tBufferHandle":U):BUFFER-VALUE          = DYNAMIC-FUNCTION("getCacheLinkBuffer":U)
           phBufferCacheBuffer:BUFFER-FIELD("tBufferName":U):BUFFER-VALUE            = "return_ObjectLink":U
           phBufferCacheBuffer:BUFFER-FIELD("tIsClassAttributeTable":U):BUFFER-VALUE = NO
           .
    phBufferCacheBuffer:BUFFER-RELEASE().

    phBufferCacheBuffer:BUFFER-CREATE().
    ASSIGN phBufferCacheBuffer:BUFFER-FIELD("tBufferHandle":U):BUFFER-VALUE          = DYNAMIC-FUNCTION("getCacheUiEventBuffer":U)
           phBufferCacheBuffer:BUFFER-FIELD("tBufferName":U):BUFFER-VALUE            = "return_ObjectUiEvent":U
           phBufferCacheBuffer:BUFFER-FIELD("tIsClassAttributeTable":U):BUFFER-VALUE = NO
           .
    phBufferCacheBuffer:BUFFER-RELEASE().

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* fetchObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getActions Procedure 
PROCEDURE getActions :
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
  RUN rygetitemp (INPUT pcCategoryList,
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
  Purpose:  This is a wrapper procedure for the getClassChildrenFromDB function
            to allow it being called using the dynamic call include seeing that
            the function needs to be run on the AppServer-side Repository Manager.
  
  Parameters:  INPUT  pcClasses   - Comma delimited list of classes to retrieve
               OUTPUT pcClassList - Function return value
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcClasses   AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcClassList AS CHARACTER  NO-UNDO.

  pcClassList = DYNAMIC-FUNCTION("getClassChildrenFromDB":U, pcClasses).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassParentsProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getClassParentsProc Procedure 
PROCEDURE getClassParentsProc :
/*------------------------------------------------------------------------------
  Purpose:  This is a wrapper procedure for the getClassParentFromDB function
            to allow it being called using the dynamic call include seeing that
            the function needs to be run on the AppServer-side Repository Manager.
  
  Parameters:  INPUT  pcClasses   - Comma delimited list of classes to retrieve
               OUTPUT pcClassList - Function return value
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcClasses   AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcClassList AS CHARACTER  NO-UNDO.

  pcClassList = DYNAMIC-FUNCTION("getClassParentsFromDB":U, pcClasses).

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getObjectNames Procedure 
PROCEDURE getObjectNames :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcObjectName            AS CHARACTER        NO-UNDO.
    DEFINE INPUT  PARAMETER pcRunAttribute          AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcPhysicalName          AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcLogicalName           AS CHARACTER        NO-UNDO.

    DEFINE VARIABLE cRootFileExt  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cRootFile     AS CHARACTER  NO-UNDO.

    RUN extractRootFile IN gshRepositoryManager (INPUT pcObjectName, OUTPUT cRootFile, OUTPUT cRootFileExt) NO-ERROR.

    /* Get the object name (i.e. with or without the extension, whatever is needed to retrieve the object */
    ASSIGN
        cRootFileExt = (IF cRootFileExt = "":U THEN cRootFile    ELSE cRootFileExt)
        pcObjectName = (IF cRootFileExt = "":U THEN pcObjectName ELSE cRootFileExt).
    
    /* cacheObjectOnClient ensures that an object is cached on the client. */
    IF DYNAMIC-FUNCTION("cacheObjectOnClient":U,
                        INPUT pcObjectName,
                        INPUT ?,
                        INPUT pcRunAttribute,
                        INPUT NO)  THEN
    DO:
        IF AVAILABLE cache_Object THEN
            ASSIGN pcPhysicalName = cache_Object.tObjectPathedFilename
                   pcLogicalName  = cache_Object.tLogicalObjectName
                   .
    END.    /* object succesfully cached on client. */
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
  Purpose:     Returns an objects custom super procedure to a caller.
  Parameters:  pcObjectName      - the object name
               pcRunAttribute    - the run attribute for this object.
               pcCustomSuperProc - the name of the cusstom super procedure
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcObjectName        AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcRunAttribute      AS CHARACTER            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcCustomSuperProc   AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE cRootFileExt  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cRootFile     AS CHARACTER  NO-UNDO.

    RUN extractRootFile IN gshRepositoryManager (INPUT pcObjectName, OUTPUT cRootFile, OUTPUT cRootFileExt) NO-ERROR.

    /* Get the object name (i.e. with or without the extension, whatever is needed to retrieve the object */
    ASSIGN
        cRootFileExt = (IF cRootFileExt = "":U THEN cRootFile    ELSE cRootFileExt)
        pcObjectName = (IF cRootFileExt = "":U THEN pcObjectName ELSE cRootFileExt).

    /* cacheObjectOnClient ensures that an object is cached on the client. */
    IF DYNAMIC-FUNCTION("cacheObjectOnClient":U,
                        INPUT pcObjectName,
                        INPUT ?,
                        INPUT pcRunAttribute,
                        INPUT NO)  THEN
    DO:
        IF AVAILABLE cache_Object THEN
            ASSIGN pcCustomSuperProc = cache_Object.tCustomSuperProc.
    END.    /* object succesfully cached on client. */
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

DEFINE VARIABLE lCacheToolbar                   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE dUserObj                        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dOrganisationObj                AS DECIMAL    NO-UNDO.

/* Get the current user and organisation */

ASSIGN dUserObj         = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,INPUT "currentUserObj":U,INPUT NO))
       dOrganisationObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,INPUT "currentOrganisationObj":U,INPUT NO))
       lCacheToolbar    = NOT (DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, INPUT "cacheToolbar":U,INPUT YES) = "no":U).

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

/* See if we can find the toolbar in the cache and remove it if it is not supposed to be cached so that a fresh copy of the toolbar (and related menu
   structures) can be retrieved in the subsequent call below */
IF lCacheToolbar = FALSE                                                  AND 
   CAN-FIND(FIRST ttStoreToolbarsCached
            WHERE ttStoreToolbarsCached.cToolbarName       = pcToolbar
              AND ttStoreToolbarsCached.cLogicalObjectName = pcObjectList
              AND ttStoreToolbarsCached.cBand              = pcBandList)  THEN
DO:

  FIND FIRST ttStoreToolbarsCached
       WHERE ttStoreToolbarsCached.cToolbarName       = pcToolbar
         AND ttStoreToolbarsCached.cLogicalObjectName = pcObjectList
         AND ttStoreToolbarsCached.cBand              = pcBandList.

  DELETE ttStoreToolbarsCached.

  FOR EACH ttCacheToolbarBand
     WHERE ttCacheToolbarBand.cToolbarName       = pcToolbar
       AND ttCacheToolbarBand.cLogicalObjectName = pcObjectList
       AND ttCacheToolbarBand.cBand              = pcBandList:

      DELETE ttCacheToolbarBand.
  END.

  FOR EACH ttCacheObjectBand
     WHERE ttCacheObjectBand.cToolbarName       = pcToolbar
       AND ttCacheObjectBand.cLogicalObjectName = pcObjectList
       AND ttCacheObjectBand.cBand              = pcBandList:

      DELETE ttCacheObjectBand.
  END.

  FOR EACH ttCacheBand
     WHERE ttCacheBand.cToolbarName       = pcToolbar
       AND ttCacheBand.cLogicalObjectName = pcObjectList
       AND ttCacheBand.cBand              = pcBandList:

      DELETE ttCacheBand.
  END.

  FOR EACH ttCacheBandAction
     WHERE ttCacheBandAction.cToolbarName       = pcToolbar
       AND ttCacheBandAction.cLogicalObjectName = pcObjectList
       AND ttCacheBandAction.cBand              = pcBandList:

      DELETE ttCacheBandAction.
  END.

  FOR EACH ttCacheAction
     WHERE ttCacheAction.cToolbarName       = pcToolbar
       AND ttCacheAction.cLogicalObjectName = pcObjectList
       AND ttCacheAction.cBand              = pcBandList:

      DELETE ttCacheAction.
  END.

  FOR EACH ttCacheCategory
     WHERE ttCacheCategory.cToolbarName       = pcToolbar
       AND ttCacheCategory.cLogicalObjectName = pcObjectList
       AND ttCacheCategory.cBand              = pcBandList:

      DELETE ttCacheCategory.
  END.
END.

/* See if we can find this toolbar in the cache */

IF CAN-FIND(FIRST ttStoreToolbarsCached
            WHERE ttStoreToolbarsCached.cToolbarName       = pcToolbar
              AND ttStoreToolbarsCached.cLogicalObjectName = pcObjectList
              AND ttStoreToolbarsCached.cBand              = pcBandList) 
THEN DO:
    /* Move info from the cached tables to the return tables */

    FOR EACH ttCacheToolbarBand
       WHERE ttCacheToolbarBand.cToolbarName       = pcToolbar
         AND ttCacheToolbarBand.cLogicalObjectName = pcObjectList
         AND ttCacheToolbarBand.cBand              = pcBandList:

      /* If the record already exists which constitutes it's unique index,
         do not create the temp table */
       FIND FIRST ttToolbarBand 
            WHERE ttToolbarBand.ToolbarName = ttCacheToolbarBand.Toolbarname
              AND ttToolbarBand.Band        = ttCacheToolbarBand.Band NO-ERROR.

       IF NOT AVAILABLE ttToolbarBand THEN
       DO:
          CREATE ttToolbarBand.
          BUFFER-COPY ttCacheToolbarBand TO ttToolbarBand.
       END.
    END.

    FOR EACH ttCacheObjectBand
       WHERE ttCacheObjectBand.cToolbarName       = pcToolbar
         AND ttCacheObjectBand.cLogicalObjectName = pcObjectList
         AND ttCacheObjectBand.cBand              = pcBandList:

       FIND FIRST ttObjectBand 
            WHERE ttObjectBand.ObjectName   = ttCacheObjectBand.ObjectName
              AND ttObjectBand.RunAttribute = ttCacheObjectBand.RunAttribute
              AND ttObjectBand.ResultCode   = ttCacheObjectBand.ResultCode
              AND ttObjectBand.Sequence     = ttCacheObjectBand.Sequence NO-ERROR.

       IF NOT AVAILABLE ttObjectBand THEN
       DO:
          CREATE ttObjectBand.
          BUFFER-COPY ttCacheObjectBand TO ttObjectBand.
       END.
    END.

    FOR EACH ttCacheBand
       WHERE ttCacheBand.cToolbarName       = pcToolbar
         AND ttCacheBand.cLogicalObjectName = pcObjectList
         AND ttCacheBand.cBand              = pcBandList:

      FIND FIRST ttBand 
           WHERE ttBand.Band            = ttCacheBand.Band
             AND ttBand.Procedurehandle = ttCacheBand.ProcedureHandle NO-ERROR.

      IF NOT AVAILABLE ttBand THEN
      DO:
         CREATE ttBand.
         BUFFER-COPY ttCacheBand TO ttBand.
      END.
    END.

    FOR EACH ttCacheBandAction
       WHERE ttCacheBandAction.cToolbarName       = pcToolbar
         AND ttCacheBandAction.cLogicalObjectName = pcObjectList
         AND ttCacheBandAction.cBand              = pcBandList:

      FIND FIRST ttBandAction 
           WHERE ttBandAction.Band            = ttCacheBandAction.Band
             AND ttBandAction.Sequence        = ttCacheBandAction.Sequence
             AND ttBandAction.Procedurehandle = ttCacheBandAction.ProcedureHandle NO-ERROR.

      IF NOT AVAILABLE ttBandAction THEN
      DO:
         CREATE ttBandAction.
         BUFFER-COPY ttCacheBandAction TO ttBandAction.
      END.
    END.

    FOR EACH ttCacheAction
       WHERE ttCacheAction.cToolbarName       = pcToolbar
         AND ttCacheAction.cLogicalObjectName = pcObjectList
         AND ttCacheAction.cBand              = pcBandList:

         FIND FIRST ttAction 
           WHERE ttAction.Action          = ttCacheAction.Action
             AND ttAction.Procedurehandle = ttCacheAction.ProcedureHandle NO-ERROR.

      IF NOT AVAILABLE ttAction THEN
      DO:
         CREATE ttAction.
         BUFFER-COPY ttCacheAction TO ttAction.
      END.
    END.

    FOR EACH ttCacheCategory
       WHERE ttCacheCategory.cToolbarName       = pcToolbar
         AND ttCacheCategory.cLogicalObjectName = pcObjectList
         AND ttCacheCategory.cBand              = pcBandList:

      FIND FIRST ttCategory 
           WHERE ttCategory.Category        = ttCacheCategory.Category
             AND ttCategory.Procedurehandle = ttCacheCategory.ProcedureHandle NO-ERROR.

      IF NOT AVAILABLE ttCategory THEN
      DO:
        CREATE ttCategory.
        BUFFER-COPY ttCacheCategory TO ttCategory.
      END.
    END.

    RETURN.
END.
ELSE DO:
    /* If not available in the cache, retrieve toolbars from the Appserver */

    &IF DEFINED(server-side) <> 0 &THEN
      RUN rygetmensp (INPUT pcToolbar,
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

    /* Create the retreived records in the cache - if the toolbar and menu details are supposed to be cached */
    IF lCacheToolbar = TRUE THEN
    DO:
      CREATE ttStoreToolbarsCached.
      ASSIGN ttStoreToolbarsCached.cToolbarName       = pcToolbar
             ttStoreToolbarsCached.cLogicalObjectName = pcObjectList
             ttStoreToolbarsCached.cBand              = pcBandList.

      FOR EACH ttToolbarBand:
          CREATE ttCacheToolbarBand.
          BUFFER-COPY ttToolbarBand TO ttCacheToolbarBand
              ASSIGN ttCacheToolbarBand.cToolbarName       = pcToolbar
                     ttCacheToolbarBand.cLogicalObjectName = pcObjectList
                     ttCacheToolbarBand.cBand              = pcBandList.
      END.

      FOR EACH ttObjectBand:
          CREATE ttCacheObjectBand.
          BUFFER-COPY ttObjectBand TO ttCacheObjectBand
              ASSIGN ttCacheObjectBand.cToolbarName       = pcToolbar
                     ttCacheObjectBand.cLogicalObjectName = pcObjectList
                     ttCacheObjectBand.cBand              = pcBandList.
      END.

      FOR EACH ttBand:
          CREATE ttCacheBand.
          BUFFER-COPY ttBand TO ttCacheBand
              ASSIGN ttCacheBand.cToolbarName       = pcToolbar
                     ttCacheBand.cLogicalObjectName = pcObjectList
                     ttCacheBand.cBand              = pcBandList.
      END.

      FOR EACH ttBandAction:
          CREATE ttCacheBandAction.
          BUFFER-COPY ttBandAction TO ttCacheBandAction
              ASSIGN ttCacheBandAction.cToolbarName       = pcToolbar
                     ttCacheBandAction.cLogicalObjectName = pcObjectList
                     ttCacheBandAction.cBand              = pcBandList.
      END.

      FOR EACH ttAction:
          CREATE ttCacheAction.
          BUFFER-COPY ttAction TO ttCacheAction
              ASSIGN ttCacheAction.cToolbarName       = pcToolbar
                     ttCacheAction.cLogicalObjectName = pcObjectList
                     ttCacheAction.cBand              = pcBandList.
      END.

      FOR EACH ttCategory:
          CREATE ttCacheCategory.
          BUFFER-COPY ttCategory TO ttCacheCategory
              ASSIGN ttCacheCategory.cToolbarName       = pcToolbar
                     ttCacheCategory.cLogicalObjectName = pcObjectList
                     ttCacheCategory.cBand              = pcBandList.
      END.
    END. /* lCacheToolbar = TRUE */
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
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
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER phSourceObject           AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER phSourcePage             AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER phSourcePageInstance     AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER phSourceLink             AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER phSourceUiEvent          AS HANDLE               NO-UNDO.
    DEFINE INPUT PARAMETER pcAttributeTableNames    AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcAttributeBufferHandles AS CHARACTER            NO-UNDO.  

    DEFINE VARIABLE hObjectBuffer           AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hPageBuffer             AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hLinkBuffer             AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hUiEventBuffer          AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hClassAttributeBuffer   AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hSourceAttributeBuffer  AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE dRecordIdentifier       AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE iEntry                  AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iQueryOrdinal1          AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iQueryOrdinal2          AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cBuffName               AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cWhereClause            AS CHARACTER                NO-UNDO.

    ASSIGN hObjectBuffer       = BUFFER cache_Object:HANDLE
           hPageBuffer         = BUFFER cache_ObjectPage:HANDLE
           hLinkBuffer         = BUFFER cache_ObjectLink:HANDLE
           hUiEventBuffer      = BUFFER cache_ObjectUiEvent:HANDLE
           .
    /* Create the queries here because we want to re-use the query and not have the 
     * overhead of having to CREATE QUERY everytime.                                */
    ASSIGN iQueryOrdinal1 = DYNAMIC-FUNCTION("getNextQueryOrdinal":U).
    IF NOT VALID-HANDLE(ghQuery[iQueryOrdinal1]) THEN
        CREATE QUERY ghQuery[iQueryOrdinal1].
    
    ghQuery[iQueryOrdinal1]:SET-BUFFERS(phSourceObject).
    ghQuery[iQueryOrdinal1]:QUERY-PREPARE(" FOR EACH ":U + phSourceObject:NAME).
    ghQuery[iQueryOrdinal1]:QUERY-OPEN().
    ghQuery[iQueryOrdinal1]:GET-FIRST().

    /* We need to get this ordinal value after the previous query has been opened. */
    ASSIGN iQueryOrdinal2 = DYNAMIC-FUNCTION("getNextQueryOrdinal":U).
    IF NOT VALID-HANDLE(ghQuery[iQueryOrdinal2]) THEN
        CREATE QUERY ghQuery[iQueryOrdinal2].

    DO WHILE phSourceObject:AVAILABLE:
        ASSIGN 
            dRecordIdentifier = phSourceObject:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE.

        /* Is it already in the cache? 
         * Even though the requested object is not in the cache at this stage, one or more               *
         * or the contained object instances' master objects may already be cached. We need to make sure *
         * that we don't have the same Master object cached more than once.                              */        
        FIND FIRST cache_Object 
            WHERE cache_Object.tRecordIdentifier = dRecordIdentifier
            NO-ERROR.

        IF NOT AVAILABLE(cache_Object) THEN
          FIND FIRST cache_Object 
              WHERE cache_Object.tRecordIdentifier  = dRecordIdentifier
                AND cache_Object.tLogicalObjectName = STRING(phSourceObject:BUFFER-FIELD("tLogicalObjectName":U):BUFFER-VALUE)
                AND cache_Object.tUserObj           = DECIMAL(phSourceObject:BUFFER-FIELD("tUserObj":U):BUFFER-VALUE)
                AND cache_Object.tResultCode        = STRING(phSourceObject:BUFFER-FIELD("tResultCode":U):BUFFER-VALUE)     
                AND cache_Object.tRunAttribute      = STRING(phSourceObject:BUFFER-FIELD("tRunAttribute":U):BUFFER-VALUE)
                AND cache_Object.tLanguageObj       = DECIMAL(phSourceObject:BUFFER-FIELD("tLanguageObj":U):BUFFER-VALUE)    
                AND cache_Object.tObjectInstanceObj = DECIMAL(phSourceObject:BUFFER-FIELD("tObjectInstanceObj":U):BUFFER-VALUE)
              NO-ERROR.
        
        IF NOT AVAILABLE(cache_Object) THEN
        DO:
            /* Create a Cache entry. */
            CREATE cache_Object.
            hObjectBuffer:BUFFER-COPY(phSourceObject).

            /* Make sure that the cacheed record points at the correct attribute buffer handle. *
             * This TT record should already exist.                                             */
            FIND FIRST ttClass WHERE ttClass.ClassTableName = cache_Object.tClassTableName.
            ASSIGN cache_Object.tClassBufferHandle = ttClass.ClassBufferHandle.
            RELEASE cache_Object.

            /* Put the attribute values into the relevant class attribute buffer. */
            ASSIGN iEntry                 = LOOKUP(ttClass.classTableName, pcAttributeTableNames)
                   hSourceAttributeBuffer = WIDGET-HANDLE(ENTRY(iEntry, pcAttributeBufferHandles)) NO-ERROR.

            /* If the buffer handles are the same in both the ttClass table and 
             * the source attribute buffer handle list, then the ttClass record 
             * was created from the returned attribute table (in this procedure's
             * calling procedure). If this is the case, then the relevant record is
             * already in the buffer, and so there is no need to create another 
             * record.                                                          */
            IF VALID-HANDLE(hSourceAttributeBuffer) AND hSourceAttributeBuffer NE ttClass.classBufferHandle THEN
            DO:
                hSourceAttributeBuffer:FIND-FIRST(" WHERE " + hSourceAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dRecordIdentifier)) NO-ERROR.
                ttClass.classBufferHandle:FIND-FIRST(" WHERE " + ttClass.classBufferHandle:NAME + ".tRecordIdentifier = ":U + QUOTER(dRecordIdentifier)) NO-ERROR.

                IF hSourceAttributeBuffer:AVAILABLE AND NOT ttClass.classBufferHandle:AVAILABLE THEN
                DO:
                    ttClass.classBufferHandle:BUFFER-CREATE().
                    ttClass.classBufferHandle:BUFFER-COPY(hSourceAttributeBuffer).
                    ttClass.classBufferHandle:BUFFER-RELEASE().
                END.    /* availableattributes */
            END.    /* valid source buffer. */

            /* ObjectPage */
            ghQuery[iQueryOrdinal2]:SET-BUFFERS(phSourcePage).
            ghQuery[iQueryOrdinal2]:QUERY-PREPARE(" FOR EACH ":U + phSourcePage:NAME + " WHERE ":U + phSourcePage:NAME + ".tRecordIdentifier = ":U + QUOTER(dRecordIdentifier)).
            ghQuery[iQueryOrdinal2]:QUERY-OPEN().
            ghQuery[iQueryOrdinal2]:GET-FIRST().

            DO WHILE phSourcePage:AVAILABLE:
                hPageBuffer:BUFFER-CREATE().
                hPageBuffer:BUFFER-COPY(phSourcePage).
                hPageBuffer:BUFFER-RELEASE().

                ghQuery[iQueryOrdinal2]:GET-NEXT().
            END.    /* record available*/
            ghQuery[iQueryOrdinal2]:QUERY-CLOSE().

            /* ObjectLink */
            ghQuery[iQueryOrdinal2]:SET-BUFFERS(phSourceLink).
            ghQuery[iQueryOrdinal2]:QUERY-PREPARE(" FOR EACH ":U + phSourceLink:NAME + " WHERE ":U + phSourceLink:NAME + ".tRecordIdentifier = ":U + QUOTER(dRecordIdentifier)).
            ghQuery[iQueryOrdinal2]:QUERY-OPEN().
            ghQuery[iQueryOrdinal2]:GET-FIRST().

            DO WHILE phSourceLink:AVAILABLE:
                hLinkBuffer:BUFFER-CREATE().
                hLinkBuffer:BUFFER-COPY(phSourceLink).
                hLinkBuffer:BUFFER-RELEASE().

                ghQuery[iQueryOrdinal2]:GET-NEXT().
            END.    /* record available*/
            ghQuery[iQueryOrdinal2]:QUERY-CLOSE().

            /* ObjectUiEvent */
            ghQuery[iQueryOrdinal2]:SET-BUFFERS(phSourceUiEvent).
            ghQuery[iQueryOrdinal2]:QUERY-PREPARE(" FOR EACH ":U + phSourceUiEvent:NAME + " WHERE ":U + phSourceUiEvent:NAME + ".tRecordIdentifier = ":U + QUOTER(dRecordIdentifier)).
            ghQuery[iQueryOrdinal2]:QUERY-OPEN().
            ghQuery[iQueryOrdinal2]:GET-FIRST().

            DO WHILE phSourceUiEvent:AVAILABLE:
                huiEventBuffer:BUFFER-CREATE().
                huiEventBuffer:BUFFER-COPY(phSourceUiEvent).
                huiEventBuffer:BUFFER-RELEASE().

                ghQuery[iQueryOrdinal2]:GET-NEXT().
            END.    /* record available*/
            ghQuery[iQueryOrdinal2]:QUERY-CLOSE().
        END.    /* put it in the cache. */
        ELSE
        IF dRecordIdentifier NE cache_Object.tRecordIdentifier THEN
        DO:
            /* Remove the returned CACHE_OBJECT* attributes from the Class attribute records sent. */
            IF pcAttributeTableNames <> "":U THEN /* Will be true for Appserver */
                ASSIGN hClassAttributeBuffer = WIDGET-HANDLE(ENTRY(LOOKUP(phSourceObject:BUFFER-FIELD("tClassTableName":U):BUFFER-VALUE, pcAttributeTableNames), pcAttributeBufferHandles)).
            ELSE
                ASSIGN hClassAttributeBuffer = phSourceObject:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.

            hClassAttributeBuffer:FIND-FIRST(" WHERE ":U + hClassAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dRecordIdentifier) ) NO-ERROR.

            IF hClassAttributeBuffer:AVAILABLE THEN
            DO:
                hClassAttributeBuffer:BUFFER-DELETE().
                hClassAttributeBuffer:BUFFER-RELEASE().
            END.    /* available record in the attribute TT. */
        END.    /* Object is in the cache already. */

        ghQuery[iQueryOrdinal1]:GET-NEXT().
    END.    /* each returned cache_Object */
    ghQuery[iQueryOrdinal1]:QUERY-CLOSE().

    ASSIGN hObjectBuffer       = ?
           hPageBuffer         = ?
           hLinkBuffer         = ?
           hUiEventBuffer      = ?
           .
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
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
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER hBufferCache   AS HANDLE     NO-UNDO.
    DEFINE INPUT  PARAMETER cTableHandles  AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE hClassAttributeTable  AS HANDLE  EXTENT 32   NO-UNDO.
    DEFINE VARIABLE hTable                AS HANDLE              NO-UNDO.
    DEFINE VARIABLE iExtentLoop           AS INTEGER             NO-UNDO.
    DEFINE VARIABLE cClassName            AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE hCacheUiEvent         AS HANDLE              NO-UNDO.
    DEFINE VARIABLE hQuery                AS HANDLE              NO-UNDO.
    DEFINE VARIABLE hBuffer               AS HANDLE              NO-UNDO.
    DEFINE VARIABLE hClassUiEventTable    AS HANDLE              NO-UNDO.

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

        IF NOT AVAILABLE ttClass THEN
        DO:
            CREATE ttClass.
            /* Guesstimate the class name. */
            ASSIGN ttClass.ClassTableName    = hClassAttributeTable[iExtentLoop]:NAME
                   ttClass.ClassName         = ENTRY(NUM-ENTRIES(ttClass.ClassTableName, "_":U), ttClass.ClassTableName, "_":U)
                   NO-ERROR.
        END.    /* n/a ttClass record. */

        IF NOT VALID-HANDLE(ttClass.ClassBufferHandle) THEN
            ASSIGN ttClass.ClassBufferHandle = hClassAttributeTable[iExtentLoop]:DEFAULT-BUFFER-HANDLE.
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-receiveCacheMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveCacheMenu Procedure 
PROCEDURE receiveCacheMenu :
/*------------------------------------------------------------------------------
  Purpose:     When the menu cache is supplemented from an external source,
               run this procedure.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR ttStoreToolbarsCached APPEND.
DEFINE INPUT PARAMETER TABLE FOR ttCacheToolbarBand    APPEND.
DEFINE INPUT PARAMETER TABLE FOR ttCacheObjectBand     APPEND.
DEFINE INPUT PARAMETER TABLE FOR ttCacheBand           APPEND.
DEFINE INPUT PARAMETER TABLE FOR ttCacheBandAction     APPEND.
DEFINE INPUT PARAMETER TABLE FOR ttCacheAction         APPEND.
DEFINE INPUT PARAMETER TABLE FOR ttCacheCategory       APPEND.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

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
         * now be used for all the future attributes of the specified class.               */
        CREATE ttClass.
        ASSIGN ttClass.ClassTableName      = hClassAttributeTable[iTableLoop]:NAME
               ttClass.ClassName           = ENTRY(NUM-ENTRIES(ttClass.ClassTableName, "_":U), ttClass.ClassTableName, "_":U)
               ttClass.ClassBufferHandle   = hClassAttributeBuffer
               ttClass.InheritsFromClasses = hClassAttributeBuffer:BUFFER-FIELD("tInheritsFromClasses":U):INITIAL
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
        { dynlaunch.i
            &PLIP              = "'RepositoryManager'"
            &iProc             = "'resolveResultCodes'"
            
            &mode1  = INPUT        &parm1  = plDesignMode  &dataType1  = LOGICAL
            &mode2  = INPUT-OUTPUT &parm2  = pcResultCodes &dataType2  = CHARACTER
        }
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
               pcResultCodes = LEFT-TRIM(pcResultCodes, ",":U)
               .
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

    DEFINE VARIABLE hClassQuery                 AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hClassBuffer                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hTempTableBuffer            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cClassQueryWhere            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iLoopCount                  AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iHandleNumber               AS INTEGER              NO-UNDO.

    DEFINE QUERY qryClass       FOR ttClass.

    /* Do the actual creation of the ttClass records first. */
    IF pcClassName EQ "":U THEN
        ASSIGN pcClassName  = "*":U.

    RUN buildClassCache ( INPUT pcClassName ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

    /* We only really want to pass back the records relevant to the class itself,
     * so we use the build_* table to avoind the overhead of passing all the other
     * records back.                                                              */
    EMPTY TEMP-TABLE build_ObjectUiEvent.

    ASSIGN phClassUiEventTable = TEMP-TABLE build_ObjectUiEvent:HANDLE
           hClassQuery         = QUERY qryClass:HANDLE
           hClassBuffer        = BUFFER ttClass:HANDLE
           cClassQueryWhere = " FOR EACH ttClass ":U
           .   
    IF pcClassName NE "*":U THEN
    DO:
        ASSIGN cClassQueryWhere = cClassQueryWhere + " WHERE ( FALSE ":U.

        DO iLoopCount = 1 TO NUM-ENTRIES(pcClassName):
            ASSIGN cClassQueryWhere = cClassQueryWhere + " OR ttClass.ClassName = ":U + QUOTER(ENTRY(iLoopCount, pcClassName)).
        END.    /* not all */
        ASSIGN cClassQueryWhere = cClassQueryWhere + " ) ":U.
    END.    /* selected classes */

    ASSIGN cClassQueryWhere = cClassQueryWhere + " NO-LOCK ":U
           iHandleNumber    = 0
           .   
    hClassQuery:QUERY-PREPARE(cClassQueryWhere).
    hClassQuery:QUERY-OPEN().

    hClassQuery:GET-FIRST(NO-LOCK).

    DO WHILE hClassBuffer:AVAILABLE AND iHandleNumber LT 31:
        FOR EACH cache_ObjectUiEvent WHERE
                 cache_ObjectUiEvent.tClassName        = QUOTER(hClassBuffer:BUFFER-FIELD("className":U):BUFFER-VALUE) AND
                 cache_ObjectUiEvent.tRecordIdentifier = 0 :
            CREATE build_ObjectUiEvent.
            BUFFER-COPY cache_ObjectUiEvent TO build_ObjectUiEvent.
        END.    /* all cache UI events */

        ASSIGN iHandleNumber    = iHandleNumber + 1
               hTempTableBuffer = hClassBuffer:BUFFER-FIELD("ClassBufferHandle":U):BUFFER-VALUE
               .
        CASE iHandleNumber:
            WHEN 01 THEN ASSIGN phClassAttributeTable01 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 02 THEN ASSIGN phClassAttributeTable02 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 03 THEN ASSIGN phClassAttributeTable03 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 04 THEN ASSIGN phClassAttributeTable04 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 05 THEN ASSIGN phClassAttributeTable05 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 06 THEN ASSIGN phClassAttributeTable06 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 07 THEN ASSIGN phClassAttributeTable07 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 08 THEN ASSIGN phClassAttributeTable08 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 09 THEN ASSIGN phClassAttributeTable09 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 10 THEN ASSIGN phClassAttributeTable10 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 11 THEN ASSIGN phClassAttributeTable11 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 12 THEN ASSIGN phClassAttributeTable12 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 13 THEN ASSIGN phClassAttributeTable13 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 14 THEN ASSIGN phClassAttributeTable14 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 15 THEN ASSIGN phClassAttributeTable15 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 16 THEN ASSIGN phClassAttributeTable16 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 17 THEN ASSIGN phClassAttributeTable17 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 18 THEN ASSIGN phClassAttributeTable18 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 19 THEN ASSIGN phClassAttributeTable19 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 20 THEN ASSIGN phClassAttributeTable20 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 21 THEN ASSIGN phClassAttributeTable21 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 22 THEN ASSIGN phClassAttributeTable22 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 23 THEN ASSIGN phClassAttributeTable23 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 24 THEN ASSIGN phClassAttributeTable24 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 25 THEN ASSIGN phClassAttributeTable25 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 26 THEN ASSIGN phClassAttributeTable26 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 27 THEN ASSIGN phClassAttributeTable27 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 28 THEN ASSIGN phClassAttributeTable28 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 29 THEN ASSIGN phClassAttributeTable29 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 30 THEN ASSIGN phClassAttributeTable30 = hTempTableBuffer:TABLE-HANDLE.
            WHEN 31 THEN ASSIGN phClassAttributeTable31 = hTempTableBuffer:TABLE-HANDLE.
        END CASE.   /* handle number */

        hClassQuery:GET-NEXT(NO-LOCK).
    END.    /* each class */
    hClassQuery:QUERY-CLOSE().
   
    DELETE OBJECT hClassQuery NO-ERROR.
    ASSIGN hClassQuery      = ?
           hClassBuffer     = ?
           hTempTableBuffer = ?
           .
    RETURN.
END PROCEDURE.  /* retrieveClassCache */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverFetchObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverFetchObject Procedure 
PROCEDURE serverFetchObject :
/*------------------------------------------------------------------------------
  Purpose:     Server-side object retrieval routine.
  Parameters:  
  Notes:       * Effective 'deep' retrieval - all contained containers and their
                 contained instances are retrieved.
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

    DEFINE VARIABLE iAttributeExtent                AS INTEGER          NO-UNDO.
    DEFINE VARIABLE cProcessedClasses               AS CHARACTER        NO-UNDO.

    /** We empty these temp-tables because we only want to return to the caller
     *  the tables representing the requested object.
     *  ----------------------------------------------------------------------- **/
    EMPTY TEMP-TABLE cache_Object.
    EMPTY TEMP-TABLE cache_ObjectPage.
    EMPTY TEMP-TABLE cache_ObjectPageInstance.
    EMPTY TEMP-TABLE cache_ObjectLink.
    EMPTY TEMP-TABLE cache_ObjectUiEvent.

    /* Empty cache_<Class> temp tables */
    FOR EACH ttClass:
        ttClass.classBufferHandle:EMPTY-TEMP-TABLE().
    END.    /* each class */

    /** bufferFetchObject retrieves the requested object from the Repository, and
     *  returns it in buffer form. serverFetchObject is designed to return objects
     *  in tables.
     *  ----------------------------------------------------------------------- **/
    RUN ry/app/ryretrobjp.p ( INPUT  pcLogicalObjectName,
                              INPUT  pdUserObj,
                              INPUT  pcResultCode,
                              INPUT  pdLanguageObj,
                              INPUT  pcRunAttribute,
                              INPUT  plDesignMode             ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

    /** If we are to return across an AppServer, then we need to return the
     *  cache_Object* TTs and any associated ttClass tables.
     *
     *  If not, we need to create cache_Object* records for all of the cache_Object*
     *  TT we have just created. In this case, the calling procedure will use the 
     *  cache_Object* tables to do its work.
     *  ----------------------------------------------------------------------- **/
    ASSIGN phObjectTable       = TEMP-TABLE cache_Object:HANDLE
           phPageTable         = TEMP-TABLE cache_ObjectPage:HANDLE
           phPageInstanceTable = TEMP-TABLE cache_ObjectPageInstance:HANDLE
           phLinkTable         = TEMP-TABLE cache_ObjectLink:HANDLE
           phUiEventTable      = TEMP-TABLE cache_ObjectUiEvent:HANDLE
           
           iAttributeExtent    = 1
           cProcessedClasses   = "":U
           .
    EMPTY TEMP-TABLE cache_BufferCache.

    FOR EACH cache_Object WHILE iAttributeExtent LT 27:
        /* We only want to create one return table per class. */
        IF NOT CAN-DO(cProcessedClasses, cache_Object.tClassName ) THEN
        DO:
            ASSIGN cProcessedClasses = cProcessedClasses + cache_Object.tClassName + ",":U.
            /* Attributes */
            CASE iAttributeExtent:
                WHEN 01 THEN ASSIGN phClassAttributeTable01 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 02 THEN ASSIGN phClassAttributeTable02 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 03 THEN ASSIGN phClassAttributeTable03 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 04 THEN ASSIGN phClassAttributeTable04 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 05 THEN ASSIGN phClassAttributeTable05 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 06 THEN ASSIGN phClassAttributeTable06 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 07 THEN ASSIGN phClassAttributeTable07 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 08 THEN ASSIGN phClassAttributeTable08 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 09 THEN ASSIGN phClassAttributeTable09 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 10 THEN ASSIGN phClassAttributeTable10 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 11 THEN ASSIGN phClassAttributeTable11 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 12 THEN ASSIGN phClassAttributeTable12 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 13 THEN ASSIGN phClassAttributeTable13 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 14 THEN ASSIGN phClassAttributeTable14 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 15 THEN ASSIGN phClassAttributeTable15 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 16 THEN ASSIGN phClassAttributeTable16 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 17 THEN ASSIGN phClassAttributeTable17 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 18 THEN ASSIGN phClassAttributeTable18 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 19 THEN ASSIGN phClassAttributeTable19 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 20 THEN ASSIGN phClassAttributeTable20 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 21 THEN ASSIGN phClassAttributeTable21 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 22 THEN ASSIGN phClassAttributeTable22 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 23 THEN ASSIGN phClassAttributeTable23 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 24 THEN ASSIGN phClassAttributeTable24 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 25 THEN ASSIGN phClassAttributeTable25 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
                WHEN 26 THEN ASSIGN phClassAttributeTable26 = cache_Object.tClassBufferHandle:TABLE-HANDLE.
            END CASE.   /* handle number */

            ASSIGN iAttributeExtent = iAttributeExtent + 1.
        END.    /* n/a cache_BufferCache */
    END.    /* each cache_Object */

    /* Delete the TABLE-HANDLES in the caller */

    RETURN.
END PROCEDURE.  /* serverFetchObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startDataObject Procedure 
PROCEDURE startDataObject :
/*------------------------------------------------------------------------------
  Purpose:     Fetches the specified DataObject from the repository and
               starts the object on the client.
  Parameters:  pcDataObject   Name of Data Object
               OUTPUT phSDO   Handle of started SDO
  Notes:       If the DataObject is a dynamic SDO, the procedure constructs the 
               necessary attributes
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcDataObject          AS CHARACTER          NO-UNDO.
    DEFINE OUTPUT PARAMETER phSDO                 AS HANDLE             NO-UNDO.

    DEFINE VARIABLE hAttributeBuffer            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hObjectBuffer               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cSDOFile                    AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cClassType                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cObjectInheritsFrom         AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE dRecordIdentifier           AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE cAttributeList              AS CHARACTER            NO-UNDO.

    /* Explicitly set the RunAttribute session parameter to blank. */
    DYNAMIC-FUNCTION("setSessionParam":U, INPUT "RunAttribute":U, INPUT "":U).

    IF DYNAMIC-FUNCTION("cacheObjectOnClient":U,
                        INPUT pcDataObject,
                        INPUT "{&DEFAULT-RESULT-CODE}":U,
                        INPUT "":U,
                        INPUT NO                    )  THEN
    DO:
        /* The hObjectBuffer record should be available immediately after the cacheObjectOnClient() call.
         * See that APIs comments for information.                                                       */
        ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U, INPUT ?).

        IF hObjectBuffer:AVAILABLE THEN
        DO:
            ASSIGN 
                cSDOFile            = hObjectBuffer:BUFFER-FIELD("tObjectPathedFilename":U):BUFFER-VALUE                  
                dRecordIdentifier   = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
                cObjectInheritsFrom = hObjectBuffer:BUFFER-FIELD("tInheritsFromClasses":U):BUFFER-VALUE
                hAttributeBuffer    = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
                cAttributeList      = DYNAMIC-FUNCTION("buildAttributeList":U,
                                                       hAttributeBuffer,
                                                       dRecordIdentifier).
            /* We cannot continue without the physical filename of an object to run. */
            IF cSDOFile > "":U AND (CAN-DO(cObjectInheritsFrom, "data":U) OR CAN-DO(cObjectInheritsFrom, "SBO":U)) THEN
            DO:
                /* If this is not a dynamic SDO, and we are running client-side, 
                 * then we need to run the _CL proxy. */
                &IF DEFINED(Server-Side) EQ 0 &THEN
                IF NOT (CAN-DO(cObjectInheritsFrom, "DynSdo":U) OR 
                        CAN-DO(cObjectInheritsFrom, "DynSBO":U)) THEN
                   ASSIGN cSDOFile = ENTRY(1, cSDOFile, ".":U) + "_cl.r":U.
                &ENDIF
                               
                /* So that prepareInstance knows which logical object is being run. */
                ASSIGN gcCurrentLogicalName = pcDataObject.
                DO ON STOP  UNDO, LEAVE ON ERROR UNDO, LEAVE:
                    RUN VALUE(cSDOFile) PERSISTENT SET phSDO NO-ERROR.
                END.    /* SDO run block */
                /* So that the DynSBO know how to get its contents */
                {set LogicalObjectName pcDataObject phSDO}. 
                ASSIGN gcCurrentLogicalName = "":U.

                RUN setPropertyList IN phSDO (cAttributeList).
                
                &IF DEFINED(Server-Side) EQ 0 &THEN
                 {set AsDivision 'Client':U phSDO}.
                &ENDIF
                RUN createObjects IN phSDO.
            END.    /* Is an SDO or DynSDO */
        END.    /* successfully retrieved into the cache. */
    END.    /* can find object in cache. */

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

    ASSIGN iQueryOrdinal = DYNAMIC-FUNCTION("getNextQueryOrdinal":U).

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

        /* Derived and Runtime values are not stored in the Repository. 
         * Return gracefully without giving an error.       */
        IF ryc_attribute.derived_value OR ryc_attribute.runtime_only THEN
        DO:
            ghQuery[iQueryOrdinal]:GET-NEXT().
            NEXT STORE-ATTRIBUTE-LOOP.
        END.    /* Derived or Runtime */

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

&IF DEFINED(EXCLUDE-areToolbarsCached) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION areToolbarsCached Procedure 
FUNCTION areToolbarsCached RETURNS LOGICAL
  (INPUT pcLogicalObjectName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Checks if toolbars for a specific object have been cached yet.
    Notes:  
------------------------------------------------------------------------------*/

  RETURN CAN-FIND(FIRST ttStoreToolbarsCached
                  WHERE ttStoreToolbarsCached.cLogicalObjectName = pcLogicalObjectName).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildAttributeList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildAttributeList Procedure 
FUNCTION buildAttributeList RETURNS CHARACTER
  ( INPUT phClassAttributeBuffer        AS HANDLE,
    INPUT pdRecordIdentifier            AS DECIMAL  ):
/*------------------------------------------------------------------------------
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
  Purpose:  Retrieves an object from the REpository and stores it in the client-side
            cache.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dCurrentUserObj         AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dCurrentLanguageObj     AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dRecordIdentifier       AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE cProperties             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE hManagerHandle          AS HANDLE                   NO-UNDO.

    /* Make sure that the design mode is at least NO */
    IF plDesignMode EQ ? THEN
        ASSIGN plDesignMode = NO.

    /* Get default values for the User, Language, Run Attribute and Result Codes */
    ASSIGN cProperties = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                          INPUT "currentUserObj,currentLanguageObj":U,
                                          INPUT YES).
    ASSIGN dCurrentUserObj     = DECIMAL(ENTRY(1, cProperties, CHR(3))) NO-ERROR.
    ASSIGN dCurrentLanguageObj = DECIMAL(ENTRY(2, cProperties, CHR(3))) NO-ERROR.

    /* Try to find a default value for the run attribute in run time mode */
    IF plDesignMode THEN
        ASSIGN pcRunAttribute = "":U.
    ELSE
    DO:
        IF pcRunAttribute EQ ? THEN
            ASSIGN pcRunAttribute = DYNAMIC-FUNCTION("getSessionParam":U, "RunAttribute":U).

        IF pcRunAttribute EQ ? THEN
            ASSIGN pcRunAttribute = "":U.
    END.    /* not design mode */

    /* Get a default value for the result code */
    IF NOT plDesignMode AND (pcResultCode EQ ? OR pcResultCode EQ "":U) THEN
    DO:
        ASSIGN hManagerHandle = DYNAMIC-FUNCTION("getManagerHandle":U, "CustomizationManager":U).

        IF VALID-HANDLE(hManagerHandle) THEN
            ASSIGN pcResultCode   = DYNAMIC-FUNCTION("getSessionResultCodes":U IN hManagerHandle).
    END.    /* no result code passed in. */

    IF pcResultCode EQ ? OR pcResultCode EQ "":U THEN
        ASSIGN pcResultCode = "{&DEFAULT-RESULT-CODE}":U.

    /* If we are not in design mode, check whether the object is in the cache. If it is then 
     * we simply return. The buffer handle will be returned elsewhere.                       */
    IF NOT plDesignMode                               AND
       DYNAMIC-FUNCTION("isObjectCached":U,
                        INPUT pcLogicalObjectName,
                        INPUT dCurrentUserObj,
                        INPUT pcResultCode,
                        INPUT pcRunAttribute,
                        INPUT dCurrentLanguageObj,
                        INPUT plDesignMode          ) THEN
        RETURN TRUE.
    /* In design mode we must make sure that the cache is clean, so that we are
     * guaranteed of getting a "fresh" object from the Repository.              */
    ELSE
    IF plDesignMode THEN
        RUN clearClientCache.

    /* If we are running without an AppServer running, or
     * we are running with databases connected, then we go straight
     * to the Database.                                           */
    IF DYNAMIC-FUNCTION("isConnected":U, INPUT "ICFDB":U) THEN
        RUN ry/app/ryretrobjp.p ( INPUT  pcLogicalObjectName,
                                  INPUT  dCurrentUserObj,
                                  INPUT  pcResultCode,
                                  INPUT  dCurrentLanguageObj,
                                  INPUT  pcRunAttribute,
                                  INPUT  plDesignMode         ) NO-ERROR.
    ELSE
        /* We need to go across the AppServer.
         * doServerRetrieval performs the retrieval of the object from the Repository, and
         * adds the returned objects to the cache. The procedure is PRIVATE and should only
         * be called from this function.
         *
         * This code has been moved into an internal procedure to (a) avoid exceeding the action segment
         * and (b) avoid exceeding the section editor limitations.                                      */
        RUN doServerRetrieval ( INPUT  pcLogicalObjectName,
                                INPUT  dCurrentUserObj,
                                INPUT  pcResultCode,
                                INPUT  dCurrentLanguageObj,
                                INPUT  pcRunAttribute,
                                INPUT  plDesignMode         ) NO-ERROR.
    /* This error check takes care of both DB~ and non-DB connected calls. */
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN FALSE.    

    /* We always find the record again, since this will ensure that 
     * if we run getCacheObjectBuffer() immediately after, we will
     * have an available record.                                  */
    DYNAMIC-FUNCTION("isObjectCached":U,
                     INPUT pcLogicalObjectName,
                     INPUT dCurrentUserObj,
                     INPUT pcResultCode,
                     INPUT pcRunAttribute,
                     INPUT dCurrentLanguageObj,
                     INPUT plDesignMode   ).

    RETURN TRUE.    /* Any errors will cause a RETURN FALSE */
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
  Purpose:  Returns whether or not the specified attribute or event exists for 
            a class.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lAttributeExists            AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE hClassBuffer                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hAttributeField             AS HANDLE               NO-UNDO.

    /* This will ensure that the class is cached, if it has not been cached already. */
    ASSIGN hClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U, INPUT pcClassName).

    ASSIGN lAttributeExists = hClassBuffer:AVAILABLE.

    IF lAttributeExists THEN
    DO:
        IF plAttributeIsEvent THEN
        DO:
            ASSIGN hAttributeBuffer = DYNAMIC-FUNCTION("getCacheUIEventBuffer":U).
            hAttributeBuffer:FIND-FIRST(" WHERE ":U
                                    + hAttributeBuffer:NAME + ".tClassName = ":U + QUOTER(pcClassName)     + " AND ":U
                                    + hAttributeBuffer:NAME + ".tEventName = ":U + QUOTER(pcAttributeName) + " AND ":U
                                    + hAttributeBuffer:NAME + ".tRecordIdentifier = 0 ":U) NO-ERROR.
            ASSIGN lAttributeExists = hAttributeBuffer:AVAILABLE.
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
           hClassBuffer     = ?
           .
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
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lClassIsA               AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE hClassBuffer            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cInheritsFrom           AS CHARACTER                NO-UNDO.

    ASSIGN hClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U, INPUT pcClassName).

    IF hClassBuffer:AVAILABLE THEN
        ASSIGN cInheritsFrom = hClassBuffer:BUFFER-FIELD("InheritsFromClasses":U):BUFFER-VALUE
               lClassIsA     = CAN-DO(cInheritsFrom, pcInheritsFromClass)
               .
    ELSE
        ASSIGN lClassIsA = NO.

    RETURN lClassIsA.
END FUNCTION.   /* ClassIsA */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAllObjectSuperProcedures) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAllObjectSuperProcedures Procedure 
FUNCTION getAllObjectSuperProcedures RETURNS CHARACTER
    ( INPUT pcObjectName        AS CHARACTER,
      INPUT pcRunAttribute      AS CHARACTER    ):        
/*------------------------------------------------------------------------------
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

    RUN getObjectSuperProcedure ( INPUT  pcObjectName,
                                  INPUT  "":U,
                                  OUTPUT cCustomSuperProcedure ) NO-ERROR.

    SUPER-PROCEDURE-LOOP:
    DO WHILE cCustomSuperProcedure NE "":U:
        ASSIGN cAllSuperProcedures = cAllSuperProcedures + cCustomSuperProcedure + ",":U
               pcObjectName        = cCustomSuperProcedure
               .    
        /* Get the next one */
        RUN getObjectSuperProcedure ( INPUT  pcObjectName,
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

&IF DEFINED(EXCLUDE-getCacheLinkBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCacheLinkBuffer Procedure 
FUNCTION getCacheLinkBuffer RETURNS HANDLE
    ( /* No Parameters */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the buffer handle of the table used to cache Repository 
            Object Links.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBuffer                 AS HANDLE                   NO-UNDO.

    ASSIGN hBuffer = BUFFER cache_ObjectLink:HANDLE.

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
  Purpose:  Returns the buffer handle of the table used to cache Repository 
            Objects.
    Notes:  * This function will attempt to find the record specified by the
              pcInstanceID. 
            * This pcInstanceID corresponds to the tRecordIdentifier which is 
              unique for each cache_Object record.
            * If a null (?) is passed in, the find is ignored.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBuffer                 AS HANDLE                   NO-UNDO.

    ASSIGN hBuffer = BUFFER cache_Object:HANDLE.

    /* If a valid ID is passed in, then we attempt to find the related record. */
    IF pdInstanceId NE ? AND pdInstanceId NE 0 THEN
        FIND FIRST cache_Object WHERE
                   cache_Object.tRecordIdentifier = pdInstanceID
                   NO-ERROR.
    
    RETURN hBuffer.
END FUNCTION.   /* getCacheLinkBuffer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCachePageBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCachePageBuffer Procedure 
FUNCTION getCachePageBuffer RETURNS HANDLE
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the buffer handle of the table used to cache Repository 
            object pages.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBuffer                 AS HANDLE                   NO-UNDO.

    ASSIGN hBuffer = BUFFER cache_ObjectPage:HANDLE.

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
  Purpose:  Returns the buffer handle of the table used to cache Repository 
            object page instances.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBuffer                 AS HANDLE                   NO-UNDO.

    /* This is left as an indicator of what the old behaviour was. This buffer is no 
     * populated by the Repository retrieval process, and so is being phased out.
    ASSIGN hBuffer = BUFFER cache_ObjectPageInstance:HANDLE.
    */
    ASSIGN hBuffer = ?.

    RETURN hBuffer.
END FUNCTION.   /* getCachePageInstanceBuffer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCacheUiEventBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCacheUiEventBuffer Procedure 
FUNCTION getCacheUiEventBuffer RETURNS HANDLE
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the buffer handle of the table used to cache Repository 
            object UI events.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBuffer                 AS HANDLE                   NO-UNDO.

    ASSIGN hBuffer = BUFFER cache_ObjectUiEvent:HANDLE.

    RETURN hBuffer.
END FUNCTION.   /* getCacheUiEventBuffer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClassChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getClassChildren Procedure 
FUNCTION getClassChildren RETURNS CHARACTER
    ( INPUT pcClassName     AS CHARACTER ) :
/*------------------------------------------------------------------------------
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
                            + DYNAMIC-FUNCTION("getClassChildrenFromDB":U, gsc_object_type.object_type_code).
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

&IF DEFINED(EXCLUDE-getClassParentsFromDB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getClassParentsFromDB Procedure 
FUNCTION getClassParentsFromDB RETURNS CHARACTER
    (pcClasses AS CHARACTER) :
  /*------------------------------------------------------------------------------
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
    DEFINE VARIABLE cClassList        AS CHARACTER  NO-UNDO.

    &IF DEFINED(server-side) = 0 &THEN
    {
     dynlaunch.i &PLIP              = 'RepositoryManager'
                 &IProc             = 'getClassParentsProc'
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
              dObjectTypeObj    = gsc_object_type.extends_object_type_obj.

          /* Find the parent class of the current class */
          FOR EACH gsc_object_type NO-LOCK
             WHERE gsc_object_type.object_type_obj = dObjectTypeObj
                BY gsc_object_type.object_type_code:

            /* For every class, see if there is a parent class above it, by recursively calling this function */
            cCurrentClassList = cCurrentClassList + ",":U
                              + DYNAMIC-FUNCTION("getClassParentsFromDB":U, gsc_object_type.object_type_code).
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

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
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

&IF DEFINED(EXCLUDE-getNextQueryOrdinal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNextQueryOrdinal Procedure 
FUNCTION getNextQueryOrdinal RETURNS INTEGER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
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
    ( INPUT pcObjectName        AS CHARACTER,
      INPUT pcObjectPath        AS CHARACTER,
      INPUT pcObjectExtension   AS CHARACTER,
      INPUT plStaticObject     AS LOGICAL,
      INPUT pdPhysicalObjectObj AS DECIMAL          ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a pathed physical file name for a given object.
    Notes:  * this function will return a file which can be run, as long as
              as it exists on disk.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cPathedObjectName           AS CHARACTER            NO-UNDO.

    &IF DEFINED(Server-Side) NE 0 &THEN
    DEFINE BUFFER ryc_smartObject       FOR ryc_smartObject.
    DEFINE BUFFER rycso_physical        FOR ryc_smartObject.

    IF NOT plStaticObject THEN
    DO:
        FIND FIRST rycso_physical WHERE
                   rycso_physical.smartObject_obj = pdPhysicalObjectObj
                   NO-LOCK NO-ERROR.
        IF AVAILABLE rycso_physical THEN
            ASSIGN cPathedObjectName = RIGHT-TRIM(rycso_physical.Object_Path, "/~\":U)
                                     + ( IF rycso_physical.Object_Path EQ "":U THEN "":U ELSE "/":U )
                                     + rycso_physical.Object_Filename
                                     + (IF rycso_physical.Object_Extension <> "":U THEN
                                            ".":U + rycso_physical.Object_Extension
                                        ELSE
                                            "":U ).
    END.    /* Logical Object */
    ELSE
        ASSIGN cPathedObjectName = RIGHT-TRIM(pcObjectPath, "/~\":U)
                                 + ( IF pcObjectPath EQ "":U THEN "":U ELSE "/":U )
                                 + pcObjectName
                                 + (IF pcObjectExtension <> "":U THEN 
                                        ".":U + pcObjectExtension
                                    ELSE
                                        "":U ).

    &ENDIF
    
    RETURN cPathedObjectName.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDOincludeFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDOincludeFile Procedure 
FUNCTION getSDOincludeFile RETURNS CHARACTER
    (   INPUT pcIncludeFile       AS CHARACTER ) :   /* Include file without relative path */
  /*------------------------------------------------------------------------------
    Purpose:  Returns a pathed physical file name given a nonpathed SDO include
              filename.
      Notes:  
  ------------------------------------------------------------------------------*/
      DEFINE VARIABLE cPathedIncludeName           AS CHARACTER            NO-UNDO.

      &IF DEFINED(Server-Side) NE 0 &THEN
      DEFINE BUFFER ryc_smartObject       FOR ryc_smartObject.

      FIND ryc_smartobject WHERE ryc_smartobject.object_filename = ENTRY(1, pcIncludeFile, ".":U)
           NO-LOCK NO-ERROR.
      IF AVAILABLE ryc_smartobject THEN
        cPathedIncludeName = ryc_smartobject.object_path + "~/":U + pcIncludeFile.

      &ENDIF

      RETURN cPathedIncludeName.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWhereConstantLevel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWhereConstantLevel Procedure 
FUNCTION getWhereConstantLevel RETURNS CHARACTER
    ( INPUT phAttributeBuffer       AS HANDLE,
      INPUT phAttributeField        AS HANDLE  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a readable indication of where a n attribute is Constant.
    Notes:  * Preprocessors which resolve the Constant-AT values into the values
              Constant in the field are in { ry/inc/ryattstori.i }
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iWhereConstant                AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cWhereConstant                AS CHARACTER            NO-UNDO.

    IF VALID-HANDLE(phAttributeBuffer) AND VALID-HANDLE(phAttributeField) AND
       phAttributeBuffer:AVAILABLE                                        AND
       phAttributeField:BUFFER-HANDLE EQ phAttributeBuffer                THEN
        ASSIGN iWhereConstant = INTEGER(ENTRY(phAttributeField:POSITION - 1, phAttributeBuffer:BUFFER-FIELD("tWhereConstant":U):BUFFER-VALUE))
               NO-ERROR.

    IF iWhereConstant GT {&STORED-AT-CUSTOMIZATION} THEN
        ASSIGN iWhereConstant = iWhereConstant - {&STORED-AT-CUSTOMIZATION}.

    CASE iWhereConstant:
        WHEN 0                                        THEN ASSIGN cWhereConstant = "NONE":U.
        WHEN {&STORED-AT-CLASS}                       THEN ASSIGN cWhereConstant = "CLASS":U.
        WHEN {&STORED-AT-CLASS} + {&STORED-AT-MASTER} THEN ASSIGN cWhereConstant = "MASTER":U.
        OTHERWISE                                          ASSIGN cWhereConstant = "INSTANCE":U.
    END CASE.   /* iWhereConstant */

    RETURN cWhereConstant.
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
  Purpose:  Returns a readable indication of where a n attribute is stored.
    Notes:  * Preprocessors which resolve the STORED-AT values into the values
              stored in the field are in { ry/inc/ryattstori.i }
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iWhereStored                AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cWhereStored                AS CHARACTER            NO-UNDO.

    IF VALID-HANDLE(phAttributeBuffer) AND VALID-HANDLE(phAttributeField) AND
       phAttributeBuffer:AVAILABLE                                        AND
       phAttributeField:BUFFER-HANDLE EQ phAttributeBuffer                THEN
        ASSIGN iWhereStored = INTEGER(ENTRY(phAttributeField:POSITION - 1, phAttributeBuffer:BUFFER-FIELD("tWhereStored":U):BUFFER-VALUE))
               NO-ERROR.

    IF iWhereStored GT {&STORED-AT-CUSTOMIZATION} THEN
        ASSIGN iWhereStored = iWhereStored - {&STORED-AT-CUSTOMIZATION}.

    /* Default to INSTANCE. */
    CASE iWhereStored:
        WHEN {&STORED-AT-CLASS}                       THEN ASSIGN cWhereStored = "CLASS":U.
        WHEN {&STORED-AT-CLASS} + {&STORED-AT-MASTER} THEN ASSIGN cWhereStored = "MASTER":U.
        OTHERWISE                                          ASSIGN cWhereStored = "INSTANCE":U.
    END CASE.   /* iWhereStored */

    RETURN cWhereStored.
END FUNCTION.   /* getWhereStoredLevel */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-IsA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION IsA Procedure 
FUNCTION IsA RETURNS LOGICAL
    ( INPUT pcObjectName        AS CHARACTER,
      INPUT pcClassName         AS CHARACTER    ) :
/*------------------------------------------------------------------------------
  Purpose:  Determines whether a class inherits from a particular class.
    Notes:  * This is based on the class name.
            * All objects of a particular name (regardless of customisation, or
              whether they are master objects or instances) inherit from the same
              class(es).
            * The null value is returned if the obejct cannot be found in the cache.
              This is because the decision as to whether the object belongs to a 
              class cannot be made or even guessed at unless the obejct is in the cache.
------------------------------------------------------------------------------*/
    DEFINE BUFFER isA_Object        FOR cache_Object.

    FIND FIRST isA_Object WHERE
               isA_Object.tLogicalObjectName = pcObjectName
               NO-ERROR.
    IF AVAILABLE isA_Object THEN
        RETURN CAN-DO(isA_Object.tInheritsFromClasses, pcClassName).    
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
  Purpose:  This function indicates whether an object is in cache, or not.  It is
            used mainly where the cache is going to be supplemented from an external
            procedure.
    Notes:  * This function call also has the effect of making the cache_Object buffer
              available. This effect/consequence is important and is used by other APIs.
              These FINDs should stay as FINDs and should not ever be made into
              CAN-FINDS().
------------------------------------------------------------------------------*/

    FIND FIRST cache_Object WHERE
               cache_Object.tLogicalObjectName = pcLogicalObjectName AND
               cache_Object.tUserObj           = pdUserObj           AND
               cache_Object.tResultCode        = pcResultCode        AND
               cache_Object.tRunAttribute      = pcRunAttribute      AND
               cache_Object.tLanguageObj       = pdLanguageObj       AND
               cache_Object.tObjectInstanceObj = 0
               NO-ERROR.
    /* If this object is not available, then it might be a static object.
     * In this case, it is possible for the object to be cached already, but
     * or without the extension, depending on the way that the object was
     * requested. If it was requested as OBJ.W then the logical object name
     * in the cache will be OBJ.W. When this object is requested as OBJ we 
     * need to ensure that the correct object is returned, since OBJ.W and OBJ
     * are the same object in the Repository.                                 */
    IF NOT AVAILABLE cache_Object THEN
        /* First try to strip off an extension. */
        FIND FIRST cache_Object WHERE
                   cache_Object.tLogicalObjectName = ENTRY(1, pcLogicalObjectName, ".":U) AND
                   cache_Object.tUserObj           = pdUserObj                            AND
                   cache_Object.tResultCode        = pcResultCode                         AND
                   cache_Object.tRunAttribute      = pcRunAttribute                       AND
                   cache_Object.tLanguageObj       = pdLanguageObj                        AND
                   cache_Object.tObjectInstanceObj = 0
                   NO-ERROR.

    IF NOT AVAILABLE cache_Object THEN
        /* Then try to add .W as a default extension. */
        FIND FIRST cache_Object WHERE
                   cache_Object.tLogicalObjectName = pcLogicalObjectName + ".w":U AND
                   cache_Object.tUserObj           = pdUserObj                    AND
                   cache_Object.tResultCode        = pcResultCode                 AND
                   cache_Object.tRunAttribute      = pcRunAttribute               AND
                   cache_Object.tLanguageObj       = pdLanguageObj                AND
                   cache_Object.tObjectInstanceObj = 0
                   NO-ERROR.

    IF NOT AVAILABLE cache_Object THEN
        /* And then finally in desperation try to add .P as an extension. */
        FIND FIRST cache_Object WHERE
                   cache_Object.tLogicalObjectName = pcLogicalObjectName + ".p":U AND
                   cache_Object.tUserObj           = pdUserObj                    AND
                   cache_Object.tResultCode        = pcResultCode                 AND
                   cache_Object.tRunAttribute      = pcRunAttribute               AND
                   cache_Object.tLanguageObj       = pdLanguageObj                AND
                   cache_Object.tObjectInstanceObj = 0
                   NO-ERROR.

    IF plDesignMode THEN 
        RETURN FALSE.

    RETURN AVAILABLE cache_Object .
END FUNCTION.   /* isObjectCached */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchClassObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION launchClassObject Procedure 
FUNCTION launchClassObject RETURNS HANDLE
    ( INPUT pcClassName             AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the running class object procedure           
    Notes:  * the procedure is laucnehd, if necessary.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hClassObject                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hClassCacheBuffer           AS HANDLE               NO-UNDO.

    /* Even though the ttClass TT is local to the Repository Manager,
     * still use the API to retrieve the buffer handle.              */
    ASSIGN hClassCacheBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U, INPUT pcClassName ).

    /* Launch the class object procedure, if necessary. */
    IF hClassCacheBuffer:BUFFER-FIELD("classObjectName":U):BUFFER-VALUE GT "":U THEN
    DO:
        /* Use the launchProcedure API since this will allow us to launch the procedure once, and use it many times. */
        RUN launchProcedure IN gshSessionManager ( INPUT  hClassCacheBuffer:BUFFER-FIELD("classObjectName":U):BUFFER-VALUE, /* pcPhysicalName */
                                                   INPUT  YES,                              /* plOnceOnly */
                                                   INPUT  NO,                               /* pcOnAppserver (we should be on the A/S partition already) */
                                                   INPUT  "":U,                             /* pcAppserverPartition */
                                                   INPUT  YES,                              /* plRunPermanent */
                                                   OUTPUT hClassObject ) NO-ERROR.
    END.    /* has class object procedure. */
    ELSE
        ASSIGN hClassObject = ?.

    RETURN hClassObject.
END FUNCTION.   /* launchClassObject */

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
 DEFINE VARIABLE iField                 AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iLoop                  AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cEntityField           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDbFieldName           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iAttribute             AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cAttribute             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cReqAttributes         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cBufAttributes         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValue                 AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hField                 AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hClassBuffer           AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hClassAttributeBuffer  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cDataType              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValueList             AS CHARACTER  EXTENT 20 NO-UNDO.
 DEFINE VARIABLE cProperty              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDelimiter             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE xcAttributeMap         AS CHARACTER  NO-UNDO 
    INITIAL {&buffer-attribute-map} .
 
 /* Deal with col label inheriting from label when we do not know the order
    of the attributes (this is the quick version) */  
 DEFINE VARIABLE lIsColLabelSet         AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lIsColLabelUnknown     AS LOGICAL    NO-UNDO.
                                      
   &IF DEFINED(Server-Side) NE 0 &THEN
 RUN createClassCache IN gshRepositoryManager ('DataField,CalculatedField':U).
 
 IF NUM-ENTRIES(pcAttributes) > 20 THEN
 DO:
   MESSAGE
      "The maximum number of attribute entries passed to"  PROGRAM-NAME(1) "was exceeded." SKIP(1)
      "Maximum number attributes that can be handled is 20."  
    VIEW-AS ALERT-BOX INFORMATION. 
 END.                              
 
 /* Requested attributes is a combination of pcAttributes and pcBufferOptions */
 cReqAttributes = pcAttributes.
 /* add possible additional buffer attributes to end of loop list */
 IF VALID-HANDLE(phBuffer) THEN
 DO iLoop = 1 TO NUM-ENTRIES(xcAttributeMap) BY 2:
   cAttribute = ENTRY(iLoop,xcAttributeMap).
   IF LOOKUP(cAttribute,pcAttributes) = 0 
   AND (LOOKUP('ALL':U,pcBufferOptions) > 0 OR LOOKUP(cAttribute,pcBufferOptions) > 0) THEN
     ASSIGN
       cReqAttributes = cReqAttributes
                      + (IF cReqAttributes = '':U THEN '':U ELSE ',':U)
                      + ENTRY(iLoop + 1,xcAttributeMap)
       cBufAttributes = cBufAttributes 
                      + (IF cBufAttributes = '':U THEN '':U ELSE ',':U)
                      + cAttribute. 
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
     FIND ryc_smartobject WHERE ryc_smartobject.object_filename = cDbFieldname        
     NO-LOCK NO-ERROR.
   ELSE
     FIND ryc_smartobject WHERE ryc_smartobject.object_filename = cEntityField        
     NO-LOCK NO-ERROR.
   IF AVAIL ryc_smartobject THEN 
   DO:   
     FIND gsc_object_type 
          WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj
     NO-LOCK.
     DO iAttribute = 1 TO NUM-ENTRIES(cReqAttributes):
       ASSIGN
         cAttribute = ENTRY(iAttribute,cReqAttributes)
         cValue     = '':U.
       
       FIND ryc_attribute 
            WHERE ryc_attribute.attribute_label     = cAttribute 
       NO-LOCK NO-ERROR.
       
       IF AVAIL ryc_attribute THEN
       DO:
         FIND ryc_attribute_value 
              WHERE ryc_attribute_value.object_type_obj     = ryc_smartobject.object_type_obj
              AND   ryc_attribute_value.smartobject_obj     = ryc_smartobject.Smartobject_obj
              AND   ryc_attribute_value.object_instance_obj = 0          
              AND   ryc_attribute_value.attribute_label     = cAttribute 
              AND   ryc_attribute_value.container_smartobject_obj = 0
         NO-LOCK NO-ERROR.
         
         IF AVAIL ryc_attribute_value THEN
         DO:
           CASE ryc_attribute.data_type:
             WHEN {&CHARACTER-DATA-TYPE} THEN cValue  = ryc_attribute_value.character_value.
             WHEN {&LOGICAL-DATA-TYPE}   THEN cValue  = STRING(ryc_attribute_value.logical_value).
             WHEN {&INTEGER-DATA-TYPE}   THEN cValue  = STRING(ryc_attribute_value.integer_value).
             WHEN {&DECIMAL-DATA-TYPE}   THEN cValue  = STRING(ryc_attribute_value.decimal_value).
             WHEN {&ROWID-DATA-TYPE}     THEN cValue  = ryc_attribute_value.character_value.
             WHEN {&DATE-DATA-TYPE}      THEN cValue  = STRING(ryc_attribute_value.date_value).
             WHEN {&RECID-DATA-TYPE}     THEN cValue  = STRING(ryc_attribute_value.integer_value).               
               /*
             WHEN {&RAW-DATA-TYPE}       THEN ryc_attribute_value.raw_value. 
             WHEN {&HANDLE-DATA-TYPE}    THEN 
               */
                                 
           END CASE.
         END. /* avail ryc_attribute_value */
         ELSE DO: /* no attributevalue*/
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
               /* we may need to use the data-type attribute for other objects
                  than SDOs
                
               FIND ryc_attribute_value 
               WHERE ryc_attribute_value.object_type_obj     = ryc_smartobject.object_type_obj
               AND   ryc_attribute_value.smartobject_obj     = ryc_smartobject.Smartobject_obj
               AND   ryc_attribute_value.object_instance_obj = 0          
               AND   ryc_attribute_value.attribute_label     = cAttribute 
               AND   ryc_attribute_value.container_smartobject_obj = 0
               NO-LOCK NO-ERROR.
               */
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
             OTHERWISE /* get the default value from the class */
               ASSIGN
                hClassBuffer = DYNAMIC-FUNC("getCacheClassBuffer":U IN gshRepositoryManager,
                                            gsc_object_type.OBJECT_type_code)
                hClassAttributeBuffer = hClassBuffer:BUFFER-FIELD('ClassBufferHandle':U):BUFFER-VALUE
                cValue                = hClassAttributeBuffer:BUFFER-FIELD(cAttribute):INITIAL .
           END CASE.
         END. 
       END.
       IF VALID-HANDLE(hField) THEN
       DO:
         IF LOOKUP('ALL':U,pcBufferOptions) > 0 OR LOOKUP(cAttribute,cBufAttributes) > 0 THEN
         DO:
           CASE cAttribute:
             /*  NOT Updatable
             WHEN "DefaultValue":U THEN
               hField:INITIAL = cValue. 
             */  
             WHEN "Label":U THEN
             DO:
               hField:LABEL = IF cValue = ? THEN cEntityField ELSE cValue.
               /* We cannot set it to unknown, so we have to fdeal with 
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
         END.
       END.
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
   cProperty = ENTRY(iAttribute,pcPropertyLists).
   DYNAMIC-FUNCTION('set':U + cProperty IN phObject,cValueList[iAttribute]).
 END.
 
 RETURN TRUE.

 &ENDIF
 
 RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareInstance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareInstance Procedure 
FUNCTION prepareInstance RETURNS LOGICAL
    ( INPUT phADMProps              AS HANDLE, 
      INPUT phInstance              AS HANDLE, 
      INPUT phSource                AS HANDLE  ) :
/*------------------------------------------------------------------------------
   Purpose: Prepare an instance by defining and preparing its property table
            and set its buffer as the first entry in ADM-DATA.
Parameters: phPropTable - The admprops table UNPRPEPARED.                            
            phInstance  - The handle of the instance being instanciated. 
            phSource    - source-procedure; containr.p that constructs
                          this instance or the manager that launches it.              
     Notes: This is called as early as possible from the main block of a running
            instance before it knows anything .. it calls this with its own 
            handle and the source-procedure as the caller. The calling 
            source-procedure is then checked for information about the callee.      
            * This is called from the Main Block of SMRTPROP.I 
------------------------------------------------------------------------------*/  
    DEFINE VARIABLE cLogicalObjectName          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hCaller                     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hObjectBuffer               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hClassBuffer                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hRawField                   AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hBuffer                     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hADMPropsBuffer             AS HANDLE               NO-UNDO.
    DEFINE VARIABLE dInstanceId                 AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE lGotIt                      AS LOGICAL              NO-UNDO.
    
    ASSIGN hCaller = DYNAMIC-FUNCTION("getTargetProcedure":U IN phSource) NO-ERROR.
    IF NOT VALID-HANDLE(hCaller) THEN
        ASSIGN hCaller = phSource.

    /** Get the object from the Repository Cache and reposition to that record.
     *  ----------------------------------------------------------------------- **/
    /* The session manager sets this before the launch (launchContainer) 
     * The dynamic container sets it to InstanceId=<instanceID>                  */
    ASSIGN cLogicalObjectName = DYNAMIC-FUNCTION("getCurrentLogicalName":U IN hCaller) NO-ERROR.

    /* If there is no data from a call back we use the prop file */       
    IF cLogicalObjectName EQ ? OR cLogicalObjectName EQ "":U THEN
      RETURN TRUE. 
    
    /* We always try to get the object from the cache, except when
     * (a) the logical object name is blank, or
     * (b) the logical name is InstanceId=*                         */
    IF NOT CAN-DO("InstanceId=*,":U, cLogicalObjectName) THEN
        ASSIGN lGotIt = DYNAMIC-FUNCTION("cacheObjectOnClient":U,
                                         INPUT cLogicalObjectName,
                                         INPUT ?,
                                         INPUT ?,
                                         INPUT NO                ).
    ELSE
        ASSIGN lGotIt = YES.

    /* Could not find the object in the Repository or cache. Return an error condition. */
    IF NOT lGotIt THEN
    DO:
        MESSAGE
            "Failed to retrieve repository object data:" SKIP
            "  Logical Name  = " cLogicalObjectName      SKIP
            "  Physical Name = " phInstance:FILE-NAME    SKIP
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.

        DELETE OBJECT phADMProps NO-ERROR.
        ASSIGN phAdmProps = ?.

        RETURN FALSE.
    END.    /* could not get object from Repository cache */
    
    /* If this is an instance being launched, we use the instanceID of the instance
     * being launched to find the correct property buffers.                        */
    IF cLogicalObjectName BEGINS "InstanceId=":U THEN
        ASSIGN dInstanceId = DECIMAL(ENTRY(1, ENTRY(2, cLogicalObjectName, "=":U), CHR(1))) NO-ERROR.
    ELSE
        ASSIGN dInstanceId = ?.

    /* Get the buffer of the cached object. */
    ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U, INPUT dInstanceId)
           hRawField     = ?
           .
    /* The cache may have been cleared between the retrieval of the container information,
     * which includes it's instances, and when the instance is actually launched. If this is
     * the case, then we nbeed to retrieve the master object for the instance being launched
     * from the Repository, so that we at least can launch the object. 
     *
     * The container needs to be cognisant of the fact that this may happen, and so it needs to be
     * able to set the correct INSTANCE attributes
     */
    IF NOT hObjectBuffer:AVAILABLE AND cLogicalObjectName BEGINS "InstanceId=":U THEN
    DO:
        DYNAMIC-FUNCTION("cacheObjectOnClient":U, INPUT ENTRY(2, ENTRY(2, cLogicalObjectName, "=":U), CHR(1)),
                         INPUT ?, INPUT ?, INPUT NO                ).

        ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U, INPUT ?)
               hBuffer       = DYNAMIC-FUNCTION("getRawAttributeValues":U IN hCaller, INPUT dInstanceId)
               hRawField     = hBuffer:BUFFER-FIELD("tRawAttributes":U)
               NO-ERROR.
    END.    /* the cache may have been cleared. */

    IF VALID-HANDLE(hObjectBuffer) AND hObjectBuffer:AVAILABLE THEN
    DO:
        ASSIGN hClassBuffer = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
               dInstanceId  = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
               .
        hClassBuffer:FIND-FIRST("WHERE " + hClassBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dInstanceId) ) NO-ERROR.

        IF NOT VALID-HANDLE(hClassBuffer) OR NOT hClassBuffer:AVAILABLE THEN 
        DO:
            MESSAGE
                "Attribute Buffer Retrieve Failure" SKIP
                "  Logical Object: " cLogicalObjectName SKIP
                "  Physical Name: " phInstance:FILE-NAME
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.

            DELETE OBJECT phADMProps NO-ERROR.
            ASSIGN phAdmProps = ?.
            RETURN FALSE.
        END.    /* could not find relevant attribute buffer */

        /** Populate and prepare the ADM Props Temp-table from the information returned
         *  from the Repository.
         *  ----------------------------------------------------------------------- **/
        phADMprops:CREATE-LIKE(hClassBuffer).
        phADMProps:TEMP-TABLE-PREPARE("ADMProps":U).

        hADMPropsBuffer = phADMProps:DEFAULT-BUFFER-HANDLE.
        hADMPropsBuffer:BUFFER-CREATE().

        hADMPropsBuffer:BUFFER-COPY(hClassBuffer). 

        IF VALID-HANDLE(hRawField) THEN
            hADMPropsBuffer:RAW-TRANSFER(FALSE, hRawField).

        /* This ADM object is now open for business! (well almost, need supers) 
         * The CHR(1) delimiters are for UserProperties and UserLinks.      */
        phInstance:ADM-DATA = STRING(hADMPropsBuffer) + CHR(1) + CHR(1).

        /* We want to use this ID for refetching the object buffer from the cache, as well
         * as being able to use it for joining to the various other cache_Object* buffers.
         * We have to assign this value directly, since smart.p has not yet been started. */
        ASSIGN hADMPropsBuffer:BUFFER-FIELD("instanceID":U):BUFFER-VALUE = dInstanceId NO-ERROR.

        RETURN TRUE.
    END.    /* cached object record was available */
    ELSE
    DO:
        MESSAGE
            "Failed to find cached object:"              SKIP
            "  Logical Name  = " cLogicalObjectName      SKIP
            "  Physical Name = " phInstance:FILE-NAME    SKIP
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.

        DELETE OBJECT phADMProps NO-ERROR.
        ASSIGN phAdmProps = ?.

        RETURN FALSE.
    END.    /* not available buffer */
    
    /* We should never get to this statement, but for safety's sake let's keep a RETURN statement here. */
    RETURN TRUE.
END FUNCTION.   /* prepareInstance */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

