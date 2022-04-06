&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
/* Procedure Description
"This SmartPanel sends navigation messages 
to its NAVIGATION-TARGET. Its buttons have 
icons and are arranged horizontally."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS P-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: - p-navico.w

  Description: 

        This is the icon version of the navigation SmartPanel.
        It sends navigation events to its NAVIGATION-TARGET(s),
        such as a SmartQuery.

        By default, the icons are arranged so that the records
        the SmartQuery sends (to wherever) are done in a left
        to right fashion; i.e. pressing the leftmost arrow sends
        record 1 and pressing the rightmost arrow sends the last
        record.

        The attribute Right-To-Left reverses the order in which
        the records are sent; i.e. the leftmost button sends the
        last record and the rightmost button sends the first
        record. This attribute is only available on the icon
        version of the navigation SmartPanel, and is provided to
        satisfy Internationalization requirements.


  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
&Scoped-define adm-attribute-dlg adm/support/n-paneld.w
DEFINE VARIABLE first-on-left AS LOGICAL NO-UNDO.

/* The following variable is used whenever the smartpanel is sent an */
/* update state. The smartpanel must know whether it's updating so   */
/* that it can re-set itself properly when the paging mechanism is   */
/* used. Only pnstates.i references this variable.                   */
DEFINE VARIABLE updating      AS LOGICAL INIT FALSE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartPanel

&Scoped-define ADM-SUPPORTED-LINKS  Navigation-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Panel-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn-First Btn-Prev Btn-Next Btn-Last 

/* Custom List Definitions                                              */
/* Box-Rectangle,List-2,List-3,List-4,List-5,List-6                     */
&Scoped-define Box-Rectangle RECT-1 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-First 
     IMAGE-UP FILE "adeicon/first-au":U
     IMAGE-INSENSITIVE FILE "adeicon/first-ai":U
     LABEL "&First":L 
     SIZE 4 BY 1.29 TOOLTIP "First".

DEFINE BUTTON Btn-Last 
     IMAGE-UP FILE "adeicon/last-au":U
     IMAGE-INSENSITIVE FILE "adeicon/last-ai":U
     LABEL "&Last":L 
     SIZE 4 BY 1.29 TOOLTIP "Last".

DEFINE BUTTON Btn-Next 
     IMAGE-UP FILE "adeicon/next-au":U
     IMAGE-INSENSITIVE FILE "adeicon/next-ai":U
     LABEL "&Next":L 
     SIZE 4 BY 1.29 TOOLTIP "Next".

DEFINE BUTTON Btn-Prev 
     IMAGE-UP FILE "adeicon/prev-au":U
     IMAGE-INSENSITIVE FILE "adeicon/prev-ai":U
     LABEL "&Prev":L 
     SIZE 4 BY 1.29 TOOLTIP "Previous".

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 18 BY 1.76.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Panel-Frame
     Btn-First AT ROW 1.29 COL 2
     Btn-Prev AT ROW 1.29 COL 6
     Btn-Next AT ROW 1.29 COL 10
     Btn-Last AT ROW 1.29 COL 14
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartPanel
   Allow: Basic
   Frames: 1
   Add Fields to: NEITHER
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW P-Win ASSIGN
         HEIGHT             = 3.67
         WIDTH              = 33.2.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW P-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME Panel-Frame
   NOT-VISIBLE Size-to-Fit Default                                      */
ASSIGN 
       FRAME Panel-Frame:SCROLLABLE       = FALSE
       FRAME Panel-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME Panel-Frame
   NO-ENABLE 1                                                          */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME Panel-Frame
/* Query rebuild information for FRAME Panel-Frame
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME Panel-Frame */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB P-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/panel.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Btn-First
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-First P-Win
ON CHOOSE OF Btn-First IN FRAME Panel-Frame /* First */
DO:
  RUN notify IN THIS-PROCEDURE (IF first-on-left THEN 'get-first':U
                                                 ELSE 'get-last':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Last
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Last P-Win
ON CHOOSE OF Btn-Last IN FRAME Panel-Frame /* Last */
DO:
  RUN notify IN THIS-PROCEDURE (IF first-on-left THEN 'get-last':U
                                                 ELSE 'get-first':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Next
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Next P-Win
ON CHOOSE OF Btn-Next IN FRAME Panel-Frame /* Next */
DO:
  RUN notify IN THIS-PROCEDURE (IF first-on-left THEN 'get-next':U
                                                 ELSE 'get-prev':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Prev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Prev P-Win
ON CHOOSE OF Btn-Prev IN FRAME Panel-Frame /* Prev */
DO:
  RUN notify IN THIS-PROCEDURE (IF first-on-left THEN 'get-prev':U
                                                 ELSE 'get-next':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK P-Win 


/* ***************************  Main Block  *************************** */

  RUN set-attribute-list ("SmartPanelType=NAV-ICON,
                           Right-To-Left=First-On-Left,
                           Edge-Pixels=2":U).

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI P-Win _DEFAULT-DISABLE
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
  HIDE FRAME Panel-Frame.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable P-Win 
PROCEDURE local-enable :
/*------------------------------------------------------------------------------
  Purpose: The SmartPanel's buttons sensitivities are re-set to whatever
           state they were in when they were disabled. This state is de-
           termined from the variable adm-panel-state.
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch ('enable':U).      /* Get all objects enabled to start. */
  RUN set-buttons (adm-panel-state).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize P-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN get-attribute ('RIGHT-TO-LEFT':U).

  ASSIGN first-on-left = IF RETURN-VALUE = "First-On-Left":U 
      THEN yes /*default*/
      ELSE no.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'adm-initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN get-attribute IN THIS-PROCEDURE ('UIB-MODE':U).
  IF RETURN-VALUE <> 'DESIGN':U THEN DO:
     IF VALID-HANDLE (adm-broker-hdl) THEN DO:
       DEFINE VARIABLE nav-target-link AS CHARACTER NO-UNDO.
       RUN get-link-handle IN adm-broker-hdl
           (INPUT THIS-PROCEDURE, 'NAVIGATION-TARGET':U, OUTPUT nav-target-link).
       IF (nav-target-link EQ "":U)THEN
         /* we have no active navigation target, so disable all the buttons.*/ 
         adm-panel-state = 'disable-all':U.
       ELSE
         /* the default button state of the smartpanel where the first record */
         /* is displayed by the smartquery.                                   */
         adm-panel-state = 'first':U.
       RUN set-buttons (adm-panel-state).
     END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-buttons P-Win 
PROCEDURE set-buttons :
/*------------------------------------------------------------------------------
  Purpose: Sets sensitivity of panel buttons based on record states.    
  Parameters:  character flag with possible values 'first', 'last',
               'enable-all', or 'disable-all'.
  Notes:  This is invoked from the query object (through new-state) or
          from the included state cases in pnstates.i. The panel itself
          does not make decisions to set its buttons sensitive or 
          insensitive because this would duplicate actions taken when
          state messages are received through the query (this puts the
          panel in the right state even if the first/last/next/prev 
          is initiated by some other object).
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER first-last AS CHARACTER NO-UNDO.

DO WITH FRAME Panel-Frame:

  IF first-last = 'disable-all':U THEN DO:
  
    /* all the buttons are disabled, which might happen in the case of */
    /* only a single record available in a table.                      */

&IF LOOKUP("Btn-First":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-First:SENSITIVE = NO.
&ENDIF
      
&IF LOOKUP("Btn-Last":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-Last:SENSITIVE = NO.
&ENDIF

&IF LOOKUP("Btn-Prev":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-Prev:SENSITIVE = NO.
&ENDIF

&IF LOOKUP("Btn-Next":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-Next:SENSITIVE = NO.
&ENDIF    
    
  END. /* first-last = disable-all */

  ELSE IF first-last = 'enable-all':U THEN DO: /* This was a next or prev-enable all */

&IF LOOKUP("Btn-First":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-First:SENSITIVE = YES.
&ENDIF
    
&IF LOOKUP("Btn-Last":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-Last:SENSITIVE = YES.
&ENDIF

&IF LOOKUP("Btn-Prev":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-Prev:SENSITIVE = YES.
&ENDIF

&IF LOOKUP("Btn-Next":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-Next:SENSITIVE = YES.
&ENDIF

  END.

  ELSE IF (first-last = 'first':U AND first-on-left) OR   /* "First" */
          (first-last = 'last':U  AND NOT first-on-left) THEN DO:

&IF LOOKUP("Btn-First":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-First:SENSITIVE = NO.
&ENDIF

&IF LOOKUP("Btn-Prev":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-Prev:SENSITIVE = NO.
&ENDIF

&IF LOOKUP("Btn-Next":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-Next:SENSITIVE = YES.
             &IF "{&WINDOW-SYSTEM}":U = "TTY":U &THEN
             APPLY "ENTRY":U TO Btn-Next.  /* Keep focus in the panel. */
             &ENDIF
&ENDIF

&IF LOOKUP("Btn-Last":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-Last:SENSITIVE = YES.
&ENDIF

  END.

  ELSE DO:                                                 /* "Last" */

&IF LOOKUP("Btn-First":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-First:SENSITIVE = YES.
&ENDIF

&IF LOOKUP("Btn-Prev":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-Prev:SENSITIVE = YES.
             &IF "{&WINDOW-SYSTEM}":U = "TTY":U &THEN
             APPLY "ENTRY":U TO Btn-Prev.  /* Keep focus in the panel. */
             &ENDIF
&ENDIF

&IF LOOKUP("Btn-Next":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-Next:SENSITIVE = NO.
&ENDIF

&IF LOOKUP("Btn-Last":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-Last:SENSITIVE = NO.
&ENDIF

  END.

END.
RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed P-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/pnstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


