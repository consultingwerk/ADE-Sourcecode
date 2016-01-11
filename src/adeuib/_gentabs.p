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

File: _gentabs.i

Description: Generates the frame/object or frame/frame pairs for doing
             the MOVE-BEFORE-TAB-ITEM and MOVE-AFTER-TAB-ITEM method 
             calls in the Runtime Attributes Section of the .w. This 
             routine is called by _genrt.i, immediately after the
             the _C._tabbing option is written to the file.
             
Input Parameters:
   parent-recid - the recid of the parent frame.

Output Parameters:
   assign_string - the entire string of MOVE-BEFORE-TAB-ITEMs and/or
                   MOVE-AFTER-TAB-ITEMs. The string is written out at
                   the calling procedure's string so that a single
                   ASSIGN statement is generated.

Author: Patrick Leach

Date Created: January 12, 1996.

-----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER parent_recid  AS RECID     NO-UNDO.
DEFINE OUTPUT PARAMETER assign_string AS CHARACTER NO-UNDO.
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

/* FUNCTION PROTOTYPE */
FUNCTION db-fld-name RETURNS CHARACTER
  (INPUT rec-type AS CHARACTER, INPUT rec-recid AS RECID) IN _h_func_lib.

DEFINE VARIABLE first_time AS LOGICAL INIT TRUE NO-UNDO.

assign_string = "ASSIGN ".
RUN iterate_tab_group (0, "", "").
IF assign_string = "ASSIGN " THEN

  /* There were no frames defined within this frame and no */
  /* MOVE-BEFORE-TAB-ITEM and MOVE-AFTER-TAB-ITEM methods  */
  /* were generated. Indicate this to _genrt.i by setting  */
  /* the parameter passed back it with the null string.    */                                      

  assign_string = "".


PROCEDURE iterate_tab_group:

/* Recursive procedure which inserts frames into the tab order by    */
/* generating the required MOVE-AFTER and MOVE-BEFOR tab item calls. */
/* These calls are only generated 1) whenever a frame comes before an*/
/* object, in which case a MOVE-BEFORE is written for the pair;      */
/* 2) whenever a frame comes after an object, in which case a MOVE-  */
/* AFTER is written for the pair; 3) whenever a frame comes before   */
/* another frame, in which case a MOVE-BEFORE is written of the pair.*/
/* The routine is recursive since a point of reference - a genuine   */
/* tab number of a non-frame objects - must be found from which each */
/* frame can be moved before or moved after. Thus, the frame-object  */
/* pairs are processed pre-order, while the frame-frame pairs are    */
/* processed post-order.                                             */

DEFINE INPUT PARAMETER tab_number AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER prev_name  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER prev_type  AS CHARACTER NO-UNDO.

DEFINE BUFFER x_U   FOR _U.
DEFINE BUFFER par_U FOR _U.

DEFINE VARIABLE good-find AS LOGICAL           NO-UNDO.


/* This used to be a simple FIND ... NO-ERROR.  But it was finding FILL-INs
   that were viewed as TEXT.  This caused big problems.  So I have made it
   continue the search in that case.  This necessitated the good-find loop. */
good-find = FALSE.
DO WHILE NOT good-find:
  good-find = TRUE.
  FIND x_U WHERE x_U._PARENT-RECID = parent_recid
          AND x_U._STATUS = 'NORMAL':U
          AND RECID (x_U) <> parent_recid
          AND LOOKUP(x_U._TYPE,
              'SmartObject,QUERY,OCX,TEXT,IMAGE,RECTANGLE,LABEL':U) = 0
          AND x_U._TAB-ORDER = tab_number + 1 NO-ERROR.
  IF AVAILABLE x_U AND x_U._TYPE = "BUTTON":U THEN
    FIND _L WHERE _L._u-recid = RECID(x_U) AND _L._LO-NAME = "Master Layout":U.
  IF (AVAILABLE x_U AND x_U._TYPE = "FILL-IN":U AND x_U._SUBTYPE = "TEXT":U) OR
     (AVAILABLE x_U AND AVAILABLE _L AND RECID(x_U) = _L._u-recid AND _L._NO-FOCUS)
  THEN DO:
    tab_number = tab_number + 1.
    good-find = FALSE.
  END.
END.

FIND par_U WHERE RECID(par_U) = parent_recid.

IF AVAILABLE (x_U) THEN DO:

  IF x_U._TYPE <> 'FRAME':U AND prev_type = 'FRAME':U THEN DO:

    /* A frame comes before a non-frame object in the tab order. */

    IF NOT first_time THEN assign_string = assign_string + "       ".
    ELSE first_time = FALSE.

    FIND _F WHERE RECID(_F) = x_U._x-recid NO-ERROR.
    assign_string = assign_string +
                    "XXTABVALXX = FRAME " + prev_name +
                    ":MOVE-BEFORE-TAB-ITEM (" +
                    (IF (x_U._DBNAME eq ? OR (AVAILABLE _F AND _F._DISPOSITION EQ "LIKE":U))
                     THEN x_U._NAME
                     ELSE db-fld-name("_U":U, RECID(x_U))) +
                    ":HANDLE IN FRAME ":U + par_U._NAME + ")":U + CHR (10).
  END.
  
  ELSE IF x_U._TYPE = 'FRAME':U AND prev_type <> 'FRAME':U AND prev_name <> '':U THEN DO:

    /* A frame comes after a non-frame object in the tab order. */
    
    IF NOT first_time THEN assign_string = assign_string + "       ".
    ELSE first_time = FALSE.          
    assign_string = assign_string +
                    "XXTABVALXX = FRAME " + x_U._NAME +
                    ":MOVE-AFTER-TAB-ITEM (" +
                    prev_name + ":HANDLE IN FRAME ":U + par_U._NAME + ")":U + CHR (10).
  END.
  
  FIND _F WHERE RECID(_F) = x_U._x-recid NO-ERROR.
  RUN iterate_tab_group (x_U._TAB-ORDER,
                        (IF (x_U._DBNAME eq ? OR (AVAILABLE _F AND _F._DISPOSITION EQ "LIKE":U))
                         THEN x_U._NAME
                         ELSE db-fld-name("_U":U, RECID(x_U))),
                         x_U._TYPE).

  IF x_U._TYPE = 'FRAME':U AND prev_type = 'FRAME':U THEN DO:

    /* Two frames are adjacent to each other in the tab order. */
    
    IF NOT first_time THEN assign_string = assign_string + "       ".
    ELSE first_time = FALSE.
    assign_string = assign_string +
                   "XXTABVALXX = FRAME " + prev_name +
                   ":MOVE-BEFORE-TAB-ITEM (FRAME " + x_U._NAME +
                   ":HANDLE)":U + CHR (10).
  END.
END.
END.

