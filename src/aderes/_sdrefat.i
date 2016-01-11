/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _sdrefat.i
*
*    De Refenrence an aliased table name. This code code fragment
*    will properly decide if the tablename provided is an alias
*    and will dereference the alias back to the "real" table.
*
*    The reason this a code fragment is for performance. This
*    code will be added to areas where performance is critical and
*    many calls to this fragment will be made.
*
*    This fragment requires that j-deinfe.i is provided. And it does
*    work with the buffers defined for qbf-rel-tt and does not expect any
*    particular state of the buffers.
*
*    The variables:
*
*        dtName is a character db.table name
*
*        realName is a character db.table and optional field name. It must
*        be preloaded with the db.table[.field] name if you want the
*        alias name to be substituted with the dereferenced table name.
*        This allows this code to be flexible about the real-name. It can
*        be a 2 or 3 level name without this code caring. If you are only
*        looking for the table id then this viable can be empty.
*
*        realTid is an integer. The tableId is returned.
*
*  Why an insert instead of a function?
*
*    Performance. 100 find statements on a 433 will take about 1 second.
*    10 calls to an external function will take at least 1 second. Since
*    the table alias feature will be used moderately and in places such as
*    field picking, the tradeoff is in saving time by not making function
*    calls.
*/

DO:
  {&FIND_TABLE_BY_NAME} {&dtName}.

  IF qbf-rel-buf.sid <> ? THEN DO:

    /*
    * There's a table alias here.
    * Go and get the name of the table. And use a tempName. qbf-v
    * is stored later, and that is what is correct. The field
    * name shoule be "db.tableAlias.field".
    */

    {&FIND_TABLE2_BY_ID} qbf-rel-buf.sid.

    /*
    * If the caller is looking for the tid only then don't make
    * the substitution.
    */
    IF NUM-ENTRIES({&realName}, ".") >= 2 THEN
      ENTRY(2, {&realName}, ".") = ENTRY(2, qbf-rel-buf2.tname, ".").

    {&realTid} = qbf-rel-buf2.tid.
  END.
  ELSE
    {&realTid} = qbf-rel-buf.tid.
END.

/* _sdrefat.i - end of file */

