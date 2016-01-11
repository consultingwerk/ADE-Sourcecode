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
 * l-guess.p - make educated guess at the address fields for mailing label 
 */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }

DEFINE VARIABLE qbf-a AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-b AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-f AS CHARACTER NO-UNDO. /* dbname.filename */
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER   NO-UNDO INITIAL 1.
DEFINE VARIABLE qbf-m AS CHARACTER NO-UNDO. /* address layout map */
DEFINE VARIABLE qbf-o AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-p AS CHARACTER NO-UNDO. /* label field prefix */
DEFINE VARIABLE qbf-s AS INTEGER   NO-UNDO. /* sequence searched */
DEFINE VARIABLE qbf-t AS CHARACTER NO-UNDO EXTENT 10.
DEFINE VARIABLE tbNam AS CHARACTER NO-UNDO.

ASSIGN
  qbf-m      = "1|2|3|4|9|5, 6 7-8|0":u
  qbf-l-text = "".

DO qbf-o = 1 TO NUM-ENTRIES(qbf-tables): /* outer */
  {&FIND_TABLE_BY_ID} INTEGER(ENTRY(qbf-o, qbf-tables)).
  qbf-f = qbf-rel-buf.tname.

  DO qbf-i = 1 TO 10: /* inner */

    /* search out of sequence */
    /* search for zip+4 before zip */
    qbf-s = INTEGER(ENTRY(qbf-i,"1,2,3,4,5,6,8,7,9,10":u)).

    CREATE ALIAS "QBF$0" FOR DATABASE VALUE(SDBNAME(ENTRY(1,qbf-f,".":u))).
    RUN aderes/l-match.p (ENTRY(1,qbf-f,".":u),
                          ENTRY(2,qbf-f,".":u),qbf-l-auto[qbf-s],OUTPUT qbf-c).

    IF qbf-c = ""
      OR qbf-t[1] = qbf-c OR qbf-t[2] = qbf-c
      OR qbf-t[3] = qbf-c OR qbf-t[4] = qbf-c
      OR qbf-t[5] = qbf-c OR qbf-t[6] = qbf-c
      OR qbf-t[7] = qbf-c OR qbf-t[8] = qbf-c
      OR qbf-t[9] = qbf-c OR qbf-t[10] = qbf-c THEN NEXT.
    qbf-t[qbf-s] = qbf-c.
  END.

END. /* qbf-o/file loop */

RUN adecomm/_setcurs.p ("WAIT":u).

/*---------- 
   We really want this but the pause 2 doesn't work and this frame
   flashes and it looks dumb so just use wait cursor. 
   Due to bug 93-07-28-020 (pause doesn't work w/o status area).
DISPLAY SKIP(1) "  Setting up label fields...  " VIEW-AS TEXT SKIP(1) 
   WITH FRAME in_progress OVERLAY CENTERED ROW 6.
PAUSE 2 NO-MESSAGE. /* avoid message flashing too fast */
-------*/
/*
This code parses the label layout map in qbf-m.  Each number, from 1
through 0, denotes one of the field-name "matches" patterns for field
guessing.  Each "|" in the map means a newline.  Other text is stored,
and if the next symbol "0" to "9" ("0" = 10) is found, and the qbf-t[]
element contains something (meaning that the field-name matches pattern
succeded), then we insert both the prefix and the field into the output
array.  Otherwise, if the field-name slot in qbf-t[] does not contain a
field, we throw away the prefix.  This keeps us from doing stupid
things like including the "-" between the zip and zip+4 when there is
no zip+4 field present.  Any blank lines are squashed out.

The default map for USA is "1|2|3|4|9|5, 6  7-8|0", which is decoded to mean:

  line 1 gets field #1 (name)
  line 2 gets field #2 (address #1)
  line 3 gets field #3 (address #2)
  line 4 gets field #4 (address #3)
  line 5 gets field #9 (city-state-zip)
  line 6 gets field #6 (city),
    also ", " + field #7 (state) if present,
    also "  " + field #8 (zip) if present,
    also "-" + field #9 (zip+4) if present
  line 7 gets field #10 (country)

The old algorithm would omit fields 6 thru 9 when 5 was present.  This
new algorithm doesn't, and depends more on the sysadmin to set things up
sensibly.

Other address maps:

Argentina:
Austria:
Belgium:
Bulgaria:
Canada:
China:
Egypt:
Europe:
Finland:
France:
Germany:
Greece:
Hungary:
Hong Kong:
Iceland:
India:
Israel:
Italy:
Japan:
Korea:
Minsk:
Netherlands:
Portugal:
Russia:
Slovakia:
South Africa:
Spain:
Sweden:
Switzerland:
Taiwan:
Thailand:
Turkey:
United Kingdom:
United States:     1|2|3|4|9|5, 6  7-8|0
*/

ASSIGN
  qbf-p = ""
  qbf-l = 1.

DO qbf-i = 1 TO LENGTH(qbf-m,"CHARACTER":u):
  qbf-o = INDEX("1234567890":u,SUBSTRING(qbf-m,qbf-i,1,"CHARACTER":u)).
  IF SUBSTRING(qbf-m,qbf-i,1,"CHARACTER":u) = "|":u THEN
    ASSIGN
      qbf-l = qbf-l + 1
      qbf-p = "".
      
  ELSE
  IF qbf-o > 0 THEN DO:
    IF qbf-t[qbf-o] <> "" THEN DO:

      /* Can the user see this field? */
      qbf-a = true.
      IF _fieldCheck <> ? THEN DO:
        hook:
        DO ON STOP UNDO hook, RETRY hook:
          IF RETRY THEN DO:
            RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-b,"error":u,"ok":u,
              SUBSTITUTE("There is a problem with &1.  &2 will use default field security.",
              _fieldCheck,qbf-product)).
              
            _fieldCheck = ?.
            LEAVE hook.
          END.

          ASSIGN
            tbNam = qbf-t[qbf-o]
            qbf-c = ENTRY(1,tbNam,".":u) + ".":u + ENTRY(2,tbNam,".":u)
          .
   
          RUN VALUE(_fieldCheck) (qbf-c,
                                  ENTRY(3,tbNam,".":u), 
                                  USERID(ENTRY(1,tbNam,".":u)),
                                  OUTPUT qbf-a).
        END.
      END.

      IF qbf-a THEN
        qbf-l-text[qbf-l] = qbf-l-text[qbf-l]
                          + qbf-p
                          + qbf-left
                          + qbf-t[qbf-o]
                          + qbf-right.
    END.
    qbf-p = "". 
  END.
  ELSE
    qbf-p = qbf-p + SUBSTRING(qbf-m,qbf-i,1,"CHARACTER":u).
END.

/* squash out blank lines */
qbf-o = 0.
DO qbf-i = 1 TO EXTENT(qbf-l-text):
  IF qbf-l-text[qbf-i] <> "" THEN
    ASSIGN qbf-o = qbf-o + 1  qbf-l-text[qbf-o] = qbf-l-text[qbf-i].
END.
DO qbf-i = qbf-o + 1 TO EXTENT(qbf-l-text):
  qbf-l-text[qbf-i] = "".
END.

/* dma
DO qbf-i = 7 TO 1 BY -1:
  IF LENGTH(qbf-l-text[qbf-i],"RAW":u) <= 66 THEN NEXT.
  DO qbf-o = 7 TO qbf-i + 1 BY -1:
    qbf-l-text[qbf-o + 1] = qbf-l-text[qbf-o].
  END.
  qbf-o = R-INDEX(SUBSTRING(qbf-l-text[qbf-i],1,66,"CHARACTER":u),qbf-left).
  IF qbf-o = 0 THEN qbf-o = R-INDEX(qbf-l-text[qbf-i],qbf-left).
  ASSIGN
    qbf-l-text[qbf-i + 1] = SUBSTRING(qbf-l-text[qbf-i],qbf-o,-1,"CHARACTER":u)
    qbf-l-text[qbf-i]     = SUBSTRING(qbf-l-text[qbf-i],1,qbf-o - 1,
                                      "CHARACTER":u) + "~~".
  qbf-i = qbf-i + 1. /* retry current line 'recursively' */
END.
*/

RUN adecomm/_setcurs.p ("").
/* HIDE FRAME in_progress. */
IF qbf-l-text[1] = "" THEN
  MESSAGE "No fields could be found using the automatic search."
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

RETURN.

/*--------------------------------------------------------------------------*/
/* alias_to_tbname */
{ aderes/s-alias.i }

/*--------------------------------------------------------------------------*/

/* l-guess.p - end of file */

