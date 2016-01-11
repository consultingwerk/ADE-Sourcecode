&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*--------------------------------------------------------------------------
    File        : datasetprop.i
    Purpose     : Defines basic properties.
    Syntax      : {src/adm2/datasetprop.i}

    Description :

    Modified    : 08/01/2005
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN  
  /* Custom instance definition file */
  {src/adm2/custom/datasetdefscustom.i}

  /**
  &IF "{&xcInstanceProperties}":U NE "":U &THEN
     &GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF 
  &GLOB xcInstanceProperties {&xcInstanceProperties},InstProp     
  **/ 
  
  /* This is the procedure to execute to set InstanceProperties at design time. */
  /***
  &IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
      &SCOP ADM-PROPERTY-DLG adm2/support/xxxx.w
  &ENDIF 
  **/   
      
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
    {src/adm2/datasetprto.i}
  &ENDIF
&ENDIF  /* defined(adm-exclude-prototypes)  */

/*  These preprocessors tell at compile time which properties can
    be retrieved directly from the temp-table */
&GLOBAL-DEFINE xpDatasetHandle
  
  {src/adm2/smrtprop.i}
  
&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN  
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:
  &IF "{&ADMSuper}":U = "":U &THEN
     ghADMProps:ADD-NEW-FIELD('DataSetHandle':U, 'HANDLE':U). 
   
  &ENDIF  /* "{&ADMSuper}" = "" */

  {src/adm2/custom/datasetpropcustom.i}

END. /* if not adm-props-defined */

&ENDIF  /* defined(adm-exclude-static)  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


