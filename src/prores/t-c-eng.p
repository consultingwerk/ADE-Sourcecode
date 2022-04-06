/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-c-eng.p - English language definitions for Scrolling Lists */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*
As of [Thu Apr 25 15:13:33 EDT 1991], this
is a list of the scrolling list programs:
  u-browse.i     c-print.p
  b-pick.p       i-pick.p
  c-entry.p      i-zap.p
  c-field.p      s-field.p
  c-file.p       u-pick.p
  c-flag.p       u-print.p
  c-form.p
*/

/* c-entry.p,c-field.p,c-file.p,c-form.p,c-print.p,c-vector.p,s-field.p */
ASSIGN
  qbf-lang[ 1] = 'Select file to join or press ['
               + KBLABEL("END-ERROR") + '] to exit.'
  qbf-lang[ 2] = 'Press [' + KBLABEL("GO") + '] when done, ['
               + KBLABEL("INSERT-MODE") + '] to toggle, ['
               + KBLABEL("END-ERROR") + '] to exit.'
  qbf-lang[ 3] = 'Press [' + KBLABEL("END-ERROR")
               + '] to stop selecting files.'
  qbf-lang[ 4] = 'Press [' + KBLABEL("GO") + '] when done, ['
               + KBLABEL("INSERT-MODE")
               + '] to toggle desc/file/program.'
  qbf-lang[ 5] = 'Label/Name-'
  qbf-lang[ 6] = 'Desc/Name'
  qbf-lang[ 7] = 'File,Prog,Desc'
  qbf-lang[ 8] = 'Looking up available fields...'
  qbf-lang[ 9] = 'Choose Fields'
  qbf-lang[10] = 'Select File'
  qbf-lang[11] = 'Select Related File'
  qbf-lang[12] = 'Select Query Form'
  qbf-lang[13] = 'Select Output Device'
  qbf-lang[14] = 'Join' /* should match t-q-eng.p "Join" string */
  qbf-lang[16] = '        Database' /* max length 16 */
  qbf-lang[17] = '            File' /* max length 16 */
  qbf-lang[18] = '           Field' /* max length 16 */
  qbf-lang[19] = '  Maximum Extent' /* max length 16 */
  qbf-lang[20] = 'The value'
  qbf-lang[21] = 'is outside the range 1 to'
  qbf-lang[22] = 'Append to existing file?'
  qbf-lang[23] = 'Cannot use this option with specified output destination'
  qbf-lang[24] = 'Enter output filename'

               /* 12345678901234567890123456789012345678901234567890 */
  qbf-lang[27] = 'Leave blank for stacked array elements, or enter a'
  qbf-lang[28] = 'comma-separated list of individual array elements'
  qbf-lang[29] = 'to include side-by-side in the report.'
  qbf-lang[30] = 'Enter a comma-separated list of individual array'
  qbf-lang[31] = 'elements to include side-by-side as fields.'
  qbf-lang[32] = 'Enter the subscript of the array element to use.'.

RETURN.
