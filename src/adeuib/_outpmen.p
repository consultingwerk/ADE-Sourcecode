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

File: _outpmen.p

Description:
    Output menu definitions to a .w.

Input Parameters:
   menu_rec : Record ID of menu to be outputted
   p_status : Type of outputting (NORMAL or EXPORT)

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992

---------------------------------------------------------------------------- */
{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */

DEFINE INPUT  PARAMETER menu_rec AS RECID                               NO-UNDO.
DEFINE INPUT  PARAMETER p_status AS CHAR.
DEFINE VARIABLE q_label      AS CHAR                                  NO-UNDO.

DEFINE SHARED STREAM    P_4GL.
DEFINE BUFFER x_U FOR _U.
DEFINE BUFFER x_M FOR _M.

FIND _U WHERE RECID(_U) = menu_rec NO-ERROR.
IF NOT AVAILABLE _U THEN RETURN.
FIND _M WHERE RECID(_M) = _U._x-recid.

FIND x_U WHERE RECID(x_U) = _M._child-recid NO-ERROR.

MENU-SCAN:                    /* First output all child submenus             */
REPEAT:
  IF AVAILABLE x_U THEN DO:
    IF x_U._TYPE = "SUB-MENU" THEN
      RUN adeuib/_outpmen.p (INPUT RECID(x_U), INPUT p_status).
    FIND x_M WHERE RECID(x_M) = x_U._x-recid.
    IF x_M._sibling-recid = ? THEN LEAVE MENU-SCAN.
    ELSE FIND x_U WHERE RECID(x_U) = x_M._sibling-recid NO-ERROR.
  END.  /* If there is an x_U available */
  ELSE LEAVE MENU-SCAN.
END.

/* Now output this menu.                                                     */
ASSIGN q_label = REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                        _U._LABEL,"~~","~~~~"), "~"","~~~""), "~\","~~~\"),
                        "~{","~~~{"), "~;","~~~;").
PUT STREAM P_4GL UNFORMATTED
  "DEFINE " _U._TYPE " " _U._NAME
          IF _U._SUBTYPE = "MENUBAR" THEN " MENUBAR"
          ELSE IF _U._SUBTYPE = "POPUP-MENU" AND _U._LABEL NE "" AND
                  _U._LABEL NE ? THEN " TITLE """ + q_label + """" +
                  (IF _U._LABEL-ATTR NE "" THEN (":" + _U._LABEL-ATTR) ELSE "")
          ELSE " ".
          
/* Set trigger status so that they will be exported too.                     */
FOR EACH _TRG WHERE _TRG._wRECID = RECID (_U):
  _TRG._STATUS = p_status.
END.

FIND x_U WHERE RECID(x_U) = _M._child-recid NO-ERROR.

MENU-OUT:
REPEAT:
  IF NOT AVAILABLE x_U THEN DO:
    PUT STREAM P_4GL UNFORMATTED "." SKIP (1).
    LEAVE MENU-OUT.
  END.

  FIND x_M WHERE RECID(x_M) = x_U._x-recid.
  IF CAN-DO("SKIP,RULE",x_U._LABEL) THEN
    PUT STREAM P_4GL UNFORMATTED SKIP "       " x_U._LABEL.
  ELSE DO:
  ASSIGN q_label = REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                        x_U._LABEL,"~~","~~~~"), "~"","~~~""), "~\","~~~\"),
                        "~{","~~~{"), "~;","~~~;").
    PUT STREAM P_4GL UNFORMATTED SKIP
      "       " x_U._TYPE FILL(" ",10 - LENGTH(x_U._TYPE, "raw":U)) x_U._NAME
      FILL(" ",14 - MIN(14,LENGTH(x_U._NAME, "raw":U))) " LABEL """ q_label """" +
                  IF x_U._LABEL-ATTR NE "" THEN ":" + x_U._LABEL-ATTR ELSE ""
      FILL(" ",14 - MIN(14,LENGTH(q_label, "raw":U))).

    IF x_M._ACCELERATOR <> "" AND x_U._TYPE <> "SUB-MENU" THEN
      PUT STREAM P_4GL UNFORMATTED " ACCELERATOR """ x_M._ACCELERATOR """".
    IF NOT x_U._SENSITIVE OR x_U._SUBTYPE = "TOGGLE-BOX" THEN
      PUT STREAM P_4GL UNFORMATTED SKIP "             ".
    IF NOT x_U._SENSITIVE THEN PUT STREAM P_4GL UNFORMATTED " DISABLED".
    IF x_U._SUBTYPE = "TOGGLE-BOX" THEN
      PUT STREAM P_4GL UNFORMATTED " TOGGLE-BOX".
      
    /* Set trigger status so that they will be exported too.                 */
    FOR EACH _TRG WHERE _TRG._wRECID = RECID (x_U):
      _TRG._STATUS = p_status.
    END.
  END.

  IF x_M._sibling-recid = ? THEN DO:
    PUT STREAM P_4GL UNFORMATTED "." SKIP (1).
    LEAVE MENU-OUT.
  END.
  ELSE FIND x_U WHERE RECID(x_U) = x_M._sibling-recid NO-ERROR.

END.

