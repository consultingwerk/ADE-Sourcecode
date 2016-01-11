&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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
/*------------------------------------------------------------------------

  File: afdbdeplsw.w

  Description: ICF Deployment packaging start window

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: December 2000

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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{af/sup/afproducts.i}

{rtb/inc/afrtbglobs.i} /* pull in Roundtable global variables */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coWorkspace coSite coDeployment buOK ~
buCancel 
&Scoped-Define DISPLAYED-OBJECTS coWorkspace coSite coDeployment 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buCancel AUTO-END-KEY DEFAULT 
     LABEL "&Exit" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buOK DEFAULT 
     LABEL "&Continue..." 
     SIZE 15 BY 1.14 TOOLTIP "Run deployment packaging for selection"
     BGCOLOR 8 .

DEFINE VARIABLE coDeployment AS INTEGER FORMAT ">>>>>9":U INITIAL 1 
     LABEL "Deployment" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     LIST-ITEMS "1" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 TOOLTIP "Select specific deployment package to update"
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE coSite AS CHARACTER FORMAT "X(256)":U 
     LABEL "Site" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 40.4 BY 1 TOOLTIP "Select site to create deployment data for"
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE coWorkspace AS CHARACTER FORMAT "X(256)":U 
     LABEL "Workspace" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 40.4 BY 1 TOOLTIP "Select Workspace from which to deploy"
     BGCOLOR 15  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     coWorkspace AT ROW 1.67 COL 3.6
     coSite AT ROW 3.19 COL 11
     coDeployment AT ROW 4.71 COL 3.4
     buOK AT ROW 6.05 COL 25
     buCancel AT ROW 6.05 COL 41.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 58 BY 6.52
         DEFAULT-BUTTON buOK CANCEL-BUTTON buCancel.


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
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Dynamics -  Deployment Packaging"
         HEIGHT             = 6.52
         WIDTH              = 58
         MAX-HEIGHT         = 35.67
         MAX-WIDTH          = 204.8
         VIRTUAL-HEIGHT     = 35.67
         VIRTUAL-WIDTH      = 204.8
         RESIZE             = yes
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
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* SETTINGS FOR COMBO-BOX coDeployment IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX coSite IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX coWorkspace IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* ICF -  Deployment Packaging */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* ICF -  Deployment Packaging */
DO:

    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel C-Win
ON CHOOSE OF buCancel IN FRAME DEFAULT-FRAME /* Exit */
DO:

    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOK C-Win
ON CHOOSE OF buOK IN FRAME DEFAULT-FRAME /* Continue... */
DO:

    DEFINE VARIABLE cSiteRecid    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cDeployRecid  AS CHARACTER    NO-UNDO.

    ASSIGN
        coWorkspace
        coDeployment
        coSite
        .

    FIND FIRST rtb_site NO-LOCK
         WHERE rtb_site.site-code = coSite
         NO-ERROR.
    IF NOT AVAILABLE rtb_site THEN
    DO:
      MESSAGE "Invalid site - cannot continue with deployment packaging".
      RETURN NO-APPLY.
    END.
    ELSE    
      ASSIGN cSiteRecid = STRING(RECID(rtb_site)).

    FIND FIRST rtb_deploy NO-LOCK
         WHERE rtb_deploy.wspace-id = coWorkspace
           AND rtb_deploy.site-code = coSite
           AND rtb_deploy.deploy-sequence = coDeployment
         NO-ERROR.         
    IF NOT AVAILABLE rtb_deploy THEN
    DO:
      MESSAGE "Invalid deployment package - cannot continue".
      RETURN NO-APPLY.
    END.
    ELSE    
      ASSIGN cDeployRecid = STRING(RECID(rtb_deploy)).

    ASSIGN
        {&WINDOW-NAME}:HIDDEN = TRUE
        FRAME {&FRAME-NAME}:HIDDEN = TRUE.

    RUN af/cod/afrtbdepsw.w  (INPUT cSiteRecid
                             ,INPUT cDeployRecid).

    APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coSite
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coSite C-Win
ON VALUE-CHANGED OF coSite IN FRAME DEFAULT-FRAME /* Site */
DO:
  RUN buildCoDeployment.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coWorkspace
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coWorkspace C-Win
ON VALUE-CHANGED OF coWorkspace IN FRAME DEFAULT-FRAME /* Workspace */
DO:
  RUN buildCoSite.
  APPLY "VALUE-CHANGED" TO coSite.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN
    CURRENT-WINDOW                = {&WINDOW-NAME} 
    THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

RUN mainSetup.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.

    IF NOT THIS-PROCEDURE:PERSISTENT
    THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildCoDeployment C-Win 
PROCEDURE buildCoDeployment :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN 
          coWorkspace
          coSite
          coDeployment:LIST-ITEMS = "":U
          .

        FOR EACH rtb_deploy NO-LOCK
           WHERE rtb_deploy.wspace-id = coWorkspace
           AND rtb_deploy.site-code = coSite
            BY rtb_deploy.deploy-sequence DESCENDING:

            coDeployment:ADD-LAST(STRING(rtb_deploy.deploy-sequence)).

        END.

        IF  coDeployment:LIST-ITEMS <> "":U
        AND coDeployment:LIST-ITEMS <> ? 
        THEN
            ASSIGN
                coDeployment:SCREEN-VALUE = ENTRY(1,coDeployment:LIST-ITEMS)
                .

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildCoSite C-Win 
PROCEDURE buildCoSite :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN 
          coWorkspace
          coSite:LIST-ITEMS = "":U
          .

        FOR EACH rtb_site NO-LOCK
           WHERE rtb_site.wspace-id = coWorkspace,
           FIRST gsm_site NO-LOCK
           WHERE gsm_site.site_code = rtb_site.site-code
              BY gsm_site.site_code:

            coSite:ADD-LAST(LC(gsm_site.site_code)).

        END.

        IF  coSite:LIST-ITEMS <> "":U
        AND coSite:LIST-ITEMS <> ? 
        THEN
            ASSIGN
                coSite:SCREEN-VALUE = ENTRY(1,coSite:LIST-ITEMS)
                .

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildCoWorkspace C-Win 
PROCEDURE buildCoWorkspace :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN 
            coWorkspace:LIST-ITEMS = "":U
            .

        FOR EACH rtb_wspace NO-LOCK
              BY rtb_wspace.wspace-id
            :
            coWorkspace:ADD-LAST(LC(rtb_wspace.wspace-id)).

        END.

        IF  coWorkspace:LIST-ITEMS <> "":U
        AND coWorkspace:LIST-ITEMS <> ? 
        THEN
            ASSIGN
                coWorkspace:SCREEN-VALUE = ENTRY(1,coWorkspace:LIST-ITEMS)
                .

        /* Default to current workdpace if any */
        IF Grtb-wspace-id <> "":U AND Grtb-wspace-id <> ? THEN
          ASSIGN
            coWorkspace:SCREEN-VALUE = Grtb-wspace-id NO-ERROR.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY coWorkspace coSite coDeployment 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE coWorkspace coSite coDeployment buOK buCancel 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mainSetup C-Win 
PROCEDURE mainSetup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:

      ASSIGN
          {&WINDOW-NAME}:TITLE = "Launch Dynamics Deployment Packaging":U
          .

      RUN buildcoWorkspace.

      APPLY "VALUE-CHANGED" TO coWorkspace.
      IF  coDeployment:LIST-ITEMS <> "":U
      AND coDeployment:LIST-ITEMS <> ? 
      THEN
      DO:
          ASSIGN
              coDeployment = INTEGER(ENTRY(1,coDeployment:LIST-ITEMS))
              .
          DISPLAY coDeployment.
      END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

