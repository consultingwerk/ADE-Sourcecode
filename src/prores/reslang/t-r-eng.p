/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-r-eng.p - English language definitions for Reports module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
/*r-header.p*/
    qbf-lang[ 1] = 'Enter expressions for the'
    qbf-lang[ 2] = 'Line' /* must be < 8 characters */
                   /* 3..7 are format x(64) */
    qbf-lang[ 3] = 'These functions are available for use in header and '
                 + 'footer text'
    qbf-lang[ 4] = '~{COUNT~}  Records listed so far  :  '
                 + '~{TIME~}  Time report started'
    qbf-lang[ 5] = '~{TODAY~}  Today''s date           :  '
                 + '~{NOW~}   Current time'
    qbf-lang[ 6] = '~{PAGE~}   Current page number    :  '
                 + '~{USER~}  User running report'
    qbf-lang[ 7] = '~{VALUE <expression>~;<format>~} to insert variables'
                 + ' ([' + KBLABEL("GET") + '] key)'
    qbf-lang[ 8] = 'Choose Field to Insert'
    qbf-lang[ 9] = 'Press [' + KBLABEL("GO") + '] to save, ['
                 + KBLABEL("GET") + '] to add field, ['
                 + KBLABEL("END-ERROR") + '] to undo.'

/*r-total.p*/    /*"|---------------------------|"*/
    qbf-lang[12] = 'Perform these actions:'
                 /*"|--------------------------------------------|"*/
    qbf-lang[13] = 'When these fields change value:'
                 /*"|---| |---| |---| |---| |---|" */
    qbf-lang[14] = 'Total Count -Min- -Max- -Avg-'
    qbf-lang[15] = 'Summary Line'
    qbf-lang[16] = 'For field:'
    qbf-lang[17] = 'Choose Field to Total'

/*r-calc.p*/
    qbf-lang[18] = 'Select Column for Running Totals'
    qbf-lang[19] = 'Select Column for Percent of Total'
    qbf-lang[20] = 'Running Total'
    qbf-lang[21] = '% Total'
    qbf-lang[22] = 'String,Date,Logical,Math,Numeric'
    qbf-lang[23] = 'Value'
    qbf-lang[24] = 'Enter starting number for counter'
    qbf-lang[25] = 'Enter increment, or a negative number to subtract'
    qbf-lang[26] = 'Counters'
    qbf-lang[27] = 'Counter'
                 /*"------------------------------|"*/
    qbf-lang[28] = '    Starting number for counter' /*right justify*/
    qbf-lang[29] = '           For each record, add' /*right justify*/
    qbf-lang[32] = 'You already have the maximum number of columns defined.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN
/* r-space.p */  /*"------------------------------|  ---------|  |------"*/
    qbf-lang[ 1] = '             Option                 Current  Default'
    /* 2..8 must be less than 32 characters long */
    qbf-lang[ 2] = 'Left margin'
    qbf-lang[ 3] = 'Spaces between columns'
    qbf-lang[ 4] = 'Starting line'
    qbf-lang[ 5] = 'Lines per page'
    qbf-lang[ 6] = 'Line spacing'
    qbf-lang[ 7] = 'Lines between header and body'
    qbf-lang[ 8] = 'Lines between body and footer'
                  /*1234567890123456789012345678901*/
    qbf-lang[ 9] = 'Spacing'
    qbf-lang[10] = 'Line spacing must be between one and the page size'
    qbf-lang[11] = 'No negative page lengths, please'
    qbf-lang[12] = 'The left-most the report can go is to column 1'
    qbf-lang[13] = 'Please keep this value reasonable'
    qbf-lang[14] = 'The top-most the report can go is to line 1'

/*r-set.p*/        /* format x(30) for 15..22 */
    qbf-lang[15] = 'F.  Formats and Labels'
    qbf-lang[16] = 'P.  Page Ejects'
    qbf-lang[17] = 'T.  Totals Only Report'
    qbf-lang[18] = 'S.  Spacing'
    qbf-lang[19] = 'LH. Left   Header'
    qbf-lang[20] = 'CH. Center Header'
    qbf-lang[21] = 'RH. Right  Header'
    qbf-lang[22] = 'LF. Left   Footer'
    qbf-lang[23] = 'CF. Center Footer'
    qbf-lang[24] = 'RF. Right  Footer'
    qbf-lang[25] = 'FO. First-page-only Header'
    qbf-lang[26] = 'LO. Last-page-only  Footer'
    qbf-lang[32] = 'Press [' + KBLABEL("END-ERROR")
                 + '] when done making changes.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
    /* r-main.p,s-page.p */
    qbf-lang[ 1] = 'Files:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Order:'
    qbf-lang[ 3] = 'Report Info'
    qbf-lang[ 4] = 'Report Layout'
    qbf-lang[ 5] = 'more' /* for <<more and more>> */
    qbf-lang[ 6] = 'Report,Width' /* each word comma-separated */
    qbf-lang[ 7] = 'Use < and > to scroll report left and right'
    qbf-lang[ 8] = 'Sorry, cannot generate report with width of more than '
                 + '255 characters'
    qbf-lang[ 9] = 'You did not clear the current report.  Do you still want '
                 + 'to continue?'
    qbf-lang[10] = 'Generating program...'
    qbf-lang[11] = 'Compiling generated program...'
    qbf-lang[12] = 'Running generated program...'
    qbf-lang[13] = 'Could not write to file or device'
    qbf-lang[14] = 'Are you sure you want to clear the current report '
                 + 'definition?'
    qbf-lang[15] = 'Are you sure you want to exit this module?'
    qbf-lang[16] = 'Press ['
                 + (IF KBLABEL("CURSOR-UP") BEGINS "CTRL-" THEN 'CURSOR-UP'
                   ELSE KBLABEL("CURSOR-UP"))
                 + '] and ['
                 + (IF KBLABEL("CURSOR-DOWN") BEGINS "CTRL-" THEN 'CURSOR-DOWN'
                   ELSE KBLABEL("CURSOR-DOWN"))
                 + '] to navigate, ['
                 + KBLABEL("END-ERROR") + '] when done.'
    qbf-lang[17] = 'Page'
    qbf-lang[18] = '~{1~} records included in report.'
    qbf-lang[19] = 'Sorry, cannot generate a Totals Only report when no '
                 + 'order-by fields are defined.'
    qbf-lang[20] = 'Sorry, cannot generate a Totals Only report with '
                 + 'stacked-array fields defined.'
    qbf-lang[21] = 'Totals Only'
    qbf-lang[23] = 'Sorry, cannot generate a report with no fields defined.'.

ELSE

/*--------------------------------------------------------------------------*/
/* FAST TRACK interface test for r-ft.p r-ftsub.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = 'FAST TRACK does not support output to terminal when'
    qbf-lang[ 2] = 'prompting for selection data.  Output changed to PRINTER.'
    qbf-lang[ 3] = 'Analyzing headers and footers...'
    qbf-lang[ 4] = 'Creating break-groups...'
    qbf-lang[ 5] = 'Creating fields and aggregates...'
    qbf-lang[ 6] = 'Creating files and WHERE clauses...'
    qbf-lang[ 7] = 'Creating headers and footers...'
    qbf-lang[ 8] = 'Creating report-rows...'
    qbf-lang[ 9] = 'There is already a report named ~{1~} in FAST TRACK.  Do '
                 + 'you want to overwrite it?'
    qbf-lang[10] = 'Overwriting report...'
    qbf-lang[11] = 'Do you want to start FAST TRACK?'
    qbf-lang[12] = 'Enter a name'
    qbf-lang[13] = 'FAST TRACK does not support TIME in header/footer, '
                 + 'replaced by NOW.'
    qbf-lang[14] = 'FAST TRACK does not support percent of total, field skipped'
    qbf-lang[15] = 'FAST TRACK does not support ~{1~} in header/footer, '
                 + '~{2~} skipped.'
    qbf-lang[16] = 'Report name can only include alphanumeric characters '
                 + 'or under-score.'
    qbf-lang[17] = 'Report name in FAST TRACK:'
    qbf-lang[18] = 'Report not transferred to FAST TRACK'
    qbf-lang[19] = 'Starting FAST TRACK, please wait...'
    qbf-lang[20] = 'Unmatched curly braces in header/footer, '
                 + 'report NOT transferred.'
    qbf-lang[21] = 'FAST TRACK does not support first-only/last-only headers.'
                 + '  Ignored.'
    qbf-lang[22] = 'Warning: Starting number ~{1~} used for counter.'
    qbf-lang[23] = 'CONTAINS'
    qbf-lang[24] = 'TOTAL,COUNT,MAX,MIN,AVG'
    qbf-lang[25] = 'FAST TRACK does not support Totals Only reports.  '
                 + 'Report could not be transferred.'
    qbf-lang[26] = 'Cannot transfer a report to FAST TRACK when no files or '
                 + 'fields defined.'.


ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 5 THEN
  ASSIGN
    /* r-short.p */
    qbf-lang[ 1] = 'Defining a Totals Only report "collapses" the report '
                 + 'to show only summary information.  Based on the '
                 + 'last field in your "Order" list, a new line '
                 + 'will appear each time that order field value '
                 + 'changes.^For this report, a new line will appear '
                 + 'each time the ~{1~} field changes.^Make this '
                 + 'a Totals Only report?'
    qbf-lang[ 2] = 'ENABLE'
    qbf-lang[ 3] = 'DISABLE'
    qbf-lang[ 4] = 'Sorry, you cannot use the "Totals Only" option until '
                 + 'you choose the "Order" fields for sorting your report.^^'
                 + 'Please select these order fields using the "Order" '
                 + 'option from the main Report menu, and then try this '
                 + 'option again.'
    qbf-lang[ 5] = 'This list shows all the fields you currently have '
                 + 'defined for'
    qbf-lang[ 6] = 'this report.  Those marked with an asterisk will be '
                 + 'summarized.'
    qbf-lang[ 7] = 'If you select a numeric field to summarize, a subtotal '
                 + 'for that field will appear each time the ~{1~} field '
                 + 'value changes.'
    qbf-lang[ 8] = 'If you select a nonnumeric field, a count showing the '
                 + 'number of records in each ~{1~} group will appear.'
    qbf-lang[ 9] = 'If you do not choose to summarize a field, then the value '
                 + 'contained in the last record in the group will appear.'

    /* r-page.p */
    qbf-lang[26] = 'Page Ejects'
    qbf-lang[27] = "don't page eject"

    qbf-lang[28] = 'When a value in one of the following'
    qbf-lang[29] = 'fields changes, the report can'
    qbf-lang[30] = 'automatically go on to a new page.'
    qbf-lang[31] = 'Pick the field from the list below'
    qbf-lang[32] = 'where you want this to occur.'.

/*--------------------------------------------------------------------------*/

RETURN.
