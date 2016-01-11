/************************************************************************
* Copyright (C) 2005-2006 by Progress Software Corporation.  All rights *
* reserved.  Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                              *
************************************************************************/
/*----------------------------------------------------------------------------

  File: quryproe.i

  Description: 
   This is the include file containing all of the internal procedures
   from e to z called by the Query Builder
  Input Parameters: N/A

  Output Parameters: N/A
      <none>

  Author: Greg O'Connor

  Created: 03/23/93 - 12:17 pm

  ---------------------------------------------------------------------------*/

/******************************************************************/
/*                     Internal Procedures                        */
/******************************************************************/

/* Check for a selected table */
/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE TableRemove.ip:
  DEFINE VARIABLE cDBnm        AS CHAR    NO-UNDO.
  DEFINE VARIABLE cDefJoin     AS CHAR    NO-UNDO.
  DEFINE VARIABLE cJoinTry     AS CHAR    NO-UNDO.
  DEFINE VARIABLE cTempOne     as char    NO-UNDO.
  DEFINE VARIABLE cFldTemp     as char    NO-UNDO.
  DEFINE VARIABLE cFldTemp-idx as INTEGER NO-UNDO.
  DEFINE VARIABLE cFldDelete   as char    NO-UNDO.
  DEFINE VARIABLE cFldName     as char    NO-UNDO.
  DEFINE VARIABLE cnt          as integer NO-UNDO.
  DEFINE VARIABLE err          as logical NO-UNDO.
  DEFINE VARIABLE pos          as integer NO-UNDO.
  DEFINE VARIABLE nxtname      as char    NO-UNDO.
  DEFINE VARIABLE ix           as integer NO-UNDO.  /* loop index */
  DEFINE VARIABLE i            as integer NO-UNDO.  /* loop index */
  DEFINE VARIABLE lConstant    as logical NO-UNDO. 
  
  DO WITH FRAME dialog-1:
  
  IF (browser-name <> "") THEN RETURN.

  /* Make sure something is selected */
  RUN CheckSelect.ip (OUTPUT iTableNum).
  IF iTableNum = 0 THEN RETURN. 

  /* Get the selected name from the "picked list". */
  cFldTemp = {&CurRight}:SCREEN-VALUE.

  /* Make certain that there isn't an <external> reference */
  DO iTemp = 1 TO NUM-ENTRIES(cFldTemp,{&Sep1}):
    IF NUM-ENTRIES(ENTRY(iTemp,cFldTemp,{&Sep1})," ":U) = 2 THEN DO:
      IF ENTRY(2,ENTRY(iTemp,cFldTemp,{&Sep1})," ":U) = "<External>":U THEN DO:
        MESSAGE "You cannot remove a reference to an external table."
          VIEW-AS ALERT-BOX WARNING.
        RETURN. 
      END.
    END.
  END.

  DO iTemp = 1 TO NUM-ENTRIES (cFldTemp, {&Sep1}):
    ASSIGN
      cTableName = ENTRY (iTemp, cFldTemp, {&Sep1}) /* full entry name */
      cTemp      = ENTRY (1,ENTRY (iTemp, cFldTemp, {&Sep1}), " ") /* table */
      pos        = LOOKUP (cTableName, {&CurRight}:LIST-ITEMS, {&Sep1})
      cDBnm      = IF NUM-ENTRIES(cTemp,".":U) = 2 THEN
                     ENTRY(1,cTemp,".":U) ELSE ?.

    /* Check to see if the table is used anywhere else ! */

    /* First check sort stuff */
    cFldDelete = whRight [{&Sort}]:LIST-ITEMS.
    DO i = 1 to NUM-ENTRIES(cFldDelete, {&Sep1}):  
      IF cDBnm NE ? THEN  
        cFldName = IF NUM-ENTRIES(ENTRY(i,cFldDelete,{&Sep1}),".") = 2 
                   THEN cDBnm + ".":U +
                        ENTRY (1, ENTRY (i, cFldDelete, {&Sep1}), ".") + "." +
                        ENTRY (2, ENTRY (i, cFldDelete, {&Sep1}), ".") 
                   ELSE ENTRY(i, cFldDelete,{&Sep1}). 
      ELSE cFldName = IF NUM-ENTRIES(ENTRY(i,cFldDelete,{&Sep1}),".") = 3 
                   THEN ENTRY (2, ENTRY (i, cFldDelete, {&Sep1}), ".") + "." +
                        ENTRY (3, ENTRY (i, cFldDelete, {&Sep1}), ".") 
                   ELSE ENTRY(i, cFldDelete,{&Sep1}). 
      /* IF the table matches or there is only one table selected that is being 
         deleted then delete the corresponding selected sort of field stuff
         from the selection list and the corresponding data */ 
      IF ENTRY (1, cTemp, " ") = ENTRY(NUM-ENTRIES(cFldName,".":U) - 1, cFldName, ".":U)
         OR (NUM-ENTRIES ({&CurRight}:LIST-ITEMS, {&Sep1}) = 1) THEN DO:
        RUN adecomm/_delitem.p (whRight[{&SORT}]:HANDLE, 
                                ENTRY (i, cFldDelete, {&Sep1}), OUTPUT cnt). 
        ENTRY (i, cMoreData [{&Sort}], {&Sep1}) = "".
      END.
    END.  /* DO i = 1 to NUM-ENTRIES of Sort stuff */
    /* Collapse the data after deletion */
    cMoreData [{&Sort}] = TRIM (REPLACE (cMoreData [{&Sort}], 
                                {&Sep1} + {&Sep1}, {&Sep1}), {&Sep1}).        

    RUN adecomm/_delitem.p ({&CurRight}:HANDLE, cTableName, OUTPUT cnt). 

    /** Rebuild the table list based on the info in the right list **/
    {&CurRight}:PRIVATE-DATA = ?. 
    DO i = 1 to NUM-ENTRIES ({&CurRight}:LIST-ITEMS, {&Sep1}):
      {&CurRight}:PRIVATE-DATA = (IF {&CurRight}:PRIVATE-DATA = ? THEN "" ELSE 
         {&CurRight}:PRIVATE-DATA + {&Sep1}) 
       + ENTRY(1, ENTRY(i, {&CurRight}:LIST-ITEMS, {&Sep1}), " ").
    END. 
  
    /* Check to see if the current table in sort is what has been
       Deleted and if it is reset it to ? cTemp = table only */
    IF (whLeft[{&Sort}]:PRIVATE-DATA = cTemp) THEN
      whLeft[{&Sort}]:PRIVATE-DATA = ?.
    
    /* Check to see if the current table in Join or Where is what has been
       Deleted and if it is reset it to ? cTableName full Right Expression 
       (order OF order-line)                                             */
    DO j = {&Join} TO {&Where}:
      IF (whLeft[j]:PRIVATE-DATA = cTableName) THEN
        whLeft[j]:PRIVATE-DATA = ?.
    END.

    /*	Delete all the ttWhere records.                                   */
    DO j = {&Join} TO {&Where}:
      FOR EACH ttWhere WHERE ttWhere.iState = j AND ttWhere.cTable = cTemp:
        DELETE ttWhere.
      END.
      
      IF pos > 0 THEN DO:
        /* Delete where and join criteria of deleted table  */
        IF (j = {&Where}) THEN acWhere [pos] = "".
                          ELSE acJoin  [pos] = "".
      END.

      /* Now delete where and join criteria of subsequent tables that
         envolve deleted table                                           */
      DO i = pos TO NUM-ENTRIES({&CurRight}:LIST-ITEMS,{&Sep1}):
        IF (j = {&Where}) AND INDEX(acWhere[MAX(i,1)], cTemp) > 0 THEN acWhere[MAX(i,1)] = "".
        IF (j = {&Join}) AND INDEX(acJoin[MAX(i,1)], cTemp) > 0 THEN acJoin[MAX(i,1)] = "".

        /* Search subsequent default joins (ie order-line of order) to
           see if any need to be changed from using the deleted table as
           the "OF" part.                                                */
        cDefJoin = ENTRY(i,{&CurRight}:LIST-ITEMS,{&Sep1}).
        IF i > 1 AND  /* First table gets handled later */
          j = {&Join} AND 
          NUM-ENTRIES(cDefJoin," ":U) = 3 AND
          ENTRY(2,cDefJoin," ":U) = "OF":U AND
          ENTRY(3,cDefJoin," ":U) = cTemp THEN DO:
          lOK = ?.
          FIND-JOIN-BLOCK:
          DO ix = 1 TO (i - 1):
           ASSIGN cDefJoin = ENTRY(1, cDefJoin, " ":U)
                  cJoinTry = ENTRY(1, 
                             ENTRY(ix, {&CurRight}:LIST-ITEMS, {&Sep1})," ":U).
            IF NUM-ENTRIES(cDefJoin,".":U) = 2 THEN /* Get the Table name */
              cDefJoin = ENTRY(2,cDefJoin,".":U).
            IF NUM-ENTRIES(cJoinTry,".":U) = 2 THEN /* Get the Table name */
              cJoinTry = ENTRY(2,cJoinTry,".":U).
            RUN IsJoinable.ip(cDefJoin, cJoinTry, OUTPUT lOK).
            IF (lOK) THEN LEAVE FIND-JOIN-BLOCK.                  
          END.
          /* Prepare to keep cFldTemp current with {&CurRight}:LIST-ITEMS */
          ASSIGN cFldtemp-idx = LOOKUP(ENTRY(i,{&CurRight}:LIST-ITEMS,{&Sep1}),
                                          cFldtemp, {&Sep1}).
          IF lOK THEN
            lOK = {&CurRight}:REPLACE(
              ENTRY(1,ENTRY(i,{&CurRight}:LIST-ITEMS,{&Sep1})," ":U) + " OF " +
                ENTRY(1, ENTRY(ix, {&CurRight}:LIST-ITEMS, {&Sep1})," ":U), i).
          ELSE
            lOK = {&CurRight}:REPLACE(
              ENTRY(1,ENTRY(i,{&CurRight}:LIST-ITEMS,{&Sep1})," ":U) 
              + " WHERE " +
              ENTRY(1, ENTRY(MAX(1,pos - 1),
                    {&CurRight}:LIST-ITEMS, {&Sep1})," ":U) + " ...", i).
          IF cFldTemp-idx > 0 THEN
            ENTRY(cFldTemp-idx, cFldtemp, {&Sep1}) = 
                  ENTRY(i, {&CurRight}:LIST-ITEMS, {&Sep1}).

        END.  /* If j = join and TABLE OF DELETED_TABLE */
      END.  /* DO i = pos TO NUM-ENTRIES */
    END.  /* DO j = join to where */

    /* Insert field back in it's proper place.  Determine the position
       this field took in original field list.  Look from this point
       down in original list until  find an entry that is still in
       the left hand field list.  This is the entry we want to insert
       above.                                                           */ 
    IF (NUM-ENTRIES (cTemp, ".") > 1) THEN
      ASSIGN cTableName  = cTemp  /* cTableName is tb.fld or db.tb.fld  */
             ENTRY (NUM-ENTRIES (cTableName, "."), cTableName, ".") = ""
                                  /* cTableName is tb. or db.tb.        */
	      cTableName  = TRIM (REPLACE (cTableName, "..", "."), ".")
	                           /* cTableName is tb or db.tb          */
             cTemp       = ENTRY (NUM-ENTRIES (cTemp, "."), cTemp, ".").
                                  /* cTemp is fld */

    IF cTableName = eCurrentTable or cDBnm = ? THEN DO:
      /* Insert removed table into left */
      /* This code assumes that the list on the Left side is in
         aplhabetical order and will insert or add accordingly  */
      Insert-loop:
      DO j = 1 TO NUM-ENTRIES ({&CurLeft}:LIST-ITEMS, {&Sep1}):
        IF (ENTRY (j, {&CurLeft}:LIST-ITEMS, {&Sep1}) > cTemp) THEN DO:
          ASSIGN err   = {&CurLeft}:INSERT(cTemp, 
                              ENTRY (j, {&CurLeft}:LIST-ITEMS, {&Sep1}))
                 cTemp = "".
          LEAVE Insert-Loop.
        END.
      END.  /* Insert-Loop: do j = 1 to Num-Entries */

      IF j > NUM-ENTRIES ({&CurLeft}:LIST-ITEMS, {&Sep1}) THEN
        err = {&CurLeft}:ADD-LAST(cTemp).
    END.  /* If the table is the same */

    /* Scrolling disabled to avoid a serious of bugs that occur when
       a user tries to delete all the tables */ 
    /* RUN adecomm/_scroll.p ({&CurLeft}:HANDLE, INPUT cTemp). */
   
  END. /* END DELETE LOOP */

  /*
  ** If we are deleting the first item and there are more items then
  ** remove the stuff on the right of the 2 item which soon will be the
  ** First item
  */
  IF (NUM-ENTRIES (ENTRY (1, {&CurRight}:LIST-ITEMS, {&Sep1}), " ") > 2) THEN
    ASSIGN
      cFieldName = {&CurRight}:LIST-ITEMS
      cTempOne = ENTRY (1, {&CurRight}:LIST-ITEMS, {&Sep1})
      cTempOne = ENTRY (1, cTempOne, " ")
      ENTRY (1, cFieldName, {&Sep1}) = cTempOne
      {&CurRight}:LIST-ITEMS = cFieldName  
      .
  ASSIGN
    whLeft[INTEGER (rsMain:SCREEN-VALUE)]:LIST-ITEMS = {&CurLeft}:LIST-ITEMS.


  DO j = {&Sort} TO {&Options}:
    IF ((NUM-ENTRIES ({&CurLeft}:LIST-ITEMS, {&Sep1}) = 1) AND 
         NUM-ENTRIES (whRight [j]:LIST-ITEMS, "."   ) > 1) THEN DO:
      cTemp = whRight [j]:LIST-ITEMS.

      DO i = 1 to NUM-ENTRIES (cTemp, {&Sep1}):
        ASSIGN
          ENTRY(i,cTemp,{&Sep1})        = ENTRY(NUM-ENTRIES(
                                            ENTRY(i,cTemp,{&Sep1}),"."), 
                                            ENTRY(i,cTemp,{&Sep1}),".")
          ENTRY(i,cMoreData[j],{&Sep1}) = ENTRY(NUM-ENTRIES(
                                            ENTRY(i,cMoreData[j],{&Sep1}),"."), 
                                            ENTRY(i,cMoreData[j],{&Sep1}),".")
          .
      END.
      whRight [j]:LIST-ITEMS = cTemp.
    END.
  END.
  RUN BuildQuery.ip (OUTPUT eDisplayCode). 
  RUN RadioSetEnable.ip.

  ASSIGN
    eDisplayCode:SCREEN-VALUE = eDisplayCode
    bCheckSyntax:SENSITIVE    = (IF eDisplayCode <> "" THEN TRUE ELSE FALSE).  
    
  RUN RadioSetEnable.ip.
  RUN EvaluateIndexReposition.ip.
END.
END PROCEDURE.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE RightRemove.ip:   
  DEFINE VARIABLE cArrayList   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cArrayEntry  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lArray       AS LOGICAL   NO-UNDO INIT FALSE.
  DEFINE VARIABLE lMatch       AS LOGICAL   NO-UNDO INIT FALSE.
  DEFINE VARIABLE cName        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFldName     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTempOrg     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cnt          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE err          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE pos          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE nxtname      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ix           AS INTEGER   NO-UNDO.  /* loop index */
  DEFINE VARIABLE i            AS INTEGER   NO-UNDO.  /* loop index */
  DEFINE VARIABLE k            AS INTEGER   NO-UNDO.  /* loop index */
  DEFINE VARIABLE icurrent     AS INTEGER   NO-UNDO.  /* loop index */

  DO WITH FRAME dialog-1:
  
    /* Make sure something is selected */
    RUN CheckSelect.ip (OUTPUT iTableNum).
    IF iTableNum = 0 THEN RETURN. 
  
    /* Get the selected name from the "picked list". */
    ASSIGN cFldName = {&CurRight}:SCREEN-VALUE.  

    DO iTemp = 1 TO NUM-ENTRIES(cFldName,{&Sep1}):
      ASSIGN cTableName = ENTRY(iTemp,cFldName,{&Sep1})
             cTemp      = IF SUBSTRING(ENTRY(1,cTableName),1,1,
                                       "CHARACTER":u) <> "(":U 
                          THEN ENTRY(1,cTableName," ")
                          ELSE cFldName
             i          = LOOKUP(cTemp,{&CurRight}:LIST-ITEMS,{&Sep1}).

      /* message '2'  cFldName i skip {&CurRight}:LIST-ITEMS skip cTemp skip
         view-as alert-box. */
    
      /* Remove this name from the "picked list" */
      RUN adecomm/_delitem.p ({&CurRight}:HANDLE, cTableName, OUTPUT cnt).
       
      /* message '21' cFldName skip {&CurRight}:LIST-ITEMS skip cTemp skip
         view-as alert-box. */
      /* Insert field back in it's proper place.  Determine the position 
         this field took in original field list.  Look from this point down 
         in original list until find an entry that is still in the left hand 
         field list.  This is the entry we want to insert above.                      */ 
      IF ((NUM-ENTRIES (cTemp, ".") > 1) 
        AND ({&DisFieldList} <> {&CurTable})) 
        AND INDEX(cTemp,"(":U) = 0 THEN
        ASSIGN cTableName = cTemp
               ENTRY (NUM-ENTRIES (cTableName, "."), cTableName, ".") = ""
               cTableName = TRIM (REPLACE (cTableName, "..", "."), ".")
               cTemp      = ENTRY (NUM-ENTRIES (cTemp, "."), cTemp,".").
            
      IF {&Sort-Mode} OR {&Options-Mode} THEN DO: 
        ASSIGN 
          ENTRY(i,{&CurData},{&Sep1}) = ""
            {&CurData} = TRIM(REPLACE({&CurData},{&Sep1} + {&Sep1},{&Sep1}),
                             {&Sep1}).
      
        RUN DisplaySort.ip (FALSE, 0, INPUT-OUTPUT eDisplayCode).
        eDisplayCode:SCREEN-VALUE = eDisplayCode.
      END.

      /* IF the current table is not a match to the table part of the 
         deleting item Next. */
      IF ((ENTRY(NUM-ENTRIES(cTableName,".":U),cTableName,".":U) <> {&CurTable})
         AND (cTableName <> cTemp)) THEN NEXT.

      /* IF the field is in the field and we are dealing with the display 
         field list List continue.  */
      IF (CAN-DO (whLeft[{&Options}]:LIST-ITEMS, cTemp)) THEN NEXT.

      /* Adds to the left side and handle array junk...	*/
      RUN adecomm/_collaps.p ({&CurLeft}:HANDLE, cTemp).

      /* Select the cTemp value, making sure it's in view. */
      /* RUN adecomm/_scroll.p ({&CurLeft}:HANDLE, INPUT cTemp). */
    END.

    DO j = {&Sort} TO {&Options}:
      IF ((NUM-ENTRIES ({&TableRight}:LIST-ITEMS, {&Sep1}) = 1)
        AND NUM-ENTRIES (whRight [j]:LIST-ITEMS, ".") > 1) 
        AND INDEX(whRight [j]:LIST-ITEMS,"(":U) = 0 THEN DO:
	cTemp = whRight [j]:LIST-ITEMS.  
        DO i = 1 to NUM-ENTRIES (cTemp, {&Sep1}):
          ASSIGN ENTRY(i,cTemp,{&Sep1}) = ENTRY(NUM-ENTRIES(
                                            ENTRY(i,cTemp,{&Sep1}),"."), 
                                            ENTRY(i,cTemp,{&Sep1}),".")
                 ENTRY(i,cMoreData[j],{&Sep1}) = ENTRY(NUM-ENTRIES(
                                            ENTRY(i,cMoreData[j],{&Sep1}),"."), 
                                            ENTRY(i,cMoreData[j],{&Sep1}),".")
                 .
        END.  /* Do i = 1 to NUM-ENTRIES */
        whRight [j]:LIST-ITEMS = cTemp.
      END.
    END.  /* DO iTEMP = 1 to NUM-ENTRIES of cFldName */ 
  END.  /* DO WITH FRAME DIALOAG-1 */
END.  /* End Procedure */

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE FieldFormat.ip:

DEFINE INPUT PARAMETER cList AS CHARACTER.

DEFINE VARIABLE cFormat AS CHARACTER.
DEFINE VARIABLE counter AS INTEGER.

DO WITH FRAME dialog-1:

  IF cList = ? OR NUM-ENTRIES(cList,{&Sep1}) <> 1 THEN DO:
    ASSIGN
      eFieldLabel:SENSITIVE     = FALSE
      eFieldFormat:SENSITIVE    = FALSE
      bFieldFormat:SENSITIVE    = FALSE
      eFieldLabel:SCREEN-VALUE  = ""
      eFieldFormat:SCREEN-VALUE = "".
    RETURN.
  END.

  /* 
  ** Get the current Label and if it is NOT set get the label's value
  ** from the data base
  */
  IF (ENTRY (2, ENTRY (LOOKUP (cList, {&CurRight}:LIST-ITEMS, {&Sep1}), 
               {&CurData}, {&Sep1}), {&sep2}) = "") THEN
    RUN DB_Field.ip (cList, "LABEL", OUTPUT cTemp).
  ELSE
    cTemp = ENTRY (2, ENTRY (LOOKUP (cList, {&CurRight}:LIST-ITEMS, {&Sep1}), 
               {&CurData}, {&Sep1}), {&sep2}).

  eFieldLabel:SCREEN-VALUE  = REPLACE (cTemp, "!", CHR(10)).
  /* 
  ** Get the currenet Format and if it is NOT set get the Format's value
  ** from the data base
  */
  IF (ENTRY (3, ENTRY (LOOKUP (cList, {&CurRight}:LIST-ITEMS, {&Sep1}), 
               {&CurData}, {&Sep1}), {&sep2}) = "") THEN
  DO:
    RUN DB_Field.ip (cList, "FORMAT", OUTPUT cTemp).
    DO counter = 2 TO NUM-ENTRIES (cTemp):
	  IF (counter = 2) THEN
        cFormat = ENTRY (counter, cTemp).
	  ELSE
        cFormat = cFormat + "," + ENTRY (counter, cTemp).
    END.
    eFieldFormat:SCREEN-VALUE = cFormat. /* DB_Field returns TYPE,FORMAT */
  END.
  ELSE
    eFieldFormat:SCREEN-VALUE = 
      ENTRY (3, ENTRY (LOOKUP (cList, {&CurRight}:LIST-ITEMS, {&Sep1}), 
               {&CurData}, {&Sep1}), {&sep2}).
   
  ASSIGN					          
    eFieldLabel:SENSITIVE     = TRUE
    eFieldFormat:SENSITIVE    = TRUE
    bFieldFormat:SENSITIVE    = TRUE
    .
END.
END PROCEDURE.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE ValueChangeRight.ip:
DEFINE VARIABLE cSelection AS CHARACTER NO-UNDO.

DO WITH FRAME dialog-1: 
  {&CurLeft}:SCREEN-VALUE   = "".    

  IF {&Table-Mode} THEN DO:
     /*
     ** For Tables do these steps (don't allow select of <external> tables
     */      
     cSelection = "".
     DO i = 1 TO NUM-ENTRIES(SELF:SCREEN-VALUE, {&Sep1}):
       cTemp = ENTRY(i, SELF:SCREEN-VALUE, {&Sep1}).
       IF NUM-ENTRIES(cTemp," ") eq 1 OR CAN-DO("OF,WHERE":U,ENTRY(2,cTemp," "))
       THEN cSelection = cSelection 
                       + (IF cSelection ne "" THEN {&Sep1} ELSE "") + cTemp. 
     END.
   END.        
   
  /*
  ** Make these assigns all the time
  */
  ASSIGN 
    cTemp   = SELF:SCREEN-VALUE
    sIndex  = cTemp
    {&CurLeft}:SCREEN-VALUE = "".

  RUN adeshar/_qset.p ("setUpDown",application,TRUE).

  /*
  ** For Sorts, do these steps
  */
  IF {&Sort-Mode} THEN DO:
    RUN CheckSelect.ip (OUTPUT i).
    rsSortDirection:SENSITIVE = i > 0.
    RUN DisplaySort.ip (FALSE, 0, INPUT-OUTPUT eDisplayCode).
    ASSIGN eDisplayCode:SCREEN-VALUE = eDisplayCode.
  END.
  
  /*
  ** For Fields, do these steps
  */
  ELSE IF {&Options-Mode} THEN 
    RUN FieldFormat.ip ({&CurRight}:SCREEN-VALUE).	
  END.
END.


/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE ValueChangeLeft.ip:
  DO WITH FRAME dialog-1: 
    ASSIGN
      {&CurRight}:SCREEN-VALUE = ""
      lPasted                  = FALSE.

    RUN adeshar/_qset.p ("setUpDown":u,application,TRUE).

    CASE rsMain:SCREEN-VALUE:
      WHEN "{&Options}":u THEN
        RUN FieldFormat.ip ({&CurRight}:SCREEN-VALUE).	     
      WHEN "{&Where}":u THEN 
        RUN LeftWhere.ip (TRUE).
    END CASE. 
  END.
END.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE MoveList.ip:
  DEFINE INPUT        PARAMETER lUp        AS LOGICAL NO-UNDO.
  DEFINE INPUT        PARAMETER cValue     AS CHARACTER NO-UNDO.
  DEFINE INPUT        PARAMETER cSeparator AS CHARACTER NO-UNDO. 
  DEFINE INPUT-OUTPUT PARAMETER cList      AS CHARACTER NO-UNDO.

  /* DEFINE VARIABLE cSeparator  AS CHARACTER NO-UNDO INIT {&Sep1}. */
  DEFINE VARIABLE i     AS INTEGER     NO-UNDO.
  DEFINE VARIABLE j     AS INTEGER     NO-UNDO.
  
  /*  
  message 
    'MOVELIST:' skip
    'CVALUE: [' cValue    ']' skip
    'CLIST:  [' cList   ']'skip
    'CSEP:   [' cSeparator  ']'
    View-as alert-box error buttons Ok.
  */  
  
  DO WITH FRAME dialog-1:
  IF (cValue <> ?) THEN DO:
    i = LOOKUP(ENTRY(1,cValue,cSeparator),cList,cSeparator).

    DO j = 1 TO NUM-ENTRIES(cValue,cSeparator):
      ASSIGN
        ENTRY(LOOKUP(ENTRY(j,cValue,cSeparator),cList,cSeparator),
                           cList,cSeparator) = ""
        cList = TRIM(REPLACE(cList,cSeparator + cSeparator,cSeparator), 
                     cSeparator).
    END.

    ASSIGN
      cList = TRIM(cList,cSeparator)
      i = (IF lUp THEN  MAXIMUM (i - 1, 1) ELSE 
                        MINIMUM (i, NUM-ENTRIES(cList, cSeparator))).

    IF i = 0 THEN
      cList = cValue.
    ELSE DO:
      IF (lUp) THEN
        ENTRY(i,cList,cSeparator) = cValue
                                  + (IF cList = "" THEN "" ELSE cSeparator 
                                     + ENTRY(i,cList,cSeparator)).
	  ELSE
        ENTRY(i,cList,cSeparator) = ENTRY(i,cList,cSeparator) 
                                  + cSeparator + cValue.
    END.
  END /* IF */ .

  END /* DO */ .
END.

/*--------------------------------------------------------------------------*/
ON DEFAULT-ACTION OF v_pick IN FRAME fr_pick 
  APPLY "GO" TO FRAME fr_pick.
/*--------------------------------------------------------------------------*/

PROCEDURE pickTable.ip: 
DO WITH FRAME dialog-1:
  DEFINE INPUT        PARAMETER ip_list AS CHARACTER NO-UNDO. /* list */
  DEFINE INPUT-OUTPUT PARAMETER io_pick AS CHARACTER NO-UNDO. /* value */ 

  DEFINE VARIABLE DecoupleFlg AS LOGICAL INIT FALSE.
  /*
  ** Check to see if this is the first entry that isn't an external table 
  */  
  IF NUM-ENTRIES(whRight[{&Table}]:LIST-ITEMS,{&Sep1}) > iXternalCnt THEN DO:  
    IF ENTRY(iXternalCnt + 1,whRight[{&Table}]:LIST-ITEMS,{&Sep1}) = 
      whRight[{&Table}]:SCREEN-VALUE THEN
      DecoupleFlg = TRUE.
  END.

  ASSIGN
    v_pick:DELIMITER  IN FRAME fr_pick   = {&Sep1}
    v_pick:LIST-ITEMS IN FRAME fr_pick   = IF DecoupleFlg THEN
                                             "(None)" + {&Sep1} + ip_list  
                                           ELSE ip_list
    v_pick:SCREEN-VALUE IN FRAME fr_pick = 
      (IF LOOKUP(io_pick,ip_list,{&Sep1}) > 0 THEN 
        io_pick ELSE ENTRY(1, ip_list, {&Sep1}))
    io_pick                              = ?.
  
  ENABLE v_pick bOk bCancel WITH FRAME fr_pick.

  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    WAIT-FOR GO OF FRAME fr_pick FOCUS v_pick IN FRAME fr_pick.
    io_pick = v_pick:SCREEN-VALUE IN FRAME fr_pick.   
  END.

  HIDE FRAME fr_pick NO-PAUSE.
  END.
END PROCEDURE. /* pick_a_table.ip */

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE Join.ip:

DEFINE INPUT PARAMETER cInsert   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER lOperator AS LOGICAL NO-UNDO.

DO WITH FRAME dialog-1:

  FIND LAST ttWhere WHERE INTEGER(rsMain:SCREEN-VALUE) = ttWhere.iState
    AND lLeft:SCREEN-VALUE = ttWhere.cTable.

  i = ttWhere.iSeq.
  /* If text selected, merely replace and return.  CURSOR-OFFSET is in
     column units, not characters, so we use RAW -dma */
  IF eDisplayCode:SELECTION-TEXT <> "" THEN
    ASSIGN
      lOK = eDisplayCode:REPLACE-SELECTION-TEXT(cInsert).
  ELSE IF (ttWhere.iOffset > 1 AND
           ttWhere.iOffset < LENGTH(ttWhere.cExpression,"RAW":u)) THEN
    ASSIGN
      eDisplayCode:SCREEN-VALUE  = SUBSTRING(ttWhere.cExpression,1,
                                     ttWhere.iOffset - 1,"RAW":u)
                                 + cInsert 
                                 + SUBSTRING(ttWhere.cExpression,
                                     ttWhere.iOffset,-1,"RAW":u)
      eDisplayCode:CURSOR-OFFSET = ttWhere.iOffset 
                                 + LENGTH(cInsert,"RAW":u)
      lWhState                   = ttWhere.lWhState
      .

  ELSE
    ASSIGN
      eDisplayCode:SCREEN-VALUE  = 
        (IF (eDisplayCode:SCREEN-VALUE = "" 
           OR eDisplayCode:SCREEN-VALUE = ? ) THEN cInsert 
         ELSE eDisplayCode:SCREEN-VALUE +
               (IF CAN-DO("AND,OR":U,cInsert) THEN CHR(10) + "  " 
                                             ELSE " ") + cInsert)

      eDisplayCode:CURSOR-OFFSET = LENGTH(eDisplayCode:SCREEN-VALUE,"RAW":u) + 1
      .

  CREATE ttWhere.

  ASSIGN
    /*
    eDisplayCode:SENSITIVE     = (IF eDisplayCode:SCREEN-VALUE > "" THEN TRUE 
                                  ELSE FALSE)
    */
    ttWhere.iState             = INTEGER (rsMain:SCREEN-VALUE)
    ttWhere.cTable             = lLeft:SCREEN-VALUE 
    ttWhere.iSeq               = i + 1
    ttWhere.cExpression        = eDisplayCode:SCREEN-VALUE 
    ttWhere.iOffset            = eDisplayCode:CURSOR-OFFSET 
    ttWhere.lOperator          = lOperator
    ttWhere.lWhState           = lWhState
    {&CurRight}:PRIVATE-DATA   = eDisplayCode:SCREEN-VALUE 
    {&CurLeft}:SCREEN-VALUE    = ""
    {&CurRight}:SCREEN-VALUE   = ""
    {&CurLeft}:SENSITIVE       = ttWhere.lOperator
    {&CurRight}:SENSITIVE      = ttWhere.lOperator
    bUndo:SENSITIVE            = TRUE
    bCheckSyntax:SENSITIVE     = TRUE
    acJoin [LOOKUP ({&CurTable}, eCurrentTable:List-Items, {&Sep1}) +
           (IF iXternalCnt = 0 THEN 1 ELSE iXternalCnt)] = ttWhere.cExpression
    .

  RUN adeshar/_qset.p ("SetOperatorsSensitive.ip":u,application,NOT lOperator).

  END.
END PROCEDURE.

/*--------------------------------------------------------------------------*/
PROCEDURE LeftWhere.ip:
  DEFINE INPUT PARAMETER lSelect AS LOGICAL NO-UNDO. 

DO WITH FRAME dialog-1:

  DEFINE VARIABLE cTemp      AS CHARACTER NO-UNDO. /* scrap */
  DEFINE VARIABLE sTemp      AS CHARACTER NO-UNDO. /* scrap */
  DEFINE VARIABLE i          AS INTEGER   NO-UNDO. /* scrap */
  DEFINE VARIABLE cMatchName AS CHARACTER NO-UNDO. /* fieldname pattern match */
  /*DEFINE VARIABLE cFieldName AS CHARACTER NO-UNDO. /* selected field name */*/

  FIND LAST ttWhere WHERE INTEGER (rsMain:SCREEN-VALUE) = ttWhere.iState
                      AND lLeft:SCREEN-VALUE            = ttWhere.cTable.
     
  ASSIGN
    i          = ttWhere.iSeq
    cTemp      = TRIM(eDisplayCode:SCREEN-VALUE)
    sTemp      = TRIM({&CurLeft}:SCREEN-VALUE).

  /* calc field in Results */
  IF {&Where-Mode} AND application = "Results_Where":u 
    AND sTemp MATCHES "*(*)" THEN 
    ASSIGN
      res_calcfld = TRUE
      cFieldName  = TRIM(SUBSTRING(sTemp,1,INDEX(sTemp,"(":u) - 1,"CHARACTER":u))
      .
  ELSE
    ASSIGN
      res_calcfld = FALSE
      cFieldName  = lLeft:SCREEN-VALUE + "." + sTemp /* whLeft */
      .

  /* If this is a value-change sensitize the operators and leave */
  IF lSelect THEN DO:
    RUN load_ops.
    eCurrentTable:SENSITIVE = FALSE.
    RETURN.
  END.

  /* From here down, we're dealing with double-click (pasted) case */
  
  /* if text selected, merely replace and return */
  IF eDisplayCode:SELECTION-TEXT <> "" THEN
    lOK = eDisplayCode:REPLACE-SELECTION-TEXT (cFieldName).
  ELSE DO:
    /* If picking field name, check to see if it should replace the last
       field name selected in the editor widget.
    */
    IF res_calcfld THEN
      cMatchName = cFieldName.
    ELSE
      RUN guess_field (OUTPUT cMatchName). /* do NOT put into cLastField */

    IF cMatchName <> ? AND (cTemp = cMatchName
      OR cTemp MATCHES "*":u + CHR(10) + " AND ":u + cMatchName
      OR cTemp MATCHES "*":u + CHR(10) + " OR ":u  + cMatchName) THEN DO:
      cTemp = TRIM(SUBSTRING(" ":u + cTemp,1,R-INDEX(CHR(10) + cTemp,CHR(10)),
                             "CHARACTER":u)).
    END.
   
    IF (ttWhere.iOffset > 1 
       AND ttWhere.iOffset < LENGTH(ttWhere.cExpression,"RAW":u)) THEN
       ASSIGN
         eDisplayCode:SCREEN-VALUE  = SUBSTRING(ttWhere.cExpression,1,
                                        ttWhere.iOffset - 1,"RAW":u)
                                    + cFieldName 
                                    + SUBSTRING(ttWhere.cExpression,
                                        ttWhere.iOffset,-1,"RAW":u)
         eDisplayCode:CURSOR-OFFSET = ttWhere.iOffset 
                                    + LENGTH(cFieldName,"RAW":u)
         lWhState                   = ttWhere.lWhState
         .
    ELSE
    ASSIGN
      eDisplayCode:SCREEN-VALUE = 
        (IF cTemp = "" THEN "" ELSE cTemp + " ":U) +
        (IF NOT tAskRun THEN cFieldName ELSE '') /* dma */

      eDisplayCode:CURSOR-OFFSET = LENGTH(eDisplayCode:SCREEN-VALUE,"RAW":u) + 1
      .
  END.

  CREATE ttWhere.
  ASSIGN
    cLastField                 = cFieldName
    ttWhere.iState             = INTEGER (rsMain:SCREEN-VALUE)
    ttWhere.cTable             = lLeft:SCREEN-VALUE
    ttWhere.iSeq               = i + 1
    ttWhere.cExpression        = eDisplayCode:SCREEN-VALUE 
    ttWhere.cLastField         = cLastField 
    ttWhere.iOffset            = eDisplayCode:CURSOR-OFFSET 
    ttWhere.lWhState           = lWhState
    {&CurLeft}:SCREEN-VALUE    = ""
    {&CurRight}:SCREEN-VALUE   = ""
    {&CurLeft}:SENSITIVE       = ttWhere.lOperator
    {&CurRight}:SENSITIVE      = ttWhere.lOperator
    bCheckSyntax:SENSITIVE     = TRUE
    bUndo:SENSITIVE            = TRUE
    acWhere[LOOKUP({&CurTable},eCurrentTable:LIST-ITEMS,
       {&Sep1}) + iXternalCnt] = ttWhere.cExpression
    .
  RUN load_ops.

  /*
   * Load_ops changes the cLastField. Since this op is putting
   * a field into the editor, set it to the one we want it to
   * be, not what load_ops guesses at what it is.
   */
  cLastField = cFieldName.
END.
END PROCEDURE.

/*--------------------------------------------------------------------------*/
/* try to get the last field listed in the expert window */

PROCEDURE guess_field:
  DEFINE OUTPUT PARAMETER cFieldTarget AS CHARACTER NO-UNDO. /* potential field */
  DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO. /* return value */
  DEFINE VARIABLE cTemp   AS CHARACTER NO-UNDO.  /* Scratch variable */
  DEFINE VARIABLE lHiden  AS LOGICAL   NO-UNDO. 

DO WITH FRAME dialog-1:

  ASSIGN
    cfieldtarget = trim(edisplaycode:SCREEN-VALUE ,
            " ,()=<>":u + CHR(9) + CHR(10) + CHR(13))
    cFieldTarget = 
      (IF cFieldTarget = "" THEN ? ELSE 
         ENTRY(NUM-ENTRIES(cFieldTarget, " ":u), cFieldTarget, " ":u))
    cFieldTarget = 
      (IF {&CurLeft}:SCREEN-VALUE <> ? THEN 
         lLeft:SCREEN-VALUE + "." + {&CurLeft}:SCREEN-VALUE 
       ELSE cFieldTarget).   

  IF NUM-ENTRIES(cFieldTarget,".":u) <> 3 THEN .
  ELSE IF lHiden THEN DO:
    /* if only one db available, quicker to search ourselves. */
    FIND FIRST DICTDB._Db NO-LOCK.
    IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN
      FIND DICTDB._File OF DICTDB._Db
        WHERE LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0 AND
              DICTDB._File._File-name = ENTRY(2,cFieldTarget,".":u)
        NO-LOCK NO-ERROR.
    ELSE
      FIND DICTDB._File OF DICTDB._Db
        WHERE DICTDB._File._File-name = ENTRY(2,cFieldTarget,".":u)
        NO-LOCK NO-ERROR.
    IF AVAILABLE DICTDB._File THEN
      FIND DICTDB._Field OF DICTDB._File
        WHERE DICTDB._Field._Field-name = ENTRY(3,cFieldTarget,".":u)
        NO-LOCK NO-ERROR.
    ELSE
      RELEASE DICTDB._Field. /* just in case... */
    IF NOT AVAILABLE DICTDB._Field THEN cFieldTarget = ?.
  END.
  ELSE DO:
    /* but if more than one db connected, call professional help. */
    cTemp = cLastField.
    IF ENTRY(1,cLastField,".":U) = "Temp-Tables" THEN DO:
      FIND _tt-tbl WHERE _tt-tbl.tt-name = ENTRY(2,cLastField,".":U).
      cTemp = _tt-tbl.like-db + ".":U + _tt-tbl.like-table + ".":U +
              ENTRY(3,cLastField,".").
    END.
    ELSE IF NUM-ENTRIES(cLastField,".":U) > 1 THEN DO: /* Perhaps a buffer */
      FIND FIRST _tt-tbl WHERE
           _tt-tbl.tt-name = ENTRY(1,cLastField,".":U) NO-ERROR.
      IF AVAILABLE _tt-tbl THEN 
        cTemp = _tt-tbl.like-db + ".":U + _tt-tbl.like-table + ".":U +
                ENTRY(2,cLastField,".").
    END.

    RUN adecomm/_y-schem.p (cTemp,"","",OUTPUT cAnswer).
    IF cAnswer = ? THEN cFieldTarget = ?.
  END.
  
  END.
END PROCEDURE. /* guess_field */

/*--------------------------------------------------------------------------*/
/* load up appropriate comparison operators into qbf-p */
PROCEDURE load_ops:

DO WITH FRAME dialog-1:
 
  DEFINE VARIABLE iExtent     AS INTEGER   NO-UNDO. /* extent */
  DEFINE VARIABLE i           AS INTEGER   NO-UNDO. /* scrap */
  DEFINE VARIABLE cListItems  AS CHARACTER NO-UNDO. /* LIST-ITEMS string */
  DEFINE VARIABLE cDataType   AS CHARACTER NO-UNDO. /* datatype */
  DEFINE VARIABLE cFormat     AS CHARACTER NO-UNDO. /* format */
  DEFINE VARIABLE cGuessField AS CHARACTER NO-UNDO. /* guessed field name */
  DEFINE VARIABLE cTemp       AS CHARACTER NO-UNDO. /* Scratch variable */
  DEFINE VARIABLE lQBW        AS LOGICAL   NO-UNDO. /* is qbw field? */

  IF res_calcfld THEN
    cGuessField = cFieldName.
  ELSE
    RUN guess_field (OUTPUT cGuessField). /* returns ? for unknown field */

  IF NUM-ENTRIES(cGuessField," ":U) > 1 THEN
    cGuessField = ENTRY(NUM-ENTRIES(cGuessField," ":U),
                                    cGuessField," ":U).
  cLastField = (IF cGuessField = ? THEN cLastField ELSE cGuessField).
  cLastField = (IF cLastField <= "" OR cLastField = ? THEN 
                lLeft:SCREEN-VALUE + "." + {&CurLeft}:SCREEN-VALUE
                ELSE cLastField ).

  IF _AliasList > "" AND NOT res_calcfld THEN DO:
    IF (NUM-ENTRIES (cLastField, ".") < 3) THEN 
      ENTRY(1,cLastField,".":u) = _AliasList.
    ELSE
      ENTRY(2,cLastField,".":u) = ENTRY(NUM-ENTRIES(_AliasList,".":u),
                                        _AliasList,".":u).
  END.

  IF (cCurrentDb <= "" ) THEN cCurrentDb = LDBNAME(1).

  IF cLastField <> ? AND cLastField <> "" THEN DO:
    IF res_calcfld THEN DO:
      RUN aderes/_calctyp.p (cGuessField,OUTPUT cDataType,OUTPUT cFormat).

      ASSIGN
        iExtent = 0
        lQBW    = FALSE.
    END.
    ELSE DO:
      IF (NUM-ENTRIES (cLastField, ".") < 3) AND
         NOT CAN-FIND(FIRST _tt-tbl WHERE _tt-tbl.tt-name = ENTRY(1,cLastField,".":U))
        THEN /* Normal db table */
       RUN adecomm/_y-schem.p (cCurrentDb + ".":u + cLastField,"","",
                                     OUTPUT cListItems).
      ELSE DO: /* Else a temp-table or buffer */
        cTemp = cLastField.
        IF cCurrentDB = "Temp-Tables" THEN DO:
          IF ENTRY(1,cLastField,".":U) = "Temp-Tables":U THEN DO: /* A temp-table */
            FIND _tt-tbl WHERE _tt-tbl.tt-name = ENTRY(2,cLastField,".":U).
            cTemp = _tt-tbl.like-db + ".":U + _tt-tbl.like-table + ".":U +
                    ENTRY(3,cLastField,".").
          END. /* A temp-table */
          ELSE DO: /* Probably a buffer */
            FIND FIRST _tt-tbl WHERE _tt-tbl.tt-name = ENTRY(1,cLastField,".":U) NO-ERROR.
            IF AVAILABLE _tt-tbl THEN
              cTemp = _tt-tbl.like-db + ".":U + _tt-tbl.like-table + ".":U +
                      ENTRY(2,cLastField,".").
          END. /* Probably a buffer */
        END.  /* If current db is the virtual temp-table database */
        RUN adecomm/_y-schem.p (cTemp,"","",OUTPUT cListItems).
      END. /* Else a temp-table or buffer */

      ASSIGN cDataType = ENTRY(1,cListItems)
             iExtent   = INTEGER(ENTRY(2,cListItems))
             lQBW      = (ENTRY(4,cListItems) = "y":u).
    END.
  END.

  cListItems = "".

  /* if data type is datetime or datetime-tz, then set it to date */
  IF CAN-DO("34,40",cDataType) THEN
      cDataType = "2".

  /*if data type is INT64, then set it to integer*/
  IF cDataType = "41" THEN
      cDataType = "4".

  /* If field name is unknown, load up everything. */
  /* If selection-text non-null and guess_field = ?, load up everything. */
  DO i = 1 TO EXTENT(acWhereState):
    IF   /* (cLastField = ?) 
      OR */ (cGuessField = ? AND eDisplayCode:SELECTION-TEXT <> "")
      OR (INDEX(ENTRY(1,acWhereState[i]),"q":u) > 0 AND lQBW)
      OR (INDEX(ENTRY(1,acWhereState[i]),cDataType) > 0) THEN
    CASE i:
      WHEN {&bEqual}        THEN bEqual:SENSITIVE        = TRUE.
      WHEN {&bNotEqual}     THEN bNotEqual:SENSITIVE     = TRUE.
      WHEN {&bLess}         THEN bLess:SENSITIVE         = TRUE.
      WHEN {&bGreater}      THEN bGreater:SENSITIVE      = TRUE.
      WHEN {&bLessEqual}    THEN bLessEqual:SENSITIVE    = TRUE.
      WHEN {&bGreaterEqual} THEN bGreaterEqual:SENSITIVE = TRUE.
      WHEN {&bBegins}       THEN bBegins:SENSITIVE       = TRUE.
      WHEN {&bMatches}      THEN bMatches:SENSITIVE      = TRUE.
      WHEN {&bRange}        THEN bRange:SENSITIVE        = TRUE.
      WHEN {&bList}         THEN bList:SENSITIVE         = TRUE.
      WHEN {&bContains}     THEN bContains:SENSITIVE     = TRUE.
      WHEN {&bAnd}          THEN bAnd:SENSITIVE          = TRUE.
      WHEN {&bOr}           THEN bOr:SENSITIVE           = TRUE.
    END CASE.
  ELSE
    CASE i:
      WHEN {&bEqual}        THEN bEqual:SENSITIVE        = FALSE.
      WHEN {&bNotEqual}     THEN bNotEqual:SENSITIVE     = FALSE.
      WHEN {&bLess}         THEN bLess:SENSITIVE         = FALSE.
      WHEN {&bGreater}      THEN bGreater:SENSITIVE      = FALSE.
      WHEN {&bLessEqual}    THEN bLessEqual:SENSITIVE    = FALSE.
      WHEN {&bGreaterEqual} THEN bGreaterEqual:SENSITIVE = FALSE.
      WHEN {&bBegins}       THEN bBegins:SENSITIVE       = FALSE.
      WHEN {&bMatches}      THEN bMatches:SENSITIVE      = FALSE.
      WHEN {&bRange}        THEN bRange:SENSITIVE        = FALSE.
      WHEN {&bList}         THEN bList:SENSITIVE         = FALSE.
      WHEN {&bContains}     THEN bContains:SENSITIVE     = FALSE.
      WHEN {&bAnd }         THEN bAnd:SENSITIVE          = FALSE.
      WHEN {&bOr }          THEN bOr:SENSITIVE           = FALSE.
    END CASE.
  END.
END.
END PROCEDURE. /* load_ops */


/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
 returns TRUE if syntax error 
-------------------------------------------------------------*/
PROCEDURE IsJoinable.ip:

  DEFINE INPUT        PARAMETER cRight    AS CHARACTER NO-UNDO.
  DEFINE INPUT        PARAMETER cLeft     AS CHARACTER NO-UNDO.
  DEFINE OUTPUT       PARAMETER lJoinable AS LOGICAL NO-UNDO.

  DEFINE VARIABLE cDbRight AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDbLeft  AS CHARACTER NO-UNDO.

  DO WITH FRAME dialog-1:

    /* First, worry about any Aliases */ 
    IF (cCurrentDb <= "" ) THEN cCurrentDb = LDBNAME(1).

    IF NUM-ENTRIES(_AliasList) = 3 AND ENTRY(3, _AliasList) <> "" THEN
        cLeft = ENTRY(3, _AliasList).
    IF ENTRY(1, _AliasList) <> "" THEN cRight = ENTRY(1, _AliasLIst).
    IF NUM-ENTRIES (cRight, ".") = 1 THEN cDbRight  = cCurrentDb + "." + cRight.
                                     ELSE cDbRight  = cRight.
    IF NUM-ENTRIES (cLeft, ".") = 1 THEN cDbLeft  = cCurrentDb + "." + cLeft.
                                    ELSE cDbLeft  = cLeft.
    IF cCurrentDB = "Temp-Tables":U THEN DO:
      /* External tables can get confused with temp-tables */
      IF NOT CAN-FIND(FIRST _tt-tbl WHERE _tt-tbl.tt-name = ENTRY(2,cDBLeft,".":U))
      THEN ENTRY(1,cDBLeft,".":U) = LDBNAME(1).
      IF NOT CAN-FIND(FIRST _tt-tbl WHERE _tt-tbl.tt-name = ENTRY(2,cDBRight,".":U))
      THEN ENTRY(1,cDBRight,".":U) = LDBNAME(1).
    END.  /* cCurrentDB is Temp-Tables */

    /* If dealing with temp-tables or buffer then use like things instead */
    IF cDBLeft BEGINS "Temp-Tables." THEN DO:
      FIND _tt-tbl WHERE _tt-tbl.tt-name = ENTRY(2,cDBLeft,".":U).
      cDBLeft = _tt-tbl.like-db + ".":U + _tt-tbl.like-table.
    END. /* If a temp-table */
    
    IF cDBRight BEGINS "Temp-Tables." THEN DO:
      FIND _tt-tbl WHERE _tt-tbl.tt-name = ENTRY(2,cDBRight,".":U).
      cDBRight = _tt-tbl.like-db + ".":U + _tt-tbl.like-table.
    END.

    RUN adecomm/_j-test.p (cDbLeft, cDbRight, OUTPUT lOK).
    IF NOT lOK THEN
      RUN adecomm/_j-test.p (cDbRight, cDbLeft, OUTPUT lOK).
    lJoinable = lOk.
    IF lJoinable AND {&Join-Mode} THEN DO:
      RUN adeshar/_qset.p ("SetJoinOperatorsSensitive.ip":U,
                            application, tJoinable).
      ASSIGN whLeft[{&Join}]:SENSITIVE = tJoinable
             whRight[{&Join}]:SENSITIVE = tJoinable.
    END.  /* IF lJoinable AND Join-Mode */
  END. /* DO WITH FRAME dialog-1 */
END PROCEDURE. 

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
 returns TRUE if syntax error 
-------------------------------------------------------------*/
PROCEDURE SetCustJoin.ip:
  DO WITH FRAME dialog-1:
  
    IF (lLeft:SCREEN-VALUE > "") THEN DO:
      RUN IsJoinable.ip (lLeft:SCREEN-VALUE, lRight:SCREEN-VALUE,
                         OUTPUT lOK).
      ASSIGN tJoinable:visible = lOK.
      IF NUM-ENTRIES({&CurTable}," ":U) > 1 THEN DO: 
        IF (ENTRY (2, {&CurTable}, " ") = "OF") THEN DO:
          /** Change to WHERE **/
          tJoinable:CHECKED = FALSE.
          APPLY "ENTRY" TO tJoinable.
        END.
        ELSE tJoinable:CHECKED = TRUE.
      END. /* If the tables have a natural join */
      IF NOT tJoinable:VISIBLE THEN
        ASSIGN whLeft[{&Join}]:SENSITIVE  = TRUE
               whRight[{&Join}]:SENSITIVE = TRUE
               eDisplayCode:READ-ONLY     = FALSE
               eDisplayCode:BGCOLOR       = ?.
      ELSE DO:
        ASSIGN whLeft[{&Join}]:SENSITIVE  = tJoinable:CHECKED
               whRight[{&Join}]:SENSITIVE = tJoinable:CHECKED
               eDisplayCode:READ-ONLY     = NOT tJoinable:CHECKED.
        IF tJoinable:CHECKED THEN 
          ASSIGN eDisplayCode:BGCOLOR  = ?.
      END.
    END. 
  END. 
END PROCEDURE. 

/* -----------------------------------------------------------
  Purpose:     RadioSetEnable.ip  
  Parameters:  <none>
  Notes:       Enable/Disable the radio set at the top of the
               screen based on the number of tables selected. 
               We only need to do this if we have changed the
               state of the flag: lNo_Tables.    
-------------------------------------------------------------*/
PROCEDURE RadioSetEnable.ip:  
 
  DEFINE VARIABLE ix        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cButton   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cList     AS CHARACTER NO-UNDO 
    INITIAL "Join,Where,Options,Sort":u.
  DEFINE VARIABLE NoEntries AS INTEGER   NO-UNDO. 

  /*
  ** Note: this procedure turns on and off the radio set items that
  ** control the QB's state.  It's very important to disable states that
  ** don't make any sense to avoid 'ENTRY n not found ...' errors that
  ** occur when a join is attempted with one table, for example.
  ** Rewritten by R. Ryan 8/94.
  */
   
  DO WITH FRAME dialog-1:  
    IF Application <> "{&UIB_SHORT_NAME}" THEN RETURN. /* i.e don't do this for Results */
    
    NoEntries = NUM-ENTRIES(whRight[{&Table}]:LIST-ITEMS,{&Sep1}).

    IF NoEntries = 0 OR 
       NoEntries = ? OR
       iXternalCnt >= NoEntries
    THEN DO: 
      /*
      ** No tables are selected or the only tables selected are external 
      ** ones, then disable all valid buttons
      */                                   
      DO ix = 1 TO NUM-ENTRIES(cList):  
        cButton = ENTRY(ix, cList).
        IF CAN-DO (pcValidStates, cButton)
        THEN lConstant = rsMain:DISABLE(cButton) NO-ERROR.
      END.
    END.
    
    ELSE DO:
      /*
      ** Enable everything. Do Special cases for the "Join" and
      ** "Sort" buttons.
      */ 
      IF CAN-DO (pcValidStates, "Join":U) THEN DO:
        /* Don't enable the Join button if there is only one table
           and nothing to join it to. */
        IF (iXternalCnt = 0 AND NoEntries = 1) OR 
           (NoEntries <= iXternalCnt)
        THEN lConstant = rsMain:DISABLE("Join":U) NO-ERROR.
        ELSE lConstant = rsMain:ENABLE("Join":U) NO-ERROR.
      END.
      IF CAN-DO (pcValidStates, "Sort":U) THEN DO:       
        /* If there is a SortBy-Phrase, don't allow user to go to
           Sort Page. */
        IF tSortByPhrase
        THEN lConstant = rsMain:DISABLE("Sort":U) NO-ERROR.
        ELSE lConstant = rsMain:ENABLE("Sort":U) NO-ERROR. 
      END.
      /* Do the other pages. */
      DO ix = 2 TO NUM-ENTRIES(cList) - 1:   
        cButton = ENTRY(ix, cList).
        IF CAN-DO (pcValidStates, cButton)     
        THEN lConstant = rsMain:ENABLE(cButton) NO-ERROR.
      END.
    END.

   IF NoEntries NE ? THEN 
      b_fields:SENSITIVE = b_fields:VISIBLE AND NoEntries > iXternalCnt.
    ELSE b_fields:SENSITIVE = FALSE.
  END.  
  
END PROCEDURE. 

/* quryproe.i - end of file */
