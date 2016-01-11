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
/*
 * j-init.p - get list of all files into qbf-rel-tt temp table
 */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/s-alias.i  }

DEFINE INPUT PARAMETER qbf-l AS CHARACTER NO-UNDO.

/*
qbf-l = ? for initial caller
      = <ldbname> to load all tablenames from that db into temp table.

the qbf-rel-tt temp table is filled with "tablename.dbname".
*/

DEFINE VARIABLE qbf-c     AS CHARACTER NO-UNDO. /* current dbname */
DEFINE VARIABLE qbf-i     AS INTEGER   NO-UNDO. /* loop */
DEFINE VARIABLE qbf-o     AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE tableName AS CHARACTER NO-UNDO.
DEFINE VARIABLE stat      AS LOGICAL   NO-UNDO.

/* this block happens when latter part of program calls self recursively */
IF qbf-l <> ? THEN DO:
  FIND FIRST QBF$0._Db WHERE QBF$0._Db._Db-name =
    (IF DBTYPE(qbf-l) = "PROGRESS":u THEN ? ELSE qbf-l) NO-LOCK.

  FOR EACH QBF$0._File OF QBF$0._Db
    WHERE NOT QBF$0._File._Hidden 
      AND (qbf-u-hook[{&ahSecTableCode}] <> ?
      OR CAN-DO(QBF$0._File._Can-Read,USERID(qbf-l))) NO-LOCK
    BY QBF$0._File._File-name:
   
      /* skip this table if it is a sql92 view or table */
      IF INTEGER(DBVERSION("QBF$0":U)) > 8 AND (QBF$0._File._Owner <> "PUB":u AND QBF$0._File._Owner <> "_FOREIGN":u)
            THEN NEXT.
     
    /* Get the table name */
    tableName = (IF QBF$0._Db._Db-name = ? THEN LDBNAME("QBF$0":u)
	         ELSE QBF$0._Db._Db-name) + ".":u + QBF$0._File._File-name.

    /* Get table CRC - dma */
    RUN aderes/s-schema.p (tableName, "", "", "FILE:CRC":u, OUTPUT qbf-o).

    CREATE qbf-rel-buf.
    ASSIGN
      qbf-rel-tbl#       = qbf-rel-tbl# + 1
      qbf-rel-buf.tid    = qbf-rel-tbl#
      qbf-rel-buf.tname  = tableName
      qbf-rel-buf.cansee = TRUE
      qbf-rel-buf.sid    = ?
      qbf-rel-buf.crc    = qbf-o
    .
 END.
 RETURN.
END.

/*--------------------------------------------------------------------------*/

qbf-rel-tbl# = 0.
FOR EACH qbf-rel-buf:
  DELETE qbf-rel-buf.
END.

/* Get a sorted list of dbnames.  This way, we are always guaranteed 
   to get the list in alpha order by dbname by tablename.  In V6
   we got the dbnames in connect order instead of alpha order, and
   sometimes had to shell-sort the whole array.  Now, we get the dbnames
   in alpha order and dispense with the time-wasting sort.
*/
RUN aderes/_sbase.p. 

/* now run thru and add filenames, always in alpha order */
DO qbf-i = 1 TO NUM-ENTRIES(qbf-dbs):
  qbf-c = ENTRY(qbf-i, qbf-dbs).
  CREATE ALIAS "QBF$0":u FOR DATABASE VALUE(SDBNAME(qbf-c)).
  RUN aderes/j-init.p (qbf-c).
END.

/* Now add in any admin defined table security */
RUN aderes/af-tsec.p.

RETURN.

/* j-init.p - end of file */

