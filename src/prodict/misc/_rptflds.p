/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _rptflds.p

Description:
   Detailed table report for character dictionary.  Includes table, field
   and index information.

Input:
   user_env[19] = begins "a" for _Field-name order or "o" for _Order order
 
Author: Tony Lavinio, Laura Stern

Date Created: 10/12/92

----------------------------------------------------------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

RUN adecomm/_dtblrpt.p
   (INPUT drec_db,
    INPUT (IF LDBNAME(user_dbname) = ? 
      	     THEN user_dbname ELSE LDBNAME(user_dbname)),
    INPUT user_dbtype,
    INPUT "",
    INPUT user_filename,
    INPUT no).

/* Reset global for "order by", if user switched order during report viewing */
IF INDEX(RETURN-VALUE, "o") > 0 THEN
   user_env[19] = "o".
ELSE IF INDEX(RETURN-VALUE, "a") > 0 THEN
   user_env[19] = "a".
