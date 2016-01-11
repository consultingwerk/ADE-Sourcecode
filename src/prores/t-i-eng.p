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
/* t-i-eng.p - English language definitions for Directory */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*i-dir.p,i-pick.p,i-zap.p,a-info.p,i-read.p*/
ASSIGN
  qbf-lang[ 1] = 'export,graph,label,query,report'
  qbf-lang[ 2] = 'Enter description of'
  qbf-lang[ 3] = 'Some of the files and/or fields have been omitted because '
               + 'of one of the following reasons:^1) original databases not '
               + 'connected^2) database definition changes^3) insufficient '
               + 'permissions'
  qbf-lang[ 4] = 'Each ~{1~} must have a unique name.  Please try again.'
  qbf-lang[ 5] = 'You have saved too many entries.  Please delete some!  '
               + 'Deleting from any module directory will free up space.'
  qbf-lang[ 6] = 'Desc----,Database,Program-'
  qbf-lang[ 7] = 'Are you sure that you want to overwrite'
  qbf-lang[ 8] = 'with'
  qbf-lang[ 9] = 'Choose'
  qbf-lang[10] = 'an Export Format,a Graph,a Label,a Query,a Report'
  qbf-lang[11] = 'export format,graph,label,query,report'
  qbf-lang[12] = 'Export Formats,Graphs,Labels,Queries,Reports'
  qbf-lang[13] = 'Data Export Formats,Graphs,Label Formats,Queries,'
               + 'Report Definitions'
  qbf-lang[14] = 'to Load,to Save,to Delete'
  qbf-lang[15] = 'Working...'
  qbf-lang[16] = 'get ~{1~} from another directory'
  qbf-lang[17] = 'save as new ~{1~}'
  qbf-lang[18] = 'not available'
  qbf-lang[19] = 'All Marked objects will be deleted.  Use ['
               + KBLABEL('RETURN') + '] to mark/unmark.'
  qbf-lang[20] = 'Press [' + KBLABEL('GO') + '] when done, or ['
               + KBLABEL('END-ERROR') + '] to not delete anything.'
  qbf-lang[21] = 'Moving number ~{1~} to position ~{2~}.'
  qbf-lang[22] = 'Deleting number ~{1~}.'
  qbf-lang[23] = '[' + KBLABEL("GO") + '] to select, ['
               + KBLABEL("INSERT-MODE") + '] to toggle, ['
               + KBLABEL("END-ERROR") + '] to exit.'
  qbf-lang[24] = 'Writing out updated report directory...'
/*a-info.p only:*/ /* 25..29 use format x(64) */
  qbf-lang[25] = 'This program displays the contents of a specific'
  qbf-lang[26] = 'user''s local directory file, showing which generated'
  qbf-lang[27] = 'programs correspond to each defined report, export,'
  qbf-lang[28] = 'label, and so forth.'
  qbf-lang[29] = 'Enter the full path name of the user''s ".qd" file:'
  qbf-lang[30] = 'Cannot find indicated file.'
  qbf-lang[31] = 'You forgot the ".qd" extension.'
  qbf-lang[32] = 'Reading directory...'.

RETURN.
