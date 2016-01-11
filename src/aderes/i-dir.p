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
 *  i-dir.p - selection list for query directory
 *
 *  output
 *
 *    queryIndex     The index of the arrays that represent the user 
 *                   selection.
 */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/i-define.i }
{ adecomm/adestds.i }
{ aderes/_fdefs.i }
{ aderes/reshlp.i } 

DEFINE OUTPUT PARAMETER queryIndex AS INTEGER NO-UNDO INITIAL 0.

/*
 * Some of the things needed to be known about the query directory code.
 *
 *  1. There is an array that holds all of the entries of the currently
 *     selected query directory.
 *
 *  2. When you change directories you change the array.
 *
 *  3. The user is allowed to see the queries of other databases. The
 *     array has all of the queries, including these. Because of this the 
 *     selection list used to display queries may not be 1 to 1. Therefore
 *     this code has to spend time looping through the array to match
 *     current selection with array index.
 *
 *  4. The array index is not the value of the QUEnnnnn.p. There is
 *     an indirection from array slot to query file number.
 */

DEFINE VARIABLE qbf-a         AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-b         AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c         AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-d         AS CHARACTER NO-UNDO. /* directory file */
DEFINE VARIABLE qbf-i         AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-j         AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-m         AS LOGICAL   NO-UNDO. /* change qbf-qdfile */
DEFINE VARIABLE qbf-s         AS CHARACTER NO-UNDO. /* selection list */

DEFINE VARIABLE fullLine      AS CHARACTER NO-UNDO.
DEFINE VARIABLE readable      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE readOtherDir  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE readPublicDir AS LOGICAL   NO-UNDO.
DEFINE VARIABLE writable      AS LOGICAL   NO-UNDO.

DEFINE BUTTON qbf-au   LABEL "D&irectory..."     SIZE 20 BY 1.
DEFINE BUTTON qbf-pd   LABEL "Public &Directory" SIZE 20 BY 1.
DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"  {&STDPH_OKBTN}.

/* standard button rectangle */
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.

/*=====================Frame Layout (form and code)=======================*/

FORM
  SKIP({&TFM_WID})
  qbf-s  AT 2 NO-LABEL 
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 42 INNER-LINES 12
    SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL
  SKIP({&VM_WID})

  qbf-qdshow AT 2
    LABEL "&Show Queries on Disconnected Databases"
    VIEW-AS TOGGLE-BOX FORMAT "yes/no":u

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  qbf-c AT COLUMN 4 ROW 3 FORMAT "x(20)":u NO-LABEL VIEW-AS TEXT 
  SKIP({&VM_WID})
  
  qbf-pd 
  SKIP({&VM_WID})
  
  qbf-au 
  SKIP({&VM_WID})

  WITH FRAME qbf-qdir SIDE-LABELS THREE-D
  TITLE " ":u DEFAULT-BUTTON qbf-Ok CANCEL-BUTTON qbf-ee 
  VIEW-AS DIALOG-BOX.

/*================================Triggers================================*/

ON HELP OF FRAME qbf-qdir OR CHOOSE OF qbf-help IN FRAME qbf-qdir
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Open_Dlg_Box},?).

ON GO OF FRAME qbf-qdir DO:
  IF qbf-s:SCREEN-VALUE = ? THEN RETURN.

  /*
   * Find the query index that the represents the query chosen by the 
   * user. Note that a user may be able to see a disconnected query,
   * but can't open it. So use a side-affect of the display of
   * disconnected queries to know that the query is disconnected. THe
   * value in the selection is something like "aaaa (db1,db2)" whereas
   * the name in the datastructure is "aaaa". So if we go through the
   * array and don't find any name then the user has clicked on a
   * disconnected database.
   */

  DO qbf-i = 1 TO EXTENT(qbf-dir-ent) WHILE queryindex = 0:
    IF qbf-s:SCREEN-VALUE = qbf-dir-ent[qbf-i] THEN
      queryindex = qbf-i.
  END.

  IF queryIndex = 0 THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
      SUBSTITUTE("&1 has disconnected database(s). It cannot be opened.",
      SUBSTRING(qbf-s:SCREEN-VALUE,1,
                R-INDEX(qbf-s:SCREEN-VALUE,"(":u) - 1,"CHARACTER":u))).

    RETURN NO-APPLY.
  END.
END.

ON DEFAULT-ACTION OF qbf-s
  APPLY "GO":u TO FRAME qbf-qdir.

/*----- PUBLIC DIRECTORY BUTTON -----*/
ON CHOOSE OF qbf-pd IN FRAME qbf-qdir DO:
  ASSIGN
    qbf-d = (IF qbf-qdfile <> qbf-qdpubl THEN qbf-qdpubl ELSE qbf-qdhome)
    qbf-m = TRUE.
      
END.

/*----- ANOTHER USER BUTTON -----*/
ON CHOOSE OF qbf-au IN FRAME qbf-qdir DO:
  hook:
  DO ON STOP UNDO hook, RETRY hook:
    IF RETRY THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
        SUBSTITUTE("There is a problem with &1.  &2 cannot change directories.  This feature will no longer be available.",
        _dirSwitch,qbf-product)).

      ASSIGN
        qbf-au:SENSITIVE IN FRAME qbf-qdir = FALSE
        _dirSwitch                         = ?.

      LEAVE hook.
    END.
       
    RUN VALUE(_dirSwitch) (INPUT-OUTPUT qbf-d, OUTPUT qbf-a).

    IF NOT qbf-a THEN 
       RETURN NO-APPLY. 

    ASSIGN qbf-c = SUBSTRING(
                 IF qbf-d MATCHES "*Public*" THEN
                    IF USERID("RESULTSDB":u) = "" THEN "Personal"
                    ELSE            
                       USERID("RESULTSDB":u) + "'s"
                 ELSE "Public"
                ,1,8,"FIXED":u) + " ":u + "&Directory"
           qbf-c = FILL(" ":u,INTEGER(10 - LENGTH(qbf-c,"RAW":u) / 2)) + qbf-c
           qbf-pd:LABEL IN FRAME qbf-qdir = STRING(qbf-c,"x(20)":u)
    .

    qbf-m = true.
  END.
END.

/*----- VALUE CHANGED -----*/
ON VALUE-CHANGED OF qbf-qdshow IN FRAME qbf-qdir DO:
  qbf-qdshow = INPUT FRAME qbf-qdir qbf-qdshow.

  DO qbf-i = 1 to extent(qbf-dir-ent):
    IF NOT qbf-dir-flg[qbf-i] AND qbf-dir-ent[qbf-i] <> "" THEN DO:

      /* we'll show the names of the other databases for the
       * disconnected databases */
      fullLine = qbf-dir-ent[qbf-i] + " (" + qbf-dir-dbs[qbf-i] + ")".

      IF NOT qbf-qdshow THEN
        /*
         * Use the text version to delete, since other things may have
         * been deleted making the numbers obsolete.
         */
        qbf-a = qbf-s:DELETE(fullLine).

      ELSE IF qbf-i > qbf-s:NUM-ITEMS THEN
        qbf-a = qbf-s:ADD-LAST(fullLine).
      ELSE
        /* Insert the entry using the *number* version of insert. */
        qbf-a = qbf-s:INSERT(fullLine, qbf-i).
    END.
  END.
END.

ON WINDOW-CLOSE OF FRAME qbf-qdir
  APPLY "END-ERROR":u TO SELF.             

/*===========================Mainline Code===============================*/

ASSIGN
  qbf-s:DELIMITER IN FRAME qbf-qdir    = CHR(10)
  qbf-c                                = "Switch listing to:":t20
  qbf-c:SCREEN-VALUE IN FRAME qbf-qdir = qbf-c
  qbf-i                                = qbf-s:WIDTH-PIXELS IN FRAME qbf-qdir
                                       + qbf-s:X IN FRAME qbf-qdir + 6
  qbf-c:X IN FRAME qbf-qdir            = qbf-i
  qbf-pd:X IN FRAME qbf-qdir           = qbf-i
  qbf-au:X IN FRAME qbf-qdir           = qbf-i

  FRAME qbf-qdir:WIDTH-PIXELS          = qbf-au:WIDTH-PIXELS IN FRAME qbf-qdir
                                       + qbf-i + 18.

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
  &FRAME = "FRAME qbf-qdir" 
  &BOX   = "rect_btns"
  &OK    = "qbf-ok" 
  &HELP  = "qbf-help"
}  

RUN adeshar/_mgetfs.p({&resId}, {&rfReadPublicDir}, OUTPUT readPublicDir).
RUN adeshar/_mgetfs.p({&resId}, {&rfReadOtherDir}, OUTPUT readOtherDir).
  
qbf-d = qbf-qdfile.

/*
 * Load up the selection list. Make sure the list has the proper set
 * of things. If the user has previously selected Show Disconnected
 * Queries then they have got to be loaded also.
 */

DO qbf-i = 1 TO extent(qbf-dir-ent):
  IF qbf-dir-ent[qbf-i] = "" THEN NEXT.
  IF (qbf-dir-flg[qbf-i] = FALSE) AND (qbf-qdshow = FALSE) THEN NEXT.

  IF qbf-dir-flg[qbf-i] = FALSE THEN
    fullLine = qbf-dir-ent[qbf-i] + " (" + qbf-dir-dbs[qbf-i] + ")".
  ELSE
    fullLine = qbf-dir-ent[qbf-i].

  qbf-a = qbf-s:ADD-LAST(fullLine) IN FRAME qbf-qdir.
END.

ENABLE qbf-s qbf-pd qbf-au qbf-qdshow qbf-ok qbf-ee qbf-help
  WITH FRAME qbf-qdir.

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  /* Does user have permission to see the current query directory? */
  RUN aderes/_ifile.p(qbf-d, OUTPUT readable, OUTPUT writable, OUTPUT qbf-a).

  ASSIGN
    _qdWritable                               = writable
    _qdReadable                               = readable

    qbf-c = SUBSTRING(
          IF qbf-d MATCHES "*Public*" THEN
             IF USERID("RESULTSDB":u) = "" THEN "Personal"
             ELSE            
                USERID("RESULTSDB":u) + "'s"
             ELSE "Public"
             ,1,8,"FIXED":u) + " ":u + "&Directory"
    qbf-c = FILL(" ":u,INTEGER(10 - LENGTH(qbf-c,"RAW":u) / 2)) + qbf-c
    qbf-pd:LABEL IN FRAME qbf-qdir            = qbf-c

    qbf-s:SCREEN-VALUE IN FRAME qbf-qdir      = qbf-s
    qbf-qdshow:SCREEN-VALUE IN FRAME qbf-qdir = STRING(qbf-qdshow,"yes/no":u)

    FRAME qbf-qdir:TITLE = "Open" + " - ":u + qbf-qdfile
  .

  IF qbf-s:NUM-ITEMS > 0 THEN
    qbf-s:SCREEN-VALUE = qbf-s:ENTRY(1).

  /* We can read another directory if we have permission and there is a
   * directory switching program */
  qbf-au:SENSITIVE IN FRAME qbf-qdir = (readOtherDir AND _dirSwitch <> ?).
  qbf-pd:SENSITIVE IN FRAME qbf-qdir = (readPublicDir).

  VIEW FRAME qbf-qdir.

  WAIT-FOR CHOOSE OF qbf-ok, qbf-pd, qbf-au IN FRAME qbf-qdir
    OR     GO     OF                           FRAME qbf-qdir
    FOCUS qbf-s IN FRAME qbf-qdir.

  IF qbf-m THEN DO:
    RUN adecomm/_setcurs.p("WAIT":u).

    ASSIGN
      qbf-c            = qbf-d
      qbf-qdfile       = qbf-d
      qbf-s:LIST-ITEMS = ""
    .

    RUN aderes/i-read.p (INPUT-OUTPUT qbf-c).
        
    IF qbf-d MATCHES "*Public*" AND qbf-c = ? THEN DO: 
       qbf-c = "The PUBLIC.QD7 file was not found".
          
       RUN create_public_qd7 (INPUT qbf-c, OUTPUT qbf-b).
     END.
     
    IF qbf-d MATCHES "*Public*" THEN
       qbf-qdpubl = qbf-d.

    /*
     * BTW: If there was no file out there it is no big deal.
     *  And don't print out an error. It is ok
     * for a user not to have a file or a file with 0 queries. When
     * was the last time you did a cd on your favorite operating
     * system and got an warning if the directory was empty.
     */

    IF qbf-dir-ent# > 0 THEN DO:
      qbf-m = FALSE.

      DO qbf-i = 1 TO EXTENT(qbf-dir-ent):
        IF qbf-dir-ent[qbf-i] = "" THEN NEXT.
        IF (qbf-dir-flg[qbf-i] = FALSE) AND (qbf-qdshow = FALSE) THEN NEXT.

        IF qbf-dir-flg[qbf-i] = FALSE THEN
          fullLine = qbf-dir-ent[qbf-i] + " (" + qbf-dir-dbs[qbf-i] + ")".
        else
          fullLine = qbf-dir-ent[qbf-i].

        qbf-a = qbf-s:ADD-LAST(fullLine) IN FRAME qbf-qdir.
      END.
    END.
    RUN adecomm/_setcurs.p ("").
    UNDO,RETRY.
  END.
END.

HIDE FRAME qbf-qdir NO-PAUSE.
RETURN.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
 
PROCEDURE create_public_qd7:
  DEFINE INPUT  PARAMETER qbf_c       AS CHARACTER       NO-UNDO.
  DEFINE OUTPUT PARAMETER qbf_abort   AS LOGICAL         NO-UNDO.

  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"warning":u,"ok-cancel":u,
    SUBSTITUTE("&1. ^^Choose OK to create one in your local directory.^^You can search for an existing PUBLIC.QD7 by selecting the 'Directory...' button.",qbf_c)). 
                                          
  /*
   * If no then, user has option to locate PUBLIC.QD7 using Directory... button.
   * If true, then create PUBLIC.QD7 in user's home directory.
   */                                                          
   
  IF qbf-a = ? THEN
     qbf_abort = TRUE.
  ELSE DO:
    RUN aderes/i-write (?). /*rebuild directory file */
    ASSIGN qbf-c = SUBSTRING(
                   IF qbf-d MATCHES "*Public*" THEN
                      IF USERID("RESULTSDB":u) = "" THEN "Personal"
                      ELSE            
                         USERID("RESULTSDB":u) + "'s"
                   ELSE "Public"
                ,1,8,"FIXED":u) + " ":u + "&Directory"
           qbf-c = FILL(" ":u,INTEGER(10 - LENGTH(qbf-c,"RAW":u) / 2)) + qbf-c
           qbf-pd:LABEL IN FRAME qbf-qdir = STRING(qbf-c,"x(20)":u)
    .                                                                          

  END. 

END PROCEDURE.

/* i-dir.p - end of file */

