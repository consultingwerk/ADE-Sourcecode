/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

