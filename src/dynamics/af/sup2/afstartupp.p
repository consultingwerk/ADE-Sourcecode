&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afstartupp.p

  Description:  Client Application Start-up Procedure

  Purpose:      Client Application Start-up Procedure.
                This procedure is used to launch the ICF application environment and run
                the first program, as specified in the input parameters.
                If no program to specified, then the plips will just be started in the
                session - used for the development environment.

  Parameters:   input name of login window to run.
                input name of 1st program to run (or blank if just in dev mode) (comma run
                attribute if required).
                input quit flag YES/NO (YES if run from desktop,NO if from Appbuilder)
                input client log filename to check for library upload (blank if not required)
                input connect to ICF Appserver Partition flag YES/NO

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   30/05/2000  Author:     Anthony Swindells

  Update Notes: Write ICF Environment

  (v:010001)    Task:        5958   UserRef:    
                Date:   08/06/2000  Author:     Anthony Swindells

  Update Notes: add user email as standard property

  (v:010002)    Task:        5933   UserRef:    
                Date:   12/06/2000  Author:     Anthony Swindells

  Update Notes: Write ICF Profile Manager and Translation Manager / update supporting
                files

  (v:010003)    Task:        6010   UserRef:    
                Date:   13/06/2000  Author:     Anthony Swindells

  Update Notes: ICF Login Window

  (v:010004)    Task:        6065   UserRef:    
                Date:   19/06/2000  Author:     Anthony Swindells

  Update Notes: Integrate Astra1 & ICF

  (v:010005)    Task:        6145   UserRef:    
                Date:   28/06/2000  Author:     Anthony Swindells

  Update Notes: Code container toolbar actions

  (v:010006)    Task:        6488   UserRef:    
                Date:   16/08/2000  Author:     Anthony Swindells

  Update Notes: Fix appservice for workspace name

  (v:010008)    Task:        6574   UserRef:    
                Date:   01/09/2000  Author:     Johan Meyer

  Update Notes: Add gsfin and gsgen procedures

  (v:010011)    Task:        7704   UserRef:    
                Date:   24/01/2001  Author:     Peter Judge

  Update Notes: AF2/ Add new AstraGen Manager

-------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afstartupp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010005


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE INPUT PARAMETER  pcLoginWindow               AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcRunWindow                 AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plQuit                      AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER  pcClientLogFile             AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plAppserverConnect          AS LOGICAL    NO-UNDO.

/* create alias's if required */
IF CONNECTED("ICFDB":U) THEN
DO:
  CREATE ALIAS AFDB           FOR DATABASE VALUE("ICFDB":U).
  CREATE ALIAS ASDB           FOR DATABASE VALUE("ICFDB":U).
  CREATE ALIAS RYDB           FOR DATABASE VALUE("ICFDB":U).
  CREATE ALIAS db_metaschema  FOR DATABASE VALUE("ICFDB":U).
  CREATE ALIAS db_index       FOR DATABASE VALUE("ICFDB":U).
END.

/* pull in Astra global variables as new global */
{af/sup2/afglobals.i NEW GLOBAL}
/* Include the file which defines AppServerConnect procedures. */
{adecomm/appserv.i}

DEFINE VARIABLE glOK                        AS LOGICAL            NO-UNDO.
DEFINE VARIABLE gcFileName                  AS CHARACTER          NO-UNDO.

/* &IF "{&scmTool}" = "RTB":U */
/* Define RTB global shared variables - used for RTB integration hooks (if installed) */
DEFINE NEW GLOBAL SHARED VARIABLE grtb-wsroot       AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-wspace-id    AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-task-num     AS INTEGER      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-propath      AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-userid       AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-access       AS CHARACTER    NO-UNDO.

/* Variables for Appserver connection */                            
DEFINE VARIABLE cAppService                         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lASUsePrompt                        AS LOGICAL      NO-UNDO.
DEFINE VARIABLE cASInfo                             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cAsDivision                         AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cRunWindow                          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cPhysicalName                       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cLogicalName                        AS CHARACTER    NO-UNDO.

/* run login window to authenticate user */
DEFINE VARIABLE lCacheTranslations                  AS LOGICAL      NO-UNDO INITIAL YES.
DEFINE VARIABLE rRowid                              AS ROWID        NO-UNDO.
DEFINE VARIABLE dCurrentUserObj                     AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dCurrentOrganisationObj             AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dCurrentLanguageObj                 AS DECIMAL      NO-UNDO.
DEFINE VARIABLE tCurrentProcessDate                 AS DATE         NO-UNDO.
DEFINE VARIABLE cCurrentUserLogin                   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cCurrentUserName                    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cCurrentUserEmail                   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cCurrentOrganisationCode            AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cCurrentOrganisationName            AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cCurrentOrganisationShort           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cCurrentLanguageName                AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cCurrentLoginValues                 AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cPropertyList                       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cValueList                          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cDateFormat                         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cCacheTranslations                  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cProfileData                        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cCalcSParm                          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cSParm                              AS CHARACTER    CASE-SENSITIVE NO-UNDO.
DEFINE VARIABLE cCalcAppService                     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCount                              AS INTEGER      NO-UNDO.
DEFINE VARIABLE lSFound                             AS LOGICAL      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 17.91
         WIDTH              = 46.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
SESSION:APPL-ALERT-BOXES = TRUE.

SESSION:SET-WAIT-STATE('general':U).

/* deal with run window containing 2 entries, the run window and a run attribute */
IF pcRunWindow <> "":U THEN
  ASSIGN cRunWindow = ENTRY(1,pcRunwindow).

/* 1st ensure the programs passed in as parameters exist */
IF SEARCH(pcLoginWindow) = ? AND SEARCH(REPLACE(pcLoginWindow,".w":U,".r":U)) = ? THEN
DO:
  SESSION:SET-WAIT-STATE('':U).
  MESSAGE "Cannot find login window name (or .r extension): " pcLoginWindow
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  IF NOT plQuit THEN RETURN. ELSE QUIT.
END.
IF plQuit AND
  (cRunWindow = "":U OR NUM-ENTRIES(cRunWindow,".":U) > 1) AND 
  SEARCH(cRunWindow) = ? AND 
  SEARCH(REPLACE(cRunWindow,".w":U,".r":U)) = ? THEN
DO:
  SESSION:SET-WAIT-STATE('':U).
  MESSAGE "Cannot find run window name (or .r extension): " cRunWindow
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  IF NOT plQuit THEN RETURN. ELSE QUIT.
END.

/* connect to ICF Appserver Partition and store handle */
ASSIGN
    cAsDivision = "CLIENT"    /* Client appserver connection */
    cAppService = "Astra"     /* ICF Appserver partition name */
    lAsUsePrompt = NO
    cAsInfo = "".

IF plAppserverConnect THEN
DO:  
  IF NOT VALID-HANDLE(gshAstraAppserver) OR (CAN-QUERY(gshAstraAppserver, "connected":U) AND NOT gshAstraAppserver:CONNECTED()) THEN
  DO:
    /* ensure we do not have stale information in partition temp-table */
    {adecomm/appsrvtt.i "NEW GLOBAL"}
    FIND FIRST AppSrv-TT WHERE AppSrv-TT.Partition = cAppService NO-ERROR.
    IF AVAILABLE AppSrv-TT THEN
    DO:
      ASSIGN AppSrv-TT.AS-Handle = ?.

      /* &IF "{&scmTool}" = "RTB":U */
      /* Check appservice name is correct for workspace */
      IF SUBSTRING(grtb-wspace-id,1,3) = "090":U
      OR SUBSTRING(grtb-wspace-id,1,3) = "101":U
      OR SUBSTRING(grtb-wspace-id,1,3) = "001":U
      OR SUBSTRING(grtb-wspace-id,1,3) = "003":U
      THEN
      DO:
        /* ICF FIX for PSC
           The following code was added to fix a problem with the ICF Development and
           QA environments.

           Instead of using the plain workspace ID for the AppService name,
           this code works out from the -S connection parameter for the RoundTable
           database what the AppService name is.

           It takes anything after the last - and replaces the entry after the last'
           - in the workspace ID with that. It then strips all - out and inserts
           an oas_ in front. Thus, working in the 090af-dev workspace connected to a
           roundtable database with a -S of db090af-qa will connect you to an AppService
           of oas_090afqa.

            Note that this is short term workaround.*/

        lSFound = FALSE.
        DBPARAM-BLK:
        DO iCount = 1 TO NUM-DBS:
          IF LDBNAME(iCount) = "RTB":U THEN
          DO:
            cCalcSParm = DBPARAM(iCount).
            LEAVE DBPARAM-BLK.
          END.
        END.
        IF cCalcSParm <> "":U THEN
        SPARAM-BLK:
        DO iCount = 1 TO NUM-ENTRIES(cCalcSParm):
          cSParm = SUBSTRING(ENTRY(iCount, cCalcSParm),1,3).
          IF cSParm = "-S ":U THEN
          DO:
            cCalcSParm = TRIM(SUBSTRING(ENTRY(iCount, cCalcSParm),3)).
            lSFound = YES.
            LEAVE SPARAM-BLK.
          END.
        END.
        IF lSFound AND
           NUM-ENTRIES(cCalcSParm,"-":U) > 1 THEN
          cCalcSParm = ENTRY(NUM-ENTRIES(cCalcSParm,"-":U),cCalcSParm,"-":U).
        ELSE
          cCalcSParm = "":U.
        IF cCalcSParm <> "":U AND
           NUM-ENTRIES(grtb-wspace-id,"-":U) > 1 THEN
        DO:
          cCalcAppService = REPLACE(grtb-wspace-id,
                                    "-":U + ENTRY(NUM-ENTRIES(grtb-wspace-id,"-":U),grtb-wspace-id,"-":U),
                                    "-":U + cCalcSParm).

          cCalcAppService = "oas_":U + LC(TRIM(REPLACE(cCalcAppService,"-":U,"":U))).
        END.
        /* END OF ADDITIONS FOR ICF FIX */
        ELSE
          cCalcAppService = "oas_":U + LC(TRIM(REPLACE(grtb-wspace-id,"-":U,"":U))).
        ASSIGN
          AppSrv-TT.App-Service = cCalcAppService.
      END.
    END.
    RUN appServerConnect(INPUT  cAppService, 
                         INPUT  IF NOT lASUsePrompt THEN ? ELSE lASUsePrompt,
                         INPUT  IF cASInfo NE "":U THEN cASInfo ELSE ?, 
                         OUTPUT gshAstraAppserver).                                       
  END. 
END.
ELSE
  ASSIGN gshAstraAppserver = SESSION:HANDLE.

/* If the AppServer handle is the SESSION:HANDLE and we are running the
   client proxy - (ASDivision = "Client") and the user doesn't have the
   right databases connected we need an error message.                 
*/
IF (gshAstraAppserver = SESSION:HANDLE OR RETURN-VALUE = "ERROR":U) AND
   cASDivision = 'CLIENT':U AND NOT CONNECTED("ICFDB":U) THEN 
DO:
  SESSION:SET-WAIT-STATE('':U).
  MESSAGE "Could not connect to the Appserver Partition and no" SKIP
          "database connection for ICFDB was found locally."
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  IF NOT plQuit THEN RETURN. ELSE QUIT.
END.

/* set-up unique session id shared variable */
IF gshAstraAppserver = SESSION:HANDLE THEN
DO:
  RUN af/sup2/afsessnidp.p(OUTPUT gscSessionId).  /* Use seq. for session id */
END.
ELSE
    ASSIGN gscSessionId = gshAstraAppserver:CLIENT-CONNECTION-ID.

/* start client side Session Manager if not already running and return handle of running procedure */
IF gshAstraAppserver = SESSION:HANDLE THEN
    ASSIGN gcFileName = "af/app/afsessrvrp.p":U.
ELSE
    ASSIGN gcFileName = "af/sup2/afsesclntp.p":U.

RUN af/sup/afrunoncep.p (INPUT gcFileName, OUTPUT gshSessionManager). /* no db connection */

IF NOT VALID-HANDLE(gshSessionManager) THEN
DO:
    RUN startupFailed (INPUT "Session", INPUT gcFileName).
    IF NOT plQuit THEN
        RETURN.
    ELSE
        QUIT.
END.    /* session manager failed to start */

/* start client side security manager if not already running and return handle of running procedure */
IF gshAstraAppserver = SESSION:HANDLE THEN
    ASSIGN gcfileName = "af/app/afsecsrvrp.p":U.
ELSE
    ASSIGN gcFileName = "af/sup2/afsecclntp.p":U.

RUN af/sup/afrunoncep.p (INPUT gcFileName, OUTPUT gshSecurityManager).

IF NOT VALID-HANDLE(gshSecurityManager) THEN
DO:
    RUN startupFailed (INPUT "Security", INPUT gcFileName).
    IF NOT plQuit THEN
        RETURN.
    ELSE
        QUIT.
END.    /* security manager failed */

/* start client side profile manager if not already running and return handle of running procedure */
IF gshAstraAppserver = SESSION:HANDLE THEN
    ASSIGN gcFileName = "af/app/afprosrvrp.p":U.
ELSE    
    ASSIGN gcFileName = "af/sup2/afproclntp.p":U.

RUN af/sup/afrunoncep.p (INPUT gcFileName, OUTPUT gshProfileManager).

IF NOT VALID-HANDLE(gshProfileManager) THEN
DO:
    RUN startupFailed (INPUT "Profile", INPUT gcFileName).
    IF NOT plQuit THEN
        RETURN.
    ELSE
        QUIT.
END.    /* profile manager failed to start */

/* start client side repository manager if not already running and return handle of running procedure */
IF gshAstraAppserver = SESSION:HANDLE THEN
    ASSIGN gcFileName = "ry/app/ryrepsrvrp.p":U.
ELSE
    ASSIGN gcFileName = "ry/prc/ryrepclntp.p":U.

RUN af/sup/afrunoncep.p (INPUT gcFileName, OUTPUT gshRepositoryManager).

IF NOT VALID-HANDLE(gshRepositoryManager) THEN
DO:
    RUN startupFailed (INPUT "Repository", INPUT gcFileName).
    IF NOT plQuit THEN
        RETURN.
    ELSE
        QUIT.
END.    /* repository manager failed to start */

/* start client side translation manager if not already running and return handle of running procedure */
IF gshAstraAppserver = SESSION:HANDLE THEN
    ASSIGN gcFileName = "af/app/aftrnsrvrp.p":U.
ELSE
    ASSIGN gcFileName = "af/sup2/aftrnclntp.p":U.

RUN af/sup/afrunoncep.p (INPUT gcFileName, OUTPUT gshTranslationManager).

IF NOT VALID-HANDLE(gshTranslationManager) THEN
DO:
    RUN startupFailed (INPUT "Translation", INPUT gcFileName).
    IF NOT plQuit THEN 
        RETURN.
    ELSE
        QUIT.
END.    /* translation manager dailed to start */

/* Start client side gen manager if not already running and return handle of running procedure */
IF gshAstraAppserver = SESSION:HANDLE THEN
    ASSIGN gcFileName = "af/app/afgensrvrp.p":U.
ELSE
    ASSIGN gcFileName = "af/sup2/afgenclntp.p":U.

RUN af/sup/afrunoncep.p (INPUT gcFileName, OUTPUT gshGenManager).

IF NOT VALID-HANDLE(gshGenManager) THEN
DO:
    RUN startupFailed (INPUT "Framework", INPUT gcFileName).
    IF NOT plQuit THEN
        RETURN.
    ELSE
        QUIT.
END.    /* gen manager dailed to start */

/* Only start the AstraGen and AstraFin managers if installed. */
&IF "{&astragen}":U <> "":U &THEN
/* Start client side gen manager if not already running and return handle of running procedure */
IF gshAstraAppserver = SESSION:HANDLE THEN
    ASSIGN gcFileName = "ag/app/gsgensrvrp.p":U.
ELSE
    ASSIGN gcFileName = "ag/prc/gsgenclntp.p":U.

RUN af/sup/afrunoncep.p (INPUT gcFileName, OUTPUT gshAgnManager).

IF NOT VALID-HANDLE(gshAgnManager) THEN
DO:
    RUN startupFailed (INPUT "AstraGen", INPUT gcFileName).
    IF NOT plQuit THEN
        RETURN.
    ELSE
        QUIT.
END.    /* AstraGen manager dailed to start */

/* Start client side gen manager if not already running and return handle of running procedure */
IF gshAstraAppserver = SESSION:HANDLE THEN
    ASSIGN gcFileName = "ag/app/gsfinsrvrp.p":U.
ELSE
    ASSIGN gcFileName = "ag/prc/gsfinclntp.p":U.

RUN af/sup/afrunoncep.p (INPUT gcFileName, OUTPUT gshFinManager).

IF NOT VALID-HANDLE(gshFinManager) THEN
DO:
    RUN startupFailed (INPUT "Fin", INPUT gcFileName).
    IF NOT plQuit THEN
        RETURN.
    ELSE
        QUIT.
END.    /* gen manager dailed to start */
&ENDIF

RUN VALUE(pcLoginWindow) (INPUT  "One":U,                       /* 1st login */
                          OUTPUT dCurrentUserObj,
                          OUTPUT cCurrentUserLogin,
                          OUTPUT cCurrentUserName,
                          OUTPUT cCurrentUserEmail,
                          OUTPUT dCurrentOrganisationObj,
                          OUTPUT cCurrentOrganisationCode,
                          OUTPUT cCurrentOrganisationName,
                          OUTPUT cCurrentOrganisationShort,
                          OUTPUT tCurrentProcessDate,
                          OUTPUT dCurrentLanguageObj,
                          OUTPUT cCurrentLanguageName,
                          OUTPUT cCurrentLoginValues).

/* if failed to login then abort */
IF NOT dCurrentUserObj > 0 THEN
DO:
    RUN startupFailed (INPUT "":U, INPUT "":U).
    IF NOT plQuit THEN
        RETURN.
    ELSE
        QUIT.
END.    /* login failed */

/* Must have logged in ok, set appropriate values in Client Session Manager,
   which will also set values in Context database via Server Session Manager
*/
IF tCurrentProcessDate = ? THEN ASSIGN tCurrentProcessDate = TODAY.

cDateFormat = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                   INPUT "dateFormat":U,
                                                   INPUT NO).

ASSIGN
  cPropertyList = "CurrentUserObj,CurrentUserLogin,CurrentUserName,CurrentUserEmail,CurrentOrganisationObj,CurrentOrganisationCode,CurrentOrganisationName,CurrentOrganisationShort,CurrentLanguageObj,CurrentLanguageName,CurrentProcessDate,CurrentLoginValues,DateFormat,LoginWindow":U
  cValueList = STRING(dCurrentUserObj) + CHR(3) +
               cCurrentUserLogin + CHR(3) +
               cCurrentUserName + CHR(3) +
               cCurrentUserEmail + CHR(3) +
               STRING(dCurrentOrganisationObj) + CHR(3) +
               cCurrentOrganisationCode + CHR(3) +
               cCurrentOrganisationName + CHR(3) +
               cCurrentOrganisationShort + CHR(3) +
               STRING(dCurrentLanguageObj) + CHR(3) +
               cCurrentLanguageName + CHR(3) +
               STRING(tCurrentProcessDate,cDateFormat) + CHR(3) +
               cCurrentLoginValues + CHR(3) +
               cDateFormat + CHR(3) +
               pcLoginWindow
  .

DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                     INPUT cPropertyList,
                                     INPUT cValueList,
                                     INPUT NO).

cCacheTranslations = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                 INPUT "cachedTranslationsOnly":U,
                                 INPUT NO).
lCacheTranslations = cCacheTranslations <> "NO":U NO-ERROR.

/* if caching translations - do so for logged into language */
IF lCacheTranslations THEN
  RUN buildClientCache IN gshTranslationManager (INPUT dCurrentLanguageObj).

/* get window user profile settings and action them */
ASSIGN rRowid = ?.
RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                         INPUT "DebugAlert":U,
                                         INPUT "DebugAlert":U,
                                         INPUT NO,
                                         INPUT-OUTPUT rRowid,
                                         OUTPUT cProfileData).
SESSION:DEBUG-ALERT = cProfileData <> "NO":U.                                         

ASSIGN rRowid = ?.
RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                         INPUT "Tooltips":U,
                                         INPUT "Tooltips":U,
                                         INPUT NO,
                                         INPUT-OUTPUT rRowid,
                                         OUTPUT cProfileData).
SESSION:TOOLTIPS = cProfileData <> "NO":U.                                         

IF cRunWindow <> "":U AND NUM-ENTRIES(cRunWindow,".":U) = 1 THEN
DO: /* must be running a logical object */
  RUN getObjectNames IN gshRepositoryManager (
      INPUT  cRunWindow,
      OUTPUT cPhysicalName,
      OUTPUT cLogicalName).
  IF cPhysicalName = "":U THEN
  DO:
    MESSAGE "Could not find Physical Name for Logical Object: " cRunWindow
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  END.
END.
ELSE
  ASSIGN cPhysicalName = cRunWindow.

/* Run startup window if specified */
IF cPhysicalName <> "":U THEN
RUN-BLOCK:
DO ON STOP UNDO RUN-BLOCK, LEAVE RUN-BLOCK ON ERROR UNDO RUN-BLOCK, LEAVE RUN-BLOCK:
/*   SESSION:SET-WAIT-STATE('general':U). */
  RUN VALUE(cPhysicalName).
END.
SESSION:SET-WAIT-STATE('':U).

/* Tidy up - Disconnect from Appserver and zap Managers */
IF cRunWindow <> "":U THEN
  RUN af/sup2/afshutdwnp.p.

/* when exit startup window, quit if from desktop, else return only to stay in
   Appbuilder
*/
IF NOT plQuit THEN RETURN. ELSE QUIT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-startupFailed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startupFailed Procedure 
PROCEDURE startupFailed :
/*------------------------------------------------------------------------------
  Purpose:     If a manager fails to start, shut down all running managers,
               report the error and disconnect from AppServer.
  Parameters:  pcManagerName     -
               pcManagerFileName -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcManagerName            AS CHARACTER            NO-UNDO.
    DEFINE INPUT PARAMETER pcManagerFileName        AS CHARACTER            NO-UNDO.

    SESSION:SET-WAIT-STATE("":U).

    IF pcManagerName <> "":U THEN
        MESSAGE "Unable to start the " TRIM(pcManagerName) 
                " Manager (" TRIM(pcManagerFileName) ")":U
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

    /* Attempt to shutdown any and all managers running.  */
    IF VALID-HANDLE(gshAgnManager)          THEN APPLY "CLOSE":U TO gshAgnManager.
    IF VALID-HANDLE(gshFinManager)          THEN APPLY "CLOSE":U TO gshFinManager.
    IF VALID-HANDLE(gshGenManager)          THEN APPLY "CLOSE":U TO gshGenManager.
    IF VALID-HANDLE(gshTranslationManager)  THEN APPLY "CLOSE":U TO gshTranslationManager.
    IF VALID-HANDLE(gshRepositoryManager)   THEN APPLY "CLOSE":U TO gshRepositoryManager.
    IF VALID-HANDLE(gshProfileManager)      THEN APPLY "CLOSE":U TO gshProfileManager.
    IF VALID-HANDLE(gshSecurityManager)     THEN APPLY "CLOSE":U TO gshSecurityManager.
    IF VALID-HANDLE(gshSessionManager)      THEN APPLY "CLOSE":U TO gshSessionManager.

    IF VALID-HANDLE(gshAstraAppserver)             AND
       CAN-QUERY(gshAstraAppserver, "connected":U) AND
       gshAstraAppserver:CONNECTED()               THEN
        RUN appServerDisconnect(INPUT cAppService).

    ASSIGN gshAgnManager         = ?
           gshFinManager         = ?
           gshGenManager         = ?
           gshTranslationManager = ?
           gshRepositoryManager  = ?
           gshProfileManager     = ?
           gshSecurityManager    = ?
           gshSessionManager     = ?
           gshAstraAppserver     = ?
           .

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

