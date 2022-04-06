/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
   WHERE %ForEachFKAtt() {%If(%==(%ParentAtt(%AttFieldName),%lower(%Substr(%Parent,%DiagramProp("TableSubstr")))_obj)) {  %Child.%AttFieldName = pdOldObj}}:
%ForEachFKAtt() {%If(%==(%ParentAtt(%AttFieldName),%lower(%Substr(%Parent,%DiagramProp("TableSubstr")))_obj)) {  ASSIGN %Child.%AttFieldName = pdNewObj.}}
END.

}


