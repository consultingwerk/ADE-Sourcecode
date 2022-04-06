&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
      File      : wbtable.p 
    Purpose     : SUPER procedure that outputs data in an HTML table 
                    
    Syntax      : RUN adm2/wbtable.p PERSISTENT 

    Created     : June 98
    Modified    : January 25, 1999 
    Notes       : 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&SCOPED-DEFINE admsuper wbtable.p

{src/web2/custom/wbtableexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addColumnLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addColumnLink Procedure 
FUNCTION addColumnLink RETURNS LOGICAL
  (pcColumn    AS CHAR,
   pcURL       AS CHAR,
   pcTarget    AS CHAR,
   pcMouseOver AS CHAR,
   pcJoinParam AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addTDModifier) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addTDModifier Procedure 
FUNCTION addTDModifier RETURNS LOGICAL
  (pcColumn   AS CHAR, 
   pcModifier AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignTDModifier) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignTDModifier Procedure 
FUNCTION assignTDModifier RETURNS LOGICAL
  (pColumn   AS CHAR,
   pModifier AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTDModifier) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnTDModifier Procedure 
FUNCTION columnTDModifier RETURNS CHARACTER
  (pColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTableRows Procedure 
FUNCTION getTableRows RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HTMLColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD HTMLColumn Procedure 
FUNCTION HTMLColumn RETURNS LOGICAL
  (pColumn AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HTMLTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD HTMLTable Procedure 
FUNCTION HTMLTable RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PageBackward) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD PageBackward Procedure 
FUNCTION PageBackward RETURNS LOGICAL() FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLinkColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLinkColumns Procedure 
FUNCTION setLinkColumns RETURNS LOGICAL
  (pcLinkColumns AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableModifier) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTableModifier Procedure 
FUNCTION setTableModifier RETURNS LOGICAL
  (pcTableModifier AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTableRows Procedure 
FUNCTION setTableRows RETURNS LOGICAL
  (piRows AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUseColumnLabels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUseColumnLabels Procedure 
FUNCTION setUseColumnLabels RETURNS LOGICAL
  (pUseLabels as log)  FORWARD.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web/method/cgidefs.i}
{src/web2/wbtaprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-fetchLast) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchLast Procedure 
PROCEDURE fetchLast :
/*------------------------------------------------------------------------------
  Purpose: Repositions the database query or dataobject to the first row of the 
           last page.
  Parameters: None
  Notes:    The main logic to finc the web page's true last record is in SUPER. 
            In addition to this we need to pageBackward to find the record 
            that's supposed to be on the top of the page.        
------------------------------------------------------------------------------*/
  RUN SUPER.
  DYNAMIC-FUNCTION('pageBackward':U IN TARGET-PROCEDURE).  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchNext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchNext Procedure 
PROCEDURE fetchNext :
/*------------------------------------------------------------------------------
  Purpose: Reposition the database query or dataobject to the first row of the 
           next page when current rowid is the first row of the current page.
  Parameters: None
  Notes: If we don't find enough records to display a full next page we call 
         the pageBackWard function to find the row that should be in the 
         top row in order to create a full page.          
------------------------------------------------------------------------------*/    
  DEFINE VARIABLE hQuery         AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hDataSource    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iNumRows       AS INTEGER NO-UNDO.
  DEFINE VARIABLE i              AS INTEGER NO-UNDO.
  DEFINE VARIABLE cQueryPosition AS CHAR    NO-UNDO.
   
  {get TableRows iNumRows}.   
    
  RUN fetchCurrent IN TARGET-PROCEDURE.
   
  /* If the datasource is a dataobject, repeat fetchNext until we have  
     reached the top row of the next page */               
  {get DataSource hDataSource}.   
  IF VALID-HANDLE(hDataSource) THEN 
  DO:
    {get QueryPosition cQueryPosition hDataSource}. 
    IF cQueryPosition = "LastRecord":U THEN 
       DYNAMIC-FUNCTION('PageBackward':U IN TARGET-PROCEDURE).         
    
    ELSE
    DO i = 1 TO iNumRows:    
      RUN fetchNext IN hDataSource.
      {get QueryPosition cQueryPosition hDataSource}.
      IF cQueryPosition = "LastRecord":U THEN
      DO: 
        DYNAMIC-FUNCTION('PageBackward':U IN TARGET-PROCEDURE).           
        LEAVE.
      END. /* if LastRecord  */
    END. /* i = 1 to numrows */       
  END. /* if valid-handle(hdataSource) */
  
  /* else if we have a query we reposition to the SECOND row on the next page,
     in order to see of we need to page at all 
     (this will keep the last page a full page)
     if it is we must step back again */                  
  ELSE 
  DO:
    {get QueryHandle hQuery}.  
    hQuery:REPOSITION-FORWARD(iNumRows).     
   
    IF hQuery:QUERY-OFF-END THEN
      RUN fetchCurrent IN TARGET-PROCEDURE.
    
    ELSE 
    DO:
      hQuery:REPOSITION-BACKWARD(1).                 
      hQuery:GET-NEXT.      
    END. /* we were off-end */ 
  END. /* else IE. database is the data-source */    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchPrev) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchPrev Procedure 
PROCEDURE fetchPrev :
/*------------------------------------------------------------------------------
  Purpose: Reposition the database query or DataSource to the first row of the 
           previous page.
  Parameters: None
  Notes:   The main logic to finc the web page's true prev record is in SUPER. 
           In addition to this we need to pageBackward to find the record 
           that's supposed to be on the top of the previous page.              
------------------------------------------------------------------------------*/
  RUN SUPER. 
  DYNAMIC-FUNCTION('PageBackward':U IN TARGET-PROCEDURE).  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ProcessWebRequest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ProcessWebRequest Procedure 
PROCEDURE ProcessWebRequest :
/*------------------------------------------------------------------------------
  Purpose: Process the request from the web and add necessary logic for 
           the web Report.      
  Parameters:  <none>
  Notes:   This is a read-only object so we addMessage to inform the user that 
           no records were found if the query is empty.
           
           The destroyObject is important when the data-source is an SDO,
           in order to be able to destroy the SDO and disconnect from AppServers
           etc.. according to the Instance Properties of the SDO. 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lEmpty      AS LOGICAL NO-UNDO.
  
 RUN SUPER.
 
 {get QueryEmpty lEmpty}.
 
 IF lEmpty THEN 
  RUN addMessage IN TARGET-PROCEDURE('No records found.',?,?).
 ELSE  
   DYNAMIC-FUNCTION('HTMLTable':U IN TARGET-PROCEDURE).
   
 RUN destroyObject IN TARGET-PROCEDURE.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addColumnLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addColumnLink Procedure 
FUNCTION addColumnLink RETURNS LOGICAL
  (pcColumn    AS CHAR,
   pcURL       AS CHAR,
   pcTarget    AS CHAR,
   pcMouseOver AS CHAR,
   pcJoinParam AS CHAR):
/*----------------------------------------------------------------------------
  Purpose: Set all attributes necessary to create a hyper link for a 
           specified column.
Parameters: 
   INPUT pcColumn    - Data-source column name 
   INPUT pcURL       - The actual URL reference (usually the object name name) 
   INPUT pcTarget    - The HTML frame reference used to receive the response.
   INPUT pcMouseOver - A function that returns the a character string that 
                       will be displayed on hte mouseOver event in the HTML
                       page.
   INPUT pcJoinParam - Specifies which parameters that need to be added to 
                       the URL in order to join this data-source to the 
                       linked object's data-source.
                       - A comma-separated list of column names
                         Will add the specified columns as URL parameters 
                         with the current value as data in addition to
                         an "ExternalObject" parameter with the SDO file-name 
                         as data.        
                       - 'ROWID' 
                          Will add the parameters "ExternalRowids" with the 
                          current rowids as data to the URL and 
                          "ExternalTables" with the corresponding table names
                          as data.
                       - blank       
                         This means that no join needs to take place and no 
                         parameters except the default "BackRowids" will be 
                         added to the URL.       
                               
    Notes: The attributes are read and used in HTMLColumn to generate the link 
           when the data is output. Each of the passed parameters are stored in 
           comma-separated or CHR(1) separated properties. The LinkColumns 
           specifies which columns that has link while all the others have 
           correspondoing entries.   
             
           The parameters that gets added to the URL as a result of what's
           specified in the pcJoinParams requires that the linked object
           is able to interprete those data. This is usually done by defining
           that the linked object should be able to link to "External tables or
           objects". 
           When this is specified the receiving object will have a 
           comma-separated ExternalTableList property that has an entry for 
           each possible external table or object. 
           
           The ExternlTables or ExternalObject parameter that is added to the 
           URL must match this list. 
           
           If a match is found the entry number in the lists will be used to 
           find the other information that are needed to complete the join. 
           When a list of columns is passed the matching ForeignFields property 
           is found in the | (pipe) separated ForeignFieldList property. 
           When ROWID is specified two | (pipe) separated properties;
           ExternalJoinList and ExternalWhereList, may have matching entries 
           that will be used to join the passed ROWIDS with the receiving query. 
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE cLinkColumns  AS CHAR NO-UNDO.
  DEFINE VARIABLE cLinkURLs     AS CHAR NO-UNDO.
  DEFINE VARIABLE cLinkTargets  AS CHAR NO-UNDO.
  DEFINE VARIABLE cLinkTexts    AS CHAR NO-UNDO.
  DEFINE VARIABLE cLinkJoins    AS CHAR NO-UNDO.
  DEFINE VARIABLE cDelimit      AS CHAR NO-UNDO.
  DEFINE VARIABLE iPos          AS INT  NO-UNDO.
    
  {get LinkColumns cLinkColumns}.
  {get LinkURLs cLinkURLs}.
  {get LinkTargets cLinkTargets}.
  {get LinkTexts cLinkTexts}.
  {get LinkJoins cLinkJoins}.
   
  IF LOOKUP(pcColumn,cLinkColumns) = 0 THEN
    ASSIGN 
      cDelimit     = (IF cLinkColumns = "":U THEN "":U ELSE ",":U)                      
      cLinkColumns = cLinkColumns 
                     + cDelimit    
                     + pcColumn
                       
      cLinkURLs    = cLinkURLs    + cDelimit
      cLinkTargets = cLinkTargets + cDelimit
      cLinkTexts   = cLinkTexts   + cDelimit
      cLinkJoins   = cLinkJoins   + CHR(3).
  
  ASSIGN
    iPos = LOOKUP(pcColumn,cLinkColumns) 
    ENTRY(iPos,cLinkURLS)         = pcURL
    ENTRY(iPos,cLinkTargets)      = pcTarget
    ENTRY(iPos,cLinkTexts)        = pcMouseOver
    ENTRY(iPos,cLinkJoins,CHR(3)) = pcJoinParam.
                            
  {set LinkColumns cLinkColumns}.
  {set LinkURLs    cLinkURLs}.
  {set LinkTargets cLinkTargets}.
  {set LinkTexts   cLinkTexts}.
  {set LinkJoins   cLinkJoins}.
    
  RETURN TRUE.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addTDModifier) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addTDModifier Procedure 
FUNCTION addTDModifier RETURNS LOGICAL
  (pcColumn   AS CHAR, 
   pcModifier AS CHAR): 
/*------------------------------------------------------------------------------
  Purpose: Add HTML attributes for the <TD> tag for a specific column.
Parameters: 
   INPUT pcColumn   - A column name corresponding to one of the entries in the
                      DataColumns property.
   INPUT pcModifier - one or more HTML attribute(s) that will be added to the TD 
                      tag. 
    Notes: There is an assignTdModifier function that will overwrite what's been 
           previously defined for the column.
           This method is used internally to achieve right justified decimals 
           and integers. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTdModifier AS CHAR NO-UNDO.
  
  
  ASSIGN
    cTDModifier = DYNAMIC-FUNCTION('columnTDModifier':U IN TARGET-PROCEDURE,
                                    pcColumn)
    cTdModifier  =  cTDModifier 
                    + (IF cTdModifier = "":U THEN "":U ELSE " ":U)
                    + pcModifier.
 
  DYNAMIC-FUNCTION('assignTDModifier':U IN TARGET-PROCEDURE,
                    pcColumn,
                    cTdModifier).

  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignTDModifier) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignTDModifier Procedure 
FUNCTION assignTDModifier RETURNS LOGICAL
  (pColumn   AS CHAR,
   pModifier AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Set attributes for the <TD> tag for a specific column.
Parameters: 
   INPUT pcColumn   - A column name corresponding to one of the entries in the
                      DataColumns property.
   INPUT pcModifier - one or more HTML attribute(s) that will be used in the TD 
                      tag. 
      Notes: Use the addTdModifier function to add an attribute. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumns    AS CHAR NO-UNDO.
  DEFINE VARIABLE cTdModifier AS CHAR NO-UNDO.
  DEFINE VARIABLE cModifier   AS CHAR NO-UNDO.
  DEFINE VARIABLE iNum        AS INT NO-UNDO.
  
  {get DataColumns cColumns}.
  {get TDModifier cTDModifier}.
  
  ASSIGN 
    iNum        = LOOKUP(pColumn,cColumns)
    cModifier   = pModifier
    cTDModifier = IF cTDModifier = "":U 
                  THEN FILL(",":U,NUM-ENTRIES(cColumns)) 
                  ELSE cTDModifier 
    
    /* Make sure the modifier has a leading blank */
    ENTRY(iNum,cTDModifier) = " ":U + TRIM(cModifier). 
 
  {set TDModifier cTDModifier}.
  
  RETURN TRUE.
   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTDModifier) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnTDModifier Procedure 
FUNCTION columnTDModifier RETURNS CHARACTER
  (pColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Retrieve the <TD> modifier for a column. 
    Notes: Used internally in HTMLcolumn and HTMLTable to generate the labels. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumns    AS CHAR NO-UNDO.
  DEFINE VARIABLE cTDModifier AS CHAR NO-UNDO.
  
  {get DataColumns cColumns}.
  {get TDModifier cTDModifier}. 
          
  RETURN IF cTDModifier = "":U 
         THEN "":U 
         ELSE ENTRY(LOOKUP(pColumn,cColumns),cTdModifier).
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTableRows Procedure 
FUNCTION getTableRows RETURNS INTEGER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the number of rows used in the HTML table. 
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE iTableRows AS INTEGER NO-UNDO. 
  
  {get TableRows iTableRows}.
  RETURN iTableRows.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HTMLColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION HTMLColumn Procedure 
FUNCTION HTMLColumn RETURNS LOGICAL
  (pColumn AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Output one column of data in the HTML <table>
Parameter: The column that are displayed.
    Notes: Checks the LinkColumns attribute to see if a hyper link should be 
           generated.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource     AS HANDLE NO-UNDO. 
  DEFINE VARIABLE cLinkColumns    AS CHAR   NO-UNDO.
  DEFINE VARIABLE cLinkURLs       AS CHAR   NO-UNDO.
  DEFINE VARIABLE cLinkURL        AS CHAR   NO-UNDO.
  DEFINE VARIABLE cLinkTargets    AS CHAR   NO-UNDO.
  DEFINE VARIABLE cLinkTexts      AS CHAR   NO-UNDO.
  DEFINE VARIABLE cStatusLine     AS CHAR   NO-UNDO.
  DEFINE VARIABLE cLinkStatus     AS CHAR   NO-UNDO.
  DEFINE VARIABLE cLinkJoins      AS CHAR   NO-UNDO. 
  DEFINE VARIABLE cCurrentRowids  AS CHAR   NO-UNDO.
  DEFINE VARIABLE cDelimiter      AS CHAR   NO-UNDO.
  DEFINE VARIABLE iPos            AS INT    NO-UNDO.

  {get DataSource hDataSource}.
  {get LinkColumns cLinkColumns}.
      
  ASSIGN
    iPos    = LOOKUP(pColumn,cLinkColumns).
 
  {&OUT} '  <td'
         DYNAMIC-FUNCTION('columnTDModifier':U IN TARGET-PROCEDURE,
                           pColumn)   
         '> '.
  
  /* If the column is defined as a linkcolumns output the <a HREF > tag */ 
  IF iPos > 0 THEN
  DO: 
    
    {get LinkURLs cLinkURLs}.
    {get LinkTargets cLinkTargets}.
    {get LinkTexts cLinkTexts}.
    {get LinkJoins cLinkJoins}.
       
    /* Don't create HREF without URL */
    IF ENTRY(iPos,cLinkUrls) <> "":U THEN
    DO:
    
      ASSIGN
        cLinkStatus = ENTRY(iPOS,cLinkTexts)
        cLinkURL    = ENTRY(iPOS,cLinkUrls)           
        cDelimiter  = IF INDEX(cLinkURL,'?':U) > 0 
                      THEN ?   
                      ELSE '?':U. 
     
      {&OUT} ' <a HREF="'
        DYNAMIC-FUNCTION('urlLink' IN TARGET-PROCEDURE, 
                          cLinkURL, 
                          ENTRY(iPos,cLinkJoins,CHR(3)))
             '"~n':U  
             '       target="' ENTRY(iPOS,cLinkTargets) '"~n':U.
      
      IF cLinkStatus <> "":U THEN
      DO:
        /* The status line is a function in the target-procedure
           in order to be able to allow for expressions */           
        cStatusLine = DYNAMIC-FUNCTION(ENTRY(iPOS,cLinkTexts) IN TARGET-PROCEDURE) NO-ERROR.
        cStatusLine = html-encode(REPLACE(cStatusLine,"'","~\'")). /* 9.0B 99-01-12-018 */       
        {&OUT} '       onMouseover="window.status=~'' 
                       cStatusLine '~'~;return true"~n'
               '       onMouseout="window.status=''''~;return true"'.
      END. /* if cLinkStatus = "" */
      {&OUT} '>':U .
    END. /* ENTRY(iPos,cLinkUrls) <> "":U */      
  END. /* ipos > 0 */ 
   
  {&OUT} 
     html-encode(dynamic-function('ColumnStringValue' in TARGET-PROCEDURE, pColumn)).

  IF iPos > 0 THEN {&OUT} '</a>' . 
  
  {&OUT} ' </td>~n'.
    
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HTMLTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION HTMLTable Procedure 
FUNCTION HTMLTable RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose: Output the HTML table.   
    Notes:  
------------------------------------------------------------------------------*/ 
 DEFINE VARIABLE iTableRows     AS INT    NO-UNDO.
 DEFINE VARIABLE cColumns       AS CHAR   NO-UNDO.
 DEFINE VARIABLE cColumnName    AS CHAR   NO-UNDO.
 DEFINE VARIABLE cCurrentRowids AS CHAR   NO-UNDO.
 DEFINE VARIABLE iTable         AS INT    NO-UNDO.
 DEFINE VARIABLE iCol           AS INT    NO-UNDO.
 DEFINE VARIABLE hQuery         AS HANDLE NO-UNDO.
 DEFINE VARIABLE hDataSource    AS HANDLE NO-UNDO.
 DEFINE VARIABLE cQueryPosition AS CHAR   NO-UNDO.
 DEFINE VARIABLE cRowids        AS CHAR   NO-UNDO.
 DEFINE VARIABLE lUseLabels     AS LOG    NO-UNDO.
 DEFINE VARIABLE cTableModifier AS CHAR   NO-UNDO.
 DEFINE VARIABLE lHref          AS LOG    NO-UNDO.
 DEFINE VARIABLE cColDataTypes  AS CHAR   NO-UNDO.
 DEFINE VARIABLE cDataType      AS CHAR   NO-UNDO.
  
 {get TableRows iTableRows}.
 {get DataColumns cColumns}.
 {get TableModifier cTableModifier}.
 {get UseColumnLabels lUseLabels}.
 {get DataSource hDataSource}.
     
 IF VALID-HANDLE(hDataSource) THEN 
 DO:
   IF cColumns = "":U THEN
   DO: 
     cColumns = DYNAMIC-FUNCTION('getColumns' IN hDataSource).
     {set DataColumns cColumns}.
   END.
   
   /* In case the dataSource is on an AppServer the columnProps function is
      probably more efficient than calling 'columnDataType' for each column.   
      This is needed to set the TD modifier to align="RIGHT" for numeric fields.*/      
   cColDataTypes = DYNAMIC-FUNCTION("columnprops":U IN hDataSource,
                                     cColumns,
                                    "DataType":U).
                
 END.
 ELSE
   {get QueryHandle hQuery}.
   
 {&OUT} '<table ' + cTableModifier + '>~n'.
 
 IF lUseLabels THEN
      {&out} '  <tr>~n'.  
    
 /* Loop thru each column to add right alignment and show labels if 
    UseColumnLabels */
 DO iCol = 1 to NUM-ENTRIES(cColumns):
   ASSIGN 
     cColumnname = Entry(iCol,cColumns)
     
                   /* if we have a datasource we have already have requested the
                      datatypes using the more efficient ColumnProps function */ 
     cDataType   = IF VALID-HANDLE(hDataSource) 
                   THEN ENTRY(2, ENTRY(iCol,cColDataTypes,CHR(3)),CHR(4))                          
                   ELSE DYNAMIC-FUNCTION('columnDataType':U IN TARGET-PROCEDURE,
                                          cColumnName)
   .
   
   /* Add right alignment for numeric datatypes */                                       .          
   IF CAN-DO('INTEGER,DECIMAL':U,cDataType) THEN 
                  
     DYNAMIC-FUNCTION('addTDModifier':U IN TARGET-PROCEDURE,
                       cColumnName,
                      'align=~"right~"'). 
                     
   /* Show the labels */
   IF lUseLabels THEN
   DO:
     {&OUT} '  <td'
      
            DYNAMIC-FUNCTION('columnTDModifier':U IN TARGET-PROCEDURE,
                              cColumnName)   
            '> '
            html-encode(DYNAMIC-FUNCTION('ColumnLabel' in TARGET-PROCEDURE, 
                                          cColumnname)) 
            '  </td>~n'.
   END. /* If lUseLabels */
                    
 END. /* do icol = 1 to num-entries(cColumns) */   
 IF lUseLabels THEN
   {&out} '  </tr>~n'.  
   
 DO iTable = 1 TO iTableRows:
 
   {&OUT} '  <tr>~n'.
    
   DO iCol = 1 to NUM-ENTRIES(cColumns):
     cColumnname = Entry(iCol,cColumns). 
     DYNAMIC-FUNCTION('HTMLColumn' IN TARGET-PROCEDURE, cColumnName).     
   END.   
  
   {&OUT} '  </tr>~n'.
     
   IF VALID-HANDLE(hDataSource) THEN
   DO:      
     {get QueryPosition cQueryPosition hDataSource}.     
     
     IF CAN-DO("LastRecord,OnlyRecord":U,cQueryPosition) THEN
       LEAVE. 
     RUN fetchNext IN hDataSource.   
   END. /* if valid-handle(hdataSource) */
   ELSE     
   DO:
     hQuery:GET-NEXT.  
     IF hQuery:QUERY-OFF-END THEN LEAVE.
   END.
 END.
  
 {&OUT} '</table>~n'.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PageBackward) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION PageBackward Procedure 
FUNCTION PageBackward RETURNS LOGICAL():
/*------------------------------------------------------------------------------
  Purpose: Fetch the top row on a page where the current row should be the 
           last row.    
    Notes: Called from fetchPrev AFTER the prev row is found
                       fetchLast AFTER the last row is found 
                       fetchNext If and AFTER the last row of a datobject is 
                       found.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery      AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iNumRows    AS INTEGER NO-UNDO.
  DEFINE VARIABLE i           AS INTEGER NO-UNDO.
  
  {get TableRows iNumRows}.   
    
  /* If the datasource is a DataObject run fetchLast in it */             
  {get DataSource hDataSource}.   
  
  IF VALID-HANDLE(hDataSource) THEN 
  DO i = 1 TO iNumRows - 1:
    RUN fetchPrev IN hDataSource.      
  END. 
  /* else we have a query */             
  ELSE 
  DO:
    {get QueryHandle hQuery}.  
    hQuery:REPOSITION-BACKWARD(iNumRows).     
    hQuery:GET-NEXT.      
    IF hQuery:QUERY-OFF-END THEN
       hQuery:GET-FIRST.                     
  END.
  
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLinkColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLinkColumns Procedure 
FUNCTION setLinkColumns RETURNS LOGICAL
  (pcLinkColumns AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Store the columns that has hyperlinks. 
 Parameter: The comma separated list of columns.  
    Notes: The logic to add a link is in AddColumnLink, so this should never
           be called directly.  
------------------------------------------------------------------------------*/
  {set LinkColumns pcLinkColumns}.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableModifier) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTableModifier Procedure 
FUNCTION setTableModifier RETURNS LOGICAL
  (pcTableModifier AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Specifies HTML attribute(s) for the <table> tag.
 Parameter:
    INPUT pcModifier - one or more HTML attribute(s) that will be used in the 
                       TABLE tag. 
    Notes:  
------------------------------------------------------------------------------*/
  {set TableModifier pcTableModifier}.
  RETURN TRUE.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTableRows Procedure 
FUNCTION setTableRows RETURNS LOGICAL
  (piRows AS INT) :
/*------------------------------------------------------------------------------
  Purpose: Store the number of rows for the table. 
    Notes:  
------------------------------------------------------------------------------*/
  {set TableRows piRows}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUseColumnLabels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUseColumnLabels Procedure 
FUNCTION setUseColumnLabels RETURNS LOGICAL
  (pUseLabels as log) :
/*------------------------------------------------------------------------------
  Purpose: Set to yes to display labels above the columns.   
    Notes: This is using the LABEL and not the COLUMN-LABEL of the field.
           (There is no logic to take care of the ! in column-labels)
               
------------------------------------------------------------------------------*/
  {set UseColumnLabels pUseLabels}.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

