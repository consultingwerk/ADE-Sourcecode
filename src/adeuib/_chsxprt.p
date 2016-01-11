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
/*-------------------------------------------------------------------------

File: _chsxprt.p

Description:
   The procedure to export selected objects.
   [This was once an internal procedure in _uibmain.p,
    called ExportSelectedObjects  -- removed by Wood 5/5/93]
    
Input Parameters:
   lipShowFileDialog - True if File Save As dialog should be shown to request
                       the save file.
                       
                       Also, if True, delete _comp_temp_file. If False,
                       do not delete it. Let the caller take care of
                       that. (jep - for bug 95-08-31-111).
                       

Output Parameters:
   <None>

Author:  Wm.T.Wood

Date Created: 1992

History:
    tsm         99/04   added support for various Intl Numeric formats (in
                        addition to American and European) by using
                        session set-numeric-format method to set session
                        format back to user's setting
    jep         98/10   added function export
    hutegger    94/03   added procedure-export - support:
                        changed alert-box to dialog-box
                        inserted button-triggers
                            
-------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER lipShowFileDialog AS LOGICAL.

/* ===================================================================== */
/*                        TEMP TABLE Definitions                         */
/* ===================================================================== */
&GLOBAL-DEFINE WIN95-BTN TRUE

{adecomm/commeng.i}          /* Help contexts                            */
{adecomm/adestds.i}          /* Standard layout stuff, colors etc.       */
{adeuib/uniwidg.i}           /* Universal Widget TEMP-TABLE definition   */
{adeuib/triggers.i}          /* Trigger TEMP-TABLE definition            */
{adeuib/sharvars.i}          /* Define _h_win etc.                       */
{adeuib/uibhlp.i}

/* Local Variables */
DEFINE BUFFER x_U    FOR _U.
DEFINE VAR    ans        AS LOGICAL                   NO-UNDO.
DEFINE VAR    v_list     AS CHAR                      NO-UNDO
                            VIEW-AS EDITOR SIZE 70 BY 5 SCROLLBAR-V SCROLLBAR-H.
DEFINE VAR    save_win   AS WIDGET                    NO-UNDO.
DEFINE VAR    org_win    AS WIDGET                    NO-UNDO.


DEFINE BUTTON btn_ok     LABEL "OK"          {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON btn_cancel LABEL "Cancel"      {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON btn_code   LABEL "&Code..."    {&STDPH_OKBTN}.
DEFINE BUTTON btn_help   LABEL "&Help"       {&STDPH_OKBTN}.

FORM 
  SKIP ({&TFM_WID})
  "Items to Copy:":L40  AT 2
  SKIP ({&VM_WID})
  v_list                AT 2
  { adecomm/okform.i
      &CANCEL = "btn_cancel"
      &OTHER  = "btn_code"
      &OK     = "btn_ok"
      &HELP   = "btn_help"
  }
  WITH FRAME v_list VIEW-AS DIALOG-BOX TITLE "Copy To File":t32 NO-LABELS THREE-D.

ASSIGN v_list:READ-ONLY IN FRAME v_list = TRUE.

/* ===================================================================== */
/*                                TRIGGERS                               */
/* ===================================================================== */

ON CHOOSE of btn_code in frame v_list
DO:

  RUN adeuib/_intpxpt.p. 
  
  ASSIGN ans    = false
         v_list = "".
  FOR EACH _U WHERE _U._SELECTEDib :
    assign 
      v_list = v_list + "   " + SUBSTRING(_U._NAME,1,20, "raw":U) + 
                FILL(" ", MAX(1, 20 - LENGTH(_U._NAME, "raw":U))) + /* at least 1 space */
                (IF _U._LABEL NE ? THEN SUBSTRING(_U._LABEL,1,20, "raw":U) ELSE "") +
                CHR(10)
      ans    = true.
  END.
  FIND _U WHERE _U._HANDLE = _h_win.
  FOR EACH _trg 
    where _trg._wrecid   = RECID(_U)
    and   (_trg._tsection = "_PROCEDURE":u OR _trg._tsection = "_FUNCTION":u)
    and   _trg._status   = "EXPORT":U
    by _trg._tevent:

    assign 
      v_list = v_list + (IF _trg._tsection = "_PROCEDURE":u
                         THEN "   PROCEDURE ":U
                         ELSE "   FUNCTION  ":U)
             + _Trg._tevent
             + chr(10)
      ans    = true.
  END.

  display v_list with frame v_list.
END.  /* CHOOSE of btn_code in frame v_list */
    

ON CHOOSE of btn_ok in frame v_list
DO:

  IF NOT ans THEN
    MESSAGE "Nothing is selected to copy to file." VIEW-AS ALERT-BOX
          INFORMATION BUTTONS OK.

  ELSE DO:   /* objects selected to export */

    IF lipShowFileDialog
     then RUN adeuib/_sel_fn.p ("Copy to File","export.wx").

    IF _save_file <> ? THEN DO:
      RUN adecomm/_setcurs.p ("WAIT":U).
      RUN adeshar/_gen4gl.p ("EXPORT":U).
      /* clean up */
      IF lipShowFileDialog THEN
        OS-DELETE VALUE(_comp_temp_file) NO-ERROR.
      SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
      RUN adecomm/_setcurs.p ("":U).
    END.
  END.     /* objects selected to export */
END.  /* CHOOSE of btn_ok in frame v_list */

/*----- HELP -----*/
ON HELP of FRAME v_list OR CHOOSE OF btn_help IN FRAME v_list
   RUN "adecomm/_adehelp.p" ("AB", "CONTEXT", {&Copy_to_File_Dlg_Box},	? ).
    
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

/* ===================================================================== */
/*                               MAIN-CODE                               */
/* ===================================================================== */

{ adecomm/okrun.i
    &FRAME  = "FRAME v_list"
    &CANCEL = "btn_cancel"
    &OTHER  = "btn_code"
    &OK     = "btn_ok"
    &HELP   = "btn_help"
} 

ASSIGN v_list     = "".

FOR EACH _U WHERE _U._SELECTEDib :
  _U._STATUS = "EXPORT":u.

  IF CAN-DO("FRAME,DIALOG-BOX",_U._TYPE) THEN
    RUN iterate_frame (RECID (_U)).
  ELSE DO:
    FOR EACH _TRG WHERE _TRG._wRECID = RECID(_U):
      _TRG._STATUS = "EXPORT":u.
    END.

    FIND _F WHERE RECID (_F) = _U._x-recid NO-ERROR.
    IF AVAILABLE (_F) THEN
      FIND x_U WHERE x_U._HANDLE = _F._FRAME.
    ELSE IF _U._TYPE = "BROWSE":U THEN
      FIND x_U WHERE RECID(x_U) = _U._PARENT-RECID.
    IF AVAILABLE (x_U) THEN
      x_U._STATUS = "EXPORT-FORM":U.
  END.
END. 

/* Show a list of the selected items.  Use "etc." if 8 or more items */
/* ksu 02/22/94 LENGTH and SUBSTRING use "raw" mode */
assign ans = false.
FOR EACH _U WHERE _U._SELECTEDib :
  assign 
    v_list = v_list + "   " + SUBSTRING(_U._NAME,1,20, "raw":U) + 
                FILL(" ", MAX(1, 20 - LENGTH(_U._NAME, "raw":U))) + /* at least 1 space */
                (IF _U._LABEL NE ? THEN SUBSTRING(_U._LABEL,1,20, "raw":U) ELSE "") +
                CHR(10) 
    ans    = true.
END.

IF lipShowFileDialog THEN
DO:
  display v_list with frame v_list.
  enable btn_ok btn_cancel btn_code btn_help v_list
    with frame v_list.
  wait-for CHOOSE of btn_cancel in frame v_list
        or CHOOSE of btn_ok     in frame v_list.
END.
ELSE DO:
  assign btn_ok:SENSITIVE = true.
  APPLY "CHOOSE" to btn_ok in frame v_list.
END.

FOR EACH _U WHERE _U._STATUS BEGINS "EXPORT":U:
  _U._STATUS = "NORMAL":U.
END.
FOR EACH _TRG WHERE _TRG._STATUS BEGINS "EXPORT":U:
  _TRG._STATUS = "NORMAL":U.
END.

/* ===================================================================== */

PROCEDURE iterate_frame:
/*------------------------------------------------------------------------------
  Purpose: Recursive routine that runs through a frame to get all its children.  
  Parameters:  recid of current _U
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER u_recid AS RECID NO-UNDO.

DEFINE BUFFER frame_U FOR _U.
DEFINE BUFFER x_U FOR _U.

/* Cycle through the field-level widgets for this frame to create the   */
/* widget definitions, be carefull not to create definitions for text   */
/* widgets as they are displayed as literals in the frame.              */

/* Get this current frame. */

FIND frame_U WHERE RECID (frame_U) = u_recid.

FOR EACH x_U WHERE x_U._PARENT = frame_U._HANDLE:FIRST-CHILD
              AND x_U._STATUS EQ "NORMAL":U:

  IF CAN-DO("FRAME", x_U._TYPE) THEN
    /* Found a frame within a frame - recurse. */
    RUN iterate_frame (RECID (x_U)).

  x_U._STATUS = "EXPORT":u.
  FOR EACH _TRG WHERE _TRG._wRECID = RECID(x_U):
     _TRG._STATUS = "EXPORT":U.
  END.
END.

/* Do the triggers of the frame or dialog */
FOR EACH _TRG WHERE _TRG._wRECID = RECID(frame_U):
  _TRG._STATUS = "EXPORT":U.
END.
END PROCEDURE.
