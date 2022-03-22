/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _rptrels.p

Description:
   File relation report for character dictionary.

Author: Tony Lavinio, Laura Stern

Date Created: 10/13/92
    History:  04/13/00 Added long path name support
----------------------------------------------------------------------------*/


{ prodict/dictvar.i }
{ prodict/user/uservar.i }


RUN adecomm/_trelrpt.p
   (INPUT drec_db,
    INPUT user_dbname,
    INPUT user_dbtype,
    INPUT user_filename,
    INPUT "s").

/* See if switch file was chosen */
IF INDEX(RETURN-VALUE, "s") > 0 THEN
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   user_path = "1=a,_usrtget,_rptrels". 
   &ELSE
   user_path = "1=a,_guitget,_rptrels". 
   &ENDIF
