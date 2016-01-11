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
 * This is an example a OUTPUT TO "printer" that requires an initial string to
 * set printer characteristics
 * 
 * Input Parameters
 *
 *    arg    The destination for the output of the Results query followed
 *           by the printer characteristics.
 *
 *  Output Parameter
 *
 *    s      True if Results should repaint the user interface.
 */

define input  parameter arg as character no-undo.
define output parameter s   as logical   no-undo initial false.

{ aderes/u-pvars.i }

define variable fileName    as character no-undo initial "temp.p".
define variable apArgs      as character no-undo.
define variable retState    as logical   no-undo.
define variable i           as integer   no-undo.
define variable controlChar as integer   no-undo.

/*
 * Set the cursor to the wait state. In case the thru function
 * takes alot of time
 */

run adecomm/_setcurs.p("WAIT").

/*
 * Put the current state of the query into a .p file
 */

apArgs = filename + "," + qbf-module.

run aderes/sffire.p("AdminProgWrite4GL", apArgs, output retState).

/*
 * Start the output.
 */

output to value(entry(1, arg)).

    /*
     * The control chars start after the file name
     */

    do i = 2 to num-entries(arg):

        if entry(i, arg) = "" then next.

        controlChar = integer(entry(i, arg)).
        if controlChar = 0 then put control null.
                           else put control chr(controlChar).
        
    end.

    run value(fileName).

output close.

os-delete value(fileName).

run adecomm/_setcurs.p("").

