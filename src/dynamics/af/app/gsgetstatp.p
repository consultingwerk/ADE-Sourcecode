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
  File: gsgetstatp.p

  Description:  Status Temp Table Cache Procedure

  Purpose:      Status Temp Table Cache Procedure

  Parameters:   pcCategoryType
                pcCategoryGroup
                pcCategorySubGroup
                pcStatusObj
                prStatusCache

  History:
  --------
  (v:010000)    Task:        6644   UserRef:    
                Date:   05/09/2000  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gsgetstatp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000


/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

/*
{af/sup2/afglobals.i}
*/

{af/app/gsmstttcch.i}

DEFINE INPUT  PARAMETER pcCategoryType              AS CHARACTER                NO-UNDO.
DEFINE INPUT  PARAMETER pcCategoryGroup             AS CHARACTER                NO-UNDO.
DEFINE INPUT  PARAMETER pcCategorySubGroup          AS CHARACTER                NO-UNDO.
DEFINE INPUT  PARAMETER pdStatusObj                 AS DECIMAL                  NO-UNDO.
DEFINE OUTPUT PARAMETER prStatusCache               AS RAW                      NO-UNDO.

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
         HEIGHT             = 12.24
         WIDTH              = 45.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE BUFFER gsm_status                    FOR gsm_status.
DEFINE BUFFER gsm_category                  FOR gsm_category.

EMPTY TEMP-TABLE ttStatusCache.

IF pdStatusObj <> 0 THEN
DO:
    FIND gsm_status WHERE
         gsm_status.status_obj = pdStatusObj
         NO-LOCK NO-ERROR.
    IF AVAILABLE gsm_status THEN
        FIND gsm_category WHERE
             gsm_category.category_obj = gsm_status.category_obj
             NO-LOCK NO-ERROR.
END.    /* Status OBJ <> 0 */
ELSE
DO:
    FIND gsm_category WHERE
         gsm_category.related_entity_mnemonic = "GSMST":U          AND
         gsm_category.category_type           = pcCategoryType     AND
         gsm_category.category_group          = pcCategoryGroup    AND
         gsm_category.category_subgroup       = pcCategorySubGroup
         NO-LOCK NO-ERROR.
    IF AVAILABLE gsm_category THEN
        FIND FIRST gsm_status WHERE
                   gsm_status.category_obj = gsm_category.category_obj
                   NO-LOCK NO-ERROR.
END.    /* use category */

IF AVAILABLE gsm_status THEN
DO:
    CREATE ttStatusCache.
    ASSIGN ttStatusCache.tStatusObj         = gsm_status.status_obj
           ttStatusCache.tCategoryType      = gsm_category.category_type
           ttStatusCache.tCategoryGroup     = gsm_category.category_group
           ttStatusCache.tCategorySubGroup  = gsm_category.category_subgroup
           ttStatusCache.tStatusShortDesc   = gsm_status.status_short_desc
           ttStatusCache.tStatusDescription = gsm_status.status_description
           ttStatusCache.tStatusTLA         = gsm_status.status_tla
           .
    RAW-TRANSFER BUFFER ttStatusCache TO FIELD prStatusCache.
END.    /* avail category */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


