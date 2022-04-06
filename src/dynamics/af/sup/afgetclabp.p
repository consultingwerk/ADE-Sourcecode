&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" procedure _INLINE
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
/*------------------------------------------------------------------------

  File:                 afgetclabp.p

  Description:          Get Column Label

  Purpose:              This procedure interrogates the metaschema of the
                        database alias created by the calling procedure to
                        get the given field's column label.
                        If the field's column label is blank or unknown, the
                        normal label is used instead.

                        NB: THIS PROCEDURE WILL NOT COMPILE UNLESS A
                            DATABASE ALIAS CALLED db_metaschema EXISTS.
                            THIS ALIAS CAN BE ON ANY DATABASE, AS IT ONLY
                            ACCESSES THE META-SCHEMA


  Input Parameters:     ip_file_name    - File name to check
                        ip_field_name   - Field name to check

  Output Parameters:    op_indexed      - Is the field indexed?
                                          "YES"     = yes
                                          "NO"      = no
                                          "WORD"    = word indexed
                                          ?         = file doesn't exist,
                                                      or field doesn't
                                                      exist in the file

  History:
  (010000)  Task: 6     21/11/1997  Alec Tucker
            Created


------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgetclabp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001



DEFINE INPUT  PARAMETER ip_file_name        AS CHARACTER                NO-UNDO.
DEFINE INPUT  PARAMETER ip_field_name       AS CHARACTER                NO-UNDO.
DEFINE OUTPUT PARAMETER op_column_label     AS CHARACTER    INITIAL ?   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

FIND FIRST db_metaschema._file NO-LOCK
    WHERE db_metaschema._file._file-name = ip_file_name
NO-ERROR.

IF AVAILABLE db_metaschema._file THEN
DO:
    FIND FIRST db_metaschema._field OF db_metaschema._file NO-LOCK
        WHERE db_metaschema._field._field-name = ip_field_name
    NO-ERROR.
    IF AVAILABLE db_metaschema._field THEN
        IF db_metaschema._field._col-label = ? OR db_metaschema._field._col-label = "":U THEN
            ASSIGN
                op_column_label = db_metaschema._field._label.
        ELSE
            ASSIGN
                op_column_label = db_metaschema._field._col-label.
    ELSE
        ASSIGN
            op_column_label = ?.
END.
ELSE
    ASSIGN
        op_column_label = ?.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


