&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*************************************************************/  
/* Copyright (c) 1984-2007 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------

  File:        _auditmainw.w

  Description: from cntnrwin.w - ADM SmartWindow Template
               Main window of the APMT utility. Enables auditing administrators to
               maintain auditing policies in their databases.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       audpolicyw.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* This holds the partition name that should be defined for this tool to work
   through an AppServer.
*/
&SCOPED-DEFINE APMT_PARTITION_NAME "APMT"

/* these are some tags we use to display with the database name in the working
   database combo-box.
*/
&SCOPED-DEFINE APPSRV-TAG       "AppSrv":U
&SCOPED-DEFINE READONLY-TAG  "Read-Only":U
&SCOPED-DEFINE NO-DB                 "<None>":U

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* holds the index of the working database  (from the combo-box) */
DEFINE VARIABLE iCurrentdatabase    AS INTEGER NO-UNDO.

DEFINE VARIABLE hdl                 AS HANDLE    NO-UNDO.
DEFINE VARIABLE hdlWin              AS HANDLE    NO-UNDO.

/* keeps track of when there are changes that were not saved in the working database */
DEFINE VARIABLE changesPending      AS LOGICAL   NO-UNDO.

/* set to true while we are in initializeObject() */
DEFINE VARIABLE initializing              AS LOGICAL  NO-UNDO INIT NO.

DEFINE VARIABLE forceDbComboChg AS LOGICAL  NO-UNDO INIT NO.

/* used in doUndoChanges */
DEFINE VARIABLE supress_confirmation AS LOGICAL  NO-UNDO INIT NO.

/* temp-table used to hold the db information */
DEFINE TEMP-TABLE workDb
    FIELD id               AS INTEGER
    FIELD dbInfo           AS CHARACTER
    FIELD display-value    AS CHARACTER
    FIELD dbGuid           AS CHARACTER
    INDEX id id.

/* If this is WebSpeed, exit */
IF SESSION:CLIENT-TYPE = "WEBSPEED" THEN RETURN ERROR.

{src/adm2/widgetprto.i}

/* initiates the audit cache procedure */
{auditing/include/_aud-cache.i}

/* includes some standard definitions */
{auditing/include/_aud-std.i}

/* for conflict and effective settings reports */
{auditing/include/aud-report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coDatabase 
&Scoped-Define DISPLAYED-OBJECTS coDatabase fill-warning 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAppService wWin 
FUNCTION getAppService RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDBGuid wWin 
FUNCTION getDBGuid RETURNS CHARACTER
  ( pcldbname AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasMultipleSelected wWin 
FUNCTION hasMultipleSelected RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isCurrentDbReadOnly wWin 
FUNCTION isCurrentDbReadOnly RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isReadOnlyDb wWin 
FUNCTION isReadOnlyDb RETURNS LOGICAL
  ( pId AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_audevpolicybrowb AS HANDLE NO-UNDO.
DEFINE VARIABLE h_audevpolicysdo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_audevpolicyviewv AS HANDLE NO-UNDO.
DEFINE VARIABLE h_audfieldpolicybrowb AS HANDLE NO-UNDO.
DEFINE VARIABLE h_audfieldpolicysdo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_audfieldpolicyviewv AS HANDLE NO-UNDO.
DEFINE VARIABLE h_audfilepolicybrowb AS HANDLE NO-UNDO.
DEFINE VARIABLE h_audfilepolicysdo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_audfilepolicyviewv AS HANDLE NO-UNDO.
DEFINE VARIABLE h_audpolicybrowb AS HANDLE NO-UNDO.
DEFINE VARIABLE h_audpolicysdo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_audpolicyviewv AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dyntoolbar AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE coDatabase AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Working database" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "<None>",0
     DROP-DOWN-LIST
     SIZE 50 BY 1 TOOLTIP "Select the database to configure the audit policy for" NO-UNDO.

DEFINE VARIABLE fill-warning AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 145 BY 1
     BGCOLOR 7 FGCOLOR 15  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     coDatabase AT ROW 1 COL 21 COLON-ALIGNED WIDGET-ID 2
     fill-warning AT ROW 17.62 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 4 NO-TAB-STOP 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 154.4 BY 24.95.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Design Page: 4
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Audit Policy Maintenance"
         HEIGHT             = 25.24
         WIDTH              = 154.4
         MAX-HEIGHT         = 33.33
         MAX-WIDTH          = 204.8
         VIRTUAL-HEIGHT     = 33.33
         VIRTUAL-WIDTH      = 204.8
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT wWin:LOAD-ICON("adeicon/progress.ico":U) THEN
    MESSAGE "Unable to load icon: adeicon/progress.ico"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fill-warning IN FRAME fMain
   NO-ENABLE                                                            */
ASSIGN 
       fill-warning:HIDDEN IN FRAME fMain           = TRUE
       fill-warning:READ-ONLY IN FRAME fMain        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Audit Policy Maintenance */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.

  /* if there are changes that were not saved, ask the user what he wants to do*/
  RUN checkPendingChanges("exit":U).

  /*  checkPendingChanges check if there are changes pending, and asks if the user
      wants to undo or commit the changes. If the user canceled, then RETURN-VALUE will
      be set to "NO-APPLY", in which case we don't do anything either
  */
  IF RETURN-VALUE = "NO-APPLY":U THEN
      RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON ENTRY OF wWin /* Audit Policy Maintenance */
DO:
  DEFINE VARIABLE cList    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDbInfo  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDbStr   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iLoop    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE jLoop    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE changeDB AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE newId    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cTemp    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE work_dis AS LOGICAL   NO-UNDO INITIAL NO.

  /* We are overriding the ENTRY trigger which is normally defined in the
     ADM2 code (see OldCurrentWindowFocus on the main block of this program).
     The following statement is defined in the ADM2 code, so let's leave it 
     so we keep the same behavior as ADM2
  */
  ASSIGN CURRENT-WINDOW = SELF NO-ERROR.
  
  /* let's check if a database was disconnected in the meantime, but only
     for non-WebClients, since WebClient can't connect to a db. Also, check if
     any connected database is not on the list and add it
  */
  /* also, don't check this if we are initializing the procedure, since we are going to populate the
     database combo-box
  */
  IF {&NOT-WEBCLIENT} AND NOT initializing THEN DO:

    /* if there is nothing on the list, return */
    IF coDatabase:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = "":U OR 
       coDatabase:LIST-ITEM-PAIRS = ? THEN
       RETURN.

    /* first get db's connected on this session */
    RUN auditing/_get-db-list.p (NO /* not complete list */, 
                                 OUTPUT cList).

    /* if there were no db's on the list, don't have to check for disconnected 
      db's 
    */
    IF LOOKUP({&NO-DB},coDatabase:LIST-ITEM-PAIRS) = 0 THEN DO:
        /* now let's scan the temp-table and check if any db is not
           connected anymore
        */

        FOR EACH workDb:
        
            IF {&NOT-WEBCLIENT} THEN DO:
              IF DYNAMIC-FUNCTION('has-DB-option' IN  hAuditCacheMgr,  workDb.dbInfo, {&DB-APPSERVER})  THEN
                 NEXT.
            END.

            ASSIGN cdbInfo = ?
                   cTemp = DYNAMIC-FUNCTION('get-DB-Name' IN  hAuditCacheMgr, workDb.dbInfo). 

            /* now check if we find the db in the list we got from _get-db-list.p.
               If not, it must be that the db is not the same, (if user disconnected the db
               and connected to a different db with the same name), so we have to remove 
               it from the list. If the db guid is not the same, this is indeed not the same db
            */
            DO iLoop = 1 TO NUM-ENTRIES(cList, CHR(1)):
                 /* this is the info for this db entry*/
                 ASSIGN cdbInfo = ENTRY(iLoop, cList, CHR(1)).

                 /* check if we find a match for the info we have in the current workDb record,
                    and if the db guid matches also */
                 IF workDb.dbInfo = cdbInfo AND 
                    workDb.dbGuid = getDBGuid(cTemp) THEN
                     LEAVE.
                 ELSE
                     cdbInfo = ?.
            END.

            IF NOT CONNECTED(cTemp) OR cdbInfo = ? THEN DO:
                /* remove it from the list. If the current db, display an error
                   message
                */
                IF coDatabase:INPUT-VALUE = workDb.Id THEN DO:
                    /* remember we need to change the working db */
                    ASSIGN changeDB = YES
                           work_dis = YES.
    
                    MESSAGE "Working database was disconnected. Removing it from the combo-box."
                        (IF changesPending THEN "~nDiscarding changes that were not saved." ELSE "")
                        VIEW-AS ALERT-BOX INFO.
                END.
                
                /* first need to get rid of any updates in progress */
                RUN check-update-in-progress.

                IF RETURN-VALUE = "NO-APPLY":U THEN DO:
                    /* if there is a current update, cancel it */
                    PUBLISH "cancelRecord" FROM h_dyntoolbar.
                    PUBLISH "resetRecord" FROM h_dyntoolbar.
                END.

                IF work_dis THEN DO:
                    /* if the working db was disconnected, we have to undo any changes now so
                       we don't display the confirmation message when running the value-changed
                       trigger of the database combo-box.
                   */
                   IF changesPending THEN DO:
                      ASSIGN supress_confirmation = YES.
                      RUN doUndoChanges.
                   END.
                END.

                coDatabase:DELETE(STRING(workDb.Id)) NO-ERROR.

                /* remove the table list for this database from the cache */
                RUN remove-table-list-cache IN hAuditCacheMgr (INPUT cTemp).

                /* delete the record from the temp-table */
                DELETE workDb.

            END. /* IF NOT CONNECTED */
        END. /* FOR EACH */
    
    END. /* IF LOOKUP */
    
    /* let's process the list and see if every db in the combo-box is in the list */
    /* entries are separated by chr(1) */
    DO iLoop = 1 TO NUM-ENTRIES(cList, CHR(1)):
        ASSIGN cdbInfo = ENTRY(iLoop, cList, CHR(1)) .

        /* if db was connected and it is not in our list, let's add entry to 
           the combo-box 
        */
        
        FIND FIRST workDb WHERE workDb.dbInfo = cDbInfo NO-ERROR.
        IF NOT AVAILABLE workDb THEN DO:
        
           /* make sure we remove the "<None>" entry if databases were added 
              to the list, if one exists.
           */
           coDatabase:DELETE("0" /* <None> */) NO-ERROR.

           /* if nothing was left on the list, remember we have to change
              the current working db
           */
           IF NOT changeDB AND (coDatabase:LIST-ITEM-PAIRS = "":U OR coDatabase:LIST-ITEM-PAIRS = ?) THEN
              ASSIGN changeDB = TRUE.

           RUN addDbToCombo(cDbInfo).
        END.
    END.

    /* if no db on the list, add "<None>" */
    IF coDatabase:LIST-ITEM-PAIRS = "":U OR coDatabase:LIST-ITEM-PAIRS = ? THEN
       coDatabase:ADD-LAST({&NO-DB},0).

    /* if we removed the working db from the list, or we added a db to the list
       and the list was empty before, assign the first one on the list as the 
       current one
    */
    IF changeDB THEN DO:

       ASSIGN coDatabase:SCREEN-VALUE = ENTRY(2,coDatabase:LIST-ITEM-PAIRS) NO-ERROR.

       ASSIGN forceDbComboChg = YES.
    END.

    APPLY "VALUE-CHANGED":U TO coDatabase. /* force refresh of database list */

  END. /* end of outermost IF statement */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON HELP OF wWin /* Audit Policy Maintenance */
DO:
  RUN doAPMTHelp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Audit Policy Maintenance */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  
    /* if there are changes that were not saved, ask the user what he wants to do*/
    RUN checkPendingChanges("exit":U).
    
    /*  checkPendingChanges check if there are changes pending, and asks if the user
        wants to undo or commit the changes. If the user canceled, then RETURN-VALUE will
        be set to "NO-APPLY", in which case we don't do anything either
    */
    IF RETURN-VALUE = "NO-APPLY":U THEN
        RETURN NO-APPLY.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coDatabase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coDatabase wWin
ON VALUE-CHANGED OF coDatabase IN FRAME fMain /* Working database */
DO:
DEFINE VARIABLE c AS CHARACTER NO-UNDO.

  /* user changed the current working database, so we need to retrieve the
     policies stored in the newly selected database.
  */
  IF SELF:INPUT-VALUE <> 0 THEN
  DO:
    /* check if user really changed the database name selected, or if we have to force it to go through
       even if the id is the same - which can happen if the db got disconnected and connected again.
    */
    IF SELF:INPUT-VALUE <> iCurrentdatabase OR  forceDbComboChg THEN DO:

        /* if there are changes that were not saved, ask the user what he wants to do*/
        RUN checkPendingChanges("changedb":U).

        /*  checkPendingChanges check if there are changes pending, and asks if the user
            wants to undo or commit the changes. If the user canceled, then RETURN-VALUE will
            be set to "NO-APPLY", in which case we don't do anything either
        */
        IF RETURN-VALUE = "NO-APPLY":U THEN DO:
            /* return the database name back to what it was */
            SELF:SCREEN-VALUE = STRING(iCurrentdatabase).
            RETURN NO-APPLY.
        END.

        /* go back to page 1 */
        RUN selectPage (INPUT 1).   

        /* remember which one is selected now */
        iCurrentdatabase = SELF:INPUT-VALUE.
  
        /* if database is read-only, don't let them update anything */
        IF isCurrentDbReadOnly() THEN DO:
            /* disable the import option */
            DYNAMIC-FUNCTION( 'disableActions':U IN h_dyntoolbar, "AuditImportPolicy":U).

            /* disable all the links so user can't update anything */
            RUN update-disable.
        END.
        ELSE DO:
            /* enable the import option */
            DYNAMIC-FUNCTION( 'enableActions':U IN h_dyntoolbar, "AuditImportPolicy":U).

            /* enable the links so user can update data */
            RUN update-enable.
        END.

        /*  enable the event maintenance option */
        DYNAMIC-FUNCTION( 'enableActions':U IN h_dyntoolbar, "AuditEventMaint":U).
        
        /* get the string with the database info. It builds it out of the screen-value 
           of this combo-box
        */
        RUN getWorkingAuditDbInfo(OUTPUT c).
 
        /* publish the the new database so we get the policies for the given db */
        PUBLISH "changeAuditDatabase":U (INPUT c).

        /* report any errors */
        IF RETURN-VALUE <> "":U THEN DO:
            MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX ERROR.
        END.

        /* let's reopen the policy sdo query so we show the correct records */
        RUN reopen-queries.

        /* enable/disable options in the Policy menu accordingly */
        RUN refresh-policy-menu.
    END.
  END.
  ELSE DO:
      /* reset currentdatabase */
      ASSIGN iCurrentdatabase = 0.

      /* go back to page 1 */
      RUN selectPage (INPUT 1).   
      
      /* if no database is available, can't do anything. Make sure the
         import option is disabled also.
       */
      DYNAMIC-FUNCTION( 'disableActions':U IN h_dyntoolbar, "AuditImportPolicy,AuditEventMaint":U).

      /* disable all the links so toolbar is disabled */
      RUN update-disable.

      /* disable all options in the Policy menu */
      RUN refresh-policy-menu.

      /* publish an empty string so SDO's reopen their query   */
      PUBLISH "changeAuditDatabase":U (INPUT "" /* no db */).

      /* let's reopen the policy sdo query so we show the correct records */
      DYNAMIC-FUNCTION('openQuery':U IN h_audpolicysdo) NO-ERROR.

  END.

  /* reset this */
  ASSIGN forceDbComboChg = NO.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* make sure only of instance of this procedure is executing, if in persistent mode */
IF THIS-PROCEDURE:PERSISTENT THEN DO:
  /* See if a copy already exists. */
  hdl = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(hdl): 
    IF hdl <> THIS-PROCEDURE AND hdl:FILE-NAME eq "auditing/_auditmainw.w"
    THEN DO:
      hdlWin = hdl:CURRENT-WINDOW.
      IF hdlWin:WINDOW-STATE = 2 THEN hdlWin:WINDOW-STATE = 3.
      IF hdlWin:MOVE-TO-TOP() THEN.
      DELETE PROCEDURE THIS-PROCEDURE.
      RETURN.
    END.
    hdl = hdl:NEXT-SIBLING.
  END.
END. 

/* if started from the operating system, prompt for login ids */
IF PROGRAM-NAME(2) = ? THEN
  RUN _prostar.p.

/* define OldCurrentWindowFocus so we can override the ENTRY trigger 
   of the window
*/
&SCOPED-DEFINE OldCurrentWindowFocus

/* set the warning text used for the Audit Field tab */
ASSIGN fill-warning = "NOTE: Any fields not shown in the browse will" +
       " inherit the auditing settings of the table!".


/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* We are exiting. If started from the operating system, quit */
IF NOT THIS-PROCEDURE:PERSISTENT AND PROGRAM-NAME(2) = ? THEN
   QUIT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addDbToCombo wWin 
PROCEDURE addDbToCombo :
/*------------------------------------------------------------------------------
  Purpose:     Adds an entry to the database combo-box. 
  Parameters:  INPUT pcDbInfo - contains the db information we use to add the
                                entry to the combo-box
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcDbInfo AS CHARACTER NO-UNDO.

DEFINE VARIABLE cDbStr  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDbName AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTemp   AS CHARACTER NO-UNDO INIT ?.
DEFINE VARIABLE newId   AS INTEGER   NO-UNDO.

        ASSIGN cDbName = DYNAMIC-FUNCTION('get-DB-Name' IN  hAuditCacheMgr, pcDbInfo).

        /* now check if there is any additional information about this db */

        IF {&NOT-WEBCLIENT} THEN DO:
       
          IF DYNAMIC-FUNCTION('has-DB-option' IN  hAuditCacheMgr, pcDbInfo, {&DB-APPSERVER})  THEN
          DO:
              IF cDbStr = "" THEN 
                 cDbStr = {&APPSRV-TAG}.
              ELSE
                 cDbStr = cDbStr + " " + {&APPSRV-TAG}.    
          END.
          ELSE /* if not on the appserver, store the db guid for this db */
             ASSIGN cTemp = getDBGuid(cDbName).
        END.

        /* check if it's read-only*/
        IF DYNAMIC-FUNCTION('has-DB-option' IN  hAuditCacheMgr, pcDbInfo, {&DB-READ-ONLY}) THEN
           IF cDbStr = "" THEN
              cDbStr = {&READONLY-TAG}.
           ELSE
              cDbStr = cDbStr + " ":U + {&READONLY-TAG}.

        IF cDbStr = "" THEN DO:

           /* the only thing we have is the db name */
           ASSIGN cDbStr = cDbName.

           IF {&NOT-WEBCLIENT} THEN DO:
               /* if dbinfo only had the db name, get the db guid  (only if not running
                  webclient, since in that case we don't have local db's connected
               */
               ASSIGN cTemp = getDBGuid(cDbName).
           END.
        END.
        ELSE
            cDbStr = "(" + cDbStr + ") " + cDbName.


        /* try to find what should be the next id value */
        FIND LAST workDb USE-INDEX id NO-ERROR.
        IF NOT AVAILABLE workdb THEN
            ASSIGN newId = 1.
        ELSE
            ASSIGN newid = workDb.Id + 1.

        /* create a new entry in the temp-table */
        CREATE workDb.

        ASSIGN workDb.Id = newId
               workDb.dbInfo = pcDbInfo
               workDb.display-value = cDbStr
               workDb.dbGuid = cTemp.

       coDataBase:ADD-LAST(cDbStr, newId) IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addLink wWin 
PROCEDURE addLink :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       Handle read-only database cases
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER phSource AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER pcLink   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER phTarget AS HANDLE NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* if database is read-only when the user switches pages for the first time,
     don't add the links so the user can't update anything.
  */
  IF pcLink = "Update":U OR pcLink = "TableIO":U THEN DO:
      /* if read-only db, or no-db available, just return */
      IF isCurrentDbReadOnly() THEN
          RETURN.
  END.

  RUN SUPER( INPUT phSource, INPUT pcLink, INPUT phTarget).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'auditing/sdo/_audpolicysdo.wDB-AWARE':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'AppServiceASUsePromptASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessyesDisconnectAppServernoObjectName_audpolicysdoUpdateFromSourcenoToggleDataTargetsyesOpenOnInityesPromptOnDeleteyesPromptColumns(NONE)':U ,
             OUTPUT h_audpolicysdo ).
       RUN repositionObject IN h_audpolicysdo ( 11.24 , 100.00 ) NO-ERROR.
       /* Size in AB:  ( 2.38 , 20.00 ) */

       RUN constructObject (
             INPUT  'auditing/ui/_audpolicybrowb.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'ScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesDataSourceNamesUpdateTargetNamesLogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_audpolicybrowb ).
       RUN repositionObject IN h_audpolicybrowb ( 2.19 , 3.00 ) NO-ERROR.
       RUN resizeObject IN h_audpolicybrowb ( 5.86 , 150.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'auditing/sdo/_audfilepolicysdo.wDB-AWARE':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'AppServiceASUsePromptASInfoForeignFieldsttAuditFilePolicy._Audit-policy-guid,_Audit-policy-guidRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessyesDisconnectAppServernoObjectName_audfilepolicysdoUpdateFromSourcenoToggleDataTargetsyesOpenOnInityesPromptOnDeleteyesPromptColumns(NONE)':U ,
             OUTPUT h_audfilepolicysdo ).
       RUN repositionObject IN h_audfilepolicysdo ( 11.24 , 126.00 ) NO-ERROR.
       /* Size in AB:  ( 3.57 , 20.00 ) */

       RUN constructObject (
             INPUT  'auditing/sdo/_audfieldpolicysdo.wDB-AWARE':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'AppServiceASUsePromptASInfoForeignFieldsttAuditFieldPolicy._Audit-policy-guid,_Audit-policy-guid,ttAuditFieldPolicy._File-name,_File-name,ttAuditFieldPolicy._Owner,_OwnerRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessyesDisconnectAppServernoObjectName_audfieldpolicysdoUpdateFromSourcenoToggleDataTargetsyesOpenOnInityesPromptOnDeleteyesPromptColumns(NONE)':U ,
             OUTPUT h_audfieldpolicysdo ).
       RUN repositionObject IN h_audfieldpolicysdo ( 14.33 , 102.00 ) NO-ERROR.
       /* Size in AB:  ( 2.62 , 19.80 ) */

       RUN constructObject (
             INPUT  'auditing/sdo/_audevpolicysdo.wDB-AWARE':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'AppServiceASUsePromptASInfoForeignFieldsttAuditEventPolicy._Audit-policy-guid,_Audit-policy-guidRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessyesDisconnectAppServernoObjectName_audevpolicysdoUpdateFromSourcenoToggleDataTargetsyesOpenOnInityesPromptOnDeleteyesPromptColumns(NONE)':U ,
             OUTPUT h_audevpolicysdo ).
       RUN repositionObject IN h_audevpolicysdo ( 15.29 , 122.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 19.80 ) */

       RUN constructObject (
             INPUT  'auditing/ui/_dyntoolbarmain.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'EdgePixels2DeactivateTargetOnHidenoDisabledActionsFlatButtonsyesMenuyesShowBorderyesToolbaryesActionGroupsTableioTableIOTypeSaveSupportedLinksTableio-sourceToolbarBandsToolbarAutoSizenoToolbarDrawDirectionHorizontalLogicalObjectName_dyntoolbarmainAutoResizeDisabledActionsHiddenActionsUpdateHiddenToolbarBandsHiddenMenuBandsMenuMergeOrder0RemoveMenuOnHidenoCreateSubMenuOnConflictyesNavigationTargetNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyntoolbar ).
       RUN repositionObject IN h_dyntoolbar ( 8.38 , 3.00 ) NO-ERROR.
       RUN resizeObject IN h_dyntoolbar ( 1.24 , 30.80 ) NO-ERROR.

       RUN constructObject (
             INPUT  'auditing/adm2/aud_folder.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'FolderLabels':U + 'Policy|Audit Tables|Audit Fields|Audit Events' + 'FolderTabWidth0FolderFont-1HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_folder ).
       RUN repositionObject IN h_folder ( 9.57 , 3.00 ) NO-ERROR.
       RUN resizeObject IN h_folder ( 16.19 , 150.00 ) NO-ERROR.

       /* Links to SmartDataBrowser h_audpolicybrowb. */
       RUN addLink ( h_audpolicysdo , 'Data':U , h_audpolicybrowb ).

       /* Links to SmartDataObject h_audfilepolicysdo. */
       RUN addLink ( h_audpolicysdo , 'Data':U , h_audfilepolicysdo ).

       /* Links to SmartDataObject h_audfieldpolicysdo. */
       RUN addLink ( h_audfilepolicysdo , 'Data':U , h_audfieldpolicysdo ).

       /* Links to SmartDataObject h_audevpolicysdo. */
       RUN addLink ( h_audpolicysdo , 'Data':U , h_audevpolicysdo ).

       /* Links to SmartFolder h_folder. */
       RUN addLink ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_audpolicybrowb ,
             coDatabase:HANDLE IN FRAME fMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_dyntoolbar ,
             h_audpolicybrowb , 'AFTER':U ).
       RUN adjustTabOrder ( h_folder ,
             h_dyntoolbar , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN constructObject (
             INPUT  'auditing/ui/_audpolicyviewv.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'EnabledObjFldsToDisableModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectNameDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_audpolicyviewv ).
       RUN repositionObject IN h_audpolicyviewv ( 12.91 , 8.00 ) NO-ERROR.
       /* Size in AB:  ( 7.24 , 97.00 ) */

       /* Links to SmartDataViewer h_audpolicyviewv. */
       RUN addLink ( h_audpolicysdo , 'Data':U , h_audpolicyviewv ).
       RUN addLink ( h_audpolicyviewv , 'Update':U , h_audpolicysdo ).
       RUN addLink ( h_dyntoolbar , 'Tableio':U , h_audpolicyviewv ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_audpolicybrowb ,
             coDatabase:HANDLE IN FRAME fMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_dyntoolbar ,
             h_audpolicybrowb , 'AFTER':U ).
       RUN adjustTabOrder ( h_folder ,
             h_dyntoolbar , 'AFTER':U ).
       RUN adjustTabOrder ( h_audpolicyviewv ,
             h_folder , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN constructObject (
             INPUT  'auditing/ui/_audfilepolicybrowb.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'ScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesDataSourceNamesUpdateTargetNamesLogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_audfilepolicybrowb ).
       RUN repositionObject IN h_audfilepolicybrowb ( 10.76 , 6.00 ) NO-ERROR.
       RUN resizeObject IN h_audfilepolicybrowb ( 8.35 , 144.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'auditing/ui/_audfilepolicyviewv.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'EnabledObjFldsToDisableModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectNameDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_audfilepolicyviewv ).
       RUN repositionObject IN h_audfilepolicyviewv ( 19.33 , 5.00 ) NO-ERROR.
       /* Size in AB:  ( 5.71 , 145.00 ) */

       /* Links to SmartDataBrowser h_audfilepolicybrowb. */
       RUN addLink ( h_audfilepolicysdo , 'Data':U , h_audfilepolicybrowb ).

       /* Links to SmartDataViewer h_audfilepolicyviewv. */
       RUN addLink ( h_audfilepolicysdo , 'Data':U , h_audfilepolicyviewv ).
       RUN addLink ( h_audfilepolicyviewv , 'Update':U , h_audfilepolicysdo ).
       RUN addLink ( h_dyntoolbar , 'Tableio':U , h_audfilepolicyviewv ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_audpolicybrowb ,
             coDatabase:HANDLE IN FRAME fMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_dyntoolbar ,
             h_audpolicybrowb , 'AFTER':U ).
       RUN adjustTabOrder ( h_folder ,
             h_dyntoolbar , 'AFTER':U ).
       RUN adjustTabOrder ( h_audfilepolicybrowb ,
             h_folder , 'AFTER':U ).
       RUN adjustTabOrder ( h_audfilepolicyviewv ,
             h_audfilepolicybrowb , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN constructObject (
             INPUT  'auditing/ui/_audfieldpolicybrowb.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'ScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesDataSourceNamesUpdateTargetNamesLogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_audfieldpolicybrowb ).
       RUN repositionObject IN h_audfieldpolicybrowb ( 10.76 , 5.00 ) NO-ERROR.
       RUN resizeObject IN h_audfieldpolicybrowb ( 6.57 , 145.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'auditing/ui/_audfieldpolicyviewv.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'EnabledObjFldsToDisableModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectNameDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_audfieldpolicyviewv ).
       RUN repositionObject IN h_audfieldpolicyviewv ( 18.57 , 5.00 ) NO-ERROR.
       /* Size in AB:  ( 6.67 , 146.00 ) */

       /* Links to SmartDataBrowser h_audfieldpolicybrowb. */
       RUN addLink ( h_audfieldpolicysdo , 'Data':U , h_audfieldpolicybrowb ).

       /* Links to SmartDataViewer h_audfieldpolicyviewv. */
       RUN addLink ( h_audfieldpolicysdo , 'Data':U , h_audfieldpolicyviewv ).
       RUN addLink ( h_audfieldpolicyviewv , 'Update':U , h_audfieldpolicysdo ).
       RUN addLink ( h_dyntoolbar , 'Tableio':U , h_audfieldpolicyviewv ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_audpolicybrowb ,
             coDatabase:HANDLE IN FRAME fMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_dyntoolbar ,
             h_audpolicybrowb , 'AFTER':U ).
       RUN adjustTabOrder ( h_folder ,
             h_dyntoolbar , 'AFTER':U ).
       RUN adjustTabOrder ( h_audfieldpolicybrowb ,
             h_folder , 'AFTER':U ).
       RUN adjustTabOrder ( h_audfieldpolicyviewv ,
             h_audfieldpolicybrowb , 'AFTER':U ).
    END. /* Page 3 */
    WHEN 4 THEN DO:
       RUN constructObject (
             INPUT  'auditing/ui/_audevpolicybrowb.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'ScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesDataSourceNamesUpdateTargetNamesLogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_audevpolicybrowb ).
       RUN repositionObject IN h_audevpolicybrowb ( 10.76 , 5.00 ) NO-ERROR.
       RUN resizeObject IN h_audevpolicybrowb ( 7.86 , 146.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'auditing/ui/_audevpolicyviewv.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'EnabledObjFldsToDisableModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectNameDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_audevpolicyviewv ).
       RUN repositionObject IN h_audevpolicyviewv ( 18.86 , 5.00 ) NO-ERROR.
       /* Size in AB:  ( 6.29 , 146.00 ) */

       /* Links to SmartDataBrowser h_audevpolicybrowb. */
       RUN addLink ( h_audevpolicysdo , 'Data':U , h_audevpolicybrowb ).

       /* Links to SmartDataViewer h_audevpolicyviewv. */
       RUN addLink ( h_audevpolicysdo , 'Data':U , h_audevpolicyviewv ).
       RUN addLink ( h_audevpolicyviewv , 'Update':U , h_audevpolicysdo ).
       RUN addLink ( h_dyntoolbar , 'Tableio':U , h_audevpolicyviewv ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_audpolicybrowb ,
             coDatabase:HANDLE IN FRAME fMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_dyntoolbar ,
             h_audpolicybrowb , 'AFTER':U ).
       RUN adjustTabOrder ( h_folder ,
             h_dyntoolbar , 'AFTER':U ).
       RUN adjustTabOrder ( h_audevpolicybrowb ,
             h_folder , 'AFTER':U ).
       RUN adjustTabOrder ( h_audevpolicyviewv ,
             h_audevpolicybrowb , 'AFTER':U ).
    END. /* Page 4 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildDatabaseCombo wWin 
PROCEDURE buildDatabaseCombo :
/*------------------------------------------------------------------------------
  Purpose:     Build list of databases that contain the audit schema
  Parameters:  <none>
  Notes:       It calls get-dbname-list in the auditUtils procedure, which
               handles local and AppServer cases. It returns a list of databases
               and some info about the db so we know when a given db is read-only,
               or it is connected in the AppServer side.
------------------------------------------------------------------------------*/
DEFINE VARIABLE iLoop      AS INTEGER   NO-UNDO.

DEFINE VARIABLE cList      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cdbInfo    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cWorking   AS CHARACTER NO-UNDO.
DEFINE VARIABLE supp_warn  AS LOGICAL   NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN 
            coDatabase:LIST-ITEM-PAIRS = ?.
    
        /* get list of database connected on this session or AppServer */
        /* the info for each db on the list is separated by chr(1). For each db,
           the format of the entry is:
           db-name[[,READ-ONLY][,APPSERVER]]
        */
        RUN get-dbname-list IN hAuditCacheMgr (OUTPUT cList).

        /* process the list and add the entries to the combo-box. We will add tags
           to the string in the combo so user knows a db is read-only, or it is
           not local (Appserver case)
        */
    
       /* entries are separated by chr(1) */
       DO iLoop = 1 TO NUM-ENTRIES(cList, CHR(1)):

           ASSIGN cdbInfo = ENTRY(iLoop, cList, CHR(1)).

           RUN addDbToCombo (INPUT cdbInfo).

            /* check if this is the working database in the Progress session,
               so we default to it. Only for non-WebClient case
            */
            IF {&NOT-WEBCLIENT} AND cWorking = "":U THEN DO:
                /* if dictdb exists, check if matches this database */
                IF LDBNAME("DICTDB":U) <> ? AND 
                   LOOKUP (LDBNAME("DICTDB":U), cDbInfo) <> 0 THEN
                    ASSIGN cWorking = STRING(iLoop).
            END.
    
        END.

        /* if no db was added to the list, add <None> as the only option */
        IF coDatabase:LIST-ITEM-PAIRS = "":U OR coDatabase:LIST-ITEM-PAIRS = ? THEN
           coDatabase:ADD-LAST({&NO-DB},0).
        
        /* try to default to the current working database */
        IF cWorking <> "":U THEN
            ASSIGN coDatabase:SCREEN-VALUE = cWorking.
        ELSE
            ASSIGN coDatabase:SCREEN-VALUE = ENTRY(2,coDatabase:LIST-ITEM-PAIRS).
    
         /* remember if session parameter is set */
         supp_warn = SESSION:SUPPRESS-WARNINGS.
         /* suppress warnings for now */
         IF NOT supp_warn THEN
            SESSION:SUPPRESS-WARNINGS = YES.

         APPLY "VALUE-CHANGED":U TO coDatabase. /* force refresh of database list */

         IF NOT supp_warn THEN
            SESSION:SUPPRESS-WARNINGS = NO.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check-update-in-progress wWin 
PROCEDURE check-update-in-progress :
/*------------------------------------------------------------------------------
  Purpose:     Check if the visual object have modified screen data or 
               if its data-source has uncommitted changes.
               
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lModified       AS LOGICAL   NO-UNDO INIT NO.

   IF VALID-HANDLE (h_audpolicyviewv)  THEN
      RUN IsUpdatePending IN h_audpolicyviewv (INPUT-OUTPUT lModified).

   IF  lModified THEN
       RETURN "NO-APPLY":U.
   
   IF VALID-HANDLE (h_audfilepolicyviewv)  THEN
       RUN IsUpdatePending IN h_audfilepolicyviewv (INPUT-OUTPUT lModified).

   IF  lModified THEN
       RETURN "NO-APPLY":U.

   IF VALID-HANDLE (h_audfieldpolicyviewv)  THEN
       RUN IsUpdatePending IN h_audfieldpolicyviewv (INPUT-OUTPUT lModified).

   IF  lModified THEN
       RETURN "NO-APPLY":U.
   
   IF VALID-HANDLE (h_audevpolicyviewv)  THEN
       RUN IsUpdatePending IN h_audevpolicyviewv (INPUT-OUTPUT lModified).
   
   IF  lModified THEN
       RETURN "NO-APPLY":U.

   RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkDataDict wWin 
PROCEDURE checkDataDict :
/*------------------------------------------------------------------------------
  Purpose:     Called before user tries to either connect or disconnect a 
               database - we don't allow it if the Data Dictionary is open
               and active at the same time (if it is not active, than it's ok).
               There's too much going on in the Data Dict - transactions,
               field properties, and we don't want to mess it up by trying
               to synchronize it.
               
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/

/*DEFINE VARIABLE h      AS HANDLE  NO-UNDO.
DEFINE VARIABLE hproc  AS HANDLE  NO-UNDO.
*/
    /* let's go through all of the windows in the session and see if we can
       find the data dict tool
    */
  /*  h = SESSION:FIRST-CHILD.

    DO  WHILE VALID-HANDLE(h).

        IF VALID-HANDLE(h) and h:TYPE = "WINDOW" THEN DO:

            hproc = h:INSTANTIATING-PROCEDURE.

            IF VALID-HANDLE(hproc) THEN DO:
               IF hproc:NAME = "adedict/_dictg.p" THEN 
               DO:
                   MESSAGE "This option is not allowed while the Data Dictionary tool " +
                       "is running" VIEW-AS ALERT-BOX INFO.

                   RETURN "OPEN".
               END.
            END.
        END.
        h = h:NEXT-SIBLING.
    END.      */

    IF PROGRAM-NAME(4) = "adedict/_dcttran.p" OR 
       PROGRAM-NAME(4) = "adedict/_dictg.p" THEN DO:

       MESSAGE "This option is not allowed while the Data Dictionary tool " +
               "is active" VIEW-AS ALERT-BOX INFO.

       RETURN "OPEN".
    END.

    RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkDataModified wWin 
PROCEDURE checkDataModified :
/*------------------------------------------------------------------------------
  Purpose:     Check if there are pending changes in the working database.
               If there are, we enable all the options that should be enabled
               for the user to access. This gets called when the user makes 
               the first change (adds,updates or deletes a record), in which case
               we unsubscribe from the published events so we don't keep calling
               this procedure. We subscribe the events again once the user either
               commit or undoes the changes.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lMod AS LOGICAL NO-UNDO.

  /* if we already know there are changes pending, just return */
  IF changesPending = YES  THEN
     RETURN.

  /* check if there are pending changes */
  RUN getDataModified IN hAuditCacheMgr (OUTPUT lMod).

  IF lMod THEN DO: /* changes pending */
     /* unsubscribe the events we had subscribed for so we could check
        when the first change was made 
     */
     RUN doUnsubscribes.

     /* enable the commit/undo changes menu options */
     RUN set-commit-options(YES).

     /* refresh the policy menu options. For instance, if there were no policies
        when the tool was executed, and the user adds a policy, we have to
        enable the options so he can activate / deactivate a police and report 
        conflicts.
     */
     RUN refresh-policy-menu.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPendingChanges wWin 
PROCEDURE checkPendingChanges :
/*------------------------------------------------------------------------------
  Purpose:     Check if there are pending changes that were not saved and ask
               what user wants to do with them
               
  Parameters:  cMode - "changedb" when user is changing the working db in the combo-box
                       "refresh"  when user selectes the "Refresh Policies" option under
                                  the Policy menu.
                       "exit"     when user tries to exit out of the application
                       
  Notes:       Returns "NO-APPLY" to the caller so it knows not to continue
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER cMode AS CHARACTER.

DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

    /* make sure user is not in the middle of an update */
    RUN check-update-in-progress.

    IF RETURN-VALUE = "NO-APPLY":U THEN DO:

        ASSIGN cMsg = 'Either save or cancel the changes to the current record before '.
        IF cMode = "changedb":U THEN
            cMsg = cMsg + "switching to a different database".
        ELSE IF cMode = "exit":U THEN
            cMsg = cMsg + "exiting the application".
        ELSE IF cMode = "commit":U THEN
            cMsg = cMsg + "commiting changes".
        ELSE IF cMode = "undo":U THEN
            cMsg = cMsg + "undoing changes".
        ELSE
            cMsg = cMsg + "refreshing the policies".

        MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.

        RETURN "NO-APPLY":U.
    END.

    /* for these modes, that's all we wanted, so return */
    IF cMode = "commit":U OR cMode = "undo":U THEN
       RETURN.

    /* if there are changes that were not saved, ask the user what he wants to do*/
    IF changesPending THEN DO:

        /* build message according to each case */
        ASSIGN cMsg = "You have not saved the current changes to the database."
                      + CHR(10).

        IF cMode = "changedb":U THEN DO:
            ASSIGN cMsg = cMsg + "The changes will be lost once you change the working database."
                          + chr(10) + chr(10) + "Do you wish to save the changes before you select another database?".
        END.
        ELSE IF cMode = "disconnectdb" THEN DO:
            ASSIGN cMsg = cMsg + "The changes will be lost once you disconnect the working database."
                          + chr(10) + chr(10) + "Do you wish to save the changes before you disconnect the database?".
        END.
        ELSE IF cMode = "exit" THEN DO:
            ASSIGN cMsg = cMsg + "The changes will be lost once you exit the application."
                          + chr(10) + chr(10) + "Do you wish to save the changes before you exit?".
        END.
        ELSE DO: /* cMode = "refresh" */
            ASSIGN cMsg = cMsg + "The changes will be lost once you refresh the policies."
                          + chr(10) + chr(10) + "Do you wish to save the changes before you refresh?".
        END.

        /* ask the user what he wants to do */
        MESSAGE cMsg VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
                UPDATE choice AS LOGICAL.
                    
        CASE choice:
            WHEN YES THEN DO:
                RUN doCommitChanges.
            END.
            WHEN NO THEN DO:
                RUN doUndoChanges.
            END.
            OTHERWISE DO:
                /* user selected the Cancel button, so don't change the
                  working database.
                */
                RETURN "NO-APPLY":U.
            END.
        END CASE.

        /*  doCommitChanges and doUndoChanges ask for confirmation. If the user decided
            then to cancel, we receive "NO-APPLY", in which case we don't do anything either
        */
        IF RETURN-VALUE = "NO-APPLY":U THEN
            RETURN "NO-APPLY":U.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE constructObject wWin 
PROCEDURE constructObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcProcName AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER phParent   AS HANDLE NO-UNDO.
  DEFINE INPUT  PARAMETER pcPropList AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER phObject   AS HANDLE NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* since we may have adm2 underneath auditing, check if it's there and run it from there */
  IF pcProcName = 'adm2/folder.w':U THEN DO:
      IF  (SEARCH(pcProcName) = ? OR SEARCH('adm2/folder.r':U) = ? ) AND 
          (SEARCH('auditing/':U + pcProcName) <> ? OR SEARCH ('auditing/adm2/folder.r':U) <> ?) THEN
          ASSIGN   pcProcName = "auditing/":U + pcProcName.
  END.

  RUN SUPER( INPUT pcProcName, INPUT phParent, INPUT pcPropList, OUTPUT phObject).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteComplete wWin 
PROCEDURE deleteComplete :
/*------------------------------------------------------------------------------
  Purpose:     We subscribe to the deleteComplete event so we know when a
               record is deleted, so we can enable the commit/undo changes
               options.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE i AS INTEGER NO-UNDO.

    RUN checkDataModified.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject wWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE hdl AS HANDLE NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  
  /* if we were running against an AppServer, disconnect now */
  RUN disconnectAppServer IN hAuditCacheMgr ({&APMT_PARTITION_NAME}).

  /* delete the auditUtils procedure */
  IF VALID-HANDLE(hAuditCacheMgr) THEN DO:
     RUN destroyObject IN hAuditCacheMgr.
     DELETE PROCEDURE hAuditCacheMgr.
     hAuditCacheMgr = ?.
  END.

  /* destroy the event maintenance window if it is still open */
   hdl = SESSION:FIRST-PROCEDURE.
   DO WHILE VALID-HANDLE(hdl): 
      IF hdl:FILE-NAME eq "auditing/ui/_audeventmaintw.w":U
      THEN DO:
        DELETE PROCEDURE hdl.
        LEAVE.
      END.
      hdl = hdl:NEXT-SIBLING.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doActivatePolicies wWin 
PROCEDURE doActivatePolicies :
/*------------------------------------------------------------------------------
  Purpose:     procedure that gets called when user selects the Activate policies
               option.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* pass it to the browse */
    RUN activatePolicies IN h_audpolicybrowb.
    
    /* chek if any message was returned */
    IF RETURN-VALUE = "":U THEN
        /* no message, make sure we enable the commit/undo changes options */
       RUN checkDataModified.
    ELSE
        MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX INFO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doAPMTHelp wWin 
PROCEDURE doAPMTHelp :
/*------------------------------------------------------------------------------
  Purpose:     Bring up the APMT help
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN adecomm/_adehelp.p ("audit":U, "TOPICS":U, ?, ?).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doCommitChanges wWin 
PROCEDURE doCommitChanges :
/*------------------------------------------------------------------------------
  Purpose:     Commit the pending changes.  We always commit to the working database
               defined in the combo-box.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cRet  AS CHARACTER NO-UNDO.

    /* if a record is being updated, can't commit changes */
    RUN checkPendingChanges("commit":U).
    
    /*  checkPendingChanges check if there are changes pending and return "NO-APPLY"
        if there are in which case we can't proceed.
    */
    IF RETURN-VALUE = "NO-APPLY":U THEN
       RETURN.

    /* ask for confirmation */
    MESSAGE "Are you sure you want to commit the changes?" VIEW-AS ALERT-BOX
        QUESTION BUTTONS YES-NO UPDATE choice AS LOGICAL.

    IF choice = YES THEN DO:

        RUN setcursor ("WAIT":u).

        /* now let's save the changes. The audit utils procedure keeps a dataset
           object which was tracking all the changes, so now we just have to tell it
           to save the changes.
         */
        RUN saveChangesAuditDatabase IN hAuditCacheMgr.

        ASSIGN cRet = RETURN-VALUE.
    
        RUN setcursor ("":U).

        /* trap errors */
        IF cRet = "":U THEN DO:

            /* go back to page 1 */
            RUN selectPage (INPUT 1).   

            /* no errors */
            MESSAGE "Commit succeeded." VIEW-AS ALERT-BOX INFO.

            /* disable the options in the menu */
            RUN set-commit-options(NO).

            /* refresh the Policy menu */
            RUN refresh-policy-menu.

            /* subscribe the events again so we catch when a change is made */
            RUN doSubscribes.


        END.
        ELSE DO:
            /* it failed, report the error */
            MESSAGE RETURN-VALUE SKIP "Commit failed." VIEW-AS ALERT-BOX ERROR.
        END.
    END.
    ELSE
        RETURN "NO-APPLY":U. /* user canceled */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doConnectDb wWin 
PROCEDURE doConnectDb :
/*------------------------------------------------------------------------------
  Purpose:     Connects to a database (local or client-server). Open the 
              'Connect db' dialog used by the Data Admin tool.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE Db_Pname AS CHARACTER NO-UNDO.
DEFINE VARIABLE Db_Lname AS CHARACTER NO-UNDO.
DEFINE VARIABLE Db_Type  AS CHARACTER NO-UNDO INITIAL ?.
DEFINE VARIABLE newId    AS INTEGER   NO-UNDO.
DEFINE VARIABLE iLoop    AS INTEGER   NO-UNDO.
DEFINE VARIABLE cList    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDbInfo  AS CHARACTER NO-UNDO INITIAL ?.

    RUN checkDataDict.

    IF RETURN-VALUE = "OPEN" THEN
       RETURN.

    /* bring up the connect dialog */
    run adecomm/_dbconn.p
                (INPUT-OUTPUT  Db_Pname,
                INPUT-OUTPUT  Db_Lname,
                INPUT-OUTPUT  Db_Type).
    
    IF Db_Lname <> ? THEN  DO: /* connect succeeded */
       
       DO WITH FRAME {&FRAME-NAME}:
    
            /* first get db's connected on this session and check if the
               db we just connected is in the list. If not, then it must
               mean that the db is not audit enabled or user doesn't have
               permissions to read tables
            */
            RUN auditing/_get-db-list.p (NO /* not complete list */, 
                                         OUTPUT cList).

            DO iLoop = 1 TO NUM-ENTRIES(cList, CHR(1))
            ON ERROR UNDO, LEAVE:

                ASSIGN cdbInfo = ENTRY(iLoop, cList, CHR(1)) .
                /* if found one, leave now */
                IF DYNAMIC-FUNCTION('get-DB-Name' IN  hAuditCacheMgr, cDbInfo) = Db_Lname THEN
                    LEAVE.
                ELSE
                    ASSIGN cDbInfo = ?.
           END.

           /* check if we found it */
           IF cDbInfo <> ? THEN DO:

               RUN addDbToCombo (INPUT cdbInfo).

                /* if <NONE> is in the combo-box, remove it */
                coDatabase:DELETE("0" /*{&NO-DB}*/) NO-ERROR.
    
                /* get the id of the entry just added */
                FIND LAST workDb USE-INDEX id NO-ERROR.
                IF NOT AVAILABLE workDb THEN /* shouldn't happen, but ... */
                    ASSIGN newId = 1.
                ELSE
                    ASSIGN newId = workDb.id.

                /* make it the default */
                ASSIGN coDatabase:SCREEN-VALUE = STRING(newId).
    
                APPLY "value-changed":U TO coDatabase.
           END.
           ELSE
               MESSAGE Db_Lname " is not enabled for auditing or you do not have the necessary permissions.~n~n"
                   "The database will remain connected but it will not appear in the combo-box." VIEW-AS ALERT-BOX INFO.
       END.

       /* check if either the data admin or the data dict tool is open */
       RUN refresh-admin-util.

    END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doDeactivatePolicies wWin 
PROCEDURE doDeactivatePolicies :
/*------------------------------------------------------------------------------
  Purpose:     Called when user selects the deactivate policies option
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* pass it to the browse */
    RUN deactivatePolicies IN h_audpolicybrowb.
    
    /* trap messages */
    IF RETURN-VALUE = "":U THEN
       RUN checkDataModified.
    ELSE
       MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX INFO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doDisconnectDb wWin 
PROCEDURE doDisconnectDb :
/*------------------------------------------------------------------------------
  Purpose:     Disconnects a database (local or client-server). Open the 
              'Disconnect db' dialog.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON bOK LABEL "&OK" SIZE 15 BY 1.14 AUTO-GO.
    DEFINE BUTTON bCancel LABEL "&Cancel" SIZE 15 BY 1.14 AUTO-ENDKEY.
    DEFINE RECTANGLE rHeavyRule 
           EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL 
           SIZE 62 BY 1.42.

    DEFINE RECTANGLE dbRect
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 62 BY 7.81.

    DEFINE VARIABLE i        AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lline    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE discondb AS LOGICAL   NO-UNDO INIT NO.

    DEFINE VARIABLE db-list AS CHARACTER INITIAL ""
           VIEW-AS SELECTION-LIST SINGLE SORT 
           SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
           SIZE 60 BY 7 NO-UNDO.

    DEFINE FRAME frDisconnect
      db-list AT ROW 2 COL 3 NO-LABEL FONT 0 WIDGET-ID 2
      bOK AT ROW 2 COL 65.5 WIDGET-ID 4
      bCancel AT ROW 3.6 COL 65.5 WIDGET-ID 6
      dbRect AT ROW 1.52 COL 2 WIDGET-ID 8
      "Databases" VIEW-AS TEXT
          SIZE 11.2 BY .62 AT ROW 1.19 COL 3.8  WIDGET-ID 10
      WITH  WIDTH 82 VIEW-AS DIALOG-BOX NO-ATTR-SPACE USE-TEXT THREE-D
      DEFAULT-BUTTON bOK CANCEL-BUTTON bCancel
      ROW 5 COLUMN 10 TITLE "Disconnect Database...".

    ON GO of frame frDisconnect
    DO:
      DEFINE VAR cName AS CHARACTER NO-UNDO.

      ASSIGN db-list.
      IF db-list <> "" AND db-list <> ? THEN DO:

        /* get the db name */
        ASSIGN cName = TRIM(SUBSTRING(db-list,1,15,"CHARACTER":U)).

        /* check if this is the working database */
        FIND FIRST workDB WHERE ENTRY(1,workDb.dbInfo) = cName NO-ERROR.
        IF AVAILABLE workDB THEN DO:

            /* check if this is the working database */
            IF coDatabase:INPUT-VALUE IN FRAME {&FRAME-NAME} = workDb.Id THEN DO:

                /* if there are changes that were not saved, ask the user what he wants to do*/
                RUN checkPendingChanges("disconnectdb":U).

                /*  checkPendingChanges check if there are changes pending, and asks if the user
                    wants to undo or commit the changes. If the user canceled, then RETURN-VALUE will
                    be set to "NO-APPLY", in which case we don't do anything either
                */
                IF RETURN-VALUE = "NO-APPLY":U THEN DO:
                    RETURN NO-APPLY.
                END.
            END.
        END.
        
        HIDE FRAME frDisconnect.

        /* now go ahead and disconnect db */
        DISCONNECT VALUE(cName) NO-ERROR.

        IF ERROR-STATUS:ERROR THEN
            MESSAGE "Failed to disconnect database." SKIP ERROR-STATUS:GET-MESSAGE(1)
            VIEW-AS ALERT-BOX.
        ELSE DO:
            MESSAGE cName "has been disconnected" VIEW-AS ALERT-BOX INFO.
            ASSIGN discondb = YES.
        END.
        /* the entry trigger can handle database disconnection, so just apply it to get database 
           combo-box refreshed 
        */
        APPLY "entry" TO wWin.
      END.
    END.

    ON WINDOW-CLOSE OF FRAME frDisconnect
    DO:
       APPLY 'CHOOSE' TO bCancel.
    END.

    /* make sure that there are db's to be disconnected */
    IF NUM-DBS = 0 THEN DO:
        MESSAGE "No databases connected" VIEW-AS ALERT-BOX INFO.
        RETURN.
    END.

    RUN checkDataDict.
    IF RETURN-VALUE = "OPEN" THEN
       RETURN.

    /* make sure user is not in the middle of an update */
    RUN check-update-in-progress.
    IF RETURN-VALUE = "NO-APPLY":U THEN DO:
        MESSAGE "Cannot disconnect database while in the middle of an update" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    DO ON ERROR UNDO,LEAVE  ON ENDKEY UNDO,LEAVE:

        DO WITH FRAME frDisconnect:
        
           /* initialize the db list */
           ASSIGN db-list:SCREEN-VALUE = ""
                  db-list:LIST-ITEMS   = "".
           DO i = 1 to NUM-DBS:
              ASSIGN lline                = ldbname(i)
                     substring(lline, 16, -1, "CHARACTER") = "[" + DBTYPE(ldbname(i)) + "]".
             IF db-list:ADD-LAST(lline) THEN.
           END.

           DISPLAY db-list WITH FRAME frDisconnect.
           
           IF NUM-DBS > 0 THEN 
               db-list:SCREEN-VALUE = ENTRY(1,db-list:LIST-ITEMS).
    
           ENABLE bCancel bOK db-list WITH FRAME frDisconnect.
        
           WAIT-FOR CHOOSE of bOK in FRAME frDisconnect OR
                GO of frame frDisconnect OR WINDOW-CLOSE OF FRAME frDisconnect
                FOCUS bOK.

           /* if we indeed disconnected a db, check if either the data admin
              or the data dict tool is open 
           */
           IF discondb THEN
              RUN refresh-admin-util.

        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doEventMaintenance wWin 
PROCEDURE doEventMaintenance :
/*------------------------------------------------------------------------------
  Purpose:   Brings up the Event Maintenance window. We pass the current
             working database so we see the audit events from the same
             database. When the user changes the working database in the main window,
             we also refresh the information in the Events Maintenance window, if it's
             open.
  Parameters:  <none>
  Notes:     We check if it's already running, and just move focus to it.  
------------------------------------------------------------------------------*/
DEFINE VARIABLE h       AS HANDLE    NO-UNDO.
DEFINE VARIABLE cDbName AS CHARACTER NO-UNDO.

    /* Prevent the procedure from being called twice (by checking FILE-NAME) */
    IF THIS-PROCEDURE:PERSISTENT THEN DO:
      /* See if a copy already exists. */
      hdl = SESSION:FIRST-PROCEDURE.
      DO WHILE VALID-HANDLE(hdl): 
        IF hdl:FILE-NAME eq "auditing/ui/_audeventmaintw.w":U
        THEN DO:
          hdlWin = hdl:CURRENT-WINDOW.
          IF hdlWin:WINDOW-STATE = 2 THEN hdlWin:WINDOW-STATE = 3.
          IF hdlWin:MOVE-TO-TOP() THEN.
          RETURN.
        END.
        hdl = hdl:NEXT-SIBLING.
      END.
    END. 
    
    /* get the db info to send to the procedure */
    RUN getWorkingAuditDbInfo (OUTPUT cDbName).
    
    IF cDbName = "":U THEN DO:
        MESSAGE "No working database selected. " VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    
    /* bring up the window */
    RUN auditing/ui/_audeventmaintw.w PERSISTENT SET h (cDbName).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doExportPolicy wWin 
PROCEDURE doExportPolicy :
/*------------------------------------------------------------------------------
  Purpose:     Export selected policies to a file (XML format)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE errorMsg  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFileName AS CHARACTER NO-UNDO.
DEFINE VARIABLE cList     AS CHARACTER NO-UNDO.
DEFINE VARIABLE pcDbInfo  AS CHARACTER NO-UNDO.

    /* get the string with the database info. It builds it out of the screen-value 
      of this combo-box
    */
    RUN getWorkingAuditDbInfo(OUTPUT pcDbInfo).

    /* check if user is admin - info passed in pcDbInfo */
    IF NOT DYNAMIC-FUNCTION('has-DB-option' IN  hAuditCacheMgr, pcDbInfo, {&AUDIT-ADMIN})  THEN DO:
        MESSAGE "You do not have the necessary privileges to run this option!" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    DO ON ERROR UNDO, LEAVE.

       RUN setcursor ("WAIT":u).

       /* get the list of selected policies from the browse */
       RUN getSelectedPolicies IN h_audpolicybrowb (OUTPUT cList).

       RUN setcursor ("":u).

       /* if list is empty, display an error */
       IF cList = ? OR cList = "":U THEN DO:
           MESSAGE 'You must select one or more policies to be exported in '
                   'the "Available Audit Policies" browse' VIEW-AS ALERT-BOX ERROR.
           RETURN.
       END.

       /* bring up the dialog to get the file name */
       RUN auditing/ui/_get-file.w (INPUT "save":U, /* mode */
                                    INPUT "Export Policy":U, /* title */
                                    INPUT "*.xml":U,
                                    INPUT "*.xml":U,
                                    OUTPUT cFileName).
                    
       /* check if file name was specified */
       IF cFileName <> "":U THEN DO:
    
            RUN setcursor ("WAIT":u).
    
            /* call the procedure in the auditUtils procedure do do the job */
            RUN export-policies-to-xml IN hAuditCacheMgr (INPUT cList,
                                                           INPUT cFileName,
                                                           OUTPUT errorMsg).
            RUN setcursor ("":U).
    
            /* either display error message or number of records exported to the file */
            IF errorMsg <> "":U THEN
               MESSAGE errorMsg VIEW-AS ALERT-BOX ERROR.
            ELSE
                MESSAGE (IF NUM-ENTRIES(cList) = 1 THEN "Policy" ELSE "Policies")
                        "exported to" cFileName
                    VIEW-AS ALERT-BOX INFO.

       END. /* cFileName <> "":U */
    END.  /* DO block */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doImportPolicy wWin 
PROCEDURE doImportPolicy :
/*------------------------------------------------------------------------------
  Purpose:     Import one or more polcies from XML file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE errorMsg  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFileName AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDupList  AS CHARACTER NO-UNDO.
DEFINE VARIABLE imported  AS LOGICAL   NO-UNDO.

DEFINE VARIABLE pcDbInfo  AS CHARACTER NO-UNDO.

    /* get the string with the database info. It builds it out of the screen-value 
      of this combo-box
    */
    RUN getWorkingAuditDbInfo(OUTPUT pcDbInfo).

    /* check if user is admin - info passed in pcDbInfo */
    IF NOT DYNAMIC-FUNCTION('has-DB-option' IN  hAuditCacheMgr, pcDbInfo, {&AUDIT-ADMIN})  THEN DO:
        MESSAGE "You do not have the necessary privileges to run this option!" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    DO ON ERROR UNDO, LEAVE.

       /* bring up the dialog to get the file name */
       RUN auditing/ui/_get-file.w (INPUT "open":U, /* mode */
                                    INPUT "Import Policy":U, /* title */
                                    INPUT "*.xml":U ,  INPUT "*.xml":U,
                                    OUTPUT cFileName).
                    
       /* check if file name was specified */
       IF cFileName <> "":U THEN DO:
    
            RUN setcursor ("WAIT":U).
    
            /* call the procedure in the auditUtils procedure do do the job */
            RUN import-policies-from-xml IN hAuditCacheMgr (INPUT cFileName,
                                                             OUTPUT cDupList,
                                                             OUTPUT errorMsg).
            RUN setcursor ("":U).
    
            /* either display error message or confirmation that the policies were imported */
            IF errorMsg <> "":U THEN
               MESSAGE errorMsg VIEW-AS ALERT-BOX ERROR.
            ELSE DO:
                /* check if xml file has policies which already exist */
                IF cDupList <> "" THEN DO:
                    
                    MESSAGE "The following policies already exist:" SKIP 
                            REPLACE(cDupList,",",CHR(10)) SKIP
                            "Do you want to override them?" SKIP 
                            "(If Yes, the listed policies will be deleted and re-imported)" VIEW-AS ALERT-BOX
                            QUESTION BUTTON YES-NO UPDATE choice AS LOGICAL.

                    IF choice = TRUE THEN DO:
                        /* user confirmed that he wants to override existing policies,
                           so let's pick up from where we left off. Keep the changes.
                        */
                        RUN setcursor ("WAIT":U).

                        RUN resubmit-import-from-xml IN hAuditCacheMgr(OUTPUT errorMsg).

                        RUN setcursor ("":U).

                        IF errorMsg = "" THEN
                           ASSIGN imported = YES.
                        ELSE
                           MESSAGE errorMsg VIEW-AS ALERT-BOX ERROR.
                    END.
                    ELSE DO:
                        /* user doesn't want to override policies, so cancel the previous
                           request
                        */
                        RUN cancel-import-from-xml IN hAuditCacheMgr.

                        MESSAGE "Import canceled" VIEW-AS ALERT-BOX INFO.
                    END.
                END.
                ELSE
                    ASSIGN imported = YES.


                /* check if import succeeded. */
                IF imported = YES THEN DO:
                    MESSAGE "Policies imported from " cFileName VIEW-AS ALERT-BOX INFO.

                    /* let's reopen the queries so we show the correct records */
                    RUN reopen-queries.

                    /* check if there are changes, so we enable the commit/undo changes
                       options
                    */
                    RUN checkDataModified.

                    /* enable/disable options in the Policy menu accordingly */
                    RUN refresh-policy-menu.

                END. /* imported = yes */
            END. /* errorMsg <> "":U  */
       END. /* cFileName <> "":U */
    END. /* DO block */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doMasterHelp wWin 
PROCEDURE doMasterHelp :
/*------------------------------------------------------------------------------
  Purpose:     Bring up the Master Help
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN adecomm/_adehelp.p ("mast", "TOPICS", ?, ?).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doRefreshPolicies wWin 
PROCEDURE doRefreshPolicies :
/*------------------------------------------------------------------------------
  Purpose:     Refresh the policies - this is useful when the user either stepped
               out for a long period of time, or wants to see the latest version
               of the policies in case he is running in multi-user mode.
               Also, if he undid changes, we don't automatically refresh policies.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE c AS CHARACTER NO-UNDO.

        /* if there are changes that were not saved, ask the user what he wants to do*/
        RUN checkPendingChanges("refresh":U).

        /*  checkPendingChanges check if there are changes pending, and asks if the user
            wants to undo or commit the changes. If the user canceled, then RETURN-VALUE will
            be set to "NO-APPLY", in which case we don't do anything either
        */
        IF RETURN-VALUE = "NO-APPLY":U THEN DO:
            /* retrun the database name back to what it was */
            RETURN NO-APPLY.
        END.

        /* get the string with the database info. It builds it out of the screen-value 
          of this combo-box
        */
        RUN getWorkingAuditDbInfo(OUTPUT c).

        /* publish the the new database so we get the records from the given db */
        PUBLISH "changeAuditDatabase":U (c).

        /* report any errors */
        IF RETURN-VALUE <> "":U THEN DO:
            MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX ERROR.
        END.

        /* let's reopen the policy sdo query so we show the correct records */
        RUN reopen-queries.

        /* enable/disable options in the Policy menu accordingly - in case policies were
           deleted or added in the meantime
        */
        RUN refresh-policy-menu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doReportConflicts wWin 
PROCEDURE doReportConflicts :
/*------------------------------------------------------------------------------
  Purpose:     Report conflicts on active policies. Gets the info on conflict from
               the audit cache manager, which has a dataset with all the policies
               we are looking at.
               
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lcDetails AS LONGCHAR VIEW-AS EDITOR LARGE SCROLLBAR-VERTICAL 
                                              SIZE 120 BY 15 NO-UNDO.
DEFINE VARIABLE cErrorMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFileName AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTempFile AS CHARACTER NO-UNDO.

    RUN setcursor ("WAIT":U).

    /* make sure temp-table is empty */
    EMPTY TEMP-TABLE ttAudReport NO-ERROR.

    /* get the information on conflicting settings and policies */
    RUN get-conflict-info IN  hAuditCacheMgr (OUTPUT TABLE ttAudReport, OUTPUT cErrorMsg).

    RUN setcursor ("":U).

    /* check for errors returned */
    IF cErrorMsg <> "":U THEN DO:
        MESSAGE cErrorMsg VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    FIND FIRST ttAudReport NO-ERROR.
    /* if no records in the temp-table, no conflicts were found */
    IF NOT AVAILABLE ttAudReport THEN DO:
        MESSAGE "No conflicts found." VIEW-AS ALERT-BOX INFO.
        RETURN.
    END.

    IF ttAudReport.cType = "NOACTIVEPOLICY":U  /*lcData = "NOACTIVEPOLICY":U*/ THEN DO:
       MESSAGE "You must have at least one active policy to be able to"
                "check for conflicts" VIEW-AS ALERT-BOX INFO.

       EMPTY TEMP-TABLE ttAudReport NO-ERROR.
    END.
    ELSE DO:
    
        /* if we got a list of conflicts to report, build a very simple frame
           and display the report.
        */
        DEFINE BUTTON bClose LABEL "&OK" SIZE 15 BY 1.14 TOOLTIP "Close window".
        
        DEFINE BUTTON bSave LABEL "&Save..." SIZE 15 BY 1.14 TOOLTIP "Save report to a file".

        DEFINE FRAME frame-conflicts
            "Conflicts found:" AT ROW 1.5 COL 5.5 WIDGET-ID 2
            lcDetails NO-LABEL FONT 0 AT ROW 2.5 COL 5.5 WIDGET-ID 4
            bClose AT ROW 18 COL 72 WIDGET-ID 6
            bSave AT ROW 18 COL 42 WIDGET-ID 8
            WITH KEEP-TAB-ORDER OVERLAY 
                 SIDE-LABELS NO-UNDERLINE THREE-D 
                 TITLE "Conflicts Report"
                 VIEW-AS DIALOG-BOX CANCEL-BUTTON bClose DEFAULT-BUTTON bClose
                 SIZE 130 BY 20.
        
        ON WINDOW-CLOSE OF FRAME frame-conflicts
        DO:
           APPLY 'CHOOSE' TO bClose.
        END.
        
        ON 'choose':U OF bSave IN FRAME frame-conflicts
        DO:

           /* bring up the dialog to get the file name */
           RUN auditing/ui/_get-file.w (INPUT "save":U, /* mode */
                                        INPUT "Report Conflicts":U, /* title */
                                        INPUT "All Files (*.*)":U,
                                        INPUT "*.*":U,
                                        OUTPUT cFileName).
                        
           /* check if file name was specified */
           IF cFileName <> "":U THEN DO:
        
              RUN setcursor ("WAIT":u).

              FILE-INFO:FILE-NAME = cFileName.

              IF FILE-INFO:FILE-TYPE NE ? THEN DO:
                  /* file exists - check we can write to it */
                  IF INDEX(FILE-INFO:FILE-TYPE, "W":U) = 0 THEN DO:
                      MESSAGE "File " cFileName " is read-only" VIEW-AS ALERT-BOX ERROR.
                      RETURN NO-APPLY.
                  END.

                  FILE-INFO:FILE-NAME = ?.
              END.

              /* just copy our temp-file */
              OS-COPY VALUE (cTempFile) VALUE(cFileName).

              RUN setcursor ("":U).

              MESSAGE "Report saved successfully." VIEW-AS ALERT-BOX INFO.
           END.
        END.

        RUN setcursor ("WAIT":U).

        /* generate a simple report to display to the user */
        RUN generateConflictReport ( OUTPUT cTempFile).

        RUN setcursor ("":U).

        DISPLAY lcDetails WITH FRAME frame-conflicts.

        /* load the contents of the temp file report into the editor */
        lcDetails:READ-FILE(cTempFile).

        ASSIGN  lcDetails:READ-ONLY= YES.
        
        ENABLE bClose lcDetails bSave WITH FRAME frame-conflicts.
        
        /* we are done with this table */
        EMPTY TEMP-TABLE ttAudReport NO-ERROR.

        DO ON ERROR UNDO, LEAVE
           ON STOP UNDO, LEAVE: /* trap errors */

           WAIT-FOR CHOOSE OF bClose.

        END.

        OS-DELETE VALUE(cTempFile) NO-ERROR.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doReportMerge wWin 
PROCEDURE doReportMerge :
/*------------------------------------------------------------------------------
  Purpose:     Report the effective settings of all policies that are active.
               Note that it reports just what is going to be audited. Anything that
               is off, won't show up.               
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lcDetails AS LONGCHAR VIEW-AS EDITOR LARGE SCROLLBAR-VERTICAL 
                                              SIZE 120 BY 15 NO-UNDO.
DEFINE VARIABLE cErrorMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFileName AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTempFile AS CHARACTER NO-UNDO.

    RUN setcursor ("WAIT":U).

    /* make sure temp-table is empty */
    EMPTY TEMP-TABLE ttAudReport NO-ERROR.

    /* get the information on merged settings and policies */
    RUN get-merge-info IN  hAuditCacheMgr (OUTPUT TABLE ttAudReport, OUTPUT cErrorMsg).

    RUN setcursor ("":U).

    /* check for errors returned */
    IF cErrorMsg <> "":U THEN DO:
        MESSAGE cErrorMsg VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    FIND FIRST ttAudReport NO-ERROR.
    /* if no records in the temp-table, nothing is on to be audited ? or something really bad happen, 
       since we check if there are active policies before doing anything else.
    */
    IF NOT AVAILABLE ttAudReport THEN DO:

        MESSAGE "Nothing is set up to be audited (table / event settings are off)." VIEW-AS ALERT-BOX INFO.

        /*MESSAGE "ERROR: Could not retrieve the settings of the active policies" VIEW-AS ALERT-BOX INFO.*/
        RETURN.
    END.

    IF ttAudReport.cType = "NOACTIVEPOLICY":U THEN DO:
       MESSAGE "You must have at least one active policy to be able to"
                "generate this report" VIEW-AS ALERT-BOX INFO.

       EMPTY TEMP-TABLE ttAudReport NO-ERROR.
    END.
    ELSE DO:
    
        /* if we got a list to be reported, build a very simple frame
           and display the report.
        */
        DEFINE BUTTON bClose LABEL "&OK" SIZE 15 BY 1.14 TOOLTIP "Close window".

        DEFINE BUTTON bSave LABEL "&Save..." SIZE 15 BY 1.14 TOOLTIP "Save report to a file".
        
        DEFINE FRAME frame-effective
            "Effective auditing settings:" AT ROW 1.5 COL 5.5 WIDGET-ID 2
            lcDetails NO-LABEL FONT 0 AT ROW 2.5 COL 5.5 WIDGET-ID 6
            bClose AT ROW 18 COL 72 WIDGET-ID 8
            bSave AT ROW 18 COL 42 WIDGET-ID 10
            WITH KEEP-TAB-ORDER OVERLAY 
                 SIDE-LABELS NO-UNDERLINE THREE-D 
                 TITLE "Effective settings report"
                 VIEW-AS DIALOG-BOX CANCEL-BUTTON bClose DEFAULT-BUTTON bClose
                 SIZE 130 BY 20.
        
        ON WINDOW-CLOSE OF FRAME frame-effective
        DO:
           APPLY 'CHOOSE' TO bClose.
        END.

        ON 'choose':U OF bSave IN FRAME frame-effective
        DO:
            /* bring up the dialog to get the file name */
           RUN auditing/ui/_get-file.w (INPUT "save":U, /* mode */
                                        INPUT "Effective Settings":U, /* title */
                                        INPUT "All Files (*.*)":U,
                                        INPUT "*.*":U,
                                        OUTPUT cFileName).
                        
           /* check if file name was specified */
           IF cFileName <> "":U THEN DO:
        
              RUN setcursor ("WAIT":u).

              FILE-INFO:FILE-NAME = cFileName.

              IF FILE-INFO:FILE-TYPE NE ? THEN DO:
                  /* file exists - check we can write to it */
                  IF INDEX(FILE-INFO:FILE-TYPE, "W":U) = 0 THEN DO:
                      MESSAGE "File " cFileName " is read-only" VIEW-AS ALERT-BOX ERROR.
                      RETURN NO-APPLY.
                  END.

                  FILE-INFO:FILE-NAME = ?.
              END.

              /* just copy our temp-file */
              OS-COPY VALUE (cTempFile) VALUE(cFileName).

              RUN setcursor ("":U).

              MESSAGE "Report saved successfully." VIEW-AS ALERT-BOX INFO.
           END.
        END.
        
        RUN setcursor ("WAIT":U).

        /* generate a simple report to display to the user */
        RUN generateMergeReport (OUTPUT cTempFile).

        DISPLAY lcDetails WITH FRAME frame-effective.

        /* load the contents of the temp file report into the editor */
        lcDetails:READ-FILE(cTempFile).

        ASSIGN lcDetails:READ-ONLY= YES.

        RUN setcursor ("":U).
 
        ENABLE bClose lcDetails bSave WITH FRAME frame-effective.
        
        /* we are done with this table */
        EMPTY TEMP-TABLE ttAudReport NO-ERROR.

        DO ON ERROR UNDO, LEAVE
           ON STOP UNDO, LEAVE: /* trap errors */

           WAIT-FOR CHOOSE OF bClose.

        END.

        OS-DELETE VALUE(cTempFile) NO-ERROR.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doSubscribes wWin 
PROCEDURE doSubscribes :
/*------------------------------------------------------------------------------
  Purpose:     Subscribes to a set of events in all the sdo's so
               we catch when changes are made.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "deleteComplete":U IN h_audpolicysdo.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "deleteComplete":U IN h_audfilepolicysdo.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "deleteComplete":U IN h_audfieldpolicysdo.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "deleteComplete":U IN h_audevpolicysdo.

  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "updateState":U IN h_audpolicysdo.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "updateState":U IN h_audfilepolicysdo.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "updateState":U IN h_audfieldpolicysdo.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "updateState":U IN h_audevpolicysdo.       

  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "queryPosition":U IN h_audpolicysdo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doUndoChanges wWin 
PROCEDURE doUndoChanges :
/*------------------------------------------------------------------------------
  Purpose:     User selected the undo changes option. Undo all the pending
               changes.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* if a record is being updated, can't undo changes */
    RUN checkPendingChanges("undo":U).
    
    /*  checkPendingChanges check if there are changes pending and return "NO-APPLY"
        if there are in which case we can't proceed.
    */
    IF RETURN-VALUE = "NO-APPLY":U THEN
       RETURN.
    
    IF NOT supress_confirmation THEN
        /* ask for confirmation */
        MESSAGE "Are you sure you want to undo all the changes?" VIEW-AS ALERT-BOX
            QUESTION BUTTON YES-NO UPDATE choice AS LOGICAL.
    ELSE
        ASSIGN choice = YES
               /* reset it - only set when db got disconnect and we had changes pending */
               supress_confirmation = NO.

    IF choice = YES THEN DO:
        /* go back to page 1 */
        RUN selectPage (INPUT 1).   

        RUN setcursor ("WAIT":u).

        /* the audit utils procedure keeps a dataset which was tracking all
           the changes. So call the procedure to reject all the changes.
        */
        RUN rejectChangesAuditDatabase IN hAuditCacheMgr.
        
        RUN setcursor ("":U).

        /* refresh the info now so user sees current data after the changes were undone.
           This is just that the user see the data he had before he started making changes
         */
        RUN reopen-queries.
        
        /* disable the commit/undo changes options */
        RUN set-commit-options(NO).
        
        /* refresh the options in the Policy menu */
        RUN refresh-policy-menu.
        
        /* subscribe to the events so we catch when a change is made again */
        RUN doSubscribes.

        /* reset this */
        ASSIGN changesPending = NO.

    END.
    ELSE
        RETURN "NO-APPLY":U. /* user canceled */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doUnsubscribes wWin 
PROCEDURE doUnsubscribes :
/*------------------------------------------------------------------------------
  Purpose:     Unsubscribes from some sdo events. We do this once we catch
               a change so we enable the commit/undo changes options.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  UNSUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "deleteComplete":U IN h_audpolicysdo.
  UNSUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "deleteComplete":U IN h_audfilepolicysdo.
  UNSUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "deleteComplete":U IN h_audfieldpolicysdo.
  UNSUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "deleteComplete":U IN h_audevpolicysdo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable-menu-items-startup wWin 
PROCEDURE enable-menu-items-startup :
/*------------------------------------------------------------------------------
  Purpose:     Enables the menu options that should be always enabled at startup
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* the "connect db" option is not enabled for WebClient */
    IF {&NOT-WEBCLIENT} THEN
        DYNAMIC-FUNCTION( 'enableActions':U IN h_dyntoolbar, "Auditdbconnect,Auditdbdisconnect":U).
    ELSE
        DYNAMIC-FUNCTION( 'disableActions':U IN h_dyntoolbar, "Auditdbconnect,Auditdbdisconnect":U).

    DYNAMIC-FUNCTION( 'enableActions':U IN h_dyntoolbar, "MasterHelp,APMTHelp":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY coDatabase fill-warning 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE coDatabase 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/
  
  /* if there are changes that were not saved, ask the user what he wants to do*/
  RUN checkPendingChanges("exit":U).

  /*  checkPendingChanges check if there are changes pending, and asks if the user
      wants to undo or commit the changes. If the user canceled, then RETURN-VALUE will
      be set to "NO-APPLY", in which case we don't do anything either
  */
  IF RETURN-VALUE = "NO-APPLY":U THEN
      RETURN NO-APPLY.
                 
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateConflictReport wWin 
PROCEDURE generateConflictReport :
/*------------------------------------------------------------------------------
  Purpose:     Generates a report based on the info stored in ttAudReport. The format
               of the data in the temp-table is defined by _aud-conflict.p.
               
  Parameters:  OUTPUT cFileName - temp file name of report. Caller's responsible
                                  for removing file.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER cFileName AS CHARACTER NO-UNDO.

/* defines are also used in generateMergeReport */

&SCOPED-DEFINE EVENT-OFF-STR              "<audit event is off>"
&SCOPED-DEFINE MULTIPLE-VALUES-STR        "<multiple values found for the same setting>"
&SCOPED-DEFINE FIELD-IGNORED-STR          "<ignored - event is off at table level>"
&SCOPED-DEFINE IDENTIFYING-CONFLICT-STR   "<ordinal position conflicts with another field>"


DEFINE VARIABLE i            AS INTEGER   NO-UNDO.
DEFINE VARIABLE cWork        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTemp        AS CHARACTER NO-UNDO.
DEFINE VARIABLE ident        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLevel1      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLevel2      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLevel3      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSecLevel    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cEvent-info  AS CHARACTER NO-UNDO.
DEFINE VARIABLE iEventID     AS INTEGER   NO-UNDO.
DEFINE VARIABLE cEventID     AS CHARACTER NO-UNDO.

    RUN get-tmpfile-name ("" , ".tmp" , OUTPUT cFileName).

    /* open temp report file for writing */
    OUTPUT TO VALUE(cFileName).

    /* header info */
    PUT UNFORMATTED FILL(" ",20)  "OpenEdge Audit Policies: Conflicts Report" SKIP
                    FILL(" ",24)  "Date/Time: " + STRING(NOW, "99/99/9999 HH:MM:SS") SKIP
                    FILL("=",80)  SKIP(1) FILL("-",80) SKIP(1).

    FOR EACH ttAudReport:

        CASE ENTRY(1, ttAudReport.cType):

        /*************************************** EVENT SETTING *****************************************/
        WHEN "EVENT":U THEN DO:

            ASSIGN cWork = "".

            /* cFieldList has a list of the fields that are conflicting, so write info to the report */
            DO i = 1 TO NUM-ENTRIES(ttAudReport.cFieldList):

                ASSIGN cTemp = ENTRY(i,ttAudReport.cFieldList).

                IF cTemp = "" THEN NEXT.

                CASE cTemp:
                    WHEN "_Event-level" THEN cTemp = "event level".
                    WHEN "_Audit-data-security-level" THEN cTemp = "data security level".
                    WHEN "_Audit-custom-detail-level" THEN cTemp = "custom detail level".
                END CASE.

                IF cwork = "" THEN
                   cWork = "  - " + cTemp.
                ELSE
                    cWork = cWork + "~n  - " + cTemp.
            END.

            ASSIGN iEventID = INTEGER(ttAudReport.cId).

            /* get the info about the event */
            RUN get-audit-event-details IN hAuditCacheMgr (INPUT iEventID, OUTPUT cEvent-Info).

            CASE ttAudReport.level-1: /* level-1 is event-level for events */
                WHEN 0 THEN
                    cLevel1 = "Off".
                WHEN 1 THEN
                    cLevel1 = (IF iEventID < 10000 THEN "On" ELSE "Minimum").
               OTHERWISE
                   cLevel1 = "Full".
            END CASE.

            CASE ttAudReport.level-2: /* event-2 is data-sec-lvl for events */
                WHEN 0 THEN
                    cLevel2 = "No additional security".
                WHEN 1 THEN
                    cLevel2 = "Message Digest".
                WHEN 2 THEN
                    cLevel2 = "DB Passkey".
            END CASE.

            PUT UNFORMATTED "          ********************Audit Event Settings********************" SKIP(1)
                            "  Conflict(s) found for event " ttAudReport.cId " (" entry(1, cEvent-Info, chr(1)) ")" SKIP(1)
                            "  Multiple values found for the following setting(s): " SKIP cWork SKIP(1)
                            "  The levels below reflect the highest levels after resolving the conflict(s)." SKIP(1).

            PUT UNFORMATTED "  Effective event level          : " cLevel1 SKIP
                            "  Effective data security  level : " cLevel2 SKIP.

            /* custom detail doesn't apply to db events (id < 10000) */
            IF iEventID >= 10000 THEN  DO:
                ASSIGN cLevel3 = IF ttAudReport.level-3 = 0 THEN "Off" ELSE "On" /* event-3 is custom-detail-lvl for events */.

                PUT UNFORMATTED "  Effective custom detail  level : " cLevel3 SKIP.
            END.

            PUT UNFORMATTED "  Event id found in policies     : " ttAudReport.cPolicies SKIP(1).

            PUT UNFORMATTED SKIP FILL("-",80) SKIP(1).

        END. /* event */

        /*************************************** FIELD SETTING *****************************************/
        WHEN "FIELD":U THEN DO:

            CASE ttAudReport.level-1: /* level-1 is create-level for fields */
                WHEN -1 THEN
                    cLevel1 = "Off".
                WHEN 0 THEN
                    cLevel1 = "Use Table".
                WHEN 1 THEN
                    cLevel1 = "Minimum".
                WHEN 2 THEN
                    cLevel1 = "Standard (1 rec/fld)".
                WHEN 12 THEN
                    cLevel1 = "Standard".
            END CASE.

            CASE ttAudReport.level-2: /* level-2 is update-level for fields */
                WHEN -1 THEN
                    cLevel2 = "Off".
                WHEN 0 THEN
                    cLevel2 = "Use Table".
                WHEN 1 THEN
                    cLevel2 = "Minimum".
                WHEN 2 THEN
                    cLevel2 = "Standard (1 rec/fld)".
                WHEN 3 THEN
                    cLevel2 = "Full (1 rec/fld)".
                WHEN 12 THEN
                    cLevel2 = "Standard".
                WHEN 13 THEN
                    cLevel2 = "Full".
            END CASE.

            CASE ttAudReport.level-3: /* level-3 is delete-level for fields */
                WHEN -1 THEN
                    cLevel3 = "Off".
                WHEN 0 THEN
                    cLevel3 = "Use Table".
                WHEN 1 THEN
                    cLevel3 = "Minimum".
                WHEN 2 THEN
                    cLevel3 = "Standard (1 rec/fld)".
                WHEN 12 THEN
                    cLevel3 = "Standard".
            END CASE.

            ASSIGN cWork = "".

            /* cFieldList has a list of the fields that are conflicting, so write info to the report */
            DO i = 1 TO NUM-ENTRIES(ttAudReport.cFieldList):

                ASSIGN cTemp = ENTRY(i,ttAudReport.cFieldList).

                IF cTemp = "" THEN NEXT.

                CASE cTemp:
                    WHEN "_Audit-create-level" THEN cTemp = "create level".
                    WHEN "_Audit-update-level" THEN cTemp = "update level".
                    WHEN "_Audit-delete-level" THEN cTemp = "delete level".
                    WHEN "_Audit-identifying-field" THEN cTemp = "identifying".
                END CASE.

                IF cwork = "" THEN
                   cWork = "  - " + cTemp.
                ELSE
                   cWork = cWork + "~n  - " + cTemp.
            END.

            PUT UNFORMATTED '          ********************Audit Field Settings********************' SKIP(1)
                            '  Conflict(s) found for field "' ttAudReport.cId 
                            '", in table "' ENTRY(1,ttAudReport.cData) '", owner "' ENTRY(2,ttAudReport.cData) '"' SKIP(1)
                            '  Multiple values found for the following setting(s): ' SKIP cWork SKIP(1) 
                            '  The levels below reflect the highest levels after resolving the conflict(s).' SKIP(1).

            ASSIGN cWork = ttAudReport.cData.

            CASE INTEGER(ENTRY(3,cWork)): /* entry 3 is identifying ordinal position VALUE */
                WHEN {&MULTIPLE-VALUES} THEN
                    ident = {&MULTIPLE-VALUES-STR}.
                WHEN {&IDENTIFYING-CONFLICT} THEN
                    ident = {&IDENTIFYING-CONFLICT-STR}.
                OTHERWISE
                    ident = ENTRY(3,cWork).
            END CASE.

            PUT UNFORMATTED "  Effective create level         : "  cLevel1 SKIP
                            "  Effective update level         : "  cLevel2 SKIP
                            "  Effective delete level         : "  cLevel3 SKIP
                            "  Identifying ordinal position   : "  ident SKIP
                            "  Field found in policies        : "  ttAudReport.cPolicies SKIP(1).

            PUT UNFORMATTED SKIP FILL("-",80) SKIP(1).

        END. /* field */

        
        /*************************************** TABLE SETTING *****************************************/
        WHEN "TABLE":U THEN DO:

            CASE ttAudReport.level-1: /* level-1 is create-level for table */
                WHEN {&EVENT-OFF} THEN
                    cLevel1 = {&EVENT-OFF-STR}.
                WHEN 0 THEN
                    cLevel1 = "Off".
                WHEN 1 THEN
                    cLevel1 = "Minimum".
                WHEN 2 THEN
                    cLevel1 = "Standard (1 rec/fld)".
                WHEN 12 THEN
                    cLevel1 = "Standard".
            END CASE.

            CASE ttAudReport.level-2: /* level-2 is update-level for table */
                WHEN {&EVENT-OFF} THEN
                    cLevel2 = {&EVENT-OFF-STR}.
                WHEN 0 THEN
                    cLevel2 = "Off".
                WHEN 1 THEN
                    cLevel2 = "Minimum".
                WHEN 2 THEN
                    cLevel2 = "Standard (1 rec/fld)".
                WHEN 3 THEN
                    cLevel2 = "Full (1 rec/fld)".
                WHEN 12 THEN
                    cLevel2 = "Standard".
                WHEN 13 THEN
                    cLevel2 = "Full".
            END CASE.

            CASE ttAudReport.level-3: /* level-3 is delete-level for table */
                WHEN {&EVENT-OFF} THEN
                    cLevel3 = {&EVENT-OFF-STR}.
                WHEN 0 THEN
                    cLevel3 = "Off".
                WHEN 1 THEN
                    cLevel3 = "Minimum".
                WHEN 2 THEN
                    cLevel3 = "Standard (1 rec/fld)".
                WHEN 12 THEN
                    cLevel3 = "Standard".
            END CASE.

            ASSIGN cWork = "".

            /* cFieldList has a list of the fields that are conflicting, so write info to the report */
            DO i = 1 TO NUM-ENTRIES(ttAudReport.cFieldList):

                ASSIGN cTemp = ENTRY(i,ttAudReport.cFieldList).
                
                IF cTemp = "" THEN NEXT.

                CASE cTemp:
                    WHEN "_Audit-create-level" THEN cTemp = "create level".
                    WHEN "_Audit-update-level" THEN cTemp = "update level".
                    WHEN "_Audit-delete-level" THEN cTemp = "delete level".
                    WHEN "_create-event-id"    THEN cTemp = "create event id".
                    WHEN "_update-event-id"    THEN cTemp = "update event id".
                    WHEN "_delete-event-id"    THEN cTemp = "delete event id ".
                    WHEN "_Audit-data-security-level" THEN cTemp = "data security level".
                END CASE.

                IF cWork = "" THEN
                   cWork = "  - " + cTemp.
                ELSE
                   cWork = cWork + "~n  - " + cTemp.
            END.

            PUT UNFORMATTED '          ********************Audit Table Settings********************' SKIP(1)
                            '  Conflict(s) found for table "' ENTRY(1,ttAudReport.cID) '", owner "' ENTRY(2,ttAudReport.cID) '"' SKIP(1).

            IF cWork NE "" THEN
                PUT UNFORMATTED '  Multiple values found for the following setting(s): ' SKIP cWork SKIP(1).


            ASSIGN cWork = ttAudReport.cData.

            /* we may get a conflict if the same event id is defined for the create, update and delete id.
               This is really up to the user, but we will warn them in case they've made a mistake.
               the event ids are the three entries starting at the second entry in ttAudReport.cData.
            */
            IF INTEGER(ENTRY(2,cWork)) NE {&MULTIPLE-VALUES} AND ENTRY(2,cWork) = ENTRY(3,cWork) AND 
               ENTRY(3,cWork) = ENTRY(4,cWork) THEN
               PUT UNFORMATTED "  The same event id was defined as the create, update and delete event ids." SKIP.


            PUT UNFORMATTED '  The levels below reflect the highest levels after resolving the conflict(s).' SKIP(1).

            CASE INTEGER(ENTRY(1,cWork)): /* first entry is data-sec-lvl for table */
                WHEN 0 THEN
                    cSecLevel = "No additional security".
                WHEN 1 THEN
                    cSecLevel = "Message Digest".
                WHEN 2 THEN
                    cSecLevel = "DB Passkey".
            END CASE.


            ASSIGN iEventID = INTEGER(ENTRY(2,cWork)) /* create event id */
                   cEventID = IF iEventID = {&MULTIPLE-VALUES} THEN {&MULTIPLE-VALUES-STR} ELSE STRING(iEventID).

            PUT UNFORMATTED "  Effective create event id      : " cEventID  SKIP
                            "  Effective create level         : " cLevel1 SKIP.

            ASSIGN iEventID = INTEGER(ENTRY(3,cWork))/* update event id */
                   cEventID = IF iEventID = {&MULTIPLE-VALUES} THEN {&MULTIPLE-VALUES-STR} ELSE  STRING(iEventID).

            PUT UNFORMATTED "  Effective update event id      : " cEventID SKIP
                            "  Effective update level         : " cLevel2 SKIP.

            ASSIGN iEventID = INTEGER(ENTRY(4,cWork)) /* delete event id */
                   cEventID = IF iEventID = {&MULTIPLE-VALUES} THEN {&MULTIPLE-VALUES-STR} ELSE  STRING(iEventID).

            PUT UNFORMATTED "  Effective delete event id      : " cEventID SKIP
                            "  Effective delete level         : " cLevel3 SKIP
                            "  Effective data security  level : " cSecLevel SKIP
                            "  Table found in policies        : " ttAudReport.cPolicies SKIP(1).

            PUT UNFORMATTED SKIP FILL("-",80) SKIP(1).

        END. /* table */

        END CASE.

    END. /* FOR */

    PUT UNFORMATTED SKIP  "          *************************End*******************************" SKIP.

    OUTPUT CLOSE. /* close temp report file */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateMergeReport wWin 
PROCEDURE generateMergeReport :
/*------------------------------------------------------------------------------
  Purpose:     Generates a report based on the info stored in ttAudReport. The format
               of the data in the temp-table is defined by  _aud-conflict.p.
               
  Parameters:  OUTPUT cFileName - temp file name of report. Caller's responsible
                                  for removing file.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER cFileName AS CHARACTER NO-UNDO.

DEFINE VARIABLE cWork        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLevel1      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLevel2      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLevel3      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cEvent-info  AS CHARACTER NO-UNDO.
DEFINE VARIABLE iEventID     AS INTEGER   NO-UNDO.
DEFINE VARIABLE cEventID     AS CHARACTER NO-UNDO.
DEFINE VARIABLE severeConfl  AS LOGICAL   NO-UNDO INIT NO.
DEFINE VARIABLE ident        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSecLevel    AS CHARACTER NO-UNDO.

    RUN get-tmpfile-name ("" , ".tmp" , OUTPUT cFileName).

    /* open temp report file for writing */
    OUTPUT TO VALUE(cFileName).

    /* header info */
    PUT UNFORMATTED FILL(" ",14)  "OpenEdge Audit Policies: Effective Settings Report" SKIP
                    FILL(" ",24)  "Date/Time: " + STRING(NOW, "99/99/9999 HH:MM:SS") SKIP
                    FILL("=",80)  SKIP(1).

    /* check if there were severe conflicts which will cause unpredictable behavior */
    FOR EACH ttAudReport FIELDS (cData) NO-LOCK:
        IF LOOKUP(STRING({&MULTIPLE-VALUES}), ttAudReport.cData) > 0 OR 
            LOOKUP(STRING({&IDENTIFYING-CONFLICT}), ttAudReport.cData) > 0 THEN DO:

            ASSIGN severeConfl = YES. /* found one, it's enough */
            LEAVE.
        END.
        
    END.

    IF severeConfl THEN
        PUT UNFORMATTED SKIP(1)
                        "  ********************************************************************************" SKIP
                        "  *  ERROR: Severe conflicts were found which cause unpredictable behavior,      *" SKIP
                        "  *  such as multiple settings for the same event, table and/or field. Run the   *" SKIP
                        "  *  Report conflicts option to get additional information and make the necessary*" SKIP
                        "  *  changes to resolve the conflicts.                                           *" SKIP
                        "  ********************************************************************************" 
                        SKIP(2).


    PUT UNFORMATTED "  NOTE: For any given table-level setting, fields that were not explicitly defined" SKIP
                    "        will not be listed in this report. Each field not listed will inherit the" SKIP
                    "        audit create, delete and update levels defined of the table." SKIP(1).

    FOR EACH ttAudReport NO-LOCK:

        CASE ENTRY(1, ttAudReport.cType):

        /*************************************** EVENT SETTING *****************************************/
        WHEN "EVENT":U THEN DO:

            ASSIGN iEventID = INTEGER(ttAudReport.cId).

            /* get the info about the event */
            RUN get-audit-event-details IN hAuditCacheMgr (INPUT iEventID, OUTPUT cEvent-Info).

            CASE ttAudReport.level-1: /* level-1 is event-level for events */
                WHEN 0 THEN
                    cLevel1 = "Off".
                WHEN 1 THEN
                    cLevel1 = (IF iEventID < 10000 THEN "On" ELSE "Minimum").
               OTHERWISE
                   cLevel1 = "Full".
            END CASE.

            CASE ttAudReport.level-2: /* event-2 is data-sec-lvl for events */
                WHEN 0 THEN
                    cLevel2 = "No additional security".
                WHEN 1 THEN
                    cLevel2 = "Message Digest".
                WHEN 2 THEN
                    cLevel2 = "DB Passkey".
            END CASE.

            PUT UNFORMATTED SKIP FILL("-",80) SKIP(1)
                            "          ********************Summary Information********************" SKIP(1)
                            "  Settings for event id " ttAudReport.cId ", name ~"" entry(1, cEvent-Info, chr(1)) "~", type ~"" entry(2, cEvent-Info, chr(1)) "~" " SKIP 
                            "  found in ".

            cWork = IF NUM-ENTRIES(ttAudReport.cPolicies) = 1 THEN "policy" ELSE "policies".

            PUT UNFORMATTED cWork  " ~"" ttAudReport.cPolicies "~"" SKIP(1).

            PUT UNFORMATTED "          ********************Event Details********************" SKIP(1)
                            "  Description                    : " ENTRY(3, cEvent-Info, CHR(1)) SKIP
                            "  Effective event level          : " cLevel1 SKIP
                            "  Effective data security  level : " cLevel2 SKIP.

            /* custom detail doesn't apply to db events (id < 10000) */
            IF iEventID >= 10000 THEN DO:
            
                ASSIGN cLevel3 = IF ttAudReport.level-3 = 0 THEN "Off" ELSE "On" /* event-3 is custom-detail-lvl for events */.

                PUT UNFORMATTED "  Effective custom detail  level : " cLevel3.
            END.
            
            PUT UNFORMATTED SKIP(1).

        END. /* event */

        /*************************************** FIELD SETTING *****************************************/
        WHEN "FIELD":U THEN DO:

            CASE ttAudReport.level-1: /* level-1 is create-level for fields */
                WHEN {&FIELD-SETTING-IGNORED} THEN
                    cLevel1 = {&FIELD-IGNORED-STR}.
                WHEN -1 THEN
                    cLevel1 = "Off".
                WHEN 0 THEN
                    cLevel1 = "Use Table".
                WHEN 1 THEN
                    cLevel1 = "Minimum".
                WHEN 2 THEN
                    cLevel1 = "Standard (1 rec/fld)".
                WHEN 12 THEN
                    cLevel1 = "Standard".
            END CASE.

            CASE ttAudReport.level-2: /* level-2 is update-level for fields */
                WHEN {&FIELD-SETTING-IGNORED} THEN
                    cLevel2 = {&FIELD-IGNORED-STR}.
                WHEN -1 THEN
                    cLevel2 = "Off".
                WHEN 0 THEN
                    cLevel2 = "Use Table".
                WHEN 1 THEN
                    cLevel2 = "Minimum".
                WHEN 2 THEN
                    cLevel2 = "Standard (1 rec/fld)".
                WHEN 3 THEN
                    cLevel2 = "Full (1 rec/fld)".
                WHEN 12 THEN
                    cLevel2 = "Standard".
                WHEN 13 THEN
                    cLevel2 = "Full".
            END CASE.

            CASE ttAudReport.level-3: /* level-3 is delete-level for fields */
                WHEN {&FIELD-SETTING-IGNORED} THEN
                    cLevel3 = {&FIELD-IGNORED-STR}.
                WHEN -1 THEN
                    cLevel3 = "Off".
                WHEN 0 THEN
                    cLevel3 = "Use Table".
                WHEN 1 THEN
                    cLevel3 = "Minimum".
                WHEN 2 THEN
                    cLevel3 = "Standard (1 rec/fld)".
                WHEN 12 THEN
                    cLevel3 = "Standard".
            END CASE.

            PUT UNFORMATTED SKIP(1) "          **********************Field Settings**********************" SKIP(1)
                            '  Settings for field "' ttAudReport.cId  '" in table "' ENTRY(1,ttAudReport.cData) '" (owner "' ENTRY(2,ttAudReport.cData) '")' SKIP
                            '  found in '.

            cWork = IF NUM-ENTRIES(ttAudReport.cPolicies) = 1 THEN "policy" ELSE "policies".
    
            PUT UNFORMATTED cWork  " ~"" ttAudReport.cPolicies "~"" SKIP(1).

            ASSIGN cWork = ttAudReport.cData.

            CASE INTEGER(ENTRY(3,cWork)): /* entry 3 is identifying ordinal position value */
                WHEN {&MULTIPLE-VALUES} THEN
                    ASSIGN severeConfl = YES 
                           ident = {&MULTIPLE-VALUES-STR}.
                WHEN {&IDENTIFYING-CONFLICT} THEN
                    ASSIGN severeConfl = YES 
                           ident = {&IDENTIFYING-CONFLICT-STR}.
                OTHERWISE
                    ident = ENTRY(3,cWork).
            END CASE.

            PUT UNFORMATTED "  Effective create level         : "  cLevel1 SKIP
                            "  Effective update level         : "  cLevel2 SKIP
                            "  Effective delete level         : "  cLevel3 SKIP
                            "  Identifying ordinal position   : "  ident SKIP(1).

        END. /* field */

        
        /*************************************** TABLE SETTING *****************************************/
        WHEN "TABLE":U THEN DO:

            CASE ttAudReport.level-1: /* level-1 is create-level for table */
                WHEN {&EVENT-OFF} THEN
                    cLevel1 = {&EVENT-OFF-STR}.
                WHEN 0 THEN
                    cLevel1 = "Off".
                WHEN 1 THEN
                    cLevel1 = "Minimum".
                WHEN 2 THEN
                    cLevel1 = "Standard (1 rec/fld)".
                WHEN 12 THEN
                    cLevel1 = "Standard".
            END CASE.

            CASE ttAudReport.level-2: /* level-2 is update-level for table */
                WHEN {&EVENT-OFF} THEN
                    cLevel2 = {&EVENT-OFF-STR}.
                WHEN 0 THEN
                    cLevel2 = "Off".
                WHEN 1 THEN
                    cLevel2 = "Minimum".
                WHEN 2 THEN
                    cLevel2 = "Standard (1 rec/fld)".
                WHEN 3 THEN
                    cLevel2 = "Full (1 rec/fld)".
                WHEN 12 THEN
                    cLevel2 = "Standard".
                WHEN 13 THEN
                    cLevel2 = "Full".
            END CASE.

            CASE ttAudReport.level-3: /* level-3 is delete-level for table */
                WHEN {&EVENT-OFF} THEN
                    cLevel3 = {&EVENT-OFF-STR}.
                WHEN 0 THEN
                    cLevel3 = "Off".
                WHEN 1 THEN
                    cLevel3 = "Minimum".
                WHEN 2 THEN
                    cLevel3 = "Standard (1 rec/fld)".
                WHEN 12 THEN
                    cLevel3 = "Standard".
            END CASE.

            PUT UNFORMATTED SKIP FILL("-",80) SKIP(1)
                            "          ********************Summary Information********************" SKIP(1)
                            '  Settings for table "' ENTRY(1,ttAudReport.cID) '" (owner "' ENTRY(2,ttAudReport.cID) '") found in'  SKIP.

            cWork = IF NUM-ENTRIES(ttAudReport.cPolicies) = 1 THEN "  policy" ELSE "  policies".
    
            PUT UNFORMATTED cWork  " ~"" ttAudReport.cPolicies "~"" SKIP(1).

            ASSIGN cWork = ttAudReport.cData.

            /* we may get a conflict if the same event id is defined for the create, update and delete id.
               This is really up to the user, but we will warn them in case they've made a mistake.
               the event ids are the three entries starting at the second entry in ttAudReport.cData.
            */
            IF INTEGER(ENTRY(2,cWork)) NE {&MULTIPLE-VALUES} AND ENTRY(2,cWork) = ENTRY(3,cWork) AND 
               ENTRY(3,cWork) = ENTRY(4,cWork) THEN
               PUT UNFORMATTED "  WARNING: The same event id is defined as the create,update and delete event ids" SKIP(1).


            CASE INTEGER(ENTRY(1,cWork)): /* first entry is data-sec-lvl for table */
                WHEN 0 THEN
                    cSecLevel = "No additional security".
                WHEN 1 THEN
                    cSecLevel = "Message Digest".
                WHEN 2 THEN
                    cSecLevel = "DB Passkey".
            END CASE.


            ASSIGN iEventID = INTEGER(ENTRY(2,cWork)) /* create event id */
                   cEventID = IF iEventID = {&MULTIPLE-VALUES} THEN {&MULTIPLE-VALUES-STR} ELSE STRING(iEventID).

            IF iEventID = {&MULTIPLE-VALUES} THEN
               ASSIGN severeConfl = YES.

            PUT UNFORMATTED "          ********************Table Settings Details********************" SKIP(1)
                            "  Effective create event id      : " cEventID  SKIP
                            "  Effective create level         : " cLevel1 SKIP.

            ASSIGN iEventID = INTEGER(ENTRY(3,cWork))/* update event id */
                   cEventID = IF iEventID = {&MULTIPLE-VALUES} THEN {&MULTIPLE-VALUES-STR} ELSE  STRING(iEventID).

            IF iEventID = {&MULTIPLE-VALUES} THEN
               ASSIGN severeConfl = YES.

            PUT UNFORMATTED "  Effective update event id      : " cEventID SKIP
                            "  Effective update level         : " cLevel2 SKIP.

            ASSIGN iEventID = INTEGER(ENTRY(4,cWork)) /* delete event id */
                   cEventID = IF iEventID = {&MULTIPLE-VALUES} THEN {&MULTIPLE-VALUES-STR} ELSE  STRING(iEventID).

            IF iEventID = {&MULTIPLE-VALUES} THEN
               ASSIGN severeConfl = YES.

            PUT UNFORMATTED "  Effective delete event id      : " cEventID SKIP
                            "  Effective delete level         : " cLevel3 SKIP
                            "  Effective data security  level : " cSecLevel SKIP(1).
        END.

        END CASE.

    END. /* FOR */

    PUT UNFORMATTED SKIP FILL("-",80) SKIP(1).

    PUT UNFORMATTED SKIP  "          *************************End*******************************" SKIP.

    OUTPUT CLOSE. /* close temp report file */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-tmpfile-name wWin 
PROCEDURE get-tmpfile-name :
/*------------------------------------------------------------------------------
  Purpose:    Creates an available temp file name. The name is a complete
              name that includes the path. 
              
  Parameters:  input user_chars:   Characters that can be used to distinguish a temp
                                   file from another temp file in the same application.
                                   
               input extension:    The file extension that is to be added to the file,
                                   including the "."
                                   
               output  name:       The name of the file

  Notes:       
------------------------------------------------------------------------------*/

DEFINE input  PARAMETER user_chars AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER extension  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER name       AS CHARACTER NO-UNDO.
 
DEFINE VARIABLE base           AS INTEGER.
define VARIABLE check_name     AS CHARACTER.
 
/*
 * Loop until we find a name that hasn't been used. In theory, if the
 * temp directory gets filled, this could be an infinite loop. But, the
 * likelihood of that is low.
 */
check_name = "r".
 
do while check_name <> ?:
  /* Take the lowest 5 digits (change the format so that everything works out to have exactly 5
     characters. */
  ASSIGN
    base = ( TIME * 1000 + ETIME ) MODULO 100000
    name = STRING(base,"99999":U).
  
  /* Add in the extension and directory into the name. */
  name = SESSION:TEMP-DIR + "p" + name + user_chars + extension.
 
  check_name = SEARCH(name).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getWorkingAuditDbInfo wWin 
PROCEDURE getWorkingAuditDbInfo :
/*------------------------------------------------------------------------------
  Purpose:     Gets the info for the working db, which we got from the 
                  aud utils procedure when we got the list of databases.
  Parameters:  pcDbInfo - string with db info
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcDbInfo AS CHARACTER.

DEFINE VARIABLE cDetails AS CHARACTER NO-UNDO.
DEFINE VARIABLE i        AS INTEGER   NO-UNDO.

    /* make sure we have a db selected */
    IF iCurrentdatabase = 0 THEN DO:
        ASSIGN pcDbInfo = "".
        RETURN.
    END.

    /* get current working database. This gets sets in the combo-box's value-changed
       trigger 
    */
    FIND FIRST workDb WHERE workDb.id = iCurrentdatabase NO-ERROR.
    IF AVAILABLE workDB THEN
        ASSIGN pcDbInfo = workDb.dbInfo.
    ELSE
        ASSIGN pcDbInfo = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

   ASSIGN initializing = YES. /* remember we are initializing */

  /* check if we need to connect to an AppServer. We handle the partition
     name ourselves. If the partition is not set for this session, 
     connectAppServer simply ignores it.
  */
  RUN connectAppServer IN hAuditCacheMgr ({&APMT_PARTITION_NAME}).

  /* set this procedure's handle */
  RUN setCallerHandle IN hAuditCacheMgr (INPUT THIS-PROCEDURE).
  
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  /* Let's populate the combo-box with the databases available */
  RUN buildDatabaseCombo.

  /* move focus to the combo-box */
  DO WITH FRAME {&FRAME-NAME}:
      ENABLE coDatabase.
      APPLY "entry":U TO coDatabase.
  END.

  /* subscribe to this event - procedures publish this event when they
     want to get the working audit database information
  */
  SUBSCRIBE "getWorkingAuditDbInfo":U ANYWHERE.

  /* enable the menu options accordingly */
  RUN enable-menu-items-startup.

  /* disable commit/undo changes at startup */
  RUN set-commit-options(NO).

  /* subscribe to some sdo's events so we catch when a change is made */
  RUN doSubscribes.

  ASSIGN initializing = NO. /* remember we are initializing */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE notifyPage wWin 
PROCEDURE notifyPage :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       Suppress warning messages that occur when initializing object
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcProc AS CHARACTER NO-UNDO.

  DEFINE VARIABLE supp_warn AS LOGICAL NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  IF pcProc = "initializeObject":U THEN DO:
      /* remember if session parameter is set */
      supp_warn = SESSION:SUPPRESS-WARNINGS.
      /* suppress warnings for now */
      IF NOT supp_warn THEN
         SESSION:SUPPRESS-WARNINGS = YES.
  END.

  RUN SUPER( INPUT pcProc).

  /* restore warnings setting if appropriate */
  IF pcProc = "initializeObject":U AND NOT supp_warn THEN
     SESSION:SUPPRESS-WARNINGS = NO.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE queryPosition wWin 
PROCEDURE queryPosition :
/*------------------------------------------------------------------------------
  Purpose:     Check if there are no records available. We subscribe to the
               policy sdo's event.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.

  /* if no policy available, disable the options related to policies */
  IF pcState BEGINS 'NoRecordAvail':U THEN
      RUN refresh-policy-menu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresh-admin-util wWin 
PROCEDURE refresh-admin-util :
/*------------------------------------------------------------------------------
  Purpose:     Called when we connect or disconnect a database to make sure
               we get the Data Admin tool refreshed if it's open and active, 
               to add or get rid of databases connected or disconnected.
               
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE h      AS HANDLE  NO-UNDO.
DEFINE VARIABLE hproc  AS HANDLE  NO-UNDO.

    /* only need to do this if the Data Admin is active - can't call
       enable_widgets otherwise, or it will have the widgets enabled
       even though something else called from it is active at this moment
    */
    IF PROGRAM-NAME(4) = "prodict/_dictc.p" THEN DO:
        /* let's go through all of the windows in the session and see if we can
           find the data admin tool
        */
        h = SESSION:FIRST-CHILD.
    
        DO  WHILE VALID-HANDLE(h).
    
            IF VALID-HANDLE(h) and h:TYPE = "WINDOW" THEN DO:
    
                hproc = h:INSTANTIATING-PROCEDURE.
    
                IF VALID-HANDLE(hproc) THEN DO:
                   IF hproc:NAME = "prodict/_dictc.p" THEN 
                   DO:
                       RUN ENABLE_widgets IN hproc.
                       LEAVE.
                   END.
                END.
            END.
            h = h:NEXT-SIBLING.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresh-policy-menu wWin 
PROCEDURE refresh-policy-menu :
/*------------------------------------------------------------------------------
  Purpose:    Enable/disable the options in the Policy menu 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE i          AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE isReadOnly AS LOGICAL NO-UNDO INITIAL NO.

    /* if no db, don't enable stuff */
    IF coDatabase:INPUT-VALUE IN FRAME {&FRAME-NAME} <> 0 THEN DO:
       /* check if this is a read-only db */
       ASSIGN isReadOnly = isCurrentDbReadOnly().
    
       /* check how many policies there are in the working db */
       i = DYNAMIC-FUNCTION('getLastRowNum':U IN h_audpolicysdo). 

       IF NOT changesPending THEN
          DYNAMIC-FUNCTION( 'enableActions':U IN h_dyntoolbar, 'AuditRefreshPolicies':U).
    END.
    ELSE DO:
        /* make sure refresh policies is disabled */
          DYNAMIC-FUNCTION( 'disableActions':U IN h_dyntoolbar, 'AuditRefreshPolicies':U).
    END.


    /* there is at least one policy, then enable the following options */
    IF i > 0 THEN DO:
        DYNAMIC-FUNCTION( 'enableActions':U IN h_dyntoolbar, 
                          "AuditRepconflict,AuditExportPolicy,AuditRepMerge":U).

        /* these options should only be available if db is updatable */
        IF NOT isReadOnly THEN
           DYNAMIC-FUNCTION( 'enableActions':U IN h_dyntoolbar, 
                              "AuditActivatePolicy,AuditDeactivatePolicy":U).
        ELSE
            DYNAMIC-FUNCTION( 'disableActions':U IN h_dyntoolbar, 
                               "AuditActivatePolicy,AuditDeactivatePolicy":U).
   END.
   ELSE DO:
       /* no policies, disable the following options */
       DYNAMIC-FUNCTION( 'disableActions':U IN h_dyntoolbar, 
                         "AuditActivatePolicy,AuditDeactivatePolicy,AuditRepConflict,AuditRepMerge,AuditExportPolicy":U).
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reopen-queries wWin 
PROCEDURE reopen-queries :
/*------------------------------------------------------------------------------
  Purpose:     Reopen the queries on all sdos. We call this when the user selects
               undo changes, so we display the data as it was before the user
               started to make changes.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
   IF VALID-HANDLE(h_audpolicysdo) THEN DO:
      DYNAMIC-FUNCTION('openQuery':U IN h_audpolicysdo) NO-ERROR.
   END.
   
   IF VALID-HANDLE(h_audfilepolicysdo) THEN DO:
      DYNAMIC-FUNCTION('openQuery':U IN h_audfilepolicysdo) NO-ERROR.
   END.

   IF VALID-HANDLE(h_audfieldpolicysdo) THEN DO:
      DYNAMIC-FUNCTION('openQuery':U IN h_audfieldpolicysdo) NO-ERROR.
   END.

   IF VALID-HANDLE(h_audevpolicysdo) THEN DO:
      DYNAMIC-FUNCTION('openQuery':U IN h_audevpolicysdo) NO-ERROR.
   END.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectPage wWin 
PROCEDURE selectPage :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER piPageNum AS INTEGER NO-UNDO.

  DEFINE VARIABLE supp_warn AS LOGICAL NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* remember if session parameter is set */
  supp_warn = SESSION:SUPPRESS-WARNINGS.
  /* suppress warnings for now */
  IF NOT supp_warn THEN
     SESSION:SUPPRESS-WARNINGS = YES.

  IF piPageNum <> 3 THEN
     ASSIGN fill-warning:VISIBLE IN FRAME {&FRAME-NAME} = NO.

  RUN SUPER( INPUT piPageNum).

  /* Code placed here will execute AFTER standard behavior.    */

  IF piPageNum = 3 THEN
     ASSIGN fill-warning:VISIBLE IN FRAME {&FRAME-NAME} = YES.

  /* restore warnings setting if appropriate */
  IF NOT supp_warn THEN
     SESSION:SUPPRESS-WARNINGS = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-commit-options wWin 
PROCEDURE set-commit-options :
/*------------------------------------------------------------------------------
  Purpose:     Enable/disable commit/undo changes options 
  Parameters:  isSensitive - set to YES to enable options, or NO to disable them.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER isSensitive AS LOGICAL  NO-UNDO.

    IF isSensitive THEN DO: /* enable options */
    
        DYNAMIC-FUNCTION( 'enableActions':U IN h_dyntoolbar, 
                          "AuditCommitChanges,AuditUndoChanges":U).

        /* can't refresh while changes are pending */
        DYNAMIC-FUNCTION( 'disableActions':U IN h_dyntoolbar, 'AuditRefreshPolicies':U).
    END.
    ELSE DO: /* disable options */

        DYNAMIC-FUNCTION( 'disableActions':U IN h_dyntoolbar, 
                          "AuditCommitChanges,AuditUndoChanges":U).

        /* if no db available, don't enable it */
        IF coDatabase:INPUT-VALUE IN FRAME {&FRAME-NAME} <> 0 THEN
           /* restore the refresh option under the Policy menu */
           DYNAMIC-FUNCTION( 'enableActions':U IN h_dyntoolbar, 'AuditRefreshPolicies':U).
    END.

    /* also, set this so we know if there are changes pending */
    ASSIGN changesPending = isSensitive.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setcursor wWin 
PROCEDURE setcursor :
/*------------------------------------------------------------------------------
  Purpose:     Sets the cursor on all windows and on any dialog box frames that are
               currently on the screen.
 
  Parameters:  INPUT  p_cursor - name of cursor to use.  This should be either
                                 "WAIT" or "".
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p_cursor  AS CHAR           NO-UNDO.
 
DEFINE VAR ldummy AS LOGICAL NO-UNDO.

 /* Set the Wait state, which changes the cursor automatically */
 ldummy = SESSION:SET-WAIT-STATE(IF p_cursor = "WAIT":U THEN "GENERAL":U 
                                                      ELSE "").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE update-disable wWin 
PROCEDURE update-disable :
/*------------------------------------------------------------------------------
  Purpose:     Remove all the Update and TableIO links so user can't update
               the policies. Also, disable the options in the toolbar. This
               gets called when db is read-only (or no db is available).
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE (h_audpolicyviewv) THEN DO:
        RUN removeLink ( h_dyntoolbar, 'Tableio':U, h_audpolicyviewv ).
        RUN removeLink ( h_audpolicyviewv, 'Update':U, h_audpolicysdo).
        RUN disableFields IN h_audpolicyviewv('All':U).
    END.
    
    IF VALID-HANDLE (h_audfilepolicyviewv ) THEN DO:
        RUN removeLink ( h_dyntoolbar, 'Tableio':U, h_audfilepolicyviewv ).
        RUN removeLink ( h_audfilepolicyviewv, 'Update':U, h_audfilepolicysdo).
        RUN disableFields IN h_audfilepolicyviewv('All':U).
    END.
    
    IF VALID-HANDLE (h_audfieldpolicyviewv) THEN DO:
        RUN removeLink ( h_dyntoolbar, 'Tableio':U, h_audfieldpolicyviewv).
        RUN removeLink ( h_audfieldpolicyviewv, 'Update':U, h_audfieldpolicysdo).
        RUN disableFields IN h_audfieldpolicyviewv('All':U).
    END.
    
    IF VALID-HANDLE (h_audevpolicyviewv) THEN DO:
        RUN removeLink ( h_dyntoolbar, 'Tableio':U, h_audevpolicyviewv ).
        RUN removeLink ( h_audevpolicyviewv, 'Update':U, h_audevpolicysdo).
        RUN disableFields IN h_audevpolicyviewv('All':U).
    END.
    
    DYNAMIC-FUNCTION('disableActions':U IN h_dyntoolbar,"add,copy,delete,save":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE update-enable wWin 
PROCEDURE update-enable :
/*------------------------------------------------------------------------------
  Purpose:    Enable the Update and TableIO links so user can update policies. 
              Also, enable the options in the toolbar.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR cLinks AS CHARACTER NO-UNDO.

    DYNAMIC-FUNCTION("enableActions":U IN h_dyntoolbar, 
                     "add,copy,delete,save":U).
    
    IF VALID-HANDLE (h_audpolicyviewv ) THEN DO:
        /* don't add it if it's already linked */
        cLinks = DYNAMIC-FUNC("getUpdateTarget":U IN h_audpolicyviewv ).
        IF cLinks = "":U OR cLinks = ? THEN DO:
            RUN addLink ( h_audpolicyviewv , 'Update':U , h_audpolicysdo ).
            RUN addLink ( h_dyntoolbar , 'Tableio':U , h_audpolicyviewv ).
            RUN enableFields IN h_audpolicyviewv.
        END.
    END.
    
    IF VALID-HANDLE (h_audfilepolicyviewv) THEN DO:
        /* don't add it if it's already linked */
        cLinks = DYNAMIC-FUNC("getUpdateTarget":U IN h_audfilepolicyviewv ).
        IF cLinks = "":U OR cLinks = ? THEN DO:
           RUN addLink ( h_audfilepolicyviewv , 'Update':U , h_audfilepolicysdo ).
           RUN addLink ( h_dyntoolbar , 'Tableio':U , h_audfilepolicyviewv ).
           RUN enableFields IN h_audfilepolicyviewv.
        END.
    END.
    
    IF VALID-HANDLE (h_audfieldpolicyviewv) THEN DO:
        /* don't add it if it's already linked */
        cLinks = DYNAMIC-FUNC("getUpdateTarget":U IN h_audfieldpolicyviewv ).
        IF cLinks = "":U OR cLinks = ? THEN DO:
            RUN addLink ( h_audfieldpolicyviewv , 'Update':U , h_audfieldpolicysdo ).
            RUN addLink ( h_dyntoolbar , 'Tableio':U , h_audfieldpolicyviewv ).
            RUN enableFields IN h_audfieldpolicyviewv.
        END.
    END.
    
    IF VALID-HANDLE (h_audevpolicyviewv) THEN DO:
        /* don't add it if it's already linked */
        cLinks = DYNAMIC-FUNC("getUpdateTarget":U IN h_audevpolicyviewv ).
        IF cLinks = "":U OR cLinks = ? THEN DO:
            RUN addLink ( h_audevpolicyviewv , 'Update':U , h_audevpolicysdo ).
            RUN addLink ( h_dyntoolbar , 'Tableio':U , h_audevpolicyviewv ).
            RUN enableFields IN h_audevpolicyviewv.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState wWin 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       We subscribe to the sdo's updateState event,
               so we know when an update is completed, so we can enable
               the commit/undo changes options.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lMod         AS LOGICAL NO-UNDO.
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.
  DEFINE VARIABLE i            AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  IF pcState = "updateComplete":U OR pcState = "updateEnd":U THEN DO:
      /* a change was made, enable the commit/undo options */
     RUN checkDataModified.
     
     REPEAT i = 1 TO 4:
         /* enable all other pages when update has ended */
         IF currentPage <> i THEN 
            RUN enableFolderPage IN h_folder (i).
     END.

  END.
  ELSE DO:

      REPEAT i = 1 TO 4:
          /* disable all other pages when update has started */
          IF currentPage <> i THEN 
             RUN disableFolderPage IN h_folder (i).
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAppService wWin 
FUNCTION getAppService RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returnsa the partition name used by the APMT tool, so caller 
            knows how to get to the AppServer, when appropriate.
    Notes: 
------------------------------------------------------------------------------*/

  RETURN {&APMT_PARTITION_NAME}. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDBGuid wWin 
FUNCTION getDBGuid RETURNS CHARACTER
  ( pcldbname AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the db guid for a db - must be connected to this session
    Notes:  If can't get it, returns ?
------------------------------------------------------------------------------*/

DEFINE VARIABLE hBuffer AS HANDLE    NO-UNDO.
DEFINE VARIABLE cGUID   AS CHARACTER NO-UNDO INITIAL ?.

    /* if webclient is running, we won't have any db connected locally, so just return */
    IF {&NOT-WEBCLIENT} THEN DO:

        /* create a buffer for the _Db table and try to get the current db guid value */
        CREATE BUFFER hBuffer FOR TABLE pcldbname + "._Db" NO-ERROR.
        
        IF NOT VALID-HANDLE(hBuffer) THEN
            RETURN ?.
        
        hBuffer:FIND-FIRST(" where true", NO-LOCK) NO-ERROR.
        IF hBuffer:AVAILABLE THEN
           ASSIGN cGuid = hBuffer::_Db-Guid.
        
        DELETE OBJECT hBuffer.
    
    END.

    RETURN cGuid.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasMultipleSelected wWin 
FUNCTION hasMultipleSelected RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns if the browse in the current tab has more
            than one row selected
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE currentPage  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cList        AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE lRet         AS LOGICAL   NO-UNDO INIT FALSE.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage:
      WHEN 1 THEN DO:
          IF VALID-HANDLE(h_audpolicybrowb) THEN DO:
             RUN getSelectedPolicies IN h_audpolicybrowb (OUTPUT cList).
             IF NUM-ENTRIES(cList) > 1 THEN
                ASSIGN lRet = TRUE.
          END.
      END.
      WHEN 2 THEN DO:
          IF VALID-HANDLE(h_audfilepolicybrowb) THEN
              lRet = DYNAMIC-FUNCTION('hasMultipleSelected':U IN h_audfilepolicybrowb) NO-ERROR.
      END.
      WHEN 3 THEN DO:
          IF VALID-HANDLE(h_audfieldpolicybrowb) THEN
             lRet = DYNAMIC-FUNCTION('hasMultipleSelected':U IN h_audfieldpolicybrowb) NO-ERROR.
      END.
      WHEN 4 THEN DO:
          IF VALID-HANDLE(h_audevpolicybrowb) THEN
             lRet = DYNAMIC-FUNCTION('hasMultipleSelected':U IN h_audevpolicybrowb) NO-ERROR.
      END.

  END CASE.

  RETURN lRet. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isCurrentDbReadOnly wWin 
FUNCTION isCurrentDbReadOnly RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Check if working db is read-only. Check the dbinfo in the record
            with the current db id.
    Notes:  
------------------------------------------------------------------------------*/

  FIND FIRST workDB WHERE id = iCurrentdatabase NO-ERROR.

  IF AVAILABLE workDb THEN DO:
      IF DYNAMIC-FUNCTION('has-DB-option' IN  hAuditCacheMgr,workdb.dbInfo, {&DB-READ-ONLY}) THEN
         RETURN TRUE.
  END.

  RETURN FALSE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isReadOnlyDb wWin 
FUNCTION isReadOnlyDb RETURNS LOGICAL
  ( pId AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Check if db is read-only. Check the dbinfo in the record
            with the id passed in.
    Notes:  
------------------------------------------------------------------------------*/

  FIND FIRST workDB WHERE id = pId NO-ERROR.

  IF AVAILABLE workDb THEN DO:
      IF DYNAMIC-FUNCTION('has-DB-option' IN  hAuditCacheMgr,workdb.dbInfo, {&DB-READ-ONLY}) THEN
         RETURN TRUE.
  END.

  RETURN FALSE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

