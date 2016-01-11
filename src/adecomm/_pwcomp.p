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

/**************************************************************************
    Procedure:  _pwcomp.p
    
    Purpose:    Execute Procedure Window Compile menu commands.

    Syntax :    RUN adecomm/_pwcomp.p ( INPUT p_Action ) .

    Parameters:
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

/* Procedure Window Global Defines include. */
{ adecomm/_pwglob.i }

/* Procedure Window Attributes include. */
{ adecomm/_pwattr.i }

DEFINE INPUT PARAMETER p_Action AS CHARACTER NO-UNDO.

DEFINE VARIABLE pw_Window       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE pw_Editor       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hAttr_Field     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE l_ok            AS LOGICAL       NO-UNDO.
DEFINE VARIABLE h_cwin          AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE Private_Data    AS CHARACTER     NO-UNDO.

/* --- Begin SCM changes --- */
DEFINE VAR scm_ok       AS LOGICAL           NO-UNDO.
/* --- End SCM changes ----- */

DO:
  REPEAT ON STOP UNDO, RETRY:
    IF RETRY THEN LEAVE.
    /* Get widget handles of Procedure Window and its editor widget. */
    RUN adecomm/_pwgetwh.p ( INPUT SELF , OUTPUT pw_Window ).
    RUN adecomm/_pwgeteh.p  ( INPUT pw_Window , OUTPUT pw_Editor ).

    /* Save current-window handle to restore later. */
    ASSIGN h_cwin         = CURRENT-WINDOW
           CURRENT-WINDOW = pw_Window.

    /* --- Begin SCM changes --- */
    RUN adecomm/_adeevnt.p
        (INPUT  {&PW_NAME} , INPUT "Before-" + p_Action ,
         INPUT STRING( pw_Editor ), INPUT pw_Editor:NAME ,
         OUTPUT scm_ok ).
    IF scm_ok = FALSE THEN RETURN.
    /* --- End SCM changes ----- */

    RUN adecomm/_pwrun.p (INPUT p_Action).
    
    LEAVE.
  END. /* REPEAT */                                                   

  /* Repoint current-window. */
  IF VALID-HANDLE( h_cwin ) THEN ASSIGN CURRENT-WINDOW = h_cwin .
  
  /* --- Begin SCM changes --- */
  RUN adecomm/_adeevnt.p
      (INPUT  {&PW_NAME} , INPUT p_Action ,
       INPUT STRING( pw_Editor ), INPUT pw_Editor:NAME ,
       OUTPUT scm_ok ).
  /* --- End SCM changes ----- */

END. /* DO */
