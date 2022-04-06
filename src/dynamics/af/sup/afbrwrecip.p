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
  File: afbrwrecip.p

  Description:  Browser record information

  Purpose:      To return information on the cirrently selected record in a browser

  Parameters:   ip_browser_handle
                op_tablename
                op_tablefla
                op-tableobj
                op_descfield

  History:
  --------
  (v:010000)    Task:         967   UserRef:    AstraGen
                Date:   31/08/1999  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afbrwrecip.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

{af/sup2/afglobals.i}

DEFINE INPUT PARAMETER  ip_browser_handle               AS HANDLE       NO-UNDO.
DEFINE OUTPUT PARAMETER op_tablename                    AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER op_tablefla                     AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER op_tableobj                     AS DECIMAL      NO-UNDO.
DEFINE OUTPUT PARAMETER op_descfield                    AS CHARACTER    NO-UNDO.

DEFINE VARIABLE lh_query                                AS HANDLE       NO-UNDO.
DEFINE VARIABLE lh_buffer                               AS HANDLE       NO-UNDO.
DEFINE VARIABLE lh_field                                AS HANDLE       NO-UNDO.
DEFINE VARIABLE lv_loop                                 AS INTEGER      NO-UNDO.

DEFINE BUFFER lb_gsc_entity_mnemonic FOR gsc_entity_mnemonic.

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
         HEIGHT             = 6.76
         WIDTH              = 46.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ASSIGN
    lh_query = ip_browser_handle:QUERY NO-ERROR.
IF NOT VALID-HANDLE(lh_query) THEN RETURN.

ASSIGN
    lh_buffer = lh_query:GET-BUFFER-HANDLE(1) NO-ERROR.
IF NOT VALID-HANDLE(lh_buffer) THEN RETURN.

ASSIGN
    op_tablename = lh_buffer:TABLE.

FIND FIRST lb_gsc_entity_mnemonic NO-LOCK
     WHERE lb_gsc_entity_mnemonic.entity_mnemonic_description = op_tablename
     NO-ERROR.
IF AVAILABLE lb_gsc_entity_mnemonic THEN
  ASSIGN
    op_tablefla = lb_gsc_entity_mnemonic.entity_mnemonic.
ELSE IF SEARCH(op_tablename + ".i":U) <> ? THEN
  DO:
    INPUT FROM VALUE(SEARCH(op_tablename + ".i":U)) NO-ECHO.
    REPEAT:
        IMPORT UNFORMATTED op_tablefla.
        LEAVE.
    END.
    INPUT CLOSE.
  END.
ASSIGN
    op_tablefla = TRIM(op_tablefla).

/* Now get _obj field value from the table if we can, plus a description field if we can */
DO lv_loop = 1 TO lh_buffer:NUM-FIELDS:
  ASSIGN lh_field = lh_buffer:BUFFER-FIELD(lv_loop).
  IF LENGTH(op_tablename) > 5 AND lh_field:NAME = DYNAMIC-FUNCTION("getObjField":U IN gshGenManager,
                                                  INPUT DYNAMIC-FUNCTION("getTableDumpName":U IN gshGenManager,
                                                        INPUT lh_buffer:DBNAME + "|":U + op_tablename)) THEN
    ASSIGN op_tableobj = lh_field:BUFFER-VALUE NO-ERROR.
  IF op_tableobj > 0 AND op_descfield <> "":U THEN LEAVE.
  IF op_descfield = "":U AND
     LENGTH(op_tablename) > 5 AND lh_field:NAME = SUBSTRING(op_tablename,5) + "_code":U THEN
    ASSIGN op_descfield = lh_field:BUFFER-VALUE NO-ERROR.
  IF op_tableobj > 0 AND op_descfield <> "":U THEN LEAVE.
  IF op_descfield = "":U AND
     LENGTH(op_tablename) > 5 AND lh_field:NAME = SUBSTRING(op_tablename,5) + "_reference":U THEN
    ASSIGN op_descfield = lh_field:BUFFER-VALUE NO-ERROR.
  IF op_tableobj > 0 AND op_descfield <> "":U THEN LEAVE.
  IF op_descfield = "":U AND
     LENGTH(op_tablename) > 5 AND lh_field:NAME = SUBSTRING(op_tablename,5) + "_short_desc":U THEN
    ASSIGN op_descfield = lh_field:BUFFER-VALUE NO-ERROR.
  IF op_tableobj > 0 AND op_descfield <> "":U THEN LEAVE.
  IF op_descfield = "":U AND
     LENGTH(op_tablename) > 5 AND lh_field:NAME = SUBSTRING(op_tablename,5) + "_short_name":U THEN
    ASSIGN op_descfield = lh_field:BUFFER-VALUE NO-ERROR.
  IF op_tableobj > 0 AND op_descfield <> "":U THEN LEAVE.
  IF op_descfield = "":U AND
     LENGTH(op_tablename) > 5 AND lh_field:NAME = SUBSTRING(op_tablename,5) + "_tla":U THEN
    ASSIGN op_descfield = lh_field:BUFFER-VALUE NO-ERROR.
  IF op_tableobj > 0 AND op_descfield <> "":U THEN LEAVE.
  IF op_descfield = "":U AND
     LENGTH(op_tablename) > 5 AND lh_field:NAME = SUBSTRING(op_tablename,5) + "_type":U THEN
    ASSIGN op_descfield = lh_field:BUFFER-VALUE NO-ERROR.
  IF op_tableobj > 0 AND op_descfield <> "":U THEN LEAVE.
  IF op_descfield = "":U AND
     LENGTH(op_tablename) > 5 AND lh_field:NAME = SUBSTRING(op_tablename,5) + "_description":U THEN
    ASSIGN op_descfield = lh_field:BUFFER-VALUE NO-ERROR.
  IF op_tableobj > 0 AND op_descfield <> "":U THEN LEAVE.
  IF op_descfield = "":U AND
     LENGTH(op_tablename) > 5 AND lh_field:NAME = SUBSTRING(op_tablename,5) + "_name":U THEN
    ASSIGN op_descfield = lh_field:BUFFER-VALUE NO-ERROR.
  IF op_tableobj > 0 AND op_descfield <> "":U THEN LEAVE.
  IF op_descfield = "":U AND
     LENGTH(op_tablename) > 5 AND lh_field:NAME = SUBSTRING(op_tablename,5) + "_summary_description":U THEN
    ASSIGN op_descfield = lh_field:BUFFER-VALUE NO-ERROR.
  IF op_tableobj > 0 AND op_descfield <> "":U THEN LEAVE.
  IF op_descfield = "":U AND
     LENGTH(op_tablename) > 5 AND lh_field:NAME = SUBSTRING(op_tablename,5) + "_label":U THEN
    ASSIGN op_descfield = lh_field:BUFFER-VALUE NO-ERROR.
  IF op_tableobj > 0 AND op_descfield <> "":U THEN LEAVE.
  IF op_descfield = "":U AND
     lh_field:NAME = "last_name":U THEN
    ASSIGN op_descfield = lh_field:BUFFER-VALUE NO-ERROR.
  IF op_tableobj > 0 AND op_descfield <> "":U THEN LEAVE.
  IF op_descfield = "":U AND
     lh_field:NAME = "caps_last_name":U THEN
    ASSIGN op_descfield = lh_field:BUFFER-VALUE NO-ERROR.
  IF op_tableobj > 0 AND op_descfield <> "":U THEN LEAVE.
  IF op_descfield = "":U AND
     lh_field:NAME = "caps_organisation_code":U THEN
    ASSIGN op_descfield = lh_field:BUFFER-VALUE NO-ERROR.
  IF op_tableobj > 0 AND op_descfield <> "":U THEN LEAVE.

END.

RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


