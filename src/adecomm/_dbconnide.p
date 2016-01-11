/*********************************************************************
* Copyright (C) 2013 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _dbconnide.p

Description:
   Calls PDS connection dialog box, doing the 
   connection if the user presses OK.  This call takes only three parameters.

Input/Output Parameters:
   
   | On input:  a value is supplied if known, otherwise, the value is ?
   | On output: if connect succeeded, all values are set.  If connect failed
      	        or if the user cancelled, Pname and LName are set to ?.

   p_PName  - the physical name of the database
   p_LName  - the logical name of the database
   p_Type   - The database type (e.g., PROGRESS, ORACLE)
   
 
Author:  hdaniels

Date Created: 08/26/2013

----------------------------------------------------------------------------*/
{adecomm/oeideservice.i}

Define INPUT-OUTPUT parameter p_PName  as char NO-UNDO.
Define INPUT-OUTPUT parameter p_LName  as char NO-UNDO.
Define INPUT-OUTPUT parameter p_Type   as char NO-UNDO.

define var lok           as logical no-undo.
define variable inum as integer no-undo.
/*----------------------------Mainline code----------------------------------*/

inum = NUM-DBS.
p_LName = ?. 
p_PName = ?.
 /* ? = no prompt do you want to connect*/
run ShowDBConnectionDialog in hOEIDEService(?, output lok).           
if lok = true then 
do:
    if NUM-DBS > 0 then
    do:
        /* The database whose name was entered in the name fill-in, may in
           fact not be one of the ones that connected successfully.
           To be sure we get this right, get the info from Progress for
           the num+1 connected database - it should be the first of the ones
           that were just connected.
          */
        assign
             p_LName = LDBNAME(inum + 1)
             p_PName = PDBNAME(inum + 1)
             p_Type = DBTYPE(inum + 1).
             
    end.  
     
end.      
   
RETURN.



