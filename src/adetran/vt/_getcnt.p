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
/*

Procedure:    adetran/vt/_getcnt.p
Author:       R. Ryan 
Created:      1/95 
Updated:      9/95
Purpose:      Visual Translator's Get Count program
Background:   Simple procedure for determining whether or not
              there are any records in the project.  This is used
              by vt/_main.p for sensitizing menus and buttons. 
Includes:     none
Called By:    vt/_main.p
*/

define output parameter TransFlag as logical no-undo.
define output parameter GlossaryFlag as logical no-undo.

find kit.XL_Project no-lock no-error.  
if available kit.XL_Project then 
DO:
  FIND FIRST kit.XL_Instance NO-LOCK NO-ERROR.
  FIND FIRST kit.XL_GlossEntry NO-LOCK NO-ERROR.
  ASSIGN
     TransFlag    = IF AVAILABLE kit.XL_Instance   THEN TRUE ELSE FALSE
     GlossaryFlag = IF AVAILABLE kit.XL_GlossEntry THEN TRUE ELSE FALSE.
END.
