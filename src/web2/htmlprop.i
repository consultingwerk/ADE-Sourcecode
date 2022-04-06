&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    Library     : web2/htmlprop.i
    Purpose     : Standard include file for HTML Mapping objects. This file 
                  is included in every web/template/html-map.w and runs
                  web2/html-map.p as its super procedure.
                
    Syntax      :
    Description : 
    Author(s)   : D.M.Adams
    Created     : March, 1998
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.                */
/*------------------------------------------------------------------------*/

/* **************************** Shared Definitions ***************************/

{src/web2/custom/html-mapdefscustom.i}

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */
 /* Include the file which defines prototypes for all of the super
     procedure's entry points. Also, start or attach to the super procedure.
     Skip start-super-proc if we *are* the super procedure. 
     And skip including the prototypes if we are *any* super procedure. */

&IF "{&ADMSuper}":U EQ "":U &THEN
   {src/web2/htmlprto.i}
&ENDIF


/* Preprocs to identify to compiler which properties are in the temp-table.*/
&GLOBAL-DEFINE xpWebFile                   
&GLOBAL-DEFINE xpContainerName             
&GLOBAL-DEFINE xpQueryName                  
&GLOBAL-DEFINE xpQueryTables                
&GLOBAL-DEFINE xpDataSourceFile             
&GLOBAL-DEFINE xpDisplayedFieldHandles      
&GLOBAL-DEFINE xpDisplayedObjects           
&GLOBAL-DEFINE xpDisplayedObjectHandles     
&GLOBAL-DEFINE xpEnabledFields        
&GLOBAL-DEFINE xpEnabledFieldHandles        
&GLOBAL-DEFINE xpFieldHandles        
&GLOBAL-DEFINE xpEnabledObjects             
&GLOBAL-DEFINE xpEnabledObjectHandles       
&GLOBAL-DEFINE xpDisplayedFields        
&GLOBAL-DEFINE xpDisplayedDataFields        
&GLOBAL-DEFINE xpDisplayedDataFieldHandles  
&GLOBAL-DEFINE xpEnabledDataFields          
&GLOBAL-DEFINE xpEnabledDataFieldHandles    
&GLOBAL-DEFINE xpDisplayedTables             
&GLOBAL-DEFINE xpEnabledTables               

/* Now include the next-level-up property include file. This builds up
   the property temp-table definition, 
   which we will then add our field definitions to. */
  
  {src/web2/admwprop.i}

&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('WebFile':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('ContainerName':U, 'CHAR':U).  
  ghADMProps:ADD-NEW-FIELD('QueryName':U, 'CHAR':U).   
  ghADMProps:ADD-NEW-FIELD('QueryTables':U, 'CHAR':U).   
  ghADMProps:ADD-NEW-FIELD('DataSourceFile':U, 'CHAR':U).   
  ghADMProps:ADD-NEW-FIELD('DisplayedFields':U, 'CHAR':U).   
  ghADMProps:ADD-NEW-FIELD('DisplayedFieldHandles':U, 'CHAR':U).   
  ghADMProps:ADD-NEW-FIELD('DisplayedObjects':U, 'CHAR':U).   
  ghADMProps:ADD-NEW-FIELD('DisplayedObjectHandles':U, 'CHAR':U).   
  ghADMProps:ADD-NEW-FIELD('EnabledFields':U, 'CHAR':U).   
  ghADMProps:ADD-NEW-FIELD('EnabledFieldHandles':U, 'CHAR':U).   
  ghADMProps:ADD-NEW-FIELD('FieldHandles':U, 'CHAR':U).   
  ghADMProps:ADD-NEW-FIELD('EnabledObjects':U, 'CHAR':U).   
  ghADMProps:ADD-NEW-FIELD('EnabledObjectHandles':U, 'CHAR':U). 
  ghADMProps:ADD-NEW-FIELD('DisplayedDataFields':U, 'CHAR':U). 
  ghADMProps:ADD-NEW-FIELD('DisplayedDataFieldHandles':U, 'CHAR':U). 
  ghADMProps:ADD-NEW-FIELD('EnabledDataFields':U, 'CHAR':U). 
  ghADMProps:ADD-NEW-FIELD('EnabledDataFieldHandles':U, 'CHAR':U). 
  ghADMProps:ADD-NEW-FIELD('DisplayedTables':U, 'CHAR':U).  
  ghADMProps:ADD-NEW-FIELD('EnabledTables':U, 'CHAR':U).   
&ENDIF

{src/web2/custom/htmlpropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



