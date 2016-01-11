/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _dbconn.p

Description:
   Calls dbconnx.p to display and handle the connect dialog box, doing the 
   connection if the user presses OK.  This call takes only three parameters.

Input/Output Parameters:
   
   | On input:  a value is supplied if known, otherwise, the value is ?
   | On output: if connect succeeded, all values are set.  If connect failed
      	        or if the user cancelled, Pname and LName are set to ?.

   p_PName  - the physical name of the database
   p_LName  - the logical name of the database
   p_Type   - The database type (e.g., PROGRESS, ORACLE)
   
 
Author: Laura Stern

Date Created: 03/24/92

----------------------------------------------------------------------------*/
{adecomm/oeideservice.i}

Define INPUT-OUTPUT parameter p_PName  as char NO-UNDO.
Define INPUT-OUTPUT parameter p_LName  as char NO-UNDO.
Define INPUT-OUTPUT parameter p_Type   as char NO-UNDO.

Define var dummy_1   	 as char    NO-UNDO.
Define var dummy_2   	 as char    NO-UNDO.
Define var dummy_3   	 as char    NO-UNDO.
Define var dummy_4   	 as char    NO-UNDO.
Define var dummy_5   	 as char    NO-UNDO.
Define var dummy_6   	 as char    NO-UNDO.
Define var dummy_7       as char    NO-UNDO.
Define var dummy_8       as char    NO-UNDO.
Define var dummy_9       as char    NO-UNDO.
Define var Db_Multi_User as logical NO-UNDO.
define var lok           as logical no-undo.
define variable inum as integer no-undo.
/*----------------------------Mainline code----------------------------------*/

DB_Multi_User = no.

if OEIDE_CanShowMessage() and num-dbs = 0 then
do: 
    RUN adecomm/_dbconnide.p ( 
                        INPUT-OUTPUT p_PName,
                        INPUT-OUTPUT p_LName,
                        INPUT-OUTPUT p_Type).        
end. 
else 
    RUN adecomm/_dbconnx.p ( YES,   /* whether to connect the database spec'd */
                        INPUT-OUTPUT p_PName,
                        INPUT-OUTPUT p_LName,
                        INPUT-OUTPUT p_Type,
                        INPUT-OUTPUT Db_Multi_User,
                        INPUT-OUTPUT dummy_1,
                        INPUT-OUTPUT dummy_2,
                        INPUT-OUTPUT dummy_3,
                        INPUT-OUTPUT dummy_4,
                        INPUT-OUTPUT dummy_5,
                        INPUT-OUTPUT dummy_6,
                        INPUT-OUTPUT dummy_7,
                        INPUT-OUTPUT dummy_8,
                        OUTPUT       dummy_9  ).

RETURN.



