/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* PROGRAM NAME: _db_gw.p
 * AUTHOR      : Gerry Seidl
 * DATE        : 12/09/94
 * DESCRIPTION : Looks for additional _db records that indicate whether or not this
 *               database is a schema-holder. If so, it returns comma-delimited lists
 *               of the foreign db names (db-name) and their db types (db-type).
 */
DEFINE OUTPUT PARAMETER anygw   AS LOG INITIAL no NO-UNDO.
DEFINE OUTPUT PARAMETER db-name AS CHAR           NO-UNDO.
DEFINE OUTPUT PARAMETER db-type AS CHAR           NO-UNDO.

FOR EACH tinydict._db WHERE tinydict._db._db-name <> ?          AND 
                            tinydict._db._db-type <> "PROGRESS" AND
                            tinydict._db._db-local = no         AND
                            tinydict._db._db-slave = YES NO-LOCK:
   ASSIGN anygw = yes
          db-name = db-name + "," + tinydict._db._db-name
          db-type = db-type + "," + tinydict._db._db-type.
END.
/* Remove leading comma */
IF LENGTH(db-name,"CHARACTER") > 0 THEN db-name = SUBSTRING(db-name,2,-1,"CHARACTER").
IF LENGTH(db-type,"CHARACTER") > 0 THEN db-type = SUBSTRING(db-type,2,-1,"CHARACTER").

RETURN.
 
                   
