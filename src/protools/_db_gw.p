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
                            tinydict._db._db-slave = yes:
   ASSIGN anygw = yes
          db-name = db-name + "," + tinydict._db._db-name
          db-type = db-type + "," + tinydict._db._db-type.
END.
/* Remove leading comma */
IF LENGTH(db-name,"CHARACTER") > 0 THEN db-name = SUBSTRING(db-name,2,-1,"CHARACTER").
IF LENGTH(db-type,"CHARACTER") > 0 THEN db-type = SUBSTRING(db-type,2,-1,"CHARACTER").

RETURN.
 
                   
