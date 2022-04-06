/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/misc/_setalia.p

Description:
    
    Sets DICTDB alias to Database number p_db-num
            
Input-Parameters:
    p_db-num    number of db to set alias to

Output-Parameters:
    none
    
Used/Modified Shared Objects:
    none
    
Author: Tom Hutegger

History:
    hutegger    94/04/12    creation

                            
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

define input parameter p_db-num     as integer.

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

if LDBNAME(p_db-num) <> ?
 then create alias DICTDB for database value(LDBNAME(p_db-num)).

/*------------------------------------------------------------------*/
