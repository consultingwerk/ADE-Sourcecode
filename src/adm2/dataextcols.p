&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : dataextcols.p
    Purpose     : Support procedure for data class.  This is an extension
                  of data.p.  The extension is necessary to avoid an overflow
                  of the action segment. This extension file contains
                  all column related functions (assignColumn* and column*)
                  as well as the col*values* functions
                  
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

&IF DEFINED(EXCLUDE-assignColumnInitial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnInitial Procedure 
FUNCTION assignColumnInitial RETURNS LOGICAL
  ( pcColumn AS CHARACTER, 
    pcInitial AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-colStringValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD colStringValues Procedure 
FUNCTION colStringValues RETURNS CHARACTER
  ( pcColumnList   AS CHARACTER,
    pcFormatOption AS CHARACTER,
    pcDelimiter    AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-colStringValuesAnyRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD colStringValuesAnyRow Procedure 
FUNCTION colStringValuesAnyRow RETURNS CHARACTER
  ( phRowObject    AS HANDLE,
    pcColumnList   AS CHARACTER,
    pcFormatOption AS CHARACTER,
    pcDelimiter    AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-columnDBName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnDBName Procedure 
FUNCTION columnDBName RETURNS CHARACTER
  ( pcColumn AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDefaultValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnDefaultValue Procedure 
FUNCTION columnDefaultValue RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-columnLongCharValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnLongCharValue Procedure 
FUNCTION columnLongCharValue RETURNS LONGCHAR
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

&IF DEFINED(EXCLUDE-columnName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnName Procedure 
FUNCTION columnName RETURNS CHARACTER
  ( phHandle AS HANDLE)  FORWARD.

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

&IF DEFINED(EXCLUDE-colValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD colValues Procedure 
FUNCTION colValues RETURNS CHARACTER
  ( pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyLargeColumnToFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD copyLargeColumnToFile Procedure 
FUNCTION copyLargeColumnToFile RETURNS LOGICAL
  ( pcColumn   AS CHAR,
    pcFileName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyLargeColumnToMemptr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD copyLargeColumnToMemptr Procedure 
FUNCTION copyLargeColumnToMemptr RETURNS LOGICAL
  ( pcColumn AS CHAR,
    pmMemptr AS MEMPTR)  FORWARD.

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


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-copyColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyColumns Procedure 
PROCEDURE copyColumns :
/*------------------------------------------------------------------------------
  Purpose:     Called from copyRow to move column values to the new row.  
  Parameters:
    INPUT pcViewColList - Comma delimited list of column names
                          NOT-IN-USE. The copy is a complete record copy.                           
    INPUT phDataQuery   - Handle to the RowObject query....  
    
  Notes:  copyColumns exists for historical reasons only. 
          (Reduced size of the r-code action segment) 
        -  moved here to dataextcols to reduce ecode action segment in 2.1 
           where this was big.
           (very small here in 10, so done just to keep versions similar...)
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcViewColList   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER phDataQuery     AS HANDLE    NO-UNDO.
  
  DEFINE VARIABLE hRowObject   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFromBuffer  AS HANDLE     NO-UNDO.

  hRowObject = phDataQuery:GET-BUFFER-HANDLE(1).

  IF hRowObject:AVAILABLE THEN
  DO:
    CREATE BUFFER hFrombuffer FOR TABLE hRowObject.
  
    hFromBuffer:FIND-FIRST('WHERE ROWID(':U + hFromBuffer:NAME + ')'  
                          + ' = TO-ROWID("':U + STRING(hRowObject:ROWID) + '")':U)
                NO-ERROR.
  END.

  hRowObject:BUFFER-CREATE().
    
  IF VALID-HANDLE(hFromBuffer) THEN 
  DO:
    /* don't copy systemfields */
    IF hFromBuffer:AVAILABLE THEN 
      hRowObject:BUFFER-COPY(hFrombuffer,"RowNum,RowIdent,RowMod,RowIdentIdx,RowUserProp":u).
  
    DELETE OBJECT hFromBuffer . 
  END.

  /* set RowNum, RowIdent and navigation Properties etc*/  
  {fnarg newRowObject 'Copy':U}.
 
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

&IF DEFINED(EXCLUDE-assignColumnInitial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnInitial Procedure 
FUNCTION assignColumnInitial RETURNS LOGICAL
  ( pcColumn AS CHARACTER, 
    pcInitial AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Progress Format text of a specified column.
  Parameters:  
    INPUT pcColumn  - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
    INPUT pcInitial - The new initial value
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
  
  IF hCol NE ? THEN hCol:INITIAL = pcInitial.
  
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

&IF DEFINED(EXCLUDE-colStringValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION colStringValues Procedure 
FUNCTION colStringValues RETURNS CHARACTER
  ( pcColumnList   AS CHARACTER,
    pcFormatOption AS CHARACTER,
    pcDelimiter    AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a delimited list of values for the requested
               columns of the current row of the RowObject.
  Parameters:
    INPUT pcColumnList   - Comma delimited list of RowObject column names
    INPUT pcFormatOption - Format of returned values
                          - Blank or ? 
                            No formatting, just buffer values 
                          - 'Formatted' 
                            Formatted according to the columnFormat with right 
                            justified numeric values.
                          - 'TrimNumeric' 
                            Formatted according to the columnFormat with LEFT 
                            justified numeric values.
                             
    INPUT pcDelimiter  - optional delimiter (default CHR(1)).   
  Notes:       This function is different from colValues in that it does NOT 
               return rowidents as the first entry and does not look in the 
               dataSource.
------------------------------------------------------------------------------*/

    RETURN DYNAMIC-FUNCTION('colStringValuesAnyRow':U IN TARGET-PROCEDURE, 
                                  ?,  /* use current RowObject */
                                  pcColumnList, 
                                  pcFormatOption,
                                  pcDelimiter) .

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-colStringValuesAnyRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION colStringValuesAnyRow Procedure 
FUNCTION colStringValuesAnyRow RETURNS CHARACTER
  ( phRowObject    AS HANDLE,
    pcColumnList   AS CHARACTER,
    pcFormatOption AS CHARACTER,
    pcDelimiter    AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a delimited list of values for the requested
               columns of the requested RowObject record. Intented for internal
               use only as the structure or implementation details of the RowObject
               Temp Table is subject to change.
  Parameters:
    INPUT phRowObject    - RowObject buffer. If ? we use current RowObject.
    INPUT pcColumnList   - Comma delimited list of RowObject column names
    INPUT pcFormatOption - Format of returned values
                          - Blank or ? 
                            No formatting, just buffer values 
                          - 'Formatted' 
                            Formatted according to the columnFormat with right 
                            justified numeric values.
                          - 'TrimNumeric' 
                            Formatted according to the columnFormat with LEFT 
                            justified numeric values.
                             
    INPUT pcDelimiter  - optional delimiter (default CHR(1)).   
  Notes:       This function is different from colValues in that it does NOT 
               return rowidents as the first entry and does not look in the 
               dataSource.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColValues  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iCol        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hColumn     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColumn     AS CHARACTER NO-UNDO.

  IF phRowObject = ? THEN
    {get RowObject phRowObject}.    /* use current RowObject record */

  IF VALID-HANDLE(phRowObject) AND phRowObject:AVAILABLE THEN 
  DO: 
    IF pcDelimiter = ? THEN
       pcDelimiter = CHR(1).

    DO iCol = 1 TO NUM-ENTRIES(pcColumnList):
      cColumn = ENTRY(iCol, pcColumnList). 
      
      IF cColumn = 'SKIP':U THEN
        cValue = '':U.
      ELSE DO:
        /* If column is formatted with the SDO name in front, strip it out */
        IF INDEX(cColumn, ".":U) > 0 THEN
          cColumn = ENTRY(2, cColumn, ".":U).
  
        hColumn = phRowObject:BUFFER-FIELD(cColumn) NO-ERROR.      
        
        IF NOT VALID-HANDLE(hColumn) THEN
          cValue = '?':U.
        ELSE DO:
          IF hColumn:DATA-TYPE = 'CLOB':U OR hColumn:DATA-TYPE = 'BLOB':U THEN
          DO:
            /* Design time error .. */
            MESSAGE SUBSTITUTE({fnarg MessageNumber 95},PROGRAM-NAME(1),
                                                   hColumn:NAME,
                                                   hColumn:DATA-TYPE)
              VIEW-AS ALERT-BOX ERROR.
            RETURN ?.
          END.

          IF cColumn = 'Rowident':U THEN
              hColumn:FORMAT = "x(" + STRING(MAXIMUM(1,LENGTH(hColumn:BUFFER-VALUE)))  + ")".
          CASE pcFormatOption:
            WHEN 'Formatted':U THEN
              cValue = RIGHT-TRIM(hColumn:STRING-VALUE,' ':U).
            WHEN 'TrimNumeric':U THEN
              cValue = IF LOOKUP(hColumn:DATA-TYPE,'Decimal,Integer':U) > 0 
                       THEN LEFT-TRIM(hColumn:STRING-VALUE,' ':U)
                       ELSE RIGHT-TRIM(hColumn:STRING-VALUE,' ':U).
            WHEN 'NoTrim':U THEN
              cValue = hColumn:STRING-VALUE.
            OTHERWISE 
              cValue = hColumn:BUFFER-VALUE.
          END CASE.
        END.       /* END ELSE DO if hColumn found locally */
      END. /* valid column name */
      cColValues = cColValues 
                 + (IF iCol > 1 
                    THEN IF pcDelimiter <> '':U 
                         THEN pcDelimiter 
                         ELSE ' ':U
                    ELSE '':U)
                 + cValue. 
    END.  /* END iCol */
    RETURN cColValues.       
  END. /* valid and avail rowObject*/
  
  RETURN ?.

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

&IF DEFINED(EXCLUDE-columnDBName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnDBName Procedure 
FUNCTION columnDBName RETURNS CHARACTER
  ( pcColumn AS CHAR ) :
/*-----------------------------------------------------------------------------
  Purpose:     Returns the database name of the column mapped to a
               SmartDataObjects RowObject column.               
  Parameters: INPUT pcColumn 
              - column name of the RowObject field being queried or a 
                qualified database column.                   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTable   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTables  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBNames AS CHARACTER  NO-UNDO.

  cTable = {fnarg columnTable pcColumn}.
  
  IF NUM-ENTRIES(cTable,'.':U) > 1 THEN
     RETURN ENTRY(1,cTable,'.':U).
  
  ELSE IF cTable > '':U THEN 
  DO:
    &SCOPED-DEFINE xp-assign
    {get Tables cTables}
    {get DBNames cDBNames}.
    &UNDEFINE xp-assign
    RETURN ENTRY(LOOKUP(cTable,cTables),cDBNames). 
  END.

  RETURN ?. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDefaultValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnDefaultValue Procedure 
FUNCTION columnDefaultValue RETURNS CHARACTER
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

  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.

  {get RowObject hRowObject}.
  
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
/* The code would certainly look more elegant if we skipped the code above
   and resolved all cases by a call to columnHandle, as below, but column 
   functions are used extensively and we don't want to let the normal call 
   with just a column name have to pay the performance overhead of an 
   additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 

  IF VALID-HANDLE(hCol) THEN
  DO:
    cValue = hCol:DEFAULT-STRING.
    /* The default-string returns literals for now and today, 
       We treat this as the anticipated default-value (datatype =run-type) */  
    IF hCol:DATA-TYPE BEGINS 'DATE':U THEN
    DO:
      CASE cValue: 
        WHEN 'TODAY':U THEN
          cValue = STRING(TODAY).
        WHEN 'NOW' THEN
          cValue = STRING(NOW).
      END CASE.
    END.
    RETURN cValue.
  END.  
  
  RETURN ?.

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
 IF NOT VALID-HANDLE(hRowObject) THEN
   RETURN ?.

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
 
    IF VALID-HANDLE(hCol) THEN
      RETURN hCol:INITIAL.   
    
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

&IF DEFINED(EXCLUDE-columnLongCharValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnLongCharValue Procedure 
FUNCTION columnLongCharValue RETURNS LONGCHAR
    ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:   Returns the LONGCHAR value of a specified column in the 
             DataObject RowObject buffer.  
 Parameters: INPUT pcColumn 
                    - Unqualified column name of the RowObject field.
                    - Column name qualified with "RowObject".   
                    - qualified database field name. 
                      (This requires that the field is mapped to the SDO).  
     Note:   ? in a CLOB is returned as blank!      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE   NO-UNDO.
  DEFINE VARIABLE cLongValue AS LONGCHAR NO-UNDO.
  
  {get RowObject hRowObject}.

  IF NOT VALID-HANDLE(hRowObject) OR NOT hRowObject:AVAILABLE THEN
    RETURN ?.

  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  CASE hCol:DATA-TYPE:
    WHEN 'CLOB':U THEN
    DO:
      IF LENGTH(hCol:BUFFER-VALUE) > 0 THEN 
        COPY-LOB FROM hCol:BUFFER-VALUE TO cLongValue NO-ERROR.
      ELSE 
        cLongValue = ''.
    END.
    WHEN 'BLOB':U THEN
    DO:
      IF hCol:BUFFER-VALUE <> ? THEN
      DO:
        COPY-LOB FROM hCol:BUFFER-VALUE TO cLongValue NO-ERROR.
      /* just show the default progress error, but set return value to ? */ 
        IF ERROR-STATUS:ERROR THEN
        DO:
          MESSAGE ERROR-STATUS:GET-MESSAGE(1)
                  VIEW-AS ALERT-BOX ERROR.
          cLongValue = ''.
        END.
      END.
    END.
    WHEN 'CHARACTER':U THEN
      cLongValue = hCol:BUFFER-VALUE.
    OTHERWISE 
      cLongValue = STRING(hCol:BUFFER-VALUE).

  END CASE.

  RETURN cLongValue.

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
  DEFINE VARIABLE hRowObject   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObjUpd   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lColModified AS LOGICAL    NO-UNDO.
  
  {get RowObject hRowObject}.
  IF NOT VALID-HANDLE(hROwObject) OR NOT hRowObject:AVAILABLE THEN
    RETURN FALSE.
  
  IF hRowObject:BUFFER-FIELD('RowMod':U):BUFFER-VALUE = "U":U THEN
  DO:
    /* The row has been changed; now get the unchanged copy and see if this
       column has been changed. */
    {get RowObjUpd hRowObjUpd}.
    CREATE BUFFER hRowObjUpd FOR TABLE hRowObjUpd.
    IF VALID-HANDLE(hRowObjUpd) THEN
    DO:
      hRowObjUpd:FIND-FIRST('WHERE ':U + hRowObjUpd:NAME + '.RowNum = ':U 
                            + hRowObject:BUFFER-FIELD('RowNum':U):BUFFER-VALUE
                            + ' AND  ':U + hRowObjUpd:NAME + '.RowMod = ""':U
                            ) NO-ERROR.
      
      lColModified =  hRowObjUpd:AVAIL AND 
                      (IF hRowObjUpd:BUFFER-FIELD(pcColumn):DATA-TYPE EQ "CHARACTER":U THEN
                         COMPARE(hRowObjUpd:BUFFER-FIELD(pcColumn):BUFFER-VALUE, 
                                 "<>":U,
                                 hRowObject:BUFFER-FIELD(pcColumn):BUFFER-VALUE,
                                 "RAW":U)
                       ELSE hRowObjUpd:BUFFER-FIELD(pcColumn):BUFFER-VALUE <>
                            hRowObject:BUFFER-FIELD(pcColumn):BUFFER-VALUE). 
    END.

    DELETE OBJECT hRowObjUpd NO-ERROR.
  END. /* if hColumn:BUFFER-VALUE = "U" */
  
  RETURN lColModified.    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnName Procedure 
FUNCTION columnName RETURNS CHARACTER
  ( phHandle AS HANDLE) :

/*------------------------------------------------------------------------------
  Purpose: Resolves the external unique name of the column from the passed 
           field handle.  
    Notes: This is the name a visual data-target would use as its identifier, 
           so the sdoname is added as qualifier when running inside an SBO.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lQueryContainer   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cObjectName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hColumn           AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get QueryContainer lQueryContainer}
  {get ObjectName cObjectname}   
  .
  &UNDEFINE xp-assign
  
  /* Ensure the reference is valid. ('rowobject,' needed to avoid db resolution)*/
  hColumn = {fnarg columnHandle "'RowObject.':U + phHandle:NAME"}.
  IF VALID-HANDLE(hColumn) THEN
    /* if managed by SBO then SDO name is needed as qualifier externally.*/ 
    RETURN (IF lQueryContainer THEN cObjectName + '.':U ELSE '':U)
            + phHandle:NAME.

  RETURN '':U.
  
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
  
  IF NOT VALID-HANDLE(hRowObject) OR NOT hRowObject:AVAILABLE THEN
    RETURN ?.
  
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  IF VALID-HANDLE(hCol) THEN
  DO:
    IF hCol:DATA-TYPE = 'CLOB':U OR hCol:DATA-TYPE = 'BLOB':U THEN
    DO:
      /* Design time error .. */
      MESSAGE SUBSTITUTE({fnarg MessageNumber 95},PROGRAM-NAME(1),
                                             hCol:NAME,
                                             hCol:DATA-TYPE)
              VIEW-AS ALERT-BOX ERROR.
      RETURN ?.
    END.
    RETURN hCol:STRING-VALUE.
  END.

  RETURN ?. 

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
          -  The columnTable is called on the server as last resort for 
             qualified columns in order to support queries on unmapped fields!                          
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
    /* If the column is in the data object find the table part of pcColumn. */  
    IF {fnarg dbColumnDataName pcColumn} <> '':U THEN
    DO:
      ASSIGN
        cTable = pcColumn
        ENTRY(NUM-ENTRIES(cTable,".":U),cTable,".":U) = "":U
        cTable = RIGHT-TRIM(cTable,".":U) 
        cTable = {fnarg resolveBuffer cTable}.
    
      /* if not blank, we have a resolution, a table name or ? (ambiguous) */  
      IF cTable <> '':U THEN
        RETURN cTable.
    END.
  END. /* else do (ie: qualified references)  */
  
  /* Query methods support querying fields that are not mapped to the 
     SDO, so the final check is done against the actual database table. 
     This require a call to the server.  */
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
  DEFINE VARIABLE hCol       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE     NO-UNDO.
  
  {get RowObject hRowObject}.
  IF NOT VALID-HANDLE(hRowObject) OR NOT hRowObject:AVAILABLE THEN
    RETURN ?.

  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  /* The code would certainly look more elegant if we skipped the code above
     and resolved all cases by a call to columnHandle, as below, but column 
     functions are used extensively and we don't want to let the normal call 
     with just a column name have to pay the performance overhead of an 
     additional function call, in order to support the odd case with qualifiers. */  
  IF hCol = ? AND NUM-ENTRIES(pcColumn,".":U) > 1 THEN
    hCol = {fnarg columnHandle pcColumn}. 
  
  IF VALID-HANDLE(hCol) THEN
  DO:
    IF hCol:DATA-TYPE = 'CLOB':U OR hCol:DATA-TYPE = 'BLOB':U THEN
    DO:
      /* Design time error .. */
      MESSAGE SUBSTITUTE({fnarg MessageNumber 95},PROGRAM-NAME(1),
                                             hCol:NAME,
                                             hCol:DATA-TYPE)
              VIEW-AS ALERT-BOX ERROR.
      RETURN ?.
    END.
    RETURN hCol:BUFFER-VALUE.
  END.

  RETURN ?. 

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

&IF DEFINED(EXCLUDE-colValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION colValues Procedure 
FUNCTION colValues RETURNS CHARACTER
  ( pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a CHR(1) delimited list of values for the requested
               columns (in pcViewColList) of the current row of the RowObject.
               The first value is the RowObect ROWID and RowIdent separated 
               with a comma.     
  Parameters:
    INPUT pcViewColList - Comma delimited list of RowObject column names
                        - SKIP means add blank value   
  Notes:       The form of the first value is:
                 <RowObject ROWID>,<DB Buffer1 ROWID>,<DB Buffer2 ROWID>,...
               This is used as a key to uniquely identify the row and its
               origins in the optimistic locking system.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColValues  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCol        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hColumn     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iColCount   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hRowObject  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField      AS CHARACTER  NO-UNDO.

  {get RowObject hRowObject}.     
  IF VALID-HANDLE(hrowObject) AND hRowObject:AVAILABLE THEN 
  DO:    
    /* If pcViewColList is formatted with the SDO name in front, strip it out */
    IF INDEX(pcViewColList, ".") > 0 THEN
       pcViewColList = ENTRY(2, pcViewColList, ".").

    /* The first value passed back is always a "key" consisting of the RowObject
       ROWID plus the ROWIDs of the individual db records which make up the row. */
    ASSIGN 
      cColValues = STRING(hRowObject:ROWID) + ",":U
      hColumn    = hRowObject:BUFFER-FIELD('RowIdent':U)
      cColvalues = cColValues + hColumn:BUFFER-VALUE + CHR(1)
      iColCount  = NUM-ENTRIES(pcViewColList).
     
    DO iCol = 1 TO iColCount:
      cField = ENTRY(iCol, pcViewColList).
      IF cField = 'SKIP':U THEN
        cColValues = cColValues + ''.         
      ELSE DO:
        hColumn = hRowObject:BUFFER-FIELD(cField) NO-ERROR.
        IF NOT VALID-HANDLE(hColumn) THEN
        DO:
          /* If this is a <calc> field, make put a constant in so that the
             browser does not fail during displayFields */
          IF INDEX(ENTRY(iCol, pcViewColList), "<calc>":U) > 0 THEN
             cColValues = cColValues + CHR(4) + "<calc>":U + CHR(4). 
          ELSE
          DO:
            /* If the column was not found in this object, look to see
              if this object has a parent that can supply it. */
            {get DataSource hDataSource}.
            IF VALID-HANDLE(hDataSource) THEN
            DO:
              cValue = DYNAMIC-FUNCTION('colValues':U IN hDataSource,
                                         ENTRY(iCol, pcViewColList)).
              IF cValue NE ? THEN
                cColValues = cColValues + ENTRY(2, cValue, CHR(1)).
              ELSE RETURN ?.
            END.   /* IF cValue */
            ELSE RETURN ?.
          END.
        END.       /* IF NOT VALID-HANDLE */
        ELSE DO:
          IF hColumn:DATA-TYPE = 'CLOB':U OR hColumn:DATA-TYPE = 'BLOB':U THEN
          DO:
            /* Design time error .. */
            MESSAGE SUBSTITUTE({fnarg MessageNumber 95},PROGRAM-NAME(1),hColumn:NAME,hColumn:DATA-TYPE)
               VIEW-AS ALERT-BOX ERROR.
            RETURN ?.
          END.
          ELSE
             cColValues = cColValues                         
                        + IF hColumn:BUFFER-VALUE = ? 
                          THEN "?":U 
                          ELSE RIGHT-TRIM(STRING(hColumn:BUFFER-VALUE)). 
        END.       /* END ELSE DO if hColumn found locally */
      END.
      IF iCol NE iColCount THEN cColValues = cColValues + CHR(1).
    END.  /* END iCol */
    RETURN cColValues.       
  END. /* valid and avail rowObject*/
  RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyLargeColumnToFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION copyLargeColumnToFile Procedure 
FUNCTION copyLargeColumnToFile RETURNS LOGICAL
  ( pcColumn   AS CHAR,
    pcFileName AS CHARACTER) :
/*------------------------------------------------------------------------------
   Purpose: Copy a large column to the passed filename. 
Parameters: pcColumn 
             - Unqualified column name of the RowObject field.
             - Column name qualified with "RowObject".   
             - qualified database field name. 
              (This requires that the field is mapped to the SDO).  
            
            pcFileName - filename to copy the data to                      
     Notes:  
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
  
  IF VALID-HANDLE(hCol) THEN
  DO ON STOP UNDO,LEAVE ON ERROR UNDO,LEAVE:
    COPY-LOB FROM hCol:BUFFER-VALUE TO FILE pcFileName.
    RETURN TRUE.
  END.
  
  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyLargeColumnToMemptr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION copyLargeColumnToMemptr Procedure 
FUNCTION copyLargeColumnToMemptr RETURNS LOGICAL
  ( pcColumn AS CHAR,
    pmMemptr AS MEMPTR) :
/*------------------------------------------------------------------------------
  Purpose: Copy the value of a large column to the passed Memptr
Parameters: pcColumn 
             - Unqualified column name of the RowObject field.
             - Column name qualified with "RowObject".   
             - qualified database field name. 
              (This requires that the field is mapped to the SDO).              
            pmMemptr 
            - The memptr to copy the data to    
    Notes:  
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
  
  IF VALID-HANDLE(hCol) THEN
  DO ON STOP UNDO,LEAVE ON ERROR UNDO,LEAVE:
    COPY-LOB FROM hCol:BUFFER-VALUE TO pmMemptr.
    RETURN TRUE.
  END.
  
  RETURN FALSE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

