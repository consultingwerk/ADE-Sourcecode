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
    File        : cntnprop.i
    Purpose     : Starts containr.p super procedure and defines general
                  SmartContainer properties and other values.
    Syntax      : {src/adm2/cntnprop.i}

    Description :

    Modified    : August 1, 2000 -- Version 9.1B
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  {src/adm2/custom/containrdefscustom.i}

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
         HEIGHT             = 7.86
         WIDTH              = 49.
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
  {src/adm2/cntnprto.i}
&ENDIF

  /* Preprocs to identify to compiler which properties are in the temp-table.*/
  &GLOB xpCurrentPage
  &GLOB xpContainerTarget
  &GLOB xpContainerTargetEvents
  &GLOB xpOutMessageTarget
  &GLOB xpPageNTarget
  &GLOB xpPageSource
  &GLOB xpFilterSource
  &GLOB xpUpdateSource
  &GLOB xpUpdateTarget
  &GLOB xpStartPage
  &GLOB xpRunMultiple
  &GLOB xpWaitForObject
  &GLOB xpDynamicSDOProcedure
  &GLOB xpRunDOOptions

  /* Now include the next-level-up property include file. This builds up
     the property temp-table definition, which we will then add our 
     field definitions to. If this is a non-visual ('virtual') container,
     then skip the visual properties */  
&IF "{&ADM-CONTAINER}":U = "VIRTUAL":U &THEN
  /* Directly to smart properties */
  &IF DEFINED(APP-SERVER-VARS) = 0 &THEN
    {src/adm2/smrtprop.i}
  /* else if appserver aware (adecomm/appserv.i) include appserver props */
  &ELSE
    {src/adm2/appsprop.i}
  &ENDIF
&ELSE
    {src/adm2/visprop.i}
&ENDIF

&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('CurrentPage':U, 'INT':U, 0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('ContainerTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ContainerTargetEvents':U, 'CHAR':U, 0, ?,
    'exitObject':U).
  ghADMProps:ADD-NEW-FIELD('OutMessageTarget':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('PageNTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('PageSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('FilterSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('UpdateSource':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('UpdateTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('StartPage':U, 'INT':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('RunMultiple':U, 'LOGICAL':U, 0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('WaitForObject':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('DynamicSDOProcedure':U, 'CHAR':U, 0, ?,
      'adm2/dyndata.w':U).
  ghADMProps:ADD-NEW-FIELD('RunDOOptions':U, 'CHARACTER':U, 0, ?,'':U).
&ENDIF

  {src/adm2/custom/cntnpropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


