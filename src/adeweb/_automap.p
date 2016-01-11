&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************
* Copyright (C) 2000,2013 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
************************************************************************/

/*--------------------------------------------------------------------------
    File        : _automap.p
    Purpose     : Automap _U and _HTM records from Browse OR treeview.  
    Syntax      : SUBSCRIBE "AB_refreshfields":U ANYWHERE.    
                  RUN automap.p 
                  
    Description : Logic on how to pick tables and do to the mapping is copied 
                  directly from WebSpeed V1 mapping browser.    
                                       
                  This procedure is started from a query or a procedure 
                  that has _U and _HTM tables for a WebObject. 
                  
                  It PUBLISHes "AB_refreshfields" to notify others that 
                  mapping can be shown. 
                  
                  The calling procedures should SUBSCRIBE to "AB_refreshfields" 
                  with a procedure that redisplays the _U and _HTM records.    

    Author(s)   : Haavard Danielsen
    Created     : 3/19/98 
    Notes       : This procedure is only partly dynamic.
                  It defines the UIB temp tables buffers and 
                  physically FINDS them using the recids from whoever starts it.   
                                    
                  If the SOURCE-PROCEDURE have a query:
                  ------------------------------------
                    It gets the query HANDLE using getQueryHandle function.
                    Buffer handles are set from the query handle. 
                    
                    The query MUST have _U (NO BUFFER) for the fields !! 
                    
                    _U and _HTM are found using the buffers RECID attribute.   
                                      
                  If the SOURCE-PROCEDURE DON'T have a query (ie _tview.p)
                  --------------------------------------------------------
                    It uses getFieldRecids to get a list of recids. 
                   
                  getNext getFirst functions encapsulates necessary logic to 
                  read the right records.
    Changed     : 4/7/98 HD 
                  Added logic for remote SDO info.
                  A call to get-sdo-hdl creates the persistent sdo if its 
                  the first time in this context. 
                  By using the SOURCE-PROCEDURE as input to that function 
                  the SDO will stay alive until the SOURCE-PROCEDURE
                  calls shutdown-sdo.
                  The SOURCE handle is also added to a local global variable
                  so that _dbfsel can fetch it thru getDataSourceHandle.
            NOTE: Because the SDO remote pretender runs a HTTP OCX that 
                  requires a wait-for, this part must be kept outside of the 
                  get-sdo-hdl function, this is solved by RUN initializeObject 
                  in the SDO if its remote. 
                 (We might consider making a get-sdo-hdl procedure instead,
                  but I did not know where to put it)                                                    
  ----------------------------------------------------------------------*/
/*       This .W file was created with the Progress AppBuilder.         */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{adeuib/uniwidg.i}
{adeweb/htmwidg.i}
{adeuib/sharvars.i}
{adecomm/oeideservice.i}
/* local global variables */
DEFINE VARIABLE gSourceHdl     AS HANDLE    NO-UNDO.
DEFINE VARIABLE gUHdl          AS HANDLE    NO-UNDO.
DEFINE VARIABLE gHTMHdl        AS HANDLE    NO-UNDO.
DEFINE VARIABLE gQueryHdl      AS HANDLE    NO-UNDO.
DEFINE VARIABLE gRecidList     AS CHARACTER NO-UNDO.
DEFINE VARIABLE gSDOColumns    AS CHARACTER NO-UNDO.
DEFINE VARIABLE gDBName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE gTables        AS CHARACTER NO-UNDO.
DEFINE VARIABLE gDataObject    AS CHARACTER NO-UNDO.
DEFINE VARIABLE gDataObjectHdl AS HANDLE    NO-UNDO.
DEFINE VARIABLE gcurrentProc   AS INTEGER   NO-UNDO.
DEFINE VARIABLE gUseDB         AS LOGICAL   NO-UNDO.
define variable gideErrorFlag as logical no-undo.
/* Reusable local variables */
DEFINE VARIABLE ok           AS LOGICAL   NO-UNDO.
DEFINE VARIABLE i            AS INTEGER   NO-UNDO.
DEFINE VARIABLE Hdl          AS HANDLE    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FindHtm Procedure 
FUNCTION FindHtm RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataObjectHandle Procedure 
FUNCTION getDataObjectHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetDataType Procedure 
FUNCTION GetDataType RETURNS CHARACTER
  (pTable AS CHAR,
   pName  AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetFirst Procedure 
FUNCTION GetFirst RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetNext Procedure 
FUNCTION GetNext RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* When going persistent this logic must be changed. 
*/
  
/* The function getQueryhandle must exist in the caller 
   if we shall get its buffers from the query */   
ASSIGN 
  gQueryHdl  = DYNAMIC-FUNCTION("getQueryHandle":U IN SOURCE-PROCEDURE)
  NO-ERROR.
  
/** If we're talking to a query we must get the buffer handles*/

IF VALID-HANDLE(gQueryHdl) THEN
DO i = 1 TO gQueryHdl:NUM-BUFFERS:
  ASSIGN 
    Hdl = gQueryHdl:GET-BUFFER-HANDLE(i).        
  
  /* The use of NAME is because the query has two buffer for _U  
     The query MUST have _U for the fields */
  IF Hdl:NAME = "_U":U THEN  
    gUhdl = Hdl.
  ELSE 
  IF Hdl:TABLE = "_HTM":U THEN
    gHTMHdl = Hdl.       
END.
/* If not query  Get the list of  _U Recids */ 
ELSE   
 ASSIGN
   gRecidList = DYNAMIC-FUNCTION("getFieldRecids":U IN SOURCE-PROCEDURE)
   NO-ERROR
 .
/* 
We will have an error if getqueryhandle or getfieldrecid does not exist.
If that's the case get out of here */
    
IF ERROR-STATUS:ERROR THEN RETURN.

/* Get context id of procedure */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT gCurrentProc).


ok = NUM-DBS > 0.  
IF NOT ok AND NOT _remote_file THEN 
DO:
  RUN adecomm/_dbcnnct.p
     ("You must have at least one connected database to map HTML fields to database fields.",
  OUTPUT ok).    

  IF NOT ok THEN RETURN.
END.

 /* Get the SmartDataObject procedure name */ 
RUN adeuib/_uibinfo.p (INT(gCurrentProc),"":U, "DataObject":U, OUTPUT gDataObject).
ASSIGN gUsedb = gDataObject = "":U.
IF gUseDB THEN
DO:
  RUN setTables NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN.
END.
ELSE
DO:
 
 /*** 
 Using SOURCE-PROCEDURE as the input parameter to get-sdo-hdl   
 Links the SDO to the the procedure that calls this or reuse it if someone already
 has done it.  
 
 The SOURCE-PROCEDURE calls shutdown-sdo(this-procedure) at closing time.   
 
 This makes it possible to use the same sdo or sdo info for repeated 
 automappings and also when mapping a single field  
 in _dbfsel called from the SOURCE-PROCEDURE.      
 */ 
 ASSIGN
   gDataObjectHdl = DYNAMIC-FUNC("get-sdo-hdl" IN _h_func_lib, 
                                   gDataObject,
                                   SOURCE-PROCEDURE).
 /* 
 initializeObject cannot be run from the function 
 because it calls the  ocx http procedure which must have a wait-for. 
 */
     
 IF _remote_file THEN
 DO: 
   RUN initializeObject IN gDataObjectHdl NO-ERROR.
   IF ERROR-STATUS:ERROR THEN RETURN.
 END.  
 gSDOColumns = DYNAMIC-FUNC('getDataColumns' IN gDataObjectHdl).
 
 RUN MapFields.
END.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-chooseTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chooseTable Procedure
procedure chooseTable:
   define variable ideevent as adeuib.iideeventservice no-undo.
   if OEIDE_CanLaunchDialog() then    
   do:
       ideevent = new adeuib._ideeventservice(). 
       ideevent:SetCurrentEvent(this-procedure,"doChooseTable").
       run runChildDialog in hOEIDEService (ideevent) .
       wait-for "u2" of this-procedure.
       if gideErrorFlag then 
          return error. 
   end.
   else do:
       run doChooseTable no-error.
       if error-status:error then
           return error. 
   end.
end procedure.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ENDIF


&IF DEFINED(EXCLUDE-doChooseTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doChooseTable Procedure
procedure doChooseTable:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
     if OEIDE_CanLaunchDialog() then 
     do:
         RUN adeuib/ide/_dialog_tblsel.p 
                  (TRUE, /* Multi */
                   ?, 
                   INPUT-OUTPUT gDbName, /* _db_name */  
                   INPUT-OUTPUT gTables, /* _fl_name */
                   OUTPUT Ok).
         IF NOT OK OR gTables = ? THEN
         do:
             gideErrorFlag = true.
         end.           
     end.    
     else do:
         RUN adecomm/_tblsel.p
                 (TRUE, /* Multi */
                   ?, 
                   INPUT-OUTPUT gDbName, /* _db_name */  
                   INPUT-OUTPUT gTables, /* _fl_name */
                   OUTPUT Ok).
    
        IF NOT OK OR gTables = ? THEN
        do:
            RETURN ERROR.
        end.  
    end.  
    run MapFields.
    
    finally:
       if OEIDE_CanLaunchDialog() then 
           apply "u2" to this-procedure.
    end.   
end procedure.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ENDIF


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MapFields Procedure 
PROCEDURE MapFields :
/*------------------------------------------------------------------------------
  Purpose:    Automatic mapping of HTMl fields 
              The basic logic with a transaction is copied from Webspeed v1.
              The transaction makes it possible to undo all the mappings.                      
  Parameters: 
  Notes:      PUBLISH AB_refreshfields may be done twice.
              1. Always before the user is prompted to keep the changes so that 
                 the mappings can be shown in the calling object. 
              2. If the user cancels the mappings.  
                 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE NumMapped   AS INTEGER  INITIAL ?.  /* UNDO !! */
  DEFINE VARIABLE TableList   AS CHAR      NO-UNDO. 
  DEFINE VARIABLE TableName   AS CHAR      NO-UNDO. 
  DEFINE VARIABLE MapName     AS CHAR      NO-UNDO. 
  DEFINE VARIABLE MapTable    AS CHAR      NO-UNDO. 
  DEFINE VARIABLE SDOTable    AS CHAR      NO-UNDO. 
  DEFINE VARIABLE HandleList  AS CHAR      NO-UNDO. 
  DEFINE VARIABLE MapDataType AS CHAR      NO-UNDO. 
  DEFINE VARIABLE Msg         AS CHAR      NO-UNDO. 
  define variable Msg2        as character no-undo.
  DEFINE VARIABLE i           AS INT       NO-UNDO. 
  RUN adecomm/_setcurs.p ("WAIT"). /* Set the cursor pointer in all windows */
  
  Transblock:
  DO TRANSACTION
     ON STOP   UNDO, LEAVE
     ON ERROR  UNDO, LEAVE
     ON ENDKEY UNDO, LEAVE:
    
    NumMapped = 0. /* distinguish between unknown and 0 to check if undone */     
    IF getFirst() THEN 
    DO WHILE TRUE:
      /* Do this only for unmapped fields */ 
      IF (_U._TABLE = ?) THEN
      DO:         
        /* Try to get the table name from the HTML name 
           Don't do that for dataObjects (currently) */        
        IF gUseDB THEN
          ASSIGN 
             TableList = gTables.       
          ELSE  
            ASSIGN TableList = "RowObject":U
                   gDbname   = "Temp-tables":U.
               
        /* 
        By using the last entry in a dot list, we are guaranteed to get
        what we think is the field name. 
        */        
        ASSIGN 
           MapName  = ENTRY(NUM-ENTRIES(_HTM._HTM-NAME, ".":u),
                                 _HTM._HTM-NAME, ".":u)
             /* The maptable is already in the tablelist from gtables 
                (updated in setTables)
                We check it here to avoid running dbfsel for another table.
                (the logic could need some improvements....) */
           
           MapTable  = IF NUM-ENTRIES(_HTM._HTM-NAME, ".":u) = 2
                       THEN TRIM(ENTRY(1,_HTM._HTM-NAME,".":u))
                       ELSE "":U.              
                                
                           
        DO i = 1 TO NUM-ENTRIES(TableList) ON ERROR UNDO, NEXT:           
          
          /* if SDO and table found in HTML check if its the right one. */                       
          IF  NOT gUseDb 
          AND MapTable <> "":U THEN 
          DO: 
            ASSIGN
              SdoTable = DYNAMIC-FUNC('columnTable' IN gDataObjectHdl,Mapname).
              IF MapTable <> SdoTable THEN LEAVE. /*--------------------------->*/
          END.
       
          ASSIGN 
            TableName   = ENTRY(i,TableList)           
            MapDataType = getDataType(TableName,Mapname).
                        
          /* If DB maptable must match tablename if not blank */ 
          IF  (NOT gUseDb OR MapTable = "" OR MapTable = TableName)                    
          AND _U._DEFINED-BY <> "User"
          AND (MapDataType <> "")
          THEN
          DO:
          
            FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
            
           /* We can map a fill-in to a db field regardless of data-type. 
              All other field objects must match the data-types. 
              If they match, we found the db.table.field specified, so map it. */        
                       
            IF (_U._TYPE = "FILL-IN":U) 
               OR (MapDataType = _F._DATA-TYPE) THEN
            DO:
            
             /* Since _dbfsel.p uses the current _U values to map the field,
                we must assign these value now for the call to _dbfsel.p to
                work properly. */
                        
              ASSIGN _U._DBNAME = gDbName
                     _U._TABLE  = TableName
                     _U._NAME   = MapName.
              
              RUN adeweb/_dbfsel.p
                 (INPUT _U._HANDLE, INPUT "_SELECT-AUTO":u).
              
              ASSIGN 
                NumMapped  = NumMapped + 1
                HandleList = HandleList 
                             + IF HandleList = "":U THEN "":U ELSE ",":U
                             + STRING(_U._HANDLE).
               LEAVE.
          
            END. /* if (_U._TYPE = "FILL-IN":U) OR (MapDataType = _F._DATA-TYPE)*/  
          END. /* if mapdatatype <> "" */              
        END. /* do i = 1 to num-entries */                   
      END. /* If _u._table = ? */ 
        
      IF NOT getNext() THEN LEAVE.
    END. /* do while true */
    CASE NumMapped:
      WHEN 0 THEN
        ASSIGN Msg = "No HTML fields could be mapped to database fields.":T.
      WHEN 1 THEN
        ASSIGN Msg = "1 HTML field was mapped to a database field.":T.
      OTHERWISE
        ASSIGN Msg = SUBSTITUTE
                      ("&1 HTML fields were mapped to &2.":T,
                       STRING(NumMapped),
                       IF gUSEDb THEN "database fields":T
                       ELSE           "the SmartDataObject":T 
                       ).  
                       
    END CASE.    
    
    IF NumMapped > 0 THEN
    DO ON STOP   UNDO, LEAVE
       ON ERROR  UNDO, LEAVE
       ON ENDKEY UNDO, LEAVE:
    
       PUBLISH "AB_RefreshFields":U.
       msg2 =  Msg + "~n~n" +
               "Choose OK to accept the mappings or Cancel to undo them.".
       if OEIDE_CanShowMessage() then
           Ok = ShowMessageInIDE(msg2,"QUESTION",?,"OK-Cancel",ok).
       
       else      
           MESSAGE msg2
              VIEW-AS ALERT-BOX QUESTION BUTTONS OK-Cancel
                      UPDATE OK IN WINDOW ACTIVE-WINDOW.
       IF NOT OK THEN 
       DO:         
         /*** 
         RUN adecomm/_setcurs.p ("WAIT"). /* Set the cursor pointer in all windows */
           DO handle-num = 1 TO NUM-ENTRIES(handle-list):
              RUN adeweb/_dbfsel.p
                  (INPUT WIDGET-HANDLE(ENTRY(handle-num, handle-list)), INPUT "_DESELECT":u).
           END
         ****/
         UNDO TransBlock, LEAVE TransBlock.             
            
       END.
    END.  
  END. /* Do trans */
  RUN adecomm/_setcurs.p ("":U).  
  
  IF NumMapped  = ? THEN   
    PUBLISH "AB_RefreshFields":U.
     
  IF NumMapped = 0 THEN
  do:
      if OEIDE_CanShowMessage() then
          ShowOkMessageInIDE(Msg,"INFORMATION",?).
      else       
          MESSAGE Msg VIEW-AS ALERT-BOX INFORMATION IN WINDOW ACTIVE-WINDOW.
   end.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetTables Procedure 
PROCEDURE SetTables :
/*------------------------------------------------------------------------------
  Purpose:   Set the tables that are to be used for automapping    
  Parameters: 
  Notes:     The logic with comments is brought unchanged from Webspeed version 1.     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE Info        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ix          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE QueryTables AS CHARACTER NO-UNDO.
  DEFINE VARIABLE TableList   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE TableName   AS CHARACTER NO-UNDO.
  
  gDbName = LDBNAME("DICTDB":U).
  
  IF GetFirst() THEN 
  DO WHILE TRUE:
     /* Do NOT try to map if:
      - No HTML field corresponds to the _U.
      - Field is mapped to a table in a db that is not the current db (???) What ?
      - HTML Name is not in the form table.field.
     */
    IF   AVAILABLE _HTM 
    AND (NUM-ENTRIES(_HTM._HTM-NAME, ".":u) > 1)
    AND (_U._DBNAME <> ? AND _U._DBNAME <> gdbName) = FALSE THEN
    DO:            
      ASSIGN TableName = _U._TABLE
             TableName = IF (TableName = ?) AND
                            (NUM-ENTRIES(_HTM._HTM-NAME, ".":u) = 2)
                         THEN ENTRY(1, _HTM._HTM-NAME, ".":u)
                         ELSE TableName.
 
      IF (TableName <> ?) AND (LOOKUP(TableName, gTables) = 0) THEN
         ASSIGN gTables = gTables + TableName + ",":u.
    END.   
    IF NOT GetNext() THEN LEAVE.
  END.
 
  /* Load query tables. */
  RUN adeuib/_uibinfo.p (gCurrentProc, "":U, 
        "CONTAINS QUERY RETURN CONTEXT":U, OUTPUT Info).
  
  IF Info <> "":U THEN
    RUN adeuib/_uibinfo.p(INT(Info), ?, "TABLES":U, OUTPUT QueryTables).  
  
  DO ix = 1 TO NUM-ENTRIES(QueryTables):
    ASSIGN
      TableName = ENTRY(ix, QueryTables)
      TableName = ENTRY(NUM-ENTRIES(TableName, ".":U), TableName, ".":U).
    
    IF LOOKUP(TableName, gTables) = 0 THEN
      ASSIGN gTables = gTables + TableName + ",":u.
  END.
  ASSIGN gTables = TRIM(gTables, ",":u).
  
  IF gTables eq "" THEN
  DO:
     run chooseTable no-error.
     if error-status:error then
         return error. 
  END.
  else 
     run MapFields.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FindHtm Procedure 
FUNCTION FindHtm RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Find the _HTM record of the current _U 
    Notes: If the _U are read from a query the _HTM record also comes from that
           query            
           (Would it have been better not to ?)     
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(gHTMHdl) THEN
    FIND _HTM WHERE RECID(_HTM) = gHTMhdl:RECID NO-ERROR.
  ELSE  
  IF AVAIL _U THEN                 
    FIND _HTM  WHERE _HTM._U-RECID = RECID(_U) NO-ERROR.
  ELSE 
    RELEASE _HTM.
     
  RETURN AVAIL _HTM.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataObjectHandle Procedure 
FUNCTION getDataObjectHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Used by _dbfsel to get the handle that are the owner of the SDO. 
    Notes:  
------------------------------------------------------------------------------*/
  RETURN gDataObjectHdl.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetDataType Procedure 
FUNCTION GetDataType RETURNS CHARACTER
  (pTable AS CHAR,
   pName  AS CHAR):
/*------------------------------------------------------------------------------
  Purpose: Return datatype     
    Notes: The automapping logic is based on this function returning ''
           for non matching fields.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE DataType   AS CHAR   NO-UNDO.
  
  IF gUseDb THEN 
    RUN adeshar/_fldtype.p
               (gDbName + ".":u + pTable + ".":u + pName,
                OUTPUT DataType).
  ELSE DO:  
    IF CAN-DO(gSDOColumns,pName) THEN
      DataType = DYNAMIC-FUNC("columnDataType" IN gDataObjectHdl, pName).
    ELSE 
      DataType = "":U.
      
  END.             
  RETURN DataType.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetFirst Procedure 
FUNCTION GetFirst RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Get first _U.     
    Notes: Get the first _U from a query handle or a list of recids. 
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(gQueryHdl) THEN 
  DO:
     gQueryHdl:get-first.
     FIND _U WHERE RECID(_U) = gUHdl:RECID NO-ERROR.
  END.
  ELSE
  DO:
    FIND _U WHERE RECID(_U) = INT(ENTRY(1,gREcidList)) NO-ERROR.                  
  END.
  FindHTM().   
  RETURN AVAILABLE _U .   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetNext Procedure 
FUNCTION GetNext RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Get next _U.     
    Notes: Get the next _U from a query handle or a list of recids. 
------------------------------------------------------------------------------*/
  DEF VAR CurrentRecid AS INT NO-UNDO.
  DEF VAR CurrentNum   AS INT NO-UNDO.
   
  IF VALID-HANDLE(gQueryHdl) THEN 
  DO:
     gQueryHdl:get-next. 
     FIND _U WHERE RECID(_U) = gUHdl:RECID NO-ERROR.
  END. 
  ELSE
  DO:
    ASSIGN
      CurrentRecid = IF AVAIL _U 
                     THEN RECID(_U)
                     ELSE ?.
      CurrentNum   = IF CurrentRecid = ? 
                     THEN  0
                     ELSE LOOKUP(STRING(CurrentREcid),gREcidList).
    
    FIND _U WHERE RECID(_U) = IF CurrentNum = NUM-ENTRIES(gREcidList) 
                              THEN ? 
                              ELSE INT(ENTRY(CurrentNum  + 1,gREcidList))
                              NO-ERROR.                   
    
  END.
  
  FindHTM().
  RETURN AVAILABLE _U.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

