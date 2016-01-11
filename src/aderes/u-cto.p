/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

