/*********************************************************************
* Copyright (C) 2005,2013 by Progress Software Corporation. All      *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* aderes.p - PROGRESS RESULTS main program
*/

&GLOBAL-DEFINE WIN95-BTN YES
&GLOBAL-DEFINE UseDefaultWindow FALSE

{ aderes/a-define.i NEW }
{ aderes/e-define.i NEW }
{ aderes/fbdefine.i NEW }
{ aderes/i-define.i NEW }
{ aderes/j-define.i NEW }
{ aderes/l-define.i NEW }
{ aderes/r-define.i NEW }
{ aderes/s-define.i NEW }
{ aderes/s-output.i NEW }
{ aderes/s-system.i NEW }
/*{ aderes/t-define.i NEW }*/
{ aderes/y-define.i NEW }

{ adeshar/_mnudefs.i NEW }
{ aderes/_fdefs.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

DEFINE VARIABLE old-3d      AS LOGICAL   NO-UNDO. /* original 3D state */
DEFINE VARIABLE qbf-c       AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-e       AS CHARACTER NO-UNDO. /* error messages */
DEFINE VARIABLE qbf-h       AS HANDLE    NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i       AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-j       AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-l       AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-propath AS CHARACTER NO-UNDO.

ASSIGN qbf-i = GET-LICENSE("RESULTS":u).
IF qbf-i <> 0 THEN DO:
  /* 1 is invalid string - should never happen */
  IF qbf-i = 2 THEN
    MESSAGE "Your copy of RESULTS is past its expiration date."
    VIEW-AS ALERT-BOX ERROR.
  ELSE IF qbf-i = 3 THEN
    MESSAGE "You have not purchased RESULTS."
    VIEW-AS ALERT-BOX ERROR.
  RETURN.
END.

old-3d = SESSION:THREE-D.

/*=========================== Mainline Code ===============================*/
ASSIGN
  qbf-depth             = 0     /* use j-table2.p for table selection */

  /* Standard SESSION:WIDTH-CHARS = 91.43, upon which most dialog boxes
     were originally sized.  For screen resolution/PPU combinations where
     less than 91 'columns' are available, we need to shrink dialog boxes
     to fix. -dma */
  shrink-hor            = IF SESSION:WIDTH-CHARS >= 91 THEN 0 ELSE
  (91 - ROUND(SESSION:WIDTH-CHARS,0))
  shrink-hor-2          = IF shrink-hor = 0 THEN 0 ELSE (shrink-hor / 2)
  shrink-ver            = IF SESSION:HEIGHT-CHARS >= 18 THEN 0 ELSE
  (18 - ROUND(SESSION:HEIGHT-CHARS,0))
  NO-ERROR.

CREATE WINDOW qbf-win
  ASSIGN
    WIDTH          = def-win-wid
    HEIGHT         = {&DEF_WIN_HEIGHT}
    MIN-WIDTH      = {&MIN_WIN_WIDTH}
    MIN-HEIGHT     = {&MIN_WIN_HEIGHT}
    SCROLL-BARS    = NO
    RESIZE         = YES
    STATUS-AREA    = FALSE
    MESSAGE-AREA   = FALSE
    HIDDEN         = TRUE
    THREE-D        = TRUE
    .

ASSIGN
  qbf-win:VIRTUAL-WIDTH  = SESSION:WIDTH
  qbf-win:VIRTUAL-HEIGHT = SESSION:HEIGHT 
  qbf-win:ROW            = MAXIMUM(1,(SESSION:HEIGHT - {&DEF_WIN_HEIGHT}) / 2)
  qbf-win:COLUMNS        = MAXIMUM(1,(SESSION:WIDTH - def-win-wid) / 2)
  NO-ERROR.

/* Load the default icon, in case there isn't one provided. */
ASSIGN qbf-l = qbf-win:LOAD-ICON(_minLogo).

/* Temporary window to show the startup logo. */
CREATE WINDOW qbf-wlogo
  ASSIGN
    WIDTH           = def-win-wid
    HEIGHT          = {&DEF_WIN_HEIGHT}
    STATUS-AREA     = FALSE
    MESSAGE-AREA    = FALSE
    HIDDEN          = TRUE
    RESIZE          = FALSE
    SHOW-IN-TASKBAR = FALSE
    CONTROL-BOX     = FALSE
    TITLE           = ""
    .

ASSIGN CURRENT-WINDOW = qbf-wlogo.

/* hack up propath to put blank entry first */
ASSIGN
  qbf-propath = PROPATH
  qbf-c       = PROPATH.
  
DO WHILE INDEX(qbf-c,",,":u) > 0:
  ASSIGN SUBSTRING(qbf-c,INDEX(qbf-c,",,":u),2,"CHARACTER":u) = ",":u.
END.
ASSIGN PROPATH = (IF qbf-c BEGINS ",":u THEN "" ELSE ",":u) + qbf-c.

PAUSE 0 BEFORE-HIDE.
HIDE MESSAGE NO-PAUSE.

IF NUM-DBS = 0 THEN DO:
  ASSIGN SESSION:THREE-D = TRUE.
  MESSAGE "There is no database connected." SKIP
    "Would you like to connect now?"
    VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL UPDATE qbf-l.
  ASSIGN SESSION:THREE-D = FALSE.

  IF qbf-l THEN DO:
    ASSIGN qbf-c = ?.
    RUN adecomm/_dbconn.p
      (INPUT-OUTPUT qbf-c,INPUT-OUTPUT qbf-c,INPUT-OUTPUT qbf-c).
  END.
END.

IF NUM-DBS > 0 THEN DO:
  IF LDBNAME("RESULTSDB":u) = ? THEN
    CREATE ALIAS "RESULTSDB":u FOR DATABASE VALUE(LDBNAME(1)).

  RUN aderes/_conndb.p. /* get unconnected DataServers */

  /* Now check to see if there any databases that RESULTS can't work with.
  RESULTS does not work some foreign databases. */
  DO qbf-i = 1 TO NUM-DBS:
    ASSIGN qbf-c = DBTYPE(qbf-i).

    IF LOOKUP(qbf-c,"AS400,CISAM,DB2,ODBC,ORACLE,PROGRESS,RMS,SYB10,MSS":u) = 0
      THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
        SUBSTITUTE("Attempt to connect to database &1, that is not supported by &2.  &2 does not support databases of type &3.",
        LDBNAME(qbf-i),qbf-product,qbf-c)).

      ASSIGN qbf-h = qbf-wlogo:FIRST-CHILD.
      IF VALID-HANDLE(qbf-h) THEN
        DELETE WIDGET qbf-h.
      IF VALID-HANDLE(qbf-wlogo) THEN
        DELETE WIDGET qbf-wlogo.
      RETURN.
    END.

    /* Make sure that there are no relevant restrictions. If so, then abort. */
    ASSIGN qbf-c = DBRESTRICTIONS(1).

    DO qbf-j = 1 TO NUM-ENTRIES(qbf-c):
      IF   ENTRY(qbf-j, qbf-c) = "LAST":u
        OR ENTRY(qbf-j, qbf-c) = "PREV":u
        OR ENTRY(qbf-j, qbf-c) = "ROWID":u
        OR ENTRY(qbf-j, qbf-c) = "USE-INDEX":u THEN DO:

        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
          SUBSTITUTE("The database &1 has the &2 restriction.  &3 cannot connect to the database.",
          LDBNAME(qbf-j),ENTRY(qbf-j,qbf-c),qbf-product)).

        ASSIGN qbf-h = qbf-wlogo:FIRST-CHILD.
        IF VALID-HANDLE(qbf-h) THEN
          DELETE WIDGET qbf-h.
        IF VALID-HANDLE(qbf-wlogo) THEN
          DELETE WIDGET qbf-wlogo.
        RETURN.
      END.
    END.
  END. /* foreign db check */

  RUN adecomm/_setcurs.p ("WAIT":u).

  /* Initialize critical variables */
  RUN aderes/_asetvar.p.

  /* Find configuration file, if available */
  RUN aderes/a-search.p (OUTPUT qbf-qcfile).

  /* remove aliases that begin with QBF$ */
  ASSIGN qbf-l = FALSE.
  DO qbf-i = 1 TO NUM-ALIASES:
    IF ALIAS(qbf-i) BEGINS "QBF$":u THEN
      DELETE ALIAS VALUE(ALIAS(qbf-i)).
  END.
  DO qbf-i = 1 TO NUM-DBS:
    ASSIGN qbf-l = qbf-l OR LDBNAME(qbf-i) BEGINS "QBF$":u
      OR LDBNAME(qbf-i) = "RESULTSDB":u.
  END.
  IF NUM-DBS = 0 THEN
    ASSIGN qbf-e = "There are no databases connected.".
  ELSE
    IF qbf-l AND NUM-DBS > 1 THEN
      ASSIGN qbf-e = 'Cannot build WHEN DATABASE logical name starts WITH "QBF$"'.

  /* abort build if, after stripping out databases with QBF$ prefix
     error encountered */
  IF qbf-e > "" THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,qbf-e).
    RETURN.
  END.

  /* just set up a bunch of QBF$x aliases to point at something */
  DO qbf-i = 0 TO NUM-DBS + 5:
    CREATE ALIAS VALUE("QBF$":u + STRING(qbf-i)) FOR DATABASE VALUE(LDBNAME(1)).
  END.

  /* Register out application with the menu system. Has to be done before
     we create any features. */
  RUN adeshar/_madda.p ({&resId},?,"",OUTPUT qbf-l).

  /* Partial read of configuration file to get integration procedure hooks.
     Abort RESULTS if there is a problem reading file.  Run logo stuff as soon
     as we find it. */
  ASSIGN qbf-l = FALSE.
  IF SEARCH(qbf-qcfile + {&qcExt}) <> ? THEN
    RUN aderes/_aread.p (1,OUTPUT qbf-l).
  ELSE
    RUN aderes/u-logo.p.

  DO WHILE NOT qbf-l ON STOP UNDO,LEAVE:
    /* Call the menu and loop, and if the admin wants, call our stuff
       through their stuff */
    IF qbf-u-hook[{&ahSharedVar}] <> ? THEN DO:
      /* The admin defined shared var doesn't have a Results Core version. If
         the Admin doesn't provide a function then "proceed to go" directly */
         RUN aderes/_ssearch.p (qbf-u-hook[{&ahSharedVar}],OUTPUT qbf-c).

      IF qbf-c = ? THEN DO:
        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
          SUBSTITUTE("The Admin function, &1, was defined but not found for the Admin Initialization Hook.  &2 cannot run the procedure and will start without it.",
          qbf-u-hook[{&ahSharedVar}],qbf-product)).
        RUN aderes/_sinit.p.
      END.
      ELSE DO:
        Sharedhook:
        DO ON STOP UNDO sharedHook, RETRY sharedHook:
          IF RETRY THEN DO:
            RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
              SUBSTITUTE("There is a problem with &1.  &2 cannot run the procedure and will start without it.",
              qbf-c,qbf-product)).
            RUN aderes/_sinit.p.
            LEAVE sharedHook.
          END.

          /* Run the shared variable program */
          RUN VALUE(qbf-u-hook[{&ahSharedVar}]) ("aderes/_sinit.p":u).
        END.
      END.
    END.
    ELSE
      RUN aderes/_sinit.p.

    ASSIGN qbf-l = TRUE.
  END.
END.

/* shut down all Print Preview windows */
FOR EACH qbf-wsys:
  RUN aderes/y-page2.p ("c":u,qbf-wsys.qbf-wwin,0).
END.

IF VALID-HANDLE(qbf-wlogo) THEN
  DELETE WIDGET qbf-wlogo.

IF qbf-win <> ? THEN DO:
  ASSIGN
    qbf-win:VISIBLE  = FALSE
    CURRENT-WINDOW   = DEFAULT-WINDOW.
  DELETE WIDGET qbf-win.
END.

HIDE ALL NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
PAUSE BEFORE-HIDE.

ASSIGN PROPATH = qbf-propath.

RUN adecomm/_adehelp.p ("res":u,"QUIT":u,?,?).

/* On the way out, make sure that the watch cursor is off */
RUN adecomm/_setcurs.p ("").

ASSIGN SESSION:THREE-D = old-3d.   /* restore session 3D state */

IF qbf-goodbye THEN
  QUIT.
ELSE
  RETURN.

/* aderes.p - end of file */

