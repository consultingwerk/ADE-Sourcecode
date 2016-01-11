&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
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
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT PARAMETER ip_descriptor_file AS CHARACTER.


&SCOPED-DEFINE EXPORT-PROGRAM SESSION:TEMP-DIRECTORY + rycso_export.p
&SCOPED-DEFINE IMPORT-PROGRAM SESSION:TEMP-DIRECTORY + rycso_import.p

DEFINE VARIABLE lv_database_name AS CHARACTER INITIAL "icfdb".
DEFINE STREAM str-in.

DEFINE STREAM str-out.

DEFINE TEMP-TABLE tt-descriptor
    FIELD table_name AS CHARACTER    
    FIELD configuration_type AS CHARACTER   
    FIELD recursive_key_fields AS CHARACTER    
    FIELD primary_key_fields AS CHARACTER
    FIELD PRIMARY_key_datatypes AS CHARACTER
    FIELD PRIMARY_key_nulls AS CHARACTER
    FIELD TABLE_sequence AS INTEGER.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DO ON ERROR UNDO, RETURN:

    RUN readDescriptor(ip_descriptor_file).

    RUN writeExportProgram("{&EXPORT-PROGRAM}").
    RUN writeImportProgram("{&IMPORT-PROGRAM}").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-readDescriptor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readDescriptor Procedure 
PROCEDURE readDescriptor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM ip_descriptor_file AS CHARACTER.    

DEFINE VARIABLE lv_idx AS INTEGER.
DEFINE VARIABLE lv_text_line AS CHARACTER.

    INPUT STREAM str-in FROM VALUE(ip_descriptor_file).
    REPEAT:
        IMPORT STREAM str-in UNFORMATTED lv_text_line.
        IF lv_text_line BEGINS ";" OR TRIM(lv_text_line) = "" THEN NEXT.
        IF NUM-ENTRIES(lv_text_line) <> 6 THEN
        DO:
            MESSAGE "Each line of the descriptor file must have exactly 6 comma-separated entries, unless that line is blank or a comment (which begins with a ; character)." VIEW-AS ALERT-BOX.
            RETURN ERROR.
        END.
        CREATE tt-descriptor.
        ASSIGN 
            tt-descriptor.table_name              = ENTRY(1,lv_text_line)
            tt-descriptor.configuration_type      = ENTRY(2,lv_text_line)
            tt-descriptor.recursive_key_fields    = ENTRY(3,lv_text_line)    
            tt-descriptor.primary_key_fields      = ENTRY(4,lv_text_line)
            tt-descriptor.primary_key_datatypes   = ENTRY(5,lv_text_line)            
            tt-descriptor.primary_key_nulls       = ENTRY(6,lv_text_line)             
            tt-descriptor.TABLE_sequence = lv_idx + 1.

        lv_idx = lv_idx + 1.        
    END.


    MESSAGE lv_idx "records read".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeExportProgram) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeExportProgram Procedure 
PROCEDURE writeExportProgram :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM ip_program_name AS CHARACTER.
DEFINE VARIABLE lv_idx AS INTEGER.
/*     IF SEARCH(ip_program_name) <> ? THEN                       */
/*     DO:                                                        */
/*         MESSAGE "Program " ip_program_name " already exists.". */
/*         RETURN ERROR.                                          */
/*     END.                                                       */
    OUTPUT STREAM str-out TO VALUE(ip_program_name).

    /* standard headings */
    PUT STREAM str-out UNFORMATTED "/* export program created by descriptor.p according to the following descriptor:" SKIP(1).

    FOR EACH tt-descriptor BY TABLE_sequence:
        PUT STREAM str-out UNFORMATTED 
            tt-descriptor.TABLE_name            + "," +
            tt-descriptor.configuration_type    + "," +             
            tt-descriptor.RECURSIVE_key_fields  + "," + 
            tt-descriptor.primary_key_fields    + "," + 
            tt-descriptor.primary_key_datatypes + "," + 
            tt-descriptor.primary_key_nulls     SKIP.
    END.

    PUT STREAM str-out UNFORMATTED SKIP "*/" SKIP(1).
    PUT STREAM str-out UNFORMATTED "DEFINE INPUT PARAMETER ip_export_directory AS CHARACTER." SKIP.
    PUT STREAM str-out UNFORMATTED SKIP(1).                        
    PUT STREAM str-out UNFORMATTED "DEFINE STREAM str-export." SKIP.
    PUT STREAM str-out UNFORMATTED "DEFINE STREAM str-objects." SKIP.
    PUT STREAM str-out UNFORMATTED SKIP(1).                        
    PUT STREAM str-out UNFORMATTED "OUTPUT STREAM str-objects TO VALUE(ip_export_directory + ~"/objectlist.v~")." SKIP.
    PUT STREAM str-out UNFORMATTED SKIP(1).                        

    FOR EACH tt-descriptor BY TABLE_sequence:
        PUT STREAM str-out UNFORMATTED "RUN dump-" + TABLE_name + "." SKIP.
    END.                                   
    PUT STREAM str-out UNFORMATTED SKIP(1).

    FOR EACH tt-descriptor BY TABLE_sequence:

        IF tt-descriptor.configuration_type = "" 
            THEN RELEASE rvc_configuration_type.                                                                                                       
            ELSE FIND rvc_configuration_type NO-LOCK
                WHERE rvc_configuration_type.configuration_type = tt-descriptor.configuration_type.

        PUT STREAM str-out UNFORMATTED "PROCEDURE dump-" + TABLE_name + ":" SKIP.
        PUT STREAM str-out UNFORMATTED "    FIND FIRST " + lv_database_name + "._File WHERE " + lv_database_name + "._File._File-Name = ~"" + tt-descriptor.TABLE_name + "~"." SKIP
                                       "    OUTPUT STREAM str-export TO VALUE ( ip_export_directory + ~"/~" + " + lv_database_name + "._File._Dump-Name + ~".v~")." SKIP.

        /* the next part depends on whether or not the dump is recursive */

        IF tt-descriptor.RECURSIVE_key_fields <> "" THEN
        DO:
            PUT STREAM str-out UNFORMATTED "        RUN recur-" + tt-descriptor.TABLE_name + "(" SKIP.
            DO lv_idx = 1 TO NUM-ENTRIES(tt-descriptor.PRIMARY_key_nulls,"|"):
                IF lv_idx > 1 THEN PUT STREAM str-out UNFORMATTED "," SKIP.
                PUT STREAM str-out UNFORMATTED "            " + ENTRY(lv_idx,PRIMARY_key_nulls).
            END.
            PUT STREAM str-out UNFORMATTED ")." SKIP.
        END.
        ELSE DO:
            PUT STREAM str-out UNFORMATTED "    FOR EACH " + tt-descriptor.TABLE_name + " NO-LOCK:" SKIP
                                           "        EXPORT STREAM str-export " + tt-descriptor.TABLE_name + "." SKIP.
            IF tt-descriptor.configuration_type <> "" THEN
            DO:
                PUT STREAM str-out UNFORMATTED "        DEFINE VARIABLE lv_product_module     AS CHARACTER NO-UNDO." SKIP
                                               "        DEFINE VARIABLE lv_object_description AS CHARACTER NO-UNDO." SKIP
                                               "        DEFINE VARIABLE lv_object_name        AS CHARACTER NO-UNDO." SKIP.
                IF rvc_configuration_type.product_module_fieldname <> "" 
                    THEN PUT STREAM str-out UNFORMATTED "        FIND FIRST gsc_product_module NO-LOCK" SKIP
                                                        "            WHERE gsc_product_module.product_module_obj = " + tt-descriptor.TABLE_name + "." + rvc_configuration_type.product_module_fieldname + "." SKIP
                                                        "        lv_product_module = gsc_product_module.product_module_code." SKIP.
                IF rvc_configuration_type.description_fieldname <> ""                                                         
                    THEN PUT STREAM str-out UNFORMATTED "        lv_object_description = " + tt-descriptor.TABLE_name + "." + rvc_configuration_type.description_fieldname + "." SKIP. 

                IF rvc_configuration_type.scm_identifying_fieldname <> ""                                                         
                    THEN PUT STREAM str-out UNFORMATTED "        lv_object_name = " + tt-descriptor.TABLE_name + "." + rvc_configuration_type.scm_identifying_fieldname + "." SKIP. 

                PUT STREAM str-out UNFORMATTED "        EXPORT STREAM str-objects ~"" + tt-descriptor.configuration_type + "~" lv_object_name lv_object_description ~"" + rvc_configuration_type.scm_code + "~" lv_product_module." SKIP.                                          
            END.


            PUT STREAM str-out UNFORMATTED "    END." SKIP.
        END.

        PUT STREAM str-out UNFORMATTED "    OUTPUT STREAM str-export CLOSE." SKIP.                                                            
        PUT STREAM str-out UNFORMATTED "END PROCEDURE." SKIP.
        PUT STREAM str-out UNFORMATTED SKIP(1).

        IF tt-descriptor.RECURSIVE_key_fields <> "" THEN 
        DO:
            PUT STREAM str-out UNFORMATTED "PROCEDURE recur-" + TABLE_name + ":" SKIP.
            DO lv_idx = 1 TO NUM-ENTRIES(tt-descriptor.PRIMARY_key_nulls,"|"):
                PUT STREAM str-out UNFORMATTED "    DEFINE INPUT PARAMETER ip_" + STRING(lv_idx) " AS " + ENTRY(lv_idx,PRIMARY_key_datatypes) + "." SKIP.
            END.
            PUT STREAM str-out UNFORMATTED SKIP(1).

            PUT STREAM str-out UNFORMATTED "    DEFINE BUFFER " + tt-descriptor.TABLE_name + " FOR " + tt-descriptor.TABLE_name + "." SKIP.
            PUT STREAM str-out UNFORMATTED SKIP(1).

            PUT STREAM str-out UNFORMATTED "    FOR EACH " + tt-descriptor.TABLE_name + " NO-LOCK" SKIP "        WHERE ".
            DO lv_idx = 1 TO NUM-ENTRIES(tt-descriptor.PRIMARY_key_nulls,"|"):
                IF lv_idx > 1 THEN PUT STREAM str-out UNFORMATTED SKIP "AND   ".
                PUT STREAM str-out UNFORMATTED ENTRY(lv_idx,recursive_key_fields) + " = ip_" + STRING(lv_idx).                    
            END.
            PUT STREAM str-out UNFORMATTED ":" SKIP.
            PUT STREAM str-out UNFORMATTED SKIP(1).

            PUT STREAM str-out UNFORMATTED "        EXPORT STREAM str-export " + tt-descriptor.TABLE_name + "." SKIP.

            IF tt-descriptor.configuration_type <> "" THEN
            DO:
                PUT STREAM str-out UNFORMATTED "        DEFINE VARIABLE lv_product_module     AS CHARACTER NO-UNDO." SKIP
                                               "        DEFINE VARIABLE lv_object_description AS CHARACTER NO-UNDO." SKIP
                                               "        DEFINE VARIABLE lv_object_name        AS CHARACTER NO-UNDO." SKIP.
                IF rvc_configuration_type.product_module_fieldname <> "" 
                    THEN PUT STREAM str-out UNFORMATTED "        FIND FIRST gsc_product_module NO-LOCK" SKIP
                                                        "            WHERE gsc_product_module.product_module_obj = " + tt-descriptor.TABLE_name + "." + rvc_configuration_type.product_module_fieldname + "." SKIP
                                                        "        lv_product_module = gsc_product_module.product_module_code." SKIP.
                IF rvc_configuration_type.description_fieldname <> ""                                                         
                    THEN PUT STREAM str-out UNFORMATTED "        lv_object_description = " + tt-descriptor.TABLE_name + "." + rvc_configuration_type.description_fieldname + "." SKIP. 

                IF rvc_configuration_type.scm_identifying_fieldname <> ""                                                         
                    THEN PUT STREAM str-out UNFORMATTED "        lv_object_name = " + tt-descriptor.TABLE_name + "." + rvc_configuration_type.scm_identifying_fieldname + "." SKIP. 

                PUT STREAM str-out UNFORMATTED "        EXPORT STREAM str-objects ~"" + tt-descriptor.configuration_type + "~" lv_object_name lv_object_description ~"" + rvc_configuration_type.scm_code + "~" lv_product_module." SKIP.                                          
            END.

            PUT STREAM str-out UNFORMATTED "        RUN recur-" + tt-descriptor.TABLE_name + "(" SKIP.

            DO lv_idx = 1 TO NUM-ENTRIES(tt-descriptor.recursive_key_fields,"|"):
                IF lv_idx > 1 THEN PUT STREAM str-out UNFORMATTED ",".
                PUT STREAM str-out UNFORMATTED "                INPUT " + ENTRY(lv_idx,primary_key_fields,"|") SKIP.                    
            END.
            PUT STREAM str-out UNFORMATTED "        )." SKIP.
            PUT STREAM str-out UNFORMATTED "    END." SKIP.
            PUT STREAM str-out UNFORMATTED "END PROCEDURE." SKIP.
            PUT STREAM str-out UNFORMATTED SKIP(1).

        END.        
    END.                                   



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeImportProgram) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeImportProgram Procedure 
PROCEDURE writeImportProgram :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM ip_program_name AS CHARACTER.
DEFINE VARIABLE lv_idx AS INTEGER.
/*     IF SEARCH(ip_program_name) <> ? THEN                       */
/*     DO:                                                        */
/*         MESSAGE "Program " ip_program_name " already exists.". */
/*         RETURN ERROR.                                          */
/*     END.                                                       */
    OUTPUT STREAM str-out TO VALUE(ip_program_name).

    /* standard headings */
    PUT STREAM str-out UNFORMATTED "/* import program created by descriptor.p according to the following descriptor:" SKIP(1).

    FOR EACH tt-descriptor BY TABLE_sequence:
        PUT STREAM str-out UNFORMATTED 
            tt-descriptor.TABLE_name            + "," +
            tt-descriptor.configuration_type    + "," +             
            tt-descriptor.RECURSIVE_key_fields  + "," + 
            tt-descriptor.primary_key_fields    + "," + 
            tt-descriptor.primary_key_datatypes + "," + 
            tt-descriptor.primary_key_nulls     SKIP.
    END.

    PUT STREAM str-out UNFORMATTED SKIP "*/" SKIP(1).
    PUT STREAM str-out UNFORMATTED "DEFINE INPUT PARAMETER ip_export_directory AS CHARACTER." SKIP.
    PUT STREAM str-out UNFORMATTED SKIP(1).                        
    PUT STREAM str-out UNFORMATTED "DEFINE STREAM str-import." SKIP.
    PUT STREAM str-out UNFORMATTED "DEFINE STREAM str-objects." SKIP.
    PUT STREAM str-out UNFORMATTED SKIP(1).                        
    PUT STREAM str-out UNFORMATTED "RUN af/sup/afutlimplp.p (INPUT ip_export_directory + ~"/objectlist.v~") NO-ERROR." SKIP
                                   "IF ERROR-STATUS:ERROR OR RETURN-VALUE <> ~"~" THEN" SKIP
                                   "DO: " SKIP
                                   "    MESSAGE ~"afutlimplp.p failed ~" RETURN-VALUE." SKIP
                                   "    RETURN." SKIP
                                   "END." SKIP.
    PUT STREAM str-out UNFORMATTED SKIP(1).     

    PUT STREAM str-out UNFORMATTED "RUN do-txn NO-ERROR." SKIP
                                   "IF ERROR-STATUS:ERROR OR RETURN-VALUE <> ~"~" THEN" SKIP
                                   "DO: " SKIP
                                   "    RUN display-errors.p." SKIP
                                   "    RETURN." SKIP
                                   "END." SKIP.

    PUT STREAM str-out UNFORMATTED SKIP(1).     
    PUT STREAM str-out UNFORMATTED "PROCEDURE do-txn:" SKIP
                                   "    DO TRANSACTION ON ERROR UNDO, RETURN ERROR RETURN-VALUE:" SKIP.

    FOR EACH tt-descriptor WHERE configuration_type <> "" BY TABLE_sequence:
        PUT STREAM str-out UNFORMATTED "        RUN delete-" + tt-descriptor.configuration_type + "-objects.". 
    END.
    PUT STREAM str-out UNFORMATTED "    END." SKIP(1)
                                   "    DO TRANSACTION ON ERROR UNDO, RETURN ERROR RETURN-VALUE:" SKIP.    


    FOR EACH tt-descriptor BY TABLE_sequence:
        PUT STREAM str-out UNFORMATTED "        RUN import-" + TABLE_name + "." SKIP.
    END.                                   

    PUT STREAM str-out UNFORMATTED "    END." SKIP
                                   "END PROCEDURE." SKIP(1).

    PUT STREAM str-out UNFORMATTED SKIP(1).

    FOR EACH tt-descriptor WHERE configuration_type <> "" BY TABLE_sequence:   
        FIND FIRST rvc_configuration_type NO-LOCK 
            WHERE rvc_configuration_type.configuration_type = tt-descriptor.configuration_type.
        PUT STREAM str-out UNFORMATTED "PROCEDURE delete-" + tt-descriptor.configuration_type + "-objects:" SKIP
                                       "    DEFINE VARIABLE lv_object_name AS CHARACTER NO-UNDO." SKIP
                                       "    INPUT STREAM str-objects FROM VALUE( ip_export_directory +  ~"/objectlist.v~")." SKIP
                                       "    REPEAT:" SKIP
                                       "        IMPORT STREAM str-objects ^ lv_object_name." SKIP
                                       "        FIND FIRST " + tt-descriptor.table_name + " WHERE " + rvc_configuration_type.scm_identifying_fieldname + " = lv_object_name EXCLUSIVE-LOCK NO-ERROR." SKIP
                                       "        IF AVAILABLE(" + tt-descriptor.table_name + ") THEN ~{af/sup/afvalidtrg.i &ACTION=DELETE &TABLE=" + tt-descriptor.TABLE_name + "~}" SKIP
                                       "    END." SKIP
                                       "    INPUT STREAM str-objects CLOSE." SKIP
                                       "END PROCEDURE." SKIP(1).
    END.

    FOR EACH tt-descriptor BY TABLE_sequence:
        PUT STREAM str-out UNFORMATTED "PROCEDURE import-" + TABLE_name + ":" SKIP.
        PUT STREAM str-out UNFORMATTED "    FIND FIRST " + lv_database_name + "._File WHERE " + lv_database_name + "._File._File-Name = ~"" + tt-descriptor.TABLE_name + "~"." SKIP
                                       "    INPUT STREAM str-import FROM VALUE ( ip_export_directory + ~"/~" + " + lv_database_name + "._File._Dump-Name + ~".v~")." SKIP.

        /* the next part depends on whether or not the dump is recursive */
        PUT STREAM str-out UNFORMATTED "    REPEAT:" SKIP
                                       "        ~{af/sup/afvalidtrg.i &ACTION=CREATE &TABLE=" + tt-descriptor.TABLE_name + "~}" SKIP
                                       "        IMPORT STREAM str-import " + tt-descriptor.TABLE_name + "." SKIP
                                       "        ~{af/sup/afvalidtrg.i &ACTION=VALIDATE &TABLE=" + tt-descriptor.TABLE_name + "~}" SKIP
                                       "    END." SKIP
                                       "END PROCEDURE." SKIP.

        PUT STREAM str-out UNFORMATTED SKIP(1).

    END.                                   

    PUT STREAM str-out UNFORMATTED "PROCEDURE clear-return-value: " SKIP
                                   "    RETURN." SKIP
                                   "END PROCEDURE." SKIP(1).



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

