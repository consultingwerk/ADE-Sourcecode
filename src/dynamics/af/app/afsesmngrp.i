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
* Copyright (C) 2005-2010 by Progress Software Corporation.          *
* All rights reserved. Prior versions of this work may contain       *
* portions contributed by participants of Possenet.                  *
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

  (v:010005)    Task:    90000010   UserRef:    
                Date:   03/26/2002  Author:     Dynamics Admin User

  Update Notes: 

  (v:010006)    Task:                UserRef:    
                Date:   04/11/2002   Author:     Mauricio J. dos Santos (MJS) 
                                                 mdsantos@progress.com
  Update Notes: Adapted for WebSpeed by changing SESSION:PARAM = "REMOTE" 
                to SESSION:CLIENT-TYPE = "WEBSPEED" in various places.

  (v:010007)    Task:    90000010   UserRef:    
                Date:   03/26/2002  Author:     Dynamics Admin User

  Update Notes: 

---------------------------------------------------*/
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

{src/adm2/globals.i} /* Astra global shared variables */

DEFINE TEMP-TABLE ttProperty NO-UNDO
    FIELD propertyName            AS CHARACTER    /* property name */
    FIELD propertyValue           AS CHARACTER    /* property value */
    INDEX propertyName AS PRIMARY UNIQUE propertyName.

DEFINE VARIABLE giLoop          AS INTEGER    NO-UNDO.
DEFINE VARIABLE glPlipShutting  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghSessTypeCache AS HANDLE     NO-UNDO.

/* temp table of persistent procs started in client session since we started the
   session manager - i.e. procs we must shutdown when this manager closes.
*/
DEFINE TEMP-TABLE ttPersistProc NO-UNDO
FIELD hProc     AS HANDLE
INDEX ObjHandle IS PRIMARY hProc.

DEFINE TEMP-TABLE ttUser NO-UNDO LIKE gsm_user.

{afcheckerr.i &define-only = YES}

{af/app/afttglobalctrl.i}
{af/app/afttsecurityctrl.i}
{af/app/afttpersist.i}
{af/app/aftttranslate.i}
{af/app/logintt.i}

/* Include the file which defines AppServerConnect procedures. */

{adecomm/appsrvtt.i "NEW GLOBAL"}
{adecomm/appserv.i}

IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
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

{aflaunch.i &Define-only = YES }
{launch.i &Define-only = YES }


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

/* Additional definitions needed for call batching */

{afttcombo.i}       /* Combo data            */
{af/app/afttglobalctrl.i}   /* Global control cache  */
{af/app/afttsecurityctrl.i} /* Security Cache        */
{af/app/afttprofiledata.i}  /* Profile Cache         */
{af/app/gsttenmn.i}         /* Entity Mnemonic Cache */

DEFINE VARIABLE cNumericDecimalPoint   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNumericSeparator      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNumericFormat         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAppDateFormat         AS CHARACTER  NO-UNDO.

/* These definitions are used for the info cached for a dynamic container */

{ry/app/rydefrescd.i} /* default result codes */

&GLOBAL-DEFINE defineCache /* Will be undefined in the include */
{src/adm2/ttaction.i}
&GLOBAL-DEFINE defineCache /* Will be undefined in the include */
{src/adm2/tttoolbar.i}
{af/app/aftttranslation.i}

DEFINE VARIABLE gcLogicalContainerName AS CHARACTER  NO-UNDO.

/* Definitions for dynamic call, only defined client side, as we're only using the dynamic call to reduce Appserver hits in this instance */

&IF DEFINED(server-side) = 0 &THEN
{
 src/adm2/calltables.i &PARAM-TABLE-TYPE = "1"
                       &PARAM-TABLE-NAME = "ttSeqType"
}
&ENDIF

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

DEFINE TEMP-TABLE ttViewerCol NO-UNDO
  FIELD dColumn   AS DECIMAL
  FIELD dColWidth AS DECIMAL
  FIELD dMaxLabel AS DECIMAL
  FIELD dNewCol   AS DECIMAL
  INDEX idx1      AS PRIMARY UNIQUE dColumn.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addAsSuperProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addAsSuperProcedure Procedure 
FUNCTION addAsSuperProcedure RETURNS LOGICAL
    ( INPUT phSuperProcedure        AS HANDLE,
      INPUT phProcedure             AS HANDLE   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-filterEvaluateOuterJoins) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD filterEvaluateOuterJoins Procedure 
FUNCTION filterEvaluateOuterJoins RETURNS CHARACTER
  (pcQueryString  AS CHARACTER,
   pcFilterFields AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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
         HEIGHT             = 25.67
         WIDTH              = 61.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */
CREATE WIDGET-POOL NO-ERROR.

ON CLOSE OF THIS-PROCEDURE 
DO:
    DELETE WIDGET-POOL NO-ERROR.

    RUN plipShutdown IN TARGET-PROCEDURE.

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

/* We use MAPI to send mail from Dynamics.  Unfortunately, MAPI changes the current application directory, which causes problems for us.     *
 * So we're going to get the current application directory before we send our mail, store it, and reset it when we're finished. (Issue 5744) */
&IF OPSYS = "WIN32" &THEN
  PROCEDURE GetCurrentDirectoryA EXTERNAL "KERNEL32.DLL":
      DEFINE INPUT        PARAMETER intBufferSize AS LONG.
      DEFINE INPUT-OUTPUT PARAMETER ptrToString   AS MEMPTR.
      DEFINE RETURN       PARAMETER intResult     AS SHORT.
  END PROCEDURE.

  PROCEDURE SetCurrentDirectoryA EXTERNAL "KERNEL32.DLL":
      DEFINE INPUT  PARAMETER chrCurDir AS CHARACTER.
      DEFINE RETURN PARAMETER intResult AS LONG.
  END PROCEDURE.
&ENDIF

&IF DEFINED(server-side) <> 0 &THEN
  /* If we're on the server side, we need to cache all the session type information for all the session
     types so that we don't need to calculate this later. */
  RUN startProcedure IN THIS-PROCEDURE
    ("ONCE|af/app/afsesstypecachep.p":U,
     OUTPUT ghSessTypeCache).
&ENDIF

RUN seedTempUniqueID IN TARGET-PROCEDURE.
RUN buildPersistentProc IN TARGET-PROCEDURE.  /* Build TT of running procedures */
run initializePropertyList in target-procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-activateSession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE activateSession Procedure 
PROCEDURE activateSession :
/*------------------------------------------------------------------------------
  Purpose:     Sets up the gst_session record for a session in a remote
               session.
  Parameters:  <none>
  Notes:       This procedure calls sets all the appropriate session parameters 
               and then calls establishSession which is responsible for 
               actually reactivating the session.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcOldSessionID   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcNewSessionID   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcSessType       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcNumFormat      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcDateFormat     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plReactivate     AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plConfirmExpired AS LOGICAL    NO-UNDO.

  /* Reset the AppServerInfo */
  RUN storeAppServerInfo IN TARGET-PROCEDURE
    ("":U).
  
  IF pcNumFormat <> ? THEN
  DO:
    IF pcNumFormat = "EUROPEAN":U OR
       pcNumFormat = "AMERICAN":U THEN
    DO:
      DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                       "client_NumericSeparator":U,
                       pcNumFormat).
      DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                       "client_DecimalPoint":U,
                       ?).
    END.
    ELSE
    DO:
      DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                       "client_NumericSeparator":U,
                       SUBSTRING(pcNumFormat,1,1)).
      DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                       "client_DecimalPoint":U,
                       SUBSTRING(pcNumFormat,2,1)).
    END.
  END.
  ELSE
  DO:
    DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                     "client_NumericSeparator":U,
                     ?).
    DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                     "client_DecimalPoint":U,
                     ?).
  END.
    
  DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                   "client_DateFormat":U,
                   pcDateFormat).
  
  DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                   "client_SessionType":U,
                   pcSessType).
  
  DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                   "client_OldSessionID":U,
                   pcOldSessionID).
  
  DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                   "client_NewSessionID":U,
                   pcNewSessionID).

  RUN establishSession (plReactivate, plConfirmExpired) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    RETURN ERROR RETURN-VALUE.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adjustWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adjustWidgets Procedure 
PROCEDURE adjustWidgets :
/*------------------------------------------------------------------------------
  Purpose:     To resize standard frame to fit new labels (not an SDF frame)
  Parameters:  input object handle
               input frame handle
               input number to add to all columns
  Notes:       called from translatewidgets from widgetwalk procedure.  This procedure
               will move all the widgets on the frame as well.  So if you want to 
               resize the frame, but keep the widgets where they are, don't use it.
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
  DEFINE VARIABLE hPopupHandle              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFieldPopupMapping        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDFLabelHandle           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSDFLabels                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dSDFRow                   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hSDFFrame                 AS HANDLE     NO-UNDO.
  define variable dCol                      as decimal    no-undo.
  define variable cLabelText                as character  no-undo.

    {get AllFieldHandles cAllFieldHandles phObject}.
    /* Separate the {get}s because only viewers have FieldPopupMapping */ 
    {get FieldPopupMapping cFieldPopupMapping phObject} NO-ERROR.
  
  field-loop:
  DO iLoop = 1 TO NUM-ENTRIES(cAllFieldHandles):  
    ASSIGN hWidget = WIDGET-HANDLE(ENTRY(iLoop, cAllFieldHandles)) NO-ERROR.
  
    IF NOT VALID-HANDLE(hWidget) THEN
        NEXT field-loop.
  
    /* SDFs need to be resized individually */  
    IF hWidget:TYPE = "PROCEDURE":U 
    THEN DO:
        {get Col dCol hWidget}.
        
        FIND FIRST ttViewerCol
             WHERE ttViewerCol.dColumn = dCol
             NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ttViewerCol THEN
          FIND FIRST ttViewerCol 
               NO-LOCK NO-ERROR.
        
        {get ContainerHandle hSDFFrame hWidget}.
        
        IF VALID-HANDLE(hSDFFrame) 
        THEN DO:
            RUN resizeSDFFrame IN TARGET-PROCEDURE
                               (INPUT hWidget,   /* The SDF procedure handle */
                                INPUT hSDFFrame, /* The SDF frame */
                                INPUT ttViewerCol.dNewCol - dCol). /* The amount it needs to move */
            
            {get LabelHandle hSDFLabelHandle hWidget} NO-ERROR.
            IF hSDFLabelHandle <> ? THEN
                ASSIGN hSDFLabelHandle:VISIBLE = YES
                       cSDFLabels = IF cSDFLabels = "":U THEN STRING(hSDFLabelHandle) ELSE (cSDFLabels + ",":U + STRING(hSDFLabelHandle)).

            /* Move the SDF */
            {get Row dSdfRow hWidget}.
            IF NOT ERROR-STATUS:ERROR THEN
                RUN repositionObject IN hWidget (INPUT dSDFRow,
                                                 INPUT ttViewerCol.dNewCol) NO-ERROR.
            NEXT field-loop.
        END.    /* valid SDF frame */        
    END.    /* SDFs */
  
    IF LOOKUP(hWidget:TYPE, "text,button,fill-in,selection-list,editor,combo-box,radio-set,slider,toggle-box":U) = 0
    OR NOT CAN-QUERY(hWidget, "column":U) THEN 
        NEXT field-loop.
    
    /* Do not move any SDF field labels */
    IF hWidget:TYPE = "TEXT" AND 
       LOOKUP(STRING(hWidget),cSDFLabels) > 0 THEN
      NEXT field-loop.
    
    /* got a valid widget to move */
    ASSIGN hSideLabel = ?
           hSideLabel = hWidget:SIDE-LABEL-HANDLE
           NO-ERROR.

    FIND FIRST ttViewerCol
         WHERE ttViewerCol.dColumn = hWidget:COLUMN
         NO-LOCK NO-ERROR.
    
    /* If we can't find a column record, don't move the widget */
    IF AVAILABLE ttViewerCol THEN
        ASSIGN hWidget:COLUMN = ttViewerCol.dNewCol NO-ERROR.
    
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
        ASSIGN hSideLabel:x = hWidget:x.
    
    /* And finally, check if the widget has a popup button (calendar or calculator). *
     * If it does, move the popup as well.                                           */
    IF cFieldPopupMapping <> "":U AND LOOKUP(STRING(hWidget), cFieldPopupMapping) > 0
    THEN DO:
        ASSIGN hPopupHandle = WIDGET-HANDLE(ENTRY(LOOKUP(STRING(hWidget), cFieldPopupMapping) + 1, cFieldPopupMapping)) NO-ERROR.
        IF VALID-HANDLE(hPopupHandle) THEN
            ASSIGN hPopupHandle:COLUMN = hPopupHandle:COLUMN + (IF AVAILABLE ttViewerCol
                                                                THEN (ttViewerCol.dNewCol - ttViewerCol.dColumn)
                                                                ELSE 0) NO-ERROR.
    END.
  END.  /* FIELD-LOOP: */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* adjustWidgets */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-aferrorlgp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aferrorlgp Procedure 
PROCEDURE aferrorlgp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  pcSummaryList           AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER  pcFullList              AS CHARACTER  NO-UNDO.
    
    &IF DEFINED(server-side) = 0 &THEN
      RUN af/app/afseserrlgp.p ON gshAstraAppServer
        (INPUT pcSummaryList,
         INPUT pcFullList) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                          ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
        DEFINE VARIABLE iLoop                           AS INTEGER    NO-UNDO.
        DEFINE VARIABLE cMessage1                       AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cMessage2                       AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cUserObj                        AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE dUserObj                        AS DECIMAL INITIAL 0 NO-UNDO.
        DEFINE VARIABLE cErrorGroup                     AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE iErrorCode                      AS INTEGER    NO-UNDO.
        DEFINE VARIABLE cErrorCode                      AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cTable                          AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cField                          AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cProgram                        AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE iStart                          AS INTEGER    NO-UNDO.
        DEFINE VARIABLE iPos1                           AS INTEGER    NO-UNDO.
        DEFINE VARIABLE iPos2                           AS INTEGER    NO-UNDO.
        DEFINE VARIABLE iLen                            AS INTEGER    NO-UNDO.
        
        /* get current user */
        cUserObj = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                        INPUT "currentUserObj":U,
                                                        INPUT NO).
        ASSIGN dUserObj = DECIMAL(cUserObj) NO-ERROR.
        ERROR-STATUS:ERROR = NO.
        
        DEFINE BUFFER bgst_error_log FOR gst_error_log.
        
        trn-block:
        DO FOR bgst_error_log TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block
           iLoop = 1 TO NUM-ENTRIES(pcSummaryList):
        
          ASSIGN
            cMessage1 = ENTRY(iLoop, pcSummaryList)
            cMessage2 = ENTRY(iLoop, pcFullList)
            .
        
          ASSIGN
            cErrorGroup = "":U
            cErrorCode = "":U
            iErrorCode = 0
            cTable = "":U
            cField = "":U
            cProgram = "":U
            .
        
          /* work out table, field, error code, error group and program from message text */
          ASSIGN iStart = INDEX(cMessage2, CHR(10) + CHR(10) + "*** Error: ":U).
          IF iStart > 0 THEN
            ASSIGN iStart = INDEX(cMessage2, "*** Error: ":U, iStart).
        
          IF iStart > 0 THEN
          DO:
            /* Work out error group and code */
            ASSIGN iPos1 = 0 iPos2 = 0.
            iPos1 = INDEX(cMessage2, "-":U, iStart).    /* look for hyphen */    
            IF iPos1 > iStart THEN iPos2 = INDEX(cMessage2, " ":U, ipos1).    /* look for space */ 
            IF iPos1 > iStart AND iPos2 = 0 THEN iPos2 = LENGTH(cMessage2) + 1.
            IF iPos1 > iStart AND iPos2 > iPos1 THEN
            DO:
              ASSIGN
                cErrorGroup = SUBSTRING(cMessage2, iStart + 11, iPos1 - (iStart + 11))
                cErrorCode  = SUBSTRING(cMessage2, iPos1 + 1, iPos2 - (iPos1 + 1))
              .
              ASSIGN iErrorCode = INTEGER(cErrorCode) NO-ERROR.
            END.
        
            /* work out table */
            ASSIGN iPos1 = 0 iPos2 = 0.
            iPos1 = INDEX(cMessage2, "table: ":U, iStart).    /* look for placeholder */    
            IF iPos1 > iStart THEN iPos2 = INDEX(cMessage2, " ":U, ipos1 + 7).    /* look for space */ 
            IF iPos1 > iStart AND iPos2 = 0 THEN iPos2 = LENGTH(cMessage2) + 1.
            IF iPos1 > iStart AND iPos2 > iPos1 THEN
            DO:
              ASSIGN
                ctable = SUBSTRING(cMessage2, iPos1 + 7, iPos2 - (iPos1 + 7))
              .
            END.
        
            /* work out field */
            ASSIGN iPos1 = 0 iPos2 = 0.
            iPos1 = INDEX(cMessage2, "field: ":U, iStart).    /* look for placeholder */    
            IF iPos1 > iStart THEN iPos2 = INDEX(cMessage2, " ":U, ipos1 + 7).    /* look for space */ 
            IF iPos1 > iStart AND iPos2 = 0 THEN iPos2 = LENGTH(cMessage2) + 1.
            IF iPos1 > iStart AND iPos2 > iPos1 THEN
            DO:
              ASSIGN
                cfield = SUBSTRING(cMessage2, iPos1 + 7, iPos2 - (iPos1 + 7))
              .
            END.
        
            /* work out program */
            ASSIGN iPos1 = 0 iPos2 = 0.
            iPos1 = INDEX(cMessage2, "program: ":U, iStart).    /* look for placeholder */    
            IF iPos1 > iStart THEN iPos2 = INDEX(cMessage2, " ":U, ipos1 + 9).    /* look for space */ 
            IF iPos1 > iStart AND iPos2 = 0 THEN iPos2 = LENGTH(cMessage2) + 1.
            IF iPos1 > iStart AND iPos2 > iPos1 THEN
            DO:
              ASSIGN
                cProgram = SUBSTRING(cMessage2, iPos1 + 9, iPos2 - (iPos1 + 9))
              .
            END.
        
          END.
        
          /* write to error log */
          CREATE bgst_error_log NO-ERROR.
          IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
        
          ASSIGN
            bgst_error_log.business_logic_error = SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U
            bgst_error_log.error_group = cErrorGroup
            bgst_error_log.error_number = iErrorCode
            bgst_error_log.error_date = TODAY
            bgst_error_log.error_time = TIME
            bgst_error_log.error_message = cMessage1
            bgst_error_log.error_in_program = cProgram
            bgst_error_log.owning_entity_mnemonic = "":U
            bgst_error_log.owning_obj = 0
            bgst_error_log.user_obj = dUserObj
            NO-ERROR.
          IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
        
          VALIDATE bgst_error_log NO-ERROR.
          IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
        
        END.
        {af/sup2/afcheckerr.i}   /* check for errors */
    &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-afgetglocp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afgetglocp Procedure 
PROCEDURE afgetglocp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT  PARAMETER TABLE FOR ttGlobalControl.
    
    &IF DEFINED(server-side) = 0 &THEN
      RUN af/app/afsesgetglcp.p ON gshAstraAppServer
        (OUTPUT TABLE ttGlobalControl) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                          ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
        {af/app/afsesgetglcp.i}
    &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-afmessagep) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afmessagep Procedure 
PROCEDURE afmessagep :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE  INPUT PARAMETER pcMessageList         AS CHARACTER  NO-UNDO.
    DEFINE  INPUT PARAMETER pcButtonList          AS CHARACTER  NO-UNDO.
    DEFINE  INPUT PARAMETER pcMessageTitle        AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcSummaryList         AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFullList            AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcNewButtonList       AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcNewTitle            AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER plUpdateErrorLog      AS LOGICAL    NO-UNDO.
    DEFINE OUTPUT PARAMETER plSuppressDisplay     AS LOGICAL    NO-UNDO.
    
    &IF DEFINED(server-side) = 0 &THEN
      RUN af/app/afsesmessagep.p ON gshAstraAppServer
        (INPUT  pcMessageList,    
         INPUT  pcButtonList,     
         INPUT  pcMessageTitle,   
         OUTPUT pcSummaryList,    
         OUTPUT pcFullList,       
         OUTPUT pcNewButtonList,  
         OUTPUT pcNewTitle,       
         OUTPUT plUpdateErrorLog, 
         OUTPUT plSuppressDisplay) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                          ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
        DEFINE VARIABLE iEntries                      AS INTEGER    NO-UNDO.
        DEFINE VARIABLE iMessageLoop                  AS INTEGER    NO-UNDO.
        DEFINE VARIABLE iLoop                         AS INTEGER    NO-UNDO.
        DEFINE VARIABLE cAmpersandEntry               AS CHARACTER  NO-UNDO. 
        DEFINE VARIABLE cCleanMessage                 AS CHARACTER  NO-UNDO. 
        DEFINE VARIABLE cFullMessage                  AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cMessage                      AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cMessage1                     AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cMessage2                     AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cTable                        AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cField                        AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cProg1                        AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cProg2                        AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cProg12                       AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cErrorGroup                   AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cErrorCode                    AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE iErrorCode                    AS INTEGER    NO-UNDO.
        DEFINE VARIABLE cErrorInclude                 AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cPropertyList                 AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE dLanguageObj                  AS DECIMAL INITIAL 0 NO-UNDO.
        DEFINE VARIABLE dUserObj                      AS DECIMAL INITIAL 0 NO-UNDO.
        DEFINE VARIABLE cOriginalText                 AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cTranslatedText               AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE ipos1                         AS INTEGER    NO-UNDO.
        DEFINE VARIABLE ipos2                         AS INTEGER    NO-UNDO.
        DEFINE VARIABLE ilen                          AS INTEGER    NO-UNDO.
        DEFINE VARIABLE iCode                         AS INTEGER    NO-UNDO.
        DEFINE VARIABLE cCode                         AS CHARACTER  NO-UNDO.
        
        /* remove trailing NL characters which are sometimes added by the ADM */
        pcMessageList = TRIM(pcMessageList,"~n":U).
        
        cPropertyList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                         "currentUserObj,currentLanguageObj":U, NO).
        
        dUserObj     = DECIMAL(ENTRY(1,cPropertyList,CHR(3))) NO-ERROR.
        dLanguageObj = DECIMAL(ENTRY(2,cPropertyList,CHR(3))) NO-ERROR.
        plUpdateErrorLog = NO.
        
        message-loop:
        DO iMessageLoop = 1 TO NUM-ENTRIES(pcMessageList, CHR(3)):
            cFullMessage = ENTRY(iMessageLoop, pcMessageList, CHR(3)).
        CASE NUM-ENTRIES(cFullMessage, CHR(4)):
                WHEN 3 THEN   /* standard ADM2 */
                  ASSIGN
                    cMessage  = ENTRY(1,cFullMessage, CHR(4))
                    cfield    = ENTRY(2,cFullMessage, CHR(4))
                    ctable    = ENTRY(3,cFullMessage, CHR(4))
                    cprog1    = "":U
                    cprog2    = "":U.
                WHEN 5 THEN   /* Astra enhanced ADM2 */
                  ASSIGN
                    cMessage  = ENTRY(1,cFullMessage, CHR(4))
                    cfield    = ENTRY(2,cFullMessage, CHR(4))
                    ctable    = ENTRY(3,cFullMessage, CHR(4))
                    cprog1    = ENTRY(4,cFullMessage, CHR(4))
                    cprog2    = ENTRY(5,cFullMessage, CHR(4)).
                OTHERWISE   /* unsupported */
                  ASSIGN
                    cMessage  = ENTRY(1,cFullMessage, CHR(4))
                    cfield    = "":U
                    ctable    = "":U
                    cprog1    = "":U
                    cprog2    = "":U.
          END CASE.
          
          IF cfield = "?":U THEN ASSIGN cField = "":U.
          IF ctable = "?":U THEN ASSIGN ctable = "":U.
        
          /* now see if actual message part is structured with caret delimiters */
              CASE NUM-ENTRIES(cMessage, "^":U):
                WHEN 3 THEN   /* old Astra 1 way */
                  ASSIGN
                    cErrorGroup   = ENTRY(1,cMessage, "^":U)      
                    cErrorCode    = ENTRY(2,cMessage, "^":U)      
                    cProg12       = ENTRY(3,cMessage, "^":U)     
                    cErrorInclude = "":U.
                WHEN 4 THEN   /* new Astra way */
                  ASSIGN
                    cErrorGroup   = ENTRY(1,cMessage, "^":U)      
                    cErrorCode    = ENTRY(2,cMessage, "^":U)      
                    cProg12       = ENTRY(3,cMessage, "^":U)     
                    cErrorInclude = ENTRY(4,cMessage, "^":U).
                OTHERWISE   /* not Astra structured - must be hard-coded */
                  ASSIGN
                    cErrorGroup   = "":U      
                    cErrorCode    = "":U      
                    cProg12       = "":U     
                    cErrorInclude = "":U.
              END CASE.
        
          IF cProg12 = "?":U THEN ASSIGN cProg12 = "":U.
          IF cErrorInclude = "?":U THEN ASSIGN cErrorInclude = "":U.
          
          /* hard-coded message with insertion codes */
          IF cErrorGroup = "?":U THEN
            ASSIGN
              cMessage = cErrorCode
              cErrorGroup   = "":U      
              cErrorCode    = "":U. 
        
          plSuppressDisplay = NO.
          IF NUM-ENTRIES(cErrorGroup,"|":U) = 2 THEN  /* old Astra way of adding |suppress to error code */
            ASSIGN
              plSuppressDisplay = ENTRY(2,cErrorGroup,"|":U) = "suppress":U
              cErrorGroup = ENTRY(1,cErrorGroup,"|":U).
          
          ASSIGN cErrorCode  = TRIM(cErrorCode)
                 cErrorGroup = TRIM(cErrorGroup).
        
          /* make gsc_error not available so that hard coded messages do not get over written with the previous loop's error record */
          FIND gsc_error NO-LOCK WHERE gsc_error.ERROR_obj = -1 NO-ERROR.
        
          /* now we have bits, read message file if appropriate */
          iErrorCode = INTEGER(cErrorCode) NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
            ASSIGN iErrorCode = 0.
          
          IF cErrorGroup <> "":U AND iErrorCode <> 0 THEN
          DO:
            /* look for error in logged in language */
            FIND FIRST gsc_error NO-LOCK
                 WHERE gsc_error.error_group  = cErrorGroup
                   AND gsc_error.error_number = iErrorCode
                   AND gsc_error.language_obj = dLanguageObj
                 NO-ERROR.
        
            /* If unsuccessful, get user language and try this */
            IF NOT AVAILABLE gsc_error
            THEN DO:
                FIND FIRST gsm_user NO-LOCK
                     WHERE gsm_user.user_obj = dUserObj
                     NO-ERROR.

                IF AVAILABLE gsm_user THEN
                    FIND FIRST gsc_error NO-LOCK
                         WHERE gsc_error.error_group  = cErrorGroup
                           AND gsc_error.error_number = iErrorCode
                           AND gsc_error.language_obj = gsm_user.language_obj
                         NO-ERROR.
            END.
        
            /* If unsuccessful, get system language from gsc_global_control */
            IF NOT AVAILABLE gsc_error THEN
            DO:
              FIND FIRST gsc_global_control NO-LOCK NO-ERROR.

              IF AVAILABLE gsc_global_control THEN
                  FIND FIRST gsc_error NO-LOCK
                       WHERE gsc_error.error_group  = cErrorGroup
                         AND gsc_error.error_number = iErrorCode
                         AND gsc_error.language_obj = gsc_global_control.default_language_obj
                       NO-ERROR.
            END.
            
            /* If unsuccessful, get message in source language */
            IF NOT AVAILABLE gsc_error THEN
              FIND FIRST gsc_error NO-LOCK
                   WHERE gsc_error.error_group     = cErrorGroup
                     AND gsc_error.error_number    = iErrorCode
                     AND gsc_error.source_language = TRUE
                   NO-ERROR.
            
            /* If unsuccessful, get message in any language */
            IF NOT AVAILABLE gsc_error THEN
              FIND FIRST gsc_error NO-LOCK
                   WHERE gsc_error.error_group     = cErrorGroup
                     AND gsc_error.error_number    = iErrorCode
                   NO-ERROR.
          END.  /* if error group and error code specified */
        
          IF AVAILABLE gsc_error THEN
          DO:
            ASSIGN
              cMessage1 = gsc_error.ERROR_summary_description
              cMessage2 = gsc_error.ERROR_full_description.
            IF gsc_error.UPDATE_error_log THEN  
              plUpdateErrorLog = YES.
          END.
          ELSE
          DO:
              /* Replace all the ampersand characters (&), if they are not to be used for substitution */
              cCleanMessage = "":U.
              DO iEntries = 1 TO NUM-ENTRIES(cMessage, "&":U):
                  cAmpersandEntry = ENTRY(iEntries, cMessage, "&":U).
        
                  IF iEntries                                                       >= 2 AND
                     LOOKUP(SUBSTRING(cAmpersandEntry, 1, 1), "1,2,3,4,5,6,7,8,9":U) > 0 THEN
                      cCleanMessage = cCleanMessage + "&" + cAmpersandEntry.
                  ELSE
                      cCleanMessage = cCleanMessage + (IF cCleanMessage = "":U THEN "":U ELSE "&&":U) + cAmpersandEntry.
              END.    /* loop through word */
        
              ASSIGN
                  cMessage1 = cCleanMessage
                  cMessage2 = cCleanMessage.
          END.  /*  n/a error */
        
          /* See if can work out error group and code from standard Progress Message */
          IF cErrorGroup = "":U AND iErrorCode = 0 THEN
          DO:
            ASSIGN
              ipos1 = R-INDEX(cMessage1, "(":U) + 1  
              ipos2 = R-INDEX(cMessage1, ")":U) - 1   
              ilen = (ipos2 - ipos1) + 1.
            IF ipos1 > 1 AND iLen > 0 THEN
            DO:
              ASSIGN 
                cCode = SUBSTRING(cMessage1, ipos1, ilen)
                iCode = 0.
              iCode = INTEGER(cCode) NO-ERROR.
              iErrorCode = iCode.
              IF iErrorCode <> 0 THEN ASSIGN cErrorGroup = "PSC":U.
            END.
          END.
        
          /* Translate insertion codes */
          DO iloop = 1 TO NUM-ENTRIES(cErrorInclude, "|":U):
            cOriginalText = ENTRY(iloop, cErrorInclude, "|":U).
        
            IF cOriginalText <> "":U THEN
            DO:
                cTranslatedText = DYNAMIC-FUNCTION("translatePhrase":U IN gshTranslationManager,
                                                   INPUT cOriginalText,
                                                   INPUT IF AVAILABLE gsc_error THEN gsc_error.LANGUAGE_obj ELSE dLanguageObj).                                                               
                entry(iLoop, cErrorInclude, '|':u) = replace(entry(iLoop, cErrorInclude, '|':u), cOriginalText, cTranslatedText).
            END.    /* original text blank */
          END.
        
          /* Do substitutions (even if hard coded message - for cmessage1 and cmessage2) */
          ASSIGN
            cMessage1 = SUBSTITUTE(cMessage1,
                                   IF NUM-ENTRIES(cErrorInclude,"|":U) >= 1 THEN ENTRY(1,cErrorInclude,"|":U) ELSE "":U,
                                   IF NUM-ENTRIES(cErrorInclude,"|":U) >= 2 THEN ENTRY(2,cErrorInclude,"|":U) ELSE "":U,
                                   IF NUM-ENTRIES(cErrorInclude,"|":U) >= 3 THEN ENTRY(3,cErrorInclude,"|":U) ELSE "":U,
                                   IF NUM-ENTRIES(cErrorInclude,"|":U) >= 4 THEN ENTRY(4,cErrorInclude,"|":U) ELSE "":U,
                                   IF NUM-ENTRIES(cErrorInclude,"|":U) >= 5 THEN ENTRY(5,cErrorInclude,"|":U) ELSE "":U,
                                   IF NUM-ENTRIES(cErrorInclude,"|":U) >= 6 THEN ENTRY(6,cErrorInclude,"|":U) ELSE "":U,
                                   IF NUM-ENTRIES(cErrorInclude,"|":U) >= 7 THEN ENTRY(7,cErrorInclude,"|":U) ELSE "":U,
                                   IF NUM-ENTRIES(cErrorInclude,"|":U) >= 8 THEN ENTRY(8,cErrorInclude,"|":U) ELSE "":U,
                                   IF NUM-ENTRIES(cErrorInclude,"|":U) >= 9 THEN ENTRY(9,cErrorInclude,"|":U) ELSE "":U
                                   )
            cMessage2 = SUBSTITUTE(cMessage2,
                                   IF NUM-ENTRIES(cErrorInclude,"|":U) >= 1 THEN ENTRY(1,cErrorInclude,"|":U) ELSE "":U,
                                   IF NUM-ENTRIES(cErrorInclude,"|":U) >= 2 THEN ENTRY(2,cErrorInclude,"|":U) ELSE "":U,
                                   IF NUM-ENTRIES(cErrorInclude,"|":U) >= 3 THEN ENTRY(3,cErrorInclude,"|":U) ELSE "":U,
                                   IF NUM-ENTRIES(cErrorInclude,"|":U) >= 4 THEN ENTRY(4,cErrorInclude,"|":U) ELSE "":U,
                                   IF NUM-ENTRIES(cErrorInclude,"|":U) >= 5 THEN ENTRY(5,cErrorInclude,"|":U) ELSE "":U,
                                   IF NUM-ENTRIES(cErrorInclude,"|":U) >= 6 THEN ENTRY(6,cErrorInclude,"|":U) ELSE "":U,
                                   IF NUM-ENTRIES(cErrorInclude,"|":U) >= 7 THEN ENTRY(7,cErrorInclude,"|":U) ELSE "":U,
                                   IF NUM-ENTRIES(cErrorInclude,"|":U) >= 8 THEN ENTRY(8,cErrorInclude,"|":U) ELSE "":U,
                                   IF NUM-ENTRIES(cErrorInclude,"|":U) >= 9 THEN ENTRY(9,cErrorInclude,"|":U) ELSE "":U
                                   )
            .
        
          /* rebuild error message using translated text in nice format (keep in synch, i.e. summary and full have some no. of messages) */  
          IF cProg12 = "":U AND cProg1 <> "":U THEN
            ASSIGN cProg12 = cProg1 + (IF cProg2 <> "":U THEN (":":U + cProg2) ELSE "":U).
          
          /* The number of messages is determined by the number of Summary messages, since a gsc_error record
             might have zero detail texts. */
          ASSIGN pcFullList = pcFullList
                            + (IF pcSummaryList <> "":U THEN CHR(3) ELSE "":U)
                            + TRIM(cMessage2).
          /* Only add extra text if this message comes from the gsc_error table */
          if cErrorGroup ne '' then
              assign pcFullList = pcFullList + CHR(10) + CHR(10)
                                + "*** Message Code: "
                                + CAPS(cErrorGroup) + "-":U + STRING(iErrorCode) + " ":U
                                + (IF cTable <> "":U THEN ("Table: " + TRIM(cTable) + " ":U) ELSE "":U)
                                + (IF cField <> "":U THEN ("Field: " + TRIM(cField) + " ":U) ELSE "":U) 
                                + (IF cProg12 <> "":U THEN ("Program: " + TRIM(cProg12)) ELSE "":U).

          ASSIGN pcSummaryList = pcSummaryList
                               + (IF pcSummaryList <> "":U THEN CHR(3) ELSE "":U)
                               + TRIM(cMessage1)
                               + IF (cErrorGroup <> "PSC":U AND cErrorGroup <> "":U) THEN (" (":U + CAPS(cErrorGroup) + ":":U + STRING(iErrorCode) + ")":U) ELSE "":U. 
        END.  /* message-loop */
        
        /* Translate title */
        ASSIGN pcNewTitle = pcMessageTitle.
        pcNewTitle = DYNAMIC-FUNCTION("translatePhrase":U IN gshTranslationManager,
                                      INPUT pcMessageTitle,
                                      INPUT IF AVAILABLE gsc_error THEN gsc_error.LANGUAGE_obj ELSE dLanguageObj).
        
        /* Translate buttons */
        ASSIGN pcNewButtonList = pcButtonList.        
        
        DO iloop = 1 TO NUM-ENTRIES(pcButtonList):
          ASSIGN cOriginalText = ENTRY(iloop, pcButtonList).
        
          IF cOriginalText <> "":U THEN
          DO:
              cTranslatedText = DYNAMIC-FUNCTION("translatePhrase":U IN gshTranslationManager,
                                                 INPUT cOriginalText,
                                                 INPUT IF AVAILABLE gsc_error THEN gsc_error.LANGUAGE_obj ELSE dLanguageObj).
              entry(iLoop, pcNewButtonList) = replace(entry(iLoop, pcNewButtonList), cOriginalText, cTranslatedText).
          END.  /* original text not blank */
        END.
    &ENDIF 
    error-status:error = no.
    return.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

  /* Next interpret / translate the messages */
  RUN afmessagep IN TARGET-PROCEDURE 
                  (INPUT pcMessageList,
                   INPUT pcButtonList,
                   INPUT pcMessageTitle,
                  OUTPUT cSummaryMessages,
                  OUTPUT cFullMessages,
                  OUTPUT cButtonList,
                  OUTPUT cMessageTitle,
                  OUTPUT lUpdateErrorLog,
                  OUTPUT lSuppressDisplay).

  /* Display message if not remote and not suppressed */
  IF NOT lSuppressDisplay THEN
      cSuppressDisplay = DYNAMIC-FUNCTION("getPropertyList":U IN TARGET-PROCEDURE, INPUT "suppressDisplay":U, INPUT YES).
  ELSE 
      cSuppressDisplay = "YES":U.

  ASSIGN lSuppressDisplay = (cSuppressDisplay = "YES":U).

  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) AND NOT lSuppressDisplay THEN
  DO:
    ASSIGN gcLogicalContainerName = "afmessaged":U.
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
    ASSIGN gcLogicalContainerName = "":U.

    IF iButtonPressed > 0 AND iButtonPressed <= NUM-ENTRIES(pcButtonList) THEN
      ASSIGN pcButtonPressed = ENTRY(iButtonPressed, pcButtonList).  /* Pass back untranslated button pressed */
    ELSE
      ASSIGN pcButtonPressed = pcDefaultButton.
  END.
  ELSE
    ASSIGN pcButtonPressed = pcDefaultButton.  /* If remote, assume default button */

  /* If remote, or update error log set to YES, then update error log and send an email if possible */
  IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) OR lUpdateErrorLog OR lSuppressDisplay THEN
  DO:
    RUN updateErrorLog IN TARGET-PROCEDURE (INPUT cSummaryMessages,
                                             INPUT cFullMessages).
    RUN notifyUser IN TARGET-PROCEDURE (INPUT 0,                           /* default user */
                                        INPUT "":U,                        /* default user */
                                        INPUT "email":U,                   /* by email */
                                        INPUT "Progress Dynamics " + cMessageTitle,    /* ICF message */
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

  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U)
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

&IF DEFINED(EXCLUDE-containerCacheUpfront) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE containerCacheUpfront Procedure 
PROCEDURE containerCacheUpfront :
/*------------------------------------------------------------------------------
  Purpose:     This procedures makes an Appserver call to cache all information
               needed to build a dynamic container.
  Parameters:  <none>
  Notes:       Deprecated.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcLogicalObjectName      AS CHARACTER  NO-UNDO. /* Needed for security & container retrieval */
DEFINE INPUT  PARAMETER pcAttributeCode          AS CHARACTER  NO-UNDO. /* Needed for security & container retrieval */
DEFINE INPUT  PARAMETER plReturnEntireContainer  AS LOGICAL    NO-UNDO. /* Needed for container retrieval */
DEFINE INPUT  PARAMETER plDesignMode             AS LOGICAL    NO-UNDO. /* Needed for container retrieval */
DEFINE INPUT  PARAMETER pcToolbar                AS CHARACTER  NO-UNDO. /* Needed for toolbar retrieval, blank for ALL */
DEFINE INPUT  PARAMETER pcBandList               AS CHARACTER  NO-UNDO. /* Needed for toolbar retrieval, blank for ALL */
DEFINE OUTPUT PARAMETER plContainerSecured       AS LOGICAL    NO-UNDO. /* Is the container, well...secured */

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
  Notes:       An event exists in visual.i that runs this procedure
               on help anywhere of the frame.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  phObject                    AS HANDLE       NO-UNDO.
  DEFINE INPUT PARAMETER  phWidget                    AS HANDLE       NO-UNDO.

  DEFINE VARIABLE cContainerFilename                  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cContainerLogicalObject             AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cObjectFilename                     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cItemName                           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cLogicalObject                      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cObjectType                         AS CHARACTER    NO-UNDO.

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
    cLogicalObject = DYNAMIC-FUNCTION('getlogicalobjectname':U IN phObject) NO-ERROR.

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

    /* Check whether object is itself a window */
    cObjectType = DYNAMIC-FUNCTION("getObjectType":U IN phObject) NO-ERROR.
    IF LOOKUP(cObjectType, "Window,SmartWindow":U) > 0 THEN
      ASSIGN cContainerFileName = cObjectFileName
             hContainer         = ?.
    ELSE DO:  /* get container handle */        
      hContainer = DYNAMIC-FUNCTION('getContainerSource':U IN phObject) NO-ERROR.
      IF NOT VALID-HANDLE(hContainer) THEN
        ASSIGN hContainer = phObject.
    END.

    /* Check whether current field is a smartDataField. If so, we need to get it's parent 
       first to find container */
    IF VALID-HANDLE(hContainer) AND cObjectType = "smartDataField":U THEN 
    DO:
       
       /* Get logical object name for SDF's container */
       cLogicalObject = "":U.
       cLogicalObject = DYNAMIC-FUNCTION('getlogicalobjectname':U IN hContainer) NO-ERROR.
       
       /* use logical object name if dynamic */
       IF cLogicalObject <> "":U THEN
         ASSIGN cObjectFilename = cLogicalObject.
       ELSE
       DO:
         /* get filename of object and strip off path */
         ASSIGN iPosn = R-INDEX(hContainer:FILE-NAME,"/":U) + 1.
         IF iPosn = 1 THEN
             ASSIGN iPosn = R-INDEX(hContainer:FILE-NAME,"~\":U) + 1.
         ASSIGN cObjectFilename = SUBSTRING(hContainer:FILE-NAME,iPosn).
       END.

       hContainer = DYNAMIC-FUNCTION('getContainerSource':U IN hContainer).
       IF NOT VALID-HANDLE(hContainer) THEN
         ASSIGN hContainer = phObject.
    END.


    IF VALID-HANDLE(hContainer) THEN
    DO:
      /* Get logical object names (for dynamic objects) */
      cContainerLogicalObject = DYNAMIC-FUNCTION('getlogicalobjectname':U IN hContainer) NO-ERROR.

      /* use logical object name if dynamic */
      IF cContainerLogicalObject <> "":U THEN
        ASSIGN cContainerFilename = cContainerLogicalObject.
      ELSE
      DO:
        ASSIGN iPosn = R-INDEX(hContainer:FILE-NAME,"/":U) + 1.
        IF iPosn = 1 THEN
            ASSIGN iPosn = R-INDEX(hContainer:FILE-NAME,"~\":U) + 1.
        ASSIGN cContainerFilename = SUBSTRING(hContainer:FILE-NAME,iPosn).
      END.
    END. /* End Valid hContainer */
  END. /* End valid-handle hObject */
  ELSE
    ASSIGN cContainerFilename = "<Unknown>":U
           cObjectFilename = "<Unknown>":U.        

  IF VALID-HANDLE(phWidget) AND CAN-QUERY(phWidget, "NAME":U) THEN 
  DO:
    cObjectType = DYNAMIC-FUNCTION("getObjectType":U IN phObject) NO-ERROR.
    IF cObjectType = "smartDataField":U THEN
       ASSIGN cItemName = DYNAMIC-FUNCTION("getFieldName":U IN phObject) NO-ERROR.

    IF cItemName = "":U THEN
      ASSIGN cItemName = {fnarg widgetName phWidget phObject} NO-ERROR.

    IF cItemName = "":U THEN
          ASSIGN cItemName = phWidget:NAME.

  END.
  ELSE
      ASSIGN cItemName = "<Unknown>":U.

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
     RUN showMessages IN TARGET-PROCEDURE (INPUT {af/sup2/aferrortxt.i 'AF' '19' '?' '?' 'help' cHelpFile},
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Progress Dynamics Help",
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
    ELSE IF iHelpContext > 0 THEN
      SYSTEM-HELP
        cHelpFound
        CONTEXT iHelpContext.
    ELSE 
      SYSTEM-HELP
         cHelpFound CONTENTS.

  END.
  ELSE IF INDEX(cHelpFound, ".chm":U) > 0 
       OR INDEX(cHelpFound, ".htm":U) > 0  THEN  /* HTML Help */
  DO:
    IF cHelpText <> "":U  THEN
      SYSTEM-HELP 
         cHelpFound HELP-TOPIC cHelpText.
    ELSE IF iHelpContext > 0 THEN
      SYSTEM-HELP cHelpFound  CONTEXT iHelpContext.     
    ELSE
      SYSTEM-HELP
         cHelpFound CONTENTS.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createContextScope) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createContextScope Procedure 
PROCEDURE createContextScope :
/*------------------------------------------------------------------------------
  Purpose:     This procedure allows for the creation of a context scope record
               at either the user or session level. That named context scope
               can then be used to group context together that applies for 
               different categories of context. A transaction would be an 
               example of a valid context scope.
  Parameters:
    plSessionScope    -  Indicates whether this is session scope or user scope.
    pcScopeName       -  Name of scope to be created. May be blank. If blank, obj is 
                         used to name it.
    pdParentScopeObj  -  The scope obj of the parent scope that this scope is 
                         being created for.
    pdScopeObj        -  (OUTPUT) The obj of the scope record that was created.                       
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER plSessionScope    AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcScopeName       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdParentScopeObj  AS DECIMAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pdScopeObj        AS DECIMAL    NO-UNDO.
  
  /* This call *always* needs to execute on the server */
  &IF DEFINED(server-side) = 0 &THEN
    RUN af/app/afsescrtctxtscpp.p ON gshAstraAppServer
      (INPUT  plSessionScope,  
       INPUT  pcScopeName,     
       INPUT  pdParentScopeObj,
       OUTPUT pdScopeObj) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE
      DEFINE BUFFER bgst_context_scope FOR gst_context_scope.

      trn-block:
      DO TRANSACTION ON ERROR UNDO, LEAVE:
        IF plSessionScope THEN
        DO:
          FIND FIRST bgst_context_scope EXCLUSIVE-LOCK
            WHERE bgst_context_scope.session_obj          = gsdSessionObj
              AND bgst_context_scope.scope_name           = pcScopeName
              AND bgst_context_scope.transaction_complete = FALSE
            NO-ERROR.
        END.
        ELSE
        DO:
          FIND FIRST bgst_context_scope EXCLUSIVE-LOCK
            WHERE bgst_context_scope.user_obj             = gsdUserObj
              AND bgst_context_scope.scope_name           = pcScopeName
              AND bgst_context_scope.transaction_complete = FALSE
            NO-ERROR.
        END.
        
        ERROR-STATUS:ERROR = NO.
        IF NOT AVAILABLE(bgst_context_scope) THEN
        DO:
          CREATE bgst_context_scope NO-ERROR.
          IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
          ASSIGN
            bgst_context_scope.session_obj              = (IF plSessionScope THEN gsdSessionObj ELSE 0.00)
            bgst_context_scope.user_obj                 = (IF plSessionScope THEN 0.00 ELSE gsdUserObj)
            bgst_context_scope.scope_name               = pcScopeName
            bgst_context_scope.transaction_complete     = FALSE
            bgst_context_scope.scope_creation_date      = TODAY
            bgst_context_scope.scope_creation_time      = TIME
            bgst_context_scope.last_access_date         = bgst_context_scope.scope_creation_date
            bgst_context_scope.last_access_time         = bgst_context_scope.scope_creation_time
            bgst_context_scope.parent_context_scope_obj = pdParentScopeObj
            NO-ERROR.
          IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
          VALIDATE bgst_context_scope NO-ERROR.
          IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
        END.
        
        ASSIGN
          pdScopeObj = bgst_context_scope.context_scope_obj
        .
        
      END.
      IF ERROR-STATUS:ERROR THEN 
        RETURN ERROR RETURN-VALUE.
      ELSE
        RETURN "":U.

  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createLinks Procedure 
PROCEDURE createLinks :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Creates pass-through links to a newly-launched container.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcPhysicalName AS CHARACTER NO-UNDO. 
    DEFINE INPUT PARAMETER phProcedureHandle AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER phObjectProcedure AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER plAlreadyRunning AS LOGICAL NO-UNDO.
 
    DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
    DEFINE VARIABLE hNavigationSource AS HANDLE NO-UNDO.
    DEFINE VARIABLE hCommitSource     AS HANDLE NO-UNDO.
    DEFINE VARIABLE cDataTargets AS CHARACTER NO-UNDO.
    DEFINE VARIABLE hContainerSource AS HANDLE NO-UNDO.
    DEFINE VARIABLE hUpdateSource AS HANDLE NO-UNDO.
    DEFINE VARIABLE hPrimarySdoTarget AS HANDLE NO-UNDO.
    DEFINE VARIABLE hOldDataSource AS HANDLE NO-UNDO.
    DEFINE VARIABLE lQueryObject   AS LOGICAL    NO-UNDO.
    
    /* The DynContainer class covers both dynamic frames and dynamic windows.
     */     
    IF valid-handle(phProcedureHandle) and
       {fnarg instanceOf 'DynContainer' phProcedureHandle} and
       valid-handle(phObjectProcedure) then
    DO:
        IF NOT plAlreadyRunning AND LOOKUP("doThisOnceOnly", phProcedureHandle:INTERNAL-ENTRIES) <> 0 THEN
            RUN doThisOnceOnly IN phProcedureHandle.
        
        hPrimarySdoTarget = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION('linkHandles':U IN phProcedureHandle,'PrimarySdo-Target'))).
        
        {get DataTarget cDataTargets phProcedureHandle}.
        {get QueryObject lQueryObject phObjectProcedure}.
        /* If this is a queryobject (SDO/SBO) then use it as datasource */ 
        IF lQueryObject THEN 
          hDataSource = phObjectProcedure.
        /* Else use its dataSource */
        ELSE 
          {get DataSource hDataSource phObjectProcedure}.

        IF NOT VALID-HANDLE(hDataSource) THEN
            hDataSource = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION('linkHandles':U IN phObjectProcedure,'PrimarySdo-Target'))).
            
        &scoped-define xp-Assign
        {get ContainerSource hContainerSource phProcedureHandle}
        {get UpdateSource hUpdateSource phProcedureHandle}
        {get NavigationSource hNavigationSource phProcedureHandle}
        {get CommitSource hCommitSource phProcedureHandle}.
        &undefine xp-Assign

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
            IF cDataTargets <> "" THEN 
                RUN addLink IN hContainerSource ( hDataSource , 'Data':U , phProcedureHandle ).
            
            IF VALID-HANDLE(hUpdateSource) THEN             
                RUN addLink IN hContainerSource ( phProcedureHandle , 'Update':U , hDataSource ).
            
            IF VALID-HANDLE(hNavigationSource) THEN 
                RUN addLink IN hContainerSource ( phProcedureHandle , 'Navigation':U , hDataSource ).
            
            IF VALID-HANDLE(hCommitSource) THEN 
                RUN addLink IN hContainerSource ( phProcedureHandle , 'Commit':U , hDataSource ).
        END.    /* valid container and SDO */
        
        IF plAlreadyRunning THEN 
        DO:
            PUBLISH 'dataAvailable' FROM hDataSource("DIFFERENT").
            PUBLISH 'toggleData' FROM phProcedureHandle (FALSE).
        END.
   END.    /* this is a container */
   
   error-status:error = no.
   return.
END PROCEDURE.    /* createLinks */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createProcDependancy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createProcDependancy Procedure 
PROCEDURE createProcDependancy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phParentProcedureHandle AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER phChildProcedureHandle  AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER pcParentType            AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcChildType             AS CHARACTER  NO-UNDO.

DEFINE BUFFER ttProcDependancy FOR ttProcDependancy.

IF NOT VALID-HANDLE(phParentProcedureHandle)
OR NOT VALID-HANDLE(phChildProcedureHandle) THEN
    RETURN "Unable to create procedure dependancy, parent or child handle invalid.".

IF NOT CAN-FIND(FIRST ttProcDependancy
                WHERE ttProcDependancy.parentProcedureHandle = phParentProcedureHandle
                  AND ttProcDependancy.childProcedureHandle  = phChildProcedureHandle) 
THEN DO:
    CREATE ttProcDependancy.
    ASSIGN ttProcDependancy.parentProcedureHandle = phParentProcedureHandle
           ttProcDependancy.childProcedureHandle  = phChildProcedureHandle
           ttProcDependancy.parentType            = pcParentType
           ttProcDependancy.childType             = pcChildType.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteActiveSession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteActiveSession Procedure 
PROCEDURE deleteActiveSession :
/*------------------------------------------------------------------------------
  Purpose:     Deletes the active session and all its context.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  &IF DEFINED(server-side) = 0 &THEN
     RUN af/app/afsesdlactsessp.p ON gshAstraAppServer NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE
    DEFINE BUFFER bgst_session        FOR gst_session.
    DEFINE BUFFER bgst_context_scope  FOR gst_context_scope.
    DEFINE BUFFER bgsm_server_context FOR gsm_server_context.

    trn-block:
    DO FOR bgst_session, bgst_context_scope, bgsm_server_context TRANSACTION 
      ON ERROR UNDO trn-block, LEAVE trn-block:
      /* Delete the session record. */
      FIND bgst_session EXCLUSIVE-LOCK
        WHERE bgst_session.session_id = SESSION:SERVER-CONNECTION-ID
        NO-ERROR.
      IF AVAILABLE(bgst_session) THEN
      DO:
        FOR EACH bgst_context_scope EXCLUSIVE-LOCK
          WHERE bgst_context_scope.session_obj = bgst_session.session_obj:

          FOR EACH bgsm_server_context EXCLUSIVE-LOCK
             WHERE bgsm_server_context.context_scope_obj = bgst_context_scope.context_scope_obj:
            DELETE bgsm_server_context NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
          END.
          DELETE bgst_context_scope NO-ERROR .
          IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
        END.
        DELETE bgst_session  NO-ERROR .
        IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
      END.
    END.
    IF ERROR-STATUS:ERROR THEN RETURN ERROR RETURN-VALUE.
  &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteContext Procedure 
PROCEDURE deleteContext :
/*------------------------------------------------------------------------------
  Purpose:     This procedure deletes context associated with a specific scope
               record if the scope record is expired.
               
   Parameters:  
     pdContextScopeObj   - Object ID of the context to be deleted.
   Notes:    
      This procedure is called by the garbage collector to delete expired
      context. It will only delete context of the context scope has expired.   
 ------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER pdContextScopeObj AS DECIMAL    NO-UNDO.

   &IF DEFINED(server-side) = 0 &THEN
     RUN af/app/afsesdlctxtp.p ON gshAstraAppServer
       (INPUT  pdContextScopeObj) NO-ERROR.
     IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
         RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                         ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
   &ELSE
       DEFINE BUFFER bgst_context_scope FOR gst_context_scope.
       DEFINE BUFFER bgsm_server_context FOR gsm_server_context.
       
       trn-block:
       DO TRANSACTION ON ERROR UNDO, LEAVE:
         FIND FIRST bgst_context_scope EXCLUSIVE-LOCK
           WHERE bgst_context_scope.context_scope_obj    = pdContextScopeObj
           NO-ERROR.

         ERROR-STATUS:ERROR = NO.
         IF AVAILABLE(bgst_context_scope) AND
            bgst_context_scope.transaction_complete THEN
         DO:
           FOR EACH bgsm_server_context EXCLUSIVE-LOCK
              WHERE bgsm_server_context.context_scope_obj = bgst_context_scope.context_scope_obj:
             DELETE bgsm_server_context NO-ERROR.
             IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
           END.
           DELETE bgst_context_scope NO-ERROR .
           IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
         END.

       END.
       IF ERROR-STATUS:ERROR THEN 
         RETURN ERROR RETURN-VALUE.
       ELSE
         RETURN "":U.

   &ENDIF

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

DEFINE VARIABLE cManagerList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hConnManager AS HANDLE     NO-UNDO.

DEFINE BUFFER bttProcDependancy FOR ttProcDependancy.
DEFINE BUFFER ttProcDependancy  FOR ttProcDependancy.

/* Check for objects open in design mode */
IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN  
DO:
    ASSIGN hProcedure = SESSION:FIRST-PROCEDURE
           lDesignMode = FALSE.

    designloop:
    DO WHILE VALID-HANDLE( hProcedure ):
    
      IF CAN-DO(hProcedure:INTERNAL-ENTRIES,"get-attribute":U) /* V8-style */ THEN
      DO:
        RUN get-attribute IN hProcedure ("UIB-MODE":U).
        ASSIGN lDesignMode = RETURN-VALUE NE ?.
      END.
      ELSE IF INDEX(hProcedure:FILE-NAME,"smart.p":U) = 0 /* v9-style */ THEN 
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

/* Shut containers first.  We're going to make sure we shut them in the reverse order of which they were launched. */
DO WHILE CAN-FIND(FIRST ttProcDependancy
                  WHERE ttProcDependancy.childType = "CON":U):

    FOR EACH ttProcDependancy
       WHERE ttProcDependancy.childType = "CON":U:

        IF NOT CAN-FIND(FIRST bttProcDependancy
                        WHERE bttProcDependancy.parentProcedureHandle = ttProcDependancy.childProcedureHandle
                          AND bttProcDependancy.childType             = "CON":U) 
        THEN DO:
            ASSIGN hDeleteProc = ttProcDependancy.childProcedureHandle.

            IF VALID-HANDLE(hDeleteProc) 
            THEN DO:
                IF LOOKUP("destroyObject":U,hDeleteProc:INTERNAL-ENTRIES) NE 0 THEN
                    APPLY "CLOSE":U TO hDeleteProc.
                ELSE
                    IF LOOKUP("dispatch":U,hDeleteProc:INTERNAL-ENTRIES) NE 0 THEN
                        RUN dispatch IN hDeleteProc ('destroy':U).
                    ELSE
                        DELETE PROCEDURE hDeleteProc.
            END.
            ELSE
                DELETE ttProcDependancy.
        END.
    END.
END.

/* Shut down, but don't shut ADM2 supers. We may shut a procedure after it that needs it. */
ASSIGN hProcedure = SESSION:FIRST-PROCEDURE.

do-blk:
DO WHILE VALID-HANDLE(hProcedure):
    FIND FIRST ttPersistProc WHERE ttPersistProc.hProc = hProcedure NO-ERROR.

    IF NOT AVAILABLE ttPersistProc THEN
      ASSIGN hDeleteProc = hProcedure.
    ELSE
      ASSIGN hDeleteProc = ?.
    
    ASSIGN hProcedure = hProcedure:NEXT-SIBLING.

    IF VALID-HANDLE(hDeleteProc) AND
       DYNAMIC-FUNCTION("isProcedureRegistered":U IN TARGET-PROCEDURE, INPUT hDeleteProc) THEN
      NEXT do-blk.

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
        /* Make sure this isn't one of the ADM2 supers */
        IF INDEX(hDeleteProc:FILE-NAME, "adm":U) > 0 THEN
            NEXT do-blk.

        IF LOOKUP("dispatch":U,hDeleteProc:INTERNAL-ENTRIES) NE 0 THEN
           RUN dispatch IN hDeleteProc ('destroy':U).
        IF VALID-HANDLE(hDeleteProc) 
            AND INDEX(hDeleteProc:FILE-NAME,"rydyncont":U) = 0 
            AND INDEX(hDeleteProc:FILE-NAME,"rydyntree":U) = 0 THEN
           APPLY "CLOSE":U TO hDeleteProc.
        IF VALID-HANDLE(hDeleteProc) THEN
           DELETE PROCEDURE hDeleteProc .    
    END.
END.

/* Now shut ADM supers as well */
ASSIGN hProcedure = SESSION:FIRST-PROCEDURE.

do-blk:
DO WHILE VALID-HANDLE(hProcedure):
    FIND FIRST ttPersistProc WHERE ttPersistProc.hProc = hProcedure NO-ERROR.

    IF NOT AVAILABLE ttPersistProc THEN
      ASSIGN hDeleteProc = hProcedure.
    ELSE
      ASSIGN hDeleteProc = ?.
    
    ASSIGN hProcedure = hProcedure:NEXT-SIBLING.

    IF VALID-HANDLE(hDeleteProc) AND
       DYNAMIC-FUNCTION("isProcedureRegistered":U IN TARGET-PROCEDURE, INPUT hProcedure) THEN
      NEXT do-blk.

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
        IF VALID-HANDLE(hDeleteProc)
        AND INDEX(hDeleteProc:FILE-NAME,"rydyncont":U) = 0 
        AND INDEX(hDeleteProc:FILE-NAME,"rydyntree":U) = 0 THEN
           APPLY "CLOSE":U TO hDeleteProc.
        IF VALID-HANDLE(hDeleteProc) THEN
           DELETE PROCEDURE hDeleteProc .    
    END.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteProcDependancies) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteProcDependancies Procedure 
PROCEDURE deleteProcDependancies :
/*------------------------------------------------------------------------------
  Purpose:     When a procedure is killed/closed/deleted, we need to ensure any
               dependancy information stored for it is deleted.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER ipProcedureHandle AS HANDLE     NO-UNDO.

DEFINE BUFFER ttProcDependancy FOR ttProcDependancy.

FOR EACH ttProcDependancy
   WHERE ttProcDependancy.parentProcedureHandle = ipProcedureHandle:
    DELETE ttProcDependancy.
END.

FOR EACH ttProcDependancy
   WHERE ttProcDependancy.childProcedureHandle = ipProcedureHandle:
    DELETE ttProcDependancy.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteProcDependancy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteProcDependancy Procedure 
PROCEDURE deleteProcDependancy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phParentProcedureHandle AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER phChildProcedureHandle  AS HANDLE     NO-UNDO.

DEFINE BUFFER ttProcDependancy FOR ttProcDependancy.

FIND ttProcDependancy
     WHERE ttProcDependancy.parentProcedureHandle = phParentProcedureHandle
       AND ttProcDependancy.childProcedureHandle  = phChildProcedureHandle
     NO-ERROR.

IF AVAILABLE ttProcDependancy THEN
    DELETE ttProcDependancy.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteSession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteSession Procedure 
PROCEDURE deleteSession :
/*------------------------------------------------------------------------------
  ACCESS_LEVEL = PUBLIC
  Purpose:     Deletes a session and all its context from the repository.
  Parameters:  
    pcSessionID - The session ID that is to be deleted.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcSessionID     AS CHARACTER  NO-UNDO.
  &IF DEFINED(server-side) = 0 &THEN
     RUN af/app/afsesdelsessp.p ON gshAstraAppServer 
       (INPUT pcSessionID) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE
    DEFINE BUFFER bgst_session        FOR gst_session.
    DEFINE BUFFER bgst_context_scope  FOR gst_context_scope.
    DEFINE BUFFER bgsm_server_context FOR gsm_server_context.

    trn-block:
    DO FOR bgst_session, bgst_context_scope, bgsm_server_context TRANSACTION 
      ON ERROR UNDO trn-block, LEAVE trn-block:
      /* Delete the session record. */
      FIND bgst_session EXCLUSIVE-LOCK
        WHERE bgst_session.session_id = pcSessionID
        NO-ERROR.
      IF AVAILABLE(bgst_session) THEN
      DO:
        FOR EACH bgst_context_scope EXCLUSIVE-LOCK
          WHERE bgst_context_scope.session_obj = bgst_session.session_obj:

          FOR EACH bgsm_server_context EXCLUSIVE-LOCK
             WHERE bgsm_server_context.context_scope_obj = bgst_context_scope.context_scope_obj:
            DELETE bgsm_server_context NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
          END.
          DELETE bgst_context_scope NO-ERROR .
          IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
        END.
        DELETE bgst_session  NO-ERROR .
        IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
      END.
    END.
    IF ERROR-STATUS:ERROR THEN RETURN ERROR RETURN-VALUE.
  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-establishSession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE establishSession Procedure 
PROCEDURE establishSession :
/*------------------------------------------------------------------------------
  ACCESS_LEVEL=PUBLIC
  
  Purpose:     This procedure is an update to activateSession. activateSession
               now calls this procedure.
  Parameters:  <none>
  Notes:       Before this procedure is called, the appropriate session
               properties should have been set, either by a call to
               storeAppServerInfo or by manual sets of the following 
               properties:
               client_DynamicsVersion
               client_PhysicalSessType
               client_NumericSeparator
               client_DecimalPoint
               client_DateFormat
               client_YearOffset
               client_SessionType
               client_OldSessionID
               client_NewSessionID
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plReactivate     AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plConfirmExpired AS LOGICAL    NO-UNDO.

  ASSIGN
    gsdTempUniqueID =  gsdTempUniqueID + 100000000000000000.0  
                    - (gsdTempUniqueID + 100000000000000000.0 
                       - TRUNCATE(gsdTempUniqueID / 100000000000000000.0 + 1, 0) 
                       * 100000000000000000.0)
  .

  &IF DEFINED(server-side) <> 0 &THEN
  
    DEFINE VARIABLE cOldSessionID           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cNewSessionID           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDateFormat             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cNumFormat              AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSessType               AS CHARACTER  NO-UNDO.
                                            
    DEFINE VARIABLE dSessionTypeObj         AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE cError                  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dInactive               AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE iDays                   AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iSeconds                AS INTEGER    NO-UNDO.
    DEFINE VARIABLE dSessionScopeObj        AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE cNumSep                 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDecPoint               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cYearOffset             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cOverrideInfo           AS CHARACTER  NO-UNDO.
    
    DEFINE BUFFER bgst_session              FOR gst_session.
    DEFINE BUFFER bgsm_session_type         FOR gsm_session_type.

    /* Retrieve all the session parameters that we can */
    cNumSep      = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                    "client_NumericSeparator":U).
    cDecPoint    = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                    "client_DecimalPoint":U).

    IF cNumSep = "EUROPEAN":U OR 
       cNumSep = "AMERICAN":U THEN
      cNumFormat = cNumSep.
    ELSE
      cNumFormat = cNumSep + cDecPoint.

    cDateFormat = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                   "client_DateFormat":U).
    cSessType   = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                   "client_SessionType":U).
    cOldSessionID = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                      "client_OldSessionID":U).
    cNewSessionID = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                      "client_NewSessionID":U).
    cYearOffset   = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                        "client_YearOffset":U).
    /* If this is a reactivation and the session ID is blank,
       get the old session id from the SESSION:SERVER-CONNECTION-ID */
    IF plReactivate AND
       cOldSessionID = "":U OR
       cOldSessionID = ? THEN
      cOldSessionID = SESSION:SERVER-CONNECTION-ID.

    DO TRANSACTION:
      /* See if we can find a session with the old session ID. */
      IF cOldSessionID <> "":U AND
         cOldSessionID <> ? THEN
      DO:
        FIND bgst_session
          WHERE bgst_session.session_id = cOldSessionID
          NO-ERROR.
      END.

      /* If the session record does not exist, we need to look at the
         reactivate flag to decide what to do. */
      IF NOT AVAILABLE(bgst_session) THEN
      DO:
        ERROR-STATUS:ERROR = NO.

        /* If Reactivate is switched on, we should be reactivating an 
           existing session. If the record was not found, there is a 
           problem and we need to return an error. */
        IF plReactivate THEN
        DO:
          ASSIGN
            cError = {af/sup2/aferrortxt.i 'ICF' '4' '?' '?' "''"}.
          RETURN ERROR cError.
        END.

        cOverrideInfo = DYNAMIC-FUNCTION("getSessionOverrideInfo":U IN ghSessTypeCache,
                                         cSessType).
        IF cOverrideInfo = ? THEN
        DO:
          ASSIGN
            cError = {af/sup2/aferrortxt.i 'ICF' '6' '?' '?' "cSessType"}.
          RETURN ERROR cError.
        END.

        CREATE bgst_session.
        ASSIGN
          bgst_session.session_creation_date = TODAY
          bgst_session.session_creation_time = TIME
        /* Set the sessionID to ? so that we don't run into
           index issues. Session ID comprises the unique index
           of the session table. If multiple clients are connecting
           quickly, the possibility exists for a second session
           record to be created before this record's session Id is 
           assigned (a little further down). Setting the session
           ID value to ? gets around the index issues.
         */
          bgst_session.session_id            = ?
          gsdSessionObj = bgst_session.session_obj
        .
        VALIDATE bgst_session.

        RUN createContextScope IN TARGET-PROCEDURE
          (INPUT TRUE, /* Create a session scope record */
           INPUT "SESSION-":U + STRING(gsdSessionObj),
           INPUT 0.00,
           OUTPUT dSessionScopeObj).

        ASSIGN
          bgst_session.default_context_scope_obj = dSessionScopeObj
        .


      END.
      ELSE
      DO:
        /* If we have to check the session expiry then lets see if it has
           expired. plConfirmExpired just tells us to perform this check. 
           The gsm_session_type contains a flag that indicates whether the session
           has expiry set, and how long a session should be allowed to run. */
        IF bgst_session.session_type_obj <> 0.0 THEN
        DO:
          /* Find the gsm_session type for this client session type. */
          FIND bgsm_session_type NO-LOCK
            WHERE bgsm_session_type.session_type_obj = bgst_session.session_type_obj
            NO-ERROR.
          /* We're only going to perform this check if the session type is available. */
          IF AVAILABLE(bgsm_session_type) THEN
          DO:
            /* The reason that we don't check the confirm expired flag earlier is that we want to 
               make sure that we set the session type code later under all conditions */
            IF plConfirmExpired THEN
            DO:
              /* Inactivity timeout only counts if it is > 0. If it is greater than 0, 
                 the integer portion contains the number of days that a session is valid for
                 and the mantissa contains the number of seconds that it is valid for -
                 kind of a date/time data type. 
                 
                 This means that we can convert the time that has elapsed since the session
                 was last active into a similar thing where the days are in the integer portion
                 and the seconds are in the mantissa, and this means that we can then do a 
                 straight comparison of the elapsed time against the time out */
              IF bgsm_session_type.inactivity_timeout_period > 0.0 THEN
              DO:
                /* First determine how many days have elapsed since the last access */
                iDays = TODAY - bgst_session.last_access_date.
  
                /* Get the number of seconds that have elapsed today. */
                iSeconds = TIME.
  
                /* If the number of seconds that has elapsed is less than the the last
                   access time, we are into at least the next day (possibly more days) 
                   and we therefore subtract the last access time from the number of 
                   seconds in a day (86400) and add the number of seconds that have elapsed 
                   today. We then subtract a day from the number of days that have elapsed
                   as we can measure the difference in seconds. */
                IF iSeconds < bgst_session.last_access_time THEN
                  ASSIGN
                    iSeconds = 86400 - bgst_session.last_access_time + iSeconds
                    iDays    = iDays - 1
                  .
                ELSE
                  /* Otherwise we just subtract the elapsed seconds from the
                     last access time */
                  ASSIGN
                    iSeconds = iSeconds - bgst_session.last_access_time
                  .
  
                /* The inactivity time has to be converted to the "date/time" format */
                dInactive = iDays + (iSeconds / 100000).
  
                /* Now we can compare the inactive time against the inactivity timeout.
                   If the session has timed out, we return an error. */
                IF dInactive >= bgsm_session_type.inactivity_timeout_period THEN
                DO:
                  ASSIGN
                    cError = {af/sup2/aferrortxt.i 'ICF' '4' '?' '?' "''"}.
                  RETURN ERROR cError.
                END. /* IF dInactive >= bgsm_session_type.inactivity_timeout_period */
              END. /* IF bgsm_session_type.inactivity_timeout_period > 0.0 */
            END. /* IF plConfirmExpired THEN */
          END.  /* IF AVAILABLE(bgsm_session_type) */
        END.  /* IF bgst_session.session_type_obj <> 0.0 */
      END. /* IF NOT AVAILABLE(bgst_session) */

      /* If we are not reactivating the session, we need to set up the
         session ID. */
      IF NOT plReactivate THEN
      DO:
        IF cNewSessionID <> "":U AND
           cNewSessionID <> ?    THEN
          ASSIGN
            bgst_session.session_id  = cNewSessionID.

        ELSE
          ASSIGN
            bgst_session.session_id  = SESSION:SERVER-CONNECTION-ID.

        ASSIGN
          bgst_session.client_date_format    = cDateFormat
          bgst_session.client_numeric_format = cNumFormat
          bgst_session.year_offset           = INTEGER(cYearOffset)
        .
      END.



      /* If the session type has not previously been set, we should set it 
         here. */
      IF bgst_session.session_type_obj = 0.0 AND
         cSessType <> ? AND
         cSessType <> "":U THEN
      DO:
        FIND bgsm_session_type NO-LOCK
          WHERE bgsm_session_type.session_type_code = cSessType
          NO-ERROR.
        IF NOT AVAILABLE(bgsm_session_type) THEN
          ASSIGN
            bgst_session.session_type_obj = 0.0.
        ELSE
          ASSIGN
            bgst_session.session_type_obj = bgsm_session_type.session_type_obj.
      END.


      /* Now we need to make sure that the session's last date and time
         is updated and that the session environment is synched up with 
         the client */
      ASSIGN
        bgst_session.last_access_date      = TODAY
        bgst_session.last_access_time      = TIME
        gscSessionId = bgst_session.session_id
        gsdSessionObj = bgst_session.session_obj
        gsdSessionScopeObj = bgst_session.default_context_scope_obj
      .

      DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                       "client_NewSessionID":U,
                       bgst_session.session_id).
      DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                       "client_OldSessionID":U,
                       ?).

      IF AVAILABLE(bgsm_session_type) THEN
        cSessType = bgsm_session_type.session_type_code.
      ELSE IF cSessType = ? THEN
        cSessType = DYNAMIC-FUNCTION("getPropertyList":U IN TARGET-PROCEDURE,
                                     "client_SessionType":U,
                                     NO).
      
      DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                       "client_SessionType":U,
                       cSessType).

      DYNAMIC-FUNCTION("setPropertyList":U IN TARGET-PROCEDURE,
                       "client_SessionType":U,
                       cSessType,
                       NO).

      /* We need to set up the year offset at this point */
      IF bgst_session.year_offset <> 0 AND
         bgst_session.year_offset <> ? THEN
        SESSION:YEAR-OFFSET = bgst_session.year_offset.
      ELSE
      DO:
        cYearOffset = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                       "session_year_offset":U).
        IF INTEGER(cYearOffset) <> 0 AND
           INTEGER(cYearOffset) <> ? THEN
        DO:
          SESSION:YEAR-OFFSET = INTEGER(cYearOffset).
        END.
      END.
      DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                       "client_YearOffset":U,
                       STRING(SESSION:YEAR-OFFSET)).


      /* If we have a valid client date format, set the server to match */
      IF bgst_session.client_date_format <> "":U AND
         bgst_session.client_date_format <> ? AND
         CAN-DO("dmy,dym,mdy,myd,ymd,ydm":U, bgst_session.client_date_format) THEN
        SESSION:DATE-FORMAT = bgst_session.client_date_format.
      ELSE
      DO:
        cDateFormat = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                       "session_date_format":U).
        IF cDateFormat <> ? AND
           CAN-DO("dmy,dym,mdy,myd,ymd,ydm":U, cDateFormat) THEN
          SESSION:DATE-FORMAT = cDateFormat.
      END.
      DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                       "client_DateFormat":U,
                       STRING(SESSION:DATE-FORMAT)).
        

      /* If we have a valid client date format, set the server to match */
      IF bgst_session.client_numeric_format <> "":U AND
         bgst_session.client_numeric_format <> ? THEN
      DO:
        IF bgst_session.client_numeric_format = "EUROPEAN":U OR 
           bgst_session.client_numeric_format = "AMERICAN":U THEN
          SESSION:NUMERIC-FORMAT = bgst_session.client_numeric_format.
        ELSE IF LENGTH(bgst_session.client_numeric_format) = 2 THEN
          SESSION:SET-NUMERIC-FORMAT(SUBSTRING(bgst_session.client_numeric_format,1,1), SUBSTRING(bgst_session.client_numeric_format,2,1)).
      END.
      ELSE
      DO:
        cNumFormat = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                      "session_numeric_format":U).
        IF cNumFormat <> ? THEN
        DO:
          IF cNumFormat = "EUROPEAN":U OR 
             cNumFormat = "AMERICAN":U THEN
            SESSION:NUMERIC-FORMAT = cNumFormat.
          ELSE IF LENGTH(cNumFormat) = 2 THEN
            SESSION:SET-NUMERIC-FORMAT(SUBSTRING(cNumFormat,1,1), SUBSTRING(cNumFormat,2,1)).
        END.
      END.
      DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                       "client_NumericSeparator":U,
                       SESSION:NUMERIC-SEPARATOR).
      DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                       "client_DecimalPoint":U,
                       SESSION:NUMERIC-DECIMAL-POINT).
    END.

    RETURN "":U. /* We need to make sure that we return because if we don't,
                    the return value never gets set. */

  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-expireContextScope) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE expireContextScope Procedure 
PROCEDURE expireContextScope :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is responsible for expiring context scope so that 
               context is no longer valid. This is necessary when the context 
               scope is no longer valid. Marking context scope as expired makes
               the scope available to the garbage collector for deletion.
  Parameters:  
    pdContextScopeObj   - Object ID of the context to be expired.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdContextScopeObj AS DECIMAL    NO-UNDO.

  /* This call *always* needs to execute on the server */
  &IF DEFINED(server-side) = 0 &THEN

    RUN af/app/afsesexpctxtscpp.p ON gshAstraAppServer
      (INPUT  pdContextScopeObj) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE
      DEFINE BUFFER bgst_context_scope FOR gst_context_scope.

      trn-block:
      DO TRANSACTION ON ERROR UNDO, LEAVE:
        FIND FIRST bgst_context_scope EXCLUSIVE-LOCK
          WHERE bgst_context_scope.context_scope_obj    = pdContextScopeObj
          NO-ERROR.
        
        ERROR-STATUS:ERROR = NO.
        IF AVAILABLE(bgst_context_scope) THEN
        DO:
          ASSIGN
            bgst_context_scope.transaction_complete     = TRUE
            bgst_context_scope.last_access_date         = TODAY
            bgst_context_scope.last_access_time         = TIME
            NO-ERROR.
          IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
          VALIDATE bgst_context_scope NO-ERROR.
          IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
        END.
        
      END.
      IF ERROR-STATUS:ERROR THEN 
        RETURN ERROR RETURN-VALUE.
      ELSE
        RETURN "":U.

  &ENDIF
  



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAbbreviatedLoginUserInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAbbreviatedLoginUserInfo Procedure 
PROCEDURE getAbbreviatedLoginUserInfo :
/*------------------------------------------------------------------------------
  Purpose:     This procedure returns user information used by the login process.                We only return the user name (encoded), default login company and                 default language.                                          
  Parameters:  input ipdUser_obj as decimal                               
               input ipcUser_login_name as decimal                        
               output table ttLoginUser (holds 1 record max.) 
               This procedure was created to eliminate the overhead that was                     created in cachelogin.p where all the user records were being
               sent to the client. Now only the user information is being passed                 back to the client for the current user_login_name. The information
               is appended to the ttUserLogin table to we don't go back to the                   server every time we change the user_login_name within one login   
               session.                                                   
               For this reason cachelogin.p and aftemlognw.w have been changed
               as well.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER ipdUser_obj         AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER ipcUser_login_name  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttLoginUser.

  IF NOT TRANSACTION THEN 
    EMPTY TEMP-TABLE ttLoginUser. 
  ELSE FOR EACH ttLoginUser: 
    DELETE ttLoginUser. 
  END.
  
  RUN af/app/afgetuserp.p ON gshAstraAppserver                              
      (INPUT ipdUser_obj,                               
       INPUT ipcUser_login_name,                        
       OUTPUT TABLE ttUser).
  
  FOR EACH ttUser:                                                          
      CREATE ttLoginUser.
      ASSIGN ttLoginUser.encoded_user_name = ENCODE(LC(ttUser.user_login_name)) 
             /* Always encode the lowercase of the username.  Encoding is case sensitive */ 
             ttLoginUser.default_organisation_obj = ttUser.default_login_company_obj                                          
             ttLoginUser.language_obj             = ttUser.language_obj.    
      DELETE ttUser.                                                        
  END.                                                                      
  
  ASSIGN ERROR-STATUS:ERROR = NO.                                           
  RETURN "":U.
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
  ELSE
  IF  pcActionScmObjectName     = "":U
  AND pcActionTablePrimaryFla   = "":U
  AND pcActionPrimaryKeyValues  = "":U
  THEN
  DO:
    FIND FIRST ttActionUnderway EXCLUSIVE-LOCK
      WHERE  ttActionUnderway.action_underway_origin BEGINS pcActionUnderwayOrigin
      AND   ttActionUnderway.action_type             = pcActionType
      NO-ERROR.
  END.

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
    
    IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) OR NOT CAN-FIND(FIRST ttGlobalControl) THEN
        RUN afgetglocp IN TARGET-PROCEDURE (OUTPUT TABLE ttGlobalControl).  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHelp Procedure 
PROCEDURE getHelp :
/*------------------------------------------------------------------------------
  Purpose:     A temp-table of widgets for an object is passed in.  Populate the
               temp-table with help context already stored on the database.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE hHelpTable.

&IF DEFINED(Server-Side) = 0 &THEN

/* We're going to make a dynamic call to the Appserver, we need to build the temp-table of parameters */

DEFINE VARIABLE hTableNotUsed    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParamTable      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTTHandlesToSend AS HANDLE     NO-UNDO EXTENT 64.        

IF NOT TRANSACTION THEN EMPTY TEMP-TABLE ttSeqType. ELSE FOR EACH ttSeqType: DELETE ttSeqType. END.

CREATE ttSeqType.
ASSIGN ttSeqType.iParamNo   = 1
       ttSeqType.cIOMode    = "INPUT-OUTPUT":U
       ttSeqType.cParamName = "T:01":U
       ttSeqType.cDataType  = "TABLE-HANDLE".

/* Now assign the TABLE-HANDLEs, note they map directly to the ttSeq records of type TABLE-HANDLE */

ASSIGN hTTHandlesToSend[1] = hHelpTable
       hParamTable         = TEMP-TABLE ttSeqType:HANDLE.

/* calltablett.p will construct and execute the call on the Appserver */

RUN adm2/calltablett.p ON gshAstraAppserver
    (
     "getHelp":U,
     "SessionManager":U,
     INPUT "S":U,
     INPUT-OUTPUT hTableNotUsed,
     INPUT-OUTPUT TABLE-HANDLE hParamTable,
     "",
     {src/adm2/callttparam.i &ARRAYFIELD = "hTTHandlesToSend"}  /* The actual array of table handles */ 
    ) NO-ERROR.

IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

&ELSE

DEFINE VARIABLE hBuffer            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hQuery             AS HANDLE     NO-UNDO.

DEFINE VARIABLE hLanguageObj       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainerFileName AS HANDLE     NO-UNDO.
DEFINE VARIABLE hObjectName        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidgetName        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hHelpFilename      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hHelpContext       AS HANDLE     NO-UNDO.

ASSIGN hBuffer            = hHelpTable:DEFAULT-BUFFER-HANDLE
       hLanguageObj       = hBuffer:BUFFER-FIELD("dLanguageObj":U)
       hContainerFileName = hBuffer:BUFFER-FIELD("cContainerFileName":U)
       hObjectName        = hBuffer:BUFFER-FIELD("cObjectName":U)
       hWidgetName        = hBuffer:BUFFER-FIELD("cWidgetName":U)
       hHelpFilename      = hBuffer:BUFFER-FIELD("cHelpFilename":U)
       hHelpContext       = hBuffer:BUFFER-FIELD("cHelpContext":U).

CREATE QUERY hQuery.
hQuery:ADD-BUFFER(hBuffer).
hQuery:QUERY-PREPARE("FOR EACH ":U + hBuffer:NAME).
hQuery:QUERY-OPEN().

hQuery:GET-FIRST().

DO WHILE NOT hQuery:QUERY-OFF-END:

    FIND gsm_help NO-LOCK
         WHERE gsm_help.language_obj            = hLanguageObj:BUFFER-VALUE
           AND gsm_help.help_container_filename = hContainerFileName:BUFFER-VALUE
           AND gsm_help.help_object_filename    = hObjectName:BUFFER-VALUE
           AND gsm_help.help_fieldname          = hWidgetName:BUFFER-VALUE
         NO-ERROR.

    IF AVAILABLE gsm_help THEN
        ASSIGN hHelpFilename:BUFFER-VALUE = gsm_help.help_filename
               hHelpContext:BUFFER-VALUE  = gsm_help.help_context.
    ELSE
        ASSIGN hHelpFilename:BUFFER-VALUE = "":U
               hHelpContext:BUFFER-VALUE  = "":U.

    hQuery:GET-NEXT().
END.

hQuery:QUERY-CLOSE().

DELETE OBJECT hQuery.
ASSIGN hQuery  = ?
       hBuffer = ?.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLoginUserInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLoginUserInfo Procedure 
PROCEDURE getLoginUserInfo :
/*------------------------------------------------------------------------------
  Purpose:     This procedure returns user information used by the login process.
               We only return the user name (encoded), default login company and
               default language.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER TABLE FOR ttLoginUser.

IF NOT TRANSACTION THEN EMPTY TEMP-TABLE ttLoginUser. ELSE FOR EACH ttLoginUser: DELETE ttLoginUser. END.

RUN af/app/afgetuserp.p ON gshAstraAppserver
                        (INPUT 0,
                         INPUT "":U,
                         OUTPUT TABLE ttUser).
FOR EACH ttUser:
    CREATE ttLoginUser.
    ASSIGN ttLoginUser.encoded_user_name        = ENCODE(LC(ttUser.user_login_name)) /* Always encode the lowercase of the username.  Encoding is case sensitive */
           ttLoginUser.default_organisation_obj = ttUser.default_login_company_obj
           ttLoginUser.language_obj             = ttUser.language_obj.
    DELETE ttUser.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMessageCacheHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getMessageCacheHandle Procedure 
PROCEDURE getMessageCacheHandle :
/*------------------------------------------------------------------------------
  Purpose:     A temp-table record is created to store message information retrieved
               from the Appserver in showMessages.  External programs can use this
               API to get at the temp-table record.  This API only applies client-side.
  Parameters:  <none>
  Notes:       Message caching is under review.  Until a decision has been made, this
               API will not return any information.
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER hBufferHandle AS HANDLE     NO-UNDO.

&IF DEFINED(server-side) = 0 &THEN
    ASSIGN hBufferHandle = ?.
&ENDIF

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

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

&IF DEFINED(EXCLUDE-getProfilerAttrs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getProfilerAttrs Procedure 
PROCEDURE getProfilerAttrs :
/*------------------------------------------------------------------------------
  Purpose:  returns the profiler's attributes
    Notes:  see $DLC/src/samples/profiler
    Param:  plRunServer - if TRUE run on server side
------------------------------------------------------------------------------*/
  DEFINE  INPUT PARAMETER plRunOnServer AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcDescription AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFileName    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcDirectory   AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTraceFilter AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTracing     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER plEnabled     AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plListings    AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plCoverage    AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plProfiling   AS LOGICAL    NO-UNDO.

  &IF DEFINED(server-side) = 0 &THEN
      IF plRunOnServer THEN DO:
        RUN af/app/afsesgtprfattrp.p ON gshAstraAppServer
          (INPUT  plRunOnServer, 
           OUTPUT pcDescription, 
           OUTPUT pcFileName,    
           OUTPUT pcDirectory,   
           OUTPUT pcTraceFilter, 
           OUTPUT pcTracing,   
           OUTPUT plEnabled,    
           OUTPUT plListings,    
           OUTPUT plCoverage,    
           OUTPUT plProfiling) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
            RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                            ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
        ELSE
          RETURN.
      END.
  &ENDIF
  ASSIGN
      pcDescription = PROFILER:DESCRIPTION     
      pcFileName    = PROFILER:FILE-NAME       
      pcDirectory   = PROFILER:DIRECTORY       
      pcTraceFilter = PROFILER:TRACE-FILTER    
      pcTracing     = PROFILER:TRACING         
      plEnabled     = PROFILER:ENABLED         
      plListings    = PROFILER:LISTINGS        
      plCoverage    = PROFILER:COVERAGE        
      plProfiling   = PROFILER:PROFILING.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getScopedContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getScopedContext Procedure 
PROCEDURE getScopedContext :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is responsible for retrieving context values from
               the context storage so that it can be used by the application.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdScopeObj        AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcContextList     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcContextNames    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcContextValues   AS CHARACTER  NO-UNDO.
    
    IF pcContextList = "":U THEN RETURN.

    &IF DEFINED(server-side) = 0 &THEN
      RUN af/app/afsesgtscpctxtp.p ON gshAstraAppServer
        (INPUT  pdScopeObj,      
         INPUT  pcContextList,   
         OUTPUT pcContextNames,
         OUTPUT pcContextValues) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                          ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
        DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.
        DEFINE VARIABLE cContext   AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.
        
        DEFINE BUFFER bgst_context_scope  FOR gst_context_scope.
        DEFINE BUFFER bgsm_server_context FOR gsm_server_context.
        
        IF pdScopeObj = 0.00 THEN
          pdScopeObj = gsdSessionScopeObj.

       /* We do not set context if the scope obj is 0.
         This works around the case where this call is made
         before the activateSession has been called. */
        IF pdScopeObj = 0.00 THEN
        DO:
          pcContextNames  = "":U.
          pcContextValues = "":U.
          RETURN "":U.
        END.

        DO FOR bgst_context_scope TRANSACTION ON ERROR UNDO, LEAVE:
          FIND FIRST bgst_context_scope EXCLUSIVE-LOCK
            WHERE bgst_context_scope.context_scope_obj = pdScopeObj
            NO-ERROR.
          IF NOT AVAILABLE(bgst_context_scope) THEN
          DO:
            pcContextNames  =  "":U.
            pcContextValues =  "":U.
            RETURN "":U.
          END.
          ELSE
          DO:
            IF bgst_context_scope.transaction_complete THEN
              RETURN ERROR {af/sup2/aferrortxt.i 'AF' '99'}.
            ELSE
              ASSIGN 
                bgst_context_scope.last_access_date = TODAY
                bgst_context_scope.last_access_time = TIME
              .
          END.
        END.

        DO iCount = 1 TO NUM-ENTRIES(pcContextList):
          ASSIGN 
            cContext = TRIM(ENTRY(iCount,pcContextList))
          .
          FIND FIRST bgsm_server_context NO-LOCK
               WHERE bgsm_server_context.context_scope_obj = pdScopeObj
                 AND bgsm_server_context.context_name = cContext
               NO-ERROR.
          IF AVAILABLE(bgsm_server_context) THEN
          DO:
            ASSIGN
              pcContextNames  = pcContextNames  + MIN(pcContextNames,",":U) 
                              + bgsm_server_context.context_name
              pcContextValues = pcContextValues + (IF NUM-ENTRIES(pcContextNames) = 1 THEN "":U ELSE CHR(3))
                              + (IF bgsm_server_context.context_value = ? THEN "?":U ELSE bgsm_server_context.context_value)
              .
          END.
        END.  /* iCount = 1 TO NUM-ENTRIES(pcContextList) */
        RETURN "":U.
    &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSecurityControlCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSecurityControlCache Procedure 
PROCEDURE getSecurityControlCache :
/*------------------------------------------------------------------------------
  Purpose:     This is a private API designed to ONLY be called from the security
               manager to pass the security control temp-table to the security manager
               if it is available within this session manager.
               The reason this is required is that this manager fetches the security
               control information from the appserver as part of the logincacheupfront
               work to get all login information in a single appserver hit. It can
               therefore give this record to the security manager to avoid the security
               manager having to make a separate appserver hit to retrieve the same
               information.
               
               Ordinarily - the getsecuritycontrol API should be used from the
               security manager to get this information.
               
  Parameters:  output table handle for security control temp-table
  Notes:       only required on client to save appserver hit - not worth it on
               the server!
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR ttSecurityControl.

RETURN.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSessionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSessionList Procedure 
PROCEDURE getSessionList :
/*------------------------------------------------------------------------------
  ACCESS_LEVEL=PUBLIC
  Purpose:     Retrieves a comma-separated list of all the session types 
               in the repository.
  Parameters:  
    pcTypes       - INPUT   - reserved for future use
    pcSessionList - OUTPUT  - Comma-separated list of session types
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcTypes         AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSessionList   AS CHARACTER  NO-UNDO.
  
  &IF DEFINED(server-side) = 0 &THEN
    RUN af/app/afsesgtsesslstp.p ON gshAstraAppServer
      (INPUT  pcTypes,      
       OUTPUT pcSessionList) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE
     DEFINE BUFFER bgsm_session_type          FOR gsm_session_type.
     DEFINE BUFFER bgsm_session_type_property FOR gsm_session_type_property.
     DEFINE BUFFER bgsc_session_property      FOR gsc_session_property.
     DEFINE VARIABLE dTemplateObj AS DECIMAL    NO-UNDO.

     IF pcTypes <> "":U AND
        NOT CAN-DO(pcTypes, "Templates":U) THEN
     DO:
       FIND FIRST bgsc_session_property NO-LOCK
         WHERE bgsc_session_property.session_property_name = "session_type_template":U
         NO-ERROR.
       IF AVAILABLE(bgsc_session_property) THEN
         dTemplateObj = bgsc_session_property.session_property_obj.
       ELSE
         dTemplateObj = 0.00.
     END.

     for-loop:
     FOR EACH bgsm_session_type NO-LOCK
       BY bgsm_session_type.session_type_code:
       IF dTemplateObj <> 0.00 THEN
       DO:
         FIND FIRST bgsm_session_type_property NO-LOCK
           WHERE bgsm_session_type_property.session_property_obj = dTemplateObj
             AND bgsm_session_type_property.session_type_obj = bgsm_session_type.session_type_obj
           NO-ERROR.
         IF AVAILABLE(bgsm_session_type_property) AND
            LOGICAL(bgsm_session_type_property.property_value) = YES THEN
           NEXT for-loop.
       END.

       pcSessionList = pcSessionList + MIN(",":U,pcSessionList)
                     + bgsm_session_type.session_type_code.
     END.
     RETURN "":U.
  &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSessTypeOverrideInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSessTypeOverrideInfo Procedure 
PROCEDURE getSessTypeOverrideInfo :
/*------------------------------------------------------------------------------
  ACCESS_LEVEL = PUBLIC
  Purpose:     Sets the session type override information into the Dynamics 
               repository.
  Parameters:  
    plConfigDefault         - Can the session types in the repository be 
                              overridden?
    plAllowUnregistered     - Do we allow users to start sessions with 
                              unregistered session types?
    pcPermittedUnregistered - Comma-separated list of session types that are
                              not defined in the repository that we will allow
                              to access the repository.
  Notes:       
    This procedure wrappers the getSessTypeOverrideInfo procedure in 
    afsrvtypecachep.p.
------------------------------------------------------------------------------*/
  DEFINE OUTPUT  PARAMETER plConfigDefault         AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT  PARAMETER plAllowUnregistered     AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT  PARAMETER pcPermittedUnregistered AS CHARACTER  NO-UNDO.

  /* This stuff only gets done in a server side session */
  &IF DEFINED(server-side) = 0 &THEN
    RUN af/app/afsesgtstorinfop.p ON gshAstraAppServer
      (OUTPUT  plConfigDefault,      
       OUTPUT  plAllowUnregistered,   
       OUTPUT  pcPermittedUnregistered) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE
    RUN getSessTypeOverrideInfo IN ghSessTypeCache
      (OUTPUT  plConfigDefault,      
       OUTPUT  plAllowUnregistered,   
       OUTPUT  pcPermittedUnregistered) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    
  &ENDIF

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

ASSIGN cTextFile = SEARCH("Version":U)
       cTextFile = IF cTextFile = ? THEN SEARCH("Version.txt":U)
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
  RUN ry/prc/_readpossever.p (OUTPUT cVersion).

  ASSIGN 
    cMessage = cMessage + (IF cMessage = "":U THEN "" ELSE CHR(10)) 
                        + (IF cVersion = "" or cVersion = ? THEN "" ELSE SUBSTITUTE("POSSE Version &1",cVersion)).
    cMessage = cMessage + (IF cMessage = "":U THEN "" ELSE CHR(10)) + "www.possenet.org":U.
END.

RUN showMessages IN TARGET-PROCEDURE (INPUT cMessage,
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

IF NOT CAN-FIND(FIRST ttSecurityControl) THEN
DO:
  RUN getSecurityControl IN gshSecurityManager (OUTPUT TABLE ttSecurityControl).
  FIND FIRST ttSecurityControl NO-ERROR.
END.

IF AVAILABLE ttSecurityControl THEN
    ASSIGN cHelpFile = ttSecurityControl.default_help_filename.

IF SEARCH(cHelpFile) = ? THEN
  /* If we can't find the help file, AND 
   * If we're dealing with a .hlp, check if we can find a .chm, or vice versa */
  ASSIGN cHelpFile = SUBSTRING(cHelpFile, 1, IF R-INDEX(cHelpFile, ".":U) = 0 THEN 
                                             LENGTH(cHelpFile)
                                             ELSE R-INDEX(cHelpFile, ".":U))
                     + IF R-INDEX(cHelpFile, ".":U) <> 0 THEN 
                         (IF SUBSTRING(cHelpFile, R-INDEX(cHelpFile, ".":U) + 1) = "hlp":U THEN "chm"
                           ELSE (IF SUBSTRING(cHelpFile, R-INDEX(cHelpFile, ".":U) + 1) = "chm":U THEN "hlp"
                                  ELSE SUBSTRING(cHelpFile, R-INDEX(cHelpFile, ".":U) + 1)))
                       ELSE "":U.

ASSIGN cHelpFound = SEARCH(cHelpFile).

IF cHelpFound = ? THEN
DO:
  DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
  RUN showMessages IN TARGET-PROCEDURE (INPUT {af/sup2/aferrortxt.i 'AF' '19' '?' '?' 'help' cHelpFile},
                                        INPUT "ERR":U,
                                        INPUT "OK":U,
                                        INPUT "OK":U,
                                        INPUT "OK":U,
                                        INPUT "Progress Dynamics Help",
                                        INPUT NOT SESSION:REMOTE,
                                        INPUT phContainer,
                                        OUTPUT cButton).
  RETURN.
END.

SYSTEM-HELP cHelpFound CONTENTS.

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
  Notes:       This is only supported for Windows help
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

IF SEARCH(cHelpFile) = ? THEN
  /* If we can't find the help file, AND 
   * If we're dealing with a .hlp, check if we can find a .chm, or vice versa */
  ASSIGN cHelpFile = SUBSTRING(cHelpFile, 1, IF R-INDEX(cHelpFile, ".":U) = 0 THEN 
                                             LENGTH(cHelpFile)
                                             ELSE R-INDEX(cHelpFile, ".":U))
                     + IF R-INDEX(cHelpFile, ".":U) <> 0 THEN 
                         (IF SUBSTRING(cHelpFile, R-INDEX(cHelpFile, ".":U) + 1) = "hlp":U THEN "chm"
                           ELSE (IF SUBSTRING(cHelpFile, R-INDEX(cHelpFile, ".":U) + 1) = "chm":U THEN "hlp"
                                  ELSE SUBSTRING(cHelpFile, R-INDEX(cHelpFile, ".":U) + 1)))
                       ELSE "":U.

ASSIGN cHelpFound = SEARCH(cHelpFile).

IF cHelpFound = ? THEN
  DO:
    DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
    RUN showMessages IN TARGET-PROCEDURE (INPUT {af/sup2/aferrortxt.i 'AF' '19' '?' '?' 'help' cHelpFile},
                                          INPUT "ERR":U,
                                          INPUT "OK":U,
                                          INPUT "OK":U,
                                          INPUT "OK":U,
                                          INPUT "Progress Dynamics Help",
                                          INPUT NOT SESSION:REMOTE,
                                          INPUT phContainer,
                                         OUTPUT cButton).
    RETURN.
  END.

IF INDEX(cHelpFound, ".hlp":U) > 0 THEN  /* Windows help */
  SYSTEM-HELP cHelpFound HELP.

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

IF SEARCH(cHelpFile) = ? THEN
  /* If we can't find the help file, AND 
   * If we're dealing with a .hlp, check if we can find a .chm, or vice versa */
  ASSIGN cHelpFile = SUBSTRING(cHelpFile, 1, IF R-INDEX(cHelpFile, ".":U) = 0 THEN 
                                             LENGTH(cHelpFile)
                                             ELSE R-INDEX(cHelpFile, ".":U))
                     + IF R-INDEX(cHelpFile, ".":U) <> 0 THEN 
                         (IF SUBSTRING(cHelpFile, R-INDEX(cHelpFile, ".":U) + 1) = "hlp":U THEN "chm"
                           ELSE (IF SUBSTRING(cHelpFile, R-INDEX(cHelpFile, ".":U) + 1) = "chm":U THEN "hlp"
                                  ELSE SUBSTRING(cHelpFile, R-INDEX(cHelpFile, ".":U) + 1)))
                       ELSE "":U.

ASSIGN cHelpFound = SEARCH(cHelpFile).
IF cHelpFound = ? THEN
DO:
    DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
    RUN showMessages IN TARGET-PROCEDURE (INPUT {af/sup2/aferrortxt.i 'AF' '19' '?' '?' 'help' cHelpFile},
                                          INPUT "ERR":U,
                                          INPUT "OK":U,
                                          INPUT "OK":U,
                                          INPUT "OK":U,
                                          INPUT "Progress Dynamics Help",
                                          INPUT NOT SESSION:REMOTE,
                                          INPUT phContainer,
                                         OUTPUT cButton).
    RETURN.
END.

/* .chm (Compiled HTML) and ,hlp  */
IF INDEX(cHelpFound, ".chm":U) > 0 
       OR INDEX(cHelpFound, ".htm":U) > 0  THEN  /* HTML Help */
  SYSTEM-HELP cHelpFound CONTENTS.
ELSE
  SYSTEM-HELP cHelpFound FINDER.

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
  RUN HtmlHelpTopic IN TARGET-PROCEDURE (phParent, pcHelpFile, "":U).

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

&IF DEFINED(EXCLUDE-increaseFrameforPopup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE increaseFrameforPopup Procedure 
PROCEDURE increaseFrameforPopup :
/*------------------------------------------------------------------------------
  Purpose:     Increase the width of a frame for a popup.  Remember
               we may have to increase the window width as well, this procedure will
               take care of the details. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phObject           AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER phFrame            AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER phLookup           AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER phWidget           AS HANDLE     NO-UNDO.

DEFINE VARIABLE dWindowMargin  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dWindowWidth   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dNewFrameWidth AS DECIMAL    NO-UNDO.
DEFINE VARIABLE hWindow        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainer     AS HANDLE     NO-UNDO.

ASSIGN hWindow        = phFrame:WINDOW
       dWindowMargin  = 1 /* Hardcoded, this is what we know it must be */
       dWindowWidth   = hWindow:WIDTH - dWindowMargin
       dNewFrameWidth = phWidget:COLUMN + phWidget:WIDTH + phLookup:WIDTH.

/* 1st resize the window */

IF phFrame:COLUMN + dNewFrameWidth + dWindowMargin > hWindow:WIDTH-CHARS 
THEN DO:
    ASSIGN hWindow:VIRTUAL-WIDTH  = 320
           hWindow:WIDTH          = phFrame:COLUMN + dNewFrameWidth + dWindowMargin
           hWindow:MIN-WIDTH      = hWindow:WIDTH.
END.

/* ...then resize the frame */

IF dNewFrameWidth > phFrame:WIDTH 
THEN DO:
    ASSIGN phFrame:SCROLLABLE     = TRUE
           phFrame:VIRTUAL-WIDTH  = 320
           phFrame:WIDTH          = dNewFrameWidth 
           phLookup:X             = phWidget:X + phWidget:WIDTH-PIXELS - 3
           NO-ERROR.
    {set minWidth phFrame:WIDTH phObject}.
END.

/* We're assuming we've been called from a viewer, so find it's container. */

ASSIGN hContainer = DYNAMIC-FUNCTION("getcontainersource":U IN phObject) NO-ERROR.

IF  VALID-HANDLE(hContainer)
THEN DO:
    IF LOOKUP("resizeWindow":U, hContainer:INTERNAL-ENTRIES) = 0 THEN
        ASSIGN hContainer = DYNAMIC-FUNCTION("getContainerSource":U IN hContainer) NO-ERROR.
    
    IF VALID-HANDLE(hContainer) AND LOOKUP("resizeWindow":U, hContainer:INTERNAL-ENTRIES) <> 0 
    THEN DO:
        APPLY "window-resized":u TO hWindow.
        RUN resizeWindow IN hContainer.
    END.
END.

/* Set virtual size back */

ASSIGN hWindow:VIRTUAL-WIDTH  = hWindow:WIDTH
       phFrame:VIRTUAL-WIDTH  = phFrame:WIDTH
       phFrame:SCROLLABLE     = FALSE
       ERROR-STATUS:ERROR     = NO.

RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializePropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializePropertyList Procedure 
PROCEDURE initializePropertyList :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Initializes Session Manager's properties.
  Parameters:  <none>
  Notes:       Called from MAIN BLOCK
------------------------------------------------------------------------------*/
    define variable cDateFormat         as character no-undo.
    
    define buffer lbProperty for ttProperty.
    
    empty temp-table lbProperty.
    
  /* When instantiated, populate temp-table with standard properties that may be cached
     on the client. These properties will always be returned from the temp-table. If a 
     property is not in the temp-table, then its value must be obtained from the server
     Session Manager which has access to the database. */

  /* The login values will be set-up during the user login process, which will also cause
     the context database to be updated with the same info for retrieval by the server side
     Session Manager. If these values are not set-up, then the user has not logged in
     sucessfully. */
    IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
    do:
      CREATE lbProperty.
      ASSIGN lbProperty.propertyName = "currentUserObj":U            /* logged in user object number */
             lbProperty.propertyValue = "0":U.
                                        
      CREATE lbProperty.
      ASSIGN lbProperty.propertyName = "currentUserLogin":U          /* logged in user login name */
             lbProperty.propertyValue = "":U.
             
      CREATE lbProperty.
      ASSIGN lbProperty.propertyName = "currentUserName":U           /* logged in user full name */
             lbProperty.propertyValue = "":U.
 
      CREATE lbProperty.
      ASSIGN lbProperty.propertyName = "currentUserEmail":U           /* logged in user email */
             lbProperty.propertyValue = "":U.
 
      CREATE lbProperty.
      ASSIGN lbProperty.propertyName = "currentLanguageObj":U         /* logged into language object number */
             lbProperty.propertyValue = "":U.
 
      CREATE lbProperty.
      ASSIGN lbProperty.propertyName = "currentLanguageName":U        /* logged into language name */
             lbProperty.propertyValue = "":U.
 
      CREATE lbProperty.
      ASSIGN lbProperty.propertyName = "currentOrganisationObj":U    /* logged in user organisation object number */
             lbProperty.propertyValue = "0":U.
 
      CREATE lbProperty.
      ASSIGN lbProperty.propertyName = "currentOrganisationCode":U   /* logged in user organisation code */
             lbProperty.propertyValue = "":U.
 
      CREATE lbProperty.
      ASSIGN lbProperty.propertyName = "currentOrganisationName":U   /* logged in user organisation full name */
             lbProperty.propertyValue = "":U.
 
      CREATE lbProperty.
      ASSIGN lbProperty.propertyName = "currentOrganisationShort":U  /* logged in user organisation short code */
             lbProperty.propertyValue = "":U.
 
      CREATE lbProperty.
      ASSIGN lbProperty.propertyName = "currentProcessDate":U        /* processing date specified at login time and used mainly in financials for forward postings */
             lbProperty.propertyValue = "":U.
 
      CREATE lbProperty.
      ASSIGN lbProperty.propertyName = "currentLoginValues":U        /* user defined list of extra login values in the form label,value,label,value, etc. */
             lbProperty.propertyValue = "":U.

      CREATE lbProperty.
      ASSIGN lbProperty.propertyName = "dateFormat":U                /* Property to hold Client PC session date format */
             lbProperty.propertyValue = "":U.
      cDateFormat = SESSION:DATE-FORMAT.    
      DO  giLoop = 1 TO 3:
          CASE SUBSTRING(cDateFormat, giLoop, 1):
              WHEN "y" THEN lbProperty.propertyValue = lbProperty.propertyValue + "9999" + "/".
              OTHERWISE lbProperty.propertyValue = lbProperty.propertyValue + "99" + "/".
          END CASE.
      END.    /* loop through date format */   
      lbProperty.propertyValue = SUBSTRING(lbProperty.propertyValue, 1, LENGTH(lbProperty.propertyValue) - 1).
      
      CREATE lbProperty.
      ASSIGN lbProperty.propertyName = "suppressDisplay":U           /* Property to supress Message Display */
             lbProperty.PropertyValue = 'No':u.    /* Historical default */          
      
      CREATE lbProperty.
      lbProperty.propertyName = "cachedTranslationsOnly":U.    /* Property to load translations at login time */
      lbProperty.propertyValue = dynamic-function('getSessionParam' in target-procedure,
                                                  'cached_translations_only':u).
      if lbProperty.PropertyValue eq '':u or lbProperty.PropertyValue eq ? then
          lbProperty.PropertyValue = 'Yes':u.    /* Historical default */          
      
      CREATE lbProperty.
      ASSIGN lbProperty.propertyName = "translationEnabled":U        /* Property to turn translation on/off */
             lbProperty.propertyValue = "YES":U.    /* Security Manager overwrites this */
      
      /* [PJ] I suspect these next 3 can be deprecated */
      CREATE lbProperty.
      ASSIGN lbProperty.propertyName = "launchphysicalobject":U      /* Property to save 1st launched physical object */
             lbProperty.propertyValue = "":U.
    
      CREATE lbProperty.
      ASSIGN lbProperty.propertyName = "launchlogicalobject":U       /* Property to save 1st launched logical object */
             lbProperty.propertyValue = "":U.
    
      CREATE lbProperty.
      ASSIGN lbProperty.propertyName = "launchrunattribute":U        /* Property to save 1st launched object run attribute */
             lbProperty.propertyValue = "":U.
    
      IF SESSION <> gshAstraAppserver THEN
      DO:
          /* The various programs needing the cached info are going to publish these events as they need it */        
          SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "loginGetMnemonicsCache":U IN SESSION:FIRST-PROCEDURE.
          SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "loginGetClassCache":U     IN SESSION:FIRST-PROCEDURE.
          SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "loginGetViewerCache":U    IN SESSION:FIRST-PROCEDURE.
          
          /* This manager should start just after the connection manager, cache the login stuff */        
          RUN loginCacheUpfront IN TARGET-PROCEDURE.
      END.
    end.    /* local session */
    
    /* [PJ] This property is basically meaningless and duplicated in icfstart.p.
       But I don't want to remove it out of fear that it breaks something else,
       somewhere else. */
    CREATE lbProperty.
    lbProperty.propertyName = "loginWindow":U.
    lbProperty.propertyValue = dynamic-function('getSessionParam' in target-procedure,
                                                'login_procedure':u).
    if lbProperty.propertyValue eq ? or lbProperty.propertyValue eq '':u then
        lbProperty.propertyValue = "af/cod2/aftemlognw.w":U.               
    
    error-status:error = no.
    return.
END PROCEDURE.    /* initializePropertyList */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isProfilingOn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE isProfilingOn Procedure 
PROCEDURE isProfilingOn :
/*------------------------------------------------------------------------------
  Purpose:  returns TRUE if profiling is on
    Notes:  see $DLC/src/samples/profiler
    Param:  plRunServer - if TRUE run on server side
------------------------------------------------------------------------------*/
    DEFINE  INPUT PARAMETER plRunOnServer   AS LOGICAL    NO-UNDO.
    DEFINE OUTPUT PARAMETER plIsProfilingOn AS LOGICAL    NO-UNDO.

    &IF DEFINED(server-side) = 0 &THEN
         IF plRunOnServer THEN DO:
           RUN af/app/afsesisprfonp.p ON gshAstraAppServer
             (INPUT  plRunOnServer,   
              OUTPUT plIsProfilingOn) NO-ERROR.
           IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
               RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                               ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
           ELSE
               RETURN.
         END.
    &ENDIF
    plIsProfilingOn = PROFILER:PROFILING.
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

      /* If we pass in a plip handle, only delete the plip we specified, not ALL with the same name as the one we wanted to delete originally.
         This causes multiple instances of a specific object to crash very badly of we closed one while the other was still running */
      IF pcPlipHandles <> "":U AND pcPlipHandles <> ? AND LOOKUP(STRING(ttPersistentProc.ProcedureHandle), pcPlipHandles, CHR(3)) = 0 THEN
        NEXT.

      /* ICF Procedure */
      IF DYNAMIC-FUNCTION("getInternalEntryExists":U IN TARGET-PROCEDURE, ttPersistentProc.ProcedureHandle, "killPlip":U) THEN
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
  IF DYNAMIC-FUNCTION("getInternalEntryExists":U IN TARGET-PROCEDURE, hPlip, "killPlip":U ) THEN
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

  /* Delete procedure dependancies */
  RUN deleteProcDependancies IN TARGET-PROCEDURE (INPUT ttPersistentProc.ProcedureHandle).
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
ACCESS_LEVEL=PUBLIC
  Purpose:     To launch an Dynamics container object, dealing with whether it
               is already running and whether the existing instance should be
               replaced or a new instance run. The temp-table of running
               persistent procedures is updated with the appropriate details.
  Parameters:  input object filename if the physical or physical and logical names are not known
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
  Notes:       See document or help file for detailed explanation of what this procedure does.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcObjectFileName      AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcPhysicalName        AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcLogicalName         AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER plOnceOnly            AS LOGICAL    NO-UNDO.
    DEFINE INPUT  PARAMETER pcInstanceAttributes  AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcChildDataKey        AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcRunAttribute        AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcContainerMode       AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER phParentWindow        AS HANDLE     NO-UNDO.
    DEFINE INPUT  PARAMETER phParentProcedure     AS HANDLE     NO-UNDO.
    DEFINE INPUT  PARAMETER phObjectProcedure     AS HANDLE     NO-UNDO.
    DEFINE OUTPUT PARAMETER phProcedureHandle     AS HANDLE     NO-UNDO.
    DEFINE OUTPUT PARAMETER pcProcedureType       AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE lAlreadyRunning               AS LOGICAL    NO-UNDO.                            
    DEFINE VARIABLE lRunSuccessful                AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cProcedureDesc                AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cButtonPressed                AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lMultiInstanceSupported       AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cLaunchContainer              AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cContainerSuperProcedure      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hWindow                       AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cObjectToCache                AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lContainerSecured             AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE dSmartObjectObj               AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE rProfileDataRowid             AS ROWID      NO-UNDO.
    DEFINE VARIABLE cProfileDataValue             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSuperHandles                 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSignature                    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSuperProcedureMode           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iSuperCnt                     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE hOldContainerSource           AS HANDLE     NO-UNDO.
    define variable lUseGeneratedObject           as logical    no-undo.
    DEFINE VARIABLE lMinimiseSiblings             AS LOGICAL    NO-UNDO.
    
    lMinimiseSiblings = (DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                          INPUT "minimiseSiblings":U,
                                          INPUT YES) = "YES").
    IF NOT (lMinimiseSiblings = TRUE) THEN 
      phParentWindow = ?.
    
    /* Save the RunAttribute value so that it can be retrieved by a "launched"
       container during container initialization
     */
    DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE, "RunAttribute":U, pcRunAttribute).
    
    /* If object filename passed in, get logical and physical object names */
    IF pcObjectFileName <> "":U THEN
    DO:
        /* Check whether there is a mapped file for the object. If so, use it.
         */                 
        pcPhysicalName = {fnarg getMappedFilename pcObjectFilename gshRepositoryManager}.
                        
        if pcPhysicalName eq ? then
        do:
            SESSION:SET-WAIT-STATE("GENERAL":U).
            RUN getObjectNames IN gshRepositoryManager ( INPUT  pcObjectFileName,
                                                         INPUT  pcRunAttribute,
                                                         OUTPUT pcPhysicalName,
                                                         OUTPUT pcLogicalName       ) NO-ERROR.
            IF RETURN-VALUE NE "":U OR ERROR-STATUS:ERROR THEN
            DO:
                RUN showMessages IN TARGET-PROCEDURE ( INPUT  (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE),
                                                       INPUT  "ERR",        /* error type */
                                                       INPUT  "&OK",        /* button list */
                                                       INPUT  "&OK",        /* default button */ 
                                                       INPUT  "&OK",        /* cancel button */
                                                       INPUT  "Error getting physical and logical names",
                                                       INPUT  YES,          /* display if empty */ 
                                                       INPUT  ?,            /* container handle */
                                                       OUTPUT cButtonPressed       ).
                RETURN.
            END.    /* Error. */
                        
            SESSION:SET-WAIT-STATE("":U).
        end.    /* no mapped file found */
        else
            /* there is a mapped filename. now set the object name */
            assign pcLogicalName = pcObjectFilename
                   lUseGeneratedObject = yes.                                   
    END.        /* get logical/physical names */

    /** Even though dynamic frames are containers themselves, they are not
     *  launchable by themselves. They should be first placed on a window,
     *  and run from there. The underlying rendering engine is changed so
     *  that the Dynamics default container is used. We can do this with
     *  an expectation of success because both the frame and window rendering
     *  engines use the same super procedures, and so much of the code is shared.
     *  ----------------------------------------------------------------------- **/
    IF pcPhysicalName MATCHES "*ry/uib/rydynframw~..":U THEN
        ASSIGN pcPhysicalName = "ry/uib/rydyncontw.w".

    /* smart objects does a Callback to getCurrentLogicalname which returns this
       in order to read attribute data from repository BEFORE any set is done
       (This may change when dynamic objects no longer include the .i)  */
    ASSIGN gcLogicalContainerName = pcLogicalName.
  
    /* If objects do not exit, give an error */
    IF pcPhysicalName = "":U THEN
    DO:
        IF pcLogicalName <> "":U THEN
            ASSIGN cLaunchContainer = pcLogicalName.
        ELSE
            ASSIGN cLaunchContainer = pcObjectFileName.
        
        RUN showMessages IN TARGET-PROCEDURE
                            (INPUT {aferrortxt.i 'RY' '6' '?' '?' cLaunchContainer}
                                    ,INPUT "ERR":U
                                    ,INPUT "OK":U
                                    ,INPUT "OK":U
                                    ,INPUT "OK":U
                                    ,INPUT "Launch Container"
                                    ,INPUT NOT SESSION:REMOTE
                                    ,INPUT ?
                                    ,OUTPUT cButtonPressed      ).
        ASSIGN phProcedureHandle          = ?
               pcProcedureType            = "":U
               gcLogicalContainerName = ?.
        RETURN.
    END.    /* no physical name */
        
    ASSIGN cProcedureDesc    = "":U
           lAlreadyRunning   = NO
           lRunSuccessful    = NO
           phProcedureHandle = ?
           pcProcedureType   = "CON":U.
                   
    /* Regardless of once only flag, see if already running as it may be an object
     * that does not support multiple instances. */
    FIND FIRST ttPersistentProc
            WHERE ttPersistentProc.physicalName  = pcPhysicalName
            AND   ttPersistentProc.logicalName   = pcLogicalName
            AND   ttPersistentProc.runAttribute  = pcRunAttribute
            AND   ttPersistentProc.childDataKey  = pcChildDataKey
            NO-ERROR.
      IF NOT AVAILABLE ttPersistentProc
      THEN
        FIND FIRST ttPersistentProc
              WHERE ttPersistentProc.physicalName  = pcPhysicalName
              AND   ttPersistentProc.logicalName   = pcLogicalName
              AND   ttPersistentProc.runAttribute  = pcRunAttribute
              AND   ttPersistentProc.childDataKey  = "":U
              NO-ERROR.

    /* check handle still valid */
    IF AVAILABLE ttPersistentProc AND
       ( NOT VALID-HANDLE(ttPersistentProc.procedureHandle) OR
         ttPersistentProc.ProcedureHandle:UNIQUE-ID <> ttPersistentProc.UniqueId) THEN
    DO:
        /* Delete procedure dependancies */
        RUN deleteProcDependancies IN TARGET-PROCEDURE (INPUT ttPersistentProc.ProcedureHandle).
        DELETE ttPersistentProc.
    END.    /* the handle is not valid. */
    
    IF AVAILABLE ttPersistentProc THEN
        ASSIGN lAlreadyRunning   = YES
               phProcedureHandle = ttPersistentProc.ProcedureHandle
               pcChildDataKey    = ttPersistentProc.childDataKey
               pcProcedureType   = ttPersistentProc.ProcedureType.
    
    /* check in running instance if multiple instances supported */
    ASSIGN lMultiInstanceSupported = YES.
    
    IF VALID-HANDLE(phProcedureHandle) THEN
        {get MultiInstanceSupported lMultiInstanceSupported phProcedureHandle } NO-ERROR.
     
    /*
     IF multiple instances support is unknown
     THEN default to the user preferences and if a attribute has been set for the container then use the conteiner default
     ELSE force a single instance
    */
    IF plOnceOnly EQ ? THEN
    DO:
        ASSIGN plOnceOnly = NO.
                
        /* Find the User Preferences */
        RUN getProfileData IN gshProfileManager (INPUT            "Window":U,
                                                 INPUT            "OneWindow":U,
                                                 INPUT            "OneWindow":U,
                                                 INPUT            NO,
                                                 INPUT-OUTPUT rProfileDataRowid,
                                                 OUTPUT cProfileDataValue).
        /* Find the Object Attribute if possible */
        /*
        TO BE DONE LATER???
         */
        ASSIGN plOnceOnly = (IF cProfileDataValue = "YES":U THEN YES ELSE NO).
    END.    /* don't know about once only? */
        
    /* if not a valid handle or not once only, then run it */
    IF NOT VALID-HANDLE(phProcedureHandle) OR NOT plOnceOnly THEN
    DO:
        ASSIGN lAlreadyRunning = NO.
                
        /* run the procedure */      
        SESSION:SET-WAIT-STATE('general':U).
        
        RUN-BLOCK:
        DO ON STOP UNDO RUN-BLOCK, LEAVE RUN-BLOCK ON ERROR UNDO RUN-BLOCK, LEAVE RUN-BLOCK:
            RUN VALUE(pcPhysicalName) PERSISTENT SET phProcedureHandle.
        END.    /* RUN-BLOCK: */
        
        IF NOT VALID-HANDLE(phProcedureHandle) THEN
        DO:
            SESSION:SET-WAIT-STATE('':U).
            ASSIGN phProcedureHandle = ?.
        END.
        ELSE
        DO:
            cContainerSuperProcedure = "":U.
            
            /* Add the container's super procedure, if any. */        
            if lUseGeneratedObject then
                {get SuperProcedure cContainerSuperProcedure phProcedureHandle}.
            else
            do:
                RUN getObjectSuperProcedure IN gshRepositoryManager
                                            ( INPUT  (IF pcLogicalName <> "":U THEN pcLogicalName ELSE pcPhysicalName),
                                              INPUT  pcRunAttribute,
                                              OUTPUT cContainerSuperProcedure ) NO-ERROR.
                
                IF RETURN-VALUE NE "":U OR ERROR-STATUS:ERROR THEN
                DO:
                    RUN showMessages IN TARGET-PROCEDURE ( INPUT  (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE),
                                                               INPUT  "ERR",        /* error type */
                                                               INPUT  "&OK",        /* button list */
                                                               INPUT  "&OK",        /* default button */ 
                                                               INPUT  "&OK",        /* cancel button */
                                                               INPUT  "Error getting super procedure",
                                                               INPUT  YES,          /* display if empty */ 
                                                               INPUT  ?,            /* container handle */
                                                               OUTPUT cButtonPressed       ).
                    RETURN.
                END.    /* Error. */
            end.    /* not a generated object */
            
            /* Make sure that the custom super procedure exists. */
            IF cContainerSuperProcedure NE "":U AND cContainerSuperProcedure NE ? THEN
            DO:
                {get SuperProcedureMode cSuperProcedureMode phProcedureHandle} NO-ERROR.
                /* Default the SuperProcedureMode to STATEFUL since this is the historical
                   behaviour.
                 */
                IF cSuperProcedureMode EQ ? OR cSuperProcedureMode EQ "":U THEN
                    ASSIGN cSuperProcedureMode = "STATEFUL":U.
                    
                /* Supers are added as SEARCH-TARGET; we add them backwards. */                                                                 
                DO iSuperCnt = NUM-ENTRIES(cContainerSuperProcedure) TO 1 BY -1:
                    /* Start the procedure. */
                    {launch.i
                        &PLIP        = "ENTRY(iSuperCnt, cContainerSuperProcedure)"
                        &OnApp       = 'NO'
                        &Iproc       = ''
                        &NewInstance = "(cSuperProcedureMode NE 'STATELESS')"
                    }
                    IF VALID-HANDLE(hPlip) THEN
                    DO:
                        DYNAMIC-FUNCTION("addAsSuperProcedure":U IN TARGET-PROCEDURE,
                                         INPUT hPlip, INPUT phProcedureHandle).
                                            
                        /* Only store the handles if this is run in stateful mode. */
                        ASSIGN cSuperHandles = cSuperHandles + ",":U + STRING(hPlip).
                    END.    /* the super procedure launched successfully. */
                END.    /* loop through super procedures */
                                    
                /* Store the list of super procedures in context. */
                IF cSuperProcedureMode NE 'STATELESS' THEN
                DO:
                    ASSIGN cSuperHandles = LEFT-TRIM(cSuperHandles, ",":U).
                    {set SuperProcedureHandle cSuperHandles phProcedureHandle}.
                END.    /* not a stateless super procedure */
            END.    /* add super procedure */
            
            /* work out the procedure type of the object run / running */
            IF LOOKUP( "dispatch":U, phProcedureHandle:INTERNAL-ENTRIES ) <> 0 THEN
                ASSIGN pcProcedureType = "ADM1":U.
            ELSE
            DO:                
                /* The 'Signature' function cannot simply be checked, since
                   if this is a non-smart object there will be no ADM2 super stack,
                   and so no Signature function. The run needs to be made NO-ERROR, 
                   and the result also checked for the existence of the getLogicalObjectName
                   function.
                 */
                ASSIGN cSignature = ?
                       cSignature = {fnarg Signature 'getLogicalObjectName' phProcedureHandle}
                       NO-ERROR.
                IF cSignature NE ? AND cSignature NE "":U THEN
                    ASSIGN pcProcedureType = "ICF":U.
            END.    /* not ADM1 */
            
            /* set initial attributes in object */
            IF pcProcedureType EQ "ICF":U OR pcProcedureType EQ "ADM2":U THEN
                RUN setAttributesInObject IN TARGET-PROCEDURE ( INPUT phProcedureHandle,
                                                                INPUT pcInstanceAttributes ).
        END.    /* IF VALID-HANDLE(phProcedureHandle) */
    END.    /* run the object (not runonce and not validhandle)*/
    
    SESSION:SET-WAIT-STATE('':U).
    
    /* see if handle now valid and if so, update temp-table with details */        
    IF VALID-HANDLE(phProcedureHandle) THEN
    DO:
        FIND FIRST ttPersistentProc
          WHERE ttPersistentProc.physicalName  = pcPhysicalName
          AND   ttPersistentProc.logicalName   = pcLogicalName
          AND   ttPersistentProc.runAttribute  = pcRunAttribute
          AND   ttPersistentProc.childDataKey  = pcChildDataKey
          NO-ERROR.

        /* Create a new entry in the temp-table if the procedure is not yet running,
         * or if this is an additional instance of a container. This will only happen if
         * the call specifies that the container should be a multiple instance.         */
        IF NOT AVAILABLE ttPersistentProc OR ( AVAILABLE ttPersistentProc AND NOT plOnceOnly ) THEN
        DO:
            CREATE ttPersistentProc.
            ASSIGN  ttPersistentProc.physicalName           = pcPhysicalName
                    ttPersistentProc.logicalName            = pcLogicalName
                    ttPersistentProc.runAttribute           = pcRunAttribute
                    ttPersistentProc.childDataKey           = pcChildDataKey
                    ttPersistentProc.procedureType          = pcProcedureType
                    ttPersistentProc.onAppserver            = NO
                    ttPersistentProc.multiInstanceSupported = lMultiInstanceSupported
                    ttPersistentProc.currentOperation       = pcContainerMode
                    ttPersistentProc.startDate              = TODAY
                    ttPersistentProc.startTime              = TIME
                    ttPersistentProc.procedureVersion       = "":U
                    ttPersistentProc.procedureNarration     = "":U.
        END.    /* create new entry in TT */
        
        /* try and get object version number */
        IF LOOKUP( "mip-get-object-version":U, phProcedureHandle:INTERNAL-ENTRIES ) <> 0 THEN
                RUN mip-get-object-version IN phProcedureHandle ( OUTPUT ttPersistentProc.procedureNarration,
                                                                  OUTPUT ttPersistentProc.procedureVersion   ).
        ELSE
        IF pcProcedureType EQ "ICF":U OR pcProcedureType EQ "ADM2":U THEN
            {get LogicalVersion ttPersistentProc.procedureVersion phProcedureHandle} NO-ERROR.
        
        /* try and get object description from standard internal procedure */   
        RUN objectDescription IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
            RUN mip-object-description IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration) NO-ERROR.
                    
        /* reset procedure handle, unique id, etc. */
        ASSIGN ttPersistentProc.ProcedureHandle  = phProcedureHandle
               ttPersistentProc.uniqueId         = phProcedureHandle:UNIQUE-ID
               ttPersistentProc.RunPermanent     = NO
               lRunSuccessful                    = YES.
                   
        /* We need to keep track of procedure dependancies.  Do so. */
        IF VALID-HANDLE(phParentProcedure) THEN
            RUN createProcDependancy IN TARGET-PROCEDURE ( INPUT phParentProcedure,
                                                           INPUT phProcedureHandle,
                                                           INPUT "CON":U,
                                                           INPUT "CON":U).
        IF pcProcedureType EQ "ICF":U THEN
        DO:
            IF VALID-HANDLE(phParentProcedure) OR phParentProcedure <> ? THEN
            DO:
                IF lAlreadyRunning THEN
                DO:
                    {get ContainerSource hOldContainerSource phProcedureHandle}.
                    
                    IF VALID-HANDLE(hOldContainerSource) THEN
                        RUN removeLink IN phParentProcedure (INPUT hOldContainerSource,
                                                             INPUT "Container":U,
                                                             INPUT phProcedureHandle ).
                END.    /* already running? */
                
                RUN addLink IN phParentProcedure (INPUT phParentProcedure,
                                                  INPUT "Container":U,
                                                  INPUT phProcedureHandle ).
            
                IF VALID-HANDLE(phParentWindow)OR phParentWindow <> ? THEN
                    /* set the parent window */
                    {set ObjectParent phParentWindow phProcedureHandle}.
            END.    /* valid procedure handle */
   
            /* give it the run attribute */
            IF pcRunAttribute <> "":U THEN
                {set RunAttribute pcRunAttribute phProcedureHandle} NO-ERROR.                
            
            /* Object launched ok, set logical object name attribute to correct value if required */
            IF pcLogicalName <> "":U THEN
               {set LogicalObjectName pcLogicalName phProcedureHandle} NO-ERROR.
            
            IF VALID-HANDLE(phObjectProcedure) OR phObjectProcedure <> ? THEN
                /* perform the required pre-initialization work */
                RUN createLinks IN TARGET-PROCEDURE (INPUT pcPhysicalName,
                                                     INPUT phProcedureHandle,
                                                     INPUT phObjectProcedure,
                                                     INPUT lAlreadyRunning          ).
                                                                                                         
            /* set correct container mode before initialize object */
            IF pcContainerMode <> "":U THEN
               {set ContainerMode pcContainerMode phProcedureHandle} NO-ERROR.
                                
            /* set caller attributes in container just launched */
            IF phObjectProcedure <> ? THEN
               {set CallerObject phObjectProcedure phProcedureHandle} NO-ERROR.
                                
            IF phParentProcedure <> ? THEN
                {set CallerProcedure phParentProcedure phProcedureHandle} NO-ERROR.
            
            IF phParentWindow <> ? THEN
                {set CallerWindow phParentWindow phProcedureHandle} NO-ERROR.
            
            /* Initialize the newly run object or view the old  */
            if plOnceOnly and lAlreadyrunning then  
              run viewObject IN phProcedureHandle no-error.
            else   
              RUN initializeObject IN phProcedureHandle NO-ERROR.
                        
            /* There may be code in the container that forces a shutdown while the
             * container is instantiating. We need to cater for this.             */
            IF NOT VALID-HANDLE(phProcedureHandle) THEN
            DO:
                ASSIGN phProcedureHandle = ?
                       pcProcedureType   = "":U.
                               
                IF AVAILABLE ttPersistentProc THEN
                DO:
                    /* Delete procedure dependancies */
                    RUN deleteProcDependancies IN TARGET-PROCEDURE (INPUT ttPersistentProc.ProcedureHandle).
                    DELETE ttPersistentProc NO-ERROR.
                END.    /* available persistent proc */
                
                SESSION:SET-WAIT-STATE("":U).
                RETURN.
            END.  /* not valid procedure handle */
        END.    /* ICF procedure type */
        
        /* Bring container to front or restore if minimized and apply focus */
        ASSIGN hWindow = phProcedureHandle:CURRENT-WINDOW NO-ERROR.
        
        IF VALID-HANDLE(hWindow) THEN
        DO:
            IF hWindow:WINDOW-STATE = WINDOW-MINIMIZED THEN      
               ASSIGN hWindow:WINDOW-STATE = WINDOW-NORMAL.
                        
            hWindow:MOVE-TO-TOP().
            APPLY "ENTRY":U TO hWindow.
        END.    /* valid window */
    END. /* END IF VALID-HANDLE(phProcedureHandle) */
    ELSE
        ASSIGN lAlreadyRunning   = NO
               lRunSuccessful    = NO
               phProcedureHandle = ?
               pcProcedureType   = "":U.
    
    ASSIGN gcLogicalContainerName = ?
           ERROR-STATUS:ERROR     = NO.
    RETURN.
END PROCEDURE.  /* launchContainer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchExternalProcess) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchExternalProcess Procedure 
PROCEDURE launchExternalProcess :
/*------------------------------------------------------------------------------
  Purpose:     To launch an external process
  Parameters:  input command line, e.g. "notepad.exe"
               input default directory for the process
               input show window flag, 0 (Hidden) / 1 (Normal) / 2 (Minimised) / 3 (Maximised)
               output result, 0 (Failure) / Non-zero (Handle of new process)

  Notes:       Uses the CreateProcess API function from af/sup/windows.i
------------------------------------------------------------------------------*/
IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN RETURN.

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

DEFINE VARIABLE hAttributeBuffer            AS HANDLE               NO-UNDO.
DEFINE VARIABLE hObjectBuffer               AS HANDLE               NO-UNDO.
DEFINE VARIABLE cClassType                  AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cCustomSuperProcedure       AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cAllCustomSuperProcedures   AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cPhysicalObjectName         AS CHARACTER            NO-UNDO.
DEFINE VARIABLE dRecordIdentifier           AS DECIMAL              NO-UNDO.   
DEFINE VARIABLE cAttributeList              AS CHARACTER            NO-UNDO.
DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.

ASSIGN cAsDivision = "CLIENT"    /* Client appserver connection */
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
  OTHERWISE DO:
    /* The user could have passed a manager description, see if he passed a manager in */

    ASSIGN phProcedureHandle = DYNAMIC-FUNCTION("getManagerHandle":U IN TARGET-PROCEDURE, pcPhysicalName) NO-ERROR.

    IF NOT VALID-HANDLE(phProcedureHandle) THEN
        ASSIGN cProcedureType = "PRO":U
               cProcedureDesc = "":U
               lAlreadyRunning = NO
               lRunSuccessful = NO
               phProcedureHandle = ?.
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
             AND ttPersistentProc.logicalName  = "":U
             AND ttPersistentProc.runAttribute = "":U
             AND ttPersistentProc.childDataKey = "":U
             AND ttPersistentProc.onAppserver  = YES
           NO-ERROR.
    ELSE
      FIND FIRST ttPersistentProc
           WHERE ttPersistentProc.physicalName = pcPhysicalName
             AND ttPersistentProc.logicalName  = "":U
             AND ttPersistentProc.runAttribute = "":U
             AND ttPersistentProc.childDataKey = "":U
             AND ttPersistentProc.onAppserver  = NO
           NO-ERROR.

    /* check handle still valid */

    IF AVAILABLE ttPersistentProc AND
       (NOT VALID-HANDLE(ttPersistentProc.procedureHandle) OR
        ttPersistentProc.ProcedureHandle:UNIQUE-ID <> ttPersistentProc.UniqueId) THEN
    DO:
      /* Delete procedure dependancies */
      RUN deleteProcDependancies IN TARGET-PROCEDURE (INPUT ttPersistentProc.ProcedureHandle).
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
           AND ttPersistentProc.logicalName  = "":U
           AND ttPersistentProc.runAttribute = "":U
           AND ttPersistentProc.childDataKey = "":U
           AND ttPersistentProc.onAppserver  = YES
         NO-ERROR.
  ELSE
    FIND FIRST ttPersistentProc
         WHERE ttPersistentProc.physicalName = pcPhysicalName
           AND ttPersistentProc.logicalName  = "":U
           AND ttPersistentProc.runAttribute = "":U
           AND ttPersistentProc.childDataKey = "":U
           AND ttPersistentProc.onAppserver  = NO
         NO-ERROR.

  /* Create a new entry in the temp-table if the procedure is not yet running, or *
   * if this is an additional instance of a procedure. This will only happen if   *
   * the call specifies that the procedure should be a multiple instance.         */

  IF NOT AVAILABLE ttPersistentProc OR
     ( AVAILABLE ttPersistentProc AND NOT plOnceOnly ) 
  THEN DO:
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

    /* First, we'll try and get all the PLIP detail in one Appserver hit.  Client-server should benefit as well. *
     * Don't check if the procedure exists first, this will result in an extra Appserver hit, just run NO-ERROR  */

    RUN getPlipInfo IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration,
                                          OUTPUT ttPersistentProc.procedureVersion,
                                          OUTPUT ttPersistentProc.internalEntries) 
                                          NO-ERROR.

    IF ERROR-STATUS:ERROR /* getPlipInfo doesn't exist */
    THEN DO:
        ASSIGN ERROR-STATUS:ERROR = NO.

        /* Get the procedure internal entries */

        ASSIGN ttPersistentProc.internalEntries = DYNAMIC-FUNCTION("getInternalEntries":U IN phProcedureHandle) NO-ERROR.

        /* try and get object version number */

        IF DYNAMIC-FUNCTION("getInternalEntryExists":U IN TARGET-PROCEDURE, phProcedureHandle, "getObjectVersion":U) THEN
            RUN getObjectVersion IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration,
                                                       OUTPUT ttPersistentProc.procedureVersion).
        ELSE
            IF DYNAMIC-FUNCTION("getInternalEntryExists":U IN TARGET-PROCEDURE, phProcedureHandle, "mip-get-object-version":U) THEN
                RUN mip-get-object-version IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration,
                                                                 OUTPUT ttPersistentProc.procedureVersion).
    
        /* try and get object description from standard internal procedure */

        IF DYNAMIC-FUNCTION("getInternalEntryExists":U IN TARGET-PROCEDURE, phProcedureHandle, "objectDescription":U) THEN
            RUN objectDescription IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration).
        ELSE
            IF DYNAMIC-FUNCTION("getInternalEntryExists":U IN TARGET-PROCEDURE, phProcedureHandle, "mip-object-description":U) THEN
                RUN mip-object-description IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration).
    END.

    /* Use manager hard coded description */
    IF ttPersistentProc.procedureNarration = "":U AND cProcedureDesc <> "":U THEN
        ASSIGN ttPersistentProc.procedureNarration = cProcedureDesc.  
  END.

  /* always reset procedure handle, unique id and run permanent flag */

  ASSIGN ttPersistentProc.ProcedureHandle = phProcedureHandle
         ttPersistentProc.uniqueId        = phProcedureHandle:UNIQUE-ID
         ttPersistentProc.RunPermanent    = plRunPermanent
         lRunSuccessful = YES
         .       
END. /* IF VALID-HANDLE(phProcedureHandle) */
ELSE
  ASSIGN
    lAlreadyRunning = NO
    lRunSuccessful = NO
    phProcedureHandle = ?
    .
ASSIGN ERROR-STATUS:ERROR     = NO.
RETURN.
END PROCEDURE.  /* launchProcedure */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loginCacheAfter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loginCacheAfter Procedure 
PROCEDURE loginCacheAfter :
/*------------------------------------------------------------------------------
  Purpose:     We can only cache certain information after we have a current user &
               organisation etc.  This procedure will fire when the user presses OK
               in the login screen, and get all the stuff to cache, and cache it 
               client side, in one Appserver call.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcLoginName                AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcPassword                 AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pdCompanyObj               AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER pdLanguageObj              AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER ptProcessDate              AS DATE       NO-UNDO.
DEFINE INPUT  PARAMETER pcDateFormat               AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcLoginValues              AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcLoginProc                AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcCustTypesPrioritised     AS CHARACTER  NO-UNDO.

DEFINE OUTPUT PARAMETER pdCurrentUserObj           AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentUserName          AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentUserEmail         AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentOrganisationCode  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentOrganisationName  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentOrganisationShort AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentLanguageName      AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcFailedReason             AS CHARACTER NO-UNDO.

DEFINE VARIABLE cTypeAPI              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSessionCustRefs      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSessionResultCodes   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hCustomizationManager AS HANDLE     NO-UNDO.
define variable cSecurityPropertyNames    as character                    no-undo.
define variable cSecurityPropertyValues   as character                    no-undo.
define variable lCachedTranslationsOnly as logical no-undo.

/* Clear the cached temp-tables */
EMPTY TEMP-TABLE ttTranslation.
EMPTY TEMP-TABLE ttProfileData.
EMPTY TEMP-TABLE ttSecurityControl.

/* Initialize any variables */
IF pcCustTypesPrioritised = ? THEN
    ASSIGN pcCustTypesPrioritised = "":U.

IF pcDateFormat = "":U THEN
    ASSIGN pcDateFormat = DYNAMIC-FUNCTION("getPropertyList":U IN TARGET-PROCEDURE,INPUT "dateFormat":U,INPUT NO).

/* We need to pass in this value, since the session properties haven't been set on the server
   yet. See icfstart.p/ICFCFM_Login for more. */
lCachedTranslationsOnly = logical(dynamic-function('getPropertyList':u in target-procedure,
                                                   'CachedTranslationsOnly':u, No) ) no-error.
if lCachedTranslationsOnly eq ? then
    lCachedTranslationsOnly = yes.                                                       

/* 1st flush old user profile cache to db - to cope with relogon - do this here
   so that if relogin as same user - latest current profile data is saved to database
   before old values are refetched!
*/
RUN updateCacheToDb IN gshProfileManager (INPUT "":U).

/* Run the Appserver procedure to extract the stuff */
RUN af/app/cacheafter.p ON gshAstraAppserver (INPUT pcLoginName,
                                              INPUT pcPassword,
                                              INPUT pdCompanyObj,
                                              INPUT pdLanguageObj,
                                              INPUT ptProcessDate,
                                              INPUT pcDateFormat,
                                              INPUT pcLoginValues,
                                              INPUT pcLoginProc,
                                              INPUT pcCustTypesPrioritised,
                                              input lCachedTranslationsOnly,

                                              OUTPUT TABLE ttSecurityControl,
                                              OUTPUT TABLE ttProfileData,
                                              OUTPUT TABLE ttTranslation,
                                              OUTPUT pdCurrentUserObj,
                                              OUTPUT pcCurrentUserName,
                                              OUTPUT pcCurrentUserEmail,
                                              OUTPUT pcCurrentOrganisationCode,
                                              OUTPUT pcCurrentOrganisationName,
                                              OUTPUT pcCurrentOrganisationShort,
                                              OUTPUT pcCurrentLanguageName,
                                              OUTPUT pcFailedReason,
                                              OUTPUT cTypeAPI,
                                              OUTPUT cSessionCustRefs,
                                              OUTPUT cSessionResultCodes,
                                              output cSecurityPropertyNames,
                                              output cSecurityPropertyValues ).
                                              
IF pcFailedReason <> "":U THEN /* This will cause the login to fail */
    RETURN.

/* Now send the profile cache to the profile manager */
IF CAN-FIND(FIRST ttProfileData) THEN
DO:
  /* next clear profile cache - ready to receive new users profile - this is required
     because the receiveprofilecache api uses input append - so the old users details
     will not be cleared for a relogin 
  */ 
  RUN clearClientCache IN gshProfileManager.
  /* pass new users profile to profile manager */
  RUN receiveProfileCache IN gshProfileManager (INPUT TABLE ttProfileData).
END.

/* Send the security cache to the security manager */
IF CAN-FIND(FIRST ttSecurityControl) THEN
    RUN receiveCacheSessionSecurity IN gshSecurityManager (INPUT TABLE ttSecurityControl).
    
/* Set the security-related properties. */
dynamic-function('setPropertyList' in gshSessionManager,
                 input cSecurityPropertyNames,
                 input cSecurityPropertyValues,
                 input Yes ).

/* Send the translation cache to the translation manager */

RUN receiveCacheClient IN gshTranslationManager (INPUT TABLE ttTranslation,
                                                 INPUT pdLanguageObj).

/* Send the type API to the customization manager */

ASSIGN hCustomizationManager = DYNAMIC-FUNCTION("getManagerHandle":U IN TARGET-PROCEDURE, "CustomizationManager":U).

IF VALID-HANDLE(hCustomizationManager) 
THEN DO:
    RUN receiveCacheTypeAPI IN hCustomizationManager (INPUT pcCustTypesPrioritised,
                                                      INPUT cTypeAPI).

    RUN receiveCacheResultCodes IN hCustomizationManager (INPUT cSessionCustRefs,
                                                          INPUT cSessionResultCodes).
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.
END PROCEDURE.    /* loginCacheAfter */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loginCacheUpfront) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loginCacheUpfront Procedure 
PROCEDURE loginCacheUpfront :
/*------------------------------------------------------------------------------
  Purpose:     This procedures makes an Appserver call to cache all information
               needed for the login process.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hClassAttributeTable AS HANDLE     NO-UNDO EXTENT 32.
DEFINE VARIABLE iCnt                 AS INTEGER    NO-UNDO.
define variable cDateFormat          as character no-undo.

/* Make sure we don't have any cached information left over from a previous login. */

IF NOT TRANSACTION 
THEN DO:
    EMPTY TEMP-TABLE ttProfileData.
    EMPTY TEMP-TABLE ttGlobalControl.
    EMPTY TEMP-TABLE ttSecurityControl.
    EMPTY TEMP-TABLE ttComboData.
END.
ELSE DO:
    FOR EACH ttProfileData:     DELETE ttProfileData.     END.
    FOR EACH ttGlobalControl:   DELETE ttGlobalControl.   END.
    FOR EACH ttSecurityControl: DELETE ttSecurityControl. END.
    FOR EACH ttComboData:       DELETE ttComboData.       END.
END.

ASSIGN cNumericDecimalPoint = "":U
       cNumericSeparator    = "":U
       cNumericSeparator    = "":U
       cNumericFormat       = "":U
       cAppDateFormat       = "":U.

/* Get all the required information from the Appserver */

RUN af/app/cachelogin.p ON gshAstraAppserver
                           (OUTPUT TABLE ttTranslate,
                            OUTPUT cNumericDecimalPoint,
                            OUTPUT cNumericSeparator,
                            OUTPUT cNumericFormat,
                            OUTPUT cDateFormat,
                            OUTPUT TABLE ttEntityMnemonic, /* Redundant, cachelogin.p isn't going to extract these either */
                            OUTPUT TABLE ttLoginUser,
                            OUTPUT TABLE ttGlobalControl,
                            OUTPUT TABLE ttSecurityControl,
                            OUTPUT TABLE ttComboData).

RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loginGetClassCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loginGetClassCache Procedure 
PROCEDURE loginGetClassCache :
/*------------------------------------------------------------------------------
  Purpose:     Returns cached class information (gsc_object_type) to whoever 
               requests it.
  Parameters:  <none>
  Notes:       This procedure is only going to contain cache up to the login 
               screen appearing.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER hCallingProcedure AS HANDLE NO-UNDO.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loginGetMnemonicsCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loginGetMnemonicsCache Procedure 
PROCEDURE loginGetMnemonicsCache :
/*------------------------------------------------------------------------------
  Purpose:     Sends the entity_mnemonic table to whoever requests it.
  Parameters:  <none>
  Notes:       This procedure is only going to contain cache up to the login 
               screen appearing.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER hCallingProcedure AS HANDLE NO-UNDO.

IF VALID-HANDLE(hCallingProcedure) 
AND LOOKUP("sendLoginCache", hCallingProcedure:INTERNAL-ENTRIES) <> 0 
THEN DO:
    /* Send the info */

    RUN sendLoginCache IN hCallingProcedure (INPUT TABLE ttEntityMnemonic).

    /* Unsubscribe from the event, it's not going to be published again */

    UNSUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "loginGetMnemonicsCache":U IN SESSION:FIRST-PROCEDURE.

    /* Clear the cached info, we don't want it hanging around in memory, we're not going to need it again */

    EMPTY TEMP-TABLE ttEntityMnemonic.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loginGetViewerCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loginGetViewerCache Procedure 
PROCEDURE loginGetViewerCache :
/*------------------------------------------------------------------------------
  Purpose:     Sends all the information required by the login screen.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER hCallingProcedure AS HANDLE NO-UNDO.

define variable cDateFormat        as character no-undo.

IF VALID-HANDLE(hCallingProcedure) 
AND LOOKUP("sendLoginCache", hCallingProcedure:INTERNAL-ENTRIES) <> 0 
THEN DO:
    /* Send the info */

    RUN sendLoginCache IN hCallingProcedure (INPUT cNumericDecimalPoint,
                                             INPUT cNumericSeparator,
                                             INPUT cNumericFormat,
                                             INPUT cDateFormat,
                                             INPUT TABLE ttGlobalControl,
                                             INPUT TABLE ttSecurityControl,
                                             INPUT TABLE ttComboData,
                                             INPUT TABLE ttLoginUser,
                                             INPUT TABLE ttTranslate).

    /* We don't clear any cache, or unsubscribe from the event, because we may relogon, we'll want this information again then */
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

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

IF pcAction = "email":U
THEN DO:
    IF pdUserObj = 0 AND pcUserName = "":U THEN
        /* get user email from property for current user */
        cEmailAddress = DYNAMIC-FUNCTION("getPropertyList":U IN TARGET-PROCEDURE,
                                         INPUT "currentUserEmail":U,
                                         INPUT NO).
    ELSE DO:
        /* find user email by reading user record */
        RUN af/app/afgetuserp.p ON gshAstraAppserver (INPUT pdUserObj, INPUT pcUserName, OUTPUT TABLE ttUser).
        FIND FIRST ttUser NO-ERROR.
        IF AVAILABLE ttUser THEN ASSIGN cEmailAddress = ttUser.USER_email_address.
    END.

    IF cEmailAddress <> "":U THEN /* Send email message to user */
        RUN sendEmail IN TARGET-PROCEDURE
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
    ELSE
        ASSIGN pcFailedReason = "Your e-mail address has not been set up against your user account.  Please contact your System Administrator.".
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseAppServerInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE parseAppServerInfo Procedure 
PROCEDURE parseAppServerInfo :
/*------------------------------------------------------------------------------
  Purpose:     Backward compatibility - scheduled for deprecation.
  Parameters:  <none>
  Notes:       THIS PROCEDURE IS HERE FOR BACKWARD COMPATIBILITY AND WILL BE 
               DEPRECATED IN A FORTHCOMING RELEASE. PLEASE USE 
               storeAppServerInfo INSTEAD
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcAppSrvrInfo   AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcSessType      AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcNumFormat     AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcDateFormat    AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcOldSessionID  AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE cCurrAppSrv AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cNumSep     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDecPoint   AS CHARACTER  NO-UNDO.
    ASSIGN
      pcSessType     = "":U
      pcNumFormat    = "":U
      pcDateFormat   = "":U
      pcOldSessionID = "":U.

    /* If this is a new format string, run the storeAppServerInfo API and
       setup the return values appropriately. */
    IF NUM-ENTRIES(pcAppSrvrInfo,CHR(3)) > 1 THEN
    DO:
      RUN storeAppServerInfo
        (pcAppSrvrInfo).

      cNumSep      = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                      "client_NumericSeparator":U).
      cDecPoint    = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                      "client_DecimalPoint":U).

      IF cNumSep = "EUROPEAN":U OR 
         cNumSep = "AMERICAN":U THEN
        pcNumFormat = cNumSep.
      ELSE
        pcNumFormat = cNumSep + cDecPoint.

      pcDateFormat = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                     "client_DateFormat":U).
      pcSessType   = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                     "client_SessionType":U).
      pcOldSessionID = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                        "client_OldSessionID":U).
    END.
    ELSE
    DO:
      /* Reset the AppServer info */
      RUN storeAppServerInfo IN TARGET-PROCEDURE
        ("":U).

      /* Parse out the information from AppSrvrInfo string. */
      IF LENGTH(pcAppSrvrInfo) > 2 THEN
      DO:
        /* First two characters MUST be numeric format */
        ASSIGN
          pcNumFormat  = SUBSTRING(pcAppSrvrInfo, 1, 2)
          cCurrAppSrv = SUBSTRING(pcAppSrvrInfo, 3).

        IF pcNumFormat = "EUROPEAN":U OR
           pcNumFormat = "AMERICAN":U THEN
        DO:
          DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                           "client_NumericSeparator":U,
                           pcNumFormat).
          DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                           "client_DecimalPoint":U,
                           ?).
        END.
        ELSE IF LENGTH(pcNumFormat) = 2 THEN
        DO:
          DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                           "client_NumericSeparator":U,
                           SUBSTRING(pcNumFormat,1,1)).
          DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                           "client_DecimalPoint":U,
                           SUBSTRING(pcNumFormat,2,1)).
        END.
        ELSE
        DO:
          DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                           "client_NumericSeparator":U,
                           ?).
          DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                           "client_DecimalPoint":U,
                           ?).
        END.

        /* Next three characters must be date format */
        IF LENGTH(cCurrAppSrv) > 3 THEN
        DO:
          ASSIGN
            pcDateFormat = SUBSTRING(cCurrAppSrv, 1, 3)
            cCurrAppSrv = SUBSTRING(cCurrAppSrv, 4).
          IF pcDateFormat = "?":U THEN
            pcDateFormat = ?.
          DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                           "client_DateFormat":U,
                           pcDateFormat).

          /* The next entry (to the comma) is the client session type,
             and everything after the comma is the old connection id. */
          IF NUM-ENTRIES(cCurrAppSrv) >= 1 THEN
          DO:
            ASSIGN
              pcSessType    = ENTRY(1,cCurrAppSrv)
              pcOldSessionID = SUBSTRING(cCurrAppSrv, LENGTH(pcSessType) + 2).
            IF pcSessType   = "?":U THEN
              pcSessType = ?.
            IF pcOldSessionID = "?":U THEN
              pcOldSessionID = ?.
            DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                             "client_SessionType":U,
                             pcSessType).
            DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                             "client_OldSessionID":U,
                             pcOldSessionID).
          END.
        END.
      END.
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

  ASSIGN glPlipShutting = YES.
  RUN deletePersistentProc IN TARGET-PROCEDURE.  /* delete persistent procs started since we started */

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
cLoginWindow = DYNAMIC-FUNCTION("getPropertyList":U IN TARGET-PROCEDURE,
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

/* 1st flush old user profile cache to db - only if not using appserver, as with
   appserver this was already done as part of login
*/
IF SESSION = gshAstraAppserver THEN
  RUN updateCacheToDb IN gshProfileManager (INPUT "":U).

/* Re-logged in, so reset details */
IF tCurrentProcessDate = ? THEN ASSIGN tCurrentProcessDate = TODAY.
DEFINE VARIABLE cDateFormat AS CHARACTER NO-UNDO.
cDateFormat = DYNAMIC-FUNCTION("getPropertyList":U IN TARGET-PROCEDURE,
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

DYNAMIC-FUNCTION("setPropertyList":U IN TARGET-PROCEDURE,
                                     INPUT cPropertyList,
                                     INPUT cValueList,
                                     INPUT NO).

/* reset status bars */
PUBLISH 'ClientCachedDataChanged' FROM TARGET-PROCEDURE.

/* clear caches - ONLY if not using appserver because if using appserver, the
   caches were already fixed as part of login
*/
IF SESSION = gshAstraAppserver THEN
DO:
  DEFINE VARIABLE cCacheTranslations            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lCacheTranslations            AS LOGICAL    INITIAL YES NO-UNDO.
  cCacheTranslations = DYNAMIC-FUNCTION("getPropertyList":U IN TARGET-PROCEDURE,
                                   INPUT "cachedTranslationsOnly":U,
                                   INPUT NO).
  lCacheTranslations = cCacheTranslations <> "NO":U NO-ERROR.
  
  /* if caching translations - do so for logged into language */
  RUN clearClientCache IN gshTranslationManager.
  IF lCacheTranslations THEN
  DO:
    RUN buildClientCache IN gshTranslationManager (INPUT dCurrentLanguageObj).
  END.

  /* Rebuild user profile data - only if not using appserver, as when using appserver
     the login window will have already cached the profile data via the api logincacheafter 
     which does all the ccahing in one appserver hit. 
  */
  RUN clearClientCache IN gshProfileManager.
  RUN buildClientCache IN gshProfileManager (INPUT "":U). /* load temp-table on client */

END.

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
  assign 
  hParent:SCROLLABLE = TRUE
  phFrame:SCROLLABLE = TRUE
  
  hWindow:VIRTUAL-WIDTH-CHARS  = session:width-chars
  hWindow:VIRTUAL-HEIGHT-CHARS = session:height-chars
  phFrame:VIRTUAL-WIDTH-CHARS  = session:width-chars
  phFrame:VIRTUAL-HEIGHT-CHARS = session:height-chars
  hParent:VIRTUAL-WIDTH-CHARS  = session:width-chars
  hParent:VIRTUAL-HEIGHT-CHARS = session:height-chars.

  /* move frame back if we can */
  IF phFrame:COLUMN - pdAddCol > 1 THEN
    ASSIGN phFrame:COLUMN = phFrame:COLUMN - pdAddCol.
  ELSE
    ASSIGN phFrame:COLUMN = 1.
  
  /* resize window if too small to fit frame (plus a bit for margin)  */
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
  
  /* got a valid widget to move */
  {get LabelHandle hSideLabel phObject} no-error.
  
  field-loop:
  DO iLoop = 1 TO NUM-ENTRIES(cAllFieldHandles):
  
    ASSIGN 
      hWidget = WIDGET-HANDLE(ENTRY(iLoop, cAllFieldHandles)).
    IF NOT VALID-HANDLE(hWidget) OR
       LOOKUP(hWidget:TYPE, "text,button,fill-in,selection-list,editor,combo-box,radio-set,slider,toggle-box":U) = 0
       OR NOT CAN-QUERY(hWidget, "column":U) THEN NEXT field-loop.
  
  
    hWidget:COLUMN = hWidget:COLUMN + pdAddCol.
  
    IF VALID-HANDLE(hSideLabel) THEN
    do:
      hSideLabel:COLUMN = hWidget:COLUMN - hSideLabel:WIDTH.
    end.
  END.

  assign 
  hWindow:VIRTUAL-WIDTH-CHARS  = hWindow:WIDTH-CHARS
  hWindow:VIRTUAL-HEIGHT-CHARS = hWindow:HEIGHT-CHARS
  phFrame:VIRTUAL-WIDTH-CHARS  = phFrame:WIDTH-CHARS
  phFrame:VIRTUAL-HEIGHT-CHARS = phFrame:HEIGHT-CHARS
  phFrame:SCROLLABLE = FALSE
  hParent:VIRTUAL-WIDTH-CHARS  = hParent:WIDTH-CHARS
  hParent:VIRTUAL-HEIGHT-CHARS = hParent:HEIGHT-CHARS
  hParent:SCROLLABLE = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeNormalFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeNormalFrame Procedure 
PROCEDURE resizeNormalFrame :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       hParent corresponds to the window or dialog-box that is parent
               of the specified frame.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phObject           AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER phFrame            AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pdNewWidth         AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE hParent                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer                AS HANDLE     NO-UNDO.
  
  IF phFrame:TYPE = "DIALOG-BOX":U THEN
      ASSIGN hContainer = ?
             hParent    = ?.
  ELSE
  DO:
      ASSIGN hContainer = DYNAMIC-FUNCTION("getcontainersource":U IN phObject) NO-ERROR.

      /* Walk through parents to get parent window or dialog-box */
      hParent = phFrame:PARENT.
      DO WHILE VALID-HANDLE(hParent):
          IF CAN-DO("WINDOW,DIALOG-BOX":U, hParent:TYPE) THEN LEAVE.
          hParent = hParent:PARENT.
      END.
  END.
  
  /* 1st make frame virtually big to avoid size issues */
  phFrame:SCROLLABLE = TRUE NO-ERROR.
  hParent:VIRTUAL-WIDTH-CHARS  = SESSION:WIDTH-CHARS NO-ERROR.
  hParent:VIRTUAL-HEIGHT-CHARS = SESSION:HEIGHT-CHARS NO-ERROR.
  phFrame:VIRTUAL-WIDTH-CHARS  = SESSION:WIDTH-CHARS - 1 NO-ERROR.
  phFrame:VIRTUAL-HEIGHT-CHARS = SESSION:HEIGHT-CHARS - 1 NO-ERROR.
  
  /* resize window if too small to fit new frame (plus a bit for margin) */
  IF VALID-HANDLE(hParent) 
      AND (pdNewWidth) > (hParent:WIDTH-CHARS - 10) THEN
  DO:
    hParent:WIDTH-CHARS = pdNewWidth + 10 NO-ERROR.
    IF CAN-SET(hParent, "MIN-WIDTH-CHARS":U) THEN
        hParent:MIN-WIDTH-CHARS = pdNewWidth + 10 NO-ERROR.
  
    IF VALID-HANDLE(hContainer) THEN
    DO:
      APPLY "window-resized":u TO hParent.
      RUN resizeWindow IN hContainer NO-ERROR.
    END.
  END.
  
  /* resize frame to fit new labels */
  phFrame:WIDTH-CHARS = pdNewWidth NO-ERROR.
  
  /* always ensure min window size set correctly - even if not resized */
  IF VALID-HANDLE(hParent)
      AND CAN-QUERY(hParent, "MIN-WIDTH-CHARS":U)
      AND CAN-SET(hParent, "MIN-WIDTH-CHARS":U)
      AND (hParent:MIN-WIDTH-CHARS - 10) < phFrame:WIDTH-CHARS THEN
    ASSIGN hParent:MIN-WIDTH-CHARS = phFrame:WIDTH-CHARS + 10 NO-ERROR.
  
  hParent:VIRTUAL-WIDTH-CHARS  = hParent:WIDTH-CHARS NO-ERROR.
  hParent:VIRTUAL-HEIGHT-CHARS = hParent:HEIGHT-CHARS NO-ERROR.
  phFrame:VIRTUAL-WIDTH-CHARS  = phFrame:WIDTH-CHARS NO-ERROR.
  phFrame:VIRTUAL-HEIGHT-CHARS = phFrame:HEIGHT-CHARS NO-ERROR.
  phFrame:SCROLLABLE = FALSE NO-ERROR.

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

  DEFINE VARIABLE hParentFrame AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindow      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSideLabel   AS HANDLE     NO-UNDO.
  
  /* We're going to move the frame in line with the other widgets */  
  ASSIGN hParentFrame = phFrame:PARENT      /* Field group */
         hParentFrame = hParentFrame:PARENT /* Frame */
         NO-ERROR.
  
  IF VALID-HANDLE(hParentFrame)
  AND hParentFrame:TYPE = "FRAME":U THEN
      IF (phFrame:COLUMN + phFrame:WIDTH + pdAddCol) <= hParentFrame:WIDTH THEN DO:
          ASSIGN phFrame:COLUMN = phFrame:COLUMN + pdAddCol no-error.
          /* We need to move the label too */          
          {get LabelHandle hSideLabel phObject} NO-ERROR.
          IF VALID-HANDLE(hSideLabel) THEN
            hSideLabel:COLUMN = IF (phFrame:COLUMN - hSideLabel:WIDTH) < 1 THEN 1 ELSE (phFrame:COLUMN - hSideLabel:WIDTH) no-error.
  END.
      ELSE
          RUN resizeLookupFrame IN TARGET-PROCEDURE
                                (INPUT phObject, /* This proc will work for combos and lookups */
                                 INPUT phFrame,
                                 INPUT pdAddCol).
  
  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN "":U.

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
    DEFINE INPUT PARAMETER phFocus      AS HANDLE                       NO-UNDO.

    DEFINE VARIABLE cOldValue       AS CHARACTER                        NO-UNDO.

    IF CAN-QUERY(phFocus,"data-type":U) AND
       CAN-QUERY(phFocus,"sensitive":U) AND phFocus:SENSITIVE = TRUE THEN
    DO:
        APPLY "ENTRY":U TO phFocus.
        ASSIGN cOldValue = phFocus:SCREEN-VALUE.

        CASE phFocus:DATA-TYPE:
            WHEN "date":U THEN
            DO:
                ASSIGN gcLogicalContainerName = "afcalnpopd":U.
                RUN af/cod2/afcalnpopd.w (INPUT phFocus).
            END.    /* date*/
            WHEN "decimal":U OR WHEN "integer":U OR WHEN "INT64":U THEN
            DO:
                ASSIGN gcLogicalContainerName = "afcalcpopd":U.
                RUN af/cod2/afcalcpopd.w (INPUT phFocus).
            END.    /* decimal/integer */
        END CASE.   /* datatype */

        ASSIGN gcLogicalContainerName = "":U.

        IF cOldValue <> phFocus:SCREEN-VALUE THEN
            APPLY "value-changed":U TO phFocus.
    END.    /* is sensitive and has a data-type */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* runLookup */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-seedTempUniqueID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE seedTempUniqueID Procedure 
PROCEDURE seedTempUniqueID :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF DEFINED(server-side) <> 0 &THEN
   DEFINE VARIABLE iSessNo AS INTEGER    NO-UNDO.
   DEFINE VARIABLE iSiteRev AS INTEGER    NO-UNDO.
   DEFINE VARIABLE iSiteDiv AS INTEGER    NO-UNDO.
   ASSIGN
     iSiteRev = CURRENT-VALUE(seq_site_reverse,ICFDB)
     iSiteRev = (IF iSiteRev = ? THEN 0 ELSE iSiteRev)
     iSiteDiv = CURRENT-VALUE(seq_site_division,ICFDB)
     iSiteDiv = (IF iSiteDiv < 1 THEN 1 ELSE iSiteDiv)
     gsdTempUniqueID = (NEXT-VALUE(seq_session_id,ICFDB) * 10000000000000000000000000000.0)
                     + (iSiteRev / iSiteDiv)

   .
&ELSE
   gsdTempUniqueID = 90000000000000000000000000000000000000000.0.
&ENDIF

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

IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
DO: /* on server so use sendmail */

  /* get current user email from property for current user */
  cFromEmail = DYNAMIC-FUNCTION("getPropertyList":U IN TARGET-PROCEDURE,
                                INPUT "currentUserEmail":U,
                                INPUT NO).
  cUserLogin = DYNAMIC-FUNCTION("getPropertyList":U IN TARGET-PROCEDURE,
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
DO: /* On client so use MAPI */

  /* Before we start, get the current application directory and store it. We need to do this because *
   * MAPI changes it.  NASTY...                                                                      */
  &IF OPSYS = "WIN32" &THEN /* Probably the whole ELSE DO needs this check, will leave as is for now */
      DEFINE VARIABLE cCurrentAppDir AS CHARACTER  NO-UNDO.
      DEFINE VARIABLE iBufferSize    AS INTEGER    NO-UNDO INITIAL 256.
      DEFINE VARIABLE iResult        AS INTEGER    NO-UNDO.
      DEFINE VARIABLE mString        AS MEMPTR     NO-UNDO.
    
      SET-SIZE(mString) = 256.    
      RUN GetCurrentDirectoryA (INPUT iBufferSize,
                                INPUT-OUTPUT mString,
                                OUTPUT iResult).
      ASSIGN cCurrentAppDir = GET-STRING(mString,1).
      SET-SIZE(mString) = 0.
  &ENDIF

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
      IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
          chRecipient1:Resolve (YES) NO-ERROR.    /* Show dialog */
      ELSE
          chRecipient1:Resolve (NO) NO-ERROR.     /* Supress Dialog */
    END.
  IF cCcEmail <> "":U THEN
    DO:
      chRecipient2 = chMessage:Recipients:Add.
      chRecipient2:Name = cCcEmail.
      chRecipient2:Type = 2.
      IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
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
/*RELEASE OBJECT chMessage NO-ERROR. - causes GPF */
  RELEASE OBJECT chSession.

  ASSIGN chAttachment = ?
         chRecipient1 = ?
         chRecipient2 = ?
         chMessage    = ?
         chSession    = ?.

  /* Make sure the application directory is set correctly */
  &IF OPSYS = "WIN32" &THEN
      RUN SetCurrentDirectoryA (INPUT cCurrentAppDir, OUTPUT iResult).
  &ENDIF
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
    cSignature = DYNAMIC-FUNCTION ("Signature":U IN phObject, "get":U + cProperty).

  /** The message code removed to avoid issues with attributes being set in an
   *  object which are not available as properties in the object. This becomes
   *  as issue as more objects become dynamic (eg viewers, lookups, etc); attributes
   *  such as HEIGHT-CHARS are necessary for the instantiation of the object, but 
   *  are not strictly properties of the object.                                  */
    IF cSignature NE "":U THEN
    CASE ENTRY(2,cSignature):
      WHEN "INTEGER":U THEN
        DYNAMIC-FUNCTION("set":U + cProperty IN phObject, INT(cValue)) NO-ERROR.
      WHEN "DECIMAL":U THEN
        DYNAMIC-FUNCTION("set":U + cProperty IN phObject, DEC(cValue)) NO-ERROR.
      WHEN "CHARACTER":U THEN
        DYNAMIC-FUNCTION("set":U + cProperty IN phObject, cValue) NO-ERROR.
      WHEN "LOGICAL":U THEN
        DYNAMIC-FUNCTION("set":U + cProperty IN phObject,LOGICAL(cValue)) NO-ERROR.
    END CASE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setProfilerAttrs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setProfilerAttrs Procedure 
PROCEDURE setProfilerAttrs :
/*------------------------------------------------------------------------------
  Purpose:  sets the profiler's attributes
    Notes:  see $DLC/src/samples/profiler
    Param:  plRunServer - if TRUE run on server side
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER plRunOnServer AS LOGICAL   NO-UNDO.
  DEFINE INPUT PARAMETER pcAttrList    AS CHARACTER NO-UNDO.

  &IF DEFINED(server-side) = 0 &THEN
      IF plRunOnServer THEN 
      DO:
        RUN af/app/afsesstprfattrp.p ON gshAstraAppServer
           (INPUT  plRunOnServer,   
            INPUT  pcAttrList) NO-ERROR.
         IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
             RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                             ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
         ELSE
             RETURN.
      END.
  &ENDIF

  DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cCurrAttr  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttrName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttrValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hCall      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCallNo    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cCalls     AS CHARACTER  NO-UNDO INITIAL
    "FILE-NAME,COVERAGE,DESCRIPTION,DIRECTORY,ENABLED,LISTINGS,PROFILING,TRACING,TRACE-FILTER".
  DEFINE VARIABLE cCallType  AS CHARACTER  NO-UNDO INITIAL
    "CHARACTER,LOGICAL,CHARACTER,CHARACTER,LOGICAL,LOGICAL,LOGICAL,CHARACTER,CHARACTER".

  CREATE CALL hCall.
  DO iCount = 1 TO NUM-ENTRIES(pcAttrList):
    ASSIGN
      cCurrAttr  = ENTRY(iCount, pcAttrList)
      cAttrName  = ENTRY(1,cCurrAttr,"=":U)
      cAttrValue = ENTRY(2,cCurrAttr,"=":U)
      iCallNo    = LOOKUP(cAttrName, cCalls)
    .
    IF iCallNo <> 0 AND
       iCallNo <> ? THEN
    DO:
      hCall:CLEAR().
      ASSIGN
        hCall:IN-HANDLE      = PROFILER:HANDLE
        hCall:CALL-TYPE      = SET-ATTR-CALL-TYPE
        hCall:CALL-NAME      = cAttrName
        hCall:NUM-PARAMETERS = 1
      .
      hCall:SET-PARAMETER(1, ENTRY(iCallNo,cCallType), "INPUT":U, cAttrValue).
      hCall:INVOKE.
      hCall:CLEAR().
    END.
  END.
  DELETE OBJECT hCall.
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

&IF DEFINED(EXCLUDE-setScopedContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setScopedContext Procedure 
PROCEDURE setScopedContext :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is responsible for setting the context values for
               a particular scope. The context values can then be used by other
               processes to determine values that have been previously set.
  Parameters:
    pdScopeObj      - The obj of the scope record that is being set.
    pcContextList   - A list of context properties that need to be set in this
                      scope.
    pcContextValues - A list of values (CHR(3) delimited) that needs to be set
                      for the above contexts.  
    
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdScopeObj        AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcContextList     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcContextValues   AS CHARACTER  NO-UNDO.
  
  /* This call *always* needs to execute on the server */
  &IF DEFINED(server-side) = 0 &THEN
      RUN af/app/afsesstscpctxtp.p ON gshAstraAppServer
        (INPUT  pdScopeObj,      
         INPUT  pcContextList,   
         INPUT pcContextValues) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                          ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE 
      DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.
      DEFINE VARIABLE cContext   AS CHARACTER  NO-UNDO.
      DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.
      DEFINE VARIABLE cErrorText AS CHARACTER  NO-UNDO.

      DEFINE BUFFER bgsm_server_context FOR gsm_server_context.
      DEFINE BUFFER bgst_context_scope  FOR gst_context_scope.

      IF pdScopeObj = 0.00 THEN
        pdScopeObj = gsdSessionScopeObj.

      /* We do not set context if the scope obj is 0.
         This works around the case where this call is made
         before the activateSession has been called. */
      IF pdScopeObj = 0.00 THEN  
        RETURN "":U.
      
      DO FOR bgst_context_scope TRANSACTION ON ERROR UNDO, LEAVE:
        FIND FIRST bgst_context_scope EXCLUSIVE-LOCK
          WHERE bgst_context_scope.context_scope_obj = pdScopeObj
          NO-ERROR.
        IF NOT AVAILABLE(bgst_context_scope) OR 
           bgst_context_scope.transaction_complete THEN
          RETURN ERROR {af/sup2/aferrortxt.i 'AF' '99'}.
        ELSE
          ASSIGN 
            bgst_context_scope.last_access_date = TODAY
            bgst_context_scope.last_access_time = TIME
          .
      END.


      DO iCount = 1 TO NUM-ENTRIES(pcContextList):
        ASSIGN 
          cContext = TRIM(ENTRY(iCount,pcContextList))
        .

        IF NUM-ENTRIES(pcContextValues, CHR(3)) >= iCount THEN
          cValue    = ENTRY(iCount,pcContextValues,CHR(3)).
        ELSE
          cValue    = "":U.
        
        trn-block:
        DO FOR bgsm_server_context TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:
          FIND FIRST bgsm_server_context EXCLUSIVE-LOCK
               WHERE bgsm_server_context.context_scope_obj = pdScopeObj
                 AND bgsm_server_context.context_name = cContext
               NO-ERROR.

          ERROR-STATUS:ERROR = NO.

          IF NOT AVAILABLE bgsm_server_context THEN
          DO:
            CREATE bgsm_server_context NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
              UNDO trn-block, LEAVE trn-block.
            ASSIGN
              bgsm_server_context.context_scope_obj = pdScopeObj
              bgsm_server_context.context_name = cContext
              .
          END.
          ASSIGN
            bgsm_server_context.context_id_date = TODAY
            bgsm_server_context.context_id_time = TIME
            bgsm_server_context.context_value = cValue
            .
          VALIDATE bgsm_server_context NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
            UNDO trn-block, LEAVE trn-block.
        END.
        IF ERROR-STATUS:ERROR THEN RETURN ERROR RETURN-VALUE.
      END.  /* iCount = 1 TO NUM-ENTRIES(pcContextList) */
      RETURN "":U.
  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSessTypeOverrideInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSessTypeOverrideInfo Procedure 
PROCEDURE setSessTypeOverrideInfo :
/*------------------------------------------------------------------------------
  ACCESS_LEVEL = PUBLIC
  Purpose:     Sets the session type override information into the Dynamics 
               repository.
  Parameters:  
    plConfigDefault         - Can the session types in the repository be 
                              overridden?
    plAllowUnregistered     - Do we allow users to start sessions with 
                              unregistered session types?
    pcPermittedUnregistered - Comma-separated list of session types that are
                              not defined in the repository that we will allow
                              to access the repository.
  Notes:       
    This API verifies whether a user is connected using a valid session type
    and only sets these values if this is true. 
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plConfigDefault         AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plAllowUnregistered     AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcPermittedUnregistered AS CHARACTER  NO-UNDO.

  /* This stuff only gets done in a server side session */
  &IF DEFINED(server-side) = 0 &THEN
    RUN af/app/afsesststorinfop.p ON gshAstraAppServer
      (INPUT  plConfigDefault,      
       INPUT  plAllowUnregistered,   
       INPUT  pcPermittedUnregistered) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE
    DEFINE BUFFER bgsc_global_default   FOR gsc_global_default.
    DEFINE BUFFER bgsc_security_control FOR gsc_security_control.
    
    DEFINE VARIABLE cSessType AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lRegSess  AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cError    AS CHARACTER  NO-UNDO.
    
    /* If we're on the AppServer, we need to use the client_SessionType parameter
       to determine whether we can set this value. On anything else, including 
       WebSpeed, we use ICFSESSTYPE. */
    IF SESSION:REMOTE THEN
      ASSIGN
        cSessType = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                     "client_SessionType":U)
      .
    ELSE
      ASSIGN
        cSessType = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                     "ICFSESSTYPE":U)
      .
  
    /* If we're on the server we need to validate that the client session type
       is a valid session type that is registered. If it is not a registered 
       session type we need to throw an exception. You may not make this call
       if you are not using a valid session type. */
    IF cSessType = "":U OR 
       cSessType = ? THEN
      lRegSess = NO.
    ELSE
      lRegSess = DYNAMIC-FUNCTION("isSessTypeRegistered":U IN ghSessTypeCache,
                                  cSessType).
  
    IF NOT lRegSess THEN
    DO:
      ASSIGN
        cError = {af/sup2/aferrortxt.i 'ICF' '6' '?' '?' "cSessType"}.
      RETURN ERROR cError.
    END.
    ELSE
    DO:
      FIND FIRST bgsc_security_control NO-LOCK.
      DO TRANSACTION ON ERROR UNDO, RETURN ERROR RETURN-VALUE:
        FIND FIRST bgsc_global_default EXCLUSIVE-LOCK
          WHERE bgsc_global_default.owning_entity_mnemonic = "GSCSC":U 
            AND bgsc_global_default.owning_obj             = bgsc_security_control.security_control_obj
            AND bgsc_global_default.default_type           = "CFG":U
            AND bgsc_global_default.effective_date         = DATE(01,01,1801)
          NO-ERROR.
        IF NOT AVAILABLE(bgsc_global_default) THEN
        DO:
          CREATE bgsc_global_default.
          ASSIGN
            bgsc_global_default.owning_entity_mnemonic = "GSCSC":U 
            bgsc_global_default.owning_obj             = bgsc_security_control.security_control_obj
            bgsc_global_default.default_type           = "CFG":U
            bgsc_global_default.effective_date         = DATE(01,01,1801)
          .
        END.
        ASSIGN
          bgsc_global_default.default_value = STRING(plConfigDefault)
        .
  
        FIND FIRST bgsc_global_default EXCLUSIVE-LOCK
          WHERE bgsc_global_default.owning_entity_mnemonic = "GSCSC":U 
            AND bgsc_global_default.owning_obj             = bgsc_security_control.security_control_obj
            AND bgsc_global_default.default_type           = "AUR":U
            AND bgsc_global_default.effective_date         = DATE(01,01,1801)
          NO-ERROR.
        IF NOT AVAILABLE(bgsc_global_default) THEN
        DO:
          CREATE bgsc_global_default.
          ASSIGN
            bgsc_global_default.owning_entity_mnemonic = "GSCSC":U 
            bgsc_global_default.owning_obj             = bgsc_security_control.security_control_obj
            bgsc_global_default.default_type           = "AUR":U
            bgsc_global_default.effective_date         = DATE(01,01,1801)
          .
        END.
        ASSIGN
          bgsc_global_default.default_value = STRING(plAllowUnregistered)
        .
        
        FIND FIRST bgsc_global_default EXCLUSIVE-LOCK
          WHERE bgsc_global_default.owning_entity_mnemonic = "GSCSC":U 
            AND bgsc_global_default.owning_obj             = bgsc_security_control.security_control_obj
            AND bgsc_global_default.default_type           = "PUR":U
            AND bgsc_global_default.effective_date         = DATE(01,01,1801)
          NO-ERROR.
        IF NOT AVAILABLE(bgsc_global_default) THEN
        DO:
          CREATE bgsc_global_default.
          ASSIGN
            bgsc_global_default.owning_entity_mnemonic = "GSCSC":U 
            bgsc_global_default.owning_obj             = bgsc_security_control.security_control_obj
            bgsc_global_default.default_type           = "PUR":U
            bgsc_global_default.effective_date         = DATE(01,01,1801)
          .
        END.
        ASSIGN
          bgsc_global_default.default_value = pcPermittedUnregistered
        .
      
      END.
    END.
  &ENDIF

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
      ASSIGN pcMessageTitle = "About Application":U.
  END CASE.
  IF plDisplayEmpty = ? THEN ASSIGN plDisplayEmpty = YES.

  /* Next interpret / translate the messages */
  RUN afmessagep IN TARGET-PROCEDURE 
                  (INPUT pcMessageList,
                   INPUT pcButtonList,
                   INPUT pcMessageTitle,
                  OUTPUT cSummaryMessages,
                  OUTPUT cFullMessages,
                  OUTPUT cButtonList,
                  OUTPUT cMessageTitle,
                  OUTPUT lUpdateErrorLog,
                  OUTPUT lSuppressDisplay).  

  /* Display message if not remote and not suppressed */
  IF NOT lSuppressDisplay THEN
      cSuppressDisplay = DYNAMIC-FUNCTION("getPropertyList":U IN TARGET-PROCEDURE, INPUT "suppressDisplay":U, INPUT YES).
  ELSE 
      cSuppressDisplay = "YES":U.

  ASSIGN lSuppressDisplay = (cSuppressDisplay = "YES":U).

  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) AND NOT lSuppressDisplay THEN
  DO:
    ASSIGN gcLogicalContainerName = "afmessaged":U.

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
    ASSIGN gcLogicalContainerName = "":U.

    IF iButtonPressed > 0 AND iButtonPressed <= NUM-ENTRIES(pcButtonList) THEN
        ASSIGN pcButtonPressed = ENTRY(iButtonPressed, pcButtonList).  /* Pass back untranslated button pressed */
    ELSE
        ASSIGN pcButtonPressed = pcDefaultButton.
  END.
  ELSE
      ASSIGN pcButtonPressed = pcDefaultButton.  /* If remote, assume default button */

  /* If remote, or update error log set to YES, then update error log and send an email if possible */
  IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) OR lUpdateErrorLog OR lSuppressDisplay THEN
      RUN updateErrorLog IN TARGET-PROCEDURE (INPUT cSummaryMessages,
                                              INPUT cFullMessages).
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

  RUN afmessagep IN TARGET-PROCEDURE 
                  (INPUT pcMessageList,
                   INPUT cButtonList,
                   INPUT pcMessageTitle,
                  OUTPUT cSummaryList,
                  OUTPUT cFullList,
                  OUTPUT cNewButtonList,
                  OUTPUT cNewTitle,
                  OUTPUT lUpdateErrorLog,
                  OUTPUT lSuppressDisplay).

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

&IF DEFINED(EXCLUDE-startProfiling) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startProfiling Procedure 
PROCEDURE startProfiling :
/*------------------------------------------------------------------------------
  Purpose:  starts 4GL execution profiling
    Notes:  see $DLC/src/samples/profiler
    Param:  plRunServer - if TRUE run on server side
------------------------------------------------------------------------------*/
  DEFINE  INPUT PARAMETER plRunOnServer   AS LOGICAL    NO-UNDO.

  &IF DEFINED(server-side) = 0 &THEN
       IF plRunOnServer THEN 
       DO:
           RUN af/app/afsesstrtprfp.p ON gshAstraAppServer
             (INPUT  plRunOnServer) NO-ERROR.
           IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
               RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                               ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
           ELSE
               RETURN.
       END.
  &ENDIF
  PROFILER:PROFILING = TRUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-stopProfiling) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE stopProfiling Procedure 
PROCEDURE stopProfiling :
/*------------------------------------------------------------------------------
  Purpose:  stops 4GL execution profiling and writes out data
    Notes:  see $DLC/src/samples/profiler
    Param:  plRunServer - if TRUE run on server side
------------------------------------------------------------------------------*/
  DEFINE  INPUT PARAMETER plRunOnServer   AS LOGICAL    NO-UNDO.

  &IF DEFINED(server-side) = 0 &THEN
      IF plRunOnServer THEN 
      DO:
          RUN af/app/afsesstpprfp.p ON gshAstraAppServer
            (INPUT  plRunOnServer) NO-ERROR.
          IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
              RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                              ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
          ELSE
              RETURN.
      END.
  &ENDIF
  PROFILER:PROFILING = FALSE. 
  PROFILER:WRITE-DATA().
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeAppServerInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE storeAppServerInfo Procedure 
PROCEDURE storeAppServerInfo :
/*------------------------------------------------------------------------------
  Purpose:     This procedure parses a string, typically provided to 
               as_connect.p and stores the values as session properties
               for later retrieval.
  Parameters:  <none>
  Notes:       
      This string is setup by afasconmngrp.p before it makes a connection to
      the AppServer. Any client wanting to make use of this mechanism needs to
      string these values together into a CHR(3) delimited string.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcAppServerInfo AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cCurrValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrParam AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParam     AS CHARACTER  
    INITIAL "DynamicsVersion,PhysicalSessType,NumericSeparator,DecimalPoint,DateFormat,YearOffset,SessionType,OldSessionID,NewSessionID":U
    NO-UNDO.
  DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.

  DO iCount = 1 TO NUM-ENTRIES(cParam):
    cCurrParam = ENTRY(iCount,cParam).
    IF iCount > NUM-ENTRIES(pcAppServerInfo,CHR(3)) THEN
      cCurrValue = ?.
    ELSE
      cCurrValue = ENTRY(iCount,pcAppServerInfo,CHR(3)).
    IF cCurrValue = "?":U THEN
       cCurrValue = ?.
    DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                     "client_":U + cCurrParam,
                     cCurrValue).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-translateWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE translateWidgets Procedure 
PROCEDURE translateWidgets :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Retrieves and applies translations for widgets on a viewer, including
                           field-level widgets and SDFs.
  Parameters:  phObject
                           phFrame
                           TABLE for ttTranslate
  Notes:       Called from widgetWalk().
------------------------------------------------------------------------------*/        
    DEFINE INPUT PARAMETER phObject AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER phFrame  AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR ttTranslate.

    /* Code moved to separate include because it blows up section editor. */
    {af/app/afsestranw.i}
    
    ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* translateWidgets */

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
    
    RUN aferrorlgp IN TARGET-PROCEDURE (INPUT pcSummaryList, INPUT pcFullList).  
    
    /* cannot check for messages as called from showmessages and may go recursive */
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateHelp Procedure 
PROCEDURE updateHelp :
/*------------------------------------------------------------------------------
  Purpose:     Update the help table with the supplied temp-table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE-HANDLE hHelpTable.

&IF DEFINED(Server-Side) = 0 &THEN

/* We're going to make a dynamic call to the Appserver, we need to build the temp-table of parameters */

DEFINE VARIABLE hTableNotUsed    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParamTable      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTTHandlesToSend AS HANDLE     NO-UNDO EXTENT 64.        

IF NOT TRANSACTION THEN EMPTY TEMP-TABLE ttSeqType. ELSE FOR EACH ttSeqType: DELETE ttSeqType. END.

CREATE ttSeqType.
ASSIGN ttSeqType.iParamNo   = 1
       ttSeqType.cIOMode    = "INPUT":U
       ttSeqType.cParamName = "T:01":U
       ttSeqType.cDataType  = "TABLE-HANDLE".

/* Now assign the TABLE-HANDLEs, note they map directly to the ttSeq records of type TABLE-HANDLE */

ASSIGN hTTHandlesToSend[1] = hHelpTable
       hParamTable         = TEMP-TABLE ttSeqType:HANDLE.

/* calltablett.p will construct and execute the call on the Appserver */

RUN adm2/calltablett.p ON gshAstraAppserver
    (
     "updateHelp":U,
     "SessionManager":U,
     INPUT "S":U,
     INPUT-OUTPUT hTableNotUsed,
     INPUT-OUTPUT TABLE-HANDLE hParamTable,
     "",
     {src/adm2/callttparam.i &ARRAYFIELD = "hTTHandlesToSend"}  /* The actual array of table handles */ 
    ) NO-ERROR.

DELETE OBJECT hParamTable.
ASSIGN hParamTable = ?.

IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

&ELSE
DEFINE BUFFER gsm_help FOR gsm_help.

DEFINE VARIABLE hBuffer            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hQuery             AS HANDLE     NO-UNDO.

DEFINE VARIABLE hLanguageObj       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainerFileName AS HANDLE     NO-UNDO.
DEFINE VARIABLE hObjectName        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidgetName        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hHelpFilename      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hHelpContext       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDelete            AS HANDLE     NO-UNDO.
DEFINE VARIABLE lDelete            AS LOGICAL    NO-UNDO.

ASSIGN hBuffer            = hHelpTable:DEFAULT-BUFFER-HANDLE
       hLanguageObj       = hBuffer:BUFFER-FIELD("dLanguageObj":U)
       hContainerFileName = hBuffer:BUFFER-FIELD("cContainerFileName":U)
       hObjectName        = hBuffer:BUFFER-FIELD("cObjectName":U)
       hWidgetName        = hBuffer:BUFFER-FIELD("cWidgetName":U)
       hHelpFilename      = hBuffer:BUFFER-FIELD("cHelpFilename":U)
       hHelpContext       = hBuffer:BUFFER-FIELD("cHelpContext":U)
       hDelete            = hBuffer:BUFFER-FIELD("lDelete":U).

CREATE QUERY hQuery.
hQuery:ADD-BUFFER(hBuffer).
hQuery:QUERY-PREPARE("FOR EACH ":U + hBuffer:NAME).
hQuery:QUERY-OPEN().

hQuery:GET-FIRST().

/* Update the whole record set in one transaction */

trn-blk:
DO FOR gsm_help TRANSACTION ON ERROR UNDO trn-blk, LEAVE trn-blk:

    do-blk:
    DO WHILE NOT hQuery:QUERY-OFF-END:
    
        FIND gsm_help EXCLUSIVE-LOCK
             WHERE gsm_help.language_obj            = hLanguageObj:BUFFER-VALUE
               AND gsm_help.help_container_filename = hContainerFileName:BUFFER-VALUE
               AND gsm_help.help_object_filename    = hObjectName:BUFFER-VALUE
               AND gsm_help.help_fieldname          = hWidgetName:BUFFER-VALUE
             NO-ERROR.
    
        IF NOT AVAILABLE gsm_help
        THEN DO:
            ASSIGN ERROR-STATUS:ERROR = NO. /* We don't want afcheckerr.i to return a false error */

            /* If no filename or context, or flagged for deletion, don't create */

            IF (hHelpFilename:BUFFER-VALUE = "":U
            AND hHelpContext:BUFFER-VALUE  = "":U)
             OR hDelete:BUFFER-VALUE = YES
            THEN DO:
                hQuery:GET-NEXT().
                NEXT do-blk.
            END.

            CREATE gsm_help NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO trn-blk, LEAVE trn-blk.

            ASSIGN gsm_help.language_obj            = hLanguageObj:BUFFER-VALUE
                   gsm_help.help_container_filename = hContainerFileName:BUFFER-VALUE
                   gsm_help.help_object_filename    = hObjectName:BUFFER-VALUE
                   gsm_help.help_fieldname          = hWidgetName:BUFFER-VALUE
                   NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO trn-blk, LEAVE trn-blk.
        END.
        ELSE DO:
            ASSIGN lDelete = (hDelete:BUFFER-VALUE = YES OR (hHelpFilename:BUFFER-VALUE = "":U AND hHelpContext:BUFFER-VALUE = "":U)).

            IF lDelete = YES 
            THEN DO:
                DELETE gsm_help NO-ERROR.
                IF ERROR-STATUS:ERROR THEN UNDO trn-blk, LEAVE trn-blk.

                hQuery:GET-NEXT().
                NEXT do-blk.
            END.
        END.

        ASSIGN gsm_help.help_filename  = hHelpFilename:BUFFER-VALUE
               gsm_help.help_context   = hHelpContext:BUFFER-VALUE
               NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO trn-blk, LEAVE trn-blk.

        hQuery:GET-NEXT().
    END.
END.

hQuery:QUERY-CLOSE().

DELETE OBJECT hQuery.
DELETE OBJECT hHelpTable.

ASSIGN hQuery     = ?
       hHelpTable = ?.

{af/sup2/afcheckerr.i}

&ENDIF

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

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
    DEFINE INPUT PARAMETER phContainer      AS HANDLE    NO-UNDO.
    DEFINE INPUT PARAMETER phObject         AS HANDLE    NO-UNDO.
    DEFINE INPUT PARAMETER phFrame          AS HANDLE    NO-UNDO.
    DEFINE INPUT PARAMETER pcAction         AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER plPopupsInFields AS LOGICAL   NO-UNDO.

    /* Section editor wusses out with too much code ... */
    {af/app/afseswiwlk.i}

    error-status:error = no.
    RETURN.
END PROCEDURE.    /* widgetWalk */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addAsSuperProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addAsSuperProcedure Procedure 
FUNCTION addAsSuperProcedure RETURNS LOGICAL
    ( INPUT phSuperProcedure        AS HANDLE,
      INPUT phProcedure             AS HANDLE   ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Adds a procedure (phSuperProcedure) and all of its super procedures
            to a specified procedure (phProcedure).
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hSuperProcedure         AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE iLoop                   AS INTEGER                  NO-UNDO.

    DO iLoop = NUM-ENTRIES(phSuperProcedure:SUPER-PROCEDURES) TO 1 BY -1:
        ASSIGN hSuperProcedure = WIDGET-HANDLE(ENTRY(iLoop, phSuperProcedure:SUPER-PROCEDURES)) NO-ERROR.

        IF VALID-HANDLE(hSuperProcedure) THEN
            phProcedure:ADD-SUPER-PROCEDURE(hSuperProcedure, SEARCH-TARGET).
    END.    /* loop through all the super procedures */

    /* Add this procedure as a super. */
    phProcedure:ADD-SUPER-PROCEDURE(phSuperProcedure, SEARCH-TARGET).

    RETURN TRUE.
END FUNCTION.   /* addAsSuperProcedure */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-filterEvaluateOuterJoins) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION filterEvaluateOuterJoins Procedure 
FUNCTION filterEvaluateOuterJoins RETURNS CHARACTER
  (pcQueryString  AS CHARACTER,
   pcFilterFields AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:     When we're filtering on OUTER-JOINs in a browser, Dynamics removes\
               the OUTER-JOIN keyword to ensure we do actually filter.  This procedure
               accepts a query, and a list of fields.  It will check if the fields
               apply to an OUTER-JOIN and remove it if so.
  Parameters:  pcQueryString  - The query to evaluate.
               pcFilterFields - Comma delimited list of fields.  <table>.<field>,<table.field>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cFilterFieldBuffers AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewQueryString     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOuterJoinEntry     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentEntry       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBuffers            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWord               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iQueryLine          AS INTEGER    NO-UNDO.
DEFINE VARIABLE iEntry              AS INTEGER    NO-UNDO.
DEFINE VARIABLE iWord               AS INTEGER    NO-UNDO.
DEFINE VARIABLE lEachFirstLast      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lFoundBuffer        AS LOGICAL    NO-UNDO.

/* Step through the Query by each buffer / table entry */
DO iEntry = 1 TO NUM-ENTRIES(pcQueryString):
    ASSIGN cCurrentEntry  = ENTRY(iEntry, pcQueryString)
           cCurrentEntry  = REPLACE(cCurrentEntry, CHR(10), " ":U) WHEN INDEX(cCurrentEntry, CHR(10)) <> 0
           cCurrentEntry  = REPLACE(cCurrentEntry, CHR(13), " ":U) WHEN INDEX(cCurrentEntry, CHR(13)) <> 0
           lEachFirstLast = FALSE
           lFoundBuffer   = FALSE.
    
    /* If the Entry contains the OUTER-JOIN keyword, continue */
    IF INDEX(cCurrentEntry, "OUTER-JOIN":U) <> 0 
    THEN DO iWord = 1 TO NUM-ENTRIES(cCurrentEntry, " ":U):
        ASSIGN cWord = ENTRY(iWord, cCurrentEntry, " ":U).
    
        /* Set the lEachFirstLast flag when the EACH, FIRST or LAST keywords are encountered */
        IF TRIM(cWord) = "EACH":U  
        OR TRIM(cWord) = "FIRST":U 
        OR TRIM(cWord) = "LAST":U THEN
            ASSIGN lEachFirstLast = TRUE.
        ELSE
            IF TRIM(cWord) <> "":U AND lEachFirstLast = TRUE THEN
              /* Found the table name */
              ASSIGN cOuterJoinEntry = cOuterJoinEntry + (IF TRIM(cOuterJoinEntry) = "":U THEN "":U ELSE ",":U) + STRING(iEntry)
                     cBuffers        = cBuffers        + (IF TRIM(cBuffers)        = "":U THEN "":U ELSE ",":U) + cWord
                     lFoundBuffer    = TRUE.
    
        IF lFoundBuffer = TRUE THEN LEAVE.
    END.
END.

/* Ensure the variable is empty for the next steps */
ASSIGN cWord = "":U.

/* Pick up to which 'buffer line' in the query do we need to replace OUTER-JOINs with '' */
IF TRIM(pcFilterFields) <> "":U 
THEN DO iEntry = 1 TO NUM-ENTRIES(cBuffers):
    ASSIGN cCurrentEntry = ENTRY(iEntry, cBuffers).
    
    DO iWord = 1 TO NUM-ENTRIES(pcFilterFields):
        IF ENTRY(1, ENTRY(iWord, pcFilterFields), ".":U) = cCurrentEntry THEN
            cWord = cCurrentEntry.
    END.
END.

IF cWord <> "":U 
THEN DO:
    ASSIGN iQueryLine = INTEGER(ENTRY(LOOKUP(cWord, cBuffers), cOuterJoinEntry)).
    
    /* Remove the OUTER-JOIN keyword from the relevant strings */
    DO iEntry = 1 TO NUM-ENTRIES(pcQueryString):
        ASSIGN cCurrentEntry = ENTRY(iEntry, pcQueryString).
    
        IF INDEX(cCurrentEntry, "OUTER-JOIN":U) <> 0 AND iEntry <= iQueryLine THEN
            cCurrentEntry = REPLACE(cCurrentEntry, "OUTER-JOIN":U, "":U).
    
        ASSIGN cNewQueryString = cNewQueryString +  (IF TRIM(cNewQueryString) = "":U THEN "":U ELSE ",":U) + cCurrentEntry.
    END.
END.
ELSE
    cNewQueryString = pcQueryString.

RETURN cNewQueryString.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcLogicalContainerName.

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

    DEFINE BUFFER ttPersistentProc FOR ttPersistentProc.

    IF VALID-HANDLE(phProcedure) THEN
        IF phProcedure:PROXY 
        THEN DO:
            /* When a procedure is launched, we store the internal entries in the temp-table. *
             * See if we can find the entry in there first                                    */

            FIND FIRST ttPersistentProc
                 WHERE ttPersistentProc.physicalName = phProcedure:FILE-NAME
                   AND ttPersistentProc.onAppserver  = YES
                 NO-ERROR.

            IF AVAILABLE ttPersistentProc THEN
                ASSIGN iEntryNumber = LOOKUP(pcProcedureName, ttPersistentProc.internalEntries).

            /* Can't find the entry in the temp-table, retrieve from the Appserver */

            IF iEntryNumber = 0 OR iEntryNumber = ? 
            THEN DO:
                ASSIGN cInternalEntries = DYNAMIC-FUNCTION("getInternalEntries":U IN phProcedure) NO-ERROR.
                ASSIGN iEntryNumber = LOOKUP(pcProcedureName, cInternalEntries) WHEN cInternalEntries <> ?.
            END.
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
  ACCESS_LEVEL=PUBLIC
  
  Purpose:     To retrieve properties from either the local temp-table or the
               database depending on the setting of the Session Only flag.
  
  Parameters:  
    pcPropertyList - Comma separated list of properties to be retrieved.
    
    plSessionOnly  - Flag indicating how the retrieval should be done. It
                     may have one of the following three values:
                     YES - Retrieve the value from the client session
                     NO  - Retrieve the value from the client session if 
                           available, otherwise retrieve from the server.
                     ?   - Retrieve from the server only.
                     
    RETURNS        - a CHR(3) delimited list of corresponding property values.
  Notes:
   There will always be as many entries in the return value as there are in 
   pcPropertyList. If any of the properties in pcPropertyList do not have a 
   value, the value returned for that value is blank.
  
   If plSessionOnly is set to YES, the value is never retrieved from the
   database. This means that if there is no property value set in the 
   cache, a blank is returned as the value of the property even if a server value
   exists for this property.
   
   If plSessionOnly is set to NO, the cache value will be returned if possible.
   If no cache value exists, the server value is retrieved and returned. If
   no value exists in the server a blank is returned as the value of the property.
   
   If plSessionOnly is set to ? (unknown value), the cache is never checked
   and the value is read from the server. If no server value has been set,
   a blank is returned as the value of the property, even if there is a cache
   value. The cache is never read if plSessionOnly is ?.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntry          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cProperty       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDbPropertyList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDbValues       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturnValues   AS CHARACTER  NO-UNDO.

  DO iLoop = 1 TO NUM-ENTRIES(pcPropertyList):
    ASSIGN 
      cProperty = TRIM(ENTRY(iLoop,pcPropertyList))
      .
    IF plSessionOnly = ? THEN
      ASSIGN
        cDBPropertyList = cDBPropertyList + MIN(cDBPropertyList,",":U)
                        + cProperty
      .
    FIND FIRST ttProperty
         WHERE ttProperty.propertyName = cProperty
         NO-ERROR.
    IF AVAILABLE(ttProperty) THEN
      cReturnValues = cReturnValues + (IF iLoop = 1 THEN "":U ELSE CHR(3))
                    + (IF ttProperty.propertyValue = ? THEN "":U ELSE ttProperty.propertyValue).
    ELSE
    DO:
      IF plSessionOnly <> ? THEN
        ASSIGN
          cDBPropertyList = cDBPropertyList + MIN(cDBPropertyList,",":U)
                          + cProperty
        .
      ASSIGN
        cReturnValues   = cReturnValues + (IF iLoop = 1 THEN "":U ELSE CHR(3))
      .
    END.
  END.  

  
  /* Now read the property values from the database (if applicable) */
  IF 
    &IF DEFINED(server-side) <> 0 &THEN
      (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) AND
    &ELSE 
      (plSessionOnly = NO OR plSessionOnly = ?)  AND
    &ENDIF 
      cDBPropertyList <> "":U THEN  
  DO:
    /* Then update database with all properties if required */
    RUN getScopedContext IN TARGET-PROCEDURE
      (INPUT 0.00,
       cDBPropertyList,
       OUTPUT cDBPropertyList,
       OUTPUT cDBValues).

    DO iLoop = 1 TO NUM-ENTRIES(pcPropertyList):
      cProperty = ENTRY(iLoop,pcPropertyList).
      iEntry = LOOKUP(cProperty,cDBPropertyList).
      IF iEntry > 0 THEN
        ASSIGN
          ENTRY(iLoop,cReturnValues,CHR(3)) = ENTRY(iEntry,cDBValues,CHR(3))
        .
      ELSE IF plSessionOnly = ? THEN
        ASSIGN
          ENTRY(iLoop,cReturnValues,CHR(3)) = "":U
        .
    END.
  END.
  RETURN cReturnValues.   /* Function return value. */

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
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
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
    IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
    DO:
      RUN setScopedContext IN TARGET-PROCEDURE
        (INPUT 0.00,
         pcPropertyList,
         pcPropertyValues) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN RETURN FALSE.
    END.

  &ELSE 
    IF NOT plSessionOnly THEN
    DO:
      RUN setScopedContext IN TARGET-PROCEDURE
        (INPUT 0.00,
         pcPropertyList,
         pcPropertyValues) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN RETURN FALSE.
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
  cFieldName = DYNAMIC-FUNCTION("getFieldName":U IN phWidget) NO-ERROR.
  /* If the function could not be found or the field name is blank - return */
  IF cFieldName = "":U THEN
    RETURN pcFieldSecurity. 

  /* Check if the field is secured - if not - Return */
  ASSIGN iEntry = LOOKUP(cFieldName,pcSecuredFields).
  IF iEntry = 0 THEN
    RETURN pcFieldSecurity. 

  CASE ENTRY(iEntry + 1, pcSecuredFields):
    WHEN "hidden":U THEN
      IF iFieldPos <> 0 THEN
        ENTRY(iFieldPos,pcFieldSecurity) = "Hidden":U NO-ERROR.
    WHEN "Read Only":U THEN
      IF iFieldPos <> 0 THEN
        ENTRY(iFieldPos,pcFieldSecurity) = "ReadOnly":U NO-ERROR.
  END CASE.
  
  RETURN pcFieldSecurity.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

