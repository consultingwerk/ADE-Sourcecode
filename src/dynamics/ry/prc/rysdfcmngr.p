&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rysdfcmngr.p

  Description:  SmartDataField Cache Manager

  Purpose: To Cache data from any SmartDataField on the client to reduce the amount
           of AppServer hits

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   22/09/2003  Author:     Mark Davies (MIP)

  Update Notes: Created from examples supplied by Organi - Issue 4285

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rysdfcmngr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* object identifying preprocessor */
&glob   AstraPlip    yes
 
DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.
 
ASSIGN cObjectName = "{&object-name}":U.
 
&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}

{src/adm2/ttdcombo.i}
{src/adm2/ttlookup.i}

DEFINE VARIABLE gcWidgetNames     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcWidgetValues    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghViewer          AS HANDLE     NO-UNDO.

/* keeps the already retrieved values */
DEFINE TEMP-TABLE masterTTdCombo   LIKE ttDCombo.
  
DEFINE TEMP-TABLE masterTTLookup   LIKE ttLookup.

/* keeps the temporary result which will be obtained from the master */
DEFINE TEMP-TABLE resultTTdCombo   LIKE ttdCombo.

DEFINE TEMP-TABLE resultTTLookup   LIKE ttLookup.

{src/adm2/sdfcmnapis.i}

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
         HEIGHT             = 15.91
         WIDTH              = 62.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "RepositoryCacheCleared":U ANYWHERE.

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-checkComboCacheData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkComboCacheData Procedure 
PROCEDURE checkComboCacheData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will attempt to find any cached information for
               all combos for a particular viewer
  Parameters:  pcWidgetNames - The names of all the widgets on a viewer
               pcWidgetValues - The corresponding values of all widgets on a 
                                viewer as specified in pcWidgetNames
               phViewer - The handle of the current viewer
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcWidgetNames   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcWidgetValues  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phViewer        AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE iField                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSubs                   AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE cNewQuery               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.

  COMBO_LOOP:
  FOR EACH  ttDCombo 
      WHERE ttDCombo.hViewer = phViewer
      BY    ttDCombo.iBuildSequence
      BY    ttDCombo.hWidget:
  
    /* default to decimal if not set-up */
    IF ttDCombo.cWidgetType = "":U THEN
        ASSIGN ttDCombo.cWidgetType = "Decimal":U. 
  
    /* Default to comma delimiter */
    IF ttDCombo.cListItemDelimiter = "":U THEN
        ASSIGN ttDCombo.cListItemDelimiter = ",":U.  
    
    /* Check & reassign comma delimiter, check with euro format */
    IF SESSION:NUMERIC-DECIMAL-POINT = ",":U AND
         ttDCombo.cWidgetType = "Decimal":U AND
         ttDCombo.cListItemDelimiter = ",":U THEN
        ASSIGN ttDCombo.cListItemDelimiter = CHR(3).  
  
    /* rebuild parentFilterQuery */
    ASSIGN cNewQuery = ttDCombo.cForEach.
    IF  pcWidgetNames <> "":U 
    AND pcWidgetNames <> "ComboAutoRefresh":U THEN
    DO:
      IF ttDCombo.cParentField       <> "":U
      OR ttDCombo.cParentFilterQuery <> "":U THEN
      DO:
        RUN returnParentFieldValues IN TARGET-PROCEDURE
                                    (INPUT  ttDCombo.cParentField,
                                     INPUT  ttDCombo.cParentFilterQuery,
                                     INPUT  pcWidgetNames,
                                     INPUT  pcWidgetValues,
                                     OUTPUT cParentFilterQuery).
  
        IF  cParentFilterQuery <> "":U 
        AND cParentFilterQuery <> ? THEN 
        DO:
          cNewQuery = ttDCombo.cForEach.
          IF  NUM-ENTRIES(cParentFilterQuery,"|":U) > 1 
          AND NUM-ENTRIES(cBufferList) > 1 then 
          DO:
             DO iLoop = 1 TO NUM-ENTRIES(cParentFilterQuery,"|":U):
               IF TRIM(entry(iLoop,cParentFilterQuery,"|":U)) <> "":U THEN
                 cNewQuery = DYNAMIC-FUNCTION("newWhereClause",
                                              ENTRY(iLoop,cBufferList),
                                              ENTRY(iLoop,cParentFilterQuery,"|":U),
                                              cNewQuery,
                                              "AND":U).
             END. /* iLoop */
          END. 
          ELSE
            cNewQuery = DYNAMIC-FUNCTION("newWhereClause",
                                         ENTRY(1,cBufferList),
                                         cParentFilterQuery,
                                         cNewQuery,
                                         "AND":U).
        END. /* Parent Filter Query <> "" */ 
      END. /* Parent Fildter Fields <> "" */
    END. /* pcWidgetNames <> "" */
    
    /* Process any filter set phrases in the query string */
    IF VALID-HANDLE(gshGenManager) THEN
      RUN processQueryStringFilterSets IN gshGenManager (INPUT  cNewQuery,
                                                         OUTPUT cNewQuery).
  
    /* Check if we should be looking for cached data */
    IF ttDCombo.lUseCache = FALSE THEN
      NEXT COMBO_LOOP.
    
    /* Find if current combo-request is already cached in memory-tables */
    FIND FIRST masterTTDCombo 
         WHERE masterTTDCombo.cForEach                 EQ cNewQuery  /* use cForeach with parent filtering */
         AND   masterTTDCombo.cWidgetType              EQ ttDCombo.cWidgetType
         AND   masterTTDCombo.cBufferList              EQ ttDCombo.cBufferList
         AND   masterTTDCombo.cPhysicalTableNames      EQ ttDCombo.cPhysicalTableNames
         AND   masterTTDCombo.cTempTableNames          EQ ttDCombo.cTempTableNames
         AND   masterTTDCombo.cKeyFieldName            EQ ttDCombo.cKeyFieldName
         AND   masterTTDCombo.cKeyFormat               EQ ttDCombo.cKeyFormat
         AND   masterTTDCombo.cDescFieldNames          EQ ttDCombo.cDescFieldNames
         AND   masterTTDCombo.cDescSubstitute          EQ ttDCombo.cDescSubstitute
         AND   masterTTDCombo.cFlag                    EQ ttDCombo.cFlag
         AND   masterTTDCombo.cFlagValue               EQ ttDCombo.cFlagValue
         AND   masterTTDCombo.cListItemDelimiter       EQ ttDCombo.cListItemDelimiter
         AND   masterTTDCombo.cParentField             EQ ttDCombo.cParentField
         AND   masterTTDCombo.cParentFilterQuery       EQ ttDCombo.cParentFilterQuery
         NO-LOCK NO-ERROR.
    IF AVAILABLE masterTTDCombo THEN
    DO:
      /* We could find cached information */
      CREATE resultTTDCombo.
      BUFFER-COPY ttDCombo 
           EXCEPT ttDCombo.cListItemPairs    
                  ttDCombo.cDescriptionValues
                  ttDCombo.cKeyValues
               TO resultTTDCombo.
      
      /* append/override values of master to result TT */
      ASSIGN resultTTDCombo.cListItemPairs     = masterTTDCombo.cListItemPairs
             resultTTDCombo.cKeyValues         = masterTTDCombo.cKeyValues
             resultTTDCombo.cDescriptionValues = masterTTDCombo.cDescriptionValues.
      /* resolve the Current Description Value corresponding to the current Key Value */
      ASSIGN resultTTDCombo.cCurrentDescValue = ENTRY(LOOKUP(resultTTDCombo.cCurrentKeyValue,resultTTDCombo.cKeyValues,resultTTDCombo.cListItemDelimiter),resultTTDCombo.cDescriptionValues,resultTTDCombo.cListItemDelimiter) NO-ERROR.
  
      /* Change key, this record has to be here for next parent fields */
      ASSIGN ttDCombo.hViewer = TARGET-PROCEDURE.
    END. /* AVAILABLE masterTTDCombo */
  END. /* EACH  ttDCombo */

  /* Delete records which are kept for parent-filter purposes */
  FOR EACH ttDCombo 
      WHERE ttDCombo.hViewer = TARGET-PROCEDURE:
    DELETE ttDCombo.
  END.

  /* Delete combo request which are not for retrieved for this viewer */
  FOR EACH  ttDCombo 
      WHERE ttDCombo.hViewer <> phViewer:
     CREATE resultTTDCombo.
     RAW-TRANSFER ttDCombo 
               TO resultTTDCombo.
     DELETE ttDCombo.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkLookupCacheData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkLookupCacheData Procedure 
PROCEDURE checkLookupCacheData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will attempt to find any cached information for
               all lookups for a particular viewer
  Parameters:  pcWidgetNames - The names of all the widgets on a viewer
               pcWidgetValues - The corresponding values of all widgets on a 
                                viewer as specified in pcWidgetNames
               phViewer - The handle of the current viewer
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcWidgetNames  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcWidgetValues AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phViewer       AS HANDLE     NO-UNDO.

  /* Delete lookup request that should not be retrieved for this viewer */
  FOR EACH  ttLookup 
      WHERE ttLookup.hViewer <> phViewer 
      OR    ttLookup.lRefreshQuery = FALSE:
     CREATE resultttLookup.
     RAW-TRANSFER ttLookup 
               TO resultttLookup.
     DELETE ttLookup.
  END.

  /* Find if current Lookup-request is already cached in memory-tables */
  LOOKUP_LOOP:
  FOR EACH ttLookup:
    /* default to decimal if not set-up */
    IF ttLookup.cWidgetType = "":U THEN
      ASSIGN ttLookup.cWidgetType = "DECIMAL":U.     
   
    /* Process any filter set phrases in the query string */
    IF VALID-HANDLE(gshGenManager) THEN
      RUN processQueryStringFilterSets IN gshGenManager (INPUT  ttLookup.cForEach,
                                                         OUTPUT ttLookup.cForEach).
    /* Check if we should be looking for cached data */
    IF ttLookup.lUseCache = FALSE THEN
      NEXT LOOKUP_LOOP.

    /* Find if current combo-request is already cached in memory-tables */
    FIND FIRST masterTTLookup 
         WHERE masterTTLookup.cWidgetType         = ttLookup.cWidgetType
         AND   masterTTLookup.cForEach            = ttLookup.cForEach
         AND   masterTTLookup.cBufferList         = ttLookup.cBufferList
         AND   masterTTLookup.cPhysicalTableNames = ttLookup.cPhysicalTableNames
         AND   masterTTLookup.cTempTableNames     = ttLookup.cTempTableNames
         AND   masterTTLookup.cFieldList          = ttLookup.cFieldList  
         AND   masterTTLookup.cDataTypeList       = ttLookup.cDataTypeList
         NO-LOCK NO-ERROR.
    IF AVAILABLE masterTTLookup THEN
    DO:
      /* create new result record */
      CREATE resultTTLookup.
      BUFFER-COPY ttLookup 
           EXCEPT ttLookup.cFoundDataValues
                  ttLookup.cRowIdent
                  ttLookup.lMoreFound
                  ttLookup.lRefreshQuery    
               TO resultTTLookup.
      
      /* append/override values of master to result TT */
      ASSIGN resultTTLookup.cFoundDataValues = masterTTLookup.cFoundDataValues
             resultTTLookup.cRowIdent        = masterTTLookup.cRowIdent       
             resultTTLookup.lMoreFound       = masterTTLookup.lMoreFound     
             resultTTLookup.lRefreshQuery    = masterTTLookup.lRefreshQuery.
      DELETE ttLookup.
      RELEASE resultTTLookup.
    END. /* AVAILABLE masterTTLookup */
  END. /* EACH ttLookup */

  /* Delete records which are kept for parent-filter purposes */
  FOR EACH  ttLookup 
      WHERE ttLookup.hViewer = TARGET-PROCEDURE:
    DELETE ttLookup.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearCache Procedure 
PROCEDURE clearCache :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will clear the temp-tables that contains the 
               cached data for lookups and combos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE masterTTDCombo.
EMPTY TEMP-TABLE masterTTLookup.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAppServerData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAppServerData Procedure 
PROCEDURE getAppServerData :
/*------------------------------------------------------------------------------
  Purpose:     If no cached data could be found on the client then this procedure
               will run accross to the server to fetch the latest data.
  Parameters:  pcWidgetNames - The names of all the widgets on a viewer
               pcWidgetValues - The corresponding values of all widgets on a 
                                viewer as specified in pcWidgetNames
               phViewer - The handle of the current viewer
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcWidgetNames  AS CHARACTER.
  DEFINE INPUT PARAMETER pcWidgetValues AS CHARACTER.
  DEFINE INPUT PARAMETER phViewer       AS HANDLE.
   
  IF VALID-HANDLE(gshAstraAppserver)  
  AND (CAN-FIND(FIRST ttLookup 
                WHERE ttLookup.hViewer = phViewer 
                  AND ttLookup.lRefreshQuery = TRUE) OR
       CAN-FIND(FIRST ttDCombo  
                WHERE ttDCombo.hViewer = phViewer)) THEN
  DO:
    /* Original AppServer new (Retrieve new which were not cached yet */
    RUN adm2/lookupqp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttLookup,
                                              INPUT-OUTPUT TABLE ttDCombo,
                                              INPUT pcWidgetNames,
                                              INPUT pcWidgetValues,
                                              INPUT phViewer).
  END. /* Valid handle for AppServer */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{ry/app/ryplipkill.i}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  {ry/app/ryplipsetu.i}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  {ry/app/ryplipshut.i}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-RepositoryCacheCleared) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RepositoryCacheCleared Procedure 
PROCEDURE RepositoryCacheCleared :
/*------------------------------------------------------------------------------
  Purpose:     This event is published from the repository manager when the
               client cache was cleared and should in turn cleat the SDF's
               client cache.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN clearCache IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveSDFCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveSDFCache Procedure 
PROCEDURE retrieveSDFCache :
/*------------------------------------------------------------------------------
  Purpose: Cache new from default dynamics framework into temp-tables
  Parameters:  localttLookup (temp-table) (paramaters from all lookups)
               localttDCombo (temp-table) (parameters from all combos)
               cWidgetname   (Naam van current field where combo is placed on)
               cWidgetValue  (Values of cWidgetName)
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttLookup.
  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttDCombo.
  
  DEFINE INPUT PARAMETER pcWidgetNames      AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcWidgetValues     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phViewer           AS HANDLE     NO-UNDO.

  /* Assign global values */
  ASSIGN gcWidgetNames  = pcWidgetNames
         gcWidgetValues = pcWidgetValues
         ghViewer       = phViewer. 

  /* clear work files to store records which are also in master table. */
  EMPTY TEMP-TABLE resultTTDCombo.
  EMPTY TEMP-TABLE resultTTLookup.

  /* check which record is in master */
  RUN checkComboCacheData IN TARGET-PROCEDURE
                         (INPUT pcWidgetNames,
                          INPUT pcWidgetValues,
                          INPUT phViewer).   
  RUN checkLookupCacheData IN TARGET-PROCEDURE
                          (INPUT pcWidgetNames,
                           INPUT pcWidgetValues,
                           INPUT phViewer).   

  /* Retrieve info from AppServer */
  RUN getAppServerData IN TARGET-PROCEDURE
                      (INPUT pcWidgetNames,
                       INPUT pcWidgetValues,
                       INPUT phViewer).

  /* Append retrieved data to Master tables */
  RUN updateMasterTTDCombo IN TARGET-PROCEDURE.
  RUN updateMasterTTLookup IN TARGET-PROCEDURE.

  /* prepare temp-table to return the obtained values from master */
  FOR EACH resultTTDCombo:
    CREATE ttDCombo.
    RAW-TRANSFER resultTTDCombo TO ttDCombo.
  END.

  FOR EACH resultTTLookup:
    CREATE ttLookup.
    RAW-TRANSFER resultTTLookup TO ttLookup.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-returnParentFieldValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnParentFieldValues Procedure 
PROCEDURE returnParentFieldValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcParentField       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcParentFilterQuery AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER ipcWidgetNames      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER ipcWidgetValues     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcNewQuery          AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ifield            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSubs             AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE cSDFFieldName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDFHandle        AS HANDLE     NO-UNDO.

  DEFINE BUFFER b_ttDCombo FOR ttDCombo.

  DO iLoop = 1 TO NUM-ENTRIES(ipcWidgetNames,CHR(3)):
    ASSIGN ifield = LOOKUP(ENTRY(iLoop,ipcWidgetNames,CHR(3)), pcParentField)
           cField = ENTRY(ifield,pcParentField)
           NO-ERROR.
    /* Check if the combo depends on anothed combo - 
       in some instances were a new record is being
       added - the parent combo's field value will
       be blank - in cases like this, we need to 
       make the value that of the first entry in
       the combo's list-items */
    IF CAN-FIND(FIRST b_ttDCombo
                WHERE b_ttDCombo.cWidgetName = cField) THEN do:
      FIND FIRST b_ttDCombo
           WHERE b_ttDCombo.cWidgetName = cField
           NO-LOCK no-error.
      IF b_ttDCombo.cCurrentKeyValue <> "":U THEN
        cValue = b_ttDCombo.cCurrentKeyValue.
      ELSE
        cValue = ENTRY(1,b_ttDCombo.cKeyValues,CHR(1)).
      IF ifield > 0 AND ifield <= 9 THEN
        assign cSubs[ifield] = TRIM(cValue).
    END.
    ELSE do:
      IF ifield > 0 AND ifield <= 9 THEN
        ASSIGN cValue        = ENTRY(iLoop,ipcWidgetValues,CHR(3))
               cSubs[ifield] = TRIM(cValue).
    END.
  END.
  pcNewQuery = SUBSTITUTE(pcParentFilterQuery,cSubs[1],cSubs[2],cSubs[3],cSubs[4],cSubs[5],cSubs[6],cSubs[7],cSubs[8],cSubs[9]).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateMasterTTDCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateMasterTTDCombo Procedure 
PROCEDURE updateMasterTTDCombo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH ttDCombo:
    /* Check if new is already in Master */
    FIND FIRST masterTTDCombo 
         WHERE masterTTDCombo.cWidgetType         = ttDCombo.cWidgetType
         AND   masterTTDCombo.cForEach            = ttDCombo.cForEach
         AND   masterTTDCombo.cBufferList         = ttDCombo.cBufferList
         AND   masterTTDCombo.cPhysicalTableNames = ttDCombo.cPhysicalTableNames 
         AND   masterTTDCombo.cTempTableNames     = ttDCombo.cTempTableNames 
         AND   masterTTDCombo.cKeyFieldName       = ttDCombo.cKeyFieldName
         AND   masterTTDCombo.cKeyFormat          = ttDCombo.cKeyFormat
         AND   masterTTDCombo.cDescFieldNames     = ttDCombo.cDescFieldNames
         AND   masterTTDCombo.cDescSubstitute     = ttDCombo.cDescSubstitute
         AND   masterTTDCombo.cCurrentKeyValue    = ttDCombo.cCurrentKeyValue
         AND   masterTTDCombo.cFlag               = ttDCombo.cFlag
         AND   masterTTDCombo.cFlagValue          = ttDCombo.cFlagValue
         AND   masterTTDCombo.cListItemDelimiter  = ttDCombo.cListItemDelimiter
         AND   masterTTDCombo.cParentField        = ttDCombo.cParentField
         AND   masterTTDCombo.cParentFilterQuery  = ttDCombo.cParentFilterQuery
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE masterTTDCombo THEN
    DO:
      CREATE masterTTDCombo.
      RAW-TRANSFER ttDCombo TO masterTTDCombo.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateMasterTTLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateMasterTTLookup Procedure 
PROCEDURE updateMasterTTLookup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH ttLookup:
    /* Check if new is already in Master */
    FIND FIRST masterTTLookup 
         WHERE masterTTLookup.cWidgetType         = ttLookup.cWidgetType
         AND   masterTTLookup.cForEach            = ttLookup.cForEach
         AND   masterTTLookup.cBufferList         = ttLookup.cBufferList
         AND   masterTTLookup.cPhysicalTableNames = ttLookup.cPhysicalTableNames 
         AND   masterTTLookup.cTempTableNames     = ttLookup.cTempTableNames
         AND   masterTTLookup.cFieldList          = ttLookup.cFieldList   
         AND   masterTTLookup.cDataTypeList       = ttLookup.cDataTypeList
         AND   masterTTLookup.cFoundDataValues    = ttLookup.cFoundDataValues
         AND   masterTTLookup.cRowIdent           = ttLookup.cRowIdent       
         AND   masterTTLookup.lMoreFound          = ttLookup.lMoreFound
         AND   masterTTLookup.lRefreshQuery       = ttLookup.lRefreshQuery
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE masterTTLookup THEN
    DO:
      CREATE masterTTLookup.
      RAW-TRANSFER ttLookup TO masterTTLookup.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

