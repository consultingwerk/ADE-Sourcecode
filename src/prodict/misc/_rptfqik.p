/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _rptfqik.p

Description:
   Quick and dirty field report for character dictionary.

Input:
   user_env[19] = begins "a" for _Field-name order or "o" for _Order order
 
Author: Tony Lavinio, Laura Stern

Date Created: 10/05/92
     History: 04/13/00 Added long path name support

----------------------------------------------------------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

RUN adecomm/_qfldrpt.p
   (INPUT drec_db,
    INPUT user_dbname, /*(IF LDBNAME(user_dbname) = ? 
      	     THEN user_dbname ELSE PDBNAME(user_dbname)),*/
    INPUT user_dbtype,
    INPUT user_filename,
    INPUT "s" + SUBSTRING(user_env[19],1,1)).

/* Reset global for "order by", based on what was last chosen in report */
IF INDEX(RETURN-VALUE, "o") > 0 THEN
   user_env[19] = "o".
ELSE IF INDEX(RETURN-VALUE, "a") > 0 THEN
   user_env[19] = "a".

/* See if switch file was chosen */
IF INDEX(RETURN-VALUE, "s") > 0 THEN
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   user_path   = "1=a,_usrtget,_rptfqik".
   &ELSE
   user_path   = "1=a,_guitget,_rptfqik".
   &ENDIF
