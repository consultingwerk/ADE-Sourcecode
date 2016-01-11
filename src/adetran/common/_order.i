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

Procedure:    adetran/common/_order.i
Author:       F. Change
Created:      1/95 
Updated:      9/95
Purpose:      Include file that does the actual column shuffling.
Called By:    common/_order.w
*/

    DEFINE INPUT-OUTPUT PARAMETER pList  AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER pOrder AS CHAR NO-UNDO. 
    DEFINE VARIABLE tSrc AS INTEGER NO-UNDO.        
    DEFINE VARIABLE FromPos AS INTEGER NO-UNDO. 
    DEFINE VARIABLE ToPos AS INTEGER NO-UNDO.
        
    DO i = 1 TO NUM-ENTRIES(pList):
       CREATE tmp-order.
       ASSIGN tmp-order.OrdCol = TRIM(ENTRY(i,pList))
              tmp-order.OldNum = i.       
    END.    
    
    DO i = 1 TO NUM-ENTRIES(pOrder):              
       tSrc = LOOKUP(ENTRY(i,pOrder),pList).
       tLog = {1}:MOVE-COLUMN(tSrc,i) IN FRAME {&Frame-Name}.
       ASSIGN FromPos = tSrc
              ToPos = i.
              
        FOR EACH tmp-order WHERE tmp-order.OldNum >= ToPos AND
                                 tmp-order.OldNum <> FromPos 
                                 BY tmp-order.OldNum:
            tmp-order.NewNum = tmp-order.OldNum + 1.
        END.                                        
        FIND tmp-order WHERE tmp-order.OrdCol = ENTRY(i,pOrder).
             tmp-order.NewNum = ToPos.
                           
        pList = "".                    
        FOR EACH tmp-order BY tmp-Order.NewNum:
            pList = pList + tmp-order.OrdCol + ",":u. 
        END.              
        pList = TRIM(pList).         
        
        FOR EACH tmp-order:
            tmp-order.OldNum = tmp-Order.NewNum.
        END.    
    END.    
    
    FOR EACH tmp-order:
        DELETE tmp-order.
    END.

