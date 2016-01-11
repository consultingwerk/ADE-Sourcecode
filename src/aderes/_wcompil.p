/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* _wcompil.p - 

    Do a test compile for a WHERE clause input into the
    Where builder dialog box.  We don't use the default
    test compile file built by the Where Builder because
    it doesn't necessarily work in the "Open Query" 
    enviroment as in browse view.  For example if you have:

    DEFINE QUERY q FOR customer.
    DEFINE QUERY q2 FOR invoice.
    OPEN QUERY q FOR EACH customer WHERE cust-num > 10.

    If there are mult tables with the same field in a db, you must
    qualify a reference to that field in a query WHERE clause such as cust-num
    in this example.  It is not like a FOR EACH where you are actually creating
    a little insulated block which has it's own references that get preference.
    The query is "block-less" so its references are general to the block it is 
    enclosed in.  This would give a compiler error that cust-num is 
    ambiguous between customer and invoice.
*/

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }

DEFINE INPUT PARAMETER p_file      AS CHARACTER NO-UNDO. /* file to write to */
DEFINE INPUT PARAMETER p_table     AS CHARACTER NO-UNDO. /* WHERE table */
DEFINE INPUT PARAMETER p_where     AS CHARACTER NO-UNDO. /* WHERE clause */

DEFINE VARIABLE ix     AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf_i  AS INTEGER   NO-UNDO. /* needed for defbufs.i */
DEFINE VARIABLE qbf_j  AS INTEGER   NO-UNDO. 
DEFINE VARIABLE qbf_l  AS INTEGER   NO-UNDO. 
DEFINE VARIABLE tbl_ix AS INTEGER   NO-UNDO. 
DEFINE VARIABLE tbname AS CHARACTER NO-UNDO.

OUTPUT TO VALUE(p_file) NO-ECHO {&NO-MAP}.

/* Define a buffer for each table, in case of aliases. qbf-tables will
   be null if we are in the Admin Table Data Selection function at which
   point there is no query open.
*/
IF qbf-tables <> "" THEN DO: 
  { aderes/defbufs.i }  
END.
ELSE DO:
  RUN alias_to_tbname (p_table, TRUE, OUTPUT tbname).
  PUT UNFORMATTED
    'DEFINE BUFFER ':u 
      (IF qbf-hidedb THEN p_table ELSE ENTRY(2, p_table, ".")) /* w/o db name */
      ' FOR ':u tbname '.':u.
END.
PUT UNFORMATTED SKIP(1).

/* Act like all tables are in a separate section since WHERE clause
   had better work no matter how user does master detail split.

  > DEFINE QUERY q FOR demo.customer.
  > DEFINE QUERY q2 FOR demo.invoice.
*/
IF qbf-tables <> "" THEN 
  DO ix = 1 TO NUM-ENTRIES(qbf-tables):
    {&FIND_TABLE_BY_ID} INTEGER(ENTRY(ix,qbf-tables)).
    IF qbf-rel-buf.tname = p_table THEN
      tbl_ix = ix.
    PUT UNFORMATTED
      'DEFINE QUERY q':U ix ' FOR ':U qbf-rel-buf.tname '.':U SKIP.
  END.
ELSE DO:
  tbl_ix = 1.
  PUT UNFORMATTED
    'DEFINE QUERY q1 FOR ':u p_table '.':u SKIP.
END.
PUT UNFORMATTED SKIP(1).

/* convert calc field in WHERE clause to 4GL */
RUN calcfld_to_4gl (INPUT-OUTPUT p_where).

/*
  > OPEN QUERY q FOR EACH demo.customer WHERE
  >   <where clause>
*/
PUT UNFORMATTED
  'OPEN QUERY q':U tbl_ix ' FOR EACH ':U p_table ' WHERE ':U SKIP
  '   ':U p_where '.':U SKIP.

OUTPUT CLOSE.

/*--------------------------------------------------------------------------*/
/* alias_to_tbname */
{ aderes/s-alias.i }

/*--------------------------------------------------------------------------*/
/* calcfld_to_4gl */
{ aderes/_calc4gl.i }

/* _wcompil.p - end of file */

