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
  File: gscemcrrcp.p

  Description:  Entity Mnemonic Import Create Rec Proc

  Purpose:      Procedure to create gsc_entity_mnemonic records for tables names passed
                to the procedure in temp table records.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:   101000035   UserRef:    
                Date:   09/19/2001  Author:     Johan Meyer

  Update Notes: Add code to check for multi-field unique indexes to store in the entity_key_field
                field when populating the entity_mnemonic table.

  (v:010001)    Task:    90000065   UserRef:    posse
                Date:   24/04/2001  Author:     Tammy St Pierre

  Update Notes: Removing debugging message

  (v:010002)    Task:    90000068   UserRef:    posse
                Date:   25/04/2001  Author:     Tammy St Pierre

  Update Notes: Add code to only set narration if it is blank.

  (v:010003)    Task:    90000073   UserRef:    posse
                Date:   26/04/2001  Author:     Tammy St Pierre

  Update Notes: Adding fields

  (v:010004)    Task:    90000127   UserRef:    posse
                Date:   08/05/2001  Author:     Tammy St Pierre

  Update Notes: Fix bug to take 0 prefix length and blank field name separator

  (v:010006)    Task:    90000163   UserRef:    
                Date:   18/07/2001  Author:     Anthony Swindells

  Update Notes: Entity Table Normalization

  (v:010007)    Task:           0   UserRef:    IZ#2699
                Date:   10/29/2001  Author:     Mark Davies (MIP)

  Update Notes: Made changes to update the following fields:
                display_field_label
                display_field_column_label
                display_field_format

  (v:010008)    Task:           0   UserRef:    
                Date:   10/29/2001  Author:     Mark Davies (MIP)

  Update Notes: Removed fixes made for V:010007 since it was intended to leave these fields blank.

--------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gscemcrrcp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{af/sup2/afglobals.i}

/* temp table of tables to create gsc_entity_mnemonic records for */
DEFINE TEMP-TABLE ttImport
  FIELD cDatabase      AS CHARACTER
  FIELD cTable         AS CHARACTER
  FIELD cDumpName      AS CHARACTER
  FIELD cDescription   AS CHARACTER
  FIELD lImport        AS LOGICAL.

DEFINE INPUT PARAMETER  plAuto          AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER  piPrefix        AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER  pcSeparator     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER  pcAuditing      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER  plDisplayFields AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR ttImport.
DEFINE OUTPUT PARAMETER pcError AS CHARACTER NO-UNDO.

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
         HEIGHT             = 6.81
         WIDTH              = 63.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE cIndexInfo  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cTableBase  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cTableIndex AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hField      AS HANDLE       NO-UNDO.
DEFINE VARIABLE hTable      AS HANDLE       NO-UNDO.
DEFINE VARIABLE iFieldLoop  AS INTEGER      NO-UNDO.
DEFINE VARIABLE iIdx        AS INTEGER      NO-UNDO.
DEFINE VARIABLE iNumIndex   AS INTEGER      NO-UNDO.
DEFINE VARIABLE iLoop       AS INTEGER      NO-UNDO.
DEFINE VARIABLE iFieldOrder AS INTEGER      NO-UNDO.

/* Reads through ttImport temp table records and creates/updates entity mnemonic
   records for each table in ttImport */
TranBlock:
DO TRANSACTION ON ERROR UNDO TranBlock, LEAVE TranBlock:

  FOR EACH ttImport:

    FIND FIRST gsc_entity_mnemonic EXCLUSIVE-LOCK 
         WHERE gsc_entity_mnemonic.entity_mnemonic = ttImport.cDumpName
         NO-ERROR.
    IF NOT AVAILABLE gsc_entity_mnemonic THEN
    DO:
      CREATE gsc_entity_mnemonic.
      ASSIGN gsc_entity_mnemonic.entity_mnemonic = CAPS(ttImport.cDumpName).
    END.  /* if not avail */
    ASSIGN
      gsc_entity_mnemonic.entity_mnemonic_description = ttImport.cTable
      gsc_entity_mnemonic.entity_dbname = ttImport.cDatabase
        WHEN gsc_entity_mnemonic.entity_dbname = '':U 
      gsc_entity_mnemonic.auto_properform_strings = plAuto
      gsc_entity_mnemonic.entity_narration = ttImport.cDescription
        WHEN gsc_entity_mnemonic.entity_narration = '':U
      gsc_entity_mnemonic.table_prefix_length = piPrefix
      gsc_entity_mnemonic.field_name_separator = pcSeparator.

    IF gsc_entity_mnemonic.entity_mnemonic_short_desc = '':U THEN 
    DO:
      IF pcSeparator NE '':U THEN
        ASSIGN gsc_entity_mnemonic.entity_mnemonic_short_desc = REPLACE(SUBSTRING(gsc_entity_mnemonic.entity_mnemonic_description, piPrefix + 1), pcSeparator, ' ':U).
      ELSE
        ASSIGN gsc_entity_mnemonic.entity_mnemonic_short_desc = SUBSTRING(gsc_entity_mnemonic.entity_mnemonic_description, piPrefix + 1).
    END.  /* if short desc blank */

    IF pcAuditing NE 'I':U THEN
      ASSIGN gsc_entity_mnemonic.auditing_enabled = IF pcAuditing = 'Y':U THEN TRUE ELSE FALSE.

    cTableBase = SUBSTRING(ttImport.cTable, piPrefix + 1).
    CREATE BUFFER hTable FOR TABLE ttImport.cTable.

    iIdx = 0.
    cTableIndex = '':U.
    IndexBlock:
    DO WHILE TRUE:
      ASSIGN 
        iIdx = iIdx + 1
        cIndexInfo = hTable:INDEX-INFORMATION(iIdx).

      IF cIndexInfo = ? THEN LEAVE IndexBlock.

      cTableIndex = cTableIndex + (IF cTableIndex NE '':U THEN CHR(3) ELSE '':U) +
          cIndexInfo.  
    END.  /* IndexBlock */

    /* entity_description_field */
    IF gsc_entity_mnemonic.entity_description_field = '':U THEN DO:
      FieldLoop:
      DO iFieldLoop = 1 TO hTable:NUM-FIELDS:
        hField = hTable:BUFFER-FIELD(iFieldLoop).

        IF hField:DATA-TYPE = 'character':U AND hField:KEY THEN
        DO:
          IF hField:NAME = cTableBase + '_description':U OR 
             hField:NAME = cTableBase + '_desc':U OR
             hField:NAME = cTableBase + '_name':U OR
             hField:NAME = cTableBase + '_short_name':U THEN
            ASSIGN gsc_entity_mnemonic.entity_description_field = hField:NAME.
        END.  /* if character key field */
      END.  /* fieldloop */

      IF gsc_entity_mnemonic.entity_description_field = '':U THEN 
      DO:
        FieldLoop:
        DO iFieldLoop = 1 TO hTable:NUM-FIELDS:
          hField = hTable:BUFFER-FIELD(iFieldLoop).

          IF hField:DATA-TYPE = 'character':U AND hField:KEY = YES THEN
          DO:
            IF hField:NAME MATCHES '*_description' OR
               hField:NAME MATCHES '*_desc' OR
               hField:NAME MATCHES '*_name' OR
               hField:NAME MATCHES '*_short_name' THEN 
               ASSIGN gsc_entity_mnemonic.entity_description_field = hField:NAME.
          END.  /* if character key field */
        END.  /* fieldloop */
      END.  /* if desc field still blank */

    END.  /* if desc field blank*/

    /*  entity_key_field */
    IF gsc_entity_mnemonic.entity_key_field = '':U THEN
    DO:
     /*check whether there is a character field in a unique single key field index with the specified naming convention*/
     FieldLoop:
      DO iFieldLoop = 1 TO hTable:NUM-FIELDS:
        hField = hTable:BUFFER-FIELD(iFieldLoop).

        IF hField:KEY AND LOOKUP(hField:DATA-TYPE, 'character':U) > 0 THEN 
        DO:
          IndexLoop:
          DO iNumIndex = 1 TO NUM-ENTRIES(cTableIndex, CHR(3)):
            cIndexInfo = ENTRY(iNumIndex, cTableIndex, CHR(3)).
            IF ENTRY(2, cIndexInfo) = '1':U AND 
              NUM-ENTRIES(cIndexInfo) = 6 AND 
              ENTRY(5, cIndexInfo) = hField:NAME AND 
              (hField:NAME = cTableBase + '_code':U OR 
               hField:NAME = cTableBase + '_reference':U OR
               hField:NAME = cTableBase + '_type':U OR
               hField:NAME = cTableBase + '_tla':U OR
               hField:NAME = cTableBase + '_number' OR
               hField:NAME = cTableBase + '_short_desc':U) THEN
            DO:
              ASSIGN gsc_entity_mnemonic.entity_key_field = hField:NAME.
              LEAVE FieldLoop.
            END.  /* unique single key field index */
            ELSE NEXT IndexLoop.
          END.  /* indexloop */
        END.  /* if key character field */
      END.  /* fieldloop */

      /*check whether there is a character field in a unique single key field index that MATCHES the specified naming convention*/
      IF gsc_entity_mnemonic.entity_key_field = '':U THEN
      DO:
        FieldLoop:
         DO iFieldLoop = 1 TO hTable:NUM-FIELDS:
           hField = hTable:BUFFER-FIELD(iFieldLoop).

           IF hField:KEY AND LOOKUP(hField:DATA-TYPE, 'character':U) > 0 THEN 
           DO:
             IndexLoop:
             DO iNumIndex = 1 TO NUM-ENTRIES(cTableIndex, CHR(3)):
               cIndexInfo = ENTRY(iNumIndex, cTableIndex, CHR(3)).
               IF ENTRY(2, cIndexInfo) = '1':U AND 
                 NUM-ENTRIES(cIndexInfo) = 6 AND 
                 ENTRY(5, cIndexInfo) = hField:NAME AND 
                 (hField:NAME MATCHES '*_code' OR
                  hField:NAME MATCHES '*_reference' OR
                  hField:NAME MATCHES '*_type' OR
                  hField:NAME MATCHES '*_tla' OR
                  hField:NAME MATCHES '*_number' OR
                  hField:NAME MATCHES '*_short_desc':U) THEN
               DO:
                 ASSIGN gsc_entity_mnemonic.entity_key_field = hField:NAME.
                 LEAVE FieldLoop.
               END.  /* unique single key field index */
               ELSE NEXT IndexLoop.
             END.  /* indexloop */
           END.  /* if key character field */
         END.  /* fieldloop */
      END.  /* if key field still blank */

      /*check whether there is a decimal or integer field in a unique single key field index with the specified naming convention*/
      IF gsc_entity_mnemonic.entity_key_field = '':U THEN
      DO:
        FieldLoop:
         DO iFieldLoop = 1 TO hTable:NUM-FIELDS:
           hField = hTable:BUFFER-FIELD(iFieldLoop).

           IF hField:KEY AND LOOKUP(hField:DATA-TYPE, 'decimal,integer':U) > 0 THEN 
           DO:
             IndexLoop:
             DO iNumIndex = 1 TO NUM-ENTRIES(cTableIndex, CHR(3)):
               cIndexInfo = ENTRY(iNumIndex, cTableIndex, CHR(3)).
               IF ENTRY(2, cIndexInfo) = '1':U AND 
                 NUM-ENTRIES(cIndexInfo) = 6 AND 
                 ENTRY(5, cIndexInfo) = hField:NAME AND 
                 (hField:NAME = cTableBase + '_code':U OR 
                  hField:NAME = cTableBase + '_reference':U OR
                  hField:NAME = cTableBase + '_type':U OR
                  hField:NAME = cTableBase + '_tla':U OR
                  hField:NAME = cTableBase + '_number' OR
                  hField:NAME = cTableBase + '_short_desc':U) THEN
               DO:
                 ASSIGN gsc_entity_mnemonic.entity_key_field = hField:NAME.
                 LEAVE FieldLoop.
               END.  /* unique single key field index */
               ELSE NEXT IndexLoop.
             END.  /* indexloop */
           END.  /* if key character field */
         END.  /* fieldloop */
      END.  /* if key field still blank */

      /*check whether there is a decimal or integer field in a unique single key field index that MATCHES the specified naming convention*/
      IF gsc_entity_mnemonic.entity_key_field = '':U THEN
      DO:
        FieldLoop:
         DO iFieldLoop = 1 TO hTable:NUM-FIELDS:
           hField = hTable:BUFFER-FIELD(iFieldLoop).

           IF hField:KEY AND LOOKUP(hField:DATA-TYPE, 'decimal,integer':U) > 0 THEN 
           DO:
             IndexLoop:
             DO iNumIndex = 1 TO NUM-ENTRIES(cTableIndex, CHR(3)):
               cIndexInfo = ENTRY(iNumIndex, cTableIndex, CHR(3)).
               IF ENTRY(2, cIndexInfo) = '1':U AND 
                 NUM-ENTRIES(cIndexInfo) = 6 AND 
                 ENTRY(5, cIndexInfo) = hField:NAME AND 
                 (hField:NAME MATCHES '*_code' OR
                  hField:NAME MATCHES '*_reference' OR
                  hField:NAME MATCHES '*_type' OR
                  hField:NAME MATCHES '*_tla' OR
                  hField:NAME MATCHES '*_number' OR
                  hField:NAME MATCHES '*_short_desc':U) THEN
               DO:
                 ASSIGN gsc_entity_mnemonic.entity_key_field = hField:NAME.
                 LEAVE FieldLoop.
               END.  /* unique single key field index */
               ELSE NEXT IndexLoop.
             END.  /* indexloop */
           END.  /* if key character field */
         END.  /* fieldloop */
      END.  /* if key field still blank */

      /*check whether the primary index is unique - if so assign the index's key fields - comma-sperated if more than one field*/
      IF gsc_entity_mnemonic.entity_key_field = '':U THEN
      DO:
        FieldLoop:
         DO iFieldLoop = 1 TO hTable:NUM-FIELDS:
           IndexLoop:
           DO iNumIndex = 1 TO NUM-ENTRIES(cTableIndex, CHR(3)):
             cIndexInfo = ENTRY(iNumIndex, cTableIndex, CHR(3)).
             IF ENTRY(2, cIndexInfo) = '1':U AND 
                ENTRY(3, cIndexInfo) = '1':U THEN
             DO:
               DO iLoop = 5 TO NUM-ENTRIES(cIndexInfo) BY 2:
                 ASSIGN 
                   gsc_entity_mnemonic.entity_key_field = gsc_entity_mnemonic.entity_key_field + ",":U WHEN gsc_entity_mnemonic.entity_key_field <> "":U
                   gsc_entity_mnemonic.entity_key_field = gsc_entity_mnemonic.entity_key_field + ENTRY(iLoop,cIndexInfo).
               END. /* iLoop */
               LEAVE FieldLoop.
             END.  /* unique single key field index */
             ELSE NEXT IndexLoop.
           END.  /* indexloop */
         END.  /* fieldloop */
      END.  /* if key field still blank */

      /*check any other unique index - if available assign the index's key fields - comma-sperated if more than one field*/
      IF gsc_entity_mnemonic.entity_key_field = '':U THEN
      DO:
        FieldLoop:
         DO iFieldLoop = 1 TO hTable:NUM-FIELDS:
           IndexLoop:
           DO iNumIndex = 1 TO NUM-ENTRIES(cTableIndex, CHR(3)):
             cIndexInfo = ENTRY(iNumIndex, cTableIndex, CHR(3)).
             IF ENTRY(2, cIndexInfo) = '1':U THEN
             DO:
               DO iLoop = 5 TO NUM-ENTRIES(cIndexInfo) BY 2:
                 ASSIGN 
                   gsc_entity_mnemonic.entity_key_field = gsc_entity_mnemonic.entity_key_field + ",":U WHEN gsc_entity_mnemonic.entity_key_field <> "":U
                   gsc_entity_mnemonic.entity_key_field = gsc_entity_mnemonic.entity_key_field + ENTRY(iLoop,cIndexInfo).
               END. /* iLoop */
               LEAVE FieldLoop.
             END.  /* unique single key field index */
             ELSE NEXT IndexLoop.
           END.  /* indexloop */
         END.  /* fieldloop */
      END.  /* if key field still blank */


    END.  /* if key field blank */

    /* entity_object_field */
    IF gsc_entity_mnemonic.entity_object_field = '':U THEN
    DO:
      FieldLoop:
      DO iFieldLoop = 1 TO hTable:NUM-FIELDS:
        hField = hTable:BUFFER-FIELD(iFieldLoop).

        IF hField:NAME = SUBSTRING(ttImport.cTable, piPrefix + 1) + '_obj':U THEN
        DO:
          ASSIGN
            gsc_entity_mnemonic.entity_object_field = hField:NAME
            gsc_entity_mnemonic.table_has_object_field = TRUE.
          LEAVE FieldLoop.
        END.  /* if found object field */
        ELSE DO:
          IF hField:KEY AND LOOKUP(hField:DATA-TYPE, 'decimal':U) > 0 THEN 
          DO:
            IndexLoop:
            DO iNumIndex = 1 TO NUM-ENTRIES(cTableIndex, CHR(3)):
              cIndexInfo = ENTRY(iNumIndex, cTableIndex, CHR(3)).
              IF ENTRY(2, cIndexInfo) = '1':U AND 
                NUM-ENTRIES(cIndexInfo) = 6 AND 
                ENTRY(5, cIndexInfo) = hField:NAME THEN
              DO:
                ASSIGN
                  gsc_entity_mnemonic.entity_object_field = hField:NAME
                  gsc_entity_mnemonic.table_has_object_field = TRUE.
                LEAVE FieldLoop.
              END.  /* if unique */
              ELSE NEXT IndexLoop.
            END.  /* indexloop */
          END.  /* if key decimal or integer */
        END.  /* if obj field */
      END.  /* fieldloop */
      IF gsc_entity_mnemonic.entity_object_field = '':U THEN
        ASSIGN gsc_entity_mnemonic.table_has_object_field = FALSE.
    END.  /* if entity_object_field blank */

    /* update entity display fields if selected */
    IF plDisplayFields THEN
    DO:
      /* 1st zap existing records - this is the only way we can do this as the table only
         contains records for the fields included.
      */
      FOR EACH gsc_entity_display_field EXCLUSIVE-LOCK
         WHERE gsc_entity_display_field.entity_mnemonic = gsc_entity_mnemonic.entity_mnemonic:
        DELETE gsc_entity_display_field.
      END.

      iFieldOrder = 0.
      /* now re-setup new fields */      
      FieldLoop:
      DO iFieldLoop = 1 TO hTable:NUM-FIELDS:
        hField = hTable:BUFFER-FIELD(iFieldLoop).
        IF hField:NAME MATCHES '*_obj':U OR hField:NAME = gsc_entity_mnemonic.entity_object_field THEN 
          NEXT FieldLoop.
        ELSE
        DO:
          CREATE gsc_entity_display_field.
          {af/sup2/afcheckerr.i &no-return = YES}
           pcError = cMessageList.
          IF pcError <> '':U THEN UNDO TranBlock, LEAVE TranBlock.
          ASSIGN
            iFieldOrder                                         = iFieldOrder + 1
            gsc_entity_display_field.entity_mnemonic            = gsc_entity_mnemonic.entity_mnemonic
            gsc_entity_display_field.display_field_name         = hField:NAME
            gsc_entity_display_field.display_field_order        = iFieldOrder /*hField:POSITION*/
            gsc_entity_display_field.display_field_label        = "":U
            gsc_entity_display_field.display_field_column_label = "":U
            gsc_entity_display_field.display_field_format       = "":U
            .
          VALIDATE gsc_entity_display_field NO-ERROR.
          {af/sup2/afcheckerr.i &no-return = YES}
           pcError = cMessageList.
          IF pcError <> '':U THEN UNDO TranBlock, LEAVE TranBlock.
        END.  /* else do */
      END.  /* fieldloop */
    END.

  END.  /* for each ttImport */

  VALIDATE gsc_entity_mnemonic NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}
   pcError = cMessageList.
  IF pcError <> '':U THEN UNDO TranBlock, LEAVE TranBlock.
END.  /* do transaction */

ERROR-STATUS:ERROR = NO.
RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


