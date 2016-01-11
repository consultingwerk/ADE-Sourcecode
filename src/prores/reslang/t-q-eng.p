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
/* t-q-eng.p - English language definitions for Query module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'No record found using this criteria.'
    qbf-lang[ 2] = 'Full Set,Join,Subset'
    qbf-lang[ 3] = 'All Shown,At Top,At Bottom'
    qbf-lang[ 4] = 'There are no indexes defined for this file.'
    qbf-lang[ 5] = 'Are you sure that you want to delete this record?'
    qbf-lang[ 6] = '' /* special total message: created from #7 or #8 */
    qbf-lang[ 7] = 'Total operation stopped.'
    qbf-lang[ 8] = 'Total records available is '
    qbf-lang[ 9] = 'Total running...   Press [' + KBLABEL("END-ERROR")
                 + '] to stop.'
    qbf-lang[10] = 'Equals,is Less Than,is Less Than or Equal To,'
                 + 'is Greater Than,is Greater Than or Equal To,'
                 + 'is Not Equal To,Matches,Begins'
    qbf-lang[11] = 'There are currently no records available.'
    qbf-lang[13] = 'You are already at the first record in the file.'
    qbf-lang[14] = 'You are already at the last record in the file.'
    qbf-lang[15] = 'There are no query forms currently defined.'
    qbf-lang[16] = 'Query'
    qbf-lang[17] = 'Please select the name of the Query form to use.'
    qbf-lang[18] = 'Press [' + KBLABEL("GO")
                 + '] or [' + KBLABEL("RETURN")
                 + '] to select form, or [' + KBLABEL("END-ERROR")
                 + '] to exit.'
    qbf-lang[19] = 'Loading query form...'
    qbf-lang[20] = 'The compiled query form is missing for this procedure.  '
                 + 'The problem may be:^1) incorrect PROPATH,^2) missing '
                 + 'query .r file, or^3) uncompiled .r file.^(Check the '
                 + '<dbname>.ql file for compiler error messages).^^You may '
                 + 'try to continue, but this may result in an error message.  '
                 + 'Do you want to attempt to continue?'
    qbf-lang[21] = 'There is a WHERE clause for the current query which '
                 + 'contains values that are asked for at RUN-TIME.  This is '
                 + 'not supported in the Query module.  Ignore WHERE clauses '
                 + 'and continue?'
    qbf-lang[22] = 'Press [' + KBLABEL("GET")
                 + '] to set different browse fields.'.

ELSE

IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Next,Next record.'
    qbf-lang[ 2] = 'Prev,Previous record.'
    qbf-lang[ 3] = 'First,First record.'
    qbf-lang[ 4] = 'Last,Last record.'
    qbf-lang[ 5] = 'Add,Add a new record.'
    qbf-lang[ 6] = 'Update,Update the currently displayed record.'
    qbf-lang[ 7] = 'Copy,Copy the currently displayed record to a new record.'
    qbf-lang[ 8] = 'Delete,Delete the currently displayed record.'
    qbf-lang[ 9] = 'View,View a different Query form.'
    qbf-lang[10] = 'Browse,Browse through a list of records.'
    qbf-lang[11] = 'Join,Join to related records.'
    qbf-lang[12] = 'Query,Query by Example selection of records.'
    qbf-lang[13] = 'Where,WHERE clause editor selection of records.'
    qbf-lang[14] = 'Total,Number of records in current set or subset.'
    qbf-lang[15] = 'Order,Switch to different index.'
    qbf-lang[16] = 'Module,Switch to a different module.'
    qbf-lang[17] = 'Info,Information on current settings.'
    qbf-lang[18] = 'User,Transfer to a customized option.'
    qbf-lang[19] = 'Exit,Exit.'
    qbf-lang[20] = ''. /* terminator */

RETURN.
