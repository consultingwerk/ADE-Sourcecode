/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/ora/_ora_als.p

Description:
    + disconnects from DICTDBG if already connectd
    + assignes the link-name to _db-misc2[8]
    + connects to the link-db 
    + sets the alias
    
Input-Parameters:  
    p_ldbname      logical name of the link-db (= physical name)
    p_link-name    link-name for _db-misc2[8]
    
Output-Parameters: 
    none
    
Used/Modified Shared Objects:
    none

    
History:
    hutegger    94/09/11    creation
    
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

define input parameter p_ldbname   as character.

{ prodict/dictvar.i }

/*---------------------------  TRIGGERS  ---------------------------*/

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

if connected(p_ldbname)
 then create alias DICTDBG for database value(p_ldbname).

 
/*------------------------------------------------------------------*/
