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
  File: gscedttabp.p

  Description:  build entity display fields temp-table

  Purpose:      To build a temp-table of display fields for the passed in table. The full list of
                fields for the passed in table is added to the temp-table. Then the
                gsc_entity_display_field table is checked for the entity passed in and the
                temp-table updated with any existing details.

  Parameters:   INPUT entity code
                INPUT tablename
                INPUT fieldname for object id field or blank for standards
                OUTPUT Table FOR ttEntityDisplayField

  History:
  --------
  (v:010000)    Task:    90000163   UserRef:    
                Date:   30/07/2001  Author:     Anthony Swindells

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gscedttabp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{afglobals.i}

/* temp-table to maintain entity display fields */
{gscedtable.i}

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
         HEIGHT             = 4
         WIDTH              = 49.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE INPUT PARAMETER pcEntityCode               AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcTable                    AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcObjectField              AS CHARACTER  NO-UNDO.

DEFINE OUTPUT PARAMETER TABLE FOR ttDisplayField.

DEFINE VARIABLE iFieldLoop                        AS INTEGER    NO-UNDO.
DEFINE VARIABLE hTable                            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField                            AS HANDLE     NO-UNDO.

/* ensure temp-table is empty */
EMPTY TEMP-TABLE ttDisplayField.

IF pcTable = "":U OR pcEntityCode = "":U THEN RETURN.

/* create a buffer for the table to ensure it is valid and then retrieve fields from it */
CREATE BUFFER hTable FOR TABLE pcTable NO-ERROR.
IF NOT VALID-HANDLE(hTable) THEN RETURN.

/* try and locate existing record details */
FIND FIRST gsc_entity_mnemonic NO-LOCK
     WHERE gsc_entity_mnemonic.entity_mnemonic = pcEntityCode 
     NO-ERROR.

/* we have a valid table - loop through table fields and create temp-table records */
FieldLoop:
DO iFieldLoop = 1 TO hTable:NUM-FIELDS:
  hField = hTable:BUFFER-FIELD(iFieldLoop).

  CREATE ttDisplayField.

  /* Set-up defaults */
  ASSIGN
    ttDisplayField.entity_display_field_obj = hField:POSITION /* temporary for adds to avoid index issues */
    ttDisplayField.entity_mnemonic = pcEntityCode
    ttDisplayField.DISPLAY_field_name = hField:NAME
    ttDisplayField.iOrder = hField:POSITION
    ttDisplayField.cLabel = hField:LABEL
    ttDisplayField.cColLabel = hField:COLUMN-LABEL
    ttDisplayField.cFormat = hField:FORMAT
    ttDisplayField.DISPLAY_field_order = ttDisplayField.iOrder
    ttDisplayField.DISPLAY_field_format = "":U
    ttDisplayField.DISPLAY_field_label = "":U
    ttDisplayField.DISPLAY_field_column_label = "":U
    .    
  
  /* Ignore object id fields by default */
  IF hField:NAME MATCHES '*_obj':U OR (pcObjectField <> "":U AND pcObjectField = gsc_entity_mnemonic.entity_object_field) THEN
    ASSIGN ttDisplayField.cInclude = NO.
  ELSE
    ASSIGN ttDisplayField.cInclude = YES.

  /* Now use existing details if they exist and still same table */  
  IF AVAILABLE gsc_entity_mnemonic AND
     gsc_entity_mnemonic.entity_mnemonic_description = pcTable THEN
  DO:
    FIND FIRST gsc_entity_display_field NO-LOCK
         WHERE gsc_entity_display_field.entity_mnemonic = pcEntityCode
           AND gsc_entity_display_field.DISPLAY_field_name = hField:NAME
         NO-ERROR.
    IF AVAILABLE gsc_entity_display_field THEN
      BUFFER-COPY 
        gsc_entity_display_field TO ttDisplayField
        ASSIGN ttDisplayField.cInclude   = YES
               ttDisplayField.lFromGSCED = YES
               .
    ELSE
        ASSIGN ttDisplayField.cInclude = NO.
  END.

  RELEASE ttDisplayField.

END. /* FieldLoop */

DELETE OBJECT hTable.
ASSIGN hTable = ?.

ERROR-STATUS:ERROR = NO.
RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


