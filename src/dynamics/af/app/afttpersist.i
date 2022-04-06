&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Include _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Include _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afttpersist.i

  Description:  Persistent Procedures temp-table

  Purpose:      Persistent Procedures temp-table

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6063   UserRef:    
                Date:   22/06/2000  Author:     Anthony Swindells

  Update Notes: Write dynamic toolbar menus.

------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afttpersist.i
&scop object-version    000000


/* MIP object identifying preprocessor */
&glob   mip-structured-include  yes

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
         HEIGHT             = 5.57
         WIDTH              = 64.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

&IF DEFINED(ttPersist) = 0 &THEN
  /* Temp-Table of persistently running procedures in current session.
     This table manages persitently running container windows, business
     logic procedures and pre-started managers, i.e. everything running
     persistently in the session (except browsers, viewers, etc).
     It is used to manage whether multiple instances of a procedure are valid
     and required, and if not, to re-use the already running instance if
     possible.
     It contains useful information about the running procedures for display
     in a browser of running procedures at run-time.
     Note that the Appserver session will have a different set of records to
     the client session, as the client and appserver are in fact different
     progress sessions. The appserver knows nothing about the client, but the
     client could obtain the rnning procedures from the appserver.
  */
  DEFINE TEMP-TABLE ttPersistentProc NO-UNDO
  FIELD physicalName            AS CHARACTER  /* Physical name of running procedure (inc path) */
  FIELD logicalName             AS CHARACTER  /* If logical, logical object name, else blank */
  FIELD runAttribute            AS CHARACTER  /* Run attribute passed into object (if any) */
  FIELD childDataKey            AS CHARACTER  /* Data key passed into procedure */
  FIELD onAppserver             AS LOGICAL    /* YES if running on Appserver (for bound connection) */
  FIELD procedureType           AS CHARACTER  /* Type of procedure, e.g. PRO = procedure,MAN = Manager, ADM1,ADM2,Astra1,Astra2 */
  FIELD procedureHandle         AS HANDLE     /* Handle of running procedure */
  FIELD runPermanent            AS LOGICAL    /* YES = do not kill when agent disconnected, default = NO */
  FIELD multiInstanceSupported  AS LOGICAL    /* YES if procedure supports multiple instances */
  FIELD currentOperation        AS CHARACTER  /* Current procedure mode, e.g. add,copy,modify,view */
  FIELD uniqueId                AS INTEGER    /* The UNIQUE-ID attribute of the procedure handle */
  FIELD startDate               AS DATE       /* The date the procedure was started */
  FIELD startTime               AS INTEGER    /* The time the procedure was started */
  FIELD procedureVersion        AS CHARACTER  /* The version of the procedure running */
  FIELD procedureNarration      AS CHARACTER  /* a description of the running procedure if available */
  FIELD internalEntries         AS CHARACTER  /* a list of all the procedure internal entries */
  INDEX key1 IS PRIMARY PhysicalName LogicalName RunAttribute ChildDataKey onAppserver
  INDEX key2 procedureType PhysicalName LogicalName RunAttribute ChildDataKey onAppserver
  .

  DEFINE TEMP-TABLE ttProcDependancy
      FIELD parentProcedureHandle AS HANDLE
      FIELD childProcedureHandle  AS HANDLE
      FIELD parentType            AS CHARACTER
      FIELD childType             AS CHARACTER
      INDEX idx1 parentProcedureHandle
      INDEX idx2 childProcedureHandle
      INDEX idx3 parentType
      INDEX idx4 childType.
  &GLOBAL-DEFINE ttPersist
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


