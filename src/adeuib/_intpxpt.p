/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------

File: adeuib/_intpxpt.p 

Description:
    lets the user select and deselect several internal procedures
    the selected procedures get the status "EXPORT"
    the unselected ones     get the status "NORMAL"
    
Input-Parameters
    none
    
Output-Parameters:
    none

Notes:
    copied and adjusted from adecomm/_mfldsel.p
    
Author: Tom Hutegger

History:
    hutegger    94/03       creation
    
--------------------------------------------------------------------*/        

/*----------------------------  DEFINES  ---------------------------*/
&GLOBAL-DEFINE WIN95-BTN

{adecomm/commeng.i}          /* Help contexts                            */
{adecomm/adestds.i}          /* Standard layout stuff, colors etc.       */
{adeuib/uniwidg.i}           /* Universal Widget TEMP-TABLE definition   */
{adeuib/triggers.i}          /* Trigger TEMP-TABLE definition            */
{adeuib/sharvars.i}          /* Define _h_win etc.                       */
{adeuib/uibhlp.i}

DEFINE VAR stat AS LOGICAL NO-UNDO. /* For status of widget methods */
 
/*--------------------------------------------------------------------------*/

DEFINE VARIABLE v_SrcLst AS CHARACTER  NO-UNDO
  VIEW-AS SELECTION-LIST MULTIPLE SIZE 31 by 10 SCROLLBAR-V SCROLLBAR-H.
DEFINE VARIABLE v_TargLst AS CHARACTER NO-UNDO
  VIEW-AS SELECTION-LIST MULTIPLE SIZE 31 by 10 SCROLLBAR-V SCROLLBAR-H.

DEFINE BUTTON qbf-ad LABEL "&Add >>"    SIZE 15 BY 1.125.
DEFINE BUTTON qbf-rm LABEL "<< &Remove" SIZE 15 BY 1.125.

Define button qbf-ok   label "OK"      {&STDPH_OKBTN} AUTO-GO.
Define button qbf-cn   label "Cancel"  {&STDPH_OKBTN} AUTO-ENDKEY.
Define button qbf-hlp  label "&Help"   {&STDPH_OKBTN}.

/* Dialog Button Box */
&IF {&OKBOX} &THEN
   DEFINE RECTANGLE rect_Btn_Box {&STDPH_OKBOX}.
&ENDIF

DEFINE VARIABLE t_int AS INTEGER   NO-UNDO. /* scrap/loop */
DEFINE VARIABLE t_log AS LOGICAL   NO-UNDO. /* scrap/loop */

FORM 
  SKIP ({&TFM_WID})
  "Available:":L31     AT  3 VIEW-AS TEXT
  "Selected:":L31 	  AT 51 VIEW-AS TEXT
  SKIP({&VM_WID})

  v_SrcLst     	     	  AT 3 
  v_TargLst    	     	  AT 51              

  { adecomm/okform.i
      &BOX    ="rect_Btn_Box"
      &OK     ="qbf-ok"
      &CANCEL ="qbf-cn"
      &HELP   ="qbf-hlp" 
  }

  qbf-ad AT ROW 4 COL 35 SKIP ({&VM_WID})
  qbf-rm AT ROW 5.25 COL 35

  WITH FRAME FldPicker NO-LABELS
   DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-cn
   TITLE "Code Sections Selector":t32 VIEW-AS DIALOG-BOX WIDTH 83.

/*---------------------------  TRIGGERS  ---------------------------*/

ON "VALUE-CHANGED" OF v_SrcLst IN FRAME FldPicker DO:
  DEFINE VAR some_thing AS LOGICAL.
  some_thing = SELF:SCREEN-VALUE NE ?.
  /* Sensitize ADD button only if something is selected */
  IF some_thing NE qbf-ad:SENSITIVE 
  THEN qbf-ad:SENSITIVE = some_thing.
  /* Turn off the Target List and Actions */
  IF qbf-rm:SENSITIVE
  THEN ASSIGN
    v_TargLst:SCREEN-VALUE = ""
    qbf-rm:SENSITIVE       = no.
END.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

ON "VALUE-CHANGED" OF v_TargLst IN FRAME FldPicker DO:
  DEFINE VAR some_thing AS LOGICAL.
  some_thing = SELF:SCREEN-VALUE NE ?.
  /* Sensitize Remove/Move buttons only if something is selected */
  IF some_thing NE qbf-rm:SENSITIVE 
  THEN ASSIGN
    qbf-rm:SENSITIVE = some_thing.
  /* Turn off the Source List and Actions */
  IF qbf-rm:SENSITIVE
  THEN ASSIGN
    v_SrcLst:SCREEN-VALUE  = ""
    qbf-ad:SENSITIVE       = no.
END.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

on WINDOW-CLOSE OF FRAME FldPicker
   apply "END-ERROR" to frame FldPicker.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

ON   CHOOSE                OF qbf-ad    IN FRAME FldPicker
  OR MOUSE-SELECT-DBLCLICK OF v_SrcLst  IN FRAME FldPicker DO:
  /* Why MOUSE-SELECT-DBLCLICK and not DEFAULT-ACTION?  Because this is in
     a dialog box and the RETURN key will fire the GO for the frame.  I don't
     want it to also fire the ADD trigger. [Arguably, this is a bug with the
     Progress DEFAULT-BUTTON logic.  RETURN should do one or the other, not
     both DEFAULT-ACTION for selection-lists and DEFAULT-BUTTON for the frame */

  DEFINE VARIABLE cnt         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE qbf_a       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE j           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE qbf_i       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE qbf_v       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iArrayHigh  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iArrayLow   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cArrayList  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cArrayEntry AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTemp       AS CHARACTER NO-UNDO.
  DEFINE VAR empty_target     AS LOGICAL			NO-UNDO.

  IF v_SrcLst:SCREEN-VALUE IN FRAME FldPicker <> ? THEN DO:
    /* when going from left to right, always add to end of list */
    qbf_v = v_SrcLst:SCREEN-VALUE IN FRAME FldPicker.

    DO qbf_i = 1 TO NUM-ENTRIES(qbf_v):

	  cTemp = ENTRY (qbf_i, qbf_v).
  	  /*
  	  ** If it matches the it is an array thing.
  	  */
      IF cTemp MATCHES ("*[*]*") THEN 
      DO:
   	    ASSIGN
   	      cTemp      = TRIM (cTemp)
   	      cArrayList = SUBSTRING (cTemp, INDEX (cTemp, '[') + 1)
   	      cArrayList = REPLACE (cArrayList , "]", "")
   	      cTemp      = SUBSTRING (cTemp, 1, INDEX (cTemp, '[') - 1)
   	  	.
   	  	/*
   	  	** Loop through the list base on ,
   	  	*/
        DO i = 1 TO NUM-ENTRIES (cArrayList, ' '):
	  
   	  	  ASSIGN
   	  	    cArrayEntry = ENTRY (i, cArrayList, ' ')
   	  	    iArrayLow   = INTEGER (ENTRY (1, cArrayEntry, '-'))
   	  	    iArrayHigh  = INTEGER (ENTRY (NUM-ENTRIES (cArrayEntry, '-'), cArrayEntry, '-'))
   	  	    .
   	  	  /*
   	  	  ** Loop through the list base on X-Y. X is the low number Y is the high number
   	  	  */
   	      DO j = iArrayLow TO iArrayHigh:
	  
      	    ASSIGN 
   	          cArrayEntry = cTemp + '[' + STRING (j) + ']'
              qbf_a = v_TargLst:ADD-LAST (cArrayEntry) IN FRAME FldPicker
              .
          END. /* DO J */
  	    END. /* DO I */
  	  END. /* IF MATCHES */
	  ELSE
        qbf_a = v_TargLst:ADD-LAST(ENTRY(qbf_i,qbf_v)) IN FRAME FldPicker.

      RUN adecomm/_delitem.p (v_SrcLst:HANDLE, ENTRY (qbf_i, qbf_v), OUTPUT cnt).
 
    END. /* NUM-ENTRIES */
    /* If the source is empty then disable all the buttons */
    qbf-ad:SENSITIVE IN FRAME FldPicker = ( v_SrcLst:LIST-ITEMS NE ? ).
  END.
END /*TRIGGER*/ .

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

ON   CHOOSE                OF qbf-rm     IN FRAME FldPicker
  OR MOUSE-SELECT-DBLCLICK OF v_TargLst  IN FRAME FldPicker DO:
  /* Why MOUSE-SELECT-DBLCLICK and not DEFAULT-ACTION?  Because this is in
     a dialog box and the RETURN key will fire the GO for the frame.  I don't
     want it to also fire the REMOVE trigger. [Arguably, this is a bug with the
     Progress DEFAULT-BUTTON logic.  RETURN should do one or the other, not
     both DEFAULT-ACTION for selection-lists and DEFAULT-BUTTON for the frame */
  DEFINE VARIABLE qbf_a AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO.
  DEFINE VARIABLE qbf_j AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cnt   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE qbf_l AS CHARACTER NO-UNDO.
  DEFINE VARIABLE qbf_v AS CHARACTER NO-UNDO.
  DEFINE VAR empty_target	AS LOGICAL			NO-UNDO.
  
  IF v_TargLst:SCREEN-VALUE IN FRAME FldPicker <> ? THEN DO:
    /* when going from right to left, put back in original position */

    ASSIGN
      qbf_l = v_SrcLst:LIST-ITEMS IN FRAME FldPicker
      qbf_v = v_TargLst:SCREEN-VALUE IN FRAME FldPicker.

    DO qbf_i = 1 TO NUM-ENTRIES(qbf_v):
      RUN adecomm/_delitem.p (v_TargLst:HANDLE, ENTRY (qbf_i, qbf_v), OUTPUT cnt).
      RUN adecomm/_collaps.p (v_SrcLst:HANDLE, ENTRY (qbf_i, qbf_v)).
    END.
    
    /* If the target is empty then disable all the buttons */
    empty_target = ( v_TargLst:LIST-ITEMS EQ ? ).
    ASSIGN
         qbf-rm:SENSITIVE IN FRAME FldPicker = NOT empty_target.
/*         v_SrcLst:LIST-ITEMS IN FRAME FldPicker = qbf_l. */
  END.
END /*TRIGGER*/ .

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

/*----- HELP -----*/
on HELP of FRAME FldPicker OR CHOOSE OF qbf-hlp IN FRAME FldPicker
   RUN "adecomm/_adehelp.p" (INPUT "AB", INPUT "CONTEXT", 
      	       	     	     INPUT {&Internal_Procs_Selector_Dlg_Box},
      	       	     	     INPUT ?).


/*--------------------------------------------------------------------------*/

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/


{ adecomm/okrun.i
    &FRAME  = "FRAME FldPicker"
    &BOX    = "rect_Btn_Box"
    &OK     = "qbf-ok"
    &HELP   = "qbf-hlp"
}


/* fill-up source- and target-lists.  Note that we should never export    
   procedures that we parse when they are read in. (I.E. don't ever export
   or copy _ADM-CREATE-OBJECTS.  */
FIND _U WHERE _U._HANDLE = _h_win.
for each _Trg
  where _Trg._wrecid   = RECID(_U)
  and   (_trg._tsection = "_PROCEDURE":u OR _trg._tsection = "_FUNCTION":u)
  and   _TRG._tSPECIAL ne "_ADM-CREATE-OBJECTS":U
  by _trg._tevent:

  assign t_log = if _trg._status = "EXPORT"
                    then v_TargLst:add-last(TRIM(_trg._tevent))
                    else v_SrcLst:add-last(TRIM(_trg._tevent)).
end.


/* run dialog-box                                                     */
ENABLE v_SrcLst 
       qbf-ad 
       v_TargLst 
       qbf-ok
       qbf-cn 
       qbf-hlp
       WITH FRAME FldPicker.
ASSIGN
   stat = qbf-rm:MOVE-AFTER-TAB-ITEM(qbf-ad:HANDLE IN FRAME FldPicker).

        /* Select the first item in the source list */
IF v_SrcLst:NUM-ITEMS > 0 THEN v_SrcLst:SCREEN-VALUE = v_SrcLst:ENTRY(1).

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  APPLY "ENTRY"  TO v_SrcLst IN FRAME FldPicker.
  WAIT-FOR "CHOOSE" OF qbf-ok IN FRAME FldPicker OR
      	   GO OF FRAME FldPicker.
END.

/* mark every selected procedure to be exported                       */
do t_int = 1 to v_targlst:NUM-ITEMS:
  find first _trg
    where _Trg._wrecid   = RECID(_U)
    and   (_trg._tsection = "_PROCEDURE":u OR _trg._tsection = "_FUNCTION":u)
    and   _Trg._tevent   = v_targlst:entry(t_int)
    no-error.
  if available _trg then assign _trg._stat = "EXPORT".  
end.

/* Since this routine can get called twice, there might be some prev. */
/*              selected procedures, which are not selected anymore.  */
do t_int = 1 to v_srclst:NUM-ITEMS:
  find first _trg
    where _Trg._wrecid   = RECID(_U)
    and   (_trg._tsection = "_PROCEDURE":u OR _trg._tsection = "_FUNCTION":u)
    and   _Trg._tevent   = v_srclst:entry(t_int)
    no-error.
  if available _trg then assign _trg._stat = "NORMAL":u.  
end.

  
HIDE FRAME FldPicker NO-PAUSE.

RETURN.
