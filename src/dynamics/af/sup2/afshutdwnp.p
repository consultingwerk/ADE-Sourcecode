&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afshutdwnp.p

  Description:  Client Application Shutdown Procedure

  Purpose:      Client Application Shutdown Procedure
                To kill session plips and disconnect from Appserver.

  Parameters:

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   02/06/2000  Author:     Anthony Swindells

  Update Notes: Write Astra2 Environment

  (v:010001)    Task:        6065   UserRef:    
                Date:   19/06/2000  Author:     Anthony Swindells

  Update Notes: Integrate Astra1 & Astra 2

  (v:010002)    Task:        7452   UserRef:    
                Date:   03/01/2001  Author:     Anthony Swindells

  Update Notes: add setting of handles to null

  (v:010003)    Task:        7508   UserRef:    
                Date:   08/01/2001  Author:     Anthony Swindells

  Update Notes: fix shutdown issues

  (v:010004)    Task:        7509   UserRef:    
                Date:   08/01/2001  Author:     Anthony Swindells

  Update Notes: shutdown issues

  (v:010005)    Task:        7704   UserRef:    
                Date:   24/01/2001  Author:     Peter Judge

  Update Notes: AF2/ Add new AstraGen Manager

----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afshutdwnp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

/* pull in Astra global variables */
{af/sup2/afglobals.i}

DEFINE VARIABLE cAppService                         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                               AS INTEGER    NO-UNDO.
DEFINE VARIABLE cPartitions                         AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.76
         WIDTH              = 46.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN sessionShutdown IN THIS-PROCEDURE.

/* The following code used to be the code for afshutdwnp.p. I have replaced it with 
   code inside the configuration file manager which does the same thing in a more 
   organized way. I needed to do this as a fix to issue 3433. 
   -- Bruce S Gruenbaum  02/08/2002 */

/*
/* Include the file which defines AppServerConnect procedures. */
{adecomm/appserv.i}

/* Tidy up - Disconnect from Appserver and zap Managers */
ASSIGN cAppService = "Astra".     /* Astra Appserver partition name */

/* Attempt to shutdown any and all managers running.  */
IF VALID-HANDLE(gshAgnManager)          THEN APPLY "CLOSE":U TO gshAgnManager.
IF VALID-HANDLE(gshFinManager)          THEN APPLY "CLOSE":U TO gshFinManager.
IF VALID-HANDLE(gshGenManager)          THEN APPLY "CLOSE":U TO gshGenManager.
IF VALID-HANDLE(gshTranslationManager)  THEN APPLY "CLOSE":U TO gshTranslationManager.
IF VALID-HANDLE(gshRepositoryManager)   THEN APPLY "CLOSE":U TO gshRepositoryManager.
IF VALID-HANDLE(gshProfileManager)      THEN APPLY "CLOSE":U TO gshProfileManager.
IF VALID-HANDLE(gshSecurityManager)     THEN APPLY "CLOSE":U TO gshSecurityManager.
IF VALID-HANDLE(gshSessionManager)      THEN APPLY "CLOSE":U TO gshSessionManager.

IF VALID-HANDLE(gshAstraAppserver)             AND
   CAN-QUERY(gshAstraAppserver, "connected":U) AND
   gshAstraAppserver:CONNECTED()               THEN
    RUN appServerDisconnect(INPUT cAppService).

ASSIGN gshAgnManager         = ?
       gshFinManager         = ?
       gshGenManager         = ?
       gshTranslationManager = ?
       gshRepositoryManager  = ?
       gshProfileManager     = ?
       gshSecurityManager    = ?
       gshSessionManager     = ?
       gshAstraAppserver     = ?
       .

/* disconnect any other Appserver partitions */
cPartitions = DYNAMIC-FUNCTION('definedPartitions').
DO iLoop = 1 TO NUM-ENTRIES(cPartitions,CHR(3)):
  IF ENTRY(iLoop,cPartitions,CHR(3)) = "Astra":U THEN NEXT.
  RUN appServerDisconnect(INPUT ENTRY(iLoop,cPartitions,CHR(3))).
END.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


