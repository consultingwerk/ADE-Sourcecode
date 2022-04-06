&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
/* Procedure Description
"ADM2 SmartSender Template.

Use this template to create your own SmartSender object.  When completed this object can be dropped onto any 'smart' container such as a SmartWindow, Simple SmartContainer, SmartFrame or SmartDialog."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS smsObject 
/*------------------------------------------------------------------------

  File:

  Description: Template for msghandler class

  Author:
  Created: 05/11/2000

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

&SCOPED-DEFINE adm-property-dlg adm2/support/senderd.w
&SCOPED-DEFINE xcInstanceProperties Destination,ReplyRequired,ReplySelector

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartSender
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS OutMessage-Source


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartSender Template
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
  CREATE WINDOW smsObject ASSIGN
         HEIGHT             = 2.43
         WIDTH              = 44.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB smsObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/msghandler.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW smsObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK smsObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI smsObject  _DEFAULT-DISABLE
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
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveReplyHandler smsObject 
PROCEDURE receiveReplyHandler :
/*------------------------------------------------------------------------------
  Purpose:     This procedure handles the processing of a reply to a message 
               being received.  
  Parameters:  phMessage AS HANDLE - handle to the reply message
  Notes:       This procedure processes the incoming reply to a message 
               that has been sent using the handle of the message with the 
               Sonic Adapter API.
               Code in the procedure can get properties of the message 
               (including a Correlation ID) and can get the body of the message.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phMessage AS HANDLE NO-UNDO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendErrorHandler smsObject 
PROCEDURE sendErrorHandler :
/*------------------------------------------------------------------------------
  Purpose:    Handle error messages if sendMessage encounters an error.   
  Parameters: pcMessages - CHR(3) separated string with error messages   
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcMessages AS CHAR NO-UNDO.

  DEFINE VARIABLE cMsgText AS CHAR NO-UNDO.
  DEFINE VARIABLE iMsg     AS INT  NO-UNDO.

  DO iMsg = 1 TO NUM-ENTRIES(pcMessages, CHR(3)):
    cMsgText = cMsgText + 
      RIGHT-TRIM(ENTRY(iMsg, pcMessages, CHR(3)), CHR(4)) + "~n":U.
  END.  /* do iMsg */
  IF cMsgText NE "":U THEN
    MESSAGE cMsgText VIEW-AS ALERT-BOX ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendHandler smsObject 
PROCEDURE sendHandler :
/*------------------------------------------------------------------------------
  Purpose:     This procedure handles the preparation of a message being sent
  Parameters:  phMessage AS HANDLE - handle to the message
  Notes:       This procedure prepares the message to be sent using the 
               handle of the message with the Sonic Adapter API.
               Code in the procedure can set properties in the message and
               set the body of the message.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phMessage AS HANDLE NO-UNDO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

