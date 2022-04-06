&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    Library     : panel.i - Basic include file for V9 SmartPanels
    Purpose     :

    Modified    : September 3, 1998
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass panel
&ENDIF

&IF "{&ADMClass}":U = "panel":U &THEN
  {src/adm2/panlprop.i}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 8
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

{src/adm2/toolbar.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  IF NOT {&ADM-LOAD-FROM-REPOSITORY} THEN
    RUN start-super-proc("adm2/panel.p":U).
&ENDIF

  DEFINE VARIABLE hFrame   AS HANDLE NO-UNDO.
  DEFINE VARIABLE hBox     AS HANDLE NO-UNDO.
  DEFINE VARIABLE hLabel   AS HANDLE NO-UNDO.
    
    ASSIGN hFrame = FRAME {&FRAME-NAME}:HANDLE
        &IF "{&Box-Rectangle}":U NE "":U &THEN
         hBox   = {&Box-Rectangle}:HANDLE IN FRAME {&FRAME-NAME}
        &ENDIF
        &IF "{&Label}":U NE "":U &THEN
         hLabel = {&Label}:HANDLE IN FRAME {&FRAME-NAME}
        &ENDIF
        .
    
 &SCOPED-DEFINE xp-assign
  {set EdgePixels 2}
  {set PanelFrame hFrame}
  {set BoxRectangle hBox}
  {set PanelLabel hLabel}
  .
  &UNDEFINE xp-assign
  
/* Automatically count the buttons. Note that sizing does not work except
   on SCROLLABLE frames (when dynamic resizing makes the panel smaller), 
   so set the frame to be scrollable.  */
  RUN countButtons NO-ERROR.
  FRAME {&FRAME-NAME}:SCROLLABLE = yes.

  /* Give the SmartPanel Frame a special PRIVATE-DATA value to identify it,
     so that code can determine whether a button which has been pressed is
     in a SmartPanel (brsleave.i, for example). */
  IF hFrame:PRIVATE-DATA = "":U OR hFrame:PRIVATE-DATA = ? THEN
      hFrame:PRIVATE-DATA = "ADM-PANEL":U.
  ELSE hFrame:PRIVATE-DATA =   /* There might be something else in it.*/
      hFrame:PRIVATE-DATA + ",ADM-PANEL":U.

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
    {src/adm2/custom/panelcustom.i}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


