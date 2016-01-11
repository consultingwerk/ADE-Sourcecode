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
/*------------------------------------------------------------------------

  File: _uib_dlg.p
  
  Description: Front end to call UIB's dialogs. 

  Input Parameters:
      pi-context (int) - recid of the _U or _P required.
      dname (char)     - dialog to call
                           "QUERY BUILDER"
                           "COLUMN EDITOR"
                           "EXTERNAL-TABLES"

  Input-Output Parameters:
      args  (char)     - data to send to and/or recieve from dialog
                         (e.g. Send/recieve table list to/from Column Editor)
                         (e.g. Specify mode on Query Builder)
                             where mode may equal (in a CDL): 
                               ? 
                               "NORMAL"
                               "QUERY-ONLY"
                               "CHECK-FIELDS"
                               "NO-FREEFORM-QUERY"

  Author: Gerry Seidl 

  Created: 4/10/95

------------------------------------------------------------------------*/
{adecomm/adestds.i} /* Standard Definitions             */ 
{adeuib/uniwidg.i}  /* Universal widget TT defs         */
{adeuib/sharvars.i} /* Shared vars                      */

DEFINE INPUT         PARAMETER pi-context AS INTEGER   NO-UNDO.
DEFINE INPUT         PARAMETER dname      AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT  PARAMETER args       AS CHARACTER NO-UNDO.

DEFINE VARIABLE i        AS INTEGER    NO-UNDO.
DEFINE VARIABLE ctblname AS CHARACTER  NO-UNDO.
DEFINE VARIABLE tmp-name AS CHARACTER  NO-UNDO.

CASE dname:
  WHEN "EXTERNAL-TABLES" THEN DO:
    FIND _P WHERE INT(RECID(_P)) = pi-context NO-ERROR.
    IF AVAILABLE _P THEN RUN adeuib/_xtblist.w (INPUT-OUTPUT _P._xTblList).
    ELSE DO:
      RUN error-msg ( "Invalid procedure context." ).
      RETURN "Error".
    END.
  END.
  
  WHEN "COLUMN EDITOR" THEN DO:
    FIND _U WHERE RECID(_U) = pi-context NO-ERROR.
    IF AVAILABLE _U THEN DO:
      ASSIGN _query-u-rec = RECID(_U).
      /* send over a table list or a handle to a SmartData */
      FIND _P WHERE _P._window-handle = _h_win.
      IF AVAILABLE _P THEN DO:
        DO i = 1 TO NUM-ENTRIES (args):
          ASSIGN ENTRY(i,args) = ENTRY(1, ENTRY(i,args), " ":U)
                 tmp-name            = ENTRY(i,args).
          IF NUM-ENTRIES(tmp-name,".":U) = 1 THEN ctblname = tmp-name.  /* May be a buffer */
          ELSE ctblname = ENTRY(2,tmp-name,".":U).
          FIND FIRST _TT WHERE _TT._p-recid = RECID(_P)
                           AND _TT._NAME = ctblname NO-ERROR.
          IF AVAILABLE _TT THEN
            ENTRY(i,args) = "Temp-Tables":U + "." + ctblname.
        END.  /* do i to num-entries*/
      END.  /* if avail _P */
      RUN adeuib/_coledit.p (INPUT args, INPUT ?).
    END.
  END.
  
  WHEN "QUERY BUILDER" THEN DO:
      /* get procedure handle to determine if dynamic or static object */
      /* if dynamic, omit the freeform query button from the query builder dlg*/
  
    FIND _U WHERE RECID(_U) = pi-context NO-ERROR.
    IF AVAILABLE _U THEN DO:

      /* iz 7535 Get rid of the freeform query button for dynamic sdos */
      FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE NO-ERROR.
        IF AVAILABLE _P AND (NOT _P.Static_object OR (_P.object_type_code EQ "DynSDO":U))
            THEN ASSIGN args = IF args = "":U THEN "NO-FREEFORM-QUERY":U 
                           ELSE  args + ",NO-FREEFORM-QUERY":U.
            
      RUN adeuib/_callqry.p ("_U", RECID(_U), args ).
    END.
    ELSE DO:
      RUN error-msg ( "Invalid context passed for call to Query Builder." ).
      RETURN "Error".
    END.
  END.
    
END CASE.

     
/* error-msg -- standared error message. */
PROCEDURE error-msg :
  DEFINE INPUT PARAMETER msg AS CHAR NO-UNDO.  
  MESSAGE "[{&FILE-NAME}]" SKIP msg VIEW-AS ALERT-BOX ERROR.
END PROCEDURE.
