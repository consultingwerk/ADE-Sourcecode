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
    File        : visprop.i
    Purpose     : Starts Super procedure visual.p and defines basic properties
                  for visual SmartObjects in V9
    Syntax      : {src/adm2/visprop.i}

    Description :

    Modified    : May 19, 1999 Version 9.1A
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  {src/adm2/custom/visualdefscustom.i}

  &IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF
  &GLOB xcInstanceProperties {&xcInstanceProperties}~
HideOnInit,DisableOnInit,ObjectLayout

/* This is the procedure to execute to set InstanceProperties at design time. */
&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
  &SCOP ADM-PROPERTY-DLG adm2/support/visuald.w
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
     procedure's entry points. Also, start or attach to the super procedure.
     Skip start-super-proc if we *are* the super procedure. 
     And skip including the prototypes if we are *any* super procedure. */
&IF "{&ADMSuper}":U EQ "":U &THEN
  {src/adm2/visprto.i}
&ENDIF

  /* These preprocessors tell at compile time which properties can be
     retrieved directly from the temp-table. */

  &GLOB xpObjectLayout
  &GLOB xpLayoutOptions
  &GLOB xpObjectEnabled
  &GLOB xpLayoutVariable
  &GLOB xpDefaultLayout
  &GLOB xpHideOnInit
  &GLOB xpDisableOnInit
  &GLOB xpEnabledObjFlds
  &GLOB xpEnabledObjHdls

  /* Include the next property file up the chain (in this case, the top
     of the chain); it starts the property temp-table definition and we
     add our field definitions to it. */

  {src/adm2/smrtprop.i}

&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('ObjectLayout':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('LayoutOptions':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ObjectEnabled':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('LayoutVariable':U, 'CHAR':U, 0, ?, '{&LAYOUT-VARIABLE}':U).
  ghADMProps:ADD-NEW-FIELD('DefaultLayout':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('HideOnInit':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('DisableOnInit':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('EnabledObjFlds':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('EnabledObjHdls':U, 'CHAR':U, 0, ?, '':U).
&ENDIF

  {src/adm2/custom/vispropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


