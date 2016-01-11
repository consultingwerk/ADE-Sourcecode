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

  File: _tbllist.p

  Description:
    Computes the list of all tables that are found in or external to the
    query associated with an object.  That is, we get the UNION of all tables
    in a browse, its parent frame, the parents parent (etc), and the procedure
    query.
                    

  Input Parameters:
    p_Urecid      - the RECID of the object (Browse or Frame)
    pl_inc_self   - if FALSE, then don't include the _U record in the tablelist

  Output Parameters:
    pc_tbllist    - the list of tables
      
  Notes: Tables can appear only once in the output list.  The output list
         is of the form "db.table,db.table2,etc".
         
  Author: Wm.T.Wood

  Created: 2/27/95
 
-----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p_Urecid    AS RECID NO-UNDO.
DEFINE INPUT  PARAMETER pl_inc_self AS LOGICAL NO-UNDO.
DEFINE OUTPUT PARAMETER pc_tbllist  AS CHAR NO-UNDO.

DEFINE VAR r-parent AS RECID NO-UNDO.

/* Standard Shared Variables */
{ adeuib/uniwidg.i }

/* Find the record of widget and procedure of interest */
FIND _U WHERE RECID(_U) eq p_Urecid.
FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE.

/* Initialize the output list to be the procedures external tables */
pc_tblList = _P._xTblList.

/* Add in the query for the current record */
IF pl_inc_self THEN DO:
  FIND _C WHERE RECID(_C) eq _U._x-recid.
  FIND _Q WHERE RECID(_Q) eq _C._q-recid.  
  RUN addtables (_Q._TblList).
END.  

/* Keep finding parent frames and adding them to the list.  Unless we are
   already on a dialog, which has no parent. */
IF _U._TYPE ne "DIALOG-BOX" THEN DO:
  r-parent = _U._parent-recid.
  FIND _U WHERE RECID(_U) eq r-parent.
  DO WHILE _U._TYPE eq "FRAME":U :
    /* Incorporate these tables */
    FIND _C WHERE RECID(_C) eq _U._x-recid.
    FIND _Q WHERE RECID(_Q) eq _C._q-recid.  
    RUN addtables (_Q._TblList).
    /* Get the next parent */
    r-parent = _U._parent-recid.
    FIND _U WHERE RECID(_U) eq r-parent.
  END.
  
  /* If the great-grandparent is a dialog-box, then get its frame. */
  IF _U._TYPE eq "DIALOG-BOX":U THEN DO:
    /* Incorporate these tables */
    FIND _C WHERE RECID(_C) eq _U._x-recid.
    FIND _Q WHERE RECID(_Q) eq _C._q-recid.  
    RUN addtables (_Q._TblList).
  END.
END.

/* ************************* Internal Tables ****************************** */

/* addtables - add the list of tables to the output list.
               Note that the input list has the form 
               "db.table,db.table2 OF db.table,db.table2 WHERE db.table etc).  
               So we want only the first ENTRY of each element of the list. */
PROCEDURE addtables:
  DEFINE INPUT PARAMETER list2add AS CHAR NO-UNDO.
  
  DEFINE VAR cnt AS INTEGER NO-UNDO.
  DEFINE VAR i   AS INTEGER NO-UNDO.
  DEFINE VAR tbl AS CHAR NO-UNDO.
  
  cnt = NUM-ENTRIES(list2add).
  DO i = 1 TO cnt:
    tbl = ENTRY (1, TRIM(ENTRY(i,list2add)), " ":U).
    /* Only add it if it isn't already in the list */
    IF pc_tblList eq "" THEN pc_tblList = tbl.
    ELSE IF NOT CAN-DO (pc_tbllist, tbl) 
    THEN pc_tblList = pc_tblList + "," + tbl.
  END.
END PROCEDURE.
