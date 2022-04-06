/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-a-eng.p - English language definitions for Admin module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/*results.p,s-module.p*/
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Q. Query'
    qbf-lang[ 2] = 'R. Reports'
    qbf-lang[ 3] = 'L. Labels'
    qbf-lang[ 4] = 'D. Data Export'
    qbf-lang[ 5] = 'U. User'
    qbf-lang[ 6] = 'A. Administration'
    qbf-lang[ 7] = 'E. Exit'
    qbf-lang[ 8] = 'F. FAST TRACK'
    qbf-lang[10] = 'The file' /*DBNAME.qc*/
    qbf-lang[11] = 'was not found.  This means that you need to do an "Initial'
                 + ' Build" on this database.  Do you want to do this now?'
    qbf-lang[12] = 'Select new module or press [' + KBLABEL("END-ERROR")
                 + '] to stay in current module.'
/*    qbf-lang[13] = 'You have not purchased RESULTS.  Program terminated.' */
    qbf-lang[13] = 'A license for RESULTS is not available.  Program terminated.'
    qbf-lang[14] = 'Are you sure that you want to exit "~{1~}" now?'
    qbf-lang[15] = 'MANUAL,SEMI,AUTO'
    qbf-lang[16] = 'There are no databases connected.'
    qbf-lang[17] = 'Cannot execute when a database has a logical name '
                 + 'beginning with "QBF$".'
    qbf-lang[18] = 'Quit'
    qbf-lang[19] = '** RESULTS is confused **^^In the ~{1~} directory, '
                 + 'neither ~{2~}.db nor ~{2~}.qc could be found.  ~{3~}.qc '
                 + 'was found in the PROPATH, but it appears to belong to '
                 + '~{3~}.db.  Please fix your PROPATH or rename/delete '
                 + '~{3~}.db and .qc.'
    /* 24,26,30,32 available if necessary */
    qbf-lang[21] = '         There are three ways to build query forms for '
                 + 'PROGRESS'
    qbf-lang[22] = '         RESULTS.  At any time after RESULTS builds '
                 + 'query forms,'
    qbf-lang[23] = '         you can manually tailor them.'
    qbf-lang[25] = 'You want to manually define each query form.'
    qbf-lang[27] = 'After you pick a subset of files from the connected'
    qbf-lang[28] = 'databases, RESULTS generates query forms only for'
    qbf-lang[29] = 'the selected files.'
    qbf-lang[31] = 'RESULTS generates all query forms automatically.'
    qbf-lang[33] = "Your copy of the RESULTS is past it's experiration date."
    .

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-user.p*/
IF qbf-s = 2 THEN
  /* format x(72) for 1,2,9-14,19-22 */
  ASSIGN
    qbf-lang[ 1] = 'Enter the name of the include file to be used for the'
    qbf-lang[ 2] = 'Browse option in the Query module.'
    qbf-lang[ 3] = '   Default Include File:' /*format x(24)*/

    qbf-lang[ 8] = 'Cannot find program'

    qbf-lang[ 9] = 'Enter the name of the sign-on program.  This program can '
                 + 'be either'
    qbf-lang[10] = 'a simple logo, or a complete login procedure similar to '
                 + '"login.p"'
    qbf-lang[11] = 'in the "DLC" directory.  This program is executed as '
                 + 'soon as the'
    qbf-lang[12] = '"signon=" line is read from the DBNAME.qc file.'
    qbf-lang[13] = 'Enter the name of the product as you want it displayed'
    qbf-lang[14] = 'on the Main Menu.'
    qbf-lang[15] = '        Sign-on Program:' /*format x(24)*/
    qbf-lang[16] = '           Product Name:' /*format x(24)*/
    qbf-lang[17] = 'Defaults:'

    qbf-lang[18] = 'PROGRESS User Procedure:'
    qbf-lang[19] = 'This procedure runs when the "User" option is selected '
                 + 'from any menu.'

    qbf-lang[20] = 'This allows a user-designed data export program to be used.'
    qbf-lang[21] = 'Please enter both the procedure name and the description'
    qbf-lang[22] = 'for the "Data Export - Settings" menu.'
    qbf-lang[23] = 'Procedure:'
    qbf-lang[24] = 'Description:'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-load.p:*/
IF qbf-s = 3 THEN
  ASSIGN
    /* menu strip for d-main.p,l-main.p,r-main.p */
    qbf-lang[ 1] = 'Get,Load a previously defined ~{1~}.'
    qbf-lang[ 2] = 'Put,Save the current ~{1~}.'
    qbf-lang[ 3] = 'Run,Run the current ~{1~}.'
    qbf-lang[ 4] = 'Define,Select files and fields.'
    qbf-lang[ 5] = 'Settings,Change type, format or layout of current ~{1~}.'
    qbf-lang[ 6] = 'Where,WHERE clause editor selection of records.'
    qbf-lang[ 7] = 'Order,Change the output order for records.'
    qbf-lang[ 8] = 'Clear,Clear the currently defined ~{1~}.'
    qbf-lang[ 9] = 'Info,Information on current settings.'
    qbf-lang[10] = 'Module,Switch to a different module.'
    qbf-lang[11] = 'User,Transfer to a customized option.'
    qbf-lang[12] = 'Exit,Exit.'
    qbf-lang[13] = '' /* terminator */
    qbf-lang[14] = 'export,label,report'

    qbf-lang[15] = 'Reading configuration file...'

    /* system values for CONTINUE Must be <= 12 characters */
    qbf-lang[18] = '  Continue' /* for error dialog box */
    qbf-lang[19] = 'English' /* this name of this language */
    /* word "of" for "xxx of yyy" on scrolling lists */
    qbf-lang[20] = 'of'
    /* standard product name */
    qbf-lang[22] = 'PROGRESS RESULTS'
    /* system values for descriptions of calc fields */
    qbf-lang[23] = ',Running Total,Percent of Total,Count Func,String Expr,'
                 + 'Date Expr,Numeric Expr,Logical Expr,Stacked Array'
    /* system values for YES and NO.  Must be <= 8 characters each */
    qbf-lang[24] = '  Yes  ,  No  ' /* for yes/no dialog box */

    qbf-lang[25] = 'An automatic build was in progress and was interrupted.  '
                 + 'Continue with automatic build?'

    qbf-lang[26] = '* WARNING - Version mismatch *^^Current version is '
                 + '<~{1~}> while .qc file is for version <~{2~}>.  There '
                 + 'may be problems until Query forms are regenerated with '
                 + '"Application Rebuild".'

    qbf-lang[27] = '* WARNING - Missing Databases *^^The following '
                 + 'database(s) are needed but are not connected:'

    qbf-lang[32] = '* WARNING - Schema changed *^^The database structure has '
                 + 'been changed since some query forms have been built.  '
                 + 'Please use "Application Rebuild" from the Administration '
                 + 'menu as soon as possible.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-main.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = " A. Application Rebuild"
    qbf-lang[ 2] = " F. Form Definitions for Query"
    qbf-lang[ 3] = " R. Relations Between Files"

    qbf-lang[ 4] = " C. Contents of a User Directory"
    qbf-lang[ 5] = " H. How to Exit Application"
    qbf-lang[ 6] = " M. Module Permissions"
    qbf-lang[ 7] = " Q. Query Permissions"
    qbf-lang[ 8] = " S. Sign-on Program/Product Name"

    qbf-lang[11] = " G. Language"
    qbf-lang[12] = " P. Printer Setup"
    qbf-lang[13] = " T. Terminal Color Settings"

    qbf-lang[14] = " B. Browse Program for Query"
    qbf-lang[15] = " D. Default Report Settings"
    qbf-lang[16] = " E. User-Defined Export Format"
    qbf-lang[17] = " L. Label Field Selection"
    qbf-lang[18] = " U. User Option"

    qbf-lang[21] = 'Select an option or press [' + KBLABEL("END-ERROR")
                 + '] to exit and save changes.'
    /* these next four have a length limit of 20 including colon */
    qbf-lang[22] = 'Files:'
    qbf-lang[23] = 'Configuration:'
    qbf-lang[24] = 'Security:'
    qbf-lang[25] = 'Modules:'

    qbf-lang[26] = 'Administration'
    qbf-lang[27] = 'Version'
    qbf-lang[28] = 'Loading additional administration settings from '
                 + 'configuration file.'
    qbf-lang[29] = 'Are you sure you want to rebuild the application?'
/* QUIT and RETURN are the PROGRESS keywords and cannot be translated */
    qbf-lang[30] = 'When the user leaves the main menu, should this program '
                 + 'Quit or Return?'
    qbf-lang[31] = 'Are you sure that you want to leave the Administration '
                 + 'menu now?'
    qbf-lang[32] = 'Verifying configuration file structure and saving any '
                 + 'changes.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 5 THEN
  ASSIGN
/*a-perm.p, 1..7 also used by a-form.p and a-print.p*/
    qbf-lang[ 1] = 'Permissions'
    qbf-lang[ 2] = '    *                   - All users are allowed access.'
    qbf-lang[ 3] = '    <user>,<user>,etc.  - Only these users have access.'
    qbf-lang[ 4] = '    !<user>,!<user>,*   - All except these users have '
                 + 'access.'
    qbf-lang[ 5] = '    acct*               - Only users that begin with '
                 + '"acct" allowed'
    qbf-lang[ 6] = 'List users by their login IDs, and separate them with '
                 + 'commas.'
    qbf-lang[ 7] = 'IDs may contain wildcards.  Use exclamation marks to '
                 + 'exclude users.'
                   /* from 8 thru 13, format x(30) */
    qbf-lang[ 8] = 'Select a module from'
    qbf-lang[ 9] = 'the list at left to'
    qbf-lang[10] = 'set permissions for.'
    qbf-lang[11] = 'Select a function from'
    qbf-lang[12] = 'the list at left to'
    qbf-lang[13] = 'set permissions for.'
    qbf-lang[14] = 'Press [' + KBLABEL("END-ERROR")
                 + '] when done making changes.'
    qbf-lang[15] = 'Press [' + KBLABEL("GO") + '] to save, ['
                 + KBLABEL("END-ERROR") + '] to undo changes.'
    qbf-lang[16] = 'You cannot exclude yourself from Administration!'
/*a-print.p:*/     /*21 thru 26 must be format x(16) and right-justified */
    qbf-lang[21] = '  Initialization'
    qbf-lang[22] = '                '
    qbf-lang[23] = '    Normal Print'
    qbf-lang[24] = '      Compressed'
    qbf-lang[25] = '        Bold  ON'
    qbf-lang[26] = '        Bold OFF'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 6 THEN
  ASSIGN
/*a-write.p:*/
    qbf-lang[ 1] = 'Loading module settings'
    qbf-lang[ 2] = 'Loading color settings'
    qbf-lang[ 3] = 'Loading printer setup'
    qbf-lang[ 4] = 'Loading list of viewable files'
    qbf-lang[ 5] = 'Loading list of relations'
    qbf-lang[ 6] = 'Loading auto-select field list for mailing labels'
    qbf-lang[ 7] = 'Loading permissions list for query functions'
    qbf-lang[ 8] = 'Loading user option information'
    qbf-lang[ 9] = 'Loading system report defaults'

/* a-color.p*/
                 /* 12345678901234567890123456789012 */
    qbf-lang[11] = ' Colors for which terminal type:' /* must be 32 */
                 /* 1234567890123456789012345 */
    qbf-lang[12] = 'Menu:             Normal:' /* must be 25 */
    qbf-lang[13] = '               Highlight:'
    qbf-lang[14] = 'Dialog Box:       Normal:'
    qbf-lang[15] = '               Highlight:'
    qbf-lang[16] = 'Scrolling List:   Normal:'
    qbf-lang[17] = '               Highlight:'

/*a-field.p*/    /*"----- ----- ----- ----- ----"*/
    qbf-lang[30] = 'Disp? Upd?  Qry?  Brow?  Seq'
    qbf-lang[31] = 'Must be within the range 1 to 9999.'
    qbf-lang[32] = 'Do you want to save the changes you just made to the '
                 + 'field list?'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 8 THEN
/*a-label.p*/
  ASSIGN            /* 1..8 use format x(78) */
                    /* 1 and 8 are available for more explanation, in */
                    /*   case the translation won't fit in 2 thru 7.  */
    qbf-lang[ 2] = 'Enter the field names that hold the address information.  '
                 + 'Use CAN-DO'
    qbf-lang[ 3] = 'style lists for matching these field-names ("*" matches '
                 + 'any number of'
    qbf-lang[ 4] = 'characters, "." matches any one character).  This '
                 + 'information is used'
    qbf-lang[ 5] = 'for creating default mailing labels.  Note that some '
                 + 'entries may be'
    qbf-lang[ 6] = 'redundant - for example, if you always store city, state '
                 + 'and zip in'
    qbf-lang[ 7] = 'separate fields, you do not need to use the "C-S-Z" line.'
                  /* each entry in list must be <= 5 characters long */
                  /* but may be any portion of address that is applicable */
                  /* in the target country */
    qbf-lang[ 9] = 'Name,Addr1,Addr2,Addr3,City,State,Zip,Zip+4,C-S-Z,Cntry'
    qbf-lang[10] = 'Field containing <name>'
    qbf-lang[11] = 'Field containing <first> line of address (e.g. street)'
    qbf-lang[12] = 'Field containing <second> line of address (e.g. PO Box)'
    qbf-lang[13] = 'Field containing <third> line of address (optional)'
    qbf-lang[14] = 'Field containing name of <city>'
    qbf-lang[15] = 'Field containing name of <state>'
    qbf-lang[16] = 'Field containing <zip code> (5 or 9 digits)'
    qbf-lang[17] = 'Field containing <last four digits> of zip code'
    qbf-lang[18] = 'Field containing <combined city-state-zip>'
    qbf-lang[19] = 'Field containing <country>'

/*a-join.p*/
    qbf-lang[23] = 'Sorry, but at this time self-joins are not allowed.'
    qbf-lang[24] = 'Maximum number of join relationships has been reached.'
    qbf-lang[25] = 'Relation of' /* 25 and 26 are automatically */
    qbf-lang[26] = 'to'          /*   right-justified           */
    qbf-lang[27] = 'Enter WHERE or OF clause: (leave blank to remove relation)'
    qbf-lang[28] = 'Press [' + KBLABEL("END-ERROR") + '] when done updating.'
    qbf-lang[30] = 'The statement must begin with WHERE or OF.'
    qbf-lang[31] = 'Enter first file of relation to add or remove.'
    qbf-lang[32] = 'Now enter second file of relation.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-form.p */
IF qbf-s = 9 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' A. Add New Query Form '
    qbf-lang[ 2] = ' C. Choose Query Form to Edit '
    qbf-lang[ 3] = ' G. General Form Characteristics '
    qbf-lang[ 4] = ' W. Which Fields on Form '
    qbf-lang[ 5] = ' P. Permissions '
    qbf-lang[ 6] = ' D. Delete Current Query Form '
    qbf-lang[ 7] = ' Select: ' /* format x(10) */
    qbf-lang[ 8] = ' Update: ' /* format x(10) */
                 /* cannot changed width of 9..16 from defined below */
    qbf-lang[ 9] = '     Database file name' /* right-justify 9..14 */
    qbf-lang[10] = '              Form type'
    qbf-lang[11] = 'Query program file name'
    qbf-lang[12] = 'Form physical file name'
    qbf-lang[13] = 'Frame name for 4GL code'
    qbf-lang[14] = '            Description'
    qbf-lang[15] = '(.p assumed)     ' /* left-justify 15 and 16 */
    qbf-lang[16] = '(needs extension)'
    qbf-lang[18] = 'This form is ~{1~} lines long.  Since RESULTS reserves '
                 + 'five lines for its own use, this will exceed the screen '
                 + 'size of a 24x80 terminal.  Are you sure that you want to '
                 + 'define a form this large?'
    qbf-lang[19] = 'A query program already exists with that name.'
    qbf-lang[20] = 'This form must already exist, or must end in .f for '
                 + 'automatic generation.'
    qbf-lang[21] = 'The name you picked for the 4GL form is reserved.  '
                 + 'Choose another.'
    qbf-lang[22] = ' Choose Accessable Files '
    qbf-lang[23] = 'Press [' + KBLABEL("END-ERROR") + '] when done updating'
    qbf-lang[24] = 'Saving form information in query form cache...'
    qbf-lang[25] = 'You have changed at least one query form.  You can '
                 + 'either compile the changed form now, or do an '
                 + '"Application Rebuild" later.  Compile now?'
    qbf-lang[26] = 'No query form called "~{1~}" could be found.  Do you '
                 + 'want one to be generated?'
    qbf-lang[27] = 'A query form called "~{1~}" exists.  Use fields from '
                 + 'this form?'
    qbf-lang[28] = 'Are you sure that you want to delete query form'
    qbf-lang[29] = '** Query program "~{1~}" deleted. **'
    qbf-lang[30] = 'Writing out query form...'
    qbf-lang[31] = 'Maximum number of query forms has been reached.'
    qbf-lang[32] = 'Cannot build query form for this file.^^In order to '
                 + 'build a query form, either the gateway must support '
                 + 'RECIDs or there must be a unique index on the file.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-print.p */
IF qbf-s = 10 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' A. Add New Output Device '
    qbf-lang[ 2] = ' C. Choose Device To Edit '
    qbf-lang[ 3] = ' G. General Device Characteristics '
    qbf-lang[ 4] = ' S. Control Sequences  '
    qbf-lang[ 5] = ' P. Printer Permissions '
    qbf-lang[ 6] = ' D. Delete Current Device '
    qbf-lang[ 7] = ' Select: ' /* format x(10) */
    qbf-lang[ 8] = ' Update: ' /* format x(10) */
    qbf-lang[ 9] = 'Must be less than 256 but greater than 0'
    qbf-lang[10] = 'Type must be term, thru, to, view, file, page or prog'
    qbf-lang[11] = 'Maximum number of output devices has been reached.'
    qbf-lang[12] = 'Only device type "term" can output to TERMINAL.'
    qbf-lang[13] = 'Could not find that program name with current PROPATH.'
                  /*17 thru 20 must be format x(16) and right-justified */
    qbf-lang[17] = 'Desc for listing'
    qbf-lang[18] = '     Device name'
    qbf-lang[19] = '   Maximum Width'
    qbf-lang[20] = '            Type'
    qbf-lang[21] = 'see below'
    qbf-lang[22] = 'TERMINAL, as in OUTPUT TO TERMINAL PAGED'
    qbf-lang[23] = 'TO a device, such as OUTPUT TO PRINTER'
    qbf-lang[24] = 'THROUGH a UNIX or OS/2 spooler or filter'
    qbf-lang[25] = 'Send the report to a file, then execute this program'
    qbf-lang[26] = 'Ask the user for a filename for the output destination'
    qbf-lang[27] = 'To screen with prev-page and next-page support'
    qbf-lang[28] = 'Call a 4GL program to start/end output stream'
    qbf-lang[30] = 'Press [' + KBLABEL("END-ERROR") + '] when done updating'
    qbf-lang[31] = 'There must be at least one output device!'
    qbf-lang[32] = 'Are you sure that you want to delete this printer?'.

/*--------------------------------------------------------------------------*/

RETURN.
