/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _fldseld.p - Single Field Selector for Data-Fields. From _mfldsel.p.
 */

/*
p_TblList     -> list of dbname.tables that should be viewed in list 1 (the left
                 side)
                 Note: Leave blank ("") if selecting from a DataObject.
p_hDataObject -> handle to DataObject that should be viewed in list 1
p_TT          -> ? if no temp-tables need to be included
                 Otherwise a comma delitted list where each entry has the form:
                 _like-db._like-table|_name
                 The _like-db and _like-table are real database.table combinations
                 and _name is either the name of the temp-table that is like
                 _like-table or ? if it is the same.

p_Items       -> Either "1", "2", or "3".  This indicates the number of
      	          components that will be used in the select lists and in 
                 the output.  i.e., 1: field, 2: table.field, 3: db.table.field
p_Dlmtr       -> The delimiter of the p_Result List
p_DType    - The data type to screen for.  If this is ?, then don't screen.
                    Otherwise this must be either
                     "character"
                     "date"
                     "decimal"
                     "integer"
                     "logical"
                     "recid"
p_Result      -> input-output list of selected fields
*/

&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/commeng.i}  /* Help contexts */
{adecomm/adestds.i}  /* Standard layout stuff, colors etc. */
{adecomm/tt-brws.i "NEW"}

DEFINE INPUT        PARAMETER p_TblLst AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER p_hDataObject AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT        PARAMETER p_TT     AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER p_Items  AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER p_Dlmtr  AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER p_DType  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_Result AS CHARACTER NO-UNDO.

DEFINE VARIABLE stat          AS LOGICAL NO-UNDO. /* For status of widget methods */
DEFINE VARIABLE useDataObject AS LOGICAL NO-UNDO.

/*--------------------------------------------------------------------------*/

DEFINE VARIABLE v_SrcLst AS CHARACTER  NO-UNDO
  VIEW-AS SELECTION-LIST SINGLE SIZE 50 by 10 SCROLLBAR-V SCROLLBAR-H.

DEFINE VARIABLE cArrayEntry AS CHARACTER NO-UNDO.
DEFINE VARIABLE cArrayList  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTemp       AS CHARACTER NO-UNDO.
DEFINE VARIABLE first-time  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE iArrayHigh  AS INTEGER   NO-UNDO.
DEFINE VARIABLE iArrayLow   AS INTEGER   NO-UNDO. 
DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
DEFINE VARIABLE j           AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_Cancel    AS LOGICAL   NO-UNDO.

DEFINE BUTTON qbf-ok   label "OK"      {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-cn   label "Cancel"  {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-hlp  label "&Help"   {&STDPH_OKBTN}.

/* Dialog Button Box */
&IF {&OKBOX} &THEN
   DEFINE RECTANGLE rect_Btn_Box {&STDPH_OKBOX}.
&ENDIF

DEFINE VARIABLE t_int AS INTEGER   NO-UNDO. /* scrap/loop */
DEFINE VARIABLE t_log AS LOGICAL   NO-UNDO. /* scrap/loop */

FORM 
  SKIP ({&TFM_WID})
  "Available Fields:":L31 AT 2 VIEW-AS TEXT
  SKIP({&VM_WID})

  v_SrcLst     	     	  AT 2 

  { adecomm/okform.i
      &BOX    ="rect_Btn_Box"
      &OK     ="qbf-ok"
      &CANCEL ="qbf-cn"
      &HELP   ="qbf-hlp" 
  }
  SKIP ({&VM_WID})
  WITH FRAME FldPicker NO-LABELS
   DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-cn
   TITLE "Field Selector":t32 VIEW-AS DIALOG-BOX.
   
ASSIGN v_SrcLst:DELIMITER  = p_Dlmtr.


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

ON "GO" OF FRAME FldPicker
  OR DEFAULT-ACTION OF v_SrcLst  IN FRAME FldPicker
DO:
  DEFINE VARIABLE tmp-entry AS CHARACTER                             NO-UNDO.
  DEFINE VARIABLE i         AS INTEGER                               NO-UNDO.

  p_Result = (IF v_SrcLst:SCREEN-VALUE IN FRAME FldPicker = ?
              THEN ""
              ELSE v_SrcLst:SCREEN-VALUE IN FRAME FldPicker
              ).

  IF INDEX(p_TblLst,"Temp-Tables":U) > 0 THEN DO:
    DO i = 1 TO NUM-ENTRIES(p_Result, p_Dlmtr):
      tmp-entry = ENTRY(i, p_Result, p_Dlmtr).
      IF NUM-ENTRIES(tmp-entry,".":U) = 2 AND
         LOOKUP("Temp-Tables.":U + ENTRY(1, tmp-entry, ".":U), p_TblLst) > 0
      THEN ENTRY(i, p_Result, p_Dlmtr) = "Temp-Tables.":U + tmp-entry.
      ELSE IF NUM-ENTRIES(tmp-entry,".":U) = 1 /* Assume DataObject RowObject table. jep-code */
      THEN ENTRY(i, p_Result, p_Dlmtr) = "Temp-Tables.RowObject.":U + tmp-entry.
    END.  /* Do i = 1 to Num-Entries */
  END.  /* If  there are temp-tables in the initial table list */

END.  /* On GO of Frame FldPicker */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

ON WINDOW-CLOSE OF FRAME FldPicker
   APPLY "END-ERROR" TO FRAME FldPicker.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* jep-unfinished - must change to Data_Field_Selection for help. */
ON HELP of FRAME FldPicker OR CHOOSE OF qbf-hlp IN FRAME FldPicker
   RUN "adecomm/_adehelp.p" (INPUT "comm", INPUT "CONTEXT", 
      	       	     	     INPUT {&Multi_Field_Selection},
      	       	     	     INPUT ?).


/*--------------------------------------------------------------------------*/

{ adecomm/okrun.i
    &FRAME  = "FRAME FldPicker"
    &BOX    = "rect_Btn_Box"
    &OK     = "qbf-ok"
    &HELP   = "qbf-hlp"
}

useDataObject = IF VALID-HANDLE(p_hDataObject) THEN TRUE ELSE FALSE.

/* JEP-UNFINISHED - _getdlst.p: should this support temp-tables? */
IF useDataObject THEN
    RUN adecomm/_getdlst.p
        (INPUT v_SrcLst:HANDLE,
         INPUT p_hDataObject,
         INPUT no,
         INPUT p_Items,
         INPUT p_DType,
         OUTPUT t_log).
/* Add temp-tables fields to the available list.
  This used to be an ELSE. I changed it to the IF check instead.
  jep-code */
IF (useDataObject <> TRUE) OR (p_TT <> ?) THEN
    RUN adecomm/_mfldlst.p
        (INPUT v_SrcLst:HANDLE,
         INPUT p_TblLst,
         INPUT p_TT,
         INPUT yes,
         INPUT p_Items,
         INPUT 1,
         INPUT "",
         OUTPUT t_log).
  
/* Remove array elements from v_SrcLst that might already be there */ 
IF p_Result NE "" THEN DO:  /* If first time, no need to check for elements */
  DO t_int = 1 TO v_SrcLst:NUM-ITEMS:
    /* Check if an array */
    cTemp = v_SrcLst:ENTRY(t_int).
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
          ASSIGN  t_log = v_SrcLst:REPLACE(cTemp + "[]":U, t_int)
                  first-time = FALSE.
                       
        /* Loop through the list base on X-Y. X is the low number.
                                              Y is the high number.           */
        DO j = iArrayLow TO iArrayHigh:
          ASSIGN cArrayEntry = cTemp + '[' + STRING (j) + ']'.
          /* Add and "Collapse" cArrayEntry out if it is NOT
             in the results list                              */
          IF LOOKUP(cArrayEntry, p_Result, p_Dlmtr) = 0 THEN DO:
            RUN adecomm/_collaps.p (v_SrcLst:HANDLE, cArrayEntry).
          END.
        END. /* DO J */
      END. /* DO I */
      IF v_SrcLst:ENTRY(t_int) MATCHES "*[]" THEN
         t_log = v_SrcLst:DELETE(t_int).
    END.  /* This is an array */  
  END. /* DO t_int 1 to num-items */
END.  /* If possibility of array elements */
   
/*
** Remove p_Result items from source list. They are not meant to be
** part of selection.
*/
DO t_int = 1 TO NUM-ENTRIES(p_Result, p_Dlmtr):
  ASSIGN t_log = v_SrcLst:DELETE(ENTRY(t_int,p_Result, p_Dlmtr)) IN FRAME FldPicker.
END.

ENABLE v_SrcLst qbf-ok qbf-cn qbf-hlp
       WITH FRAME FldPicker.

/* Select the first item in the source list */
IF v_SrcLst:NUM-ITEMS > 0 THEN v_SrcLst:SCREEN-VALUE = v_SrcLst:ENTRY(1).

/* Assume a cancel until the user hits OK. */
l_Cancel = yes.
DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  APPLY "ENTRY"  TO v_SrcLst IN FRAME FldPicker.
  WAIT-FOR GO OF FRAME FldPicker
           OR DEFAULT-ACTION OF v_SrcLst  IN FRAME FldPicker.
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
   (_mfldsel.p) is brought into context on the MOUSE-SELECT-DOWN of the 2nd click.
   However, the MOUSE-SELECT-UP of the second click "bleeds" through to the underlying
   frame of the UIB design window and attempts to fire the frame-select-up persistent
   trigger.  This fails with an error message that it can't find frame-select-up.  By
   putting this procedure in this file it will find it and supress the error message. */
PROCEDURE frame-select-up.
  RETURN.
END.
