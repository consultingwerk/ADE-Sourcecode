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
  File: afsizxftrp.p

  Description:  Resize widgets wizard

  Purpose:      Wizard to step through widgets on a SmartViewer and set them to the
                standard widget size based on the format mask.

  Parameters:

  History:
  --------
  (v:010000)    Task:          76   UserRef:    
                Date:   01/03/1998  Author:     Anthony Swindells

  Update Notes: Write new wizard to resize field widgets on a smart viewer

  (v:010001)    Task:          73   UserRef:    AS3
                Date:   03/03/1998  Author:     Anthony Swindells

  Update Notes: Fix problem with %'s

  (v:010003)    Task:         239   UserRef:    
                Date:   25/05/1998  Author:     Anthony Swindells

  Update Notes: The resize on dates is not big enough for disabled fields so we had to increase it

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afsizxftrp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010003

DEFINE INPUT        PARAMETER  ip_context_id                    AS INTEGER                                                      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER  iop_code                         AS CHARACTER                                                    NO-UNDO.

DEFINE VARIABLE lv_uibinfo                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_srecid                       AS INTEGER      NO-UNDO.
DEFINE VARIABLE lv_code                         AS CHARACTER    NO-UNDO.

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
         HEIGHT             = 1.67
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

    DEFINE VARIABLE lv_handle AS HANDLE NO-UNDO.
    DEFINE VARIABLE lv_loop AS INTEGER NO-UNDO.
    DEFINE VARIABLE lv_dbname AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lv_object_list AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lv_object_name AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lv_format AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lv_datatype AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lv_length AS INTEGER NO-UNDO.
    DEFINE VARIABLE lv_start_posn AS INTEGER NO-UNDO.
    DEFINE VARIABLE lv_end_posn AS INTEGER NO-UNDO.
    DEFINE VARIABLE lv_width AS INTEGER NO-UNDO.

    RUN adeuib/_uibinfo.p ( ?, "PROCEDURE ?":U, "CONTAINS * RETURN NAME":U, OUTPUT lv_object_list ).

    /* Step through each object */
    DO lv_loop = 1 TO NUM-ENTRIES(lv_object_list):
        ASSIGN lv_object_name = ENTRY(lv_loop,lv_object_list).
        IF lv_object_name BEGINS "_LBL-":U /*OR
 *            NUM-ENTRIES(lv_object_name,".":U) <> 3*/ THEN NEXT.

        RUN adeuib/_uibinfo( INPUT  ?,
                             INPUT  lv_object_name,
                             INPUT  "HANDLE", 
                             OUTPUT lv_uibinfo ). 
        ASSIGN lv_handle = WIDGET-HANDLE(lv_uibinfo) NO-ERROR.
        IF NOT VALID-HANDLE(lv_handle) THEN NEXT.
        IF NOT CAN-QUERY(lv_handle,"TYPE":U) OR lv_handle:TYPE <> "FILL-IN" THEN NEXT.

        ASSIGN
            lv_format = lv_handle:FORMAT
            lv_datatype = lv_handle:DATA-TYPE.

        IF NUM-ENTRIES(lv_object_name,".":U) = 3 THEN
          DO:   /* This is a database field - read metaschema for format and datatype */
            ASSIGN lv_dbname = ENTRY(1,lv_object_name,".":U).
            CREATE ALIAS db_metaschema FOR DATABASE VALUE (lv_dbname) NO-ERROR.
            RUN af/sup/afchkvfldp.p (INPUT ENTRY(2,lv_object_name,".":U) + ".":U + ENTRY(3,lv_object_name,".":U), OUTPUT lv_datatype, OUTPUT lv_format).
          END.

        ASSIGN lv_length = LENGTH(TRIM(lv_format)).

        IF INDEX(lv_format,"(":U) > 0 AND
           INDEX(lv_format,")":U) > INDEX(lv_format,"(":U) THEN
          DO:
            ASSIGN
                lv_start_posn = INDEX(lv_format,"(":U)
                lv_end_posn = INDEX(lv_format,")":U)
                lv_length = INTEGER(SUBSTRING(lv_format,lv_start_posn + 1, (lv_end_posn - 1) - lv_start_posn)).
          END.        

        CASE lv_datatype:
            WHEN "date":U THEN ASSIGN lv_width = 14.
            WHEN "character":U THEN
              DO:
                CASE lv_length:
                    WHEN 1 THEN ASSIGN lv_width = 4.
                    WHEN 2 THEN ASSIGN lv_width = 6.
                    WHEN 3 THEN ASSIGN lv_width = 8.
                    WHEN 4 THEN ASSIGN lv_width = 10.
                    WHEN 5 THEN ASSIGN lv_width = 14.
                    WHEN 6 THEN ASSIGN lv_width = 15.
                    WHEN 7 THEN ASSIGN lv_width = 15.
                    WHEN 8 THEN ASSIGN lv_width = 17.
                    WHEN 9 THEN ASSIGN lv_width = 18.
                    WHEN 10 THEN ASSIGN lv_width = 20.
                    WHEN 11 THEN ASSIGN lv_width = 20.
                    WHEN 12 THEN ASSIGN lv_width = 22.
                    WHEN 15 THEN ASSIGN lv_width = 24.
                    WHEN 20 THEN ASSIGN lv_width = 30.
                    WHEN 28 THEN ASSIGN lv_width = 40.
                    WHEN 35 THEN ASSIGN lv_width = 48.
                    WHEN 70 THEN ASSIGN lv_width = 65.
                    OTHERWISE ASSIGN lv_width = 0.
                END CASE.
              END.
            OTHERWISE   /* integer and decimal */
              DO:
                CASE lv_length:
                    WHEN 1 THEN ASSIGN lv_width = 3.
                    WHEN 2 THEN ASSIGN lv_width = 4.
                    WHEN 3 THEN ASSIGN lv_width = 5.
                    WHEN 4 THEN ASSIGN lv_width = 6.
                    WHEN 5 THEN ASSIGN lv_width = 8.
                    WHEN 6 THEN ASSIGN lv_width = 9.
                    WHEN 7 THEN ASSIGN lv_width = 10.
                    WHEN 8 THEN ASSIGN lv_width = 11.
                    WHEN 9 THEN ASSIGN lv_width = 12.
                    WHEN 10 THEN ASSIGN lv_width = 14.
                    WHEN 11 THEN ASSIGN lv_width = 15.
                    WHEN 12 THEN ASSIGN lv_width = 16.
                    WHEN 13 THEN ASSIGN lv_width = 17.
                    WHEN 14 THEN ASSIGN lv_width = 18.
                    WHEN 15 THEN ASSIGN lv_width = 20.
                    WHEN 16 THEN ASSIGN lv_width = 21.
                    WHEN 17 THEN ASSIGN lv_width = 22.
                    WHEN 18 THEN ASSIGN lv_width = 23.
                    WHEN 19 THEN ASSIGN lv_width = 24.
                    WHEN 20 THEN ASSIGN lv_width = 26.
                    OTHERWISE ASSIGN lv_width = 0.
                END CASE.
              END.
        END CASE.

        IF lv_width > 0 THEN
          DO:
            IF INDEX(lv_format, "%":U) > 0 THEN ASSIGN lv_width = lv_width + 1.
            ASSIGN lv_handle:WIDTH-CHARS = lv_width.
            APPLY "END-MOVE":U TO lv_handle.
            APPLY "END-RESIZE":U TO lv_handle.
          END.
    END.

    MESSAGE "Database Fill-in widgets resized to standard sizes"
        VIEW-AS ALERT-BOX INFORMATION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


