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
    File        : admweb.i  
    Purpose     : Provides basic ADM functionality for Web based applications
                  without including most of the ADM code.
  
    Syntax      : {src/web2/admweb.i}

    Updates     : Add new attribute - Web Time Remaining -  nhorn 1/31/97 
                  for web objects.  
  
    Author(s)   : D.M.Adams
    Created     : March 1998
    Notes       : Loosely based on ADM Version 1.0 code
--------------------------------------------------------------------------*/
/*            This .i file was created with Progress Appbuilder           */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

&IF "{&ADMClass}":U = "":U &THEN
  &GLOBAL-DEFINE ADMClass admweb
&ENDIF

&IF "{&ADMClass}":U = "admweb":U &THEN
  {src/web2/admwprop.i}
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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

{src/web2/wbdata.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


RUN start-super-proc("web2/admweb.p":U).

/* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
{src/web2/custom/admwebcustom.i}
/* _ADM-CODE-BLOCK-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


