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
 * i-opnsav.p - handler for "File->Open", "File->Save" and 
                  "File->Save As" events
 */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/i-define.i }
{ aderes/j-define.i }
{ aderes/_fdefs.i   }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

/* 1=Save-, 2=Save-As, 3=Open */
DEFINE INPUT  PARAMETER qbf-s AS INTEGER NO-UNDO. 

DEFINE OUTPUT PARAMETER queryIndex AS INTEGER NO-UNDO INITIAL 0.
DEFINE OUTPUT PARAMETER lRet       AS LOGICAL NO-UNDO. /* TRUE=cancelled */

DEFINE VARIABLE qbf-a AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-b AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-d AS CHARACTER NO-UNDO. /* directory name */
DEFINE VARIABLE qbf-f AS CHARACTER NO-UNDO. /* directory name */
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO. /* scrap/loop */
DEFINE VARIABLE qbf-m AS LOGICAL   NO-UNDO. /* change qbf-qdfile */
DEFINE VARIABLE qbf-r AS INTEGER   NO-UNDO. /* slot in qbf-dir-ent[] */

DEFINE VARIABLE r-pos           AS INTEGER   NO-UNDO.
DEFINE VARIABLE prefix          AS CHARACTER NO-UNDO.
DEFINE VARIABLE queryFileNumber AS INTEGER   NO-UNDO.
DEFINE VARIABLE querySelList    AS CHARACTER NO-UNDO. /* selection list */
DEFINE VARIABLE switchText      AS CHARACTER NO-UNDO.
DEFINE VARIABLE readable        AS LOGICAL   NO-UNDO INITIAL ?.
DEFINE VARIABLE writable        AS LOGICAL   NO-UNDO INITIAL ?.
DEFINE VARIABLE fullLine        AS CHARACTER NO-UNDO.
/*
DEFINE VARIABLE readOtherDir    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE readPublicDir   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE writeOtherDir   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE writePublicDir  AS LOGICAL   NO-UNDO.
*/

DEFINE BUTTON qbf-au   LABEL "D&irectory..."     SIZE 24 BY 1.
DEFINE BUTTON qbf-pd   LABEL "Public &Directory" SIZE 24 BY 1.
DEFINE BUTTON qbf-ok   LABEL "OK"                {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel"            {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"             {&STDPH_OKBTN}.

/* standard button rectangle */
DEFINE RECTANGLE rect_btns                       {&STDPH_OKBOX}.

DEFINE TEMP-TABLE qbf-w NO-UNDO /* used to temp save wask-clauses */
  FIELD qbf-n AS INTEGER
  FIELD qbf-t AS CHARACTER.

FORM
  SKIP({&TFM_WID})
  "Description of &Query:":t40 AT 2  VIEW-AS TEXT
  SKIP({&VM_WID})
  
  qbf-name FORMAT "x(48)":u AT 2 {&STDPH_FILL}
    VIEW-AS FILL-IN SIZE 42 BY 1
  SKIP({&VM_WID})

  querySelList AT 2 NO-LABEL 
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 45 INNER-LINES 12
    SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL
  SKIP({&VM_WID})
  
  qbf-qdshow AT 2
    LABEL "&Show Queries on Disconnected Databases"
    VIEW-AS TOGGLE-BOX FORMAT "yes/no"

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  switchText FORMAT "x(25)":u AT COLUMN 52 ROW-OF qbf-name + 2 
    VIEW-AS TEXT
  SKIP({&VM_WID})

  qbf-pd AT COLUMN 52 ROW-OF switchText + 1
  SKIP({&VM_WID})
  
  qbf-au AT COLUMN-OF qbf-pd ROW-OF qbf-pd + 1.1
  SKIP({&VM_WID})

  WITH FRAME qbf-nframe NO-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  TITLE qbf-d VIEW-AS DIALOG-BOX.

/*--------------------------------------------------------------------------*/

ON CHOOSE OF qbf-pd IN FRAME qbf-nframe DO:
  RUN adecomm/_setcurs.p ("WAIT":u).  

  r-pos = R-INDEX(qbf-qdpubl,"~\":u).

  IF r-pos = 0 THEN
     r-pos = R-INDEX(qbf-qdpubl,"~:":u).

  ASSIGN
    r-pos                   = r-pos + 1
    qbf-qdpubl              = SUBSTRING(qbf-qdpubl,r-pos,
                                LENGTH(qbf-qdpubl,"CHARACTER":u),"CHARACTER":u)
    qbf-qdpubl              = SEARCH(qbf-qdpubl).

  IF qbf-qdpubl = ? THEN qbf-qdpubl = "public.qd7":u.

  ASSIGN 
    qbf-d                   = (IF qbf-qdfile MATCHES "*public*":u THEN 
                                 qbf-qdhome ELSE qbf-qdpubl)
    querySelList:LIST-ITEMS = "".
   .

  RUN aderes/_ifile.p (qbf-d,OUTPUT readable,OUTPUT writable,OUTPUT qbf-a).

  IF NOT writable THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
      SUBSTITUTE("You do not have permission to write to &1.  You cannot save queries in this directory.",
      qbf-d)).
              
    RUN adecomm/_setcurs.p ("").
    RETURN NO-APPLY.
  END.

  ASSIGN
    _qdWritable            = writable
    _qdReadable            = readable
    qbf-ok:SENSITIVE       = _qdWritable
    qbf-qdfile             = qbf-d      
    FRAME qbf-nFrame:TITLE = IF qbf-s = 3 THEN
                              "Open" + " - ":u + CAPS(qbf-d) 
                             ELSE
                              "Save As" + " - ":u + CAPS(qbf-d)
    qbf-c = SUBSTRING(
          IF qbf-d MATCHES "*Public*" THEN
            IF USERID("RESULTSDB":u) = "" THEN "Personal" 
            ELSE CAPS(qbf-qdhome)
          ELSE "Public"
            ,1,8,"FIXED":u) + " ":u + "&Directory"
    qbf-c = FILL(" ":u,INTEGER(10 - LENGTH(qbf-c,"RAW":u) / 2)) + qbf-c
    qbf-f = SEARCH(qbf-qdfile)
    qbf-pd:LABEL IN FRAME qbf-nframe 
          = STRING(qbf-c,"x(20)":u)
    qbf-name = ""
    qbf-name:SCREEN-VALUE IN FRAME qbf-nframe = qbf-name
    .
    
  RUN aderes/i-read.p (INPUT-OUTPUT qbf-d).

  IF qbf-d = ? AND qbf-qdpubl MATCHES "*public*":u THEN DO:
    ASSIGN 
      qbf-c = "The public.qd7 file was not found"
      qbf-d = "public.qd7":u.

    RUN create_public_qd7 (INPUT qbf-c, OUTPUT qbf-b).
    IF qbf-b THEN
      RETURN NO-APPLY.
        
    ASSIGN 
      qbf-qdpubl = qbf-c
      qbf-d      = qbf-qdpubl
      qbf-f      = qbf-qdpubl. 
  END.                                                 

  DO qbf-i = 1 TO EXTENT(qbf-dir-ent):
    IF qbf-dir-ent[qbf-i] = "" OR
      (qbf-dir-flg[qbf-i] = FALSE AND qbf-qdshow = FALSE) THEN NEXT.

    IF qbf-dir-flg[qbf-i] = FALSE THEN
      fullLine = qbf-dir-ent[qbf-i] + " (":u + qbf-dir-dbs[qbf-i] + ")":u.
    ELSE
      fullLine = qbf-dir-ent[qbf-i].

    qbf-a = querySelList:ADD-LAST(fullLine) IN FRAME qbf-nframe.
  END.   

  RUN findSlot (OUTPUT qbf-r,OUTPUT queryFileNumber).
  RUN adecomm/_setcurs.p ("").
END.

/*----- ANOTHER USER BUTTON -----*/
ON CHOOSE OF qbf-au IN FRAME qbf-nframe DO: 

  hook:
  DO ON STOP UNDO hook, RETRY hook:
    IF RETRY THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a, "error":u, "ok":u,
        SUBSTITUTE("There is a problem with &1.  &2 cannot change directories.",_dirSwitch,qbf-product)).

      ASSIGN
        qbf-au:SENSITIVE IN FRAME qbf-nframe = FALSE
        _dirSwitch                           = ?.
      LEAVE hook.
    END.
 
    RUN VALUE(_dirSwitch) (INPUT-OUTPUT qbf-d,OUTPUT qbf-a).

    IF NOT qbf-a THEN 
      RETURN NO-APPLY.

    /* Verify .ext is equal to defaulted value found in {&qdExt} */
    IF SUBSTRING(qbf-d,R-INDEX(qbf-d,".":u),4,"CHARACTER":u) <> 
      {&qdExt} THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"information":u,"ok":u,
        SUBSTITUTE("File extention will default to &1.",{&qdExt})).
        
      qbf-d = SUBSTRING(qbf-d,1,R-INDEX(qbf-d,".":u) - 1,"CHARACTER":u) 
            + {&qdExt}.
    END.
  END.

  querySelList:LIST-ITEMS = "".

  RUN adecomm/_setcurs.p ("WAIT":u).     
  RUN aderes/_ifile.p (qbf-d,OUTPUT readable,OUTPUT writable,OUTPUT qbf-a).

  IF NOT writable THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a, "error":u, "ok":u,
      SUBSTITUTE("You do not have permission to write to &1.  You cannot save queries in this directory.",
      qbf-d)).

    RUN adecomm/_setcurs.p ("").
    RETURN NO-APPLY.
  END.

  ASSIGN
    _qdWritable            = writable
    _qdReadable            = readable
    qbf-ok:SENSITIVE       = _qdWritable
    qbf-qdfile             = qbf-d 
    FRAME qbf-nFrame:TITLE = IF qbf-s = 3 THEN
                               "Open":t20 + " - ":u + CAPS(qbf-d) 
                             ELSE
                               "Save As":t20 + " - ":u + CAPS(qbf-d)
    qbf-c = SUBSTRING(
            IF qbf-d MATCHES "*Public*" THEN
              IF USERID("RESULTSDB":u) = "" THEN "Personal"
              ELSE            
                CAPS(qbf-qdhome)
            ELSE "Public"
            ,1,8,"FIXED":u) + " ":u + "&Directory"
    qbf-c    = FILL(" ":u,INTEGER(10 - LENGTH(qbf-c,"RAW":u) / 2)) + qbf-c
    qbf-pd:LABEL IN FRAME qbf-nframe = STRING(qbf-c,"x(20)":u)
    qbf-name = ""
    qbf-name:SCREEN-VALUE IN FRAME qbf-nframe = qbf-name
    .
  
  IF qbf-d MATCHES "*Public*" THEN
     qbf-qdpubl = qbf-d.

  RUN aderes/i-read.p (INPUT-OUTPUT qbf-d). 

  DO qbf-i = 1 TO extent(qbf-dir-ent):
    IF qbf-dir-ent[qbf-i] = "" OR
      (qbf-dir-flg[qbf-i] = FALSE AND qbf-qdshow = FALSE) THEN NEXT.

    IF qbf-dir-flg[qbf-i] = FALSE THEN
      fullLine = qbf-dir-ent[qbf-i] + " (":u + qbf-dir-dbs[qbf-i] + ")":u.
    ELSE
      fullLine = qbf-dir-ent[qbf-i].

    qbf-a = querySelList:ADD-LAST(fullLine) IN FRAME qbf-nframe.
  END.   

  RUN findSlot (OUTPUT qbf-r,OUTPUT queryFileNumber).
  RUN adecomm/_setcurs.p ("").
END.

/*----- VALUE CHANGED -----*/

ON VALUE-CHANGED OF querySelList IN FRAME qbf-nframe
  qbf-name:SCREEN-VALUE IN FRAME qbf-nframe = 
    querySelList:SCREEN-VALUE IN FRAME qbf-nframe.
            
ON VALUE-CHANGED OF qbf-qdshow IN FRAME qbf-nframe DO:
  ASSIGN qbf-qdshow = INPUT FRAME qbf-nframe qbf-qdshow.

  DO qbf-i = 1 to extent(qbf-dir-ent):
    IF NOT qbf-dir-flg[qbf-i] AND qbf-dir-ent[qbf-i] <> "" THEN DO:

      /* we'll show the names of the other databases for the
       * disconnected databases */
      fullLine = qbf-dir-ent[qbf-i] + " (":u + qbf-dir-dbs[qbf-i] + ")":u.

      IF NOT qbf-qdshow THEN
        /*
         * Use the text version to delete, since other things may have
         * been deleted making the numbers obsolete.
         */
        qbf-a = querySelList:DELETE(fullLine).

      ELSE IF qbf-i > querySelList:NUM-ITEMS THEN
        qbf-a = querySelList:ADD-LAST(fullLine).
      ELSE
        /* Insert the entry using the *number* version of insert. */
        qbf-a = querySelList:INSERT(fullLine, qbf-i).
        
    END.
  END.
END.

ON ALT-Q OF FRAME qbf-nframe
  APPLY "ENTRY":u TO qbf-name IN FRAME qbf-nframe.

ON GO OF FRAME qbf-nframe DO:
  DEFINE VARIABLE fullWrite AS LOGICAL NO-UNDO INITIAL TRUE.

  /* query name is missing or null */
  IF qbf-name:SCREEN-VALUE IN FRAME qbf-nframe = "" OR 
     qbf-name:SCREEN-VALUE IN FRAME qbf-nframe = ? THEN DO:
    BELL.
    RETURN NO-APPLY.
  END.

  IF qbf-f = ? AND qbf-qdfile MATCHES "*public*":u THEN DO:
    qbf-c = "The public.qd7 file was not found".

    RUN create_public_qd7 (INPUT qbf-c, OUTPUT qbf-b).
    IF qbf-b THEN
      RETURN NO-APPLY.
     
    ASSIGN 
      qbf-qdpubl = qbf-c
      qbf-d      = qbf-qdpubl
      qbf-f      = qbf-qdpubl. 
  END.

  /* Check directory file read/write permissions.  See the Mainline Code 
     block for similar code. */
  IF qbf-qdfile <> qbf-qdhome THEN DO:
    ASSIGN
      qbf-a = (IF qbf-qdfile = qbf-qdpubl THEN _wPublic ELSE _wOther) 
      qbf-b = (IF qbf-qdfile = qbf-qdpubl THEN _rPublic ELSE _rOther).
      
    /* Does the user have permission to write into the directory?  Either the
       write[public | other]dir is false or the .qd7 file is not writeable. 
       99-03-25-047: added test for save vs. open (dma) */
    IF qbf-s < 3 THEN DO:
      IF (NOT qbf-a OR NOT _qdWritable) THEN DO:
        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a, "error":u, "ok":u,
          SUBSTITUTE("You do not have permission to write to &1.  To save this query you must change directories.",
          qbf-qdfile)).
        RETURN NO-APPLY.
      END.
    END.

    /* Does the user have permission to read from the directory?  Either the
       read[public | other]dir is false or the .qd7 file is not readable. */
    ELSE DO:
      IF (NOT qbf-b OR NOT _qdReadable) THEN DO:
        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a, "error":u, "ok":u,
          SUBSTITUTE("You do not have permission to read from &1.",
          qbf-qdfile)).
        RETURN NO-APPLY.
      END.
    END.
  END.

  IF qbf-dir-ent# = EXTENT(qbf-dir-ent) THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
      SUBSTITUTE("&1 is full. You must switch to another query directory.  You could also delete a query from the current query directory.",
      qbf-d)).
    qbf-r = 0.
    RETURN NO-APPLY.
  END.

  IF qbf-s <> 3 THEN fullWrite = TRUE.

  CASE qbf-s:
    /* check for duplicate query (with same name) */
    WHEN 1 OR WHEN 2 THEN DO:
      DO qbf-i = 1 TO extent(qbf-dir-ent):
        IF qbf-dir-ent[qbf-i] = 
          qbf-name:SCREEN-VALUE IN FRAME qbf-nframe THEN DO:
          qbf-a = TRUE.
      
          /* Don't dump out the message if the current value is the same as
             the current open query. This becomes a save.  */
          IF qbf-name:SCREEN-VALUE <> qbf-name THEN
            RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok-cancel":u,
               "A query with this name already exists.  Do you want to overwrite it?").

          /* reset to correct slot for overwriting */
          IF qbf-a THEN
            ASSIGN 
              /*
               * Update the information affected by this overwrite.  It is
               * possible that the user is using a different database than
               * the old query. 
               */
              qbf-r              = qbf-i
              queryFileNumber    = qbf-dir-num[qbf-r]
              qbf-dir-flg[qbf-r] = TRUE
              qbf-dir-dbs[qbf-r] = qbf-dbs
              qbf-dir-ent[qbf-r] = qbf-name:SCREEN-VALUE IN FRAME qbf-nframe
              fullWrite          = FALSE
             .
           ELSE
             RETURN NO-APPLY.
        END.
      END. /* qbf-i = 1 to extent( */

      /*
       * If the name changes then change the window title. Do it here
       * to avoid a repaint, which causes a full regen of code. That
       * can be quite lengthy when working with forms.
       */

      IF qbf-name <> qbf-name:SCREEN-VALUE THEN
        CURRENT-WINDOW:TITLE = qbf-product + " - [":u + 
                               qbf-name:SCREEN-VALUE + "]":u.

       ASSIGN 
         qbf-name  = qbf-name:SCREEN-VALUE IN FRAME qbf-nframe
         qbf-dirty = FALSE.

       RUN saveQuery (fullWrite, qbf-r, queryFileNumber).
    END. /* WHEN 1 or 2 */

    WHEN 3 THEN DO:
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
      DO qbf-i = 1 TO EXTENT(qbf-dir-ent) WHILE queryIndex = 0:
        IF qbf-name:SCREEN-VALUE = qbf-dir-ent[qbf-i] THEN
          queryindex = qbf-i.
      END.

      IF queryIndex = 0 THEN DO:
        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
          SUBSTITUTE("&1 could not be found or has disconnected database(s). It cannot be opened.",
          SUBSTRING(qbf-name:SCREEN-VALUE,1,
                    R-INDEX(qbf-name:SCREEN-VALUE,"(":u) - 1,"CHARACTER":u))).

        RETURN NO-APPLY.
      END.
    END. /* WHEN 3 */
  END CASE.
END. /* ON GO */
   
ON HELP OF FRAME qbf-nframe OR CHOOSE OF qbf-help IN FRAME qbf-nframe DO:
  CASE qbf-s:
    WHEN 1 OR WHEN 2 THEN
      RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Save_As_Dlg_Box},?).
    WHEN 3 THEN
      RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Open_Dlg_Box},?).        
  END CASE.
END.

ON MOUSE-SELECT-DBLCLICK OF querySelList IN FRAME qbf-nframe
  APPLY "GO":u TO SELF.
   
ON WINDOW-CLOSE OF FRAME qbf-nframe 
  OR CHOOSE OF qbf-ee IN FRAME qbf-nframe DO:
  lRet = TRUE.
  APPLY "END-ERROR":u TO SELF. 
END.

/*-------------------------- Mainline Code --------------------------------*/

{adecomm/okrun.i  
   &FRAME = "FRAME qbf-nframe" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help" }

/* The following code helps determine where the public.qd7 file 'currently' 
   resides. */ 
r-pos = R-INDEX(qbf-qdpubl,"~\":u).

IF r-pos = 0 THEN
  r-pos = R-INDEX(qbf-qdpubl,"~:":u).
   
ASSIGN
  FRAME qbf-nframe:HIDDEN                     = TRUE
  querySelList:DELIMITER IN FRAME qbf-nframe  = CHR(10)
  qbf-d                                       = qbf-qdfile
  r-pos                                       = r-pos + 1
  qbf-qdpubl                                  = 
    SUBSTRING(qbf-qdpubl,r-pos,LENGTH(qbf-qdpubl,"CHARACTER":u),"CHARACTER":u)
  qbf-qdpubl                                  = SEARCH(qbf-qdpubl)
  qbf-r                                       = 0
 .

IF qbf-qdpubl = ? THEN 
  qbf-qdpubl = "public.qd7":u.
   
IF qbf-d MATCHES "*Public*" THEN 
  ASSIGN 
    qbf-d      = qbf-qdpubl
    qbf-qdfile = qbf-d
    qbf-c      = SUBSTRING(
                   IF qbf-d MATCHES "*Public*" THEN
                     IF USERID("RESULTSDB":u) = "" THEN "Personal"
                     ELSE USERID("RESULTSDB":u) + "'s"
                   ELSE "Public"
                   ,1,8,"FIXED":u) + " ":u + "&Directory"
    qbf-c      = FILL(" ":u,INTEGER(10 - LENGTH(qbf-c,"RAW":u) / 2)) + qbf-c
    qbf-pd:LABEL IN FRAME qbf-nframe = STRING(qbf-c,"x(20)":u)
    .
  
/*
 * If this is SAVE, make sure that there is a slot for the query. It may
 * not be there.  For example, open query s; Delete query s (the query has
 * been deleted from the directory, but the query is still "on the screen"
 * and in the data structures); Save. In this case force a SAVE-AS.
 */

IF qbf-s = 1 and qbf-name <> "" THEN DO:  

  /* User wants to save the existing query. Find the slot that matches
     the current query's name */
  DO qbf-i = 1 TO EXTENT(qbf-dir-ent) WHILE qbf-r = 0:
    IF qbf-dir-ent[qbf-i] = qbf-name THEN qbf-r = qbf-i.
  END.

  /* No slot, then let's continue on as a save-as.  */
  IF qbf-r > 0 THEN DO:
    ASSIGN
      queryFileNumber = qbf-dir-num[qbf-r]
      qbf-dirty       = FALSE
      .
                     
    RUN saveQuery (FALSE, qbf-r, queryFileNumber).
    RETURN.
  END.
END.

/*
 * Save-As, unlike Save, is available on the menu even if the user doesn't have
 * permission to write out to a directory. The reason is, we want the user
 * to be able to "copy" the query from one directory to another. But only if
 * the user can write to a directory.
 */

/* Check directory file read/write permissions.  See the ON GO OF FRAME 
   trigger for similar code. */
IF qbf-qdfile <> qbf-qdhome THEN DO:
  ASSIGN
    qbf-a = (IF qbf-qdfile = qbf-qdpubl THEN _wPublic ELSE _wOther)
    qbf-b = (IF qbf-qdfile = qbf-qdpubl THEN _rPublic ELSE _rOther).

  /* Does the user have permission to write to the directory?  Either the
     write[public | other]dir is false or the .qd7 file is not writeable. 
     99-03-25-047: added test for save vs. open (dma) */
  IF qbf-s < 3 THEN DO:
    IF (NOT qbf-a OR NOT _qdWritable) THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a, "error":u, "ok":u,
        SUBSTITUTE("You do not have permission to write to &1.  To save this query you must change directories.",
        qbf-qdfile)).
        
      /* Do not return. Bring up the dialog box and let the user choose 
         another directory. */
    END.
  END.

  /* Does the user have permission to read from the directory?  Either the
     read[public | other]dir is false or the .qd7 file is not readable. */
  ELSE DO:
    IF (NOT qbf-b OR NOT _qdReadable) THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a, "error":u, "ok":u,
        SUBSTITUTE("You do not have permission to read from &1.  To open a query you must change directories.",
        qbf-qdfile)).
        
      /* Do not return. Bring up the dialog box and let the user choose 
         another directory. */
    END.
  END.
END.

/*
RUN adeshar/_mgetfs.p({&resId}, {&rfReadPublicDir},  OUTPUT readPublicDir).
RUN adeshar/_mgetfs.p({&resId}, {&rfReadOtherDir},   OUTPUT readOtherDir).
RUN adeshar/_mgetfs.p({&resId}, {&rfWritePublicDir}, OUTPUT writePublicDir).
RUN adeshar/_mgetfs.p({&resId}, {&rfWriteOtherDir},  OUTPUT writeOtherDir).
*/
     
DO qbf-i = 1 TO extent(qbf-dir-ent):
  IF qbf-dir-ent[qbf-i] = ""  OR
    (qbf-dir-flg[qbf-i] = FALSE AND qbf-qdshow = FALSE) THEN NEXT.

  IF qbf-dir-flg[qbf-i] = FALSE THEN
    fullLine = qbf-dir-ent[qbf-i] + " (":u + qbf-dir-dbs[qbf-i] + ")":u.
  ELSE
    fullLine = qbf-dir-ent[qbf-i].

  qbf-a = querySelList:ADD-LAST(fullLine) IN FRAME qbf-nframe.
END.

ASSIGN
  FRAME qbf-nFrame:TITLE               = IF qbf-s = 3 THEN
                                           "Open":t20 + " - ":u + CAPS(qbf-d) 
                                         ELSE
                                           "Save As":t20 + " - ":u + CAPS(qbf-d)
  qbf-name:SENSITIVE                   = TRUE
  qbf-name:SCREEN-VALUE                = qbf-name
  qbf-name:WIDTH                       = querySelList:WIDTH IN FRAME qbf-nframe
  qbf-ok:SENSITIVE                     = _qdWritable
  qbf-help:SENSITIVE                   = TRUE
  qbf-ee:SENSITIVE                     = TRUE
  qbf-pd:SENSITIVE                     = (_rPublic AND _wPublic)
  qbf-au:SENSITIVE                     = (_rOther AND _wOther)
  qbf-c = SUBSTRING(
          IF qbf-d MATCHES "*Public*" THEN
             IF USERID("RESULTSDB":u) = "" THEN "Personal"
             ELSE USERID("RESULTSDB":u) + "'s"
          ELSE "Public"
             ,1,8,"FIXED":u) + " ":u + "&Directory"
  qbf-c = FILL(" ":u,INTEGER(10 - LENGTH(qbf-c,"RAW":u) / 2)) + qbf-c
  qbf-pd:LABEL IN FRAME qbf-nframe     = STRING(qbf-c,"x(20)":u)
  qbf-f                                = SEARCH(qbf-qdfile)
  switchText                           = "Switch listing to:"
  switchText:SCREEN-VALUE              = switchText
  switchText:WIDTH                     = qbf-pd:WIDTH
.

/* If the inn is already full then don't continue */

IF qbf-dir-ent# = EXTENT(qbf-dir-ent) THEN DO:
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
    SUBSTITUTE("&1 is full. You must switch to another query directory.  You could also delete a query from the current query directory.",
    qbf-d)).
    
   qbf-r = 0.
END.
ELSE
/* The following finds the appropriate slot for the save.  If the
 * query has not yet been saved, then it will match with the first
 * deleted entry (= "").  If it runs off the end, then it will add
 * a new slot after the last entry.
 */
RUN findSlot (OUTPUT qbf-r,OUTPUT queryFileNumber).

ENABLE qbf-name querySelList qbf-pd qbf-au qbf-qdshow qbf-ok qbf-ee qbf-help
  WITH FRAME qbf-nframe.

FRAME qbf-nframe:HIDDEN = FALSE.

DO ON ERROR UNDO, RETRY ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME qbf-nframe.
END.

HIDE FRAME qbf-nframe NO-PAUSE.

RETURN.

/* ----------------------------------------------------------------------- */

PROCEDURE saveQuery:
  DEFINE INPUT  PARAMETER fullWrite       AS LOGICAL NO-UNDO.
  DEFINE INPUT  PARAMETER queryIndex      AS INTEGER NO-UNDO.
  DEFINE INPUT  PARAMETER queryFileNumber AS INTEGER NO-UNDO.

  IF queryFileNumber = 0 THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
      SUBSTITUTE("An incorrect query file number has been generated.  &1 was not saved.",
      qbf-name)).
    RETURN.
  END.

  IF queryIndex > extent(qbf-dir-ent) THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
      SUBSTITUTE("An incorrect query index, &1 has been generated.  &2 was not saved.",
      queryIndex,qbf-name)).
    RETURN.
  END.

  RUN adecomm/_statdsp.p 
    (wGlbStatus, 1, SUBSTITUTE('Saving query "&1".':t24,qbf-name)).

  RUN adecomm/_setcurs.p ("WAIT":u).
  DO ON ERROR UNDO, LEAVE:
    IF fullWrite = TRUE THEN DO:
      /* record ldbnames */
      ASSIGN
        qbf-dir-ent#            = qbf-dir-ent# + 1
        qbf-dir-ent[queryIndex] = qbf-name
        qbf-dir-flg[queryIndex] = TRUE
        qbf-dir-num[queryIndex] = queryFileNumber
  
        /* Set list of databases (used by i-write.p) */
        qbf-dir-dbs[queryIndex] = qbf-dbs
      .

      /* Now sort the names */
      RUN aderes/_isort.p.
    END. 

    qbf-a = FALSE.

    /* Before writing stuff out, save qbf-wask (which is in display
     * format), update ask variables in some nice fashion for the
     * generated code, and, when done, reset things as we found them. */
    FOR EACH qbf-where:
      CREATE qbf-w.
      ASSIGN
	qbf-w.qbf-n = qbf-where.qbf-wtbl
	qbf-w.qbf-t = qbf-where.qbf-wask.
    END.
  
    /* handle ask-at-runtime WHERE-clause questions */
    RUN aderes/s-ask.p ("", FALSE, INPUT-OUTPUT qbf-a).
  
    /* split the filename from the basename */
    RUN aderes/s-prefix.p (qbf-qdfile,OUTPUT qbf-c).
    qbf-c = qbf-c + "que":u + STRING(queryFileNumber,"99999":u) + ".p":u.
  
    /* write out query file */
    RUN aderes/s-write.p (qbf-c, "s":u).
     
    IF RETURN-VALUE = "OK":u THEN DO:  
      /* write out .QD file */
      RUN aderes/i-write.p (?).

      IF RETURN-VALUE = "OK":u THEN DO:
        FOR EACH qbf-where,EACH qbf-w 
          WHERE qbf-w.qbf-n = qbf-where.qbf-wtbl:
          qbf-where.qbf-wask = qbf-w.qbf-t.
        END.
  
        qbf-dirty = FALSE.
  
        RUN adecomm/_statdsp.p 
          (wGlbStatus, 1, SUBSTITUTE('Query "&1" saved.':t24,qbf-name)).
          
        RUN adecomm/_statdsp.p (wGlbStatus, 2,
          ENTRY(INDEX("elrfb":u,qbf-module),
          "Export,Label,Report,Form,Browse") + " View").
      END.
      ELSE 
        RUN adecomm/_statdsp.p (wGlbStatus, 1, "").
    END.
    ELSE
      RUN adecomm/_statdsp.p (wGlbStatus, 1, "").
  END. 

  RUN adecomm/_setcurs.p ("").
END PROCEDURE. 

/* ----------------------------------------------------------------------- */

PROCEDURE findSlot:
  DEFINE OUTPUT PARAMETER slotNum    AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER fileNumber AS INTEGER NO-UNDO.

  DEFINE VARIABLE i        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE j        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lastGasp AS LOGICAL   NO-UNDO INITIAL FALSE.
  DEFINE VARIABLE fileName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE msg      AS CHARACTER NO-UNDO.

  /*
   * Find first empty slot. Since the file number is not the the array index
   * start with largest number we can find. If we reach the end (99999) then
   * restart at the beginning to find a slot. In all cases, check to see if
   * the file name is being used. If it is there then go get another
   * number and try again.
   */
  DO i = 1 to EXTENT(qbf-dir-ent) WHILE slotNum = 0:
    IF qbf-dir-ent[i] = "" THEN slotNum = i.
  END.

  /* If the slotNum is 0 then we've got a full house, Dump a message and
     flag it.  */
  IF slotNum = 0 THEN DO:
    /* If the inn is already full then don't continue */
    IF qbf-dir-ent# = EXTENT(qbf-dir-ent) THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a, "error":u, "ok":u,
        SUBSTITUTE("&1 is full. You must switch to another query directory or delete a query from the current query directory.",
        qbf-d)).
        
      slotNum = -1.
      RETURN.
    END.
  END.

  /* First check to see if the we can use the slot number. If it isn't
     available then start the search for another number.  */
  RUN aderes/s-prefix.p (qbf-qdfile,OUTPUT prefix).
  fileName = prefix + "que":u + STRING(slotNum,"99999":u) + ".p":u.
  fileName = SEARCH(fileName).
    
  /* If we *don't* find the file then we are ok */
  j = 1.

  IF fileName <> ? THEN DO:
    DO i = 1 TO EXTENT(qbf-dir-num):
      j = MAXIMUM(j, qbf-dir-num[i]).
    END.
    
    IF j = 99999 THEN
      /* The maximum allowed name has been found. Start at the
         beginning. But do keep a check out in case the directory is
         completely filled up! */
      ASSIGN
        j        = 0
        lastGasp = TRUE
      .
    
    /* Start the search for an available name.  */
    i = j + 1.
    
    DO WHILE TRUE:
      /* If we are at the end are we out of space? */
      IF i = 99999 THEN DO:
        IF lastGasp = TRUE THEN DO:
          /* The directory has run out of room */
          RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a, "error":u, "ok":u,
            SUBSTITUTE("&1 can not save this query since it can not create a file in the query directory.",
            qbf-product)).
          RETURN.
        END.
        ELSE
          /* We'll make one more pass through all the numbers */
          ASSIGN 
            i        = 1
            lastGasp = true
          .
      END.
    
      ASSIGN
        fileName    = prefix + "que":u + STRING(i,"99999":u) + ".p":u.
        fileName    = SEARCH(fileName).

      IF fileName = ? THEN LEAVE.
      i = i + 1.
    END.
    fileNumber = i.
  END.
  ELSE
    fileNumber = slotNum.
END PROCEDURE.

/* ----------------------------------------------------------------------- */
 
PROCEDURE create_public_qd7:
  DEFINE INPUT  PARAMETER qbf_c       AS CHARACTER       NO-UNDO.
  DEFINE OUTPUT PARAMETER qbf_abort   AS LOGICAL         NO-UNDO.
     
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"warning":u,"ok-cancel":u,
    SUBSTITUTE("&1. ^^Choose OK to create one in your local directory.^^You can search for an existing public.qd7 by selecting the 'Directory...' button.",qbf_c)). 
                                          
  /*
   * If no then, user has option to locate public.qd7 using Directory... button.
   * If true, then create public.qd7 in user's home directory.
   */                                                          
  
  IF qbf-a = ? THEN
     qbf_abort = TRUE.
  ELSE DO:
    RUN aderes/i-write (?). /*rebuild directory file */

    ASSIGN 
      qbf-c = SUBSTRING(
                IF qbf-d MATCHES "*Public*" THEN
                  IF USERID("RESULTSDB":u) = "" THEN "Personal"
                  ELSE            
                    USERID("RESULTSDB":u) + "'s"
                ELSE "Public"
                ,1,8,"FIXED":u) + " ":u + "&Directory"
      qbf-c = FILL(" ":u,INTEGER(10 - LENGTH(qbf-c,"RAW":u) / 2)) + qbf-c
      qbf-pd:LABEL IN FRAME qbf-nframe = STRING(qbf-c,"x(20)":u)
    .
  END. 
END PROCEDURE.

/* i-opnsav.p - end of file */

