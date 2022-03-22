/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _rpttrig.p

Description:
   Trigger report for character dictionary.
 
Author: Laura Stern

Date Created: 11/20/92
    History:  04/13/00 Added long path name support

----------------------------------------------------------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

RUN adecomm/_trigrpt.p
   (INPUT drec_db,    
    INPUT user_dbname,
    INPUT user_dbtype).

