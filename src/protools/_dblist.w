&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: protools/_dblist.w

  Description: DB Connections PRO*Tools window

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Tammy Marshall

  Created: 04/09/99

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

{ adecomm/_adetool.i }
{ protools/_runonce.i }
{ protools/_schdef.i }  /* TableDetails, FieldDetails, IndexDetails temp table definitions */

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE run_dblist  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE db_lname    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSelcDB     AS CHARACTER  NO-UNDO.  /* currently selected db */
DEFINE VARIABLE iHeightChng AS INTEGER    NO-UNDO.  /* new height of frame and window to display DB connection info */
DEFINE VARIABLE hSchema     AS HANDLE     NO-UNDO.  /* Schema window handle */
DEFINE VARIABLE cTableList  AS CHARACTER  NO-UNDO.  /* comma separated list of table names */  
DEFINE VARIABLE cDBName     AS CHARACTER  NO-UNDO.  /* database name */
DEFINE VARIABLE cDBType     AS CHARACTER  NO-UNDO.  /* type of db - PROGRESS or foreign */
DEFINE VARIABLE hChildWin   AS HANDLE     NO-UNDO.  /* handle of Schema window */
DEFINE VARIABLE lExists     AS LOGICAL    NO-UNDO.  
DEFINE VARIABLE gwflag      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE db-type     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE db-name     AS CHARACTER  NO-UNDO.

/* Shared variable needed when connecting to an Oracle database */
DEFINE NEW SHARED VARIABLE drec_db AS RECID INITIAL ? NO-UNDO.

DEFINE TEMP-TABLE run-list
  FIELD rdb-name  AS CHARACTER /* database name */
  FIELD sh-name  AS CHARACTER /* schema holder name */
  FIELD prg-name AS CHARACTER /* program which uses it */
  INDEX db-name  IS PRIMARY rdb-name.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bClose db-list bHelp bConnect dbRect 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD availFld C-Win 
FUNCTION availFld RETURNS LOGICAL
 ( INPUT pcTblName AS CHARACTER, INPUT pcFldName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD availIdx C-Win 
FUNCTION availIdx RETURNS LOGICAL
 ( INPUT pcTblName AS CHARACTER, INPUT pcIdxName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD availTbl C-Win 
FUNCTION availTbl RETURNS LOGICAL
  ( INPUT pcTblName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dbconn C-Win 
FUNCTION dbconn RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getdbName C-Win 
FUNCTION getdbName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getdbType C-Win 
FUNCTION getdbType RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFld C-Win 
FUNCTION getFld RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getIndx C-Win 
FUNCTION getIndx RETURNS CHARACTER
  ( INPUT cTable AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTbl C-Win 
FUNCTION getTbl RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bClose 
     LABEL "C&lose" 
     SIZE 20 BY 1.14.

DEFINE BUTTON bConnect 
     LABEL "&Connect" 
     SIZE 20 BY 1.14.

DEFINE BUTTON bHelp 
     LABEL "&Help" 
     SIZE 20 BY 1.14.

DEFINE BUTTON b_DBDetails 
     LABEL "&DB Details >>" 
     SIZE 20 BY 1.14.

DEFINE BUTTON b_disconnect 
     LABEL "D&isconnect" 
     SIZE 20 BY 1.14.

DEFINE BUTTON b_Schema 
     LABEL "&Schema Details" 
     SIZE 20 BY 1.14.

DEFINE VARIABLE eInfo AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 76 BY 5.24
     FONT 0 NO-UNDO.

DEFINE VARIABLE eLbl AS CHARACTER FORMAT "X(256)":U INITIAL "Connection Information" 
     LABEL "" 
      VIEW-AS TEXT 
     SIZE 23 BY .76 NO-UNDO.

DEFINE RECTANGLE connrect
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 78 BY 6.

DEFINE RECTANGLE dbRect
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57 BY 8.81.

DEFINE VARIABLE db-list AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 55 BY 8
     FONT 0 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     bClose AT ROW 1.52 COL 60
     db-list AT ROW 2 COL 3 NO-LABEL
     bHelp AT ROW 2.86 COL 60
     bConnect AT ROW 4.91 COL 60
     b_disconnect AT ROW 6.24 COL 60
     b_Schema AT ROW 7.86 COL 60
     b_DBDetails AT ROW 9.19 COL 60
     eInfo AT ROW 11.33 COL 3 NO-LABEL
     eLbl AT ROW 10.43 COL 2 COLON-ALIGNED
     connrect AT ROW 10.81 COL 2
     dbRect AT ROW 1.52 COL 2
     "Databases" VIEW-AS TEXT
          SIZE 11.2 BY .62 AT ROW 1.19 COL 3.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 16.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Database Connections"
         HEIGHT             = 16
         WIDTH              = 80
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80
         MAX-BUTTON         = no
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* SETTINGS FOR BUTTON b_DBDetails IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b_disconnect IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b_Schema IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE connrect IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       connrect:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR SELECTION-LIST db-list IN FRAME DEFAULT-FRAME
   NO-DISPLAY                                                           */
/* SETTINGS FOR EDITOR eInfo IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       eInfo:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE
       eInfo:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN eLbl IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       eLbl:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Database Connections */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Database Connections */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bClose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bClose C-Win
ON CHOOSE OF bClose IN FRAME DEFAULT-FRAME /* Close */
DO:
  /* Applying window-close to this window will close this window and will cause
     a parent-window-close event to fire in any child windows */
  APPLY "WINDOW-CLOSE":U TO C-Win.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bConnect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bConnect C-Win
ON CHOOSE OF bConnect IN FRAME DEFAULT-FRAME /* Connect */
DO:
  Define var lline         as char    NO-UNDO. /* sel-list line */
  
  /* Database Parameters */
  DEFINE VARIABLE PysName       AS CHARACTER    NO-UNDO. /* Physical DB Name */
  DEFINE VARIABLE LogName       AS CHARACTER    NO-UNDO. /* Logical DB Name  */
  DEFINE VARIABLE theType       AS CHARACTER    NO-UNDO. /* DB Name Type - eg. "PROGRESS" */
  DEFINE VARIABLE Db_Multi_User AS LOGICAL      NO-UNDO.

  /* Addl. Parameters */
  DEFINE VARIABLE network       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE host          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE service       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE uid           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE pwd           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE trigloc       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE pfile         AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE uparms        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE pargs         AS CHARACTER    NO-UNDO.
   
  DEFINE VARIABLE args          AS CHARACTER EXTENT 4 NO-UNDO.
  DEFINE VARIABLE logname2      AS CHARACTER          NO-UNDO.
  DEFINE VARIABLE constring     AS CHARACTER          NO-UNDO.
  
  DEFINE VARIABLE x             AS INTEGER            NO-UNDO.
  DEFINE VARIABLE iPos          AS INTEGER            NO-UNDO.
  
  if substring(db-list:SCREEN-VALUE ,28, -1, "CHARACTER") = "(not connected)" THEN 
  DO: /* connect dataserver */ 
      ASSIGN     
      logname = trim(substring(db-list:SCREEN-VALUE, 1, 15, "CHARACTER"))
      theType = trim(substring(db-list:SCREEN-VALUE,17,11, "CHARACTER"))
      theType = substring(theType,1,length(theType, "CHARACTER") - 1, "CHARACTER").

      run prodict/misc/_getconp.p
              (INPUT        logname,
               INPUT-OUTPUT PysName,
               INPUT-OUTPUT logname2,
               INPUT-OUTPUT theType,
               OUTPUT       trigloc,
               OUTPUT       pfile,
               OUTPUT       Db_Multi_User,
               OUTPUT       network,
               OUTPUT       host,
               OUTPUT       service,
               OUTPUT       uid,
               OUTPUT       pwd,
               OUTPUT       args[2],
               OUTPUT       args[3],
               OUTPUT       args[4]
               ).  
      ASSIGN pargs = trim(args[2] + " " + args[3] + " " + args[4]).
  END.  
  ELSE
  /* Set defaults for the db connect dialog. */
  ASSIGN DB_Multi_User = no
         theType       = "PROGRESS":U.

  run adecomm/_dbconnx.p ( YES,
                          INPUT-OUTPUT PysName,
                          INPUT-OUTPUT LogName,
                          INPUT-OUTPUT theType,       
                          INPUT-OUTPUT Db_Multi_User,
                          INPUT-OUTPUT network,
                          INPUT-OUTPUT host,
                          INPUT-OUTPUT service,
                          INPUT-OUTPUT uid,
                          INPUT-OUTPUT pwd,
                          INPUT-OUTPUT trigloc,
                          INPUT-OUTPUT pfile,
                          INPUT-OUTPUT pargs,
                          OUTPUT       constring ).

  /* Was a database connected */    
  /*message constring length(constring) view-as alert-box. */            
  IF theType = "PROGRESS":U THEN DO:
    
    x = 1.
    DO x = 1 TO NUM-DBS:
      ASSIGN lline                = LDBNAME(x).
             substring(lline, 16, -1, "CHARACTER") = "[" + dbtype(LDBNAME(x)) + "]".
      iPos = LOOKUP(lline,db-list:LIST-ITEMS,db-list:DELIMITER).
      IF DBTYPE(LDBNAME(X)) = "PROGRESS":U AND (iPos = 0 OR iPos = ?) THEN DO:
        db-list:ADD-LAST(lline).
        CREATE ALIAS tinydict FOR DATABASE VALUE(LDBNAME(x)). /* needed for next procedure */
        RUN protools/_db_gw.p (OUTPUT gwflag, OUTPUT db-name, OUTPUT db-type). /* Is schema-holder? If so, of what? */
        DELETE ALIAS tinydict.
        IF gwflag THEN DO x = 1 to NUM-ENTRIES(db-name): /* go after foreign databases */
          ASSIGN lline = "  " + entry(x,db-name)
                 substring(lline,16,-1,"CHARACTER") = "[" + entry(x,db-type) + "]".
          IF NOT CONNECTED(entry(x,db-name)) THEN
                 substring(lline,28,-1,"CHARACTER") = "(not connected)".
          IF db-list:ADD-LAST(lline) THEN.
        END.  /* if gwflag */      
      END.  /* if dbtype = "PROGRESS" and iPos = 0 or ? */
    END.  /* do x = 1 to num-dbs */
  END.  /* if theType = "PROGRESS" */

  IF CONNECTED(logname) THEN DO: /* hey! we connected something */
    IF theType <> "PROGRESS" THEN DO:
        IF NOT db-list:SCREEN-VALUE BEGINS logname THEN DO:
          search-blk:
          DO x = 1 TO db-list:NUM-ITEMS:
            IF TRIM(db-list:ENTRY(x)) BEGINS logname THEN DO:
              ASSIGN lline = db-list:ENTRY(x)
                     db-list:SCREEN-VALUE = lline.
              LEAVE search-blk.
            END.  /* Found the correct line */
          END.  /* search-blk */
        END.  /* If selected line isn't the correct line */
        lline = substring(db-list:SCREEN-VALUE,1,27,"CHARACTER").
        IF db-list:REPLACE(lline, db-list:SCREEN-VALUE) THEN.
        ASSIGN db-list:SCREEN-VALUE   = lline
               b_dbdetails:SENSITIVE    = yes
               b_schema:SENSITIVE     = yes
               b_disconnect:SENSITIVE = yes.
    END.
    IF PysName ne ? AND eInfo:VISIBLE THEN RUN fill-editor.
    IF db-list:NUM-ITEMS <> 0 and db-list:SCREEN-VALUE = ? THEN DO:
        db-list:SCREEN-VALUE = db-list:ENTRY(1).
        APPLY "VALUE-CHANGED" TO db-list.
        IF b_dbdetails:SENSITIVE = no THEN b_dbdetails:SENSITIVE = yes.
        IF b_Schema:SENSITIVE = no THEN b_Schema:SENSITIVE = yes.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bHelp C-Win
ON CHOOSE OF bHelp IN FRAME DEFAULT-FRAME /* Help */
DO:
  RUN adecomm/_adehelp.p
    (INPUT "ptls":U, 
     INPUT "CONTEXT":U, 
     INPUT 17, 
     INPUT  ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_DBDetails
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_DBDetails C-Win
ON CHOOSE OF b_DBDetails IN FRAME DEFAULT-FRAME /* DB Details >> */
DO:
  /* Need to see if the database is still connected - it may have been 
     disconnected through the data dictionary */
  IF NOT dbconn() THEN DO:
    MESSAGE "You are no longer connected to" CAPS(getdbName()) + " database"
      VIEW-AS ALERT-BOX INFORMATION.
    db-list:DELETE(db-list).  /* remove db from list b/c no longer connected to it */
    IF db-list:NUM-ITEMS > 0 THEN
      ASSIGN db-list:SCREEN-VALUE = db-list:ENTRY(1). 
    IF db-list:SCREEN-VALUE = ? OR db-list:NUM-ITEMS = 0 THEN
      ASSIGN  b_DBDetails:SENSITIVE = no
              b_Schema:SENSITIVE  = no
              b_Disconnect:SENSITIVE = no.
  END.  /* selected database no longer connected */
  
  ELSE DO:  /* selected database is still connected */
    
    /* The expanded Information is HIDDEN if the dialog is alreadey collapsed */
    IF eInfo:HIDDEN THEN
    DO: /* Expand window */
   
      /* Calculate what the window and frame height needs to be changed to 
         when the window initially displays with the DB Connection Info hidden */
      ASSIGN iHeightChng = connrect:ROW + connrect:HEIGHT - 1.0 +
        FRAME {&FRAME-NAME}:BORDER-TOP + 
        FRAME {&FRAME-NAME}:BORDER-BOTTOM +
        0.4.            
           
      ASSIGN {&WINDOW-NAME}:HEIGHT = iHeightChng
             {&WINDOW-NAME}:VIRTUAL-HEIGHT = iHeightChng
             FRAME {&FRAME-NAME}:HEIGHT = iHeightChng   
             FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT = iHeightChng   
             eInfo:HIDDEN = no
             eLbl:HIDDEN  = no
             connrect:HIDDEN = no
             eInfo:SENSITIVE = yes.
                        
      RUN Fill-Editor.
      ASSIGN self:label = "Hide &DB Details <<".
    END.  /* expand window */ 
    ELSE /* collapse window */
    DO:
      ASSIGN iHeightChng = dbrect:ROW + dbrect:HEIGHT - 1.0 +
        FRAME {&FRAME-NAME}:BORDER-TOP + 
        FRAME {&FRAME-NAME}:BORDER-BOTTOM +
        0.4. 

      ASSIGN eInfo:HIDDEN = yes
             connrect:HIDDEN = yes
             eLbl:HIDDEN  = yes 
             FRAME {&FRAME-NAME}:HEIGHT = iHeightChng
             FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT = iHeightChng
             {&WINDOW-NAME}:HEIGHT = iHeightChng
             {&WINDOW-NAME}:VIRTUAL-HEIGHT = iHeightChng
             self:LABEL = "&DB Details >>".
    END.  /* else do - collapse window */
  END.  /* else do - database still connected */
END.  /* choose */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_disconnect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_disconnect C-Win
ON CHOOSE OF b_disconnect IN FRAME DEFAULT-FRAME /* Disconnect */
DO:
  DEFINE VARIABLE dbtodisc AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE errmsg   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE prgstr   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE fdstr    AS CHARACTER NO-UNDO.
  
  /* Generate list of database which code is currently running against */
  FOR EACH run-list:
    DELETE run-list.
  END.  /* for each run-list */
  RUN Running_DBList.

  ASSIGN db-list
         dbtodisc = trim(substring(db-list,1,15,"CHARACTER":U)).
  IF CAN-FIND (FIRST run-list WHERE rdb-name EQ dbtodisc) THEN DO:
    FOR EACH run-list WHERE rdb-name EQ dbtodisc:
      prgstr = prgstr + "  " + prg-name + CHR(10).
    END.
    MESSAGE CAPS(dbtodisc) "is in use by the following running procedure" + 
            (IF NUM-ENTRIES(RIGHT-TRIM(prgstr),CHR(10)) > 1 THEN "s:" ELSE ":") skip(1)
            RIGHT-TRIM(prgstr) skip(1)
            CAPS(dbtodisc) "cannot be disconnected until all procedures that" {&SKP}
            "access it are terminated."
            VIEW-AS ALERT-BOX INFORMATION.
    RETURN NO-APPLY.
  END.  
  ELSE IF CAN-FIND (FIRST run-list WHERE sh-name EQ dbtodisc) THEN DO:
    /* Trying to disconnect the schema of a database which has running code! */
    FOR EACH run-list WHERE sh-name EQ dbtodisc BREAK BY rdb-name:
      IF FIRST-OF(rdb-name) THEN 
        prgstr = CHR(10) + "Foreign Database: " + rdb-name + CHR(10) + "Running Procedure(s): " + prg-name.
      ELSE prgstr = prgstr + ", " + prg-name.
    END.
    MESSAGE CAPS(dbtodisc) "is a schema-holder database for at least one foreign" skip
            "database which is currently in use by a running procedure:" skip(1)
            TRIM(prgstr) skip(1)
            CAPS(dbtodisc) "cannot be disconnected until all procedures that" skip
            "access its foreign databases are terminated."
            VIEW-AS ALERT-BOX INFORMATION.
    RETURN NO-APPLY.
  END.    
  IF db-list NE "" THEN DISCONNECT VALUE(dbtodisc) NO-ERROR.  
  IF ERROR-STATUS:ERROR THEN DO: /* Oh no! */
    IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
      DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
        errmsg = errmsg + ERROR-STATUS:GET-MESSAGE(i) + 
                 (IF i NE ERROR-STATUS:NUM-MESSAGES THEN chr(10) ELSE ""). 
      END.
      MESSAGE errmsg VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END.
    ELSE MESSAGE "An error occurred during disconnect." 
           VIEW-AS ALERT-BOX ERROR.
    RETURN.
  END. 
  /* Is the database still connected? If so, 'disconnect-pending' */
  IF CONNECTED(dbtodisc) THEN
    MESSAGE "Database: " + dbtodisc + " cannot be disconnected at this time." skip(1)
            "It may be in use by a running procedure or SmartObject." skip(1)
            "It will be disconnected automatically when the last" skip
            "dependant object terminates."
            VIEW-AS ALERT-BOX WARNING.
  ELSE DO:
    RUN initialize-dblist. /* Rebuild list of connected dbs */
    
    /* If Schema window is running then close it */
    IF VALID-HANDLE(hSchema) THEN DO:
      hChildWin = hSchema:CURRENT-WINDOW.
      APPLY "WINDOW-CLOSE":U TO hChildWin.
    END.  /* if Schema window running */
    
    DO i = 1 TO db-list:NUM-ITEMS:
      IF TRIM(SUBSTRING(db-list:ENTRY(i),1,15,"CHARACTER":U)) = dbtodisc THEN
      
      IF SUBSTRING(db-list:ENTRY(i), 28, -1, "CHARACTER") = "(not connected)" THEN.
      ELSE 
        MESSAGE "Database: " + dbtodisc + " cannot be disconnected at this time." skip(1)
                "It may be in use by a running procedure or SmartObject." skip(1)
                "It will be disconnected automatically when the last" skip
                "dependant object terminates."
                VIEW-AS ALERT-BOX WARNING.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Schema
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Schema C-Win
ON CHOOSE OF b_Schema IN FRAME DEFAULT-FRAME /* Schema Details */
DO:
  /* Need to see if the selected db is still connected - it may have been 
     disconnected through the data dictionary */
  IF NOT dbconn() THEN DO:
    MESSAGE "You are no longer connected to" CAPS(getDBName()) + " database"
      VIEW-AS ALERT-BOX INFORMATION.
    db-list:DELETE(db-list).  /* remove db from list b/c no longer connected to it */
    RUN initialize-dblist.
    IF db-list:NUM-ITEMS > 0 THEN 
      ASSIGN db-list:SCREEN-VALUE = db-list:ENTRY(1). 
    IF db-list:SCREEN-VALUE = ? OR db-list:NUM-ITEMS = 0 THEN 
      ASSIGN  b_DBDetails:SENSITIVE = no
              b_Schema:SENSITIVE  = no
              b_Disconnect:SENSITIVE = no.
              
    /* If schema window is running, close it and any child windows */          
    IF VALID-HANDLE(hSchema) THEN DO:
      hChildWin = hSchema:CURRENT-WINDOW.
      APPLY "WINDOW-CLOSE":U TO hChildWin.
    END.  /* if Schema window running */
  END.  /* selected database no longer connected */
  
  ELSE DO:  /* db still connected */
    /* If Schema window is running, don't run it again, move it to the top */
    IF VALID-HANDLE(hSchema) THEN DO:
      hChildWin = hSchema:CURRENT-WINDOW.
      hChildWin:MOVE-TO-TOP().
      APPLY "ENTRY":U TO hChildWin.
    END.  /* if Schema detail window is already running */
    
    /* If Schema window is not already running, run it */
    ELSE DO:
      cDBName = getdbName().
      cDBType = getdbType().
    
      IF db-list:SCREEN-VALUE NE ? THEN 
      DO:
          /* We need to determine if this is a Schema holder, if so, we don't 
             run the Schema detail window */
          CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME(cDBName)). /* needed for next procedure */
          RUN protools/_db_gw.p (OUTPUT gwflag, OUTPUT db-name, OUTPUT db-type). /* Is schema-holder? If so, of what? */
          DELETE ALIAS tinydict.
          IF gwflag AND cDBType = "PROGRESS" THEN MESSAGE 
            "There are no Schema details to display for Schema holders."
            VIEW-AS ALERT-BOX INFORMATION.
          ELSE DO:  /* this is not a schema holder */
            RUN protools/_schlist.w PERSISTENT SET hSchema (INPUT THIS-PROCEDURE).
            RUN RefreshSchema IN hSchema (INPUT cDBName, INPUT cDBType, INPUT getTbl()).
          END.  /* else do - not schema holder */
      END.  /* if db-list screen value ne ? */
      ELSE MESSAGE "You must select a database." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END.  /* else do - Schema window not already running */
  END.  /* else do - db is still connected */
END.  /* choose */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME db-list
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL db-list C-Win
ON VALUE-CHANGED OF db-list IN FRAME DEFAULT-FRAME
DO:
  /* If the foreign db is not connected, disconnected, schema detail and db details
     buttons should not be available */
  IF SUBSTRING(db-list:SCREEN-VALUE, 28, -1,"CHARACTER") = "(not connected)" THEN DO:
  
    IF eInfo:VISIBLE IN FRAME {&FRAME-NAME} = yes THEN DO:
      ASSIGN eInfo:HIDDEN IN FRAME {&FRAME-NAME}    = yes
         connrect:HIDDEN IN FRAME {&FRAME-NAME} = yes
         eLbl:HIDDEN  IN FRAME {&FRAME-NAME}    = yes
         &IF "{&WINDOW-SYSTEM}" EQ "OSF/Motif" &THEN
           b_DBDetails:LABEL = "DB Details >>".
         &ELSE
           b_DBDetails:LABEL = "&DB Details >>".
         &ENDIF  
  
      /* Calculate what the window and frame height needs to be changed to 
         when the window initially displays with the DB Connection Info hidden */
      ASSIGN iHeightChng = dbrect:ROW + dbrect:HEIGHT - 1.0 +
        FRAME {&FRAME-NAME}:BORDER-TOP + 
        FRAME {&FRAME-NAME}:BORDER-BOTTOM +
        0.4.

        ASSIGN FRAME {&FRAME-NAME}:HEIGHT = iHeightChng
             FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT = iHeightChng
             {&WINDOW-NAME}:HEIGHT = iHeightChng
             {&WINDOW-NAME}:VIRTUAL-HEIGHT = iHeightChng.  

    END.  /* if Db Details visible */
    
    ASSIGN 
      b_disconnect:SENSITIVE = no
      b_Schema:SENSITIVE = no
      b_DBDetails:SENSITIVE = no.

    IF VALID-HANDLE(hSchema) THEN DO:
      hChildWin = hSchema:CURRENT-WINDOW.
      APPLY "WINDOW-CLOSE":U TO hChildWin.
    END.  /* if Schema window running */
    RETURN.
  END.  /* if foreign db not connected */
  ELSE b_disconnect:SENSITIVE = yes.

  /* Need to see if the selected db is still connected - it may have been 
     disconnected through the data dictionary */
  IF NOT dbconn() THEN DO:
    MESSAGE "You are not longer connected to" CAPS(cSelcDB) + " database" 
      VIEW-AS ALERT-BOX INFORMATION.
    db-list:DELETE(db-list).  /* remove db from list b/c no longer connected to it */
    RUN initialize-dblist.
    IF db-list:NUM-ITEMS > 0 THEN 
      ASSIGN db-list:SCREEN-VALUE = db-list:ENTRY(1). 
    IF VALID-HANDLE(hSchema) THEN DO:
      hChildWin = hSchema:CURRENT-WINDOW.
      APPLY "WINDOW-CLOSE":U TO hChildWin.
    END.  /* if Schema window running */
  END.  /* if database no longer connected */

  ELSE DO:  /* selected db still connected */
    IF eInfo:VISIBLE THEN RUN fill-editor. /* Show more info about the database */
    ASSIGN 
      b_Schema:SENSITIVE = yes
      b_DBDetails:SENSITIVE = yes.

    /* If Schema window is open, need to get a list of tables for the
       database that user has selected */
    IF VALID-HANDLE(hSchema) THEN DO:
      cDBName = TRIM(substring(db-list:SCREEN-VALUE,1,15,"CHARACTER")).
      cDBType = TRIM(substring(db-list:SCREEN-VALUE,17,11,"CHARACTER")).
      cDBType = substring(cDBType,1,length(cDBType,"CHARACTER") - 1,"CHARACTER").

      IF db-list:SCREEN-VALUE NE ? THEN 
      DO:
        /* We need to determine if this is a Schema holder, if so, we close
           the Schema detail window */
        CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME(cDBName)). /* needed for next procedure */
        RUN protools/_db_gw.p (OUTPUT gwflag, OUTPUT db-name, OUTPUT db-type). /* Is schema-holder? If so, of what? */
        DELETE ALIAS tinydict.
        IF gwflag AND cDBType = "PROGRESS" THEN DO:
          MESSAGE "There are no Schema details to display for Schema holders."
            VIEW-AS ALERT-BOX INFORMATION.
          hChildWin = hSchema:CURRENT-WINDOW.
          APPLY "WINDOW-CLOSE":U TO hChildWin.
        END.  /* if schema holder */
        ELSE DO:
          CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME(cDBName)).
          RUN protools/_tbllist.p (INPUT cDBType, INPUT cDBName, OUTPUT cTableList).
          DELETE ALIAS tinydict.
          RUN RefreshSchema IN hSchema (INPUT cDBName, INPUT cDBType, INPUT cTableList).
        END.  /* else do - not schema holder */
      END.  /* if db-list screen value NE ? */
    END.  /* if schema detail running */
  END.  /* else do - db still connected */
END.  /* value-changed */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Initialize lists */
RUN initialize-dblist.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  APPLY "ENTRY":U TO C-Win.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE bClose db-list bHelp bConnect dbRect 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Fill-Editor C-Win 
PROCEDURE Fill-Editor :
/* -----------------------------------------------------------
  Purpose:     Fill editor with db info.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  ASSIGN 
    db_lname = trim(substring(db-list:SCREEN-VALUE IN FRAME {&FRAME-NAME}, 1, 15,"CHARACTER"))
    cDBType = trim(substring(db-list:SCREEN-VALUE,17,11,"CHARACTER"))
    cDBType = substring(cDBType,1,length(cDBType,"CHARACTER") - 1, "CHARACTER").

  IF db_lname = "" OR db_lname = ? THEN
  ASSIGN einfo = "Database  n/a" + chr(10) +
                 "  Physical Name: n/a" + chr(10) +
                 "  Database Type: n/a" + chr(10) +
                 "  Schema Name  : n/a" + chr(10) +
                 "  Restrictions : n/a". 
  ELSE 
  ASSIGN eInfo = "Database " + db_lname + chr(10) +
                 "  Physical Name: " + (IF PDBNAME(db_lname) = ? THEN "n/a" ELSE PDBNAME(db_lname)) + chr(10)
         eInfo = eInfo + "  Database Type: " + (IF DBTYPE(db_lname) = ?  THEN cDBType ELSE DBTYPE(db_lname))  + chr(10)
         eInfo = eInfo + "  Schema Holder: " + (IF SDBNAME(db_lname) = ? THEN "n/a" ELSE SDBNAME(db_lname)) + chr(10)
         eInfo = eInfo + "  Restrictions : " + (IF DBRESTRICTIONS(db_lname) = "" THEN "None" 
                                       ELSE DBRESTRICTIONS(db_lname)) + CHR(10)
         eInfo = eInfo + (IF DBTYPE(db_lname) NE "PROGRESS" THEN "" ELSE "    DB Version : " + (IF DBVERSION(db_lname) = ? THEN "" ELSE DBVERSION(db_lname)) + CHR(10))
         eInfo = eInfo + "Connect Params : " + (IF DBPARAM(db_lname) = ? THEN "" ELSE DBPARAM(db_lname)) + CHR(10) 
         eInfo = eInfo + "     Code Page : " + (IF DBCODEPAGE(db_lname) = ? THEN "" ELSE DBCODEPAGE(db_lname)) + CHR(10)
         eInfo = eInfo + "     Collation : " + (IF DBCOLLATION(db_lname) = ? THEN "" ELSE DBCOLLATION(db_lname))
  .
  DISPLAY eLbl eInfo with frame {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFieldDetails C-Win 
PROCEDURE getFieldDetails :
/*------------------------------------------------------------------------------
  Purpose: This procedure accepts a temp-table with a record for the
           currently selected field.  It calls _getfld which poplulates
           the temp-table with the field details to display in the Field
           Detail window.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR FieldDetails.

  cDBName = getdbName().
  cDBType = getdbType().
    
  IF db-list:SCREEN-VALUE IN FRAME {&FRAME-NAME} NE ? THEN 
  DO:
      CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME(cDBName)).
      RUN protools/_getfld.p (INPUT cDBType, INPUT cDBName, INPUT-OUTPUT TABLE FieldDetails).
      DELETE ALIAS tinydict.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIndexDetails C-Win 
PROCEDURE getIndexDetails :
/*------------------------------------------------------------------------------
  Purpose: This procedure accepts a temp-table with a record for the
           currently selected field.  It calls _getidx which poplulates
           the temp-table with the index details to display in the Index
           Detail window.         
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR IndexDetails.
DEFINE OUTPUT PARAMETER TABLE FOR IndxFldDetails.

  cDBName = getdbName().
  cDBType = getdbType().
    
  IF db-list:SCREEN-VALUE IN FRAME {&FRAME-NAME} NE ? THEN 
  DO:
      CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME(cDBName)).
      RUN protools/_getidx.p (INPUT cDBType, INPUT cDBName, INPUT-OUTPUT TABLE IndexDetails, OUTPUT TABLE IndxFldDetails).
      DELETE ALIAS tinydict.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTableDetails C-Win 
PROCEDURE getTableDetails :
/*------------------------------------------------------------------------------
  Purpose: This procedure accepts a temp-table with a record for the
           currently selected table.  It calls _gettbl which poplulates
           the temp-table with the table details to display in the Table
           Detail window.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR TableDetails.

  cDBName = getdbName().
  cDBType = getdbType().
    
  IF db-list:SCREEN-VALUE IN FRAME {&FRAME-NAME} NE ? THEN 
  DO:
      CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME(cDBName)).
      RUN protools/_gettbl.p (INPUT cDBType, INPUT cDBName, INPUT-OUTPUT TABLE TableDetails).
      DELETE ALIAS tinydict.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialize-dblist C-Win 
PROCEDURE initialize-dblist :
/* -----------------------------------------------------------
  Purpose:     Create a list of Connected databases.  Assign
               the first one as the "current" selection and
               show the info about it.  
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VARIABLE x       AS INTEGER                NO-UNDO.
  DEFINE VARIABLE i       AS INTEGER                NO-UNDO.
  DEFINE VARIABLE lline   AS CHAR    FORMAT "X(40)" NO-UNDO.
  
  ASSIGN eInfo:HIDDEN IN FRAME {&FRAME-NAME}    = yes
         connrect:HIDDEN IN FRAME {&FRAME-NAME} = yes
         eLbl:HIDDEN  IN FRAME {&FRAME-NAME}    = yes
         &IF "{&WINDOW-SYSTEM}" EQ "OSF/Motif" &THEN
           b_DBDetails:LABEL = "DB Details >>".
         &ELSE
           b_DBDetails:LABEL = "&DB Details >>".
         &ENDIF  
  
  /* Calculate what the window and frame height needs to be changed to 
     when the window initially displays with the DB Connection Info hidden */
  ASSIGN iHeightChng = dbrect:ROW + dbrect:HEIGHT - 1.0 +
    FRAME {&FRAME-NAME}:BORDER-TOP + 
    FRAME {&FRAME-NAME}:BORDER-BOTTOM +
    0.4.

  ASSIGN FRAME {&FRAME-NAME}:HEIGHT = iHeightChng
         FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT = iHeightChng
         {&WINDOW-NAME}:HEIGHT = iHeightChng
         {&WINDOW-NAME}:VIRTUAL-HEIGHT = iHeightChng.  
         
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN db-list:SCREEN-VALUE = ""
           db-list:LIST-ITEMS   = "".
    DO i = 1 to NUM-DBS: /* loop through connected databases */
      IF DBTYPE(ldbname(i)) <> "PROGRESS" THEN next. /* skip non-progress databases */
      ASSIGN lline                = ldbname(i)
             substring(lline, 16, -1, "CHARACTER") = "[" + DBTYPE(ldbname(i)) + "]".
      IF db-list:ADD-LAST(lline) THEN.
      CREATE ALIAS tinydict FOR DATABASE VALUE(ldbname(i)).
      RUN protools/_db_gw.p (OUTPUT gwflag, OUTPUT db-name, OUTPUT db-type). /* Is schema-holder? If so, of what? */
      DELETE ALIAS tinydict.
      IF gwflag THEN DO x = 1 to NUM-ENTRIES(db-name): /* go after foreign databases */
          ASSIGN lline = "  " + entry(x,db-name).
                 SUBSTRING(lline, 16, -1, "CHARACTER") = "[" + entry(x,db-type) + "]".
          IF NOT CONNECTED(entry(x,db-name)) THEN
                 SUBSTRING(lline, 28, -1, "CHARACTER") = "(not connected)".
          IF db-list:ADD-LAST(lline) THEN.
      END.
    END.
    IF NUM-DBS > 0 THEN db-list:SCREEN-VALUE = db-list:ENTRY(1).
  END.
  IF eInfo:VISIBLE THEN RUN fill-editor.  
  IF db-list:SCREEN-VALUE = ? OR db-list:NUM-ITEMS = 0 THEN
      ASSIGN  b_DBDetails:SENSITIVE = no
              b_Schema:SENSITIVE  = no
              b_Disconnect:SENSITIVE = no.
  ELSE ASSIGN b_DBDetails:SENSITIVE = yes
              b_Schema:SENSITIVE  = yes
              b_Disconnect:SENSITIVE = yes.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Running_DBList C-Win 
PROCEDURE Running_DBList :
/* -----------------------------------------------------------
  Purpose:     Build used db list.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VARIABLE h       AS HANDLE.
  DEFINE VARIABLE i       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE dbentry AS CHARACTER NO-UNDO.

  /* Run through the list of procedures and build a list
   * of databases which they rely on
   */
  ASSIGN h = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(h):
    DO i = 1 TO NUM-ENTRIES(h:DB-REFERENCES):
      ASSIGN dbentry = ENTRY(i, h:DB-REFERENCES).
      IF LOOKUP(dbentry, run_dblist) = 0 THEN
        FIND run-list WHERE rdb-name = dbentry AND
                              prg-name = h:FILE-NAME NO-ERROR.
        IF NOT AVAILABLE run-list THEN DO:
          CREATE run-list.
          ASSIGN 
            run-list.rdb-name  = dbentry
            run-list.sh-name  = (IF SDBNAME(dbentry) NE dbentry THEN SDBNAME(dbentry) ELSE ?)
            run-list.prg-name = h:FILE-NAME.
        END.
    END.    
    h = h:NEXT-SIBLING.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION availFld C-Win 
FUNCTION availFld RETURNS LOGICAL
 ( INPUT pcTblName AS CHARACTER, INPUT pcFldName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: This function determines if a field still exists in the database, it
           may have been removed through the data dictionary  
    Notes:  
------------------------------------------------------------------------------*/
  cDBName = getdbName().
  cDBType = getdbType().
    
  IF db-list:SCREEN-VALUE IN FRAME {&FRAME-NAME} NE ? THEN 
  DO:
    CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME(cDBName)).
    RUN protools/_fldavbl.p (INPUT cDBType, INPUT cDBName, INPUT pcTblName, 
      INPUT pcFldName, OUTPUT lExists).
    DELETE ALIAS tinydict.
  END.  /* if dblist screen-value NE ? */
  RETURN lExists.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION availIdx C-Win 
FUNCTION availIdx RETURNS LOGICAL
 ( INPUT pcTblName AS CHARACTER, INPUT pcIdxName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: This function determines if an Index still exists in the database, it
           may have been removed through the data dictionary  
    Notes:  
------------------------------------------------------------------------------*/
  cDBName = getdbName().
  cDBType = getdbType().
    
  IF db-list:SCREEN-VALUE IN FRAME {&FRAME-NAME} NE ? THEN 
  DO:
    CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME(cDBName)).
    RUN protools/_idxavbl.p (INPUT cDBType, INPUT cDBName, INPUT pcTblName, 
      INPUT pcIdxName, OUTPUT lExists).
    DELETE ALIAS tinydict.
  END.  /* if dblist screen-value NE ? */
  RETURN lExists.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION availTbl C-Win 
FUNCTION availTbl RETURNS LOGICAL
  ( INPUT pcTblName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: This function determines if a Table still exists in the database, it 
           may have been removed through the data dictionary
    Notes:  
------------------------------------------------------------------------------*/
  cDBName = getdbName().
  cDBType = getdbType().
    
  IF db-list:SCREEN-VALUE IN FRAME {&FRAME-NAME} NE ? THEN 
  DO:
    CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME(cDBName)).
    RUN protools/_tblavbl.p (INPUT cDBType, INPUT cDBName, INPUT pcTblName, OUTPUT lExists).
    DELETE ALIAS tinydict.
  END.  /* if dblist screen-value NE ? */
  RETURN lExists.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dbconn C-Win 
FUNCTION dbconn RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: This function determines whether the selected database is still
           still connected.  It may have been disconnected by the user (though
           the dictionary, for example).  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN db-list
      cSelcDB = trim(substring(db-list,1,15,"CHARACTER":U)).
  END.  /* do with frame */
  IF NOT CONNECTED(cSelcDB) THEN RETURN FALSE.
  ELSE RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getdbName C-Win 
FUNCTION getdbName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns name of currently selected database 
    Notes:  
------------------------------------------------------------------------------*/

  RETURN TRIM(substring(db-list:SCREEN-VALUE IN FRAME {&FRAME-NAME},1,15,"CHARACTER")). /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getdbType C-Win 
FUNCTION getdbType RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the type for the currently selected database 
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cType AS CHARACTER NO-UNDO.
  
  cType = TRIM(substring(db-list:SCREEN-VALUE IN FRAME {&FRAME-NAME},17,11,"CHARACTER")).
  cType = substring(cType,1,length(cType,"CHARACTER") - 1,"CHARACTER").

  RETURN cType.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFld C-Win 
FUNCTION getFld RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: This function is called from the Schema window with a table name, it 
           creates an alias for the currently selected database and runs a procedure 
           to get a comma separated list of field names.  It passes the list of
           field names back to the Schema window.   
    Notes:  
------------------------------------------------------------------------------*/
  cDBName = getdbName().
  cDBType = getdbType().
    
  IF db-list:SCREEN-VALUE IN FRAME {&FRAME-NAME} NE ? THEN 
  DO:
      CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME(cDBName)).
      RUN protools/_fldlist.p (INPUT cDBType, INPUT cDBName, INPUT pcTable, OUTPUT cTableList).
      DELETE ALIAS tinydict.
  END.  /* if db-list screen-value ne ? */
  RETURN cTableList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getIndx C-Win 
FUNCTION getIndx RETURNS CHARACTER
  ( INPUT cTable AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: This function is called from the Schema window with a table name, it 
           creates an alias for the currently selected database and runs a procedure 
           to get a comma separated list of index names.  It passes the list of
           index names back to the Schema window. 
    Notes:  
------------------------------------------------------------------------------*/
  cDBName = getdbName().
  cDBType = getdbType().
    
  IF db-list:SCREEN-VALUE IN FRAME {&FRAME-NAME} NE ? THEN 
  DO:
      CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME(cDBName)).
      RUN protools/_idxlist.p (INPUT cDBType, INPUT cDBName, INPUT cTable, OUTPUT cTableList).
      DELETE ALIAS tinydict.
  END.  /* if db-list screen-value ne ? */
  RETURN cTableList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTbl C-Win 
FUNCTION getTbl RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: This function creates an alias for the currently selected database and 
           runs a procedure to get a comma separated list of table names.
    Notes:  
------------------------------------------------------------------------------*/
  cDBName = getdbName().
  cDBType = getdbType().
    
  IF db-list:SCREEN-VALUE IN FRAME {&FRAME-NAME} NE ? THEN 
  DO:
    CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME(cDBName)).
    RUN protools/_tbllist.p (INPUT cDBType, INPUT cDBName, OUTPUT cTableList).
    DELETE ALIAS tinydict.
  END.  /* if dblist screen-value NE ? */
  RETURN cTableList.   /* Function return value. */
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

