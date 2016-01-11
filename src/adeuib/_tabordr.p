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

File: _tabordr.p

Description:
    Goes though all the children of an object and computes a TAB-ORDER integer
    for them.
    
    This routine looks at the Frames "TABBING" property (_C._Tabbing).  This
    can have two values
       [L-to-R|R-to-L][,COLUMNS]
    If COLUMNS is in the list, then we base tab-order on columns that are
    5 PPU's wide.  If R-to-L, then we do everything Right-to-Left, based
    on the upper-right corner of the widget's position.  
    
    You can have both r-to-l and column, in which case we do columns from the
    right, with tabbing within each row of the column also from the right.
     
Input Parameters:
    p_status - Status of objects to compute (we only need to look at
               objects we are writing out, here).
    p_Urecid - RECID of the _U record for the parent.
    
Output Parameters:
   <None>

Author:  Wm.T.Wood

Date Created: July 31, 1995

Modified: Patrick Leach 12/12/95
          Return if "CUSTOM" is the value of _C._tabbing.

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p_status AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_Urecid AS RECID NO-UNDO.

/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

/* *************************** Local Variables ************************* */

DEFINE VARIABLE row-width   AS INTEGER        NO-UNDO.
DEFINE VARIABLE col-width   AS INTEGER        NO-UNDO.
DEFINE VARIABLE col-height  AS INTEGER        NO-UNDO.
DEFINE VARIABLE col-num     AS INTEGER        NO-UNDO.
DEFINE VARIABLE hpos        AS INTEGER        NO-UNDO.
DEFINE VARIABLE vpos        AS INTEGER        NO-UNDO.
DEFINE VARIABLE l-to-r      AS LOGICAL        NO-UNDO.
DEFINE VARIABLE by-col      AS LOGICAL        NO-UNDO.
DEFINE VARIABLE skip_object AS LOGICAL        NO-UNDO.
DEFINE VARIABLE tab-option  AS CHAR           NO-UNDO.
DEFINE VARIABLE tab_i       AS INTEGER        NO-UNDO.
DEFINE BUFFER   x_U     FOR _U.
DEFINE BUFFER   x_L     FOR _L.
DEFINE QUERY    t_order FOR x_U, x_L.


/* Get the parent record. */
FIND _U WHERE RECID(_U) eq p_Urecid.
FIND _C WHERE RECID(_C) eq _U._x-recid.
FIND _L WHERE _L._u-recid eq p_Urecid AND _L._LO-NAME eq "{&Master-Layout}":U.

/* Decide how we are going to do tabbing. In v8 we look at the _default_tabbing
   variable. At some future point we should look as _C._tabbing (which could
   be initialized from _default_tabbing on read and _draw.  */

tab-option = _C._tabbing. 

IF tab-option = "Default":U THEN
  tab-option = _default_tabbing.

IF tab-option = "CUSTOM":U THEN RETURN.

ASSIGN l-to-r = LOOKUP ("R-to-L":U, tab-option) eq 0   
       by-col = LOOKUP ("COLUMNS":U, tab-option) > 0
       .   

/* Save the frame height, because we will be using it alot. 
   (Save the value in 100's of PPU's.) */
ASSIGN row-width  = _L._VIRTUAL-WIDTH * 100
       col-height = _L._VIRTUAL-HEIGHT * 100
       col-width  = 500
       col-num    = 0.

/* Now compute TAB-ORDER for each Object. */
FOR EACH x_U WHERE x_U._parent-recid = p_Urecid 
             AND x_U._STATUS eq p_status
             AND RECID (x_U) ne p_Urecid
             AND NOT CAN-DO ('QUERY,TEXT,IMAGE,RECTANGLE,LABEL':U, x_U._TYPE), 
    EACH x_L WHERE x_L._u-recid = RECID(x_U) 
             AND x_L._LO-NAME = "Master Layout":U
             AND NOT x_L._NO-FOCUS:

 /* Compute the horizontal position of the object in it's column.  (NOTE: for
    r-to-l, this is computed as the upper-right corner. */
  IF l-to-r THEN hpos = (x_L._COL - 1.0) * 100.
  ELSE hpos = row-width - ((x_L._COL - 1.0 + x_L._WIDTH) * 100).
 
 /* Fix the horizontal position based on COLUMNS. */
 IF by-col 
 THEN ASSIGN 
       col-num =  TRUNCATE (hpos / col-width, 0)
       hpos = hpos - (col-num * col-width)
       x_U._TAB-ORDER = 
                 (col-width * ((col-num * col-height) + ((x_L._ROW - 1.0) * 100) )) + hpos . 
  ELSE ASSIGN
       x_U._TAB-ORDER = 
                 (row-width * (x_L._ROW - 1.0) * 100) + hpos.
END.

/* the previous code assigns each object a large tab order number, based */
/* upon mathematical figuring. The code that generates the MOVE-BEFORE   */
/* and MOVE-AFTER tab item calls relies on the numbers being sequential. */
/* So, loop through all the objects, again, but this time do it by tab   */
/* order, and assign each tab order an incremented value.                */
OPEN QUERY t_order 
     PRESELECT EACH x_U
               WHERE x_U._parent-recid = p_Urecid 
               AND x_U._STATUS eq p_status
               AND RECID (x_U) ne p_Urecid
               AND NOT CAN-DO ('QUERY,TEXT,IMAGE,RECTANGLE,LABEL':U, _U._TYPE),
               EACH x_L
               WHERE x_L._u-recid = RECID(x_U) 
               AND x_L._LO-NAME = "Master Layout":U
               AND NOT x_L._NO-FOCUS
               BY x_U._TAB-ORDER.

GET FIRST t_order.
DO WHILE AVAILABLE (x_U):
  skip_object = FALSE.
  IF x_U._TYPE = "FILL-IN":U AND x_U._SUBTYPE = "TEXT":U THEN skip_object = TRUE.
  IF NOT skip_object THEN
    ASSIGN tab_i          = tab_i + 1
           x_U._TAB-ORDER = tab_i.
  GET NEXT t_order.
END.
