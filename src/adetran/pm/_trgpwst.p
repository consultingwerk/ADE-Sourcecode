/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR WRITE OF xlatedb.XL_String_Info.
   find first xlatedb.XL_Project exclusive-lock no-error.
   if avail xlatedb.XL_Project then
      xlatedb.XL_Project.NumberOfWords = 
       xlatedb.XL_Project.NumberOfWords + 
        num-entries(xlatedb.XL_String_Info.Original_string," ").  

