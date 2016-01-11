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
 * c-gen1.i - write out variable definitions for calculated fields
 *
 * Parameter
 *
 *    genUsage  Variable holding standalone state. If "g" then standalone
 */

IF {&genUsage} = "g":u THEN
  PUT UNFORMATTED
    'DEFINE VARIABLE qbf-count    AS INTEGER NO-UNDO.':u SKIP
    'DEFINE VARIABLE qbf-governor AS INTEGER NO-UNDO.':u SKIP.
ELSE
  PUT UNFORMATTED
    'DEFINE SHARED VARIABLE qbf-count    AS INTEGER NO-UNDO.':u SKIP
    'DEFINE SHARED VARIABLE qbf-governor AS INTEGER.':u SKIP
    'DEFINE SHARED VARIABLE qbf-index    AS INTEGER NO-UNDO.':u SKIP(1).

DO qbf-i = 1 TO qbf-rc#:
  IF qbf-rcc[qbf-i] = "" OR qbf-rcc[qbf-i] BEGINS "e":u THEN NEXT.
  IF qbf-module = "f":u AND CAN-DO("c,p,r":u,qbf-rcc[qbf-i]) THEN NEXT.

  PUT UNFORMATTED /*SKIP*/
    'DEFINE VARIABLE ':u ENTRY(1,qbf-rcn[qbf-i]) '  AS ':u.

  CASE SUBSTRING(qbf-rcc[qbf-i],1,1,"CHARACTER":u):
    WHEN "p":u THEN
      PUT UNFORMATTED
        'DECIMAL NO-UNDO.':u SKIP
        'DEFINE VARIABLE ':u ENTRY(1,qbf-rcn[qbf-i])
          '% AS DECIMAL INITIAL 0 NO-UNDO.':u SKIP.
    WHEN "r":u THEN
      PUT UNFORMATTED
        'DECIMAL INITIAL 0 NO-UNDO.':u SKIP.
    WHEN "c":u THEN
      PUT UNFORMATTED
	CAPS(ENTRY(qbf-rct[qbf-i],qbf-dtype))
	' INITIAL ':u
	INTEGER(ENTRY(2,qbf-rcn[qbf-i]))
	      - INTEGER(ENTRY(3,qbf-rcn[qbf-i]))
	' NO-UNDO.':u SKIP.
    WHEN "x":u THEN DO:
      DEFINE VARIABLE real-table AS CHARACTER NO-UNDO.
      RUN alias_to_tbname (ENTRY(4,qbf-rcn[qbf-i]),TRUE,OUTPUT real-table).

      PUT UNFORMATTED
        CAPS(ENTRY(qbf-rct[qbf-i],qbf-dtype)) ' NO-UNDO.':u SKIP
        'DEFINE BUFFER qbf-':u STRING(qbf-i,"999":u) '-buffer FOR ':u
           real-table '.':u SKIP.
    END.
    OTHERWISE
      PUT UNFORMATTED
        CAPS(ENTRY(qbf-rct[qbf-i],qbf-dtype)) ' NO-UNDO.':u SKIP.
  END CASE.
END.
PUT UNFORMATTED " " SKIP.

/* c-gen1.i - end of file */
