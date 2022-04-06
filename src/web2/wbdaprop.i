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
    File        : wbdaprop.i  
    Purpose     : starts web2/wbdata.p super procedure and provides basic 
                  transaction logic for Web objects
    Syntax      : {src/web2/wbdaprop.i}

    Description :        
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{src/web2/custom/wbdatadefscustom.i}

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
  {src/web2/wbdaprto.i}
&ENDIF

&GLOBAL-DEFINE xpFrameHandle
&GLOBAL-DEFINE xpAddMode 
&GLOBAL-DEFINE xpDeleteTables 
           
/* Include the next property file up the chain; we will add our field
     definitions to its list. */
{src/web2/webrprop.i}

&IF "{&ADMSuper}":U = "":U &THEN
ghADMProps:ADD-NEW-FIELD('FrameHandle':U, 'HANDLE':U). 
ghADMProps:ADD-NEW-FIELD('AddMode':U, 'LOG':U).        /* Yes = Create a record on submit of data */ 
ghADMProps:ADD-NEW-FIELD('DeleteTables':U, 'CHAR':U).  /* Tables to delete on delete */ 
&ENDIF

{src/web2/custom/wbdapropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



