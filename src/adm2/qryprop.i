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
    File        : qryprop.i
    Purpose     : Starts query.p Super procedure and defines Basic Query Object
                  properties.
    Syntax      : {src/adm2/qryprop.i}

    Description :

    Modified    : May 15, 2000 -- Version 9.1B
    Modified    : 10/24/2001            Mark Davies (MIP0
                  Added new property FilterAvailable.
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  {src/adm2/custom/querydefscustom.i}

/* This variable designates the maximal length of any database 
   table index within the Rocket. If the total length of index 
   fields exceeds this limit, PROGRESS raises a run-time error. */ 
DEF VAR xiRocketIndexLimit AS INTEGER INIT 188 NO-UNDO.

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
         HEIGHT             = 7.48
         WIDTH              = 42.8.
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
  {src/adm2/qryprto.i}
&ENDIF

 /* Preprocessors to define properties that can be retrieved
    directly from the property temp-table. */

 &GLOB xpBaseQuery                               
 &GLOB xpDataColumnsByTable                               
 &GLOB xpNavigationSource       
 &GLOB xpNavigationSourceEvents          
 &GLOB xpBufferHandles          
 &GLOB xpFilterSource           
 &GLOB xpFilterWindow           
 &GLOB xpQueryHandle            
 &GLOB xpQueryRowIdent
 &GLOB xpOpenOnInit
 &GLOB xpForeignValues
 &GLOB xpCheckLastOnOpen
 &GLOB xpQueryString
 &GLOB xpQueryColumns
 &GLOB xpLastDBRowIdent
 &GLOB xpAssignList
 &GLOB xpUpdatableColumnsByTable                
 &GLOB xpDataIsFetched

  /* Include the property temp-table definition and then add query's
     properties to its fields. */
 &IF DEFINED(BrowserQueryObject) NE 0 &THEN
  /* If this is a browser with its own query, then include the browse 
     properties (and everything up the class tree) from here. */
  {src/adm2/brsprop.i}
   /* if appserver aware add appserver properties */ 
 &ELSEIF DEFINED(APP-SERVER-VARS) <> 0 &THEN
  {src/adm2/appsprop.i}
 &ELSE
  {src/adm2/smrtprop.i}
 &ENDIF   
 
&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('BaseQuery':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('DataColumnsByTable':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('NavigationSource':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('NavigationSourceEvents':U, 'CHAR':U, 0, ?, 
    'fetchFirst,fetchNext,fetchPrev,fetchLast,startFilter':U).
  ghADMProps:ADD-NEW-FIELD('FilterWindow':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('FilterSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('ForeignFields':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('QueryPosition':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('BufferHandles':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('QueryHandle':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('QueryRowIdent':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('OpenOnInit':U, 'LOGICAL':U, 0, ?, yes).
  ghADMProps:ADD-NEW-FIELD('ForeignValues':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('CheckLastOnOpen':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('QueryString':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('QueryColumns':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('LastDBRowIdent':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('AssignList':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('UpdatableColumnsByTable':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('Tables':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('DBNames':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('KeyFields':U, 'CHARACTER':U, 0, ?, '{&KEY-FIELDS}':U). 
  ghADMProps:ADD-NEW-FIELD('KeyTableId', 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('FetchOnOpen':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('DataIsFetched':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('FilterActive':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('FilterAvailable':U, 'LOGICAL':U, 0, ?, no).

&ENDIF

  {src/adm2/custom/qrypropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


