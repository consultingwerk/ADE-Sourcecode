&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*--------------------------------------------------------------------------
    File        : lookup.p
    Purpose     : Super procedure for Astra 2 lookup class.

    Syntax      : RUN start-super-proc("adm2/lookup.p":U).

    Modified    : 09/11/2000
                  Anthony Swindells, MIP
    
    Modified    : 09/25/2001         Mark Davies (MIP)
                  1. If the key field was an integer value and user left the
                     field, the value is not auto completed and did not launch
                     the browser. This was a result of defaulting to a 'BEGINS'
                     function in the query for all data types.
                  2. Remove References to KeyFieldValue and SavedScreenValue.
    Modified    : 09/29/2001        Mark Davies (MIP)
                  When using an SBO in a SDV and a lookup is put on a field
                  on the secondary SDO that also exists in the master or other
                  SDO, the incorrect value is being displayed in the lookup.
    Modified    : 10/17/2001        Mark Davies (MIP)
                  Made changes to setDataValue to clear field if '' or '0' 
                  is passed.
    Modified    : 16/11/2001         Mark Davies (MIP)
                  Changed AllFieldHandles to reference the PROCEDURE handle
                  of SDF's and not the FRAME handle.
    Modified    : 28/01/2002         Mark Davies (MIP)
                  Fix for issue #3663 - Dynlookup doesn't fire child parent query 

    Modified    : 05/02/2002         Mark Davies (MIP)
                  Fix for issue #3627 - Toolbar with tableiotype ‘UPDATE’ does not sentisize correctly
                  Always ensure that the lookup field is disabled on initialization.
    Modified    : 07/02/2002         Mark Davies (MIP)
                  Fix for issue #3864 - Clearing a Dynamic Lookup keeps old value
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


&SCOP ADMSuper lookup.p
&SCOP LookupKey F4

/* Astra 2 global variables */


{src/adm2/ttlookup.i}
{src/adm2/tttranslate.i}
{src/adm2/ttdcombo.i}
  
  /* Custom exclude file */

  {src/adm2/custom/lookupexclcustom.i}

DEFINE VARIABLE gcLookupFilterValue AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

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

&IF DEFINED(EXCLUDE-getBaseQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBaseQueryString Procedure 
FUNCTION getBaseQueryString RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-getDisplayDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisplayDataType Procedure 
FUNCTION getDisplayDataType RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayedField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisplayedField Procedure 
FUNCTION getDisplayedField RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisplayFormat Procedure 
FUNCTION getDisplayFormat RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldLabel Procedure 
FUNCTION getFieldLabel RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldToolTip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldToolTip Procedure 
FUNCTION getFieldToolTip RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getKeyDataType Procedure 
FUNCTION getKeyDataType RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getKeyField Procedure 
FUNCTION getKeyField RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getKeyFormat Procedure 
FUNCTION getKeyFormat RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLabelHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLabelHandle Procedure 
FUNCTION getLabelHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-getParentField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getParentField Procedure 
FUNCTION getParentField RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getParentFilterQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getParentFilterQuery Procedure 
FUNCTION getParentFilterQuery RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryTables Procedure 
FUNCTION getQueryTables RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-getSDFFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDFFileName Procedure 
FUNCTION getSDFFileName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDFTemplate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDFTemplate Procedure 
FUNCTION getSDFTemplate RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-insertExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD insertExpression Procedure 
FUNCTION insertExpression RETURNS CHARACTER PRIVATE
  (pcWhere      AS CHAR,   
   pcExpression AS CHAR,     
   pcAndOr      AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newQueryString Procedure 
FUNCTION newQueryString RETURNS CHARACTER
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcDataTypes   AS CHARACTER,    
   pcOperators   AS CHARACTER,
   pcQueryString AS CHARACTER,
   pcAndOr       AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newWhereClause) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newWhereClause Procedure 
FUNCTION newWhereClause RETURNS CHARACTER
  (pcBuffer     AS CHAR,   
   pcExpression AS char,  
   pcWhere      AS CHAR,
   pcAndOr      AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBaseQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBaseQueryString Procedure 
FUNCTION setBaseQueryString RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setDisplayDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisplayDataType Procedure 
FUNCTION setDisplayDataType RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayedField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisplayedField Procedure 
FUNCTION setDisplayedField RETURNS LOGICAL
  ( pcDisplayedField AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisplayFormat Procedure 
FUNCTION setDisplayFormat RETURNS LOGICAL
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

&IF DEFINED(EXCLUDE-setFieldLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldLabel Procedure 
FUNCTION setFieldLabel RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldToolTip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldToolTip Procedure 
FUNCTION setFieldToolTip RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setKeyDataType Procedure 
FUNCTION setKeyDataType RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setKeyField Procedure 
FUNCTION setKeyField RETURNS LOGICAL
  ( pcKeyField AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setKeyFormat Procedure 
FUNCTION setKeyFormat RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLabelHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLabelHandle Procedure 
FUNCTION setLabelHandle RETURNS LOGICAL
  ( phValue AS HANDLE )  FORWARD.

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

&IF DEFINED(EXCLUDE-setParentField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setParentField Procedure 
FUNCTION setParentField RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setParentFilterQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setParentFilterQuery Procedure 
FUNCTION setParentFilterQuery RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setSDFFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSDFFileName Procedure 
FUNCTION setSDFFileName RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSDFTemplate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSDFTemplate Procedure 
FUNCTION setSDFTemplate RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

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
  pcWhere = LEFT-TRIM(pcWhere).

  /* Remove double blanks */
  DO WHILE INDEX(pcWhere,"  ":U) > 0:
    pcWhere = REPLACE(pcWhere,"  ":U," ":U).
  END.

  RETURN (IF NUM-ENTRIES(pcWhere," ":U) > 1 
          THEN ENTRY(IF pcWhere BEGINS "FOR ":U THEN 3 ELSE 2,pcWhere," ":U)
          ELSE "":U).

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
         HEIGHT             = 31.57
         WIDTH              = 64.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/lookprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-anyKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anyKey Procedure 
PROCEDURE anyKey :
/*------------------------------------------------------------------------------
  Purpose:     We could trap a keypress in here and auto-display single value
               found if only 1 is found, by going direct to query.
  Parameters:  <none>
  Notes:       Use LAST-EVENT:FUNCTION for testing keypress.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBrowseKeys AS CHAR  NO-UNDO.

  /* Currently we check for both labels and functions. 
     There is a theoretic potential for a collison here? */
  IF CAN-DO("F4":U,LAST-EVENT:FUNCTION) 
  OR CAN-DO("F4":U,LAST-EVENT:LABEL) THEN
  DO:

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
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

  DEFINE VARIABLE hLookup               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cKeyField             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFieldValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayDataType      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSavedScreenValue     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFunc                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnValues         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnNames          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFilter               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewQuery             AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cFieldName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyDataType          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewerLinkedFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedFieldDataTypes AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentFilterQuery    AS CHARACTER  NO-UNDO.
  
  {get KeyField cKeyField}.
  {get DisplayedField cDisplayedField}.
  {get DisplayDataType cDisplayDataType}.
  {get DataValue cKeyFieldValue}.
  {get FieldName cFieldName}.
  {get KeyDataType cKeyDataType}.
  {get QueryTables cQueryTables}.
  {get ViewerLinkedFields cViewerLinkedFields}.
  {get LinkedFieldDataTypes cLinkedFieldDataTypes}.
  {get LookupHandle hLookup}.
  {get DisplayValue cSavedScreenValue}.

  ASSIGN
    hLookup:SCREEN-VALUE = pcDisplayFieldValue
    hLookup:MODIFIED     = plSetModified.

  {get containerSource hContainer}.
  
  IF pcKeyFieldValue = "":U AND
     pcDisplayFieldValue = "":U THEN
    RETURN.

  /* If Only the Display Value was passed */
  IF pcKeyFieldValue = "":U AND
     pcDisplayFieldValue <> "":U THEN DO:
    CASE cDisplayDataType:
      WHEN "CHARACTER":U THEN
        /* Set up where clause for key field equal to current value of key field */
        cNewQuery = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                                     cDisplayedField,
                                     pcDisplayFieldValue,
                                     cDisplayDataType,
                                     "BEGINS":U,
                                     ?,
                                     ?).
      WHEN "LOGICAL":U THEN /* Don't think there will be one like this - just incase */
        /* Set up where clause for key field equal to current value of key field */
        cNewQuery = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                                     cDisplayedField,
                                     pcDisplayFieldValue,
                                     cDisplayDataType,
                                     "=":U,
                                     ?,
                                     ?).
      OTHERWISE DO:
        /* Set up where clause for key field equal to current value of key field */
        cNewQuery = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                                     cDisplayedField,
                                     pcDisplayFieldValue,
                                     cDisplayDataType,
                                     ">=":U,
                                     ?,
                                     ?).
        cNewQuery = DYNAMIC-FUNCTION("newWhereClause" IN TARGET-PROCEDURE,
                                     (IF LOOKUP(cQueryTables,ENTRY(1,cDisplayedField,".":U)) > 0 THEN ENTRY(LOOKUP(cQueryTables,ENTRY(1,cDisplayedField,".":U)),cQueryTables) ELSE ENTRY(NUM-ENTRIES(cQueryTables),cQueryTables)),
                                     (cDisplayedField + " <= '" + pcDisplayFieldValue + "'"),
                                     cNewQuery,
                                     "AND":U).
      END.
    END CASE.
  END.
  ELSE DO:
    /* Set up where clause for key field equal to current value of key field */
    cNewQuery = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                                 cKeyField,
                                 pcKeyFieldValue,
                                 cKeyDataType,
                                 "=":U,
                                 ?,
                                 ?).
  END.
  
  {set DataValue pcKeyFieldValue}.

  /* Set Parent-Child filter */
  RUN returnParentFieldValues IN TARGET-PROCEDURE (OUTPUT cParentFilterQuery).
  IF cParentFilterQuery <> "":U THEN
    cNewQuery = DYNAMIC-FUNCTION("newWhereClause" IN TARGET-PROCEDURE,
                                 ENTRY(NUM-ENTRIES(cQueryTables),cQueryTables),
                                 cParentFilterQuery,
                                 cNewQuery,
                                 "AND":U).
  
  EMPTY TEMP-TABLE ttLookup.
  CREATE ttLookup.
  ASSIGN
    ttLookup.hWidget = TARGET-PROCEDURE
    ttLookup.cWidgetName = cFieldName
    ttLookup.cWidgetType = cKeyDataType
    ttLookup.cForEach = cNewQuery
    ttLookup.cBufferList = cQueryTables
    ttLookup.cFieldList = cKeyField + ",":U + cDisplayedField + ",":U + cViewerLinkedFields
    ttLookup.cDataTypeList = cKeyDataType + ",":U + cDisplayDataType + ",":U + cLinkedFieldDataTypes
    ttLookup.cFoundDataValues = "":U    
    ttLookup.cRowIdent = "":U    
    .

  /* Resolve query */
  IF VALID-HANDLE(gshAstraAppserver) THEN
    RUN adm2/lookupqp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttLookup,
                                                  INPUT-OUTPUT TABLE ttDCombo,
                                                  INPUT "":U,
                                                  INPUT "":U).

  {set DisplayValue hLookup:SCREEN-VALUE}.
  
  /* Update display with result of query */
  RUN displayLookup IN TARGET-PROCEDURE (INPUT TABLE ttLookup).        
  
  {get DataValue cKeyFieldValue}.
  
  FIND FIRST ttLookup.

  PUBLISH "lookupComplete":U FROM hContainer (INPUT ttLookup.cFieldList,        /* CSV of fields specified */
                                              INPUT ttLookup.cFoundDataValues,  /* CHR(1) delim list of all the values of the above fields */
                                              INPUT cKeyFieldValue,      /* the key field value of the selected record */
                                              INPUT pcDisplayFieldValue,        /* the value displayed on screen (may be the same as the key field value ) */
                                              INPUT cSavedScreenValue,   /* the old value displayed on screen (may be the same as the key field value ) */
                                              INPUT NO,                  /* YES = lookup browser used, NO = manual value entered */
                                              INPUT TARGET-PROCEDURE     /* Handle to lookup - use to determine which lookup has been left */
                                             ). 

  {get DataValue cKeyFieldValue}.
  {get DisplayValue cSavedScreenValue}.
  
  IF plSetModified THEN
    {set DataModified TRUE}.      
  
  RETURN.

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

  {fn destroyLookup}.

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
    {get BrowseContainer hBrowseContainer}.
    {get ButtonHandle hButton}.

    IF VALID-HANDLE(hBrowsecontainer) THEN
      RUN disableObject IN hBrowseContainer.

    ASSIGN hButton:SENSITIVE = FALSE.
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
   {get BrowseContainer hBrowseContainer}.
   {get ButtonHandle hButton}.

   IF VALID-HANDLE(hBrowsecontainer) THEN 
     RUN disableObject IN hBrowseContainer.

   ASSIGN
     hButton:SENSITIVE    = FALSE
     hLookup:READ-ONLY = TRUE
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
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER TABLE FOR ttLookup.

DEFINE VARIABLE cFieldName              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyField               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDisplayedField         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyDataType            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDisplayDataType        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQueryTables            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cViewerLinkedFields     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cViewerLinkedWidgets    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLinkedFieldDataTypes   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyFieldValue          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewQuery               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hLookup                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE iField                  AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAllFieldHandles        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidget                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE cDisplayValue           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDynComboList           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hCombo                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE cParentFields           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hComboField             AS HANDLE     NO-UNDO.

{get FieldName cFieldName}.

FIND FIRST ttLookup
     WHERE ttLookup.hWidget = TARGET-PROCEDURE
       AND ttLookup.cWidgetName = cFieldName
     NO-ERROR.
IF NOT AVAILABLE ttLookup THEN RETURN.

{get KeyField cKeyField}.
{get DisplayedField cDisplayedField}.
{get LookupHandle hLookup}.
{get ViewerLinkedFields cViewerLinkedFields}.
{get ViewerLinkedWidgets cViewerLinkedWidgets}.
{get LinkedFieldDataTypes cLinkedFieldDataTypes}.
{get containerSource hContainer}.   /* viewer */
{get DisplayValue cDisplayValue}.

/* If value entered and more than one record could be found matching
   the entered value - automatically launch the lookup and filter
   on entered value */
IF ttLookup.lMoreFound THEN DO:
  DEFINE VARIABLE hButton AS HANDLE NO-UNDO.
  
  {get ButtonHandle hButton}.
  IF hButton:SENSITIVE = TRUE AND 
     cDisplayValue <> hLookup:SCREEN-VALUE THEN
  DO:
    APPLY "CHOOSE":U TO hButton.
    RETURN "BROWSE-OPEN":U.
  END.
END.

/* Update displayed field */
ASSIGN iField = LOOKUP(cDisplayedField, ttLookup.cFieldList).
IF iField > 0 AND NUM-ENTRIES(ttLookup.cFoundDataValues,CHR(1)) >= iField THEN
  ASSIGN hLookup:SCREEN-VALUE = ENTRY(iField, ttLookup.cFoundDataValues, CHR(1)).
ELSE
  /* blank out as it is invalid - unless displayed field = key field */
  ASSIGN 
    hLookup:SCREEN-VALUE = (IF cKeyField <> cDisplayedField OR hLookup:SCREEN-VALUE = "?":U OR hLookup:SCREEN-VALUE = "0":U THEN "":U ELSE hLookup:SCREEN-VALUE)
    .
{set DisplayValue hLookup:SCREEN-VALUE}. /* avoid leave trigger code */
/* Update key field */
{get DataValue cKeyFieldValue}.
ASSIGN iField = LOOKUP(cKeyField, ttLookup.cFieldList).
IF iField > 0 AND NUM-ENTRIES(ttLookup.cFoundDataValues,CHR(1)) >= iField THEN
  ASSIGN cKeyFieldValue = ENTRY(iField, ttLookup.cFoundDataValues, CHR(1)).
ELSE
  ASSIGN cKeyFieldValue = "":U.     /* blank out as it is invalid */
{set DataValue cKeyFieldValue}.

/* store rowident property - rowids of current record */
{set RowIdent ttLookup.cRowIdent}.

/* Update linked fields */
/*IF cViewerLinkedFields <> "":U AND VALID-HANDLE(hContainer) THEN*/
cAllFieldHandles = DYNAMIC-FUNCTION("getAllFieldHandles":U IN hContainer).
/*IF cAllFieldHandles <> "":U AND cViewerLinkedFields <> "":U THEN*/

field-loop:
DO iLoop = 1 TO NUM-ENTRIES(cAllFieldHandles):
  hWidget = WIDGET-HANDLE(ENTRY(iLoop,cAllFieldHandles)).
  IF VALID-HANDLE(hWidget) AND
     hWidget:TYPE <> "PROCEDURE":U AND
     CAN-QUERY(hWidget, "NAME":U) AND 
     LOOKUP(hWidget:NAME, cViewerLinkedWidgets) <> 0 THEN
  DO:
    ASSIGN
      iField = LOOKUP(hWidget:NAME, cViewerLinkedWidgets)
      cField = ENTRY(iField,cViewerLinkedFields)
      .
    ASSIGN
      iField = LOOKUP(cField, ttLookup.cFieldList).
    IF iField > 0 THEN
    DO:
      cValue = IF NUM-ENTRIES(ttLookup.cFoundDataValues,CHR(1)) >= iField THEN
                 ENTRY(iField,ttLookup.cFoundDataValues, CHR(1))
               ELSE
                 "":U.  /* blank out as invalid */
      ASSIGN hWidget:SCREEN-VALUE = cValue.
    END.
  END.
  /* Check for Dynamic Combos */
  IF VALID-HANDLE(hWidget) AND
     hWidget:TYPE = "PROCEDURE":U THEN DO:
    IF LOOKUP("dynamicCombo":U,hWidget:INTERNAL-ENTRIES) > 0 THEN
      cDynComboList = IF cDynComboList = "":U 
                        THEN STRING(hWidget)
                        ELSE cDynComboList + ",":U + STRING(hWidget).
  END.
END.

IF cDynComboList <> "":U THEN DO:
  DynCombo_Loop:
  DO iLoop = 1 TO NUM-ENTRIES(cDynComboList):
    hCombo = WIDGET-HANDLE(ENTRY(iLoop,cDynComboList)).
    IF VALID-HANDLE(hCombo) THEN DO:
      cParentFields = "":U.
      cParentFields = DYNAMIC-FUNCTION("getParentField":U IN hCombo) NO-ERROR.
      IF cParentFields = "":U OR
         cParentFields = ? THEN
        NEXT DynCombo_Loop.
      /* Refreshes any other child dependant Dynamic combo's */
      IF LOOKUP(cFieldName,cParentFields) > 0 THEN DO:
        hComboField = DYNAMIC-FUNCTION("getComboHandle":U IN hCombo) NO-ERROR.
        /* Check if the combo has been initialized */
        IF CAN-QUERY(hComboField,"LIST-ITEM-PAIRS":U) THEN
          RUN refreshChildDependancies IN hCombo (INPUT cFieldName).
      END.
    END.
  END.
END.

/* Astra 2 Code - Chris Koster */
PUBLISH "lookupDisplayComplete":U FROM  hContainer (INPUT ttLookup.cFieldList,        /* CSV of fields specified */
                                                    INPUT ttLookup.cFoundDataValues,  /* CHR(1) delim list of all the values of the above fields */
                                                    INPUT cKeyFieldValue,             /* the key field value of the selected record */
                                                    INPUT TARGET-PROCEDURE            /* Handle to lookup - use to determine which lookup has been left */
                                                   ). 
/* End of Astra 2 Block */

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
   hLookup:READ-ONLY = FALSE.

   ASSIGN
     hButton:SENSITIVE   = TRUE 
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

  {get LookupHandle hLookup}.
  {get containerSource hContainer}.
  {set DisplayValue hLookup:SCREEN-VALUE}.

  PUBLISH "lookupEntry":U FROM hContainer (INPUT hLookup:SCREEN-VALUE,   /* current lookup value */
                                           INPUT TARGET-PROCEDURE           /* handle of lookup */
                                          ).
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
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttLookup.

  DEFINE VARIABLE cFieldName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyDataType            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayDataType        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewerLinkedFields     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedFieldDataTypes   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFieldValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewQuery               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentField            AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource             AS HANDLE     NO-UNDO.

  {get FieldName cFieldName}.
  {get KeyField cKeyField}.
  {get DisplayedField cDisplayedField}.
  {get KeyDataType cKeyDataType}.
  {get DisplayDataType cDisplayDataType}.
  {get QueryTables cQueryTables}.
  {get ViewerLinkedFields cViewerLinkedFields}.
  {get LinkedFieldDataTypes cLinkedFieldDataTypes}.
  {get DataValue cKeyFieldValue}.
  {get ParentField cParentField}.

  {get containerSource hContainer}.   /* viewer */
  IF VALID-HANDLE(hContainer) THEN
    hDataSource = DYNAMIC-FUNCTION('getDataSource':U IN hContainer) NO-ERROR.

  /* we must get the value of the external field from the SDO that is the 
     data source of the viewer - and then change the query for the lookup
     to find the record where the keyfield is equal to this external field
     value
  */
  IF VALID-HANDLE(hDataSource) THEN 
    cKeyFieldValue = DYNAMIC-FUNCTION("ColumnStringValue":U IN hDataSource,cFieldName).

    IF  cKeyFieldValue = "":u OR cKeyFieldValue = ? OR cKeyFieldValue = "0":u THEN
        {get DataValue cKeyFieldValue}.
    ELSE
        /* reset saved keyfieldvalue */
        {set DataValue cKeyFieldValue}.

  
  
  /* Set up where clause for key field equal to current value of key field */
  cNewQuery = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                               cKeyField,
                               cKeyFieldValue,
                               cKeyDataType,
                               "=":U,
                               ?,
                               ?).
  
  /* Update query into temp-table */
  FIND FIRST ttLookup
       WHERE ttLookup.hWidget = TARGET-PROCEDURE
         AND ttLookup.cWidgetName = cFieldName
       NO-ERROR.
  IF NOT AVAILABLE ttLookup THEN CREATE ttLookup.

  ASSIGN
    ttLookup.hWidget = TARGET-PROCEDURE
    ttLookup.cWidgetName = cFieldName
    ttLookup.cWidgetType = cKeyDataType
    ttLookup.cForEach = cNewQuery
    ttLookup.cBufferList = cQueryTables
    ttLookup.cFieldList = cKeyField + ",":U + cDisplayedField + ",":U + cViewerLinkedFields
    ttLookup.cDataTypeList = cKeyDataType + ",":U + cDisplayDataType + ",":U + cLinkedFieldDataTypes
    ttLookup.cFoundDataValues = "":U    
    ttLookup.cRowIdent = "":U    
    .

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
  DEFINE VARIABLE iRowsToBatch     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hBrowseWindow    AS HANDLE    NO-UNDO.

  {get uibMODE cUIBmode}.

  IF cuibMode BEGINS "DESIGN":U THEN 
    RETURN. 
  
  /* First see if already running */
  {get BrowseObject hBrowseObject}.
  {get BrowseContainer hBrowseContainer}.

  IF NOT VALID-HANDLE(hBrowseContainer) THEN 
  DO: 
    {get ContainerSource hContainer}.
    {get ContainerSource hRealContainer hContainer}.

    /* Construct the window and objects */
    RUN constructObject IN hContainer (
         INPUT  'ry/uib/rydyncontw.w':U,
         INPUT  ?,
         INPUT  'LogicalObjectName':U + CHR(4) + 'rydynlookw':U + CHR(3) + "InitialPageList":U + CHR(4) + "*":U,
         OUTPUT hBrowseContainer).

    /* set caller object so can get focus back on exit */
    IF hRealContainer <> ? AND VALID-HANDLE(hBrowseContainer) 
       AND LOOKUP("setCallerObject", hBrowseContainer:INTERNAL-ENTRIES) <> 0 THEN
    DO:
      DYNAMIC-FUNCTION('setCallerObject' IN hBrowseContainer, INPUT hRealContainer).
    END.

    RUN initializeObject IN hBrowseContainer.  

    {get ContainerHandle hBrowseWindow hBrowseContainer}.
    {get BrowseTitle cBrowseTitle}.

    /* Set window title */
    hBrowseWindow:TITLE = cBrowseTitle.
    
    {get LookupHandle hLookup}.
    {set LookupFilterValue hLookup:SCREEN-VALUE}.
    /* construct browser and filter settings */
    PUBLISH "buildBrowser":U FROM hBrowseContainer (INPUT TARGET-PROCEDURE).
    PUBLISH "buildFilters":U FROM hBrowseContainer (INPUT TARGET-PROCEDURE).
    {set LookupFilterValue ''}.

    /* Store running window handle */
    {set BrowseContainer hBrowseContainer}.

    APPLY "window-resized":u TO hBrowseWindow.
    RUN selectPage IN hBrowseContainer(1).

  END.  /* not valid handle browse container */

  /* View and focus the browser */
  RUN applyEntry IN hBrowseContainer (INPUT ?).

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
  
  {get ContainerHandle hFrame}.

  hParentFrame = hFrame:FRAME.

  IF NOT VALID-HANDLE(hParentFrame) THEN 
    RETURN.

  {fn destroyLookup}. /* Get rid of existing widgets so we can recreate them */

  {get DisplayedField cDisplayedField}.
  {get KeyField cKeyField}.
  {get FieldLabel cLabel}.
  {get FieldToolTip cToolTip}.
  {get KeyFormat cKeyFormat}.
  {get KeyDataType cKeyDataType}.
  {get DisplayFormat cDisplayFormat}.
  {get DisplayDataType cDisplayDataType}.
  {get RowsToBatch iRowsToBatch}.
  {get UIBMode cUIBmode}. 

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
    WHEN "decimal":U THEN ASSIGN cKeyFormat = ">>>>>>>>>>>>>>>>>9.999999999":U.
    WHEN "date":U THEN ASSIGN cKeyFormat = "99/99/9999":U.
    WHEN "integer":U THEN ASSIGN cKeyFormat = ">>>>>>>9":U.
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
  IF cDisplayFormat = "":U THEN
  CASE cDisplayDataType:
    WHEN "decimal":U THEN ASSIGN cDisplayFormat = ">>>>>>>>>>>>>>>>>9.999999999":U.
    WHEN "date":U THEN ASSIGN cDisplayFormat = "99/99/9999":U.
    WHEN "integer":U THEN ASSIGN cDisplayFormat = ">>>>>>>9":U.
    OTHERWISE ASSIGN cDisplayFormat = "x(256)":U.
  END CASE.
  {set DisplayFormat  cDisplayFormat}.

  /* create a label if not blank */  
  IF cLabel NE "":U THEN
  DO: 
    {fnarg createLabel cLabel}. 
  END. /* cLabel <> "":U */

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
           HIDDEN           = FALSE
           SENSITIVE        = (cUIBMode BEGINS "DESIGN":U) = FALSE  
           READ-ONLY        = (cUIBMode BEGINS "DESIGN":U) = TRUE
           TAB-STOP         = FALSE.

  CREATE BUTTON hBtn
    ASSIGN NO-FOCUS         = TRUE
           FRAME            = hFrame
           X                = hLookup:WIDTH-P + 4
           Y                = 1 
           WIDTH-PIXELS     = 19
           HEIGHT-P         = hLookup:HEIGHT-P - 1 
           HIDDEN           = FALSE
           SENSITIVE        = hLookup:SENSITIVE
        TRIGGERS:
          ON CHOOSE PERSISTENT 
            RUN initializeBrowse IN TARGET-PROCEDURE.
        END.
  {get LookupImage cLookupImg}.
  hBtn:LOAD-IMAGE(cLookupImg).      
  hFrame:HEIGHT = hLookup:HEIGHT.

  /* create an entry/leave trigger always, code is defined */
  ON ENTRY OF hLookup 
   PERSISTENT RUN enterLookup IN TARGET-PROCEDURE.
  ON LEAVE OF hLookup 
   PERSISTENT RUN leaveLookup IN TARGET-PROCEDURE.
    
  {set ButtonHandle hBtn}.       

  IF VALID-HANDLE(hLookup) THEN
  DO:
    hLookup:MOVE-TO-BOTTOM().
    hLookup:TOOLTIP = cToolTIP.

    ON ANY-KEY OF hLookup PERSISTENT RUN anyKey IN TARGET-PROCEDURE.

    ON VALUE-CHANGED OF hLookup PERSISTENT RUN valueChanged  IN TARGET-PROCEDURE.
    ON END-MOVE      OF hFrame  PERSISTENT RUN endMove       IN TARGET-PROCEDURE. 
  END.
  {set LookupHandle hLookup}.
  RUN disableField IN TARGET-PROCEDURE. /* Always disable field on initialization - fix for issue #3627*/  
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

  DEFINE VARIABLE hLookup               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cKeyField             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFieldValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayDataType      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScreenValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSavedScreenValue     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFunc                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnValues         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnNames          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFilter               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewQuery             AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cFieldName            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyDataType          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewerLinkedFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedFieldDataTypes AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentFilterQuery    AS CHARACTER  NO-UNDO.
  
  {get KeyField cKeyField}.
  {get DisplayedField cDisplayedField}.
  {get DisplayDataType cDisplayDataType}.
  {get DataValue cKeyFieldValue}.
  {get FieldName cFieldName}.
  {get KeyDataType cKeyDataType}.
  {get QueryTables cQueryTables}.
  {get ViewerLinkedFields cViewerLinkedFields}.
  {get LinkedFieldDataTypes cLinkedFieldDataTypes}.
  {get LookupHandle hLookup}.
  {get DisplayValue cSavedScreenValue}.

  ASSIGN
    cScreenValue = hLookup:SCREEN-VALUE.

  {get containerSource hContainer}.

  /* If user has manually changed description field - try and lookup new value user has entered
  */
  IF  cScreenValue <> cSavedScreenValue THEN
  DO:
    /* lookup manually entered screen value */
    CASE cDisplayDataType:
      WHEN "CHARACTER":U THEN
        /* Set up where clause for key field equal to current value of key field */
        cNewQuery = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                                     cDisplayedField,
                                     cScreenValue,
                                     cDisplayDataType,
                                     "BEGINS":U,
                                     ?,
                                     ?).
      WHEN "LOGICAL":U THEN /* Don't think there will be one like this - just incase */
        /* Set up where clause for key field equal to current value of key field */
        cNewQuery = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                                     cDisplayedField,
                                     cScreenValue,
                                     cDisplayDataType,
                                     "=":U,
                                     ?,
                                     ?).
      OTHERWISE DO:
        /* Set up where clause for key field equal to current value of key field */
        cNewQuery = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                                     cDisplayedField,
                                     cScreenValue,
                                     cDisplayDataType,
                                     ">=":U,
                                     ?,
                                     ?).
        cNewQuery = DYNAMIC-FUNCTION("newWhereClause" IN TARGET-PROCEDURE,
                                     (IF LOOKUP(cQueryTables,ENTRY(1,cDisplayedField,".":U)) > 0 THEN ENTRY(LOOKUP(cQueryTables,ENTRY(1,cDisplayedField,".":U)),cQueryTables) ELSE ENTRY(NUM-ENTRIES(cQueryTables),cQueryTables)),
                                     (cDisplayedField + " <= '" + cScreenValue + "'"),
                                     cNewQuery,
                                     "AND":U).
      END.
    END CASE.
    /* Set Parent-Child filter */
    RUN returnParentFieldValues IN TARGET-PROCEDURE (OUTPUT cParentFilterQuery).
    IF cParentFilterQuery <> "":U THEN
      cNewQuery = DYNAMIC-FUNCTION("newWhereClause" IN TARGET-PROCEDURE,
                                   ENTRY(NUM-ENTRIES(cQueryTables),cQueryTables),
                                   cParentFilterQuery,
                                   cNewQuery,
                                   "AND":U).
    EMPTY TEMP-TABLE ttLookup.
    CREATE ttLookup.
    ASSIGN
      ttLookup.hWidget = TARGET-PROCEDURE
      ttLookup.cWidgetName = cFieldName
      ttLookup.cWidgetType = cKeyDataType
      ttLookup.cForEach = cNewQuery
      ttLookup.cBufferList = cQueryTables
      ttLookup.cFieldList = cKeyField + ",":U + cDisplayedField + ",":U + cViewerLinkedFields
      ttLookup.cDataTypeList = cKeyDataType + ",":U + cDisplayDataType + ",":U + cLinkedFieldDataTypes
      ttLookup.cFoundDataValues = "":U    
      ttLookup.cRowIdent = "":U    
      .

    /* Resolve query */
    IF VALID-HANDLE(gshAstraAppserver) THEN
      RUN adm2/lookupqp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttLookup,
                                                    INPUT-OUTPUT TABLE ttDCombo,
                                                    INPUT "":U,
                                                    INPUT "":U).

    /* Update display with result of query */
    RUN displayLookup IN TARGET-PROCEDURE (INPUT TABLE ttLookup).        
    
    /* Check if the Lookup Browser was fired */
    IF RETURN-VALUE = "BROWSE-OPEN":U THEN
      RETURN NO-APPLY.
    /* fire lookupcomplete hook */
    IF hLookup:SCREEN-VALUE <> "":U AND hLookup:SCREEN-VALUE <> "0":U THEN
      ASSIGN
        cScreenValue = hLookup:SCREEN-VALUE.  /* Only store new screen value if we actually found a value, otherwise pass back what they typed */
    {get DataValue cKeyFieldValue}.
    FIND FIRST ttLookup.

    PUBLISH "lookupComplete":U FROM hContainer (INPUT ttLookup.cFieldList,        /* CSV of fields specified */
                                                INPUT ttLookup.cFoundDataValues,  /* CHR(1) delim list of all the values of the above fields */
                                                INPUT cKeyFieldValue,      /* the key field value of the selected record */
                                                INPUT cScreenValue,        /* the value displayed on screen (may be the same as the key field value ) */
                                                INPUT cSavedScreenValue,   /* the old value displayed on screen (may be the same as the key field value ) */
                                                INPUT NO,                  /* YES = lookup browser used, NO = manual value entered */
                                                INPUT TARGET-PROCEDURE     /* Handle to lookup - use to determine which lookup has been left */
                                               ). 
    IF cScreenValue <> cSavedScreenValue THEN
      RUN valueChanged IN TARGET-PROCEDURE.

    {set DisplayValue hLookup:SCREEN-VALUE}.

  END.
  
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

  DEFINE VARIABLE hFrame   AS HANDLE NO-UNDO.
  DEFINE VARIABLE cUIBMode AS CHAR   NO-UNDO.

  {get ContainerHandle hFrame}.

  {fn destroyLookup}.

  ASSIGN hFrame:SCROLLABLE            = TRUE
         hFrame:WIDTH-CHARS           = pidWidth
         hFrame:HEIGHT-CHARS          = pidHeight
         hFrame:VIRTUAL-WIDTH-CHARS   = hFrame:WIDTH-CHARS
         hFrame:VIRTUAL-HEIGHT-CHARS  = hFrame:HEIGHT-CHARS
         hFrame:SCROLLABLE            = FALSE.

  {get UIBMode cUIBMode}.

  IF cUIBMode = "design":U  THEN
    RUN initializeLookup IN TARGET-PROCEDURE.

  RETURN.

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
  DEFINE OUTPUT PARAMETER pcNewQuery  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cParentField      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterQuery      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWidget           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cAllFieldHandles  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iField            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSubs             AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE cSDFFieldName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDFHandle        AS HANDLE     NO-UNDO.

  {get ParentField cParentField}.
  {get ParentFilterQuery cFilterQuery}.
  {get containerSource hContainer}.   /* viewer */

IF cParentField <> "":U AND VALID-HANDLE(hContainer) THEN
  cAllFieldHandles = DYNAMIC-FUNCTION("getAllFieldHandles":U IN hContainer).

IF cAllFieldHandles <> "":U AND cParentField <> "":U THEN
field-loop:
DO iLoop = 1 TO NUM-ENTRIES(cAllFieldHandles):
  hWidget = WIDGET-HANDLE(ENTRY(iLoop,cAllFieldHandles)).
  /* Normal Widgets - Non SmartDataFields */
  IF VALID-HANDLE(hWidget) AND
     hWidget:TYPE <> "PROCEDURE":U AND
     CAN-QUERY(hWidget, "NAME":U) AND 
     LOOKUP(hWidget:NAME, cParentField) <> 0 THEN
  DO:
    ASSIGN
      iField = LOOKUP(hWidget:NAME, cParentField)
      cField = ENTRY(iField,cParentField)
      NO-ERROR.
    IF iField > 0 AND iField <= 9 THEN
      ASSIGN cValue        = IF CAN-QUERY(hWidget,"INPUT-VALUE":U) THEN hWidget:INPUT-VALUE ELSE hWidget:SCREEN-VALUE
             cSubs[iField] = TRIM(cValue).
  END.
  
  /* SmartDataFields Static Combo, Dynamic Combos and Lookups */
  IF VALID-HANDLE(hWidget) AND
     hWidget:TYPE = "PROCEDURE":U THEN DO:
    hSDFHandle = hWidget.
    IF CAN-QUERY(hSDFHandle, "INTERNAL-ENTRIES":U) THEN DO:
      IF LOOKUP("getFieldName":U,hSDFHandle:INTERNAL-ENTRIES) > 0 THEN DO:
        ASSIGN
          cSDFFieldName = DYNAMIC-FUNCTION("getFieldName" IN hSDFHandle)
          iField = LOOKUP(cSDFFieldName, cParentField)
          cField = ENTRY(iField,cParentField)
          NO-ERROR.
        
        /* Dynamic Lookups and Dynamic Combos */
        IF LOOKUP("getDataValue":U,hSDFHandle:INTERNAL-ENTRIES) > 0 THEN
          cValue = DYNAMIC-FUNCTION("getDataValue":U IN hSDFHandle).
        ELSE /* Static Combos */
          IF LOOKUP("getDataValue":U,hSDFHandle:INTERNAL-ENTRIES) > 0 THEN
            cValue = DYNAMIC-FUNCTION("getDataValue":U IN hSDFHandle).

        IF iField > 0 AND iField <= 9 THEN
          ASSIGN cSubs[iField] = TRIM(cValue).
      END.
    END.
  END.
  
END.

pcNewQuery = SUBSTITUTE(cFilterQuery,cSubs[1],cSubs[2],cSubs[3],cSubs[4],cSubs[5],cSubs[6],cSubs[7],cSubs[8],cSubs[9]).

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

  DEFINE VARIABLE cViewerLinkedFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyDataType        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLookup             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFunc               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldDisplayValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewDisplayValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldKeyValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewKeyValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowIdent           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnValues       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnNames        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRealContainer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iField              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cQueryString        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkedFieldDataTypes AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayDataType    AS CHARACTER  NO-UNDO.

  {get containerSource hContainer}.
  {get containerSource hRealContainer hContainer}.
  {get LookupHandle hLookup}.

  IF VALID-HANDLE(hLookup) THEN
  DO:
    {get DisplayedField cDisplayedField}.
    {get KeyField cKeyField}.
    {get KeyDataType cKeyDataType}.
    {get FieldName cFieldName}.
    {get ViewerLinkedFields cViewerLinkedFields}.
    {get DataValue cNewKeyValue}.
    {get QueryTables cQueryTables}.
    {get BaseQueryString cQueryString}.      
    {get LinkedFieldDataTypes cLinkedFieldDataTypes}.
    {get DisplayDataType cDisplayDataType}.

    ASSIGN
      cOldDisplayValue = hLookup:SCREEN-VALUE
      cNewDisplayValue = hLookup:SCREEN-VALUE
      cColumnNames = cKeyField + ",":U + cDisplayedField + ",":U + cViewerLinkedFields
      .

    /* Find key value */
    ASSIGN cOldKeyValue = cNewKeyValue
           iField       = LOOKUP(cKeyField,pcAllFields).
    IF iField > 0 THEN
      ASSIGN cNewKeyValue = ENTRY(iField, pcValues, CHR(1)).

    /* Find new displayed field */
    ASSIGN iField = LOOKUP(cDisplayedField,pcAllFields).
    IF iField > 0 THEN
      ASSIGN cNewDisplayValue = ENTRY(iField, pcValues, CHR(1)).

    /* Find values of other columnds */
    DO iLoop = 1 TO NUM-ENTRIES(cColumnNames):
      ASSIGN cField = ENTRY(iLoop, cColumnNames).
      ASSIGN iField = LOOKUP(cField,pcAllFields).
      IF iField > 0 THEN
        ASSIGN cValue = ENTRY(iField, pcValues, CHR(1)).
      ELSE
        ASSIGN cValue = "":U.
      ASSIGN
        cColumnValues = cColumnValues +
                        (IF iLoop = 1 THEN "":U ELSE CHR(1)) +
                        cValue.
    END.

    /* Update screen value and new key field value */
    {set DataValue cNewKeyValue}.
    ASSIGN 
      hLookup:SCREEN-VALUE = cNewDisplayValue.

    EMPTY TEMP-TABLE ttLookup.
    CREATE ttLookup.
    ASSIGN
      ttLookup.hWidget = TARGET-PROCEDURE
      ttLookup.cWidgetName = cFieldName
      ttLookup.cWidgetType = cKeyDataType
      ttLookup.cForEach = cQueryString
      ttLookup.cBufferList = cQueryTables
      ttLookup.cFieldList = cKeyField + ",":U + cDisplayedField + ",":U + cViewerLinkedFields
      ttLookup.cDataTypeList = cKeyDataType + ",":U + cDisplayDataType + ",":U + cLinkedFieldDataTypes
      ttLookup.cFoundDataValues = cColumnValues    
      ttLookup.cRowIdent = pcRowIdent    
      .

    /* Update display with linked fields */
    RUN displayLookup IN TARGET-PROCEDURE (INPUT TABLE ttLookup).        

  END. /* valid hLookup */

/*   RUN SUPER (INPUT pcAllFields, INPUT pcValues, INPUT pcRowIdent). */

  IF VALID-HANDLE(hLookup) THEN
  DO:
    /* Reset saved screen value to prevent code in leave trigger trying to find a new keyvalue */
    {set DisplayValue hLookup:SCREEN-VALUE}.

    /* Focus back in fill-in */
    RUN applyEntry IN TARGET-PROCEDURE (hLookup:NAME).
    /* get focus back in correct window */
    DEFINE VARIABLE hWindow AS HANDLE NO-UNDO.
    {get ContainerHandle hWindow hRealContainer}.
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
       cNewKeyValue <> cOldKeyValue) THEN
      RUN valueChanged IN TARGET-PROCEDURE.

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
  
  /* Get the current language */
  IF VALID-HANDLE(gshAstraAppserver) THEN
    dCurrentLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                   INPUT "CurrentLanguageObj":U,
                                                   INPUT NO)) NO-ERROR.
                                                     
  IF NOT VALID-HANDLE(phBrowseHandle) THEN
    RETURN.
  hBrowseColumn = phBrowseHandle:FIRST-COLUMN.
  
  IF NOT VALID-HANDLE(hBrowseColumn) THEN
    RETURN.
  
  DO WHILE VALID-HANDLE(hBrowseColumn):
    ASSIGN cWidgetType = "BROWSE":U
           cWidgetName = hBrowseColumn:NAME
           NO-ERROR.
    IF VALID-HANDLE(gshAstraAppserver) THEN
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
    IF cTranslatedLabel <> "":U AND
       cTranslatedLabel <> ? THEN
      hBrowseColumn:LABEL = cTranslatedLabel.
    hBrowseColumn = hBrowseColumn:NEXT-COLUMN.
  END.

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
            The code currently duplicates the logic that is defined
            in the U10 trigger in the SmartDataViewer because this code's check
            of FOCUS is wrong when the actual change is caused by a user event
            in the browser.         
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLookup AS HANDLE     NO-UNDO.

  {set DataModified YES}.
  {get LookupHandle hLookup}.

  IF VALID-HANDLE(hLookup) AND 
    hLookup:SCREEN-VALUE = "":U THEN DO:
    {set DataValue "":U}.
    RUN leaveLookup IN TARGET-PROCEDURE.
  END.
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

   {get LabelHandle hLabel}.
   IF VALID-HANDLE(hLabel) THEN
   DO:
     /* endmove passes blank value, if so just copy the old value */ 
     IF pcLabel = "":U THEN 
       pcLabel = RIGHT-TRIM(hLabel:SCREEN-VALUE,":":U).
     DELETE WIDGET hLABEL.
   END.   
   ELSE IF pcLabel = "":U THEN
     RETURN ?.

   {get ContainerHandle hFrame}.

   hParentFrame = hFrame:FRAME.

   iLabelLength = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(pcLabel + ": ":U, hFrame:FONT).

   CREATE TEXT hLabel
     ASSIGN FRAME                 = hParentFrame
            X                     = hFrame:X - iLabelLength
            Y                     = hFrame:Y
            HIDDEN                = FALSE
            WIDTH-PIXELS          = iLabelLength
            FORMAT                = "x(256)"
            SCREEN-VALUE          = pcLabel + ":":U
            HEIGHT-PIXELS         = SESSION:PIXELS-PER-ROW 
            .  
  {set LabelHandle hLabel}.

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

  {get LookupHandle hLookup}.
  {get LabelHandle hLabel}.
  {get ButtonHandle hButton}.

  IF VALID-HANDLE(hLookup) THEN DELETE WIDGET hLookup.
  IF VALID-HANDLE(hLabel)  THEN DELETE WIDGET hLabel.
  IF VALID-HANDLE(hButton) THEN DELETE WIDGET hButton.

  ASSIGN
    hLookup = ?
    hLabel = ?
    hButton = ?
    .

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBaseQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBaseQueryString Procedure 
FUNCTION getBaseQueryString RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get BaseQueryString cValue}.
  RETURN cValue.

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
  /*
  /* ensure manual field changes are saved correctly */
  RUN leaveLookup IN TARGET-PROCEDURE.
  */
  {get LookupHandle hLookup}.

  IF NOT VALID-HANDLE(hLookup) THEN
    RETURN ERROR. 

  {get KeyField cKeyField}.
  {get DisplayedField cDisplayedField}.

  IF cKeyField <> cDisplayedField THEN DO:
      &SCOPED-DEFINE xpDataValue
      {get DataValue cDataValue}.
      &UNDEFINE xpDataValue
    RETURN cDataValue.
  END.
  ELSE
  DO:
    DEFINE VARIABLE cChar               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDisplayDataType    AS CHARACTER  NO-UNDO.
    ASSIGN
      cChar = hLookup:SCREEN-VALUE.
    IF NOT LENGTH(hLookup:SCREEN-VALUE) > 0 THEN
    DO:
      {get DisplayDataType cDisplayDataType}.
      CASE cDisplayDataType:
        WHEN "integer" THEN
          ASSIGN cChar = "0":U.
        WHEN "decimal" THEN
          ASSIGN cChar = "0":U.
        WHEN "date" THEN
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

&IF DEFINED(EXCLUDE-getDisplayDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisplayDataType Procedure 
FUNCTION getDisplayDataType RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get DisplayDataType cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayedField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisplayedField Procedure 
FUNCTION getDisplayedField RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the name of the field to display in the selection
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDisplayedField AS CHARACTER NO-UNDO.
  {get DisplayedField cDisplayedField}.
  RETURN cDisplayedField.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisplayFormat Procedure 
FUNCTION getDisplayFormat RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get DisplayFormat cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldLabel Procedure 
FUNCTION getFieldLabel RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get FieldLabel cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldToolTip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldToolTip Procedure 
FUNCTION getFieldToolTip RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get FieldToolTip cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getKeyDataType Procedure 
FUNCTION getKeyDataType RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get KeyDataType cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getKeyField Procedure 
FUNCTION getKeyField RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the name of the key field
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cKeyField AS CHARACTER NO-UNDO.
  {get KeyField cKeyField}.
  RETURN cKeyField.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getKeyFormat Procedure 
FUNCTION getKeyFormat RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get KeyFormat cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLabelHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLabelHandle Procedure 
FUNCTION getLabelHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hValue AS HANDLE NO-UNDO.
  {get LabelHandle hValue}.
  RETURN hValue.

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

&IF DEFINED(EXCLUDE-getParentField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getParentField Procedure 
FUNCTION getParentField RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get ParentField cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getParentFilterQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getParentFilterQuery Procedure 
FUNCTION getParentFilterQuery RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get ParentFilterQuery cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryTables Procedure 
FUNCTION getQueryTables RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get QueryTables cValue}.
  RETURN cValue.

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

&IF DEFINED(EXCLUDE-getSDFFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDFFileName Procedure 
FUNCTION getSDFFileName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get SDFFileName cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDFTemplate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDFTemplate Procedure 
FUNCTION getSDFTemplate RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get SDFTemplate cValue}.
  RETURN cValue.

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
  {get ViewerLinkedWidgets cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION insertExpression Procedure 
FUNCTION insertExpression RETURNS CHARACTER PRIVATE
  (pcWhere      AS CHAR,   
   pcExpression AS CHAR,     
   pcAndOr      AS CHAR):                         
/*------------------------------------------------------------------------------
 Purpose:     Inserts an expression into ONE buffer's where-clause.
 Parameters:  
      pcWhere      - Complete where clause with or without the FOR keyword,
                     but without any comma before or after.
      pcExpression - New expression OR OF phrase (Existing OF phrase is replaced)
      pcAndOr      - Specifies what operator is used to add the new expression 
                     to existing ones.
                     - AND (default) 
                     - OR         
 Notes:       The new expression is embedded in parenthesis, but no parentheses
              are placed around the existing one.  
              Lock keywords must be unabbreviated or without -lock (i.e. SHARE
              or EXCLUSIVE.)   
              Any keyword in comments may cause problems.
              This is PRIVATE to query.p.   
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cTable        AS CHAR NO-UNDO.  
  DEFINE VARIABLE cRelTable     AS CHAR NO-UNDO.  
  DEFINE VARIABLE cJoinTable    AS CHAR NO-UNDO.  
  DEFINE VARIABLE cWhereOrAnd   AS CHAR NO-UNDO.  
  DEFINE VARIABLE iTblPos       AS INT  NO-UNDO.
  DEFINE VARIABLE iWherePos     AS INT  NO-UNDO.
  DEFINE VARIABLE lWhere        AS LOG  NO-UNDO.
  DEFINE VARIABLE iOfPos        AS INT  NO-UNDO.
  DEFINE VARIABLE iRelTblPos    AS INT  NO-UNDO.  
  DEFINE VARIABLE iInsertPos    AS INT  NO-UNDO.    

  DEFINE VARIABLE iUseIdxPos    AS INT  NO-UNDO.        
  DEFINE VARIABLE iOuterPos     AS INT  NO-UNDO.        
  DEFINE VARIABLE iLockPos      AS INT  NO-UNDO.      

  DEFINE VARIABLE iByPos        AS INT  NO-UNDO.        
  DEFINE VARIABLE iIdxRePos     AS INT  NO-UNDO.        

  ASSIGN 
    cTable        = whereClauseBuffer(pcWhere)
    iTblPos       = INDEX(pcWhere,cTable) + LENGTH(cTable,"CHARACTER":U)

    iWherePos     = INDEX(pcWhere," WHERE ":U) + 6    
    iByPos        = INDEX(pcWhere," BY ":U)    
    iUseIdxPos    = INDEX(pcWhere," USE-INDEX ":U)    
    iIdxRePos     = INDEX(pcWhere + " ":U," INDEXED-REPOSITION ":U)    
    iOuterPos     = INDEX(pcWhere + " ":U," OUTER-JOIN ":U)     
    iLockPos      = MAX(INDEX(pcWhere + " ":U," NO-LOCK ":U),
                        INDEX(pcWhere + " ":U," SHARE-LOCK ":U),
                        INDEX(pcWhere + " ":U," EXCLUSIVE-LOCK ":U),
                        INDEX(pcWhere + " ":U," SHARE ":U),
                        INDEX(pcWhere + " ":U," EXCLUSIVE ":U)
                        )    
    iInsertPos    = LENGTH(pcWhere) + 1 
                    /* We must insert before the leftmoust keyword,
                       unless the keyword is Before the WHERE keyword */ 
    iInsertPos    = MIN(
                      (IF iLockPos   > iWherePos THEN iLockPos   ELSE iInsertPos),
                      (IF iOuterPos  > iWherePos THEN iOuterPos  ELSE iInsertPos),
                      (IF iUseIdxPos > iWherePos THEN iUseIdxPos ELSE iInsertPos),
                      (IF iIdxRePos  > iWherePos THEN iIdxRePos  ELSE iInsertPos),
                      (IF iByPos     > iWherePos THEN iByPos     ELSE iInsertPos)
                       )                                                        
    lWhere        = INDEX(pcWhere," WHERE ":U) > 0 
    cWhereOrAnd   = (IF NOT lWhere          THEN " WHERE ":U 
                     ELSE IF pcAndOr = "":U OR pcAndOr = ? THEN " AND ":U 
                     ELSE " ":U + pcAndOr + " ":U) 
    iOfPos        = INDEX(pcWhere," OF ":U).

  IF LEFT-TRIM(pcExpression) BEGINS "OF ":U THEN 
  DO:   
    /* If there is an OF in both the join and existing query we replace the 
       table unless they are the same */      
    IF iOfPos > 0 THEN 
    DO:
      ASSIGN
        /* Find the table in the old join */               
        cRelTable  = ENTRY(1,LEFT-TRIM(SUBSTRING(pcWhere,iOfPos + 4))," ":U)      
        /* Find the table in the new join */       
        cJoinTable = SUBSTRING(LEFT-TRIM(pcExpression),3).

      IF cJoinTable <> cRelTable THEN
        ASSIGN 
         iRelTblPos = INDEX(pcWhere + " ":U," ":U + cRelTable + " ":U) 
                      + 1                            
         SUBSTRING(pcWhere,iRelTblPos,LENGTH(cRelTable)) = cJointable. 
    END. /* if iOfPos > 0 */ 
    ELSE 
      SUBSTRING(pcWhere,iTblPos,0) = " ":U + pcExpression.                                                                
  END. /* if left-trim(pcExpression) BEGINS "OF ":U */
  ELSE             
    SUBSTRING(pcWhere,iInsertPos,0) = cWhereOrAnd 
                                      + "(":U 
                                      + pcExpression 
                                      + ")":U. 

  RETURN RIGHT-TRIM(pcWhere).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newQueryString Procedure 
FUNCTION newQueryString RETURNS CHARACTER
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcDataTypes   AS CHARACTER,    
   pcOperators   AS CHARACTER,
   pcQueryString AS CHARACTER,
   pcAndOr       AS CHARACTER):
/*------------------------------------------------------------------------------   
   Purpose: Returns a new query string to the passed query. 
            The tables in the passed query must match getQueryTables().  
            Adds column/value pairs to the corresponding buffer's where-clause. 
            Each buffer's expression will always be embedded in parenthesis.
   Parameters: 
     pcColumns   - Column names (Comma separated) as table.fieldname                  

     pcValues    - corresponding Values (CHR(1) separated)
     pcDataTypes - corresponding data types (comma seperated)
     pcOperators - Operator - one for all columns
                              - blank - defaults to (EQ)  
                              - Use slash to define alternative string operator
                                EQ/BEGINS etc..
                            - comma separated for each column/value
     pcQueryString - A complete querystring matching the queries tables.
                     MUST be qualifed correctly.
                     ? - use the base query  
     pcAndOr       - AND or OR decides how the new expression is appended to 
                     the passed query (for each buffer!).                                               
   Notes:  This was taken from query.p but changed for lookups to work without an
           SDO.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBufferList    AS CHAR      NO-UNDO.
  DEFINE VARIABLE cBuffer        AS CHARACTER NO-UNDO.

  /* We need the columns name and the parts */  
  DEFINE VARIABLE cColumn        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColumnName    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE iBuffer        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iColumn        AS INTEGER   NO-UNDO.

  DEFINE VARIABLE cUsedNums      AS CHAR      NO-UNDO.

  /* Used to builds the column/value string expression */
  DEFINE VARIABLE cBufWhere      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataType      AS CHAR      NO-UNDO.
  DEFINE VARIABLE cQuote         AS CHAR      NO-UNDO.    
  DEFINE VARIABLE cValue         AS CHAR      NO-UNDO.  
  DEFINE VARIABLE cOperator      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cStringOp      AS CHARACTER NO-UNDO.

  {get QueryTables cBufferList}.    

  /* If unkown value is passed used the existing query string */
  IF pcQueryString = ? THEN
  DO:
    {get BaseQueryString pcQueryString}.      
  END. /* pcQueryString = ? */

  IF pcAndOr = "":U OR pcAndOr = ? THEN pcAndOr = "AND":U.   

  DO iBuffer = 1 TO NUM-ENTRIES(cBufferList):  
    ASSIGN
      cBufWhere      = "":U
      cBuffer        = ENTRY(iBuffer,cBufferList).

    ColumnLoop:    
    DO iColumn = 1 TO NUM-ENTRIES(pcColumns):

      IF CAN-DO(cUsedNums,STRING(iColumn)) THEN 
        NEXT ColumnLoop.      

      cColumn     = ENTRY(iColumn,pcColumns).

      /* Unqualified fields will use the first buffer in the query */
      IF INDEX(cColumn,".":U) = 0 THEN       
        cColumn = cBuffer + ".":U + cColumn.

      /* Wrong buffer? */
      IF NOT (cColumn BEGINS cBuffer + ".":U) THEN NEXT ColumnLoop.

      ASSIGN
        /* Get the operator for this valuelist. 
           Be forgiving and make sure we handle '',? and '/begins' as default */                                                  
        cOperator   = IF pcOperators = "":U 
                      OR pcOperators BEGINS "/":U 
                      OR pcOperators = ?                       
                      THEN "=":U 
                      ELSE IF NUM-ENTRIES(pcOperators) = 1 
                           THEN ENTRY(1,pcOperators,"/":U)                                                 
                           ELSE ENTRY(iColumn,pcOperators)

        /* Look for optional string operator if only one entry in operator */          
        cStringOp   = IF NUM-ENTRIES(pcOperators) = 1 
                      AND NUM-ENTRIES(pcOperators,"/":U) = 2  
                      THEN ENTRY(2,pcOperators,"/":U)                                                 
                      ELSE cOperator                    
        cColumnName = ENTRY(NUM-ENTRIES(cColumn,".":U),cColumn,".":U)              
        cDataType   = ENTRY(iColumn,pcDataTypes).

      IF cDataType <> ? THEN
      DO:
        ASSIGN          
          cValue     = ENTRY(iColumn,pcValues,CHR(1))                         
          cValue     = IF CAN-DO("INTEGER,DECIMAL":U,cDataType) AND cValue = "":U 
                       THEN "0":U 
                       ELSE IF cDataType = "DATE":U and cValue = "":U
                       THEN "?":U 
                       ELSE IF cValue = ? /*This could happen if only one value*/
                       THEN "?":U 
                       ELSE cValue
          cValue     = (IF cValue <> "":U 
                        THEN REPLACE(cValue,"'","~~~'")
                        ELSE " ":U) 
          cQuote     = (IF cDataType = "CHARACTER":U AND cValue = "?" 
                        THEN "":U 
                        ELSE "'":U)
          cBufWhere  = cBufWhere 
                       + (If cBufWhere = "":U 
                          THEN "":U 
                          ELSE " ":U + "AND":U + " ":U)
                       + cColumn 
                       + " ":U
                       + (IF cDataType = "CHARACTER":U  
                          THEN cStringOp
                          ELSE cOperator)
                       + " ":U
                       + cQuote  
                       + cValue
                       + cQuote
          cUsedNums  = cUsedNums
                       + (IF cUsedNums = "":U THEN "":U ELSE ",":U)
                       + STRING(iColumn).

      END. /* if cDatatype <> ? */          
    END. /* do iColumn = 1 to num-entries(pColumns) */    
    /* We have a new expression */                               
    IF cBufWhere <> "":U THEN
      ASSIGN 
        pcQueryString = DYNAMIC-FUNCTION("newWhereClause":U IN TARGET-PROCEDURE, INPUT cBuffer, INPUT cBufWhere, INPUT pcQueryString, INPUT pcAndOr).
  END. /* do iBuffer = 1 to hQuery:num-buffers */
  RETURN pcQueryString.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newWhereClause) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newWhereClause Procedure 
FUNCTION newWhereClause RETURNS CHARACTER
  (pcBuffer     AS CHAR,   
   pcExpression AS char,  
   pcWhere      AS CHAR,
   pcAndOr      AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:     Inserts a new expression to query's prepare string for a specified 
               buffer.
  Parameters:  pcBuffer     - Which buffer.
               pcExpression - The new expression. 
               pcWhere      - The current query prepare string.
               pcAndOr      - Specifies what operator is used to add the new
                              expression to existing expression(s)
                              - AND (default) 
                              - OR                                                
  Notes:       This is a utility function that doesn't use any properties.             
------------------------------------------------------------------------------*/
 DEFINE VARIABLE iComma      AS INT    NO-UNDO. 
 DEFINE VARIABLE iCount      AS INT    NO-UNDO.
 DEFINE VARIABLE iStart      AS INT    NO-UNDO.
 DEFINE VARIABLE iLength     AS INT    NO-UNDO.
 DEFINE VARIABLE iEnd        AS INT    NO-UNDO.
 DEFINE VARIABLE cWhere      AS CHAR   NO-UNDO.
 DEFINE VARIABLE cString     AS CHAR   NO-UNDO.
 DEFINE VARIABLE cFoundWhere AS CHAR   NO-UNDO.
 DEFINE VARIABLE cNextWhere  AS CHAR   NO-UNDO.
 DEFINE VARIABLE hQuery      AS HANDLE NO-UNDO.

  /* Astra2  - fix European decimal format issues with Astra object numbers in query string
     FYI: fixQueryString is a function in smartcustom.p
  */
  pcWhere = DYNAMIC-FUNCTION("fixQueryString":U IN TARGET-PROCEDURE, INPUT pcWhere). /* Astra2 */

 ASSIGN
   cString = pcWhere
   iStart  = 1.          

 DO WHILE TRUE:

   iComma  = INDEX(cString,","). 

   /* If a comma was found we split the string into cFoundWhere and cNextwhere */  
   IF iComma <> 0 THEN 
     ASSIGN
       cFoundWhere = cFoundWhere + SUBSTR(cString,1,iComma)
       cNextWhere  = SUBSTR(cString,iComma + 1)     
       iCount      = iCount + iComma.       
   ELSE 

     /* cFoundWhere is blank if this is the first time or if we have moved on 
        to the next buffers where clause
        If cFoundwhere is not blank the last comma that was used to split 
        the string into cFoundwhere and cNextwhere was not a join, 
        so we must set them together again.   
     */     
     cFoundWhere = IF cFoundWhere = "":U 
                   THEN cString
                   ELSE cFoundWhere + cNextwhere.

   /* We have a complete table whereclause if there are no more commas
      or the next whereclause starts with each,first or last */    
   IF iComma = 0 
   OR CAN-DO("EACH,FIRST,LAST":U,ENTRY(1,TRIM(cNextWhere)," ":U)) THEN
   DO:
     /* Remove comma or period before inserting the new expression */
     ASSIGN
       cFoundWhere = RIGHT-TRIM(cFoundWhere,",.":U) 
       iLength     = LENGTH(cFoundWhere).

     IF whereClauseBuffer(cFoundWhere) = pcBuffer  THEN
     DO:   
       SUBSTR(pcWhere,iStart,iLength) = insertExpression(cFoundWhere,
                                                         pcExpression,
                                                         pcAndOr).           
       LEAVE.
     END.
     ELSE
       /* We're moving on to the next whereclause so reset cFoundwhere */ 
       ASSIGN      
         cFoundWhere = "":U                     
         iStart      = iCount + 1.      

     /* No table found and we are at the end so we need to get out of here */  
     IF iComma = 0 THEN 
     DO:
       /* (Buffer is not in query) Is this a run time error ? */.
       LEAVE.    
     END.
   END. /* if iComma = 0 or can-do(EACH,FIRST,LAST */
   cString = cNextWhere.  
 END. /* do while true. */
 RETURN pcWhere.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBaseQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBaseQueryString Procedure 
FUNCTION setBaseQueryString RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set BaseQueryString pcValue}.
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
  DEFINE VARIABLE hRealContainer    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cContainerMode    AS CHARACTER NO-UNDO.


  {get containerSource hContainer}.
  {get containerSource hRealContainer hContainer}.

  IF VALID-HANDLE(hRealContainer) THEN
    {get ContainerMode cContainerMode hRealContainer}.
  
  IF cContainerMode <> "add":U THEN
  DO:
    &SCOPED-DEFINE xpDataValue
    {set DataValue pcValue}.
    &UNDEFINE xpDataValue
    {get LookupHandle hLookup}.
    IF VALID-HANDLE(hLookup) THEN
    DO:
      {get KeyField cKeyField}.
      {get DisplayedField cDisplayedField}.
      IF cKeyField = cDisplayedField THEN  
        ASSIGN hLookup:SCREEN-VALUE = pcValue.
      ELSE DO:
        IF pcValue = "":U OR pcValue = "0":U THEN
          ASSIGN hLookup:SCREEN-VALUE = "":U.
      END.
      {set DisplayValue hLookup:SCREEN-VALUE}. /* avoid leave trigger code */
    END.
  END.
  ELSE
  DO: /* in an add - ensure lookup screen value is cleared */
      DEFINE VARIABLE pcKeyValue         AS CHARACTER  NO-UNDO.
      DEFINE VARIABLE cNewRecord         AS CHARACTER  NO-UNDO.
      &SCOPED-DEFINE xpDataValue
      {get DataValue pcKeyValue}.
      &UNDEFINE xpDataValue
      {get LookupHandle hLookup}.
      {get newRecord cNewRecord hContainer}.

      IF cNewRecord <> "no":U AND
         pcValue <> "":U AND pcValue <> "0":U THEN
      DO: /* must be a reset operation or after a succesful save - reset value */
        &SCOPED-DEFINE xpDataValue
        {set DataValue pcValue}.
        &UNDEFINE xpDataValue
        IF VALID-HANDLE(hLookup) THEN
        DO:
          {get KeyField cKeyField}.
          {get DisplayedField cDisplayedField}.
          IF cKeyField = cDisplayedField THEN  
            hLookup:SCREEN-VALUE = pcValue.
          {set DisplayValue hLookup:SCREEN-VALUE}. /* avoid leave trigger code */
        END.
      END.

      /* clear values on add - once */
      IF (pcValue = "":U OR pcValue = "0":U) /*AND pcKeyValue <> "":U AND pcKeyValue <> "0":U*/ THEN
      DO:
        ASSIGN pcValue = "":U.
        &SCOPED-DEFINE xpDataValue
        {set DataValue pcValue}.
        &UNDEFINE xpDataValue
        IF VALID-HANDLE(hLookup) THEN
        DO:
          hLookup:SCREEN-VALUE = pcValue.
          {set DisplayValue hLookup:SCREEN-VALUE}. /* avoid leave trigger code */
        END.
      END.
  END.
  
  {set Modify TRUE}.      
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisplayDataType Procedure 
FUNCTION setDisplayDataType RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set DisplayDataType pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayedField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisplayedField Procedure 
FUNCTION setDisplayedField RETURNS LOGICAL
  ( pcDisplayedField AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Stores the name of the field to display in the selection
Parameters: INPUT pcDisplayedField - fieldname    
    Notes:   
------------------------------------------------------------------------------*/
  {set DisplayedField pcDisplayedField}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisplayFormat Procedure 
FUNCTION setDisplayFormat RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set DisplayFormat pcValue}.
  RETURN TRUE.

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
  
  {get LookupHandle hLookup}.
  {get ContainerHandle hFrame}.
  
  IF VALID-HANDLE(hLookup) THEN
  DO:
   {get ButtonHandle hButton}.
   {get LabelHandle hLabel}.
  
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

&IF DEFINED(EXCLUDE-setFieldLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldLabel Procedure 
FUNCTION setFieldLabel RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/

  {set FieldLabel pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldToolTip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldToolTip Procedure 
FUNCTION setFieldToolTip RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set FieldToolTip pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setKeyDataType Procedure 
FUNCTION setKeyDataType RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set KeyDataType pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setKeyField Procedure 
FUNCTION setKeyField RETURNS LOGICAL
  ( pcKeyField AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Stores the name of the key field
Parameters: INPUT pcKeyField - fieldname    
    Notes:   
------------------------------------------------------------------------------*/
  {set KeyField pcKeyField}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setKeyFormat Procedure 
FUNCTION setKeyFormat RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set KeyFormat pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLabelHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLabelHandle Procedure 
FUNCTION setLabelHandle RETURNS LOGICAL
  ( phValue AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set LabelHandle phValue}.
  RETURN TRUE.

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

&IF DEFINED(EXCLUDE-setParentField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setParentField Procedure 
FUNCTION setParentField RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the Parent field name of this lookup's parent dependant object
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set ParentField pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setParentFilterQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setParentFilterQuery Procedure 
FUNCTION setParentFilterQuery RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the Parent object's foreign fields
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set ParentFilterQuery pcValue}.
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
  {set QueryTables pcValue}.
  RETURN TRUE.

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

&IF DEFINED(EXCLUDE-setSDFFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSDFFileName Procedure 
FUNCTION setSDFFileName RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the SmartDataField file name 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set SDFFileName pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSDFTemplate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSDFTemplate Procedure 
FUNCTION setSDFTemplate RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the SmartDataField template file name 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set SDFTemplate pcValue}.
  RETURN TRUE.

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
  {set ViewerLinkedFields pcValue}.
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
  {set ViewerLinkedWidgets pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

