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
  File: afgetfldip.p

  Description:  Get table field information

  Purpose:      Returns comma-delimited lists of field names, labels and data types for a given
                DB.TABLE
                A database alias of db_metaschema must already be available

  Parameters:   INPUT  ip_table
                OUTPUT op_field_list
                OUTPUT op_label_list
                OUTPUT op_datatype_list

  History:
  --------
  (v:010000)    Task:         684   UserRef:    Astra
                Date:   02/11/1998  Author:     Alec Tucker

  Update Notes: Created from Template afgetfldlp.p

  (v:010001)    Task:        2336   UserRef:    
                Date:   18/08/1999  Author:     Anthony Swindells

  Update Notes: enusre same number of entries for each output paramater always returned

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgetfldip.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE INPUT  PARAMETER ip_table            AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER op_field_list       AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER op_label_list       AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER op_datatype_list    AS CHARACTER NO-UNDO.

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
         HEIGHT             = 1.95
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ASSIGN
    op_field_list = "":U
    op_label_list = "":U
    op_datatype_list = "":U.

FIND FIRST db_metaschema._file NO-LOCK
     WHERE db_metaschema._file._file-name = ip_table NO-ERROR.
IF AVAILABLE db_metaschema._file THEN
  DO:
    FOR EACH db_metaschema._field OF db_metaschema._file NO-LOCK:
        ASSIGN
            op_label_list       = (IF op_field_list    = "":U THEN "":U ELSE op_label_list    + ",":U) +
                                  (IF db_metaschema._field._label <> ? THEN db_metaschema._field._label ELSE "":U)
            op_datatype_list    = (IF op_field_list    = "":U THEN "":U ELSE op_datatype_list + ",":U) +
                                  (db_metaschema._field._data-type)
            op_field_list       = (IF op_field_list    = "":U THEN "":U ELSE op_field_list    + ",":U) +
                                  (db_metaschema._field._field-name)
            .
    END.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


