/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _ttyconv.p
*
*    Converts a TTY Results application to GUI Results.
*
*    The configuration file, as well as the query files will be
*    moved to GUI Results.
*/

&GLOBAL-DEFINE WIN95-BTN YES

/* Do I really need all these? -dma 
{ aderes/s-system.i NEW }
{ aderes/s-define.i NEW }
{ aderes/a-define.i NEW }
{ aderes/e-define.i NEW }
{ aderes/l-define.i NEW }
{ aderes/r-define.i NEW }
{ aderes/i-define.i NEW }
{ aderes/j-define.i NEW }
{ aderes/y-define.i NEW }
{ aderes/s-output.i NEW }
{ aderes/t-define.i NEW }
{ aderes/s-menu.i NEW }
{ aderes/fbdefine.i NEW }
{ adeshar/_mnudefs.i NEW }
{ aderes/_fdefs.i }
{ adecomm/adestds.i }
{ aderes/_alayout.i }
*/
{ aderes/reshlp.i }

&SCOPED-DEFINE WINDOW-NAME convWindow
&SCOPED-DEFINE FRAME-NAME  convFrame

DEFINE NEW SHARED VARIABLE {&WINDOW-NAME} AS HANDLE  NO-UNDO.
DEFINE NEW SHARED VARIABLE initDb         AS LOGICAL NO-UNDO.

DEFINE VARIABLE c-type     AS INTEGER   NO-UNDO. /* conversion type */
DEFINE VARIABLE lRet       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE m_main-h   AS HANDLE    NO-UNDO.
DEFINE VARIABLE qbf-i      AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-s      AS LOGICAL   NO-UNDO.

/* Menu definitions */
DEFINE SUB-MENU m_file
  MENU-ITEM m_Exit           LABEL "E&xit".
  
DEFINE SUB-MENU m_Convert
  MENU-ITEM m_Configuration  LABEL "&Configuration"
  MENU-ITEM m_Query          LABEL "&Query Directory"
  MENU-ITEM m_AllFiles       LABEL "&All Files".
  
DEFINE SUB-MENU m_Help
  MENU-ITEM m_Master         LABEL "OpenEdge &Master Help"
  MENU-ITEM m_Contents       LABEL "&Contents"
  MENU-ITEM m_SearchForHelp  LABEL "&Search for Help On..."
  RULE
  MENU-ITEM m_HowTo          LABEL "&How To"
  MENU-ITEM m_Messages       LABEL "M&essages..."
  MENU-ITEM m_RecentMessages LABEL "&Recent Messages..."
  RULE
  MENU-ITEM m_AboutConverter LABEL "&About Converter...".

DEFINE MENU m_Main MENUBAR
  SUB-MENU m_File            LABEL "&File"
  SUB-MENU m_Convert         LABEL "&Convert"
  SUB-MENU m_Help            LABEL "&Help".

m_main-h = MENU m_Main:HANDLE.

{ aderes/_asbar.i }

CREATE WINDOW {&WINDOW-NAME}
  ASSIGN
    VISIBLE          = FALSE
    TITLE            = "RESULTS Converter"
    WIDTH            = 70 
    HEIGHT           = 6 
    RESIZE           = FALSE
    SCROLL-BARS      = FALSE
    STATUS-AREA      = FALSE
    BGCOLOR          = ?
    FGCOLOR          = ?
    MESSAGE-AREA     = FALSE
    THREE-D          = TRUE 
    SENSITIVE        = TRUE
    MENUBAR          = m_main-h
    .

/*-----------------------------------------------------------------------*/
ON HELP OF {&WINDOW-NAME}
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&RESULTS_Converter_Window},?).

ON CHOOSE OF MENU-ITEM m_Exit
  APPLY "WINDOW-CLOSE":u TO {&WINDOW-NAME}.

ON CHOOSE OF MENU-ITEM m_Configuration 
  RUN aderesc/_convqc.p.
  
ON CHOOSE OF MENU-ITEM m_Query
  RUN aderesc/_convu.p.

ON CHOOSE OF MENU-ITEM m_AllFiles DO:
  RUN aderesc/_convqc.p.
  RUN aderesc/_convu.p.
END.

ON CHOOSE OF MENU-ITEM m_Contents
  RUN adecomm/_adehelp.p ("res":u,"CONTENTS":u,?,?).
  
ON CHOOSE OF MENU-ITEM m_Master
  RUN adecomm/_adehelp.p ("mast":u,"CONTENTS":u,?,?).

ON CHOOSE OF MENU-ITEM m_SearchForHelp
  RUN adecomm/_adehelp.p ("res":u,"PARTIAL-KEY":u,?,"").
 
ON CHOOSE OF MENU-ITEM m_HowTo
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&How_To}, ?).
  
ON CHOOSE OF MENU-ITEM m_Messages
  RUN prohelp/_msgs.p.
  
ON CHOOSE OF MENU-ITEM m_RecentMessages
  RUN prohelp/_rcntmsg.p.
  
ON CHOOSE OF MENU-ITEM m_AboutConverter
  RUN adecomm/_about.p ("RESULTS Converter":u,"adeicon/results%":u).
  
/*--------------------------- Main Block -------------------------------*/
/* Send messages to alert boxes because there is no message area. */
ASSIGN 
  CURRENT-WINDOW              = {&WINDOW-NAME}
  SESSION:SYSTEM-ALERT-BOXES  = TRUE
  lRet                        = {&WINDOW-NAME}:LOAD-ICON("adeicon/results%":u)
  .

PAUSE 0 BEFORE-HIDE.

/* check for presence of QBF$ ldbname */
DO qbf-i = 1 TO NUM-DBS:
  qbf-s = qbf-s OR LDBNAME(qbf-i) BEGINS "QBF$":u 
                OR LDBNAME(qbf-i) = "RESULTSDB":u.
END.
IF qbf-s AND NUM-DBS > 1 THEN DO:
  MESSAGE "Can't build with QBF$* ldbname present."
    VIEW-AS ALERT-BOX ERROR.
  RETURN.
END.

/* Worry about alias code. Some of V7 RESULTS code (_awrite) needs this. */
DO qbf-i = 1 TO NUM-ALIASES:
  IF ALIAS(qbf-i) BEGINS "QBF$":u THEN
    DELETE ALIAS VALUE(ALIAS(qbf-i)).
END.

/* Set up a bunch of QBF$n aliases to point at something */
DO qbf-i = 0 TO NUM-DBS + 5:
  CREATE ALIAS VALUE("QBF$":u + STRING(qbf-i))
    FOR DATABASE VALUE(LDBNAME(1)).
END.

{&WINDOW-NAME}:VISIBLE = TRUE.

RUN aderesc/_convtyp.p (OUTPUT c-type).

IF c-type = 1 OR c-type = 3 THEN
  RUN aderesc/_convqc.p.
IF c-type = 2 OR c-type = 3 THEN
  RUN aderesc/_convu.p.

DO ON ERROR UNDO, LEAVE ON END-KEY UNDO, LEAVE:
  WAIT-FOR WINDOW-CLOSE OF {&WINDOW-NAME}.
END.

DELETE WIDGET {&WINDOW-NAME}.

RETURN.

/* _ttyconv.p - end of file */

