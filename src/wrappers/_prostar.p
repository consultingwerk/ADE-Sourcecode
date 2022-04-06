/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/******************************************************************************* 
*
*   PROGRAM:  prostart.p
*
*   PROGRAM SUMMARY:
*       Standard PROGRESS Startup Procedure
*
*   RUN/CALL SYNTAX:
*       RUN prostart.p
*
*   PARAMETERS/ARGUMENTS LIST:
*       None
*
*******************************************************************************/

{ login.i NEW }

DEFINE VARIABLE savedb   AS CHARACTER.
DEFINE VARIABLE i        AS INTEGER.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
DEFINE VARIABLE login_window AS WIDGET-HANDLE.
&ENDIF

/******************************************************************************* 
* tty specific banners
*******************************************************************************/

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
/* display hello and version for VMS */
IF OPSYS = "VMS" THEN DO:
    VMS SILENT "@DLC:prostart.com".
END.
/* display hello and version for BTOS */
IF OPSYS = "BTOS" THEN DO:
    DEFINE VARIABLE filename AS CHARACTER.
    filename = SEARCH("hello").
    IF filename <> ? THEN
        BTOS OS-COPY VALUE(filename).
    filename = SEARCH("version").
    IF filename <> ? THEN
        BTOS OS-COPY VALUE(filename).
    PAUSE 3.
END.

IF OPSYS = "VMS" THEN DO:
DISPLAY " ".
END.
HIDE ALL NO-PAUSE.
&ENDIF

/******************************************************************************* 
* main
*******************************************************************************/

/* Prompt for userid and password in all connected Progress databases */
/* (If not supplied as startup parameters).         */
/* Non Progress databases MUST supply userid/passwd using -U and -P   */
/* startup parameters.            */

IF NUM-DBS > 0 THEN 
    savedb = LDBNAME("DICTDB").

IF NUM-DBS > 1 AND savedb = "DICTDB" THEN DO:
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    RUN create_login_window.
    login_window:VISIBLE = TRUE.
    DISPLAY savedb @ currentdb WITH FRAME login_frame IN WINDOW login_window.
    &ENDIF
    BELL.
    MESSAGE
        "You cannot use security if you have more than one database" SKIP
        "connected and the logical name of one database is DICTDB."
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
END.
ELSE IF NUM-DBS > 0 THEN DO:
    DO i = 1 to NUM-DBS:
        IF DBTYPE(i) <> "PROGRESS" THEN NEXT.
        CREATE ALIAS DICTDB FOR DATABASE VALUE( LDBNAME(i) ).
	&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
	IF login_window = ? THEN
	    RUN create_login_window.
	&ENDIF
        RUN _login.p(false).
    END.
    /************************************************************************** 
       Be certain the database assigned DICTDB by Progress is still connected.
       If not, assign DICTDB to first db still connected.  This can happen if
       PROGRESS runs -p startup procedure, connects to more than one database,
       and then before the -p routine completes, the first connected database
       (DICTDB) gets disconnected.
    **************************************************************************/
    IF ( savedb <> ? ) 
        THEN CREATE ALIAS DICTDB FOR DATABASE VALUE( savedb ).
        ELSE CREATE ALIAS DICTDB FOR DATABASE VALUE( LDBNAME(1) ).
END.

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
HIDE ALL NO-PAUSE.
&ELSE
RUN destroy_login_window.
&ENDIF

/******************************************************************************* 
* create_login_window
* destroy_login_window
* 
* Create a special window for the login frame when running under a GUI.
*******************************************************************************/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN

PROCEDURE create_login_window.

    DEFINE VARIABLE ok AS LOGICAL.

    DEFAULT-WINDOW:VISIBLE = FALSE.
    CREATE WINDOW login_window
        ASSIGN
            X               = CURRENT-WINDOW:X
            Y               = CURRENT-WINDOW:Y
            HEIGHT-PIXELS   = FRAME login_frame:HEIGHT-PIXELS
            WIDTH-PIXELS    = FRAME login_frame:WIDTH-PIXELS
            TITLE           = "Login"
            VISIBLE         = FALSE
            MESSAGE-AREA    = NO
            STATUS-AREA     = NO
            HIDDEN          = True.

    ok = login_window:LOAD-ICON("adeicon/progress").
    SESSION:SYSTEM-ALERT-BOXES = YES.

    CURRENT-WINDOW = login_window.
END.

PROCEDURE destroy_login_window.
    IF login_window <> ? THEN
        DELETE WIDGET login_window.
END.

&ENDIF

