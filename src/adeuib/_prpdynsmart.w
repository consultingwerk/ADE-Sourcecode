&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
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
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

&IF DEFINED(UIB_is_Running) NE 0 &THEN
DEFINE VARIABLE phSelf AS WIDGET               NO-UNDO.
&ELSE    
DEFINE INPUT PARAMETER phSelf AS WIDGET               NO-UNDO.
&ENDIF

/*{adecomm/adestds.i} */            /* Standards for "Sullivan Look"            */
{adeuib/uniwidg.i}              /* Universal widget definition              */
/*{adeuib/brwscols.i}*/             /* Definition of _BC records                */
/*{adeuib/triggers.i}*/             /* Trigger Temp-table definition            */
{adeuib/uibhlp.i}               /* Help pre-processor directives            */
{adeuib/sharvars.i}             /* The shared variables                     */
{src/adm2/globals.i}            /* Global vars for Dynamics */
/*{adecomm/icondir.i}*/
/** Contains definitions for dynamics design-time temp-tables. **/
{destdefi.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnLookup btnClear cSuper BtnOK BtnCancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOpenObjectFilter Dialog-Frame 
FUNCTION getOpenObjectFilter RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON btnClear 
     IMAGE-UP FILE "adeicon/cancel.bmp":U
     LABEL "Clear" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1.14 TOOLTIP "Clear custom super procedure".

DEFINE BUTTON btnLookup 
     IMAGE-UP FILE "adeicon/browse-u.bmp":U
     LABEL "Lookup" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1.14 TOOLTIP "Lookup custom super procedure".

DEFINE BUTTON BtnOK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE cObject AS CHARACTER FORMAT "X(50)":U 
     LABEL "Object" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 64 BY 1 NO-UNDO.

DEFINE VARIABLE cSuper AS CHARACTER FORMAT "X(50)":U 
     LABEL "Custom super proc" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 53.6 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     cObject AT ROW 1.14 COL 20.2 COLON-ALIGNED
     btnLookup AT ROW 2.24 COL 76.2
     btnClear AT ROW 2.24 COL 81.4
     cSuper AT ROW 2.29 COL 20.2 COLON-ALIGNED
     BtnOK AT ROW 4.33 COL 3.4
     BtnCancel AT ROW 4.33 COL 19.2
     SPACE(53.39) SKIP(0.52)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Property sheet"
         DEFAULT-BUTTON BtnOK CANCEL-BUTTON BtnCancel.


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
   FRAME-NAME                                                           */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN cObject IN FRAME Dialog-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN cSuper IN FRAME Dialog-Frame
   NO-DISPLAY                                                           */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Property sheet */
DO:
  RUN saveData.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Property sheet */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnClear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnClear Dialog-Frame
ON CHOOSE OF btnClear IN FRAME Dialog-Frame /* Clear */
DO:
  RUN clearCustomSuper.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnLookup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnLookup Dialog-Frame
ON CHOOSE OF btnLookup IN FRAME Dialog-Frame /* Lookup */
DO:
  RUN selectCustomSuper.
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
  RUN initializeObject. 
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignCustomSuper Dialog-Frame 
PROCEDURE assignCustomSuper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:   This is duplicated in several prp* procedures.
           The DataView for which this was intended has no _U 'browse', but the 
           procedure is kind of a generic.  
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcSuper AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cSearch AS CHARACTER  NO-UNDO.

DEFINE BUFFER B_U FOR _U.
DEFINE BUFFER B_C FOR _C. 
DEFINE BUFFER X_U FOR _U. 
DEFINE BUFFER X_C FOR _C. 

   FIND B_U WHERE RECID(B_U) = _P._u-recid.
   FIND B_C WHERE RECID(B_C) = B_U._x-recid.

   FIND X_U WHERE X_U._parent-recid = RECID(_U) AND
       X_U._TYPE = "BROWSE":U NO-ERROR.
   IF AVAILABLE X_U THEN
     FIND X_C WHERE RECID(X_C) = X_U._x-recid NO-ERROR.
   cSearch = SEARCH(pcSuper) NO-ERROR.
   IF cSearch > "" THEN
   DO:
      ASSIGN B_C._CUSTOM-SUPER-PROC = pcSuper
              _C._CUSTOM-SUPER-PROC = pcSuper.
      IF AVAILABLE X_C THEN 
         X_C._CUSTOM-SUPER-PROC = pcSuper.
   END.
   ELSE DO:
      ASSIGN B_C._CUSTOM-SUPER-PROC = ?
             _C._CUSTOM-SUPER-PROC = ?.
      IF AVAILABLE X_C THEN 
        X_C._CUSTOM-SUPER-PROC = ?.
   END.
END PROCEDURE. /* assignCustomSuper */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearCustomSuper Dialog-Frame 
PROCEDURE clearCustomSuper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  cSuper = ''.
  DISPLAY cSuper WITH FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayObject Dialog-Frame 
PROCEDURE displayObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    cObject = IF _P._SAVE-AS-FILE eq ? THEN "Untitled"
              ELSE _P._SAVE-AS-FILE.
    DISPLAY cSuper
            cObject WITH FRAME {&FRAME-NAME}.
    FRAME {&FRAME-NAME}:TITLE = FRAME {&FRAME-NAME}:TITLE 
                                + ' - ':U
                                + cObject.
  END.
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
  ENABLE btnLookup btnClear cSuper BtnOK BtnCancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchCustomSuper Dialog-Frame 
PROCEDURE fetchCustomSuper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE OUTPUT PARAMETER pcCustomSuper AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hDesManager AS HANDLE     NO-UNDO.
 IF _C._CUSTOM-SUPER-PROC = ""  THEN
 DO:  
   hDesManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
   /* Retrieve the object for the current existing object opened in the appBuilder */
   RUN retrieveDesignObject IN hDesManager ( INPUT  _P.object_filename,
                                             INPUT  "",  /* Get default result Code */
                                             OUTPUT TABLE ttObject ,
                                             OUTPUT TABLE ttPage,
                                             OUTPUT TABLE ttLink,
                                             OUTPUT TABLE ttUiEvent,
                                             OUTPUT TABLE ttObjectAttribute ) NO-ERROR.  
   FIND FIRST ttObject WHERE ttObject.tLogicalObjectname       = _P.object_filename 
                       AND ttObject.tContainerSmartObjectObj = 0 NO-ERROR.
   IF AVAIL ttObject THEN
     pcCustomSuper =  ttObject.tCustomSuperprocedure.
 END. /* CUSTOM SUPER PROCEDURE */
 ELSE IF _C._CUSTOM-SUPER-PROC <> ? THEN
   RUN adecomm/_relname.p (_C._CUSTOM-SUPER-PROC, "",OUTPUT pcCustomSuper).
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Dialog-Frame 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE BUFFER b_U FOR _U. 
  /* Create necessary widgets and initialize with current data                */
 
 FIND _U WHERE _U._HANDLE = phSelf.
 FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE.
 FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
 IF NOT AVAILABLE _F THEN DO:
   FIND _C WHERE RECID(_C) = _U._x-recid.
   IF _C._q-recid NE ? THEN FIND _Q WHERE RECID(_Q) = _C._q-recid NO-ERROR.
 END.

 /* Find _C of Window  */
 FIND b_U WHERE b_U._HANDLE = _h_win.
 FIND _C WHERE RECID(_C)  = b_U._x-recid.
 RUN fetchCustomSuper (OUTPUT cSuper).
 RUN displayObject. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveData Dialog-Frame 
PROCEDURE saveData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN assignCustomSuper(cSuper:INPUT-VALUE IN FRAME {&FRAME-NAME}).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectCustomSuper Dialog-Frame 
PROCEDURE selectCustomSuper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /* gopendialog uses this ........ sorry  */
   CURRENT-WINDOW:PRIVATE-DATA = STRING(THIS-PROCEDURE). 
   RUN adeuib/_openreposfile.p
      (CURRENT-WINDOW,'Procedure':U,"":U,No,"Get Object",OUTPUT cSuper).
   DISPLAY cSuper WITH FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOpenObjectFilter Dialog-Frame 
FUNCTION getOpenObjectFilter RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN "Procedure":U.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

