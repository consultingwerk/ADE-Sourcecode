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
/* s-info.p - summary of current object */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-t AS CHARACTER NO-UNDO.

{ prores/t-set.i &mod=s &set=3 }

/* file info, field info, order info */

DEFINE VARIABLE qbf-a AS LOGICAL INITIAL ? NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER         NO-UNDO.
DEFINE VARIABLE qbf-e AS CHARACTER         NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER           NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER           NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER           NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER INITIAL 0 NO-UNDO.

IF qbf-file[1] = "" THEN DO:
  /*"You have not yet selected any files!"*/
  RUN prores/s-error.p ("#11").
  { prores/t-reset.i }
  RETURN.
END.

/* right-justify all labels */
ASSIGN
  qbf-lang[3] = qbf-lang[3] + " ##"  /*"File #n"*/
  qbf-lang[6] = qbf-lang[6] + " ###". /*"Field name #nn"*/
DO qbf-i = 1 TO 7:
  qbf-l = MAXIMUM(qbf-l,LENGTH(qbf-lang[qbf-i])).
END.
DO qbf-i = 1 TO 7:
  qbf-lang[qbf-i] = FILL(" ",qbf-l - LENGTH(qbf-lang[qbf-i])) + qbf-lang[qbf-i].
END.

/* convert where-clauses to printable format and place in qbf-asked[] */
RUN prores/s-ask.p (INPUT-OUTPUT qbf-a).

OUTPUT TO VALUE(qbf-tempdir + ".d") NO-ECHO.

IF qbf-module <> "q" AND qbf-name <> "" THEN DO:
  EXPORT qbf-name.
  EXPORT FILL("-",LENGTH(qbf-name)).
END.
IF qbf-module <> "q" AND qbf-time <> "" THEN DO:
  EXPORT
    ENTRY(1,qbf-lang[19]) /* 'Elapsed time of last Run,minutes:seconds' */
    + ": " + qbf-time
    + " (" + ENTRY(2,qbf-lang[19]) + ")".
END.
IF qbf-module <> "q" AND qbf-name <> "" OR qbf-time <> "" THEN EXPORT "".

DO qbf-i = 1 TO 5 WHILE qbf-file[qbf-i] <> "":
  SUBSTRING(qbf-lang[3],qbf-l,1) = STRING(qbf-i). /*"File #n"*/
  EXPORT qbf-lang[3] + ": " + qbf-db[qbf-i] + "." + qbf-file[qbf-i].

  /* This sneaky little loop means we only need to include the wrap */
  /* code once to cover both the relation-clause (qbf-of[]) and the */
  /* where-clause (qbf-asked[]).                                    */
  DO qbf-j = 4 TO 5:
    qbf-c = (IF qbf-j = 4 THEN qbf-of[qbf-i] ELSE qbf-asked[qbf-i]).
    IF qbf-c = "" THEN NEXT.
    qbf-c = qbf-lang[qbf-j] + ": " + qbf-c. /*4:'Relation' 5:'Where'*/

    /* wrap text at 78 columns */
    DO WHILE LENGTH(qbf-c) > 78:
      ASSIGN
        qbf-k = R-INDEX(SUBSTRING(qbf-c,1,78)," ")
        qbf-k = (IF qbf-k < LENGTH(qbf-lang[qbf-j]) + 3 THEN 78 ELSE qbf-k).
      EXPORT SUBSTRING(qbf-c,1,qbf-k).
      qbf-c = FILL(" ",qbf-l + 2) + SUBSTRING(qbf-c,qbf-k + 1).
    END.
    IF qbf-c <> "" THEN EXPORT qbf-c.

  END.

  EXPORT "".
END.

DO qbf-i = 1 TO 5 WHILE qbf-order[qbf-i] <> "":
  EXPORT qbf-lang[IF qbf-i = 1 THEN 1 ELSE 2] + ": " + qbf-order[qbf-i].
  /*1:'Order By'  2:'and By'*/
END.
IF qbf-order[1] <> "" THEN EXPORT "".

IF qbf-module = "q" OR qbf-module = "l" THEN .
ELSE
DO qbf-i = 1 TO qbf-rc#:
  IF qbf-i > 1 THEN EXPORT "".

  /*qbf-lang[6]="Field ##:"  qbf-lang[7]="Expression"*/
  /*qbf-lang[10]="FROM,BY,FOR"*/
  ASSIGN
    SUBSTRING(qbf-lang[6],qbf-l - 1,2) = STRING(qbf-i,"ZZ") /*"Field ##:"*/
    qbf-j = INDEX("rpcsdnle",SUBSTRING(qbf-rcc[qbf-i],1,1))
    qbf-c = qbf-lang[7] + ": "
          + (IF qbf-j = 1 OR qbf-j = 2 THEN
              ENTRY(2,qbf-rcn[qbf-i])
            ELSE IF qbf-j = 3 THEN
              ENTRY(1,qbf-lang[10]) + " " + ENTRY(2,qbf-rcn[qbf-i]) + " "
              + ENTRY(2,qbf-lang[10]) + " "  + ENTRY(3,qbf-rcn[qbf-i])
            ELSE IF qbf-j = 8 THEN
              qbf-c + "[1 " + ENTRY(3,qbf-lang[10]) + " "
              + SUBSTRING(qbf-rcc[qbf-i],2) + "]"
            ELSE IF qbf-j > 0 THEN
              SUBSTRING(qbf-rcn[qbf-i],INDEX(qbf-rcn[qbf-i],",") + 1)
            ELSE
              qbf-rcn[qbf-i]
            ).

  qbf-e = qbf-rcf[qbf-i]. 
  IF STRING(0,"9.") = "0," THEN
    RUN prores/d-extra.p (INPUT-OUTPUT qbf-e). 

  EXPORT
    qbf-lang[6] + ': "' + qbf-rcl[qbf-i]
    + '" (' + ENTRY(qbf-rct[qbf-i],qbf-dtype)
    + (IF qbf-j = 0 THEN "" ELSE ", " + ENTRY(qbf-j + 1,qbf-etype))
    + ', "' + qbf-e + '")'.

  /* wrap text at 78 columns */
  DO WHILE LENGTH(qbf-c) > 78:
    ASSIGN
      qbf-k = R-INDEX(SUBSTRING(qbf-c,1,78)," ")
      qbf-k = (IF qbf-k < LENGTH(qbf-lang[6]) + 3 THEN 78 ELSE qbf-k).
    EXPORT SUBSTRING(qbf-c,1,qbf-k).
    qbf-c = FILL(" ",qbf-l + 2) + SUBSTRING(qbf-c,qbf-k + 1).
  END.
  IF qbf-c <> "" THEN EXPORT qbf-c.

END.

OUTPUT CLOSE.

qbf-c = qbf-module.
IF      qbf-module BEGINS "d" THEN qbf-module = "d9s".
ELSE IF qbf-module BEGINS "l" THEN qbf-module = "l9s".
ELSE IF qbf-module BEGINS "q" THEN qbf-module = "q17s".
ELSE IF qbf-module BEGINS "r" THEN qbf-module = "r9s".

RUN prores/s-page.p (qbf-tempdir + ".d",0,FALSE).

qbf-module = qbf-c.
{ prores/t-reset.i }
RETURN.
