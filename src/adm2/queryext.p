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
    File        : queryext.p
   Purpose     : Support procedure for Query Object.  This is an extension
                 of query.p.  The extension is necessary to avoid an overflow
                 of the action segment on AS400. This extension file contains
                 all of the get and set property functions. These functions 
                 will be rolled back into query.p when segment size increases.

    Syntax      : adm2/query.p

    Modified    : Jan 22, 2001 Version 9.1C
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
  /* Tell qryprop.i that this is the query super procedure. */
&SCOP ADMSuper query.p

{src/adm2/custom/queryexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getAssignList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAssignList Procedure 
FUNCTION getAssignList RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCheckLastOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCheckLastOnOpen Procedure 
FUNCTION getCheckLastOnOpen RETURNS LOGICAL
 (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataColumns Procedure 
FUNCTION getDataColumns RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataIsFetched) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataIsFetched Procedure 
FUNCTION getDataIsFetched RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDBNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDBNames Procedure 
FUNCTION getDBNames RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getForeignFields Procedure 
FUNCTION getForeignFields RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getForeignValues Procedure 
FUNCTION getForeignValues RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationSource Procedure 
FUNCTION getNavigationSource RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationSourceEvents Procedure 
FUNCTION getNavigationSourceEvents RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOpenOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOpenOnInit Procedure 
FUNCTION getOpenOnInit RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOpenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOpenQuery Procedure 
FUNCTION getOpenQuery RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryHandle Procedure 
FUNCTION getQueryHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryOpen Procedure 
FUNCTION getQueryOpen RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryPosition Procedure 
FUNCTION getQueryPosition RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQuerySort Procedure 
FUNCTION getQuerySort RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryString Procedure 
FUNCTION getQueryString RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryWhere Procedure 
FUNCTION getQueryWhere RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTables Procedure 
FUNCTION getTables RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdatableColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdatableColumns Procedure 
FUNCTION getUpdatableColumns RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseDBQualifier) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUseDBQualifier Procedure 
FUNCTION getUseDBQualifier RETURNS LOGICAL
 (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWordIndexedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWordIndexedFields Procedure 
FUNCTION getWordIndexedFields RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAutoCommit Procedure 
FUNCTION setAutoCommit RETURNS LOGICAL
  ( plCommit AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCheckLastOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCheckLastOnOpen Procedure 
FUNCTION setCheckLastOnOpen RETURNS LOGICAL
 (pCheck AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataIsFetched) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataIsFetched Procedure 
FUNCTION setDataIsFetched RETURNS LOGICAL
  ( plFetched AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDBNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDBNames Procedure 
FUNCTION setDBNames RETURNS LOGICAL
  (pcDBNames AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setForeignFields Procedure 
FUNCTION setForeignFields RETURNS LOGICAL
  ( pcFields AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNavigationSource Procedure 
FUNCTION setNavigationSource RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOpenOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOpenOnInit Procedure 
FUNCTION setOpenOnInit RETURNS LOGICAL
  ( plOpen AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOpenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOpenQuery Procedure 
FUNCTION setOpenQuery RETURNS LOGICAL
  (pcQuery AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryPosition Procedure 
FUNCTION setQueryPosition RETURNS LOGICAL
  ( pcPosition AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQuerySort Procedure 
FUNCTION setQuerySort RETURNS LOGICAL
  ( pcSort AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryString Procedure 
FUNCTION setQueryString RETURNS LOGICAL
  (pcQueryString AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryWhere Procedure 
FUNCTION setQueryWhere RETURNS LOGICAL
  ( pcWhere AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTables Procedure 
FUNCTION setTables RETURNS LOGICAL
  ( pcTables AS CHAR)  FORWARD.

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
         HEIGHT             = 10.81
         WIDTH              = 51.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/qryprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getAssignList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAssignList Procedure 
FUNCTION getAssignList RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the list of updatable columns whose names have been 
              modified in the SmartDataObject.

  Parameters: <none>

  Notes:      This string is of the form:
              <RowObjectFieldName>,<DBFieldName>[,...][CHR(1)...]
              with a comma separated list of pairs of fields for each db table,
              and CHR(1) between the lists of pairs.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cList AS CHARACTER NO-UNDO.
  
  {get AssignList cList}.
  
  RETURN cList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCheckLastOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCheckLastOnOpen Procedure 
FUNCTION getCheckLastOnOpen RETURNS LOGICAL
 (  ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the flag indicating whether a get-last should be performed 
              on an open in order for fetchNext to be able to detect that we are 
              on the last row. This is necessary to make the QueryPosition 
              attribute reliable.   

  Parameters: <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lCheck AS LOGICAL NO-UNDO.
  {get CheckLastOnOpen lCheck}.
  RETURN lCheck.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataColumns Procedure 
FUNCTION getDataColumns RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a comma-delimited list of the columnNames for the 
               SmartDataObject. 
  Parameters:  
       Notes:  Uses the DataColumsByTable property that stores in different 
               tables delimited by CHR(1) instead of comma in order to identify 
               which columns are from which table in the event of a join. 
               For example, if the query is a join of customer and order and 
               the Name field from customer and the OrderNum and OrderData field 
               from Order are selected, then the property value will be equal to
               "Name<CHR(1)>OrderNum,OrderDate".
               This function replaces CHR(1) with "," to return just a 
               comma-delimited list. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumns AS CHARACTER NO-UNDO.
  {get DataColumnsByTable cColumns}.
    
  IF NUM-ENTRIES(cColumns,CHR(1)) > 1 THEN
    cColumns = REPLACE(cColumns,CHR(1),",":U).

  /* There might be empty entries */
  DO WHILE INDEX(cColumns,",,":U) > 0:
    cColumns = REPLACE(cColumns,",,":U,",":U).
  END.
  
  /* There's may also be commas at the ends */ 
  RETURN TRIM(cColumns,",":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataIsFetched) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataIsFetched Procedure 
FUNCTION getDataIsFetched RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
   Purpose: The SBO sets this to true in the SDO when it has fethed 
            data on the SDOs behalf in order to prevent that the SDO does 
            another server call to fetch the data it already has. 
            This is checked in query.p dataAvailable and openQuery is skipped
            if its true. It's immediately turned off after it is checked.    
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lFetched AS LOGICAL    NO-UNDO.
  {get DataIsFetched lFetched}.

  RETURN lFetched.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDBNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDBNames Procedure 
FUNCTION getDBNames RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
   Purpose:  Returns a comma delimited list of DBNames that corresponds 
             to the Tables in the Query Objects
Parameters:  <none>
     Notes: This does not have an xpTables preprocessor because getDBNames
            is overridden in data.p.   
------------------------------------------------------------------------------*/
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('DBNames':U).

  RETURN ghProp:BUFFER-VALUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getForeignFields Procedure 
FUNCTION getForeignFields RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the property which holds the mapping of field's in 
               another DataSource to fields in this SMartDataObject's RowObject 
               temp-table, to open a dependent query.
  
  Parameters:  <none>
  
  Notes:       The property format is a comma-separated list, consisting of the
               first local db fieldname, followed by the matching source 
               temp-table field name, followed by more pairs if there is more 
               than one field to match.
------------------------------------------------------------------------------*/
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('ForeignFields':U).
  
  RETURN ghProp:BUFFER-VALUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getForeignValues Procedure 
FUNCTION getForeignValues RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves the values of the most recently received ForeignField
               values received by dataAvailable.  The values are character
               strings formatted according to the field format specification and
               they are separated by the CHR(1) character.

  Parameters:  <none>
  
  Notes:
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cValues AS CHARACTER NO-UNDO.
  {get ForeignValues cValues}.
  RETURN cValues.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationSource Procedure 
FUNCTION getNavigationSource RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the char list of the query object's Navigation source handles..
  
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cSource AS CHARACTER NO-UNDO.
  {get NavigationSource cSource}.
  RETURN cSource. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationSourceEvents Procedure 
FUNCTION getNavigationSourceEvents RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a comma-separated list of the events this object 
               needs to subscribe to in its NavigationSource.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get NavigationSourceEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOpenOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOpenOnInit Procedure 
FUNCTION getOpenOnInit RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns TRUE if the query should be opened automatically when 
              the object is initialized.

  Parameters: <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOpen AS LOGICAL NO-UNDO.
  {get OpenOnInit lOpen}.
  RETURN lOpen.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOpenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOpenQuery Procedure 
FUNCTION getOpenQuery RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the OPEN-QUERY preprocessor value, to allow it to be
              manipulated by setQueryWhere, for example
  Parameters: <none>  
  Notes:      This is important because no matter how the query is dynamically
              modified, it can be reset to its original state using this return
              value in a QUERY-PREPARE method.
            - getOpenQuery is called from the client on AppServer, so we are not
              using the xp preprocessor.
------------------------------------------------------------------------------*/  
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('OpenQuery':U).
  
  RETURN ghProp:BUFFER-VALUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryHandle Procedure 
FUNCTION getQueryHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the handle of the database query.

  Parameters: <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
  {get QueryHandle hQuery}.
  RETURN hQuery.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryOpen Procedure 
FUNCTION getQueryOpen RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns TRUE if the Query Object's database query is currently 
               open.

  Parameters:  <none>
------------------------------------------------------------------------------*/
    
  DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
  
  {get QueryHandle hQuery}.
  RETURN IF NOT VALID-HANDLE(hQuery) THEN
      NO ELSE hQuery:IS-OPEN.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryPosition Procedure 
FUNCTION getQueryPosition RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the QueryPosition property.

  Parameters:  <none>
  
  Notes:       Valid return values are:
                 FirstRecord, LastRecord, NotFirstOrLast or NoRecordAvailable
------------------------------------------------------------------------------*/

  /* The property does not have a field preprocessor to prevent it from being
     "set" directly, because it must also publish an event. So the code below
     must not use the {get} syntax. */

  DEFINE VARIABLE cPosition AS CHARACTER NO-UNDO.
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('QueryPosition':U)
         cPosition = ghProp:BUFFER-VALUE.
  RETURN cPosition.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQuerySort Procedure 
FUNCTION getQuerySort RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the sort phrase.   
    Notes: Does NOT return the first BY keyword.      
           If a query is under work in the QueryString property this will 
           return this BY-phrase, otherwise it will return the BY-phrase in the 
           current or design query. 
           This should make this property safe to use in qbf objects that 
           may or may not have done query manipulation and may or may not 
           have opened the query. 
           It can also be used to retrieve the BY phrase before a setQueryWhere 
           (which overrides setQuerySort) and reset it after. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryText AS CHAR NO-UNDO.
  DEFINE VARIABLE iByPos     AS INT  NO-UNDO.
  
  /* If a query is under work, use that. */  
  {get QueryString cQueryText}.  

  /* If not use the actual query */ 
  IF cQueryText = "":U THEN 
    {get QueryWhere cQueryText}.
  
  /* If not found so far use the designed query */ 
  IF cQueryText = "":U THEN 
    {get OpenQuery cQueryText}.
  
  /* Any BY ? */ 
  iByPos = INDEX(cQueryText," BY ":U) + 3.

  RETURN IF iByPos > 3  
         /* trim away blanks and period and remove indexed-reposition */
         THEN REPLACE(TRIM(SUBSTR(cQueryText,iByPos)," .":U),
                      ' INDEXED-REPOSITION':U,
                      '':U)
         ELSE "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryString Procedure 
FUNCTION getQueryString RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the QueryString attribute used as working storage for 
               all query manipulation methods.
  Parameters:  <none>
  Notes:     - The method will always return a whereclause 
               If the QueryString property has not been set it will use 
               the current where clause - QueryWhere.
               If there's no current use the design where clause - OpenQuery. 
             - The openQuery will call prepareQuery with this property.     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryString AS CHARACTER NO-UNDO.
  {get QueryString cQueryString}.
  RETURN cQueryString. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryWhere Procedure 
FUNCTION getQueryWhere RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the current where-clause for the database query.
               Returns ? if the query handle is undefined.

  Parameters:  <none>
------------------------------------------------------------------------------*/    
  DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
  {get QueryHandle hQuery}.
  
  RETURN IF VALID-HANDLE(hQuery) 
         THEN hQuery:PREPARE-STRING
         ELSE ?.  
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTables Procedure 
FUNCTION getTables RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
   Purpose:  Returns a comma delimited list of tables in the Query Objects
Parameters:  <none>
     Notes: Qualified with database name if the query is defined with dbname.
            
            From 9.1B this property is a design time property while it earlier 
            was resolved from the actual query. This was very expensive as the 
            function then always needed to be resolved on the server and it is 
            rather extensively used. 
            
            There is currently no way to change the order of the tables at run 
            time. But it would be even more important to have this as a property
            if the order of the tables were changed dynamically, because several 
            other properties have table delimiters and are totally depending of 
            the design time order of this property.              
            
            This does not have an xpTables preprocessor because some web2 
            objects overrides getTables()    
------------------------------------------------------------------------------*/
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('Tables':U).

  RETURN ghProp:BUFFER-VALUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdatableColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdatableColumns Procedure 
FUNCTION getUpdatableColumns RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a comma delimited list of the Updatable Columns for this
               SmartDataObject.
  Parameters:  <none>
  Notes:       Uses the UpdatableColumnsByTable property which stores the
               the columns in different tables delimited by CHR(1) instead of 
               comma in order to identify which columns are from which table 
               in the event of a join. For example, if the query is a join of 
               customer and order and the Name field from customer and the
               OrderNum and OrderData field from Order are Updatable, then the 
               property value will be equal to "Name<CHR(1)>OrderNum,OrderDate".
               This function replaces CHR(1) with "," to return just a 
               comma-delimited list. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumns AS CHARACTER NO-UNDO.
  {get UpdatableColumnsByTable cColumns}.
  
  IF NUM-ENTRIES(cColumns,CHR(1)) > 1 THEN
    cColumns = REPLACE(cColumns,CHR(1),",":U).

  /* There might be empty entries */
  DO WHILE INDEX(cColumns,",,":U) > 0:
    cColumns = REPLACE(cColumns,",,":U,",":U).
  END.
  
  /* There's may also be commas at the ends  */ 
  RETURN TRIM(cColumns,",":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseDBQualifier) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUseDBQualifier Procedure 
FUNCTION getUseDBQualifier RETURNS LOGICAL
 (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return true if table references are qualified with db. 
    Notes: This property was originally implemented to be able to return 
           getTables() correctly when getTables() was resolved from the query 
           handle. 
           From 9.1B the Tables property is set at design time and will thus 
           always reflect the design time database qualification, so this 
           function is now changed to be resolved from getTables, the very same 
           function it was implemented to serve.
           (It is also used in other functions).  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTables AS CHAR NO-UNDO.
  
  {get Tables cTables}.
  
  RETURN NUM-ENTRIES(ENTRY(1,cTables),".":U) > 1.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWordIndexedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWordIndexedFields Procedure 
FUNCTION getWordIndexedFields RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return a comma separated list of word indexed fields 
    Notes: Qualified with database and table name.
           We return database name from dynamic methods as all column* 
           methods are able to respond to that.
           This dbname is returned also if qualify with db name is false.
------------------------------------------------------------------------------*/
  RETURN 
     REPLACE(DYNAMIC-FUNCTION("indexInformation":U IN TARGET-PROCEDURE,
                              "WORD":U,
                              NO,
                              ?),
             CHR(1),",":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAutoCommit Procedure 
FUNCTION setAutoCommit RETURNS LOGICAL
  ( plCommit AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:     Passes along a "set AutoCommit" to the object's Update-Target.
  
  Parameters:
    plCommit - True or False to be set in the Update-Target procedure.

  Notes:       There is no AutoCommit property in a query object, but the 
               AutoCommit setting may be passed from a SmartDataObject to its 
               Data-Targets. If one of those targets is a query object that 
               isn't also a SmartDataObject (e.g., a SmartDataBrowser that has 
               its own db query), then the setting must be passed to the 
               Update-Target, which is the actual DataObject. 
               In a SmartDataObject the version of setAutoCommit in data.p
               will be found in preference to this one and will set the 
               actual property.
------------------------------------------------------------------------------*/

  dynamic-function("assignLinkProperty":U IN TARGET-PROCEDURE,
    'Update-Target':U, 'AutoCommit':U, IF plCommit THEN 'yes':U ELSE 'No':U).

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCheckLastOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCheckLastOnOpen Procedure 
FUNCTION setCheckLastOnOpen RETURNS LOGICAL
 (pCheck AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:    Sets the flag indicating whether a get-last should be performed on 
              an open in order for fetchNext to be able to detect that we are on 
              the last row. This is necessary to make the QueryPosition 
              attribute reliable.
 
  Parameters:
    pCheck - True or False depending on whether the check should be done or not.
------------------------------------------------------------------------------*/
  
  {set CheckLastOnOpen pCheck}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataIsFetched) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataIsFetched Procedure 
FUNCTION setDataIsFetched RETURNS LOGICAL
  ( plFetched AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: The SBO sets this to true in the SDO when it has fethed 
           data on the SDOs behalf in order to prevent that the SDO 
           does another server call to fetch the data it already has. 
           The SDO checks it in dataAvailable and avoids openQuery if its true.
           It's immediately turned off after it is checked.    
    Notes:  
------------------------------------------------------------------------------*/
  {set DataIsFetched plFetched}.
  
  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDBNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDBNames Procedure 
FUNCTION setDBNames RETURNS LOGICAL
  (pcDBNames AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose:  Sets the comma delimited list of DBNames that corresponds 
             to the Tables in the Query Objects
Parameters:  pcDBNames - Comma delimited list of each buffer's DBNAME. 
     Notes: FOR INTERNAL USE ONLY
            Function is required because this does not have an xpTables 
            preprocessor because getDBNames is overridden in data.p. 
            The function is also used when this property is passed from server 
            to client.    
------------------------------------------------------------------------------*/
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('DBNames':U)
         ghProp:BUFFER-VALUE = pcDBNames.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setForeignFields Procedure 
FUNCTION setForeignFields RETURNS LOGICAL
  ( pcFields AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Foreign Fields property of the object.
  
  Parameters:
    pcFields - comma-separated paired list of db fields and the RowObject 
               fields they map to.
------------------------------------------------------------------------------*/
  /* In case a previous value has been used to add the key to the query 
     we must remove it. It's too late to figure out after the Foreignfields 
     have changed. */ 
  {fn removeForeignKey}.
  
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('ForeignFields':U)
         ghProp:BUFFER-VALUE = pcFields.
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNavigationSource Procedure 
FUNCTION setNavigationSource RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the NavigationSource link value.
  
  Parameters:  
    pcObject - char delim string of procedure handles of the object which 
               should be made this object's Navigation-Source(s).
------------------------------------------------------------------------------*/

  {set NavigationSource pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOpenOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOpenOnInit Procedure 
FUNCTION setOpenOnInit RETURNS LOGICAL
  ( plOpen AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the flag indicating whether the object's database query 
               should be opened automatically when the object is initialized -
               yes by default.
  
  Parameters:
    plOpen - True if the database query should be opened at initialization.
------------------------------------------------------------------------------*/

  {set OpenOnInit plOpen}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOpenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOpenQuery Procedure 
FUNCTION setOpenQuery RETURNS LOGICAL
  (pcQuery AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:    Sets the design Query value, to allow it to be manipulated 
              by setQueryWhere, for example

  Parameters: pcQuery - Query expression without open query <name>.
    Notes:    getOpenQuery is called from the client on AppServer, so we are not
              using the xp preprocessor.
------------------------------------------------------------------------------*/
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('OpenQuery':U)
         ghProp:BUFFER-VALUE = pcQuery.

  /* Just use the setQueryWhere to blank to apply this property to the query.
     setQueryWhere has all the required logic to prepare and set other  
     query props to blank. */ 
  RETURN {fnarg setQueryWhere '':U}.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryPosition Procedure 
FUNCTION setQueryPosition RETURNS LOGICAL
  ( pcPosition AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Query Position property, and publishes an event to 
               tell others.
  
  Parameters:
    pcPosition - query position possible values are:
                 'FirstRecord', 'LastRecord', 'NotFirstOrLast' and 
                 'NoRecordAvailable'
------------------------------------------------------------------------------*/

    /* The property name does not have a property preprocessor
       to prevent it from being "set" directly, so that the event will 
       always be published, so the {set} syntax is not used. */

  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('QueryPosition':U)
         ghProp:BUFFER-VALUE = pcPosition.
  PUBLISH 'queryPosition':U FROM TARGET-PROCEDURE (pcPosition).
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQuerySort Procedure 
FUNCTION setQuerySort RETURNS LOGICAL
  ( pcSort AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets or resets the sorting criteria (BY phrase) of the database
               query and stores the result in the QueryString property.
  Parameters:
    pcSort - new sort (BY) clause.
  
  Notes:     - setQueryWhere wipes out anything done in setQuerySort.
             - addQuerywhere does not. 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cQueryText   AS CHARACTER NO-UNDO.
 DEFINE VARIABLE iByPos       AS INTEGER   NO-UNDO.
 DEFINE VARIABLE hQuery       AS HANDLE    NO-UNDO.
 DEFINE VARIABLE iIdxPos      AS INTEGER   NO-UNDO.
 DEFINE VARIABLE iLength      AS INTEGER   NO-UNDO.
 DEFINE VARIABLE lOk          AS LOGICAL   NO-UNDO.

  /* If a query is under work, use that. */  
  {get QueryString cQueryText}.
  
  IF cQueryText = "":U THEN 
  DO:
    {get QueryWhere cQueryText}.
  END. /* no query under work */
  
  IF cQueryText <> '':U THEN
  DO:
    
    ASSIGN  /* Remove BY from parameter, we'll add it back */ 
      pcSort  = IF pcSort BEGINS "BY ":U 
                THEN TRIM(SUBSTRING(pcSort,3)) 
                ELSE pcSort

      /* check for indexed-reposition */
      iIdxPos = INDEX(RIGHT-TRIM(cQueryText,". ") + " ":U,
                      " INDEXED-REPOSITION ":U)          

      /* If there was no INDEX-REPOS we set the iLlength (where to end insert)
         to the end of where-clause. (right-trim periods and blanks to find 
         the true end of the expression)
         Otherwise iLength is the position of INDEX-REPOS. */
      iLength = (IF iIdxPos = 0 
                 THEN LENGTH(RIGHT-TRIM(cQueryText,". ":U)) + 1     
                 ELSE iIdxPos)    
      
      /* Any By ? */ 
      iByPos  = INDEX(cQueryText," BY ":U)             
      
      /* Now find where we should start the insert; 
         We might have both a BY and an INDEXED-REPOSITION 
         or only one of them or none. 
         Just make sure we use the MINIMUM of whichever of those if they
         are <> 0. */

      iByPos  = MIN(IF iByPos  = 0 THEN iLength ELSE iByPos,
                    IF iIdxPos = 0 THEN iLength ELSE iIdxPos) 
      
      SUBSTR(cQueryText,iByPos,iLength - iByPos) = IF pcSort <> '':U 
                                                   THEN " BY ":U + pcSort
                                                   ELSE "":U.
      
    {set QueryString cQueryText}.

  END. /* if cQuerytext = '' */

  RETURN cQueryText <> '':U.
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryString Procedure 
FUNCTION setQueryString RETURNS LOGICAL
  (pcQueryString AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the QueryString property used as working storage for the
               addQueryString, assignQuerySelection, removeQuerySelection, 
               setQueryWhere, setQuerySort etc.   
  Parameters:  pcQueryString - The string to store
        Note:  NEVER set this directly. It should only be maintained by other
               query manipulation methods.  
------------------------------------------------------------------------------*/
  {set QueryString pcQueryString}.
  RETURN TRUE. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryWhere Procedure 
FUNCTION setQueryWhere RETURNS LOGICAL
  ( pcWhere AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Append a WHERE clause to the basic static database query 
              definition (on client or server side) or modifes the complete 
              where clause.  
 
Parameters:
    INPUT pcWhere - new WHERE clause (a logical expression without the 
                    leading WHERE keyword). 
  
  Notes:      NOTE that we always start with the base query definition 
              to do this. If the where-clause parameter is blank, we simply 
              reprepare the original query.
              Criteria appended with the other query manipulation methods 
              will be removed, INCLUDED sort criteria added with setQuerySort. 
  Parameters:
    pcWhere - new query expression or complete new where clause.  
              - An expression without the leading WHERE keyword.
                Will be added to the base query, if the base query has an 
                expression the new expression wil be appended with AND 
              - blank - reprepare the base query.
              - a complete query with the FOR keyword.
              
   Notes:     If pcWhere starts with "For " or "Preselect " then the existing 
              where clause is completely replaced with pcWhere.
              If pcWhere is blank, then the existing where clause is replaced
              with the design-time where clause.
              Otherwise pcWhere is added to the design-time where clause.
 ------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQuery  AS  CHARACTER NO-UNDO.
  
  cQuery = {fnarg newQueryWhere pcWhere}.
  IF cQuery <> ? THEN
    /* prepares the query with the new string */ 
    RETURN {fnarg prepareQuery cQuery}. 
  ELSE 
    RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTables Procedure 
FUNCTION setTables RETURNS LOGICAL
  ( pcTables AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Set Tables property  
    Notes: This cannot have an xp because WebSpeed must use getTables()    
------------------------------------------------------------------------------*/
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('Tables':U)
         ghProp:BUFFER-VALUE = pcTables NO-ERROR.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

