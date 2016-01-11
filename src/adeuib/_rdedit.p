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

File: _rdedit.p

Description:
    Procedure to read in static editor information.

Input Parameters:
   from_schema - TRUE if processing schema picker output ELSE false

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992

Modified on 11/20/96 by gfs added tooltip from qs
            12/20/96 by gfs added no-box  from qs
            01/29/98 by gfs replaced refs to _F._SCROLLBAR-V to _U._SCROLLBAR-V
            02/12/98 by gfs added no-tab-stop and drop-target attrs.
            07/16/98 by hd  don't run adecomm/_s-schem.p for web unmapped fields
            10/13/98 by gfs added tooltip attr
            06/07/99 by tsm added context-help-id attribute
---------------------------------------------------------------------------- */

DEFINE INPUT PARAMETER from_schema AS LOGICAL                      NO-UNDO.

{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/sharvars.i}     /* Shared variables                                  */
{adeuib/analyze.i &TYPE = "EDITOR" }  /* Analyzer Names for Buttons          */

DEFINE SHARED  VARIABLE  _inp_line AS  CHAR     EXTENT 100            NO-UNDO.

DEFINE SHARED  STREAM    _P_QS2.

{ adeuib/readinit.i &p_type="EDITOR"
                    &p_basetype="EDITOR" }

IF from_schema THEN _F._DICT-VIEW-AS = _suppress_dict_view-as.

ASSIGN _F._DATA-TYPE   = "Character":U
       _U._LABEL       = v_label
       _F._WORD-WRAP   = ({&AED_no-word-wrap} ne "y")
       _F._SCROLLBAR-H = ({&AED_scrollbar-h} eq "y")
       _U._SCROLLBAR-V = ({&AED_scrollbar-v} eq "y")
       _F._MAX-CHARS   = INTEGER ({&AED_max_chars})
       _F._INNER-LINES = INTEGER ({&AED_inner-lines})
       _F._INNER-CHARS = INTEGER ({&AED_inner-chars})
       _F._LARGE       = ({&AED_large} eq "y") 
       _F._UNDO        = IF _U._TABLE = ? THEN ({&AED_undo} eq "y") ELSE TRUE
       _U._TOOLTIP     = {&AED_TOOLTIP}
       _U._TOOLTIP-ATTR = {&AED_TOOLTIP-ATTR}
       _L._NO-BOX      = ({&AED_no-box} eq "y")
       _U._DROP-TARGET = ({&AED_drop-target} eq "y")
       _U._NO-TAB-STOP = ({&AED_no-tab-stop} eq "y")
       _U._CONTEXT-HELP-ID = INTEGER({&AED_context-help-id})
.

/* IZ 7907 If we are reading a static SDV and this is a RowObject record and the 
   Dictionary contains a view-as specifying either inner-lines or inner-chars, 
   we have to suppress writing the view-as phrase or we get a compile error.     */
IF AVAILABLE _P THEN DO:
  IF _P.static_object AND (_U._TABLE = "RowObject":U OR _U._BUFFER = "RowObject":U) AND
     (_F._INNER-LINES GT 0 OR _F._INNER-CHARS GT 0) THEN
    _F._DICT-VIEW-AS = YES.
END. /* If the _P is available */

CREATE EDITOR _U._HANDLE
    ASSIGN {adeuib/std_attr.i &MODE = "READ" }
           SCROLLBAR-H = _F._SCROLLBAR-H
           SCROLLBAR-V = _U._SCROLLBAR-V
           READ-ONLY   = TRUE  /* User can't edit in design mode */
           BOX         = (IF _L._NO-BOX THEN FALSE ELSE TRUE)
      TRIGGERS:
           {adeuib/std_trig.i}
      END TRIGGERS.

/* Assign Handles that we now know */
ASSIGN { adeuib/std_uf.i &SECTION = "HANDLES" } .

IF _U._LAYOUT-UNIT THEN 
  ASSIGN _U._HANDLE:COL          = ((_L._COL - 1) * _cur_col_mult) + 1
         _U._HANDLE:ROW          = ((_L._ROW - 1) * _cur_row_mult) + 1
         _U._HANDLE:WIDTH-CHARS  = _L._WIDTH * _cur_col_mult
         _U._HANDLE:HEIGHT-CHARS = _L._HEIGHT * _cur_row_mult.
ELSE
  ASSIGN _U._HANDLE:X             = _X
         _U._HANDLE:Y             = _Y
         _U._HANDLE:WIDTH-PIXELS  = _WIDTH-P
         _U._HANDLE:HEIGHT-PIXELS = _HEIGHT-P.

/* Create multiple layout records if necessary */
{adeuib/crt_mult.i}
/* Now get the _L for the current layout instead of the master layout */
FIND _L WHERE RECID(_L) = _U._lo-recid.


/* Explicitly set NO-LABELS for static Editors */
_L._NO-LABELS = YES.
         
         
/* Place object within frame boundary. */
{adeuib/onframe.i
   &_whFrameHandle = "_h_frame"
   &_whObjHandle   = "_U._HANDLE"
   &_lvHidden      = FALSE}
   
/* Make sure the Universal Widget Record is "correct" by reading the actually
   instantiated values. */
ASSIGN  {adeuib/std_uf.i &section = "GEOMETRY"} .

/* Realize the widget in tty mode */
IF NOT _cur_win_type THEN
  RUN adeuib/_ttyedit.p (_U._HANDLE, _F._SCROLLBAR-H, _U._SCROLLBAR-V).
  
IF _F._INITIAL-DATA NE "" THEN
  _U._HANDLE:SCREEN-VALUE = _F._INITIAL-DATA.

/* Avoid ugly message for unmapped webobjects when disconnected 
   BUG 98-060-02-018
*/
IF AVAIL _TT AND _TT._TABLE-TYPE = "W" THEN
DO:
 /* nothing */
END. /* If editor is associated with a db field grep the label for documentation of */
     /* trigger code blocks                                                         */
ELSE IF _U._DBNAME NE ? THEN RUN adecomm/_s-schem.p (_U._DBNAME, _U._TABLE, _U._NAME,
                            "FIELD:LABEL", OUTPUT _U._LABEL).



