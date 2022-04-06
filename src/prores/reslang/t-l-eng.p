/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-l-eng.p - English language definitions for Labels module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* l-guess.p:1..5,l-verify.p:6.. */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Searching "~{1~}" for "~{2~}" field...'
    qbf-lang[ 2] = 'No fields could be found using the automatic search.'
    qbf-lang[ 4] = 'Setting up label fields'
    qbf-lang[ 5] = 'name,address #1,address #2,address #3,city,'
                 + 'state,zip+4,zip,city-state-zip,country'

    qbf-lang[ 6] = 'Line ~{1~}: Unbalanced or missing brace.'
    qbf-lang[ 7] = 'Line ~{2~}: Unable to find field "~{1~}".'
    qbf-lang[ 8] = 'Line ~{2~}: Field "~{1~}", not an array field.'
    qbf-lang[ 9] = 'Line ~{2~}: Field "~{1~}", extent ~{3~} out of range.'
    qbf-lang[10] = 'Line ~{2~}: Field "~{1~}", from unselected file.'.

ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    /* each entry of 1 and also 2 must fit in format x(6) */
    qbf-lang[ 1] = 'Files:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Order:'
    qbf-lang[ 3] = 'Label Info'
    qbf-lang[ 4] = 'Label Layout'
    qbf-lang[ 5] = 'Choose a Field'
    /*cannot change length of 6 thru 17, right-justify 6-11,13-14 */
    qbf-lang[ 6] = 'Omit Blank Lines:'
    qbf-lang[ 7] = '  Copies of Each:'
    qbf-lang[ 8] = '  Total Height:'
    qbf-lang[ 9] = '    Top Margin:'
    qbf-lang[10] = ' Text to Text Spacing:'
    qbf-lang[11] = '   Left Margin Indent:'
    qbf-lang[12] = '(width)'
    qbf-lang[13] = '   Label Text'
    qbf-lang[14] = '   and Fields'
    qbf-lang[15] = 'Number of         ' /* 15..17 used as group.   */
    qbf-lang[16] = 'Labels            ' /*   do not change length, */
    qbf-lang[17] = 'Across:      ' /*        but do right-justify  */
    qbf-lang[19] = 'You did not clear the current label.  '
                 + 'Do you still want to continue?'
    qbf-lang[20] = 'Your label height is ~{1~}, but you have ~{2~} lines '
                 + 'defined.  Some information will not fit on the label size '
                 + 'you have defined, and therefore will not be printed.  '
                 + 'Do you still want to continue and print these labels?'
    qbf-lang[21] = 'There is no label text or fields to print!'
    qbf-lang[22] = 'Generating labels program...'
    qbf-lang[23] = 'Compiling labels program...'
    qbf-lang[24] = 'Running generated program...'
    qbf-lang[25] = 'Could not write to file or device'
    qbf-lang[26] = '~{1~} labels printed.'
    qbf-lang[27] = 'F. Fields'
    qbf-lang[28] = 'A. Active Files'
    qbf-lang[29] = 'Should this program try to select the fields for the '
                 + 'labels automatically?'
    qbf-lang[31] = 'Are you sure that you want to clear these settings?'
    qbf-lang[32] = 'Are you sure you want to exit this module?'.

ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'If more than one label across, text spacing must be > 0'
    qbf-lang[ 2] = 'Top margin cannot be negative'
    qbf-lang[ 3] = 'Total height must be greater than one'
    qbf-lang[ 4] = 'Number of labels across must be at least one'
    qbf-lang[ 5] = 'Number of copies must be at least one'
    qbf-lang[ 6] = 'Left margin cannot be negative'
    qbf-lang[ 7] = 'Text spacing must be greater than one'
    qbf-lang[ 8] = 'Shift lower lines up when line is blank'
    qbf-lang[ 9] = 'Number of lines from the top of label to first line of print'
    qbf-lang[10] = 'Total height of label measured in lines'
    qbf-lang[11] = 'Number of labels across'
    qbf-lang[12] = 'Number of copies of each label'
    qbf-lang[13] = 'Number of spaces from edge of label to first print position'
    qbf-lang[14] = 'Distance from left edge of one label to edge of next'.

/*--------------------------------------------------------------------------*/

RETURN.
