/*********************************************************************
* Copyright (C) 2000-2001 by Progress Software Corporation ("PSC"),  *
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

File: _uibshut.p

Description:
    Shutdown the UIB and clean-up everything.
    
Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992 

Modified on 12/17/96 by gfs - Delete PROX object
            05/06/99 by tsm - Delete MRU FileList Temp Table records
            05/31/00 by jep - Delete LIB-MGR object
            08/19/01 by jep - Delete AB's menubar object. Part of ICF. jep-icf
----------------------------------------------------------------------------*/
 
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}    
{adeuib/links.i}
{adeshar/mrudefs.i}   /* MRU Filelist preferences and temp table definition */

DEFINE VARIABLE sobject AS HANDLE  NO-UNDO.
DEFINE VARIABLE SS      AS INTEGER NO-UNDO.
DEFINE VARIABLE c       AS INTEGER NO-UNDO.

/* Delete any persistent objects that may still be around. */
FOR EACH _U WHERE _U._TYPE eq "SmartObject",
    EACH _S WHERE RECID(_S) = _U._x-recid:
  sobject = _S._HANDLE.
  RUN adeuib/_delet_u.p (INPUT RECID(_U), INPUT TRUE /* Trash Them */ ).
  /* Totally kill it, if this didn't work */
  IF VALID-HANDLE (sobject) THEN DELETE PROCEDURE sobject.
END.                

/* Delete all frames and and dialog frames (which automatically deletes  */
/* all children).  Note that we do need to explicitly remove the         */
/* dialog-box window.                                                    */
FOR EACH _U WHERE CAN-DO("FRAME,DIALOG-BOX,WINDOW",_U._TYPE):
  RUN adeuib/_delet_u.p (INPUT RECID(_U), INPUT TRUE /* Trash Them */ ).
END.

/* Remove any remaining _P records */
FOR EACH _P:
  { adeuib/delete_p.i }
END.

/* Delete the OCX cut file file. */
IF OPSYS = "WIN32":u THEN
DO:
  OS-DELETE VALUE(SEARCH(_control_cut_file)).
  /*
   * At this time, the UIB is the only tool that can change
   * into design mode. So turn it off, we haven't rememebered
   * the state when the UIB was started.
   */
  run adeshar/_cntrsdm.p (0, output ss).
END.    

DELETE WIDGET _h_menu_win.   /* This will delete the Palette */

IF VALID-HANDLE(xPalette) THEN RUN destroy IN xPalette.

/* Delete PROX.PROIDE com object */
IF _h_Controls NE ? THEN RELEASE OBJECT _h_Controls NO-ERROR.
IF ERROR-STATUS:ERROR AND ERROR-STATUS:NUM-MESSAGES > 0 THEN
DO c = 1 TO ERROR-STATUS:NUM-MESSAGES:
  MESSAGE ERROR-STATUS:GET-MESSAGE(c) VIEW-AS ALERT-BOX ERROR TITLE "Error deleting PROX".
END.

/* Ensure that the startup defaults file is restored */
USE "" NO-ERROR.

/* Send a QUIT message to the Help System */
RUN adecomm/_adehelp.p ("AB", "QUIT", ?, ?).

/* Shutdown all design persistent procedures */
FOR EACH _PDP:
  IF VALID-HANDLE(_PDP._hInstance) THEN
    DELETE PROCEDURE _PDP._hInstance.
  DELETE _PDP.
END.

/* Remove internally maintained MRU Filelist */
FOR EACH _mru_files:
  DELETE _mru_files.
END.  /* for each mru */

/* Shutdown the ADE's Method Library Manager object. Important because it references
   AB shared var _h_func_lib, which itself is created and deleted each time the AB
   is started and shutdown. Not deleting the LIB-MGR object would leave it's _h_func_lib
   shared var pointing to a stale persistent procedure handle. This can cause error
   messages such as 2777 when AB utilizes the LIB-MGR, such as in the Section Editor
   Insert Call option. -jep */
IF VALID-HANDLE(_h_mlmgr) THEN
  RUN destroy IN _h_mlmgr NO-ERROR.

/* jep-icf: Shutdown AB menubar procedure. Part of ICF support. */
IF VALID-HANDLE(_h_menubar_proc) THEN
  RUN destroy IN _h_menubar_proc NO-ERROR.
