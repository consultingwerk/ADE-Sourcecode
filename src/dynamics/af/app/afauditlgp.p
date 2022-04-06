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
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
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
         HEIGHT             = 12.91
         WIDTH              = 63.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE iLoopNum              AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoopFields           AS INTEGER    NO-UNDO.
define variable iExtentLoop           as integer    no-undo.
define variable iExtents              as integer    no-undo.
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
AND VALID-HANDLE(phNewBuffer) AND VALID-HANDLE(phOldBuffer)
THEN DO:
  FIND b_gsc_entity_mnemonic NO-LOCK
    WHERE b_gsc_entity_mnemonic.entity_mnemonic = pcEntityMnemonic
    NO-ERROR.
  IF NOT AVAILABLE b_gsc_entity_mnemonic
  THEN LEAVE.
  
  /* Put the appropriate identifying field name in cKeyFieldValue*/
  IF b_gsc_entity_mnemonic.table_has_object_field AND b_gsc_entity_mnemonic.entity_object_field <> "" THEN
    assign cKeyFieldValue = b_gsc_entity_mnemonic.entity_object_field.
  ELSE IF b_gsc_entity_mnemonic.entity_key_field <> "" THEN
    assign cKeyFieldValue = b_gsc_entity_mnemonic.entity_key_field.
  
  cKeyFieldValue = REPLACE(cKeyFieldValue,'~,':U,CHR(2)).
  
  /* Determine number of fields to loop through.
     Only attempt to audit if at least one buffer is 
     available.
   */
  if phNewBuffer:available or phOldBuffer:available then
      iLoopFields = phOldBuffer:NUM-FIELDS.
  
  IF iLoopFields <> 0 THEN 
  FIELD-LOOP:
  DO iLoopNum = 1 TO iLoopFields:
    assign cBufferFieldName = "":U
           iExtents = 0
           hOldBufferField = ?.
    
    /* Get the names of the fields in the buffer.
       We can get these names off either buffer, without
       worrying about whether the record is available. 
     */
    hNewBufferField = phNewBuffer:BUFFER-FIELD(iLoopNum) NO-ERROR.
    
    iExtents = hNewBufferField:extent.
    if iExtents gt 0 then
    do iExtentLoop = 1 to iExtents:
        cBufferFieldName = cBufferFieldName
                         + (if iExtentLoop eq 1 then '':u else ';':u)
                         /* Extent field names are consistent with their DataField representation */
                         + hNewBufferField:name + string(iExtentLoop).
    end.    /* extent loop */
    else
        cBufferFieldName = hNewBufferField:NAME.
    
    /* We can't/don't audit BLOB and CLOB fields. */
    if can-do('Blob,Clob':u, hNewBufferField:Data-type) then
        next FIELD-LOOP.
    
    /* We use this buffer handle later for other stuff. 
       Clean it out now.
     */
    hNewBufferField = ?.
    
    /* New buffer typically available on CREATE, WRITE and DELETE.
       
       However, there is nothing stopping this procedure being called
       with the new buffer not having an available record, and/or the
       old buffer having (or not having) a record available. We need 
       to ensure that this code works fine whether the new (and old)
       buffers have available records or not.       
     */
    IF phNewBuffer:AVAILABLE
    THEN DO:
      hNewBufferField = phNewBuffer:BUFFER-FIELD(iLoopNum) No-error.
      /* if the fieldname is in cKeyFieldValue then replace the field name with the field value in cKeyFieldValue*/
      IF LOOKUP(cBufferFieldName,cKeyFieldValue,CHR(2)) > 0 THEN
        assign ENTRY(LOOKUP(cBufferFieldName,cKeyFieldValue,CHR(2)),cKeyFieldValue,CHR(2)) = STRING(hNewBufferField:BUFFER-VALUE).
    END.    /* new buffer available */
    
    /* No ELSE here because WRITE actions have both new and old available */
        /* Old buffer available on WRITE.
       No old buffer available on CREATE and DELETE.
     */
    IF phOldBuffer:AVAILABLE
    THEN DO:
      hOldBufferField = phOldBuffer:BUFFER-FIELD(iLoopNum) NO-ERROR.
      
      /*if the fieldname is in cKeyFieldValue then replace the field name with the field value in cKeyFieldValue*/
      IF LOOKUP(cBufferFieldName,cKeyFieldValue,CHR(2)) > 0 THEN
        assign ENTRY(LOOKUP(cBufferFieldName,cKeyFieldValue,CHR(2)),cKeyFieldValue,CHR(2)) = STRING(hOldBufferField:BUFFER-VALUE).
    END.    /* Old buffer available */
    
    IF LOOKUP(pcAction,"DELETE":U) > 0 THEN DO:
       /* Be careful here: the Old variable gets the New buffer,
          and vice-versa. 
          
          This is (probably) because only the New buffer is available
          on deletes, and it may be more logical to think of the
          new value being the missing (i.e. deleted) record, and so
          we want to transpose the value from the New buffer into
          the Old variable.
           
          [PJ] Not 100% sure that this is the reason, but I think 
               this is why.
        */
       
       /* Create an empty value for cases where the
          buffer field isn't available/valid.
        */
       if iExtents eq 0 then 
           assign cBufferFieldValueNew = (IF VALID-HANDLE(hOldBufferField) THEN hOldBufferField:BUFFER-VALUE ELSE "":U)
                  cBufferFieldValueOld = (IF VALID-HANDLE(hNewBufferField) THEN hNewBufferField:BUFFER-VALUE ELSE "":U).
       else
       do:
           if not phNewBuffer:available then
               cBufferFieldValueOld = fill(chr(3), iExtents - 1).
           else
           do iExtentLoop = 1 to iExtents:
               cBufferFieldValueOld = (if iExtentLoop eq 1 then '':u else (cBufferFieldValueOld + chr(3)))
                                    + (if hNewBufferField:buffer-value(iExtentLoop) eq ? then '?':u else hNewBufferField:buffer-value(iExtentLoop)).
           end.    /* extent loop */
           
           if not phOldBuffer:available then
               cBufferFieldValueNew = fill(chr(3), iExtents - 1).           
           else
           do iExtentLoop = 1 to iExtents:
               cBufferFieldValueNew = (if iExtentLoop eq 1 then '':u else (cBufferFieldValueNew + chr(3)))
                                    + (if hOldBufferField:buffer-value(iExtentLoop) eq ? then '?':u else hOldBufferField:buffer-value(iExtentLoop)).
           end.    /* extent loop */
        end.    /* field has extents */
    END.    /* Delete */
    ELSE DO:
       /* Create an empty value for cases where the
          buffer field isn't available/valid.
        */
        if iExtents eq 0 then
           assign cBufferFieldValueNew = (IF VALID-HANDLE(hNewBufferField) THEN hNewBufferField:BUFFER-VALUE ELSE "":U)
                  cBufferFieldValueOld = (IF VALID-HANDLE(hOldBufferField) THEN hOldBufferField:BUFFER-VALUE ELSE "":U).
        else
        do:                                                    
            if not phNewBuffer:available then
                cBufferFieldValueNew = fill(chr(3), iExtents - 1).
            else
            do iExtentLoop = 1 to iExtents:
                cBufferFieldValueNew = (if iExtentLoop eq 1 then '':u else (cBufferFieldValueNew + chr(3)))                     
                                     + (if hNewBufferField:buffer-value(iExtentLoop) eq ? then '?':u else hNewBufferField:buffer-value(iExtentLoop)).
            end.    /* extent loop */

            if not phOldBuffer:available then
                cBufferFieldValueOld = fill(chr(3), iExtents - 1).
            else
            do iExtentLoop = 1 to iExtents:
                cBufferFieldValueOld = (if iExtentLoop eq 1 then '':u else (cBufferFieldValueOld + chr(3)))
                                     + (if hOldBufferField:buffer-value(iExtentLoop) eq ? then '?':u else hOldBufferField:buffer-value(iExtentLoop)).
            end.    /* extent loop */
        end.    /* field has extents */
    END.    /* Create/Write */  
    
    IF cBufferFieldName <> "":U
    AND ( ( LOOKUP(pcAction,"WRITE":U) > 0 AND cBufferFieldValueNew <> cBufferFieldValueOld )
      OR  ( LOOKUP(pcAction,"CREATE,DELETE":U) > 0 ) )
    THEN DO:
        if iExtents eq 0 then
            assign cBufferValues = cBufferValues
                                 + (IF iLoopNum > 1 AND cBufferValues <> "":U THEN CHR(5) ELSE "":U)
                                 + cBufferFieldName
                                 + CHR(6)
                                 + (IF cBufferFieldValueNew = ? THEN "?":U ELSE cBufferFieldValueNew)
                                 + CHR(6)
                                 + (IF cBufferFieldValueOld  = ? THEN "?":U ELSE cBufferFieldValueOld).
        else
        do iExtentLoop = 1 to iExtents:
            /* We've made sure above that there will always be
               the right number of entries here.
             */
            if entry(iExtentLoop, cBufferFieldValueNew, chr(3)) ne entry(iExtentLoop, cBufferFieldValueOld, chr(3)) then
                cBufferValues = cBufferValues
                              + (if iLoopNum gt 1 and cBufferValues ne '':u then chr(5) else '':u)
                              + entry(iExtentLoop, cBufferFieldName, ';':u)
                              + chr(6)
                              + entry(iExtentLoop, cBufferFieldValueNew, chr(3))
                              + chr(6)
                              + entry(iExtentLoop, cBufferFieldValueOld, chr(3)).
        end.    /* extent loop */
    END.    /* buffer fieldname exists */
  END.    /* FIELD-LOOP: loop through fields */
  
  IF (b_gsc_entity_mnemonic.entity_object_field <> "":U OR b_gsc_entity_mnemonic.entity_key_field <> "":U) AND 
      cKeyFieldValue <> "":U THEN 
  DO:
      dCurrentUserObj = DECIMAL( DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager ,INPUT "CurrentUserObj" ,INPUT NO) ) NO-ERROR.

    CREATE gst_audit NO-ERROR. /* gst_audit.audit_obj = getNextObj() */
    /* Catch errors from the create trigger */
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

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
      NO-ERROR.
    /* Catch errors from field assignment, like unique index errors */
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.

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
        ASSIGN gst_audit.program_procedure = PROGRAM-NAME(iLoopNum) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
        LEAVE prgBlock.
      END.
    END.

    IF gst_audit.program_procedure = "":U THEN
    DO:
      ASSIGN gst_audit.program_procedure = PROGRAM-NAME(3) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    END.

    /* Catch errors from the write trigger */
    VALIDATE gst_audit NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
  END.    /* ntity has a key field, and there's a vallue recorded for it */
END.    /* there's a valid before and after image buffer, and this is an auditable action */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


