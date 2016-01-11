&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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
    File        : toolprop.i
    Purpose     : Defines basic properties.
    Syntax      : {src/adm2/toolprop.i}

    Description :

    Modified    : 05/31/1999
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* This is the procedure to execute to set InstanceProperties at design time. */
&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
  &SCOP ADM-PROPERTY-DLG adm2/support/toold.w
&ENDIF

&IF "{&xcInstanceProperties}":U NE "":U &THEN
   &GLOB xcInstanceProperties {&xcInstanceProperties},
&ENDIF
&GLOB xcInstanceProperties {&xcInstanceProperties}~
FlatButtons,Menu,ShowBorder,Toolbar,ActionGroups,SubModules,TableIOType,SupportedLinks

  /* Custom instance definition file */

  {src/adm2/custom/toolbardefscustom.i}

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
         HEIGHT             = 6.43
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

  /* Include the file which defines prototypes for all of the super
     procedure's entry points. 
     And skip including the prototypes if we are *any* super procedure. */
&IF "{&ADMSuper}":U EQ "":U &THEN
  {src/adm2/toolprto.i}
&ENDIF

&GLOB xpMenu
&GLOB xpToolbar
&GLOB xpMenubarHandle
&GLOB xpFlatButtons
&GLOB xpActionGroups
&GLOB xpToolMarginPxl
&GLOB xpToolSpacingPxl
&GLOB xpToolSeparatorPxl
&GLOB xpToolWidthPxl
&GLOB xpToolHeightPxl
&GLOB xpImagePath 
&GLOB xpShowBorder 
&GLOB xpAvailMenuActions 
&GLOB xpAvailToolbarActions 
&GLOB xpSubModules 
&GLOB xpTableioType 
&GLOB xpToolbarMinWidth

  {src/adm2/actiprop.i}
  
&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('Menu':U, 'LOGICAL':U, 0, ?, TRUE).
  ghADMProps:ADD-NEW-FIELD('Toolbar':U, 'LOGICAL':U, 0, ?, TRUE).
  ghADMProps:ADD-NEW-FIELD('MenubarHandle':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('FlatButtons':U, 'LOGICAL':U, 0, ?, TRUE).
  ghADMProps:ADD-NEW-FIELD('ActionGroups':U, 'CHARACTER':U, 0, ?,'Tableio,Navigation':U).
  ghADMProps:ADD-NEW-FIELD('ToolMarginPxl':U, 'INTEGER':U, 0, ?, 3).
  ghADMProps:ADD-NEW-FIELD('ToolSpacingPxl':U, 'INTEGER':U, 0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('ToolSeparatorPxl':U, 'INTEGER':U, 0, ?, 3).
  ghADMProps:ADD-NEW-FIELD('ToolWidthPxl':U, 'INTEGER':U, 0, ?, 24).
  ghADMProps:ADD-NEW-FIELD('ToolHeightPxl':U, 'INTEGER':U, 0, ?, 22).
  ghADMProps:ADD-NEW-FIELD('ImagePath':U, 'CHARACTER':U, 0, ?, 'adm2/image':U).
  ghADMProps:ADD-NEW-FIELD('ShowBorder':U, 'LOGICAL':U, 0, ?, TRUE).
  ghADMProps:ADD-NEW-FIELD('AvailMenuActions':U, 'CHARACTER':U, 0, ?,'':U).
  ghADMProps:ADD-NEW-FIELD('AvailToolbarActions':U, 'CHARACTER':U, 0, ?,'':U).
  ghADMProps:ADD-NEW-FIELD('subModules':U, 'CHARACTER':U, 0, ?,'':U).
  ghADMProps:ADD-NEW-FIELD('TableIoType':U, 'CHARACTER':U, 0, ?,'Save':U).
  ghADMProps:ADD-NEW-FIELD('ToolbarMinWidth':U, 'DECIMAL':U, 0, ?, 0 ).
  ghADMProps:ADD-NEW-FIELD('DisabledActions':U, 'CHARACTER':U, 0, ?, '':U).
&ENDIF

  /*<<BEGIN-CUSTOM-PROPERTIES>>*/
  {src/adm2/custom/toolpropcustom.i}
  /*<<END-CUSTOM-PROPERTIES>>*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


