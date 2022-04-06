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
/*------------------------------------------------------------------------

  File:                 afgettypep.p

  Description:          Get data type of given field from the meta-schema

  Purpose:              NB: THIS PROCEDURE WILL NOT COMPILE UNLESS A
                            DATABASE ALIAS CALLED db_metaschema EXISTS.
                            THIS ALIAS CAN BE ON ANY DATABASE, AS IT ONLY
                            ACCESSES THE META-SCHEMA

  Input Parameters:     ip_table    - Table name
                        ip_field    - Field name whose data type is to be
                                      returned

  Output Parameters:    op_type     - Data type as read from the meta-schema

  History:
  (010000)  Task: 6     05/04/1997  Anthony D Swindells
            New template designed for use by MIP. It was originally created
            from the standard ADM template
            Task: 6     16/10/1997  Alec Tucker
            Created

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgettypep.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000



DEFINE INPUT  PARAMETER ip_table AS CHARACTER               NO-UNDO.
DEFINE INPUT  PARAMETER ip_field AS CHARACTER               NO-UNDO.
DEFINE OUTPUT PARAMETER op_type  AS CHARACTER   INITIAL ?   NO-UNDO.

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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

FIND db_metaschema._File NO-LOCK
    WHERE db_metaschema._File._File-Name = ip_table NO-ERROR.

IF NOT AVAILABLE db_metaschema._File THEN
    MESSAGE SUBSTITUTE( "afgettypep.p failed to find a _File record for table &1", ip_table ) VIEW-AS ALERT-BOX ERROR.
ELSE
DO:
    FIND db_metaschema._Field WHERE
         db_metaschema._Field._File-recid = RECID(db_metaschema._File) AND
         db_metaschema._Field._Field-Name = ip_field 
         NO-LOCK NO-ERROR.

    IF NOT AVAILABLE db_metaschema._Field THEN
        MESSAGE SUBSTITUTE( "afgettypep.p failed to find a _Field record for &1 (table &2)", ip_field, ip_table ) VIEW-AS ALERT-BOX ERROR.
    ELSE
        ASSIGN op_type = db_metaschema._Field._Data-Type.
END.

/* -- EOF -- */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


