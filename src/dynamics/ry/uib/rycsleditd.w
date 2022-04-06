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

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBulder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT        PARAMETER pdContainerSmartObjectObj AS DECIMAL.
DEFINE INPUT-OUTPUT PARAMETER pdSourceObjectInstanceObj AS DECIMAL.
DEFINE INPUT-OUTPUT PARAMETER pdSmartLinkTypeObj        AS DECIMAL.
DEFINE INPUT-OUTPUT PARAMETER pcLinkName                AS CHARACTER.
DEFINE INPUT-OUTPUT PARAMETER pdTargetObjectInstanceObj AS DECIMAL.
DEFINE OUTPUT       PARAMETER plProceed                 AS LOGICAL NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coSource coLink coTarget Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS coSource coLink coTarget FiChar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE coLink AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Link" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "",0
     DROP-DOWN-LIST
     SIZE 31 BY 1.05 NO-UNDO.

DEFINE VARIABLE coSource AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Source" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "",0
     DROP-DOWN-LIST
     SIZE 40 BY 1.05 NO-UNDO.

DEFINE VARIABLE coTarget AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Target" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "",0
     DROP-DOWN-LIST
     SIZE 40 BY 1.05 NO-UNDO.

DEFINE VARIABLE FiChar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     coSource AT ROW 1.24 COL 8 COLON-ALIGNED
     coLink AT ROW 1.24 COL 54 COLON-ALIGNED
     coTarget AT ROW 1.24 COL 93 COLON-ALIGNED
     FiChar AT ROW 2.43 COL 54 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 2.67 COL 104
     Btn_Cancel AT ROW 2.67 COL 120
     SPACE(0.39) SKIP(0.13)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartLink"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


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

/* SETTINGS FOR FILL-IN FiChar IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
ASSIGN 
       FiChar:HIDDEN IN FRAME Dialog-Frame           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* SmartLink */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
    ASSIGN FRAME {&FRAME-NAME} coSource coLink coTarget.

    pdSourceObjectInstanceObj = coSource.
    pdTargetObjectInstanceObj = coTarget.
    pdSmartlinkTypeObj = coLink.
    pcLinkName = ENTRY(-1 + 2 * coLink:LOOKUP(coLink:SCREEN-VALUE), coLink:LIST-ITEM-PAIRS, coLink:DELIMITER).
    plProceed = TRUE.


    MESSAGE  "pcLinkName=" pcLinkName.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN initialize.

  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
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
  DISPLAY coSource coLink coTarget FiChar 
      WITH FRAME Dialog-Frame.
  ENABLE coSource coLink coTarget Btn_OK Btn_Cancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialize Dialog-Frame 
PROCEDURE initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO WITH FRAME {&FRAME-NAME}: END.

    ASSIGN
        coLink:LIST-ITEM-PAIRS   = ",0"
        coSource:LIST-ITEM-PAIRS = ",0"
        coTarget:LIST-ITEM-PAIRS = ",0".
    FOR EACH ryc_smartlink_type:        
        coLink:ADD-FIRST(ryc_smartlink_type.link_name, ryc_smartlink_type.smartlink_type_obj).
    END.


    coSource:ADD-FIRST("THIS-OBJECT",0.0).

    FOR EACH ryc_object_instance NO-LOCK
        WHERE ryc_object_instance.container_smartobject_obj = pdContainerSmartObjectObj,
    FIRST ryc_smartobject NO-LOCK
        WHERE ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj:

        coSource:ADD-FIRST(ryc_smartobject.OBJECT_filename + " " + STRING(ryc_object_instance.OBJECT_instance_obj), ryc_object_instance.OBJECT_instance_obj).
    END.


    coTarget:LIST-ITEM-PAIRS = coSource:LIST-ITEM-PAIRS.

/*     coTarget:DELETE("1"). */
/*     coSource:DELETE("1"). */

    coSource = (IF pdSourceObjectInstanceObj = ? THEN 0 ELSE pdSourceObjectInstanceObj).
    coTarget = (IF pdTargetObjectInstanceObj = ? THEN 0 ELSE pdTargetObjectInstanceObj).
    coLink   = pdSmartLinkTypeObj.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

