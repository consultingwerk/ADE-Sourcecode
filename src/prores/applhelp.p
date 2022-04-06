/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* applhelp.p - PROGRESS RESULTS applhelp.p */

DEFINE SHARED VARIABLE qbf-module AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-c AS CHARACTER INITIAL ? NO-UNDO.

/* FAST TRACK help */
IF qbf-module = "f" THEN qbf-c = SEARCH("ft.r").
IF qbf-c <> ? THEN DO:
  RUN prores/s-prefix.p (qbf-c,OUTPUT qbf-c).
  RUN VALUE(qbf-c + "applhelp.p").
  RETURN.
END.

/*
You can intercept RESULTS help here for special cases.  If
ENTRY(1,qbf-module) = "ask" then you are in the "ask for a value at
run-time" mode.  ENTRY(2,qbf-module) will contain the
dbname.filename.fieldname of the field that is being compared.

Similarly, if ENTRY(1,qbf-module) = "where", then ENTRY(2,qbf-module)
contains the name of the field being compared in the "where-clause
builder".  Intercepting these values can be used to create scrolling
list programs.

If ENTRY(1,qbf-module) = "browse", then ENTRY(2,qbf-module) will
contain the dbname.filename that you are currently browsing.  It would
be very easy to change prores/u-browse.i (since the source is supplied)
to also include the ROWID (perhaps as ENTRY(3,qbf-module)), allowing
incredible amounts of hand-holding during queries.

For example:

  IF CAN-DO("ask,where",ENTRY(1,qbf-module))
      AND ENTRY(2,qbf-module) MATCHES "*~~.cust-num" THEN DO:
    RUN findcust.p.
    RETURN.
  END.

Here, findcust.p uses FRAME-VALUE to place the value of the selected
customer into the current field.  (findcust.p is not supplied with
RESULTS.)  Note that you could not use FRAME-DB, FRAME-FILE, and
FRAME-FIELD to get the field name, since both ask-at-run-time and
where-clause-builder get the values into variables, not the actual
fields.
*/

/* RESULTS help */
IF LENGTH(qbf-module) > 0 THEN DO: /* RESULTS help */
  RUN prores/s-help.p.
  RETURN.
END.

/* put your own help routine here */
