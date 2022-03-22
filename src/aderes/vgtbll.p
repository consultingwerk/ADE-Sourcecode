/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* vgtbll.p
*
*   shared Variable Get TaBLe List.
*
*      Returns the tables that are defining the view.
*
*  output parameter
*
*     tableList - A comma seperated list of the tables. In the order
*                 in which they have been added to the view.
*/

DEFINE OUTPUT PARAMETER tableList AS CHARACTER NO-UNDO.

{ aderes/s-define.i }
{ aderes/j-define.i }

DEFINE VARIABLE qbf-i     AS INTEGER   NO-UNDO.
DEFINE VARIABLE lookAhead AS CHARACTER NO-UNDO INITIAL "".
DEFINE VARIABLE tableNum  AS INTEGER   NO-UNDO.

tableList = "".

DO qbf-i = 1 TO NUM-ENTRIES(qbf-tables):

  tableNum = INTEGER(ENTRY(qbf-i, qbf-tables)).
  {&FIND_TABLE_BY_ID} tableNum.
  ASSIGN
    tableList = tableList + lookAhead + qbf-rel-buf.tname
    lookAhead = ",":u
    .
END.

/* vgtbll.p - end of file */

