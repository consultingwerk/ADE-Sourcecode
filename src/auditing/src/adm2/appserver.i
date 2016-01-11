&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
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
/*-------------------------------------------------------------------------
    File        : appserver.i
    Purpose     : Basic Method Library for the ADMClass appserver.
  
    Syntax      : {src/adm2/appserver.i}

    Description :
  
    Created     : 17 Nov 2000
    Author      : Roland de Pijper, Progress Software BV                
    Modified    : 24 Dec 2001 
                  Added to the Commercial product 
                 (Renamed to appserver and made part of existing classes) 
-------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass appserver
&ENDIF

&IF "{&ADMClass}":U = "appserver":U &THEN
  {src/adm2/appsprop.i}
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
         HEIGHT             = 8
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

{src/adm2/smart.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */
  DEFINE VARIABLE cAppService          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cASDivision          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cServerOperatingMode AS CHARACTER  NO-UNDO.

  &IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  /* Starts super procedure */
  IF NOT {&ADM-LOAD-FROM-REPOSITORY} THEN
    RUN start-super-proc("adm2/appserver.p":U).
  &ENDIF
  
  /* May have been retrieved from repository */ 
  {get AppService cAppService}.

  /* NOTE: If REMOTE = true, we are running on an AppServer, so ignore the 
     AppService (partition) value, which is meaningful only to the client. 
     Also set the ASDivision property to Server.
     Note that AsDivision is set to 'Client' or blank in connectServer upon 
     in appserver.p */
  IF SESSION:REMOTE THEN
  DO:
    ASSIGN cAppService          = '':U
           cASDivision          = 'Server':U
           cServerOperatingMode = CAPS(SESSION:SERVER-OPERATING-MODE).
  END.  /* remote */
  ELSE IF cAppService = '':U THEN 
    ASSIGN cAppService  = '{&APPLICATION-SERVICE}':U.

  &IF '{&DB-REQUIRED}':U = 'FALSE':U &THEN
    /* If this is a client proxy, set the Division property to reflect this. */
    ASSIGN cASDivision  = 'Client':U.
  &ENDIF
  
  IF cASDivision = '':U THEN
     cServerOperatingMode = 'NONE':U.
  /* keep as as unknown if nothing was changed here, getAsDivision uses this 
     as an indication that it does not know yet, Blank means that we do know */
  ELSE 
    {set ASDivision cASDivision}.

  {set ServerOperatingMode cServerOperatingMode}.
  {set AppService cAppService}.
  
  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */

  &IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  {src/adm2/custom/appservercustom.i}
  &ENDIF
  
  /* _ADM-CODE-BLOCK-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


