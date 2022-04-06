/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _rptvqik.p

Description:
   Quick and dirty view report for character dictionary.
 
Input: user_env[1] = View name or "ALL".

Author: Tony Lavinio, Laura Stern

Date Created: 10/07/92
    History:  04/13/00 Added Long path name support

----------------------------------------------------------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

RUN adecomm/_qviwrpt.p
   (INPUT drec_db,    
    INPUT user_dbname,
    INPUT user_dbtype,
    INPUT user_env[1]).

