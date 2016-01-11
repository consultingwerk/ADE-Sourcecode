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
 * _qisjoin.p
 *
 *    Detirmines if two fields are "OF" joinable
 *
 *  Input Parameters
 *
 *    rightField - The "right" field to be joined
 *
 *   leftField   - THe "left" side of the join
 *
 *  Output Parameters
 *
 *   joinable    - Logical telling if the feilds are OF joinable
 */

{ adecomm/browqury.i }

define input  parameter rightField as character no-undo.
define input  parameter leftField  as character no-undo.
define output parameter joinable   as logical   no-undo.

define variable cDbRight as character no-undo.
define variable cDbLeft  as character no-undo.
define variable isOk     as logical   no-undo.

if (num-entries (rightField, ".") = 1) then
    assign
        cDbRight  = cCurrentDb + "." + rightField
        cDbLeft   = cCurrentDb + "." + leftField
    .
else
    assign
        cDbRight  = rightField
        cDbLeft   = leftField
    .

run "adecomm/_j-test.p" (cDbLeft, cDbRight, output isOk).
if not isOK then run "adecomm/_j-test.p" (cDbRight, cDbLeft, output isOK).

joinable = isOk.

