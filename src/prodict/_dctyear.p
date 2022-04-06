/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _dctyear.p - returns -d <mdy> setting and -yy <nnnn> setting */

/* Removed all do loops that tried to figure out the settings and use
   the session options instead.  Old code had problem if -yr4def startup
   parameter was used.  D. McMann 12/01/99
*/

DEFINE OUTPUT PARAMETER mdy AS CHARACTER         NO-UNDO.
DEFINE OUTPUT PARAMETER yy  AS INTEGER INITIAL ? NO-UNDO.

ASSIGN mdy = SESSION:DATE-FORMAT
       yy  = SESSION:YEAR-OFFSET.

RETURN.





