&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
/* Procedure Description
"Method Library for db query objects."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    Library     : query.i - Basic include file for V9 query objects
    Purpose     : Included in objects which retrieve data through a 
                  database query, including DataObjects. 
    Syntax      : {src/adm2/query.i}

   Modified    : February 18, 2001 Version 9.1C 
   Modified    : 02/27/02 Gikas A. Gikas - IZ 4050 Max query buffers
    
    Note: !!!   : Method Libraries are maintained manually for 
                  conditional inclusion.        
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass query
&ENDIF

&IF "{&ADMClass}":U = "query":U &THEN
  {src/adm2/qryprop.i}
&ENDIF

&IF '{&adm-tabledelimiter}' = '' &THEN
  &GLOBAL-DEFINE adm-tabledelimiter ';':U
&ENDIF

/* Exclude the static delete and initProps for a dynamic data object */ 
&IF DEFINED(DATA-FIELD-DEFS) = 0 &THEN
   &SCOPED-DEFINE EXCLUDE-deleteRecordStatic
   &SCOPED-DEFINE EXCLUDE-initProps  
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-deleteRecordStatic) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteRecordStatic Method-Library 
FUNCTION deleteRecordStatic RETURNS LOGICAL
  ( INPUT piTableIndex AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 8
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

{src/adm2/dataquery.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  IF NOT {&ADM-LOAD-FROM-REPOSITORY} THEN
  DO:
      RUN start-super-proc("adm2/query.p":U).
      RUN start-super-proc("adm2/queryext.p":U).
        /* queryext.p is merely a simple "extension" of query.p.  This was necessary
           because functions don't have their own action segement and query.p got
           too big on AS400.  All of the functions in queryext.p are get and set 
           property functions.  */

  END.  /* if not adm-load-from-repos */

  
  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
  {src/adm2/custom/querycustom.i}
  /* _ADM-CODE-BLOCK-END */
&ENDIF

&IF DEFINED(DATA-FIELD-DEFS) <> 0 &THEN
  RUN initProps IN TARGET-PROCEDURE.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-initProps) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initProps Method-Library 
PROCEDURE initProps :
/*------------------------------------------------------------------------------
  Purpose:     Sets all the object's properties that are related to the
               Query, during initialization.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTable          AS CHARACTER  NO-UNDO. 
  DEFINE VARIABLE iTable          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cColumns        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataCols       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdCols        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcData       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcUpd        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNumData        AS INT        NO-UNDO.
  DEFINE VARIABLE iNumUpd         AS INT        NO-UNDO.
  DEFINE VARIABLE cBuffers        AS CHARACTER  NO-UNDO INIT "":U.
  DEFINE VARIABLE cKeyFields      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAssignList     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iAssigns        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPos            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntry          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTables         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableAssign    AS CHARACTER EXTENT 19 NO-UNDO INIT "":U.
  DEFINE VARIABLE cDbEntry        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField          AS CHAR       NO-UNDO.
  DEFINE VARIABLE cKeyTable       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString    AS CHARACTER  NO-UNDO.
    /* New for 9.1D to allow storage of this in the client SDO so the one-hit 
     appserver can be utilized also oat initialization */

  cQueryString = '{&QUERY-STRING-{&QUERY-NAME}}':U.
  cTables = REPLACE("{&TABLES-IN-QUERY-{&QUERY-NAME}}":U," ":U,",":U).

 /* Server side logic */ 
&IF DEFINED(OPEN-QUERY-{&QUERY-NAME}) NE 0 &THEN

  DEFINE VARIABLE hQuery                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer                 AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cOpenQuery              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBNames                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhysicalTables         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyTableEntityFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyTableEntityValues   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyTableEntityMnemonic AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyTableEntityObjField AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBName                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntityFields           AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lHasObjectField         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHasAudit               AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHasComment             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHasAutoComment         AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE iLookup                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iAlias                  AS INTEGER    NO-UNDO.

  ASSIGN hQuery = QUERY {&QUERY-NAME}:HANDLE   /* Database query */
         hQuery:ADM-DATA = (IF hQuery:ADM-DATA <> ?
                              THEN (hQuery:ADM-DATA + chr(1)) ELSE "")
                           + "STATIC":U.

  /* Initialize the list of buffer handles for the tables in the db query,
     which is used to build the "RowIdent" key passed to clients. 
     Also initialize DBNames, which is used to forgive developers that
     use db-qualified calls to non-db-qualified SDOs and vice/versa */
  DO iTable = 1 TO hQuery:NUM-BUFFERS:
    ASSIGN 
      hBuffer         = hQuery:GET-BUFFER-HANDLE(iTable)
      cBuffers        = cBuffers 
                      + (IF iTable = 1 THEN "":U ELSE ",":U) 
                      + STRING(hBuffer)
      cPhysicalTables = cPhysicalTables 
                      + (IF iTable = 1 THEN "":U ELSE ",":U) 
                      + hBuffer:TABLE.
      
    ALS-BLK:
    DO:
      cDBName = "":U. /* Reset variable */
      /* Check to see if the dbname is connected as an alias */
      DO iAlias = 1 TO NUM-ALIASES:
        IF LDBNAME(ALIAS(iAlias)) EQ hBuffer:DBNAME AND
           CAN-DO(cTables,ALIAS(iAlias) + ".":U + hBuffer:NAME) THEN DO: 
          cDBName = ALIAS(iAlias).
          LEAVE ALS-BLK.
        END.
      END.  
    END.
    cDBNames = cDBNames + (IF iTable = 1 THEN "":U ELSE ",":U) 
                          + (IF cDBName EQ "":U THEN hBuffer:DBNAME ELSE cDBName).
  END. /* iTable = 1 to num-buffers */

  &SCOPED-DEFINE xp-assign
  {set DataIsFetched no} /* override inherited default */
  {set BufferHandles cBuffers}
  {set DBNames cDBNames}  
  {set QueryHandle hQuery}
  {set PhysicalTables cPhysicalTables}
  {set Tables cTables}   /* List of DB table names */
  .
  &UNDEFINE xp-assign
  
  IF cQueryString = '':U THEN
    ASSIGN
      cOpenQuery = '{&OPEN-QUERY-{&QUERY-NAME}}':U  /* NOTE: ' vs " parsing?? */
      /* Next eliminate the "OPEN QUERY Query-Main" text. */
      iPos       = INDEX(cOpenQuery, " FOR ":U) 
      /* No FOR keyword (reserved) found, check for PRESELECT (not reserved) */ 
      iPos       = IF iPos = 0 THEN INDEX(cOpenQuery, " PRESELECT ":U) ELSE iPos  
      cQueryString = SUBSTR(cOpenQuery,iPos + 1).
  
  /* Store the original query in the OpenQuery property and prepare the query 
     with it. 
     - setOpenQuery -> setQueryWhere -> prepareQuery */
 
  IF NOT {fnarg setOpenQuery cQueryString} THEN
    DYNAMIC-FUNCTION('showMessage':U IN TARGET-PROCEDURE, '5':U). 
&ELSE  /* if defined(open-query) */
  {set Tables cTables}.   /* List of DB table names */
    /* Store the original query in the BaseQuery client property */ 
  IF cQueryString <> '' THEN
     {set BaseQuery cQueryString}.
&ENDIF /* client */  

&IF "{&TABLES-IN-QUERY-{&QUERY-NAME}}":U NE "":U &THEN
  /* Define the AssignList property. This takes the ASSIGN-LIST preprocessor,
     which is in the form:
  RowObject.<ROfieldname><space>=<space><DBtable>.<DBfieldname><space><space>...
     and converts it to a series of lists of fields for each table:
  ROfieldname,DBfieldname[,...]{&adm-tabledelimiter}...
     This is a form usable by dynamic BUFFER-COPY and BUFFER-COMPARE.
  */
  
  cAssignList = "{&ASSIGN-LIST}":U.  /* Start with the raw preproc value. */
  iAssigns = NUM-ENTRIES(cAssignList, " ":U).
  
  DO iEntry = 1 TO iAssigns BY 4:    /* NB: extra space delim is important! */
    ASSIGN
      /* First get the DB table name and match it against the Tables list.  */
      cDbEntry = ENTRY(iEntry + 2, cAssignList, " ":U)
      /* NOTE, we cannot use columnTable here because that will not work on 
         a client, since that will resolve to query.p at this moment, because 
         data.p, which has a non-db columnTable is not added as super yet! */     
      cTable   = cDbEntry
      /* remove field part from qualified fieldname */
      ENTRY(NUM-ENTRIES(cTable, ".":U),cTable,".":U) = "":U
      /* trim off remaining period */
      cTable   = RIGHT-TRIM(cTable,".":U)
      /* now lookup the [db.]table part of this in the table list */
      iTable   = LOOKUP(cTable,cTables).
    IF iTable > 0  THEN
      cTableAssign[iTable] = cTableAssign[iTable] 
        + (IF cTableAssign[iTable] = "":U THEN "":U ELSE ",":U)
        /* This is the RowObject field name: */
        + ENTRY(2, ENTRY(iEntry, cAssignList, " ":U), ".":U) 
        + ",":U 
          /* and this is the Database field name--ENTRY(3) if db qual, else 2:*/
        + ENTRY(NUM-ENTRIES(cDbEntry, ".":U),cDbEntry, ".":U).
  END.    /* END DO iEntry */
   
  /* Now put the list back together in the final form: */
  cAssignList = "":U.

  DO iTable = 1 TO NUM-ENTRIES(cTables):

    cAssignList = cAssignList + 
      (IF iTable = 1 THEN "":U ELSE {&adm-tabledelimiter}) +
        cTableAssign[iTable].
  END.    /* END DO iTable */

  {set AssignList cAssignList}.

&ENDIF   /* If TABLES-IN-QUERY */

&IF "{&DATA-FIELDS}":U NE "":U &THEN
  /* Now set the UpdatableColumns and DataColumnsByTable property to be all 
     the Enabled-Fields and Data-Fields, delimited by {&adm-tabledelimiter}.
     Also store the original list which may xontain computed fields */

 &SCOPED-DEFINE datavar         cDataCols 
 &SCOPED-DEFINE enabledvar      cUpdCols
 &SCOPED-DEFINE datacount       iNumData 
 &SCOPED-DEFINE enabledcount    iNumUpd

  {src/adm2/tblprep.i &num=FIRST}
  {src/adm2/tblprep.i &num=SECOND}
  {src/adm2/tblprep.i &num=THIRD}
  {src/adm2/tblprep.i &num=FOURTH}
  {src/adm2/tblprep.i &num=FIFTH}
  {src/adm2/tblprep.i &num=SIXTH}
  {src/adm2/tblprep.i &num=SEVENTH}
  {src/adm2/tblprep.i &num=EIGHTH}
  {src/adm2/tblprep.i &num=NINTH}
  {src/adm2/tblprep.i &num=TENTH} 
  {src/adm2/tblprep.i &num=ELEVENTH}
  {src/adm2/tblprep.i &num=TWELFTH}
  {src/adm2/tblprep.i &num=THIRTEENTH}
  {src/adm2/tblprep.i &num=FOURTEENTH}
  {src/adm2/tblprep.i &num=FIFTEENTH}
  {src/adm2/tblprep.i &num=SIXTEENTH}
  {src/adm2/tblprep.i &num=SEVENTEENTH}
  {src/adm2/tblprep.i &num=EIGHTEENTH}

 &UNDEFINE enabledvar 
 &UNDEFINE datavar   
 &UNDEFINE datacount   
 &UNDEFINE enabledcount   
 
 cColumns =  REPLACE('{&DATA-FIELDS}':U,' ':U,',':U).

 &SCOPED-DEFINE xp-assign
 {set DataColumns cColumns}
 {set UpdatableColumnsByTable cUpdCols}
 {set DataColumnsByTable cDataCols}
 .
 &UNDEFINE xp-assign
 
/* Is there any calculated fields? */
DO iCount = 1 TO NUM-ENTRIES(cColumns) 
WHILE  (iNumUpd  < NUM-ENTRIES('{&ENABLED-FIELDS}':U,' ':U)
        OR 
        iNumData < NUM-ENTRIES(cColumns)):
  /* All fields are in data-fields so we don't care about enabled-fields */
  cField = ENTRY(iCount,cColumns).
  /* Replace {&adm-tabledelimiter} with commas in order to can-do */
  IF NOT CAN-DO(REPLACE(cDataCols,{&adm-tabledelimiter},",":U),cField) THEN
  DO:
    ASSIGN 
      cCalcData = cCalcData + (IF cCalcData = "":U THEN "":U ELSE ",":U) + cField
      iNumData  = iNumData  + 1.
  END. /* not can-do(datacols with commas,cfield) */
  /* Replace {&adm-tabledelimiter} with commas in order to can-do */
  IF  NOT CAN-DO(REPLACE(cUpdCols,{&adm-tabledelimiter},",":U),cField) 
  AND LOOKUP(cField,'{&enabled-fields}':U,' ':U) > 0 THEN
  DO:  
    ASSIGN 
      cCalcUpd = cCalcUpd + (IF cCalcUpd = "":U THEN "":U ELSE ",":U) + cField
      iNumUpd  = iNumUpd + 1.
  END. /* not can-do(updcols with commas,cfield) and lookup(enabled,cfield > 0)*/
END.
/* Put the non-db data at the end of the list 
  (we always add this even if there are no calc fields. This ensures that 
   anyone that looks at this list in an object without calc-fields 
   (can) understand that the num-entries({&adm-tabledelimiter}) are higher than num-tables*/ 
 
ASSIGN
  cDataCols = cDataCols + {&adm-tabledelimiter} + cCalcData
  cUpdCols  = cUpdCols + {&adm-tabledelimiter}  + cCalcUpd.

&SCOPED-DEFINE xp-assign
{set UpdatableColumnsByTable cUpdCols}
{set DataColumnsByTable cDataCols}
.
&UNDEFINE xp-assign

&ENDIF /* DATA-FIELDS NE "" */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-deleteRecordStatic) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteRecordStatic Method-Library 
FUNCTION deleteRecordStatic RETURNS LOGICAL
  ( INPUT piTableIndex AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  Deletes a record from the specified table in the query.  This 
            function is necessary in order to work around a limitation with the
            BUFFER-DELETE() method for buffer handles: The method will fail if
            there is delete validation defined on the target table.  The work
            around is to use a static "DELETE {table}." statement instead.
    Notes:  Called internally by fetchDBRowForUpdate() in adm2/query.p
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lRet AS LOGICAL NO-UNDO INIT TRUE.

  CASE piTableIndex:
    WHEN 1 THEN DO:
      {src/adm2/delrecst.i &num=FIRST}
    END.
    WHEN 2 THEN DO:
      {src/adm2/delrecst.i &num=SECOND}
    END.
    WHEN 3 THEN DO:
      {src/adm2/delrecst.i &num=THIRD}
    END.
    WHEN 4 THEN DO:
      {src/adm2/delrecst.i &num=FOURTH}
    END.
    WHEN 5 THEN DO:
      {src/adm2/delrecst.i &num=FIFTH}
    END.
    WHEN 6 THEN DO:
      {src/adm2/delrecst.i &num=SIXTH}
    END.
    WHEN 7 THEN DO:
      {src/adm2/delrecst.i &num=SEVENTH}
    END.
    WHEN 8 THEN DO:
      {src/adm2/delrecst.i &num=EIGHTH}
    END.
    WHEN 9 THEN DO:
      {src/adm2/delrecst.i &num=NINTH}
    END.
    WHEN 10 THEN DO:
      {src/adm2/delrecst.i &num=TENTH}
    END.
    WHEN 11 THEN DO:
      {src/adm2/delrecst.i &num=ELEVENTH}
    END.
    WHEN 12 THEN DO:
      {src/adm2/delrecst.i &num=TWELFTH}
    END.
    WHEN 13 THEN DO:
      {src/adm2/delrecst.i &num=THIRTEENTH}
    END.
    WHEN 14 THEN DO:
      {src/adm2/delrecst.i &num=FOURTEENTH}
    END.
    WHEN 15 THEN DO:
      {src/adm2/delrecst.i &num=FIFTEENTH}
    END.
    WHEN 16 THEN DO:
      {src/adm2/delrecst.i &num=SIXTEENTH}
    END.
    WHEN 17 THEN DO:
      {src/adm2/delrecst.i &num=SEVENTEENTH}
    END.
    WHEN 18 THEN DO:
      {src/adm2/delrecst.i &num=EIGHTEENTH}
    END.
  END CASE.

  RETURN lRet.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

