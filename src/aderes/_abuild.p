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
 * _abuild.p - application rebuild
 */

&GLOBAL-DEFINE WIN95-BTN YES
{ aderes/i-define.i }
{ aderes/j-define.i }
{ aderes/s-system.i }
{ adecomm/adestds.i }
{ aderes/s-menu.i }
{ aderes/reshlp.i }

DEFINE VARIABLE qbf-a AS CHARACTER NO-UNDO. /* rebuild errors */
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-e AS INTEGER   NO-UNDO. /* rebuild errors */
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-l AS LOGICAL   NO-UNDO. /* query OK */
DEFINE VARIABLE qbf-n AS CHARACTER NO-UNDO. /* current query */
DEFINE VARIABLE qbf-p AS CHARACTER NO-UNDO. /* PROPATH temp. */
DEFINE VARIABLE qbf-q AS CHARACTER NO-UNDO. /* full query name */
DEFINE VARIABLE qbf-s AS INTEGER   NO-UNDO. /* successful rebuilds */
DEFINE VARIABLE qbf-t AS CHARACTER NO-UNDO. /* nnn OF ttt */

DEFINE VARIABLE qbf-r AS INTEGER   NO-UNDO VIEW-AS RADIO-SET VERTICAL
  RADIO-BUTTONS "Rebuild Configuration and All &Query Files", 1,
                "Rebuild &Configuration File Only", 2.

DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"  {&STDPH_OKBTN}.
/* standard button rectangle */
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.

FORM
  "Rebuilding Query:":t20 AT 2 
    qbf-n AT 30 VIEW-AS TEXT FORMAT "x(48)":u SPACE(1) SKIP
  "Query OS File:":t20    AT 2 
    qbf-q AT 30 VIEW-AS TEXT FORMAT "x(48)":u SKIP(1)
  "Working On Query:":t20 AT 2 
    qbf-t AT 30 VIEW-AS TEXT FORMAT "x(48)":u SKIP
  "Aborted Rebuilds:":t20 AT 2 
    qbf-a AT 30 VIEW-AS TEXT SKIP
  WITH FRAME build-stat NO-ATTR-SPACE ROW 6 OVERLAY NO-LABELS /*FONT 0*/.
  
FORM
  SKIP({&TFM_WID})
  qbf-r AT 2 
    
  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help }

  WITH FRAME qbf-build NO-ATTR-SPACE NO-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  TITLE "Application Rebuild" VIEW-AS DIALOG-BOX.

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
  &FRAME = "FRAME qbf-build" 
  &BOX   = "rect_btns"
  &OK    = "qbf-ok" 
  &HELP  = "qbf-help"
}
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

ON HELP OF FRAME qbf-build OR CHOOSE OF qbf-help IN FRAME qbf-build
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u, 
                          {&Application_Rebuild_Dlg_Box}, ?).

ON GO OF FRAME qbf-build DO:
  RUN adecomm/_setcurs.p ("WAIT":u).
  
  /*
   * Workaround note: The following works around a problem. At this time,
   * the app rebuild
   * gets the relationship information from the .qc7 file. There's
   * a case where the temp tables could be out of synch with the qc7 file.
   * This happens whne the user changes a rel, leaves the dbox
   * (with the write-on-dbox-exit-flag OFF), and then chosses app rebuild.
   * Those changes to the rels would be lost.
   *
   * This is, however, a corner case. We don't expect that scenario
   * to occur that often. So the fix to the problem is to write out
   * the qc7 file  before starting the rebuild This will add some time to
   * the rebuild, but since this is a corner case, the user shouldn't
   * run into it very often.
   */
          
  IF _configDirty THEN
    RUN aderes/_awrite.p (2).
  
  RUN adecomm/_statdsp.p (wGlbStatus, 1, 
                          "Rebuilding table relationships...":t72).
  RUN aderes/j-init.p (?).   /* get list of tables into qbf-rel-buf */
  RUN aderes/j-find.p.       /* find implied OF-style relationships */

  /* Rebuild the aliases, they got destroyed when qbf-rel-tt was zapped. */
  RUN adecomm/_statdsp.p (wGlbStatus, 1, "Rebuilding table aliases...":t72).
  RUN aderes/_abuilda.p.

  RUN aderes/_awrite.p (2).  /* write configuration file */
  RUN aderes/_afwrite.p (2).  /* write feature file */
  RUN aderes/_amwrite.p (2).  /* write menu file */

  RUN adecomm/_setcurs.p ("").
  
  IF INTEGER(qbf-r:SCREEN-VALUE IN FRAME qbf-build) = 1 THEN 
  DO WHILE TRUE:
    HIDE FRAME qbf-build. 

    /* select query directory */
    RUN aderes/u-direct.p (INPUT-OUTPUT qbf-qdfile, OUTPUT qbf-l).
    HIDE FRAME qbf-build NO-PAUSE.
   
    IF FRAME build-stat:THREE-D = FALSE AND SESSION:THREE-D = TRUE THEN
      FRAME build-stat:THREE-D = TRUE.

    ASSIGN
      FRAME build-stat:X       = CURRENT-WINDOW:WIDTH 
                               - (FRAME build-stat:WIDTH / 2)
      FRAME build-stat:TITLE   = "Query Rebuild Status"
                               + " - ":u + LC(qbf-qdfile)
      qbf-a                    = ""
      .
      
    DISPLAY qbf-a
      WITH FRAME build-stat.

    IF qbf-l THEN DO:
      RUN aderes/s-prefix.p (qbf-qdfile, OUTPUT qbf-c). /* get base path */
    
      ASSIGN
        qbf-e      = 0
        qbf-p      = PROPATH
        PROPATH    = qbf-c + qbf-p.
   
      RUN aderes/i-read.p (INPUT-OUTPUT qbf-qdfile). /* read user directory */
   
      qbf-t = STRING(qbf-dir-ent#).

      /* loop through queries in user directory */
      DO qbf-i = 1 TO EXTENT(qbf-dir-ent):
   
        IF qbf-dir-ent[qbf-i] = "" THEN NEXT. /* omit empty slots */
        
        RUN adecomm/_statdsp.p (wGlbStatus, 1, 
                               "Rebuilding query directory...":t72).
        RUN adecomm/_setcurs.p ("WAIT":u).
        
        DO ON ERROR UNDO, LEAVE:
   
          ASSIGN
            qbf-n = qbf-dir-ent[qbf-i]
            qbf-q = LC(qbf-c + "que":u
                             + STRING(qbf-dir-num[qbf-i],"99999":u) + ".p":u).

          IF SEARCH(qbf-q) = ? THEN 
            qbf-l = FALSE.

          /* repair queries for connected databases */
          ELSE IF qbf-dir-flg[qbf-i] THEN DO: 
            DISPLAY qbf-n qbf-q 
              (STRING(qbf-i) + " OF ":u 
                + STRING(qbf-dir-ent#) + " (":u
                + TRIM(STRING((qbf-i / qbf-dir-ent#) * 100, ">>9":u))
                + "%)":u) @ qbf-t
              WITH FRAME build-stat.
           
            RUN aderes/s-read.p (SEARCH(qbf-q),"build":u,OUTPUT qbf-l).
          END.
         
          /* Fatal build error - remove query from query directory */
          IF NOT qbf-l THEN DO:
            ASSIGN
              qbf-e = qbf-e + 1
              qbf-a = STRING(qbf-e).

              /* removed per bug #94-05-05-038 [english]
              qbf-dir-dbs[qbf-i] = ""
              qbf-dir-ent[qbf-i] = ""
              qbf-dir-num[qbf-i] = 0
              qbf-dir-flg[qbf-i] = FALSE
              */
              
            DISPLAY qbf-a
              WITH FRAME build-stat.
          END.
         
          /* write out rebuilt query to OS file */
          ELSE IF qbf-dir-flg[qbf-i] THEN
            RUN aderes/s-write.p (qbf-q, "s":u).
        END.

        RUN adecomm/_setcurs.p ("").
      END.

      RUN adecomm/_statdsp.p (wGlbStatus, 1, "").
      RUN aderes/i-write.p (?). /* rebuild directory file */
      
      PROPATH = qbf-p.
    END.
    ELSE LEAVE.
  END.
  
  HIDE FRAME build-stat NO-PAUSE.
  RUN adecomm/_statdsp.p (wGlbStatus, 1,"").
END. /* GO... */

ON WINDOW-CLOSE OF FRAME qbf-build 
  APPLY "END-ERROR":u TO SELF.

/*--------------------------------------------------------------------------*/
qbf-r = 1.

RUN adecomm/_statdsp.p (wGlbStatus, 1,"").
RUN adecomm/_statdsp.p (wGlbStatus, 2,"").

ENABLE ALL WITH FRAME qbf-build.

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  WAIT-FOR GO OF FRAME qbf-build.

  ASSIGN
    qbf-module = ?
    qbf-name   = ""
    qbf-qdfile = qbf-qdhome.

  RUN adecomm/_statdsp.p (wGlbStatus, 1,"").
END.

HIDE FRAME qbf-build NO-PAUSE.
RETURN.

/* _abuild.p - end of file */


