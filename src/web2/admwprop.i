&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : admprop.i  
    Purpose     : Provides basic ADM functionality for Web based applications
                  without including most of the ADM code.
  
    Syntax      : {src/web2/admprop.i}

    Author(s)   : D.M.Adams
    Created     : March 1998
    Notes       : Loosely based on ADM Version 1.0 code
--------------------------------------------------------------------------*/
/*            This .i file was created with Progress Appbuilder           */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

&GLOBAL-DEFINE ADM-VERSION        ADM2.0

{src/web2/custom/admwebdefscustom.i}

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
         HEIGHT             = 12.14
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


&IF "{&ADMSuper}":U EQ "":U &THEN
   {src/web2/admwprto.i}
&ENDIF

 &GLOBAL-DEFINE xpWebState
 &GLOBAL-DEFINE xpWebTimeout
 &GLOBAL-DEFINE xpWebToHdlr                 
 
  /* Now include the next-level-up property include file. This builds up
     the property temp-table definition, 
     which we will then add our field definitions to. */  
  {src/web2/wbdaprop.i}

&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('WebState':U, 'CHAR':U, 0, ?,'state-less':U).
  ghADMProps:ADD-NEW-FIELD('WebTimeout':U, 'DEC':U).
  ghADMProps:ADD-NEW-FIELD('WebToHdlr':U, 'CHAR':U, 0, ?,'':U).  
&ENDIF

{src/web2/custom/admwpropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


