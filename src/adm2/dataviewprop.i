&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : dataviewprop.i
    Purpose     : Defines basic properties.
    Syntax      : {src/adm2/dataviewprop.i}

    Description :

    Modified    : 07/30/2005
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN  
  /* Custom instance definition file */
  {src/adm2/custom/dataviewdefscustom.i}

  &IF "{&xcInstanceProperties}":U <> "":U &THEN 
&GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF 
  
&GLOB xcInstanceProperties {&xcInstanceProperties}~
BusinessEntity,DataQueryString,DataSetName,DataTable,Tables,SubmitParent,~
DataIsFetched,ResortOnSave 

&ENDIF    

/* This is the procedure to execute to set InstanceProperties at design time. */
&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
  &SCOP ADM-PROPERTY-DLG adm2/support/dataviewd.w
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
    {src/adm2/dataviewprto.i}
  &ENDIF
&ENDIF  /* defined(adm-exclude-prototypes)  */
 
{src/adm2/dataqueryprop.i}

 &GLOBAL-DEFINE xpBusinessEntity
 &GLOBAL-DEFINE xpDataSetName
 &GLOBAL-DEFINE xpDataSetSource
 &GLOBAL-DEFINE xpDataTable
 &GLOBAL-DEFINE xpResortOnSave
 &GLOBAL-DEFINE xpUndoOnConflict
 &GLOBAL-DEFINE xpUndoDeleteOnSubmitError

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN  
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:
  &IF "{&ADMSuper}":U = "":U &THEN 
     ghADMProps:ADD-NEW-FIELD('BusinessEntity':U, 'CHAR':U, 0,'X(40)':U, '':U). 
     ghADMProps:ADD-NEW-FIELD('DataSetName':U, 'CHAR':U, 0,'X(40)':U, '':U). 
     ghADMProps:ADD-NEW-FIELD('DataSetSource':U, 'HANDLE':U).   
     ghADMProps:ADD-NEW-FIELD('DataTable':U, 'CHAR':U, 0,'X(20)':U, '':U). 
     ghADMProps:ADD-NEW-FIELD('ResortOnSave':U, 'LOGICAL':U, 0,?,YES). 
     ghADMProps:ADD-NEW-FIELD('SubmitParent':U, 'LOGICAL':U, 0,?,?). 
     ghADMProps:ADD-NEW-FIELD('UndoOnConflict':U, 'CHAR':U, 0,'X(8)':U, 'BEFORE':U). 
     ghADMProps:ADD-NEW-FIELD('UndoDeleteOnSubmitError':U, 'CHAR':U, 0,'X(8)':U, 'ERROR':U). 
  &ENDIF  /* "{&ADMSuper}" = "" */

  {src/adm2/custom/dataviewpropcustom.i}

END. /* if not adm-props-defined */

&ENDIF  /* defined(adm-exclude-static)  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


