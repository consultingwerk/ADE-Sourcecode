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
    File        : prodprop.i
    Purpose     : Defines basic properties.
    Syntax      : {src/adm2/prodprop.i}

    Description :

    Modified    : 04/26/2000
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  /* Custom instance definition file */
  {src/adm2/custom/producerdefscustom.i}


&IF "{&xcInstanceProperties}":U NE "":U &THEN
  &GLOB xcInstanceProperties {&xcInstanceProperties},
&ENDIF
&GLOB xcInstanceProperties {&xcInstanceProperties}~
Domain,JMSpartition,PromptLogin,JMSuser,JMSpassword,ClientID,MessageType,Priority,TimeToLive,Persistency,PingInterval

/* This is the procedure to execute to set InstanceProperties at design time. */
&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
  &SCOP ADM-PROPERTY-DLG adm2/support/producerd.w
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
    {src/adm2/prodprto.i}
  &ENDIF
&ENDIF

  /* Put your xp{&Property} preprocessor definitions here.
     Use the following format, e.g.,
     &GLOBAL-DEFINE xpMyProperty
     These preprocessors tell at compile time which properties can
     be retrieved directly from the temp-table */

  &GLOBAL-DEFINE xpCurrentMessage
  &GLOBAL-DEFINE xpErrorConsumer
  &GLOBAL-DEFINE xpOutMessageSource
  &GLOBAL-DEFINE xpPersistency
  &GLOBAL-DEFINE xpPriority
  &GLOBAL-DEFINE xpReplyConsumer
  &GLOBAL-DEFINE xpTimeToLive
  {src/adm2/messprop.i}
  
&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:
&IF "{&ADMSuper}":U = "":U &THEN
  /* Put your property field definitions here.
     Use the following syntax, e.g.,
     ghADMProps:ADD-NEW-FIELD('MyProperty':U, 'CHAR':U, 0,'X(20)':U, 'Hi':U). */
  
  ghADMProps:ADD-NEW-FIELD('CurrentMessage':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('ErrorConsumer':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('OutMessageSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('Persistency':U, 'CHARACTER':U, 0, ?, 'PERSISTENT':U).
  ghADMProps:ADD-NEW-FIELD('Priority':U, 'INTEGER':U, 0, ?, 4).
  ghADMProps:ADD-NEW-FIELD('ReplyConsumer':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('TimeToLive':U, 'DECIMAL':U, 0, ?, 0).

&ENDIF

  {src/adm2/custom/prodpropcustom.i}

END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


