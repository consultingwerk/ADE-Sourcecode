/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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
