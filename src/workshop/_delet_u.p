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

File: _delet_u.p

Description:
   This routine deletes frame level widgets and their children and
   sets the _U record as DELETED. If p_TRASH is set, then the objects
   are deleted.
   
   Associated _F, _Q and _HTM records are also deleted.

Input Parameters:
   p_Urecid -  Recid of _U to be deleted.
   p_TRASH  -  True if objects are to be truely deleted, else select the objects
               as being deleted. 

Output Parameters:
   <None>
       
Author: Wm. T. Wood [from adeuib/_delet_u.p and adeuib/delete_u.i]

Date Created: Feb. 2, 1997

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p_Urecid AS RECID NO-UNDO.
DEFINE INPUT PARAMETER p_TRASH  AS LOGICAL NO-UNDO.

/* Include files */
{ workshop/code.i }        /* Code Section TEMP-TABLE definition             */
{ workshop/htmwidg.i }     /* HTML Field TEMP-TABLE definition               */
{ workshop/uniwidg.i }     /* Universal Widget TEMP-TABLE definition         */
   
DEFINE BUFFER x_U FOR _U.
DEFINE BUFFER x_F FOR _F.
 
/* Find a _U record and delete it */
FIND _U WHERE RECID(_U) eq p_Urecid.

/* Delete all children of a frame. */
IF _U._TYPE eq "FRAME":U THEN DO:
  FOR EACH x_U WHERE x_U._PARENT-RECID eq RECID(_U) AND RECID(x_U) ne RECID(_U):


    /* Mark the _U record as deleted (or just Trash it). */	 
    IF p_TRASH THEN DO: 
      /* Delete the associated code blocks. */
      FOR EACH _code WHERE _code._l-recid eq RECID(x_U):
        RUN workshop/_del_cd.p (RECID(_code)).
      END.
      /* Delete linked extension record. */
      FIND _F WHERE RECID(_F) = x_U._x-recid NO-ERROR.
      IF AVAILABLE (_F) THEN DELETE _F.
      ELSE FIND _Q WHERE RECID(_Q) = x_U._x-recid NO-ERROR.
      IF AVAILABLE (_Q) THEN DELETE _Q.
      /* Delete linked HTM record. */
      FIND _HTM WHERE _HTM._U-recid eq RECID(x_U) NO-ERROR.
      IF AVAILABLE (_HTM) THEN DELETE _HTM.
      /* Finally, delete the original record. */
      DELETE x_U. 
    END.
    ELSE ASSIGN x_U._STATUS        = "DELETED":U
                x_U._SELECTEDib    = FALSE
                .
  END.  /* For each child of a Frame or Dialog-box */

END. /* IF...FRAME...*/

/* First delete its triggers */
IF p_TRASH THEN DO:
  /* Delete the associated code blocks. */
  FOR EACH _code WHERE _code._l-recid eq RECID(_U):
    RUN workshop/_del_cd.p (RECID(_code)).
  END. 
  /* Delete linked extension record. */
  FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
  IF AVAILABLE (_F) THEN DELETE _F.
  ELSE FIND _Q WHERE RECID(_Q) = _U._x-recid NO-ERROR.
  IF AVAILABLE (_Q) THEN DELETE _Q.
  /* Delete linked HTM record. */
  FIND _HTM WHERE _HTM._U-recid eq RECID(_U) NO-ERROR.
  IF AVAILABLE (_HTM) THEN DELETE _HTM.
  /* Finally, delete the original record. */
  DELETE _U.
END.
ELSE ASSIGN _U._STATUS        = "DELETED"
            _U._SELECTEDib    = FALSE
            .

