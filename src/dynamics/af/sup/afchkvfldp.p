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
  File: afchkvfldp.p

  Description:  Check passed in field is valid

  Purpose:      To check that the table.field passed in is valid for the database with an alias
                db_metaschema, and pass back the field datatype if it exists.

  Parameters:   ip_fieldname
                op_field_datatype

  History:
  --------
  (v:010000)    Task:          41   UserRef:    AS0
                Date:   10/02/1998  Author:     Anthony Swindells

  Update Notes: New Program written from MIP Template

  (v:010001)    Task:          53   UserRef:    
                Date:   15/02/1998  Author:     Anthony Swindells

  Update Notes: To change the output parameter to pass back the field data type rather. If the
                field does not exist, the field data type will be passed back as blank.

  (v:010002)    Task:          76   UserRef:    
                Date:   01/03/1998  Author:     Anthony Swindells

  Update Notes: Add a 3rd parameter to return the field format

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER ip_fieldname AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER op_field_datatype AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER op_field_format AS CHARACTER NO-UNDO.

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afchkvfldp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010002

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

FIND FIRST db_metaschema._file 
     WHERE db_metaschema._file._file-name = ENTRY(1,ip_fieldname,".":U)
     NO-LOCK NO-ERROR.
IF AVAILABLE db_metaschema._file THEN
    FIND FIRST db_metaschema._Field OF db_metaschema._File NO-LOCK
        WHERE db_metaschema._Field._Field-Name = ENTRY(2,ip_fieldname,".":U)
    NO-ERROR.
IF AVAILABLE db_metaschema._Field THEN
    ASSIGN
        op_field_datatype = LC(TRIM(db_metaschema._Field._Data-Type))
        op_field_format = LC(TRIM(db_metaschema._Field._format)).

ELSE
    ASSIGN
        op_field_datatype = "":U
        op_field_format = "":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


