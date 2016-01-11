&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
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
    File        : filter.p
    Purpose     : Super procedure for filter class.

    Syntax      : RUN start-super-proc("adm2/filter.p":U).

    Modified    : 06/28/1999
    Modified    : 10/24/2001        Mark Davies (MIP)
                  Set new property FilterAvailable to TRUE. This will ensure
                  that the Filter button is enabled on the toolbar.
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&SCOPED-DEFINE ADMSuper filter.p
&SCOPED-DEFINE charformat 'x(256)':U
  /* Custom exclude file */

  {src/adm2/custom/filterexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-assignColumnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnFormat Procedure 
FUNCTION assignColumnFormat RETURNS LOGICAL
  (pcColumn AS CHAR,
   pcFormat AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnHelpId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnHelpId Procedure 
FUNCTION assignColumnHelpId RETURNS LOGICAL
  (pcColumn AS CHAR,
   piHelpId AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnLabel Procedure 
FUNCTION assignColumnLabel RETURNS LOGICAL
  (pcColumn AS CHAR,
   pcLabel  AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnOperatorStyle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnOperatorStyle Procedure 
FUNCTION assignColumnOperatorStyle RETURNS LOGICAL
  (pcColumn AS CHAR,
   pcStyle  AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnTooltip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnTooltip Procedure 
FUNCTION assignColumnTooltip RETURNS LOGICAL
  (pcColumn AS CHAR,
   pcTooltip  AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnWidth Procedure 
FUNCTION assignColumnWidth RETURNS LOGICAL
  (pcColumn AS CHAR,
   pdWidth  AS DEC) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-blankField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD blankField Procedure 
FUNCTION blankField RETURNS LOGICAL
  ( phField      AS HANDLE,
    phRangeField AS HANDLE,
    phOperator   AS HANDLE) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-blankFillIn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD blankFillIn Procedure 
FUNCTION blankFillIn RETURNS LOGICAL
  (phFillIn As HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-blankNumericFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD blankNumericFormat Procedure 
FUNCTION blankNumericFormat RETURNS LOGICAL
  ( phField AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  (pcColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnFilterTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnFilterTarget Procedure 
FUNCTION columnFilterTarget RETURNS HANDLE
  ( pcColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnFormat Procedure 
FUNCTION columnFormat RETURNS CHARACTER
  (pcColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHelpId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnHelpId Procedure 
FUNCTION columnHelpId RETURNS INTEGER
  (pcColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnLabel Procedure 
FUNCTION columnLabel RETURNS CHARACTER
  (pcColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLabelDefault) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnLabelDefault Procedure 
FUNCTION columnLabelDefault RETURNS LOGICAL
   (pcColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnOperatorStyle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnOperatorStyle Procedure 
FUNCTION columnOperatorStyle RETURNS CHARACTER
  (pcColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnStyleDefault) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnStyleDefault Procedure 
FUNCTION columnStyleDefault RETURNS LOGICAL
   (pcColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTooltip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnTooltip Procedure 
FUNCTION columnTooltip RETURNS CHARACTER
  (pcColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnWidth Procedure 
FUNCTION columnWidth RETURNS DECIMAL
  (pcColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnWidthDefault) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnWidthDefault Procedure 
FUNCTION columnWidthDefault RETURNS LOGICAL
   (pcColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createField Procedure 
FUNCTION createField RETURNS HANDLE
  (phFrame    AS HANDLE,
   pcName     AS CHAR,
   pcDataType AS CHAR,
   pcViewAs   AS CHAR,
   pcFormat   AS CHAR,
   plEnable   AS LOG,
   pcTooltip  AS CHAR,
   piHelpid   AS INT,
   pdRow      AS DEC,
   pdCol      AS DEC,
   pdHeight   AS DEC,   
   pdWidth    AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createLabel Procedure 
FUNCTION createLabel RETURNS HANDLE
  (phField AS HANDLE,
   pcLabel AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createOperator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createOperator Procedure 
FUNCTION createOperator RETURNS HANDLE
  (phField  AS HANDLE,
   pcType   AS CHAR,
   pcValues AS CHAR,
   pdCol    AS DEC,
   pdWidth  AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dataValue Procedure 
FUNCTION dataValue RETURNS CHARACTER
  (pcColumn AS CHAR,
   pcValue  AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteObjects Procedure 
FUNCTION deleteObjects RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fieldLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fieldLookup Procedure 
FUNCTION fieldLookup RETURNS INTEGER PRIVATE
  (pcField AS CHAR,
   pcList  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fieldProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fieldProperty Procedure 
FUNCTION fieldProperty RETURNS CHAR PRIVATE
  (pcList  AS CHAR,
   pcField AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataObject Procedure 
FUNCTION getDataObject RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDefaultCharWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDefaultCharWidth Procedure 
FUNCTION getDefaultCharWidth RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDefaultEditorLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDefaultEditorLines Procedure 
FUNCTION getDefaultEditorLines RETURNS DECIMAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDefaultLogical) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDefaultLogical Procedure 
FUNCTION getDefaultLogical RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDefaultWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDefaultWidth Procedure 
FUNCTION getDefaultWidth RETURNS DECIMAL
   ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisplayedFields Procedure 
FUNCTION getDisplayedFields RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEnabledFields Procedure 
FUNCTION getEnabledFields RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldColumn Procedure 
FUNCTION getFieldColumn RETURNS DECIMAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldFormats) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldFormats Procedure 
FUNCTION getFieldFormats RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldHelpIds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldHelpIds Procedure 
FUNCTION getFieldHelpIds RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldLabels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldLabels Procedure 
FUNCTION getFieldLabels RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldOperatorStyles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldOperatorStyles Procedure 
FUNCTION getFieldOperatorStyles RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldToolTips) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldToolTips Procedure 
FUNCTION getFieldToolTips RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldWidths) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldWidths Procedure 
FUNCTION getFieldWidths RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFilterTarget Procedure 
FUNCTION getFilterTarget RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFilterTargetEvents Procedure 
FUNCTION getFilterTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOperator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOperator Procedure 
FUNCTION getOperator RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOperatorLongValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOperatorLongValues Procedure 
FUNCTION getOperatorLongValues RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOperatorStyle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOperatorStyle Procedure 
FUNCTION getOperatorStyle RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOperatorViewAs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOperatorViewAs Procedure 
FUNCTION getOperatorViewAs RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseBegins) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUseBegins Procedure 
FUNCTION getUseBegins RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseContains) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUseContains Procedure 
FUNCTION getUseContains RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getViewAsFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getViewAsFields Procedure 
FUNCTION getViewAsFields RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getVisualBlank) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getVisualBlank Procedure 
FUNCTION getVisualBlank RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertFieldProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD insertFieldProperty Procedure 
FUNCTION insertFieldProperty RETURNS CHARACTER PRIVATE
  (pcList  AS CHAR,
   pcField AS CHAR,
   pcValue AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataObject Procedure 
FUNCTION setDataObject RETURNS LOGICAL
  ( pcDataObject AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDefaultCharWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDefaultCharWidth Procedure 
FUNCTION setDefaultCharWidth RETURNS LOGICAL
  ( pdDefaultCharWidth AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDefaultEditorLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDefaultEditorLines Procedure 
FUNCTION setDefaultEditorLines RETURNS LOGICAL
  ( piLines AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDefaultLogical) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDefaultLogical Procedure 
FUNCTION setDefaultLogical RETURNS LOGICAL
  ( pcDefaultLogical AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDefaultWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDefaultWidth Procedure 
FUNCTION setDefaultWidth RETURNS LOGICAL
  ( pdDefaultWidth AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisplayedFields Procedure 
FUNCTION setDisplayedFields RETURNS LOGICAL
  ( pcDisplayedFields AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnabledFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEnabledFields Procedure 
FUNCTION setEnabledFields RETURNS LOGICAL
  ( pcEnabledFields AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldColumn Procedure 
FUNCTION setFieldColumn RETURNS LOGICAL
  ( pcFieldColumn AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldFormats) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldFormats Procedure 
FUNCTION setFieldFormats RETURNS LOGICAL
  ( pcFieldFormats AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldHelpIds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldHelpIds Procedure 
FUNCTION setFieldHelpIds RETURNS LOGICAL
  ( pcFieldHelpIds AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldLabels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldLabels Procedure 
FUNCTION setFieldLabels RETURNS LOGICAL
  ( pcFieldLabels AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldOperatorStyles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldOperatorStyles Procedure 
FUNCTION setFieldOperatorStyles RETURNS LOGICAL
  ( pcFieldOperatorStyles AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldToolTips) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldToolTips Procedure 
FUNCTION setFieldToolTips RETURNS LOGICAL
  ( pcFieldToolTips AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldWidths) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldWidths Procedure 
FUNCTION setFieldWidths RETURNS LOGICAL
  ( pcFieldWidths AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFilterTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFilterTarget Procedure 
FUNCTION setFilterTarget RETURNS LOGICAL
  (pcTarget AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFilterTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFilterTargetEvents Procedure 
FUNCTION setFilterTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOperator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOperator Procedure 
FUNCTION setOperator RETURNS LOGICAL
  ( pcOperator AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOperatorStyle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOperatorStyle Procedure 
FUNCTION setOperatorStyle RETURNS LOGICAL
  ( pcOperatorStyle AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOperatorViewAs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOperatorViewAs Procedure 
FUNCTION setOperatorViewAs RETURNS LOGICAL
  ( pcOperatorViewAs AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUseBegins) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUseBegins Procedure 
FUNCTION setUseBegins RETURNS LOGICAL
  (plUseBegins AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUseContains) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUseContains Procedure 
FUNCTION setUseContains RETURNS LOGICAL
  (plUseContains AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setViewAsFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setViewAsFields Procedure 
FUNCTION setViewAsFields RETURNS LOGICAL
  ( pcViewAsFields AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setVisualBlank) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setVisualBlank Procedure 
FUNCTION setVisualBlank RETURNS LOGICAL
  (pcVisual AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showDataMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD showDataMessages Procedure 
FUNCTION showDataMessages RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-unBlankFillin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD unBlankFillin Procedure 
FUNCTION unBlankFillin RETURNS LOGICAL
  ( phField AS HANDLE)  FORWARD.

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
         HEIGHT             = 13.33
         WIDTH              = 58.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/filtprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-applyFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyFilter Procedure 
PROCEDURE applyFilter :
/*------------------------------------------------------------------------------
  Purpose: Apply filter criteria to the filter-target     
  Parameters:  
  Notes:   The procedure parses the dynamic filter fields and builds a list
           of fields, operators and values to pass to the query. 
           The fields are only added to the list if the field or the operator 
           is MODIFIED. (We may need a better mechanism to identify  
           actually blanks vlaues that needs to be added to the query)
           If columnQuerySelection returns any criteria for the field with an
           operator that are not in the list to add it will be 
           added to a list of fields and operators to remove form the query. 
           The operator for the field is either
           - In a separate widget. (combo-box or radio-set).
           - If wildcard in the value we use MATCHES or BEGINS.
           - GE and LE if there is a range field with a second value.
           - First blank separated entry in the field if OperatorStyle is set 
             to "inline"
           - Implicit specified by the Operator property. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iField           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hField           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE EnabledHandles    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldNames      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldValues     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRangeValue      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cField           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValue           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOperator        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRemoveFields    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hOperator        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRangeField      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cOperatorStyle   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOperatorHandles AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDefaultOperator AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldOperators  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOldSelection    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOldOperator     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOldValue        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRemoveoperators AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lUseBegins       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lRange           AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iWildCard        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iWildCardChar    AS INTEGER   NO-UNDO.

  DEFINE VARIABLE hFilterTarget    AS HANDLE    NO-UNDO.      
  DEFINE VARIABLE cFilterTarget    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iValue           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lCancel          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hdl              AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lFirst           AS LOG       NO-UNDO.

  DEFINE VARIABLE xcInlineOpList   AS CHAR      NO-UNDO INIT ">=,>,<,<=":U.
  DEFINE VARIABLE xcRangeOperator  AS CHAR      NO-UNDO INIT "<=":U.
     
  {get EnabledHandles EnabledHandles}.
  {get OperatorHandles cOperatorHandles}.
  {get OperatorStyle cOperatorStyle}.
  {get Operator cDefaultOperator}.
  {get useBegins lUseBegins}.
  {get FilterTarget cFilterTarget}.
  
  /* What happened to the intention to support multiple filter targets ?*/
  hFilterTarget = WIDGET-HANDLE(cFilterTarget).
 
  IF NOT VALID-HANDLE(hFilterTarget) THEN
     RETURN.
   
  /* Is there any unsaved or uncommitted data? */ 
  RUN confirmContinue IN hFilterTarget (INPUT-OUTPUT lCancel).
  IF lCancel THEN RETURN.

  DO iField = 1 TO NUM-ENTRIES(EnabledHandles):
    ASSIGN
      hField      = WIDGET-HANDLE(ENTRY(iField,EnabledHandles))
      hOperator   = ?
      hRangeField = ?
      cField      = (IF NUM-ENTRIES(hField:NAME,".":U) = 1 
                     THEN "RowObject.":U ELSE "":U) 
                     + hField:NAME
      cOperator   = "":U.
      
    /* Chweck if we have a true operator or a range field */
    IF cOperatorHandles <> "":U THEN
    DO:
       hdl = WIDGET-HANDLE(ENTRY(iField,cOperatorHandles)).
       IF VALID-HANDLE(hdl) THEN
       DO:
         IF hdl:TYPE = "FILL-IN":U THEN 
            hRangeField = hdl.
         ELSE 
            hOperator   = hdl.  
       END. /* if valid hdl */ 
    END. /* if cOperatorhandle <> '' */
    
    /* The removeSpace trigger is currently not used for editors, so deal 
       with blank versus empty here..  */
    IF hField:TYPE = 'EDITOR':U 
    AND hField:INPUT-VALUE = ''
    AND (LENGTH(hField:INPUT-VALUE) = 0 
         OR 
         hOperator:SCREEN-VALUE = 'Contains':U) THEN

      hField:MODIFIED = FALSE.

    IF hField:MODIFIED 
    OR (VALID-HANDLE(hOperator) AND hOperator:MODIFIED) THEN
    DO:
      ASSIGN
        cValue        = hField:INPUT-VALUE
        cOperator     = cDefaultOperator
        iWildCardChar = INDEX(cValue,".":U)
        iWildCard     = INDEX(cValue,"*":U)
        iWildCard     = IF lUseBegins AND iWildCard = LENGTH(cValue) 
                        THEN 0
                        ELSE iWildCard
        iWildCard     = IF iWildCard > 0 AND iWildCardChar > 0
                        THEN MIN(iWildCard,iWildCardChar) 
                        ELSE MAX(iWildCard,iWildCardChar). 
      
      /* A valid hOperator means that the screen-value holds the operator */ 
      IF VALID-HANDLE(hOperator) THEN   
        cOperator = hOperator:SCREEN-VALUE.            
      
      ELSE IF hField:TYPE = "EDITOR":U THEN
        cOperator = "CONTAINS":U.
      /* If wildcard in data, check if we must use matches or begins.
         If begins remove wildcard */
      ELSE IF iWildCard > 0 THEN
        ASSIGN
          cOperator = IF  iWildCardChar = 0
                      AND iWildCard = LENGTH(cValue)  
                      THEN "BEGINS":U
                      ELSE "MATCHES":U
          cValue    = IF cOperator = "BEGINS":U 
                      THEN SUBSTR(cValue,1,iWildCard - 1)
                      ELSE cValue.
                      
      ELSE IF VALID-HANDLE(hRangeField) THEN   
        cOperator = ">=":U.
        
      ELSE IF hField:DATA-TYPE = "CHARACTER":U THEN
      DO: 
        IF cValue <> "":U 
        AND cOperatorStyle = "INLINE":U 
        AND CAN-DO(xcInlineOpList,ENTRY(1,cValue," ":U)) THEN
          ASSIGN 
            cOperator = ENTRY(1,cValue," ":U)
            cValue    = SUBSTR(cValue,LENGTH(cOperator) + 2).
        ELSE IF lUseBegins 
             AND {fnarg columnDataType hField:NAME} = "CHARACTER":U THEN 
          cOperator = "BEGINS":U.
      END. /* else if hField:data-type = CHAR */  
      
      /* This is not needed to remove formats as we are using INPUT-VALUE,
         but it's useful for data-type checking when inline */  
      cValue =    DYNAMIC-FUNCTION("dataValue":U IN TARGET-PROCEDURE,
                                    hField:NAME,
                                    cValue).
    END.                             


      /* Should we add the rangefield screen-value  
         Note that blank is not supported */
    lRange = VALID-HANDLE(hRangeField) AND hRangeField:MODIFIED AND
             hRangeField:SCREEN-VALUE <> "":U.
     
    /* Find all old criteria for this field and add them to the list of 
       field/operators to remove.
       Currently we don't care about checking if the value already is 
       in the query. */    
    
    cOldSelection = {fnarg columnQuerySelection cField hFilterTarget}.    
    IF cOldSelection <> "":U THEN
    DO iValue = 1 TO NUM-ENTRIES(cOldSelection,CHR(1)) BY 2:
      ASSIGN
        cOldOperator = ENTRY(iValue,cOldSelection,CHR(1))
        cOldValue    = ENTRY(iValue + 1,cOldSelection,CHR(1)).
      
      IF cOldOperator <> cOperator 
      OR (cOldOperator = xcRangeoperator AND NOT lRange) THEN 
        ASSIGN
          lFirst           = cRemoveFields = "":U
          cRemoveFields    = (IF lFirst THEN cField   
                              ELSE cRemoveFields +  ",":U + cField)
          cRemoveOperators = (IF lFirst THEN cOldOperator  
                              ELSE cRemoveOperators + ",":U + cOldOperator).
    END. /* if cOldSelection <> "":U then DO iValue = 1 TO NUM-ENTRIES */
    
    /* if coperator is set we have a value to add to the list */ 
    IF cOperator <> "":U THEN   
      ASSIGN                   
         /*  We may have blank entries so we cannot do 'if  = '' and 
            this also is a problem when trying to trim, so we use a logical */ 
         lFirst          = cFieldNames = "":U  
         cFieldNames     = (IF lFirst THEN cField 
                            ELSE           cFieldNames + ",":U + cField) 
         cFieldOperators = (IF lFirst THEN cOperator
                            ELSE cFieldOperators + "," + cOperator)
         cFieldValues    = (IF lFirst 
                            THEN '':U 
                            ELSE cFieldValues + CHR(1))
                            + (IF cValue= ? THEN '?':U ELSE cValue).
    
    IF lRange THEN    
      ASSIGN
        /*  We may gave blank entries so we cannot do 'if  = '' and 
           this also is a problem when trying to trim, so we use a logical */ 
         lFirst          = cFieldNames = "":U  
         cFieldNames     = (IF lFirst THEN cField 
                            ELSE           cFieldNames + ",":U + cField) 
         cFieldOperators = (IF lFirst THEN cOperator
                            ELSE cFieldOperators + ",":U + "<=":U)
         cFieldValues    = (IF lFirst 
                            THEN '':U
                            ELSE cFieldValues + CHR(1))
                         + (IF hRangeField:SCREEN-VALUE = ? THEN '?':U ELSE hRangeField:SCREEN-VALUE).
    
  END. /*  do iField = 1 to .. */
  
  IF {fn anyMessage} THEN
  DO:
    cField = {fn showDataMessages}.
    RUN applyEntry IN TARGET-PROCEDURE (cfield). 
  END.

  ELSE DO:
    IF cRemoveFields <> "":U THEN
      DYNAMIC-FUNC("removeQuerySelection":U IN hFilterTarget,
                      cRemoveFields,
                      cRemoveOperators).
    IF cFieldNames <> "":U THEN                  
      DYNAMIC-FUNC("assignQuerySelection":U IN hFilterTarget,
                      cFieldNames,
                      cFieldValues,
                      cFieldOperators).
    
    DYNAMIC-FUNC('openQuery' IN hFilterTarget).
  END.

  RETURN.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-blankFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE blankFields Procedure 
PROCEDURE blankFields :
/*------------------------------------------------------------------------------
  Purpose: Set all filter fields to blank and unmodified    
  Parameters:  <none>
  Notes:     
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hFrameField      AS HANDLE    NO-UNDO.
 DEFINE VARIABLE hOperator        AS HANDLE    NO-UNDO.
 DEFINE VARIABLE hdl              AS HANDLE    NO-UNDO.
 DEFINE VARIABLE hRangeField      AS HANDLE    NO-UNDO.
 DEFINE VARIABLE iValue           AS INTEGER   NO-UNDO.
 DEFINE VARIABLE cEnabledHandles  AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cOperatorHandles AS CHARACTER NO-UNDO.

 DEFINE VARIABLE cFormat          AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cFalseChar       AS CHARACTER NO-UNDO.

 {get EnabledHandles cEnabledHandles}.
 {get OperatorHandles cOperatorHandles}.
 
 DO iValue = 1 TO NUM-ENTRIES(cEnabledHandles):
   ASSIGN     
     hFrameField = WIDGET-HANDLE(ENTRY(iValue,cEnabledHandles))     
     hRangeField  = ?
     hOperator    = ?.
                               
   IF cOperatorHandles <> "":U THEN
   DO:
     hdl = WIDGET-HANDLE(ENTRY(iValue,cOperatorHandles)).
     IF VALID-HANDLE(hdl) THEN
     DO:
       IF hdl:TYPE = "FILL-IN":U THEN 
          hRangeField = hdl.
       ELSE 
          hOperator   = hdl.  
     END.
   END. /* if cOperatorhandle <> '' */
   
   DYNAMIC-FUNCTION("blankField":U IN TARGET-PROCEDURE,
                    hFrameField,
                    hRangeField,
                    hOperator).
                     
 END.
 RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose: This procedure is subscribed to the filter-target in order to 
           make sure that the filter reflects ForeignFields and values.     
  Parameters: pcRelative - NOT USED 
  Notes:   This is necessary in order not to override the Foreignfield 
           criteria in the query    
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcRelative AS CHAR   NO-UNDO.
  
  DEFINE VARIABLE cField            AS CHAR   NO-UNDO. 
  DEFINE VARIABLE hField            AS HANDLE NO-UNDO. 
  DEFINE VARIABLE cValue            AS CHAR   NO-UNDO. 
  DEFINE VARIABLE cForeignFields    AS CHAR   NO-UNDO. 
  DEFINE VARIABLE cForeignValues    AS CHAR   NO-UNDO. 
  DEFINE VARIABLE hFilterTarget     AS HANDLE NO-UNDO. 
  DEFINE VARIABLE cFilterTarget     AS CHAR   NO-UNDO. 
  DEFINE VARIABLE cDisplayedFields  AS CHAR   NO-UNDO. 
  DEFINE VARIABLE cFieldHandles     AS CHAR   NO-UNDO. 
  DEFINE VARIABLE i                 AS INTEGER NO-UNDO. 
  DEFINE VARIABLE cnt               AS INTEGER NO-UNDO. 
  DEFINE VARIABLE iField            AS INTEGER NO-UNDO. 
        
  {get FilterTarget cFilterTarget}.   /* Proc. handle of SDO. */
   hFilterTarget = WIDGET-HANDLE(cFilterTarget).   
   
   IF VALID-HANDLE(hFilterTarget) THEN
   DO:
     {get ForeignFields cForeignfields hFilterTarget}.
     {get ForeignValues cForeignValues hFilterTarget}.
     IF cForeignValues <> "":U THEN
     DO:
       {get FieldHandles cFieldHandles}.
       {get DisplayedFields cDisplayedFields}.
       DO i = 2 TO NUM-ENTRIES(cForeignFields) BY 2: 
         cField = ENTRY(i,cForeignFields).
         cnt = cnt + 1.
         iField = LOOKUP(cField,cDisplayedfields).
         IF iField <> 0 THEN 
         DO:
           hField = WIDGET-HANDLE(ENTRY(iField,cFieldHandles)).
           hField:SCREEN-VALUE = ENTRY(cnt,cForeignValues,CHR(1)).
         END.            
       END. /* i = 2 to */
     END. /* if cforeignvalues <> '' */
  END. /* valid filter */    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFields Procedure 
PROCEDURE disableFields :
/*------------------------------------------------------------------------------
  Purpose:     Disables fields in the ENABLED-FIELDS list
  Parameters:  <none> 
  Notes:      
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEnableFields AS CHARACTER NO-UNDO.  /* List of handles. */
  DEFINE VARIABLE iField        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hField        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hOperator     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cOperatorHandles AS CHAR   NO-UNDO.
  DEFINE VARIABLE lEnabled      AS LOGICAL   NO-UNDO.
  
  {get FieldsEnabled lEnabled}.
  IF lEnabled THEN
  DO:  
    {get EnabledHandles cEnableFields}.
    {get operatorHandles cOperatorHandles}.
       
      
    DO iField = 1 TO NUM-ENTRIES(cEnableFields):
      hField    = WIDGET-HANDLE(ENTRY(iField, cEnableFields)).
      hOperator = WIDGET-HANDLE(ENTRY(iField,cOperatorHandles)).
      
      IF NOT hField:HIDDEN THEN   /* Skip fields hidden for multi-layout etc. */
      DO:
        hField:READ-ONLY = yes.  
        IF VALId-HANDLE(hOperator) THEN
        DO:
          IF hOperator:TYPE = "FILL-IN":U THEN
            hOperator:READ-ONLY = TRUE.
          ELSE
            hOperator:SENSITIVE = FALSE.
        END.   
      END.  /* END DO NOT HIDDEN */
    END.     /* END DO iField     */
      
    {set fieldsEnabled no}.
  END.
                                           
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields Procedure 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Enables fields in the ENABLED-FIELDS list
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEnableFields AS CHARACTER NO-UNDO.  /* List of handles. */
  DEFINE VARIABLE iField        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hField        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hOperator     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cOperatorHandles AS CHAR   NO-UNDO.
  DEFINE VARIABLE lEnabled      AS LOGICAL   NO-UNDO.
  
  
  {get FieldsEnabled lEnabled}.
  {get EnabledHandles cEnableFields}.
  {get operatorHandles cOperatorHandles}.
  DO iField = 1 TO NUM-ENTRIES(cEnableFields):
    hField = WIDGET-HANDLE(ENTRY(iField, cEnableFields)).
    hOperator = WIDGET-HANDLE(ENTRY(iField,cOperatorHandles)).
    IF NOT hField:HIDDEN THEN   /* Skip fields hidden for multi-layout */
    DO:
      hField:SENSITIVE = yes.
      hField:READ-ONLY = no.     
      IF VALID-HANDLE(hOperator) THEN
      DO:
        IF hOperator:TYPE = "FILL-IN":U THEN
          hOperator:READ-ONLY = FALSE.
        hOperator:SENSITIVE = TRUE.
      END. 
    END.
  END.
      
  /* If the list of enabled field handles isn't set, it may because this
     object hasn't been fully initialized yet. So don't set the enabled
     flag because we may be through here again. */
  IF cEnableFields NE "":U THEN
    {set FieldsEnabled yes}.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Filter object initialization code.
  Parameters:  <none>
  Note:        Dynamic widgets are created for the list of fields specified 
               in DisplayedFields.
               The deleteObjects() function is called in order to clean up 
               to be able to reflect changes  in the  Instance Property dialog
             - WordIndexedFields property is NEVER checked again.
               Operator objects will assume that CONTAINS is allowed if 
               the filter field object type is EDITOR. 
               UseContains will also only work together with EDITOR fields. 
             - RANGE will NOT be used for wordindexed fields unless 
               UseContains is FALSE.      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFilterTarget     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cFilterTarget     AS CHAR      NO-UNDO.
  DEFINE VARIABLE hFrameField       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cFieldHandles     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cLabelHandles     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataColumns      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOperatorHandles  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOperatorStyle    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE dHeight           AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE dFieldColumn      AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE iNumSkipped       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iFieldSpacingPXL  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iFieldSeparatorPXL AS INTEGER   NO-UNDO.
  DEFINE VARIABLE dDefaultWidth     AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE dDefaultCharWidth AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE dWidth            AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE dRow              AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE iEditorLines      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE dMinHeight        AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE cOperatorViewAs   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOperatorShortValues AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOperatorLongValues  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOperator         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldFormats     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEnabledHandles   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDisplayedFields  AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE cUIBMode          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iField            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cField            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cLabel            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cToolTip          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iHelpId           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cOpValues         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hLabel            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hOperator         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cFormat           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataType         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hContainerHandle  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hField            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lWordIdx          AS LOG       NO-UNDO.
  DEFINE VARIABLE lUseContains      AS LOG       NO-UNDO.
  DEFINE VARIABLE cWordIdxFields    AS CHAR      NO-UNDO.
  DEFINE VARIABLE cForeignFields    AS CHAR      NO-UNDO.
  DEFINE VARIABLE dOperatorWidth    AS DEC       NO-UNDO.
  DEFINE VARIABLE iOp               AS INT       NO-UNDO.
  DEFINE VARIABLE lHidden           AS LOG    NO-UNDO.
  
  RUN SUPER.
       
  {get UIBmode cUibmode}.

  IF cUibMode BEGINS "DESIGN":U THEN
    {fn deleteObjects}.
  
  {get FieldHandles cFieldHandles}.
  {get FieldSpacingPXL iFieldSpacingPXL}.
  {get FieldSeparatorPXL iFieldSeparatorPXL}.
  {get DefaultEditorLines iEditorLines}.
  {get DefaultCharWidth dDefaultCharWidth}.
  {get DefaultWidth dDefaultWidth}.
  {get DefaultHeight dHeight}.
  {get FieldColumn dFieldColumn}.
  {get Operator cOperator}.
  {get UseContains lUsecontains}.
  {get OperatorShortValues cOperatorShortValues}.
  {get OperatorLongValues cOperatorLongValues}.
  {get OperatorViewAs cOperatorViewAS}.
  
  IF cFieldHandles = "":U THEN
  DO:  
    /* Get Displayed and Enabled fields at runtime. */    
    {get DisplayedFields cDisplayedFields}.            
    
    {get FilterTarget cFilterTarget}.   /* Proc. handle of SDO. */
    IF cFilterTarget <> "":U THEN
       hFilterTarget = 
        /* use the last one for now */ 
        WIDGET-HANDLE(ENTRY(NUM-ENTRIES(cFilterTarget),cFilterTarget)).   
 
    IF VALID-HANDLE(hFilterTarget) THEN
    DO:
      {get DataColumns cDataColumns hFilterTarget}.
      {get WordIndexedFields cWordIdxFields hFilterTarget}.

      /* If Displayed fields is blank, take all fields from the SDO. */    
      IF cDisplayedFields = "":U THEN
        {set DisplayedFields cDataColumns}. /* Set the property. */
     
      {get ForeignFields cForeignfields hFilterTarget}.
      {set FilterAvailable TRUE hFilterTarget}.

    END. /* if valid hFiltertarget */

    {get ContainerHandle hContainerHandle}.
    
    /* Parse non-dynamic widgets to decide the minimumm size of the frame.
       The dynamic ones were deleted by the deleteObject call above */
    IF cUibMode BEGINS "DESIGN":U THEN
    DO:
      ASSIGN
        hField = hContainerHandle:FIRST-CHILD
        hField = hField:FIRST-CHILD.
      DO WHILE VALID-HANDLE(hField):
        ASSIGN
          dMinHeight = MAX(dMinHeight,hField:ROW + hField:HEIGHT - 1)
          hField = hField:NEXT-SIBLING. 
      END.  /* do while true */
    END. /* if cUIBmode begins 'design' */
    
    ASSIGN 
      lhidden                 = hContainerHandle:HIDDEN 
      hContainerHandle:HIDDEN = TRUE
      drow                    = 1
      cOpValues               = IF cOperatorViewAs = "combo-box"
                                THEN cOperatorLongValues
                                ELSE cOperatorShortValues.
    DO iField = 1 TO NUM-ENTRIES(cDisplayedFields):
      ASSIGN
        cField    = ENTRY(iField,cDisplayedFields).
      
     /* Skip fields that are not in the filter-target.
        Note that for now, we do not resize the frame in run-time, so the frame 
        will not be adjusted accordingly. */

      IF VALID-HANDLE(hFilterTarget) AND NOT CAN-DO(cDataColumns,cField) THEN 
      DO:
        iNumSkipped = iNumSkipped + 1.
        NEXT.
      END.

      ASSIGN
        dRow      = dRow + (iFieldSpacingPXl / session:pixels-per-row)  
        cLabel    = {fnarg columnLabel cField}
        cFormat   = {fnarg columnFormat cField}      
        cToolTip  = {fnarg columnToolTip cField}      
        iHelpId   = {fnarg columnHelpId cField}      
        cFormat   = {fnarg columnFormat cField}      
        cDataType = {fnarg columnDataType cField}        
        dWidth    = {fnarg columnWidth cField}
        cOperatorStyle = {fnarg columnOperatorStyle cField}
                   
                   /* createOperator will remove begins if not char and
                                                   contains if not editor,
                      We don't care about UseContains when Explicit */   
        lWordIdx  = CAN-DO(cWordIdxFields,cField) 
                    AND (cOperatorStyle = "EXPLICIT":U OR lUseContains)
        hOperator = ?.
      
      /* If we are gong to use a combo-box calculate width from data
         unless we already have done so. */
      IF dOperatorWidth = 0 
      AND cOperatorStyle = "EXPLICIT":U 
      AND cOperatorViewAs = "combo-box":U THEN
      DO: 
        DO iOp = 1 TO NUM-ENTRIES(cOpValues) BY 2:
          dOperatorWidth = MAX(dOperatorWidth,
                               FONT-TABLE:GET-TEXT-WIDTH(
                                    ENTRY(iOp,cOpValues),
                                    hContainerHandle:FONT
                                                         )
                               ).
        END.
        dOperatorWidth = dOperatorWidth + 5. /* add space for combo button */
      END. /* operatorWidth = 0 and style explicit and combo-box. */ 

      ASSIGN                           
        hField      = DYNAMIC-FUNC("createField":U IN TARGET-PROCEDURE,
                           hContainerHandle,               /* frame */
                           cField,                         /* name */
                           IF cOperatorStyle = "INLINE":U  /*datatype */
                           THEN "CHARACTER":U
                           ELSE cDataType,
                           IF lWordIdx                    /* viewas */
                           THEN "editor":U
                           ELSE "fill-in":u,
                           IF cOperatorStyle = "INLINE":U  /* format */
                           THEN {&charformat}
                           ELSE cFormat,
                           NOT (cUIBMode BEGINS "DESIGN":U), /* Enable */
                           cToolTip,
                           iHelpId,
                           dRow,
                           dFieldColumn,
                           /* inner-lines for editors, heigth for others
                              But if inner-lines is 1 we use the default height
                              to make editor same height as fill-in */
                           IF lWordIdx AND iEditorLines > 1 
                           THEN DEC(iEditorLines)   
                           ELSE dHeight,
                           dWidth)

        hLabel    = DYNAMIC-FUNCTION("createLabel":U IN TARGET-PROCEDURE,
                                      hField,
                                      cLabel).
        
      /* Turns MODIFIED off on delete and backspace if the result is blank */ 
      IF hField:TYPE <> 'EDITOR':U AND cDataType = "CHARACTER":U THEN
        ON 'delete-character':U,'backspace':U OF hField
           PERSISTENT RUN removeSpace IN TARGET-PROCEDURE.

      IF cForeignfields <> "":U 
      AND CAN-DO(cForeignfields,cField) THEN
      DO:
        ASSIGN
          hField:READ-ONLY = TRUE.
              
      END.
      ELSE DO: 
        IF  cOperatorStyle = "EXPLICIT":U 
        OR (cOperatorStyle = "RANGE" AND hField:TYPE <> "EDITOR":U) THEN
          ASSIGN
            hOperator = DYNAMIC-FUNC("createOperator":U IN TARGET-PROCEDURE,
                                     hField,
                                     IF cOperatorStyle = "RANGE":U 
                                     THEN "":U
                                     ELSE cOperatorViewAs,
                                     cOpValues,
                                   dFieldColumn 
                                   + MAX(dWidth,dDefaultCharWidth,dDefaultWidth)
                                   + (iFieldSeparatorPXl / session:pixels-per-row),
                                   dOperatorWidth).
        
        ASSIGN
         cOperatorHandles = cOperatorHandles
         /* YES enabled-->*/  + (IF cEnabledHandles NE "":U THEN "," ELSE "":U)
                              + (IF hOperator = ? THEN "":U ELSE STRING(hOperator))

         cEnabledHandles = cEnabledHandles 
                            + (IF cEnabledHandles NE "":U THEN "," ELSE "":U)
                            + STRING(hField).
      END.
      
      ASSIGN
        dRow          = dRow + hField:HEIGHT
        cFieldHandles = cFieldHandles + 
          (IF cFieldHandles NE "":U THEN "," ELSE "":U) + STRING(hField) 
        cLabelHandles = cLabelHandles + 
          (IF cLabelHandles NE "":U THEN "," ELSE "":U) + STRING(hLabel).

    END.  /* END DO iField */
    
    IF cUIBmode = "DESIGN":U THEN
    DO:
      hContainerHandle:HEIGHT = MAX(dMinHeight,dHeight + drow - 1).
      /* store the size in the AppBuilder */
    /* Issue 4771 - not necessary to apply in appbuilder */
    /*  APPLY  "END-RESIZE":U TO hContainerHandle.*/
    END. /* if cUIBmode begins 'design' */

    IF NOT lHidden THEN 
      hContainerHandle:HIDDEN = FALSE NO-ERROR.

    IF cUIBmode = "DESIGN":U AND ERROR-STATUS:GET-NUMBER(1) = 6491 THEN
    DO:      
      MESSAGE 
       "The attempt to resize the frame to fit the filter fields failed." SKIP
       "This will typically occur when the frame's container is to small." SKIP(1)   
       "You must manually resize the container and the filter frame to make all filter fields visible." 
       VIEW-AS ALERT-BOX INFORMATION.
    END. /* if error */


    {set LabelHandles cLabelHandles}.
    {set OperatorHandles cOperatorHandles}.
    {set FieldsEnabled yes}.    
    {set EnabledHandles cEnabledHandles}.
    {set DisplayedFields cDisplayedFields}.
    {set EnabledFields cDisplayedFields}.
    {set FieldHandles cFieldHandles}.
  END.   /* if cEnabledHandles = ""  */
 
  RUN ResetFields IN TARGET-PROCEDURE.
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeSpace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeSpace Procedure 
PROCEDURE removeSpace :
/*------------------------------------------------------------------------------
  Purpose:  Backspace and delete sets the field to unmodifed which will keep 
            it out of the selection criteria.  
  Parameters:  
  Notes:    Start persistent in initializeObject.
            Note that filter.i has the following trigger anywhere of frame: 
            on value-changed --> u10 --> unblankFillin trigger to reset format
            when all fields have been blanked (emptied).
         -  The main purpose of this is to distiguish between blank and empty,
            (the user can use space bar and search for a blank) 
              -- may be able to visualize this in the future.....  )  . 
            Checking screen-value in applyFilter would not allow this. 
            (length(screen-value) could have, but we also want ONE delete or
            BACKSPACE to remove all blanks)
         -  This trigger is not used for editors, 
            ed:cursor-offset = ed:cursor-offset - 1 should handle this, but 
            messes up makes carriage-returns CHR(10) visible.
            (Trying to fix it in code messes up this developers brain... 
             since OFFSET also seems to ignore CR in this trigger)
------------------------------------------------------------------------------*/  
  /* Make sure that backspace and delete always makes the field UNModifed
     if it is blank after apply. */    
  IF CAN-DO('backspace,delete-character':U,LAST-EVENT:FUNCTION) THEN
  DO:  
    APPLY LASTKEY.

    IF SELF:SCREEN-VALUE = '':U THEN
      SELF:MODIFIED = FALSE.
    
    RETURN NO-APPLY.
  END. /* backspace,delete-character */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetFields Procedure 
PROCEDURE resetFields :
/*------------------------------------------------------------------------------
  Purpose: Reset all the fields to the previosly applied filter values  
  Parameters: 
  Notes:  The field values and operator values are retrieved form the actual 
          filter-targets query.       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iField           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iValue           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hField           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cField           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFormat          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEnabledHandles    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDefaultOperator AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hFilterTarget    AS HANDLE    NO-UNDO.      
  DEFINE VARIABLE cFilterTarget    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValues          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hOperator        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cOperator        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOperatorStyle   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValue           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRangeField      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cOperatorHandles AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hdl              AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cSelection       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE xcInlineOpList   AS CHAR      NO-UNDO INIT ">=,>,<,<=":U.
  DEFINE VARIABLE xcRangeOperator  AS CHAR      NO-UNDO INIT "<=":U.
  DEFINE VARIABLE lUseBegins       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lHi              AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lLo              AS LOGICAL   NO-UNDO.
    
  {get EnabledHandles cEnabledHandles}.
  {get FilterTarget cFilterTarget}.
  {get OperatorHandles cOperatorHandles}.
  {get Operator cDefaultOperator}.
  {get OperatorStyle cOperatorStyle}.
  {get useBegins lUseBegins}.
 
  /* We obviously only support one filter target*/
  hFilterTarget = WIDGET-HANDLE(cFilterTarget).
 
  IF NOT VALID-HANDLE(hFilterTarget) THEN
  DO:
     RUN blankFields IN TARGET-PROCEDURE.
     RETURN.
  END.
      
  DO iField = 1 TO NUM-ENTRIES(cEnabledHandles):
    ASSIGN
      hField        = WIDGET-HANDLE(ENTRY(iField,cEnabledHandles))
      cFormat       = IF cOperatorStyle <> "Inline":U 
                      THEN {fnarg ColumnFormat hField:NAME}
                      ELSE {&charformat}
      hOperator     = ?
      hRangeField   = ?
      cField        = (IF NUM-ENTRIES(hField:NAME,".":U) = 1 
                       THEN "RowObject.":U ELSE "":U) 
                       + hField:NAME
      cOperator     = "":U
      lHi           = FALSE
      lLO           = FALSE.
    
    IF CAN-SET(hField,"FORMAT":U) THEN
       hField:FORMAT = cFormat.
    
    IF cOperatorHandles <> "":U THEN
    DO:
       hdl = WIDGET-HANDLE(ENTRY(iField,cOperatorHandles)).
       IF VALID-HANDLE(hdl) THEN
       DO:
         IF hdl:TYPE = "FILL-IN":U THEN 
         DO:
            hRangeField = hdl.
            hRangeField:FORMAT = cFormat.
         END.
         ELSE 
            hOperator   = hdl.  
       END.
    END. /* if cOperatorhandle <> '' */
    
    cSelection = {fnarg columnQuerySelection cField hFilterTarget}.
    
    IF cSelection <> "":U THEN
    DO iValue = 1 TO NUM-ENTRIES(cSelection,CHR(1)) BY 2:
      ASSIGN
        cOperator = ENTRY(iValue,cSelection,CHR(1))
        cValue    = ENTRY(iValue + 1,cSelection,CHR(1)).
      
      IF VALID-HANDLE(hOperator) THEN 
      DO:
        hField:SCREEN-VALUE    = cValue NO-ERROR.
        hOperator:SCREEN-VALUE = cOperator NO-ERROR.   
      END.
      ELSE IF VALID-HANDLE(hRangeField) AND
      cOperator = xcRangeoperator THEN  
        ASSIGN
           hRangeField:SCREEN-VALUE = cValue
           lHi                      = TRUE. 
      ELSE IF VALID-HANDLE(hRangeField) AND
      cOperator = ">=":U THEN  
        ASSIGN
          hField:SCREEN-VALUE = cValue
          lLo                 = TRUE.
      ELSE IF cOperator = "BEGINS" AND NOT lUseBegins THEN 
        hField:SCREEN-VALUE = cValue + "*":U.
      
      ELSE IF cOperator <> cDefaultOperator AND
      CAN-DO(xcInlineOpList,cOperator) THEN
        hField:SCREEN-VALUE = cOperator + " ":U + cValue.
      
      ELSE
        hField:SCREEN-VALUE = cValue.
      
    END. /* if cSelection <> "":U then DO iValue = 1 TO NUM-ENTRIES */    
    ELSE
      DYNAMIC-FUNCTION("blankField":U IN TARGET-PROCEDURE,
                    hField,
                    hRangeField,
                    hOperator).
    
    /* Blank range fields in case only one of them was set */
    IF cSelection <> "":U AND VALID-HANDLE(hRangeField) THEN
    DO:                 
       IF NOT lLo THEN
         {fnarg BlankFillIn hField}.
      
       IF NOT lHi THEN
         {fnarg BlankFillIn hRangeField}.
    END. /* if valid-handle(hrangefield) */
  END. /*  do iField = 1 to .. */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-unBlankLogical) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unBlankLogical Procedure 
PROCEDURE unBlankLogical :
/*------------------------------------------------------------------------------
  Purpose:  Reset the format of a blank fill-in of data-type LOGICAL
Parameters: INPUT phField - the handle of a field      
    Notes: The blankFields changes the format of fill-ins in order to make it 
           appear blank. 
           This procedure is defined  
            ON ANY-PRINTABLE, 'shift-ins', 'ctrl-v' PERSISTENT trigger when 
            the field is blanked. 
           It is also called from unblankFillin, in case the user used the 
           paste from the popup menu, an event which progress cannot trap.  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phField AS HANDLE.
   
  DEFINE VARIABLE cFormat AS CHAR NO-UNDO.
  DEFINE VARIABLE cFalse  AS CHAR NO-UNDO.
  DEFINE VARIABLE cTrue   AS CHAR NO-UNDO.
  DEFINE VARIABLE cKey    AS CHAR NO-UNDO.
  DEFINE VARIABLE lPaste  AS LOGICAL    NO-UNDO. 
  
  cFormat = {fnarg columnFormat phField:NAME}.
  IF phField:FORMAT <> cFormat THEN 
  DO:
    ASSIGN
      lPaste  = LENGTH(KEY-FUNCTION(LASTKEY)) <> 1
      cFalse  = ENTRY(2,cFormat,"/":U)
      cTrue   = ENTRY(1,cFormat,"/":U)
      cKey    = IF NOT lPaste THEN KEY-FUNCTION(LASTKEY) 
                ELSE IF phField:EDIT-CAN-PASTE 
                     THEN RIGHT-TRIM(CLIPBOARD:VALUE)
                     ELSE ?.  

    /* If paste apply before format is set if value is yes. (setting format 
       makes screen-value 'no'. Apply lastkey with 'yes' in clipboard has 
       no effect after this) */
    IF lPaste AND cTrue BEGINS cKey THEN     
      APPLY LASTKEY TO phField.

    /* Format is only applied if correct value as otherwise the screen 
       would show NO. */
    IF cFalse BEGINS cKey OR cTrue BEGINS cKey THEN
    DO:
      phField:FORMAT = cFormat.
      /* if paste set cursor at end as default behavior and return no apply 
         since the 'paste' is either applied above if TRUE or set implicit 
         from format if FALSE */
      IF lPaste THEN 
      DO:
        APPLY 'END':U TO phField.
        RETURN NO-APPLY.  
      END.
    END.
  END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-assignColumnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnFormat Procedure 
FUNCTION assignColumnFormat RETURNS LOGICAL
  (pcColumn AS CHAR,
   pcFormat AS CHAR):
/*------------------------------------------------------------------------------
  Purpose: Override the default format of a column. 
  Parameters - pcColumn - Column in the Filter Target
               pcFormat - Overridden format. 
    Notes: The value will be stored with all overidden formats in the 
           FieldFormats property.
            The private insertFieldProperty function will add the field to the 
           correct postion in the internal list.
           The columnFormat(pccolumn) function uses the private fieldProperty 
           function to retrieve it.  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cFieldFormats    AS CHAR    NO-UNDO.
  
  {get FieldFormats cFieldFormats}.   
  cFieldFormats = insertFieldProperty(cFieldFormats,pcColumn,pcFormat).      
  {set FieldFormats cFieldFormats}.
  
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnHelpId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnHelpId Procedure 
FUNCTION assignColumnHelpId RETURNS LOGICAL
  (pcColumn AS CHAR,
   piHelpId AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose: Store HelpId of a column. 
  Parameters - pcColumn - Column in the Filter Target
               pcFormat - HelpId. 
    Notes: The value will be stored with all defined HelpIds in the 
           internal FieldHelpIds property.
           The private insertFieldProperty function will add the field to the 
           correct postion in the internal list.
           The private fieldProperty function must be used to retrieve it.  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cFieldHelpIds     AS CHAR    NO-UNDO.
 
  {get FieldHelpIds cFieldHelpIds}.  
   
  cFieldHelpIds = insertFieldProperty(cFieldHelpIds,pcColumn,STRING(piHelpId)).     
  
  {set FieldHelpIds cFieldHelpIds}.
  
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnLabel Procedure 
FUNCTION assignColumnLabel RETURNS LOGICAL
  (pcColumn AS CHAR,
   pcLabel  AS CHAR):
/*------------------------------------------------------------------------------
  Purpose: Override the default Label of a column. 
  Parameters - pcColumn - Column in the Filter Target
               pcFormat - Overridden Label. 
    Notes: - The value will be stored with all overidden labels in the 
             internal label Property.
           - The private insertFieldProperty function will add the field to the 
             correct postion in the internal list.
           - The private fieldProperty function must be used to retrieve it.  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cFieldLabels     AS CHAR    NO-UNDO.  
  
  {get FieldLabels cFieldLabels}.   
    
  ASSIGN  
   cFieldLabels = insertFieldProperty(cFieldLabels,pcColumn,pcLabel).     
  
  {set FieldLabels cFieldLabels}.
  
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnOperatorStyle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnOperatorStyle Procedure 
FUNCTION assignColumnOperatorStyle RETURNS LOGICAL
  (pcColumn AS CHAR,
   pcStyle  AS CHAR):
/*------------------------------------------------------------------------------
  Purpose: Override default operatorStyle of a column. 
  Parameters - pcColumn - Column in the Filter Target
               pcFormat - Overridden OperatorStyle.  
    Notes: The value will be stored with all other fields where this is overridden 
           in the internal FieldOperatorStyles property.
           The private insertFieldProperty function will add the field to the 
           correct postion in the internal list.
           The private fieldProperty function must be used to retrieve it.  
------------------------------------------------------------------------------*/  
 DEFINE VARIABLE cFieldOperatorStyles AS CHAR NO-UNDO.  
  
  {get FieldOperatorStyles cFieldOperatorStyles}.   
    
  cFieldOperatorStyles = 
      insertFieldProperty(cFieldOperatorStyles,pcColumn,pcStyle).     
  
  {set FieldOperatorStyles cFieldOperatorStyles}.
  
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnTooltip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnTooltip Procedure 
FUNCTION assignColumnTooltip RETURNS LOGICAL
  (pcColumn AS CHAR,
   pcTooltip  AS CHAR):
/*------------------------------------------------------------------------------
  Purpose: Store Tooltip of a column. 
  Parameters - pcColumn - Column in the Filter Target
               pcFormat - Tooltip. 
    Notes: The value will be stored with all defined ToolTips in the 
           FieldToolTips property.
           The private insertFieldProperty function will add the field to the 
           correct postion in the internal list.
           The private fieldProperty function must be used to retrieve it.  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cToolTips     AS CHAR    NO-UNDO.  
  
  {get FieldToolTips cToolTips}.   
    
  cToolTips = insertFieldProperty(cToolTips,pcColumn,pcToolTip).     
  
  {set FieldToolTips cToolTips}.
  
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnWidth Procedure 
FUNCTION assignColumnWidth RETURNS LOGICAL
  (pcColumn AS CHAR,
   pdWidth  AS DEC):
/*------------------------------------------------------------------------------
  Purpose: Override default Width of a column.  
  Parameters - pcColumn - Column in the Filter Target
               pcFormat - Overridden width. 
    Notes: The default width is stored in the DefaultWidth or DefaultCharWidth 
           Properties. 
           The value will be stored with all overidden widths in the 
           internal FieldWidths property.
           The private insertFieldProperty function will add the field to the 
           correct postion in the internal list.
           The private fieldProperty function must be used to retrieve it.            
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cFieldWidths  AS CHAR    NO-UNDO.  
  DEFINE VARIABLE dMaxWidth     AS DEC    NO-UNDO.  

  {get FieldWidths cFieldWidths}.   
   
  ASSIGN  
   cFieldWidths = insertFieldProperty(cFieldWidths,pcColumn,STRING(pdWidth)).
   
  {set FieldWidths cFieldWidths}.
   RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-blankField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION blankField Procedure 
FUNCTION blankField RETURNS LOGICAL
  ( phField      AS HANDLE,
    phRangeField AS HANDLE,
    phOperator   AS HANDLE):
/*------------------------------------------------------------------------------
  Purpose: Blank a field including its operator or rangefield and 
           sets MODIFIED eq false.
Parameters:
    INPUT phField       -  handle of the actual filter field.
    INPUT phRangeField  -  handle of the optional range field.  
    INPUT phOperator    -  handle of the optional operator. 
                
    Notes: A special blankFillIn function takes care of making all fill-ins            
           really appear as blank.    
           Used internally in blankFields and resetFields.
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cDefaultOperator AS CHARACTER NO-UNDO.

 {get Operator cDefaultOperator}.
 IF cDefaultoperator = "":U THEN cDefaultoperator = ">=":U.

 IF phField:TYPE = "FILL-IN":U THEN 
     {fnarg blankFillIn phField}.
 
  ELSE phField:SCREEN-VALUE = "":U.

 IF VALID-HANDLE(phRangeField) THEN 
 DO:
   {fnarg blankFillIn phRangeField}.
   phRangeField:MODIFIED = no.
 END.
 
 IF VALID-HANDLE(phOperator) THEN 
 DO:
   phOperator:SCREEN-VALUE = IF phField:TYPE = "EDITOR":U 
                             THEN "CONTAINS":U
                             ELSE IF  phField:DATA-TYPE = "CHARACTER":U 
                             THEN "BEGINS":U
                             ELSE cDefaultOperator NO-ERROR.
   phOperator:MODIFIED     = no.
 END.
 
 phField:MODIFIED = no.

 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-blankFillIn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION blankFillIn Procedure 
FUNCTION blankFillIn RETURNS LOGICAL
  (phFillIn As HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Makes all types of fill-in appear as blank by changing their format.  
Parameters: INPUT phFillIn - The handle of an actual fill-in 
    Notes:  Called internally from blankFields - blankField() 
          - The new format is of same size as original, so that paste 
            operations will work. 
          - Logicals will not accept NO in the new format, but 'shift-ins' and
            'ctrl-v' triggers will capture this. 
            This does NOT capture the a paste from the popup menu, but for some 
            reason the value-changed trigger still fires, so we can detect this 
            situation in umblankFillin. The only negative effect is that this 
            is too late to prevent the beep caused by the paste of a value that 
            does not match the format.
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE cFormat     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldFormat  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFormatMask AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iChar       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iDecimal    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cChar       AS CHARACTER  NO-UNDO.

  ASSIGN
    phFillIn:SCREEN-VALUE = IF phFillIn:DATA-TYPE = "LOGICAL":U THEN 'no'
                            /* date* should actually handle '' as ? , this is 
                               a temp workaround for a temp bug in core and
                               can be removed if necessary.. */      
                            ELSE IF phFillIn:DATA-TYPE BEGINS "DATE":U THEN ?
                            ELSE "".
  CASE phFillIn:DATA-TYPE:
    /* Remove masking from format for character fields */
    WHEN "CHARACTER":U THEN 
    DO:
      ASSIGN
        cFormatMask = phFillin:SCREEN-VALUE
        cFormat = phFillin:FORMAT.
      /* replace any mask characters in the format with space. 
         This ensures that cursor is correctly placed on typing or paste 
         into this field with this format and makes it easy to reset cursor 
         after format is set back in unblabkfillin() */
      DO iChar = 1 TO LENGTH(cFormatMask):
        cChar = SUBSTR(cFormatMask,iChar,1).
        IF cChar > '' THEN
          OVERLAY(cFormat,iChar,1) = ''.
      END.
      phFillIn:FORMAT = cFormat.
    END.

    /* Change digits to use 'Z' as format and remove decimal part for 
       numerics */ 
    WHEN "DECIMAL":U OR WHEN 'INTEGER':U THEN 
      {fnarg blankNumericFormat phFillin}.

    /* logical needs to have the NO part of the format blank */ 
    WHEN "LOGICAL":U THEN 
    DO:
      phFillIn:FORMAT =  ENTRY(1,phFillIn:FORMAT,"/":U) + "/":U.
      /* The format need to be reset BEFORE key or paste is applied, so define
         pre-event triggers  */
      ON ANY-PRINTABLE, 'SHIFT-INS':U, 'CTRL-V':U OF phFillIn PERSISTENT 
        RUN unBlankLogical IN TARGET-PROCEDURE (phFillIn).        
    END.
  END.
  phFillIn:MODIFIED = FALSE.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-blankNumericFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION blankNumericFormat Procedure 
FUNCTION blankNumericFormat RETURNS LOGICAL
  ( phField AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: Assign a format that will display as blank when the field
           is 0, but still are able to receive a 'paste' of any value that 
           the original format supports.   
    Notes: Used for both integer and decimal. 
           The function simply omits the decimal part of the format. 
           The premiss for this is that it is not possible to paste a decimal
           value with the numeric-point into a decimal field in the first place, 
           i.e. if the field shows '0.0' it does not accept a paste of value with
           a decimal point in it, unless the existing value is highlighted for 
           replace. The latter is not applicable when the field is blank, so   
           omitting the decimal part does not limit the paste-ability of the 
           field.
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hField  AS HANDLE   NO-UNDO.
   DEFINE VARIABLE cFormat AS CHAR     NO-UNDO INIT 'Z'.

   CREATE FILL-IN hField
     ASSIGN 
       DATA-TYPE    = phField:DATA-TYPE
       /* must set format AFTER datatype*/ 
       FORMAT       = phField:FORMAT
       SCREEN-VALUE = '1'.

   /* Prepend digits untill screen-value is not within format limits */  
   DO WHILE TRUE:
     ASSIGN
       hField:SCREEN-VALUE = '1' + hField:SCREEN-VALUE 
       cFormat             = cFormat + 'Z' 
       NO-ERROR.     
     IF ERROR-STATUS:GET-MESSAGE(1) <> '' THEN
       LEAVE.
   END.
   
   /* Add '-' if current format accepts a negative value */
   hField:SCREEN-VALUE = '-':U + hField:SCREEN-VALUE NO-ERROR.
   IF ERROR-STATUS:GET-MESSAGE(1) = '' THEN
     cFormat = cFormat + '-':U.

   phField:FORMAT = cFormat.

   DELETE OBJECT hField. 

   RETURN TRUE .

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  (pcColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the datatype of a column
Parameters: INPUT pcColumn - The name of the column in the filter-target.    
    Notes: When the object is opened at design time there's no target available
           so the field will always appear as character.
            
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hFilterTarget  AS HANDLE.
    DEFINE VARIABLE cDataType      AS CHARACTER.
    DEFINE VARIABLE cOperatorStyle AS CHAR    NO-UNDO.

   {get OperatorStyle coperatorStyle}.
    hFilterTarget = {fnarg columnFilterTarget pcColumn}.
    
    IF VALID-HANDLE(hFilterTarget) THEN 
      cDataType = {fnarg columnDataType pcColumn hFilterTarget}.      
    ELSE
      cDataType = "CHARACTER":U.
    
    RETURN cDataType. 
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnFilterTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnFilterTarget Procedure 
FUNCTION columnFilterTarget RETURNS HANDLE
  ( pcColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the filter target of a specific column  
Parameters: INPUT pcColumn - The name of the column in the filter-target.    
    Notes: This currently returns the same value for all fields, but may  be 
           changed in order to support more than one filter-target.
           This function should subsequently always be used to find the 
           filter-target of a specific field.    
-----------------------------------------------------------------------------*/    
  DEFINE VARIABLE cFilterTarget    AS CHAR    NO-UNDO.
   
  {get FilterTarget cFilterTarget}.
  
  IF cFilterTarget <> "":u THEN   
    RETURN  WIDGET-HANDLE(ENTRY(1,cFilterTarget)).

  RETURN ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnFormat Procedure 
FUNCTION columnFormat RETURNS CHARACTER
  (pcColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the Format of a column. 
Parameters: INPUT pcColumn - The name of the column in the filter-target.    
    Notes: If the format is overridden it will be found in the CHR(1) separated
           FieldFormats property.   
           otherwise if there's a valid filter-target it will return the format 
           returned from the filter-target.
           The last resort is a hardcoded {&charformat} 
           (Which is the case at open in design-time)      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldFormats    AS CHAR    NO-UNDO.
  DEFINE VARIABLE hFilterTarget    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE cFormat          AS CHAR    NO-UNDO.

  {get FieldFormats cFieldFormats}.
                     
  cFormat = fieldProperty(cFieldFormats,pcColumn).
  
   /* no override, find datasource format */
  IF cFormat = "":U THEN 
  DO:
    hFilterTarget = {fnarg columnFilterTarget pcColumn}.       
    IF VALID-HANDLE(hFilterTarget) THEN 
      cFormat = DYNAMIC-FUNC("columnFormat":U IN hFilterTarget,pcColumn).      
    ELSE 
      cFormat = {&charformat}.    
  END. 
       
  RETURN cFormat.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHelpId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnHelpId Procedure 
FUNCTION columnHelpId RETURNS INTEGER
  (pcColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the HelpId of a column. 
Parameters: INPUT pcColumn - The name of the column in the filter-target.    
    Notes: The actual value is stored in the FieldHelpIds property.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldHelpIds    AS CHAR    NO-UNDO.
    
  {get FieldHelpIds cFieldHelpIds}.
  RETURN INT(fieldProperty(cFieldHelpIds,pcColumn)).     

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnLabel Procedure 
FUNCTION columnLabel RETURNS CHARACTER
  (pcColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the Label of a column. 
Parameters: INPUT pcColumn - The name of the column in the filter-target.    
    Notes: If the label is overridden it will be found in the CHR(1) separated
           FieldLabels property.   
           otherwise if there is a valid filter-target it will return the label 
           returned from the filter-target.
           The last resort is blank. (Which is the case at open in design-time)       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldLabels     AS CHAR    NO-UNDO.
  DEFINE VARIABLE hFilterTarget    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE cLabel           AS CHAR    NO-UNDO INIT ?.
 
  {get FieldLabels cFieldLabels}.
  
  IF fieldLookup(pccolumn,cfieldLabels) = 0 THEN
    cLabel = ?. 
  ELSE
    cLabel = fieldPRoperty(cFieldLabels,pcColumn). 
  
   /* no override, find datasource Label */
  IF cLabel = "?":U OR cLabel = ? THEN 
  DO:  
    hFilterTarget = {fnarg columnFilterTarget pcColumn}.                
    IF VALID-HANDLE(hFilterTarget) THEN 
    DO:
      cLabel = DYNAMIC-FUNC("columnLabel":U IN hFilterTarget,pcColumn).      
    END.
    ELSE 
      cLabel = "":U.    
  END. 
       
  RETURN cLabel.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLabelDefault) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnLabelDefault Procedure 
FUNCTION columnLabelDefault RETURNS LOGICAL
   (pcColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return true if the Label is overridden. 
Parameters: INPUT pcColumn - The name of the column in the filter-target.    
    Notes: Only used in design-time because the columnLabel function returns
           the overidden value.  
---------------------------------------------------------------------------*/  
  DEFINE VARIABLE cFieldLabels  AS CHAR    NO-UNDO.
  DEFINE VARIABLE cLabel        AS CHAR    NO-UNDO.
    
  {get FieldLabels cFieldLabels}.
  
  IF fieldLookup(pccolumn,cFieldLabels) = 0 THEN
     RETURN TRUE.
     
  cLabel = fieldProperty(cFieldLabels,pcColumn).
  RETURN cLabel = "?":U OR cLabel = ?.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnOperatorStyle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnOperatorStyle Procedure 
FUNCTION columnOperatorStyle RETURNS CHARACTER
  (pcColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Returns the operator style of a field, will return the OperatorStyle
           property if not defined for the column.
Parameters: INPUT pcColumn - The name of the column in the filter-target.                 
    Notes: Current restrictions:
            - If default is "INLINE" it always returns the OperatorStyle prop.
            - "EXPLICIT" is only allowed if default style is "RANGE".    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldOperatorStyles AS CHAR      NO-UNDO.
  DEFINE VARIABLE cOperatorStyle       AS CHAR      NO-UNDO.
  DEFINE VARIABLE cStyle               AS CHAR      NO-UNDO.
    
  {get FieldOperatorStyles cFieldOperatorStyles}.
  {get OperatorStyle cOperatorStyle}.
  
  /* no override of inline */
  IF cOperatorStyle = "InLine":U THEN 
    RETURN cOperatorStyle.
    
  cStyle = fieldProperty(cFieldOperatorStyles,pcColumn).
  
  IF cStyle <> "":U THEN
  DO:  
    IF cOperatorStyle = "RANGE":U THEN
    DO:
      IF cStyle = "EXPLICIT":U THEN
        RETURN cStyle.
    END.
    ELSE 
      RETURN cStyle.        
  END. /* dwidth = 0 */
         
  RETURN cOperatorStyle.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnStyleDefault) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnStyleDefault Procedure 
FUNCTION columnStyleDefault RETURNS LOGICAL
   (pcColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return true if the column's Style is overridden. 
Parameters: INPUT pcColumn - The name of the column in the filter-target.    
    Notes: Only used in design-time because the columnOperatorStyle function 
           returns the overidden value.  
---------------------------------------------------------------------------*/  
  DEFINE VARIABLE cStyle               AS CHAR    NO-UNDO.
  DEFINE VARIABLE cFieldOperatorStyles AS CHAR    NO-UNDO.
    
  {get FieldOperatorStyles cFieldOperatorStyles}.

  cStyle = fieldProperty(cFieldOperatorStyles,pcColumn).
 
  RETURN cStyle = "":U.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTooltip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnTooltip Procedure 
FUNCTION columnTooltip RETURNS CHARACTER
  (pcColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the Toooltip of a column. 
Parameters: INPUT pcColumn - The name of the column in the filter-target.    
    Notes: The actual value is stored in the FieldTooltips property.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldTooltips   AS CHAR    NO-UNDO.
    
  {get FieldTooltips cFieldTooltips}.
  RETURN fieldProperty(cFieldTooltips,pcColumn).     
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnWidth Procedure 
FUNCTION columnWidth RETURNS DECIMAL
  (pcColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Returns the width of a field 
Parameters: INPUT pcColumn - The name of the column in the filter-target.    
     Notes: Checks the internal FieldWidths property to see if the width is 
            overridden. If not it returns the default withs from the 
            DefaultCharWidth or DefaultWidth properties. 
            The field widget is NOT used because this value needs to
            be read before/while the object is created.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldWidths     AS CHAR      NO-UNDO.
  DEFINE VARIABLE cDataType        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hFilterTarget    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE dWidth           AS DECIMAL   NO-UNDO.
    
  {get FieldWidths cFieldWidths}.
  
  dWidth = DEC(fieldProperty(cFieldwidths,pcColumn)).     
  
  IF dWidth = 0 OR dWidth = ? THEN
  DO:
    hFilterTarget = {fnarg columnFilterTarget pcColumn}.                
         
    IF {fnarg columnDataType pcColumn} = "CHARACTER":U THEN
      {get DefaultCharWidth dWidth}.
    ELSE
      {get DefaultWidth dWidth}.     
  
  END. /* dwidth = 0 */
         
  RETURN dWidth.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnWidthDefault) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnWidthDefault Procedure 
FUNCTION columnWidthDefault RETURNS LOGICAL
   (pcColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return true if the Width is overridden. 
Parameters: INPUT pcColumn - The name of the column in the filter-target.    
    Notes: Only used in design-time because the columnWidth function returns
           the overidden value.  
---------------------------------------------------------------------------*/  
  DEFINE VARIABLE cFieldWidths  AS CHAR    NO-UNDO.
  DEFINE VARIABLE cWidth        AS CHAR    NO-UNDO.
    
  {get FieldWidths cFieldWidths}.
  
  cWidth = fieldProperty(cFieldWidths,pcColumn).
  RETURN cWidth = "":U OR cWidth = "?":U.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createField Procedure 
FUNCTION createField RETURNS HANDLE
  (phFrame    AS HANDLE,
   pcName     AS CHAR,
   pcDataType AS CHAR,
   pcViewAs   AS CHAR,
   pcFormat   AS CHAR,
   plEnable   AS LOG,
   pcTooltip  AS CHAR,
   piHelpid   AS INT,
   pdRow      AS DEC,
   pdCol      AS DEC,
   pdHeight   AS DEC,   
   pdWidth    AS DEC) :
/*------------------------------------------------------------------------------
     Purpose: Create the Filter for one field
 Description: INPUT phFrame    - Frame handle
              INPUT pcName     - The name of the column 
              INPUT pcDatatype - Datatype to use
              INPUT pcViewAs   - View-as 
              INPUT pcFormat   - Format 
              INPUT plEnable  -  Enable for input  
              INPUT pcTooltip  - Tooltip text
              INPUT pcTooltip  - Tooltip text
              INPUT piHelpid   - Integer HelpId   
              INPUT pdRow      - decimal Row  
              INPUT pdCol      - decimal Col 
              INPUT pdHeight   - decimal height
                                 If this is an editor a height > 2 will be 
                                 used to set inner-lines instead of height
                                 and the editor will have word-wrap and a
                                 vertical scrollbar. 
              INPUT pdWidth    - decimal width   
       Notes: PRIVATE
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hLabel        AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hField        AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hOperator     AS HANDLE    NO-UNDO.
             
   CREATE VALUE(pcViewAS) hField
     ASSIGN 
       FRAME     = phFrame
       ROW       = pdRow
       COL       = pdCol
       NAME      = pcName
       WIDTH     = pdWidth
       TOOLTIP   = pcTooltip
       CONTEXT-HELP-ID = piHelpid
       HIDDEN    = FALSE       
       SENSITIVE = TRUE
       READ-ONLY = NOT plEnable
       TAB-STOP  = plEnable.
   
   /* Height >= 2 will be used to set INNER-LINES */
   IF pcViewAs = "editor":U THEN 
     ASSIGN
       hField:INNER-LINES = IF pdHeight >= 2 THEN INT(pdHeight) ELSE 1
                            /* Scroll left and rigth in one line editor */
       hField:WORD-WRAP          = pdHeight >= 2
       hField:SCROLLBAR-VERTICAL = pdHeight >= 2
       hField:HEIGHT      = IF pdHeight < 2 THEN pdHeight ELSE hField:HEIGHT.

  ELSE 
     ASSIGN
       hField:HEIGHT    = pdHeight
       hField:DATA-TYPE = pcDataType
       hField:FORMAT    = pcFormat.
   
  RETURN hField. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createLabel Procedure 
FUNCTION createLabel RETURNS HANDLE
  (phField AS HANDLE,
   pcLabel AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Create the label for the filter field
Parameters: INPUT phField - The handle of the actual filter field
            INPUT pcLabel - the text to use as label
    Notes: PRIVATE  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hLabel       AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hFrame       AS HANDLE  NO-UNDO.
   DEFINE VARIABLE cUIBMode     AS CHAR    NO-UNDO.
   DEFINE VARIABLE iLabelLength AS INTEGER NO-UNDO.
   
   ASSIGN
     hFrame       = phField:FRAME
     iLabelLength = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(pcLabel + ": ":U, hFrame:FONT).

   IF phField:X - iLabelLength LT 0 THEN
   DO:
     {get UIBMode cUIBMode}.
      IF cUIBMode = "DESIGN":U THEN
        MESSAGE 
          "The label for field" phField:NAME "was truncated!" SKIP
          VIEW-AS ALERT-BOX INFORMATION.
   END. /* X lt 0 */
   CREATE TEXT hLabel
     ASSIGN FRAME            = hFrame
            X                = MAX(0,phField:X - iLabelLength)
            ROW              = phField:ROW
            HIDDEN           = FALSE
            WIDTH-PIXELS     = MIN(phField:X,iLabelLength)
            FORMAT           = "x(":U + STRING(LENGTH(pcLabel) + 1) + ")":U
            SCREEN-VALUE     = pcLabel + ":":U
            HEIGHT-PIXELS    = SESSION:PIXELS-PER-ROW.
   
   RETURN hLabel. 
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createOperator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createOperator Procedure 
FUNCTION createOperator RETURNS HANDLE
  (phField  AS HANDLE,
   pcType   AS CHAR,
   pcValues AS CHAR,
   pdCol    AS DEC,
   pdWidth  AS DEC) :
/*------------------------------------------------------------------------------
  Purpose: Create the widget to use as operator or fill-in for the range option   
Parameters: INPUT phField - The handle of the actual filter field
            INPUT pcType  - Widget-type 
                            - "radio-set", "combo-box" 
                            - otherwise a fill-in will be created
            INPUT pcValues - List of operator values for the combo-box 
                             or radio-set        
            INPUT pdCol    - decimal column position
            INPUT pdWidth  - decimal width                                      
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hOperator AS HANDLE NO-UNDO.
  
  IF pcType = "Radio-set":U THEN 
    CREATE RADIO-SET hOperator
     ASSIGN 
       FRAME           = phField:FRAME
       ROW             = phField:ROW
       COL             = phField:COL + 21
       RADIO-BUTTONS   = pcValues
       HORIZONTAL      = TRUE
       HEIGHT          = phField:HEIGHT
       HIDDEN          = FALSE       
       SENSITIVE       = NOT phField:READ-ONLY.
  
  ELSE IF pcType = "Combo-box":U THEN
   CREATE COMBO-BOX hOperator
     ASSIGN 
       FRAME           = phField:FRAME
       ROW             = phField:ROW
       COL             = pdCol
       WIDTH           = pdWidth
       LIST-ITEM-PAIRS = pcValues
       HIDDEN          = FALSE       
       SENSITIVE       = NOT phField:READ-ONLY.

 ELSE 
   CREATE FILL-IN hOperator
    ASSIGN 
       FRAME     = phField:FRAME
       ROW       = phField:ROW
       COL       = pdCol
       NAME      = phField:NAME
       HEIGHT    = phField:HEIGHT
       WIDTH     = phField:WIDTH
       DATA-TYPE = phField:DATA-TYPE
       FORMAT    = phField:FORMAT
       HIDDEN    = FALSE       
       SENSITIVE = TRUE
       READ-ONLY       = phField:READ-ONLY
       TAB-STOP        = phField:TAB-STOP.
     
  /* Remove BEGINS from list if not character and CONTAINS if not editor */ 
  IF hOperator:TYPE <> "Fill-in":U THEN
  DO:
    IF phField:DATA-TYPE <> "CHARACTER" THEN 
      hOperator:DELETE('BEGINS':U).    
    IF phField:TYPE <> "EDITOR" THEN 
      hOperator:DELETE('CONTAINS':U).
  END. /* hoperator <> fill-in */

  RETURN hOperator.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dataValue Procedure 
FUNCTION dataValue RETURNS CHARACTER
  (pcColumn AS CHAR,
   pcValue  AS CHAR):   
/*------------------------------------------------------------------------------
   Purpose: validate and return the true datavalue of a column   
Parameters: INPUT pcColumn - The column's name in the data-source.
            INPUT pcValue  - formatted screen-Value.
     Notes: This is in reality obsolete with the introduction of INPUT-VALUE 
            Due to the fact that it takes a value as input it need to have 
            separate fields in case it has been used for an other value than 
            the filter's current screen-value. (very unlikely...)             
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ch AS CHAR NO-UNDO.
  DEFINE VARIABLE da AS DATE NO-UNDO.
  DEFINE VARIABLE dt AS DATETIME NO-UNDO.
  DEFINE VARIABLE dz AS DATETIME-TZ NO-UNDO.
  DEFINE VARIABLE de AS DEC  NO-UNDO.
  DEFINE VARIABLE i  AS INT  NO-UNDO.
  DEFINE VARIABLE lo AS LOG  NO-UNDO. 

  DEFINE VARIABLE cValue    AS CHAR   NO-UNDO.
  DEFINE VARIABLE hdl       AS HANDLE NO-UNDO.
  DEFINE VARIABLE cDataType AS CHAR   NO-UNDO.
  DEFINE VARIABLE cFormat   AS CHAR   NO-UNDO.
  
  DEFINE FRAME X ch da de dt dz i lo WITH STREAM-IO.
  
  ASSIGN  
    cDataType = DYNAMIC-FUNCTION('columnDataType' IN TARGET-PROCEDURE,pcColumn).
    cFormat   = DYNAMIC-FUNCTION('columnFormat' IN TARGET-PROCEDURE,pcColumn).
  
  CASE cDataType:
    WHEN "CHARACTER":U THEN 
      ASSIGN 
        ch:FORMAT       = cFormat
        ch:SCREEN-VALUE = pcValue
        cValue          = INPUT ch NO-ERROR.
    
    WHEN "DATE":U THEN 
      ASSIGN
        da:FORMAT        = cFormat
        da:SCREEN-VALUE  = pcValue  
        cValue           = STRING(INPUT da) NO-ERROR.

    WHEN "DATETIME":U THEN 
      ASSIGN
        dt:FORMAT        = cFormat
        dt:SCREEN-VALUE  = pcValue  
        cValue           = STRING(INPUT dt) NO-ERROR.

    WHEN "DATETIME-TZ":U THEN 
      ASSIGN
        dz:FORMAT        = cFormat
        dz:SCREEN-VALUE  = pcValue  
        cValue           = STRING(INPUT dz) NO-ERROR.
    
    WHEN "DECIMAL":U THEN 
      ASSIGN
        de:FORMAT         = cFormat
        de:SCREEN-VALUE   = pcValue  
        cValue            = STRING(INPUT de) NO-ERROR.

    WHEN "INTEGER":U THEN 
     ASSIGN
       i:FORMAT         = cFormat
       i:SCREEN-VALUE   = pcValue  
       cValue           = STRING(INPUT i) NO-ERROR.
    
    WHEN "LOGICAL":U THEN 
      ASSIGN
        lo:FORMAT         = cFormat
        lo:SCREEN-VALUE   = pcValue  
        cValue            = STRING(INPUT lo) NO-ERROR.

  END CASE.  /* cDatatype  */

  /* Only return the first error-message */
  IF ERROR-STATUS:GET-MESSAGE(1) <> "":U THEN   
     RUN AddMessage IN TARGET-PROCEDURE (ERROR-STATUS:GET-MESSAGE(1),pcColumn,?). 
  
  RETURN cValue.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteObjects Procedure 
FUNCTION deleteObjects RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Delete all dynamic widgets.  
    Notes: Called at design-time every time the Instance Properties are changed  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldHandles     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cLabelHandles     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOperatorHandles  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i                 AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hdl               AS HANDLE    NO-UNDO.
   
  {get FieldHandles cFieldHandles}.
  {get LabelHandles cLabelHandles}.
  {get OperatorHandles cOperatorHandles}.
    
  DO i = 1 TO NUM-ENTRIES(cFieldHandles):
    Hdl = WIDGET-HANDLE(ENTRY(i,cFieldHandles)).
    IF VALID-HANDLE(Hdl) AND hdl:DYNAMIC THEN 
       DELETE WIDGET Hdl.
    Hdl = WIDGET-HANDLE(ENTRY(i,cLabelHandles)).
    IF VALID-HANDLE(Hdl) AND hdl:DYNAMIC THEN 
       DELETE WIDGET Hdl.
    
    IF cOperatorHandles <> "":U AND NUM-ENTRIES(cOperatorHandles) >= i THEN
    DO:
      Hdl = WIDGET-HANDLE(ENTRY(i,cOperatorHandles)).
      IF VALID-HANDLE(Hdl) THEN 
         DELETE WIDGET Hdl.
    END. 
  END.
  cFieldHandles = "":U.
  {set FieldHandles cFieldHandles}.
  {set LabelHandles cFieldHandles}.
  {set OperatorHandles cFieldHandles}.
    
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fieldLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fieldLookup Procedure 
FUNCTION fieldLookup RETURNS INTEGER PRIVATE
  (pcField AS CHAR,
   pcList  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Find the LOOKUP position of the corresponding value to the field 
           in a chr(1) list of fields and values.   
Parameters:  INPUT pcFields - fieldname 
             INPUT pcList   - CHR(1) separated list with fieldnames and values. 
    Notes: PRIVATE used for all defined and/or overridden column properties
------------------------------------------------------------------------------*/
  DEF VAR iLookUp AS INT NO-UNDO.
  DO WHILE TRUE:
    iLookup = LOOKUP(pcField,pcList,CHR(1)).
    IF iLookup = 0 OR iLookup = ? THEN LEAVE.
    IF iLookup MODULO 2 = 1 THEN 
      LEAVE.
      /* Remove this entry because its data and not a field */ 
    ENTRY(iLookup,pcList,CHR(1)) = "":U.   
  END.
  
  RETURN iLookup.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fieldProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fieldProperty Procedure 
FUNCTION fieldProperty RETURNS CHAR PRIVATE
  (pcList  AS CHAR,
   pcField AS CHAR) :

/*------------------------------------------------------------------------------
  Purpose: Find the actual value of the corresponding value to the field in a 
           chr(1) list of fields and values.   
Parameters:  INPUT pcFields - fieldname 
             INPUT pcList   - CHR(1) separated list with fieldnames and values. 
    Notes: PRIVATE used for all defined and/or overridden column properties
------------------------------------------------------------------------------*/   
  DEF VAR iLookUp AS INTEGER NO-UNDO.

  iLookup = fieldLookup(pcField,pcList).
  
  IF iLookup > 0 THEN 
    RETURN ENTRY(iLookup + 1,pcList,CHR(1)).
    
  RETURN "":U.
                
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataObject Procedure 
FUNCTION getDataObject RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the filter used at design time  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR cDataObject AS CHAR NO-UNDO.
  {get DataObject cDataObject}.
  
  RETURN cDataObject.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDefaultCharWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDefaultCharWidth Procedure 
FUNCTION getDefaultCharWidth RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Defalt width for character fields. 
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR dDefaultCharWidth AS DEC NO-UNDO.
  {get DefaultCharWidth dDefaultCharWidth}.
  
  RETURN dDefaultCharWidth.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDefaultEditorLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDefaultEditorLines Procedure 
FUNCTION getDefaultEditorLines RETURNS DECIMAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Defalt Inner-lines for editors. 
    Notes: Word indexed field will automatically use editor. 
------------------------------------------------------------------------------*/
  DEF VAR iLines AS DEC NO-UNDO.
  {get DefaultEditorLines iLines}.
  
  RETURN iLines.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDefaultLogical) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDefaultLogical Procedure 
FUNCTION getDefaultLogical RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Not used 
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR cDefaultLogical AS CHAR NO-UNDO.
  {get DefaultLogical cDefaultLogical}.
  
  RETURN cDefaultLogical.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDefaultWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDefaultWidth Procedure 
FUNCTION getDefaultWidth RETURNS DECIMAL
   ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Defualt width for fields that are non-char 
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR dDefaultWidth AS DEC NO-UNDO.
  {get DefaultWidth dDefaultWidth}. 
  RETURN dDefaultWidth.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisplayedFields Procedure 
FUNCTION getDisplayedFields RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Complete list of fields in the filter.
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR cDisplayedFields AS CHAR NO-UNDO.
  {get DisplayedFields cDisplayedFields}.
  
  RETURN cDisplayedFields.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEnabledFields Procedure 
FUNCTION getEnabledFields RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR cEnabledFields AS CHAR NO-UNDO.
  {get EnabledFields cEnabledFields}.
  
  RETURN cEnabledFields.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldColumn Procedure 
FUNCTION getFieldColumn RETURNS DECIMAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:    Column of left-most field.   
    Notes:    
------------------------------------------------------------------------------*/
  DEF VAR dFieldColumn AS DEC NO-UNDO.
  {get FieldColumn dFieldColumn}.
  
  RETURN dFieldColumn.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldFormats) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldFormats Procedure 
FUNCTION getFieldFormats RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Internal override of formats for fields
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR cFieldFormats AS CHAR NO-UNDO.
  {get FieldFormats cFieldFormats}.
  
  RETURN cFieldFormats.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldHelpIds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldHelpIds Procedure 
FUNCTION getFieldHelpIds RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:    Internal list of properties for the fields 
    Notes:    CHR(1) separated list of names and values
------------------------------------------------------------------------------*/
  DEF VAR cFieldHelpIds AS CHAR NO-UNDO.
  {get FieldHelpIds cFieldHelpIds}.
  
  RETURN cFieldHelpIds.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldLabels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldLabels Procedure 
FUNCTION getFieldLabels RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:    Internal list of properties for the fields 
    Notes:    CHR(1) separated list of names and values
------------------------------------------------------------------------------*/
  DEF VAR cFieldLabels AS CHAR NO-UNDO.
  {get FieldLabels cFieldLabels}.
  
  RETURN cFieldLabels.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldOperatorStyles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldOperatorStyles Procedure 
FUNCTION getFieldOperatorStyles RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:    Internal list of properties for the fields 
    Notes:    CHR(1) separated list of names and values
------------------------------------------------------------------------------*/
  DEF VAR cFieldOperatorStyles AS CHAR NO-UNDO.
  {get FieldOperatorStyles cFieldOperatorStyles}.
  
  RETURN cFieldOperatorStyles.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldToolTips) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldToolTips Procedure 
FUNCTION getFieldToolTips RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:    Internal list of properties for the fields 
    Notes:    CHR(1) separated list of names and values
------------------------------------------------------------------------------*/
  DEF VAR cFieldToolTips AS CHAR NO-UNDO.
  {get FieldToolTips cFieldToolTips}.
  
  RETURN cFieldToolTips.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldWidths) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldWidths Procedure 
FUNCTION getFieldWidths RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:    Internal list of properties for the fields 
    Notes:    CHR(1) separated list of names and values
------------------------------------------------------------------------------*/
  DEF VAR cFieldWidths AS CHAR NO-UNDO.
  {get FieldWidths cFieldWidths}.
  
  RETURN cFieldWidths.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterTarget Procedure 
FUNCTION getFilterTarget RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: The linked filter object. Currently supports only one.
    Notes: USE columnFilterTarget for a column  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFilterTarget AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xpFilterTarget
  {get FilterTarget cFilterTarget}.
  &UNDEFINE xpFilterTarget
  
  RETURN cFilterTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterTargetEvents Procedure 
FUNCTION getFilterTargetEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a comma-separated list of the events this object wants 
            to subscribe to in its FilterTarget
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get FilterTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOperator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOperator Procedure 
FUNCTION getOperator RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the default operator when OperatorStyle eq "Implicit"
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR cOperator AS CHAR NO-UNDO.
  {get Operator cOperator}.
  
  RETURN cOperator.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOperatorLongValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOperatorLongValues Procedure 
FUNCTION getOperatorLongValues RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: A list of operators and long text    
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR cOperatorLongValues AS CHAR NO-UNDO.
  {get OperatorLongValues cOperatorLongValues}.
  
  RETURN cOperatorLongValues.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOperatorStyle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOperatorStyle Procedure 
FUNCTION getOperatorStyle RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns operatorStyle  
    Notes: Four valid values.
           - "Explicit"  - specify operator in a separate widget
           - "Implicit"  - Use the Operator and UseBegins property 
           - "Range"     - Use two fill-ins and specify GE and LE values
           - "Inline"    - Type the operator in the field 
                            (Defualt Equals or BEGINS if UseBegins eq true)     
------------------------------------------------------------------------------*/
  DEF VAR cOperatorStyle AS CHAR NO-UNDO.
  {get OperatorStyle cOperatorStyle}.
  
  RETURN cOperatorStyle.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOperatorViewAs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOperatorViewAs Procedure 
FUNCTION getOperatorViewAs RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the view-as type used to define the operator when 
           OperatorStyle equals "Explicit".  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR cOperatorViewAs AS CHAR NO-UNDO.
  {get OperatorViewAs cOperatorViewAs}.
  
  RETURN cOperatorViewAs.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseBegins) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUseBegins Procedure 
FUNCTION getUseBegins RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true when BEGINS is supposed to be used as operator 
           for character values.  
    Notes: Is NOT used for OperatorStyle "RANGE" or "EXPLICIT"  
------------------------------------------------------------------------------*/
  DEF VAR lUseBegins AS LOG NO-UNDO.
  {get UseBegins lUseBegins}.
  
  RETURN lUseBegins.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseContains) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUseContains Procedure 
FUNCTION getUseContains RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true when Contains is supposed to be used as operator 
           for character values.  
    Notes: Is NOT used for OperatorStyle "EXPLICIT"
            (It will always be in the list of available operators) 
------------------------------------------------------------------------------*/
  DEF VAR lUseContains AS LOG NO-UNDO.
  {get UseContains lUseContains}.
  
  RETURN lUseContains.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getViewAsFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getViewAsFields Procedure 
FUNCTION getViewAsFields RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: not in use  
    Notes:   
------------------------------------------------------------------------------*/
  DEF VAR cViewAsFields AS CHAR NO-UNDO.
  {get ViewAsFields cViewAsFields}.
  
  RETURN cViewAsFields.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getVisualBlank) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getVisualBlank Procedure 
FUNCTION getVisualBlank RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the value that are used to visualize that we actually are 
           searching for BLANK values.   
    Notes: Toggles on and off with space-bar and off with back-space.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cVisual AS CHAR NO-UNDO.
  {get VisualBlank cVisual}.

  RETURN cVisual.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertFieldProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION insertFieldProperty Procedure 
FUNCTION insertFieldProperty RETURNS CHARACTER PRIVATE
  (pcList  AS CHAR,
   pcField AS CHAR,
   pcValue AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Insert or add a  fields property to the CHR(1) separated internal 
           property that holdes fields and values.   
Parameters: INPUT pcList   - CHR(1) separated list with fieldnames and values. 
            INPUT pcFields - fieldname
            INPUT pcValue  - Value of the field property 
   Notes:  PRIVATE
------------------------------------------------------------------------------*/
  DEF VAR iLookup AS INTEGER NO-UNDO.
  
  IF pcList = ? THEN pcList = "":U.
  iLookup = fieldLookup(pcField,pcList).
  
  IF iLookup > 0 THEN 
    ENTRY(iLookup + 1,pcList,CHR(1)) = IF pcValue = ? THEN "?":U
                                       ELSE pcValue. 
  
  ELSE IF pcValue <> "":U AND pcValue <> "?" AND pcValue <> ? THEN
    ASSIGN 
     pcList = pcList 
              + (IF pcList = "":U THEN "":U ELSE CHR(1))
              + pcField
              + CHR(1)
              + pcValue.    
  RETURN pcList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataObject Procedure 
FUNCTION setDataObject RETURNS LOGICAL
  ( pcDataObject AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Sets the name of the filter used at design time  
Parameter: pcDataObject - The name of a filter-target    
    Notes:  
------------------------------------------------------------------------------*/
  {set DataObject pcDataObject}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDefaultCharWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDefaultCharWidth Procedure 
FUNCTION setDefaultCharWidth RETURNS LOGICAL
  ( pdDefaultCharWidth AS DEC) :
/*------------------------------------------------------------------------------
  Purpose: Sets the default width of character fields
Parameters: INPUT pdDefualtCharwidth - decimal width.  
    Notes:  
------------------------------------------------------------------------------*/
  {set DefaultCharWidth pdDefaultCharWidth}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDefaultEditorLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDefaultEditorLines Procedure 
FUNCTION setDefaultEditorLines RETURNS LOGICAL
  ( piLines AS INT) :
/*------------------------------------------------------------------------------
  Purpose: Sets the default inner-lines for editor fields
Parameters: INPUT pdDefaultHeight - decimal Height.  
    Notes:  Editors are used for fields with word-index.
------------------------------------------------------------------------------*/
  {set DefaultEditorLines piLines}. 
  RETURN TRUE.            
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDefaultLogical) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDefaultLogical Procedure 
FUNCTION setDefaultLogical RETURNS LOGICAL
  ( pcDefaultLogical AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Not in use
    Notes:  
------------------------------------------------------------------------------*/
  {set DefaultLogical pcDefaultLogical}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDefaultWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDefaultWidth Procedure 
FUNCTION setDefaultWidth RETURNS LOGICAL
  ( pdDefaultWidth AS DEC) :
/*------------------------------------------------------------------------------
  Purpose: Sets the default width of non-character fields
Parameters: INPUT pdDefualtwidth - decimal width.  
    Notes:  
------------------------------------------------------------------------------*/
  {set DefaultWidth pdDefaultWidth}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisplayedFields Procedure 
FUNCTION setDisplayedFields RETURNS LOGICAL
  ( pcDisplayedFields AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Set the list of fields to display  
Parameters: INPUT pcDisplayedFields - comma separated list  
    Notes:  
------------------------------------------------------------------------------*/
  {set DisplayedFields pcDisplayedFields}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnabledFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEnabledFields Procedure 
FUNCTION setEnabledFields RETURNS LOGICAL
  ( pcEnabledFields AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Set the list of fields to enabled  
Parameters: INPUT pcEnabledFields - comma separated list  
    Notes: NOT used  
----------------------------------------------------------------------------*/

 {set EnabledFields pcEnabledFields}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldColumn Procedure 
FUNCTION setFieldColumn RETURNS LOGICAL
  ( pcFieldColumn AS DEC) :
/*------------------------------------------------------------------------------
  Purpose:  Store the Column position of the fields 
Parameters: INPUT pcFieldColumn field Column position
    Notes:  
------------------------------------------------------------------------------*/  
  {set FieldColumn pcFieldColumn}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldFormats) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldFormats Procedure 
FUNCTION setFieldFormats RETURNS LOGICAL
  ( pcFieldFormats AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Store the internal list of overridden fields and formats 
Parameters: INPUT pcFieldFormats- CHR(1) separated list  
    Notes:  
------------------------------------------------------------------------------*/
  {set FieldFormats pcFieldFormats}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldHelpIds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldHelpIds Procedure 
FUNCTION setFieldHelpIds RETURNS LOGICAL
  ( pcFieldHelpIds AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Store the internal list of fields and helpids 
Parameters: INPUT pcFieldHelpIds- CHR(1) separated list  
    Notes:  
------------------------------------------------------------------------------*/
  {set FieldHelpIds pcFieldHelpIds}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldLabels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldLabels Procedure 
FUNCTION setFieldLabels RETURNS LOGICAL
  ( pcFieldLabels AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Store the internal list of overridden fields and labels 
Parameters: INPUT pcFieldLabels - CHR(1) separated list  
    Notes:  
------------------------------------------------------------------------------*/
  {set FieldLabels pcFieldLabels}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldOperatorStyles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldOperatorStyles Procedure 
FUNCTION setFieldOperatorStyles RETURNS LOGICAL
  ( pcFieldOperatorStyles AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Store the internal list of overridden fields and operatorstyle 
Parameters: INPUT pcFieldOperatorStyles - CHR(1) separated list  
    Notes:  
------------------------------------------------------------------------------*/
  {set FieldOperatorStyles pcFieldOperatorStyles}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldToolTips) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldToolTips Procedure 
FUNCTION setFieldToolTips RETURNS LOGICAL
  ( pcFieldToolTips AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Store the internal list of fields and TOOLTIPs
Parameters: INPUT pcFieldTooltips- CHR(1) separated list  
    Notes:  
------------------------------------------------------------------------------*/
  {set FieldToolTips pcFieldToolTips}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldWidths) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldWidths Procedure 
FUNCTION setFieldWidths RETURNS LOGICAL
  ( pcFieldWidths AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Store the internal list of overridden field widths 
Parameters: INPUT pcFieldWidths - CHR(1) separated list  
    Notes:  
------------------------------------------------------------------------------*/  
  {set FieldWidths pcFieldWidths}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFilterTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFilterTarget Procedure 
FUNCTION setFilterTarget RETURNS LOGICAL
  (pcTarget AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Store the filter-target handle  
    Notes:    
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpFilterTarget
  {set FilterTarget pcTarget}.
  &UNDEFINE xpFilterTarget
  
  RETURN TRUE. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFilterTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFilterTargetEvents Procedure 
FUNCTION setFilterTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of events to subscribe to in the FilterTarget.
   Params:  pcEvents AS CHARACTER -- CHARACTER string form of the event names.
    Notes:  Because the value can be a list, it should be changed using
              modifyListProperty
------------------------------------------------------------------------------*/

  {set FilterTargetEvents pcEvents}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOperator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOperator Procedure 
FUNCTION setOperator RETURNS LOGICAL
  ( pcOperator AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Store the default operator when OperatorStyle eq "Implicit" 
Parametsers: INPUT pcOperator - a valid operator    
    Notes:  
------------------------------------------------------------------------------*/
  {set Operator pcOperator}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOperatorStyle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOperatorStyle Procedure 
FUNCTION setOperatorStyle RETURNS LOGICAL
  ( pcOperatorStyle AS CHAR) :
/* ----------------------------------------------------------------------------  
Purpose: Stores operatorStyle  
Parameters: INPUT pcOperatorStyle  
           - "Explicit"  - specify operator in a separate widget
           - "Implicit"  - Use the Operator and UseBegins property 
           - "Range"     - Use two fill-ins and specify GE and LE values
           - "Inline"    - Type the operator in the field 
                            (Defualt Equals or BEGINS if UseBegins eq true)     
------------------------------------------------------------------------------*/
  {set OperatorStyle pcOperatorStyle}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOperatorViewAs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOperatorViewAs Procedure 
FUNCTION setOperatorViewAs RETURNS LOGICAL
  ( pcOperatorViewAs AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Store the view-as type used to define the operator when 
           OperatorStyle equals "Explicit".  
Parameters: INPUT pcOperatorViewAs - character 
                                   - Radio-set or combo-box.    
    Notes:  
------------------------------------------------------------------------------*/
  {set OperatorViewAs pcOperatorViewAs}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUseBegins) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUseBegins Procedure 
FUNCTION setUseBegins RETURNS LOGICAL
  (plUseBegins AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Store TRUE if default string operator should be BEGINS 
Parameters: INPUT plUseBegins - logical        
    Notes: Is NOT used for OperatorStyle "RANGE" or "EXPLICIT"   
------------------------------------------------------------------------------*/
  {set UseBegins plUseBegins}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUseContains) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUseContains Procedure 
FUNCTION setUseContains RETURNS LOGICAL
  (plUseContains AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Store TRUE if default operator for word indexed fields is Contains 
Parameters: INPUT plUseContains - logical        
    Notes:  Is NOT used for OperatorStyle "EXPLICIT"   
------------------------------------------------------------------------------*/
  {set UseContains plUseContains}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setViewAsFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setViewAsFields Procedure 
FUNCTION setViewAsFields RETURNS LOGICAL
  ( pcViewAsFields AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Not used  
    Notes:  
------------------------------------------------------------------------------*/
  {set ViewAsFields pcViewAsFields}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setVisualBlank) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setVisualBlank Procedure 
FUNCTION setVisualBlank RETURNS LOGICAL
  (pcVisual AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Set the value that are used to visualize that we actually are 
           searching for BLANK values.   
Parameters: INPUT pcVisual - value             
    Notes: Toggles on and off with space-bar and off with back-space. 
           The logic will ONLY work with these keys so if you type this value
           we will search for whatever was typed.     
------------------------------------------------------------------------------*/
  {set VisualBlank pcVisual}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showDataMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION showDataMessages Procedure 
FUNCTION showDataMessages RETURNS CHARACTER
  ( ) : 
/*------------------------------------------------------------------------------
  Purpose:   Returns the name of the field (if any) from the first
             error message, to allow the caller to use it to position the 
             cursor.
   Params:   <none>.   
   Notes:    Invokes fetchMessages() to retrieve all Data-related messages
             (normally database update-related error messages), and
             displays them in a alert-box of type error.
             This function expects to receive back a single string 
             from fetchMessages with one or more messages delimited by CHR(3),
             and within each message the message text, Fieldname (or blank) +
             a Tablename (or blank), delimited by CHR(4) if present.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMessages   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iMsg        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iMsgCnt     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cMessage    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFirstField AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cField      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTable      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cText       AS CHARACTER NO-UNDO INIT "":U.
  
  cMessages = DYNAMIC-FUNCTION('fetchMessages':U IN TARGET-PROCEDURE).
  iMsgCnt = NUM-ENTRIES(cMessages, CHR(3)).
  DO iMsg = 1 TO iMsgCnt:
    /* Format a string of messages; each has a first line of
       "Field:  <field>    "Table:  <table>"
       (if either of these is defined) plus the error message on a
        separate line. */
    ASSIGN cMessage = ENTRY(iMsg, cMessages, CHR(3))
           cField = IF NUM-ENTRIES(cMessage, CHR(4)) > 1 THEN
             ENTRY(2, cMessage, CHR(4)) ELSE "":U
           cTable = IF NUM-ENTRIES(cMessage, CHR(4)) > 2 THEN
             ENTRY(3, cMessage, CHR(4)) ELSE "":U
           cText = cText + (IF cField NE "":U THEN
             dynamic-function('messageNumber':U IN TARGET-PROCEDURE, 10) ELSE "":U)              
             + cField + "   ":U +       
             (IF cTable NE "":U THEN 
             dynamic-function('messageNumber':U IN TARGET-PROCEDURE, 11) ELSE "":U) + cTable + 
             (IF cField NE "":U OR cTable NE "":U THEN "~n":U ELSE "":U)
                 + "  ":U + ENTRY(1, cMessage, CHR(4)) + "~n":U.
    /* Return the field name from the first error message so the caller can
       use it to position the cursor. */
    IF iMsg = 1 THEN cFirstField = cField.
  END.   /* END DO iMsg */
  IF cText NE "":U THEN
    MESSAGE cText VIEW-AS ALERT-BOX ERROR.

  RETURN cFirstField.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-unBlankFillin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION unBlankFillin Procedure 
FUNCTION unBlankFillin RETURNS LOGICAL
  ( phField AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Reset the format of a blank fill-in 
Parameters: INPUT phField - the handle of a field      
    Notes: blankFields changes the format of fill-ins in order to make it 
           appear blank. 
         - Logical fill-ins are unblanked in unblankLogical.  
         - This function is called as soon as the user starts editing the field 
           VALUE-CHANGED -> "U10" triggers in filter.i makes this happen.         
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFormat   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataType AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iPeriod   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cDecPoint AS CHAR      NO-UNDO.
  DEFINE VARIABLE iCursor   AS INTEGER   NO-UNDO.
  /* We need to avoid setting format for datetime fields as the datasource
     format is always 'mdy', while the widget format is adjusted when
     widget is created, but not when assigned. The format for date fields 
     is not manipulated anyways */  
  IF NOT (phField:DATA-TYPE BEGINS 'Date':U) THEN 
  DO:
    ASSIGN
      cDataType = {fnarg columnDataType phField:NAME}
       
      /* The objects data-type may be different than the field's real data-type 
        (OperatorStyle = "inline") */  
      cFormat   = IF  cDataType <> phField:DATA-TYPE 
                  AND phField:DATA-TYPE = "CHARACTER":U 
                  THEN {&charformat}
                  ELSE {fnarg columnFormat phField:NAME}.
    
    IF phField:FORMAT <> cFormat THEN 
    DO:
      /* logical format is reapplied in the persistent any-printable, ctrl-v
         shift-ins unblankLogical trigger. If we get here with mismatched format 
         the user must have pasted a value from the fill-ins default popup menu.
         This event in not triggered in progress and thus bypasses unblankLogical,
         so we call unblankLogical, which will use the clipboard:value if 
         lastkey is not printable */ 
      IF phField:DATA-TYPE = 'LOGICAL':U  THEN
        RUN unblankLogical IN TARGET-PROCEDURE(phField).      
      ELSE DO:
        iCursor = phField:CURSOR-OFFSET.
        phField:FORMAT = cFormat NO-ERROR.
        /* If format does not match the typed character just give a BELL, which is
           how it would behave if the format was there BEFORE the typing */ 
        IF ERROR-STATUS:GET-MESSAGE(1) <> '':U THEN
        DO:
          BELL.
        END.
        /* Character fields had correct position before format was applied
          (blankfillin replaces mask with blank-mask, so there is no change 
           in position of input-value data) */
        ELSE IF phField:DATA-TYPE = "CHARACTER":U THEN
          phField:CURSOR-OFFSET = iCursor.        
        ELSE IF phField:DATA-TYPE = "DECIMAL":U THEN
        DO:     
          /* In decimal fields the cursor should be before the decimal point */ 
          ASSIGN
            cDecPoint = SESSION:NUMERIC-DECIMAL-POINT
            iPeriod   = INDEX(phField:SCREEN-VALUE,cDecPoint).
          
          IF iPeriod > 0 THEN
            phField:CURSOR-OFFSET = iPeriod.
          ELSE
            APPLY "END":U TO phField.          
        END. /* IF DATA-TYPE EQ DECIMAL */
        ELSE 
          APPLY "END":U TO phField.
      END.
    END.      
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

