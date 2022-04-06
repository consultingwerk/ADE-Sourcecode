&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:  adm2/support/dsender.w

  Description: Edit Instance Properties for a Sender.  

  Created: May 2000  
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBulder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE INPUT PARAMETER phParentHdl AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cDestination lReplyRequired cReplySelector ~
RECT-3 
&Scoped-Define DISPLAYED-OBJECTS cDestination lReplyRequired cReplySelector 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initReplySelector Dialog-Frame 
FUNCTION initReplySelector RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE cDestination AS CHARACTER FORMAT "X(256)":U 
     LABEL "Destination" 
     VIEW-AS FILL-IN 
     SIZE 33 BY 1 NO-UNDO.

DEFINE VARIABLE cReplySelector AS CHARACTER FORMAT "X(256)":U 
     LABEL "Reply Selector" 
     VIEW-AS FILL-IN 
     SIZE 33 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 52 BY 4.29.

DEFINE VARIABLE lReplyRequired AS LOGICAL INITIAL no 
     LABEL "Reply Required" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     cDestination AT ROW 1.62 COL 17 COLON-ALIGNED
     lReplyRequired AT ROW 2.95 COL 19
     cReplySelector AT ROW 4.14 COL 17 COLON-ALIGNED
     RECT-3 AT ROW 1.24 COL 2
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartSender Instance Properties".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* SmartSender Instance Properties */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lReplyRequired
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lReplyRequired Dialog-Frame
ON VALUE-CHANGED OF lReplyRequired IN FRAME Dialog-Frame /* Reply Required */
DO:
  ASSIGN lReplyRequired.
  initReplySelector().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Define Context ID's for HELP files */
{ src/adm2/support/admhlp.i }    

 /* Attach the standard OK/Cancel/Help button bar. */
 { adecomm/okbar.i  &TOOL = "AB"
                    &CONTEXT = {&SmartSender_Instance_Properties_Dialog_Box} }



/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN readProperties.
  RUN enable_UI.
  initReplySelector().
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  RUN storeProperties.

END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY cDestination lReplyRequired cReplySelector 
      WITH FRAME Dialog-Frame.
  ENABLE cDestination lReplyRequired cReplySelector RECT-3 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readProperties Dialog-Frame 
PROCEDURE readProperties :
/*------------------------------------------------------------------------------
  Purpose:    Read instanceProperties   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN 
    cDestination   = DYNAMIC-FUNCTION('getDestination' IN phParentHdl)  
    lReplyRequired = DYNAMIC-FUNCTION('getReplyRequired' IN phParentHdl)  
    cReplySelector = DYNAMIC-FUNCTION('getReplySelector' IN phParentHdl).  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE storeProperties Dialog-Frame 
PROCEDURE storeProperties :
/*------------------------------------------------------------------------------
  Purpose: Store the Instance Properties in the Smart Instance.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN FRAME {&FRAME-NAME}
    cDestination
    lReplyRequired
    cReplySelector.

  DYNAMIC-FUNCTION('setDestination' IN phParentHdl, cDestination).
  DYNAMIC-FUNCTION('setReplyRequired' IN phParentHdl,lReplyRequired).  
  DYNAMIC-FUNCTION('setReplySelector' IN phParentHdl, cReplySelector).  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initReplySelector Dialog-Frame 
FUNCTION initReplySelector RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Set the ReplySelector sensitivity  
    Notes:  
------------------------------------------------------------------------------*/
  cReplySelector:READ-ONLY IN FRAME {&FRAME-NAME} = NOT lReplyRequired.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

