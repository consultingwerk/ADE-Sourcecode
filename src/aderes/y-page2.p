/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * y-page2.p - persistent trigger support for y-page.p
 */

{ aderes/s-system.i }
{ aderes/y-define.i }

DEFINE INPUT PARAMETER qbf-a AS CHARACTER NO-UNDO. /* action */
DEFINE INPUT PARAMETER qbf-w AS HANDLE    NO-UNDO. /* widget */
DEFINE INPUT PARAMETER qbf-s AS INTEGER   NO-UNDO. /* # pages */

DEFINE VARIABLE cTemp AS CHARACTER NO-UNDO.
DEFINE VARIABLE ix    AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-1 AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-3 AS LOGICAL   NO-UNDO.

DEFINE VARIABLE qbf-d AS CHARACTER NO-UNDO. /* print destination */
DEFINE VARIABLE qbf-l AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-p AS LOGICAL   NO-UNDO. /* MSW print OK */

/* walk up widget tree to find parent */
DO WHILE qbf-w:TYPE <> "WINDOW":u: 
  qbf-w = qbf-w:PARENT.  
END.

FIND FIRST qbf-wsys WHERE qbf-wsys.qbf-wwin = qbf-w.

/* removed to fix bug #94-02-02-015 */
/*RUN adecomm/_setcurs.p ("WAIT":u).*/

CASE qbf-a:
  WHEN "f":u THEN DO: /* first page */
    IF qbf-wsys.qbf-wpage <> 1 THEN DO:
      qbf-wsys.qbf-wpage = 1.
      RUN readPage (TRUE).
    END.
  END.
  
  WHEN "p":u THEN DO: /* prev page */
    IF qbf-wsys.qbf-wpage > 1 THEN DO:
      qbf-wsys.qbf-wpage = qbf-wsys.qbf-wpage - 1.
      RUN readPage (TRUE).
    END.
  END.
  
  WHEN "n":u THEN DO: /* next page */
    IF qbf-wsys.qbf-wpage < qbf-wsys.qbf-wlast
      OR qbf-wsys.qbf-wlast = 0 THEN DO:
   
      qbf-wsys.qbf-wpage = qbf-wsys.qbf-wpage + 1.
      RUN readPage (TRUE).
    END.
  END.
  
  WHEN "l":u THEN DO: /* last page */
    RUN adecomm/_setcurs.p ("WAIT":u).
    IF qbf-wsys.qbf-wpage = qbf-wsys.qbf-wlast THEN RETURN.
    
    /* If the last page hasn't been read in then read in the rest of
     * the report. The "DO WHILE" will not execute if all the pages are
     * already available. */
       
    DO WHILE qbf-wseek[qbf-wsys.qbf-wlast] = ?:
      qbf-wsys.qbf-wpage = qbf-wsys.qbf-wpage + 1.
      RUN readPage (FALSE).
    END.

    /* Now go to the page we want to see */
    qbf-wsys.qbf-wpage = qbf-wsys.qbf-wlast.
      
    RUN readPage (TRUE).
    RUN adecomm/_setcurs.p ("").
  END.
  
  WHEN "#":u THEN DO: /* goto page # */
    RUN adecomm/_setcurs.p ("WAIT":u).

    /* ix is being used to represent the page to go to -dma */
    ix = qbf-wsys.qbf-wpage.

    CURRENT-WINDOW = qbf-wsys.qbf-wwin.
    RUN aderes/_gotopag.p (qbf-s,qbf-wsys.qbf-wpage,OUTPUT ix).
    CURRENT-WINDOW = qbf-win.

    RUN adecomm/_setcurs.p ("WAIT":u).
    IF qbf-wsys.qbf-wpage <> ix THEN DO:
      IF ix > qbf-s THEN
	ix = qbf-s.

      DO WHILE qbf-wseek[ix] = ?:
	qbf-wsys.qbf-wpage = qbf-wsys.qbf-wpage + 1.
	RUN readPage (FALSE).
      END.

      /* Now go to the page we want to see */
      qbf-wsys.qbf-wpage = ix.

      RUN readPage (TRUE).
    END.
    RUN adecomm/_setcurs.p ("").
  END.

  WHEN "c":u THEN DO: /* close window */
    /* y-page and y-page2 used to use a named stream for the first print
       preview file (qbf1.d) and the unnamed stream for all other ones
       (qbf2.d, qbf3.d, etc.).  Why did it do this???  It was messing
       things up when running with "share" on DOS, when you tried to print,
       we'd get a share violation.  The named stream remains open for the
       life of the print preview window.  The unnamed stream is opened and
       closed each time we call y-page2.p, by Progress.  It seems like this
       shouldn't have made a difference because the access should be for
       read-only -- but it did.  So all this stream stuff is getting 
       commented out. We should find out from Tony why this was and either
       really remove it or whatever.
    */
    /*IF qbf-wsys.qbf-wfile = "qbf1.d":u THEN INPUT STREAM qbf-wio CLOSE.*/

    ASSIGN
      CURRENT-WINDOW = qbf-win  /* this seems to have no effect - dma */
      qbf-w:VISIBLE  = FALSE.

    DELETE WIDGET qbf-wsys.qbf-wbut[1].  /* print */
    DELETE WIDGET qbf-wsys.qbf-wbut[2].  /* first */
    DELETE WIDGET qbf-wsys.qbf-wbut[3].  /* previous */
    DELETE WIDGET qbf-wsys.qbf-wbut[4].  /* next */
    DELETE WIDGET qbf-wsys.qbf-wbut[5].  /* last */
    DELETE WIDGET qbf-wsys.qbf-wbut[6].  /* close */
    DELETE WIDGET qbf-wsys.qbf-wedi.     /* editor */
    DELETE WIDGET qbf-wsys.qbf-wfrm.     /* then the frame */
    DELETE WIDGET qbf-wsys.qbf-wwin.     /* and the window */

    IF SEARCH(qbf-wsys.qbf-wfile) <> ? THEN
      OS-DELETE VALUE(qbf-wsys.qbf-wfile).     /* and the file */
    DELETE qbf-wsys.                           /* and the temp-table record */
  END.
  
  WHEN "*":u THEN DO: /* print! */
    IF NOT SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":u THEN
       RUN adecomm/_setcurs.p ("WAIT":u).

    RUN adecomm/_osprint.p (qbf-win, qbf-wsys.qbf-wfile,
			    0, 0, 0, qbf-s, OUTPUT qbf-p).

    IF NOT SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":u THEN
       RUN adecomm/_setcurs.p ("").
  END.
  
  WHEN "w":u THEN DO: /* window-resized */
    DEFINE VAR wid      AS DECIMAL NO-UNDO.
    DEFINE VAR win_wid  AS DECIMAL NO-UNDO. /* usable wid for the frame */
    DEFINE VAR win_ht   AS DECIMAL NO-UNDO. /* usable ht for the frame */
   
    ASSIGN
      win_wid      = qbf-w:WIDTH-PIXELS
      win_ht       = qbf-w:HEIGHT-PIXELS - qbf-wsys.wStatus:HEIGHT-PIXELS
      /* Status bar doesn't shrink below the default size */
      wid          = MAXIMUM(win_wid,def-wid-pix)
      qbf-wsys.qbf-wfrm:VISIBLE = no.  /* to avoid wierd painting */

    ASSIGN
      qbf-wsys.wStatus:Y                    = win_ht 
      qbf-wsys.wStatus:VIRTUAL-WIDTH-PIXELS = wid
      qbf-wsys.wStatus:WIDTH-PIXELS         = wid.

    IF win_wid > qbf-wsys.qbf-wfrm:WIDTH-PIXELS THEN
      /* window growing - make frame bigger first */
      ASSIGN
	qbf-wsys.qbf-wfrm:WIDTH-PIXELS         = win_wid
	qbf-wsys.qbf-wedi:WIDTH-PIXELS         = win_wid
	qbf-wsys.qbf-wfrm:VIRTUAL-WIDTH-PIXELS = win_wid.
   ELSE
      /* window shrinking - shrink editor first */
      ASSIGN
	qbf-wsys.qbf-wedi:WIDTH-PIXELS         = win_wid 
	qbf-wsys.qbf-wfrm:WIDTH-PIXELS         = win_wid
	qbf-wsys.qbf-wfrm:VIRTUAL-WIDTH-PIXELS = win_wid.

    IF win_ht > qbf-wsys.qbf-wfrm:HEIGHT-PIXELS THEN
      ASSIGN
	qbf-wsys.qbf-wfrm:HEIGHT-PIXELS         = win_ht
	qbf-wsys.qbf-wfrm:VIRTUAL-HEIGHT-PIXELS = win_ht
	qbf-wsys.qbf-wedi:HEIGHT-PIXELS         = win_ht - qbf-wsys.qbf-wedi:Y.
   ELSE
      ASSIGN
	qbf-wsys.qbf-wedi:HEIGHT-PIXELS         = win_ht - qbf-wsys.qbf-wedi:Y
	qbf-wsys.qbf-wfrm:HEIGHT-PIXELS         = win_ht
	qbf-wsys.qbf-wfrm:VIRTUAL-HEIGHT-PIXELS = win_ht.

    qbf-wsys.qbf-wfrm:VISIBLE = yes.
  END.
END CASE.

/*RUN adecomm/_setcurs.p ("").*/

RETURN. /* to keep from 'beep' on window-close */

/*--------------------------------------------------------------------------*/

PROCEDURE readPage:
  DEFINE INPUT PARAMETER pi_show AS LOGICAL NO-UNDO.

  DEFINE VARIABLE wioStream AS LOGICAL   NO-UNDO. /* to use qbf-wio stream */
  DEFINE VARIABLE lineIndex AS INTEGER   NO-UNDO.
  DEFINE VARIABLE numLines  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE curLine   AS CHARACTER NO-UNDO. /* current input line */
  DEFINE VARIABLE curBuffer AS CHARACTER NO-UNDO. /* value of editor widget */

  FIND FIRST qbf-wsys WHERE qbf-wsys.qbf-wwin = qbf-w.

  /* The code is based on an array of disk offsets. If an offset is
   * ? then the page hasn't been seen. If the value is negative then
   * we've found the end of the file. The negative part of the number
   * indicates we're at the end. The absolute value of the number 
   * indicates the number of lines left on the final page.  */

  /* wioStream = (qbf-wsys.qbf-wfile = "qbf1.d":u). */
  wioStream = no.  /* see comment above - look for qbf1.d to find it) */

  /* open file stream */
  IF wioStream AND SEEK(qbf-wio) = ? THEN
    INPUT STREAM qbf-wio FROM VALUE(qbf-wsys.qbf-wfile) NO-ECHO.

  IF wioStream THEN DO:
    IF qbf-wseek[qbf-wsys.qbf-wpage] = 0 THEN DO: /* file empty */
      INPUT STREAM qbf-wio CLOSE.
      INPUT STREAM qbf-wio FROM VALUE(qbf-wsys.qbf-wfile) NO-ECHO.
    END.
    ELSE
      SEEK STREAM qbf-wio TO qbf-wseek[qbf-wsys.qbf-wpage].
  END.
  ELSE DO:
    INPUT FROM VALUE(qbf-wsys.qbf-wfile) NO-ECHO.
    SEEK INPUT TO qbf-wseek[qbf-wsys.qbf-wpage]. /* first page = 0 */
  END.

  /* Get the number of lines on the next page. If the number is negative 
   * then the page is the last page.  */
  ASSIGN
    curBuffer = ""
    numLines  = qbf-wseek[qbf-wsys.qbf-wpage + 1]
    numLines  = (IF numLines < 0 THEN - numLines ELSE qbf-wsys.qbf-wsize)
    .

  /* Bring in the lines */
  DO lineIndex = 1 TO numLines ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    curLine = "".

    IF wioStream THEN
      IMPORT STREAM qbf-wio UNFORMATTED curLine NO-ERROR. 
    ELSE
      IMPORT UNFORMATTED curLine NO-ERROR. 
    {aderes/_aerror.i &i=ix &msg="The following error(s) were found:"}

    /* Blow away embedded cr's. */
    &IF "{&WINDOW-SYSTEM}" = "OSF/MOTIF" &THEN
      curLine = REPLACE(curLine, CHR(13), ""). 
    &ENDIF

    /* Found a page break.  If the first line, then ignore */
    IF curLine BEGINS CHR(12) AND lineIndex = 1 THEN
      curLine = SUBSTRING(curLine, 2,-1,"CHARACTER":u).

    IF qbf-wseek[qbf-wsys.qbf-wpage + 1] > 0
      AND (IF wioStream THEN SEEK(qbf-wio) ELSE SEEK(INPUT))
	>= qbf-wseek[qbf-wsys.qbf-wpage + 1] THEN UNDO, LEAVE.

    qbf-wsys.qbf-wback = (IF wioStream THEN SEEK(qbf-wio) ELSE SEEK(INPUT)).

    /* We found premature end-of-page, so reset and leave - dma */
    IF curLine BEGINS CHR(12) AND lineIndex > 1 THEN DO:
      /* This used to subtract 1, which makes sense to me but it would
	 cause the 1st char of the next page to be missing - but only
	 when outputting to the screen, not when printing, and only
	 on the PC!  Now that I've made it "2", it seems to work on 
	 both machines for both print preview and real print.  
	 - los.   
      */
      qbf-wsys.qbf-wback = qbf-wsys.qbf-wback - LENGTH(curLine,"RAW":u) - 2.
      LEAVE.
    END.
 
    curBuffer = curBuffer
	      + (IF lineIndex = 1 THEN "" ELSE CHR(10))
	      + curLine.
  END.

  /* We found a page end - are there more?  This block handles checking to
   * see if the next page is empty - meaning a ff ends the last page.  This
   * keeps us from showing an extra blank screen at the end of the file.  */
  ASSIGN
    numLines = (IF wioStream THEN SEEK(qbf-wio) ELSE SEEK(INPUT))
    curLine = "".

  /* If there is another page then figure out the seek offset. */
  IF numLines <> ? AND qbf-wsys.qbf-wlast = 0 THEN DO:
    IF wioStream THEN DO:
      REPEAT WHILE curLine = "":
	curLine = ?.
	IMPORT STREAM qbf-wio UNFORMATTED curLine NO-ERROR. 
	{aderes/_aerror.i &i=ix &msg="The following error(s) were found:"}

	IF curLine BEGINS CHR(12) THEN 
	  curLine = SUBSTRING(curLine, 2,-1,"CHARACTER":u).
      END.

      IF curLine = ? THEN
	INPUT STREAM qbf-wio CLOSE.
      ELSE
	SEEK STREAM qbf-wio TO numLines.
    END.
    ELSE DO:
      REPEAT WHILE curLine = "":
	curLine = ?.
	IMPORT UNFORMATTED curLine NO-ERROR. 
	{aderes/_aerror.i &i=ix &msg="The following error(s) were found:"}

	IF curLine BEGINS CHR(12) THEN 
	  curLine = SUBSTRING(curLine, 2,-1,"CHARACTER":u).
      END.

      IF curLine = ? THEN
	INPUT CLOSE.
      ELSE
	SEEK INPUT TO numLines.
    END.
  END. /* next page seek offset */

  numLines = (IF wioStream THEN SEEK(qbf-wio) ELSE SEEK(INPUT)).

  /* Adding 1 to wback prevents last line of page from being chopped off,
     but side-effect is that first character of first line is sometimes
     missing... dma */
  IF qbf-wseek[qbf-wsys.qbf-wpage + 1] = ? THEN
    qbf-wseek[qbf-wsys.qbf-wpage + 1] = 
      (IF numLines = ? THEN - lineIndex ELSE qbf-wsys.qbf-wback + 
      (IF qbf-module = "e" THEN 0 ELSE 1)). 

  /* This gets around PROGRESS' habit of closing 
   * streams automatically when the eof is hit.  */
  IF wioStream AND numLines = ? THEN DO:
    INPUT STREAM qbf-wio CLOSE.
    INPUT STREAM qbf-wio FROM VALUE(qbf-wsys.qbf-wfile) NO-ECHO.
  END.
  IF NOT wioStream THEN INPUT CLOSE.

  IF qbf-wsys.qbf-wpage = EXTENT(qbf-wsys.qbf-wseek) THEN
    qbf-wsys.qbf-wlast = qbf-wsys.qbf-wpage.
  ELSE 
  IF qbf-wsys.qbf-wlast = 0 AND qbf-wseek[qbf-wsys.qbf-wpage + 1] < 0 THEN
    qbf-wsys.qbf-wlast = qbf-wsys.qbf-wpage.

  IF pi_show THEN
    ASSIGN
      cTemp   = "Page: " + STRING(qbf-wsys.qbf-wpage,">>>>>":u) +
		" of "   +   (IF qbf-wsys.qbf-wlast = 0 THEN "?????":u
			      ELSE STRING(qbf-wsys.qbf-wlast,">>>>>":u))
      qbf-wsys.qbf-wedi:SCREEN-VALUE = curBuffer
      qbf-wsys.qbf-wbut[1]:SENSITIVE = TRUE
      qbf-wsys.qbf-wbut[4]:SENSITIVE = (qbf-wsys.qbf-wpage > 1)
      qbf-wsys.qbf-wbut[5]:SENSITIVE = (qbf-wsys.qbf-wlast = 0
				  OR qbf-wsys.qbf-wpage < qbf-wsys.qbf-wlast)
      qbf-wsys.qbf-wbut[3]:SENSITIVE = qbf-wsys.qbf-wbut[4]:SENSITIVE
      qbf-wsys.qbf-wbut[6]:SENSITIVE = qbf-wsys.qbf-wbut[5]:SENSITIVE
      qbf-wsys.qbf-wbut[2]:SENSITIVE = qbf-s > 1
      .
  RUN adecomm/_statdsp.p (qbf-wsys.wStatus,2,cTemp).
END PROCEDURE. /* readPage */

/* y-page2.p - end of file */

