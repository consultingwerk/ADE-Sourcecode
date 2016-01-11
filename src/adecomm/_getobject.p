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

File                  : _getobject.p

Description           : This is the ADE API to do the call to open a Dynamic Object.

Input Parameters:
  phWindow            : Window in which to display the dialog box.
  gcProductModule     : Initial Product Module Code.
  glOpenInAppBuilder  : Open in Appbuilder
  pcTitle             : Title for Dialog Window to be launched

Output Parameters:
  gcFileName          : The filename selected.
  pressedOK           : TRUE if user successfully choose an object file name.

Author: Pieter J. Meyer

Date Created: September 2002

----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER phWindow           AS HANDLE      NO-UNDO.
DEFINE INPUT  PARAMETER gcProductModule    AS CHARACTER   NO-UNDO. /* LIKE gsc_product_module.product_module_code. */
DEFINE INPUT  PARAMETER glOpenInAppBuilder AS LOGICAL     NO-UNDO.
DEFINE INPUT  PARAMETER pcTitle            AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER gcFileName         AS CHARACTER   NO-UNDO. /* LIKE ryc_smartobject.object_filename. */
DEFINE OUTPUT PARAMETER pressedOK          AS LOGICAL     NO-UNDO.

IF SEARCH("ry/obj/gopendialog.w":U) <> ?
OR SEARCH("ry/obj/gopendialog.r":U) <> ?
THEN
  RUN ry/obj/gopendialog.w (INPUT  phWindow
                           ,INPUT  gcProductModule
                           ,INPUT  glOpenInAppBuilder
                           ,INPUT  pcTitle
                           ,OUTPUT gcFileName
                           ,OUTPUT pressedOK
                           ).
ELSE DO:
  ASSIGN
    pressedOK = NO.
  MESSAGE "No open object dialog is available."
    VIEW-AS ALERT-BOX BUTTONS OK.
  RETURN.

END.

RETURN.
