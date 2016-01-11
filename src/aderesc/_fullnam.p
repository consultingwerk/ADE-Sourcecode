/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _fullnam.p
*
*    Insures that a table name has a database qualification
*/

DEFINE INPUT        PARAMETER dtName AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER source AS CHARACTER NO-UNDO.

DEFINE VARIABLE loc   AS INTEGER   NO-UNDO. /* location */
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE dName AS CHARACTER NO-UNDO. /* db name */
DEFINE VARIABLE tName AS CHARACTER NO-UNDO. /* table name */

/*
* Assume that only the 2 tables are involved in the relationship
* If there are more then this code will not deal with it. The
* admin will have to edit the new configuration file by hand to
* clean up.
*
* Start with the "left" table. Search for it and see if the
* name is fully qualifed. If the name is fully qualified then
* leave it alone. Otherwise substitute in the db name. Repeat
* for the second table.
*/

ASSIGN
  dName = SUBSTRING(dtName,1,INDEX(dtName,".":u) - 1,"CHARACTER":u)
  tName = SUBSTRING(dtName,INDEX(dtName,".":u) + 1,-1,"CHARACTER":u)
  loc   = INDEX(source,tName)
  qbf-c = ?
  .

/*
* See if the name is fully qualifed. We have the loc of the
* start of the table name. Check the character before to see
* if there is a period. If there is this table name is already
* fully qualified. And if loc is 1 then the table begins the
* line, so it can't be fully qualified.
*/

IF loc > 1 THEN
  qbf-c = SUBSTRING(dtName,loc - 1,1,"CHARACTER":u).

IF qbf-c = ? OR qbf-c <> ".":u THEN
  source = REPLACE(source,tName,dName + ".":u + tName).

/* _fullnam.p - end of file */
