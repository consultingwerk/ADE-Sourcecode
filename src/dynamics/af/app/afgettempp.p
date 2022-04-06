&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* Update Version Notes Wizard
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
  File: afgettempp.p

  Description:  Get temp table procedure

  Purpose:      Get temp table procedure

  Parameters:

  History:
  --------
  (v:010000)    Task:        7065   UserRef:    
                Date:   17/11/2000  Author:     Anthony Swindells

  Update Notes: Astra 2 dynamic lookups

  (v:010002)    Task:        7772   UserRef:    
                Date:   31/01/2001  Author:     Anthony Swindells

  Update Notes: Fix outer-join issues with lookups

-----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgettempp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

/* Query core limitation used to define extents in query logic */                                                    
&SCOPED-DEFINE MaxTables 18  

/* input-output temp-table for combo boxes / selection lists whose list items pairs
   need to be built
*/
{af/sup2/afttlkctrl.i}
{af/sup2/afglobals.i}


DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttLookCtrl. /* lookup control information */
DEFINE OUTPUT PARAMETER TABLE-HANDLE ohttLookup.    /* table handle for lookup Data dynamic temp-table */

/* To keep track of PLIPs started */
DEFINE TEMP-TABLE ttPLIP NO-UNDO
  FIELDS cPLIP    AS CHARACTER
  FIELDS hHandle  AS HANDLE
  INDEX  idx1     AS PRIMARY UNIQUE cPLIP.

{ry/inc/ryrepprmod.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-insertExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD insertExpression Procedure 
FUNCTION insertExpression RETURNS CHARACTER
  (pcWhere      AS CHAR,   
   pcExpression AS CHAR,     
   pcAndOr      AS CHAR) FORWARD.

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

&IF DEFINED(EXCLUDE-whereClauseBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-EXTERNAL whereClauseBuffer Procedure 
FUNCTION whereClauseBuffer RETURNS CHARACTER
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

  cBuffer =  (IF NUM-ENTRIES(pcWhere," ":U) > 1 
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
         HEIGHT             = 11.38
         WIDTH              = 52.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE hTT                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTTBuff            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hQuery             AS HANDLE     NO-UNDO.
DEFINE VARIABLE cBufferHdlList     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldHdlList      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hBuffer            AS HANDLE     NO-UNDO.
DEFINE VARIABLE iRow               AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoop              AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoop2             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iBuffer            AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBuffer            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField             AS HANDLE     NO-UNDO.
DEFINE VARIABLE hFromBuffer        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hFromField         AS HANDLE     NO-UNDO.
DEFINE VARIABLE cValue             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEmptyValue        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lOk                AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cRowid             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iStartRow          AS INTEGER    NO-UNDO.
DEFINE VARIABLE cStartRowId        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE rRowIDs            AS ROWID EXTENT {&MaxTables} NO-UNDO.
DEFINE VARIABLE lOffEnd            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cPlipName          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBufferName        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hPlipHandle        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTempTable         AS HANDLE     NO-UNDO.
DEFINE VARIABLE cNewQuery          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE rRowid             AS ROWID      NO-UNDO.
DEFINE VARIABLE cProfileData       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lDisplayRepository AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cProduct           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProductModule     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iPrLoop            AS INTEGER    NO-UNDO.
DEFINE VARIABLE iExtentLoop        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cBufferList        AS CHARACTER  NO-UNDO.
/* 1st find lookup control information */
ASSIGN
  ohttLookup = ?
  .
FIND FIRST ttLookCtrl NO-ERROR.
IF NOT AVAILABLE ttLookCtrl THEN RETURN.

/* See if appending to an existing result set */ 
IF ttLookCtrl.cLastResultRow <> "":U THEN
  ASSIGN
    iStartRow = INTEGER(ENTRY(1,ttLookCtrl.cLastResultRow,";":U))
    cStartRowId = ENTRY(2,ttLookCtrl.cLastResultRow,";":U).
ELSE
  ASSIGN
    iStartRow = 0
    cStartRowId = "":U.

/* Create a query */
CREATE QUERY hQuery NO-ERROR.
/* Add buffers */
buffer-loop:
DO iLoop = 1 TO NUM-ENTRIES(ttLookCtrl.cQueryTables):
  hBuffer = ?.
  /* Check for TEMP-TABLES */
  IF ttLookCtrl.cTempTableNames <> "":U AND 
     ENTRY(iLoop,ttLookCtrl.cTempTableNames) <> "":U THEN DO:
    /* Since we are on the AppServer we do not care to run any special code
       to ensure that we run the PLIPs anywhere esle */
    cPlipName = ENTRY(iLoop,ttLookCtrl.cTempTableNames).
    IF cPlipName <> "":U THEN DO:
      FIND FIRST ttPLIP 
           WHERE ttPLIP.cPLIP = cPlipName
           NO-LOCK NO-ERROR.
      IF AVAILABLE ttPLIP THEN
        hPLIPHandle = ttPLIP.hHandle.
      ELSE DO:
        RUN VALUE(cPlipName) PERSISTENT SET hPLIPHandle NO-ERROR.
        CREATE ttPLIP.
        ASSIGN ttPLIP.cPLIP   = cPlipName
               ttPLIP.hHandle = hPLIPHandle.
      END.
      /* If for some reason we could not run the PLIP - just continue with 
         the other SDFs */
      IF NOT VALID-HANDLE(hPLIPHandle) THEN
        NEXT.
      /* Check if the procedure to populate the data for the Temp Table is available in the PLIP */
      IF LOOKUP(ENTRY(iLoop,ttLookCtrl.cQueryTables) + "Data":U,hPLIPHandle:INTERNAL-ENTRIES) = 0 THEN
        NEXT.
      RUN VALUE(ENTRY(iLoop,ttLookCtrl.cQueryTables) + "Data":U) IN hPLIPHandle (OUTPUT hTempTable) NO-ERROR.
      /* Make sure we have a valid Temp Table */
      IF NOT VALID-HANDLE(hTempTable) OR 
         ERROR-STATUS:ERROR THEN
        NEXT.
      /* Now create the buffer handle */
      CREATE BUFFER hBuffer FOR TABLE hTempTable NO-ERROR.
    END.
  END.

  /* Check for BUFFERS */
  IF ttLookCtrl.cPhysicalTableNames <> "":U AND 
     ENTRY(iLoop,ttLookCtrl.cPhysicalTableNames) <> "":U THEN
    CREATE BUFFER hBuffer FOR TABLE TRIM(ENTRY(iLoop,ttLookCtrl.cPhysicalTableNames)) BUFFER-NAME ENTRY(iLoop,ttLookCtrl.cQueryTables) NO-ERROR. 

  /* Actual DataBase Tables */
  IF NOT VALID-HANDLE(hBuffer) THEN
    CREATE BUFFER hBuffer FOR TABLE ENTRY(iLoop,ttLookCtrl.cQueryTables) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN NEXT buffer-loop.
  cBufferHdlList = cBufferHdlList + (IF cBufferHdlList <> "":U THEN ",":U ELSE "":U) + STRING(hBuffer).
  hQuery:ADD-BUFFER(hBuffer) NO-ERROR.
END. /* buffer-loop */

/* Strip DB Prefix */
DO iLoop = 1 TO NUM-ENTRIES(ttLookCtrl.cQueryTables):
  cBuffer = ENTRY(iLoop,ttLookCtrl.cQueryTables).
  cBuffer = IF NUM-ENTRIES(cBuffer,".":U) > 1 THEN ENTRY(2,cBuffer,".":U) ELSE cBuffer.
  
  cBufferList = IF cBufferList = "":U THEN cBuffer ELSE cBufferList + ",":U + cBuffer.
END.

/* Get Field Handles, assuming all fields in table.field format */
DO iLoop = 1 TO NUM-ENTRIES(ttLookCtrl.cAllFields):
  cBuffer = ENTRY(iLoop,ttLookCtrl.cAllFields).
  cField = ENTRY(2,cBuffer,".":U).
  cBuffer = ENTRY(1,cBuffer,".":U).
  hBuffer = WIDGET-HANDLE(ENTRY(LOOKUP(cBuffer,cBufferList),cBufferHdlList)).
  hField = hBuffer:BUFFER-FIELD(cField).
  cFieldHdlList = cFieldHdlList + (IF cFieldHdlList <> "":U THEN ",":U ELSE "":U) + STRING(hField).
END.

/* Create the dynamic temp-table */
CREATE TEMP-TABLE hTT.


/* Add fields - static ones first */
hTT:ADD-NEW-FIELD("RowNum":U,"INTEGER":U).      /* Row number for sequencing */
hTT:ADD-NEW-FIELD("RowIdent":U,"CHARACTER":U).  /* string of Rowid of correspding record, comma delimited for multiple tables */

/* Add selected fields */
DO iLoop = 1 TO NUM-ENTRIES(cFieldHdlList):
  hField = WIDGET-HANDLE(ENTRY(iLoop,cFieldHdlList)).
  cBuffer = ENTRY(iLoop,ttLookCtrl.cAllFields).
  cField = ENTRY(2,cBuffer,".":U).
  cBuffer = ENTRY(1,cBuffer,".":U).
  hTT:ADD-LIKE-FIELD(cBuffer + "_":U + cField,hField).
  /*
  hTT:ADD-LIKE-FIELD(hField:NAME,hField).
  */
END.

/* Add indexes to the temp-table */
hTT:ADD-NEW-INDEX("idxRowNum":U,FALSE,FALSE).
hTT:ADD-INDEX-FIELD("idxRowNum":U,"RowNum":U,"asc":U).
hTT:ADD-NEW-INDEX("idxRowIdent":U,FALSE,FALSE).
hTT:ADD-INDEX-FIELD("idxRowIdent":U,"RowIdent":U,"asc":U).


/* Prepare the temp-table with the name the user chose */
hTT:TEMP-TABLE-PREPARE("RowObject":U).

/* Store the handle to the buffer for the temp-table */
hTTBuff = hTT:DEFAULT-BUFFER-HANDLE.

RUN processQueryStringFilterSets IN gshGenManager (INPUT  ttLookCtrl.cBaseQueryString,
                                                   OUTPUT ttLookCtrl.cBaseQueryString).

/* Exclude Products and Product Modules belonging to Repository */
IF INDEX(ttLookCtrl.cBaseQueryString,"[EXCLUDE_REPOSITORY_PRODUCTS]":U) > 0 OR 
   INDEX(ttLookCtrl.cBaseQueryString,"[EXCLUDE_REPOSITORY_PRODUCT_MODULES]":U) > 0 THEN DO:
  cNewQuery = ttLookCtrl.cBaseQueryString.
  /* Display Repository?  */
  ASSIGN rRowid = ?.
  RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                            INPUT        "DispRepos":U,
                                            INPUT        "DispRepos":U,
                                            INPUT        NO,
                                            INPUT-OUTPUT rRowid,
                                                  OUTPUT cProfileData).
  ASSIGN lDisplayRepository = (cProfileData EQ "YES":U).
  rRowID = ?.
  
  /* Add Product Exclusion */
  IF NOT lDisplayRepository AND 
     INDEX(cNewQuery,"[EXCLUDE_REPOSITORY_PRODUCTS]":U) > 0 AND
     LOOKUP("gsc_product":U,cBufferList) > 0 THEN DO:
    cNewQuery = REPLACE(cNewQuery,"[EXCLUDE_REPOSITORY_PRODUCTS]":U,"TRUE":U).
    DO iPrLoop = 1 TO NUM-ENTRIES("{&REPOSITORY-PRODUCTS}":U):
      cProduct = TRIM(ENTRY(iPrLoop,"{&REPOSITORY-PRODUCTS}":U)).
      IF cProduct = "":U THEN
        NEXT.
      cNewQuery = DYNAMIC-FUNCTION("newWhereClause",
                                   "gsc_product":U,
                                   "gsc_product.product_code <> '" + cProduct + "'",
                                   cNewQuery,
                                   "AND":U).
    END.
    ttLookCtrl.cBaseQueryString = cNewQuery.
  END.
  
  /* Add Product Module Exclusion */
  IF NOT lDisplayRepository AND 
     INDEX(cNewQuery,"[EXCLUDE_REPOSITORY_PRODUCT_MODULES]":U) > 0 AND
     LOOKUP("gsc_product_module":U,cBufferList) > 0 THEN DO:
    cNewQuery = REPLACE(cNewQuery,"[EXCLUDE_REPOSITORY_PRODUCT_MODULES]":U,"TRUE":U).
    DO iPrLoop = 1 TO NUM-ENTRIES("{&REPOSITORY-MODULES}":U):
      cProduct = TRIM(ENTRY(iPrLoop,"{&REPOSITORY-MODULES}":U)).
      IF cProduct = "":U THEN
        NEXT.
      cNewQuery = DYNAMIC-FUNCTION("newWhereClause",
                                   "gsc_product_module":U,
                                   "NOT gsc_product_module.product_module_code BEGINS '" + cProduct + "'",
                                   cNewQuery,
                                   "AND":U).
    END.
    ttLookCtrl.cBaseQueryString = cNewQuery.
  END.
  IF lDisplayRepository THEN
    ASSIGN ttLookCtrl.cBaseQueryString = REPLACE(ttLookCtrl.cBaseQueryString,"[EXCLUDE_REPOSITORY_PRODUCTS]":U,"TRUE":U)
           ttLookCtrl.cBaseQueryString = REPLACE(ttLookCtrl.cBaseQueryString,"[EXCLUDE_REPOSITORY_PRODUCT_MODULES]":U,"TRUE":U).

END.

/* Prepare a query using the string the user provided */

hQuery:QUERY-PREPARE(ttLookCtrl.cBaseQueryString).
/* Open the query */
hQuery:QUERY-OPEN() NO-ERROR.

/* position to desired record */
IF ttLookCtrl.iFirstRowNum = 0 OR cStartRowId = "":U THEN
DO:
  /* Get the first result in the result set and indicate query started */
  hQuery:GET-FIRST() NO-ERROR.
END.
ELSE
DO: /* Restart from after the last record read */
  ASSIGN rRowIDs = ?.       /* Fill in this array with all the rowids. */
  DO iLoop = 1 TO NUM-ENTRIES(cStartRowId):
    rRowIDs[iLoop] = TO-ROWID(ENTRY(iLoop, cStartRowId)).
  END.        /* END DO iCnt */
  lOffEnd = hQuery:QUERY-OFF-END. 
  lOk = hQuery:REPOSITION-TO-ROWID(rRowIDs) NO-ERROR.
  IF lOk OR (lOffEnd AND NOT ERROR-STATUS:ERROR) THEN 
  DO:
    hQuery:GET-NEXT() NO-ERROR. /* get row repositioned to */
    hQuery:GET-NEXT() NO-ERROR. /* get next record */
  END.
END.

/* Iterate for as many rows as the user has chosen, or until the query is 
   off-end */
REPEAT iRow = (iStartRow + 1) TO (ttLookCtrl.iRowsToBatch + iStartRow) WHILE NOT hQuery:QUERY-OFF-END:

  /* Create a temp-table record */
  hTTBuff:BUFFER-CREATE().
  /* Iterate through the fields in the temp table */

  DO iLoop = 1 TO hTTBuff:NUM-FIELDS:
    /* Get the handle to the current field */
    hField = hTTBuff:BUFFER-FIELD(iLoop).
    /* If this is the first field, we just increment the counter */
    IF iLoop = 1 THEN
      hField:BUFFER-VALUE = iRow.
    ELSE IF iLoop = 2 THEN /* rowident list */
    DO:
      hField:BUFFER-VALUE = "":U.
      DO iLoop2 = 1 TO NUM-ENTRIES(cBufferHdlList):
        ASSIGN hBuffer = WIDGET-HANDLE(ENTRY(iLoop2, cBufferHdlList)).
        IF VALID-HANDLE(hbuffer) THEN
          cRowid = STRING(hBuffer:ROWID).
        ELSE
          cRowid = "?":U.
        ASSIGN
          hField:BUFFER-VALUE = hField:BUFFER-VALUE +
                                (IF iLoop2 = 1 THEN "":U ELSE ",":U) +
                                (IF cRowid = ? THEN "?":U ELSE cRowId).
      END.

      /* Store first row details */
      IF ttLookCtrl.iFirstRowNum = 0 AND iRow = 1 THEN
      DO:
        ASSIGN 
          ttLookCtrl.iFirstRowNum = 1
          ttLookCtrl.cFirstResultRow = "1;":U + hField:BUFFER-VALUE
          .
      END.

      /* Store last result row details */
      ASSIGN
        ttLookCtrl.cLastResultRow = STRING(iRow) + ";":U + (IF hField:BUFFER-VALUE = ? THEN "?":U ELSE hField:BUFFER-VALUE)
        .
    END.  /* iloop = 2 */
    ELSE
    DO:
      /* Otherwise get the handle of the corresponding field in the 
         cFieldHdlList list */
      cBuffer = ENTRY(iLoop - 2,ttLookCtrl.cAllFields).
      cField = ENTRY(2,cBuffer,".":U).
      cBuffer = ENTRY(1,cBuffer,".":U).
      hFromBuffer = WIDGET-HANDLE(ENTRY(LOOKUP(cBuffer,cBufferList),cBufferHdlList)).
      hFromField = WIDGET-HANDLE(ENTRY(iLoop - 2,cFieldHdlList)).
      /* Set the value of the temp-table field to the value of the 
         database table field */
      IF hField:EXTENT = 0 THEN
        hField:BUFFER-VALUE = hFromBuffer:BUFFER-FIELD(hFromField:NAME):BUFFER-VALUE.
      ELSE DO:
        DO iExtentLoop = 1 TO hField:EXTENT:
          hField:BUFFER-VALUE[iExtentLoop] = hFromBuffer:BUFFER-FIELD(hFromField:NAME):BUFFER-VALUE[iExtentLoop].
        END.
      END.
    END.
  END.

  /* Release the temp-table record */
  hTTBuff:BUFFER-RELEASE().
  /* Get the next result in the query */
  hQuery:GET-NEXT().

END. /* repeat */

/* See if reached last record and store last row if we have */
IF hQuery:QUERY-OFF-END THEN
  ASSIGN
    ttLookCtrl.iLastRowNum = iRow. 
ELSE
  ASSIGN
    ttLookCtrl.iLastRowNum = 0.   /* more to come, reached batch count */ 

/* Cleanup */
DELETE OBJECT hQuery NO-ERROR.
ASSIGN hQuery = ?.

buffer-loop2:
DO iLoop = 1 TO NUM-ENTRIES(cBufferHdlList):
  hBuffer = WIDGET-HANDLE(ENTRY(iLoop,cBufferHdlList)).
  DELETE OBJECT hBuffer NO-ERROR.
  ASSIGN hBuffer = ?.
END. /* buffer-loop2 */

ASSIGN
  ohttLookup = hTT
  .

/* delete temp-table object */
DELETE OBJECT hTT.
hTT = ?.

FOR EACH ttPLIP:
  IF VALID-HANDLE(ttPLIP.hHandle) THEN
    RUN killPlip IN ttPLIP.hHandle NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-insertExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION insertExpression Procedure 
FUNCTION insertExpression RETURNS CHARACTER
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

