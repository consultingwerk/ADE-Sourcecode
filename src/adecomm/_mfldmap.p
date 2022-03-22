/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*
 * _mfldmap.p - side-by-side field picker
 */

/*
p_nSource -> name of the SmartObject that should be viewed in list 1
p_nDest   -> name of the SmartObject that should be viewed in list 2
p_hSource -> handle to SmartObject that should be viewed in list 1
p_hDest   -> handle to SmartObject that should be viewed in list 2
p_TT      -> ? if no temp-tables need to be included
             Otherwise a comma delitted list where each entry has the form:
             _like-db._like-table|_name
             The _like-db and _like-table are real database.table combinations
             and _name is either the name of the temp-table that is like
             _like-table or ? if it is the same.

p_Items   -> Either "1", "2", or "3".  This indicates the number of
                    components that will be used in the select list 1 and in 
                    the output.  i.e., 1: field, 2: table.field, 3: db.table.field
p_Dlmtr   -> The delimiter of the p_Result List
p_Result  -> input-output list of selected mapped fields
                comes in in the form "customer.cust-num,CustNum"


RUN _mfldmap.p (INPUT source-handle,
                INPUT dest-handle,
                INPUT ?,
                INPUT "2",
                INPUT ",",
                INPUT-OUTPUT p_Result)
        
Create: 03/08 SLK
Modified: 03/98 SLK Allow 1 to 1 only
          03/19/98 SLK Changed parameter to 2 handles vs tableList and handle
          08/18/98 SLK Moved display so that Destination is always on the right
          08/17/99 hd Show EACH array. 
                       Pass 2 to mfldLst and don't run adecomm/_collaps. 
                       Skip all logic to update list of extents 
*/
/*
   IT DOESN'T LOOK LIKE THIS ANYMORE, BUT THIS GIVES YOU THE IDEA! 
  Source Fields                             Target Fields
+------------------------------+ +-----+ +------------------------------+  
| Cust-num                   | | | Map | | customer.Cust-Num          | |  
| Nombre                     | | +-----+ | customer.Addr              | |  
|                            | |         | customer.Address2          | |
|                            | |         | customer.St                | |
|                            | |         | customer.Zip               | |
|                            | |         | customer.Phone             | |
|                            | |         | customer.Contact           | |
|                            | |         | customer.Sales-Rep         | |
|                            | |         |                            | | 
|                            | |         |                            | | 
|                            | |         |                            | | 
+------------------------------+         +------------------------------+ 
Mapped Fields:
+--------------------------------------------------+ +-------+
| City,customer.City                             | | | UnMap |
|                                                | | +-------+
|                                                | |
|                                                | |
|                                                | |
+-------------------------------------------------+
*/     
&GLOBAL-DEFINE WIN95-BTN YES
{adeuib/uibhlp.i}    /* Help contexts */
{adecomm/adestds.i}  /* Standard layout stuff, colors etc. */
{adeuib/sharvars.i}
{adecomm/tt-brws.i "NEW"}
  &IF DEFINED(UIB_is_running) = 0 &THEN
DEFINE INPUT        PARAMETER p_nDest   AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER p_nSource AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER p_hDest   AS HANDLE NO-UNDO.
DEFINE INPUT        PARAMETER p_hSource AS HANDLE NO-UNDO.
DEFINE INPUT        PARAMETER p_TT      AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER p_Items   AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER p_Dlmtr   AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_Result  AS CHARACTER NO-UNDO.
  &ELSE
DEFINE VAR  p_nDest   AS CHARACTER NO-UNDO.
DEFINE VAR  p_nSource AS CHARACTER NO-UNDO.
DEFINE VAR  p_hDest   AS HANDLE NO-UNDO.

DEFINE VAR  p_hSource AS HANDLE NO-UNDO.
DEFINE VAR  p_TT      AS CHARACTER NO-UNDO.
DEFINE VAR  p_Items   AS CHARACTER NO-UNDO.
DEFINE VAR  p_Dlmtr   AS CHARACTER NO-UNDO INIT ",".
DEFINE VAR  p_Result  AS CHARACTER NO-UNDO.

RUN dcust.w PERSISTENT SET p_hSource.
RUN dsls.w PERSISTENT SET  p_hDest.
  
  &ENDIF
  
DEFINE VAR stat AS LOGICAL NO-UNDO. /* For status of widget methods */
 
/*--------------------------------------------------------------------------*/

DEFINE VARIABLE v_TargetLst AS CHARACTER  NO-UNDO
  VIEW-AS SELECTION-LIST SIZE 31 BY 10 SCROLLBAR-V SCROLLBAR-H SORT.
DEFINE VARIABLE v_SourceLst AS CHARACTER NO-UNDO
  VIEW-AS SELECTION-LIST SIZE 31 BY 10 SCROLLBAR-V SCROLLBAR-H SORT.
DEFINE VARIABLE v_MapLst AS CHARACTER NO-UNDO
  VIEW-AS SELECTION-LIST MULTIPLE SIZE 62 BY 3 SCROLLBAR-V SCROLLBAR-H.

DEFINE VARIABLE cArrayEntry AS CHARACTER NO-UNDO.
DEFINE VARIABLE cArrayList  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTemp       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTemp2      AS CHARACTER NO-UNDO.
DEFINE VARIABLE first-time  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE iArrayHigh  AS INTEGER   NO-UNDO.
DEFINE VARIABLE iArrayLow   AS INTEGER   NO-UNDO. 
DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
DEFINE VARIABLE j           AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_Cancel    AS LOGICAL   NO-UNDO.

DEFINE BUTTON   qbf-map            LABEL "&Map"   SIZE 13 BY 1.125.
DEFINE BUTTON   qbf-unmap          LABEL "&Unmap" SIZE 13 BY 1.125.
DEFINE VARIABLE dest_unique-list   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE dest_accept-list   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE dest_supply-list   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE source_unique-list AS CHARACTER           NO-UNDO.
DEFINE VARIABLE source_accept-list AS CHARACTER           NO-UNDO.
DEFINE VARIABLE source_supply-list AS CHARACTER           NO-UNDO.
DEFINE VARIABLE element            AS CHARACTER           NO-UNDO.


DEFINE VARIABLE cnt                AS INTEGER             NO-UNDO.
DEFINE VARIABLE fieldName          AS CHARACTER           NO-UNDO.
DEFINE VARIABLE cTargetLbl         AS CHARACTER           NO-UNDO.
DEFINE VARIABLE cSourceLbl         AS CHARACTER           NO-UNDO.
DEFINE VARIABLE lTargetQueryObj    AS LOGICAL             NO-UNDO.
DEFINE VARIABLE lSourceQueryObj    AS LOGICAL             NO-UNDO.
DEFINE VARIABLE cTargetObjType     AS CHARACTER           NO-UNDO.
DEFINE VARIABLE cSourceObjType     AS CHARACTER           NO-UNDO.
DEFINE VARIABLE dest_TblLst        AS CHARACTER           NO-UNDO.
DEFINE VARIABLE source_TblLst      AS CHARACTER           NO-UNDO.
DEFINE VARIABLE lDbAware           AS LOGICAL             NO-UNDO.

DEFINE BUTTON qbf-ok   LABEL "OK"      {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-cn   LABEL "Cancel"  {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-hlp  LABEL "&Help"   {&STDPH_OKBTN}.

/* Dialog Button Box */
&IF {&OKBOX} &THEN
   DEFINE RECTANGLE rect_Btn_Box {&STDPH_OKBOX}.
&ENDIF

DEFINE VARIABLE t_int AS INTEGER   NO-UNDO. /* scrap/loop */
DEFINE VARIABLE t_log AS LOGICAL   NO-UNDO. /* scrap/loop */

FORM 
  SKIP ({&TFM_WID})
  cSourceLbl   FORMAT "x(50)"         AT 2 VIEW-AS TEXT SIZE 31 BY .7
  cTargetLbl FORMAT "x(50)"           AT 48 VIEW-AS TEXT SIZE 31 BY .7
  SKIP({&VM_WID})
  v_SourceLst                         AT 2              
  v_TargetLst                         AT 48 
  SKIP({&VM_WID})
  "Mapped Fields:"                    AT 2 VIEW-AS TEXT
  v_MapLst                            AT 2
  { adecomm/okform.i
      &BOX    ="rect_Btn_Box"
      &OK     ="qbf-ok"
      &CANCEL ="qbf-cn"
      &HELP   ="qbf-hlp" 
  }
  qbf-map AT ROW-OF v_TargetLst COL 34 SKIP ({&VM_WID})
  qbf-unmap AT ROW 13 COL 66 SKIP ({&VM_WID})
  SKIP ({&VM_WID})
  WITH FRAME FldPicker NO-LABELS
   DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-cn
   TITLE "Multi-Field Mapping":t32 VIEW-AS DIALOG-BOX.
   
ASSIGN v_TargetLst:DELIMITER = p_Dlmtr
       v_SourceLst:DELIMITER = p_Dlmtr
       v_MapLst:DELIMITER = CHR(10).

IF NOT(VALID-HANDLE(p_hDest) AND VALID-HANDLE(p_hSource)) THEN RETURN.

ASSIGN
   cTargetLbl      = p_nDest
   cSourceLbl      = p_nSource.

ASSIGN
   lTargetQueryObj = DYNAMIC-FUNCTION("getQueryObject":U IN p_hDest) 
   cTargetObjType  = DYNAMIC-FUNCTION("getObjectType":U  IN p_hDest) 
   lSourceQueryObj = DYNAMIC-FUNCTION("getQueryObject":U IN p_hSource) 
   cSourceObjType  = DYNAMIC-FUNCTION("getObjectType":U  IN p_hSource) 
NO-ERROR.
IF ERROR-STATUS:ERROR OR (NOT lTargetQueryObj) OR (NOT lSourceQueryObj) THEN RETURN.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

ON "VALUE-CHANGED" OF v_TargetLst IN FRAME FldPicker 
   OR "VALUE-CHANGED" OF v_SourceLst IN FRAME FldPicker DO:
  DEFINE VAR some_thing AS LOGICAL.

  /* If anything highlighted */
  IF (v_TargetLst:SCREEN-VALUE NE ? OR
     v_SourceLst:SCREEN-VALUE NE ? ) AND
     qbf-unmap:SENSITIVE THEN 
  ASSIGN
     v_MapLst:SCREEN-VALUE = ""
     qbf-unmap:SENSITIVE       = NO.
/* IF pair chosen */
  IF v_TargetLst:SCREEN-VALUE NE ? AND
     v_SourceLst:SCREEN-VALUE NE ? AND
     qbf-map:SENSITIVE = FALSE THEN
  ASSIGN   qbf-map:SENSITIVE = TRUE.
END.

ON "VALUE-CHANGED" OF v_MapLst IN FRAME FldPicker DO:
  DEFINE VAR some_thing AS LOGICAL.
  some_thing = SELF:SCREEN-VALUE NE ?. 
  
  /* Sensitize UnMap button only if something is selected */
  IF some_thing NE qbf-unmap:SENSITIVE THEN
    ASSIGN qbf-unmap:SENSITIVE = some_thing.
  
  /* Turn off the Source List and Actions */
  IF qbf-unmap:SENSITIVE
  THEN ASSIGN
    v_TargetLst:SCREEN-VALUE  = ""
    v_SourceLst:SCREEN-VALUE  = ""
    qbf-map:SENSITIVE       = NO.
END.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

ON "GO" OF FRAME FldPicker DO:
     IF v_MapLst:LIST-ITEMS IN FRAME FldPicker = ? THEN
        ASSIGN p_Result = "":U.
     ELSE
     DO:
        ASSIGN p_Result = v_MapLst:LIST-ITEMS IN FRAME FldPicker.
/* *** Don't need to do this; Foreign Fields are displayed in the correct order...
        RUN FlipList(INPUT CHR(10), INPUT-OUTPUT p_Result).
 *** */
        ASSIGN p_Result = REPLACE(p_Result,CHR(10),p_Dlmtr).
     END.
END.  /* On GO of Frame FldPicker */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

ON WINDOW-CLOSE OF FRAME FldPicker
   APPLY "END-ERROR" TO FRAME FldPicker.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
ON   CHOOSE                OF qbf-map    IN FRAME FldPicker
  OR MOUSE-SELECT-DBLCLICK OF v_TargetLst  IN FRAME FldPicker
  OR MOUSE-SELECT-DBLCLICK OF v_SourceLst  IN FRAME FldPicker DO:
  /* Why MOUSE-SELECT-DBLCLICK and not DEFAULT-ACTION?  Because this is in
     a dialog box and the RETURN key will fire the GO for the frame.  I don't
     want it to also fire the MAP trigger. [Arguably, this is a bug with the
     Progress DEFAULT-BUTTON logic.  RETURN should do one or the other, not
     both DEFAULT-ACTION for selection-lists and DEFAULT-BUTTON for the frame */
          
  DEFINE VARIABLE cnt         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE qbf_a       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE qbf_i       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE qbf_v       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE qbf_vsdo    AS CHARACTER NO-UNDO.
  DEFINE VAR empty_target     AS LOGICAL   NO-UNDO.

  IF v_TargetLst:SCREEN-VALUE IN FRAME FldPicker <> ? 
     AND v_SourceLst:SCREEN-VALUE IN FRAME FldPicker <> ? THEN DO:
    /* add to end of mapped list - remove from the dbLst */
    qbf_v = v_TargetLst:SCREEN-VALUE IN FRAME FldPicker.
    qbf_vsdo = v_SourceLst:SCREEN-VALUE IN FRAME FldPicker.

      cTemp = qbf_v.
      
      /*** The arrays are shown individually in the list  
      
      /* If it matches the it is an array thing. */
      IF cTemp MATCHES ("*[*]*") THEN DO:
        ASSIGN cTemp      = TRIM (cTemp)
               cArrayList = SUBSTRING(cTemp,INDEX(cTemp,'[':u) + 1,-1,
                                      "CHARACTER":u)
               cArrayList = REPLACE(cArrayList,"]":u,"")
               cTemp      = SUBSTRING(cTemp,1,INDEX(cTemp,'[':u) - 1,
                                      "CHARACTER":u).

        /* Loop through the list base on " " */
        DO i = 1 TO NUM-ENTRIES (cArrayList, ' '):
          ASSIGN cArrayEntry = ENTRY (i, cArrayList, ' ')
                 iArrayLow   = INTEGER (ENTRY (1, cArrayEntry, '-'))
                 iArrayHigh  = INTEGER (ENTRY (NUM-ENTRIES (cArrayEntry, '-'),
                                                            cArrayEntry, '-')).

          /* Loop through the list base on X-Y. X is the low number.
                                                Y is the high number.           */
          DO j = iArrayLow TO iArrayHigh:
            ASSIGN cArrayEntry = cTemp + '[' + STRING (j) + ']'.
            /* Add element if it is not already there */
            ASSIGN element = qbf_vsdo + ",":U + cArrayEntry.
            IF v_MapLst:LOOKUP(element) = 0 THEN
                   qbf_a = v_MapLst:ADD-LAST (element) IN FRAME FldPicker.
          END. /* DO J */
        END. /* DO I */
      END. /* IF MATCHES */
      
      ELSE 
      ***/
      
      DO:
        /* Make sure displayed order matches the internal storage order
           so people don't get confused when defining the ForeignFields
           property themselves */
        ASSIGN element = qbf_v + ",":U + qbf_vsdo.
        qbf_a = v_MapLst:ADD-LAST(element) IN FRAME FldPicker.
      END.

      /* Keep the position in the db list highlighted if there was only one. */
      RUN adecomm/_delitem.p (v_TargetLst:HANDLE, 
                              qbf_v,
                              OUTPUT cnt).  
      /* Keep the position in the sdo list highlighted if there was only one. */
      RUN adecomm/_delitem.p (v_SourceLst:HANDLE, 
                              qbf_vsdo,
                              OUTPUT cnt).  
      
      ASSIGN stat = v_SourceLst:DELETE (qbf_vsdo)
             stat = v_TargetLst:DELETE (qbf_v). 
    /* If the dbLst has no selection then disable all the buttons */
    qbf-map:SENSITIVE IN FRAME FldPicker = ( v_TargetLst:SCREEN-VALUE NE ? ).
  END.
END /*TRIGGER*/ .

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
*/
ON   CHOOSE                OF qbf-unmap     IN FRAME FldPicker
  OR MOUSE-SELECT-DBLCLICK OF v_MapLst  IN FRAME FldPicker DO:
  /* Why MOUSE-SELECT-DBLCLICK and not DEFAULT-ACTION?  Because this is in
     a dialog box and the RETURN key will fire the GO for the frame.  I don't
     want it to also fire the REMOVE trigger. [Arguably, this is a bug with the
     Progress DEFAULT-BUTTON logic.  RETURN should do one or the other, not
     both DEFAULT-ACTION for selection-lists and DEFAULT-BUTTON for the frame */
  DEFINE VARIABLE qbf_a    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE qbf_i    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE qbf_j    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cnt      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE target_list  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE dest_item  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE source_list AS CHARACTER NO-UNDO.
  DEFINE VARIABLE source_item AS CHARACTER NO-UNDO.
  DEFINE VARIABLE map_item AS CHARACTER NO-UNDO.
  DEFINE VAR empty_target  AS LOGICAL                        NO-UNDO.
  DEFINE VAR element       AS CHARACTER                        NO-UNDO.
  
  IF v_MapLst:SCREEN-VALUE IN FRAME FldPicker <> ? THEN DO:
    /* WORK put back in original position in dbLst */
    ASSIGN
      target_list = v_TargetLst:LIST-ITEMS IN FRAME FldPicker
      source_list = v_SourceLst:LIST-ITEMS IN FRAME FldPicker
      map_item = v_MapLst:SCREEN-VALUE IN FRAME FldPicker.

    /* Fix dblist  and smartdatalist */
    DO qbf_i = 1 TO NUM-ENTRIES(map_item, CHR(10)):
      /* Keep the position in the list highlighted if there was only one. */
      IF NUM-ENTRIES(map_item,CHR(10)) EQ 1 THEN 
          RUN adecomm/_delitem.p (v_MapLst:HANDLE, 
                                   ENTRY (qbf_i, map_item, CHR(10)), 
                                   OUTPUT cnt).
      ELSE 
          stat = v_MapLst:DELETE (ENTRY(qbf_i, map_item, CHR(10))).

      ASSIGN element = ENTRY(1,ENTRY (qbf_i, map_item, CHR(10)),p_Dlmtr).
      
      /* We don't want arrays to appear as ONE element      
      RUN adecomm/_collaps.p (v_TargetLst:HANDLE, element).
      */
      
      RUN addEntry(v_TargetLst:HANDLE, element). 

      ASSIGN element = ENTRY(2,ENTRY (qbf_i, map_item, CHR(10)),p_Dlmtr).
      
      /* No need for this  
      RUN adecomm/_collaps.p (v_SourceLst:HANDLE, element).
      */
      RUN addEntry(v_SourceLst:HANDLE, element). 
    END.

    /* If the target is empty then disable all the buttons. */
    empty_target = ( v_MapLst:SCREEN-VALUE EQ ? ).
    ASSIGN
         qbf-unmap:SENSITIVE IN FRAME FldPicker = NOT empty_target
         .
    /* Empty the screen-value if the list is empty. There seems to be
       a bug here that the SCREEN-VALUE becomes UNKNOWN and stops the
       next VALUE-CHANGED from firing. */
    IF empty_target THEN v_MapLst:SCREEN-VALUE = "".
  END.
END /*TRIGGER*/ .

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

/*----- HELP -----*/
ON HELP OF FRAME FldPicker OR CHOOSE OF qbf-hlp IN FRAME FldPicker
   RUN "adecomm/_adehelp.p" 
     (INPUT "AB", INPUT "CONTEXT", INPUT {&Foreign_Fields}, INPUT ?).


/*--------------------------------------------------------------------------*/

{ adecomm/okrun.i
    &FRAME  = "FRAME FldPicker"
    &BOX    = "rect_Btn_Box"
    &OK     = "qbf-ok"
    &HELP   = "qbf-hlp"
}

/* The current posibilities are:
 *    SmartData -> SmartData
 *    DBBrowser -> SmartData
 *    DBBrowser -> DBBrowser
 *    SmartData -> DBBrowser
 * Target is ALWAYS in the format DB selection list
 */
/* Populates the Target selection list 
 * Target will most likely be a SmartDataObject
 */
IF cTargetObjType = "SmartBusinessObject":U THEN
DO:
  /* RUN createObjects IN p_hDest NO-ERROR. */
  RUN adecomm/_getdlst.p
      (INPUT v_TargetLst:HANDLE,
       INPUT p_hDest,
       INPUT NO,
       INPUT "2",
       INPUT ?,
       OUTPUT t_log).
END.
ELSE
DO:
  /* This section retrieves database fields, so just skip for non-dbaware */  
  IF cTargetObjType = "SmartDataObject":U THEN 
    lDbAware = {fn getDbAware p_hDest}.
  ELSE 
    lDbAware = TRUE.

  IF lDbAware THEN
  DO:
    ASSIGN
       dest_TblLst = DYNAMIC-FUNCTION("getTables":U IN p_hDest) NO-ERROR.
    
    RUN adecomm/_mfldlst.p (
       INPUT v_TargetLst:HANDLE,
       INPUT dest_TblLst,
       INPUT p_TT,
       INPUT YES,
       INPUT p_Items,
       INPUT 2, /* expand EACH array element */
       INPUT "",
       OUTPUT t_log).
  END.
  ELSE  /* not really needed jsut to make it clearer */
    t_log = FALSE. 
END.

IF NOT t_log AND cTargetObjType = "SmartDataObject":U THEN
DO:
   /* We have a DataView  */
   /* OR   */ 
   /* We have an SDO but we did not succeed in building a field list.
    * Assume that this is an SDO built against a temp-table.
    * (NOTE: Although the above procedure should be able to handle 
    *  this case, there currently does not appear to be a way to get
    *  the information needed for the p_TT parameter here.  Note also that
    *  the above function always tries to get the field information 
    *  from a database table, which should not be necessary for an SDO
    *  that queries a temp-table). [1/12/2000 tomn]
    */

    /* dbaware is set for SDO above. dest_TBlList is set for dbaware above. 
       If not dbaware ensure that only DataTable columns can be picked.  */
    IF NOT lDbAware THEN
      dest_TblLst = {fn getDataTable p_hDest}.

    RUN adecomm/_getdlst.p (
       INPUT v_TargetLst:HANDLE,
       INPUT p_hDest,
       INPUT NO,
       INPUT "2|" + dest_TblLst,
       INPUT ?,
       OUTPUT t_log).
END.

/* Populates the Source selection list 
 * Source can be in the format DB selection list or tt selection list
 */

IF cSourceObjType = "SmartDataObject":U THEN 
DO:
  lDbAware = {fn getDbAware p_hSource}.
  IF NOT lDbAware THEN
    source_TblLst = {fn getDataTable p_hSource}.

  RUN adecomm/_getdlst.p (
     INPUT v_SourceLst:HANDLE,
     INPUT p_hSource,
     INPUT NO,
     INPUT IF lDbAware THEN "1"  /* no qualifier for source */
           ELSE "2|" + source_TblLst,
     INPUT ?,
     OUTPUT t_log).

END. /* If SmartData */
ELSE IF cSourceObjType = "SmartBusinessObject":U THEN 
DO:
  RUN adecomm/_getdlst.p (
     INPUT v_SourceLst:HANDLE,
     INPUT p_hSource,
     INPUT NO,
     INPUT "2",
     INPUT ?,
     OUTPUT t_log).
END. /* If SmartData */
ELSE
DO:
   ASSIGN
      source_TblLst = DYNAMIC-FUNCTION("getTables":U IN p_hSource)
   NO-ERROR.
   RUN adecomm/_mfldlst.p (
     INPUT v_SourceLst:HANDLE,
     INPUT source_TblLst,
     INPUT p_TT,
     INPUT YES,
     INPUT "1",
     INPUT 2, /* expand arrays */
     INPUT "",
     OUTPUT t_log).
END. /* If other = SmartDataBrowser referencing a Database */

/* WORK 
   Determines the DB best guess
   FROM keyedit.p. p_hDest must be in the format sports.customer,sports.salesrep 
IF SEARCH("adeuib/_uibinfo.r":U) <> ? THEN
RUN adeuib/_keygues.p (
  INPUT p_hDest,
  OUTPUT dest_unique-list,
  OUTPUT dest_accept-list,
  OUTPUT dest_supply-list).
REMOVE */
  
IF dest_unique-list NE "" THEN DO:
  /* For BROWSE and QUERY objects, the unique-list should probably NOT
   * be in the acceptable keys because they imply a unique entry. */
  cnt = NUM-ENTRIES(dest_accept-list).
  DO i = 1 TO cnt:
     fieldName = ENTRY(i, dest_accept-list).
     IF NOT CAN-DO(dest_unique-list, fieldName) 
     THEN cTemp = (IF cTemp EQ "" THEN "" ELSE cTemp + ",":U) + fieldName.
  END.
  dest_accept-list = cTemp.   
END.

/***** No array elements ()
/* Remove array elements from v_TargetLst that might already be there */ 
IF p_Result NE "" THEN DO:  /* If first time, no need to check for elements */
  DO t_int = 1 TO v_TargetLst:NUM-ITEMS:
    /* Check if an array */
    cTemp = v_TargetLst:ENTRY(t_int).
    
    IF INDEX(cTemp,"[":U) > 0 THEN DO:  /* This is an array */
      ASSIGN cTemp      = TRIM (cTemp)
             cArrayList = SUBSTRING(cTemp,INDEX(cTemp,'[':u) + 1,-1,
                                    "CHARACTER":u)
             cArrayList = REPLACE(cArrayList,"]":u,"")
             cTemp      = ENTRY(1,cTemp,"[":U)
             first-time = TRUE.

      /* Loop through the list base on " " */
      DO i = 1 TO NUM-ENTRIES (cArrayList, ' '):
        ASSIGN cArrayEntry = ENTRY (i, cArrayList, ' ')
               iArrayLow   = INTEGER (ENTRY (1, cArrayEntry, '-'))
               iArrayHigh  = INTEGER (ENTRY (NUM-ENTRIES (cArrayEntry, '-'),
                                                          cArrayEntry, '-')).

        IF first-time THEN /* Clear existing brackets */
          ASSIGN  t_log = v_TargetLst:REPLACE(cTemp + "[]":U, t_int)
                  first-time = FALSE.
                       
        /* Loop through the list base on X-Y. X is the low number.
                                              Y is the high number.           */
        DO j = iArrayLow TO iArrayHigh:
          ASSIGN cArrayEntry = cTemp + '[' + STRING (j) + ']'.
          /* Add and "Collapse" cArrayEntry out if it is NOT
             in the results list                              */
          IF LOOKUP(cArrayEntry, p_Result, p_Dlmtr) = 0 THEN DO:
            RUN adecomm/_collaps.p (v_TargetLst:HANDLE, cArrayEntry).
          END.
        END. /* DO J */
      END. /* DO I */
      IF v_TargetLst:ENTRY(t_int) MATCHES "*[]" THEN
         t_log = v_TargetLst:DELETE(t_int).
    END.  /* This is an array */  
  END. /* DO t_int 1 to num-items */
END.  /* If possibility of array elements */
***/  

/*
** Make sure p_Result items are in the v_TargetLst list and v_SourceLst list.  
** If they are, then remove them and put the item in the v_MapLst selection list.
*/
DO t_int = 1 TO NUM-ENTRIES(p_Result, p_Dlmtr):
  ASSIGN cTemp = ENTRY(t_int,p_Result,p_Dlmtr)   
         t_log = v_TargetLst:DELETE(cTemp) IN FRAME FldPicker
         t_int = t_int + 1
         cTemp2 = ENTRY(t_int,p_Result,p_Dlmtr)
         t_log = v_SourceLst:DELETE(cTemp2) IN FRAME FldPicker
         t_log = v_MapLst:ADD-LAST(cTemp + p_Dlmtr + cTemp2) IN FRAME FldPicker.
END.

/* Highlight these fields */
ASSIGN v_TargetLst:SCREEN-VALUE = dest_accept-list NO-ERROR.
ASSIGN cSourceLbl = "Source: " + cSourceLbl  
       cTargetLbl = "Target: " + cTargetLbl.

RUN center-frame (FRAME FldPicker:HANDLE).

DISPLAY cTargetLbl cSourceLbl 
WITH FRAME FldPicker.
ENABLE v_TargetLst 
       qbf-map 
       v_SourceLst 
       v_MapLst 
       qbf-ok
       qbf-cn 
       qbf-hlp
       WITH FRAME FldPicker.
ASSIGN
   stat = qbf-unmap:MOVE-AFTER-TAB-ITEM(qbf-map:HANDLE IN FRAME FldPicker).

/* Select the first item in the source list */
IF v_TargetLst:NUM-ITEMS > 0 THEN v_TargetLst:SCREEN-VALUE = v_TargetLst:ENTRY(1).

/* Assume a cancel until the user hits OK. */
l_Cancel = YES.
DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  APPLY "ENTRY"  TO v_TargetLst IN FRAME FldPicker.
  WAIT-FOR "CHOOSE" OF qbf-ok IN FRAME FldPicker OR
                 GO OF FRAME FldPicker.   
  /* No Cancel. */
  l_cancel = NO.
END.

HIDE FRAME FldPicker NO-PAUSE.

IF l_Cancel 
THEN RETURN "Cancel":U.
ELSE RETURN.

/* two.p - end of file */

/* This is a kludge for MS-WINDOWS  - see bug # 94-09-16-030.   */
/* When the user dblclicks on a table in the adecomm/_tblsel.p procedure this dialog
   (_mfldmap.p) is brought into context on the MOUSE-SELECT-DOWN of the 2nd click.
   However, the MOUSE-SELECT-UP of the second click "bleeds" through to the underlying
   frame of the UIB design window and attempts to fire the frame-select-up persistent
   trigger.  This fails with an error message that it can't find frame-select-up.  By
   putting this procedure in this file it will find it and supress the error message. */
PROCEDURE frame-select-up.
  RETURN.
END.

/* Internal Procedures */
PROCEDURE flipList:
   DEFINE INPUT        PARAMETER pcDelimeter    AS CHARACTER NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER pcFlipList     AS CHARACTER NO-UNDO.

   DEFINE VARIABLE i                            AS INTEGER   NO-UNDO.
   DEFINE VARIABLE cTmpString                   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cTmpString2                  AS CHARACTER NO-UNDO.

   DO i = 1 TO NUM-ENTRIES(pcFlipList,pcDelimeter):
      ASSIGN  
         cTmpString = ENTRY(i, pcFlipList, pcDelimeter)
         cTmpString2 = cTmpString2 
                       + ENTRY(2, cTmpString, ",":U)
                       + ",":U
                       + ENTRY(1, cTmpString, ",":U)
                       + pcDelimeter.
   END. 
   ASSIGN pcFlipList = SUBSTRING(cTmpString2,1,LENGTH(cTmpString2) - LENGTH(pcDelimeter)).
END PROCEDURE. /* flipList */

/* Internal Procedures */
PROCEDURE addEntry:
   DEFINE INPUT  PARAMETER phHandle  AS HANDLE    NO-UNDO.
   DEFINE INPUT  PARAMETER pcEntry   AS CHARACTER NO-UNDO.

   DEFINE VARIABLE i                            AS INTEGER   NO-UNDO.
   DEFINE VARIABLE cName                        AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cEntry                       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cListName                    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE iArray                       AS INTEGER   NO-UNDO.
   DEFINE VARIABLE iListArray                   AS INTEGER   NO-UNDO.
   DEFINE VARIABLE lOk                          AS LOGICAL   NO-UNDO.

   ASSIGN 
     cName   = ENTRY(1,pcEntry,"[")
     iArray  = IF NUM-ENTRIES(pcEntry,"[") > 1 
               THEN INT(ENTRY(1,ENTRY(2,pcEntry,"["),"]"))
               ELSE 0.
   DO i = 1 TO NUM-ENTRIES(phHandle:LIST-ITEMS):
      ASSIGN
        cEntry     = phHandle:ENTRY(i)
        cListName  = ENTRY(1,cEntry,"[").    
        iListArray = IF NUM-ENTRIES(cEntry,"[") > 1 
                     THEN INT(ENTRY(1,ENTRY(2,cEntry,"["),"]"))
                     ELSE 0.

      IF (cListName > cName) 
      OR (iArray > 0 AND cName = cListName AND iListArray > iArray) THEN 
      DO:
        lOk = phHandle:INSERT(pcEntry,i).
        LEAVE.
      END.
   END.
   /* list was empty or we have a higher value than anything else */
   IF NOT lok THEN 
     phHandle:ADD-LAST(pcEntry).

END PROCEDURE. /* addEntry */

PROCEDURE center-frame:
/*------------------------------------------------------------------------------
  Purpose:  Center dialog box in the middle of the screen. The ROW and COLUMN
            attributes are relative to its parent, so adjust.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phFrame AS HANDLE NO-UNDO.
  
  DEFINE VARIABLE hParent AS HANDLE NO-UNDO.

  ASSIGN
    hParent        = phFrame:PARENT
    phFrame:ROW    = MAXIMUM(1,(SESSION:HEIGHT - phFrame:HEIGHT) / 2) 
                     - hParent:ROW
    phFrame:COLUMN = MAXIMUM(1,(SESSION:WIDTH - phFrame:WIDTH) / 2)
                     - hParent:COLUMN.

END PROCEDURE. /* center-frame */


