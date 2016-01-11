&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wiMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" wiMain _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" wiMain _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" wiMain _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wiMain 
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
  File: aftemlognw.w

  Description:  Astra 2 Login Window (no db connection)

  Purpose:      Astra 2 Login Window (no db connection)

  Parameters:   input mode "One" = 1st login, "Two" = Re-login / change details
                output user object number
                output user login name
                output user full name
                output user email
                output organisation object number
                output organisation code
                output organisation name
                output organisation short name
                output process date
                output language object number
                output language name
                output Other values as list label,value,label,value

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   29/05/2000  Author:     Anthony Swindells

  Update Notes: Write Astra2 Toolbar

  (v:010001)    Task:        6010   UserRef:    
                Date:   12/06/2000  Author:     Anthony Swindells

  Update Notes: Astra 2 Login Window

  (v:010002)    Task:        6120   UserRef:    
                Date:   22/06/2000  Author:     Anthony Swindells

  Update Notes: Reduce Appserver Requests in Managers / login

  (v:010003)    Task:        6145   UserRef:    
                Date:   25/06/2000  Author:     Anthony Swindells

  Update Notes: Code container toolbar actions

  (v:010004)    Task:        6998   UserRef:    
                Date:   01/11/2000  Author:     Jenny Bond

  Update Notes: Implement calendar on login window

  (v:010005)    Task:        7405   UserRef:    
                Date:   28/12/2000  Author:     Anthony Swindells

  Update Notes: Astra 2 translations

  (v:010006)    Task:        7506   UserRef:    
                Date:   08/01/2001  Author:     Anthony Swindells

  Update Notes: translation issues

------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER pcMode                      AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pdCurrentUserObj            AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentUserLogin          AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentUserName           AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentUserEmail          AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pdCurrentOrganisationObj    AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentOrganisationCode   AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentOrganisationName   AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentOrganisationShort  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER ptCurrentProcessDate        AS DATE       NO-UNDO.
DEFINE OUTPUT PARAMETER pdCurrentLanguageObj        AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentLanguageName       AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentLoginValues        AS CHARACTER  NO-UNDO.

{af/sup2/afglobals.i}

DEFINE VARIABLE cAction                         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lError                          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lAbort                          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cDateFormat                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFileName                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iPasswordMaxRetries             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iMultiUserCheckEnabled          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cUserObj                        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dUserObj                        AS DECIMAL INITIAL 0 NO-UNDO.
DEFINE VARIABLE cFailedReason                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOldPassword                    AS CHARACTER  NO-UNDO.

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       aftemlognw.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

{af/app/afttsecurityctrl.i}
{af/app/afttglobalctrl.i}
DEFINE TEMP-TABLE ttUser NO-UNDO LIKE gsm_user.
{af/sup2/afttcombo.i}

{af/app/aftttranslate.i}

DEFINE TEMP-TABLE ttSavedLabels NO-UNDO LIKE ttTranslate.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiLoginName fiPassword coLanguage coCompany ~
fiDate buCalc buOk buCancel imCompany imLogo 
&Scoped-Define DISPLAYED-OBJECTS fiLoginName fiPassword coLanguage ~
coCompany fiDate 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wiMain AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buCalc 
     LABEL "..." 
     SIZE 2.8 BY .81
     BGCOLOR 8 .

DEFINE BUTTON buCancel 
     LABEL "&Cancel" 
     SIZE 15.4 BY 1.14 TOOLTIP "Abort login"
     BGCOLOR 8 .

DEFINE BUTTON buOk 
     LABEL "&OK" 
     SIZE 15.4 BY 1.14 TOOLTIP "Login to application"
     BGCOLOR 8 .

DEFINE BUTTON buPassword 
     LABEL "&Password" 
     SIZE 15.4 BY 1.14 TOOLTIP "Change user password"
     BGCOLOR 8 .

DEFINE VARIABLE coCompany AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Company" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "",0
     DROP-DOWN-LIST
     SIZE 42 BY 1 NO-UNDO.

DEFINE VARIABLE coLanguage AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Language" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "",0
     DROP-DOWN-LIST
     SIZE 42 BY 1 NO-UNDO.

DEFINE VARIABLE fiDate AS DATE FORMAT "99/99/9999":U 
     LABEL "Processing Date" 
     VIEW-AS FILL-IN 
     SIZE 18.8 BY 1 TOOLTIP "The date to use for processing transactions, etc." NO-UNDO.

DEFINE VARIABLE fiLoginName AS CHARACTER FORMAT "X(25)":U 
     LABEL "Login Name" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1 TOOLTIP "User login name for authentication" NO-UNDO.

DEFINE VARIABLE fiPassword AS CHARACTER FORMAT "X(25)":U 
     LABEL "Password" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1 TOOLTIP "User password - (case sesnsitive)" NO-UNDO.

DEFINE IMAGE imCompany
     FILENAME "adeicon/login.bmp":U
     SIZE 14.4 BY 4.76.

DEFINE IMAGE imLogo
     FILENAME "adeicon/icfdev.ico":U TRANSPARENT
     SIZE 8.8 BY 1.76.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiLoginName AT ROW 1.14 COL 31.4 COLON-ALIGNED
     fiPassword AT ROW 2.19 COL 31.4 COLON-ALIGNED BLANK 
     coLanguage AT ROW 3.24 COL 31.4 COLON-ALIGNED
     coCompany AT ROW 4.38 COL 31.4 COLON-ALIGNED
     fiDate AT ROW 5.48 COL 31.4 COLON-ALIGNED
     buCalc AT ROW 5.57 COL 49
     buOk AT ROW 1.14 COL 77.4
     buCancel AT ROW 2.33 COL 77.4
     buPassword AT ROW 3.62 COL 77.4
     imCompany AT ROW 1.19 COL 1.8
     imLogo AT ROW 5.1 COL 82.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 94.2 BY 6.33
         DEFAULT-BUTTON buOk CANCEL-BUTTON buCancel.


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
  CREATE WINDOW wiMain ASSIGN
         HIDDEN             = YES
         TITLE              = "Application Login"
         COLUMN             = 34.6
         ROW                = 13.1
         HEIGHT             = 6.33
         WIDTH              = 94.2
         MAX-HEIGHT         = 6.33
         MAX-WIDTH          = 94.2
         VIRTUAL-HEIGHT     = 6.33
         VIRTUAL-WIDTH      = 94.2
         MIN-BUTTON         = no
         MAX-BUTTON         = no
         TOP-ONLY           = yes
         RESIZE             = no
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
/* SETTINGS FOR WINDOW wiMain
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE L-To-R,COLUMNS                                           */
/* SETTINGS FOR BUTTON buPassword IN FRAME frMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiMain)
THEN wiMain:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wiMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiMain wiMain
ON END-ERROR OF wiMain /* Application Login */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiMain wiMain
ON WINDOW-CLOSE OF wiMain /* Application Login */
DO:
  ASSIGN cAction = "cancel":U.
  APPLY "GO":U TO FRAME {&FRAME-NAME}.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCalc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCalc wiMain
ON CHOOSE OF buCalc IN FRAME frMain /* ... */
DO:
    RUN af/cod2/afcalnpopd.w (INPUT fiDate:HANDLE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel wiMain
ON CHOOSE OF buCancel IN FRAME frMain /* Cancel */
DO:
    ASSIGN cAction = "cancel":U.
    APPLY "GO":U TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOk wiMain
ON CHOOSE OF buOk IN FRAME frMain /* OK */
DO:
    ASSIGN cAction = "ok":U.
    APPLY "GO":U TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buPassword
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buPassword wiMain
ON CHOOSE OF buPassword IN FRAME frMain /* Password */
DO:
    RUN changePassword.
    APPLY "ENTRY":U TO fiLoginName IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coLanguage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coLanguage wiMain
ON VALUE-CHANGED OF coLanguage IN FRAME frMain /* Language */
DO:
  RUN doTranslation.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiDate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiDate wiMain
ON F4 OF fiDate IN FRAME frMain /* Processing Date */
DO:
    APPLY "choose":u TO buCalc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiLoginName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiLoginName wiMain
ON LEAVE OF fiLoginName IN FRAME frMain /* Login Name */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    IF fiLoginName:SCREEN-VALUE <> fiLoginName THEN
    DO:
      ASSIGN
          fiLoginName
          .

      /* get user details for login name specified */
      EMPTY TEMP-TABLE ttUser.
      IF fiLoginName <> "":U THEN
        RUN af/app/afgetuserp.p ON gshAstraAppserver (INPUT 0, INPUT fiLoginName, OUTPUT TABLE ttUser).
      FIND FIRST ttUser NO-ERROR.

      /* set combo defaults to match user defaults */
      IF AVAILABLE ttUser THEN
      DO:
        IF ttUser.LANGUAGE_obj <> 0 THEN
          coLanguage:SCREEN-VALUE = STRING(ttUser.LANGUAGE_obj) NO-ERROR. 
        IF ttUser.default_login_company_obj <> 0 THEN
          coCompany:SCREEN-VALUE = STRING(ttUser.default_login_company_obj) NO-ERROR. 
      END.

      ERROR-STATUS:ERROR = NO.
    END.

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME imLogo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL imLogo wiMain
ON MOUSE-SELECT-DBLCLICK OF imLogo IN FRAME frMain
DO:
  RCODE-INFO:FILE-NAME = THIS-PROCEDURE:FILE-NAME.
  MESSAGE "Databases Referenced = " RCODE-INFO:DB-REFERENCES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wiMain 


/* ***************************  Main Block  *************************** */

/* RTB issues with global triggers ? */
ON LEAVE ANYWHERE DO:
END.

IF THIS-PROCEDURE:PERSISTENT THEN
  DO:
    MESSAGE "The login window should not be run persistently"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN ERROR.
  END.


/* Check session compatibility with client */
DEFINE VARIABLE cNumericDecimalPoint   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cNumericSeparator      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cNumericFormat         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cSessionDateFormat     AS CHARACTER    NO-UNDO.

RUN af/app/afgetsesnp.p ON gshAstraAppserver (OUTPUT cNumericDecimalPoint,
                                              OUTPUT cNumericSeparator,
                                              OUTPUT cNumericFormat,
                                              OUTPUT cSessionDateFormat).

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Always centre the login window in the session as we can not yet get where
   the user prefers to have the login window as we do not know who the user is
   yet!
*/

CURRENT-WINDOW:X = (SESSION:WIDTH-PIXELS - CURRENT-WINDOW:WIDTH-PIXELS) / 2 NO-ERROR.
CURRENT-WINDOW:Y = (SESSION:HEIGHT-PIXELS - CURRENT-WINDOW:HEIGHT-PIXELS) / 2 NO-ERROR.   

/* See if customised logo's exist / get global control defaults */          
IF NOT CAN-FIND(FIRST ttSecurityControl) OR
   NOT CAN-FIND(FIRST ttGlobalControl) THEN
DO:
  RUN af/app/afgetgansp.p ON gshAstraAppserver (OUTPUT TABLE ttGlobalControl,
                                                OUTPUT TABLE ttSecurityControl).
  FIND FIRST ttGlobalControl NO-ERROR.
  FIND FIRST ttSecurityControl NO-ERROR.
END.

/* load icons if set-up in database */

ASSIGN
    cFileName = IF  AVAILABLE ttSecurityControl AND ttSecurityControl.company_logo_filename <> "":U THEN
                    ttSecurityControl.company_logo_filename ELSE "":U
  .

IF cFileName <> "":U AND SEARCH(cFileName) <> ? THEN
    IF imCompany:LOAD-IMAGE(cFileName ) THEN 
  PROCESS EVENTS.

ASSIGN
    cFileName = IF  AVAILABLE ttSecurityControl AND ttSecurityControl.product_logo_filename <> "":U THEN
                    ttSecurityControl.product_logo_filename ELSE ""
  .
IF cFileName <> "":U AND SEARCH(cFileName) <> ? THEN
    IF imLogo:LOAD-IMAGE(cFileName ) THEN PROCESS EVENTS.


/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.
RUN enable_UI.

{af/sup2/aficonload.i}

RUN populateCombos.
RUN buildTranslations.

APPLY "value-changed":U TO coLanguage IN FRAME {&FRAME-NAME}.

cDateFormat = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                   INPUT "dateFormat":U,
                                                   INPUT NO).

IF AVAILABLE ttSecurityControl THEN
    ASSIGN
        iPasswordMaxRetries = ttSecurityControl.password_max_retries
        iMultiUserCheckEnabled = ttSecurityControl.multi_user_check.
ELSE
    ASSIGN
        iPasswordMaxRetries = 0
        iMultiUserCheckEnabled = NO.

VIEW wiMain.
wiMain:SENSITIVE = YES.
VIEW FRAME {&FRAME-NAME}.
FRAME {&FRAME-NAME}:SENSITIVE = YES.

/* Check if already logged in */
cUserObj = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                   INPUT "currentUserObj":U,
                                                   INPUT NO).
ASSIGN dUserObj = DECIMAL(cUserObj) NO-ERROR.

IF dUserObj <> 0 THEN
  ENABLE buPassword
     WITH FRAME frMain IN WINDOW wiMain.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
REPEAT WHILE TRUE:

  DO WITH FRAME {&FRAME-NAME}:
    IF fiDate = ? THEN ASSIGN fiDate = DATE(STRING(TODAY, cDateFormat)).
    DISPLAY fiDate.
  END.

  /* ensure password field is empty */
  fiPassword:SCREEN-VALUE = "":U.

/*   APPLY "ENTRY":U TO fiLoginName IN FRAME {&FRAME-NAME}. */
  SESSION:SET-WAIT-STATE('':U).

  IF cNumericDecimalPoint <> SESSION:NUMERIC-DECIMAL-POINT OR
     cNumericSeparator <> SESSION:NUMERIC-SEPARATOR OR
     cNumericFormat <> SESSION:NUMERIC-FORMAT OR
     cSessionDateFormat <> SESSION:DATE-FORMAT THEN
  DO:
    DEFINE VARIABLE cAbort AS CHARACTER NO-UNDO.      
    RUN showMessages IN gshSessionManager (INPUT "Cannot Login - Your session settings do not match the server settings:" + CHR(10) + 
                                                 "Server Numeric Decimal Point = " + cNumericDecimalPoint + CHR(10) +
                                                 "Server Numeric Separator     = " + cNumericSeparator + CHR(10) +
                                                 "Server Numeric Format        = " + cNumericFormat + CHR(10) +
                                                 "Server Date Format           = " + cSessionDateFormat + CHR(10) + CHR(10) +
                                                 "Client Numeric Decimal Point = " + SESSION:NUMERIC-DECIMAL-POINT + CHR(10) +
                                                 "Client Numeric Separator     = " + SESSION:NUMERIC-SEPARATOR + CHR(10) +
                                                 "Client Numeric Format        = " + SESSION:NUMERIC-FORMAT + CHR(10) +
                                                 "Client Date Format           = " + SESSION:DATE-FORMAT,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Incompatible Session Settings",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cAbort).
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN ERROR.
  END.

  WAIT-FOR GO OF FRAME {&FRAME-NAME} FOCUS fiLoginName.

  /* check action and act accordingly */
  IF cAction = "OK":U THEN
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        fiDate
        fiLoginName
        fiPassword
        coLanguage
        coCompany
        cFailedReason = "":U
        .

    ASSIGN
      pdCurrentOrganisationObj = IF coCompany <> ? THEN coCompany ELSE 0
      ptCurrentProcessDate     = fiDate
      pdCurrentLanguageObj     = IF coLanguage <> ? THEN coLanguage ELSE 0
      pcCurrentLoginValues     = "":U
      pcCurrentUserLogin       = fiLoginName
      .

    RUN checkUser IN gshSecurityManager (INPUT fiLoginName,
                                         INPUT IF fiPassword <> "":U THEN ENCODE(fiPassword) ELSE "":U,
                                         INPUT coCompany,
                                         INPUT coLanguage,
                                         OUTPUT pdCurrentUserObj,
                                         OUTPUT pcCurrentUserName,
                                         OUTPUT pcCurrentUserEmail,
                                         OUTPUT pcCurrentOrganisationCode,
                                         OUTPUT pcCurrentOrganisationName,
                                         OUTPUT pcCurrentOrganisationShort,
                                         OUTPUT pcCurrentLanguageName,
                                         OUTPUT cFailedReason).

    IF cFailedReason = "expired":U THEN
    DO: /* force change of password */
      CURRENT-WINDOW:SENSITIVE = FALSE.
      RUN af/cod2/aftemcpasw.w (INPUT  fiLoginName,
                                INPUT  pdCurrentUserObj,
                                INPUT  IF fiPassword <> "":U THEN ENCODE(fiPassword) ELSE "":U,
                                INPUT  YES,           /* expired flag */
                                INPUT  coLanguage,
                                OUTPUT cFailedReason).
      CURRENT-WINDOW:SENSITIVE = TRUE.
      IF cFailedReason <> "":U THEN NEXT main-block.
    END.
    ELSE IF cFailedReason <> "":U THEN
    DO:
      DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.      
      RUN showMessages IN gshSessionManager (INPUT cFailedReason,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "User Authentication Failure",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      NEXT main-block.      
    END.
  END.  /* action = ok */
  ELSE
  DO:
    ASSIGN
      pdCurrentUserObj  = 0
      pcCurrentUserLogin = "":U
      pcCurrentUserName = "":U
      pcCurrentUserEmail = "":U
      pdCurrentOrganisationObj = 0
      pcCurrentOrganisationCode = "":U
      pcCurrentOrganisationName = "":U
      pcCurrentOrganisationShort = "":U
      pdCurrentLanguageObj = 0
      pcCurrentLanguageName = "":U
      ptCurrentProcessDate = TODAY
      pcCurrentLoginValues = "":U
      .
  END.

  LEAVE MAIN-BLOCK.

END.  /* repeat while true */

ASSIGN
    wiMain:HIDDEN = TRUE
    FRAME {&FRAME-NAME}:HIDDEN = TRUE.

APPLY "CLOSE":U TO THIS-PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildTranslations wiMain 
PROCEDURE buildTranslations :
/*------------------------------------------------------------------------------
  Purpose:     Build the temp-table of widgets to translate
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ttSavedLabels.
EMPTY TEMP-TABLE ttTranslate.

IF AVAILABLE ttSecurityControl AND ttSecurityControl.translation_enabled = NO THEN
  RETURN.

RUN buildWidgetTable IN gshTranslationManager (INPUT THIS-PROCEDURE:FILE-NAME,
                                               INPUT 0,
                                               INPUT CURRENT-WINDOW,
                                               INPUT FRAME {&FRAME-NAME}:HANDLE,
                                               OUTPUT TABLE ttTranslate).
/* save original translations */
FOR EACH ttTranslate:
  CREATE ttSavedLabels.
  BUFFER-COPY ttTranslate TO ttSavedLabels
    ASSIGN
      ttSavedLabels.dlanguageObj = 0
      ttSavedLabels.clanguageName = "":U
      .

END.

/* Do translations */
IF CAN-FIND(FIRST ttTranslate) THEN
  RUN multiTranslation IN gshTranslationManager (INPUT YES,   /* All languages */
                                                 INPUT-OUTPUT TABLE ttTranslate).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changePassword wiMain 
PROCEDURE changePassword :
/*------------------------------------------------------------------------------
  Purpose:     Action for change password button.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFailed                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAnswer                 AS CHARACTER  NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

  ASSIGN
    fiLoginName
    fiPassword
    coLanguage
    .

  CURRENT-WINDOW:SENSITIVE = FALSE.
  RUN af/cod2/aftemcpasw.w (INPUT  fiLoginName,
                            INPUT  pdCurrentUserObj,
                            INPUT  IF fiPassword <> "":U THEN ENCODE(fiPassword) ELSE "":U,
                            INPUT  NO,           /* expired flag */
                            INPUT  coLanguage,
                            OUTPUT cFailed).
  CURRENT-WINDOW:SENSITIVE = TRUE.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wiMain  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiMain)
  THEN DELETE WIDGET wiMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doTranslation wiMain 
PROCEDURE doTranslation :
/*------------------------------------------------------------------------------
  Purpose:     Translate widgets in temp-table
  Parameters:  <none>
  Notes:       Temp table will be empty if translations disabled.
               Called from value change of language.
------------------------------------------------------------------------------*/

IF CAN-FIND(FIRST ttTranslate) THEN
DO WITH FRAME {&FRAME-NAME}:

  DEFINE VARIABLE cRadioButtons AS CHARACTER NO-UNDO.
  ASSIGN
    coLanguage.

  FOR EACH ttTranslate
     WHERE ttTranslate.dLanguageObj = coLanguage:

    FIND FIRST ttSavedLabels
         WHERE ttSavedLabels.dLanguageObj = 0
           AND ttSavedLabels.cObjectName = ttTranslate.cObjectName
           AND ttSavedLabels.lGlobal = ttTranslate.lGlobal
           AND ttSavedLabels.cWidgetType = ttTranslate.cWidgetType
           AND ttSavedLabels.cWidgetName = ttTranslate.cWidgetName
           AND ttSavedLabels.hWidgetHandle = ttTranslate.hWidgetHandle
           AND ttSavedLabels.iWidgetEntry = ttTranslate.iWidgetEntry
         NO-ERROR.

    CASE ttTranslate.cWidgetType:
      WHEN "TITLE":U THEN
      DO:
        IF LENGTH(ttTranslate.cTranslatedLabel) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
          ttTranslate.hWidgetHandle:TITLE = ttTranslate.cTranslatedLabel.
        ELSE IF AVAILABLE ttSavedLabels AND LENGTH(ttSavedLabels.cOriginalLabel) > 0 THEN
          ttTranslate.hWidgetHandle:TITLE = ttSavedLabels.cOriginalLabel.
      END.
      WHEN "RADIO-SET":U THEN
      DO:
        IF LENGTH(ttTranslate.cTranslatedLabel) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
        DO:
          ASSIGN cRadioButtons = ttTranslate.hWidgetHandle:RADIO-BUTTONS.
          ENTRY(ttTranslate.iWidgetEntry, cRadioButtons) = ttTranslate.cTranslatedLabel.
          ASSIGN ttTranslate.hWidgetHandle:RADIO-BUTTONS = cRadioButtons.
        END.
        ELSE IF AVAILABLE ttSavedLabels AND LENGTH(ttSavedLabels.cOriginalLabel) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
        DO:
          ASSIGN cRadioButtons = ttTranslate.hWidgetHandle:RADIO-BUTTONS.
          ENTRY(ttTranslate.iWidgetEntry, cRadioButtons) = ttSavedLabels.cOriginalLabel.
          ASSIGN ttTranslate.hWidgetHandle:RADIO-BUTTONS = cRadioButtons.
        END.

        IF LENGTH(ttTranslate.cTranslatedTooltip) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
          ASSIGN
            ttTranslate.hWidgetHandle:TOOLTIP = ttTranslate.cTranslatedTooltip.
        ELSE IF AVAILABLE ttSavedLabels AND LENGTH(ttSavedLabels.cOriginalTooltip) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
          ASSIGN
            ttTranslate.hWidgetHandle:TOOLTIP = ttSavedLabels.cOriginalTooltip.
      END.
      WHEN "TEXT":U THEN
      DO:
        IF LENGTH(ttTranslate.cTranslatedLabel) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
        DO:
          ASSIGN
            ttTranslate.hWidgetHandle:SCREEN-VALUE = ttTranslate.cTranslatedLabel.
        END.
        ELSE IF AVAILABLE ttSavedLabels AND LENGTH(ttSavedLabels.cOriginalLabel) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
        DO:
          ASSIGN
            ttTranslate.hWidgetHandle:SCREEN-VALUE = ttSavedLabels.cOriginalLabel.
        END.

        IF LENGTH(ttTranslate.cTranslatedTooltip) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
          ASSIGN
            ttTranslate.hWidgetHandle:TOOLTIP = ttTranslate.cTranslatedTooltip.
        ELSE IF AVAILABLE ttSavedLabels AND LENGTH(ttSavedLabels.cOriginalTooltip) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
          ASSIGN
            ttTranslate.hWidgetHandle:TOOLTIP = ttSavedLabels.cOriginalTooltip.
      END.
      OTHERWISE
      DO:
        IF LENGTH(ttTranslate.cTranslatedLabel) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
        DO:
          IF NOT CAN-QUERY(ttTranslate.hWidgetHandle,"LABELS":U) OR
             (CAN-QUERY(ttTranslate.hWidgetHandle,"LABELS":U) AND ttTranslate.hWidgetHandle:LABELS) THEN
            ASSIGN
              ttTranslate.hWidgetHandle:LABEL = ttTranslate.cTranslatedLabel.
        END.
        ELSE IF AVAILABLE ttSavedLabels AND LENGTH(ttSavedLabels.cOriginalLabel) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
        DO:
          IF NOT CAN-QUERY(ttTranslate.hWidgetHandle,"LABELS":U) OR
             (CAN-QUERY(ttTranslate.hWidgetHandle,"LABELS":U) AND ttTranslate.hWidgetHandle:LABELS) THEN
            ASSIGN
              ttTranslate.hWidgetHandle:LABEL = ttSavedLabels.cOriginalLabel.
        END.

        IF LENGTH(ttTranslate.cTranslatedTooltip) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
          ASSIGN
            ttTranslate.hWidgetHandle:TOOLTIP = ttTranslate.cTranslatedTooltip.
        ELSE IF AVAILABLE ttSavedLabels AND LENGTH(ttSavedLabels.cOriginalTooltip) > 0 AND VALID-HANDLE(ttTranslate.hWidgetHandle) THEN
          ASSIGN
            ttTranslate.hWidgetHandle:TOOLTIP = ttSavedLabels.cOriginalTooltip.
      END.
    END CASE.

    IF VALID-HANDLE(ttTranslate.hWidgetHandle) AND CAN-QUERY(ttTranslate.hWidgetHandle,"MODIFIED":U) THEN
    ASSIGN ttTranslate.hWidgetHandle:MODIFIED = FALSE.

  END. /* FOR EACH ttTranslate */

END. /* do with frame */

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wiMain  _DEFAULT-ENABLE
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
  DISPLAY fiLoginName fiPassword coLanguage coCompany fiDate 
      WITH FRAME frMain IN WINDOW wiMain.
  ENABLE fiLoginName fiPassword coLanguage coCompany fiDate buCalc buOk 
         buCancel imCompany imLogo 
      WITH FRAME frMain IN WINDOW wiMain.
  {&OPEN-BROWSERS-IN-QUERY-frMain}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateCombos wiMain 
PROCEDURE populateCombos :
/*------------------------------------------------------------------------------
  Purpose:     To build company combo for companies with a business type of "COM"
               short for "login company", plus languages combo.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:

 IF SESSION:NUMERIC-DECIMAL-POINT = ",":U THEN
  ASSIGN
    coLanguage:DELIMITER = CHR(3)
    coCompany:DELIMITER = CHR(3)
    .



  EMPTY TEMP-TABLE ttComboData.
  CREATE ttComboData.
  ASSIGN
    ttComboData.cWidgetName = "coLanguage":U
    ttComboData.hWidget = coLanguage:HANDLE
    ttComboData.cForEach = "FOR EACH gsc_language NO-LOCK BY gsc_language.language_name":U
    ttComboData.cBufferList = "gsc_language":U
    ttComboData.cKeyFieldName = "gsc_language.language_obj":U
    ttComboData.cDescFieldNames = "gsc_language.language_name":U
    ttComboData.cDescSubstitute = "&1":U
    ttComboData.cFlag = "N":U
    ttComboData.cCurrentKeyValue = "":U
    ttComboData.cListItemDelimiter = coLanguage:DELIMITER
    ttComboData.cListItemPairs = "":U
    ttComboData.cCurrentDescValue = "":U
    .

  CREATE ttComboData.
  ASSIGN
    ttComboData.cWidgetName = "coCompany":U
    ttComboData.hWidget = coCompany:HANDLE
    ttComboData.cForEach = "FOR EACH gsm_login_company NO-LOCK BY gsm_login_company.login_company_name":U 
    ttComboData.cBufferList = "gsm_login_company":U
    ttComboData.cKeyFieldName = "gsm_login_company.login_company_obj":U
    ttComboData.cDescFieldNames = "gsm_login_company.login_company_name,gsm_login_company.login_company_code":U
    ttComboData.cDescSubstitute = "&1 (&2)":U
    ttComboData.cFlag = "N":U
    ttComboData.cCurrentKeyValue = "":U
    ttComboData.cListItemDelimiter = coCompany:DELIMITER
    ttComboData.cListItemPairs = "":U
    ttComboData.cCurrentDescValue = "":U
    .

  /* build combo list-item pairs */
  RUN af/app/afcobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).

  /* and set-up combos */
  FIND FIRST ttComboData WHERE ttComboData.cWidgetName = "coLanguage":U.
  coLanguage:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.
  IF AVAILABLE ttGlobalControl THEN 
    coLanguage:SCREEN-VALUE = STRING(ttGlobalControl.DEFAULT_language_obj) NO-ERROR.
  IF coLanguage:SCREEN-VALUE = "0":U OR coLanguage:SCREEN-VALUE = ? THEN
    ASSIGN coLanguage:SCREEN-VALUE = "0":U NO-ERROR.

  FIND FIRST ttComboData WHERE ttComboData.cWidgetName = "coCompany":U.
  coCompany:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.
  coCompany:SCREEN-VALUE = "0":U.

END. /* {&FRAME-NAME} */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

