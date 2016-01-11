&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
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

{src/adm2/action.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

  RUN start-super-proc("adm2/panel.p":U).

  DEFINE VARIABLE hFrame   AS HANDLE NO-UNDO.
  DEFINE VARIABLE hBox     AS HANDLE NO-UNDO.
  DEFINE VARIABLE hLabel   AS HANDLE NO-UNDO.
    
  {set EdgePixels 2}.
  ASSIGN hFrame = FRAME {&FRAME-NAME}:HANDLE
        &IF "{&Box-Rectangle}":U NE "":U &THEN
         hBox   = {&Box-Rectangle}:HANDLE IN FRAME {&FRAME-NAME}
        &ENDIF
        &IF "{&Label}":U NE "":U &THEN
         hLabel = {&Label}:HANDLE IN FRAME {&FRAME-NAME}
        &ENDIF
        .
  {set PanelFrame hFrame}.
  {set BoxRectangle hBox}.
  {set PanelLabel hLabel}.
  
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

  {src/adm2/custom/panelcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


