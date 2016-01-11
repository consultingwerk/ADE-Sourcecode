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

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/reshlp.i   }
{ adecomm/adestds.i }

/* file info, field info, order info */
DEFINE VARIABLE qbf-a  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-c  AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-e  AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-f  AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i  AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j  AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-k  AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l  AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-p  AS INTEGER   NO-UNDO.

DEFINE VARIABLE info   AS CHARACTER NO-UNDO.
DEFINE VARIABLE usage  AS CHARACTER NO-UNDO.

DEFINE BUTTON qbf-ok   LABEL "OK"    {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-help LABEL "&Help" {&STDPH_OKBTN}.
/* standard button rectangle */
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.

FORM
  SKIP({&TFM_WID})
  info AT 2 
    VIEW-AS EDITOR INNER-CHARS 68 INNER-LINES 20 
    SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL NO-LABEL

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &HELP   = qbf-help}

  WITH FRAME qbf-info SIDE-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ok  
  TITLE "Query Information":t32 VIEW-AS DIALOG-BOX.

/*-----------------------------Triggers---------------------------------*/

ON HELP OF FRAME qbf-info OR CHOOSE OF qbf-help IN FRAME qbf-info
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Query_Description_Dlg_Box},?).

ON WINDOW-CLOSE OF FRAME qbf-info
  APPLY "END-ERROR":u TO SELF.

/*----------------------------Mainline---------------------------------*/

IF NUM-ENTRIES(qbf-tables) = 0 THEN DO:
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
    "You have not yet selected any tables!").
  RETURN.
END.

/* convert WHERE clauses to printable format and place in qbf-wask */
RUN aderes/s-ask.p ("", FALSE, INPUT-OUTPUT qbf-a).

/* query name */
IF qbf-name <> "" THEN
  info = info + qbf-name + CHR(10)
        + FILL("-":u,LENGTH(qbf-name,"CHARACTER":u)) + CHR(10).

/* timing stuff */
IF qbf-timing <> "" THEN
  info = info
        + "Elapsed time of last Report Run":t40 + ": ":u + qbf-timing
        + " (":u + "minutes":t12 + ":":u + "seconds":t12 + ")":u + CHR(10).

/* data governor */
IF qbf-governor > 0 THEN
  info = info
       + "Data governor record limit":t40 + ": ":u
       + STRING(qbf-governor) + CHR(10).
       
/* connected databases */
info = info + CHR(10)
     + "Connected databases":t40 + ": ":u
     + qbf-dbs + CHR(10).
     
IF info <> "" THEN info = info + CHR(10).

DO qbf-i = 1 TO NUM-ENTRIES(qbf-tables):
  qbf-p = INTEGER(ENTRY(qbf-i,qbf-tables)).
  {&FIND_TABLE_BY_ID} qbf-p.

  info = info
        + "Table":t10 + " #":u + STRING(qbf-i)
        + ": ":u + qbf-rel-buf.tname
        + CHR(10).

  FIND FIRST qbf-where WHERE qbf-where.qbf-wtbl = qbf-p NO-ERROR.

  /* This sneaky little loop means we only need to include the wrap */
  /* code once to cover both the relation-clause (qbf-wrel) and the */
  /* where-clause (qbf-where.qbf-wask).                             */
  DO qbf-j = 1 TO 2 WHILE AVAILABLE qbf-where:
    qbf-c = (IF qbf-j = 1 THEN qbf-where.qbf-wrel ELSE qbf-where.qbf-wask).
    IF qbf-c = "" THEN NEXT.
    ASSIGN
      qbf-c = STRING(qbf-j = 1,"Relation":t12 + "/":u + "Where":t12)
            + ": ":u + qbf-c
      qbf-p = INDEX(qbf-c,":":u). /* how far to indent subsequent lines */

    /* wrap text at 70 columns */
    DO WHILE LENGTH(qbf-c,"RAW":u) > 70:
      ASSIGN
        qbf-k = R-INDEX(SUBSTRING(qbf-c,1,70,"FIXED":u)," ":u)
        qbf-k = (IF qbf-k < 11 THEN 70 ELSE qbf-k)
        info = info + SUBSTRING(qbf-c,1,qbf-k,"FIXED":u) + CHR(10)
        qbf-c = FILL(" ":u,qbf-p) + SUBSTRING(qbf-c,qbf-k + 1,-1,"CHARACTER":u).
    END.
    IF qbf-c <> "" THEN 
      info = info + qbf-c + CHR(10).
  END.

  IF qbf-i < NUM-ENTRIES(qbf-tables) THEN
    info = info + CHR(10).
END.

DO qbf-i = 1 TO NUM-ENTRIES(qbf-sortby):
  info = info + "  ":u
        + TRIM(STRING(qbf-i = 1,"Order By" + "/":u + "And By"))
        + ": ":u + ENTRY(qbf-i,qbf-sortby) + CHR(10).
END.
IF qbf-sortby <> "" THEN info = info + CHR(10).

DO qbf-i = 1 TO qbf-rc#:
  IF qbf-i > 1 THEN info = info + CHR(10).

  ASSIGN
    qbf-j = INDEX("rpcsdnlex":u,SUBSTRING(qbf-rcc[qbf-i],1,1,"CHARACTER":u))
    qbf-c = "  Expression" + ": ":u
          + (IF qbf-j = 1 OR qbf-j = 2 THEN
              ENTRY(2,qbf-rcn[qbf-i])
            ELSE IF qbf-j = 3 THEN
              "FROM" + " ":u + ENTRY(2,qbf-rcn[qbf-i]) + " ":u
              + "BY" + " ":u  + ENTRY(3,qbf-rcn[qbf-i])
            ELSE IF qbf-j = 8 THEN
              ENTRY(2,qbf-rcn[qbf-i]) + "[1 FOR ":u
              + SUBSTRING(qbf-rcc[qbf-i],2,-1,"CHARACTER":u) + "]":u
            ELSE IF qbf-j > 0 THEN
              SUBSTRING(qbf-rcn[qbf-i],INDEX(qbf-rcn[qbf-i],",":u) + 1,-1,
                        "CHARACTER":u)
            ELSE
              qbf-rcn[qbf-i]
            ).

  qbf-e = qbf-rcf[qbf-i]. 
  IF STRING(0,"9.":u) = "0,":u THEN
    RUN comma_swap (INPUT-OUTPUT qbf-e). 

  info = info
        + "Field #" + STRING(qbf-i) + ': "':u + qbf-rcl[qbf-i]
        + '" (':u + ENTRY(qbf-rct[qbf-i],qbf-dtype)
        + (IF qbf-j = 0 THEN "" ELSE ", ":u + ENTRY(qbf-j + 1,qbf-etype))
        + ', "':u + qbf-e + '")':u + CHR(10).

  /* wrap text at 70 columns */
  DO WHILE LENGTH(qbf-c,"RAW":u) > 70:
    ASSIGN
      qbf-k = R-INDEX(SUBSTRING(qbf-c,1,70,"FIXED":u)," ":u)
      qbf-k = (IF qbf-k < 8 THEN 70 ELSE qbf-k)
      info = info + SUBSTRING(qbf-c,1,qbf-k,"FIXED":u) + CHR(10)
      qbf-c = "     " + "  ":u + SUBSTRING(qbf-c,qbf-k + 1,-1,"CHARACTER":u).
  END.
  IF qbf-c <> "" THEN info = info + qbf-c + CHR(10).

END.

/* add label field list to info stuff - dma */
RUN aderes/l-verify.p (FALSE, OUTPUT qbf-i, OUTPUT qbf-f).
info = info + CHR(10) + qbf-f.

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME qbf-info" 
   &BOX   = "rect_Btns"
   &OK    = "qbf-OK" 
   &HELP  = "qbf-Help"
}

ASSIGN
  info:SCREEN-VALUE IN FRAME qbf-info = info
  info:READ-ONLY    IN FRAME qbf-info = TRUE.

ENABLE info qbf-ok qbf-help WITH FRAME qbf-info.

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  WAIT-FOR CHOOSE OF qbf-ok IN FRAME qbf-info OR GO OF FRAME qbf-info.
END.

HIDE FRAME qbf-info NO-PAUSE.

RETURN.

/*--------------------------------------------------------------------------*/
/* sub-proc to convert format from ".," to ",." and back */
{ aderes/p-comma.i }

/* s-info.p - end of file */

