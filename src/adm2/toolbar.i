&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-------------------------------------------------------------------------
    File        : toolbar.i
    Purpose     : Basic Method Library for the ADMClass toolbar.
  
    Syntax      : {src/adm2/toolbar.i}

    Description :
  
    Modified    : 05/31/1999
-------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass toolbar
&ENDIF

&IF "{&ADMClass}":U = "toolbar":U &THEN
  {src/adm2/toolprop.i}
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

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  IF NOT {&ADM-LOAD-FROM-REPOSITORY} THEN
  DO:
    RUN start-super-proc("adm2/toolbar.p":U).

    /* Subscribe to createObjects from container */
    RUN modifyListProperty(THIS-PROCEDURE, "ADD":U, 
                          "ContainerSourceEvents":U,"createObjects":U).
    /* Subscribe to removeMenu from container */
    RUN modifyListProperty(THIS-PROCEDURE, "ADD":U, 
                          "ContainerSourceEvents":U,"removeMenu":U).

    /* Subscribe to rebuildMenu from container */
    RUN modifyListProperty(THIS-PROCEDURE, "ADD":U, 
                          "ContainerSourceEvents":U,"rebuildMenu":U).

 
  END.

  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
 
  /* To support the merging of the action class in the toolbar class */
  {src/adm2/custom/actioncustom.i}
 
  {src/adm2/custom/toolbarcustom.i} 

  /* _ADM-CODE-BLOCK-END */
  
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


