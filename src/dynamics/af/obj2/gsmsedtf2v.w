&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
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
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gsmsedtf2v.w

  Description:  Session Type Valid OS List SDF

  Purpose:      Static SmartDataField to maintain the session type valid OS list

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000026   UserRef:    posse
                Date:   17/04/2001  Author:     Tammy St Pierre

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

&scop object-name       gsmsedtf2v.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

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
&Scoped-Define ENABLED-OBJECTS ToBoxWin32 ToBoxUnix ToBoxAll 
&Scoped-Define DISPLAYED-OBJECTS ToBoxWin32 ToBoxUnix ToBoxAll 

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
DEFINE VARIABLE ToBoxAll AS LOGICAL INITIAL no 
     LABEL "All" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.4 BY .81 NO-UNDO.

DEFINE VARIABLE ToBoxUnix AS LOGICAL INITIAL no 
     LABEL "UNIX (Any Progress supported UNIX)" 
     VIEW-AS TOGGLE-BOX
     SIZE 41.2 BY .81 NO-UNDO.

DEFINE VARIABLE ToBoxWin32 AS LOGICAL INITIAL no 
     LABEL "WIN32 (Win95,98,ME,NTor Win2000)" 
     VIEW-AS TOGGLE-BOX
     SIZE 41.2 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     ToBoxWin32 AT ROW 1.1 COL 5.6
     ToBoxUnix AT ROW 1.91 COL 5.6
     ToBoxAll AT ROW 2.71 COL 5.6
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
         HEIGHT             = 2.76
         WIDTH              = 53.6.
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
       ToBoxAll:PRIVATE-DATA IN FRAME frMain     = 
                "ALL".

ASSIGN 
       ToBoxUnix:PRIVATE-DATA IN FRAME frMain     = 
                "UNIX".

ASSIGN 
       ToBoxWin32:PRIVATE-DATA IN FRAME frMain     = 
                "WIN32".

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

&Scoped-define SELF-NAME ToBoxAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToBoxAll sObject
ON VALUE-CHANGED OF ToBoxAll IN FRAME frMain /* All */
DO:
  {set DataModified TRUE}.
  IF SELF:CHECKED THEN
    ASSIGN 
      ToBoxWin32:CHECKED = FALSE
      ToBoxUnix:CHECKED = FALSE
    .
  ELSE 
    ASSIGN
      ToBoxWin32:CHECKED = TRUE
      ToBoxUnix:CHECKED = TRUE
    .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToBoxWin32
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToBoxWin32 sObject
ON VALUE-CHANGED OF ToBoxWin32 IN FRAME frMain /* WIN32 (Win95,98,ME,NTor Win2000) */
,ToBoxUnix
DO:
  {set DataModified TRUE}.
  IF SELF:CHECKED THEN
    ASSIGN ToBoxAll:CHECKED = FALSE.
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
    ToBoxWin32:SENSITIVE = FALSE
    ToBoxUnix:SENSITIVE  = FALSE
    ToBoxAll:SENSITIVE   = FALSE
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
    ToBoxWin32:SENSITIVE = TRUE
    ToBoxUnix:SENSITIVE  = TRUE
    ToBoxAll:SENSITIVE   = TRUE
    .

END.

{set FieldEnabled TRUE}.

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
DEFINE VARIABLE cSetValue   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hFrameField AS HANDLE       NO-UNDO.

  ASSIGN 
    hFrameField = FRAME {&FRAME-NAME}:HANDLE
    hFrameField = hFrameField:FIRST-CHILD
    hFrameField = hFrameField:FIRST-CHILD.

  DO WHILE VALID-HANDLE(hFrameField):
    IF hFrameField:CHECKED THEN 
      ASSIGN cSetValue = cSetValue + (IF cSetValue <> '':U THEN ',':U ELSE '':U) + hFrameField:PRIVATE-DATA.
    hFrameField = hFrameField:NEXT-SIBLING.
  END.  /* do while valid frame field */

  IF cSetValue = 'All':U THEN RETURN '':U.
  ELSE RETURN cSetValue.

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
DEFINE VARIABLE hFrameField AS HANDLE       NO-UNDO.

  ASSIGN 
    hFrameField = FRAME {&FRAME-NAME}:HANDLE
    hFrameField = hFrameField:FIRST-CHILD
    hFrameField = hFrameField:FIRST-CHILD.

  DO WHILE VALID-HANDLE(hFrameField):
    IF pcValue = '':U THEN DO:
      IF hFramefield:PRIVATE-DATA = 'ALL':U THEN 
        ASSIGN hFrameField:CHECKED = TRUE.
      ELSE ASSIGN hFrameField:CHECKED = FALSE.
    END.
    ELSE DO:
      IF LOOKUP(hFrameField:PRIVATE-DATA, pcValue) > 0 THEN
        ASSIGN hFrameField:CHECKED = TRUE.
      ELSE ASSIGN hFrameField:CHECKED = FALSE.
    END.  /* else do */
    hFrameField = hFrameField:NEXT-SIBLING.
  END.  /* do while valid frame field */

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

