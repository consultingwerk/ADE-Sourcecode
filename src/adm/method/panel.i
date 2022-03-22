&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-------------------------------------------------------------------------
    Library     : panel.i  
    Purpose     : Base ADM methods for button bar objects
  
    Syntax      : {src/adm/method/panel.i}

    Description :
  
    Author(s)   :
    Created     :
    HISTORY: 
-----------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE VARIABLE adm-panel-state AS CHARACTER NO-UNDO.

&IF DEFINED (adm-panel) = 0 &THEN
&GLOBAL adm-panel yes
/* Dialog program to run to set runtime attributes - if not defined in master */

/* +++ This is the list of attributes whose values are to be returned
   by get-attribute-list, that is, those whose values are part of the
   definition of the object instance and should be passed to init-object
   by the UIB-generated code in adm-create-objects. */
&IF DEFINED(adm-attribute-list) = 0 &THEN
&SCOP adm-attribute-list Edge-Pixels,SmartPanelType,AddFunction,Right-to-Left
&ENDIF

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 6.88
         WIDTH              = 66.
                                                                        */
&ANALYZE-RESUME
 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

{src/adm/method/smart.i}
{src/adm/method/panelsiz.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

/* Give the SmartPanel Frame a special PRIVATE-DATA value to identify it,
   so that code can determine whether a button which has been pressed is
   in a SmartPanel (brsleave.i, for example). 
*/
  IF adm-object-hdl:PRIVATE-DATA = "":U OR adm-object-hdl:PRIVATE-DATA = ? THEN
      adm-object-hdl:PRIVATE-DATA = "ADM-PANEL":U.
  ELSE adm-object-hdl:PRIVATE-DATA =   /* There might be something else in it.*/
      adm-object-hdl:PRIVATE-DATA + ",ADM-PANEL":U.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-use-edge-pixels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-edge-pixels Method-Library 
PROCEDURE use-edge-pixels :
/*------------------------------------------------------------------------------
  Purpose:     Sets the EDGE-PIXELS for the panel's box rectangle
               when the EDGE-PIXELS attribute is set.
  Parameters:  attribute value (edge pixels as character)
  Notes:       Run automatically from broker-set-attribute-list
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER attr-value AS CHARACTER NO-UNDO.

&IF NUM-ENTRIES("{&Box-Rectangle}":U) = 1 &THEN
     DEFINE VARIABLE e-pixels         AS INTEGER   NO-UNDO.
     DO WITH FRAME {&FRAME-NAME}:
        IF {&Box-Rectangle}:TYPE = "RECTANGLE":U THEN DO:
            &IF "{&WINDOW-SYSTEM}":U = "TTY":U &THEN
               e-pixels = 0.     /* No border rectangle for TTY */
            &ELSE
               e-pixels = INTEGER (attr-value).
            &ENDIF
            ASSIGN {&Box-Rectangle}:EDGE-PIXELS = e-pixels
                   {&Box-Rectangle}:HIDDEN = (e-pixels EQ 0).
         END.
     END.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

