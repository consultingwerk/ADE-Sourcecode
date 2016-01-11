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
/* t-b-eng.p - English language definitions for Build subsystem */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

message qbf-s 
view-as alert-box error buttons Ok.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* b-build.p,b-again.p */
IF qbf-s = 1 THEN
  ASSIGN
                /* formats: x(10) x(45) x(8) */
    qbf-lang[ 1] = 'Program,Database and File,Time'
    qbf-lang[ 2] = 'Checkpoint file is corrupt.  Remove .qc file and restart '
                 + 'build from beginning.'
    qbf-lang[ 3] = 'Working on'     /*format x(15)*/
    qbf-lang[ 4] = 'Compiling'      /*format x(15)*/
    qbf-lang[ 5] = 'Re-Compiling'   /*format x(15)*/
    qbf-lang[ 6] = 'Working on file,Working on form,Working on program'
    qbf-lang[ 7] = 'All marked forms will be built.  Use ['
                 + KBLABEL("RETURN") + '] to mark/unmark.'
    qbf-lang[ 8] = 'Press [' + KBLABEL("GO") + '] when done, or ['
                 + KBLABEL("END-ERROR") + '] to quit.'
    qbf-lang[ 9] = 'Scanning files to build initial list of query forms...'
    qbf-lang[10] = 'Are you done defining query forms?'
    qbf-lang[11] = 'Finding implied OF-relations.'
    qbf-lang[12] = 'Processing list of relations.'
    qbf-lang[13] = 'Not all joins could be located.'
    qbf-lang[14] = 'Eliminating redundant relation information.'
    qbf-lang[15] = 'Are you sure that you want to exit?'
    qbf-lang[16] = 'Elapsed time,Average time'
    qbf-lang[17] = 'Reading checkpoint file...'
    qbf-lang[18] = 'Writing checkpoint file...'
    qbf-lang[19] = 'already exists.  Instead using'
    qbf-lang[20] = 'rebuilding file'
    qbf-lang[21] = 'Scanning form "~{1~}" for changes.'
    qbf-lang[22] = 'Cannot build query form unless ROWID or UNIQUE INDEX '
                 + 'available.'
    qbf-lang[23] = 'Form unchanged.'
    qbf-lang[24] = 'does not need recompiling.'
    qbf-lang[25] = 'No fields left on form.  Query form not being generated.'
    qbf-lang[26] = 'No fields left on form.  Existing query form deleted.'
    qbf-lang[27] = 'Packing viewable file listing.'
    qbf-lang[28] = 'Elapsed time'
    qbf-lang[29] = 'Done!'
    qbf-lang[30] = 'Compile of "~{1~}" failed.'
    qbf-lang[31] = 'Writing config file'
    qbf-lang[32] = 'Errors were found during the build and/or compile stages.'
                 + '^^Press a key to see the query log file.  Lines '
                 + 'containing errors will be highlighted.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN

/* b-misc.p */
    /* 1..10 for qbf-l-auto[] */
    qbf-lang[ 1] = 'name,*name*,contact,*contact*'
    qbf-lang[ 2] = '*street,*addr,*address,*address*1'
    qbf-lang[ 3] = '*po*box*,*address*2'
    qbf-lang[ 4] = '*address*3'
    qbf-lang[ 5] = 'city,*city*'
    qbf-lang[ 6] = 'st,state,*state*'
    qbf-lang[ 7] = 'zip,*zip*'
    qbf-lang[ 8] = 'zip*4,postal*'
    qbf-lang[ 9] = '*csz*,*city*st*z*'
    qbf-lang[10] = '*country*'

    qbf-lang[15] = 'Sample Export'.

/*--------------------------------------------------------------------------*/

RETURN.
