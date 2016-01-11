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
/* r-extra.p - run-time part of report column totals */
/* File prores/r-extra.x is an xcoded version of this file. If you
   make changes to r-extra.p, you must create a new xcoded version
   of r-extra.x. Also, r-extra.x must be deployed to the prores rcode
   directory.
*/

DEFINE SHARED VARIABLE qbf-lang  AS CHARACTER EXTENT 33 NO-UNDO.
DEFINE SHARED VARIABLE qbf-order AS CHARACTER EXTENT  5 NO-UNDO.

DEFINE SHARED VARIABLE qbf-m AS CHARACTER EXTENT 5 NO-UNDO.
DEFINE SHARED VARIABLE qbf-r AS LOGICAL            NO-UNDO.
DEFINE SHARED VARIABLE qbf-s AS LOGICAL            NO-UNDO.
DEFINE SHARED VARIABLE qbf-v AS CHARACTER          NO-UNDO.

DEFINE SHARED VARIABLE qbf-a AS LOGICAL   EXTENT 6 NO-UNDO. /*avg*/
DEFINE SHARED VARIABLE qbf-c AS LOGICAL   EXTENT 6 NO-UNDO. /*cnt*/
DEFINE SHARED VARIABLE qbf-n AS LOGICAL   EXTENT 6 NO-UNDO. /*min*/
DEFINE SHARED VARIABLE qbf-t AS LOGICAL   EXTENT 6 NO-UNDO. /*tot*/
DEFINE SHARED VARIABLE qbf-x AS LOGICAL   EXTENT 6 NO-UNDO. /*max*/

FORM
  /*14:"Total Count -Min- -Max- -Avg-"  15:"Summary Line"*/
    qbf-lang[14] FORMAT "x(29)" NO-ATTR-SPACE SKIP
  qbf-t[6]   FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-c[6] FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-n[6] FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-x[6] FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-a[6] FORMAT {1} "yes /no  " /{1}**/ {2} SPACE(0)
    qbf-lang[15] FORMAT "x(45)" NO-ATTR-SPACE SKIP(1)
  qbf-t[1]   FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-c[1] FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-n[1] FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-x[1] FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-a[1] FORMAT {1} "yes /no  " /{1}**/ {2} SPACE(0)
    qbf-m[1] FORMAT "x(45)" NO-ATTR-SPACE SKIP
  qbf-t[2]   FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-c[2] FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-n[2] FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-x[2] FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-a[2] FORMAT {1} "yes /no  " /{1}**/ {2} SPACE(0)
    qbf-m[2] FORMAT "x(45)" NO-ATTR-SPACE SKIP
  qbf-t[3]   FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-c[3] FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-n[3] FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-x[3] FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-a[3] FORMAT {1} "yes /no  " /{1}**/ {2} SPACE(0)
    qbf-m[3] FORMAT "x(45)" NO-ATTR-SPACE SKIP
  qbf-t[4]   FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-c[4] FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-n[4] FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-x[4] FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-a[4] FORMAT {1} "yes /no  " /{1}**/ {2} SPACE(0)
    qbf-m[4] FORMAT "x(45)" NO-ATTR-SPACE SKIP
  qbf-t[5]   FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-c[5] FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-n[5] FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-x[5] FORMAT {1} "yes /no  " /{1}**/ {2}
    qbf-a[5] FORMAT {1} "yes /no  " /{1}**/ {2} SPACE(0)
    qbf-m[5] FORMAT "x(45)" NO-ATTR-SPACE SKIP
  HEADER
  qbf-v FORMAT "x(65)" SKIP(1) /*"For field:"*/
  /*12:"Perform these actions:" 13:"When these fields change value:"*/
  qbf-lang[12] FORMAT "x(29)" qbf-lang[13] FORMAT "x(46)" NO-ATTR-SPACE SKIP
  WITH FRAME qbf-accum ROW 5 CENTERED ATTR-SPACE NO-LABELS OVERLAY.

PAUSE 0.
DISPLAY
  qbf-m[1 FOR 5] qbf-lang[14 FOR 2]
  "" WHEN                      NOT qbf-r @ qbf-t[6]
  "" WHEN                      NOT qbf-s @ qbf-n[6]
  "" WHEN                      NOT qbf-s @ qbf-x[6]
  "" WHEN                      NOT qbf-r @ qbf-a[6]
  "" WHEN qbf-order[1] = "" OR NOT qbf-r @ qbf-t[1]
  "" WHEN qbf-order[1] = ""              @ qbf-c[1]
  "" WHEN qbf-order[1] = "" OR NOT qbf-s @ qbf-n[1]
  "" WHEN qbf-order[1] = "" OR NOT qbf-s @ qbf-x[1]
  "" WHEN qbf-order[1] = "" OR NOT qbf-r @ qbf-a[1]
  "" WHEN qbf-order[2] = "" OR NOT qbf-r @ qbf-t[2]
  "" WHEN qbf-order[2] = ""              @ qbf-c[2]
  "" WHEN qbf-order[2] = "" OR NOT qbf-s @ qbf-n[2]
  "" WHEN qbf-order[2] = "" OR NOT qbf-s @ qbf-x[2]
  "" WHEN qbf-order[2] = "" OR NOT qbf-r @ qbf-a[2]
  "" WHEN qbf-order[3] = "" OR NOT qbf-r @ qbf-t[3]
  "" WHEN qbf-order[3] = ""              @ qbf-c[3]
  "" WHEN qbf-order[3] = "" OR NOT qbf-s @ qbf-n[3]
  "" WHEN qbf-order[3] = "" OR NOT qbf-s @ qbf-x[3]
  "" WHEN qbf-order[3] = "" OR NOT qbf-r @ qbf-a[3]
  "" WHEN qbf-order[4] = "" OR NOT qbf-r @ qbf-t[4]
  "" WHEN qbf-order[4] = ""              @ qbf-c[4]
  "" WHEN qbf-order[4] = "" OR NOT qbf-s @ qbf-n[4]
  "" WHEN qbf-order[4] = "" OR NOT qbf-s @ qbf-x[4]
  "" WHEN qbf-order[4] = "" OR NOT qbf-r @ qbf-a[4]
  "" WHEN qbf-order[5] = "" OR NOT qbf-r @ qbf-t[5]
  "" WHEN qbf-order[5] = ""              @ qbf-c[5]
  "" WHEN qbf-order[5] = "" OR NOT qbf-s @ qbf-n[5]
  "" WHEN qbf-order[5] = "" OR NOT qbf-s @ qbf-x[5]
  "" WHEN qbf-order[5] = "" OR NOT qbf-r @ qbf-a[5]
  WITH FRAME qbf-accum.
PUT SCREEN ROW 9 COLUMN 32 " ".

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  UPDATE
    qbf-t[6] WHEN                        qbf-r
    qbf-c[6]
    qbf-n[6] WHEN                        qbf-s
    qbf-x[6] WHEN                        qbf-s
    qbf-a[6] WHEN                        qbf-r
    qbf-t[1] WHEN qbf-order[1] <> "" AND qbf-r
    qbf-c[1] WHEN qbf-order[1] <> ""
    qbf-n[1] WHEN qbf-order[1] <> "" AND qbf-s
    qbf-x[1] WHEN qbf-order[1] <> "" AND qbf-s
    qbf-a[1] WHEN qbf-order[1] <> "" AND qbf-r
    qbf-t[2] WHEN qbf-order[2] <> "" AND qbf-r
    qbf-c[2] WHEN qbf-order[2] <> ""
    qbf-n[2] WHEN qbf-order[2] <> "" AND qbf-s
    qbf-x[2] WHEN qbf-order[2] <> "" AND qbf-s
    qbf-a[2] WHEN qbf-order[2] <> "" AND qbf-r
    qbf-t[3] WHEN qbf-order[3] <> "" AND qbf-r
    qbf-c[3] WHEN qbf-order[3] <> ""
    qbf-n[3] WHEN qbf-order[3] <> "" AND qbf-s
    qbf-x[3] WHEN qbf-order[3] <> "" AND qbf-s
    qbf-a[3] WHEN qbf-order[3] <> "" AND qbf-r
    qbf-t[4] WHEN qbf-order[4] <> "" AND qbf-r
    qbf-c[4] WHEN qbf-order[4] <> ""
    qbf-n[4] WHEN qbf-order[4] <> "" AND qbf-s
    qbf-x[4] WHEN qbf-order[4] <> "" AND qbf-s
    qbf-a[4] WHEN qbf-order[4] <> "" AND qbf-r
    qbf-t[5] WHEN qbf-order[5] <> "" AND qbf-r
    qbf-c[5] WHEN qbf-order[5] <> ""
    qbf-n[5] WHEN qbf-order[5] <> "" AND qbf-s
    qbf-x[5] WHEN qbf-order[5] <> "" AND qbf-s
    qbf-a[5] WHEN qbf-order[5] <> "" AND qbf-r
    WITH FRAME qbf-accum.
END.

HIDE FRAME qbf-accum NO-PAUSE.

RETURN.
