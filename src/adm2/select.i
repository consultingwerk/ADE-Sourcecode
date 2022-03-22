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
    File        : select.i
    Purpose     : Basic Method Library for the ADMClass select.
  
    Syntax      : {src/adm2/select.i}

    Description :
  
    Modified    : 06/23/1999
-------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass select
&ENDIF

&IF "{&ADMClass}":U = "select":U &THEN
  {src/adm2/seleprop.i}
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

{src/adm2/field.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  /* Starts super procedure */
  IF NOT {&ADM-LOAD-FROM-REPOSITORY} THEN
  DO:
    RUN start-super-proc("adm2/select.p":U).
  
   /* override smrtprop.i default DataSourceEvents 
      queryopened is special for smartselect because it tells the object to
      refresh it self completely (dataAvailable is not sufficent)   
    (queryPosition, deletecomplete not used, but they may malke sense) */  
    {set DataSourceEvents 
      'dataAvailable,queryPosition,deleteComplete,queryOpened':U}.
  END.  /* if not adm-load-from-repos */

  /* custom library that can be overridden to start-super custom/selectcustom.p */ 
  {src/adm2/custom/selectcustom.i}

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


