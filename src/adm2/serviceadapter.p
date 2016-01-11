&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/
/* Copyright (c) 2005 by Progress Software Corporation      */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : adm2/serviceadapter.p
    Purpose     : Data request service adapter interface
    Notes       : This is a template stub procedure to show the required
                  APIs for the service adapater.  Logic must be implemented
                  in these APIs to interact with an OERA service interface
                  implementation.    
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getObjectType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectType Procedure 
FUNCTION getObjectType RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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
         HEIGHT             = 6.52
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */ 
&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure
PROCEDURE destroyObject:
/*------------------------------------------------------------------------------
    Purpose:
    Parameters: <none>
    Notes:
------------------------------------------------------------------------------*/
  delete procedure this-procedure.
END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveData Procedure 
PROCEDURE retrieveData :
/*------------------------------------------------------------------------------
  Purpose:  Retrieve data or definitions for one or many Business Entities 
            from a service interface proxy. 
            The caller specifies the number of entities that need to be handled 
            by the request by defining a finite number of extents for the array 
            parameters.   
Parameters:  
         pcEntity 
               This uniquely identifies a Business Entity in the Service 
               Interface. The same name can be used multiple times in a given 
               request in order to request multiple instances of a specific
               Entity. 
               Each Business Entity is expected to define a single prodataset,
               but other than that there is no requirement to how or where the 
               actual physical Entity is implemented. 
         pcTables 
               Tables for which to retrieve data or definitions, specified as a 
               comma separated list. The names must match the physical name of 
               the temp-table definitions of the prodataset that corresponds to 
               the Business Entity.      
         pcQueries 
               A chr(1) separated list of queries that corresponds to 
               the requested tables. An empty entry means use default query.
               Special values:
                'DEFS' - no query, only defintions requested.
         pcJoins 
               A chr(1) separated list of join fields for the requested tables,
               in the form of ForeignFields. Included in this  parameter, if 
               applicable, is the element number of the Business Entity the 
               foreign field is contained in, relative to the current request. 
             - The join limits the query of this table to the records that are 
               children of the parent table as specified in a comma separated 
               paired list where this table's field(s) is/are the first entry 
               of each pair and the parent's field is/are the second entry of 
               each pair. 
               
               e.g. <thistable.field,othertable.field> 
                 
             - Joins across Entities are specified by a third qualifier on the 
               parent field name that specifies the array number of the parent 
               Entity.
               
               e.g. order.custnum,1.customer.custnum   
                
               In this above example the order is joined to the customer table 
               in the first Entity of this request.
               
             - The ADM will set this from the prodataset relation, so the 
               parameter is typically not important for relationships within the
               same prodataset. 
             - A blank entry means that the table is not to be joined in this 
               request.   
         pcPositions
               A chr(1) separated list of positions for the requested tables.
               Positions specifies how to find a single record in a table from 
               a child of this table where the child is used to filter or find 
               the parent record. This is specified as a comma separated paired 
               list where this table's field(s) is/are the first entry of each 
               pair. 
               
               e.g. <thistable.field,othertable.field>
                 
             - Positioning across Entities are specified by a third qualifier on 
               the parent field name that specifies the array number of the 
               other Entity.
                 
               e.g. salesrep.salesrep.1.order.salesrep   
                
               In this above example the salesrep is found from the order 
               records of the first Entity of the request.
                
         pcRequest 
               Specifies the actual request that corresponds to the table in 
               a chr(1) delimited list. 
               Valid values:
                FIRST - Start retrieving from the first record.
                NEXT  - Start retrieving from the record that is the next record
                        from what is currently the last. The BatchContext 
                        parameter has the information to where the next 
                        position actually starts.
                PREV  - Start retrieving from the record that is the previous
                        record from what is currently the first. The BatchContext 
                        parameter has the information to where the previous 
                        position actually starts.
                LAST  - Start retrieve so that the last record is included in 
                        the batch. 
                WHERE <query expression>  
                      - Start retrieving on the first record that satisfies
                        the specified criteria. 
                ALL   - Retrieve all records as defined by join.
                        Retrieve all records that are related to all parents in 
                        this request. This corresponds to the default FILL 
                        behavior of a prodataset parent-child relation. 
         pcBatchContext 
                Specifies the position info for a batch request. 
                The passed values are the values previously returned by this 
                API's pcStartPositions or pcEndPositions output parameters.    
              - These values are not used for any logic on the client and can in 
                principle have any content. The use of ROWIDs as context fits 
                with PRODATASET attributes like START-ROWID and NEXT-ROWID, but
                ROWIDS are not suited as context in a Progress database where 
                records may get deleted. Consider using context-ids that can be 
                used to refind context info stored on the server or just use the
                actual logical query expression that defines the record that is 
                the next or prev.                    
              - This parameter is NOT defined as extent, since it only applies 
                to the first table of the request. 
         plFillBatch 
                Set to yes if the request should read a full batch size  or all 
                data even if the context says otherwise. 
              - This can only be yes for clients that empties all data before 
                retrieval of the next batch and is currently only set to yes
                in ADM when the pcRequest begins with WHERE.    
              - This may be necessary for certain UI components, like the browser
                to behave correctly. A browser that has fewer records than fits 
                the viewport will not enable the scrollbar and prevent the user 
                from navigating backwards.
         pcNumRecords 
                Specifies the batch size that corresponds to each table in 
                a comma-separated list. The parameter is  also intended to 
                return the actually retrieved number of records, although this 
                is not currently used actively in the ADM.               
         pcHandles 
                Prodataset handles.    
                Unknown is passed on the first request. 
         pcContext 
                Other context CHR(1) separator per table. The context for 
                each table must be chr(4) delimited pairs of property name
                and value. The output value will be applied to the set<Prop>
                function in the DataView for the corresponding DataTable.  
                The input is from the DataView's obtainContextForServer, which
                has no default.                 
         pcPrevContext
                Specifies the prev record that was NOT returned to the 
                client. 
              - The ADM only differentiates between no value and some value to 
                be able to know if there is more records to retrieve, but the
                actual values are not used for on the client and can in 
                principle have any content. The use of ROWIDs as context fits 
                with PRODATASET attributes like START-ROWID and NEXT-ROWID, but
                ROWIDS are not safe as context in progress databases where 
                records may get deleted. Consider using context-ids that can be 
                used to refind context info stored on the server or just use the
                actual logical query expression that defines the record that is 
                prev.   
              - Special values
                'FIRST' or blank means that the first record is included in the 
                request and that there is no more data on the server in a 
                backwards direction.
              - The implementer needs to fix the number of extents in this 
                parameter to that of the pcEntity parameter, noted above.
         pcNextContext
                Specifies the next record that was NOT returned to the client. 
              - The ADM only differentiates between no value and some value to 
                be able to know if there is more records to retrieve, but the
                actual values are not used for on the client and can in 
                principle have any content. The use of ROWIDs as context fits 
                with PRODATASET attributes like START-ROWID and NEXT-ROWID, but
                ROWIDS are not safe as context in progress databases where 
                records may get deleted. Consider using context-ids that can be 
                used to re-find context info stored on the server or just use the
                actual logical query expression that defines the record that is 
                next by the use of true keys. (eg. order.ordernum = 55)    
              - Special values
                 'LAST' or blank means that the last record is included in the 
                 request and that there is no more data on the server in a 
                 forward direction.
              - The implementer needs to fix the number of extents in this 
                parameter to that of the pcEntity parameter, noted above.
                                        
  Notes: This is an API stub that has the required parameters needed by the
         ADM2 to interact with an OERA service interface implementation.
      -  The mentioned table delimiters are defaults that can be overidden by 
         adding the following functions to this service adapter. 
         - getTableDelimiter   - Return the delimiter to use instead of comma 
                                 delimiter; pcTables, pcNumRecords and 
                                 pcPrevContext and pcNextContext. 
         - getRequestDelimiter - Return the delimiter to use instead of chr(1) 
                                 delimiter; pcQueries, pcJoins, pcPositions,
                                 pccontext                                  
------------------------------------------------------------------------------*/
/* Business Entity reference */
DEFINE INPUT         PARAMETER pcEntity     AS CHARACTER     NO-UNDO EXTENT.

/* Data table request info */
DEFINE INPUT         PARAMETER pcTables        AS CHARACTER  NO-UNDO EXTENT.
DEFINE INPUT         PARAMETER pcQueries       AS CHARACTER  NO-UNDO EXTENT.
DEFINE INPUT         PARAMETER pcJoins         AS CHARACTER  NO-UNDO EXTENT.
DEFINE INPUT         PARAMETER pcPositions     AS CHARACTER  NO-UNDO EXTENT.
DEFINE INPUT         PARAMETER pcRequest       AS CHARACTER  NO-UNDO EXTENT.

DEFINE INPUT         PARAMETER pcBatchContext  AS CHARACTER  NO-UNDO.
DEFINE INPUT         PARAMETER plFillBatch     AS LOGICAL    NO-UNDO.

DEFINE INPUT-OUTPUT  PARAMETER pcNumRecords    AS CHARACTER  NO-UNDO EXTENT.
/* data ref */
DEFINE INPUT-OUTPUT  PARAMETER phHandles       AS HANDLE     NO-UNDO EXTENT. 
DEFINE INPUT-OUTPUT  PARAMETER pcContext       AS CHARACTER  NO-UNDO EXTENT.

DEFINE OUTPUT        PARAMETER pcPrevContext   AS CHARACTER  NO-UNDO EXTENT.
DEFINE OUTPUT        PARAMETER pcNextContext   AS CHARACTER  NO-UNDO EXTENT.

EXTENT(pcPrevContext) = EXTENT(pcEntity).
EXTENT(pcNextContext) = EXTENT(pcEntity).

MESSAGE
  'The Service Adapter received a request for Business Entity "':U +
   pcEntity[1] + 
   '". In order to make this work you must add implementation logic for several APIs to adm2/serviceadapter.p.' +
   '  Refer to the template adm2/serviceadapter.p procedure shipped with the product and to ' + 
   'the documentation on ADM2 integration with OERA compliant business logic.'
    VIEW-AS ALERT-BOX WARNING BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE submitData Procedure 
PROCEDURE submitData :
/*------------------------------------------------------------------------------
  Purpose:     Interface for submit of changes
  Parameters:  <none>
             pcEntity 
               This uniquely identifies a Business Entity in the Service 
               Interface. The same name can be used multiple times in a given 
               request in order to request multiple instances of a specific
               Entity. 
               Each Business Entity is expected to define a single prodataset,
               but other than that there is no requirement to how or where the 
               actual physical Entity is implemented. 
             pcHandles 
               Prodataset handle.           
            pcContext 
                Other context. 
                 
  Notes:       This is an API stub that has the required parameters needed by the
               ADM2 to interact with an OERA service interface implementation.
------------------------------------------------------------------------------*/
  DEFINE INPUT         PARAMETER pcEntity     AS CHARACTER  NO-UNDO EXTENT.
  DEFINE INPUT-OUTPUT  PARAMETER phHandles    AS HANDLE     NO-UNDO EXTENT.
  DEFINE INPUT-OUTPUT  PARAMETER pcContext    AS CHARACTER  NO-UNDO EXTENT.

  MESSAGE
    'The Service Adapter received a request for Business Entity "':U +
     pcEntity[1] + 
     '". In order to make this work you must add implementation logic for several APIs to adm2/serviceadapter.p.' +
     '  Refer to the template adm2/serviceadapter.p procedure shipped with the product and to ' + 
     'the documentation on ADM2 integration with OERA compliant business logic.'
      VIEW-AS ALERT-BOX WARNING BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getObjectType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectType Procedure 
FUNCTION getObjectType RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:   
    Notes:  
------------------------------------------------------------------------------*/
  RETURN "Service". 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

