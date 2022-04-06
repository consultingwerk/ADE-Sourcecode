&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : wbdtprop.i  
    Purpose     : starts web2/wbtable.p super procedure and provides logic
                  to output data in an HTML table
    Syntax      : {src/web2/wbtaprop.i}

    Description :        
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{src/web2/custom/wbtabledefscustom.i}

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
         HEIGHT             = 15
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
  {src/web2/wbtaprto.i}
&ENDIF

  &GLOBAL-DEFINE xpTableRows                     
  &GLOBAL-DEFINE xpTableModifier               
  &GLOBAL-DEFINE xpTDModifier                   
  &GLOBAL-DEFINE xpLinkColumns                  
  &GLOBAL-DEFINE xpLinkURLs                    
  &GLOBAL-DEFINE xpLinkTargets                 
  &GLOBAL-DEFINE xpLinkTexts                    
  &GLOBAL-DEFINE xpLinkJoins                   
  &GLOBAL-DEFINE xpUseColumnLabels             

{src/web2/webrprop.i} 

&IF "{&ADMSuper}":U = "":U &THEN 
  ghADMProps:ADD-NEW-FIELD('TableRows':U, 'INT':U).
  ghADMProps:ADD-NEW-FIELD('TableModifier':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('TDModifier':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('LinkColumns':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('LinkURLs':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('LinkTargets':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('LinkTexts':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('LinkJoins':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('UseColumnLabels':U, 'LOGICAL':U).
&ENDIF

{src/web2/custom/wbtapropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



