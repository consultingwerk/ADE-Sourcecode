&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
/* Procedure Description
"Method Library for db query objects."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
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
 
/* Include smart or appserver (which includes smart). 
   Appserver aware objects includes adecomm/appserv.i and defines this 
   preprocessor */ 
&IF DEFINED(APP-SERVER-VARS) = 0 &THEN  
  {src/adm2/smart.i}
&ELSE
  {src/adm2/appserver.i}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

  DEFINE VARIABLE cMode AS CHARACTER NO-UNDO.

  RUN start-super-proc("adm2/query.p":U).
  RUN start-super-proc("adm2/queryext.p":U).
  /* sboext.p is merely a simple "extension" of query.p.  This was necessary
     because functions don't have their own action segement and query.p got
     too big on AS400.  All of the functions in queryext.p are get and set 
     property functions.  */

  RUN initProps IN TARGET-PROCEDURE.

  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
  {src/adm2/custom/querycustom.i}
  /* _ADM-CODE-BLOCK-END */

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
  DEFINE VARIABLE cQueryString    AS CHARACTER NO-UNDO.

  /* New for 9.1D to allow storage of this in the client SDO so the one-hit 
     appserver can be utilized also oat initialization */

  cQueryString = '{&QUERY-STRING-{&QUERY-NAME}}':U.

 /* Server side logic */ 
&IF DEFINED(OPEN-QUERY-{&QUERY-NAME}) NE 0 &THEN

  DEFINE VARIABLE hQuery         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cOpenQuery     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDBNames       AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cKeyTableEntityFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyTableEntityValues   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyTableEntityMnemonic AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyTableEntityObjField AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lHasObjectField         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iLookup                 AS INTEGER    NO-UNDO.
  
  ASSIGN hQuery = QUERY {&QUERY-NAME}:HANDLE.   /* Database query */
  
  /* Initialize the list of buffer handles for the tables in the db query,
     which is used to build the "RowIdent" key passed to clients. 
     Also initialize DBNames, which is used to forgive developers that
     use db-qualified calls to non-db-qualified SDOs and vice/versa */
  DO iTable = 1 TO hQuery:NUM-BUFFERS:
    ASSIGN 
      hBuffer  = hQuery:GET-BUFFER-HANDLE(iTable)
      cBuffers = cBuffers + (IF iTable = 1 THEN "":U ELSE ",":U) 
                          + STRING(hBuffer)
      cDBNames = cDBNames + (IF iTable = 1 THEN "":U ELSE ",":U) 
                          + hBuffer:DBNAME.
  END. /* iTable = 1 to num-buffers */

  {set BufferHandles cBuffers}.
  {set DBNames cDBNames}.  
  {set QueryHandle hQuery}.
  
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
  /* Store the original query in the BaseQuery client property */ 
  {set BaseQuery cQueryString}.
&ENDIF /* client */  

&IF "{&TABLES-IN-QUERY-{&QUERY-NAME}}":U NE "":U &THEN
  /* Define the AssignList property. This takes the ASSIGN-LIST preprocessor,
     which is in the form:
  RowObject.<ROfieldname><space>=<space><DBtable>.<DBfieldname><space><space>...
     and converts it to a series of lists of fields for each table:
  ROfieldname,DBfieldname[,...]CHR(1)...
     This is a form usable by dynamic BUFFER-COPY and BUFFER-COMPARE.
  */
  
  cTables = REPLACE("{&TABLES-IN-QUERY-{&QUERY-NAME}}":U," ":U,",":U).
  {set Tables cTables}. /* List of DB table names */
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
      (IF iTable = 1 THEN "":U ELSE CHR(1)) +
        cTableAssign[iTable].
  END.    /* END DO iTable */

  {set AssignList cAssignList}.

&ENDIF   /* If TABLES-IN-QUERY */

  /* Now set the UpdatableColumns and DataColumnsByTable property to be all 
     the Enabled-Fields and Data-Fields, delimited by CHR(1).
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
 
 {set UpdatableColumnsByTable cUpdCols}.
 {set DataColumnsByTable cDataCols}.
 
/* Is there any calculated fields? */
DO iCount = 1 TO NUM-ENTRIES('{&DATA-FIELDS}',' ':U) 
WHILE  (iNumUpd  < NUM-ENTRIES('{&ENABLED-FIELDS}',' ':U)
        OR 
        iNumData < NUM-ENTRIES('{&DATA-FIELDS}',' ':U)):
  /* All fields are in data-fields so we don't care about enabled-fields */
  cField = ENTRY(iCount,'{&DATA-FIELDS}',' ':U).
  /* Replace the commas with CHR(1) in order to can-do */
  IF NOT CAN-DO(REPLACE(cDataCols,CHR(1),",":U),cField) THEN
  DO:
    ASSIGN 
      cCalcData = cCalcData + (IF cCalcData = "":U THEN "":U ELSE ",") + cField
      iNumData  = iNumData  + 1.
  END. /* not can-do(datacols with commas,cfield) */
  /* Replace the commas with CHR(1) in order to can-do */
  IF  NOT CAN-DO(REPLACE(cUpdCols,CHR(1),",":U),cField) 
  AND LOOKUP(cField,'{&enabled-fields}':U,' ':U) > 0 THEN
  DO:  
    ASSIGN 
      cCalcUpd = cCalcUpd + (IF cCalcUpd = "":U THEN "":U ELSE ",") + cField
      iNumUpd  = iNumUpd + 1.
  END. /* not can-do(updcols with commas,cfield) and lookup(enabled,cfield > 0)*/
END.
/* Put the non-db data at the end of the list 
  (we always add this even if there are no calc fields. This ensures that 
   anyone that looks at this list in an object without calc-fields 
   (can) understand that the num-entries(chr(1)) are higher than num-tables*/ 
 
ASSIGN
  cDataCols = cDataCols + CHR(1) + cCalcData
  cUpdCols  = cUpdCols + CHR(1)  + cCalcUpd.
  
{set UpdatableColumnsByTable cUpdCols}.
{set DataColumnsByTable cDataCols}.

&IF DEFINED(OPEN-QUERY-{&QUERY-NAME}) NE 0 &THEN
/* We do this after updatableColumnsBytable has been set as this 
   will give us the Enabledtables 
   (we still only do it on the server as the to as getEntityDetail is a server 
    procedure) */
  
 {get EnabledTables cKeyTable}.
 /* First enabled .. */
 cKeyTable = ENTRY(1,cKeyTable).
 /* if no enabled use the first table */
 IF cKeyTable = '':U THEN
   cKeyTable = "{&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}".
  

 IF cKeyTable <> "":U
 AND VALID-HANDLE(gshGenManager) THEN  
  /* AND LOOKUP("getEntityDetail":U, gshGenManager:INTERNAL-ENTRIES) > 0 */
 DO:

    RUN getEntityDetail IN gshGenManager
                       (INPUT  cKeyTable,
                        OUTPUT cKeyTableEntityFields,
                        OUTPUT cKeyTableEntityValues) NO-ERROR.

    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
    DO:
      {checkerr.i &display-error = "YES"}
    END.
    IF cKeyTableEntityFields <> "":U THEN 
    DO:
      IF LOOKUP("entity_mnemonic",cKeyTableEntityFields,CHR(1)) <> 0 THEN 
         ASSIGN cKeyTableEntityMnemonic = ENTRY( LOOKUP("entity_mnemonic",cKeyTableEntityFields,CHR(1))    ,cKeyTableEntityValues,CHR(1) ).
 
      IF LOOKUP("table_has_object_field",cKeyTableEntityFields,CHR(1)) <> 0 THEN 
        ASSIGN lHasObjectField = CAN-DO("TRUE,YES",ENTRY( LOOKUP("table_has_object_field",cKeyTableEntityFields,CHR(1)) ,cKeyTableEntityValues,CHR(1) )).
       
      IF lHasObjectField THEN
         IF LOOKUP("entity_object_field",cKeyTableEntityFields,CHR(1)) <> 0 THEN 
           ASSIGN cKeyTableEntityObjField = ENTRY( LOOKUP("entity_object_field",cKeyTableEntityFields,CHR(1)) ,cKeyTableEntityValues,CHR(1) ).
      ELSE
        IF LOOKUP("entity_key_field",cKeyTableEntityFields,CHR(1)) <> 0 THEN 
           ASSIGN cKeyTableEntityObjField = ENTRY( LOOKUP("entity_key_field",cKeyTableEntityFields,CHR(1)) ,cKeyTableEntityValues,CHR(1) ).
      {set KeyTableId cKeyTableEntityMnemonic}.
      {set KeyFields  cKeyTableEntityObjField}.
    END.
 END.
&ENDIF

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
  END CASE.

  RETURN lRet.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

