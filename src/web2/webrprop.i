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
    File        : webrprop.i
    Purpose     : Basic Property definiton include file for Web objects  
                  Starts super procedure web2/webrep.p
    Syntax      : {src/web2/webprop.i}

    Description :
 
    Created     : July, 1998
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{src/web2/custom/webrepdefscustom.i}

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
  {src/web2/webrprto.i}
&ENDIF

&GLOBAL-DEFINE xpUpdateMode              
&GLOBAL-DEFINE xpNavigationMode              
&GLOBAL-DEFINE xpAppService              
&GLOBAL-DEFINE xpCurrentRowIds              
&GLOBAL-DEFINE xpCurrentRowIds              
&GLOBAL-DEFINE xpSearchColumns             
&GLOBAL-DEFINE xpExternalTableList     
&GLOBAL-DEFINE xpExternalJoinList     
&GLOBAL-DEFINE xpExternalWhereList
&GLOBAL-DEFINE xpExternalTables   
&GLOBAL-DEFINE xpHTMLFocusOnError   
&GLOBAL-DEFINE xpHTMLSelectOnError     
&GLOBAL-DEFINE xpForeignFieldList 
&GLOBAL-DEFINE xpContextFields
&GLOBAL-DEFINE xpDataColumns
&GLOBAL-DEFINE xpServerConnection

/* Include the next property file up the chain; we will add our field
     definitions to its list. */
{src/adm2/qryprop.i}
&UNDEFINE xpTables 

&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('UpdateMode':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('NavigationMode':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('CurrentRowids':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('SearchColumns':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('AppService':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('ExternalTableList':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('ExternalJoinList':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('ExternalWhereList':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('ForeignFieldList':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('ExternalTables':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('HTMLFocusOnError':U, 'LOG':U, 0, ?, TRUE).
  ghADMProps:ADD-NEW-FIELD('HTMLSelectOnError':U, 'LOG':U, 0, ?, TRUE).
  ghADMProps:ADD-NEW-FIELD('ContextFields':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('DataColumns':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('ServerConnection':U, 'CHAR':U).
&ENDIF

{src/web2/custom/webrpropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


