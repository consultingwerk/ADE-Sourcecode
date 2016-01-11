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
  File: afauditlgp.p

  Description:  Audit Log update procedure

  Purpose:      To update audit log - usually called from triggers.

  Parameters:   input action - create, delete or write
                input new buffer handle
                input old buffer handle

  History:
  --------
  (v:010000)    Task:    90000034   UserRef:    
                Date:   26/03/2001  Author:     Anthony Swindells

  Update Notes: Created from Template rytemprocp.p

  (v:010002)    Task:   101000035   UserRef:    
                Date:   09/28/2001  Author:     Johan Meyer

  Update Notes: Change use the information in entity_key_field for tables that do not have object numbers.

  (v:010001)    Task:   101000008   UserRef:    
                Date:   08/17/2001  Author:     Pieter J Meyer

  Update Notes: Generic Audits and Comments

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afauditlgp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010002


/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{af/sup2/afglobals.i}

DEFINE INPUT PARAMETER pcAction                       AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcEntityMnemonic               AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER phNewBuffer                    AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER phOldBuffer                    AS HANDLE     NO-UNDO.

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
         HEIGHT             = 7.05
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE iLoopNum              AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoopFields           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cBufferValues         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cKeyFieldValue        AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hOldBufferField       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hNewBufferField       AS HANDLE     NO-UNDO.

DEFINE VARIABLE cBufferFieldName      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBufferFieldValueNew  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBufferFieldValueOld  AS CHARACTER  NO-UNDO.

DEFINE VARIABLE dCurrentUserObj       AS DECIMAL    NO-UNDO.

DEFINE BUFFER b_gsc_entity_mnemonic FOR gsc_entity_mnemonic.

ASSIGN
  iLoopNum          = 0
  iLoopFields       = 0
  cBufferValues     = "":U
  cKeyFieldValue    = "":U
  .

IF LOOKUP(pcAction,"CREATE,WRITE,DELETE":U) > 0
AND VALID-HANDLE(phNewBuffer)
AND VALID-HANDLE(phOldBuffer)
THEN DO:

  FIND FIRST b_gsc_entity_mnemonic NO-LOCK
    WHERE b_gsc_entity_mnemonic.entity_mnemonic = pcEntityMnemonic
    NO-ERROR.
  IF NOT AVAILABLE b_gsc_entity_mnemonic
  THEN LEAVE.

  /*put the appropriate identifying field name in cKeyFieldValue*/
  IF b_gsc_entity_mnemonic.table_has_object_field AND b_gsc_entity_mnemonic.entity_object_field <> "" THEN
    ASSIGN
      cKeyFieldValue = b_gsc_entity_mnemonic.entity_object_field.
  ELSE IF b_gsc_entity_mnemonic.entity_key_field <> "" THEN
    ASSIGN
      cKeyFieldValue = b_gsc_entity_mnemonic.entity_key_field.

  cKeyFieldValue = REPLACE(cKeyFieldValue,'~,':U,CHR(2)).

  IF iLoopFields = 0
  AND phOldBuffer:AVAILABLE
  THEN
    ASSIGN iLoopFields = phOldBuffer:NUM-FIELDS.

  IF iLoopFields = 0
  AND phNewBuffer:AVAILABLE
  THEN
    ASSIGN iLoopFields = phNewBuffer:NUM-FIELDS.

  IF iLoopFields <> 0
  THEN DO iLoopNum = 1 TO iLoopFields:

    ASSIGN
      cBufferFieldName = "":U
      .

    IF phNewBuffer:AVAILABLE
    THEN DO:
      ASSIGN
        hNewBufferField = phNewBuffer:BUFFER-FIELD(iLoopNum)
        NO-ERROR.
      IF cBufferFieldName = "":U
      THEN
        ASSIGN
          cBufferFieldName = hNewBufferField:NAME.
      
      /*if the fieldname is in cKeyFieldValue then replace the field name with the field value in cKeyFieldValue*/
      IF LOOKUP(cBufferFieldName,cKeyFieldValue,CHR(2)) > 0 THEN
        ASSIGN
          ENTRY(LOOKUP(cBufferFieldName,cKeyFieldValue,CHR(2)),cKeyFieldValue,CHR(2)) = STRING(hNewBufferField:BUFFER-VALUE).
    END.
    ELSE
      ASSIGN
        hNewBufferField = ?
        NO-ERROR.

    IF phOldBuffer:AVAILABLE
    THEN DO:
      ASSIGN
        hOldBufferField = phOldBuffer:BUFFER-FIELD(iLoopNum)
        NO-ERROR.
      IF cBufferFieldName = "":U
      THEN
        ASSIGN
          cBufferFieldName = hOldBufferField:NAME.
      /*if the fieldname is in cKeyFieldValue then replace the field name with the field value in cKeyFieldValue*/
      IF LOOKUP(cBufferFieldName,cKeyFieldValue,CHR(2)) > 0 THEN
        ASSIGN
          ENTRY(LOOKUP(cBufferFieldName,cKeyFieldValue,CHR(2)),cKeyFieldValue,CHR(2)) = STRING(hOldBufferField:BUFFER-VALUE).
    END.
    ELSE
      ASSIGN
        hOldBufferField = ?
        NO-ERROR.

    /* cBufferFieldValueNew is set to unknown so the ASSIGN code below is skipped for BLOB/CLOB fields */
    cBufferFieldValueNew = ?.
    IF VALID-HANDLE(hNewBufferField) THEN
      IF hNewBufferField:DATA-TYPE = "BLOB":U OR hNewBufferField:DATA-TYPE = "CLOB":U THEN
         ASSIGN cBufferFieldValueOld = "":U cBufferFieldValueNew = "":U.

    IF cBufferFieldValueNew = ? AND VALID-HANDLE(hOldBufferField) THEN
      IF hOldBufferField:DATA-TYPE = "BLOB":U OR hOldBufferField:DATA-TYPE = "CLOB":U THEN
         ASSIGN cBufferFieldValueOld = "":U cBufferFieldValueNew = "":U.     

    IF cBufferFieldValueNew = ? THEN DO:
       IF LOOKUP(pcAction,"DELETE":U) > 0 THEN DO:
         ASSIGN
           cBufferFieldValueOld = (IF VALID-HANDLE(hNewBufferField) THEN hNewBufferField:BUFFER-VALUE ELSE "":U)
           cBufferFieldValueNew = (IF VALID-HANDLE(hOldBufferField) THEN hOldBufferField:BUFFER-VALUE ELSE "":U)
         .
       END.
       ELSE DO:
         ASSIGN
           cBufferFieldValueNew = (IF VALID-HANDLE(hNewBufferField) THEN hNewBufferField:BUFFER-VALUE ELSE "":U)
           cBufferFieldValueOld = (IF VALID-HANDLE(hOldBufferField) THEN hOldBufferField:BUFFER-VALUE ELSE "":U)
         .
       END.
    END.

    IF cBufferFieldName <> "":U
    AND ( ( LOOKUP(pcAction,"WRITE":U) > 0 AND cBufferFieldValueNew <> cBufferFieldValueOld )
      OR  ( LOOKUP(pcAction,"CREATE,DELETE":U) > 0 ) )
    THEN DO:
      ASSIGN
        cBufferValues = cBufferValues
                      + (IF iLoopNum > 1 AND cBufferValues <> "":U THEN CHR(5) ELSE "":U)
                      + cBufferFieldName
                      + CHR(6)
                      + (IF cBufferFieldValueNew = ? THEN "?":U ELSE cBufferFieldValueNew)
                      + CHR(6)
                      + (IF cBufferFieldValueOld  = ? THEN "?":U ELSE cBufferFieldValueOld)
                      .
    END.

  END.

  IF (b_gsc_entity_mnemonic.entity_object_field <> "":U OR b_gsc_entity_mnemonic.entity_key_field <> "":U) AND cKeyFieldValue <> "":U
  THEN DO:

    ASSIGN
      dCurrentUserObj = DECIMAL( DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager ,INPUT "CurrentUserObj" ,INPUT NO) ).

    CREATE gst_audit. /* gst_audit.audit_obj = getNextObj() */
    ASSIGN
      gst_audit.audit_date              = TODAY
      gst_audit.audit_time              = TIME
      gst_audit.audit_user_obj          = dCurrentUserObj
      gst_audit.owning_entity_mnemonic  = pcEntityMnemonic
      gst_audit.owning_reference        = cKeyFieldValue
      gst_audit.audit_action            = (IF pcAction = "CREATE":U THEN "CRE":U
                                      ELSE IF pcAction = "DELETE":U THEN "DEL":U
                                      ELSE IF pcAction = "WRITE":U  THEN "AME":U
                                                                    ELSE "OTH":U)
      gst_audit.old_detail              = cBufferValues
      gst_audit.program_name            = PROGRAM-NAME(2)
      gst_audit.program_procedure       = "":U
      .

    /* Find the originating calling routine */
    prgBlock:
    DO iLoopNum = 3 TO 10:
      IF gst_audit.program_procedure <> "":U
      OR PROGRAM-NAME(iLoopNum)      = ?
      OR PROGRAM-NAME(iLoopNum)      = "":U
      THEN LEAVE prgBlock.
      /* When a SDO fires off the trigger code the 3rd entry will be a ADM2 program i.e. adm2/query.p */
      /* The program_procedure value should therefor contain the SDO and not the ADM2 program name    */
      /* For triggers being executed from standard code, the program executing the triggers would     */
      /* usually be the 3rd entry in the PROGRAM-NAME stack                                           */
      IF  INDEX(PROGRAM-NAME(iLoopNum),"adm~/":U)  = 0
      AND INDEX(PROGRAM-NAME(iLoopNum),"adm~\":U)  = 0
      AND INDEX(PROGRAM-NAME(iLoopNum),"adm2~/":U) = 0
      AND INDEX(PROGRAM-NAME(iLoopNum),"adm2~\":U) = 0
      OR (PROGRAM-NAME(iLoopNum + 1) = ? OR PROGRAM-NAME(iLoopNum + 1) = "":U)
      THEN DO:
        ASSIGN gst_audit.program_procedure = PROGRAM-NAME(iLoopNum).
        LEAVE prgBlock.
      END.
    END.

    IF gst_audit.program_procedure = "":U
    THEN
      ASSIGN
        gst_audit.program_procedure = PROGRAM-NAME(3).

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


