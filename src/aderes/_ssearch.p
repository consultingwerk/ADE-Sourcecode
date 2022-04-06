/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _ssearch
*
*    Given a a filename, it figures out if it, or its r code, is "out there."
*
* The algorithm:
*
*    1. No extension, assume the file is a .p.
*    2. If a .p then look for .p
*    3. If no .p then look for .r
*
* Input Parameters
*
*    fileName    Character holding the name
*
* Output Parameter
*
*    s           True if the fileName exists
*/

DEFINE INPUT  PARAMETER fileName AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-s    AS CHARACTER NO-UNDO INITIAL "".

DEFINE VARIABLE baseName   AS CHARACTER NO-UNDO.
DEFINE VARIABLE extension  AS CHARACTER NO-UNDO.
DEFINE VARIABLE dot        AS INTEGER   NO-UNDO.

IF (fileName = ?) OR (fileName = "") THEN RETURN.

dot = INDEX(fileName, ".":u).

IF dot = 0 THEN
  baseName = fileName.
ELSE
  ASSIGN
    extension = SUBSTRING(fileName,dot + 1,
                  LENGTH(fileName,"CHARACTER":u) - dot,"CHARACTER":u)
    baseName  = SUBSTRING(fileName,1,dot - 1,"CHARACTER":u)
    .

/* Look for the source first. If it isn't there then look for a .r of the
 * same name. */

IF extension <> "r":u THEN DO:
  qbf-s = SEARCH(fileName).
  IF qbf-s <> ? THEN RETURN.

  /*
  * The baseName doesn't exist. If there was no extension add a .p
  * and look for the file
  */
  qbf-s = SEARCH(baseName + ".p":u).

  IF qbf-s <> ? THEN RETURN.
END.

qbf-s = SEARCH(baseName + ".r":u).

/* _ssearch.p - end of file */

