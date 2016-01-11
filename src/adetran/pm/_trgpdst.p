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
TRIGGER PROCEDURE FOR DELETE OF xlatedb.XL_String_Info.
    define buffer bXLStrInfo for xlatedb.XL_String_Info.
    
    find first xlatedb.XL_Project exclusive-lock no-error.
    if avail xlatedb.XL_Project then                  
    do:  
       xlatedb.XL_Project.NumberOfWords = 
         xlatedb.XL_Project.NumberOfWords - num-entries(xlatedb.XL_String_Info.Original_string," ").  
         
       if not can-find(first bXLStrInfo where bXLStrInfo.Original_string = 
                        xlatedb.XL_String_Info.Original_String) then
       xlatedb.XL_Project.NumberOfUniquePhrases = 
         xlatedb.XL_Project.NumberOfUniquePhrases - 1.
       
     end.

