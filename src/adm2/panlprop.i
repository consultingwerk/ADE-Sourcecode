&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : panlprop.i
    Purpose     : Starts panel.p Super procedure and defines Basic SmartPanel
                  properties.
    Syntax      : {src/adm2/panlprop.i}

    Description :

    Modified    : May 17, 2000 -- Version 9.1B
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  {src/adm2/custom/paneldefscustom.i}
  
  &IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF
                                         
&GLOB xcInstanceProperties {&xcInstanceProperties}~
PanelType,AddFunction
  
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
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 8
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

  /* Include the file which defines prototypes for all of the super
     procedure's entry points. 
     And skip including the prototypes if we are *any* super procedure. */
&IF DEFINED(ADM-EXCLUDE-PROTOTYPES) = 0 &THEN
  &IF "{&ADMSuper}":U EQ "":U &THEN
    {src/adm2/panlprto.i}
  &ENDIF
&ENDIF

 /* These preprocessors tell us at compile time what properties can be
    retrieved directly from the temp-table. */
 &GLOB xpButtonCount
 &GLOB xpStaticPrefix
 &GLOB xpPanelFrame
 &GLOB xpMarginPixels
 &GLOB xpPanelLabel
 
&IF  ('{&ADM-Panel-Type}':U BEGINS 'Nav':U) &THEN
  /* Navigation-Panel-specific properties */
  &GLOB xpRightToLeft
&ELSEIF ('{&ADM-Panel-Type}':U BEGINS 'Upd':U) 
     OR ('{&ADM-Panel-Type}':U BEGINS 'Sav':U) &THEN 
  /* Update/Save panel-specific properties */
  &GLOB xpAddFunction
  &GLOB xpUpdatingRecord
&ENDIF

{src/adm2/toolprop.i}

&UNDEFINE xpTableioType   /* mapped to paneltype */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:
    &IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('ButtonCount':U, 'INT':U, 0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('StaticPrefix':U, 'CHAR':U, 0, ?, 'Btn-':U).          
  ghADMProps:ADD-NEW-FIELD('PanelFrame':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('MarginPixels':U, 'INT':U, 0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('PanelLabel':U, 'HANDLE':U).
    
      &IF ('{&ADM-Panel-Type}':U BEGINS 'Nav':U) &THEN
  /* Navigation-Panel-specific properties */
  ghADMProps:ADD-NEW-FIELD('RightToLeft':U, 'CHAR':U, 0, ?, '':U).
      &ELSEIF ('{&ADM-Panel-Type}':U BEGINS 'Upd':U) OR ('{&ADM-Panel-Type}':U BEGINS 'Sav':U) &THEN
  /* Update/Save panel-specific properties */
  ghADMProps:ADD-NEW-FIELD('AddFunction':U, 'CHAR':U, 0, ?, 'One-Record':U).
  ghADMProps:ADD-NEW-FIELD('UpdatingRecord':U, 'LOGICAL':U, 0, ?, FALSE).
      &ELSEIF '{&ADM-Panel-Type}':U NE '':U AND '{&ADM-Panel-Type}':U NE 'commit':U  &THEN
  /* If Panel-Type is anything else at all, look for p + type + prop.i,
     which should contain FIELD definitions *only*. */
  {src/adm2/p{&ADM-Panel-Type}prop.i}
      &ENDIF
    &ENDIF

  {src/adm2/custom/panlpropcustom.i}
END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


