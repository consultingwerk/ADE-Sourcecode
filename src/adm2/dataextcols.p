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
    File        : dataextcols.p
    Purpose     : Support procedure for data class.  This is an extension
                  of data.p.  The extension is necessary to avoid an overflow
                  of the action segment. The split in data.p and dataext.p  
                  was not sufficient on AS400. This extension file contains
                  all column related functions (assignColumn* and column*). 
                  These functions will be rolled back into data.p when segment 
                  size increases.
                  
    Syntax      : adm2/dataextcols.p

    Modified    : Jan 30, 2001 Version 9.1C
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell dataattr.i that this is the Super procedure. */
   &SCOP ADMSuper data.p
   
  {src/adm2/custom/dataexclcustom.i}

  DEFINE VARIABLE ghRowObject AS HANDLE    NO-UNDO. /* Handle of current TT rec.*/

/* This AddStartRow number, is used as a global sequence for new records, 
   This may very well change in a future release. */
&SCOP  xiAddStartRow 9000000 /* high # for new rows*/
  DEFINE VARIABLE giAddRowNum  AS INTEGER NO-UNDO 
    INIT {&xiAddStartRow}. /* tmp row num for add */

  /* Include the file which defines AppServerConnect procedures. */
  {adecomm/appserv.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-assignColumnColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnColumnLabel Procedure 
FUNCTION assignColumnColumnLabel RETURNS LOGICAL
  ( pcColumn AS CHARACTER, 
    pcLabel  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnFormat Procedure 
FUNCTION assignColumnFormat RETURNS LOGICAL
  ( pcColumn AS CHARACTER, 
    pcFormat AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnHelp Procedure 
FUNCTION assignColumnHelp RETURNS LOGICAL
  ( pcColumn AS CHARACTER, 
    pcHelp   AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnLabel Procedure 
FUNCTION assignColumnLabel RETURNS LOGICAL
  ( pcColumn AS CHARACTER, 
    pcLabel  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnPrivateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnPrivateData Procedure 
FUNCTION assignColumnPrivateData RETURNS LOGICAL
  ( pcColumn AS CHARACTER, 
    pcData AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnValExp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnValExp Procedure 
FUNCTION assignColumnValExp RETURNS LOGICAL
  ( pcColumn AS CHARACTER, 
    pcValExp AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnValMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnValMsg Procedure 
FUNCTION assignColumnValMsg RETURNS LOGICAL
  ( pcColumn AS CHARACTER, pcValMsg AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnColumnLabel Procedure 
FUNCTION columnColumnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnExtent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnExtent Procedure 
FUNCTION columnExtent RETURNS INTEGER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnFormat Procedure 
FUNCTION columnFormat RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnHandle Procedure 
FUNCTION columnHandle RETURNS HANDLE
  ( pcColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnHelp Procedure 
FUNCTION columnHelp RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnInitial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnInitial Procedure 
FUNCTION columnInitial RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnLabel Procedure 
FUNCTION columnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnModified Procedure 
FUNCTION columnModified RETURNS LOGICAL
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnPrivateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnPrivateData Procedure 
FUNCTION columnPrivateData RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnQuerySelection Procedure 
FUNCTION columnQuerySelection RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnReadOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnReadOnly Procedure 
FUNCTION columnReadOnly RETURNS LOGICAL
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnStringValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnStringValue Procedure 
FUNCTION columnStringValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnTable Procedure 
FUNCTION columnTable RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValExp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnValExp Procedure 
FUNCTION columnValExp RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnValMsg Procedure 
FUNCTION columnValMsg RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnValue Procedure 
FUNCTION columnValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnWidth Procedure 
FUNCTION columnWidth RETURNS DECIMAL
  ( pcColumn AS CHARACTER )  FORWARD.

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
         HEIGHT             = 13.91
         WIDTH              = 53.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/dataprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-assignColumnColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnColumnLabel Procedure 
FUNCTION assignColumnColumnLabel RETURNS LOGICAL
  ( pcColumn AS CHARACTER, 
    pcLabel  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Progress Column Label text of a specified column.

  Parameters: 
    INPUT pcColumn - Unqualified column name of the RowObject field.
                   - Column name qualified with "RowObject".  
                   - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
    INPUT pcLabel  - The new Column Label text
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  IF hCol NE ? THEN hCol:COLUMN-LABEL = pcLabel.
  
  RETURN IF hCol = ? THEN FALSE ELSE TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnFormat Procedure 
FUNCTION assignColumnFormat RETURNS LOGICAL
  ( pcColumn AS CHARACTER, 
    pcFormat AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Progress Format text of a specified column.
  Parameters:  
    INPUT pcColumn  - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
    INPUT pcFormat - The new format string
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  IF hCol NE ? THEN hCol:FORMAT = pcFormat.
  
  RETURN IF hCol = ? THEN FALSE ELSE TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnHelp Procedure 
FUNCTION assignColumnHelp RETURNS LOGICAL
  ( pcColumn AS CHARACTER, 
    pcHelp   AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Progress Help text of a specified column.

  Parameters:  
    INPUT pcColumn  - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
    INPUT pcHelp   - The new help text
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  IF hCol NE ? THEN hCol:HELP = pcHelp.
  RETURN IF hCol = ? THEN FALSE ELSE TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnLabel Procedure 
FUNCTION assignColumnLabel RETURNS LOGICAL
  ( pcColumn AS CHARACTER, 
    pcLabel  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Progress Label text of a specified column.

  Parameters:  
    INPUT pcColumn  - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
     INPUT pcLabel  - The new Label text
 -----------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  IF hCol NE ? THEN hCol:LABEL = pcLabel.
  RETURN IF hCol = ? THEN FALSE ELSE TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnPrivateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnPrivateData Procedure 
FUNCTION assignColumnPrivateData RETURNS LOGICAL
  ( pcColumn AS CHARACTER, 
    pcData AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Progress Private-data attribute of a specified column.

  Parameters:  
    INPUT pcColumn  - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
    INPUT pcData   - The new Private-data string
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  IF hCol NE ? THEN hCol:PRIVATE-DATA = pcData.
  RETURN IF hCol = ? THEN FALSE ELSE TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnValExp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnValExp Procedure 
FUNCTION assignColumnValExp RETURNS LOGICAL
  ( pcColumn AS CHARACTER, 
    pcValExp AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Progress Validation Expression of a specified column.
  Parameters:  
    INPUT pcColumn  - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
  
    INPUT pcValExp - The new Validation Expression.
    
  Notes:       This will not actually change the column's validation which
               gets irrevocably set at compile time.  However, it can be 
               retrieved by an object and then used to generate validation 
               code for the column.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  IF hCol = ? THEN RETURN FALSE.
  ELSE DO:
    hCol:VALIDATE-EXPRESSION = pcValExp. 
    RETURN TRUE.
  END.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnValMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnValMsg Procedure 
FUNCTION assignColumnValMsg RETURNS LOGICAL
  ( pcColumn AS CHARACTER, pcValMsg AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Progress Validation Message text of a specified column.

  Parameters:  
   INPUT pcColumn  - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
    INPUT pcValMsg - The new Validation Message text.
    
  Notes:       This will not actually change the column's message which
               gets irrevocably set at compile time.  However, it can be 
               retrieved by an object and then used to generate a
               message on some sort of dynamic validation.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  IF hCol = ? THEN 
    RETURN FALSE.
  ELSE DO:
    hCol:VALIDATE-MESSAGE = pcValMsg. 
    RETURN TRUE.
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnColumnLabel Procedure 
FUNCTION columnColumnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the Progress Column Label of a specified column.
  Parameters: INPUT pcColumn 
                    - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
   
  IF NOT VALID-HANDLE(hCol) THEN
    RETURN ?.

  RETURN IF hCol:COLUMN-LABEL = ? 
         THEN {fnarg columnLabel pcColumn}
         ELSE hCol:COLUMN-LABEL.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the Progress datatype of a specified column.
  
  Parameters:
    INPUT pcColumn - a column name, either a RowObject fieldname or a
                     qualified DB fieldname of a table in the DB query.
  
  Note:        columnDataType recognizes that pcColumn is a qualified DB
               fieldname based on the presence of a period (".").
               If pcColumn is a qualified DB fieldname and columnDataType is
               called on the client side of the SmartDataObject, an attempt is 
               made to resolve this on the client. First by using the mapped 
               SmartDataObject name in a recursive call to columnDataType.  If
               this fails, and there is a ForeignFields property, the 
               corresponding data source field is queried via this function.
               
      !!!      As a last resort columnDataType is called on the Server side.
               This is done in order to support queries with fields that are
               not mapped to the SDO.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol           AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject     AS HANDLE NO-UNDO.
  DEFINE VARIABLE cASDivision    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hAppServer     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataSource    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDataColumn    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataType      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cForeignFields AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOperatingMode AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cContext       AS CHARACTER NO-UNDO.
 
  IF pcColumn BEGINS 'RowObject.':U THEN
     pcColumn  = ENTRY(2,pcColumn,'.':U).
  
  /* If not Qualified check the RowObject */
  IF INDEX(pcColumn,".":U) = 0 THEN
  DO:         
    {get RowObject hRowObject}.
    hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
    RETURN IF hCol = ? THEN ? ELSE hCol:DATA-TYPE.     
  END. /* if index(pccolumn,".") = 0 ie RowObject */
  ELSE DO:  
    {get ASDivision cASDivision}.
    IF cASDivision = 'Client':U THEN
    DO:
      ASSIGN
        cDataType = ?
        /* get the mapped RowObject column */
        cDataColumn = {fnarg dbColumnDataName pcColumn}.            
      
      IF cDataColumn <> "":U THEN 
        cDataType   = {fnarg columnDataType cDataColumn}. 
            
      /* The database field was not defined in the sdo so we will try to get the
         datatype from other sources */            
      IF cDataType = ? THEN
      DO:                      
        {get ASHandle hAppServer}.                  
        cDataType = {fnarg columnDataType pcColumn hAppServer}.
        /* unbind if this call did the bind (getASHandle) */
        RUN unbindServer IN TARGET-PROCEDURE (?).  
      END.  /* END DO cDatatype = ? */
      RETURN cDataType.       
    END. /* END DO client */
    ELSE 
      RETURN SUPER(pcColumn). 
  END. /* qualified column */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnExtent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnExtent Procedure 
FUNCTION columnExtent RETURNS INTEGER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the Progress extent of a specified column.
  Parameters: INPUT pcColumn 
                    - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  RETURN IF hCol = ? THEN ? ELSE hCol:EXTENT.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnFormat Procedure 
FUNCTION columnFormat RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the Progress format of a specified column.  
  Parameters: INPUT pcColumn 
                    - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  RETURN IF hCol = ? THEN ? ELSE hCol:FORMAT.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnHandle Procedure 
FUNCTION columnHandle RETURNS HANDLE
  ( pcColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the handle of a RowObject column.  
  Parameters: INPUT pcColumn 
               - Unqualified column name of the RowObject field.
               - Column name qualified with "RowObject".   
               - qualified database field name. 
                 (This requires that the field is mapped to the SDO).  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hRowObject AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hColumn    AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cColumn    AS CHARACTER  NO-UNDO.

 {get RowObject hRowObject}.

 IF NUM-ENTRIES(pcColumn,".":U) > 1 THEN
 DO:
   IF pcColumn BEGINS 'RowObject.':U THEN
     pcColumn  = ENTRY(2,pcColumn,'.':U).
   ELSE 
     pcColumn = {fnarg dbColumnDataName pcColumn}.
 END.
 
 hColumn = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.

 RETURN hColumn.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnHelp Procedure 
FUNCTION columnHelp RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the Progress help text for a specified column.  
  Parameters: INPUT pcColumn 
                    - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  RETURN IF hCol = ? THEN ? ELSE hCol:HELP.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnInitial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnInitial Procedure 
FUNCTION columnInitial RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the initial value for a specified field as a character
               string with the field FORMAT applied.
  
  Parameters:
    INPUT pcColumn - column name of the RowObject field being queried.
  
  Notes:       Example: If the value of a numeric field is 123456789 and the
                        format is "999-99-9999", columnInitial would return
                        a character string containing "123-45-6789".
-----------------------------------------------------------------------------*/

  DEFINE VARIABLE hColumn    AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
    {get RowObject hRowObject}.
    hColumn = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
    
    IF VALID-HANDLE(hColumn) THEN
    DO:
      IF hColumn:INITIAL = ? THEN 
        RETURN "":U.
      ELSE IF hColumn:DATA-TYPE = "DATE":U AND hColumn:INITIAL = "TODAY":U THEN
        RETURN STRING(TODAY).
      ELSE 
        RETURN hColumn:INITIAL.   /* INITIAL is always CHARACTER. */
    END. /* valid-handle(hcolumn) */
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnLabel Procedure 
FUNCTION columnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the Progress Label of a specified column.
  Parameters: INPUT pcColumn 
                    - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
  Note:       If no label have been specified, then the column name is return.
              Use ColumnColumnLabel to get the COLUMN-LABEL (for browsers) 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  IF NOT VALID-HANDLE(hCol) THEN
    RETURN ?.

  RETURN IF hCol:LABEL = ? THEN hCol:NAME ELSE hCol:LABEL.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnModified Procedure 
FUNCTION columnModified RETURNS LOGICAL
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns true if a specified column has been modified in the 
               RowObject record.
  
  Parameters:  
    INPUT pcColumn - column name of the RowObject field being queried.
  
  Notes:       NOTE: The only way to do this is to see if the row has been
               modified and then compare the changed and unchanged copies; 
               there's no MODIFIED attribute on the BUFFER-FIELD.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hRowObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cValue     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowQuery  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRowNum    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lChanged   AS LOGICAL   NO-UNDO.
  
  {get RowObject hRowObject}.
  IF NOT hRowObject:AVAILABLE THEN
      RETURN ?.
  hColumn = hRowObject:BUFFER-FIELD('RowMod':U).
  IF hColumn:BUFFER-VALUE = "U":U THEN
  DO:
    /* The row has been changed; now get the unchanged copy and see if this
       *column* has been changed. This requires defining a query for that row. */
      hColumn = hRowObject:BUFFER-FIELD(pcColumn).
      cValue = hColumn:BUFFER-VALUE.  /* Save off the value from the updated row. */
      hColumn = hRowObject:BUFFER-FIELD('RowNum':U).
      cRowNum = hColumn:STRING-VALUE. /* ...also the row number of the row. */
      {get RowObjUpd hRowObject}.
      CREATE QUERY hRowQuery.
      hRowQuery:SET-BUFFERS(hRowObject).
      hRowQuery:QUERY-PREPARE('FOR EACH RowObjUpd WHERE RowObjUpd.RowNum = ':U + 
         cRowNum).
      hRowQuery:QUERY-OPEN().
      hRowQuery:GET-FIRST().
      hColumn = hRowObject:BUFFER-FIELD(pcColumn).
      lChanged = (hColumn:BUFFER-VALUE <> cValue).
      DELETE WIDGET hRowQuery.
  END. /* if hColumn:BUFFER-VALUE = "U" */
  
  RETURN lChanged.    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnPrivateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnPrivateData Procedure 
FUNCTION columnPrivateData RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
   Purpose: Returns the Progress Private-Data attribute of a specified column.
Parameters: INPUT pcColumn 
                    - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we resolved all cases 
     by a call to columnHandle, as below, but column functions are used 
     extensively and repeatedly and we don't want to let the normal call with 
     just a column name have to pay the performance overhead of an additional 
     function call, just to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 

  RETURN IF hCol = ? THEN ? ELSE hCol:PRIVATE-DATA.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnQuerySelection Procedure 
FUNCTION columnQuerySelection RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
 Purpose:      Returns a CHR(1) separated string with ALL operators and values 
               that has been added to the Query for this column using the 
               assignQuerySelection method. 
               
               Example: If the query contains 'custnum > 5 and custnum < 9' 
                        this function will return (chr(1) is shown as '|'): 
                        '>|5|<|9'    
                              
  Parameters:
   INPUT pcColumn - A column in the RowObject. 
                    - unqualifed or qualified with RowObject.                       
                    Qualified field names will be passed directly to the
                    super procedure:   
                    - TBL.FLDNM or DB.TBL.FLDNM (only if qualified with db),
 
  Notes:       This override is needed to take a rowobject column as input and 
               pass the mapped database column to the super procedure in query.p   
               The data returned reflects the QueryString/QueryColumns properties, 
               which is maintained by the assignQuerySelection. These values
               may not have been used in an openQuery yet.               
------------------------------------------------------------------------------*/
  IF pcColumn BEGINS "RowObject." THEN
    pcColumn = ENTRY(2,pcColumn,".":U).
  
  /* Find the mapped database column */
  IF INDEX(pcColumn,".":U) = 0 THEN
    pcColumn = {fnarg columnDBColumn pcColumn}.            
   
    /* Call the query version */  
  RETURN SUPER(pcColumn). 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnReadOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnReadOnly Procedure 
FUNCTION columnReadOnly RETURNS LOGICAL
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns TRUE if a specified column is READ-ONLY in the 
               SmartDataObject, that is, if it is not in the list of Updatable
               Columns.  Returns unknown if non-existing in the SDO
  Parameters:
    INPUT pcColumn - column name of the RowObject temp-table that is being
                     queried.
  
  Notes:       A visualization may use this dynamically to determine whether 
               the field should be updatable on the screen.  Even still, there
               may be circumstances where it is desirable to have it updatable
               on the screen but if it is READ-ONLY in the SmartDataObject any
               changes sent back to the SmartDataObject will not be made in
               the RowObject temp-table and, therefore, in the database.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cUpdatable   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColumns     AS CHARACTER NO-UNDO.

  IF pcColumn BEGINS "RowObject.":U THEN
    pcColumn = ENTRY(2,pcColumn,".":U).
  
  IF NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    pcColumn = {fnarg dbColumnDataName pcColumn}.
   
  {get DataColumns cColumns}.
  
  IF CAN-DO(cColumns,pcColumn) THEN
  DO:
    {get UpdatableColumns cUpdatable}.  
    RETURN NOT CAN-DO(cUpdatable,pcColumn).
  END.
  ELSE
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnStringValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnStringValue Procedure 
FUNCTION columnStringValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the STRING-VALUE of a specified column in the 
               SmartDataObject RowObject buffer.  The STRING-VALUE is the value
               of a field expressed as a character string formatted according
               to the columns FORMAT expression.
 Parameters: INPUT pcColumn 
                    - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  
  IF NOT hRowObject:AVAILABLE THEN
    RETURN ?.
  
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  RETURN IF hCol = ? THEN ? ELSE hCol:STRING-VALUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnTable Procedure 
FUNCTION columnTable RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*-----------------------------------------------------------------------------
  Purpose:     Returns the database table name of the column mapped to a
               SmartDataObjects RowObject column or the correct .               
  Parameters: INPUT pcColumn 
              - column name of the RowObject field being queried or a 
                qualified database column.                   
      Notes: The table is returned according to the queries db qualification.
             Returns unknown if ambiguous, blank if not found.    
          -  The columnTable is called on the server as last resort in order 
             to support queries on unmapped fields.             
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTable     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBColumn  AS CHARACTER  NO-UNDO.

  IF pcColumn BEGINS "RowObject.":U THEN
    pcColumn = ENTRY(2,pccolumn,".":U).

  IF NUM-ENTRIES(pcColumn,".":U) = 1 THEN
  DO:
    cDbColumn = {fnarg columnDbColumn pcColumn}.
    
    IF cDbColumn <> "":U THEN 
    DO:
      /* Remove the field part */  
      ENTRY(NUM-ENTRIES(cDbColumn,".":U),cDbColumn,".":U) = "":U.
      RETURN RIGHT-TRIM(cDbColumn,".":U). 
    END. /* if cDbColumn  <> '' */
    ELSE 
      RETURN "":U.    
  END. /* unqualified pcColumn */ 
  ELSE DO:

    /* Find the table part of pcColumn. */  
    ASSIGN
      cTable = pcColumn
      ENTRY(NUM-ENTRIES(cTable,".":U),cTable,".":U) = "":U
      cTable = RIGHT-TRIM(cTable,".":U). 

    cTable = {fnarg resolveBuffer cTable}.
    
    /* if not blank, we have a resolution, a table name or ? (ambiguous) */  
    IF cTable <> '':U THEN
      RETURN cTable.

  END. /* else do (ie: qualified references)  */
  
  /* Query methods support querying fields that are not mapped to the 
     SDO, so the final check is done against the actual database table. 
     This may require a call to the server.  */
  {src/adm2/cltorsvr.i columnTable Char pcColumn}

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValExp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnValExp Procedure 
FUNCTION columnValExp RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:   Returns the Progress Validation expression for a specified column
 Parameters: INPUT pcColumn 
                    - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  RETURN IF hCol = ? THEN ? ELSE hCol:VALIDATE-EXPRESSION.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnValMsg Procedure 
FUNCTION columnValMsg RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the Progress Validation message for a specified column
               of the SmartDataObjects RowObject temp-table.
 Parameters: INPUT pcColumn 
                    - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  RETURN IF hCol = ? THEN ? ELSE hCol:VALIDATE-MESSAGE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnValue Procedure 
FUNCTION columnValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:   Returns the UNFORMATTED character value of a specified column 
             in the SmartDataObject RowObject buffer.  
 Parameters: INPUT pcColumn 
                    - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
     Note:     This is different from columnStringValue which returns the 
               formatted value.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  
  IF NOT hRowObject:AVAILABLE THEN
    RETURN ?.

  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  RETURN IF hCol = ? THEN ? ELSE STRING(hCol:BUFFER-VALUE).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnWidth Procedure 
FUNCTION columnWidth RETURNS DECIMAL
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the width (in character units) of a specified column in
               the SmartDataObjects RowObject temp-table.
  
 Parameters: INPUT pcColumn 
                    - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
  
  Notes:       The width is setable inside of the column editor when editing
               the fields of the SmartDataObject.  However, its default is
               based on the numbers of characters needed to satisfy the
               FORMAT expression assigned to the field.
               The width may be used as a reference by the visualization, but
               the visualization doesn't necessarily use the same width.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  RETURN IF hCol = ? THEN ? ELSE hCol:WIDTH-CHARS.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

