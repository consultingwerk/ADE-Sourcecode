/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _rpttqik.p

Description:
   Quick and dirty table report for character dictionary.
 
Author: Tony Lavinio, Laura Stern

Date Created: 10/05/92
     History:  04/13/00 Added long path name support

----------------------------------------------------------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

RUN adecomm/_qtblrpt.p
   (INPUT drec_db,    
    INPUT user_dbname,
    INPUT user_dbtype).

