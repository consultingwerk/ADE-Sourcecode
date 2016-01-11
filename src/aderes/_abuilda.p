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
 * _abuilda.p
 *
 *    Recreates the table aliases, relationships involving aliases, and
 *    any "custom" relationship during an application
 *    rebuild. This code will open the ASCII configuration file, looking
 *    only for table aliases and relationships.
 *
 *    This is the easiest way to rebuild, since the rebuild of the
 *    databases could end up with different IDs and such. Instead of
 *    having to try to synch up old IDs with new IDs, we get the information
 *    from the config file and build on the fly. It's not the fastest, but
 *    it is the simplest method to insure that aliases and their
 *    relationships get added back in correctly.
 */

{ aderes/s-system.i }
{ aderes/j-define.i }

DEFINE VARIABLE abortRead    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE aliasOnly    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE aliasName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile        AS CHARACTER NO-UNDO.
DEFINE VARIABLE didSomething AS LOGICAL   NO-UNDO.
DEFINE VARIABLE key          AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i        AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j        AS INTEGER   NO-UNDO.
DEFINE VARIABLE token        AS CHARACTER NO-UNDO EXTENT 6.

DEFINE STREAM cStream.

cFile = SEARCH(qbf-qcfile + {&qcExt}).

INPUT STREAM cStream FROM VALUE(cFile) NO-ECHO.

REPEAT:
  ASSIGN
    key   = ""
    token = ""
    .

  IMPORT STREAM cStream key token.

  IF INDEX(key,"=":u) = 0 OR key BEGINS "#":u THEN NEXT.

  /* Rip off the junk at the end of the key. */
  ASSIGN
    key = SUBSTRING(key,1,LENGTH(key,"CHARACTER":u) - 1,"CHARACTER":u)
    qbf-i   = INDEX(key,"[":u)
    qbf-j   = INDEX(key,"]":u)
    .

  IF qbf-i > 0 AND qbf-j > qbf-i THEN
    key = SUBSTRING(key,1,qbf-i - 1,"CHARACTER":u).

  qbf-i = INDEX(key,".":u).
  CASE (IF qbf-i > 0 THEN SUBSTRING(key,1,qbf-i,"CHARACTER":u) ELSE key):
    WHEN "talias.":u THEN DO:

      /* Set up the alias */
      aliasName = SUBSTRING(key,INDEX(key,".":u) + 1,-1,"CHARACTER":u).

      RUN aderes/af-tal.p (aliasName, token[1], FALSE).
      
      {&FIND_TABLE_BY_NAME} aliasName.
      IF AVAILABLE qbf-rel-buf THEN
        RUN aderes/_atalrel.p(TRUE,
                              qbf-rel-buf.tname,
                              qbf-rel-buf.tid,
                              qbf-rel-buf.sid,
                              TRUE,
                              TRUE,
                              OUTPUT qbf-rel-buf.rels).
    END.

    WHEN "relat":u THEN DO:
      /* Only try to build the relationship if aliases are involved
       * or if there is a custom join. */
      ASSIGN
        aliasOnly    = IF token[4] = "" THEN TRUE ELSE FALSE
        didSomething = TRUE.

      RUN af-rship (token[1],token[3],token[2],token[4],token[5],aliasOnly,
                    OUTPUT abortRead).
      IF abortRead THEN RETURN.
    END.
  END.
END.
INPUT STREAM cStream CLOSE.

/* Since we've built relationships let's make sure they are sorted. */
IF didSomething THEN DO:
  FOR EACH qbf-rel-buf:
    RUN aderes/_jsort1.p (qbf-rel-buf.rels, OUTPUT qbf-rel-buf.rels).
  END.
END.

/*-------------------------------------------------------------------------*/
{ aderes/af-rship.i }

/* _abuilda.p - end of file */

