/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------
  Aspexp.p

  Description: Active Server Page Example. Performs a multitable database
  query.

--------------------------------------------------------------------*/

/* Include WebSpeed utility routines */
{src/web/method/cgidefs.i}

DEFINE VARIABLE Result-Rows    AS INTEGER    NO-UNDO.
DEFINE VARIABLE Res-Rows       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE search-value   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE Navigate       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE NavRowid       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE NavRowid2      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE NavRowid3      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE NavRowid4      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE NavRowid5      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE FirstRowid     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-count        AS INTEGER    NO-UNDO.
DEFINE VARIABLE TmpUrl         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE DelimiterField AS CHARACTER  NO-UNDO.
DEFINE VARIABLE NoPrev         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE NoNext         AS LOGICAL    NO-UNDO.

/* Form Buffer for column labels and display data formats */
FORM
  Salesrep.RepName
  Customer.Name
  Item.ItemName
  OrderLine.ExtendedPrice
  WITH FRAME ReportFrame.

/* Get all the fields from the input */
ASSIGN
  search-value = get-field("search-name":U)
  Navigate     = get-field("Navigate":U)
  NavRowid     = get-field("NavRowid":U)
  NavRowid2    = get-field("NavRowid2":U)
  NavRowid3    = get-field("NavRowid3":U)
  NavRowid4    = get-field("NavRowid4":U)
  NavRowid5    = get-field("NavRowid5":U)
  FirstRowid   = get-field("FirstRowid":U)
  Res-Rows     = get-field("ResultRows":U).

Result-Rows = INTEGER(Res-Rows).
IF Result-Rows = 0 THEN 
  Result-Rows = 25.
  
/* For stand alone calling */
RUN OutputContentType IN web-utilities-hdl ("text/html":U).

/* External Table Reference */

/* Define the Query */
DEFINE QUERY Browse-Qry
FOR Salesrep,Order,Customer,OrderLine,Item SCROLLING.

/* Open the Query */
OPEN QUERY Browse-Qry FOR
EACH Salesrep NO-LOCK,
EACH Order WHERE Salesrep.SalesRep = Order.SalesRep NO-LOCK,
EACH Customer WHERE Order.custnum = Customer.CustNum NO-LOCK,
EACH OrderLine WHERE Order.Ordernum = orderline.Ordernum NO-LOCK,
EACH Item WHERE orderline.itemnum = Item.Itemnum NO-LOCK.

IF NOT AVAILABLE Salesrep THEN DO:
  GET FIRST Browse-Qry NO-LOCK.
  FirstRowid = STRING(ROWID(Salesrep)).
END.

{&OUT}
  '<!-- Display Table Definition -->~n':U
  '<TABLE BORDER="2">~n~n':U
  '<!-- Display Column Headings -->~n':U
  '<TH>':U 'Rep Name' '</TH>':U
  '<TH>':U 'Customer Name' '</TH>':U
  '<TH>':U 'Item' '</TH>':U
  '<TH>':U 'Dollars' '</TH>~n':U.

CASE Navigate:
  WHEN "Prev":U THEN DO:
    REPOSITION Browse-Qry TO ROWID TO-ROWID(NavRowid) NO-ERROR.
    IF NOT ERROR-STATUS:ERROR THEN DO:
      GET NEXT Browse-Qry NO-LOCK.
      DO WHILE 
        ROWID(Customer) NE TO-ROWID(NavRowid2) OR 
        ROWID(Order) NE TO-ROWID(NavRowid3) OR 
        ROWID(orderline) NE TO-ROWID(NavRowid4) OR 
        ROWID(Item) NE TO-ROWID(NavRowid5):
        GET NEXT Browse-Qry NO-LOCK.
      END.
      REPOSITION Browse-Qry BACKWARDS 2 NO-ERROR.
      i-count = 1.
      DO WHILE AVAILABLE Salesrep AND i-count < Result-Rows:
        GET PREV Browse-Qry NO-LOCK.
        i-count = i-count + 1.
      END.
    END.
    ELSE
      {&OUT} 
        '<SCRIPT LANGUAGE="JavaScript">~n':U
        'window.alert("Reposition error.  Repositioning to first record.");~n':U
        '</SCRIPT>~n':U.
  END.

  WHEN "Next":U THEN DO:
    REPOSITION Browse-Qry TO ROWID TO-ROWID(NavRowid) NO-ERROR.
    IF NOT ERROR-STATUS:ERROR THEN DO:
      GET NEXT Browse-Qry NO-LOCK.
      DO WHILE 
        ROWID(Customer) NE TO-ROWID(NavRowid2) OR 
        ROWID(Order) NE TO-ROWID(NavRowid3) OR 
        ROWID(OrderLine) NE TO-ROWID(NavRowid4) OR 
        ROWID(Item) NE TO-ROWID(NavRowid5):
        GET NEXT Browse-Qry NO-LOCK.
      END.
      i-count = 0.
      DO WHILE AVAILABLE Salesrep AND i-count < Result-Rows:
        GET NEXT Browse-Qry NO-LOCK.
        i-count = i-count + 1.
      END.
      IF NOT AVAILABLE Salesrep THEN 
        {&OUT} 
          '<SCRIPT LANGUAGE="JavaScript">~n':U
          'window.alert("Reposition error.  Repositioning to first record.");~n':U
          '</SCRIPT>~n':U.
    END.
    ELSE
      {&OUT} 
        '<SCRIPT LANGUAGE="JavaScript">~n':U
        'window.alert("Reposition error.  Repositioning to first record.");~n':U
        '</SCRIPT>~n':U.
  END.
END CASE.

NoNext = FALSE.
/* Output the number of requested Rows to "Result List" */
DO i-count = 1 to Result-Rows:
  IF AVAILABLE Salesrep THEN DO:
    /* Create form buffer for correct data display format */      
    DISPLAY
      Salesrep.RepName
      Customer.Name
      Item.itemname
      orderline.ExtendedPrice
      WITH FRAME ReportFrame.
    IF i-count = 1 THEN DO:
      ASSIGN
        NoPrev         = IF FirstRowid = STRING(ROWID(Salesrep)) 
                         THEN TRUE ELSE FALSE
        DelimiterField = ?
        TmpUrl         = TmpUrl + url-field("NavRowid":U,STRING(ROWID(Salesrep)),DelimiterField)
        /* If more than one table defined in Query, add ROWID here. */
        TmpUrl         = TmpUrl + url-field("NavRowid2":U,STRING(ROWID(Customer)),DelimiterField)
        TmpUrl         = TmpUrl + url-field("NavRowid3":U,STRING(ROWID(Order)),DelimiterField)
        TmpUrl         = TmpUrl + url-field("NavRowid4":U,STRING(ROWID(OrderLine)),DelimiterField)
        TmpUrl         = TmpUrl + url-field("NavRowid5":U,STRING(ROWID(Item)),DelimiterField).
    END.

    /* Output the requested Display Fields */
    {&OUT}
      '<TR>':U
      '<TD>':U Salesrep.repname:SCREEN-VALUE IN FRAME ReportFrame '</TD>':U
      '<TD>':U Customer.Name:SCREEN-VALUE IN FRAME ReportFrame '</TD>':U
      '<TD>':U Item.itemname:SCREEN-VALUE IN FRAME ReportFrame '</TD>':U
      '<TD>':U OrderLine.ExtendedPrice:SCREEN-VALUE IN FRAME ReportFrame '</TD>':U
      '</TR>~n':U.

    GET NEXT Browse-Qry NO-LOCK.
  END.
  ELSE DO:
    /* Reached End of Query */
    NoNext = TRUE.
    LEAVE.
  END.
END. /* Close of "DO i-count = 1 to {&Result-Rows}:" */

{&OUT}
  '</TABLE>':U.
  
IF NoPrev = FALSE THEN
  {&OUT}
    '<P><A HREF="/wsasp/example.asp?ResultRows=' Result-Rows TmpUrl url-field('Navigate','Prev',DelimiterField) '">':U
    SUBSTITUTE('Previous &1 Records', Result-Rows) ' </A>':U.
IF NoNext = FALSE THEN
  {&OUT}
    '<P><A HREF="/wsasp/example.asp?ResultRows=' Result-Rows TmpUrl url-field('Navigate','Next',DelimiterField) '">':U
    SUBSTITUTE('Next &1 Records', Result-Rows) ' </A>':U.

/* aspexp.p - end of file */
