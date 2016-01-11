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
* p-where.i
*
*    Holds several internal procedure needed to handle the various
*    aspects of the WHERE clause
*/

PROCEDURE synchAdminWhere:
  /* Walk through all the admin WHERE clause and add them into the proper
   * parts of the qbf-where datastructure.  */

  FOR EACH _tableWhere:
    FIND FIRST qbf-where
      WHERE qbf-where.qbf-wtbl = _tableWhere._tableId NO-ERROR.

    IF NOT AVAILABLE qbf-where THEN DO:
      CREATE qbf-where.
      qbf-where.qbf-wtbl = _tableWhere._tableId.
    END.

    qbf-where.qbf-acls = _tableWhere._text.
  END.
END PROCEDURE.

/*------------------------------------------------------------------------*/
PROCEDURE removeEmptyWheres:
  /* Remove all tables that don't have anything to go into any WHERE clause.
   * This is needed because code gneeration assumes that if there any
   * qbf-where reocrds then a WHERE clause is needed.
   */

  FOR EACH qbf-where
    WHERE qbf-where.qbf-wrel = ""
      AND qbf-where.qbf-acls = ""
      AND qbf-where.qbf-wcls = ""
      AND qbf-where.qbf-wsec = ""
      AND qbf-where.qbf-winc = ""
      AND NOT qbf-where.qbf-wojo:

    DELETE qbf-where.
  END.
END PROCEDURE.

/* p-where.i - end of file */

