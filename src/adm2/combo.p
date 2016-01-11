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
    File        : combo.p
    Purpose     : Super procedure for combo class.

    Syntax      : RUN start-super-proc("adm2/combo.p":U).

    Modified    : 08/14/2001
    
    Modified    : 08/23/2001
                  When adding a new record the key field value is not set when 
                  the combo did not have a value-changed event. Check if the 
                  currentKeyValue field is BLANK and set the KeyFieldValue 
                  property to the first item in the list. (displayCombo)

    Modified    : 08/30/2001
                  Added new field to ttDCombo 'cKeyFormat'. This field will
                  help to convert the STRING value of any non-character
                  field to the correct value in the list items. A problem
                  occurred due to obj field's decimal value being trimmed
                  when converted to a string.
    
    Modified    : 09/25/2001         Mark Davies (MIP)
                  1. Remove References to KeyFieldValue and SavedScreenValue.
    Modofied    : 10/16/2001         Mark Davies (MIP)
                  1. Removed 'Sort' option and added Inner Lines
    Modified    : 10/25/2001         Mark Davies (MIP)
                  Added global variable glSecured and functions to get and set
                  the value depending on the field if it is secured.
    Modified    : 10/26/2001         Mark Davies (MIP)
                  Renamed property 'ComboFlagValue' to 'FlagValue'
    Modified    : 16/11/2001         Mark Davies (MIP)
                  Changed AllFieldHandles to reference the PROCEDURE handle
                  of SDF's and not the FRAME handle.
    Modified    : 02/05/2002         Mark Davies (MIP)
                  Fix for issue #3627 - Toolbar with tableiotype ‘UPDATE’ does not sentisize correctly
                  Always ensure that the combo box is disabled on initialization.
    Modified    : 03/06/2002         Mark Davies (MIP)
                  Fix for issue #3781 - Flashing fix prevents dyn combo from 
                  repositioning to initial value
    Modified    : 04/11/2002         Chris Koster (MIP)
                  Added repositionObject to ensure resizing and repositioning
                  a lookup repositions the fill-in and the label correctly.
    Modified    : 04/11/2002         Mark Davies (MIP)
                  Fix for issue #2937 - Dyn combobox value doesn't change on 
                  selection of a new value
    Modified    : 05/09/2002        Mark Davies (MIP)
                  Added new field to ttDCombo called hViewer to contain the
                  handle a combo is on. Issue #4525
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


&SCOP ADMSuper combo.p

{src/adm2/ttlookup.i}
{src/adm2/ttdcombo.i}
{src/adm2/tttranslate.i}
  
  /* Custom exclude file */

  {src/adm2/custom/comboexclcustom.i}

DEFINE TEMP-TABLE ttDComboCopy  NO-UNDO LIKE ttDcombo.             
DEFINE TEMP-TABLE ttLookupEmpty NO-UNDO LIKE ttLookup.

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

&IF DEFINED(EXCLUDE-destroyCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyCombo Procedure 
FUNCTION destroyCombo RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fixKeyDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fixKeyDataType Procedure 
FUNCTION fixKeyDataType RETURNS CHARACTER
  ( pcKeyFormat AS CHARACTER,
    pcKeyDataType AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-getBuildSequence) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBuildSequence Procedure 
FUNCTION getBuildSequence RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComboDelimiter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getComboDelimiter Procedure 
FUNCTION getComboDelimiter RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComboFlag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getComboFlag Procedure 
FUNCTION getComboFlag RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComboHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getComboHandle Procedure 
FUNCTION getComboHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentDescValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentDescValue Procedure 
FUNCTION getCurrentDescValue RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentKeyValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentKeyValue Procedure 
FUNCTION getCurrentKeyValue RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-getDescSubstitute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDescSubstitute Procedure 
FUNCTION getDescSubstitute RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-getFieldHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldHandle Procedure 
FUNCTION getFieldHandle RETURNS HANDLE
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-getFlagValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFlagValue Procedure 
FUNCTION getFlagValue RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInnerLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInnerLines Procedure 
FUNCTION getInnerLines RETURNS INTEGER
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

&IF DEFINED(EXCLUDE-getLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLabel Procedure 
FUNCTION getLabel RETURNS CHARACTER
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-getListItemPairs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getListItemPairs Procedure 
FUNCTION getListItemPairs RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-getPhysicalTableNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPhysicalTableNames Procedure 
FUNCTION getPhysicalTableNames RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderJoinCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryBuilderJoinCode Procedure 
FUNCTION getQueryBuilderJoinCode RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderOptionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryBuilderOptionList Procedure 
FUNCTION getQueryBuilderOptionList RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderOrderList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryBuilderOrderList Procedure 
FUNCTION getQueryBuilderOrderList RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderTableOptionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryBuilderTableOptionList Procedure 
FUNCTION getQueryBuilderTableOptionList RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderTuneOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryBuilderTuneOptions Procedure 
FUNCTION getQueryBuilderTuneOptions RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderWhereClauses) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryBuilderWhereClauses Procedure 
FUNCTION getQueryBuilderWhereClauses RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-getRefreshList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRefreshList Procedure 
FUNCTION getRefreshList RETURNS CHARACTER
  ( INPUT pcParentCombo AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-getSecured) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSecured Procedure 
FUNCTION getSecured RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTempTables Procedure 
FUNCTION getTempTables RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUseCache Procedure 
FUNCTION getUseCache RETURNS LOGICAL
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

&IF DEFINED(EXCLUDE-returnTableIOType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD returnTableIOType Procedure 
FUNCTION returnTableIOType RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-setBuildSequence) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBuildSequence Procedure 
FUNCTION setBuildSequence RETURNS LOGICAL
  ( piSequence AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setComboDelimiter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setComboDelimiter Procedure 
FUNCTION setComboDelimiter RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setComboFlag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setComboFlag Procedure 
FUNCTION setComboFlag RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setComboHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setComboHandle Procedure 
FUNCTION setComboHandle RETURNS LOGICAL
  ( phValue AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentDescValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentDescValue Procedure 
FUNCTION setCurrentDescValue RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentKeyValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentKeyValue Procedure 
FUNCTION setCurrentKeyValue RETURNS LOGICAL
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

&IF DEFINED(EXCLUDE-setDescSubstitute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDescSubstitute Procedure 
FUNCTION setDescSubstitute RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setFlagValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFlagValue Procedure 
FUNCTION setFlagValue RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInnerLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setInnerLines Procedure 
FUNCTION setInnerLines RETURNS LOGICAL
  ( piInnerLines AS INTEGER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLabel Procedure 
FUNCTION setLabel RETURNS LOGICAL
  ( pcLabel AS CHAR )  FORWARD.

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

&IF DEFINED(EXCLUDE-setListItemPairs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setListItemPairs Procedure 
FUNCTION setListItemPairs RETURNS LOGICAL
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

&IF DEFINED(EXCLUDE-setPhysicalTableNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPhysicalTableNames Procedure 
FUNCTION setPhysicalTableNames RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderJoinCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryBuilderJoinCode Procedure 
FUNCTION setQueryBuilderJoinCode RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderOptionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryBuilderOptionList Procedure 
FUNCTION setQueryBuilderOptionList RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderOrderList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryBuilderOrderList Procedure 
FUNCTION setQueryBuilderOrderList RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderTableOptionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryBuilderTableOptionList Procedure 
FUNCTION setQueryBuilderTableOptionList RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderTuneOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryBuilderTuneOptions Procedure 
FUNCTION setQueryBuilderTuneOptions RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderWhereClauses) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryBuilderWhereClauses Procedure 
FUNCTION setQueryBuilderWhereClauses RETURNS LOGICAL
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

&IF DEFINED(EXCLUDE-setSecured) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSecured Procedure 
FUNCTION setSecured RETURNS LOGICAL
  ( INPUT plFieldIsSecured AS LOGICAL )  FORWARD.

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
         HEIGHT             = 21.29
         WIDTH              = 55.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/combprop.i}

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
  Purpose:     We could trap a keypress in here and scroll to the first occurance
               of an entry that begins with the key entered.
  Parameters:  <none>
  Notes:       Use LAST-EVENT:FUNCTION for testing keypress.
------------------------------------------------------------------------------*/

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
  
  FIND FIRST ttDCombo
       WHERE ttDCombo.hWidget = TARGET-PROCEDURE
         AND ttDCombo.cWidgetName = cFieldName
       NO-ERROR.
  IF AVAILABLE ttDCombo THEN 
    DELETE ttDCombo.
  ELSE
    ASSIGN ERROR-STATUS:ERROR = NO.
  
  {fn destroyCombo}.
  
  RUN SUPER.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableField Procedure 
PROCEDURE disableField :
/*------------------------------------------------------------------------------
  Purpose:   disable Combo Field
  Parameters: <NONE>
  Notes:  The SmartDataViewer container will call this procedure if a widget of 
          type PROCEDURE is encountered in disableFields    
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hCombo           AS HANDLE    NO-UNDO.
 DEFINE VARIABLE hBrowseContainer AS HANDLE    NO-UNDO.

 {get ComboHandle hCombo}.

 IF VALID-HANDLE(hCombo) THEN
 DO:
   ASSIGN
     hCombo:SENSITIVE = FALSE
     hCombo:TAB-STOP   = TRUE.   
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

&IF DEFINED(EXCLUDE-displayCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayCombo Procedure 
PROCEDURE displayCombo :
/*------------------------------------------------------------------------------
  Purpose:     This is published from the smartviewer containing the smartdatafield 
               to populate the combo with the evaluated query data - if the
               query was succesful.
               It is published from displayfields in the viewer.
               The queries were initially built in getComboQuery. 
  Parameters:  input combo temp-table
  Notes:       This is designed to facilitate all combo queries being built with
               a single appserver hit.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER TABLE FOR ttDCombo.

DEFINE VARIABLE cFieldName              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyFieldValue          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hCombo                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE iEntry                  AS INTEGER    NO-UNDO.
DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.
DEFINE VARIABLE cCurrentListItemPairs   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lFieldIsSecured         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cNewRecord              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lDisplayField           AS LOGICAL    NO-UNDO.

{get FieldName cFieldName}.

FIND FIRST ttDCombo
     WHERE ttDCombo.hWidget = TARGET-PROCEDURE
       AND ttDCombo.cWidgetName = cFieldName
     NO-ERROR.
IF NOT AVAILABLE ttDCombo THEN RETURN.

&SCOPED-DEFINE xp-assign
{get ComboHandle hCombo}
{get containerSource hContainer}   /* viewer */
{get DisplayField lDisplayField}
{get Secured lFieldIsSecured}.
&UNDEFINE xp-assign

cNewRecord = "":U.
IF VALID-HANDLE(hContainer) THEN
  {get NewRecord cNewRecord hContainer}. 

cKeyFieldValue = DYNAMIC-FUNCTION("formattedValue":U IN TARGET-PROCEDURE, ttDCombo.cCurrentKeyValue).

cCurrentListItemPairs = "":U.
IF CAN-QUERY(hCombo,"LIST-ITEM-PAIRS":U) THEN
  cCurrentListItemPairs = hCombo:LIST-ITEM-PAIRS.

ASSIGN hCombo:DELIMITER = ttDCombo.cListItemDelimiter.

IF cCurrentListItemPairs <> ttDCombo.cListItemPairs THEN
  hCombo:LIST-ITEM-PAIRS = ttDCombo.cListItemPairs
                           NO-ERROR.
{set ListItemPairs ttDCombo.cListItemPairs}.

/*cKeyFieldValue = TRIM(cKeyFieldValue).*/

iEntry = LOOKUP(cKeyFieldValue,ttDCombo.cKeyValues,ttDCombo.cListItemDelimiter)
         NO-ERROR.

IF iEntry = ? THEN
  iEntry = 0.
/* Only set the SCREEN-VALUE if the field is not secured */
IF NOT lFieldIsSecured AND lDisplayField THEN DO:
  IF iEntry > 0 THEN
    hCombo:SCREEN-VALUE = hCombo:ENTRY(iEntry) NO-ERROR.
  IF iEntry > 0 AND
     (hCombo:ENTRY(iEntry) = "":U OR  
      hCombo:ENTRY(iEntry) = ?) THEN
    {fnarg clearCombo hCombo}.
  
  /* If all else fails - make sure the combo doesn't assume the first available entry */
  IF (iEntry <= 0 OR
      ERROR-STATUS:ERROR OR 
      hCombo:SCREEN-VALUE = ?) AND 
     hCombo:LIST-ITEM-PAIRS <> ? THEN
    {fnarg clearCombo hCombo}.
  
  /* Check for a BLANK combo entry if pcValue is BLANK */

  IF iEntry <> 0 AND cKeyFieldValue = "":U AND cNewRecord <> "Add":U THEN DO:
    hCombo:LIST-ITEM-PAIRS = REPLACE(hCombo:LIST-ITEM-PAIRS,(hCombo:DELIMITER + hCombo:DELIMITER),(hCombo:DELIMITER + "!":U + hCombo:DELIMITER)).
    /* No assign the combo to the  */
    hCombo:SCREEN-VALUE = "!" NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
      {fnarg clearCombo hCombo}.
  END.

  IF cNewRecord <> "Add":U THEN
    cKeyFieldValue = hCombo:SCREEN-VALUE.
                           
END.
ELSE DO:
  {fnarg clearCombo hCombo}.
  ERROR-STATUS:ERROR = FALSE.
END.

IF cKeyFieldValue <> ? THEN
  {set DataValue cKeyFieldValue}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableField Procedure 
PROCEDURE enableField :
/*------------------------------------------------------------------------------
  Purpose:   enable Combo Field
  Parameters: <NONE>
  Notes:  The SmartDataViewer Container will call this procedure if a widget of 
          type PROCEDURE is encountered in enableFields    
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hCombo          AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hButton          AS HANDLE     NO-UNDO.

 {get ComboHandle hCombo}.

 IF VALID-HANDLE(hCombo) THEN
 DO:
   hCombo:SENSITIVE = TRUE.

   ASSIGN
     hCombo:TAB-STOP = TRUE.   
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

&IF DEFINED(EXCLUDE-enterCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enterCombo Procedure 
PROCEDURE enterCombo :
/*------------------------------------------------------------------------------
  Purpose:     Trigger fired on entry of combo field
  Parameters:  <none>
  Notes:       The purpose of this trigger is to store the current screen value
               of the displayed field in the combo so that where the 
               displayedfield is not equal to the keyfield (usually the case) then
               we can fire logic when the displayed field is changed in the leave
               trigger to see if the new value keyed in actually exists as a unique
               record, and if so, avoid having to use the combo.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hCombo              AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hContainer          AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cScreenValue        AS CHARACTER    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ComboHandle hCombo}
  {get containerSource hContainer}.
  &UNDEFINE xp-assign
  
  cScreenValue = ENTRY((hCombo:LOOKUP(hCombo:SCREEN-VALUE) * 2) - 1,hCombo:LIST-ITEM-PAIRS,hCombo:DELIMITER).
  {set DisplayValue cScreenValue}.

  PUBLISH "comboEntry":U FROM hContainer (INPUT hCombo:SCREEN-VALUE,   /* current combo key field value */
                                           INPUT TARGET-PROCEDURE      /* handle of combo */
                                          ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComboQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getComboQuery Procedure 
PROCEDURE getComboQuery :
/*------------------------------------------------------------------------------
  Purpose:     This routine is published from the viewer and is used to pass the query
               required by this combo back to the viewer for building. Once built,
               the query will be returned into the procedure displayCombo.
  Parameters:  input-output combo temp table
  Notes:       This is designed to facilitate all combo queries being built with
               a single appserver hit.
               It is published from displayfields in the viewer.
               NOTE that this is not run at all in add mode.
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttDCombo.

  DEFINE VARIABLE cFieldName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFormat              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyDataType            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayDataType        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDescSubstitute         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFieldValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewQuery               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentField            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentFilterQuery      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboFlag              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFlagValue              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboDelimiter         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iBuildSequence          AS INTEGER    NO-UNDO.

  DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cPhysicalTableNames     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempTableNames         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUseCache               AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get FieldName cFieldName}
  {get KeyField cKeyField}
  {get KeyFormat cKeyFormat}
  {get DisplayedField cDisplayedField}
  {get KeyDataType cKeyDataType}
  {get DisplayDataType cDisplayDataType}
  {get BaseQueryString cQueryString}
  {get QueryTables cQueryTables}
  {get DataValue cKeyFieldValue}
  {get ParentField cParentField}
  {get ParentFilterQuery cParentFilterQuery}
  {get DescSubstitute cDescSubstitute}
  {get ComboFlag cComboFlag}
  {get ComboDelimiter cComboDelimiter}
  {get FlagValue cFlagValue}
  {get BuildSequence iBuildSequence}
  {get PhysicalTableNames cPhysicalTableNames}
  {get TempTables cTempTableNames}
  {get containerSource hContainer}.   /* viewer */
  {get UseCache lUseCache}.
  &UNDEFINE xp-assign
  
  IF VALID-HANDLE(hContainer) THEN
    hDataSource = DYNAMIC-FUNCTION('getDataSource':U IN hContainer) NO-ERROR.

  cKeyDataType = fixKeyDataType(cKeyFormat,cKeyDataType).
  {set KeyDataType cKeyDataType}.

  /* we must get the value of the external field from the SDO that is the 
     data source of the viewer - and then change the query for the combo
     to find the record where the keyfield is equal to this external field
     value
  */

  IF VALID-HANDLE(hDataSource) THEN
    cKeyFieldValue = IF NUM-ENTRIES(cFieldName,".":U) > 1 THEN
                        DYNAMIC-FUNCTION("ColumnValue":U IN hDataSource,ENTRY(2, cFieldName, ".":U))
                     ELSE
                        DYNAMIC-FUNCTION("ColumnValue":U IN hDataSource,cFieldName).
  IF (cKeyFieldValue = "":u OR cKeyFieldValue = ? OR cKeyFieldValue = "0":u) AND
     DYNAMIC-FUNCTION("getNewRecord":U IN hContainer) = "Add":U THEN
      {set DataValue ''}.
  ELSE
    /* reset saved keyfieldvalue */
    {set DataValue cKeyFieldValue}.
  
      /* Update query into temp-table */
  FIND FIRST ttDCombo
       WHERE ttDCombo.hWidget = TARGET-PROCEDURE
         AND ttDCombo.hViewer = hContainer
         AND ttDCombo.cWidgetName = cFieldName
       NO-ERROR.
  IF NOT AVAILABLE ttDCombo THEN CREATE ttDCombo.
  ASSIGN
    ttDCombo.hWidget             = TARGET-PROCEDURE
    ttDCombo.hViewer             = hContainer
    ttDCombo.cWidgetName         = cFieldName
    ttDCombo.cWidgetType         = cKeyDataType
    ttDCombo.cForEach            = cQueryString
    ttDCombo.cBufferList         = cQueryTables
    ttDCombo.cKeyFieldName       = cKeyField
    ttDCombo.cKeyFormat          = cKeyFormat
    ttDCombo.cDescFieldNames     = cDisplayedField
    ttDCombo.cDescSubstitute     = cDescSubstitute
    ttDCombo.cFlag               = cComboFlag
    ttDCombo.cListItemDelimiter  = cComboDelimiter
    ttDCombo.cCurrentKeyValue    = cKeyFieldValue
    ttDCombo.cFlagValue          = cFlagValue
    ttDCombo.cParentField        = cParentField
    ttDCombo.cParentFilterQuery  = cParentFilterQuery
    ttDCombo.iBuildSequence      = iBuildSequence
    ttDCombo.cPhysicalTableNames = cPhysicalTableNames
    ttDCombo.cTempTableNames     = cTempTableNames
    ttDCombo.lUseCache           = lUseCache.
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

&IF DEFINED(EXCLUDE-initializeCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeCombo Procedure 
PROCEDURE initializeCombo :
/*------------------------------------------------------------------------------
  Purpose:     Run as part of initializeObject to set up the combo
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
  DEFINE VARIABLE hCombo                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLookupImg            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBtn                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iRowsToBatch          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cUIBMode              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboDelimiter       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iInnerLines           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dComboWidth           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lLocalField           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cTableIOType          AS CHARACTER  NO-UNDO.

  {get ContainerHandle hFrame}.

  hParentFrame = hFrame:FRAME.

  IF NOT VALID-HANDLE(hParentFrame) THEN 
    RETURN.

  {fn destroyCombo}. /* Get rid of existing widgets so we can recreate them */
  
  &SCOPED-DEFINE xp-assign
  {get DisplayedField cDisplayedField}
  {get KeyField cKeyField}
  {get FieldLabel cLabel}
  {get FieldToolTip cToolTip}
  {get KeyFormat cKeyFormat}
  {get KeyDataType cKeyDataType}
  {get DisplayFormat cDisplayFormat}
  {get DisplayDataType cDisplayDataType}
  {get UIBMode cUIBmode}
  {get ComboDelimiter cComboDelimiter}
  {get InnerLines iInnerLines}
  {get ContainerSource hContainer}
  {get Width dComboWidth}
  /* Check if SDF was dropped onto a Local Field #9417*/
  {get LocalField lLocalField}.
  &UNDEFINE xp-assign

  IF cComboDelimiter = '':U THEN
  DO:
    cComboDelimiter = CHR(1).
    {set ComboDelimiter cComboDelimiter}.
  END.

  cKeyDataType = fixKeyDataType(cKeyFormat,cKeyDataType).
  {set KeyDataType cKeyDataType}.

  IF VALID-HANDLE(hContainer) AND (cUIBMode BEGINS "DESIGN":U) = FALSE THEN
    DYNAMIC-FUNCTION("setEditable":U IN hContainer,TRUE) NO-ERROR.
  
  IF iInnerLines = ? OR
     iInnerLines = 0 THEN
    iInnerLines = 5.
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
  IF cKeyDataType = "":U AND
     INDEX(cKeyFormat,".":U) > 0 THEN
    ASSIGN cKeyDataType = "decimal":U.

  IF cKeyDataType = "":U AND
     INDEX(cKeyFormat,"X(":U) > 0 THEN
    ASSIGN cKeyDataType = "CHARACTER":U.

  IF cKeyDataType = "":U AND
     cKeyFormat = "":U THEN
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
    WHEN "decimal":U THEN ASSIGN cDisplayFormat = "->>>>>>>>>>>>>>>>>9.999999999":U.
    WHEN "date":U THEN ASSIGN cDisplayFormat = "99/99/9999":U.
    WHEN "datetime":U THEN ASSIGN cDisplayFormat = "99/99/9999 HH:MM:SS.SSS":U.
    WHEN "datetime-tz":U THEN ASSIGN cDisplayFormat = "99/99/9999 HH:MM:SS.SSS+HH:MM":U.
    WHEN "integer":U THEN ASSIGN cDisplayFormat = ">>>>>>>9":U.
    OTHERWISE ASSIGN cDisplayFormat = "x(256)":U.
  END CASE.
  {set DisplayFormat  cDisplayFormat}.

    
  CREATE COMBO-BOX hCombo
    ASSIGN FRAME            = hFrame
           NAME             = "fiCombo" 
           SUBTYPE          = "DROP-DOWN-LIST":U 
           X                = 0
           Y                = 0
           INNER-LINES      = iInnerLines
           AUTO-COMPLETION  = TRUE       
           DELIMITER        = cComboDelimiter
           WIDTH-PIXELS     = hFrame:WIDTH-PIXELS
           SORT             = FALSE
           SENSITIVE        = (cUIBMode BEGINS "DESIGN":U) = FALSE
           TAB-STOP         = TRUE.

  ASSIGN 
    hCombo:DATA-TYPE = cKeyDataType 
    hCombo:FORMAT    = cKeyFormat
    hCombo:HIDDEN    = FALSE NO-ERROR.

  {set ComboHandle hCombo}.

  ASSIGN hFrame:HEIGHT = hCombo:HEIGHT NO-ERROR.

  /* create an entry/leave trigger always, code is defined */
  ON ENTRY OF hCombo 
   PERSISTENT RUN enterCombo IN TARGET-PROCEDURE.
  ON LEAVE OF hCombo 
   PERSISTENT RUN leaveCombo IN TARGET-PROCEDURE.
  ON CTRL-ALT-SHIFT-Q OF hCombo
   PERSISTENT RUN showQuery IN TARGET-PROCEDURE.

  IF VALID-HANDLE(hCombo) THEN
  DO:
    /* create a label if not blank */  
    IF cLabel NE "":U THEN
      {fnarg createLabel cLabel}. 
    
    hCombo:MOVE-TO-BOTTOM().
    hCombo:TOOLTIP = cToolTIP.

    /*ON ANY-KEY OF hCombo PERSISTENT RUN anyKey IN TARGET-PROCEDURE.*/

    ON VALUE-CHANGED OF hCombo PERSISTENT RUN valueChanged IN TARGET-PROCEDURE.
    ON END-MOVE      OF hFrame PERSISTENT RUN endMove      IN TARGET-PROCEDURE. 
  END.
   
  cTableIOType = DYNAMIC-FUNCTION("returnTableIOType":U IN TARGET-PROCEDURE).

  IF NOT lLocalField OR cTableIOType = "Update":U THEN
    RUN disableField IN TARGET-PROCEDURE. /* Always disable field on initialization - fix for issue #3627*/  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-leaveCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveCombo Procedure 
PROCEDURE leaveCombo :
/*------------------------------------------------------------------------------
  Purpose:     Trigger fired on leave of combo field
  Parameters:  <none>
  Notes:       The purpose of this trigger is to store the current screen value
               of the displayed field in the combo so that where the 
               displayedfield is not equal to the keyfield (usually the case) then
               we can fire logic when the displayed field is changed in the leave
               trigger to see if the new value keyed in actually exists as a unique
               record, and if so, avoid having to use the combo.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hCombo               AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hContainer           AS HANDLE       NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ComboHandle hCombo}
  {get containerSource hContainer}.
  &UNDEFINE xp-assign

  PUBLISH "comboLeave":U FROM hContainer (INPUT hCombo:SCREEN-VALUE,   /* current combo key field value */
                                          INPUT TARGET-PROCEDURE       /* handle of combo */
                                          ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshChildDependancies) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshChildDependancies Procedure 
PROCEDURE refreshChildDependancies :
/*------------------------------------------------------------------------------
  Purpose:     This procedure steps through any other Dynamic Combo's and checks
               if it is a parent of that combo, If it is, it will run refreshCombo
               in this procedure that will refresh the data items accordingly.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFieldName AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cFieldName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyDataType        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayDataType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryTables        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDescSubstitute     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFieldValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewQuery           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentField        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboFlag          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFlagValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboDelimiter     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentFilterQuery  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hContainer          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCombo              AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cList               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLoopList           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRefreshList        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLoop2              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cCombo              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOriginalKeyValue   AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get containerSource hContainer}   /* viewer */
  {get ComboHandle hCombo}.
  &UNDEFINE xp-assign
  /* Create a list of Dynamic Combos to be refreshed
     due to the parent changing */
  cLoopList = pcFieldName.
  cList = cLoopList.
  DO_WHILE:
  DO WHILE cList <> "":U:
    cList = "":U.
    DO iLoop = 1 TO NUM-ENTRIES(cLoopList):
      cCombo = ENTRY(iLoop,cLoopList).
      IF getRefreshList(cCombo) = "":U THEN
        LEAVE DO_WHILE.
      cList = IF cList = "":U THEN getRefreshList(cCombo) ELSE cList + "," + getRefreshList(cCombo).
    END.
    cLoopList = cList.
    cRefreshList = IF cRefreshList = "":U THEN cList ELSE cRefreshList + ",":U + cList.
  END.
  
  ASSIGN cLoopList    = cRefreshList
         cRefreshList = "":U.

  DO iLoop = 1 TO NUM-ENTRIES(cLoopList):
    cCombo = ENTRY(iLoop,cLoopList).
    IF LOOKUP(cCombo,cRefreshList) > 0 THEN
      NEXT.
    cRefreshList = IF cRefreshList = "":U THEN cCombo ELSE cRefreshList + ",":U + cCombo.
  END.
  
  IF cRefreshList = "":U OR
     cRefreshList = ? THEN
    RETURN.

  DO iLoop = 1 TO NUM-ENTRIES(cRefreshList):
    cCombo = ENTRY(iLoop,cRefreshList).
    
    FIND FIRST ttDCombo
         WHERE ttDCombo.hViewer     = hContainer
         AND   ttDCombo.cWidgetName = cCombo
         EXCLUSIVE-LOCK NO-ERROR.
    
    IF NOT AVAILABLE ttDCombo THEN
      NEXT.

    IF NOT VALID-HANDLE(ttDCombo.hWidget) THEN
        NEXT.

    &SCOPED-DEFINE xp-assign
    {get FieldName cFieldName ttDCombo.hWidget}
    {get KeyField cKeyField ttDCombo.hWidget}
    {get DisplayedField cDisplayedField ttDCombo.hWidget}
    {get KeyDataType cKeyDataType ttDCombo.hWidget}
    {get DisplayDataType cDisplayDataType ttDCombo.hWidget}
    {get BaseQueryString cQueryString ttDCombo.hWidget}
    {get QueryTables cQueryTables ttDCombo.hWidget}
    {get DataValue cKeyFieldValue ttDCombo.hWidget}
    {get ParentField cParentField ttDCombo.hWidget}
    {get DescSubstitute cDescSubstitute ttDCombo.hWidget}
    {get ComboFlag cComboFlag ttDCombo.hWidget}
    {get ComboDelimiter cComboDelimiter ttDCombo.hWidget}
    {get FlagValue cFlagValue ttDCombo.hWidget}.
    &UNDEFINE xp-assign
  
    cNewQuery = cQueryString .
  
    /* We need to set the values to nothing in order to refresh
       the queries to the new values of each individual combo */
    {set DataValue '' ttDCombo.hWidget}.
    /* Get Parent-Child filter Query */
    RUN returnParentFieldValues IN ttDCombo.hWidget (OUTPUT cParentFilterQuery).
    IF cParentFilterQuery <> "":U THEN DO:
      IF  NUM-ENTRIES(cParentFilterQuery,"|":U) > 1 
      AND NUM-ENTRIES(cQueryTables) > 1 THEN 
      DO:
        DO iLoop2 = 1 TO NUM-ENTRIES(cParentFilterQuery,"|":U):
          IF TRIM(ENTRY(iLoop2,cParentFilterQuery,"|":U)) <> "":U THEN
            cNewQuery = DYNAMIC-FUNCTION("newWhereClause" IN ttDCombo.hWidget,
                                         ENTRY(iLoop2,cQueryTables),
                                         ENTRY(iLoop2,cParentFilterQuery,"|":U),
                                         cNewQuery,
                                         "AND":U).
        END.
      END.
      ELSE 
        cNewQuery = DYNAMIC-FUNCTION("newWhereClause" IN ttDCombo.hWidget,
                                     ENTRY(1,cQueryTables),
                                     cParentFilterQuery,
                                     cNewQuery,
                                     "AND":U).
    END.
    /* Just making double sure that we do not refresh the combo
       if no parent filter query was specified */
    ELSE
      NEXT.
     
    /* If the query is still the same - there is no need to refresh
       the query. Get out of here */
    IF ttDCombo.cForEach = cNewQuery THEN
      NEXT.
     
    /* Since we do not want to lose the other Combo information
       we'll copy the changed record to another buffer and
       get the query back for these combos only */
    CREATE ttDComboCopy.
    BUFFER-COPY ttDCombo TO ttDComboCopy.
    ASSIGN ttDComboCopy.cForEach = cNewQuery.
  END.

  /* To be on the save side of Lookups, I created another temp-table
     for it so that we don't break anything - this would always
     be empty in anycase */
  EMPTY TEMP-TABLE ttLookupEmpty.

  /* Resolve query */
  IF VALID-HANDLE(gshAstraAppserver) THEN
    RUN adm2/lookupqp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttLookupEmpty,
                                              INPUT-OUTPUT TABLE ttDComboCopy,
                                              INPUT "ComboAutoRefresh":U,
                                              INPUT "":U,
                                              INPUT hContainer).
  
  /* After the query has been repopulated - assign all the values back
     to the original temp-table - since all the other procedures
     refer to that table */
  FOR EACH ttDComboCopy:
    FIND FIRST ttDCombo
         WHERE ttDCombo.hWidget     = ttDComboCopy.hWidget
         AND   ttDCombo.cWidgetName = ttDComboCopy.cWidgetName
         EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE ttDCombo THEN 
    DO:
      BUFFER-COPY ttDComboCopy TO ttDCombo.
      RUN refreshCombo IN ttDCombo.hWidget.
    END.
  END.
  /* The table is duplicated in the viewer class, so assign the values back 
     to that also */
  RUN updateDynComboTable IN hContainer(TEMP-TABLE ttDComboCopy:DEFAULT-BUFFER-HANDLE).
  EMPTY TEMP-TABLE ttDComboCopy.
  
  /* Now we need to see if we can set the combo back to the original set value 
     We only want to do this if called from somewhere other than VALUE-CHANGED */
  IF  INDEX(PROGRAM-NAME(2),"valueChanged":U) = 0 
  AND INDEX(PROGRAM-NAME(2),"combo.p":U) = 0 THEN 
  DO:
    FIND FIRST ttDCombo
         WHERE ttDCombo.hWidget = TARGET-PROCEDURE
         NO-LOCK NO-ERROR.
    IF AVAILABLE ttDCombo THEN 
    DO:
      IF VALID-HANDLE(hContainer) THEN
        hDataSource = DYNAMIC-FUNCTION('getDataSource':U IN hContainer) NO-ERROR.
      {get FieldName cFieldName}.
      IF VALID-HANDLE(hDataSource) THEN
        cOriginalKeyValue = IF NUM-ENTRIES(cFieldName,".":U) > 1 THEN
                              DYNAMIC-FUNCTION("ColumnStringValue":U IN hDataSource,ENTRY(2, cFieldName, ".":U))
                            ELSE
                              DYNAMIC-FUNCTION("ColumnStringValue":U IN hDataSource,cFieldName).
      IF LOOKUP(cKeyFieldValue,ttDCombo.cKeyValues,ttDCombo.cListItemDelimiter) > 0 AND 
         cOriginalKeyValue <> "":U AND cOriginalKeyValue <> ? AND cOriginalKeyValue <> "?":U THEN
        {set DataValue cOriginalKeyValue}.
        
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshCombo Procedure 
PROCEDURE refreshCombo :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is usually triggered from a value-changed event
               of a parent combo.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
  RUN displayCombo IN TARGET-PROCEDURE (INPUT TABLE ttDCombo).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionObject Procedure 
PROCEDURE repositionObject :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will reposition the combo and it's label
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
  Purpose: Resize the Combo      
  Parameters:  INPUT pidHeight decimal New height of component 
               INPUT pidWidth decimal New widtht of component.
  Notes:  The procedure deletes the current widget,
          Resizes the frame and recreates the widget.  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pidHeight AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pidWidth  AS DECIMAL NO-UNDO.

  DEFINE VARIABLE hCombo    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFrame    AS HANDLE     NO-UNDO.
                     
  &SCOPED-DEFINE xp-assign
  {get ContainerHandle hFrame}
  {get ComboHandle     hCombo}.
  &UNDEFINE xp-assign
                     
  ASSIGN hFrame:SCROLLABLE            = TRUE
         hFrame:WIDTH-CHARS           = pidWidth
         hFrame:HEIGHT-CHARS          = pidHeight
         hFrame:VIRTUAL-WIDTH-CHARS   = hFrame:WIDTH-CHARS
         hFrame:VIRTUAL-HEIGHT-CHARS  = hFrame:HEIGHT-CHARS
         hFrame:SCROLLABLE            = FALSE.
  
  IF VALID-HANDLE(hCombo) THEN
    hCombo:WIDTH-CHARS = pidWidth.



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

  &SCOPED-DEFINE xp-assign
  {get ParentField cParentField}
  {get ParentFilterQuery cFilterQuery}
  {get containerSource hContainer}.   /* viewer */
  &UNDEFINE xp-assign

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
       LOOKUP(hWidget:NAME, cParentField) <> 0 AND 
       hWidget:NAME <> ? THEN
    DO:
      ASSIGN
        iField = LOOKUP(hWidget:NAME, cParentField)
        cField = ENTRY(iField,cParentField)
        NO-ERROR.
      IF iField > 0 AND iField <= 9 AND iField <> ? THEN
        ASSIGN cValue        = IF CAN-QUERY(hWidget,"INPUT-VALUE":U) THEN hWidget:INPUT-VALUE ELSE hWidget:SCREEN-VALUE
               cValue        = IF cValue = ? OR cValue = "?":U THEN "":U ELSE cValue
               cSubs[iField] = TRIM(cValue).
    END.
    
    /* SmartDataFields Static Combo, Dynamic Combos and Lookups */
    IF VALID-HANDLE(hWidget) AND hWidget:TYPE = "PROCEDURE":U THEN 
    DO:
      ASSIGN 
        hSDFHandle    = hWidget
        cSDFFieldName = '':U.

      {get FieldName cSDFFieldName hSDFHandle} NO-ERROR.
      IF cSDFFieldName NE '':U THEN
      DO:
        ASSIGN
          iField = LOOKUP(cSDFFieldName, cParentField)
          cField = ENTRY(iField,cParentField) NO-ERROR.

        {get DataValue cValue hSDFHandle}.
        
        IF iField > 0 AND iField <= 9 THEN
          ASSIGN cSubs[iField] = TRIM(cValue).
      END.  /* if SDF */
    END.  /* if procedure */
    
  END.
  
  pcNewQuery = SUBSTITUTE(cFilterQuery,cSubs[1],cSubs[2],cSubs[3],cSubs[4],cSubs[5],cSubs[6],cSubs[7],cSubs[8],cSubs[9]).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showQuery Procedure 
PROCEDURE showQuery :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will display the current query of the combo.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldName              AS CHARACTER  NO-UNDO.
  
  {get FieldName cFieldName}.
  
  FIND FIRST ttDCombo
       WHERE ttDCombo.hWidget = TARGET-PROCEDURE
         AND ttDCombo.cWidgetName = cFieldName
       NO-ERROR.
  IF NOT AVAILABLE ttDCombo THEN RETURN.
  
  MESSAGE ttDCombo.cForEach
          VIEW-AS ALERT-BOX TITLE "Combo Query".

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

  DEFINE VARIABLE cEvent         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hCombo         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lRepos         AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cKeyFieldValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScreenValue   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyValues     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDescValues    AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get ComboHandle hCombo}
  {get ContainerSource hContainer}
  {get FieldName cFieldName}.
  &UNDEFINE xp-assign
 
  /* First we'll set the new KeyFieldValue */
  cKeyFieldValue = TRIM(hCombo:INPUT-VALUE) NO-ERROR.
  IF NOT ERROR-STATUS:ERROR THEN
    {set DataValue cKeyFieldValue}.
  
  &SCOPED-DEFINE xp-assign
  /* Get the value formatted correctly */
  {get DataValue cKeyFieldValue}
  {set DataModified YES}.
  &UNDEFINE xp-assign
  
  FIND FIRST ttDCombo
       WHERE ttDCombo.hWidget = TARGET-PROCEDURE
       AND   ttDCombo.cWidgetName = cFieldName
       EXCLUSIVE-LOCK NO-ERROR.
  
  IF AVAILABLE ttDCombo THEN 
  DO:
    ASSIGN ttDCombo.cCurrentKeyValue = cKeyFieldValue.
    cScreenValue = ENTRY((hCombo:LOOKUP(hCombo:SCREEN-VALUE) * 2) - 1,hCombo:LIST-ITEM-PAIRS,hCombo:DELIMITER).
    {set CurrentDescValue cScreenValue}.
  END.

  /* Refreshes any other child dependant Dynamic combo's */
  RUN refreshChildDependancies IN TARGET-PROCEDURE (INPUT cFieldName).

  /* This will ensure that the Static Combo's know that the parent has changed */
  PUBLISH "populateChildCombo":U FROM hContainer (INPUT cKeyFieldValue, INPUT TRUE).
  
  PUBLISH "comboValueChanged":U FROM  hContainer (INPUT cKeyFieldValue,     /* Key Field Value */
                                                  INPUT cScreenValue,       /* Current Screen Value */
                                                  INPUT TARGET-PROCEDURE    /* Handle to combo - use to determine which combo's value was changed */
                                                  ). 

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
  Purpose   : Create the label of the Combo 
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
   DEFINE VARIABLE hCombo        AS HANDLE     NO-UNDO.

   &SCOPED-DEFINE xp-assign
   {get LabelHandle hLabel}
   {get Labels lLabels}
   /* Check if the SDF is being hidden on initialization - issue 11059 */
   {get HideOnInit lVisible}
   {get ComboHandle hCombo}
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
            HIDDEN                = FALSE
            WIDTH-PIXELS          = iLabelLength
            FORMAT                = "x(256)":U
            SCREEN-VALUE          = pcLabel + ":":U
            HEIGHT-PIXELS         = SESSION:PIXELS-PER-ROW 
            HIDDEN                = lVisible
            .  
   IF hLabel:COL <= 0 THEN
     hLabel:COL = 1.

  {set LabelHandle hLabel}.
  hCombo:SIDE-LABEL-HANDLE = hLabel.

  RETURN hLabel. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyCombo Procedure 
FUNCTION destroyCombo RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Cleanup all dynamicly created objects. 
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hCombo       AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hLabel        AS HANDLE   NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get ComboHandle hCombo}
  {get LabelHandle hLabel}.
  &UNDEFINE xp-assign

  IF VALID-HANDLE(hCombo) THEN DELETE WIDGET hCombo.
  IF VALID-HANDLE(hLabel)  THEN DELETE WIDGET hLabel.

  ASSIGN
    hCombo = ?
    hLabel = ?
    .

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fixKeyDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fixKeyDataType Procedure 
FUNCTION fixKeyDataType RETURNS CHARACTER
  ( pcKeyFormat AS CHARACTER,
    pcKeyDataType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  In an earlier version of Dynamics we saved the DisplayDataType
            in the KeyDataType attribute and visa-versa...
            We need to cater for this situation since older version's data
            will still be incorrect and it is not possible to fix the data
            in the repository due to the complexity.
    Notes:  
------------------------------------------------------------------------------*/
  
  IF pcKeyDataType = "CHARACTER":U THEN DO:
    IF INDEX(pcKeyFormat,">":U) > 0 AND
       INDEX(pcKeyFormat,"9":U) > 0 AND
       INDEX(pcKeyFormat,".":U) > 0 THEN /* We have a decimal */
      pcKeyDataType = "DECIMAL":U.
    IF INDEX(pcKeyFormat,">":U) > 0 AND
       INDEX(pcKeyFormat,"9":U) > 0 AND
       INDEX(pcKeyFormat,".":U) = 0 THEN /* We have an Integer */
      pcKeyDataType = "INTEGER":U.
    IF INDEX(pcKeyFormat,"/":U) > 0 AND
       INDEX(pcKeyFormat,"99":U) > 0 THEN /* We have a Date */
      pcKeyDataType = "DATE":U.
    IF INDEX(pcKeyFormat,"TRUE":U) > 0 OR
       INDEX(pcKeyFormat,"YES":U) > 0 THEN /* We have a Logical */
      pcKeyDataType = "LOGICAL":U.
  END.

  RETURN pcKeyDataType.   /* Function return value. */

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

&IF DEFINED(EXCLUDE-getBuildSequence) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBuildSequence Procedure 
FUNCTION getBuildSequence RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iSequence AS INTEGER NO-UNDO.
  
  
  &SCOPED-DEFINE xpBuildSequence
  {get BuildSequence iSequence}.
  &UNDEFINE xpBuildSequence
  
  RETURN iSequence.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComboDelimiter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getComboDelimiter Procedure 
FUNCTION getComboDelimiter RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get ComboDelimiter cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComboFlag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getComboFlag Procedure 
FUNCTION getComboFlag RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get ComboFlag cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComboHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getComboHandle Procedure 
FUNCTION getComboHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hValue AS HANDLE NO-UNDO.
  {get ComboHandle hValue}.
  RETURN hValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentDescValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentDescValue Procedure 
FUNCTION getCurrentDescValue RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get DisplayValue cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentKeyValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentKeyValue Procedure 
FUNCTION getCurrentKeyValue RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get DataValue cValue}.
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
  DEFINE VARIABLE hCombo          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDisplayedField AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDefaultValue   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyDataType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFormat      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldDataValue   AS CHARACTER  NO-UNDO.
  
  /*
  /* ensure manual field changes are saved correctly */
  RUN leaveCombo IN TARGET-PROCEDURE.
  */
  {get ComboHandle hCombo}.

  IF NOT VALID-HANDLE(hCombo) THEN
    RETURN ERROR. 

  &SCOPED-DEFINE xp-assign
  {get KeyField cKeyField}
  {get DisplayedField cDisplayedField}
  {get FlagValue cDefaultValue}
  {get KeyDataType cKeyDataType}
  {get keyFormat cKeyFormat}.
  &UNDEFINE xp-assign

  &SCOPED-DEFINE xpDataValue
  {get DataValue cDataValue}.
  &UNDEFINE xpDataValue
  cDataValue = TRIM(cDataValue).
  
  /* Check if a BLANK VALUE is valid for our COMBO */
  IF CAN-QUERY(hCombo,"LIST-ITEM-PAIRS":U) AND
     cDataValue = "":U AND 
     (LOOKUP(cDataValue,hCombo:LIST-ITEM-PAIRS,hCombo:DELIMITER) > 0 OR
      LOOKUP("!":U,hCombo:LIST-ITEM-PAIRS,hCombo:DELIMITER) > 0) THEN
    cDataValue = "!":U.

  IF cDataValue = "":U AND 
     cDataValue <> cDefaultValue THEN
    ASSIGN cDataValue    = cDefaultValue
           cOldDataValue = cDataValue.
  

  CASE cKeyDataType:
    WHEN "DECIMAL":U THEN
      cDataValue = TRIM(STRING(DECIMAL(cDataValue),cKeyFormat)) NO-ERROR.
    WHEN "INTEGER":U THEN
      cDataValue = TRIM(STRING(INTEGER(cDataValue),cKeyFormat)) NO-ERROR.
  END CASE.
  /* Check for invalid values in an Integer or Decimal field */
  IF ERROR-STATUS:ERROR AND
     ERROR-STATUS:GET-NUMBER(1) = 76 AND 
     cDataValue = cDefaultValue THEN DO:
    ASSIGN cDataValue = "0":U.
    /* Set the DefaultValue 'FlagValue' to 0 (zero) */
    {set FlagValue '0'}.
  END.
  
  /* Check if the value was a BLANK value */
  IF cDataValue = "!":U THEN
    cDataValue = "":U.
  
  RETURN cDataValue.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDescSubstitute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDescSubstitute Procedure 
FUNCTION getDescSubstitute RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get DescSubstitute cValue}.
  RETURN cValue.

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

&IF DEFINED(EXCLUDE-getFieldHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldHandle Procedure 
FUNCTION getFieldHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Override to return the ComboHandle  
    Notes: The different sibling classes, like lookup and select have all been 
           implemented with different names. This function is expected to 
           replace those in order to achieve polymorphism. 
         - Currently used by clearField.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField AS HANDLE     NO-UNDO.
  {get ComboHandle hField}.

  RETURN hField.   

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

&IF DEFINED(EXCLUDE-getFlagValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFlagValue Procedure 
FUNCTION getFlagValue RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Get's the Option Flag Key Values for <All> and <None>
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get FlagValue cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInnerLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInnerLines Procedure 
FUNCTION getInnerLines RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Get's the Option Flag Key Values for <All> and <None>
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iInnerLines AS INTEGER NO-UNDO.
  {get InnerLines iInnerLines}.
  RETURN iInnerLines.

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

&IF DEFINED(EXCLUDE-getLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLabel Procedure 
FUNCTION getLabel RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Get the Label to use when creating the widget.     
    Notes: The underlying Label property implemented in the Smart class is 
           currently not used, but is expected to replace the redundant 
           FieldLabel in a future releasa. 
 -----------------------------------------------------------------------------*/
  DEFINE VARIABLE cLabel AS CHARACTER  NO-UNDO.
  {get FieldLabel cLabel}.

  RETURN cLabel.

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

&IF DEFINED(EXCLUDE-getListItemPairs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getListItemPairs Procedure 
FUNCTION getListItemPairs RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get ListItemPairs cValue}.
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

&IF DEFINED(EXCLUDE-getPhysicalTableNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPhysicalTableNames Procedure 
FUNCTION getPhysicalTableNames RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get PhysicalTableNames cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderJoinCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryBuilderJoinCode Procedure 
FUNCTION getQueryBuilderJoinCode RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get QueryBuilderJoinCode cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderOptionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryBuilderOptionList Procedure 
FUNCTION getQueryBuilderOptionList RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get QueryBuilderOptionList cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderOrderList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryBuilderOrderList Procedure 
FUNCTION getQueryBuilderOrderList RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get QueryBuilderOrderList cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderTableOptionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryBuilderTableOptionList Procedure 
FUNCTION getQueryBuilderTableOptionList RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get QueryBuilderTableOptionList cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderTuneOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryBuilderTuneOptions Procedure 
FUNCTION getQueryBuilderTuneOptions RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get QueryBuilderTuneOptions cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryBuilderWhereClauses) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryBuilderWhereClauses Procedure 
FUNCTION getQueryBuilderWhereClauses RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get QueryBuilderWhereClauses cValue}.
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

&IF DEFINED(EXCLUDE-getRefreshList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRefreshList Procedure 
FUNCTION getRefreshList RETURNS CHARACTER
  ( INPUT pcParentCombo AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will return the names of the Dynamic Combos to be 
            refreshed for a parent combo as the input parameter.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cReturnList AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bDCombo FOR ttDCombo.

  cReturnList = "":U.
  FOR EACH  bDCombo
      WHERE bDCombo.cWidgetName <> pcParentCombo
      AND   LOOKUP(pcParentCombo,bDCombo.cParentField) > 0
      NO-LOCK:
    cReturnList = cReturnList + IF cReturnList = "":U THEN bDCombo.cWidgetName ELSE ",":U + bDCombo.cWidgetName.
  END.

  RETURN cReturnList.
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

&IF DEFINED(EXCLUDE-getSecured) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSecured Procedure 
FUNCTION getSecured RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns TRUE if the combo's security is set to HIDDEN
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE plFieldIsSecured  AS LOGICAL    NO-UNDO.
  
  {get Secured plFieldIsSecured}.
  
  RETURN plFieldIsSecured.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTempTables Procedure 
FUNCTION getTempTables RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get TempTables cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUseCache Procedure 
FUNCTION getUseCache RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lValue AS LOGICAL NO-UNDO.
  {get UseCache lValue}.
  RETURN lValue.

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
   Notes:  This was taken from query.p but changed for combos to work without an
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
  
  ASSIGN pcQueryString = REPLACE(pcQueryString,CHR(10)," ":U)
         pcQueryString = REPLACE(pcQueryString,CHR(12)," ":U)
         pcQueryString = REPLACE(pcQueryString,CHR(13)," ":U).

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
          cValue     = IF cValue = ? /*This could happen if only one value*/
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

&IF DEFINED(EXCLUDE-returnTableIOType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION returnTableIOType Procedure 
FUNCTION returnTableIOType RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hViewerHandle   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTableIOSource  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTableIOSource  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableIOType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cuibMode        AS CHARACTER  NO-UNDO.

  {get uibMODE cUIBmode}.

  IF cuibMode BEGINS "DESIGN":U THEN 
    RETURN "":U. 

  {get ContainerSource hViewerHandle}.
  
  IF VALID-HANDLE(hViewerHandle) THEN
    {get TableIOSource cTableIOSource hViewerHandle}.
  
  hTableIOSource = WIDGET-HANDLE(ENTRY(1,cTableIOSource)).

  IF VALID-HANDLE(hTableIOSource) THEN
    cTableIOType = DYNAMIC-FUNCTION("getTableIOType":U IN hTableIOSource).

  RETURN cTableIOType.   /* Function return value. */

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

&IF DEFINED(EXCLUDE-setBuildSequence) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBuildSequence Procedure 
FUNCTION setBuildSequence RETURNS LOGICAL
  ( piSequence AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  IF piSequence = ? THEN ASSIGN piSequence = 0. /* avoid nulls */
  
  &SCOPED-DEFINE xpBuildSequence
  {set BuildSequence piSequence}.
  &UNDEFINE xpBuildSequence
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setComboDelimiter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setComboDelimiter Procedure 
FUNCTION setComboDelimiter RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set ComboDelimiter pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setComboFlag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setComboFlag Procedure 
FUNCTION setComboFlag RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set ComboFlag pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setComboHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setComboHandle Procedure 
FUNCTION setComboHandle RETURNS LOGICAL
  ( phValue AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set ComboHandle phValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentDescValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentDescValue Procedure 
FUNCTION setCurrentDescValue RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set DisplayValue pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentKeyValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentKeyValue Procedure 
FUNCTION setCurrentKeyValue RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set DataValue pcValue}.
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
  DEFINE VARIABLE hCombo            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cKeyField         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisplayedField   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRealContainer    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iEntry            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lFieldIsSecured   AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE lDisplayField     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cNewRecord        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScreenValue      AS CHARACTER  NO-UNDO.

  {get DisplayField lDisplayField}.

  pcValue = DYNAMIC-FUNCTION("formattedValue":U IN TARGET-PROCEDURE,pcValue) NO-ERROR.

  /*  pcValue = TRIM(pcValue).*/
  /* Check if the Combo has been populated */
  IF NOT CAN-FIND(FIRST ttDCombo
                  WHERE ttDCombo.hWidget = TARGET-PROCEDURE) THEN DO:
    /* If the combo has not been populated then we must only
       update the ADMProps field */
    &SCOPED-DEFINE xpDataValue
    {set DataValue pcValue}.
    &UNDEFINE xpDataValue
    RETURN TRUE.
  END.

  /* Test for BLANK VALUE '!' */
  IF pcValue = '!' THEN
    pcValue = "".

  &SCOPED-DEFINE xp-assign
  {get containerSource hContainer}
  {get Secured lFieldIsSecured}.
  &UNDEFINE xp-assign
  
  cNewRecord = "":U.
  IF VALID-HANDLE(hContainer) THEN
    {get NewRecord cNewRecord hContainer}. 
  IF cNewRecord = "no":U THEN
  DO:
    &SCOPED-DEFINE xpDataValue
    {set DataValue pcValue}.
    &UNDEFINE xpDataValue
    {get ComboHandle hCombo}.
    IF VALID-HANDLE(hCombo) AND 
       CAN-QUERY(hCombo,"LIST-ITEM-PAIRS":U) THEN
    DO:
      &SCOPED-DEFINE xp-assign
      {get KeyField cKeyField}
      {get DisplayedField cDisplayedField}.
      &UNDEFINE xp-assign
      IF cKeyField = cDisplayedField THEN DO:
        ASSIGN hCombo:SCREEN-VALUE = IF NOT lFieldIsSecured AND lDisplayField THEN pcValue ELSE hCombo:LIST-ITEM-PAIRS NO-ERROR.
        ERROR-STATUS:ERROR = FALSE.
      END.
      ELSE DO:
        FIND FIRST ttDCombo
             WHERE ttDCombo.hWidget = TARGET-PROCEDURE
             NO-ERROR.
        IF AVAILABLE ttDCombo THEN DO:
          /*pcValue = TRIM(pcValue).*/
          iEntry = LOOKUP(pcValue,ttDCombo.cKeyValues,ttDCombo.cListItemDelimiter)
                   NO-ERROR.
          IF iEntry > 0 AND NOT lFieldIsSecured AND lDisplayField THEN
            hCombo:SCREEN-VALUE = hCombo:ENTRY(iEntry) NO-ERROR.

          /* If all else fails - reposition to first entry */
          IF (iEntry <= 0 OR
              ERROR-STATUS:ERROR OR 
              hCombo:SCREEN-VALUE = ?) AND 
             hCombo:LIST-ITEM-PAIRS <> ? AND 
             lFieldIsSecured = FALSE AND 
             lDisplayField = TRUE THEN
               {fnarg clearCombo hCombo}.
          END.
          /* Check for a BLANK combo entry if pcValue is BLANK */
          IF iEntry <> 0 AND pcValue = "":U THEN DO:
            hCombo:LIST-ITEM-PAIRS = REPLACE(hCombo:LIST-ITEM-PAIRS,(hCombo:DELIMITER + hCombo:DELIMITER),(hCombo:DELIMITER + "!":U + hCombo:DELIMITER)).
            /* Now assign the combo to the <BLANKVALUE> '!' */
            hCombo:SCREEN-VALUE = "!" NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
              {fnarg clearCombo hCombo}.
          END.
      END.
      
      &SCOPED-DEFINE xpDataValue
      {set DataValue pcValue}.
      &UNDEFINE xpDataValue
      cScreenValue = ENTRY((hCombo:LOOKUP(hCombo:SCREEN-VALUE) * 2) - 1,hCombo:LIST-ITEM-PAIRS,hCombo:DELIMITER).
      {set DisplayValue cScreenValue}. /* avoid leave trigger code */
    END.
  END.
  ELSE
  DO: /* in an add - ensure combo screen value is cleared */
      DEFINE VARIABLE pcKeyValue         AS CHARACTER  NO-UNDO.
      DEFINE VARIABLE cListItems         AS CHARACTER  NO-UNDO.
      &SCOPED-DEFINE xpDataValue
      {get DataValue pcKeyValue}.
      &UNDEFINE xpDataValue
      {get ComboHandle hCombo}.
      
      IF cNewRecord <> "no":U AND
         pcValue <> "":U AND pcValue <> "0":U THEN
      DO: /* must be a reset operation or after a succesful save - reset value */
        &SCOPED-DEFINE xpDataValue
        {set DataValue pcValue}.
        &UNDEFINE xpDataValue
        IF VALID-HANDLE(hCombo) AND 
           CAN-QUERY(hCombo,"LIST-ITEM-PAIRS":U) THEN
        DO:
          &SCOPED-DEFINE xp-assign
          {get KeyField cKeyField}
          {get DisplayedField cDisplayedField}.
          &UNDEFINE xp-assign
          IF cKeyField = cDisplayedField THEN  DO:
            hCombo:SCREEN-VALUE = IF NOT lFieldIsSecured AND lDisplayField THEN pcValue ELSE hCombo:LIST-ITEM-PAIRS NO-ERROR.
            ERROR-STATUS:ERROR = FALSE.
          END.
          ELSE DO:
            FIND FIRST ttDCombo
                 WHERE ttDCombo.hWidget = TARGET-PROCEDURE
                 NO-ERROR.
            IF AVAILABLE ttDCombo THEN DO:
              /*pcValue = TRIM(pcValue).*/
              iEntry = LOOKUP(pcValue,ttDCombo.cKeyValues,ttDCombo.cListItemDelimiter)
                       NO-ERROR.

              IF iEntry > 0 AND NOT lFieldIsSecured AND lDisplayField THEN
              hCombo:SCREEN-VALUE = hCombo:ENTRY(iEntry) NO-ERROR.
              /**
              /* If all else fails - reposition to first entry */
              IF (iEntry <= 0 OR
                  ERROR-STATUS:ERROR OR 
                  hCombo:SCREEN-VALUE = ?) AND 
                 hCombo:LIST-ITEM-PAIRS <> ? AND 
                 lFieldIsSecured = FALSE THEN
                hCombo:SCREEN-VALUE = hCombo:ENTRY(1).
              **/
            END.
          END.
          &SCOPED-DEFINE xpDataValue
          {set DataValue pcValue}.
          &UNDEFINE xpDataValue
          cScreenValue = ENTRY((hCombo:LOOKUP(hCombo:SCREEN-VALUE) * 2) - 1,hCombo:LIST-ITEM-PAIRS,hCombo:DELIMITER).
          {set DisplayValue cScreenValue}. /* avoid leave trigger code */
        END.
      END.

      /* clear values on add - once */
      IF (pcValue = "":U OR pcValue = "0":U) AND pcKeyValue <> "":U AND pcKeyValue <> "0":U THEN
      DO:
        ASSIGN pcValue = "":U.
        &SCOPED-DEFINE xpDataValue
        {set DataValue pcValue}.
        &UNDEFINE xpDataValue
        IF VALID-HANDLE(hCombo) AND 
           CAN-QUERY(hCombo,"LIST-ITEM-PAIRS":U) THEN
        DO:
          ASSIGN cListItems             = hCombo:LIST-ITEM-PAIRS
                 hCombo:LIST-ITEM-PAIRS = ",":U
                 hCombo:SCREEN-VALUE    = IF NOT lFieldIsSecured AND lDisplayField THEN pcValue ELSE hCombo:LIST-ITEM-PAIRS
                 hCombo:LIST-ITEM-PAIRS = cListItems
                 NO-ERROR.
          ERROR-STATUS:ERROR = FALSE.
          cScreenValue = ENTRY((hCombo:LOOKUP(hCombo:SCREEN-VALUE) * 2) - 1,hCombo:LIST-ITEM-PAIRS,hCombo:DELIMITER).
          {set DisplayValue cScreenValue}. /* avoid leave trigger code */
        END.
      END.
  END.

  {set Modify TRUE}.      
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDescSubstitute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDescSubstitute Procedure 
FUNCTION setDescSubstitute RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set DescSubstitute pcValue}.
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

&IF DEFINED(EXCLUDE-setFlagValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFlagValue Procedure 
FUNCTION setFlagValue RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Set's the Option Flag Key Values for <All> and <None>
Parameters:     
    Notes: The need to make the value of <All> and <None> something different 
           than the normal ? . or BLANK. This value will be assigned to the 
           key field when one of these options are chosen.
------------------------------------------------------------------------------*/
  {set FlagValue pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInnerLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setInnerLines Procedure 
FUNCTION setInnerLines RETURNS LOGICAL
  ( piInnerLines AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Set's the Sort propery for the Combo
    Notes:  
------------------------------------------------------------------------------*/
  {set InnerLines piInnerLines}.
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

&IF DEFINED(EXCLUDE-setLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLabel Procedure 
FUNCTION setLabel RETURNS LOGICAL
  ( pcLabel AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Set the Label  
Parameter: pcLabel - The label to use when creating the widget.     
    Notes: The underlying Label property implemented in the Smart class is 
           currently not used, but is expected to replace the redundant 
           FieldLabel in a future releasa. 
 -----------------------------------------------------------------------------*/
  {set FieldLabel pcLabel}.

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

&IF DEFINED(EXCLUDE-setListItemPairs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setListItemPairs Procedure 
FUNCTION setListItemPairs RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set ListItemPairs pcValue}.
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
  Purpose: Sets the Parent field name of this combo's parent dependant object
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

&IF DEFINED(EXCLUDE-setPhysicalTableNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPhysicalTableNames Procedure 
FUNCTION setPhysicalTableNames RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the actual DB Tables names of buffers defined for the query
Parameters:     
    Notes:   
------------------------------------------------------------------------------*/
  {set PhysicalTableNames pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderJoinCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryBuilderJoinCode Procedure 
FUNCTION setQueryBuilderJoinCode RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  {set QueryBuilderJoinCode pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderOptionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryBuilderOptionList Procedure 
FUNCTION setQueryBuilderOptionList RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set QueryBuilderOptionList pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderOrderList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryBuilderOrderList Procedure 
FUNCTION setQueryBuilderOrderList RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set QueryBuilderOrderList pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderTableOptionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryBuilderTableOptionList Procedure 
FUNCTION setQueryBuilderTableOptionList RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set QueryBuilderTableOptionList pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderTuneOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryBuilderTuneOptions Procedure 
FUNCTION setQueryBuilderTuneOptions RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set QueryBuilderTuneOptions pcValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryBuilderWhereClauses) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryBuilderWhereClauses Procedure 
FUNCTION setQueryBuilderWhereClauses RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set QueryBuilderWhereClauses pcValue}.
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

&IF DEFINED(EXCLUDE-setSecured) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSecured Procedure 
FUNCTION setSecured RETURNS LOGICAL
  ( INPUT plFieldIsSecured AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Indicates whether a field has the HIDDEN security option set
    Notes:  
------------------------------------------------------------------------------*/
  {set Secured plFieldIsSecured}.
  
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
  {set TempTables pcValue}.
  RETURN TRUE.

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
  {set USeCache plValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

