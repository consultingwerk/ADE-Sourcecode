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
/*---------------------------------------------------------------------------------
  File: afsetprplp.p

  Description:  Proxy for setPropertyList in SessionMgr

  Purpose:      Proxy for setPropertyList in Session Manager.

  Parameters:   input property name list
                input property value list

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   05/06/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

  (v:010001)    Task:        5933   UserRef:    
                Date:   12/06/2000  Author:     Anthony Swindells

  Update Notes: Write Astra 2 Profile Manager and Translation Manager / update supporting
                files

  (v:010002)    Task:        6063   UserRef:    
                Date:   23/06/2000  Author:     Anthony Swindells

  Update Notes: trim property

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afsetprplp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010002


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE INPUT PARAMETER  pcPropertyList          AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcPropertyValues        AS CHARACTER  NO-UNDO.

{af/sup2/afglobals.i}     /* Astra global shared variables */

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
         HEIGHT             = 6.38
         WIDTH              = 44.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cProperty       AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bgsm_server_context FOR gsm_server_context.

  DO iLoop = 1 TO NUM-ENTRIES(pcPropertyList):
    ASSIGN cProperty = TRIM(ENTRY(iLoop,pcPropertyList)).

    trn-block:
    DO FOR bgsm_server_context TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

      FIND FIRST bgsm_server_context EXCLUSIVE-LOCK
           WHERE bgsm_server_context.session_obj = gsdSessionObj
             AND bgsm_server_context.CONTEXT_name = cProperty
           NO-ERROR.
      IF NOT AVAILABLE bgsm_server_context THEN
      DO:
        CREATE bgsm_server_context NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
        ASSIGN
          bgsm_server_context.session_obj = gsdSessionObj
          bgsm_server_context.CONTEXT_name = cProperty
          .
      END.

      ASSIGN
        bgsm_server_context.CONTEXT_id_date = TODAY
        bgsm_server_context.CONTEXT_id_time = TIME
        bgsm_server_context.CONTEXT_value = ENTRY(iLoop,pcPropertyValues,CHR(3))
        .

      VALIDATE bgsm_server_context NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.

    END.

    IF ERROR-STATUS:ERROR THEN RETURN ERROR RETURN-VALUE.

  END.  /* iLoop = 1 TO NUM-ENTRIES(pcPropertyList) */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


