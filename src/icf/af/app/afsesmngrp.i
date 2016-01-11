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
/*---------------------------------------------------------------------------------
  File: afsesmngrp.i

  Description:  ICF Session Manager Code

  Purpose:      The ICF Session Manager is a standard procedure to manage information
                that must span the client / server divide, i.e. information that must
                be available to business logic regardless of whether it is running
                client or server side.
                The session manager also supports properties that are only required
                client side and is an efficient mechanism to pass information between
                objects.
                On the client, session information is cached into a local temp-table and
                on the server the information is stored in a context table.
                The session manager also supports a persistent procedure manager to
                control the running of business logic procedures.
                This include file contains the common code for both the server and client
                Session Manager procedures.

  Parameters:   <none>

  History:
  --------
  (v:010036)    Task:           0   UserRef:    
                Date:   01/23/2002  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #3704 - Can't translate text treeview items.
                Assign translated TEXT widget value to SCREEN-VALUE directly,

  (v:010004)    Task:    90000021   UserRef:    
                Date:   02/15/2002  Author:     Dynamics Admin User

  Update Notes: Remove RVDB dependency

----------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afsesmngrp.i
&scop object-version    000000

/* Astra object identifying preprocessor */
&global-define astraSessionManager  yes

{af/sup2/afglobals.i} /* Astra global shared variables */

DEFINE TEMP-TABLE ttProperty NO-UNDO
FIELD propertyName            AS CHARACTER    /* property name */
FIELD propertyValue           AS CHARACTER    /* prooperty value */
INDEX propertyName AS PRIMARY UNIQUE propertyName.

DEFINE VARIABLE giLoop                    AS INTEGER    NO-UNDO.

/* temp table of persistent procs started in client session since we started the
   session manager - i.e. procs we must shutdown when this manager closes.
*/
DEFINE TEMP-TABLE ttPersistProc NO-UNDO
FIELD hProc     AS HANDLE
INDEX ObjHandle IS PRIMARY hProc.

DEFINE TEMP-TABLE ttUser NO-UNDO LIKE gsm_user.

{af/app/afttglobalctrl.i}
{af/app/afttsecurityctrl.i}

{af/sup2/afcheckerr.i &define-only = YES}

{af/app/afttpersist.i}

/* Include the file which defines AppServerConnect procedures. */
{adecomm/appsrvtt.i "NEW GLOBAL"}
{adecomm/appserv.i}

IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
DO:
  /* Code for windows API calls and Help Integration */
  &GLOB DONTRUN-WINFUNC
  {af/sup/windows.i}

  PROCEDURE LockWindowUpdate EXTERNAL "user32.dll":
      DEFINE INPUT  PARAMETER piWindowHwnd AS LONG NO-UNDO.
      DEFINE RETURN PARAMETER piResult     AS LONG NO-UNDO.
  END PROCEDURE.

  &GLOBAL-DEFINE HH_DISPLAY_TOPIC 0
  &GLOBAL-DEFINE HH_KEYWORD_LOOKUP 13
  &GLOBAL-DEFINE HH_DISPLAY_TEXT_POPUP 14

  PROCEDURE HtmlHelpA EXTERNAL "hhctrl.ocx" PERSISTENT :
     DEFINE INPUT PARAMETER  hwndCaller AS LONG.
     DEFINE INPUT PARAMETER  pszFile    AS CHAR.
     DEFINE INPUT PARAMETER  uCommand   AS LONG.
     DEFINE INPUT PARAMETER  dwData     AS LONG.
     DEFINE RETURN PARAMETER hwndHelp   AS LONG.
  END PROCEDURE.
END.

{af/app/aftttranslate.i}

{ af/sup2/aflaunch.i &Define-only = YES }

DEFINE TEMP-TABLE ttActionUnderway NO-UNDO
FIELD action_underway_origin  AS CHARACTER /* Identify the origin, i.e "DYN" "RTB" */
FIELD action_table_fla        AS CHARACTER
FIELD action_type             AS CHARACTER
FIELD action_primary_key      AS CHARACTER
FIELD action_scm_object_name  AS CHARACTER
INDEX XPKrvt_action_underway  IS PRIMARY
      action_underway_origin  ASCENDING
      action_type             ASCENDING
      action_scm_object_name  ASCENDING
      action_table_fla        ASCENDING
      action_primary_key      ASCENDING
      .

/*
ttActionUnderway - used for SCM Integration:
-----------------
This table will only contain records during a  transaction for some action,
e.g. deletion, assignment, etc. Its purpose is to make primary table information available
to involved tables during the operation, e.g. cascade deletion, object assignment, etc.

The problem is that during a deletion of the primary table, the involved tables
replication triggers can not access the primary table anymore, as it has been deleted.

To resolve this issue, we will create a record in this table at the top of the delete trigger
of a primary table, and subsequently delete the record at the end of the primary table
replication delete trigger. This means the information will be available throughout
the entire delete transaction.

Under normal cicumstances (no active transaction), this table will be empty.

action_underway_origin:
-----------------------
Where the action was initiated from, e.g. "SCM" , "DYN"
As to prevent recursive triggers firing between systems.

action_table_fla:
-----------------
The FLA of the table whose data is being actioned, e.g. deleted or assigned.

action_type:
------------
The type of action, e.g. ANY = anything, DEL = Deletion , ASS = Assignment of new data, MOV = move (CV), or ADD = Adding

action_primary_key:
-------------------
A chr(3) delimited list of primary key field values to identify the record being actioned.
The field values correspond to the primary key fields "smartobject_obj":U.
This field is only required for deletions. For other things such as assigns,
just the scm object name will be used with the table FLA to locate this record.

action_scm_object_name:
-----------------------
The object name of the data item being actioned as referenced in the SCM tool.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fixQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fixQueryString Procedure 
FUNCTION fixQueryString RETURNS CHARACTER
  ( INPUT pcQueryString AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInternalEntryExists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInternalEntryExists Procedure 
FUNCTION getInternalEntryExists RETURNS LOGICAL
  ( INPUT phProcedure           AS HANDLE,
    INPUT pcProcedureName       AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPropertyList Procedure 
FUNCTION getPropertyList RETURNS CHARACTER
  ( INPUT pcPropertyList AS CHARACTER,
    INPUT plSessionOnly AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isObjQuoted) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isObjQuoted Procedure 
FUNCTION isObjQuoted RETURNS LOGICAL
  (INPUT pcQueryString  AS CHARACTER,
   INPUT piPosition     AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPropertyList Procedure 
FUNCTION setPropertyList RETURNS LOGICAL
  ( INPUT pcPropertyList AS CHARACTER,
    INPUT pcPropertyValues AS CHARACTER,
    INPUT plSessionOnly AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSecurityForDynObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSecurityForDynObjects Procedure 
FUNCTION setSecurityForDynObjects RETURNS CHARACTER
  ( INPUT phWidget          AS HANDLE,
    INPUT pcSecuredFields   AS CHARACTER,
    INPUT pcDisplayedFields AS CHARACTER,
    INPUT pcFieldSecurity   AS CHARACTER,
    INPUT phViewer          AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 27.95
         WIDTH              = 49.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm/method/attribut.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */
CREATE WIDGET-POOL NO-ERROR.

ON CLOSE OF THIS-PROCEDURE 
DO:
    DELETE WIDGET-POOL NO-ERROR.

    RUN plipShutdown.

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

&IF DEFINED(server-side) <> 0 &THEN
  PROCEDURE afdelctxtp:         {af/app/afdelctxtp.p}     END PROCEDURE.
  PROCEDURE afgetprplp:         {af/app/afgetprplp.p}     END PROCEDURE.
  PROCEDURE afsetprplp:         {af/app/afsetprplp.p}     END PROCEDURE.
  PROCEDURE afmessagep:         {af/app/afmessagep.p}     END PROCEDURE.
  PROCEDURE aferrorlgp:         {af/app/aferrorlgp.p}     END PROCEDURE.
  PROCEDURE afgetglocp:         {af/app/afgetglocp.p}     END PROCEDURE.
&ENDIF

RUN buildPersistentProc.  /* Build TT of running procedures */

IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
DO:

  /* When instantiated, populate temp-table with standard properties that may be cached
     on the client. These properties will always be returned from the temp-table. If a 
     property is not in the temp-table, then its value must be obtained from the server
     Session Manager which has access to the database.
  */

  /* The login values will be set-up during the user login process, which will also cause
     the context database to be updated with the same info for retrieval by the server side
     Session Manager. If these values are not set-up, then the user has not logged in
     sucessfully.
  */
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentUserObj":U            /* logged in user object number */
    ttProperty.propertyValue = "0":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentUserLogin":U          /* logged in user login name */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentUserName":U           /* logged in user full name */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentUserEmail":U           /* logged in user email */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentLanguageObj":U         /* logged into language object number */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentLanguageName":U        /* logged into language name */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentOrganisationObj":U    /* logged in user organisation object number */
    ttProperty.propertyValue = "0":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentOrganisationCode":U   /* logged in user organisation code */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentOrganisationName":U   /* logged in user organisation full name */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentOrganisationShort":U  /* logged in user organisation short code */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentProcessDate":U        /* processing date specified at login time and used mainly in financials for forward postings */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentLoginValues":U        /* user defined list of extra login values in the form label,value,label,value, etc. */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "dateFormat":U                /* Property to hold Client PC session date format */
    ttProperty.propertyValue = "":U
    .

  DEFINE VARIABLE cDateFormat AS CHARACTER NO-UNDO.
  ASSIGN cDateFormat = SESSION:DATE-FORMAT.

/* The following code has been deliberately commented out to resolve 
   issue 2235 
/* get date format from global control */
  RUN af/app/afsetsndfp.p ON gshAstraAppserver (INPUT-OUTPUT cDateFormat).
  SESSION:DATE-FORMAT = cDateFormat. 
              */

  DO  giLoop = 1 TO 3:
      CASE SUBSTRING(cDateFormat, giLoop, 1):
          WHEN "y" THEN
              ASSIGN
                  ttProperty.propertyValue = ttProperty.propertyValue + "9999" + "/".
          OTHERWISE
              ASSIGN
                  ttProperty.propertyValue = ttProperty.propertyValue + "99" + "/".
      END CASE.
  END.

  ASSIGN ttProperty.propertyValue = SUBSTRING(ttProperty.propertyValue, 1, LENGTH(ttProperty.propertyValue) - 1).

  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "suppressDisplay":U           /* Property to supress Message Display */
    ttProperty.propertyValue = "NO":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "cachedTranslationsOnly":U    /* Property to load translations at login time */
    ttProperty.propertyValue = "YES":U
    .

  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "translationEnabled":U        /* Property to turn translation on/off */
    ttProperty.propertyValue = "YES":U
    .

  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "launchphysicalobject":U      /* Property to save 1st launched physical object */
    ttProperty.propertyValue = "":U
    .

  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "launchlogicalobject":U       /* Property to save 1st launched logical object */
    ttProperty.propertyValue = "":U
    .

  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "launchrunattribute":U        /* Property to save 1st launched object run attribute */
    ttProperty.propertyValue = "":U
    .

END. /* not (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) */

CREATE ttProperty.
ASSIGN
  ttProperty.propertyName = "loginWindow":U
  ttProperty.propertyValue = "af/cod2/aftemlognw.w":U
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-askQuestion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE askQuestion Procedure 
PROCEDURE askQuestion :
/*------------------------------------------------------------------------------
  Purpose: This is the procedure for the display of all question message types.
           Any button combination is supported. 
           The default button list is "OK,CANCEL", the default label to return is
           OK if OK is passed in, otherwise the first button in the list.
           The default cancel button is CANCEL if available otherwise the first
           entry in the list, the default title will be "Question".
           If running server side the messages cannot be displayed and will only
           be able to write to the message log. Also, server side there is no user
           interface, so the default button label and answer will always be returned.
           Client side the messages will be displayed in a dialog window. 
           The procedure checks the property "suppressDisplay" in the Session Manager
           and if set to YES, will not display the message but will simply pass the
           message to the log as would be the case for a server side message.
           This is useful when running take-on procedures client side.
           The messages will be passed to a procedure on Appserver for interpretation
           called af/app/afmessagep.p. This procedure will format the messages appropriately,
           read text from the ICF message file where appropriate, interpret the carrot
           delimited lists that come back from triggers, deal with ADM2 CHR(4) delimited
           messages, etc. to end up with actual formatted messages (translated if required).
           Once the messages have been formatted, if on the client, the message will be
           displayed using the standard ICF message dialog af/cod2/afmessaged.w which is
           an enhanced dialog that contains an email button, etc. This dialog window is also
           used by showMessages.
           If server side, or the error log flag was returned as YES, or message display
           supression is enabled, the ICF error log will be updated with the error and an 
           email will be sent to the currently logged in user notifying them of the error
           (if possible).
    Notes: Returns untranslated button text of button pressed if client side,
           else default button if server side. 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER        pcMessageList     AS CHARACTER.
DEFINE INPUT PARAMETER        pcButtonList      AS CHARACTER.
DEFINE INPUT PARAMETER        pcDefaultButton   AS CHARACTER.
DEFINE INPUT PARAMETER        pcCancelButton    AS CHARACTER.
DEFINE INPUT PARAMETER        pcMessageTitle    AS CHARACTER.
DEFINE INPUT PARAMETER        pcDataType        AS CHARACTER.
DEFINE INPUT PARAMETER        pcFormat          AS CHARACTER.
DEFINE INPUT-OUTPUT PARAMETER pcAnswer          AS CHARACTER.
DEFINE OUTPUT PARAMETER       pcButtonPressed   AS CHARACTER.

  DEFINE VARIABLE cSummaryMessages                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullMessages                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButtonList                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageTitle                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUpdateErrorLog                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iButtonPressed                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFailed                         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuppressDisplay                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSuppressDisplay                AS CHARACTER  NO-UNDO.

  /* Set up defaults for values not passed in */
  IF pcButtonList = "":U THEN ASSIGN pcButtonList = "OK,CANCEL":U.
  IF pcDefaultButton = "":U OR LOOKUP(pcDefaultButton,pcButtonList) = 0 THEN
  DO:
    IF LOOKUP("OK":U,pcButtonList) > 0 THEN
      ASSIGN pcDefaultButton = "OK":U.
    ELSE
      ASSIGN pcDefaultButton = ENTRY(1,pcButtonList).
  END.
  IF pcCancelButton = "":U OR LOOKUP(pcCancelButton,pcButtonList) = 0 THEN
  DO:
    IF LOOKUP("CANCEL":U,pcButtonList) > 0 THEN
      ASSIGN pcCancelButton = "CANCEL":U.
    ELSE
      ASSIGN pcCancelButton = ENTRY(1,pcButtonList).
  END.
  IF pcMessageTitle = "":U THEN ASSIGN pcMessageTitle = "Question":U. 

  /* When the message is substituted later in the procedure
     and the message data contains any substitute characters 
     it bombs out - MAD (MIP) 10/08/2001 */
  IF INDEX(pcMessageList,"&":U) <> 0 THEN
    pcMessageList = REPLACE(pcMessageList,"&":U,"'&'":U).

  /* Next interpret / translate the messages */
  &IF DEFINED(server-side) <> 0 &THEN
    DO:
      RUN afmessagep (INPUT pcMessageList,
                      INPUT pcButtonList,
                      INPUT pcMessageTitle,
                      OUTPUT cSummaryMessages,
                      OUTPUT cFullMessages,
                      OUTPUT cButtonList,
                      OUTPUT cMessageTitle,
                      OUTPUT lUpdateErrorLog,
                      OUTPUT lSuppressDisplay).  
    END.
  &ELSE
    DO:
      RUN af/app/afmessagep.p ON gshAstraAppserver (INPUT pcMessageList,
                                                    INPUT pcButtonList,
                                                    INPUT pcMessageTitle,
                                                    OUTPUT cSummaryMessages,
                                                    OUTPUT cFullMessages,
                                                    OUTPUT cButtonList,
                                                    OUTPUT cMessageTitle,
                                                    OUTPUT lUpdateErrorLog,
                                                    OUTPUT lSuppressDisplay).  
    END.
  &ENDIF

  /* Display message if not remote and not suppressed */
  IF NOT lSuppressDisplay THEN
  DO:
    cSuppressDisplay = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                        INPUT "suppressDisplay":U,
                                        INPUT YES).
  END.
  ELSE cSuppressDisplay = "YES":U.

  IF cSuppressDisplay = "YES":U THEN ASSIGN lSuppressDisplay = YES.

  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) AND NOT lSuppressDisplay THEN
  DO:
    RUN af/cod2/afmessaged.w (INPUT "QUE",
                              INPUT cSummaryMessages,
                              INPUT cFullMessages,
                              INPUT cButtonList,
                              INPUT cMessageTitle,
                              INPUT LOOKUP(pcDefaultButton,pcButtonList),
                              INPUT LOOKUP(pcCancelButton,pcButtonList),
                              INPUT pcDataType,
                              INPUT pcFormat,
                              INPUT pcAnswer,
                              INPUT ?,
                              OUTPUT iButtonPressed,
                              OUTPUT pcAnswer).
    IF iButtonPressed > 0 AND iButtonPressed <= NUM-ENTRIES(pcButtonList) THEN
      ASSIGN pcButtonPressed = ENTRY(iButtonPressed, pcButtonList).  /* Pass back untranslated button pressed */
    ELSE
      ASSIGN pcButtonPressed = pcDefaultButton.
  END.
  ELSE
    ASSIGN pcButtonPressed = pcDefaultButton.  /* If remote, assume default button */

  /* If remote, or update error log set to YES, then update error log and send an email if possible */
  IF (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) OR lUpdateErrorLog OR lSuppressDisplay THEN
  DO:
    RUN updateErrorLog IN gshSessionManager (INPUT cSummaryMessages,
                                             INPUT cFullMessages).
    RUN notifyUser IN gshSessionManager (INPUT 0,                           /* default user */
                                         INPUT "":U,                        /* default user */
                                         INPUT "email":U,                   /* by email */
                                         INPUT "Dynamics " + cMessageTitle,    /* ICF message */
                                         INPUT cSummaryMessages,            /* Summary translated messages */
                                         OUTPUT cFailed).           
  END.


  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildPersistentProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildPersistentProc Procedure 
PROCEDURE buildPersistentProc :
/*------------------------------------------------------------------------------
  Purpose:     To build a temp-table of persistent procs already running before
               this manager was started - i.e. the ones we should not kill.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hProcedure AS HANDLE NO-UNDO.

  ASSIGN hProcedure = SESSION:FIRST-PROCEDURE.

  DO WHILE VALID-HANDLE( hProcedure ):
    CREATE ttPersistProc.
    ASSIGN ttPersistProc.hProc = hProcedure
           hProcedure          = hProcedure:NEXT-SIBLING.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearActionUnderwayCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearActionUnderwayCache Procedure 
PROCEDURE clearActionUnderwayCache :
/*------------------------------------------------------------------------------
  Purpose:     To empty client cache temp-tables to ensure the database is accessed
               again to retrieve up-to-date information. This may be called when 
               SCM and Dynamicsmaintennance programs have been run. The procedure prevents
               having to log off and start a new session in order to use the new
               repository data settings.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U)
  THEN DO:
    IF TRANSACTION
    THEN
      FOR EACH ttActionUnderway:
        DELETE ttActionUnderway.
      END.
    ELSE
      EMPTY TEMP-TABLE ttActionUnderway.
  END.    /* runnign client side. */

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-contextHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE contextHelp Procedure 
PROCEDURE contextHelp :
/*------------------------------------------------------------------------------
  Purpose:     Context help launcher - for ICF context help integration
  Parameters:  input handle of object containing widget (THIS-PROCEDURE)
               input handle of widget that has focus (FOCUS)
  Notes:       An event exists in visualcustom.i that runs this procedure
               on help anywhere of the frame.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  phObject                    AS HANDLE       NO-UNDO.
  DEFINE INPUT PARAMETER  phWidget                    AS HANDLE       NO-UNDO.

  DEFINE VARIABLE cContainerFilename                  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cObjectFilename                     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cItemName                           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cLogicalObject                      AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE iPosn                               AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cLinkHandles                        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hContainer                          AS HANDLE       NO-UNDO.

  DEFINE VARIABLE cHelpFile                           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cHelpFound                          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iHelpContext                        AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cHelpText                           AS CHARACTER    NO-UNDO.

  IF VALID-HANDLE(phObject) THEN
    DO:
      /* Get logical object names (for dynamic objects) */
      IF LOOKUP("getlogicalobjectname", phObject:INTERNAL-ENTRIES) <> 0 THEN
        cLogicalObject = DYNAMIC-FUNCTION('getlogicalobjectname' IN phObject).
      ELSE cLogicalObject = "":U.      

      /* use logical object name if dynamic */
      IF cLogicalObject <> "":U THEN
        ASSIGN cObjectFilename = cLogicalObject.
      ELSE
      DO:
        /* get filename of object and strip off path */
        ASSIGN iPosn = R-INDEX(phObject:FILE-NAME,"/":U) + 1.
        IF iPosn = 1 THEN
            ASSIGN iPosn = R-INDEX(phObject:FILE-NAME,"~\":U) + 1.
        ASSIGN cObjectFilename = SUBSTRING(phObject:FILE-NAME,iPosn).
      END.

      /* get container handle */        
      IF LOOKUP("getContainerSource", phObject:INTERNAL-ENTRIES) <> 0 THEN
      DO:
        hContainer = DYNAMIC-FUNCTION('getContainerSource' IN phObject).
        IF NOT VALID-HANDLE(hContainer) THEN
          ASSIGN hContainer = phObject.
      END.

      IF VALID-HANDLE(hContainer) THEN
      DO:
        /* Get logical object names (for dynamic objects) */
        IF LOOKUP("getlogicalobjectname", hContainer:INTERNAL-ENTRIES) <> 0 THEN
          cLogicalObject = DYNAMIC-FUNCTION('getlogicalobjectname' IN hContainer).
        ELSE cLogicalObject = "":U.      

        /* use logical object name if dynamic */
        IF cLogicalObject <> "":U THEN
          ASSIGN cContainerFilename = cLogicalObject.
        ELSE
        DO:
          ASSIGN iPosn = R-INDEX(hContainer:FILE-NAME,"/":U) + 1.
          IF iPosn = 1 THEN
              ASSIGN iPosn = R-INDEX(hContainer:FILE-NAME,"~\":U) + 1.
          ASSIGN cContainerFilename = SUBSTRING(hContainer:FILE-NAME,iPosn).
        END.
      END.
    END.
  ELSE
    ASSIGN
      cContainerFilename = "<Unknown>":U
      cObjectFilename = "<Unknown>":U.        

  IF VALID-HANDLE(phWidget) AND CAN-QUERY(phWidget, "NAME":U) THEN
    ASSIGN
      cItemName = phWidget:NAME.
  ELSE
    ASSIGN
      cItemName = "<Unknown>":U.

  /* get help context to use */
  RUN af/app/afgethctxp.p ON gshAstraAppserver (INPUT cContainerFilename,
                                                INPUT cObjectFilename,
                                                INPUT cItemName,
                                                OUTPUT cHelpFile,
                                                OUTPUT iHelpContext,
                                                OUTPUT cHelpText).
  cHelpFound = SEARCH(cHelpFile).

  IF cHelpFound = ? OR cHelpFound = "":U THEN
    DO:
      DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
      RUN showMessages IN gshSessionManager (INPUT {af/sup2/aferrortxt.i 'AF' '19' '?' '?' 'help' cHelpFile},
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Dynamics Help",
                                             INPUT NOT SESSION:REMOTE,
                                             INPUT hContainer,
                                             OUTPUT cButton).
      RETURN.
    END.
  IF INDEX(cHelpFound, ".hlp":U) > 0 THEN  /* Windows help */
  DO:
    IF cHelpText <> "":U THEN
      SYSTEM-HELP
        cHelpFound
        PARTIAL-KEY cHelpText.
    ELSE
      SYSTEM-HELP
        cHelpFound
        CONTEXT iHelpContext.
  END.
  ELSE                                   /* HTML Help */
  DO:
    IF cHelpText <> "":U  THEN
      SYSTEM-HELP 
         cHelpFound HELP-TOPIC cHelpText.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createLinks Procedure 
PROCEDURE createLinks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pcPhysicalName AS CHARACTER NO-UNDO.
 DEFINE INPUT PARAMETER phProcedureHandle AS HANDLE NO-UNDO.
 DEFINE INPUT PARAMETER phObjectProcedure AS HANDLE NO-UNDO.
 DEFINE INPUT PARAMETER plAlreadyRunning AS LOGICAL NO-UNDO.

    IF pcPhysicalName = "ry/uib/rydyncontw.w" AND VALID-HANDLE(phProcedureHandle) 
        AND VALID-HANDLE(phObjectProcedure) THEN
    DO:
        DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
        DEFINE VARIABLE hNavigationSource AS HANDLE NO-UNDO.
        DEFINE VARIABLE hCommitSource     AS HANDLE NO-UNDO.
        DEFINE VARIABLE cDataTargets AS CHARACTER NO-UNDO.
        DEFINE VARIABLE hContainerSource AS HANDLE NO-UNDO.
        DEFINE VARIABLE hUpdateSource AS HANDLE NO-UNDO.
        DEFINE VARIABLE hPrimarySdoTarget AS HANDLE NO-UNDO.
        DEFINE VARIABLE hOldDataSource AS HANDLE NO-UNDO.
        DEFINE VARIABLE lQueryObject   AS LOGICAL    NO-UNDO.
        IF NOT plAlreadyRunning AND LOOKUP("doThisOnceOnly", phProcedureHandle:INTERNAL-ENTRIES) <> 0 THEN
        DO:            
            RUN doThisOnceOnly IN phProcedureHandle.
        END.

        hPrimarySdoTarget = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION('linkHandles' IN phProcedureHandle,'PrimarySdo-Target'))).


        {get DataTarget cDataTargets phProcedureHandle}.
        {get QueryObject lQueryObject phObjectProcedure}.
        /* If this is a queryobject (SDO/SBO) then use it as datasource */ 
        IF lQueryObject THEN 
          hDataSource = phObjectProcedure.
        /* Else use its dataSource */
        ELSE 
          {get DataSource hDataSource phObjectProcedure}.

        IF NOT VALID-HANDLE(hDataSource) THEN hDataSource = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION('linkHandles' IN phObjectProcedure,'PrimarySdo-Target'))).
        {get ContainerSource hContainerSource phProcedureHandle}.
        {get UpdateSource hUpdateSource phProcedureHandle}.     
        {get NavigationSource hNavigationSource phProcedureHandle}.
        {get CommitSource hCommitSource phProcedureHandle}.

        PUBLISH "toggleData" FROM phProcedureHandle (TRUE).

        IF VALID-HANDLE(hContainerSource) AND VALID-HANDLE(hDataSource) THEN
        DO:                                                         
            IF VALID-HANDLE(hPrimarySdoTarget) THEN 
            DO:
                /* remove the old Data Links */
                {get DataSource hOldDataSource hPrimarySdoTarget}.
                IF VALID-HANDLE(hOldDataSource) THEN RUN removeLink IN hContainerSource (hOldDataSource, 'Data':U, hPrimarySdoTarget).

                RUN addLink IN hContainerSource ( hDataSource , 'Data':U , hPrimarySdoTarget ).
            END.
            IF cDataTargets <> ""        THEN 
            DO:
                RUN addLink IN hContainerSource ( hDataSource , 'Data':U , phProcedureHandle ).
            END.
            IF VALID-HANDLE(hUpdateSource)      THEN 
            DO:
                RUN addLink IN hContainerSource ( phProcedureHandle , 'Update':U , hDataSource ).
            END.
            IF VALID-HANDLE(hNavigationSource)  THEN 
            DO:
                RUN addLink IN hContainerSource ( phProcedureHandle , 'Navigation':U , hDataSource ).
            END.
            IF VALID-HANDLE(hCommitSource)  THEN 
            DO:
                RUN addLink IN hContainerSource ( phProcedureHandle , 'Commit':U , hDataSource ).
            END.

        END.

        IF plAlreadyRunning THEN 
        DO:
            PUBLISH 'dataAvailable' FROM hDataSource("DIFFERENT").
            PUBLISH 'toggleData' FROM phProcedureHandle (FALSE).
        END.

   END.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteContext Procedure 
PROCEDURE deleteContext :
/*------------------------------------------------------------------------------
  Purpose:     deletion of session context, run from as_disconnect when client
               disconnects from agent.
  Parameters:  <none>
  Notes:       Zap any remaining context database entries
               This must use the actual SESSION:SERVER-CONNECTION-ID and not the
               gscSessionId as the gscSessionId may have been set to null by the
               time this runs.
------------------------------------------------------------------------------*/

&IF DEFINED(server-side) <> 0 &THEN
  RUN afdelctxtp.  
&ELSE
  RUN af/app/afdelctxtp.p ON gshAstraAppserver.
&ENDIF

{af/sup2/afcheckerr.i &display-error = YES}   /* check for errors and display if can */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deletePersistentProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deletePersistentProc Procedure 
PROCEDURE deletePersistentProc :
/*------------------------------------------------------------------------------
  Purpose:     To delete persistent procedures started since this manager started
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDeleteProc   AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hProcedure    AS HANDLE   NO-UNDO.
  DEFINE VARIABLE lDesignMode   AS LOGICAL  NO-UNDO.

  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN  /* check for objects open in design mode */
  DO:
    ASSIGN
      hProcedure = SESSION:FIRST-PROCEDURE
      lDesignMode = FALSE.
    designloop:
    DO WHILE VALID-HANDLE( hProcedure ):

      IF CAN-DO(hProcedure:INTERNAL-ENTRIES,"get-attribute":U) /* V8-style */ THEN
      DO:
        RUN get-attribute IN hProcedure ("UIB-MODE":U).
        ASSIGN lDesignMode = RETURN-VALUE NE ?.
      END.
      ELSE IF CAN-DO(hProcedure:INTERNAL-ENTRIES,"getUIBMode":U) 
              AND INDEX(hProcedure:FILE-NAME,"smart.p":U) = 0 /* v9-style */ THEN 
      DO:
        lDesignMode = DYNAMIC-FUNCTION("getUIBMode":U IN hProcedure) = "Design":U NO-ERROR.
      END.
      IF lDesignMode THEN LEAVE designloop.

      ASSIGN hProcedure = hProcedure:NEXT-SIBLING.
    END.

    IF lDesignMode THEN
    DO:
      MESSAGE "Could not shutdown persistent procedures started in session as you" SKIP
              "have got objects open in design mode." SKIP
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      RETURN.      
    END.
  END.

  ASSIGN hProcedure = SESSION:FIRST-PROCEDURE.

  DO WHILE VALID-HANDLE( hProcedure ):
    FIND FIRST ttPersistProc WHERE ttPersistProc.hProc = hProcedure NO-ERROR.
    IF NOT AVAILABLE ttPersistProc THEN
      ASSIGN hDeleteProc = hProcedure.
    ASSIGN hProcedure = hProcedure:NEXT-SIBLING.
    /* Be VERY careful not to shutdown OpenAppbuilder if running, or the
       editor extensions if running - as this will cause funny editor
       problems and GPFs
    */
    IF VALID-HANDLE( hDeleteProc ) AND 
        LOOKUP("ADEPersistent",hDeleteProc:INTERNAL-ENTRIES) = 0 AND
        LOOKUP("OpenAppEMGetProcedures",hDeleteProc:INTERNAL-ENTRIES) = 0 AND
        LOOKUP("CapKeyWord",hDeleteProc:INTERNAL-ENTRIES) = 0 AND 
        NOT hDeleteProc:FILE-NAME BEGINS "rtb":U AND /* &IF "{&scmTool}" = "RTB":U */
        NOT hDeleteProc:FILE-NAME BEGINS "ade":U AND
        NOT hDeleteProc:FILE-NAME BEGINS "pro":U THEN
    DO:
        IF LOOKUP("dispatch":U,hDeleteProc:INTERNAL-ENTRIES) NE 0 THEN
           RUN dispatch IN hDeleteProc ('destroy':U).
        IF VALID-HANDLE(hDeleteProc) AND INDEX(hDeleteProc:FILE-NAME,"rydyncont":U) = 0 THEN /* not container */
           APPLY "CLOSE":U TO hDeleteProc.
        IF VALID-HANDLE(hDeleteProc) THEN
           DELETE PROCEDURE hDeleteProc .    
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getActionUnderway) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getActionUnderway Procedure 
PROCEDURE getActionUnderway :
/*------------------------------------------------------------------------------
  Purpose:     Get the ttActionUnderway values for the passed in records
  Parameters:  <none>
  Notes:       ttActionUnderway
               ttActionUnderway.action_underway_origin
               ttActionUnderway.action_table_fla
               ttActionUnderway.action_type
               ttActionUnderway.action_primary_key
               ttActionUnderway.action_scm_object_name
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcActionUnderwayOrigin   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcActionType             AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcActionScmObjectName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcActionTablePrimaryFla  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcActionPrimaryKeyValues AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plActionUnderwayRemove   AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plActionUnderway         AS LOGICAL    NO-UNDO.

  IF pcActionType = "ANY":U
  THEN
  DO:
    FIND FIRST ttActionUnderway EXCLUSIVE-LOCK
      WHERE  ttActionUnderway.action_underway_origin BEGINS pcActionUnderwayOrigin
      NO-ERROR.
  END.
  ELSE
  IF pcActionScmObjectName <> "":U
  THEN
    FIND FIRST ttActionUnderway EXCLUSIVE-LOCK
      WHERE ttActionUnderway.action_underway_origin  BEGINS pcActionUnderwayOrigin
      AND   ttActionUnderway.action_scm_object_name  = pcActionScmObjectName
      AND   ttActionUnderway.action_type             = pcActionType
      NO-ERROR.
  ELSE
  IF pcActionTablePrimaryFla   <> "":U
  AND pcActionPrimaryKeyValues <> "":U
  THEN
    FIND FIRST ttActionUnderway EXCLUSIVE-LOCK
      WHERE ttActionUnderway.action_underway_origin  BEGINS pcActionUnderwayOrigin
      AND   ttActionUnderway.action_table_fla        = pcActionTablePrimaryFla
      AND   ttActionUnderway.action_primary_key      = pcActionPrimaryKeyValues
      AND   ttActionUnderway.action_type             = pcActionType
      NO-ERROR.

  IF AVAILABLE ttActionUnderway
  THEN DO:
    ASSIGN
      plActionUnderway = YES.
    IF plActionUnderwayRemove AND pcActionType <> "ANY":U
    THEN DO:
      DELETE ttActionUnderway.
    END.
  END.
  ELSE
    ASSIGN
      plActionUnderway = NO.

  ERROR-STATUS:ERROR = NO.
  RETURN. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getGlobalControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getGlobalControl Procedure 
PROCEDURE getGlobalControl :
/*------------------------------------------------------------------------------
  Purpose:     To return the global control details in the form of a temp-table.
  Parameters:  output table containing single latest global control record
  Notes:       If the temp-table is empty, then it first goes to the appserver
               to read the details and populate the temp-table. 
               On the server, we must always access the database to get the
               information.
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER TABLE FOR ttGlobalControl.

IF (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) OR NOT CAN-FIND(FIRST ttGlobalControl) THEN
DO:
  &IF DEFINED(server-side) <> 0 &THEN
    RUN afgetglocp (OUTPUT TABLE ttGlobalControl).  
  &ELSE
    RUN af/app/afgetglocp.p ON gshAstraAppserver (OUTPUT TABLE ttGlobalControl).
  &ENDIF
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPersistentProcs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPersistentProcs Procedure 
PROCEDURE getPersistentProcs :
/*------------------------------------------------------------------------------
  Purpose:     Retrieve temp-table of running persistent procedures. Used to
               make this available outside the session manager for display in
               a browser.
  Parameters:  output temp table of persistent procedures
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER TABLE FOR ttPersistentProc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-helpAbout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE helpAbout Procedure 
PROCEDURE helpAbout :
/*------------------------------------------------------------------------------
  Purpose:     To Display help about window
  Parameters:  input container procedure handle
  Notes:       Simply uses a showmessage being sute to pass in the container so
               that all the object names and versions are shown in the system
               information.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phContainer  AS HANDLE       NO-UNDO.

DEFINE VARIABLE cButton             AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTextFile           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMessage            AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLine               AS CHARACTER NO-UNDO.
DEFINE VARIABLE cVersion            AS CHARACTER NO-UNDO.

ASSIGN cTextFile = SEARCH("ICFVersion":U)
       cTextFile = IF cTextFile = ? THEN SEARCH("ICFVersion.txt":U)
                                    ELSE cTextFile.

IF cTextFile <> ? THEN
DO:
  ASSIGN cMessage = "":U.
  INPUT FROM VALUE(cTextFile) NO-ECHO.
  REPEAT:
      IMPORT UNFORMATTED cLine.
      ASSIGN cMessage = cMessage + cLine + CHR(10).
  END.
  INPUT CLOSE.
END.
ELSE DO:  /*  If this is a commercial version, the posse version info is not displayed  */
  /* Read the POSSE version from POSSEINFO.XML */
  RUN adecomm/_readpossever.p (OUTPUT cVersion).

  ASSIGN 
    cMessage = cMessage + (IF cMessage = "":U THEN "" ELSE CHR(10)) 
                        + (IF cVersion = "" or cVersion = ? THEN "" ELSE SUBSTITUTE("POSSE Version &1",cVersion)).
    cMessage = cMessage + (IF cMessage = "":U THEN "" ELSE CHR(10)) + "www.possenet.org":U.
END.

RUN showMessages IN gshSessionManager (INPUT cMessage,
                                       INPUT "ABO":U,
                                       INPUT "OK":U,
                                       INPUT "OK":U,
                                       INPUT "OK":U,
                                       INPUT "About Application",
                                       INPUT NOT SESSION:REMOTE,
                                       INPUT phContainer,
                                       OUTPUT cButton).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-helpContents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE helpContents Procedure 
PROCEDURE helpContents :
/*------------------------------------------------------------------------------
  Purpose:     To Display help contents from help file
  Parameters:  input container procedure handle
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phContainer  AS HANDLE       NO-UNDO.

DEFINE VARIABLE cHelpFile           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cHelpFound          AS CHARACTER    NO-UNDO.

ASSIGN
  cHelpFile = "gs~\hlp~\astramodule.chm":U.

IF NOT CAN-FIND(FIRST ttSecurityControl) THEN
DO:
  RUN getSecurityControl IN gshSecurityManager (OUTPUT TABLE ttSecurityControl).
  FIND FIRST ttSecurityControl NO-ERROR.
END.

IF AVAILABLE ttSecurityControl THEN
    ASSIGN cHelpFile = ttSecurityControl.default_help_filename.

ASSIGN cHelpFound = SEARCH(cHelpFile).

IF cHelpFound = ? THEN
  DO:
    DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
    RUN showMessages IN gshSessionManager (INPUT {af/sup2/aferrortxt.i 'AF' '19' '?' '?' 'help' cHelpFile},
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Dynamics Help",
                                           INPUT NOT SESSION:REMOTE,
                                           INPUT phContainer,
                                           OUTPUT cButton).
    RETURN.
  END.
IF INDEX(cHelpFound, ".hlp":U) > 0 THEN  /* Windows help */
  DO:
    SYSTEM-HELP
        cHelpFound
        CONTENTS.
  END.
ELSE                                        /* HTML Help */
  DO:
    DEFINE VARIABLE hwindow AS HANDLE.
    DEFINE VARIABLE hFrame AS HANDLE.

    ASSIGN 
      hWindow = phContainer:CURRENT-WINDOW
      hFrame = hWindow:FIRST-CHILD
      .

    RUN htmlHelpTopic IN gshSessionManager (INPUT hFrame,
                                            INPUT cHelpFound,
                                            INPUT "htm~\helpcontents1.htm":U).
  END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-helpHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE helpHelp Procedure 
PROCEDURE helpHelp :
/*------------------------------------------------------------------------------
  Purpose:     To Display help contents from help file
  Parameters:  input container procedure handle
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phContainer  AS HANDLE       NO-UNDO.

DEFINE VARIABLE cHelpFile           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cHelpFound          AS CHARACTER    NO-UNDO.

ASSIGN
  cHelpFile = "gs~\hlp~\astramodule.chm":U.

IF NOT CAN-FIND(FIRST ttSecurityControl) THEN
DO:
  RUN getSecurityControl IN gshSecurityManager (OUTPUT TABLE ttSecurityControl).
  FIND FIRST ttSecurityControl NO-ERROR.
END.

IF AVAILABLE ttSecurityControl THEN
    ASSIGN cHelpFile = ttSecurityControl.default_help_filename.

ASSIGN cHelpFound = SEARCH(cHelpFile).

IF cHelpFound = ? THEN
  DO:
    DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
    RUN showMessages IN gshSessionManager (INPUT {af/sup2/aferrortxt.i 'AF' '19' '?' '?' 'help' cHelpFile},
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Dynamics Help",
                                           INPUT NOT SESSION:REMOTE,
                                           INPUT phContainer,
                                           OUTPUT cButton).
    RETURN.
  END.
IF INDEX(cHelpFound, ".hlp":U) > 0 THEN  /* Windows help */
  DO:
    SYSTEM-HELP
        cHelpFound
        HELP.
  END.
ELSE                                        /* HTML Help */
  DO:
    DEFINE VARIABLE hwindow AS HANDLE.
    DEFINE VARIABLE hFrame AS HANDLE.

    ASSIGN 
      hWindow = phContainer:CURRENT-WINDOW
      hFrame = hWindow:FIRST-CHILD
      .

    RUN htmlHelpTopic IN gshSessionManager (INPUT hFrame,
                                            INPUT cHelpFound,
                                            INPUT "htm~\astrahelp.htm":U).
  END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-helpTopics) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE helpTopics Procedure 
PROCEDURE helpTopics :
/*------------------------------------------------------------------------------
  Purpose:     To Display help contents from help file
  Parameters:  input container procedure handle
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phContainer  AS HANDLE       NO-UNDO.

DEFINE VARIABLE cHelpFile           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cHelpFound          AS CHARACTER    NO-UNDO.
  
IF NOT CAN-FIND(FIRST ttSecurityControl) THEN
DO:
  RUN getSecurityControl IN gshSecurityManager (OUTPUT TABLE ttSecurityControl).
  FIND FIRST ttSecurityControl NO-ERROR.
END.

IF AVAILABLE ttSecurityControl THEN
    ASSIGN cHelpFile = ttSecurityControl.default_help_filename.

ASSIGN cHelpFound = SEARCH(cHelpFile).
IF cHelpFound = ? THEN
DO:
    DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
    RUN showMessages IN gshSessionManager (INPUT {af/sup2/aferrortxt.i 'AF' '19' '?' '?' 'help' cHelpFile},
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Dynamics Help",
                                           INPUT NOT SESSION:REMOTE,
                                           INPUT phContainer,
                                           OUTPUT cButton).
    RETURN.
END.

/* Will work for both .chm (Compiled HTML) and ,hlp  */
SYSTEM-HELP cHelpFound CONTENTS.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-htmlHelpKeywords) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE htmlHelpKeywords Procedure 
PROCEDURE htmlHelpKeywords :
/*------------------------------------------------------------------------------
  Purpose:     To show a help topics using keyword lookup from a html help file
  Parameters:  input parent handle (frame) or ?
               input help file
               input help keywords
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phParent         AS HANDLE       NO-UNDO.
  DEFINE INPUT PARAMETER pcHelpFile       AS CHARACTER    NO-UNDO.  
  DEFINE INPUT PARAMETER pcHelpKeywords   AS CHARACTER    NO-UNDO.  

  DEFINE VARIABLE        hWndHelp           AS INTEGER      NO-UNDO.
  DEFINE VARIABLE        lpKeywords         AS MEMPTR       NO-UNDO.
  DEFINE VARIABLE        lpHH_AKLINK        AS MEMPTR       NO-UNDO.

  IF NOT VALID-HANDLE(phParent) THEN 
    ASSIGN phParent = CURRENT-WINDOW:HANDLE.

  IF pcHelpKeywords = "":U THEN RETURN.

  IF pcHelpFile = "":U THEN ASSIGN pcHelpFile = "gs/hlp/astramodule.chm":U.

  /* first use HH_DISPLAY_TOPIC to initialize the help window */
  RUN ShowHelpTopic (phParent, pcHelpFile, "":U).

  /* if succeeded then use HH_KEYWORD_LOOKUP */
  SET-SIZE (lpKeywords)     = length(pcHelpKeywords) + 2.
  PUT-STRING(lpKeywords, 1) = pcHelpKeywords.
  SET-SIZE (lpHH_AKLINK)    = 32.
  PUT-LONG (lpHH_AKLINK, 1) = GET-SIZE(lpHH_AKLINK).
  PUT-LONG (lpHH_AKLINK, 5) = INT(FALSE). /* reserved, always FALSE */
  PUT-LONG (lpHH_AKLINK, 9) = GET-POINTER-VALUE(lpKeywords).
  PUT-LONG (lpHH_AKLINK,13) = 0.          /* pszUrl      */
  PUT-LONG (lpHH_AKLINK,17) = 0.          /* pszMsgText  */
  PUT-LONG (lpHH_AKLINK,21) = 0.          /* pszMsgTitle */
  PUT-LONG (lpHH_AKLINK,25) = 0.          /* pszWindow   */
  PUT-LONG (lpHH_AKLINK,29) = INT(TRUE).  /* fIndexOnFail */

  RUN HtmlHelpA( phParent:Hwnd ,
                 pcHelpFile, 
                 {&HH_KEYWORD_LOOKUP},
                 GET-POINTER-VALUE(lpHH_AKLINK), 
                 OUTPUT hWndHelp).
  SET-SIZE (lpHH_AKLINK) = 0.
  SET-SIZE (lpKeywords) = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-htmlHelpTopic) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE htmlHelpTopic Procedure 
PROCEDURE htmlHelpTopic :
/*------------------------------------------------------------------------------
  Purpose:     To show a specific help topic in a html help file
  Parameters:  input parent handle (frame) or ?
               input help file
               input help topic
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phParent         AS HANDLE       NO-UNDO.
DEFINE INPUT PARAMETER pcHelpfile       AS CHARACTER    NO-UNDO.  
DEFINE INPUT PARAMETER pcHelpTopic      AS CHARACTER    NO-UNDO.  

DEFINE VARIABLE        hWndHelp         AS INTEGER      NO-UNDO.

IF NOT VALID-HANDLE(phParent) THEN 
  ASSIGN phParent = CURRENT-WINDOW:HANDLE.

IF pcHelpfile = "":U THEN ASSIGN pcHelpfile = "gs/hlp/astramodule.chm":U.

IF pcHelpTopic <> "":U THEN
  ASSIGN pcHelpTopic = "::/":U + pcHelpTopic + (IF INDEX(pcHelpTopic,".":U) > 0 THEN "":U ELSE ".htm":U).

RUN HtmlHelpA( phParent:HWND,
               pcHelpfile + pcHelpTopic, 
               {&HH_DISPLAY_TOPIC},
               0, 
               OUTPUT hWndHelp).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlips) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlips Procedure 
PROCEDURE killPlips :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to shutdown plips cleanly, forcing correct update of
               the running procedures temp-table.
  Parameters:  input CHR(3) delimited list of plip names to kill
               input CHR(3) delimited list of plip handles to kill
  Notes:       Only one of the parameters is required, depending on whether
               the plip name or the plip handle is known. A combination can
               be passed in if required.
               Note if plip names are used, the full plip name including relative
               path and .p extension must be specified, as was specified when the
               plip was launched.
               Copes with killing Astra 1 and ICF plips, plus non standard plips.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcPlipNames               AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcPlipHandles             AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iLoop                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE hPlip                             AS HANDLE     NO-UNDO.
DEFINE VARIABLE cPlipName                         AS CHARACTER  NO-UNDO.

/* first add plip handle filenames to plip names */
IF pcPlipHandles <> "":U THEN
handle-loop:
DO iLoop = 1 TO NUM-ENTRIES(pcPlipHandles, CHR(3)):
  ASSIGN hPlip = WIDGET-HANDLE(ENTRY(iLoop, pcPlipHandles, CHR(3))) NO-ERROR.
  ASSIGN cPlipName = "":U.
  IF VALID-HANDLE(hPlip) THEN ASSIGN cPlipName = hPlip:FILE-NAME NO-ERROR.
  IF cPlipName <> "":U THEN
    ASSIGN
      pcPlipNames = pcPlipNames + (IF pcPlipNames <> "":U THEN CHR(3) ELSE "":U) +
                                  cPlipName.
END.

/* then loop around and kill them */
IF pcPlipNames <> "":U THEN
name-loop:
DO iLoop = 1 TO NUM-ENTRIES(pcPlipNames, CHR(3)):
  FOR EACH ttPersistentProc
     WHERE ttPersistentProc.physicalName = ENTRY(iLoop, pcPlipNames, CHR(3))
       AND ttPersistentProc.procedureType <> "MAN":U: 

      /* ICF Procedure */
      IF DYNAMIC-FUNCTION("getInternalEntryExists":U, ttPersistentProc.ProcedureHandle, "killPlip":U) THEN
          RUN killPlip IN ttPersistentProc.ProcedureHandle.
      ELSE
      IF VALID-HANDLE(ttPersistentProc.ProcedureHandle) THEN
      DO:
        DELETE PROCEDURE ttPersistentProc.ProcedureHandle.
        DELETE ttPersistentProc.
      END.
  END.
END.  /* name-loop */

/* Finally, just to be sure, zap any handles STILL valid if handles passed in */
IF pcPlipHandles <> "":U THEN
handle-loop2:
DO iLoop = 1 TO NUM-ENTRIES(pcPlipHandles, CHR(3)):
  ASSIGN hPlip = WIDGET-HANDLE(ENTRY(iLoop, pcPlipHandles, CHR(3))) NO-ERROR.
  IF hPlip = gshSessionManager OR
     hplip = gshProfileManager OR
     hplip = gshTranslationManager OR
     hplip = gshSecurityManager OR
     hplip = gshRepositoryManager THEN NEXT handle-loop2.
  IF DYNAMIC-FUNCTION("getInternalEntryExists":U, hPlip, "killPlip":U ) THEN
    RUN killPlip IN hPlip.
  ELSE
  IF VALID-HANDLE(hPlip) THEN
    DELETE PROCEDURE hPlip.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killProcedure Procedure 
PROCEDURE killProcedure :
/*------------------------------------------------------------------------------
  Purpose:     To remove a procedure from the temp-table of running procedures
  Parameters:  input physical object filename (with path and extension)
               input logical object name if applicable and known
               input child data key if applicable
               input run attribute if required to post into container run
               input on appserver flag YES/NO
  Notes:       This is used to remove all types of procedures from the 
               temp-table as launched by the launchContainer and the
               launchProcedure procedures.
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcPhysicalName    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcLogicalName     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcChildDataKey    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcRunAttribute    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER plOnAppserver     AS LOGICAL   NO-UNDO.

DEFINE VARIABLE         lOnAppserver      AS LOGICAL   NO-UNDO.

FOR EACH ttPersistentProc
   WHERE ttPersistentProc.physicalName = pcPhysicalName
     AND ttPersistentProc.logicalName = pcLogicalName
     AND ttPersistentProc.runAttribute = pcRunAttribute
     AND ttPersistentProc.childDataKey = pcChildDataKey
     AND ttPersistentProc.onAppserver = plOnAppserver:
  DELETE ttPersistentProc.
END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchContainer Procedure 
PROCEDURE launchContainer :
/*------------------------------------------------------------------------------
  Purpose:     To launch an Astra 1 and ICF container object, dealing with whether it
               is already running and whether the existing instance should be
               replaced or a new instance run. The temp-table of running
               persistent procedures is updated with the appropriate details.
  Parameters:  input object filename if do not know physical/logical names
               input physical object name (with path and extension) if known
               input logical object name if applicable and known
               input once only flag YES/NO
               input instance attributes to pass to container
               input child data key if applicable
               input run attribute if required to post into container run
               input container mode, e.g. modify, view, add or copy
               input parent (caller) window handle if known (container window handle)
               input parent (caller) procedure handle if known (container procedure handle)
               input parent (caller) object handle if known (handle at end of toolbar link, e.g. browser)
               output procedure handle of object run/running
               output procedure type (e.g ADM1, Astra1, ADM2, ICF, "")
  Notes:       See astraenvironment.doc or help file for detailed explanation of 
               what this procedure does.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcObjectFileName     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcPhysicalName       AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcLogicalName        AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER plOnceOnly           AS LOGICAL   NO-UNDO.
DEFINE INPUT  PARAMETER pcInstanceAttributes AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcChildDataKey       AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcRunAttribute       AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcContainerMode      AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER phParentWindow       AS HANDLE    NO-UNDO.
DEFINE INPUT  PARAMETER phParentProcedure    AS HANDLE    NO-UNDO.
DEFINE INPUT  PARAMETER phObjectProcedure    AS HANDLE    NO-UNDO.
DEFINE OUTPUT PARAMETER phProcedureHandle    AS HANDLE    NO-UNDO.
DEFINE OUTPUT PARAMETER pcProcedureType      AS CHARACTER NO-UNDO.

DEFINE VARIABLE lAlreadyRunning           AS LOGICAL    NO-UNDO.                            
DEFINE VARIABLE lRunSuccessful            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cProcedureDesc            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cButtonPressed            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lMultiInstanceSupported   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cLaunchContainer          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cContainerSuperProcedure  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hWindow                   AS HANDLE     NO-UNDO.

/* If object filename passed in, get logical and physical object names */
IF pcObjectFileName <> "":U THEN
DO:
  RUN getObjectNames IN gshRepositoryManager (
      INPUT  pcObjectFileName,
      OUTPUT pcPhysicalName,
      OUTPUT pcLogicalName).
  
END.

/* If objects do not exist, give an error */
IF pcPhysicalName = "":U THEN
DO:
  IF pcLogicalName <> "":U THEN
    ASSIGN cLaunchContainer = pcLogicalName.
  ELSE
    ASSIGN cLaunchContainer = pcObjectFileName.

  DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
  RUN showMessages IN gshSessionManager (INPUT {af/sup2/aferrortxt.i 'RY' '6' '?' '?' cLaunchContainer},
                                         INPUT "ERR":U,
                                         INPUT "OK":U,
                                         INPUT "OK":U,
                                         INPUT "OK":U,
                                         INPUT "Launch Container",
                                         INPUT NOT SESSION:REMOTE,
                                         INPUT ?,
                                         OUTPUT cButton).
  ASSIGN
    phProcedureHandle = ?
    pcProcedureType = "":U
    .
  RETURN.
END.


ASSIGN
  cProcedureDesc = "":U
  lAlreadyRunning = NO
  lRunSuccessful = NO
  phProcedureHandle = ?
  pcProcedureType = "CON":U.

/* regardless of once only flag, see if already running as it may be an object
   that does not support multiple instances.
*/
FIND FIRST ttPersistentProc
     WHERE ttPersistentProc.physicalName = pcPhysicalName
       AND ttPersistentProc.logicalName = pcLogicalName
       AND ttPersistentProc.runAttribute = pcRunAttribute
       AND ttPersistentProc.childDataKey = pcChildDataKey
     NO-ERROR.
IF NOT AVAILABLE ttPersistentProc THEN
FIND FIRST ttPersistentProc
     WHERE ttPersistentProc.physicalName = pcPhysicalName
       AND ttPersistentProc.logicalName = pcLogicalName
       AND ttPersistentProc.runAttribute = pcRunAttribute
       AND ttPersistentProc.childDataKey = "":U
     NO-ERROR.
/* check handle still valid */
IF AVAILABLE ttPersistentProc AND
   (NOT VALID-HANDLE(ttPersistentProc.procedureHandle) OR
    ttPersistentProc.ProcedureHandle:UNIQUE-ID <> ttPersistentProc.UniqueId) THEN
DO:
  DELETE ttPersistentProc.
END.

IF AVAILABLE ttPersistentProc THEN
DO:
  ASSIGN
    lAlreadyRunning = YES
    phProcedureHandle = ttPersistentProc.ProcedureHandle
    pcChildDataKey = ttPersistentProc.childDataKey.       
END.

/* check in running instance if multiple instances supported */
ASSIGN
  lMultiInstanceSupported = YES.

IF VALID-HANDLE(phProcedureHandle)
   AND LOOKUP("getMultiInstanceSupported", phProcedureHandle:INTERNAL-ENTRIES) <> 0 THEN
  lMultiInstanceSupported = DYNAMIC-FUNCTION('getMultiInstanceSupported' IN phProcedureHandle) = "YES":U NO-ERROR.

/* if no support for multiple instances, force a single instance */
/* IF NOT lMultiInstanceSupported THEN ASSIGN plOnceOnly = YES. */

/* if not a valid handle or not once only, then run it */
IF NOT VALID-HANDLE(phProcedureHandle) OR NOT plOnceOnly THEN
DO:
  ASSIGN
    lAlreadyRunning = NO.

  /* run the procedure */      
  SESSION:SET-WAIT-STATE('general':U).
  RUN-BLOCK:
  DO ON STOP UNDO RUN-BLOCK, LEAVE RUN-BLOCK ON ERROR UNDO RUN-BLOCK, LEAVE RUN-BLOCK:
    RUN VALUE(pcPhysicalName) PERSISTENT SET phProcedureHandle.
  END.
  IF NOT VALID-HANDLE(phProcedureHandle) THEN
  DO:
    SESSION:SET-WAIT-STATE('':U).
    ASSIGN phProcedureHandle = ?.
  END.

  /* Add the container's super procedure, if any. */  
  IF VALID-HANDLE(phProcedureHandle) THEN
  DO:
      ASSIGN cContainerSuperProcedure = "":U.
      
      RUN getObjectSuperProcedure IN gshRepositoryManager ( INPUT  (IF pcLogicalName NE "":U THEN pcLogicalName ELSE pcPhysicalName),
                                                            OUTPUT cContainerSuperProcedure).

      /* Make sure that the custom super procedure exists. */
      IF SEARCH(cContainerSuperProcedure)                          NE ? OR
         SEARCH(REPLACE(cContainerSuperProcedure, ".p":U, ".r":U)) NE ? THEN
      DO:
          { af/sup2/aflaunch.i
              &PLIP  = cContainerSuperProcedure
              &OnApp = 'NO'
              &Iproc = ''
          }
          IF VALID-HANDLE(hPlip) THEN
              phProcedureHandle:ADD-SUPER-PROCEDURE(hPlip, SEARCH-TARGET).
      END.    /* add super procedure */
  END.    /* valid handle */

  /* work out the procedure type of the object run / running */
  IF VALID-HANDLE(phProcedureHandle) AND 
     LOOKUP( "dispatch":U, phProcedureHandle:INTERNAL-ENTRIES ) <> 0 THEN
    ASSIGN pcProcedureType = "ADM1":U.
  IF VALID-HANDLE(phProcedureHandle) AND 
     LOOKUP( "getobjectversion":U, phProcedureHandle:INTERNAL-ENTRIES ) <> 0 THEN
    ASSIGN pcProcedureType = "ADM2":U.
  IF VALID-HANDLE(phProcedureHandle) AND 
     LOOKUP( "getLogicalObjectName":U, phProcedureHandle:INTERNAL-ENTRIES ) <> 0 THEN
    ASSIGN pcProcedureType = "ICF":U.

  /* set initial attributes in object */
  IF VALID-HANDLE (phProcedureHandle) AND
     (pcProcedureType = "ICF":U OR pcProcedureType = "ADM2":U) THEN
  DO:   
      RUN setAttributesInObject IN gshSessionManager (INPUT phProcedureHandle, 
                                                      INPUT pcInstanceAttributes).
  END.

END.

/* turn egg timer off */
IF VALID-HANDLE(phProcedureHandle) THEN
DO:
  SESSION:SET-WAIT-STATE('':U).
END.

/* see if handle now valid and if so, update temp-table with details */        
IF VALID-HANDLE(phProcedureHandle) THEN
DO:
  FIND FIRST ttPersistentProc
       WHERE ttPersistentProc.physicalName = pcPhysicalName
         AND ttPersistentProc.logicalName = pcLogicalName
         AND ttPersistentProc.runAttribute = pcRunAttribute
         AND ttPersistentProc.childDataKey = pcChildDataKey
       NO-ERROR.

    /* Create a new entry in the temp-table if the procedure is not yet running, or
     * if this is an additional instance of a container. This will only happen if
     * the call specifies that the container should be a multiple instance.         */
  IF NOT AVAILABLE ttPersistentProc OR
     ( AVAILABLE ttPersistentProc AND NOT plOnceOnly ) THEN
  DO:
    CREATE ttPersistentProc.
    ASSIGN
      ttPersistentProc.physicalName = pcPhysicalName
      ttPersistentProc.logicalName = pcLogicalName
      ttPersistentProc.runAttribute = pcRunAttribute
      ttPersistentProc.childDataKey = pcChildDataKey
      ttPersistentProc.procedureType = pcProcedureType
      ttPersistentProc.onAppserver = NO
      ttPersistentProc.multiInstanceSupported = lMultiInstanceSupported
      ttPersistentProc.currentOperation = pcContainerMode
      ttPersistentProc.startDate = TODAY
      ttPersistentProc.startTime = TIME
      ttPersistentProc.procedureVersion = "":U
      ttPersistentProc.procedureNarration = "":U.
  END.

  /* try and get object version number */
  IF VALID-HANDLE(phProcedureHandle)
     AND LOOKUP("getLogicalVersion", phProcedureHandle:INTERNAL-ENTRIES) <> 0 THEN
    ttPersistentProc.procedureVersion = DYNAMIC-FUNCTION('getLogicalVersion' IN phProcedureHandle) NO-ERROR.
  ELSE IF LOOKUP( "mip-get-object-version":U, phProcedureHandle:INTERNAL-ENTRIES ) <> 0 THEN
      RUN mip-get-object-version IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration,
                                                       OUTPUT ttPersistentProc.procedureVersion).
  /* try and get object description from standard internal procedure */
  IF LOOKUP( "objectDescription":U, phProcedureHandle:INTERNAL-ENTRIES ) <> 0 THEN
      RUN objectDescription IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration).
  ELSE IF LOOKUP( "mip-object-description":U, phProcedureHandle:INTERNAL-ENTRIES ) <> 0 THEN
      RUN mip-object-description IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration).

  /* reset procedure handle, unique id, etc. */
  ASSIGN
    ttPersistentProc.ProcedureHandle = phProcedureHandle
    ttPersistentProc.uniqueId = phProcedureHandle:UNIQUE-ID
    ttPersistentProc.RunPermanent = NO
    lRunSuccessful = YES.       

  IF pcProcedureType = "ICF":U THEN
  DO:
    IF lAlreadyRunning THEN
    DO:
        DEFINE VARIABLE hOldContainerSource AS HANDLE NO-UNDO.
        {get ContainerSource hOldContainerSource phProcedureHandle}.
        IF VALID-HANDLE(hOldContainerSource) THEN 
            RUN removeLink IN phParentProcedure (INPUT hOldContainerSource, INPUT "container", INPUT phProcedureHandle).
    END.
    RUN addLink IN phParentProcedure (INPUT phParentProcedure, INPUT "Container", INPUT phProcedureHandle).                              

    /* set the parent window */
    {set ObjectParent phParentWIndow phProcedureHandle}.

    /* give it the run attribute */
    IF pcRunAttribute <> "":U AND VALID-HANDLE(phProcedureHandle) AND 
       LOOKUP("setRunAttribute", phProcedureHandle:INTERNAL-ENTRIES) <> 0 THEN
    DO:
      DYNAMIC-FUNCTION('setRunAttribute' IN phProcedureHandle, pcRunAttribute).
    END.

    /* Object launched ok, set logical object name attribute to correct value if
       required
    */
    IF VALID-HANDLE(phProcedureHandle) AND pcLogicalName <> "":U 
       AND LOOKUP("setLogicalObjectName", phProcedureHandle:INTERNAL-ENTRIES) <> 0 THEN
    DO:
      DYNAMIC-FUNCTION('setLogicalObjectName' IN phProcedureHandle, INPUT pcLogicalName).
    END.

    /* perform the required pre-initialization work */

    RUN createLinks (
        INPUT pcPhysicalName,
        INPUT phProcedureHandle,
        INPUT phObjectProcedure,
        INPUT lAlreadyRunning).

    /* set correct container mode before initialize object */
    IF pcContainerMode <> "":U AND VALID-HANDLE(phProcedureHandle) 
       AND LOOKUP("setContainerMode", phProcedureHandle:INTERNAL-ENTRIES) <> 0 THEN
    DO:
      DYNAMIC-FUNCTION('setContainerMode' IN phProcedureHandle, INPUT pcContainerMode).
    END.

    /* set caller attributes in container just launched */
    IF phObjectProcedure <> ? AND VALID-HANDLE(phProcedureHandle) 
       AND LOOKUP("setCallerObject", phProcedureHandle:INTERNAL-ENTRIES) <> 0 THEN
    DO:
      DYNAMIC-FUNCTION('setCallerObject' IN phProcedureHandle, INPUT phObjectProcedure).
    END.
    IF phParentProcedure <> ? AND VALID-HANDLE(phProcedureHandle) 
       AND LOOKUP("setCallerProcedure", phProcedureHandle:INTERNAL-ENTRIES) <> 0 THEN
    DO:
      DYNAMIC-FUNCTION('setCallerProcedure' IN phProcedureHandle, INPUT phParentProcedure).
    END.
    IF phParentWindow <> ? AND VALID-HANDLE(phProcedureHandle) 
       AND LOOKUP("setCallerWindow", phProcedureHandle:INTERNAL-ENTRIES) <> 0 THEN
    DO:
      DYNAMIC-FUNCTION('setCallerWindow' IN phProcedureHandle, INPUT phParentWindow).
    END.

    /* Initialize the run object */
    IF VALID-HANDLE(phProcedureHandle) 
       AND LOOKUP("initializeObject", phProcedureHandle:INTERNAL-ENTRIES) <> 0 THEN
    DO:
      RUN initializeObject IN phProcedureHandle.
    END.

  END.  /* END ICF code */
      /* If ADM2 Container */
  IF VALID-HANDLE(phprocedureHandle) AND
     (pcProcedureType = "ADM2":U OR pcProcedureType = "ICF":U) AND 
        LOOKUP("viewObject":U, phprocedureHandle:INTERNAL-ENTRIES) > 0 THEN
    RUN viewObject IN phprocedureHandle.
  ELSE IF VALID-HANDLE(phprocedureHandle) THEN
  DO: 
    /* For non adm2 container, bring container to front or restore if minimized and apply focus */
    ASSIGN hWindow = phProcedureHandle:CURRENT-WINDOW NO-ERROR. 
    IF VALID-HANDLE(hWindow) THEN
    DO:  
      IF hWindow:WINDOW-STATE = WINDOW-MINIMIZED THEN
         hWindow:WINDOW-STATE = WINDOW-NORMAL.
      hWindow:MOVE-TO-TOP().
      APPLY "ENTRY":U TO hWindow.
    END.
  END. /* END non adm2 container */
END. /* END IF VALID-HANDLE(phProcedureHandle) */
ELSE
DO:
  ASSIGN
    lAlreadyRunning = NO
    lRunSuccessful = NO
    phProcedureHandle = ?
    pcProcedureType = "":U
    .       
END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-LaunchExternalProcess) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LaunchExternalProcess Procedure 
PROCEDURE LaunchExternalProcess :
/*------------------------------------------------------------------------------
  Purpose:     To launch an external process
  Parameters:  input command line, e.g. "notepad.exe"
               input default directory for the process
               input show window flag, 0 (Hidden) / 1 (Normal) / 2 (Minimised) / 3 (Maximised)
               output result, 0 (Failure) / Non-zero (Handle of new process)

  Notes:       Uses the CreateProcess API function from af/sup/windows.i
------------------------------------------------------------------------------*/
IF (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN RETURN.

DEFINE INPUT  PARAMETER pcCommandLine         AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcCurrentDirectory    AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER piShowWindow          AS INTEGER      NO-UNDO.
DEFINE OUTPUT PARAMETER piResult              AS INTEGER      NO-UNDO.

DEFINE VARIABLE pmStartupInfoPointer          AS MEMPTR       NO-UNDO.
DEFINE VARIABLE pmProcessInfoPointer          AS MEMPTR       NO-UNDO.
DEFINE VARIABLE pmCurrentDirPointer           AS MEMPTR       NO-UNDO.
DEFINE VARIABLE iResult                       AS INTEGER      NO-UNDO.

SET-SIZE(  pmStartupInfoPointer     ) = 68.
PUT-LONG(  pmStartupInfoPointer,  1 ) = 68.
PUT-LONG(  pmStartupInfoPointer, 45 ) = 1.   /* = STARTF_USESHOWWINDOW */
PUT-SHORT( pmStartupInfoPointer, 49 ) = piShowWindow.

SET-SIZE( pmProcessInfoPointer ) = 16.

IF pcCurrentDirectory <> "":U THEN
  DO:
    SET-SIZE(   pmCurrentDirPointer    ) = 256.
    PUT-STRING( pmCurrentDirPointer, 1 ) = pcCurrentDirectory.
  END.


RUN CreateProcess{&A} IN hpApi
 ( 0,
   pcCommandLine,
   0,
   0,
   0,
   0,
   0,
   IF pcCurrentDirectory = "":U
      THEN 0
      ELSE GET-POINTER-VALUE( pmCurrentDirPointer ),
   GET-POINTER-VALUE( pmStartupInfoPointer ),
   GET-POINTER-VALUE( pmProcessInfoPointer ),
   OUTPUT iResult
 ).

DEFINE VARIABLE iProcessHandle   AS INTEGER  NO-UNDO.
ASSIGN
  iProcessHandle = GET-LONG( pmProcessInfoPointer, 1 ).

SET-SIZE( pmStartupInfoPointer ) = 0.
SET-SIZE( pmProcessInfoPointer ) = 0.
SET-SIZE( pmCurrentDirPointer  ) = 0.

ASSIGN
    piResult = iProcessHandle.

RELEASE EXTERNAL PROCEDURE "kernel32".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchProcedure Procedure 
PROCEDURE launchProcedure :
/*------------------------------------------------------------------------------
  Purpose:     To launch a business logic procedure / manager procedure.
               Deals with whether the procedure is already running and whether
               the existing instance should be replaced or a new instance run.
               Also deals with connecting to appserver partition if required.
               The temp-table of running persistent procedures is updated with
               the appropriate details.
  Parameters:  input physical object filename (with path and extension)
               input once only flag YES/NO (default = YES)
               input run on appserver flag YES/NO/APPSERVER
               input appserver partition name to run on
               input run permanent flag YES/NO, default is NO
               output procedure handle of object run/running
  Notes:       If the once only flag is passed in as YES, then the procedure will
               check for an already running instance and use this if possible. 
               If the run permanent flag is passed in as YES, then this procedure
               will not be automatically killed when an Appserver agent is
               deactivated. Ordinarily this flag should be NO and all procedures
               left running should be deleted at the end of an appserver request by
               the deactivation routine. When procedures are closed down corerectly,
               they are removed from the temp-table and deleted - this behaviour is just
               to tidy up any procedures started outside of this control procedure, or
               shutdown incorrectly for some reason.
               If the appserver flag is passed in as APPSERVER, then this procedure
               may ONLY be run on appserver. If the flag is YES and no Appserver
               partition is passed in, then "Astra" will be defaulted and the session
               handle gshAstraAppserver handle used for the Appserver.
               If the partition is passed in as anthing other than Astra and the Appserver
               flag is not NO, then the partition is connected if required. Any
               partitions connected in this way will be disconnected by the shutdown
               procedure af/sup2/afshutdwnp.p.
               Do not ordinarily need to run this procedure for managers as their
               handles are available via system wide global shared variables. We do
               however initially use this for the managers when they are first run to
               add them to the temp-table of running persistent procedures.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcPhysicalName        AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plOnceOnly            AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER pcOnAppserver         AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcAppserverPartition  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plRunPermanent        AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER phProcedureHandle     AS HANDLE     NO-UNDO.

DEFINE VARIABLE lAlreadyRunning               AS LOGICAL    NO-UNDO.                            
DEFINE VARIABLE lRunSuccessful                AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cProcedureType                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProcedureDesc                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cButtonPressed                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hAppserver                    AS HANDLE     NO-UNDO.

/* Variables for Appserver connection */
DEFINE VARIABLE lASUsePrompt                  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cASInfo                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAsDivision                   AS CHARACTER  NO-UNDO.    

ASSIGN
    cAsDivision = "CLIENT"    /* Client appserver connection */
    lAsUsePrompt = NO
    cAsInfo = "".

/* check for pre-started managers running */
CASE pcPhysicalName:
  WHEN "af/sup2/afproclnt.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Client Profile Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshProfileManager
      .
  END.
  WHEN "af/app/afprosrvrp.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Server Profile Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshProfileManager
      .
  END.
  WHEN "af/sup2/afsecclnt.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Client Security Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshSecurityManager
      .
  END.
  WHEN "af/app/afsecsrvrp.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Server Security Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshSecurityManager
      .
  END.
  WHEN "af/sup2/afsesclnt.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Client Session Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshSessionManager
      .
  END.
  WHEN "af/app/afsessrvrp.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Server Session Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshSessionManager
      .
  END.
  WHEN "af/sup2/aftrnclnt.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Client Translation Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshTranslationManager
      .
  END.
  WHEN "af/app/aftrnsrvrp.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Server Translation Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshTranslationManager
      .
  END.
  WHEN "ry/prc/ryrepclnt.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Client Repository Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshRepositoryManager
      .
  END.
  WHEN "ry/app/ryprosrvrp.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Server Repository Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshRepositoryManager
      .
  END.
  OTHERWISE
  DO:
    ASSIGN
      cProcedureType = "PRO":U
      cProcedureDesc = "":U
      lAlreadyRunning = NO
      lRunSuccessful = NO
      phProcedureHandle = ?
      .
  END.
END CASE.

/* default to astra appserver partition */
IF pcAppserverPartition = "":U AND pcOnAppserver <> "NO":U THEN 
  ASSIGN pcAppserverPartition = "Astra":U.

/* check if Appserver connected and get handle to it */
IF pcOnAppserver <> "NO":U AND NOT VALID-HANDLE(phProcedureHandle) THEN
DO:
  IF pcAppserverPartition = "Astra":U THEN
    ASSIGN hAppserver = gshAstraAppserver.
  ELSE
  DO:
    RUN appServerConnect(INPUT  pcAppserverPartition, 
                         INPUT  IF NOT lASUsePrompt THEN ? ELSE lASUsePrompt,
                         INPUT  IF cASInfo NE "":U THEN cASInfo ELSE ?, 
                         OUTPUT hAppserver).                                       
  END.
END.

/* if can only run on appserver and appserver not connected, return a null handle */
IF NOT VALID-HANDLE(phProcedureHandle) AND NOT VALID-HANDLE(hAppserver) AND pcOnAppserver = "APPSERVER":U THEN
DO:
  ASSIGN phProcedureHandle = ?.
  RETURN ERROR "Could not connect to Appserver Partition: " + pcAppserverPartition. 
END.

IF NOT VALID-HANDLE(hAppserver) THEN
  ASSIGN hAppserver = SESSION:HANDLE.

/* if handle not already valid (not a manager) - then run it if not already running 
   or want multiple instances
*/
IF NOT VALID-HANDLE(phProcedureHandle) THEN
DO:
  IF plOnceOnly THEN
  DO:
    IF pcOnAppserver <> "NO":U AND VALID-HANDLE(hAppserver) AND hAppserver <> SESSION:HANDLE THEN
      FIND FIRST ttPersistentProc
           WHERE ttPersistentProc.physicalName = pcPhysicalName
             AND ttPersistentProc.logicalName = "":U
             AND ttPersistentProc.runAttribute = "":U
             AND ttPersistentProc.childDataKey = "":U
             AND ttPersistentProc.onAppserver = YES
           NO-ERROR.
    ELSE
      FIND FIRST ttPersistentProc
           WHERE ttPersistentProc.physicalName = pcPhysicalName
             AND ttPersistentProc.logicalName = "":U
             AND ttPersistentProc.runAttribute = "":U
             AND ttPersistentProc.childDataKey = "":U
             AND ttPersistentProc.onAppserver = NO
           NO-ERROR.
    /* check handle still valid */
    IF AVAILABLE ttPersistentProc AND
       (NOT VALID-HANDLE(ttPersistentProc.procedureHandle) OR
        ttPersistentProc.ProcedureHandle:UNIQUE-ID <> ttPersistentProc.UniqueId) THEN
    DO:
      DELETE ttPersistentProc.
    END.

    IF AVAILABLE ttPersistentProc THEN
    DO:
      ASSIGN
        lAlreadyRunning = YES
        lRunSuccessful = YES
        phProcedureHandle = ttPersistentProc.ProcedureHandle
        .       
    END.
  END. /* IF plOnceOnly */

  /* if still not a valid handle, then run it */
  IF NOT VALID-HANDLE(phProcedureHandle) THEN
  DO:
    /* run the procedure */      
    RUN-BLOCK:
    DO ON STOP UNDO RUN-BLOCK, LEAVE RUN-BLOCK ON ERROR UNDO RUN-BLOCK, LEAVE RUN-BLOCK:
      RUN VALUE(pcPhysicalName) PERSISTENT SET phProcedureHandle ON hAppserver.
    END.
  END.
END. 

/* see if handle now valid and if so, update temp-table with details */        
IF VALID-HANDLE(phProcedureHandle) THEN
DO:
  IF pcOnAppserver <> "NO":U AND VALID-HANDLE(hAppserver) AND hAppserver <> SESSION:HANDLE THEN
    FIND FIRST ttPersistentProc
         WHERE ttPersistentProc.physicalName = pcPhysicalName
           AND ttPersistentProc.logicalName = "":U
           AND ttPersistentProc.runAttribute = "":U
           AND ttPersistentProc.childDataKey = "":U
           AND ttPersistentProc.onAppserver = YES
         NO-ERROR.
  ELSE
    FIND FIRST ttPersistentProc
         WHERE ttPersistentProc.physicalName = pcPhysicalName
           AND ttPersistentProc.logicalName = "":U
           AND ttPersistentProc.runAttribute = "":U
           AND ttPersistentProc.childDataKey = "":U
           AND ttPersistentProc.onAppserver = NO
         NO-ERROR.
    /* Create a new entry in the temp-table if the procedure is not yet running, or
     * if this is an additional instance of a procedure. This will only happen if
     * the call specifies that the procedure should be a multiple instance.         */
  IF NOT AVAILABLE ttPersistentProc OR
     ( AVAILABLE ttPersistentProc AND NOT plOnceOnly ) THEN
  DO:
    CREATE ttPersistentProc.
    ASSIGN
      ttPersistentProc.physicalName = pcPhysicalName
      ttPersistentProc.logicalName = "":U
      ttPersistentProc.runAttribute = "":U
      ttPersistentProc.childDataKey = "":U
      ttPersistentProc.procedureType = cProcedureType
      ttPersistentProc.onAppserver = (IF pcOnAppserver <> "NO":U AND VALID-HANDLE(hAppserver) AND hAppserver <> SESSION:HANDLE THEN YES ELSE NO)
      ttPersistentProc.multiInstanceSupported = YES
      ttPersistentProc.currentOperation = "":U
      ttPersistentProc.startDate = TODAY
      ttPersistentProc.startTime = TIME
      ttPersistentProc.procedureVersion = "":U
      ttPersistentProc.procedureNarration = "":U
      .    

    /* try and get object version number */
      IF DYNAMIC-FUNCTION("getInternalEntryExists":U, phProcedureHandle, "getObjectVersion":U) THEN
          RUN getObjectVersion IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration,
                                                     OUTPUT ttPersistentProc.procedureVersion).
      ELSE
      IF DYNAMIC-FUNCTION("getInternalEntryExists":U, phProcedureHandle, "mip-get-object-version":U) THEN
          RUN mip-get-object-version IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration,
                                                           OUTPUT ttPersistentProc.procedureVersion).

      /* try and get object description from standard internal procedure */
      IF DYNAMIC-FUNCTION("getInternalEntryExists":U, phProcedureHandle, "objectDescription":U) THEN
          RUN objectDescription IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration).
      ELSE
      IF DYNAMIC-FUNCTION("getInternalEntryExists":U, phProcedureHandle, "mip-object-description":U) THEN
          RUN mip-object-description IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration).

      /* use manager hard coded description */
      IF ttPersistentProc.procedureNarration = "":U AND cProcedureDesc <> "":U THEN
          ASSIGN ttPersistentProc.procedureNarration = cProcedureDesc.  
  END.

  /* always reset procedure handle, unique id and run permanent flag */
  ASSIGN
    ttPersistentProc.ProcedureHandle = phProcedureHandle
    ttPersistentProc.uniqueId = phProcedureHandle:UNIQUE-ID
    ttPersistentProc.RunPermanent = plRunPermanent
    lRunSuccessful = YES
    .       
END. /* IF VALID-HANDLE(phProcedureHandle) */
ELSE
DO:
  ASSIGN
    lAlreadyRunning = NO
    lRunSuccessful = NO
    phProcedureHandle = ?
    .       
END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-notifyUser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE notifyUser Procedure 
PROCEDURE notifyUser :
/*------------------------------------------------------------------------------
  Purpose:     Notify a user of some message by some means, e.g. email
  Parameters:  input Object number of user record to notify
               input User name of user record to notify (used only when obj is 0)
               input Action, e.g. "email"
               input Subject of message
               input Message text
               output failed reason
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  pdUserObj                     AS DECIMAL      NO-UNDO.
DEFINE INPUT PARAMETER  pcUserName                    AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  pcAction                      AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  pcSubject                     AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  pcMessage                     AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcFailedReason                AS CHARACTER    NO-UNDO.

DEFINE VARIABLE         cEmailAddress                 AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         cEmailProfile                 AS CHARACTER    NO-UNDO.

IF pdUserObj = 0 AND pcUserName = "" THEN
DO:
  /* get user email from property for current user */
  cEmailAddress = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                   INPUT "currentUserEmail":U,
                                   INPUT NO).
END.
ELSE
DO:
  /* find user email by reading user record */
  RUN af/app/afgetuserp.p ON gshAstraAppserver (INPUT pdUserObj, INPUT pcUserName, OUTPUT TABLE ttUser).
  FIND FIRST ttUser NO-ERROR.
  IF AVAILABLE ttUser THEN ASSIGN cEmailAddress = ttUser.USER_email_address.
END.

IF cEmailAddress <> "":U AND pcAction = "email":U THEN
  DO:   /* Send email message to user */
    RUN sendEmail IN gshSessionManager
                      ( INPUT cEmailProfile,        /* Email profile to use  */
                        INPUT cEmailAddress,        /* Comma list of Email addresses for to: box */
                        INPUT "":U,                 /* Comma list of Email addresses to cc */
                        INPUT pcSubject,            /* Subject of message */
                        INPUT pcMessage,            /* Message text */
                        INPUT "":U,                 /* Comma list of attachment filenames */
                        INPUT "":U,                 /* Comma list of attachment filenames with full path */
                        INPUT NOT SESSION:REMOTE,   /* YES = display dialog for modification before send */
                        INPUT 0,                    /* Importance 0 = low, 1 = medium, 2 = high */
                        INPUT NO,                   /* YES = return a read receipt */
                        INPUT NO,                   /* YES = return a delivery receipt */
                        INPUT "":U,                 /* Not used yet but could be used for additional settings */
                        OUTPUT pcFailedReason       /* If failed - the reason why, blank = it worked */
                      ).

  END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     Run on close of procedure
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN deletePersistentProc.  /* delete persistent procs started since we started */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-relogon) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE relogon Procedure 
PROCEDURE relogon :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to relogon user, clear caches, etc.
  Parameters:  <none>
  Notes:       If user cancels from login window, then nothing is done.
               If the user presses ok, then details are reset and caches cleared,
               even if the user informationwas the same - this is so that we have
               a facility to clear caches on the fly without exiting the session.
               The user details are reset.
               Status bar information is updated.
               The translations are cleared and re-cached for the new language.
               The cached user profile data for the previous user is flushed to the
               database, and the cache rebuilt for the new user.
               The security cache is cleared
               The repository cache is cleared
------------------------------------------------------------------------------*/

DEFINE VARIABLE cLoginWindow              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dCurrentUserObj           AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cCurrentUserLogin         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentUserName          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentUserEmail         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dCurrentOrganisationObj   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cCurrentOrganisationCode  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentOrganisationName  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentOrganisationShort AS CHARACTER  NO-UNDO.
DEFINE VARIABLE tCurrentProcessDate       AS DATE       NO-UNDO.
DEFINE VARIABLE dCurrentLanguageObj       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cCurrentLanguageName      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentLoginValues       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPropertyList             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValueList                AS CHARACTER  NO-UNDO.

/* 1st get login window in user */
cLoginWindow = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                   INPUT "loginWindow":U,
                                                   INPUT NO).
IF cLoginWindow = "":U THEN RETURN.

RUN VALUE(cLoginWindow)  (INPUT  "Two":U,                       /* Re-login */
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

IF dCurrentUserObj = 0 THEN RETURN.

SESSION:SET-WAIT-STATE('general').

/* 1st flush old user profile cache to db */
RUN updateCacheToDb IN gshProfileManager (INPUT "":U).

/* Re-logged in, so reset details */
IF tCurrentProcessDate = ? THEN ASSIGN tCurrentProcessDate = TODAY.
DEFINE VARIABLE cDateFormat AS CHARACTER NO-UNDO.
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
               cLoginWindow
  .

DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                     INPUT cPropertyList,
                                     INPUT cValueList,
                                     INPUT NO).

/* reset status bars */
PUBLISH 'ClientCachedDataChanged' FROM gshSessionManager.

/* clear caches */
DEFINE VARIABLE cCacheTranslations            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lCacheTranslations            AS LOGICAL    INITIAL YES NO-UNDO.
cCacheTranslations = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                 INPUT "cachedTranslationsOnly":U,
                                 INPUT NO).
lCacheTranslations = cCacheTranslations <> "NO":U NO-ERROR.

/* if caching translations - do so for logged into language */
RUN clearClientCache IN gshTranslationManager.
IF lCacheTranslations THEN
DO:
  RUN buildClientCache IN gshTranslationManager (INPUT dCurrentLanguageObj).
END.

/* Rebuild user profile data */
RUN clearClientCache IN gshProfileManager.
RUN buildClientCache IN gshProfileManager (INPUT "":U). /* load temp-table on client */

/* Clear security manager cache */
RUN clearClientCache IN gshSecurityManager.

/* Clear repository cache */
RUN clearClientCache IN gshRepositoryManager.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeLookupFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeLookupFrame Procedure 
PROCEDURE resizeLookupFrame :
/*------------------------------------------------------------------------------
  Purpose:     To resize lookup SDF frame to fit new labels 
  Parameters:  input object handle
               input SDF frame handle
               input number to add to all columns
  Notes:       called from translatewidgets from widgetwalk procedure
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER phObject           AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER phFrame            AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER pdAddCol           AS DECIMAL    NO-UNDO.

DEFINE VARIABLE cAllFieldHandles          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE hParent                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWindow                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainer                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hViewer                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidget                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSideLabel                AS HANDLE     NO-UNDO.

hViewer = DYNAMIC-FUNCTION("getcontainersource":U IN phObject) NO-ERROR.
IF VALID-HANDLE(hViewer) AND 
   LOOKUP("resizeWindow":U, hViewer:INTERNAL-ENTRIES) = 0 THEN
  hContainer = DYNAMIC-FUNCTION("getcontainersource":U IN hViewer) NO-ERROR.

hWindow = phFrame:WINDOW.
hParent = DYNAMIC-FUNCTION("getcontainerhandle":U IN hViewer) NO-ERROR.
IF hParent:TYPE = "window":U THEN
  hParent = hParent:FIRST-CHILD.

/* 1st make frame virtually big to avoid size issues */
hParent:SCROLLABLE = TRUE.
phFrame:SCROLLABLE = TRUE.
hWindow:VIRTUAL-WIDTH-CHARS  = 204.80.
hWindow:VIRTUAL-HEIGHT-CHARS = 35.67.
phFrame:VIRTUAL-WIDTH-CHARS  = 204.80.
phFrame:VIRTUAL-HEIGHT-CHARS = 35.67.
hParent:VIRTUAL-WIDTH-CHARS  = 204.80.
hParent:VIRTUAL-HEIGHT-CHARS = 35.67.

/* move frame back if we can */
IF phFrame:COLUMN - pdAddCol > 1 THEN
  ASSIGN phFrame:COLUMN = phFrame:COLUMN - pdAddCol.
ELSE
  ASSIGN phFrame:COLUMN = 1.

/* resize window if too small to fit frame (plus a bit for margin) */
IF (phFrame:COLUMN + phFrame:WIDTH-CHARS + pdAddCol) > (hWindow:WIDTH-CHARS - 10) THEN
DO:
  hWindow:WIDTH-CHARS = phFrame:COLUMN + phFrame:WIDTH-CHARS + pdAddCol + 10.
  hWindow:MIN-WIDTH-CHARS = phFrame:COLUMN + phFrame:WIDTH-CHARS + pdAddCol + 10.

  IF VALID-HANDLE(hContainer) AND LOOKUP("resizeWindow":U, hContainer:INTERNAL-ENTRIES) <> 0 THEN
  DO:
    APPLY "window-resized":u TO hWindow.
    RUN resizeWindow IN hContainer.
  END.
END.

/* resize parent frame if too small to fit new SDF frame */
IF (phFrame:COLUMN + phFrame:WIDTH-CHARS + pdAddCol) > (hParent:WIDTH-CHARS) THEN
DO:
  hParent:WIDTH-CHARS = phFrame:COLUMN + phFrame:WIDTH-CHARS + pdAddCol + 1.
END.

/* resize frame to fit new labels */
phFrame:WIDTH-CHARS = phFrame:WIDTH-CHARS + pdAddCol.

/* always ensure min window size set correctly - even if not resized */
IF (hWindow:MIN-WIDTH-CHARS - 10) < (phFrame:WIDTH-CHARS + phFrame:COLUMN) THEN
  ASSIGN hWindow:MIN-WIDTH-CHARS = phFrame:WIDTH-CHARS + phFrame:COLUMN + 10.

cAllFieldHandles = DYNAMIC-FUNCTION("getAllFieldHandles":U IN phObject) NO-ERROR.

IF cAllFieldHandles = "":U OR cAllFieldHandles = ? THEN RETURN.

field-loop:
DO iLoop = 1 TO NUM-ENTRIES(cAllFieldHandles):

  ASSIGN 
    hWidget = WIDGET-HANDLE(ENTRY(iLoop, cAllFieldHandles)).
  IF NOT VALID-HANDLE(hWidget) OR
     LOOKUP(hWidget:TYPE, "text,button,fill-in,selection-list,editor,combo-box,radio-set,slider,toggle-box":U) = 0
     OR NOT CAN-QUERY(hWidget, "column":U) THEN NEXT field-loop.

  /* got a valid widget to move */
  ASSIGN hSideLabel = DYNAMIC-FUNCTION("getfieldlabel":U IN phObject).   

  hWidget:COLUMN = hWidget:COLUMN + pdAddCol.

  IF VALID-HANDLE(hSideLabel) THEN
    hSideLabel:COLUMN = hSideLabel:COLUMN + pdAddCol.

END.

hWindow:VIRTUAL-WIDTH-CHARS  = hWindow:WIDTH-CHARS.
hWindow:VIRTUAL-HEIGHT-CHARS = hWindow:HEIGHT-CHARS.
phFrame:VIRTUAL-WIDTH-CHARS  = phFrame:WIDTH-CHARS.
phFrame:VIRTUAL-HEIGHT-CHARS = phFrame:HEIGHT-CHARS.
phFrame:SCROLLABLE = FALSE.
hParent:VIRTUAL-WIDTH-CHARS  = hParent:WIDTH-CHARS.
hParent:VIRTUAL-HEIGHT-CHARS = hParent:HEIGHT-CHARS.
hParent:SCROLLABLE = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeNormalFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeNormalFrame Procedure 
PROCEDURE resizeNormalFrame :
/*------------------------------------------------------------------------------
  Purpose:     To resize standard frame to fit new labels (not an SDF frame)
  Parameters:  input object handle
               input frame handle
               input number to add to all columns
  Notes:       called from translatewidgets from widgetwalk procedure
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER phObject           AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER phFrame            AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER pdAddCol           AS DECIMAL    NO-UNDO.

DEFINE VARIABLE cAllFieldHandles          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE hWindow                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainer                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidget                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSideLabel                AS HANDLE     NO-UNDO.

hContainer = DYNAMIC-FUNCTION("getcontainersource":U IN phObject) NO-ERROR.
IF VALID-HANDLE(hContainer) AND 
   LOOKUP("resizeWindow":U, hContainer:INTERNAL-ENTRIES) = 0 THEN
  hContainer = DYNAMIC-FUNCTION("getcontainersource":U IN hContainer) NO-ERROR.

hWindow = phFrame:WINDOW.

/* 1st make frame virtually big to avoid size issues */
phFrame:SCROLLABLE = TRUE.
hWindow:VIRTUAL-WIDTH-CHARS  = 204.80.
hWindow:VIRTUAL-HEIGHT-CHARS = 35.67.
phFrame:VIRTUAL-WIDTH-CHARS  = 204.80.
phFrame:VIRTUAL-HEIGHT-CHARS = 35.67.

/* resize window if too small to fit new frame (plus a bit for margin) */
IF (phFrame:WIDTH-CHARS + pdAddCol) > (hWindow:WIDTH-CHARS - 10) THEN
DO:
  hWindow:WIDTH-CHARS = phFrame:WIDTH-CHARS + pdAddCol + 10.
  hWindow:MIN-WIDTH-CHARS = phFrame:WIDTH-CHARS + pdAddCol + 10.

  IF VALID-HANDLE(hContainer) AND LOOKUP("resizeWindow":U, hContainer:INTERNAL-ENTRIES) <> 0 THEN
  DO:
    APPLY "window-resized":u TO hWindow.
    RUN resizeWindow IN hContainer.
  END.
END.

/* resize frame to fit new labels */
phFrame:WIDTH-CHARS = phFrame:WIDTH-CHARS + pdAddCol.

/* always ensure min window size set correctly - even if not resized */
IF (hWindow:MIN-WIDTH-CHARS - 10) < phFrame:WIDTH-CHARS THEN
  ASSIGN hWindow:MIN-WIDTH-CHARS = phFrame:WIDTH-CHARS + 10.

cAllFieldHandles = DYNAMIC-FUNCTION("getAllFieldHandles":U IN phObject) NO-ERROR.

IF cAllFieldHandles = "":U OR cAllFieldHandles = ? THEN RETURN.

field-loop:
DO iLoop = 1 TO NUM-ENTRIES(cAllFieldHandles):

  ASSIGN 
    hWidget = WIDGET-HANDLE(ENTRY(iLoop, cAllFieldHandles)).
  IF NOT VALID-HANDLE(hWidget) OR
     LOOKUP(hWidget:TYPE, "text,button,fill-in,selection-list,editor,combo-box,radio-set,slider,toggle-box":U) = 0
     OR NOT CAN-QUERY(hWidget, "column":U) THEN NEXT field-loop.

  /* got a valid widget to move */
  ASSIGN hSideLabel = ?.
  ASSIGN hSideLabel = hWidget:SIDE-LABEL-HANDLE NO-ERROR.

  hWidget:COLUMN = hWidget:COLUMN + pdAddCol.

  /* If the label has been created as a separate widget (like the dynamic
   * viewer does), then ignore the moving of the label. This will be done
   * as if it were a normal text widget.                                  
   *
   * We still need to cater for static fill-ins. These also have a side
   * label handle, but they differ from dynamic fill-ins in that these labels
    have a widget type of LITERAL, as opposed to TEXT.                       */
  IF VALID-HANDLE(hSideLabel) AND
     ( LOOKUP(STRING(hSideLabel), cAllFieldHandles) EQ 0 OR
       hSideLabel:TYPE                              EQ "LITERAL":U ) THEN
    hSideLabel:COLUMN = hSideLabel:COLUMN + pdAddCol.
END.

hWindow:VIRTUAL-WIDTH-CHARS  = hWindow:WIDTH-CHARS.
hWindow:VIRTUAL-HEIGHT-CHARS = hWindow:HEIGHT-CHARS.
phFrame:VIRTUAL-WIDTH-CHARS  = phFrame:WIDTH-CHARS.
phFrame:VIRTUAL-HEIGHT-CHARS = phFrame:HEIGHT-CHARS.
phFrame:SCROLLABLE = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeSDFFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeSDFFrame Procedure 
PROCEDURE resizeSDFFrame :
/*------------------------------------------------------------------------------
  Purpose:     To resize SDF frame to fit new labels 
  Parameters:  input object handle
               input SDF frame handle
               input number to add to all columns
  Notes:       called from translatewidgets from widgetwalk procedure
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER phObject           AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER phFrame            AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER pdAddCol           AS DECIMAL    NO-UNDO.

DEFINE VARIABLE cAllFieldHandles          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE hParent                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWindow                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainer                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hViewer                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidget                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSideLabel                AS HANDLE     NO-UNDO.

hViewer = DYNAMIC-FUNCTION("getcontainersource":U IN phObject) NO-ERROR.
IF VALID-HANDLE(hViewer) AND 
   LOOKUP("resizeWindow":U, hViewer:INTERNAL-ENTRIES) = 0 THEN
  hContainer = DYNAMIC-FUNCTION("getcontainersource":U IN hViewer) NO-ERROR.

hWindow = phFrame:WINDOW.
hParent = DYNAMIC-FUNCTION("getcontainerhandle":U IN hViewer) NO-ERROR.
IF hParent:TYPE = "window":U THEN
  hParent = hParent:FIRST-CHILD.

/* 1st make frame virtually big to avoid size issues */
hParent:SCROLLABLE = TRUE.
phFrame:SCROLLABLE = TRUE.
hWindow:VIRTUAL-WIDTH-CHARS  = 204.80.
hWindow:VIRTUAL-HEIGHT-CHARS = 35.67.
phFrame:VIRTUAL-WIDTH-CHARS  = 204.80.
phFrame:VIRTUAL-HEIGHT-CHARS = 35.67.
hParent:VIRTUAL-WIDTH-CHARS  = 204.80.
hParent:VIRTUAL-HEIGHT-CHARS = 35.67.

/* move frame back if we can */
IF phFrame:COLUMN - pdAddCol > 1 THEN
  ASSIGN phFrame:COLUMN = phFrame:COLUMN - pdAddCol.
ELSE
  ASSIGN phFrame:COLUMN = 1.

/* resize window if too small to fit frame (plus a bit for margin) */
IF (phFrame:COLUMN + phFrame:WIDTH-CHARS + pdAddCol) > (hWindow:WIDTH-CHARS - 10) THEN
DO:
  hWindow:WIDTH-CHARS = phFrame:COLUMN + phFrame:WIDTH-CHARS + pdAddCol + 10.
  hWindow:MIN-WIDTH-CHARS = phFrame:COLUMN + phFrame:WIDTH-CHARS + pdAddCol + 10.

  IF VALID-HANDLE(hContainer) AND LOOKUP("resizeWindow":U, hContainer:INTERNAL-ENTRIES) <> 0 THEN
  DO:
    APPLY "window-resized":u TO hWindow.
    RUN resizeWindow IN hContainer.
  END.
END.

/* resize parent frame if too small to fit new SDF frame */
IF (phFrame:COLUMN + phFrame:WIDTH-CHARS + pdAddCol) > (hParent:WIDTH-CHARS) THEN
DO:
  hParent:WIDTH-CHARS = phFrame:COLUMN + phFrame:WIDTH-CHARS + pdAddCol + 1.
END.

/* resize frame to fit new labels */
phFrame:WIDTH-CHARS = phFrame:WIDTH-CHARS + pdAddCol.

/* always ensure min window size set correctly - even if not resized */
IF (hWindow:MIN-WIDTH-CHARS - 10) < (phFrame:WIDTH-CHARS + phFrame:COLUMN) THEN
  ASSIGN hWindow:MIN-WIDTH-CHARS = phFrame:WIDTH-CHARS + phFrame:COLUMN + 10.

cAllFieldHandles = DYNAMIC-FUNCTION("getAllFieldHandles":U IN phObject) NO-ERROR.

IF cAllFieldHandles = "":U OR cAllFieldHandles = ? THEN RETURN.

field-loop:
DO iLoop = 1 TO NUM-ENTRIES(cAllFieldHandles):

  ASSIGN 
    hWidget = WIDGET-HANDLE(ENTRY(iLoop, cAllFieldHandles)).
  IF NOT VALID-HANDLE(hWidget) OR
     LOOKUP(hWidget:TYPE, "text,button,fill-in,selection-list,editor,combo-box,radio-set,slider,toggle-box":U) = 0
     OR NOT CAN-QUERY(hWidget, "column":U) THEN NEXT field-loop.

  /* got a valid widget to move */
  ASSIGN hSideLabel = ?.    
  ASSIGN hSideLabel = hWidget:SIDE-LABEL-HANDLE NO-ERROR.

  hWidget:COLUMN = hWidget:COLUMN + pdAddCol.

  IF VALID-HANDLE(hSideLabel) THEN
    hSideLabel:COLUMN = hSideLabel:COLUMN + pdAddCol.

END.

hWindow:VIRTUAL-WIDTH-CHARS  = hWindow:WIDTH-CHARS.
hWindow:VIRTUAL-HEIGHT-CHARS = hWindow:HEIGHT-CHARS.
phFrame:VIRTUAL-WIDTH-CHARS  = phFrame:WIDTH-CHARS.
phFrame:VIRTUAL-HEIGHT-CHARS = phFrame:HEIGHT-CHARS.
phFrame:SCROLLABLE = FALSE.
hParent:VIRTUAL-WIDTH-CHARS  = hParent:WIDTH-CHARS.
hParent:VIRTUAL-HEIGHT-CHARS = hParent:HEIGHT-CHARS.
hParent:SCROLLABLE = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-runLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runLookup Procedure 
PROCEDURE runLookup :
/*------------------------------------------------------------------------------
  Purpose:     Launch a lookup window for a widget
  Parameters:  handle of focused widget
  Notes:       If the data type is a date then a pop-up calendar is displayed.
               If the data type is a integer or decimal then a pop-up calculator
               is displayed.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER phFocus AS HANDLE NO-UNDO.

DEFINE VARIABLE cOldValue AS CHARACTER NO-UNDO.  

IF CAN-QUERY(phFocus,"data-type":U) AND CAN-QUERY(phFocus,"sensitive":U) 
   AND phFocus:SENSITIVE = TRUE THEN
DO:
  APPLY "ENTRY":U TO phFocus.
  ASSIGN cOldValue = phFocus:SCREEN-VALUE.
  CASE phFocus:DATA-TYPE:
    WHEN "date":U THEN
    DO:
      RUN af/cod2/afcalnpopd.w (INPUT phFocus).
    END.
    WHEN "decimal":U OR WHEN "integer":U THEN
    DO:
      RUN af/cod2/afcalcpopd.w (INPUT phFocus).
    END.
  END CASE.
  IF cOldValue <> phFocus:SCREEN-VALUE THEN
    APPLY "value-changed":U TO phFocus.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sendEmail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendEmail Procedure 
PROCEDURE sendEmail :
/*------------------------------------------------------------------------------
  Purpose:     Send an email message. This is similar to notifyUser but is
               far more flexible and has many additional options specific to 
               sending an email message.
  Parameters:  input Mail profile to use e.g. Microsoft Outlook
               input Comma list of Email addresses for to: box
               input Comma list of Email addresses to cc
               input Subject of message
               input Message text
               input Comma list of attachment filenames 
               input Comma list of attachment filenames with full path
               input YES = display dialog for modification before send
               input 0 = low, 1 = medium, 2 = high
               input YES = return a read receipt
               input YES = return a delivery receipt
               input Not used yet but could be used for additional settings
               output If failed - the reason why, blank = it worked
  Notes:       Most of the above fields are optional and will simply be left blank
               as appropriate.
               Multiple file attachments can be sent using comma delimited lists.
               If the display dialog is set to NO then no user intervention will 
               be required and the message will be sent immediately.
               Because this routine uses MAPI for client email, it will work with whatever
               email is installed on the client PC sending the email.
               On the server it uses sendmail and not all options are supported.
               The extra options parameter could contain a comma list of other 
               settings as required, e.g. setting, value, setting, value, etc.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  cEmailProfile                   AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  cToEmail                        AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  cCcEmail                        AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  cSubject                        AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  cMessage                        AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  cAttachmentName                 AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  cAttachmentFPath                AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  lDisplayDialog                  AS LOGICAL      NO-UNDO.
DEFINE INPUT PARAMETER  iImportance                     AS INTEGER      NO-UNDO.
DEFINE INPUT PARAMETER  lReadReceipt                    AS LOGICAL      NO-UNDO.
DEFINE INPUT PARAMETER  lDeliveryReceipt                AS LOGICAL      NO-UNDO.
DEFINE INPUT PARAMETER  cOptions                        AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER cFailedReason                   AS CHARACTER    NO-UNDO.

DEFINE VARIABLE         cFromEmail                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         cUserLogin                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         cUnixToDosFile                  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         cAttachmentLabel                AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         cMessageFile                    AS CHARACTER    NO-UNDO.

DEFINE VARIABLE         chSession                       AS COM-HANDLE   NO-UNDO.
DEFINE VARIABLE         chMessage                       AS COM-HANDLE   NO-UNDO.
DEFINE VARIABLE         chRecipient1                    AS COM-HANDLE   NO-UNDO.
DEFINE VARIABLE         chRecipient2                    AS COM-HANDLE   NO-UNDO.
DEFINE VARIABLE         chAttachment                    AS COM-HANDLE   NO-UNDO.

DEFINE VARIABLE         lOk                             AS LOGICAL      NO-UNDO.
DEFINE VARIABLE         iLoop                           AS INTEGER      NO-UNDO.

IF (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
DO: /* on server so use sendmail */

  /* get current user email from property for current user */
  cFromEmail = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                INPUT "currentUserEmail":U,
                                INPUT NO).
  cUserLogin = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                INPUT "currentUserLogin":U,
                                INPUT NO).

  ASSIGN cAttachmentLabel = REPLACE(cAttachmentName," ","_").

  ASSIGN
    cMessageFile = "/tmp/":U + REPLACE(cUserLogin," ":U,"_":U) +
                   STRING(ETIME) + ".txt":U.


  IF cFromEmail = "":U THEN ASSIGN cFromEmail = "mip@mip-holdings.com".

  OUTPUT TO VALUE(cMessageFile).
  PUT UNFORMATTED cMessage SKIP.
  OUTPUT CLOSE.

  UNIX SILENT VALUE('af/app/afsendmail.dat ' + '"' + cToEmail              + '" ' +
                                               '"' + cFromEmail            + '" ' +
                                               '"' + cCcEmail              + '" ' +
                                               '"' + cSubject              + '" ' +
                                               '"' + cMessageFile          + '" ' +
                                               '"' + cAttachmentFPath      + '" ' +
                                               '"' + cAttachmentLabel      + '"').
END.
ELSE
DO: /* on client so use MAPI */
  /* Create MAPI Session */
  CREATE "MAPI.session" chSession NO-ERROR.
  IF NOT VALID-HANDLE (chSession) THEN
    DO:
      ASSIGN cFailedReason = "Could not create MAPI Session".
      RETURN.
    END.

  /* Logon to MAPI Session */
  chSession:logon (cEmailProfile, No, Yes, 0). 

  /* Create a new message in the outbox */ 
  chMessage = chSession:outbox:messages:ADD NO-ERROR.
  IF NOT VALID-HANDLE (chMessage) THEN
    DO:
      ASSIGN cFailedReason = "Could not create mail message in outbox".
      chSession:Logoff().      
      RELEASE OBJECT chSession.
      chSession = ?.
      RETURN.
    END.

  /* Set up email defaults */
  chMessage:Subject = cSubject.
  chMessage:Type = "IPM.Note".
  chMessage:Text = cMessage.
  chMessage:Importance = iImportance.
  chMessage:DeliveryReceipt = lDeliveryReceipt.
  chMessage:ReadReceipt = lReadReceipt.

  /* Set-up recipients */
  IF cToEmail <> "":U THEN
    DO:
      chRecipient1 = chMessage:Recipients:Add.
      chRecipient1:Name = cToEmail.
      chRecipient1:Type = 1.
      IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
          chRecipient1:Resolve (YES) NO-ERROR.    /* Show dialog */
      ELSE
          chRecipient1:Resolve (NO) NO-ERROR.     /* Supress Dialog */
    END.
  IF cCcEmail <> "":U THEN
    DO:
      chRecipient2 = chMessage:Recipients:Add.
      chRecipient2:Name = cCcEmail.
      chRecipient2:Type = 2.
      IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
          chRecipient2:Resolve (YES) NO-ERROR.    /* Show dialog */
      ELSE
          chRecipient2:Resolve (NO) NO-ERROR.     /* Supress Dialog */
    END.

  /* Add attachments if any */
  DO iLoop = 1 TO NUM-ENTRIES(cAttachmentName):
      chAttachment = chMessage:Attachments:Add.
      chAttachment:Name = ENTRY(iLoop, cAttachmentName).
      chAttachment:Type = 1.
      chAttachment:Source = ENTRY(iLoop, cAttachmentFPath).
      chAttachment:ReadFromFile (ENTRY(iLoop, cAttachmentFPath)).
      RELEASE OBJECT chAttachment NO-ERROR.
  END.

  /* Save the message */
  chMessage:Update.

  /* Check resolution of recipients */
  lOk = chMessage:Recipients:Resolved.

  IF lOk OR (cToEmail = "":U AND cCcEmail = "":U) THEN
     chMessage:Send (yes, lDisplayDialog, 0) NO-ERROR.
  ELSE
     ASSIGN cFailedReason = "Mail not sent - address not resolved for " + cToEmail + " or " + cCcEmail.

  chSession:Logoff().      

  RELEASE OBJECT chAttachment NO-ERROR.
  RELEASE OBJECT chRecipient1 NO-ERROR.
  RELEASE OBJECT chRecipient2 NO-ERROR.
/*   RELEASE OBJECT chMessage NO-ERROR. */ /* causes GPF */
  RELEASE OBJECT chSession.

  ASSIGN
    chAttachment = ?
    chRecipient1 = ?
    chRecipient2 = ?
    chMessage = ?
    chSession = ?
    .

END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setActionUnderway) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setActionUnderway Procedure 
PROCEDURE setActionUnderway :
/*------------------------------------------------------------------------------
  Purpose:     Set the ttActionUnderway values for the passed in records
  Parameters:  see below
  Notes:       ttActionUnderway
               ttActionUnderway.action_underway_origin - SCM or DYN
               ttActionUnderway.action_table_fla
               ttActionUnderway.action_type - ASS, DEL, MOV, ADD
               ttActionUnderway.action_primary_key
               ttActionUnderway.action_scm_object_name
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcActionUnderwayOrigin   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcActionType             AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcActionScmObjectName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcActionTablePrimaryFla  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcActionPrimaryKeyValues AS CHARACTER  NO-UNDO.

  IF CAN-FIND(FIRST ttActionUnderway 
              WHERE ttActionUnderway.action_underway_origin <> pcActionUnderwayOrigin)
  THEN RETURN.

  FIND FIRST ttActionUnderway NO-LOCK
    WHERE ttActionUnderway.action_underway_origin  = pcActionUnderwayOrigin
    AND   ttActionUnderway.action_type             = pcActionType
    AND   ttActionUnderway.action_scm_object_name  = pcActionScmObjectName
    AND   ttActionUnderway.action_table_fla        = pcActionTablePrimaryFla
    NO-ERROR.
  IF NOT AVAILABLE ttActionUnderway
  THEN DO:
    CREATE ttActionUnderway.
    ASSIGN
      ttActionUnderway.action_underway_origin  = pcActionUnderwayOrigin
      ttActionUnderway.action_type             = pcActionType
      ttActionUnderway.action_scm_object_name  = pcActionScmObjectName
      ttActionUnderway.action_table_fla        = pcActionTablePrimaryFla
      ttActionUnderway.action_primary_key      = pcActionPrimaryKeyValues
      .
  END.
  RELEASE ttActionUnderway.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributesInObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAttributesInObject Procedure 
PROCEDURE setAttributesInObject :
/*------------------------------------------------------------------------------
  Purpose:     Set Instance attributes in an object
  Parameters:  input handle of object
               input instance attribute list
  Notes:       Run from launch container to pass on instance attributes into
               an object.
               The list is in the same format as returned to the function 
               instancePropertyList, with CHR(3) between entries and CHR(4) 
               between the property name and its value in each entry. 
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER phObject     AS HANDLE.
DEFINE INPUT PARAMETER pcPropList   AS CHARACTER.

DEFINE VARIABLE iEntry AS INTEGER NO-UNDO.
DEFINE VARIABLE cEntry AS CHARACTER NO-UNDO.
DEFINE VARIABLE cProperty AS CHARACTER NO-UNDO.
DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSignature AS CHARACTER NO-UNDO.

/* Set any Instance Properties specified. The list is in the same format
     as returned to the function instancePropertyList, with CHR(3) between
     entries and CHR(4) between the property name and its value in each entry. 
     NOTE: we must get the datatype for each property in order to set it. */

  DO iEntry = 1 TO NUM-ENTRIES(pcPropList, CHR(3)):
    cEntry = ENTRY(iEntry, pcPropList, CHR(3)).
    cProperty = ENTRY(1, cEntry, CHR(4)).
    cValue = ENTRY(2, cEntry, CHR(4)).
    /* Get the datatype from the return type of the get function. */
    cSignature = dynamic-function
      ("Signature":U IN phObject, "get":U + cProperty).

  /** The message code removed to avoid issues with attributes being set in an
   *  object which are not available as properties in the object. This becomes
   *  as issue as more objects become dynamic (eg viewers, lookups, etc); attributes
   *  such as HEIGHT-CHARS are necessary for the instantiation of the object, but 
   *  are not strictly properties of the object.                                  */
    IF cSignature NE "":U THEN
    CASE ENTRY(2,cSignature):
      WHEN "INTEGER":U THEN
        dynamic-function("set":U + cProperty IN phObject, INT(cValue)).
      WHEN "DECIMAL":U THEN
        dynamic-function("set":U + cProperty IN phObject, DEC(cValue)).
      WHEN "CHARACTER":U THEN
        dynamic-function("set":U + cProperty IN phObject, cValue).
      WHEN "LOGICAL":U THEN
        dynamic-function("set":U + cProperty IN phObject,
          IF cValue = "yes":U THEN yes ELSE no).
    END CASE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setReturnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setReturnValue Procedure 
PROCEDURE setReturnValue :
/*------------------------------------------------------------------------------
  Purpose:     Return whatever was sent in to set the required RETURN-VALUE
  Parameters:  INPUT PARAMETER pcReturnValue - Required return value
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcReturnValue    AS CHARACTER  NO-UNDO.

  RETURN pcReturnValue.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showMessages Procedure 
PROCEDURE showMessages :
/*------------------------------------------------------------------------------
  Purpose: This procedure is the central procedure for the display of all message
           types including Message (MES), Information (INF), Warnings (WAR), 
           Errors (ERR), Serious Halt Errors (HAL), About Window (ABO).
           Any button combination is supported.
           The default message type is "ERR", the default button list is "OK",
           the default label to return is OK if OK exists, otherwise the default
           is the first button in the list, the default cancel button is also OK
           or the 1st entry in the button list, and the default title depends on
           the message type.
           If running server side the messages cannot be displayed and will only be
           able to write to the message log. Also, server side there is no user
           interface, so the default button label will always be returned. 
           Client side the messages will be displayed in a dialog window.
           The procedure checks the property "suppressDisplay" in the Session Manager
           and if set to YES, will not display the message but will simply pass the
           message to the log as would be the case for a server side message. 
           This is useful when running take-on procedures client side.
           The messages will be passed to a procedure on Appserver for interpretation
           called af/app/afmessagep.p. This procedure will format the messages
           appropriately, read text from the ICF message file where appropriate,
           interpret the carrot delimited lists that come back from triggers, deal
           with ADM2 CHR(4) delimited messages, etc. to end up with actual formatted
           messages (translated if required).
           Once the messages have been formatted, if on the client, the message will
           be displayed using the standard ICF message dialog af/cod2/afmessaged.w
           which is an enhanced dialog that contains an email button, etc.
           This dialog window is also used by askQuestion.
           If server side, or the error log flag was returned as YES, or message display
           supression is enabled, the ICF error log will be updated with the error and
           an email will be sent to the currently logged in user notifying them of the
           error (if possible).

    Notes: Returns untranslated button text of button pressed if client side,
           else default button if server side. 
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMessageList   AS CHARACTER.
  DEFINE INPUT  PARAMETER pcMessageType   AS CHARACTER.
  DEFINE INPUT  PARAMETER pcButtonList    AS CHARACTER.
  DEFINE INPUT  PARAMETER pcDefaultButton AS CHARACTER.
  DEFINE INPUT  PARAMETER pcCancelButton  AS CHARACTER.
  DEFINE INPUT  PARAMETER pcMessageTitle  AS CHARACTER.
  DEFINE INPUT  PARAMETER plDisplayEmpty  AS LOGICAL.
  DEFINE INPUT  PARAMETER phContainer     AS HANDLE.
  DEFINE OUTPUT PARAMETER pcButtonPressed AS CHARACTER.    

  DEFINE VARIABLE cSummaryMessages                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullMessages                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButtonList                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageTitle                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUpdateErrorLog                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iButtonPressed                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cAnswer                         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFailed                         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuppressDisplay                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSuppressDisplay                AS CHARACTER  NO-UNDO.

  /* Set up defaults for values not passed in */
  IF NOT CAN-DO("MES,INF,WAR,ERR,HAL,ABO":U,pcMessageType) THEN
    ASSIGN pcMessageType = "ERR":U.
  IF pcButtonList = "":U THEN ASSIGN pcButtonList = "OK":U.
  IF pcDefaultButton = "":U OR LOOKUP(pcDefaultButton,pcButtonList) = 0 THEN
  DO:
    IF LOOKUP("OK":U,pcButtonList) > 0 THEN
      ASSIGN pcDefaultButton = "OK":U.
    ELSE
      ASSIGN pcDefaultButton = ENTRY(1,pcButtonList).
  END.
  IF pcCancelButton = "":U OR LOOKUP(pcCancelButton,pcButtonList) = 0 THEN
  DO:
    IF LOOKUP("OK":U,pcButtonList) > 0 THEN
      ASSIGN pcCancelButton = "OK":U.
    ELSE
      ASSIGN pcCancelButton = ENTRY(1,pcButtonList).
  END.
  IF pcMessageTitle = "":U THEN
  CASE pcMessageType:
    WHEN "MES":U THEN
      ASSIGN pcMessageTitle = "Message":U. 
    WHEN "INF":U THEN
      ASSIGN pcMessageTitle = "Information":U.
    WHEN "WAR":U THEN
      ASSIGN pcMessageTitle = "Warning":U. 
    WHEN "ERR":U THEN
      ASSIGN pcMessageTitle = "Error":U.
    WHEN "HAL":U THEN
      ASSIGN pcMessageTitle = "Halt Condition":U.
    WHEN "ABO":U THEN
      ASSIGN pcMessageTitle = "About ICF":U.
  END CASE.
  IF plDisplayEmpty = ? THEN ASSIGN plDisplayEmpty = YES.

  /* Next interpret / translate the messages */
  &IF DEFINED(server-side) <> 0 &THEN
    DO:
      RUN afmessagep (INPUT pcMessageList,
                      INPUT pcButtonList,
                      INPUT pcMessageTitle,
                      OUTPUT cSummaryMessages,
                      OUTPUT cFullMessages,
                      OUTPUT cButtonList,
                      OUTPUT cMessageTitle,
                      OUTPUT lUpdateErrorLog,
                      OUTPUT lSuppressDisplay).  
    END.
  &ELSE
    DO:
      RUN af/app/afmessagep.p ON gshAstraAppserver (INPUT pcMessageList,
                                                    INPUT pcButtonList,
                                                    INPUT pcMessageTitle,
                                                    OUTPUT cSummaryMessages,
                                                    OUTPUT cFullMessages,
                                                    OUTPUT cButtonList,
                                                    OUTPUT cMessageTitle,
                                                    OUTPUT lUpdateErrorLog,
                                                    OUTPUT lSuppressDisplay).  
    END.
  &ENDIF

  /* Display message if not remote and not suppressed */
  IF NOT lSuppressDisplay THEN
  DO:
    cSuppressDisplay = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                        INPUT "suppressDisplay":U,
                                        INPUT YES).
  END.
  ELSE cSuppressDisplay = "YES":U.

  IF cSuppressDisplay = "YES":U THEN ASSIGN lSuppressDisplay = YES.

  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) AND NOT lSuppressDisplay THEN
  DO:
    RUN af/cod2/afmessaged.w (INPUT pcMessageType,
                              INPUT cSummaryMessages,
                              INPUT cFullMessages,
                              INPUT cButtonList,
                              INPUT cMessageTitle,
                              INPUT LOOKUP(pcDefaultButton,pcButtonList),
                              INPUT LOOKUP(pcCancelButton,pcButtonList),
                              INPUT "":U,
                              INPUT "":U,
                              INPUT "":U,
                              INPUT phContainer,
                              OUTPUT iButtonPressed,
                              OUTPUT cAnswer).
    IF iButtonPressed > 0 AND iButtonPressed <= NUM-ENTRIES(pcButtonList) THEN
      ASSIGN pcButtonPressed = ENTRY(iButtonPressed, pcButtonList).  /* Pass back untranslated button pressed */
    ELSE
      ASSIGN pcButtonPressed = pcDefaultButton.
  END.
  ELSE
    ASSIGN pcButtonPressed = pcDefaultButton.  /* If remote, assume default button */

  /* If remote, or update error log set to YES, then update error log and send an email if possible */
  IF (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) OR lUpdateErrorLog OR lSuppressDisplay THEN
  DO:
    RUN updateErrorLog IN gshSessionManager (INPUT cSummaryMessages,
                                             INPUT cFullMessages).
/*    RUN notifyUser IN gshSessionManager (INPUT 0,                           /* default user */*/
/*                                         INPUT "email":U,                   /* by email */*/
/*                                         INPUT "ICF " + cMessageTitle,    /* ICF message */*/
/*                                         INPUT cSummaryMessages,            /* Summary translated messages */*/
/*                                         OUTPUT cFailed).           */
  END.


  RETURN.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showWarningMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showWarningMessages Procedure 
PROCEDURE showWarningMessages :
/*------------------------------------------------------------------------------
  Purpose:  To issue a warning to a user without generating an input blocking statement
            in the process

  Parameters:  INPUT pcMessageList  - Standard {aferrortxt.i} formatted message (Can contain many messages)
               INPUT pcMessageType  - ERR (Error), INF (Information), ERR (Error)
               INPUT pcMessageTitle - The title of the message dialog
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcMessageList  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcMessageType  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcMessageTitle AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cButtonList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSummaryList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullList         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewButtonList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewTitle         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUpdateErrorLog   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSuppressDisplay  AS LOGICAL    NO-UNDO.

  IF pcMessageTitle = "":U OR
     pcMessageTitle = ?    THEN
  DO:
    CASE pcMessageType:
      WHEN "ERR":U THEN pcMessageTitle = "Error":U.
      WHEN "INF":U THEN pcMessageTitle = "Information":U.
      WHEN "MES":U THEN pcMessageTitle = "Message":U.

      OTHERWISE pcMessageTitle = "Warning":U.
    END CASE.
  END.

  &IF DEFINED(server-side) <> 0 &THEN
    DO:
      RUN afmessagep (INPUT  pcMessageList,
                      INPUT  cButtonList,
                      INPUT  pcMessageTitle,
                      OUTPUT cSummaryList,
                      OUTPUT cFullList,
                      OUTPUT cNewButtonList,
                      OUTPUT cNewTitle,
                      OUTPUT lUpdateErrorLog,
                      OUTPUT lSuppressDisplay).
    END.
  &ELSE
    DO:
      RUN af/app/afmessagep.p ON gshAstraAppserver (INPUT  pcMessageList,
                                                    INPUT  cButtonList,
                                                    INPUT  pcMessageTitle,
                                                    OUTPUT cSummaryList,
                                                    OUTPUT cFullList,
                                                    OUTPUT cNewButtonList,
                                                    OUTPUT cNewTitle,
                                                    OUTPUT lUpdateErrorLog,
                                                    OUTPUT lSuppressDisplay).
    END.
  &ENDIF  

  CASE pcMessageType:
    WHEN "ERR":U THEN MESSAGE cFullList VIEW-AS ALERT-BOX ERROR       TITLE cNewTitle.
    WHEN "INF":U THEN MESSAGE cFullList VIEW-AS ALERT-BOX INFORMATION TITLE cNewTitle.
    WHEN "MES":U THEN MESSAGE cFullList VIEW-AS ALERT-BOX MESSAGE     TITLE cNewTitle.

    OTHERWISE MESSAGE cFullList VIEW-AS ALERT-BOX WARNING TITLE cNewTitle.
  END CASE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-translateWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE translateWidgets Procedure 
PROCEDURE translateWidgets :
/*------------------------------------------------------------------------------
  Purpose:     Translate widget labels, etc.
  Parameters:  input object handle
               input frame handle
               input table tttranslate
  Notes:       called from widgetwalk procedure
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phObject           AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER phFrame            AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR ttTranslate.

DEFINE VARIABLE hDataSource               AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSideLabel                AS HANDLE     NO-UNDO.
DEFINE VARIABLE cRadioButtons             AS CHARACTER  NO-UNDO.

DEFINE VARIABLE dNewLabelLength           AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dLabelWidth               AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dFirstCol                 AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dAddCol                   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE lResize                   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE dMinCol                   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE iEntry                    AS INTEGER    NO-UNDO.

ASSIGN hDataSource = DYNAMIC-FUNCTION("getDataSource":U IN phObject).
RUN multiTranslation IN gshTranslationManager (INPUT NO,
                                               INPUT-OUTPUT TABLE ttTranslate).

ASSIGN
  dAddCol = 0
  dMinCol = 0
  dFirstCol = 0
  lResize = NO
  .

size-check1:
FOR EACH ttTranslate:
  IF ttTranslate.cTranslatedLabel = "":U AND
     ttTranslate.cTranslatedTooltip = "":U THEN NEXT size-check1.

  IF ttTranslate.cWidgetType = "browse":U OR 
     ttTranslate.cWidgetType = "radio-set":U THEN NEXT size-check1.

  dNewLabelLength = FONT-TABLE:GET-TEXT-WIDTH-CHARS(ttTranslate.cTranslatedLabel, ttTranslate.hWidgetHandle:FONT).
  dMinCol = MAXIMUM(dminCol, dNewLabelLength + 1.2).

  IF VALID-HANDLE(ttTranslate.hWidgetHandle) AND 
     CAN-QUERY(ttTranslate.hWidgetHandle, "column":U) AND
     (ttTranslate.hWidgetHandle:COLUMN < dFirstCol OR dFirstCol = 0) THEN
    ASSIGN dFirstCol = ttTranslate.hWidgetHandle:COLUMN.

END.

IF dMinCol > 0 THEN
size-check2:
FOR EACH ttTranslate:
  IF ttTranslate.cTranslatedLabel = "":U AND
     ttTranslate.cTranslatedTooltip = "":U THEN NEXT size-check2.

  IF ttTranslate.cWidgetType = "browse":U OR 
     ttTranslate.cWidgetType = "radio-set":U THEN NEXT size-check2.

  IF VALID-HANDLE(ttTranslate.hWidgetHandle) AND 
     CAN-QUERY(ttTranslate.hWidgetHandle, "column":U) AND
     ttTranslate.hWidgetHandle:COLUMN < dMinCol THEN
  DO:
    ASSIGN lResize = YES.
    LEAVE size-check2.
  END.
END.

IF lResize = YES AND dMinCol > 0 AND dFirstCol > 0 THEN dAddCol = (dMinCol - dFirstcol) + 1.
ELSE dAddCol = 0.

/* need to resize frame to fit new labels */
IF lResize = YES AND dAddCol > 0 THEN
DO:
  IF LOOKUP("setfieldlabel":U, phObject:INTERNAL-ENTRIES) <> 0 THEN
    RUN resizeLookupFrame (INPUT phObject, INPUT phFrame, INPUT dAddCol). 
  ELSE IF LOOKUP("getdisplayfield":U, phObject:INTERNAL-ENTRIES) <> 0 THEN
    RUN resizeSDFFrame (INPUT phObject, INPUT phFrame, INPUT dAddCol). 
  ELSE  
    RUN resizeNormalFrame (INPUT phObject, INPUT phFrame, INPUT dAddCol).
END.

translate-loop:
FOR EACH ttTranslate:
  IF ttTranslate.cTranslatedLabel = "":U AND
     ttTranslate.cTranslatedTooltip = "":U THEN NEXT translate-loop.

  CASE ttTranslate.cWidgetType:
    WHEN "browse":U THEN
    DO:
      IF ttTranslate.cTranslatedLabel <> "":U THEN
      DO:
        ttTranslate.hWidgetHandle:LABEL = ttTranslate.cTranslatedLabel.
        IF VALID-HANDLE(hDataSource) THEN
        DO:
          DYNAMIC-FUNCTION("assignColumnLabel":U IN hDataSource,
                           INPUT (IF ttTranslate.hWidgetHandle:NAME = ? THEN "":U ELSE ttTranslate.hWidgetHandle:NAME),
                           INPUT ttTranslate.hWidgetHandle:LABEL).
          DYNAMIC-FUNCTION("assignColumnColumnLabel":U IN hDataSource,
                           INPUT (IF ttTranslate.hWidgetHandle:NAME = ? THEN "":U ELSE ttTranslate.hWidgetHandle:NAME),
                           INPUT ttTranslate.hWidgetHandle:LABEL).
        END.
      END.
      IF ttTranslate.cTranslatedTooltip <> "":U THEN
      DO:
        ttTranslate.hWidgetHandle:TOOLTIP = ttTranslate.cTranslatedTooltip.
      END.
    END.
    WHEN "radio-set":U THEN
    DO:
      /* the program that creates ttTranslate table refers to the entries as 
       * 1,2,3 as opposed to 1,3,5 (there is a label,value pair)
       * so we have to calculate the right position. Plus we need to
       * re-assign radio-buttons to new value when done (fixes bug iz 1440)
       */  
      ASSIGN cRadioButtons = ttTranslate.hWidgetHandle:RADIO-BUTTONS
             iEntry = (ttTranslate.iWidgetEntry * 2) - 1.
      IF ttTranslate.cTranslatedLabel <> "":U THEN
        ENTRY(iEntry, cRadioButtons) = ttTranslate.cTranslatedLabel.
      IF ttTranslate.cTranslatedTooltip <> "":U THEN
        ttTranslate.hWidgetHandle:TOOLTIP = ttTranslate.cTranslatedTooltip.
      ASSIGN ttTranslate.hWidgetHandle:RADIO-BUTTONS = cradiobuttons.
    END.
    WHEN "text":U THEN
    DO:
      ASSIGN ttTranslate.hWidgetHandle:PRIVATE-DATA = ttTranslate.cTranslatedLabel
             ttTranslate.hWidgetHandle:SCREEN-VALUE = ttTranslate.cTranslatedLabel.
    END.
    OTHERWISE
    DO:

      IF ttTranslate.cTranslatedLabel <> "":U AND 
         ttTranslate.hWidgetHandle = ? AND
         INDEX(ttTranslate.cObjectName, ":":U) <> 0 AND
         LOOKUP("setfieldlabel":U, phObject:INTERNAL-ENTRIES) <> 0 THEN
      DO:
        DYNAMIC-FUNCTION("setfieldLabel":U IN phObject, INPUT ttTranslate.cTranslatedLabel).                                  
      END.
      ELSE IF ttTranslate.cTranslatedLabel <> "":U AND
           INDEX(ttTranslate.cObjectName, ":":U) <> 0 AND
           ttTranslate.cOriginalLabel = "nolabel":U THEN
      DO:          
        ttTranslate.hWidgetHandle:SCREEN-VALUE = REPLACE(ttTranslate.cTranslatedLabel,":":U,"":U) + ":":U.
        ttTranslate.hWidgetHandle:MODIFIED = NO.
      END.
      ELSE IF ttTranslate.cTranslatedLabel <> "":U THEN
      DO:
          /* Cater for widgets like TOGGLE-BOXes which do not have a side label 
           * Buttons would also fall into this category.                        */
          IF CAN-QUERY(ttTranslate.hWidgetHandle, "SIDE-LABEL-HANDLE":U) THEN
              ASSIGN hSideLabel = ttTranslate.hWidgetHandle:SIDE-LABEL-HANDLE.
          ELSE
              ASSIGN hSideLabel = ?.

         /* We need to manually resize, move and change to format of labels for
          * objects on the dynamic viewer. These labels are DYNAMIC and have a TYPE
          * of text.                                                                */
         IF VALID-HANDLE(hSideLabel) AND hSideLabel:TYPE EQ "TEXT":U AND hSideLabel:DYNAMIC THEN
         DO:
             ASSIGN ttTranslate.cTranslatedLabel = ttTranslate.cTranslatedLabel + ":":U
                    dNewLabelLength              = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(ttTranslate.cTranslatedLabel,
                                                                                    ttTranslate.hWidgetHandle:FONT)
                    .
             /** Position the label. We use pixels here since X and WIDTH-PIXELS
              *  are denominated in the same units, unlike COLUMN and WIDTH-CHARS.
              *  ----------------------------------------------------------------------- **/
             IF ( dNewLabelLength + 1 ) GT ttTranslate.hWidgetHandle:X THEN
                 ASSIGN dLabelWidth = ttTranslate.hWidgetHandle:X + 1.
             ELSE
                 ASSIGN dLabelWidth = dNewLabelLength + 1.

             IF dLabelWidth LE 0 THEN
                 ASSIGN dLabelWidth = 1.

             IF CAN-SET(hSideLabel, "FORMAT":U) THEN
                 ASSIGN hSideLabel:FORMAT = "x(" + STRING(LENGTH(ttTranslate.cTranslatedLabel, "CHARACTER":U) + 1) + ")":U.

             ASSIGN hSideLabel:WIDTH-PIXELS = dLabelWidth
                    hSideLabel:X            = ttTranslate.hWidgetHandle:X - dLabelWidth
                    hSideLabel:SCREEN-VALUE = ttTranslate.cTranslatedLabel
                    .
         END.   /* valid side-label */
         ELSE
             ASSIGN ttTranslate.hWidgetHandle:LABEL = ttTranslate.cTranslatedLabel.
      END.  /* there is a translation */
    END.    /* other widget types */
  END CASE. /* widget type */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateErrorLog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateErrorLog Procedure 
PROCEDURE updateErrorLog :
/*------------------------------------------------------------------------------
  Purpose:     Updates the messages into the error log database table
  Parameters:  input CHR(3) delimited list of summary messages.
               input CHR(3) delimited list of full messages.
  Notes:       Called from askQuestion and showMessages.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcSummaryList              AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcFullList                 AS CHARACTER  NO-UNDO.

&IF DEFINED(server-side) <> 0 &THEN
  DO:
    RUN aferrorlgp (INPUT pcSummaryList, INPUT pcFullList).  
  END.
&ELSE
  DO:
    RUN af/app/aferrorlgp.p ON gshAstraAppserver (INPUT pcSummaryList, INPUT pcFullList).
  END.
&ENDIF

/* cannot check for messages as called from showmessages and may go recursive */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetWalk) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE widgetWalk Procedure 
PROCEDURE widgetWalk :
/*------------------------------------------------------------------------------
  Purpose:     Walk widget tree for the frame input
  Parameters:  input container handle
               input object handle
               input frame or window handle.
               input action code (e.g. setup)
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phContainer AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER phObject    AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER phFrame     AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pcAction    AS CHARACTER NO-UNDO.

DEFINE VARIABLE hRealContainer   AS HANDLE    NO-UNDO.
DEFINE VARIABLE cContainerName   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRunAttribute    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cObjectName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE hWidgetGroup     AS HANDLE    NO-UNDO.
DEFINE VARIABLE hDataSource      AS HANDLE    NO-UNDO.
DEFINE VARIABLE hWidget          AS HANDLE    NO-UNDO.
DEFINE VARIABLE hLookup          AS HANDLE    NO-UNDO.
DEFINE VARIABLE iLoop            AS INTEGER   NO-UNDO.
DEFINE VARIABLE iEntry           AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk              AS LOGICAL   NO-UNDO.
DEFINE VARIABLE hLabel           AS HANDLE    NO-UNDO.
DEFINE VARIABLE hColumn          AS HANDLE    NO-UNDO.
DEFINE VARIABLE cFieldName       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRadioButtons    AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRadioLoop       AS INTEGER   NO-UNDO.
DEFINE VARIABLE iBrowseLoop      AS INTEGER   NO-UNDO.
DEFINE VARIABLE cSecuredTokens   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSecuredFields   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cShowPopup       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cHiddenFields    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cParentField     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDisplayedFields AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFieldSecurity   AS CHARACTER NO-UNDO.
DEFINE VARIABLE iFieldPos        AS INTEGER   NO-UNDO.

IF NOT VALID-HANDLE(phContainer) OR NOT VALID-HANDLE(phObject) OR NOT VALID-HANDLE(phFrame) THEN RETURN.

ASSIGN hDataSource = DYNAMIC-FUNCTION("getDataSource":U IN phObject).

cDisplayedFields = DYNAMIC-FUNCTION("getAllFieldHandles" IN phObject) NO-ERROR.
IF cDisplayedFields <> "":U THEN
  cFieldSecurity = FILL(",":U,NUM-ENTRIES(cDisplayedFields)).
IF phFrame:TYPE = "window":U THEN
  phFrame = phFrame:FIRST-CHILD.

IF VALID-HANDLE(phFrame) AND phFrame:NAME <> "FolderFrame":U THEN DO:
  IF pcAction = "setup":U THEN DO:
    /* get real container name and run attribute (if sdf container is viewer !) */    
    ASSIGN hRealContainer = ?.
    IF LOOKUP("getFieldName":U, phObject:INTERNAL-ENTRIES) <> 0 THEN
      hRealContainer = DYNAMIC-FUNCTION("getcontainersource":U IN phContainer) NO-ERROR.
    IF NOT VALID-HANDLE(hRealContainer) THEN ASSIGN hRealContainer = phContainer.

    ASSIGN cContainerName = hRealContainer:FILE-NAME.
    IF LOOKUP("getLogicalObjectName":U, hRealContainer:INTERNAL-ENTRIES) <> 0 THEN
      ASSIGN cContainerName = DYNAMIC-FUNCTION('getLogicalObjectName' IN hRealContainer).
    IF cContainerName = "":U OR cContainerName = ? THEN
      ASSIGN cContainerName = hRealContainer:FILE-NAME.
    ASSIGN
      cContainerName = LC(TRIM(REPLACE(cContainerName,"~\":U,"/":U)))
      cContainerName = SUBSTRING(cContainerName,R-INDEX(cContainerName,"/":U) + 1)
      cRunAttribute = "":U.
    cRunAttribute = DYNAMIC-FUNCTION('getRunAttribute' IN hRealContainer) NO-ERROR.  

    /* get object name to use */    
    IF LOOKUP("getFieldName":U, phObject:INTERNAL-ENTRIES) <> 0 OR
       phFrame:NAME = "Panel-Frame":U THEN
    DO: /* for toolbars and SDF's - use container name for translations */
      ASSIGN cObjectName = phContainer:FILE-NAME.
      IF LOOKUP("getLogicalObjectName":U, phContainer:INTERNAL-ENTRIES) <> 0 THEN
        ASSIGN cObjectName = DYNAMIC-FUNCTION('getLogicalObjectName' IN phContainer).
      IF cObjectName = "":U OR cObjectName = ? THEN
        ASSIGN cObjectName = phContainer:FILE-NAME.
      ASSIGN
        cObjectName = LC(TRIM(REPLACE(cObjectName,"~\":U,"/":U)))
        cObjectName = SUBSTRING(cObjectName,R-INDEX(cObjectName,"/":U) + 1).
      IF LOOKUP("getFieldName":U, phObject:INTERNAL-ENTRIES) <> 0 THEN
        cObjectName = cObjectName + ":":U + DYNAMIC-FUNCTION("getFieldName":U IN phObject).
    END.
    ELSE
    DO: /* otherwise use object name for translations */
      ASSIGN cObjectName = phObject:FILE-NAME.
      IF LOOKUP("getLogicalObjectName":U, phObject:INTERNAL-ENTRIES) <> 0 THEN
        ASSIGN cObjectName = DYNAMIC-FUNCTION('getLogicalObjectName' IN phObject).
      IF cObjectName = "":U OR cObjectName = ? THEN
        ASSIGN cObjectName = phObject:FILE-NAME.
      ASSIGN cObjectName = LC(TRIM(REPLACE(cObjectName,"~\":U,"/":U)))
             cObjectName = SUBSTRING(cObjectName,R-INDEX(cObjectName,"/":U) + 1).
    END.
    EMPTY TEMP-TABLE ttTranslate.
  END.

  ASSIGN
      hwidgetGroup = phFrame:HANDLE
      hwidgetGroup = hwidgetGroup:FIRST-CHILD
      hWidget = hwidgetGroup:FIRST-CHILD.

  /* deal with lookups and smartselects not initialized yet */
  IF pcAction = "setup":U AND hWidget = ? AND INDEX(cObjectName, ":":U) <> 0 AND
     LOOKUP("setfieldlabel":U, phObject:INTERNAL-ENTRIES) <> 0 THEN
  DO:
    CREATE ttTranslate.
    ASSIGN
      ttTranslate.dLanguageObj = 0
      ttTranslate.cObjectName = cObjectName
      ttTranslate.lGlobal = NO
      ttTranslate.lDelete = NO
      ttTranslate.cWidgetType = "fill-in":U
      ttTranslate.cWidgetName = "fiLookup":U
      ttTranslate.hWidgetHandle = ?
      ttTranslate.iWidgetEntry = 0
      ttTranslate.cOriginalLabel = "nolabel":U
      ttTranslate.cTranslatedLabel = "":U
      ttTranslate.cOriginalTooltip = "nolabel":U
      ttTranslate.cTranslatedTooltip = "":U
      .
  END.

  /* check field security and token security */
  ASSIGN cHiddenFields = "":U.
  IF pcAction = "setup":U THEN
    RUN fieldSecurityCheck IN gshSecurityManager (INPUT cContainerName,
                                                INPUT cRunAttribute,
                                                OUTPUT cSecuredFields).
  IF pcAction = "setup":U THEN
    RUN tokenSecurityCheck IN gshSecurityManager (INPUT cContainerName,
                                                INPUT cRunAttribute,
                                                OUTPUT cSecuredTokens).
  widget-walk:
  REPEAT WHILE VALID-HANDLE (hWidget):

    /* check if european format and if so and this is a decimal widget and the delimiter is a
       comma, then set the delimiter to chr(3) because comma is a decimal separator in european
       format */
    IF pcAction = "setup":U AND
       LOOKUP(hWidget:TYPE,"selection-list,radio-set,combo-box":U) <> 0 AND
       CAN-QUERY(hWidget,"data-type":U) AND
       hWidget:DATA-TYPE = "decimal":U AND
       CAN-QUERY(hWidget,"delimiter":U) AND
       hWidget:DELIMITER = ",":U AND
       SESSION:NUMERIC-DECIMAL-POINT = ",":U THEN
    DO:
      hWidget:DELIMITER = CHR(3).    
    END.
    /* Set secured fields for Dynamic Combos and Lookups */
    IF pcAction = "setup":U AND
       hWidget:TYPE = "FRAME":U  THEN
      cFieldSecurity = setSecurityForDynObjects (hWidget,cSecuredFields,cDisplayedFields,cFieldSecurity,phObject).
      
    /* use database help for tooltip if no tooltip set-up */
    IF pcAction = "setup":U AND CAN-QUERY(hWidget,"tooltip":U) THEN
    ASSIGN hWidget:TOOLTIP = (IF hWidget:TOOLTIP <> ? AND hWidget:TOOLTIP <> "":U THEN
                         hWidget:TOOLTIP ELSE hWidget:HELP).
    /* translation and security */
    IF pcAction = "Setup":U AND LOOKUP(hWidget:TYPE, "text,button,fill-in,selection-list,editor,combo-box,radio-set,slider,toggle-box":U) > 0 THEN
    DO:
      ASSIGN
        cFieldName = (IF CAN-QUERY(hWidget, "TABLE":U) AND LENGTH(hWidget:TABLE) > 0 AND hWidget:TABLE <> "RowObject":U THEN (hWidget:TABLE + ".":U) ELSE "":U) + hWidget:NAME.
      IF cFieldName = ? OR cFieldName = "":U THEN DO:
        ASSIGN hWidget = hWidget:NEXT-SIBLING.
        NEXT widget-walk.
      END.

      /* check security */
      IF hWidget:TYPE = "button":U AND cSecuredTokens <> "":U AND LOOKUP(cFieldName,cSecuredTokens) <> 0 THEN DO:
        ASSIGN
          hWidget:SENSITIVE = FALSE
          hWidget:MODIFIED = FALSE.
      END.
      iFieldPos = LOOKUP(STRING(hWidget),cDisplayedFields).
      IF hWidget:TYPE <> "button":U AND cSecuredFields <> "":U AND LOOKUP(cFieldName,cSecuredFields) <> 0 THEN DO:
        ASSIGN iEntry = LOOKUP(cFieldName,cSecuredFields). /* Look for field in list */
        IF iEntry > 0 AND NUM-ENTRIES(cSecuredFields) > iEntry THEN
        DO:
          CASE ENTRY(iEntry + 1, cSecuredFields):
            WHEN "hidden":U THEN
            DO:
              IF LOOKUP(hWidget:TYPE, "fill-in":U) > 0 THEN /* Can only blank fill-in's */
                ASSIGN hWidget:BLANK = TRUE.
              ASSIGN
                hWidget:SENSITIVE = FALSE
                hWidget:BGCOLOR = 8.
                cHiddenFields = (IF cHiddenFields <> "":U THEN cHiddenFields + ",":U + cFieldName ELSE cFieldName).
              IF CAN-SET(hWidget,"READ-ONLY":U) THEN
                hWidget:READ-ONLY = TRUE.
              ELSE
                hWidget:SENSITIVE = FALSE.
              IF iFieldPos <> 0 THEN
                ENTRY(iFieldPos,cFieldSecurity) = "Hidden":U NO-ERROR.
            END.
            WHEN "Read Only":U THEN
            DO:
              ASSIGN
                hWidget:SENSITIVE = FALSE
                hWidget:BGCOLOR = 8.
              IF CAN-SET(hWidget,"READ-ONLY":U) THEN
                hWidget:READ-ONLY = TRUE.
              IF iFieldPos <> 0 THEN
                ENTRY(iFieldPos,cFieldSecurity) = "ReadOnly":U NO-ERROR.
            END.
          END CASE.

          /* disable field in SDO if can */
          IF VALID-HANDLE(hDataSource) THEN
          DO:
          END.
          ASSIGN hWidget:MODIFIED = FALSE.
        END.
      END.

      /* Avoid duplicates */
      IF CAN-FIND(FIRST ttTranslate
                  WHERE ttTranslate.dLanguageObj = 0
                    AND ttTranslate.cObjectName = cObjectName
                    AND ttTranslate.cWidgetType = hWidget:TYPE
                    AND ttTranslate.cWidgetName = cFieldName) THEN
      DO:
        ASSIGN hWidget = hWidget:NEXT-SIBLING.
        NEXT widget-walk.
      END.

      IF hWidget:TYPE <> "RADIO-SET":U THEN
      DO:
        CREATE ttTranslate.
        ASSIGN
          ttTranslate.dLanguageObj = 0
          ttTranslate.cObjectName = cObjectName
          ttTranslate.lGlobal = NO
          ttTranslate.lDelete = NO
          ttTranslate.cWidgetType = hWidget:TYPE
          ttTranslate.cWidgetName = cFieldName
          ttTranslate.hWidgetHandle = hWidget
          ttTranslate.iWidgetEntry = 0
          ttTranslate.cOriginalLabel = (IF CAN-QUERY(hWidget,"LABEL":U) AND hWidget:LABEL <> ? THEN hWidget:LABEL ELSE "":U)
          ttTranslate.cTranslatedLabel = "":U
          ttTranslate.cOriginalTooltip = (IF CAN-QUERY(hWidget,"TOOLTIP":U) AND hWidget:TOOLTIP <> ? THEN hWidget:TOOLTIP ELSE "":U)
          ttTranslate.cTranslatedTooltip = "":U
          .

        /* deal with SDF's where label is separate */
        IF INDEX(cObjectName, ":":U) <> 0 AND ttTranslate.cOriginalLabel = "":U THEN
        DO:
          ASSIGN hLabel = ?.
          ASSIGN hLabel = DYNAMIC-FUNCTION("getLabelHandle":U IN phObject) NO-ERROR.
          IF VALID-HANDLE(hLabel) AND hLabel:SCREEN-VALUE <> ? AND hLabel:SCREEN-VALUE <> "":U THEN
          DO:
            ttTranslate.cOriginalLabel = "nolabel":U /* REPLACE(hLabel:SCREEN-VALUE,":":U,"":U) */ .
            ttTranslate.hWidgetHandle = hLabel.
          END.
        END.

      END. /* not a radio-set */
      ELSE  /* It is a radio-set */
      DO:
        ASSIGN cRadioButtons = hWidget:RADIO-BUTTONS.
        radio-loop:
        DO iRadioLoop = 1 TO NUM-ENTRIES(cRadioButtons) BY 2:

          CREATE ttTranslate.
          ASSIGN
            ttTranslate.dLanguageObj = 0
            ttTranslate.cObjectName = cObjectName
            ttTranslate.lGlobal = NO
            ttTranslate.lDelete = NO
            ttTranslate.cWidgetType = hWidget:TYPE
            ttTranslate.cWidgetName = cFieldName
            ttTranslate.hWidgetHandle = hWidget
            ttTranslate.iWidgetEntry = (iRadioLoop + 1) / 2
            ttTranslate.cOriginalLabel = ENTRY(iRadioLoop, cRadioButtons)
            ttTranslate.cTranslatedLabel = "":U
            ttTranslate.cOriginalTooltip = (IF CAN-QUERY(hWidget,"TOOLTIP":U) AND hWidget:TOOLTIP <> ? THEN hWidget:TOOLTIP ELSE "":U)
            ttTranslate.cTranslatedTooltip = "":U.
        END. /* radio-loop */
      END. /* radio-set */
    END.  /* valid widget type */
    ELSE IF pcAction = "Setup":U AND INDEX(hWidget:TYPE,"browse":U) <> 0 THEN DO:
      ASSIGN hColumn = hWidget:FIRST-COLUMN.
      col-loop:
      DO iBrowseLoop = 1 TO hWidget:NUM-COLUMNS:
        IF NOT VALID-HANDLE(hColumn) THEN LEAVE col-loop.
        ASSIGN cFieldName = (IF CAN-QUERY(hColumn, "TABLE":U) AND LENGTH(hColumn:TABLE) > 0 AND hColumn:TABLE <> "RowObject":U THEN (hColumn:TABLE + ".":U) ELSE "":U) + hColumn:NAME.

        IF cFieldName = ? OR cFieldName = "":U THEN DO:
          ASSIGN hColumn = hcolumn:NEXT-COLUMN NO-ERROR.
          NEXT col-loop.
        END.

        /* Avoid duplicates */
        IF CAN-FIND(FIRST ttTranslate
                    WHERE ttTranslate.dLanguageObj = 0
                      AND ttTranslate.cObjectName = cObjectName
                      AND ttTranslate.cWidgetType = hWidget:TYPE
                      AND ttTranslate.cWidgetName = cFieldName) THEN
        DO:
          ASSIGN hColumn = hcolumn:NEXT-COLUMN NO-ERROR.
          NEXT col-loop.
        END.

        CREATE ttTranslate.
        ASSIGN
          ttTranslate.dLanguageObj = 0
          ttTranslate.cObjectName = cObjectName
          ttTranslate.lGlobal = NO
          ttTranslate.lDelete = NO
          ttTranslate.cWidgetType = hWidget:TYPE
          ttTranslate.cWidgetName = cFieldName
          ttTranslate.hWidgetHandle = hColumn
          ttTranslate.iWidgetEntry = 0
          ttTranslate.cOriginalLabel = (IF CAN-QUERY(hColumn,"LABEL":U) AND hColumn:LABEL <> ? THEN hColumn:LABEL ELSE "":U)
          ttTranslate.cTranslatedLabel = "":U
          ttTranslate.cOriginalTooltip = (IF CAN-QUERY(hColumn,"TOOLTIP":U) AND hColumn:TOOLTIP <> ? THEN hColumn:TOOLTIP ELSE "":U)
          ttTranslate.cTranslatedTooltip = "":U
          .

        ASSIGN hColumn = hcolumn:NEXT-COLUMN NO-ERROR.
      END.
    END. /* browse setup */

    ASSIGN hWidget = hWidget:NEXT-SIBLING.
  END. /* widget-walk */

  /* translate widgets */
  IF pcAction = "setup":U AND CAN-FIND(FIRST ttTranslate) THEN
    RUN translateWidgets (INPUT phobject, INPUT phFrame, INPUT TABLE ttTranslate).

  /* put popup buttons on - after translation and resizes */
  IF pcAction = "setup":U  THEN
  DO:
    ASSIGN
        hwidgetGroup = phFrame:HANDLE
        hwidgetGroup = hwidgetGroup:FIRST-CHILD
        hWidget = hwidgetGroup:FIRST-CHILD.

    widget-walk2:
    REPEAT WHILE VALID-HANDLE(hWidget):
        /* Only Date, Decimal or Integer Fill-ins will ever have popups. */
        IF LOOKUP(hWidget:TYPE, "FILL-IN":U)                   NE 0 AND
           CAN-QUERY(hWidget, "DATA-TYPE":U)                        AND
           LOOKUP(hWidget:DATA-TYPE, "DATE,DECIMAL,INTEGER":U) NE 0 THEN
        DO:
            /* Check whether the ShowPopup property has been explicitly set.
             * If so, use this value. If not, act according to the defaults. */
            ASSIGN cShowPopup = "":U.
            IF CAN-QUERY(hWidget, "PRIVATE-DATA":U)             AND
               LOOKUP("ShowPopup":U, hWidget:PRIVATE-DATA) GT 0 THEN
                ASSIGN cShowPopup = ENTRY(LOOKUP("ShowPopup":U, hWidget:PRIVATE-DATA) + 1, hWidget:PRIVATE-DATA).
            /* Get the name of the field for which popup is to be created only if there are hidden fields here */
            IF cHiddenFields <> "":U THEN DO:
                cParentField = (IF CAN-QUERY(hWidget, "TABLE":U) AND LENGTH(hWidget:TABLE) > 0 AND hWidget:TABLE <> "RowObject":U THEN 
                                  (hWidget:TABLE + ".":U) ELSE "":U) + hWidget:NAME.
                IF cParentField <> "":U AND cParentField <> ? THEN
                    IF LOOKUP(cParentField,cHiddenFields) <> 0 THEN /* Don't create popup for hidden fields */
                        ASSIGN cShowPopup = "NO".
            END.
            /* Only check for ShowPopups = NO. If it is YES, create the popup. */
            IF cShowPopup EQ "NO":U THEN
            DO:
                ASSIGN hWidget = hWidget:NEXT-SIBLING.
                NEXT widget-walk2.
            END.    /* ShowPopup is NO */
            ELSE
            IF cShowPopup NE "YES":U THEN
            DO:
                /* By default there is no popup for integer widgets. */
                IF CAN-QUERY(hWidget, "DATA-TYPE":U) AND
                   hWidget:DATA-TYPE  EQ "INTEGER":U THEN
                DO:
                    ASSIGN hWidget = hWidget:NEXT-SIBLING.
                    NEXT widget-walk2.
                END.    /* integer default. */

                /* Kept for backwards compatability. */
                IF (phFrame:PRIVATE-DATA NE ? AND INDEX(phFrame:PRIVATE-DATA, "NoLookups":U) NE 0) OR
                   (hWidget:PRIVATE-DATA NE ? AND INDEX(hWidget:PRIVATE-DATA, "NoLookups":U) NE 0) THEN
                DO:
                    ASSIGN hWidget = hWidget:NEXT-SIBLING.
                    NEXT widget-walk2.
                END.    /* NOLOOKUPS set in private data */
            END.    /* default */

            /* create a lookup button for pop-up calendar or calculator */
            CREATE BUTTON hLookup
                ASSIGN FRAME = phFrame
                       NO-FOCUS = TRUE
                       PRIVATE-DATA = "":U
                TRIGGERS:
                    ON CHOOSE PERSISTENT RUN runLookup IN gshSessionManager (INPUT hWidget).
                END TRIGGERS.
            ASSIGN hLookup:LABEL = "...":U
                   hLookup:WIDTH-PIXELS = 15
                   hLookup:HEIGHT-PIXELS = hWidget:HEIGHT-PIXELS - 1
                   hLookup:HIDDEN = FALSE
                   hLookup:SENSITIVE = TRUE
                   hLookup:X = (hWidget:X + hWidget:WIDTH-PIXELS) - 15
                   hLookup:Y = hWidget:Y + 1
                   hWidget:WIDTH-PIXELS = hWidget:WIDTH-PIXELS - 15.
            hLookup:MOVE-TO-TOP().

            /* Add F4 trigger to widget */
            ON F4 OF hWidget PERSISTENT RUN runLookup IN gshSessionManager (hWidget).
            /* Store the handle of the lookup in the widget's private data. */
            IF hWidget:PRIVATE-DATA EQ ? THEN
                ASSIGN hWidget:PRIVATE-DATA = "":U.
            ASSIGN hWidget:PRIVATE-DATA = hWidget:PRIVATE-DATA + ",":U + "PopupHandle,":U + STRING(hLookup).
        END. /* setup of lookups */
        ASSIGN hWidget = hWidget:NEXT-SIBLING.
    END. /* widget-walk2 */
  END. /*setup action */
END.  /* valid-handle(phframe) */

/* Now we need to set the Secured fields */
IF cFieldSecurity <> "":U THEN
  DYNAMIC-FUNCTION("setFieldSecurity" IN phObject, cFieldSecurity) NO-ERROR.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fixQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fixQueryString Procedure 
FUNCTION fixQueryString RETURNS CHARACTER
  ( INPUT pcQueryString AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: To check for non-Decimal point decimal places in query string and replace 
           with full stops to resolve issues when running with non-American numeric
           formats selected.
    Notes: Whereever a query prepare is being used, this procedure should first
           be called to resolve any issues in the query string, such as decimal
           formatting.
           The main issues arise when the query string contains stringed decimal
           values.
------------------------------------------------------------------------------*/
    /* Don't bother if we are using American decimal format. */
    IF SESSION:NUMERIC-DECIMAL-POINT EQ ".":U THEN
        RETURN pcQueryString.

    DEFINE VARIABLE iPosn                   AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cBefore                 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cAfter                  AS CHARACTER  NO-UNDO.

    ASSIGN iPosn = INDEX(pcQueryString, SESSION:NUMERIC-DECIMAL-POINT).

    comma-loop:
    REPEAT WHILE iPosn <> 0 AND iPosn <> ?:
        ASSIGN cBefore = "":U
               cAfter  = "":U
               .
        IF iPosn > 1 THEN
            ASSIGN cBefore = SUBSTRING(pcQueryString, iPosn - 1,1).
        IF iPosn < LENGTH(pcQueryString) THEN
            ASSIGN cAfter = SUBSTRING(pcQueryString, iPosn + 1,1).

        IF cBefore >= "0":U AND cBefore <= "9":U AND
           cAfter  >= "0":U AND cAfter  <= "9":U THEN
        DO:
            /* See if it is not quoted and thus needs to be changed */
            IF DYNAMIC-FUNCTION("isObjQuoted":U, pcQueryString, iPosn) = FALSE THEN
                SUBSTRING(pcQueryString,iPosn,1) = ".":U.
        END.
        
        ASSIGN iPosn = INDEX(pcQueryString, SESSION:NUMERIC-DECIMAL-POINT, iPosn + 1).
    END.  /* sesion decimal point loop */

    RETURN pcQueryString.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInternalEntryExists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInternalEntryExists Procedure 
FUNCTION getInternalEntryExists RETURNS LOGICAL
  ( INPUT phProcedure           AS HANDLE,
    INPUT pcProcedureName       AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Checks whether a procedure or function exists for a given handle
    Notes:  * If the procedure handle is a proxy handle for a persistent
              procedure running remotely in the context of a Progress
              AppServer the :PROXY attribute will be true. If not, it
              will be false. 
            * We want to know this because we cannot read the :INTERNAL-
              ENTRIES attribute of procedures which are running remotely.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iEntryNumber                AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cInternalEntries            AS CHARACTER            NO-UNDO.

    IF VALID-HANDLE(phProcedure) THEN
        IF phProcedure:PROXY THEN
        DO:
            ASSIGN cInternalEntries = DYNAMIC-FUNCTION("getInternalEntries":U IN phProcedure) NO-ERROR.
            ASSIGN iEntryNumber = LOOKUP(pcProcedureName, cInternalEntries) WHEN cInternalEntries <> ?.
        END.    /* procedure is a proxy: running on AppServer */
        ELSE
            ASSIGN iEntryNumber = LOOKUP(pcProcedureName, phProcedure:INTERNAL-ENTRIES).

    RETURN ( iEntryNumber > 0 ).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPropertyList Procedure 
FUNCTION getPropertyList RETURNS CHARACTER
  ( INPUT pcPropertyList AS CHARACTER,
    INPUT plSessionOnly AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:     To retrieve properties from local temp-table if available, otherwise
               via server side Session Manager from context database.
  Parameters:  input comma delimited list of properties whose value you wish to retrieve.
  Notes:       Returns a CHR(3) delimited list of corresponding property values.
               The local cache temp-table is only checked when running client side.
               If the session only flag is set to YES then the database is not checked
               if running client side.
               If the server side routine is running client side due to not being connected
               to the appserver, then also do not check context database as all properties
               will be set in the local temp-table.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntry          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cProperty       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDbPropertyList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDbValueList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturnValues   AS CHARACTER  NO-UNDO.

  /* First ensure the value list has a corresponding entry for every property */
  ASSIGN cReturnValues = FILL(CHR(3), NUM-ENTRIES(pcPropertyList) - 1).

  /* Properties to get from the database */
  IF (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
    ASSIGN
      cDbPropertyList = pcPropertyList
      cDbValueList = cReturnValues.
  ELSE
    ASSIGN
      cDbPropertyList = "":U
      cDbValueList = "":U.
      .

  /* Read cached values + build list of values to get from server if required */
  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
  cache-loop:
  DO iLoop = 1 TO NUM-ENTRIES(pcPropertyList):
    ASSIGN cProperty = TRIM(ENTRY(iLoop,pcPropertyList)).
    FIND FIRST ttProperty
         WHERE ttProperty.propertyName = cProperty
         NO-ERROR.
    IF AVAILABLE ttProperty THEN
      ENTRY(iLoop,cReturnValues,CHR(3)) = ttProperty.propertyValue. 
    ELSE
      ASSIGN cDbPropertyList = cDbPropertyList +
                               (IF cDbPropertyList = "":U THEN "":U ELSE ",":U) +
                               cProperty.
  END.  /* cache-loop */

  /* get properties from database if required */
  &IF DEFINED(server-side) <> 0 &THEN
    IF (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) AND cDbPropertyList <> "":U THEN
    DO:
      RUN afgetprplp (INPUT cDbPropertyList,
                      OUTPUT cDbValueList).  
    END.
  &ELSE
    IF NOT plSessionOnly AND cDbPropertyList <> "":U THEN
    DO:
      RUN af/app/afgetprplp.p ON gshAstraAppserver (INPUT cDbPropertyList,
                                                    OUTPUT cDbValueList).
    END.
  &ENDIF

  /* Update database values into returned value list */
  IF cDbPropertyList = pcPropertyList THEN
    ASSIGN cReturnValues = cDbValueList.
  ELSE
  db-loop:
  DO iLoop = 1 TO NUM-ENTRIES(cDbPropertyList):
    ASSIGN
      cProperty = TRIM(ENTRY(iLoop,cDbPropertyList))
      iEntry = LOOKUP(cProperty,pcPropertyList)
      .
    IF iEntry > 0 AND iEntry <= NUM-ENTRIES(cReturnValues, CHR(3)) THEN
      ENTRY(iEntry,cReturnValues,CHR(3)) = ENTRY(iLoop,cDbValueList, CHR(3)). 
  END.  /* db-loop */

  RETURN cReturnValues.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isObjQuoted) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isObjQuoted Procedure 
FUNCTION isObjQuoted RETURNS LOGICAL
  (INPUT pcQueryString  AS CHARACTER,
   INPUT piPosition     AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose: Looks at the object number in the query string and determines whether
           or not it is wrapped in quotes

    Notes: This is needed when running the application in European format. If an
           object number is in quotes and we are in European mode / format, the
           object number must remain with a comma in the quotes, i.e. '12345678,02'
           to convert properly to a decimal. If it is not quoted however, then
           the comma must be replaced by a '.', i.e. ...obj = 12345678,02, FIRST ...
           must be replaced with ...obj = 12345678.02, FIRST ... to ensure that
           the query resolves properly. The replace will be done by 'fixQueryString',
           which calls this function to establish whether or not to replace the object
           number's decimal seperator based on whether it is quoted or not
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAllowedCharacters  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCharacter          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQuotedInFront      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lQuotedBehind       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lObjQuoted          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFinished           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCounter            AS INTEGER    NO-UNDO.

  ASSIGN
      cAllowedCharacters = "1234567890 ":U + "'" + '"':U + CHR(10) + CHR(13)
      lQuotedInFront     = FALSE
      lQuotedBehind      = FALSE
      lObjQuoted         = FALSE.

  /* Read forward through the string */
  IF LENGTH(pcQueryString) >= piPosition THEN
  DO:
    ASSIGN
        lFinished = FALSE
        iCounter  = piPosition.

    DO WHILE lFinished = FALSE:
      ASSIGN
          iCounter   = iCounter + 1.
          cCharacter = SUBSTRING(pcQueryString, iCounter, 1).

      IF INDEX(cAllowedCharacters, cCharacter) <> 0 AND
         (cCharacter = "'":U OR cCharacter = '"':U) THEN
        ASSIGN
            lQuotedBehind = TRUE
            lFinished     = TRUE.

      IF iCounter >= LENGTH(pcQueryString) THEN lFinished = TRUE.
    END.
  END.

  /* Read backward through the string */
  IF piPosition > 1 THEN
  DO:
    ASSIGN
        lFinished = FALSE
        iCounter  = piPosition.

    DO WHILE lFinished = FALSE:
      ASSIGN
          iCounter   = iCounter - 1.
          cCharacter = SUBSTRING(pcQueryString, iCounter, 1).

      IF INDEX(cAllowedCharacters, cCharacter) <> 0 AND
         (cCharacter = "'":U OR cCharacter = '"':U) THEN
        ASSIGN
            lQuotedInFront = TRUE
            lFinished      = TRUE.

      IF iCounter <= 1 THEN lFinished = TRUE.
    END.
  END.

  IF lQuotedInFront AND lQuotedBehind THEN
    lObjQuoted = TRUE.

  RETURN lObjQuoted.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPropertyList Procedure 
FUNCTION setPropertyList RETURNS LOGICAL
  ( INPUT pcPropertyList AS CHARACTER,
    INPUT pcPropertyValues AS CHARACTER,
    INPUT plSessionOnly AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:     To set properties in local temp-table if available, then
               via server side Session Manager procedure into context database.
  Parameters:  input comma delimited list of property names whose value you wish to set.
               input CHR(3) delimited list of corresponding property values.
               input this session only flag. If set to YES, only stores property
               on the client, and creates temp-table record if it does not
               exist.
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cProperty       AS CHARACTER  NO-UNDO.

  /* First update cache temp-table with all properties */
  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
  cache-loop:
  DO iLoop = 1 TO NUM-ENTRIES(pcPropertyList):
    ASSIGN cProperty = TRIM(ENTRY(iLoop,pcPropertyList)).

    FIND FIRST ttProperty
         WHERE ttProperty.propertyName = cProperty
         NO-ERROR.

    /* if server side routine running on client due to no appserver connection, then
       only use temp-table cache for all properties
    */
    &IF DEFINED(server-side) <> 0 &THEN
      IF NOT AVAILABLE ttProperty THEN
      DO:
        CREATE ttProperty.
        ASSIGN
          ttProperty.propertyName = cProperty.
      END.
    &ENDIF

    IF plSessionOnly AND NOT AVAILABLE ttProperty THEN
    DO:
      CREATE ttProperty.
      ASSIGN
        ttProperty.propertyName = cProperty.
    END.

    IF AVAILABLE ttProperty THEN
      ASSIGN ttProperty.propertyValue = ENTRY(iLoop,pcPropertyValues,CHR(3)).

  END.  /* cache-loop */

  /* Then update database with all properties if required */
  &IF DEFINED(server-side) <> 0 &THEN
    IF (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
    DO:
      RUN afsetprplp (INPUT pcPropertyList,
                      INPUT pcPropertyValues).  
    END.
  &ELSE
    IF NOT plSessionOnly THEN
    DO:
      RUN af/app/afsetprplp.p ON gshAstraAppserver (INPUT pcPropertyList,
                                                    INPUT pcPropertyValues).
    END.
  &ENDIF

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSecurityForDynObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSecurityForDynObjects Procedure 
FUNCTION setSecurityForDynObjects RETURNS CHARACTER
  ( INPUT phWidget          AS HANDLE,
    INPUT pcSecuredFields   AS CHARACTER,
    INPUT pcDisplayedFields AS CHARACTER,
    INPUT pcFieldSecurity   AS CHARACTER,
    INPUT phViewer          AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  This function will set security properties for Dynamic Lookups and
            Dynamic Combos.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iFieldPos     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntry        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFieldName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFrameHandle  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFieldHandle  AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE iSDFLoop           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cContainerTargets  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSDFHandle         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hSDFFrameHandle    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFrameProc         AS HANDLE    NO-UNDO.

  cContainerTargets = DYNAMIC-FUNCTION("linkHandles":U IN phViewer, "Container-Target":U) NO-ERROR.

  /* To move away from reading the procedure handle from the 
     frame's PRIVATE-DATA we are checking that the FRAME we
     are reading is indeed that of an SDF and that the handle
     of this FRAME is one of the SDF's found from the Container 
     Target list. This checks that we are assigning the handle 
     of the current frame's procedure handle and not any other
     SDF's that might be on the viewer. */
  hFrameProc = ?.
  SDF_LOOP:
  DO iSDFLoop = 1 TO NUM-ENTRIES(cContainerTargets):
    hSDFHandle = WIDGET-HANDLE(ENTRY(iSDFLoop,cContainerTargets)).
    IF VALID-HANDLE(hSDFHandle) THEN
      hSDFFrameHandle = DYNAMIC-FUNCTION("getSDFFrameHandle":U IN hSDFHandle) NO-ERROR.
    IF phWidget = hSDFFrameHandle THEN DO:
      hFrameProc = hSDFHandle.
      LEAVE SDF_LOOP.
    END.
  END.
  
  IF hFrameProc = ? THEN
    RETURN pcFieldSecurity. 
  

  ASSIGN phWidget = hFrameProc.
  
  IF NOT VALID-HANDLE(phWidget) OR 
     phWidget:TYPE <> "PROCEDURE":U THEN
    RETURN pcFieldSecurity. 

  /* Find the position of the Dynamic Object in the field list */
  iFieldPos = LOOKUP(STRING(hFrameProc),pcDisplayedFields).
  IF iFieldPos = ? THEN
    iFieldPos = 0.
  /* Run a function to get the field name from the Dynamic Object */
  IF LOOKUP("getFieldName":U,phWidget:INTERNAL-ENTRIES) > 0 THEN
    cFieldName = DYNAMIC-FUNCTION("getFieldName":U IN phWidget) NO-ERROR.
  /* If the function could not be found or the field name is blank - return */
  IF cFieldName = "":U THEN
    RETURN pcFieldSecurity. 

  /* Check if the field is secured - if not - Return */
  ASSIGN iEntry = LOOKUP(cFieldName,pcSecuredFields).
  IF iEntry = 0 THEN
    RETURN pcFieldSecurity. 

  /* Now we need to find the handle to the actual fill-in for lookups 
     and the combo-box for dynamic combos */
  hFieldHandle = ?.
  
  IF LOOKUP("dynamicCombo":U,phWidget:INTERNAL-ENTRIES) > 0 THEN
    hFieldHandle = DYNAMIC-FUNCTION("getComboHandle":U IN phWidget) NO-ERROR.
  ELSE
    ASSIGN hFieldHandle  = DYNAMIC-FUNCTION("getLookupHandle":U IN phWidget) NO-ERROR.
                                                
  /* Make sure that the widget is valid */
  IF NOT VALID-HANDLE(hFieldHandle) THEN
    RETURN pcFieldSecurity.
  
  CASE ENTRY(iEntry + 1, pcSecuredFields):
    WHEN "hidden":U THEN
    DO:
      IF LOOKUP(hFieldHandle:TYPE, "fill-in":U) > 0 THEN   /* Can only blank fill-in's */
        ASSIGN hFieldHandle:BLANK = TRUE.
      ASSIGN
        hFieldHandle:SENSITIVE = FALSE
        hFieldHandle:BGCOLOR = 8.
      IF CAN-SET(hFieldHandle,"READ-ONLY":U) THEN
        hFieldHandle:READ-ONLY = TRUE.
      ELSE
        hFieldHandle:SENSITIVE = FALSE.
      IF iFieldPos <> 0 THEN
        ENTRY(iFieldPos,pcFieldSecurity) = "Hidden":U NO-ERROR.
    END.
    WHEN "Read Only":U THEN
    DO:
      ASSIGN
        hFieldHandle:SENSITIVE = FALSE
        hFieldHandle:BGCOLOR = 8.
      IF CAN-SET(hFieldHandle,"READ-ONLY":U) THEN
        hFieldHandle:READ-ONLY = TRUE.
      IF iFieldPos <> 0 THEN
        ENTRY(iFieldPos,pcFieldSecurity) = "ReadOnly":U NO-ERROR.
    END.
  END CASE.
  
  RETURN pcFieldSecurity.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

