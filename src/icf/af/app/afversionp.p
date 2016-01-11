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
  File: afversionp.p

  Description:  Data Versioning Procedure

  Purpose:      Data Versioning Procedure

  Parameters:   input table buffer handle
                input table fla
                input table action

  History:
  --------
  (v:010000)    Task:   101000035   UserRef:    
                Date:   09/18/2001  Author:     Johan Meyer

  Update Notes: Change Procedure to handle multiple fields in
                gsc_entity_mnemonic.entity_key_field.
                If there are multiple fields in entity_key_field, then store a CHR(1) seperated list
                of values in gst_record_version.key_field_value

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afversionp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{af/sup2/afglobals.i}

{af/sup2/afcheckerr.i &define-only = YES}

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
         HEIGHT             = 28.57
         WIDTH              = 60.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE INPUT PARAMETER phBuffer                 AS HANDLE       NO-UNDO.
DEFINE INPUT PARAMETER pcFLA                    AS CHARACTER    NO-UNDO.  
DEFINE INPUT PARAMETER pcAction                 AS CHARACTER    NO-UNDO.   

DEFINE VARIABLE cKeyField                       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cFieldValue                     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hField                          AS HANDLE       NO-UNDO.
DEFINE VARIABLE cErrorText                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cUserLogin                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iLoop                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE iSeqSiteDiv                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iSeqSiteRev                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cRelation                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFLA                            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCount                          AS INTEGER    NO-UNDO.
DEFINE VARIABLE cSite                           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iNumChar                        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cConvSite                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrRelate                     AS CHARACTER  NO-UNDO.
/* These variables are here to cater for the specific issue that we have with
   ryc_smartobject and performance */

DEFINE VARIABLE cTableList AS CHARACTER  
  INITIAL "RYCPO,RYCPA,RYCOI,RYCSM,RYCAV,RYCUE,GSMTM,GSMOM,RYMWT":U
  NO-UNDO.

DEFINE VARIABLE cRelateOn AS CHARACTER
  EXTENT 9
  INITIAL ["container_smartobject_obj:RYCSO":U,
           "container_smartobject_obj:RYCSO":U,
           "container_smartobject_obj:RYCSO":U,
           "container_smartobject_obj:RYCSO":U,
           "primary_smartobject_obj:RYCSO":U,
           "container_smartobject_obj:RYCSO":U,
           "object_obj:GSCOB,menu_item_obj:GSMMI":U,
           "object_obj:GSCOB,menu_structure_obj:GSMMS":U,
           "smartobject_obj:RYCSO":U]
  NO-UNDO.


FIND FIRST gsc_entity_mnemonic NO-LOCK
     WHERE gsc_entity_mnemonic.entity_mnemonic = pcFLA
     NO-ERROR. 
IF NOT AVAILABLE (gsc_entity_mnemonic) OR 
   gsc_entity_mnemonic.version_data = NO THEN
  RETURN.

/* If this is a special table, handle it accordingly */
IF CAN-DO(cTableList,pcFLA) THEN 
DO:
  IF pcFLA = "RYMWT":U THEN
  DO:
    hField = phBuffer:BUFFER-FIELD("object_name":U).
    FIND FIRST ryc_smartobject NO-LOCK
      WHERE ryc_smartobject.object_filename = hField:BUFFER-VALUE
      NO-ERROR.
    IF NOT AVAILABLE(ryc_smartobject) THEN
      RETURN.
    ELSE
      phBuffer = BUFFER ryc_smartobject:HANDLE.
  END.
  cRelation = cRelateOn[LOOKUP(pcFLA,cTableList)].
END.
ELSE
  cRelation = "STANDARD":U.



DO iCount = 1 TO NUM-ENTRIES(cRelation):
  cCurrRelate = ENTRY(iCount,cRelation).
  /* If we're going to do this the standard way, handle it */
  IF cCurrRelate = "STANDARD":U THEN
  DO:
    IF gsc_entity_mnemonic.TABLE_has_object_field AND
       gsc_entity_mnemonic.entity_object_field <> "":U THEN
      ASSIGN cKeyField = gsc_entity_mnemonic.entity_object_field.
    ELSE
      ASSIGN cKeyField = gsc_entity_mnemonic.entity_key_field.
  END.
  ELSE
  DO:
    cKeyField = ENTRY(1,cCurrRelate,":":U).
    pcFLA = ENTRY(2,cCurrRelate,":":U).
  END.

  ASSIGN
    hField = ?
    .

  /* if gsc_entity_mnemonic.entity_key_field represents a multi-field identifier,then cKeyField will 
  contain a comma-seperated list of field names. In that case, build a cFieldvalue based on the field list*/
  IF cKeyField <> "":U THEN
  DO:
    IF NUM-ENTRIES(cKeyField) >= 2 THEN
    DO iLoop = 1 TO NUM-ENTRIES(cKeyField):
      ASSIGN
        hField  = phBuffer:BUFFER-FIELD(ENTRY(1,cKeyField)) NO-ERROR.
      IF VALID-HANDLE(phBuffer) AND VALID-HANDLE(hField) AND phBuffer:AVAILABLE THEN
        ASSIGN
          cFieldValue = cFieldValue + CHR(1) WHEN cFieldValue <> "":U
          cFieldValue = cFieldValue + STRING(hField:BUFFER-VALUE).
    END.
    ELSE DO:
      ASSIGN
        hField  = phBuffer:BUFFER-FIELD(cKeyField) NO-ERROR
        .       
      IF VALID-HANDLE(phBuffer) AND VALID-HANDLE(hField) AND phBuffer:AVAILABLE THEN
        ASSIGN
          cFieldValue = STRING(hField:BUFFER-VALUE).
    END.
  END.

  IF VALID-HANDLE(phBuffer) AND phBuffer:AVAILABLE AND cFieldValue <> "":U THEN
  DO:
    cUserLogin = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                  INPUT "currentUserLogin":U,
                                  INPUT NO).

    DEFINE BUFFER bgst_record_version FOR gst_record_version.
    trn-block:
    DO FOR bgst_record_version TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:
      FIND FIRST bgst_record_version EXCLUSIVE-LOCK
           WHERE bgst_record_version.entity_mnemonic = pcFLA
             AND bgst_record_version.key_field_value = cFieldValue
           NO-ERROR.
      IF NOT AVAILABLE bgst_record_version THEN
      DO:

        /* Get the current site number */
        RUN getSiteNumber IN gshGenManager
          (OUTPUT iSeqSiteRev).

        /* Switch it round so we can put the right stuff
           in the mantissa of the version number seq */
        cSite = STRING(iSeqSiteRev).
        iSeqSiteDiv = 1.
        DO iNumChar = LENGTH(cSite) TO 1 BY -1:
          cConvSite = cConvSite + SUBSTRING(cSite,iNumChar,1).
          iSeqSiteDiv = iSeqSiteDiv * 10.
        END.

        iSeqSiteRev = INTEGER(cConvSite).


        CREATE bgst_record_version NO-ERROR.
        {af/sup2/afcheckerr.i &no-return = YES}    
        cErrorText = cMessageList.
        IF cErrorText <> "":U THEN UNDO trn-block, LEAVE trn-block.
        /* Seed the last version number with the site number */
        ASSIGN
          bgst_record_version.last_version_number_seq = iSeqSiteRev / iSeqSiteDiv
          .
      END.

      ASSIGN
        bgst_record_version.entity_mnemonic = pcFLA
        bgst_record_version.KEY_field_value = cFieldValue
        bgst_record_version.last_version_number_seq = bgst_record_version.last_version_number_seq + 1
        bgst_record_version.version_number_seq = bgst_record_version.last_version_number_seq
        bgst_record_version.version_date = TODAY
        bgst_record_version.version_time = TIME
        bgst_record_version.version_user = cUserLogin
        bgst_record_version.deletion_flag = (INDEX(pcAction,"delete":U) <> 0)
        .          

      VALIDATE bgst_record_version NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}    
      cErrorText = cMessageList.
      IF cErrorText <> "":U THEN UNDO trn-block, LEAVE trn-block.

    END. /* trn-block */
  END. /* valid buffer and field */

END. /* iCount = 1 TO NUM-ENTRIES(cRelation) */

IF ERROR-STATUS:ERROR THEN
  RETURN ERROR cErrorText.
ELSE
  RETURN cErrorText.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


