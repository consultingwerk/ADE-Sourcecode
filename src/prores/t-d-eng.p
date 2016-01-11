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
/* t-d-eng.p - English language definitions for Data Export module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* d-edit.p,a-edit.p */
IF qbf-s = 1 THEN
/*
When entering codes, the following methods may be used:
  'x' - literal character enclosed in single quotes.
  ^x  - interpreted as control-character.
  ##h - one or two hex digits followed by the letter "h".
  ### - one, two or three digits, a decimal number.
  xxx - "xxx" is a symbol such as "lf" from the following table.
*/
  ASSIGN
    qbf-lang[ 1] = 'is a symbol such as'
    qbf-lang[ 2] = 'from the following table.'
    qbf-lang[ 3] = 'Press [' + KBLABEL("GET")
                 + '] to toggle Expert Mode on and off.'
    /* format x(70): */
    qbf-lang[ 4] = 'When entering codes, these methods may be used and mixed '
                 + 'freely:'
    /* format x(60): */
    qbf-lang[ 5] = 'literal character enclosed in single quotes.'
    qbf-lang[ 6] = 'interpreted as control-character.'
    qbf-lang[ 7] = 'one or two hex digits followed by the letter "h".'
    qbf-lang[ 8] = 'one, two or three digits, a decimal number.'
    qbf-lang[ 9] = 'is an unknown code.  Please correct.'
    qbf-lang[10] = 'Processing printer control definitions...'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Files:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Order:'
    qbf-lang[ 3] = 'Data Export Info'
    qbf-lang[ 4] = 'Data Export Layout'
    qbf-lang[ 5] = 'Fields:,      :,      :,      :,      :'
    qbf-lang[ 7] = '    Export Type:'
    qbf-lang[ 8] = 'Headers:'
    qbf-lang[ 9] = '   (export names as first record)'
    qbf-lang[10] = '   Record start:'
    qbf-lang[11] = '     Record end:'
    qbf-lang[12] = 'Field delimiter:'
    qbf-lang[13] = 'Field separator:'
    qbf-lang[14] = 'Data Export does not support the exporting of stacked '
                 + 'arrays.  If you continue, they will be eliminated from '
                 + 'the export.^Do you wish to continue?'
    qbf-lang[15] = 'Sorry, cannot export data with no fields defined.'
    qbf-lang[21] = 'You did not clear the current export format.  '
                 + 'Do you still want to continue?'
    qbf-lang[22] = 'Generating export program...'
    qbf-lang[23] = 'Compiling export program...'
    qbf-lang[24] = 'Running generated program...'
    qbf-lang[25] = 'Could not write to file or device'
    qbf-lang[26] = '~{1~} records exported.'
    qbf-lang[31] = 'Are you sure that you want to reset the export settings?'
    qbf-lang[32] = 'Are you sure you want to exit this module?'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
/* this set contains only export formats.  Each is composed of the */
/* internal RESULTS id and the description.  The description must  */
/* not contain a comma, and must fit within format x(32).          */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'PROGRESS,PROGRESS Export'
    qbf-lang[ 2] = 'ASCII   ,Generic ASCII'
    qbf-lang[ 3] = 'ASCII-H ,ASCII with Field-name header'
    qbf-lang[ 4] = 'FIXED   ,Fixed-width ASCII (SDF)'
    qbf-lang[ 5] = 'CSV     ,Comma-separated value (CSV)'
    qbf-lang[ 6] = 'DIF     ,DIF'
    qbf-lang[ 7] = 'SYLK    ,SYLK'
    qbf-lang[ 8] = 'WS      ,WordStar'
    qbf-lang[ 9] = 'WORD    ,Microsoft Word'
    qbf-lang[10] = 'WORD4WIN,Microsoft Word for Windows'
    qbf-lang[11] = 'WPERF   ,WordPerfect'
    qbf-lang[12] = 'OFISW   ,CTOS/BTOS OfisWriter'
    qbf-lang[13] = 'USER    ,User'
    qbf-lang[14] = '*'. /* terminator for list */

/*--------------------------------------------------------------------------*/

RETURN.
