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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "CreateWizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? af/sup/afwizdeltp.p */
/* MIP New Program Wizard
Destroy on next read */
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
  File: afbrwcolsp.p

  Description:  Return info on browser columns

  Purpose:      Return info on browser columns

  Parameters:   ip_browser_handle
                op_file_list - pipe delimited
                op_label_list - pipe delimited
                op_width_list - pipe delimited

  History:
  --------
  (v:010000)    Task:        2607   UserRef:    
                Date:   30/08/1999  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afbrwcolsp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE INPUT PARAMETER ip_browser_handle    AS HANDLE    NO-UNDO.
DEFINE OUTPUT PARAMETER op_field_list       AS CHARACTER        NO-UNDO.
DEFINE OUTPUT PARAMETER op_label_list       AS CHARACTER        NO-UNDO.
DEFINE OUTPUT PARAMETER op_width_list       AS CHARACTER        NO-UNDO.
DEFINE OUTPUT PARAMETER op_value_list       AS CHARACTER        NO-UNDO.

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
         HEIGHT             = 5
         WIDTH              = 49.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

    DEFINE VARIABLE lh_browser_column           AS WIDGET-HANDLE    NO-UNDO.
    DEFINE VARIABLE lv_browser_columns          AS INTEGER          NO-UNDO.
    DEFINE VARIABLE lv_browser_loop             AS INTEGER          NO-UNDO.

    ASSIGN
        op_field_list = "":U
        op_label_list = "":U
        op_width_list = "":U
        op_value_list = "":U
        .
    ASSIGN
        lv_browser_columns  = ip_browser_handle:NUM-COLUMNS
        lh_browser_column   = ip_browser_handle:FIRST-COLUMN.
    DO lv_browser_loop = 1 to lv_browser_columns:
        ASSIGN
            op_field_list = op_field_list +
                            (IF op_field_list = "":U THEN "":U ELSE "|":U) +
                            (IF lh_browser_column:TABLE <> ? THEN lh_browser_column:TABLE + "_":U ELSE "":U) +
                            lh_browser_column:NAME
            op_label_list = op_label_list +
                            (IF op_label_list = "":U THEN "":U ELSE "|":U) +
                            (IF lh_browser_column:LABEL <> ? AND lh_browser_column:LABEL <> "":U
                                THEN REPLACE(lh_browser_column:LABEL,"|":U,"":U)
                                ELSE "?":U)
            op_width_list = op_width_list +
                            (IF op_width_list = "":U THEN "":U ELSE "|":U) +
                            STRING(lh_browser_column:WIDTH-CHARS)
            op_value_list = op_value_list +
                            (IF op_value_list = "":U THEN "":U ELSE "|":U) +
                            (IF lh_browser_column:SCREEN-VALUE <> ? AND lh_browser_column:SCREEN-VALUE <> "":U
                                THEN REPLACE(lh_browser_column:SCREEN-VALUE,"|":U,"":U)
                                ELSE "?":U)
                            .
        ASSIGN lh_browser_column = lh_browser_column:NEXT-COLUMN.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


