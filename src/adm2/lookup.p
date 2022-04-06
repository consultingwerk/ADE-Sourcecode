&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************
* Copyright (C) 2005-2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*--------------------------------------------------------------------------
    File        : lookup.p
    Purpose     : Super procedure for adm2 dynlookup class.

    Syntax      : RUN start-super-proc("adm2/lookup.p":U).

  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


&SCOP ADMSuper LOOKUP.p
&SCOP LookupKey F4

{src/adm2/ttlookup.i}
{src/adm2/tttranslate.i}
{src/adm2/ttdcombo.i}
  
  /* Custom exclude file */

  {src/adm2/custom/lookupexclcustom.i}

DEFINE VARIABLE gcLookupFilterValue    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glRecordBeingSaved     AS LOGICAL    NO-UNDO.

/* glUsenewAPI is conditionally defined in smrtprop.i based on &admSUPER names
   and can be used in and below the main-block in this super */ 

/* Create copies of the lookup and combo temp tables */
DEFINE TEMP-TABLE ttLookupCopy LIKE ttLookup.
DEFINE TEMP-TABLE ttDComboCopy LIKE ttDCombo.

&SCOPED-DEFINE setprop ~
    DEFINE VARIABLE hLookupBuffer AS HANDLE NO-UNDO. ~
    DEFINE VARIABLE hLookupCont   AS HANDLE NO-UNDO. ~
    ~{get ContainerSource hLookupCont~}. ~
    hLookupBuffer = DYNAMIC-FUNCT('returnLookupBuffer' IN TARGET-PROCEDURE). ~
    IF NOT hLookupBuffer:AVAILABLE THEN ~
    DO: ~
      hLookupBuffer:BUFFER-CREATE(). ~
      hLookupBuffer:BUFFER-FIELD('hWidget':U):BUFFER-VALUE  = TARGET-PROCEDURE. ~
      hLookupBuffer:BUFFER-FIELD('hViewer':U):BUFFER-VALUE  = hLookupCont. ~
    END. ~
    hLookupBuffer:BUFFER-FIELD('~{&ttfield~}':U):BUFFER-VALUE = ~{&propvalue~}. ~
    &UNDEFINE ttfield ~
    &UNDEFINE propvalue

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */
&IF DEFINED(EXCLUDE-buildFieldQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildFieldQuery Procedure 
FUNCTION buildFieldQuery RETURNS CHARACTER
  ( pcValue AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildSearchQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildSearchQuery Procedure 
FUNCTION buildSearchQuery RETURNS CHARACTER
  ( pcValue AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createLabel Procedure 
FUNCTION createLabel RETURNS HANDLE
  (pcLabel AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyLookup Procedure 
FUNCTION destroyLookup RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBlankOnNotAvail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBlankOnNotAvail Procedure 
FUNCTION getBlankOnNotAvail RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseFieldDataTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseFieldDataTypes Procedure 
FUNCTION getBrowseFieldDataTypes RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseFieldFormats) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseFieldFormats Procedure 
FUNCTION getBrowseFieldFormats RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseFields Procedure 
FUNCTION getBrowseFields RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseObject Procedure 
FUNCTION getBrowseObject RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseTitle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseTitle Procedure 
FUNCTION getBrowseTitle RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColumnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getColumnFormat Procedure 
FUNCTION getColumnFormat RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColumnLabels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getColumnLabels Procedure 
FUNCTION getColumnLabels RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataValue Procedure 
FUNCTION getDataValue RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldHandle Procedure 
FUNCTION getFieldHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkedFieldDataTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLinkedFieldDataTypes Procedure 
FUNCTION getLinkedFieldDataTypes RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkedFieldFormats) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLinkedFieldFormats Procedure 
FUNCTION getLinkedFieldFormats RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLookupFilterValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLookupFilterValue Procedure 
FUNCTION getLookupFilterValue RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLookupHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLookupHandle Procedure 
FUNCTION getLookupHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLookupImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLookupImage Procedure 
FUNCTION getLookupImage RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMaintenanceObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMaintenanceObject Procedure 
FUNCTION getMaintenanceObject RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMaintenanceSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMaintenanceSDO Procedure 
FUNCTION getMaintenanceSDO RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMappedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMappedFields Procedure 
FUNCTION getMappedFields RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPopupOnAmbiguous) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPopupOnAmbiguous Procedure 
FUNCTION getPopupOnAmbiguous RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPopupOnNotAvail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPopupOnNotAvail Procedure 
FUNCTION getPopupOnNotAvail RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPopupOnUniqueAmbiguous) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPopupOnUniqueAmbiguous Procedure 
FUNCTION getPopupOnUniqueAmbiguous RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowIdent Procedure 
FUNCTION getRowIdent RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowsToBatch Procedure 
FUNCTION getRowsToBatch RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getViewerLinkedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getViewerLinkedFields Procedure 
FUNCTION getViewerLinkedFields RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getViewerLinkedWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getViewerLinkedWidgets Procedure 
FUNCTION getViewerLinkedWidgets RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionDataSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD repositionDataSource Procedure 
FUNCTION repositionDataSource RETURNS LOGICAL PRIVATE
  ( pcValue AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-returnLookupBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD returnLookupBuffer Procedure 
FUNCTION returnLookupBuffer RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBlankOnNotAvail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBlankOnNotAvail Procedure 
FUNCTION setBlankOnNotAvail RETURNS LOGICAL
  ( plValue AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseFieldDataTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseFieldDataTypes Procedure 
FUNCTION setBrowseFieldDataTypes RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseFieldFormats) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseFieldFormats Procedure 
FUNCTION setBrowseFieldFormats RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseFields Procedure 
FUNCTION setBrowseFields RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseObject Procedure 
FUNCTION setBrowseObject RETURNS LOGICAL
  ( phObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseTitle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseTitle Procedure 
FUNCTION setBrowseTitle RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColumnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setColumnFormat Procedure 
FUNCTION setColumnFormat RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColumnLabels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setColumnLabels Procedure 
FUNCTION setColumnLabels RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataValue Procedure 
FUNCTION setDataValue RETURNS LOGICAL
  (pcValue AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayedField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisplayedField Procedure 
FUNCTION setDisplayedField RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldHidden Procedure 
FUNCTION setFieldHidden RETURNS LOGICAL
  ( INPUT plHide AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setKeyField Procedure 
FUNCTION setKeyField RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLinkedFieldDataTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLinkedFieldDataTypes Procedure 
FUNCTION setLinkedFieldDataTypes RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLinkedFieldFormats) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLinkedFieldFormats Procedure 
FUNCTION setLinkedFieldFormats RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLookupFilterValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLookupFilterValue Procedure 
FUNCTION setLookupFilterValue RETURNS LOGICAL
  ( INPUT pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLookupHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLookupHandle Procedure 
FUNCTION setLookupHandle RETURNS LOGICAL
  ( phValue AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLookupImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLookupImage Procedure 
FUNCTION setLookupImage RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMaintenanceObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMaintenanceObject Procedure 
FUNCTION setMaintenanceObject RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMaintenanceSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMaintenanceSDO Procedure 
FUNCTION setMaintenanceSDO RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMappedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMappedFields Procedure 
FUNCTION setMappedFields RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPhysicalTableNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPhysicalTableNames Procedure 
FUNCTION setPhysicalTableNames RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPopupOnAmbiguous) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPopupOnAmbiguous Procedure 
FUNCTION setPopupOnAmbiguous RETURNS LOGICAL
  ( plValue AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPopupOnNotAvail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPopupOnNotAvail Procedure 
FUNCTION setPopupOnNotAvail RETURNS LOGICAL
  ( plValue AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPopupOnUniqueAmbiguous) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPopupOnUniqueAmbiguous Procedure 
FUNCTION setPopupOnUniqueAmbiguous RETURNS LOGICAL
  ( plValue AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryTables Procedure 
FUNCTION setQueryTables RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRowIdent Procedure 
FUNCTION setRowIdent RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRowsToBatch Procedure 
FUNCTION setRowsToBatch RETURNS LOGICAL
  ( piValue AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTempTables Procedure 
FUNCTION setTempTables RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUseCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUseCache Procedure 
FUNCTION setUseCache RETURNS LOGICAL
  ( plValue AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setViewerLinkedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setViewerLinkedFields Procedure 
FUNCTION setViewerLinkedFields RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setViewerLinkedWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setViewerLinkedWidgets Procedure 
FUNCTION setViewerLinkedWidgets RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-whereClauseBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-EXTERNAL whereClauseBuffer Procedure 
FUNCTION whereClauseBuffer RETURNS CHARACTER PRIVATE
  (pcWhere AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:     Returns the buffername of a where clause expression. 
               This function avoids problems with leading or double blanks in 
               where clauses.
  Parameters:
    pcWhere - Complete where clause for ONE table with or without the FOR 
              keyword. The buffername must be the second token in the
              where clause as in "EACH order OF Customer" or if "FOR" is
              specified the third token as in "FOR EACH order".

  Notes:       PRIVATE, used internally in query.p only.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBuffer AS CHARACTER  NO-UNDO.

  pcWhere = LEFT-TRIM(pcWhere).

  /* Remove double blanks */
  DO WHILE INDEX(pcWhere,"  ":U) > 0:
    pcWhere = REPLACE(pcWhere,"  ":U," ":U).
  END.

  cBuffer = (IF NUM-ENTRIES(pcWhere," ":U) > 1 
            THEN ENTRY(IF pcWhere BEGINS "FOR ":U THEN 3 ELSE 2,pcWhere," ":U)
            ELSE "":U).
  
  /* Strip DB prefix */
  IF NUM-ENTRIES(cBuffer,".":U) > 1 THEN
    cBuffer = ENTRY(2,cBuffer,".":U).
  
  RETURN cBuffer.

END.

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
         HEIGHT             = 20.62
         WIDTH              = 59.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */


{src/adm2/lookupprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* glUsenewAPI is conditionally defined in smrtprop.i based on &admSUPER names*/
    
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */ 
&IF DEFINED(EXCLUDE-assignNewValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignNewValue Procedure 
PROCEDURE assignNewValue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcKeyFieldValue     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcDisplayFieldValue AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plSetModified       AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE hLookup                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cKeyFieldValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSavedScreenValue       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDynLookupBuf           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNewQuery               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScreenValue            AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get containerSource hContainer}
  {get DisplayValue cSavedScreenValue}
  {get LookupHandle hLookup}.
  &UNDEFINE xp-assign

  hLookup:SCREEN-VALUE = pcDisplayFieldValue.
  IF NOT glUseNewAPI THEN
  DO:
    hDynLookupBuf = {fn returnLookupBuffer}.
    RUN oldPrepareQuery IN TARGET-PROCEDURE 
               (pcDisplayFieldValue, pcKeyFieldValue, "AssignNewValue":U).
    RUN displayLookup IN TARGET-PROCEDURE (INPUT TABLE ttLookup).        
    {set DataModified plSetModified}.    
  END. /* if NOT new API */
  ELSE DO:
    &SCOPED-DEFINE xp-assign
    {get KeyField cKeyField}
    {get DisplayedField cDisplayedField}.
    &UNDEFINE xp-assign
    
    IF cKeyField = cDisplayedField THEN
      {set DataValue pcKeyFieldValue}.

    cScreenValue = hLookup:INPUT-VALUE.
    hDynLookupBuf = {fn returnLookupBuffer}.
    
    ASSIGN
      hDynLookupBuf:BUFFER-FIELD('cScreenValue':U):BUFFER-VALUE = cScreenValue
      hDynLookupBuf:BUFFER-FIELD('lMoreFound':U):BUFFER-VALUE = FALSE.

    IF pcKeyFieldValue = "":U AND pcDisplayFieldValue <> "":U THEN 
      cNewQuery = {fnarg buildSearchQuery pcDisplayFieldValue}.
    ELSE  
      cNewQuery = {fnarg buildFieldQuery pcKeyFieldValue}.
    
    {set QueryString cNewQuery}.  
    RUN retrieveData IN TARGET-PROCEDURE (hContainer).
    RUN displayField IN TARGET-PROCEDURE.
    /* set the passed value  */ 
    {set DataModified plSetModified}.
    RUN notifyChildFields IN TARGET-PROCEDURE ('Fetch':U). 
  END.
  
  {get DataValue cKeyFieldValue}.
  /* could have been passed in as blank, ensure it is set after display
     for lookupComplete below  */
  pcDisplayFieldValue = hLookup:input-value. 
  hDynLookupBuf = {fn returnLookupBuffer}.
  IF hDynLookupBuf:AVAILABLE AND
     hDynLookupBuf:BUFFER-FIELD('cFoundDataValues':U):BUFFER-VALUE > "":U
  THEN
    PUBLISH "lookupComplete":U FROM hContainer 
            (INPUT hDynLookupBuf:BUFFER-FIELD('cFieldList':U):BUFFER-VALUE,        /* CSV of fields specified */
             INPUT hDynLookupBuf:BUFFER-FIELD('cFoundDataValues':U):BUFFER-VALUE,  /* CHR(1) delim list of all the values of the above fields */
             INPUT cKeyFieldValue,      /* the key field value of the selected record */
             INPUT pcDisplayFieldValue, /* the value displayed on screen (may be the same as the key field value ) */
             INPUT cSavedScreenValue,   /* the old value displayed on screen (may be the same as the key field value ) */
             INPUT NO,                  /* YES = lookup browser used, NO = manual value entered */
             INPUT TARGET-PROCEDURE     /* Handle to lookup - use to determine which lookup has been left */
             ). 
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-chooseButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chooseButton Procedure 
PROCEDURE chooseButton :
/*------------------------------------------------------------------------------
  Purpose:   Choose button event handler that sets focus if required before 
             calling initalizeBrowse. 
  Parameters:  <none>
  Notes:     The lookup button is defined as no-focus. 'Entry' is applied
             to the fill-in in order to make the lookup fill-in and button 
             behave as a single widget and fire leave of other widgets also 
             when the user clicks directly on the button.       
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE hField AS HANDLE     NO-UNDO.
  
  {get LookupHandle hField}.

  IF FOCUS <> hField THEN
    APPLY 'ENTRY':U TO hField.

  RUN initializeBrowse IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearField Procedure 
PROCEDURE clearField :
/*------------------------------------------------------------------------------
  Purpose:     override to clear viewerlinkedwidgets...
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAllFieldHandles     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllFieldNames       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewerLinkedWidgets AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cName                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iField               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLoop                AS INTEGER    NO-UNDO.

  RUN SUPER.
  
  &SCOPED-DEFINE xp-assign
  {get ViewerLinkedWidgets cViewerLinkedWidgets}
  {get ContainerSource hContainer}
  {set DataValue ?}.
  &UNDEFINE xp-assign

  IF VALID-HANDLE(hContainer) THEN 
  DO:
    &SCOPED-DEFINE xp-assign
    {get AllFieldHandles cAllFieldHandles hContainer} 
    {get AllFieldNames cAllFieldNames hContainer}
     .
    &UNDEFINE xp-assign
    
    DO iLoop = 1 TO NUM-ENTRIES(cViewerLinkedWidgets):
      ASSIGN
        cName   = ENTRY(iLoop,cViewerLinkedWidgets)
        iField  = LOOKUP(cName,cAllFieldNames).
      /* Double check that the name is a name as Allfieldnames currently 
         have '?' for labels in static viewers while ViewerLinkedwidgets 
         may have '?' for fields to retrieve with no linking...  */
      IF iField > 0 AND cName <> '?':U THEN
      DO:
        hField = WIDGET-HANDLE(ENTRY(iField,cAllFieldHandles)).
        IF VALID-HANDLE(hField) THEN
        DO:
          IF hField:TYPE = "COMBO-BOX":U THEN
            {fnarg clearCombo hField}.          
          /* logical defaults to no (also radio-sets) */
          ELSE IF hField:DATA-TYPE = "LOGICAL":U THEN 
            hField:SCREEN-VALUE = 'NO':U.
            /* radio-set show first button */
          ELSE IF hField:TYPE = "RADIO-SET":U THEN
            hField:SCREEN-VALUE = ENTRY(2,hField:RADIO-BUTTONS) NO-ERROR. 
          ELSE  
            hField:SCREEN-VALUE = "".
        END.
      END. /* if valid */
    END. /* loop linked widgets*/
  END. /* valid hcontainer */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:   local overide of destroyObject; delete created widgets
  Parameters: <NONE>
  Notes:     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldName              AS CHARACTER  NO-UNDO.

  {get FieldName cFieldName}.
  
  FIND FIRST ttLookup
       WHERE ttLookup.hWidget = TARGET-PROCEDURE
         AND ttLookup.cWidgetName = cFieldName
       NO-ERROR.
       
  IF AVAILABLE ttLookup THEN 
    DELETE ttLookup.
  ELSE
    ASSIGN ERROR-STATUS:ERROR = NO.
      
  {fn destroyLookup}.

  /* A widget pool was created in initializeLookup for creation of the 
     lookup browser in rylookupbv.w.  This is to work around 20031119-043. */
  DELETE WIDGET-POOL cFieldName + STRING(TARGET-PROCEDURE) NO-ERROR.

  RUN SUPER.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableButton Procedure 
PROCEDURE disableButton :
/*------------------------------------------------------------------------------
  Purpose:     In certain instances, i.e. when we modify a specific record,
               we don't want a user to use a specific Lookup to find
               another record and potentially modify another record. For this
               reason we would just disable the specific Lookup's button
               and Browser to prevent the use of the lookup.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLookup          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hButton          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBrowseContainer AS HANDLE    NO-UNDO.

  {get LookupHandle hLookup}.

  IF VALID-HANDLE(hLookup) THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get BrowseContainer hBrowseContainer}
    {get ButtonHandle hButton}.
    &UNDEFINE xp-assign

    IF VALID-HANDLE(hBrowsecontainer) THEN
      RUN disableObject IN hBrowseContainer.

    IF VALID-HANDLE(hButton) THEN
      hButton:SENSITIVE = FALSE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableField Procedure 
PROCEDURE disableField :
/*------------------------------------------------------------------------------
  Purpose:   disable Lookup Field
  Parameters: <NONE>
  Notes:  The SmartDataViewer container will call this procedure if a widget of 
          type PROCEDURE is encountered in disableFields    
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hLookup          AS HANDLE    NO-UNDO.
 DEFINE VARIABLE hButton          AS HANDLE    NO-UNDO.
 DEFINE VARIABLE hBrowseContainer AS HANDLE    NO-UNDO.

 {get LookupHandle hLookup}.

 IF VALID-HANDLE(hLookup) THEN
 DO:
   &SCOPED-DEFINE xp-assign
   {get BrowseContainer hBrowseContainer}
   {get ButtonHandle hButton}.
   &UNDEFINE xp-assign

   IF VALID-HANDLE(hBrowsecontainer) THEN 
     RUN disableObject IN hBrowseContainer.

   IF VALID-HANDLE(hButton) THEN
     hButton:SENSITIVE = FALSE.

   ASSIGN
     hLookup:SENSITIVE = FALSE
     hLookup:TAB-STOP  = TRUE.   
 END.

 {set FieldEnabled FALSE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disable_UI) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Procedure 
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayField Procedure 
PROCEDURE displayField :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDataValue              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lDataModified           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cKeyFieldValue          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyField               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDisplayedField         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cViewerLinkedFields     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cViewerLinkedWidgets    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hLookup                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE iField                  AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cViewerField            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAllFieldHandles        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAllFieldNames          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidget                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE hCombo                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE cComboValue             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lBlankOnNotAvail        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lDisplayField           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hDynLookupBuf           AS HANDLE     NO-UNDO.
DEFINE VARIABLE cFoundValues            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFields                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iWidget                 AS INTEGER    NO-UNDO.
DEFINE VARIABLE cChildList              AS CHARACTER     NO-UNDO.

hDynLookupBuf = {fnarg returnBuffer 'Lookup':U}.
IF NOT hDynLookupBuf:AVAILABLE THEN
  RETURN.

&SCOPED-DEFINE xp-assign
{get DisplayField lDisplayField}
{get containerSource hContainer}    /* viewer */
{get LookupHandle hLookup}
{get DataModified lDataModified}
{get DataValue cDataValue}
{get KeyField cKeyField}
{get BlankOnNotAvail lBlankOnNotAvail}
{get DisplayedField cDisplayedField}
{get ViewerLinkedWidgets cViewerLinkedWidgets}
 .
&UNDEFINE xp-assign

IF NOT lDisplayField THEN
  RETURN.
  
/* Update displayed field */
ASSIGN
  cFoundValues = hDynLookupBuf:BUFFER-FIELD('cFoundDataValues':U):BUFFER-VALUE 
  cFields = hDynLookupBuf:BUFFER-FIELD('cFieldList':U):BUFFER-VALUE
  iField = LOOKUP(cDisplayedField, cFields).

IF iField > 0 AND NUM-ENTRIES(cFoundValues, CHR(1)) >= iField THEN
  hLookup:SCREEN-VALUE = ENTRY(iField, cFoundValues, CHR(1)).
ELSE DO: /* deal with an invalid value */
  IF lBlankOnNotAvail THEN     /* blank it out unless cKeyField = cDisplayedField */
    hLookup:SCREEN-VALUE = (IF cKeyField <> cDisplayedField OR 
                               hLookup:INPUT-VALUE = "?":U OR 
                               hLookup:INPUT-VALUE = "0":U 
                            THEN "":U 
                            ELSE hLookup:INPUT-VALUE).
  ELSE IF lDataModified THEN  /* keep the entered value while in Modified mode */
  DO:
    IF cKeyField <> cDisplayedField THEN
    DO:
      {set DataValue ?}. 
      hLookup:SCREEN-VALUE = hDynLookupBuf:BUFFER-FIELD('cScreenValue':U):BUFFER-VALUE.
    END.
    ELSE DO:
      {get DataValue cKeyFieldValue}.
      hLookup:SCREEN-VALUE = cKeyFieldValue.
    END.
  END.
END.

&SCOPED-DEFINE xp-assign
{set DisplayValue hLookup:INPUT-VALUE} /* avoid leave trigger code */
{get DataValue cKeyFieldValue}.
&UNDEFINE xp-assign

iField = LOOKUP(cKeyField, cFields).
IF iField > 0 AND NUM-ENTRIES(cFoundValues, CHR(1)) >= iField THEN
  cKeyFieldValue = ENTRY(iField, cFoundValues, CHR(1)).
ELSE
  cKeyFieldValue = "":U.     /* blank out as it is invalid */

IF (cFoundValues <> "":U AND cFoundValues <> ?) OR lBlankOnNotAvail THEN 
  {set DataValue cKeyFieldValue}.

/* store rowident property - rowids of current record */
{set RowIdent hDynLookupBuf:BUFFER-FIELD('cRowIdent':U):BUFFER-VALUE}.

/* Update linked fields  - linked SDFs are not supported */
IF cViewerLinkedWidgets > '':U THEN
DO:
  {get ViewerLinkedFields cViewerLinkedFields}.

  &SCOPED-DEFINE xp-assign
  {get AllFieldHandles cAllFieldHandles hContainer}
  {get AllFieldNames cAllFieldNames hContainer}
   .
  &UNDEFINE xp-assign
  
  DO iLoop = 1 TO NUM-ENTRIES(cViewerLinkedWidgets):
    ASSIGN
      hWidget      = ?
      cField       = ENTRY(iLoop, cViewerLinkedFields)
      cViewerField = ENTRY(iLoop, cViewerLinkedWidgets)
      iField       = LOOKUP(cField, cFields)
      iWidget      = LOOKUP(cViewerField, cAllFieldNames).
    IF iWidget > 0 THEN
        hWidget = WIDGET-HANDLE(ENTRY(iWidget, cAllFieldHandles)).
  
    IF VALID-HANDLE(hWidget) AND CAN-QUERY(hWidget, "NAME":U) AND iField > 0 THEN
      hWidget:SCREEN-VALUE = (IF NUM-ENTRIES(cFoundValues,CHR(1)) >= iField 
                              THEN ENTRY(iField,cFoundValues, CHR(1))
                              ELSE IF hWidget:TYPE = "COMBO-BOX":U 
                                   THEN {fnarg clearCombo hWidget}
                                   ELSE IF hWidget:DATA-TYPE = "LOGICAL" 
                                        THEN "NO":U 
                                        ELSE "":U) NO-ERROR.
  
  END.
END.  /* cViewerLinkedWidgets > '' */

/* If modified, refresh children */
IF lDataModified THEN 
  RUN notifyChildFields IN TARGET-PROCEDURE ('Reset':U). 

PUBLISH "lookupDisplayComplete":U FROM  hContainer 
        (INPUT cFields,        /* CSV of fields specified */
         INPUT cFoundValues,  /* CHR(1) delim list of all the values of the above fields */
         INPUT cKeyFieldValue,             /* the key field value of the selected record */
         INPUT TARGET-PROCEDURE            /* Handle to lookup - use to determine which lookup has been left */
         ). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayLookup Procedure 
PROCEDURE displayLookup :
/*------------------------------------------------------------------------------
  Purpose:     This is published from the smartviewer containing the smartdatafield 
               to populate the lookup with the evaluated query data - if the
               query was succesful.
               It is published from displayfields in the viewer.
               The queries were initially built in getLookupQuery. 
  Parameters:  input lookup temp-table
  Notes:       This is designed to facilitate all lookup queries being built with
               a single appserver hit.
               NOTE that this is not run at all in add mode - unless lookup
               manually fired.
               
               DEPRECATED - Use displayField instead.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR ttLookup.

  /* this section is included to support calls from custom code that uses the New API */
  IF glUseNewAPI THEN
  DO:
    RUN copyToLookupTable IN TARGET-PROCEDURE (INPUT TABLE ttLookup).
    EMPTY TEMP-TABLE ttLookup.
    RUN displayField IN TARGET-PROCEDURE.
  END.
  ELSE
    RUN oldDisplayLookup IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableButton Procedure 
PROCEDURE enableButton :
/*------------------------------------------------------------------------------
  Purpose:    If the Lookup button was disabled because the programmer did
              not want the user to do a lookup, this procedure will enable the
              button again
  Parameters: <NONE>
  Notes:      
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hLookup         AS HANDLE NO-UNDO.
 DEFINE VARIABLE cDisplayedField AS CHAR   NO-UNDO.
 DEFINE VARIABLE cKeyField       AS CHAR   NO-UNDO.
 DEFINE VARIABLE hButton         AS HANDLE NO-UNDO.

 {get LookupHandle hLookup}.

 IF VALID-HANDLE(hLookup) THEN
 DO:
   {get ButtonHandle hButton}.
   ASSIGN hButton:SENSITIVE = TRUE.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableField Procedure 
PROCEDURE enableField :
/*------------------------------------------------------------------------------
  Purpose:   enable Lookup Field
  Parameters: <NONE>
  Notes:  The SmartDataViewer Container will call this procedure if a widget of 
          type PROCEDURE is encountered in enableFields    
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hLookup          AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hButton          AS HANDLE     NO-UNDO.

 {get LookupHandle hLookup}.

 IF VALID-HANDLE(hLookup) THEN
 DO:
   {get ButtonHandle hButton}.
   hLookup:SENSITIVE = TRUE.

   /* to support lookup SDF WITHOUT a lookup button */
   IF VALID-HANDLE(hButton) THEN
      hButton:SENSITIVE   = TRUE. 

    hLookup:TAB-STOP = TRUE.   
 END.

 {set FieldEnabled TRUE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-endMove) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endMove Procedure 
PROCEDURE endMove :
/*------------------------------------------------------------------------------
  Purpose:  Move the label when the field is moved in design-mode    
  Parameters:  
  Notes:    Defined as PERSISTENT on END-MOVE of the frame of the widget.    
------------------------------------------------------------------------------*/

   DEFINE VARIABLE cBlank AS CHARACTER NO-UNDO.
   /* Because we override endmove we must apply it in order to make the
      AppBuilder notify the change */
   APPLY "END-RESIZE":U TO SELF. /* runs setPosition */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enterLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enterLookup Procedure 
PROCEDURE enterLookup :
/*------------------------------------------------------------------------------
  Purpose:     Trigger fired on entry of lookup field
  Parameters:  <none>
  Notes:       The purpose of this trigger is to store the current screen value
               of the displayed field in the lookup so that where the 
               displayedfield is not equal to the keyfield (usually the case) then
               we can fire logic when the displayed field is changed in the leave
               trigger to see if the new value keyed in actually exists as a unique
               record, and if so, avoid having to use the lookup.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hLookup               AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hContainer            AS HANDLE       NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get LookupHandle hLookup}
  {get containerSource hContainer}
  {set DisplayValue hLookup:INPUT-VALUE}.
  &UNDEFINE xp-assign

  PUBLISH "lookupEntry":U FROM hContainer (INPUT hLookup:INPUT-VALUE,   /* current lookup value */
                                           INPUT TARGET-PROCEDURE           /* handle of lookup */
                                          ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-exportTT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportTT Procedure 
PROCEDURE exportTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  OUTPUT TO Lookupwww.txt.
  FOR EACH ttLookup:
      EXPORT STRING(ttLookup.hWidget) STRING(ttLookup.hViewer) ttLookup.cwidgetname ttLookup.cForeach .

  END.
  OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLookupQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLookupQuery Procedure 
PROCEDURE getLookupQuery :
/*------------------------------------------------------------------------------
  Purpose:     This routine is published from the viewer and is used to pass the query
               required by this lookup back to the viewer for building. Once built,
               the query will be returned into the procedure displayLookup.
  Parameters:  input-output lookup temp table
  Notes:       This is designed to facilitate all lookup queries being built with
               a single appserver hit.
               It is published from displayfields in the viewer.
               NOTE that this is not run at all in add mode.
               DEPRECATED
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttLookup.

  DEFINE VARIABLE cFieldName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyDataType            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFieldValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewQuery               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentFilterQuery      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource             AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get FieldName cFieldName}
  {get KeyField cKeyField}
  {get KeyDataType cKeyDataType}
  {get QueryTables cQueryTables}
  {get containerSource hContainer}.   /* viewer */
  &UNDEFINE xp-assign
  
  IF VALID-HANDLE(hContainer) THEN
    hDataSource = DYNAMIC-FUNCTION('getDataSource':U IN hContainer) NO-ERROR.

  PUBLISH "initializeLookup":U FROM  hContainer (INPUT TARGET-PROCEDURE).            /* Handle to lookup - use to determine which lookup is being initialized */

  /* we must get the value of the external field from the SDO that is the 
     data source of the viewer - and then change the query for the lookup
     to find the record where the keyfield is equal to this external field
     value
  */
  IF VALID-HANDLE(hDataSource) THEN 
    cKeyFieldValue = DYNAMIC-FUNCTION("ColumnValue":U IN hDataSource,cFieldName).
  
  IF  cKeyFieldValue = "":u OR cKeyFieldValue = ? OR cKeyFieldValue = "0":u THEN
      {get DataValue cKeyFieldValue}.
  ELSE
      /* reset saved keyfieldvalue */
      {set DataValue cKeyFieldValue}.

  /* Set up where clause for key field equal to current value of key field */
  cNewQuery = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                               cKeyField,
                               TRIM(cKeyFieldValue),
                               cKeyDataType,
                               "=":U,
                               ?,
                               ?).
  
  /* Set Parent-Child filter */
  RUN returnParentFieldValues IN TARGET-PROCEDURE (OUTPUT cParentFilterQuery).
  IF cParentFilterQuery <> "":U THEN DO:
    IF NUM-ENTRIES(cParentFilterQuery,"|":U) > 1 AND 
       NUM-ENTRIES(cQueryTables) > 1 THEN DO:
      DO iLoop = 1 TO NUM-ENTRIES(cParentFilterQuery,"|":U):
        IF TRIM(ENTRY(iLoop,cParentFilterQuery,"|":U)) <> "":U THEN
          cNewQuery = DYNAMIC-FUNCTION("newWhereClause" IN TARGET-PROCEDURE,
                                       ENTRY(iLoop,cQueryTables),
                                       ENTRY(iLoop,cParentFilterQuery,"|":U),
                                       cNewQuery,
                                       "AND":U).
      END.
    END.
    ELSE
        cNewQuery = DYNAMIC-FUNCTION("newWhereClause" IN TARGET-PROCEDURE,
                                     ENTRY(NUM-ENTRIES(cQueryTables),cQueryTables),
                                     cParentFilterQuery,
                                     cNewQuery,
                                     "AND":U).
  END.
  
  /* Update query into temp-table */
  RUN oldUpdateTable IN TARGET-PROCEDURE
                   (cNewQuery,          /* cForEach */
                    "":U,               /* cFoundDataValues */
                    "":U,               /* cRowIdent */
                    TRUE,               /* lRefresh */
                    ?,                  /* lMoreFound */
                    ?).                 /* cScreenValue */
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideObject Procedure 
PROCEDURE hideObject :
/*------------------------------------------------------------------------------
  Purpose: Override in order to make sure the label is hidden     
  Parameters:  <none>
  Notes:   For sizing reasons, the label is not really a part of the object,
           but added as a text widget to the parent frame.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLabel AS HANDLE NO-UNDO.

  {get LabelHandle hLabel}.

  IF VALID-HANDLE(hLabel) THEN 
    hLabel:HIDDEN = TRUE.

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeBrowse Procedure 
PROCEDURE initializeBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Fire up the lookup browser window
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cUIBmode         AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hContainer       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRealContainer   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBrowseContainer AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBrowseObject    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hLookup          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cBrowseTitle     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hBrowseWindow    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDisplayedValue  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hWindowHandle    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cProcedureType   AS CHARACTER NO-UNDO.
  {get uibMODE cUIBmode}.

  IF cuibMode BEGINS "DESIGN":U THEN 
    RETURN. 
  
  /* First see if already running */
  &SCOPED-DEFINE xp-assign
  {get BrowseObject hBrowseObject}
  {get BrowseContainer hBrowseContainer}.
  &UNDEFINE xp-assign
  
  IF NOT VALID-HANDLE(hBrowseContainer) THEN 
  DO:   
    {get ContainerSource hContainer}.
    {get ContainerSource hRealContainer hContainer}.
    {get ContainerHandle hWindowHandle hRealContainer}.        
    /* Construct the window and objects 
       NOTE: Currently containr constructObject looks for LogicalObjectName as
             the FIRST entry and sets the current name for correct launch */         
    IF VALID-HANDLE(gshSessionManager) THEN
      RUN launchContainer IN gshSessionManager (                                                    
          INPUT "rydynlookw":U,     /* pcObjectFileName       */
          INPUT "":U,               /* pcPhysicalName         */
          INPUT "":U,               /* pcLogicalName          */
          INPUT FALSE,              /* plOnceOnly             */
          INPUT "StartPage":U + CHR(4) + '1':U,     
                                     /* pcInstanceAttributes   */ 
          INPUT "":U,               /* pcChildDataKey         */
          INPUT "":U,               /* pcRunAttribute         */
          INPUT "":U,               /* container mode         */
          INPUT hWindowHandle,      /* phParentWindow         */
          INPUT hRealContainer,     /* phParentProcedure      */
          INPUT hRealContainer,     /* phObjectProcedure      */
          OUTPUT hBrowseContainer,  /* phProcedureHandle      */
          OUTPUT cProcedureType     /* pcProcedureType        */       
      ).       
    
    {get ContainerHandle hBrowseWindow hBrowseContainer}.
    {get BrowseTitle cBrowseTitle}.
    /* Set window title */
    hBrowseWindow:TITLE = cBrowseTitle.
    
    IF VALID-HANDLE(hContainer) THEN
      /* Handle to lookup - use to determine which lookup is being initialized */
      PUBLISH "initializeBrowse":U FROM hContainer (INPUT TARGET-PROCEDURE).
    
    &SCOPED-DEFINE xp-assign
    {get LookupHandle hLookup}
    {get DisplayValue cDisplayedValue}.
    &UNDEFINE xp-assign
    
    /* Only set the Auto Filter if the value in the field has changed */
    IF DYNAMIC-FUNCTION("getDataModified":U IN TARGET-PROCEDURE) = TRUE 
    AND cDisplayedValue <> hLookup:INPUT-VALUE THEN
      {set LookupFilterValue hLookup:INPUT-VALUE}.
    ELSE
      {set LookupFilterValue '':U}.

    /* construct browser and filter settings */
    PUBLISH "buildBrowser":U FROM hBrowseContainer (INPUT TARGET-PROCEDURE).
    PUBLISH "buildFilters":U FROM hBrowseContainer (INPUT TARGET-PROCEDURE).

    &SCOPED-DEFINE xp-assign
    /* set by BuildBrowser */
    {get BrowseObject hBrowseObject}
    {set LookupFilterValue ''}
    /* Store container handle */
    {set BrowseContainer hBrowseContainer}
    .
    &UNDEFINE xp-assign
    
    /* Force a resize of the newly-launched window. We do this because
       the resize performed on initialisation is done before the browser
       and filter have been constructed, and so there are some minor sizing 
       issues. This resize call sorts those out. */
    run resizeWindow in hBrowseContainer no-error.
  END.  /* not valid handle browse container */
  
  /* View and focus the browser */
  RUN applyEntry IN hBrowseObject (INPUT ?).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeLookup Procedure 
PROCEDURE initializeLookup :
/*------------------------------------------------------------------------------
  Purpose:     Run as part of initializeObject to set up the lookup
  Parameters:  <none>
  Notes:       Defaults keyfield to actual field if not defined.
               Defaults displayed field to keyfield if not defined.
               Assumes a data type of decimal for keyfield and character for
               displayed field if different.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cDisplayedField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLABEL                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFormat            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayFormat        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cToolTip              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyDataType          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayDataType      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFrame                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParentFrame          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLookup               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLookupImg            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBtn                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iRowsToBatch          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cUIBMode              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBrowseFields         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBrowseFieldFormats   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lLocalField           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cTableIOType          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewerLinkedFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedFieldDataTypes AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUseCache             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lPopupOnAmbiguous     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lPopupOnUniqueAmbiguous AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE hDynLookupBuf         AS HANDLE     NO-UNDO.
      
  {get ContainerHandle hFrame}.

  hParentFrame = hFrame:FRAME.

  IF NOT VALID-HANDLE(hParentFrame) THEN 
    RETURN.

  {fn destroyLookup}. /* Get rid of existing widgets so we can recreate them */

  &SCOPED-DEFINE xp-assign
  {get FieldName cFieldName}
  {get DisplayedField cDisplayedField}
  {get KeyField cKeyField}
  {get FieldLabel cLabel}
  {get FieldToolTip cToolTip}
  {get KeyFormat cKeyFormat}
  {get KeyDataType cKeyDataType}
  {get DisplayFormat cDisplayFormat}
  {get DisplayDataType cDisplayDataType}
  {get RowsToBatch iRowsToBatch}
  {get UIBMode cUIBmode}
  {get ContainerSource hContainer}
  {get BrowseFields cBrowseFields}
  {get ColumnFormat cBrowseFieldFormats}
  {get ViewerLinkedFields cViewerLinkedFields}
  {get LinkedFieldDataTypes cLinkedFieldDataTypes}
  {get PopupOnAmbiguous lPopupOnAmbiguous}
  {get PopupOnUniqueAmbiguous lPopupOnUniqueAmbiguous}
  {get UseCache lUseCache}.
  .
  &UNDEFINE xp-assign
                     
  /* A widget pool must be created for creation of the lookup browser
     in rylookupbv.w.  This is to work around 20031119-043.
     The widget pool is deleted in destroyObject. */
  CREATE WIDGET-POOL cFieldName + STRING(TARGET-PROCEDURE) PERSISTENT NO-ERROR.

  /* Check if DisplayedField's format was changed in BrowseField formats,
     if it has, override the DisplayFormat with this new format */
  IF LOOKUP(cDisplayedField,cBrowseFields) > 0 AND
     NUM-ENTRIES(cBrowseFieldFormats,"|":U) >= LOOKUP(cDisplayedField,cBrowseFields) AND
     ENTRY(LOOKUP(cDisplayedField,cBrowseFields),cBrowseFieldFormats,"|":U) <> "":U THEN DO:
    ASSIGN cDisplayFormat = TRIM(ENTRY(LOOKUP(cDisplayedField,cBrowseFields),cBrowseFieldFormats,"|":U)).
    {set DisplayFormat cDisplayFormat}.
  END.

  IF VALID-HANDLE(hContainer) AND (cUIBMode BEGINS "DESIGN":U) = FALSE THEN
    DYNAMIC-FUNCTION("setEditable":U IN hContainer,TRUE) NO-ERROR.
  
  /* default to the fieldname if no keyfield 
     (This will give errors further down if the field does not exist) */
  IF cKeyField = "":U THEN
  DO:
     {get FieldName cKeyfield}.
     {set KeyField  cKeyfield}.
  END.

  /* default to the keyfield if no displayedfield */
  IF cDisplayedField = "":U OR cDisplayedField = ? THEN
  DO:
    cDisplayedField = cKeyField.
    {set DisplayedField cDisplayedField}.
  END.

  /* Assume a decimal data type if not defined for key field */
  IF cKeyDataType = "":U THEN
    ASSIGN cKeyDataType = "decimal":U.
  {set KeyDataType  cKeyDataType}.

  /* Default the format of the key field if not defined */
  IF cKeyFormat = "":U THEN
  CASE cKeyDataType:
    WHEN "decimal":U THEN ASSIGN cKeyFormat = "->>>>>>>>>>>>>>>>>9.999999999":U.
    WHEN "date":U THEN ASSIGN cKeyFormat = "99/99/9999":U.
    WHEN "datetime":U THEN ASSIGN cKeyFormat = "99/99/9999 HH:MM:SS.SSS":U.
    WHEN "datetime-tz":U THEN ASSIGN cKeyFormat = "99/99/9999 HH:MM:SS.SSS+HH:MM":U.
    WHEN "integer":U THEN ASSIGN cKeyFormat = ">>>>>>>9":U.
    WHEN "int64":U THEN ASSIGN cKeyFormat = ">>>>>>>>>>9":U.
    OTHERWISE ASSIGN cKeyFormat = "x(256)":U.
  END CASE.
  {set KeyFormat  cKeyFormat}.

  /* default data type of display field to key field data type or character */
  IF cDisplayDataType = "":U AND cKeyField = cDisplayedField THEN
    ASSIGN cDisplayDataType = cKeyDataType.
  IF cDisplayDataType = "":U THEN
    ASSIGN cDisplayDataType = "character":U.
  {set DisplayDataType  cDisplayDataType}.

  /* Default the format of the display field if not defined */
  IF TRIM(cDisplayFormat) = "":U THEN
    CASE cDisplayDataType:
      WHEN "decimal":U THEN ASSIGN cDisplayFormat = "->>>>>>>>>>>>>>>>>9.999999999":U.
      WHEN "date":U THEN ASSIGN cDisplayFormat = "99/99/9999":U.
      WHEN "datetime":U THEN ASSIGN cDisplayFormat = "99/99/9999 HH:MM:SS.SSS":U.
      WHEN "datetime-tz":U THEN ASSIGN cDisplayFormat = "99/99/9999 HH:MM:SS.SSS+HH:MM":U.
      WHEN "integer":U THEN ASSIGN cDisplayFormat = ">>>>>>>9":U.
      WHEN "int64":U THEN ASSIGN cKeyFormat = ">>>>>>>>>>9":U.
      OTHERWISE ASSIGN cDisplayFormat = "x(256)":U.
    END CASE.
  {set DisplayFormat cDisplayFormat}.

  CREATE FILL-IN hLookup
    ASSIGN FRAME            = hFrame
           NAME             = "fiLookup" 
           SUBTYPE          = IF cUIBMode BEGINS "DESIGN":U
                              THEN "NATIVE":U
                              ELSE "PROGRESS":U 
           X                = 0
           Y                = 0
           DATA-TYPE        = cDisplayDataType 
           FORMAT           = cDisplayFormat
           WIDTH-PIXELS     = hFrame:WIDTH-PIXELS - 24
           HIDDEN           = TRUE
           SENSITIVE        = (cUIBMode BEGINS "DESIGN":U) = FALSE  
           READ-ONLY        = (cUIBMode BEGINS "DESIGN":U) = TRUE
           TAB-STOP         = FALSE.

  CREATE BUTTON hBtn
    ASSIGN NO-FOCUS         = TRUE
           FRAME            = hFrame
           X                = hLookup:WIDTH-P + (if SESSION:WINDOW-SYSTEM eq 'MS-WINXP' then 0 else 4)
           Y                = (if SESSION:WINDOW-SYSTEM eq 'MS-WINXP' then 0 else 1)
           WIDTH-PIXELS     = (if SESSION:WINDOW-SYSTEM eq 'MS-WINXP' then 22 else 19)
           HEIGHT-P         = hLookup:HEIGHT-P - ( if SESSION:WINDOW-SYSTEM eq 'MS-WINXP' then 0 else 1)
           HIDDEN           = TRUE
           SENSITIVE        = hLookup:SENSITIVE
        TRIGGERS:
          ON CHOOSE PERSISTENT 
            RUN chooseButton IN TARGET-PROCEDURE.
        END.

  IF DYNAMIC-FUNCTION('getUseWidgetID':U IN TARGET-PROCEDURE) THEN
      RUN assignWidgetID IN TARGET-PROCEDURE (INPUT hLookup, INPUT 6,
                                              INPUT hBtn,    INPUT 2).

  &SCOPED-DEFINE xp-assign
  {set LookupHandle hLookup}
  {set ButtonHandle hBtn}       
  {get LookupImage cLookupImg}.
  &UNDEFINE xp-assign

  ASSIGN hBtn:HIDDEN    = FALSE
         hLookup:HIDDEN = FALSE.

  hBtn:LOAD-IMAGE(cLookupImg).
  hFrame:HEIGHT = hLookup:HEIGHT.

  /* create an entry/leave trigger always, code is defined */
  ON ENTRY OF hLookup 
   PERSISTENT RUN enterLookup IN TARGET-PROCEDURE.
  ON LEAVE OF hLookup 
   PERSISTENT RUN leaveLookup IN TARGET-PROCEDURE.

  IF VALID-HANDLE(hLookup) THEN
  DO:
    /* create a label if not blank */  
    IF cLabel NE "":U THEN
      {fnarg createLabel cLabel}. 

    hLookup:MOVE-TO-BOTTOM().
    hLookup:TOOLTIP = cToolTIP.

    ON F4            OF hLookup PERSISTENT RUN shortCutKey   IN TARGET-PROCEDURE.
    ON VALUE-CHANGED OF hLookup PERSISTENT RUN valueChanged  IN TARGET-PROCEDURE.
    ON END-MOVE      OF hFrame  PERSISTENT RUN endMove       IN TARGET-PROCEDURE. 
  END.
  
  FIND FIRST ttLookup WHERE ttLookup.hWidget = TARGET-PROCEDURE NO-ERROR.
  IF NOT AVAIL ttLookup THEN
  DO:
    CREATE ttLookup.
    ttLookup.hWidget  = TARGET-PROCEDURE.
  END.   
  
  ASSIGN ttLookup.hViewer                 = hContainer
         ttLookup.cWidgetName             = cFieldName
         ttLookup.cWidgetType             = cKeyDataType
         ttLookup.cFieldList              = cKeyField + ",":U 
                                          + cDisplayedField + ",":U 
                                          + cViewerLinkedFields
         ttLookup.cDataTypeList           = cKeyDataType + ",":U 
                                          + cDisplayDataType + ",":U 
                                          + cLinkedFieldDataTypes
         ttLookup.lPopupOnAmbiguous       = lPopupOnAmbiguous
         ttLookup.lPopupOnUniqueAmbiguous = lPopupOnUniqueAmbiguous
         ttLookup.lUseCache               = lUseCache
         ttLookup.lRefreshQuery           = TRUE.
  /* move this record to the proper table */
  IF glUseNewAPI THEN
  DO:
    hDynLookupBuf = {fn returnLookupBuffer}.
    IF NOT hDynLookupBuf:AVAILABLE THEN
       hDynLookupBuf:BUFFER-CREATE().
    hDynLookupBuf:BUFFER-COPY(BUFFER ttLookup:HANDLE, 
                 'cBufferList,cPhysicalTableNames,cTempTableNames,cRowIdent,cScreenValue,lMoreFound,cFoundDataValues,cForEach').
  END.
  
  RUN disableField IN TARGET-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-leaveLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveLookup Procedure 
PROCEDURE leaveLookup :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is fired on leave of a lookup field.
  Parameters:  <none>
  Notes:       The purpose of this procedure is to cope with the situation where
               a value is manually entered rather than using the lookup key.
               In this case, we need to see if the screen value has been changed,
               and if so, see if the changed screen value is a valid record.
               If it is, reset the keyvalue thereby avoiding having to use the
               lookup.
------------------------------------------------------------------------------*/
DEFINE VARIABLE hButton                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLookup                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE cKeyField               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyFieldValue          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cScreenValue            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSavedScreenValue       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lPopupOnNotAvail        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hDynLookupBuf           AS HANDLE     NO-UNDO.
DEFINE VARIABLE cDisplayedField         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cViewerLinkedFields     AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get containerSource hContainer}
  {get LookupHandle hLookup}
  {get ButtonHandle hButton}
  {get KeyField cKeyField}
  {get DisplayedField cDisplayedField}
  {get ViewerLinkedFields cViewerLinkedFields}
  {get DataValue cKeyFieldValue}
  {get PopupOnNotAvail lPopupOnNotAvail}
  {get DisplayValue cSavedScreenValue}.
  &UNDEFINE xp-assign

  /* If the lookup's button is disabled, that means that the developer did not want 
     the lookup's standard behaviour, but rather wanted to use the lookup as fill-in. 
     Even in this instance, the developer would like to know what the value was that 
     was entered into the lookup and therefore also about the lookupComplete event. 
     Because no lookup was done, there is also no subsequent data that can be returned,
     so publish lookupComplete with the data that was entered into the lookup */
  cScreenValue = hLookup:INPUT-VALUE.
  IF VALID-HANDLE(hButton) AND NOT hButton:SENSITIVE AND {fn getFieldEnabled} THEN
  DO:    
    PUBLISH "lookupComplete":U FROM hContainer 
         (INPUT cKeyField + ",":U + cDisplayedField + ",":U + cViewerLinkedFields, /* fields specified */
          INPUT cScreenValue,       /* CHR(1) delim list of all the values of the above fields */
          INPUT cScreenValue,       /* the key field value of the selected record */
          INPUT cScreenValue,       /* the value displayed on screen (may be the same as the key field value ) */
          INPUT cScreenValue,       /* the old value displayed on screen (may be the same as the key field value ) */
          INPUT NO,                 /* YES = lookup browser used, NO = manual value entered */
          INPUT TARGET-PROCEDURE).  /* Handle to lookup - use to determine which lookup has been left */
    RETURN.
  END.

  /* If user has manually changed description field - lookup new value 
     user has entered.  */
  IF cScreenValue <> cSavedScreenValue THEN
  DO:
    /* handled in cache manager in new API */
    IF glUseNewAPI = FALSE THEN
      RUN OldPrepareQuery IN TARGET-PROCEDURE (cScreenValue, "":U, "LeaveLookup":U).
    ELSE DO:
      hDynLookupBuf = {fn returnLookupBuffer}.
      hDynLookupBuf:BUFFER-FIELD('cScreenValue':U):BUFFER-VALUE = cScreenValue.
      RUN prepareField IN TARGET-PROCEDURE.
      RUN retrieveData IN TARGET-PROCEDURE (hContainer).
    END.

    /* we need to re-find the record since retrieveData calls several 
       unsafe APIs that directly messes with the temp-table */
    hDynLookupBuf = {fn returnLookupBuffer}.

    /* If value entered and more than one record could be found matching
       the entered value - automatically launch the lookup and filter
       on entered value */
    IF hDynLookupBuf:BUFFER-FIELD('lMoreFound':U):BUFFER-VALUE = TRUE
    AND hButton:SENSITIVE = TRUE THEN
    DO:
      RUN initializeBrowse IN TARGET-PROCEDURE.
      RETURN NO-APPLY.
    END.

    IF TRIM(hDynLookupBuf:BUFFER-FIELD('cFoundDataValues':U):BUFFER-VALUE) = "":U 
    AND lPopupOnNotAvail = TRUE 
    AND glRecordBeingSaved = FALSE 
    AND cScreenValue <> "":U 
    AND hButton:SENSITIVE = TRUE 
    AND hLookup:INPUT-VALUE <> "":U 
    AND hLookup:INPUT-VALUE <> ? 
    AND hLookup:INPUT-VALUE <> "?" THEN 
    DO:
      hLookup:SCREEN-VALUE = "":U.
      RUN initializeBrowse IN TARGET-PROCEDURE.
      RETURN NO-APPLY.
    END.

    /* Update display with result of query */
    IF glUseNewAPI THEN
    DO:
      RUN displayField IN TARGET-PROCEDURE.
      RUN notifyChildFields IN TARGET-PROCEDURE ('Fetch':U). 
      /* we need to re-find the record since notifyChildfields calls 
         retrieveData, which again calls several unsafe APIs that 
         directly messes with the temp-table */
      hDynLookupBuf = {fn returnLookupBuffer}.
    END.
    ELSE
      RUN displayLookup IN TARGET-PROCEDURE (INPUT TABLE ttLookup).        
 
    /* Only store new screen value if we actually found a value, 
       otherwise pass back what they typed */
    IF hLookup:INPUT-VALUE <> "":U AND hLookup:INPUT-VALUE <> "0":U THEN
      cScreenValue = hLookup:INPUT-VALUE. 
   
    {get DataValue cKeyFieldValue}.
    IF hDynLookupBuf:AVAILABLE THEN 
      PUBLISH "lookupComplete":U FROM hContainer 
              (INPUT hDynLookupBuf:BUFFER-FIELD('cFieldList':U):BUFFER-VALUE,        /* CSV of fields specified */
               INPUT hDynLookupBuf:BUFFER-FIELD('cFoundDataValues':U):BUFFER-VALUE,  /* CHR(1) delim list of all the values of the above fields */
               INPUT cKeyFieldValue,      /* the key field value of the selected record */
               INPUT cScreenValue,        /* the value displayed on screen (may be the same as the key field value ) */
               INPUT cSavedScreenValue,   /* the old value displayed on screen (may be the same as the key field value ) */
               INPUT NO,                  /* YES = lookup browser used, NO = manual value entered */
               INPUT TARGET-PROCEDURE     /* Handle to lookup - use to determine which lookup has been left */
               ). 
    IF cScreenValue <> cSavedScreenValue THEN
      RUN valueChanged IN TARGET-PROCEDURE.

    {set DisplayValue hLookup:INPUT-VALUE}.
  END.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-oldDisplayLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE oldDisplayLookup Procedure 
PROCEDURE oldDisplayLookup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       DEPRECATED - used by the old API only. 
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFieldName              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyField               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDisplayedField         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cViewerLinkedFields     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cViewerLinkedWidgets    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyFieldValue          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hLookup                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE iField                  AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAllFieldHandles        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAllFieldNames          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidget                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE cDynComboList           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hCombo                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE cParentFields           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hComboField             AS HANDLE     NO-UNDO.
DEFINE VARIABLE cComboValue             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lBlankOnNotAvail        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lDisplayField           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hDynLookupBuf           AS HANDLE     NO-UNDO.
DEFINE VARIABLE cFoundValues            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFields                 AS CHARACTER  NO-UNDO.

hDynLookupBuf = {fn returnLookupBuffer}.
IF NOT hDynLookupBuf:AVAILABLE THEN
  RETURN.

&SCOPED-DEFINE xp-assign
{get FieldName cFieldName}
{get KeyField cKeyField}
{get DisplayedField cDisplayedField}
{get LookupHandle hLookup}
{get ViewerLinkedFields cViewerLinkedFields}
{get ViewerLinkedWidgets cViewerLinkedWidgets}
{get containerSource hContainer}    /* viewer */
{get BlankOnNotAvail lBlankOnNotAvail}
{get DisplayField lDisplayField}.
&UNDEFINE xp-assign

IF NOT lDisplayField THEN
  RETURN.

/* Update displayed field */
ASSIGN
  cFoundValues = hDynLookupBuf:BUFFER-FIELD('cFoundDataValues':U):BUFFER-VALUE 
  cFields = hDynLookupBuf:BUFFER-FIELD('cFieldList':U):BUFFER-VALUE
  iField = LOOKUP(cDisplayedField, cFields).

IF iField > 0 AND NUM-ENTRIES(cFoundValues, CHR(1)) >= iField THEN
  hLookup:SCREEN-VALUE = ENTRY(iField, cFoundValues, CHR(1)).
ELSE DO:
  /* blank out as it is invalid - unless displayed field = key field */
  IF lBlankOnNotAvail THEN
    hLookup:SCREEN-VALUE = (IF cKeyField <> cDisplayedField OR 
                               hLookup:INPUT-VALUE = "?":U OR 
                               hLookup:INPUT-VALUE = "0":U 
                            THEN "":U 
                            ELSE hLookup:INPUT-VALUE).
END.

IF (cFoundValues = "":U OR cFoundValues = ?) AND NOT lBlankOnNotAvail THEN 
DO: 
  IF cKeyField <> cDisplayedField THEN
  DO:
    {set DataValue ?}.   
    hLookup:SCREEN-VALUE = hDynLookupBuf:BUFFER-FIELD('cScreenValue':U):BUFFER-VALUE.
  END.
  ELSE DO:
    {get DataValue cKeyFieldValue}.
    hLookup:SCREEN-VALUE = cKeyFieldValue.
  END.
END.

&SCOPED-DEFINE xp-assign
{set DisplayValue hLookup:INPUT-VALUE} /* avoid leave trigger code */
/* Update key field */
{get DataValue cKeyFieldValue}.
&UNDEFINE xp-assign

iField = LOOKUP(cKeyField, cFields).
IF iField > 0 AND NUM-ENTRIES(cFoundValues, CHR(1)) >= iField THEN
  cKeyFieldValue = ENTRY(iField, cFoundValues, CHR(1)).
ELSE
  cKeyFieldValue = "":U.     /* blank out as it is invalid */

IF (cFoundValues <> "":U AND cFoundValues <> ?) OR lBlankOnNotAvail THEN 
  {set DataValue cKeyFieldValue}.

/* store rowident property - rowids of current record */
{set RowIdent hDynLookupBuf:BUFFER-FIELD('cRowIdent':U):BUFFER-VALUE}.

/* Update linked fields */
/*IF cViewerLinkedFields <> "":U AND VALID-HANDLE(hContainer) THEN*/
cAllFieldHandles = DYNAMIC-FUNCTION("getAllFieldHandles":U IN hContainer).
/*IF cAllFieldHandles <> "":U AND cViewerLinkedFields <> "":U THEN*/

DO iLoop = 1 TO NUM-ENTRIES(cAllFieldHandles):
  hWidget = WIDGET-HANDLE(ENTRY(iLoop, cAllFieldHandles)).
  IF VALID-HANDLE(hWidget) THEN
  DO:
    /* Check for child Lookups or Combos and flag them for data retrieval */
    IF hWidget:TYPE = "PROCEDURE":U AND {fn getObjectType hWidget} = "SmartDataField":U THEN
    DO:
      IF {fnarg instanceOf 'DynCombo':U hWidget} THEN
        cDynComboList = IF cDynComboList = "":U 
                          THEN STRING(hWidget)
                          ELSE cDynComboList + ",":U + STRING(hWidget).
    END.
    ELSE IF CAN-QUERY(hWidget, "NAME":U) THEN 
    DO:
      iField = LOOKUP(hWidget:NAME, cViewerLinkedWidgets).
      IF iField > 0 THEN
      DO: /* it's a linked widget and its value should be in cFoundValues */
        ASSIGN
          cField = ENTRY(iField, cViewerLinkedFields)
          iField = LOOKUP(cField, cFields).
        IF iField > 0 THEN
          ASSIGN
            cValue = IF NUM-ENTRIES(cFoundValues,CHR(1)) >= iField THEN
                       ENTRY(iField,cFoundValues, CHR(1))
                     ELSE /* ADDED: check on datatype of widget */
                       IF hWidget:DATA-TYPE = "LOGICAL" THEN "NO":U ELSE "":U.
            hWidget:SCREEN-VALUE = cValue NO-ERROR.
      END.  /* iField > 0  */
    END.
  END.  /* VALID-HANDLE(hWidget) */
END.

IF cDynComboList <> "":U THEN 
DO iLoop = 1 TO NUM-ENTRIES(cDynComboList):
  hCombo = WIDGET-HANDLE(ENTRY(iLoop, cDynComboList)).
  IF VALID-HANDLE(hCombo) THEN 
  DO:
    cParentFields = DYNAMIC-FUNCTION("getParentField":U IN hCombo) NO-ERROR.
    IF LOOKUP(cFieldName,cParentFields) > 0 THEN 
    DO:
      hComboField = DYNAMIC-FUNCTION("getComboHandle":U IN hCombo) NO-ERROR.
      /* Check if the combo has been initialized */
      IF CAN-QUERY(hComboField,"LIST-ITEM-PAIRS":U) THEN 
      DO:
        cComboValue = DYNAMIC-FUNCTION("getDataValue" IN hCombo).
        RUN refreshChildDependancies IN hCombo (cFieldName).
        DYNAMIC-FUNCTION("setDataValue" IN hCombo, cComboValue).
      END.
    END.
  END.
END.

PUBLISH "lookupDisplayComplete":U FROM  hContainer 
        (INPUT cFields,        /* CSV of fields specified */
         INPUT cFoundValues,  /* CHR(1) delim list of all the values of the above fields */
         INPUT cKeyFieldValue,             /* the key field value of the selected record */
         INPUT TARGET-PROCEDURE            /* Handle to lookup - use to determine which lookup has been left */
         ). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-oldPrepareQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE oldPrepareQuery Procedure 
PROCEDURE oldPrepareQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       This is a temporary dumping place for OLD code to support the 
               old Lookup API. Do not override or call this procedure. 
               IT WILL BE REMOVED when the old API is no longer supported.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcDisplayValue   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcKeyValue       AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcMode           AS CHARACTER NO-UNDO.

DEFINE VARIABLE cDisplayedField         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDisplayDataType        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewQuery               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE cKeyDataType            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQueryTables            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentFilterQuery      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.
DEFINE VARIABLE cKeyField               AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get containerSource hContainer}
  {get KeyField cKeyField}
  {get DisplayedField cDisplayedField}
  {get DisplayDataType cDisplayDataType}
  {get KeyDataType cKeyDataType}
  {get QueryTables cQueryTables}.
  &UNDEFINE xp-assign

  /* lookup entered screen value */
  IF pcKeyValue = "":U AND pcDisplayValue <> "":U THEN 
  DO:
    CASE cDisplayDataType:
      WHEN "CHARACTER":U THEN
        /* Set up where clause for key field equal to current value of key field */
        cNewQuery = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                                     cDisplayedField,
                                     pcDisplayValue,
                                     cDisplayDataType,
                                     "BEGINS":U,
                                     ?,
                                     ?).
      WHEN "LOGICAL":U THEN /* Don't think there will be one like this - just incase */
        /* Set up where clause for key field equal to current value of key field */
        cNewQuery = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                                     cDisplayedField,
                                     pcDisplayValue,
                                     cDisplayDataType,
                                     "=":U,
                                     ?,
                                     ?).
      OTHERWISE DO:
        /* Set up where clause for key field equal to current value of key field */
        cNewQuery = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                                     cDisplayedField,
                                     pcDisplayValue,
                                     cDisplayDataType,
                                     ">=":U,
                                     ?,
                                     ?).
        cNewQuery = DYNAMIC-FUNCTION("newWhereClause" IN TARGET-PROCEDURE,
                                     (IF LOOKUP(ENTRY(1,cDisplayedField,".":U),cQueryTables) > 0 
                                        THEN ENTRY(LOOKUP(ENTRY(1,cDisplayedField,".":U),cQueryTables),cQueryTables) 
                                        ELSE ENTRY(NUM-ENTRIES(cQueryTables),cQueryTables)),
                                     (cDisplayedField + " <= '" + pcDisplayValue + "'"),
                                     cNewQuery,
                                     "AND":U).
      END.
    END CASE.
  END.
  ELSE DO:
    /* Set up where clause for key field equal to current value of key field */
    cNewQuery = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                                 cKeyField,
                                 pcKeyValue,
                                 cKeyDataType,
                                 "=":U,
                                 ?,
                                 ?).
  END.

  IF pcMode = "AssignNewValue":U THEN
    {set DataValue pcKeyValue}.

  /* Set Parent-Child filter */
  RUN returnParentFieldValues IN TARGET-PROCEDURE (OUTPUT cParentFilterQuery).
  IF cParentFilterQuery <> "":U THEN 
  DO:
    IF NUM-ENTRIES(cParentFilterQuery,"|":U) > 1 AND 
       NUM-ENTRIES(cQueryTables) > 1 THEN 
    DO:
      DO iLoop = 1 TO NUM-ENTRIES(cParentFilterQuery,"|":U):
        IF TRIM(ENTRY(iLoop,cParentFilterQuery,"|":U)) <> "":U THEN
          cNewQuery = DYNAMIC-FUNCTION("newWhereClause" IN TARGET-PROCEDURE,
                                       ENTRY(iLoop,cQueryTables),
                                       ENTRY(iLoop,cParentFilterQuery,"|":U),
                                       cNewQuery,
                                       "AND":U).
      END.
    END.
    ELSE
      cNewQuery = DYNAMIC-FUNCTION("newWhereClause" IN TARGET-PROCEDURE,
                                   ENTRY(NUM-ENTRIES(cQueryTables),cQueryTables),
                                   cParentFilterQuery,
                                   cNewQuery,
                                   "AND":U).
  END.

  /* Update query into temp-table */
  RUN oldUpdateTable IN TARGET-PROCEDURE
                   (cNewQuery,          /* cForEach */
                    "":U,               /* cFoundDataValues */
                    "":U,               /* cRowIdent */
                    TRUE,               /* lRefresh */
                    FALSE,              /* lMoreFound */
                    (IF pcMode = "LeaveLookup":U 
                       THEN pcDisplayValue ELSE ?)   /* cScreenValue */
                    ).          
  
  IF VALID-HANDLE(gshAstraAppserver) THEN 
    RUN adm2/lookupqp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttLookup,
                                              INPUT-OUTPUT TABLE ttDCombo,
                                              INPUT "":U,
                                              INPUT "":U,
                                              INPUT hContainer).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-oldUpdateTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE oldUpdateTable Procedure 
PROCEDURE oldUpdateTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       This is a temporary dumping place for OLD code to support the 
               old Lookup API. Do not override or call this procedure. 
               IT WILL BE REMOVED when the old API is no longer supported.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcQuery     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcValues    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcRowIdent  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER plRefresh   AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER plMore      AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER pcScreen    AS CHARACTER NO-UNDO.

DEFINE VARIABLE cKeyDataType            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldName              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQueryTables            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLinkedFieldDataTypes   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDisplayDataType        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPhysicalTableNames     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTempTableNames         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lPopupOnAmbiguous       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lPopupOnUniqueAmbiguous AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lUseCache               AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cKeyField               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDisplayedField         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cViewerLinkedFields     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get containerSource hContainer}
  {get PopupOnAmbiguous lPopupOnAmbiguous}
  {get PopupOnUniqueAmbiguous lPopupOnUniqueAmbiguous}
  {get UseCache lUseCache}
  {get KeyDataType cKeyDataType}
  {get FieldName cFieldName}
  {get QueryTables cQueryTables}
  {get LinkedFieldDataTypes cLinkedFieldDataTypes}
  {get DisplayDataType cDisplayDataType}
  {get PhysicalTableNames cPhysicalTableNames}
  {get KeyField cKeyField}
  {get DisplayedField cDisplayedField}
  {get ViewerLinkedFields cViewerLinkedFields}
  {get TempTables cTempTableNames}.
  &UNDEFINE xp-assign
    
    /* Update query into temp-table */
    FIND FIRST ttLookup
         WHERE ttLookup.hWidget = TARGET-PROCEDURE
           AND ttLookup.hViewer = hContainer
           AND ttLookup.cWidgetName = cFieldName
         NO-ERROR.
    IF NOT AVAILABLE ttLookup THEN CREATE ttLookup.

    ASSIGN
      ttLookup.hWidget             = TARGET-PROCEDURE
      ttLookup.hViewer             = hContainer 
      ttLookup.cWidgetName         = cFieldName
      ttLookup.cWidgetType         = cKeyDataType
      ttLookup.cBufferList         = cQueryTables
      ttLookup.cPhysicalTableNames = cPhysicalTableNames
      ttLookup.cTempTableNames     = cTempTableNames
      ttLookup.lPopupOnAmbiguous   = lPopupOnAmbiguous
      ttLookup.lPopupOnUniqueAmbiguous = lPopupOnUniqueAmbiguous
      ttLookup.cFieldList          = cKeyField + ",":U + cDisplayedField + 
                                     ",":U + cViewerLinkedFields
      ttLookup.cDataTypeList       = cKeyDataType + ",":U + cDisplayDataType + 
                                     ",":U + cLinkedFieldDataTypes
      ttLookup.lUseCache           = lUseCache
      ttLookup.cForEach            = pcQuery    WHEN pcQuery <> ?
      ttLookup.cFoundDataValues    = pcValues   WHEN pcValues <> ?    
      ttLookup.cRowIdent           = pcRowIdent WHEN pcRowIdent <> ?
      ttLookup.lRefreshQuery       = plRefresh  WHEN plRefresh <> ?
      ttLookup.cScreenValue        = pcScreen   WHEN pcScreen <> ?
      ttLookup.lMoreFound          = plMore     WHEN plMore <> ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareField Procedure 
PROCEDURE prepareField :
/*------------------------------------------------------------------------------
  Purpose:     To Determine if the field values required by the Lookup are
               available by the Lookup container's Data Source.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE hViewer                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE cKeyField               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldName              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyFieldValue          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyDataType            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewQuery               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDataSource             AS HANDLE     NO-UNDO.
DEFINE VARIABLE lLocal                  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lModified               AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hField                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE cDisplayedField         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQueryTables            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hVar                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE cDSN                    AS CHARACTER  NO-UNDO.
/* the Viewer's 'stripLookupFields' should be moved here */
  
   &SCOPED-DEFINE xp-assign
   {get ContainerSource hViewer}
   {get LocalField lLocal}
   {get FieldName cFieldName}
   {get DataModified lModified} 
   {get FieldHandle hField}
   .
   &UNDEFINE xp-assign

    IF lModified THEN
    DO:
      cNewQuery = {fnarg buildSearchQuery hField:INPUT-VALUE}.
      RUN notifyChildFields IN TARGET-PROCEDURE('prepare':U).
    END.
    ELSE DO: 
      IF NOT lLocal AND VALID-HANDLE(hViewer) THEN
        {get DataSource hDataSource hViewer}.
    
      IF VALID-HANDLE(hDataSource) THEN 
      DO:
        /* check if the DataSource is an SBO */
        {get MasterDataObject hVar hDataSource} NO-ERROR.      
        IF VALID-HANDLE(hVar) THEN
        DO: 
          /* if this viewer is constructed from an SBO the fields are already qualified */
          IF NOT INDEX(cFieldName, ".":U) > 0 THEN
          DO:
            {get DataSourceNames cDSN hViewer}.
            IF cDSN > "":U THEN
              cFieldName = cDSN + ".":U + cFieldName.
          END.
        END.
        cKeyFieldValue = DYNAMIC-FUNCTION("ColumnValue":U IN hDataSource, cFieldName).
      END.
      ELSE 
        {get DataValue cKeyFieldValue}.

      cNewQuery = {fnarg buildFieldQuery cKeyFieldValue}.
    END.
    {set QueryString cNewQuery}.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionObject Procedure 
PROCEDURE repositionObject :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will reposition the lookup fill-in and it's label
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdRow    AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdColumn AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE hLabelHandle    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLabelLength    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hFrame          AS HANDLE     NO-UNDO.

  RUN SUPER (INPUT pdRow, INPUT pdColumn).

  {get LabelHandle hLabelHandle}.

  IF NOT VALID-HANDLE(hLabelHandle) THEN
    RETURN.

  IF TRIM(hLabelHandle:SCREEN-VALUE) = "":U THEN
    RETURN.

  {get ContainerHandle hFrame}.

  iLabelLength = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(hLabelHandle:SCREEN-VALUE + " ":U, hFrame:FONT).

  ASSIGN
      hLabelHandle:X            = hFrame:X - iLabelLength
      hLabelHandle:Y            = hFrame:Y
      hLabelHandle:WIDTH-PIXELS = iLabelLength
      .

  RETURN. 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose: Resize the Lookup      
  Parameters:  INPUT pidHeight decimal New height of component 
               INPUT pidWidth decimal New widtht of component.
  Notes:  The procedure deletes the current widget,
          Resizes the frame and recreates the widget.  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pidHeight AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pidWidth  AS DECIMAL NO-UNDO.

  DEFINE VARIABLE hFrame        AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hLookup       AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hButton       AS HANDLE   NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ContainerHandle hFrame}
  {get LookupHandle    hLookup}
  {get ButtonHandle    hButton}.
  &UNDEFINE xp-assign

  ASSIGN hFrame:SCROLLABLE            = TRUE
         hFrame:WIDTH-CHARS           = pidWidth
         hFrame:HEIGHT-CHARS          = pidHeight
         hFrame:VIRTUAL-WIDTH-CHARS   = hFrame:WIDTH-CHARS
         hFrame:VIRTUAL-HEIGHT-CHARS  = hFrame:HEIGHT-CHARS
         hFrame:SCROLLABLE            = FALSE
         .
  IF VALID-HANDLE(hLookup) THEN
    ASSIGN
        hLookup:WIDTH-PIXELS = hFrame:WIDTH-PIXELS - 24
        hButton:X            = hLookup:X + hLookup:WIDTH-PIXELS + (if SESSION:WINDOW-SYSTEM eq 'MS-WINXP' then 0 else 4)
        .

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowSelected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowSelected Procedure 
PROCEDURE rowSelected :
/*------------------------------------------------------------------------------
  Purpose:     Publish a lookupcomplete event in the container allowing deveopers
               to perform some action when a row is selected from the browser.
  Parameters:  input comma delimited list of found field names
               input chr(1) delimited list of corresponding field values
               input comma delimited list of rowids of query buffers (rowident)
  Notes:       This will not fire if the field is changed manually in the fill-in,
               so you will need to use lookupleave as well to trap for this.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAllFields  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcValues     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcRowIdent   AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cKeyField               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewerLinkedFields     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLookup                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cOldDisplayValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewDisplayValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldKeyValue            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewKeyValue            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnValues           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnNames            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iField                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hDynLookupBuf           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cScreenValue            AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get containerSource hContainer}
  {get LookupHandle hLookup}
  {get DataValue cOldKeyValue}
  {get DisplayValue cOldDisplayValue}
  {get KeyField cKeyField}
  {get DisplayedField cDisplayedField}
  {get ViewerLinkedFields cViewerLinkedFields}.
  &UNDEFINE xp-assign
  
  /* Extract the return values for all Lookup fields */
  cColumnNames = cKeyField + ",":U + cDisplayedField + ",":U + cViewerLinkedFields.
  DO iLoop = 1 TO NUM-ENTRIES(cColumnNames):
    ASSIGN 
      cField = ENTRY(iLoop, cColumnNames)
      iField = LOOKUP(cField, pcAllFields)
      cValue = "":U.
    IF iField > 0 THEN
      cValue = ENTRY(iField, pcValues, CHR(1)).

    cColumnValues = cColumnValues + (IF iLoop = 1 THEN "":U ELSE CHR(1)) + cValue.
  END.

  ASSIGN
    cNewKeyValue     = ENTRY(1, cColumnValues, CHR(1))
    cNewDisplayValue = ENTRY(2, cColumnValues, CHR(1)).

  /* Update TT record and display with new values */
  IF glUseNewAPI THEN DO:
    hDynLookupBuf = {fn returnLookupBuffer}.
    
    ASSIGN
      hLookup:SCREEN-VALUE = cNewDisplayValue 
      cScreenValue         = hLookup:INPUT-VALUE.

    IF hDynLookupBuf:AVAILABLE THEN
      ASSIGN
        hdynLookupBuf:BUFFER-FIELD('cFoundDataValues':U):BUFFER-VALUE = cColumnValues
        hdynLookupBuf:BUFFER-FIELD('cRowIdent':U):BUFFER-VALUE = pcRowIdent
        hdynLookupBuf:BUFFER-FIELD('lRefreshQuery':U):BUFFER-VALUE = FALSE
        hDynLookupBuf:BUFFER-FIELD('cScreenValue':U):BUFFER-VALUE = cScreenValue.
    {set DataModified TRUE}.
    RUN prepareField IN TARGET-PROCEDURE.
    RUN displayField IN TARGET-PROCEDURE.
    RUN notifyChildFields IN TARGET-PROCEDURE ('Fetch':U). 
  END.
  ELSE DO:
    /* Update query into temp-table */
    RUN oldUpdateTable IN TARGET-PROCEDURE
                     (?,                  /* cForEach */
                      cColumnValues,      /* cFoundDataValues */
                      pcRowIdent,         /* cRowIdent */
                      TRUE,               /* lRefresh */
                      FALSE,              /* lMoreFound */
                      ?).                 /* cScreenValue */
    RUN displayLookup IN TARGET-PROCEDURE (INPUT TABLE ttLookup).        
  END.

  /* Focus back in fill-in */
  RUN applyEntry IN TARGET-PROCEDURE (hLookup:NAME).

  /* get focus back in correct window */
  DEFINE VARIABLE hWindow AS HANDLE NO-UNDO.
  {get ContainerHandle hWindow hContainer}.
   DO WHILE (VALID-HANDLE(hWindow) AND 
     hWindow:TYPE NE "WINDOW":U):
       hWindow = hWindow:PARENT.
   END.
  IF hWindow:TYPE = "WINDOW":U THEN
    CURRENT-WINDOW = hWindow.

  PUBLISH "lookupComplete":U FROM hContainer (INPUT cColumnNames,        /* CSV of fields specified */
                                              INPUT cColumnValues,       /* CHR(1) delim list of all the values of the above columns */
                                              INPUT cNewKeyValue,        /* the key field value of the selected record */
                                              INPUT cNewDisplayValue,    /* the value displayed on screen (may be the same as the key field value ) */
                                              INPUT cOldDisplayValue,    /* the old value displayed on screen (may be the same as the key field value ) */
                                              INPUT YES,                 /* YES = lookup browser used, NO = manual value entered */
                                              INPUT TARGET-PROCEDURE     /* Handle to lookup - use to determine which lookup has been left */
                                             ). 
  IF cNewDisplayValue <> cOldDisplayValue OR 
     (cNewDisplayValue = cOldDisplayValue AND /* Resolves Issue 1567 on IssueZilla */
      cNewKeyValue <> cOldKeyValue) 
  THEN
    RUN valueChanged IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-shortCutKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE shortCutKey Procedure 
PROCEDURE shortCutKey :
/*------------------------------------------------------------------------------
  Purpose:     We could trap a keypress in here and auto-display single value
               found if only 1 is found, by going direct to query.
  Parameters:  <none>
  Notes:       Use LAST-EVENT:FUNCTION for testing keypress.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBrowseKeys AS CHAR  NO-UNDO.

  /* Check to see if the Lookup button is enabled. If it is not,
     it probably means that the programmer did not want to perform a lookup
     and therefore ran the disableButton procedure. In this case, do not open
     the browser.

     *** NOTE: Because the standard behaviour would enable the browser again
        -----  no RUN SUPER will be done!!! */
  DEFINE VARIABLE hButton AS HANDLE NO-UNDO.

  {get ButtonHandle hButton}.

  IF hButton:SENSITIVE = TRUE THEN
  DO:
    RUN initializeBrowse IN TARGET-PROCEDURE.
    RETURN NO-APPLY.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-translateBrowseColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE translateBrowseColumns Procedure 
PROCEDURE translateBrowseColumns :
/*------------------------------------------------------------------------------
  Purpose:     Translates lookup and filter browse columns.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcObjectName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phBrowseHandle  AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE dCurrentLanguageObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cOriginalLabel      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTranslatedLabel    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOriginalTooltip    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTranslatedTooltip  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBrowseColumn       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cWidgetType         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWidgetName         AS CHARACTER  NO-UNDO.
  define variable cBrowseFields       as character no-undo.
  define variable iCnt                as integer no-undo.
  define variable cColumn             as character no-undo.

    /* We don't always needs these. */
    if phBrowseHandle:name eq 'LookupDataBrowser':u then
        {get BrowseFields cBrowseFields}.
    
  /* Get the current language */
  IF VALID-HANDLE(gshSessionManager) THEN
    dCurrentLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                   INPUT "CurrentLanguageObj":U,
                                                   INPUT NO)) NO-ERROR.
  
  IF NOT VALID-HANDLE(phBrowseHandle) THEN
    RETURN.
  hBrowseColumn = phBrowseHandle:FIRST-COLUMN.
  
  IF NOT VALID-HANDLE(hBrowseColumn) THEN
    RETURN.
  
  iCnt = 0.
  DO WHILE VALID-HANDLE(hBrowseColumn):
    ASSIGN cWidgetType = "BROWSE":U
           cWidgetName = hBrowseColumn:NAME
           iCnt = iCnt + 1
           NO-ERROR.
    
    IF CAN-QUERY(hBrowseColumn,"TABLE":U) AND
       hBrowseColumn:TABLE <> "RowObject":U THEN
      cWidgetName =  hBrowseColumn:TABLE + ".":U + cWidgetName.
    
    /* Find translations on exact column names. This will
       be "Table_Field" for DB columns. */
    IF VALID-HANDLE(gshTranslationManager) THEN
      RUN getTranslation IN gshTranslationManager
          ( INPUT  dCurrentLanguageObj,
            INPUT  pcObjectName,
            INPUT  cWidgetType,
            INPUT  cWidgetName,
            INPUT  0,
            OUTPUT cOriginalLabel,
            OUTPUT cTranslatedLabel,
            OUTPUT cOriginalTooltip,
            OUTPUT cTranslatedTooltip).
    
    /* If no specific translation was found for this column,
       nn this object, and this is the data browser for the lookup
       (not the filter), then look for global translations for 
       the underlying column. */
    if phBrowseHandle:name eq 'LookupDataBrowser':u and
      (cTranslatedLabel eq ? or cTranslatedLabel eq '':u) then
    do:
        cColumn = ?.
        cColumn = entry(iCnt, cBrowseFields) no-error.
        
        if cColumn ne ? and
           replace(cColumn, '.':u, '_':u) eq cWidgetName then
            cWidgetName = entry(2, cColumn, '.':u).
        
        IF VALID-HANDLE(gshTranslationManager) THEN
          RUN getTranslation IN gshTranslationManager
              ( INPUT  dCurrentLanguageObj,
                INPUT  '':u,    /* pcObjectName */
                INPUT  '':u,    /* cWidgetType */
                INPUT  cWidgetName,
                INPUT  0,
                OUTPUT cOriginalLabel,
                OUTPUT cTranslatedLabel,
                OUTPUT cOriginalTooltip,
                OUTPUT cTranslatedTooltip).
    end.    /* translations not found */
        
    IF cTranslatedLabel <> "":U AND
       cTranslatedLabel <> ? THEN
      hBrowseColumn:LABEL = cTranslatedLabel.
    
    hBrowseColumn = hBrowseColumn:NEXT-COLUMN.
  END.    /* browser column loop */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-valueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChanged Procedure 
PROCEDURE valueChanged :
/*------------------------------------------------------------------------------
  Purpose: Make sure the SmartDataViewer  container knows that this value has
           changed.      
  Parameters:  <none>
  Notes:    Defined as a PERSISTENT value-changed trigger in the dynamic-widget    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLookup     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.

  {get LookupHandle hLookup}.
  
  IF VALID-HANDLE(hLookup) AND hLookup:SCREEN-VALUE = ? THEN
  DO:
    /* Fix for issue #7076 */
    hLookup:SCREEN-VALUE = "":U.
    RETURN NO-APPLY.
  END.
  {set DataModified YES}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject Procedure 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose: Make sure the label is viewed     
  Parameters:  <none>
  Notes:   For sizing reasons, the label is not really a part of the object,
           but added as a text widget to the parent frame.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLabel AS HANDLE NO-UNDO.

  {get LabelHandle hLabel}.

  IF VALID-HANDLE(hLabel) THEN 
    hLabel:HIDDEN = FALSE.

  RUN SUPER.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-buildFieldQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildFieldQuery Procedure 
FUNCTION buildFieldQuery RETURNS CHARACTER
  ( pcValue AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the query with search criteria on the DisplayedField.                
  Parameters:  pcValue - the value to use in the DisplayedField expression
  Notes:       The operator is NOT a parameter to this function as the very 
               purpose of this function is to allow consistent control over 
               the single field search operator, either by an override and/or 
               by a property.               
             - The fieldname is not passed since the DisplayedField is the 
               assumed searchfield, but future versions may very well be 
               extended to operate on current search field/sort field, which 
               then also would be a property.    
------------------------------------------------------------------------------*/
DEFINE VARIABLE cNewQuery         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyField         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyDataType      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataType         AS CHARACTER  NO-UNDO.
   
 &SCOPED-DEFINE xp-assign
 {get KeyField cKeyField}
 {get KeyDataType cDataType} 
 &UNDEFINE xp-assign
  
 cNewQuery = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                               cKeyField,
                               pcValue,
                               cKeyDataType,
                               "=":U,
                               ?, /* buildQuery is basis (if new api)*/
                               ?) .
  RETURN cNewQuery.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildSearchQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildSearchQuery Procedure 
FUNCTION buildSearchQuery RETURNS CHARACTER
  ( pcValue AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the query with search criteria on the DisplayedField.                
  Parameters:  pcValue - the value to use in the DisplayedField expression
  Notes:       The operator is NOT a parameter to this function as the very 
               purpose of this function is to allow consistent control over 
               the single field search operator, either by an override and/or 
               by a property.               
             - The fieldname is not passed since the DisplayedField is the 
               assumed searchfield, but future versions may very well be 
               extended to operate on current search field/sort field, which 
               then also would be a property.    
------------------------------------------------------------------------------*/
DEFINE VARIABLE cNewQuery               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDisplayedField         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataType               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQueryTables            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField                  AS HANDLE     NO-UNDO.
   
 &SCOPED-DEFINE xp-assign
 {get DisplayedField cDisplayedField}
 {get DisplayDataType cDataType} 
 {get LookupHandle hField}
 {get QueryTables cQueryTables}.
 &UNDEFINE xp-assign
  /* Set up where clause for displayfield and value */
  CASE cDataType:
     WHEN 'CHARACTER':U THEN   
       cNewQuery = DYNAMIC-FUNCTION('newQueryString':U IN target-procedure,
                                     cDisplayedField,
                                     pcValue,
                                     cDataType,
                                     "BEGINS":U,
                                     ?,
                                     ?).
     WHEN 'LOGICAL':U THEN
        cNewQuery = DYNAMIC-FUNCTION('newQueryString':U IN target-procedure,
                                     cDisplayedField,
                                     pcValue,
                                     cDataType,
                                     "=":U,
                                     ?,
                                     ?).
      OTHERWISE DO:
        cNewQuery = DYNAMIC-FUNCTION('newQueryString':U IN target-procedure,
                                       cDisplayedField,
                                       pcValue,
                                       cDataType,
                                       ">=":U,
                                       ?,
                                       ?).
        cNewQuery = DYNAMIC-FUNCTION("newWhereClause" IN target-procedure,
                                     (IF LOOKUP(ENTRY(1,cDisplayedField,".":U),cQueryTables) > 0 
                                        THEN ENTRY(LOOKUP(ENTRY(1,cDisplayedField,".":U),cQueryTables),cQueryTables) 
                                        ELSE ENTRY(NUM-ENTRIES(cQueryTables),cQueryTables)),
                                      (cDisplayedField + " <= '" + pcValue + "'"),
                                      cNewQuery,
                                      "AND":U).

      END.
  END CASE.
  
  RETURN cNewQuery.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createLabel Procedure 
FUNCTION createLabel RETURNS HANDLE
  (pcLabel AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose   : Create the label of the Lookup 
 Description:         The label are added to the parent frame  
    Notes   : This function is separated in order to be able to create 
               the label in design-mode.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLabel        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iLabelLength  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hParentFrame  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFrame        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lLabels       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lVisible      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hLookup       AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get LabelHandle hLabel}
  {get Labels lLabels}
  {get HideOnInit lVisible}
  {get LookupHandle hLookup}
  {get ContainerHandle hFrame}.
  &UNDEFINE xp-assign

  IF NOT lLabels THEN
    pcLabel = "":U.

  IF VALID-HANDLE(hLabel) THEN
  DO:
     /* endmove passes blank value, if so just copy the old value */ 
    IF pcLabel = "":U THEN 
      pcLabel = RIGHT-TRIM(hLabel:SCREEN-VALUE,":":U).
    DELETE WIDGET hLABEL.
  END.   
  ELSE IF pcLabel = "":U THEN
     RETURN ?.
  
   hParentFrame = hFrame:FRAME.
  
   iLabelLength = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(pcLabel + ": ":U, hFrame:FONT).
  
   CREATE TEXT hLabel
     ASSIGN FRAME                 = hParentFrame
            X                     = hFrame:X - iLabelLength
            Y                     = hFrame:Y
            HIDDEN                = TRUE
            WIDTH-PIXELS          = iLabelLength
            FORMAT                = "x(256)"
            SCREEN-VALUE          = pcLabel + ":":U
            HEIGHT-PIXELS         = SESSION:PIXELS-PER-ROW 
            .  
   IF hLabel:COL <= 0 THEN
     hLabel:COL = 1.

   {set LabelHandle hLabel}. 
   IF DYNAMIC-FUNCTION('getUseWidgetID':U IN TARGET-PROCEDURE) THEN
     RUN assignLabelWidgetID IN TARGET-PROCEDURE.

   ASSIGN hLabel:HIDDEN = lVisible.
   hLookup:SIDE-LABEL-HANDLE = hLabel.

  RETURN hLabel. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyLookup Procedure 
FUNCTION destroyLookup RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Cleanup all dynamicly created objects. 
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hLookup       AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hLabel        AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hButton       AS HANDLE   NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get LookupHandle hLookup}
  {get LabelHandle hLabel}
  {get ButtonHandle hButton}.
  &UNDEFINE xp-assign

  IF VALID-HANDLE(hLookup) THEN DELETE OBJECT hLookup NO-ERROR.
  IF VALID-HANDLE(hLabel)  THEN DELETE OBJECT hLabel NO-ERROR.
  IF VALID-HANDLE(hButton) THEN DELETE OBJECT hButton NO-ERROR.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBlankOnNotAvail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBlankOnNotAvail Procedure 
FUNCTION getBlankOnNotAvail RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lValue AS LOGICAL NO-UNDO.
  {get BlankOnNotAvail lValue}.
  RETURN lValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseFieldDataTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseFieldDataTypes Procedure 
FUNCTION getBrowseFieldDataTypes RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get BrowseFieldDataTypes cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseFieldFormats) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseFieldFormats Procedure 
FUNCTION getBrowseFieldFormats RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get BrowseFieldFormats cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseFields Procedure 
FUNCTION getBrowseFields RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get BrowseFields cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseObject Procedure 
FUNCTION getBrowseObject RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the procedure handle of the object that has the pop up 
           browse  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hObject AS HANDLE     NO-UNDO.
  {get BrowseObject hObject}.
  RETURN hObject.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseTitle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseTitle Procedure 
FUNCTION getBrowseTitle RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get BrowseTitle cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColumnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getColumnFormat Procedure 
FUNCTION getColumnFormat RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Gets the browse column format override values
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get ColumnFormat cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColumnLabels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getColumnLabels Procedure 
FUNCTION getColumnLabels RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Gets the browse column label override values
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get ColumnLabels cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataValue Procedure 
FUNCTION getDataValue RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the datavalue   
    Notes: This is read by the SmartDataViewer when it collectChanges 
           if it encounters this PROCEDURE in the list of EnabledHandles and 
           the  DataModified property of this object equals TRUE. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLookup         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDisplayedField AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyDataType    AS CHARACTER  NO-UNDO.

  {get LookupHandle hLookup}.
  
  IF NOT VALID-HANDLE(hLookup) THEN
    RETURN ?. 

  /* This is to fix issue #6773
     When the user is in a lookup field and the value
     is changed and while still in the lookup field the
     save button is pressed, the leave event is never fired */
  IF VALID-HANDLE(FOCUS) AND
     FOCUS = hLookup AND 
     INDEX(PROGRAM-NAME(2),"collectChanges":U) > 0 THEN DO:
    glRecordBeingSaved = TRUE.
    APPLY "LEAVE":U TO hLookup.
      glRecordBeingSaved = FALSE.
  END.

  &SCOPED-DEFINE xp-assign
  {get KeyField cKeyField}
  {get DisplayedField cDisplayedField}.
  &UNDEFINE xp-assign

  IF cKeyField <> cDisplayedField THEN 
  DO:
      &SCOPED-DEFINE xpDataValue
      {get DataValue cDataValue}.
      &UNDEFINE xpDataValue
      {get KeyDataType cKeyDataType}.
      /* If the value is BLANK and the key data type is not CHARACTER, then
         FIX the data value */
      IF cDataValue = "":U AND
         cKeyDataType <> "CHARACTER":U THEN 
      DO:
        CASE cKeyDataType:
          WHEN "INTEGER" THEN
            ASSIGN cDataValue = "0":U.
          WHEN "INT64" THEN
            ASSIGN cDataValue = "0":U.
          WHEN "DECIMAL" THEN
            ASSIGN cDataValue = "0":U.
          WHEN "DATE" THEN
            ASSIGN cDataValue = "?":U.
          WHEN "DATETIME" THEN
            ASSIGN cDataValue = "?":U.
          WHEN "DATETIME-TZ" THEN
            ASSIGN cDataValue = "?":U.
          OTHERWISE          
            ASSIGN cDataValue = "":U.
        END CASE.
      END.

    RETURN cDataValue.
  END.
  ELSE
  DO:
    DEFINE VARIABLE cChar               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDisplayDataType    AS CHARACTER  NO-UNDO.
    
    cChar = hLookup:INPUT-VALUE.    
    IF NOT LENGTH(cChar) > 0 THEN
    DO:
      {get DisplayDataType cDisplayDataType}.
      CASE cDisplayDataType:
        WHEN "integer" THEN
          ASSIGN cChar = "0":U.
        WHEN "int64" THEN
          ASSIGN cChar = "0":U.
        WHEN "decimal" THEN
          ASSIGN cChar = "0":U.
        WHEN "date" THEN
          ASSIGN cChar = "?":U.
        WHEN "datetime" THEN
          ASSIGN cChar = "?":U.
        WHEN "datetime-tz" THEN
          ASSIGN cChar = "?":U.
        OTHERWISE          
          ASSIGN cChar = "":U.
      END CASE.
    END.
    RETURN cChar.
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldHandle Procedure 
FUNCTION getFieldHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Override to return the LookupHandle  
    Notes: The different sibling classes, like select and combo have all been 
           implemented with different names. This function is expected to 
           replace those in order to achieve polymorphism. 
         - Currently used by clearField.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField AS HANDLE     NO-UNDO.
  {get LookupHandle hField}.

  RETURN hField.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkedFieldDataTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLinkedFieldDataTypes Procedure 
FUNCTION getLinkedFieldDataTypes RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get LinkedFieldDataTypes cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkedFieldFormats) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLinkedFieldFormats Procedure 
FUNCTION getLinkedFieldFormats RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get LinkedFieldFormats cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLookupFilterValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLookupFilterValue Procedure 
FUNCTION getLookupFilterValue RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the filter value set.
    Notes:  
------------------------------------------------------------------------------*/

  
  RETURN gcLookupFilterValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLookupHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLookupHandle Procedure 
FUNCTION getLookupHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hValue AS HANDLE NO-UNDO.
  {get LookupHandle hValue}.
  RETURN hValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLookupImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLookupImage Procedure 
FUNCTION getLookupImage RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get LookupImage cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMaintenanceObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMaintenanceObject Procedure 
FUNCTION getMaintenanceObject RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get MaintenanceObject cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMaintenanceSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMaintenanceSDO Procedure 
FUNCTION getMaintenanceSDO RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get MaintenanceSDO cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMappedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMappedFields Procedure 
FUNCTION getMappedFields RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get MappedFields cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPopupOnAmbiguous) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPopupOnAmbiguous Procedure 
FUNCTION getPopupOnAmbiguous RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lValue AS LOGICAL NO-UNDO.
  
  &scoped-define xpPopupOnAmbiguous
  {get PopupOnAmbiguous lValue}.
  &undefine xpPopupOnAmbiguous
  
  RETURN lValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPopupOnNotAvail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPopupOnNotAvail Procedure 
FUNCTION getPopupOnNotAvail RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lValue AS LOGICAL NO-UNDO.
  {get PopupOnNotAvail lValue}.
  RETURN lValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPopupOnUniqueAmbiguous) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPopupOnUniqueAmbiguous Procedure 
FUNCTION getPopupOnUniqueAmbiguous RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lValue AS LOGICAL NO-UNDO.
  
  &scoped-define xpPopupOnUniqueAmbiguous
  {get PopupOnUniqueAmbiguous lValue}.
  &undefine xpPopupOnUniqueAmbiguous
  
  RETURN lValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowIdent Procedure 
FUNCTION getRowIdent RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get RowIdent cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowsToBatch Procedure 
FUNCTION getRowsToBatch RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iValue AS INTEGER NO-UNDO.
  {get RowsToBatch iValue}.
  RETURN iValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getViewerLinkedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getViewerLinkedFields Procedure 
FUNCTION getViewerLinkedFields RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get ViewerLinkedFields cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getViewerLinkedWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getViewerLinkedWidgets Procedure 
FUNCTION getViewerLinkedWidgets RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  
  &scoped-define xpViewerLinkedWidgets
  {get ViewerLinkedWidgets cValue}.
  &undefine xpViewerLinkedWidgets
  
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionDataSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION repositionDataSource Procedure 
FUNCTION repositionDataSource RETURNS LOGICAL PRIVATE
  ( pcValue AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  NOT IN USE 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNewQuery   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE     NO-UNDO.
  {get ContainerSource hContainer}.

  cNewQuery = {fnarg buildFieldQuery pcValue}.
  {set QueryString cNewQuery}.  
  RUN notifyChildFields IN TARGET-PROCEDURE('prepare':U).
  RUN retrieveData IN TARGET-PROCEDURE (hContainer).
  hBuffer = {fn returnLookupBuffer}.

  IF TRIM(hBuffer:BUFFER-FIELD('cFoundDataValues':U):BUFFER-VALUE) = "":U THEN
    RETURN FALSE.   /* NO RECORD FOUND. */
  IF hBuffer:BUFFER-FIELD('lMoreFound':U):BUFFER-VALUE = TRUE THEN
    RETURN ?.  /* AMBIGUOUS */
  ELSE 
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-returnLookupBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION returnLookupBuffer Procedure 
FUNCTION returnLookupBuffer RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF glUseNewAPI THEN
    RETURN {fnarg ReturnBuffer 'Lookup':U}.  /* let lookup.p return the handle */
  ELSE DO:
    FIND FIRST ttLookup WHERE ttLookup.hWidget = TARGET-PROCEDURE NO-ERROR.
    RETURN BUFFER ttLookup:HANDLE.
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBlankOnNotAvail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBlankOnNotAvail Procedure 
FUNCTION setBlankOnNotAvail RETURNS LOGICAL
  ( plValue AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set BlankOnNotAvail plValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseFieldDataTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseFieldDataTypes Procedure 
FUNCTION setBrowseFieldDataTypes RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set BrowseFieldDataTypes pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseFieldFormats) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseFieldFormats Procedure 
FUNCTION setBrowseFieldFormats RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set BrowseFieldFormats pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseFields Procedure 
FUNCTION setBrowseFields RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set BrowseFields pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseObject Procedure 
FUNCTION setBrowseObject RETURNS LOGICAL
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set BrowseObject phObject}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBrowseTitle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseTitle Procedure 
FUNCTION setBrowseTitle RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set BrowseTitle pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColumnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setColumnFormat Procedure 
FUNCTION setColumnFormat RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Set override formats for browse columns
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set ColumnFormat pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColumnLabels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setColumnLabels Procedure 
FUNCTION setColumnLabels RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Set override labels for browse columns
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set ColumnLabels pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataValue Procedure 
FUNCTION setDataValue RETURNS LOGICAL
  (pcValue AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Sets the datavalue   
Parameters: INPUT pcValue - Value that corresponds to the KeyField property      
    Notes: This is called by the SmartDataViewer if it encounters this PROCEDURE
           in the list of DisplayedHandles. 
           Note that the actual display of the fill-in (browser) is done in
           displayedFields.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLookup           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cKeyField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cKeyFieldValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lBlankOnNotAvail  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lInvalidValue     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cNewRecord        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDisplayField     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDisplayDataType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyDataType      AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DisplayDataType cDisplayDataType}
  {get KeyDataType cKeyDataType}
  {get containerSource hContainer}
  {get KeyFieldValue cKeyFieldValue}
  {get BlankOnNotAvail lBlankOnNotAvail}
  {get DisplayField lDisplayField}
  {get KeyField cKeyField}
  {get DisplayedField cDisplayedField}.
  &UNDEFINE xp-assign

  cNewRecord = "":U.
  IF VALID-HANDLE(hContainer) THEN
    {get NewRecord cNewRecord hContainer}. 

  IF pcValue = ? AND NOT lBlankOnNotAvail AND cNewRecord = "no":U AND cKeyField = cDisplayedField THEN
    ASSIGN pcValue        = cKeyFieldValue
           lInvalidValue  = FALSE.
  ELSE
    IF pcValue = ? AND NOT lBlankOnNotAvail AND cNewRecord = "no":U AND cKeyField <> cDisplayedField  THEN
      ASSIGN cKeyFieldValue = "":U
             pcValue        = "":U
             lInvalidValue  = TRUE.

  IF cNewRecord = "no":U THEN
  DO:
    &SCOPED-DEFINE xpDataValue
    {set DataValue pcValue}.
    &UNDEFINE xpDataValue
    {get LookupHandle hLookup}.
    IF VALID-HANDLE(hLookup) THEN
    DO:
      IF cKeyField = cDisplayedField AND lDisplayField 
                     AND (pcValue > "":U 
                          OR (pcValue = "":U AND NOT lInvalidValue)
                          ) THEN  
        ASSIGN hLookup:SCREEN-VALUE = pcValue.
      /* If the value is being set to blank and the current value is not blank or 
         the value being set is invalid and the key field is different from the 
         displayed field then the lookup's screen-value should be set to blank.  
         If the value is being set to blank and the current value is blank then 
         the lookup's screen-value should not be set to blank because blank is a 
         valid value and the displayed value should not be blanked */  
      ELSE DO:
        IF (pcValue = "":U AND 
             (cKeyFieldValue <> "":U OR (lInvalidValue AND cKeyField <> cDisplayedField))) OR
           (cKeyDataType NE "CHARACTER":U AND (pcValue = "0":U OR pcValue = ? OR pcValue = "?")) THEN
          ASSIGN hLookup:SCREEN-VALUE = "":U.
      END.
      {set DisplayValue hLookup:INPUT-VALUE}. /* avoid leave trigger code */
    END.
  END.
  ELSE
  DO: /* in an add - ensure lookup screen value is cleared */
      DEFINE VARIABLE pcKeyValue         AS CHARACTER  NO-UNDO.
      &SCOPED-DEFINE xpDataValue
      {get DataValue pcKeyValue}.
      &UNDEFINE xpDataValue
      {get LookupHandle hLookup}.
      {get newRecord cNewRecord hContainer}.

      IF cNewRecord <> "no":U AND
         pcValue <> "":U      AND 
         (IF cKeyDataType NE "CHARACTER":U THEN (pcValue <> "0":U) ELSE TRUE) AND 
         pcValue <> ? THEN
      DO: /* must be a reset operation or after a succesful save - reset value */
        &SCOPED-DEFINE xpDataValue
        {set DataValue pcValue}.
        &UNDEFINE xpDataValue
        IF VALID-HANDLE(hLookup) THEN
        DO:
          &SCOPED-DEFINE xp-assign
          {get KeyField cKeyField}
          {get DisplayedField cDisplayedField}.
          &UNDEFINE xp-assign
          IF cKeyField = cDisplayedField AND lDisplayField THEN  
            hLookup:SCREEN-VALUE = pcValue.
          {set DisplayValue hLookup:INPUT-VALUE}. /* avoid leave trigger code */
        END.
      END.

      /* clear values on add - once */
      IF (pcValue = "":U OR 
            (cKeyDataType NE "CHARACTER":U AND (pcValue = "0":U OR pcValue = ? OR pcValue = "?"))) 
        AND NOT lInvalidValue /*AND pcKeyValue <> "":U AND pcKeyValue <> "0":U*/ THEN
      DO:
        pcValue = "":U.
        &SCOPED-DEFINE xpDataValue
        {set DataValue pcValue}.
        &UNDEFINE xpDataValue
        IF VALID-HANDLE(hLookup) THEN
        DO:
          hLookup:SCREEN-VALUE = pcValue.
          {set DisplayValue hLookup:INPUT-VALUE}. /* avoid leave trigger code */
        END.
      END.
  END.
  
  {set Modify TRUE}.      
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayedField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisplayedField Procedure 
FUNCTION setDisplayedField RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hLB AS HANDLE NO-UNDO.

  hLB = DYNAMIC-FUNCT('returnLookupBuffer':U IN TARGET-PROCEDURE).
  IF hLB:AVAILABLE THEN
    hLB:BUFFER-FIELD('cFieldList':U):BUFFER-VALUE  = 
        {fn getKeyField} + "," + pcValue + "," + {fn getViewerLinkedFields}.

  RETURN SUPER(pcValue).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldHidden Procedure 
FUNCTION setFieldHidden RETURNS LOGICAL
  ( INPUT plHide AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Hide or view a lookup field
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLookup   AS HANDLE NO-UNDO.
  DEFINE VARIABLE hButton   AS HANDLE NO-UNDO.
  DEFINE VARIABLE hLabel    AS HANDLE NO-UNDO.
  DEFINE VARIABLE hFrame    AS HANDLE NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get LookupHandle hLookup}
  {get ContainerHandle hFrame}.
  &UNDEFINE xp-assign
  
  IF VALID-HANDLE(hLookup) THEN
  DO:
   &SCOPED-DEFINE xp-assign
   {get ButtonHandle hButton}
   {get LabelHandle hLabel}.
   &UNDEFINE xp-assign
  
   ASSIGN
     hButton:HIDDEN   = plHide
     hLookup:HIDDEN   = plHide
     hLabel:HIDDEN    = plHide
     hLookup:TAB-STOP = plHide = FALSE
     hFrame:HIDDEN    = plHide. 
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setKeyField Procedure 
FUNCTION setKeyField RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hLB AS HANDLE NO-UNDO.

  hLB = DYNAMIC-FUNCT('returnLookupBuffer':U IN TARGET-PROCEDURE).
  IF hLB:AVAILABLE THEN
    hLB:BUFFER-FIELD('cFieldList':U):BUFFER-VALUE  = 
        pcValue + "," + {fn getDisplayedField} + "," + {fn getViewerLinkedFields}.

  RETURN SUPER(pcValue).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLinkedFieldDataTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLinkedFieldDataTypes Procedure 
FUNCTION setLinkedFieldDataTypes RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set LinkedFieldDataTypes pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLinkedFieldFormats) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLinkedFieldFormats Procedure 
FUNCTION setLinkedFieldFormats RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set LinkedFieldFormats pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLookupFilterValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLookupFilterValue Procedure 
FUNCTION setLookupFilterValue RETURNS LOGICAL
  ( INPUT pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the filter value for the lookup browser
    Notes:  
------------------------------------------------------------------------------*/

  ASSIGN gcLookupFilterValue = pcValue.
  
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLookupHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLookupHandle Procedure 
FUNCTION setLookupHandle RETURNS LOGICAL
  ( phValue AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set LookupHandle phValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLookupImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLookupImage Procedure 
FUNCTION setLookupImage RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the Lookup button (binoculars) image file name
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set LookupImage pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMaintenanceObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMaintenanceObject Procedure 
FUNCTION setMaintenanceObject RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the lookup's logical object name to launch when allowing maintenance
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set MaintenanceObject pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMaintenanceSDO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMaintenanceSDO Procedure 
FUNCTION setMaintenanceSDO RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the lookup's SDO name to launch when allowing maintenance
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set MaintenanceSDO pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMappedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMappedFields Procedure 
FUNCTION setMappedFields RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set MappedFields pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPhysicalTableNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPhysicalTableNames Procedure 
FUNCTION setPhysicalTableNames RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the actual DB Tables names of buffers defined for the query
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
 &SCOPED-DEFINE ttfield cPhysicalTableNames 
 &SCOPED-DEFINE propvalue pcvalue
 {&setprop} 

 RETURN SUPER(pcValue).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPopupOnAmbiguous) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPopupOnAmbiguous Procedure 
FUNCTION setPopupOnAmbiguous RETURNS LOGICAL
  ( plValue AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
 &SCOPED-DEFINE ttfield lPopupOnAmbiguous 
 &SCOPED-DEFINE propvalue plvalue
 {&setprop} 

  &SCOPED-DEFINE xpPopupOnAmbiguous
  {set PopupOnAmbiguous plValue}.
  &UNDEFINE xpPopupOnAmbiguous
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPopupOnNotAvail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPopupOnNotAvail Procedure 
FUNCTION setPopupOnNotAvail RETURNS LOGICAL
  ( plValue AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpPopupOnNotAvail
  {set PopupOnNotAvail plValue}.
  &UNDEFINE xpPopupOnNotAvail
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPopupOnUniqueAmbiguous) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPopupOnUniqueAmbiguous Procedure 
FUNCTION setPopupOnUniqueAmbiguous RETURNS LOGICAL
  ( plValue AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
 &SCOPED-DEFINE ttfield lPopupOnUniqueAmbiguous
 &SCOPED-DEFINE propvalue plvalue
 {&setprop} 

  &SCOPED-DEFINE xpPopupOnUniqueAmbiguous
  {set PopupOnUniqueAmbiguous plValue}.
  &UNDEFINE xpPopupOnUniqueAmbiguous
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryTables Procedure 
FUNCTION setQueryTables RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
 &SCOPED-DEFINE ttfield cBufferList 
 &SCOPED-DEFINE propvalue pcvalue
 {&setprop}

 RETURN SUPER(pcValue).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRowIdent Procedure 
FUNCTION setRowIdent RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set RowIdent pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRowsToBatch Procedure 
FUNCTION setRowsToBatch RETURNS LOGICAL
  ( piValue AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set RowsToBatch piValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTempTables Procedure 
FUNCTION setTempTables RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the PLIP names of Temp Tables defined for the query
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE ttfield cTempTableNames
  &SCOPED-DEFINE propvalue pcValue
  {&setprop}

  RETURN SUPER(pcValue).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUseCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUseCache Procedure 
FUNCTION setUseCache RETURNS LOGICAL
  ( plValue AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE ttfield lUseCache
  &SCOPED-DEFINE propvalue plValue
  {&setprop}

  RETURN SUPER(plValue).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setViewerLinkedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setViewerLinkedFields Procedure 
FUNCTION setViewerLinkedFields RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
DEFINE VARIABLE hLB AS HANDLE NO-UNDO.

  &SCOPED-DEFINE xpViewerLinkedFields
  {set ViewerLinkedFields pcValue}.
  &UNDEFINE xpViewerLinkedFields
  
  hLB = DYNAMIC-FUNCT('returnLookupBuffer':U IN TARGET-PROCEDURE).
  IF hLB:AVAILABLE THEN
    hLB:BUFFER-FIELD('cFieldList':U):BUFFER-VALUE  = 
        {fn getKeyField} + "," + {fn getDisplayedField} + "," + pcValue.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setViewerLinkedWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setViewerLinkedWidgets Procedure 
FUNCTION setViewerLinkedWidgets RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  &scoped-define xpViewerLinkedWidgets
  {set ViewerLinkedWidgets pcValue}.
  &undefine xpViewerLinkedWidgets
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

