/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-s-eng.p - English language definitions for general system use */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/

/* l-edit.p,s-edit.p */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Insert'
    qbf-lang[ 2] = 'Are you sure you want to exit without saving changes?'
    qbf-lang[ 3] = 'Type the name of the file to merge'
    qbf-lang[ 4] = 'Type the search string'
    qbf-lang[ 5] = 'Choose Field to Insert'
    qbf-lang[ 6] = 'Press [' + KBLABEL("GO") + '] to save, ['
                 + KBLABEL("GET") + '] to add field, ['
                 + KBLABEL("END-ERROR") + '] to undo.'
    qbf-lang[ 7] = 'Search string not found.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-ask.p,s-where.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Equal'
    qbf-lang[ 2] = 'Not Equal'
    qbf-lang[ 3] = 'Less Than'
    qbf-lang[ 4] = 'Less or Equal'
    qbf-lang[ 5] = 'Greater Than'
    qbf-lang[ 6] = 'Greater or Equal'
    qbf-lang[ 7] = 'Begins'
    qbf-lang[ 8] = 'Contains'    /* must match [r.4.23] */
    qbf-lang[ 9] = 'Matches'

    qbf-lang[10] = 'Choose a Field'
    qbf-lang[11] = 'Expression'
    qbf-lang[12] = 'Enter a Value'
    qbf-lang[13] = 'Comparisons'

    qbf-lang[14] = 'At run-time, ask the user for a value.'
    qbf-lang[15] = 'Enter the question to ask at run-time:'

    qbf-lang[16] = 'Ask For' /* data-type */
    qbf-lang[17] = 'Value'

    qbf-lang[18] = 'Press [' + KBLABEL("END-ERROR") + '] to exit.'
    qbf-lang[19] = 'Press [' + KBLABEL("END-ERROR") + '] to undo last step.'
    qbf-lang[20] = 'Press [' + KBLABEL("GET") + '] for Expert Mode.'

    qbf-lang[21] = 'Select the type of comparison to perform on the field.'

    qbf-lang[22] = 'Enter the ~{1~} value to compare with "~{2~}".'
    qbf-lang[23] = 'Please enter the ~{1~} value for "~{2~}".'
    qbf-lang[24] = 'Press [' + KBLABEL("PUT")
                 + '] to prompt for a value at run-time.'
    qbf-lang[25] = 'Context: ~{1~} is ~{2~} some ~{3~} value.'

    qbf-lang[27] = 'Sorry, but "Expert Mode" is not compatible with "ask for '
                 + 'a value at run-time".  You can use one or the other.'
    qbf-lang[28] = 'Must not be unknown value!'
    qbf-lang[29] = 'Enter more values for' /* '?' append to string */
    qbf-lang[30] = 'Enter more selection criteria?'
    qbf-lang[31] = 'Combine with previous criteria using?'
    qbf-lang[32] = 'Expert Mode'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
/* s-info.p, s-format.p */
    qbf-lang[ 1] = 'Order By'  /* s-info.p automatically right-justifies */
    qbf-lang[ 2] = 'and By'    /*   1..9 and adds colons for you. */
    qbf-lang[ 3] = 'File'      /* but must fit in format x(24) */
    qbf-lang[ 4] = 'Relation'
    qbf-lang[ 5] = 'Where'
    qbf-lang[ 6] = 'Field'
    qbf-lang[ 7] = 'Expression'
    qbf-lang[ 9] = 'Hide Repeating Values?'

    qbf-lang[10] = 'FROM,BY,FOR'
    qbf-lang[11] = 'You have not yet selected any files!'
    qbf-lang[12] = 'Formats and Labels'
    qbf-lang[13] = 'Formats'
    qbf-lang[14] = 'Choose a Field' /* also used by s-calc.p below */
    /* 15..18 must be format x(16) (see notes on 1..7) */
    qbf-lang[15] = 'Label'
    qbf-lang[16] = 'Format'
    qbf-lang[17] = 'Database'
    qbf-lang[18] = 'Type'
    qbf-lang[19] = 'Elapsed time of last Run,minutes:seconds'
    qbf-lang[20] = 'Expression cannot be unknown value (?)'

/*s-calc.p*/ /* there are many more for s-calc.p, see qbf-s = 5 thru 8 */
/*s-calc.p also uses #14 */
    qbf-lang[27] = 'Expression Builder'
    qbf-lang[28] = 'Expression'
    qbf-lang[29] = 'Continue adding to this expression?'
    qbf-lang[30] = 'Select Operation'
    qbf-lang[31] = 'today''s date'
    qbf-lang[32] = 'constant value'.

ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 4 THEN
  ASSIGN
/*s-help.p*/
    qbf-lang[ 1] = 'Sorry, no help is yet available for this option.'
    qbf-lang[ 2] = 'Help'

/*s-order.p*/
    qbf-lang[15] = 'asc/desc' /*neither can be over 8 characters */
    qbf-lang[16] = 'For each component, type "a" for'
    qbf-lang[17] = 'ascending or "d" for descending.'

/*s-define.p*/
    qbf-lang[21] = 'W. Width/Format of Fields'
    qbf-lang[22] = 'F. Fields'
    qbf-lang[23] = 'A. Active Files'
    qbf-lang[24] = 'T. Totals and Subtotals'
    qbf-lang[25] = 'R. Running Total'
    qbf-lang[26] = 'P. Percent of Total'
    qbf-lang[27] = 'C. Counters'
    qbf-lang[28] = 'M. Math Expressions'
    qbf-lang[29] = 'S. String Expressions'
    qbf-lang[30] = 'N. Numeric Expressions'
    qbf-lang[31] = 'D. Date Expressions'
    qbf-lang[32] = 'L. Logical Expressions'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - string expressions */
IF qbf-s = 5 THEN
  ASSIGN
    qbf-lang[ 1] = 's,Constant or Field,s00=s24,~{1~}'
    qbf-lang[ 2] = 's,Substring,s00=s25n26n27,SUBSTRING(~{1~}'
                 + ';INTEGER(~{2~});INTEGER(~{3~}))'
    qbf-lang[ 3] = 's,Combine Two Strings,s00=s28s29,~{1~} + ~{2~}'
    qbf-lang[ 4] = 's,Combine Three Strings,s00=s28s29s29,'
                 + '~{1~} + ~{2~} + ~{3~}'
    qbf-lang[ 5] = 's,Combine Four Strings,s00=s28s29s29s29,'
                 + '~{1~} + ~{2~} + ~{3~} + ~{4~}'
    qbf-lang[ 6] = 's,Lesser of Two Strings,s00=s30s31,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 's,Greater of Two Strings,s00=s30s31,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 8] = 's,Length of String,n00=s32,LENGTH(~{1~})'
    qbf-lang[ 9] = 's,User ID,s00=,USERID("RESULTSDB")'
    qbf-lang[10] = 's,Current Time,s00=,STRING(TIME;"HH:MM:SS")'

    qbf-lang[24] = 'Enter the field name to include as a column in your '
                 + 'report, or select <<constant value>> to insert a constant '
                 + 'string value into the report.'
    qbf-lang[25] = 'SUBSTRING allows you to extract a portion of a character '
                 + 'string for display.  Select a field name.'
    qbf-lang[26] = 'Enter the starting character position'
    qbf-lang[27] = 'Enter the number of characters to extract'
    qbf-lang[28] = 'Select the first value'
    qbf-lang[29] = 'Select the next value'
    qbf-lang[30] = 'Select the first entry to compare'
    qbf-lang[31] = 'Select the second entry to compare'
    qbf-lang[32] = 'The number returned corresponds to the length of the '
                 + 'selected string.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - numeric expressions */
IF qbf-s = 6 THEN
  ASSIGN
    qbf-lang[ 1] = 'n,Constant or Field,n00=n26,~{1~}'
    qbf-lang[ 2] = 'n,Smaller of Two Numbers,n00=n24n25,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 3] = 'n,Greater of Two Numbers,n00=n24n25,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 4] = 'n,Remainder,n00=n31n32,~{1~} MODULO ~{2~}'
    qbf-lang[ 5] = 'n,Absolute Value,n00=n27,'
                 + '(IF ~{1~} < 0 THEN - ~{1~} ELSE ~{1~})'
    qbf-lang[ 6] = 'n,Round,n00=n28,ROUND(~{1~};0)'
    qbf-lang[ 7] = 'n,Truncate,n00=n29,TRUNCATE(~{1~};0)'
    qbf-lang[ 8] = 'n,Square Root,n00=n30,SQRT(~{1~})'
    qbf-lang[ 9] = 'n,Display as Time,s00=n23,STRING(INTEGER(~{1~});"HH:MM:SS")'

    qbf-lang[23] = 'Select a field to be displayed as HH:MM:SS'
    qbf-lang[24] = 'Select the first entry to compare'
    qbf-lang[25] = 'Select the second entry to compare'
    qbf-lang[26] = 'Enter the field name to include as a column in your '
                 + 'report, or select <<constant value>> to insert a constant '
                 + 'numeric value into the report.'
    qbf-lang[27] = 'Select a field to be displayed as an absolute (unsigned) '
                 + 'value.'
    qbf-lang[28] = 'Select a field to be rounded to the nearest whole number.'
    qbf-lang[29] = 'Select a field to be rounded down (fractional part '
                 + 'removed).'
    qbf-lang[30] = 'Select a field to be square-rooted.'
    qbf-lang[31] = 'After dividing a number by a quotient, this is the '
                 + 'remainder.  What value do you want the remainer of?'
    qbf-lang[32] = 'Divided by what?'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - date expressions */
IF qbf-s = 7 THEN
  ASSIGN
    qbf-lang[ 1] = 'd,Current Date,d00=,TODAY'
    qbf-lang[ 2] = 'd,Add Days to Date Value,d00=d22n23,~{1~} + ~{2~}'
    qbf-lang[ 3] = 'd,Subtract Days from Date Value,d00=d22n24,~{1~} - ~{2~}'
    qbf-lang[ 4] = 'd,Difference between Two Dates,n00=d25d26,~{1~} - ~{2~}'
    qbf-lang[ 5] = 'd,Earlier of Two Dates,d00=d20d21,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 6] = 'd,Later of Two Dates,d00=d20d21,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 'd,Day of Month,n00=d27,DAY(~{1~})'
    qbf-lang[ 8] = 'd,Month of Year,n00=d28,MONTH(~{1~})'
    qbf-lang[ 9] = 'd,Name of Month,s00=d29,ENTRY(MONTH(~{1~});"January'
                 + ';February;March;April;May;June;July;August;September'
                 + ';October;November;December")'
    qbf-lang[10] = 'd,Year Value,n00=d30,YEAR(~{1~})'
    qbf-lang[11] = 'd,Day of Week,n00=d31,WEEKDAY(~{1~})'
    qbf-lang[12] = 'd,Name of Weekday,s00=d32,ENTRY(WEEKDAY(~{1~});"'
                 + 'Sunday;Monday;Tuesday;Wednesday;Thursday;Friday;Saturday")'

    qbf-lang[20] = 'Select the first entry to compare'
    qbf-lang[21] = 'Select the second entry to compare'
    qbf-lang[22] = 'Select a date field.'
    qbf-lang[23] = 'Select a field that contains the number of days to be '
                 + 'added to this date.'
    qbf-lang[24] = 'Select a field that contains the number of days to be '
                 + 'subtracted from this date.'
    qbf-lang[25] = 'Compare two date values and display the difference '
                 + 'between the two, in days, as a column.  Choose the '
                 + 'first field.'
    qbf-lang[26] = 'Now choose the second date field.'
    qbf-lang[27] = 'This returns the day of the month as a number from '
                 + '1 to 31.'
    qbf-lang[28] = 'This returns the month of the year as a number from '
                 + '1 to 12.'
    qbf-lang[29] = 'This returns the name of the month.'
    qbf-lang[30] = 'This returns the year portion of the date as an integer.'
    qbf-lang[31] = 'This returns a number for the weekday, with Sunday being 1.'
    qbf-lang[32] = 'This returns the name of the day of the week.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - mathematical expressions */
IF qbf-s = 8 THEN
  ASSIGN
    qbf-lang[ 1] = 'm,Add,n00=n25n26m...,~{1~} + ~{2~}'
    qbf-lang[ 2] = 'm,Subtract,n00=n25n27m...,~{1~} - ~{2~}'
    qbf-lang[ 3] = 'm,Multiply,n00=n28n29m...,~{1~} * ~{2~}'
    qbf-lang[ 4] = 'm,Divide,n00=n30n31m...,~{1~} / ~{2~}'
    qbf-lang[ 5] = 'm,Raise to a Power,n00=n25n32m...,EXP(~{1~};~{2~})'

    qbf-lang[25] = 'Enter first number'
    qbf-lang[26] = 'Enter next number to add'
    qbf-lang[27] = 'Enter next number to substract'
    qbf-lang[28] = 'Enter first multiplier'
    qbf-lang[29] = 'Enter next multiplier'
    qbf-lang[30] = 'Enter quotient'
    qbf-lang[31] = 'Enter divisor'
    qbf-lang[32] = 'Enter power'.

/*--------------------------------------------------------------------------*/

RETURN.
