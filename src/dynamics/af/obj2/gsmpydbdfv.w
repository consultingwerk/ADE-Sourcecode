&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sObject _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*---------------------------------------------------------------------------------
  File: gsmpydbdfv.w

  Description:  Database Connection Parameters SDF

  Purpose:      Accepts the connection parameters to a database

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000027   UserRef:    
                Date:   10/05/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rysttdatfv.w

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

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

&scop object-name       gsmpydbdfv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE gcString    AS CHARACTER    NO-UNDO.


/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataField yes

{af/sup2/afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataField
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiDBName coNetwork fiHost fiService toSSL ~
toSessionReuse toHostVerify EdEditor 
&Scoped-Define DISPLAYED-OBJECTS fiDBName coNetwork fiHost fiService toSSL ~
toSessionReuse toHostVerify EdEditor 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataValue sObject 
FUNCTION getDataValue RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataValue sObject 
FUNCTION setDataValue RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE coNetwork AS CHARACTER FORMAT "X(256)":U INITIAL "<none>" 
     LABEL "Network Type (-N)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "<none>","<none>",
                     "TCP","TCP"
     DROP-DOWN-LIST
     SIZE 18.4 BY 1 NO-UNDO.

DEFINE VARIABLE EdEditor AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 104.4 BY 6.38 NO-UNDO.

DEFINE VARIABLE fiDBName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Physical Database Name (-db)" 
     VIEW-AS FILL-IN 
     SIZE 73.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiHost AS CHARACTER FORMAT "X(256)":U 
     LABEL "Host (-H)" 
     VIEW-AS FILL-IN 
     SIZE 73.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiService AS CHARACTER FORMAT "X(256)":U 
     LABEL "Service (-S)" 
     VIEW-AS FILL-IN 
     SIZE 73.6 BY 1 NO-UNDO.

DEFINE VARIABLE toHostVerify AS LOGICAL INITIAL NO 
     LABEL "Host verification disabled (-nohostverify)" 
     VIEW-AS TOGGLE-BOX
     SIZE 46.4 BY .81 NO-UNDO.

DEFINE VARIABLE toSessionReuse AS LOGICAL INITIAL NO 
     LABEL "Session reuse disabled (-nosessionreuse)" 
     VIEW-AS TOGGLE-BOX
     SIZE 46.4 BY .81 NO-UNDO.

DEFINE VARIABLE toSSL AS LOGICAL INITIAL NO 
     LABEL "SSL enabled (-ssl)" 
     VIEW-AS TOGGLE-BOX
     SIZE 46.4 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiDBName AT ROW 2.05 COL 30.2 COLON-ALIGNED
     coNetwork AT ROW 3.1 COL 30.2 COLON-ALIGNED
     fiHost AT ROW 4.19 COL 30.2 COLON-ALIGNED
     fiService AT ROW 5.29 COL 30.2 COLON-ALIGNED
     toSSL AT ROW 6.48 COL 28.2
     toSessionReuse AT ROW 7.29 COL 28.2
     toHostVerify AT ROW 8.1 COL 28.2
     EdEditor AT ROW 9.14 COL 1.4 NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataField
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 17.57
         WIDTH              = 106.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/field.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

ASSIGN 
       EdEditor:RETURN-INSERTED IN FRAME frMain  = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME fiDBName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiDBName sObject
ON VALUE-CHANGED OF fiDBName IN FRAME frMain /* Physical Database Name (-db) */
,coNetwork,fiHost,fiService,EdEditor
DO:
  {set DataModified TRUE}.

  IF coNetwork:SCREEN-VALUE = "TCP":U THEN
     ASSIGN toSSL:SENSITIVE           = TRUE.
  ELSE
     ASSIGN toSSL:CHECKED             = FALSE
            toSSL:SENSITIVE           = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toHostVerify
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toHostVerify sObject
ON VALUE-CHANGED OF toHostVerify IN FRAME frMain /* Host verification disabled (-nohostverify) */
DO:
  {set DataModified TRUE}.
  IF toHostVerify:CHECKED THEN 
      EdEditor:SCREEN-VALUE = IF EdEditor:SCREEN-VALUE = "":U THEN '-nohostverify':U 
                              ELSE EdEditor:SCREEN-VALUE + ' -nohostverify':U.
  ELSE
      EdEditor:SCREEN-VALUE = TRIM(REPLACE(EdEditor:SCREEN-VALUE, '-nohostverify':U, '':U)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toSessionReuse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toSessionReuse sObject
ON VALUE-CHANGED OF toSessionReuse IN FRAME frMain /* Session reuse disabled (-nosessionreuse) */
DO:
  {set DataModified TRUE}.
  IF toSessionReuse:CHECKED THEN 
      EdEditor:SCREEN-VALUE = IF EdEditor:SCREEN-VALUE = "":U THEN '-nosessionreuse':U 
                              ELSE EdEditor:SCREEN-VALUE + ' -nosessionreuse':U.
  ELSE
      EdEditor:SCREEN-VALUE = TRIM(REPLACE(EdEditor:SCREEN-VALUE, '-nosessionreuse':U, '':U)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toSSL
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toSSL sObject
ON VALUE-CHANGED OF toSSL IN FRAME frMain /* SSL enabled (-ssl) */
DO:
  {set DataModified TRUE}.
  IF toSSL:CHECKED THEN 
  DO:
      EdEditor:SCREEN-VALUE = IF EdEditor:SCREEN-VALUE = "":U THEN '-ssl':U
                              ELSE EdEditor:SCREEN-VALUE + ' -ssl':U.
      ASSIGN toSessionReuse:SENSITIVE = TRUE
             toHostVerify:SENSITIVE   = TRUE.
  END.
  ELSE DO:
      ASSIGN toSessionReuse:CHECKED   = FALSE
             toHostVerify:CHECKED     = FALSE
             toSessionReuse:SENSITIVE = FALSE
             toHostVerify:SENSITIVE   = FALSE.
      EdEditor:SCREEN-VALUE = TRIM(REPLACE(EdEditor:SCREEN-VALUE, '-ssl':U, '':U)).
      EdEditor:SCREEN-VALUE = TRIM(REPLACE(EdEditor:SCREEN-VALUE, '-nosessionreuse':U, '':U)).
      EdEditor:SCREEN-VALUE = TRIM(REPLACE(EdEditor:SCREEN-VALUE, '-nohostverify':U, '':U)).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableField sObject 
PROCEDURE disableField :
/*------------------------------------------------------------------------------
  Purpose:   Disable the field   
  Parameters:  <none>
  Notes:    SmartDataField:disableFields will call this for all Objects of type
            PROCEDURE that it encounters in the EnableFields Property.  
            The developer must add logic to disable the actual SmartField.    
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN
      fiDBName:SENSITIVE  = FALSE
      coNetwork:SENSITIVE = FALSE
      fiHost:SENSITIVE    = FALSE
      fiService:SENSITIVE = FALSE
      edEditor:SENSITIVE  = FALSE
      toSSL:SENSITIVE          = FALSE
      toSessionReuse:SENSITIVE = FALSE
      toHostVerify:SENSITIVE   = FALSE
      .

  END.

  {set FieldEnabled FALSE}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableField sObject 
PROCEDURE enableField :
/*------------------------------------------------------------------------------
  Purpose:   Enable the field   
  Parameters:  <none>
  Notes:    SmartDataField:enableFields will call this for all Objects of type
            PROCEDURE that it encounters in the EnableFields Property.  
            The developer must add logic to enable the SmartField.    
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN
      fiDBName:SENSITIVE  = TRUE
      coNetwork:SENSITIVE = TRUE
      fiHost:SENSITIVE    = TRUE
      fiService:SENSITIVE = TRUE
      edEditor:SENSITIVE  = TRUE
      .
    IF coNetwork:SCREEN-VALUE = "TCP":U THEN
      ASSIGN toSSL:SENSITIVE          = TRUE.
    IF toSSL:CHECKED THEN
      ASSIGN
        toSessionReuse:SENSITIVE = TRUE
        toHostVerify:SENSITIVE   = TRUE
        .

  END.
   {set FieldEnabled TRUE}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableObject sObject 
PROCEDURE enableObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  RUN SUPER.

  /* sets screen-value to <none> for network type if it has not value */
  DO WITH FRAME {&FRAME-NAME}:
    IF coNetwork:SCREEN-VALUE = ? THEN
      coNetwork:SCREEN-VALUE = '<none>':U.
  END.  /* do with frame */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hContainerSource    AS HANDLE       NO-UNDO.

  hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U).
  /* subscribe to validateField in the viewer */
  SUBSCRIBE TO 'validateField':U IN hContainerSource.

  RUN SUPER.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      toSSL:SENSITIVE          = FALSE
      toSessionReuse:SENSITIVE = FALSE
      toHostVerify:SENSITIVE   = FALSE
      .
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE parseValue sObject 
PROCEDURE parseValue :
/*------------------------------------------------------------------------------
  Purpose:     This procedure parses the connection string to display the 
               connection data in appropriate fields.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcValue AS CHARACTER NO-UNDO.

DEFINE VARIABLE cList          AS CHARACTER  INIT '-D,-N,-H,-S'  NO-UNDO.
DEFINE VARIABLE cString        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iAdditional    AS INTEGER      NO-UNDO.
DEFINE VARIABLE iPosition      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iStorePosition AS INTEGER    NO-UNDO.
DEFINE VARIABLE iNext          AS INTEGER      NO-UNDO.
DEFINE VARIABLE iNum           AS INTEGER      NO-UNDO.
DEFINE VARIABLE iSpace         AS INTEGER      NO-UNDO.

ASSIGN pcValue = ' ':U + pcValue.

DO WITH FRAME {&FRAME-NAME}:
    DO iNum = 1 TO NUM-ENTRIES(cList):
        ASSIGN iPosition = INDEX(pcValue, ENTRY(iNum, cList)).

        IF iPosition > 0 
        THEN DO:
            iSpace = INDEX(pcValue, ' ':U, iPosition + 1).
            iNext = INDEX(pcValue, ' -':U, iPosition + 1).
            IF iNum = NUM-ENTRIES(cList) THEN
                iAdditional = iNext.
            IF iNext = 0 THEN iNext = -1.
            ELSE iNext = (iNext - 1) - iSpace.
            ASSIGN cString = TRIM(SUBSTRING(pcValue, iSpace + 1, iNext)).

            CASE ENTRY(iNum, cList):
                WHEN '-D':U THEN fiDBName:SCREEN-VALUE = cString.
                WHEN '-N':U THEN coNetwork:SCREEN-VALUE = cString.
                WHEN '-H':U THEN fiHost:SCREEN-VALUE = cString.
                WHEN '-S':U THEN fiService:SCREEN-VALUE = cString.
           END CASE.

           ASSIGN iStorePosition = iPosition.
        END.  /* option found */
        ELSE
            IF iNum = NUM-ENTRIES(cList) THEN
                ASSIGN iAdditional = INDEX(pcValue, ' -':U, iStorePosition + 1).
    END.  /* do while */

    IF iAdditional > 0 THEN
        ASSIGN edEditor:SCREEN-VALUE = TRIM(SUBSTRING(pcValue, iAdditional)).
    IF coNetwork:SCREEN-VALUE = ? THEN
        ASSIGN coNetwork:SCREEN-VALUE = '<none>':U.
    iPosition = INDEX(pcValue, '-ssl':U).
    IF iPosition > 0 THEN toSSL:CHECKED = TRUE.
    iPosition = INDEX(pcValue, '-nosessionreuse':U).
    IF iPosition > 0 THEN toSessionReuse:CHECKED = TRUE.
    iPosition = INDEX(pcValue, '-nohostverify':U).
    IF iPosition > 0 THEN toHostVerify:CHECKED = TRUE.
END.  /* do with frame */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateField sObject 
PROCEDURE validateField :
/*------------------------------------------------------------------------------
  Purpose:     Checks whether data has been entered for certain fields based on 
               the chosen option and returns the appropriate list of error numbers.
  Parameters:  OUTPUT pcError AS CHARACTER
  Notes:       validateField is published from updateRecord of the Physical
               Service SmartDataViewer (gsmpyviewv.w).
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcError AS CHARACTER NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    IF fiDBName:SCREEN-VALUE = '':U THEN 
      pcError = '129':U.

    IF (coNetwork:SCREEN-VALUE NE '<none>':U OR
      fiHost:SCREEN-VALUE NE '':U OR
      fiService:SCREEN-VALUE NE '':U) AND
      (coNetwork:SCREEN-VALUE = '<none>':U OR
      fiHost:SCREEN-VALUE = '':U OR
      fiService:SCREEN-VALUE = '':U )THEN
        pcError = pcError + (IF NUM-ENTRIES(pcError) > 0 THEN ',':U ELSE '':U) + '130':U.
  END.  /* do with frame */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataValue sObject 
FUNCTION getDataValue RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current value of the SmartDataField object.
   Params:  none
    Notes:  This function must be defined by the developer of the object
            to return its value.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cConnectString  AS CHARACTER    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    cConnectString = '-db ' + fiDBName:SCREEN-VALUE.     
    IF coNetwork:SCREEN-VALUE NE '<none>':U THEN 
      cConnectString = cConnectString + ' -N ':U + coNetwork:SCREEN-VALUE.
    IF fiHost:SCREEN-VALUE NE '':U THEN
      cConnectString = cConnectString + ' -H ':U + fiHost:SCREEN-VALUE.
    IF fiService:SCREEN-VALUE NE '':U THEN
      cConnectString = cConnectString + ' -S ':U + fiService:SCREEN-VALUE.
    cConnectString = cConnectString + ' ':U + edEditor:SCREEN-VALUE. 
  END.  /* do with frame */

  RETURN cConnectString.  
   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataValue sObject 
FUNCTION setDataValue RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function receives the value for the SmartDataField and assigns it.
   Params:  The parameter and its datatype must be defined by the developer.
    Notes:  
------------------------------------------------------------------------------*/

  RUN parseValue (INPUT pcValue).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

