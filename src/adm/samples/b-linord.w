&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          sports           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
  
/* Local Variable Definitions ---                                       */

  DEFINE VARIABLE v-item AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES Order
&Scoped-define FIRST-EXTERNAL-TABLE Order


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Order.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Order-Line

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Order-Line.Line-num ~
Order-Line.Item-num Order-Line.Qty Order-Line.Discount Order-Line.Price ~
Order-Line.Extended-Price Order-Line.Backorder 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table Order-Line.Item-num ~
Order-Line.Qty Order-Line.Discount 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}Item-num ~{&FP2}Item-num ~{&FP3}~
 ~{&FP1}Qty ~{&FP2}Qty ~{&FP3}~
 ~{&FP1}Discount ~{&FP2}Discount ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table Order-Line
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table Order-Line
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Order-Line OF Order NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table Order-Line
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Order-Line


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Order-Line SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Order-Line.Line-num LABEL-FGCOLOR 0 LABEL-BGCOLOR 8
      Order-Line.Item-num LABEL-FGCOLOR 15 LABEL-BGCOLOR 7
      Order-Line.Qty LABEL-FGCOLOR 15 LABEL-BGCOLOR 7
      Order-Line.Discount LABEL-FGCOLOR 15 LABEL-BGCOLOR 7
      Order-Line.Price LABEL-FGCOLOR 0 LABEL-BGCOLOR 8
      Order-Line.Extended-Price LABEL-FGCOLOR 0 LABEL-BGCOLOR 8
      Order-Line.Backorder LABEL-FGCOLOR 0 LABEL-BGCOLOR 8
  ENABLE
      Order-Line.Item-num
      Order-Line.Qty
      Order-Line.Discount
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 90 BY 7.62
         BGCOLOR 11 FGCOLOR 1 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 .

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: sports.Order
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 7.67
         WIDTH              = 90.4.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Default                                      */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "sports.Order-Line OF sports.Order"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > sports.Order-Line.Line-num
"Order-Line.Line-num" ? ? "integer" ? ? ? 8 0 ? no ?
     _FldNameList[2]   > sports.Order-Line.Item-num
"Order-Line.Item-num" ? ? "integer" ? ? ? 7 15 ? yes ?
     _FldNameList[3]   > sports.Order-Line.Qty
"Order-Line.Qty" ? ? "integer" ? ? ? 7 15 ? yes ?
     _FldNameList[4]   > sports.Order-Line.Discount
"Order-Line.Discount" ? ? "integer" ? ? ? 7 15 ? yes ?
     _FldNameList[5]   > sports.Order-Line.Price
"Order-Line.Price" ? ? "decimal" ? ? ? 8 0 ? no ?
     _FldNameList[6]   > sports.Order-Line.Extended-Price
"Order-Line.Extended-Price" ? ? "decimal" ? ? ? 8 0 ? no ?
     _FldNameList[7]   > sports.Order-Line.Backorder
"Order-Line.Backorder" ? ? "logical" ? ? ? 8 0 ? no ?
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Order-Line.Item-num
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Order-Line.Item-num br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF Order-Line.Item-num IN BROWSE br_table /* Item-num */
DO:
  v-item = IF AVAILABLE order-line THEN order-line.item-num
           ELSE 1.
  RUN adm/samples/itemsel.w (INPUT-OUTPUT v-item).
  IF v-item <> ? THEN
      SELF:SCREEN-VALUE = STRING(v-item).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize').        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "Order"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Order"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record B-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE BUFFER oline-buffer FOR order-line.
  
  /* We can't add/edit order-lines if there is no order */
  IF NOT AVAILABLE ORDER THEN DO:
    MESSAGE "Cannot create order-line. " SKIP
            "There is no current order for this customer."
            VIEW-AS ALERT-BOX WARNING.
    UNDO, RETURN ERROR.
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
  /* For new records, assign order-num from the order record,
     next line-num in sequence, and price from the item record. */ 
  RUN get-attribute ('ADM-NEW-RECORD':U).
  IF RETURN-VALUE = "YES":U THEN 
  DO:
      FIND LAST oline-buffer OF order NO-LOCK NO-ERROR.
      ASSIGN order-line.line-num = 
         IF AVAILABLE oline-buffer THEN oline-buffer.line-num + 1 
                                   ELSE 1
             order-line.order-num = order.order-num.
  END.
      
  /* For either a new or existing record, get the item record and make
     sure the price matches the price from the item record.
     Note that extended price is assigned by a db trigger. */
  FIND item WHERE item.item-num = order-line.item-num NO-LOCK NO-ERROR.
  IF NOT AVAILABLE item THEN DO:
      /* If this is the first order-line, then the user had no
         opportunity to enter an item-number, so let it go;
         otherwise complain. */
      IF NUM-RESULTS("{&BROWSE-NAME}") > 0 THEN DO:
        MESSAGE "Item number" order-line.item-num "was not found." 
            VIEW-AS ALERT-BOX ERROR.
        UNDO, LEAVE.
      END.
  END.
  ELSE order-line.price = item.price. 
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "Order"}
  {src/adm/template/snd-list.i "Order-Line"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


