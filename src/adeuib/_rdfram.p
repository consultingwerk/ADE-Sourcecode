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
/*----------------------------------------------------------------------------

File: _rdfram.p

Description:
    Procedure to read in static frame information.

Input-Output Parameters:
   import_mode - Can either be WINDOW, WINDOW UNTITLED or IMPORT
                 If an error occurs, this will be set to "ABORT".

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992

Date Modified: 02/09/94 by RPR (added 3-D support)
               02/12/98 by GFS Added DROP-TARGET attr.
               06/04/99 by TSM Added Context-sensitive help for dialogs
               07/02/99 by TSM Added support NO-AUTO-VALIDATE
---------------------------------------------------------------------------- */

{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/layout.i}       /* Layout temp-table definitions                     */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/name-rec.i}     /* Name indirection table                            */
{adeuib/sharvars.i}     /* Shared variables                                  */
{adeuib/dialvars.i}     /* Special Dialog borders                            */
{adeuib/frameown.i}     /* Frame owner temp table definition                */

DEFINE INPUT-OUTPUT PARAMETER import_mode  AS CHAR NO-UNDO .
                        /* "WINDOW" if opening a window                      */
                        /* "WINDOW UNTITLED" if opening as UNTITLED          */
                        /* "IMPORT" if importing an Export file              */

DEFINE SHARED  STREAM    _P_QS2.
DEFINE SHARED  VARIABLE  _inp_line  AS  CHAR     EXTENT 100            NO-UNDO.
DEFINE SHARED VAR _can_butt         AS CHAR                            NO-UNDO.
DEFINE SHARED VAR _def_butt         AS CHAR                            NO-UNDO.

DEFINE VARIABLE _HEIGHT-P         AS INTEGER INITIAL ?.
DEFINE VARIABLE _WIDTH-P          AS INTEGER INITIAL ?.
DEFINE VARIABLE _X                AS INTEGER INITIAL ?.
DEFINE VARIABLE _Y                AS INTEGER INITIAL ?.                        

DEFINE VARIABLE dot-w-file          AS CHAR                            NO-UNDO.
DEFINE VARIABLE ok-flag             AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE header_ht           AS DECIMAL                         NO-UNDO.
DEFINE VARIABLE iteration_ht        AS DECIMAL                         NO-UNDO.
DEFINE VARIABLE n_down              AS INTEGER                         NO-UNDO.
DEFINE VARIABLE v_name              AS CHAR                            NO-UNDO.
DEFINE VARIABLE v_org-name          AS CHAR                            NO-UNDO.
DEFINE VARIABLE v_type              AS CHAR                            NO-UNDO.
DEFINE VARIABLE v_label             AS CHAR                            NO-UNDO.
DEFINE VARIABLE v_basetype          AS CHAR                            NO-UNDO.
DEFINE VARIABLE AZ                  AS CHAR                            NO-UNDO.
DEFINE VARIABLE i                   AS INTEGER                         NO-UNDO.
DEFINE VARIABLE v_index             AS INTEGER                         NO-UNDO.
DEFINE VARIABLE v_exists            AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l_import            AS LOGICAL                         NO-UNDO.
DEFINE BUFFER x_U FOR _U.

/* First see if we are dealing with a dialog-box or window                   */
IF _h_win NE ? THEN DO:
  FIND _U WHERE _U._HANDLE = _h_win.
  IF _U._WIN-TYPE NE ? THEN _cur_win_type = _U._WIN-TYPE.
END.

ASSIGN
  v_org-name  = _inp_line[2]
  v_name      = _inp_line[2]
  dot-w-file  = _inp_line[3].

IMPORT STREAM _P_QS2 _inp_line.
 
/* Check to see if we have a valid window to place thing into      */           
IF _h_win = ? AND _inp_line[33] NE "y" THEN DO:    /* Not a dialog */
  MESSAGE "There is no window or dialog-box to place things in.  Aborting" SKIP
          "the opening of" dot-w-file + "."
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  import_mode = "ABORT".
  RETURN.
END.

v_label = IF (_inp_line[9] <> ?) THEN _inp_line[9] ELSE "".


IF _inp_line[33] = "N" THEN     /* A Normal frame                        */
  ASSIGN
       v_index    = {&FRAME}
       v_basetype = "FRAME"
       v_type     = "FRAME".
ELSE                            /* A DIALOG-BOX                          */
  ASSIGN
       v_index    = {&DIALG}
       v_basetype = "DIALOG"
       v_type     = "DIALOG-BOX".

IF (v_name = "") THEN DO:
   /* Don't instantiate an imported frame if name is null, but make sure
      bar and iteration are set up if a down frame                       */
   IF import_mode = "IMPORT":U THEN RETURN.
   ASSIGN _count[v_index] = _count[v_index] + 1
          v_name          = "DEFAULT-" + TRIM(STRING(_count[v_index])).
END.

CREATE _NAME-REC.
ASSIGN _NAME-REC._wNAME  = v_name
       _NAME-REC._wTYPE  = v_type.

/* Look to see if record already exists */
FIND FIRST _U WHERE _U._NAME = v_name AND _U._TYPE = v_type AND
           _U._STATUS = "NORMAL" AND
           _U._WINDOW-HANDLE = _h_win
     USE-INDEX _NAME NO-ERROR.

IF available _U THEN
DO:
  ASSIGN
      /* Compute a name for the frame like A,B,C...Z,AA..AZ,BA,BB..ZZ. */
      i = TRUNCATE ((_count[v_index] - 1) / 26, 0)
      AZ = IF i < 1 THEN "" ELSE CHR(64 + i)
      i =  ((_count[v_index]) MODULO 26) + 1
      AZ = AZ + CHR(64 + i) 
      _count[v_index] = _count[v_index] + 1.
      
  /* Do we need a new default label */
  IF v_label = REPLACE (v_name, "-", " ") 
  THEN ASSIGN v_label = SUBSTRING (v_label, 1, LENGTH (v_basetype + "-","CHARACTER":U),
                                   "CHARACTER":U) + AZ.
  /* Create a new name */
  ASSIGN  v_name = v_type + "-" +  AZ.
  /* Scan _frame_owner_tt records and replace old name with new name */
  FOR EACH _frame_owner_tt:
    IF _frame_owner_tt._child =_NAME-REC._wNAME THEN
      _frame_owner_tt._child = v_name.
    IF _frame_owner_tt._parent =_NAME-REC._wNAME THEN
      _frame_owner_tt._parent = v_name.
  END.
END.

CREATE _U.
CREATE _L.
CREATE _C.
CREATE _Q.

ASSIGN _U._NAME                = v_name    
       _U._WINDOW-HANDLE       = _h_win
       _L._WIN-TYPE            = _cur_win_type
       _U._WIN-TYPE            = _cur_win_type
       _U._x-recid             = RECID(_C)
       _U._lo-recid            = RECID(_L)
       _C._q-recid             = RECID(_Q)
       _U._SENSITIVE           = TRUE
       _Q._OptionList          = "SHARE-LOCK" /* Frame/dialogs are SHARE-LOCK */
       _NAME-REC._wRECID       = RECID(_U)
       _NAME-REC._wFRAME       = _U._NAME     /* Point to the "new" frame name */
       .
   
/* Establish new _count[{&FRAME}] */
IF _U._NAME BEGINS "FRAME-" AND LENGTH(_U._NAME, "CHARACTER":U) = 7 AND
   ASC(SUBSTRING(_U._NAME,7,-1,"CHARACTER":U)) > 64 THEN
  _count[{&FRAME}] = MAX(_count[{&FRAME}],ASC(SUBSTRING(_U._NAME,7,-1,"CHARACTER":U))
                                              - 64).
ELSE IF _U._NAME BEGINS "BROWSE-":U AND LENGTH(_U._NAME,"CHARACTER":U) = 9 AND
   ASC(SUBSTRING(_U._NAME,9,-1,"CHARACTER":U)) > 64 THEN
  _count[{&BRWSR}] = MAX(_count[{&BRWSR}],ASC(SUBSTRING(_U._NAME,9,-1,"CHARACTER":U))
                                              - 64).
ELSE IF _U._NAME BEGINS "DIALOG-" AND LENGTH(_U._NAME, "CHARACTER":U) = 8 AND
   ASC(SUBSTRING(_U._NAME,8,-1,"CHARACTER":U)) > 64 THEN
  _count[{&DIALG}] = MAX(_count[{&DIALG}],ASC(SUBSTRING(_U._NAME,8,-1,"CHARACTER":U))
                                              - 64).   

IF _inp_line[1] = "p" THEN 
    ASSIGN _X   = INTEGER(_inp_line[2])
           _Y   = INTEGER(_inp_line[3]).
  ELSE DO:
    IF INTEGER(_inp_line[2]) < 1 THEN _inp_line[2] = "1".
    IF INTEGER(_inp_line[3]) < 1 THEN _inp_line[3] = "1".
    ASSIGN _L._COL = DECIMAL(_inp_line[2]) / 100
           _L._ROW = DECIMAL(_inp_line[3]) / 100.
  END.
           
/* Read in the SIZE of the dialog-box.  Remember that this size INCLUDES the
   dialog-box borders.  The UIB does not (as of 7/14/94).  Therefore, we 
   want to subtract out the dialog-border size. */
IF _inp_line[5] = "p" THEN 
  ASSIGN _WIDTH-P         = INTEGER(_inp_line[6]) - IF v_type = "DIALOG-BOX" THEN
                            (_dialog_border_width * SESSION:PIXELS-PER-COLUMN) ELSE 0
         _HEIGHT-P        = INTEGER(_inp_line[7]) - IF v_type = "DIALOG-BOX" THEN
                            (_dialog_border_height * SESSION:PIXELS-PER-ROW) ELSE 0
         _U._LAYOUT-UNIT  = FALSE.
ELSE
  ASSIGN _L._WIDTH        = (DECIMAL(_inp_line[6]) / 100) -
                             IF v_type = "DIALOG-BOX" THEN _dialog_border_width ELSE 0
         _L._HEIGHT       = (DECIMAL(_inp_line[7]) / 100) -
                             IF v_type = "DIALOG-BOX" THEN _dialog_border_height ELSE 0
         _U._LAYOUT-UNIT  = TRUE.
         
ASSIGN n_down                      = INTEGER(_inp_line[4])
       _C._DOWN                    = IF (v_type eq "DIALOG-BOX":U OR n_down eq 1) 
                                     THEN NO ELSE YES     
       _U._LABEL                   = v_label
       _U._LABEL-ATTR              = IF _inp_line[10] <> ? THEN _inp_line[10] ELSE ""
       _C._RETAIN                  = IF INTEGER(_inp_line[21]) > 0 THEN
                                       INTEGER(_inp_line[21]) ELSE ?
        /* When we write out code, we use a trick to size dialog-boxes.  We set them to
           SCROLLABLE in the frame-phrase.  We never want them to be SCROLLABLE in the
           Universal widget record. */
       _C._SCROLLABLE              = IF v_type eq "DIALOG-BOX":U THEN NO 
                                     ELSE (_inp_line[22] = "y")
       _C._OVERLAY                 = _inp_line[23] = "y"
       _C._title                   = IF _inp_line[9] = ? THEN FALSE ELSE TRUE
       _C._TOP-ONLY                = _inp_line[24] = "y"
       _L._NO-BOX                  = _inp_line[25] = "y"
       _U._SHARED                  = _inp_line[26] = "y"
       _L._NO-LABELS               = _inp_line[27] = "y"
       _C._SIDE-LABELS             = _inp_line[28] = "y"
       _C._HIDE                    = _inp_line[29] = "n"
       _C._PAGE-BOTTOM             = _inp_line[30] = "y"
       _C._PAGE-TOP                = _inp_line[31] = "y"
       _U._WINDOW-HANDLE           = _h_win
       _U._TYPE                    = IF _inp_line[33] = "y" THEN "DIALOG-BOX"
                                     ELSE IF _inp_line[34] = "y" THEN "BROWSE":U
                                     ELSE "FRAME"
       iteration_ht                = INTEGER(_inp_line[35]) / 100
       header_ht                   = INTEGER(_inp_line[36]) / 100
       _def_butt                   = _inp_line[37]
       _can_butt                   = _inp_line[38]
       _L._NO-UNDERLINE            = _inp_line[39] = "n"
       _C._VALIDATE                = _inp_line[40] = "y"
       _L._LO-NAME                 = "Master Layout"
       _L._u-recid                 = RECID(_U)
       _L._3-D                     = _inp_line[41] = "y"
       _C._KEEP-TAB-ORDER          = _inp_line[42] = "y"
       _C._NO-HELP                 = _inp_line[44] = "n"
       _C._USE-DICT-EXPS           = _inp_line[45] = "y"
       _U._DROP-TARGET             = _inp_line[46] = "y"
       _C._CONTEXT-HELP            = _inp_line[47] = "y"
       _C._CONTEXT-HELP-FILE       = _inp_line[48] 
       _C._NO-AUTO-VALIDATE        = _inp_line[49] = "y"
       _L._BGCOLOR                 = IF _inp_line[15] = "7" THEN INTEGER(_inp_line[17])
                                     ELSE IF _inp_line[15] = "6" THEN -1 ELSE ?
       _L._COL-MULT                = _cur_col_mult
       _L._FGCOLOR                 = IF _inp_line[15] = "7" THEN INTEGER(_inp_line[16])
                                     ELSE IF _inp_line[15] = "6" THEN -1 ELSE ?
       _L._FONT                    = INTEGER(_inp_line[8])
       _L._NO-BOX                  = _inp_line[25] = "y"
       _L._NO-LABELS               = _inp_line[27] = "y"
       _L._NO-UNDERLINE            = _inp_line[39] = "n"
       _L._ROW-MULT                = _cur_row_mult
       _L._TITLE-BGCOLOR           = IF _inp_line[11] = "7" THEN INTEGER(_inp_line[13])
                                     ELSE IF _inp_line[11] = "6" THEN -1 ELSE ?
       _L._TITLE-FGCOLOR           = IF _inp_line[11] = "7" THEN INTEGER(_inp_line[12])
                                     ELSE IF _inp_line[11] = "6" THEN -1 ELSE ?
       _L._VIRTUAL-HEIGHT          = _L._HEIGHT
       _L._VIRTUAL-WIDTH           = _L._WIDTH
       _L._WIN-TYPE                = _cur_win_type.

IF _U._LAYOUT-UNIT AND _L._HEIGHT = 0 THEN 
    ASSIGN _L._HEIGHT         = 1.3 + header_ht + iteration_ht *
                                 (IF n_down = ? THEN 1 ELSE MAX(n_down,1))
           _L._VIRTUAL-HEIGHT = _L._HEIGHT.
ELSE IF NOT _U._LAYOUT-UNIT AND _HEIGHT-P = 0 THEN
   ASSIGN _HEIGHT-P           = 1.3 + header_ht + iteration_ht *
                                 (IF n_down = ? THEN 1 ELSE MAX(n_down,1)) *
                                            SESSION:PIXELS-PER-ROW.

IF NOT _cur_win_type THEN  /* Force TTY Colors */
  ASSIGN _L._FGCOLOR       = ?
         _L._BGCOLOR       = ?
         _L._TITLE-FGCOLOR = ?
         _L._TITLE-BGCOLOR = ?.
         
IF v_type = "DIALOG-BOX" THEN _L._NO-UNDERLINE = TRUE.

/* Do standard frame reading. */   
{adeuib/_rdfram.i}

IF _U._TYPE = "FRAME":U THEN DO:  /* Not for  dialogs */         
  /* Handle the case of pasting a frame into a frame with multiple layouts */
  /* ie. create and populate many _L's.                                    */
  FIND parent_L WHERE parent_L._u-recid = RECID(parent_U) AND 
                      parent_L._LO-NAME = "Master Layout":U.
  {adeuib/crt_mult.i}
END.  /* IF a FRAME */
