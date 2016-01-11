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
* Contributors: MIP Holdings (Pty) Ltd ("MIP")                       *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
/* ERwin Generated File - To fix data if table object number changes */
/* Table = %TableName, FLA = %EntityProp(TableFLA) */

DEFINE INPUT PARAMETER pdOldObj             AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER pdNewObj             AS DECIMAL    NO-UNDO.


%ForEachParentRel() 
{
FOR EACH %Child EXCLUSIVE-LOCK
   WHERE %ForEachFKAtt() {%If(%==(%ParentAtt(%AttFieldName),%lower(%Substr(%Parent,5))_obj)) {  %Child.%AttFieldName = pdOldObj}}:
%ForEachFKAtt() {%If(%==(%ParentAtt(%AttFieldName),%lower(%Substr(%Parent,5))_obj)) {  ASSIGN %Child.%AttFieldName = pdNewObj.}}
END.

}


