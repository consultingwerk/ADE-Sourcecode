/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _rptiqik.p

Description:
   Quick and dirty index report for character dictionary.
 
Author: Tony Lavinio, Laura Stern

Date Created: 10/05/92
    History:  04/13/00 Added long path name support

----------------------------------------------------------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

RUN adecomm/_qidxrpt.p
   (INPUT drec_db,
    INPUT user_dbname,
    INPUT user_dbtype,
    INPUT user_filename,
    INPUT "s").

IF RETURN-VALUE = "s" THEN 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   user_path = "1=a,_usrtget,_rptiqik".
   &ELSE
   user_path = "1=a,_guitget,_rptiqik".
   &ENDIF
