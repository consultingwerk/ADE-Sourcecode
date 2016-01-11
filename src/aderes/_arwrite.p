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
* Contributors:  Fernando de Souza                                                    *
*                                                                    *
*********************************************************************/
/*
 * _arwrite.p
 *
 *    Writes out the fastload version of the database and relationship
 *    information.
 *
 *    Originally, _awrite handled writing out both the ASCII version and
 *    compiled version of the configuration file. But with the changes to
 *    qbf-rel-tt, the code generation for the table/relationship
 *    information became vastly different in appearance. So, this part
 *    of the code generation merits its own function.
 *
 *  Input
 *
 *    pName   - The name (with extension) of the temporary
 *              file we write out to.
 *
 *    pBase   - THe Base name (without extension) of the temporary
 *              file we write out to.
 *
 * Due to the way database aliases work as well as Progress programming
 * limits we have to bludgeon the code to work. We'll do everything
 * in 2 passes.
 *
 * The first pass walks through the database list and build the controlling
 * program. This program will create the proper database alias and will
 * call the reload programs
 *
 * Then dump the temptable into the individual files
 */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/a-define.i }

&GLOBAL-DEFINE blockSize 28
&GLOBAL-DEFINE fileSize  3

DEFINE INPUT PARAMETER pName AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pBase AS CHARACTER NO-UNDO.

DEFINE VARIABLE currentFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE nextFile    AS CHARACTER NO-UNDO.
DEFINE VARIABLE dName       AS CHARACTER NO-UNDO.
DEFINE VARIABLE tName       AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i       AS INTEGER   NO-UNDO INITIAL 0.
DEFINE VARIABLE qbf-j       AS INTEGER   NO-UNDO.
DEFINE VARIABLE pCount      AS INTEGER   NO-UNDO.
DEFINE VARIABLE fCount      AS INTEGER   NO-UNDO.

DEFINE STREAM pStream.

/* Start the control file. This defines the aliases and the WHERE clauses */
RUN adecomm/_statdsp.p (wGlbStatus,1,"Writing Fastload control file...":t72).

currentFile = qbf-fastload + {&flRelationshipExt} + ".r":u.
RUN startFile (pName,INPUT-OUTPUT pCount,"",currentFile).

PUT STREAM pStream UNFORMATTED
  '/*PROGRESS RESULTS fastload relationship control file */':u SKIP
  'qbf-rel-tbl# = ':u qbf-rel-tbl# '.':u SKIP
  'qbf-rel-whr# = ':u qbf-rel-whr# '.':u SKIP
  'RUN aderes/_sbase.p.':u SKIP(2)
  .

DO qbf-j = 1 TO NUM-ENTRIES(qbf-dbs):
  fCount = fCount + 1.
  PUT STREAM pStream UNFORMATTED
    'CREATE ALIAS "QBF$0":u FOR DATABASE ':u SDBNAME(ENTRY(qbf-j, qbf-dbs))
    '.':u SKIP
    'RUN ':u qbf-fastload + STRING(fCount,"999":u) + '.r.':u SKIP(2)
    .
END.

/* Finalize the aliases. The CRCs and permissions may have changed. */
PUT STREAM pStream UNFORMATTED
  'RUN aderes/_aflend.p.':u SKIP
  'RUN aderes/af-tsec.p.':u SKIP.

/* Now write out the rel where clauses. These are attached to the tables, 
 * therefore the table has to be available before loading this information. */
RUN endProc (INPUT-OUTPUT qbf-i).

RUN startProc(INPUT-OUTPUT pCount).

/* table join WHERE clause */
FOR EACH qbf-rel-whr WHERE qbf-rel-whr.jwhere > "":
  PUT STREAM pStream UNFORMATTED
    'CREATE qbf-rel-whr.':u SKIP
    'ASSIGN':u SKIP
    '  qbf-rel-whr.wid = ':u qbf-rel-whr.wid SKIP
    '  qbf-rel-whr.jwhere = ':u
    .
  EXPORT STREAM pStream qbf-rel-whr.jwhere.
  PUT STREAM pStream UNFORMATTED
    '  .':u SKIP.
END.

/* Now write out the admin WHERE clauses. These are attached to the tables, 
 * therefore the table has to be available before loading this information. */
RUN endProc (INPUT-OUTPUT qbf-i).

RUN startProc (INPUT-OUTPUT pCount).

FOR EACH _tableWhere:
  IF (_tableWhere._text = ?) OR (_tableWhere._text = "") THEN NEXT.

  FIND qbf-rel-buf WHERE qbf-rel-buf.tid = _tableWhere._tableId.

  PUT STREAM pStream UNFORMATTED
    'RUN aderes/af-where.p(':u
    '"':u qbf-rel-buf.tname '",':u
    '"':u REPLACE(_tableWhere._text,'"':u,'""':u) '").':u SKIP
    .
END.

RUN endFile (INPUT-OUTPUT qbf-i,"").
RUN compileFastload (pBase,currentFile).

/* Now on to the individual files. */
DO qbf-j = 1 TO NUM-ENTRIES(qbf-dbs):
  RUN adecomm/_statdsp.p (wGlbStatus, 1,
    "Writing Relationships for " + ENTRY(qbf-j,qbf-dbs) + "...":t72).
  ASSIGN
    currentFile = qbf-fastload + STRING(qbf-j,"999":u) + ".r":u
    dName       = ENTRY(qbf-j,qbf-dbs)
    .

  RUN startFile (pName,INPUT-OUTPUT pCount,"",currentFile).

  PUT STREAM pStream UNFORMATTED
    '/*PROGRESS RESULTS fastload relationship file */' SKIP.

  FOR EACH qbf-rel-buf USE-INDEX tidix:
    /* Recreate the record */
    IF qbf-rel-buf.tname = ""
      OR ENTRY(1,qbf-rel-buf.tname,".":u) <> dName THEN NEXT.

    tName = ENTRY(2,qbf-rel-buf.tname,".":u).

    PUT STREAM pStream UNFORMATTED
      'CREATE qbf-rel-tt.':u SKIP.

    /* Write out a FIND statement if this isn't an alias. */
    IF qbf-rel-buf.sid = ? THEN DO:
        /* filter out sql92 views and tables by checking owner */
        IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN
            PUT STREAM pStream UNFORMATTED
                'FIND FIRST QBF$0._File WHERE _File-name = "':u tName '"
                AND (QBF$0._File._Owner = "PUB":U 
                OR QBF$0._File._Owner = "_FOREIGN":U). ':u SKIP.
        ELSE 
            PUT STREAM pStream UNFORMATTED
        'FIND FIRST QBF$0._File WHERE _File-name = "':u tName '".':u SKIP.
    END.
    

    PUT STREAM pStream UNFORMATTED
      'ASSIGN' SKIP
      '  tid    = ':u  qbf-rel-buf.tid          SKIP
      '  tname  = "':u qbf-rel-buf.tname '"':u  SKIP
      '  rels   = "':u qbf-rel-buf.rels  '"':u  SKIP
      '  crc    = "':u qbf-rel-buf.crc '"':u    SKIP
      '  sid    = ':u  qbf-rel-buf.sid          SKIP
      .

    /* The can-see is also determined by type */
    IF qbf-rel-buf.sid = ? THEN
      PUT STREAM pStream UNFORMATTED
        '  cansee = NOT _File._Hidden':u SKIP
        '           AND CAN-DO(_File._Can-Read,USERID("':u dName '"))':u SKIP.
    ELSE
      PUT STREAM pStream UNFORMATTED
        '  cansee = ':u qbf-rel-buf.cansee SKIP.

    /* Finish off the assign statement */
    PUT STREAM pStream UNFORMATTED
      SKIP '.':u SKIP(1).

    /* If we've hit the self-imposed limit for lines in a subprocedure then
     * make a new subprocedure. */
    qbf-i = qbf-i + 1.
    IF qbf-i = {&blockSize} THEN DO:
      RUN endProc (INPUT-OUTPUT qbf-i).
      RUN startProc (INPUT-OUTPUT pCount).
    END.

    /* If we've hit the self imposed limit for number of internal procedures
       in a file then close this file and make a new one. */
    IF pCount - 1 = {&fileSize} THEN DO:
      /* Make sure the chain to the next file is written */
      ASSIGN
        fCount = fCount + 1
        nextFile = qbf-fastload + STRING(fCount,"999":u) + ".r":u
        .

      RUN endFile (INPUT-OUTPUT qbf-i,"RUN ":u + nextFile + ".":u).
      RUN compileFastload (pBase,currentFile).

      currentFile = nextFile.
      RUN startFile (pName,INPUT-OUTPUT pCount,"",currentFile).
    END.
  END.

  RUN endFile (INPUT-OUTPUT qbf-i,"").
  RUN compileFastload (pBase,currentFile).
END.

{ aderes/_awrite.i }

/* _arwrite.p - end of file */

