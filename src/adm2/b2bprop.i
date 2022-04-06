&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : b2bprop.i
    Purpose     : Defines basic properties.
    Syntax      : {src/adm2/b2bprop.i}

    Description :

    Modified    : 04/19/2000
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  /* Custom instance definition file */
  {src/adm2/custom/b2bdefscustom.i}

&IF "{&xcInstanceProperties}":U NE "":U &THEN
  &GLOB xcInstanceProperties {&xcInstanceProperties},
&ENDIF
&GLOB xcInstanceProperties {&xcInstanceProperties}~
DirectionList,NameList,SchemaList,DocTypeList,DestinationList,~
ReplyReqList,ReplySelectorList,MapObjectProducer,MapNameProducer,~
MapTypeProducer,DTDPublicIdList,DTDSystemIdList 

/* This is the procedure to execute to set InstanceProperties at design time. */
&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
  &SCOP ADM-PROPERTY-DLG adm2/support/b2bd.w
&ENDIF

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
    {src/adm2/b2bprto.i}
  &ENDIF
&ENDIF

  /* These preprocessors tell at compile time which properties can
     be retrieved directly from the temp-table */
  
  &GLOBAL-DEFINE xpDestinationList
  &GLOBAL-DEFINE xpDirectionList
  &GLOBAL-DEFINE xpDocTypeList
  &GLOBAL-DEFINE xpDTDPublicIdList
  &GLOBAL-DEFINE xpDTDSystemIdList
  &GLOBAL-DEFINE xpNameList
  &GLOBAL-DEFINE xpReplyReqList
  &GLOBAL-DEFINE xpReplySelectorList
  &GLOBAL-DEFINE xpSchemaHandle
  &GLOBAL-DEFINE xpNameSpaceHandle
  &GLOBAL-DEFINE xpSchemaName
  &GLOBAL-DEFINE xpSchemaList
  &GLOBAL-DEFINE xpLoadedByRouter
  &GLOBAL-DEFINE xpMapObjectProducer
  &GLOBAL-DEFINE xpMapTypeProducer
  &GLOBAL-DEFINE xpMapNameProducer
  &GLOBAL-DEFINE xpTypeName
    
  {src/adm2/xmlprop.i}
 
&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:

&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('DestinationList':U, 'CHAR':U, 0).
  ghADMProps:ADD-NEW-FIELD('DirectionList':U, 'CHAR':U, 0).
  ghADMProps:ADD-NEW-FIELD('DocTypeList':U, 'CHAR':U, 0).
  ghADMProps:ADD-NEW-FIELD('DTDPublicIdList':U, 'CHAR':U, 0).
  ghADMProps:ADD-NEW-FIELD('DTDSystemIdList':U, 'CHAR':U, 0).
  ghADMProps:ADD-NEW-FIELD('NameList':U, 'CHAR':U, 0).
  ghADMProps:ADD-NEW-FIELD('ReplyReqList':U, 'CHAR':U, 0).
  ghADMProps:ADD-NEW-FIELD('ReplySelectorList':U, 'CHAR':U, 0).
  ghADMProps:ADD-NEW-FIELD('SchemaHandle':U, 'HANDLE':U, 0). 
  ghADMProps:ADD-NEW-FIELD('NameSpaceHandle':U, 'HANDLE':U, 0). 
  ghADMProps:ADD-NEW-FIELD('SchemaName':U, 'CHAR':U, 0). 
  ghADMProps:ADD-NEW-FIELD('SchemaList':U, 'CHAR':U, 0).
  ghADMProps:ADD-NEW-FIELD('LoadedByRouter':U, 'LOG':U).
  ghADMProps:ADD-NEW-FIELD('MapObjectProducer':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('MapTypeProducer':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('MapNameProducer':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('TypeName':U, 'CHAR':U).
&ENDIF

  {src/adm2/custom/b2bpropcustom.i}
END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


