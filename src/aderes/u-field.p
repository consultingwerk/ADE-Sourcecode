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
* u-field.p - field-level security for RESULTS
*
*    An example file to provide the function interface that is expected by
*    Results. The Admin is going to provide their security for the
*    fields available in the various GUI field pickers.
*
*    Results will RUN this file every time a field picker is brought
*    up.
*
*    Results does not provide a Core equivalent to this program. If this
*    program is not hooked to Results, Results will use the current
*    state of the of the permissions of the fields.
*
*    Use the Admin->Integration Procedures... to hook this function into
*    Results. In the dialog box choose "Field Security Code" and
*    change the codepath.
*
*    This function, if hooked in as is, will not change the permissions
*    of the fields.
*
*  Input Parameters
*
*    tableName The table in question
*
*    fieldName The field in question
*
*    userName  The user.
*
*  Output Parameters
*
*    retStat True, if the userName can see the field
*/

DEFINE INPUT  PARAMETER tableName AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER fieldName AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER userName  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER retStat   AS LOGICAL   NO-UNDO INITIAL TRUE.

/* u-field.p - end of file */

