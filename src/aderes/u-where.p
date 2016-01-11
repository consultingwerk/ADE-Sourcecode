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
/*
* u-where.p
*
*    An example file to provide the function interface that is expected by
*    Results. The Admin is going to provide their own secure where functions.
*
*    Results will call this file for each table that is part of the currently
*    define query. This file returns a syntactically correct string that
*    will be added (and ANDED) to the WHERE clause of the current query.
*
*    Returing an empty string signal to Results that nothing should
*    be added to the Where clause.
*
*    Results does not provide an equivalent to this program. If this
*    program is not hooked to Results, there will be no "secure where"
*    added to the WHERE clause. Results provides no user interface or
*    data structures for the Admin to provide secure where. That aspect
*    falls entirely on the Admin.
*
*    The string that is returned cannot start with WHERE. The string can
*    be a complex clause.
*
*    Use the Admin->Integration Procedures... menu to hook this function
*    into Results. In the IntegrationProcedures dialog box choose
*    "Where Security Code" and change the codepath.
*
*    This function, if hooked in as is, will not change the query.
*
*  Input Parameters
*
*    tableName  - A table name that is part of the current query definition.
*
*    userName   - The user name of this Results session.
*
*  Output Parameters
*
*    whereText  - THe text to be returned to Results.
*/

DEFINE INPUT  PARAMETER tableName AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER userName  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER whereText AS CHARACTER NO-UNDO INITIAL "".

RETURN.

/* u-where.p - end of file */

