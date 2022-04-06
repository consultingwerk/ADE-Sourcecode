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
    File        : messprop.i
    Purpose     : Defines basic properties.
    Syntax      : {src/adm2/messprop.i}

    Description :

    Modified    : 05/03/2000
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  /* Custom instance definition file */
  {src/adm2/custom/messagingdefscustom.i}
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
    {src/adm2/messprto.i}
  &ENDIF
&ENDIF

  /* Put your xp{&Property} preprocessor definitions here.
     Use the following format, e.g.,
     &GLOBAL-DEFINE xpMyProperty
     These preprocessors tell at compile time which properties can
     be retrieved directly from the temp-table */

  &GLOBAL-DEFINE xpClientID
  &GLOBAL-DEFINE xpJMSpartition
  &GLOBAL-DEFINE xpJMSuser
  &GLOBAL-DEFINE xpJMSpassword
  &GLOBAL-DEFINE xpMessageType
  &GLOBAL-DEFINE xpPingInterval
  &GLOBAL-DEFINE xpPromptLogin  
  &GLOBAL-DEFINE xpSupportedMessageTypes
  {src/adm2/smrtprop.i}
  
&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:
&IF "{&ADMSuper}":U = "":U &THEN
  /* Put your property field definitions here.
     Use the following syntax, e.g.,
     ghADMProps:ADD-NEW-FIELD('MyProperty':U, 'CHAR':U, 0,'X(20)':U, 'Hi':U). */
   
  ghADMProps:ADD-NEW-FIELD('ClientID':U, 'CHARACTER':U, 0, ?, '':U).  
  ghADMProps:ADD-NEW-FIELD('Domain':U, 'CHARACTER':U, 0, ?, 'PubSub':U).
  ghADMProps:ADD-NEW-FIELD('JMSpartition':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('JMSuser':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('JMSpassword':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('MessageType':U, 'CHARACTER':U, 0, ?, 'TextMessage':U).
  ghADMProps:ADD-NEW-FIELD('PingInterval':U, 'INTEGER':U, 0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('PromptLogin':U, 'LOGICAL':U, 0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('SupportedMessageTypes':U, 'CHARACTER':U, 0, ?, 
    'BytesMessage,HeaderMessage,MapMessage,TextMessage,StreamMessage,XMLMessage':U).
&ENDIF

  {src/adm2/custom/messpropcustom.i}
END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


