/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/_dctalia.p

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
    mcmann      10/17/03    Add NO-LOCK statement to _Db find in support of on-line schema add

                            
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

define input parameter p_db-name    as character.

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

      find first DICTDB._Db
        where DICTDB._Db._Db-name = p_db-name
        NO-LOCK no-error.

      if not available DICTDB._Db
       then create alias "DICTDB"
            for database VALUE(SDBNAME(p_db-name))
            no-error.

/*------------------------------------------------------------------*/
