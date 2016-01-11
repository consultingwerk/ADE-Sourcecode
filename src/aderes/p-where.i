/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

