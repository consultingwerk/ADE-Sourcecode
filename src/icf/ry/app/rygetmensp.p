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
  File        : ry/app/rygetmensp.p  
  Description:  To get bands, actions and categories as well as
                toolbarBands and objectBands from the repository. 
                
  Parameters:   pcToolbar        - Objectname of a toolbar.  
                pcObjectList     - Comma-separated list of objects 
                                   (optional semi-colon separated Runattribute)
                pcband           - A band  (menu_structure_reference)
                pdUserObj         - user key
                pdOrganisationOBj - org key                     
                ttToolbarBand    = gsm_toolbar_menu_structure
                ttObjectBand     = gsm_object_menu_structure
                ttBand           = gsm_menu_structure   
                ttBandAction     = gsm_menu_structure_item
                ttAction         = gsm_menu_item 
                ttCategory       = gsc_item_category
  
   Notes:      The three first parameters are independent of each other. 
               All three may be used or just one of them. 
 -----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&scop object-name       rygetmensp.p
&scop object-version    010204

/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

{defrescd.i}              /* Default Result Code */
{af/sup2/afglobals.i}     /* Astra global shared variables */

{src/adm2/ttaction.i}
{src/adm2/tttoolbar.i}

DEFINE INPUT PARAMETER  pcToolbar               AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectList            AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcBandList              AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pdUserObj               AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdOrganisationObj       AS DECIMAL    NO-UNDO.

DEFINE OUTPUT PARAMETER TABLE FOR ttToolbarBand.
DEFINE OUTPUT PARAMETER TABLE FOR ttObjectBand.
DEFINE OUTPUT PARAMETER TABLE FOR ttBand. 
DEFINE OUTPUT PARAMETER TABLE FOR ttBandAction. 
DEFINE OUTPUT PARAMETER TABLE FOR ttAction.
DEFINE OUTPUT PARAMETER TABLE FOR ttCategory.

&IF DEFINED(server-side) = 0 &THEN
   {ry/app/rymenufunc.i}
&ENDIF

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
DEFINE VARIABLE lBuildTopOnly                   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iObject                         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iBand                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cObjectName                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRunAttribute                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lRestricted                     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cSecurityValue1                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSecurityValue2                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cClientResultCodes              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentResultCode              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hManagerHandle                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE iResultCode                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE dCustomizationResultObj         AS DECIMAL    NO-UNDO.

EMPTY TEMP-TABLE ttToolbarBand.
EMPTY TEMP-TABLE ttObjectBand.
EMPTY TEMP-TABLE ttBand.
EMPTY TEMP-TABLE ttBandAction.
EMPTY TEMP-TABLE ttAction.
EMPTY TEMP-TABLE ttCategory.

DEFINE BUFFER gsc_security_control     FOR gsc_security_control.
DEFINE BUFFER ryc_customization_result FOR ryc_customization_result.
DEFINE BUFFER ryc_smartobject          FOR ryc_smartobject.
DEFINE BUFFER gsc_instance_attribute   FOR gsc_instance_attribute.
DEFINE BUFFER gsm_menu_structure       FOR gsm_menu_structure.

FIND FIRST gsc_security_control NO-LOCK NO-ERROR.

ASSIGN lBuildTopOnly      = AVAILABLE gsc_security_control AND gsc_security_control.build_top_menus_only = YES
       hManagerHandle     = DYNAMIC-FUNCTION("getManagerHandle":U, "CustomizationManager":U).

IF VALID-HANDLE(hManagerHandle) THEN
    ASSIGN cClientResultCodes = DYNAMIC-FUNCTION("getClientResultCodes":U IN hManagerHandle).

IF cClientResultCodes = ? 
OR cClientResultCodes = "?":U
OR cClientResultCodes = "":U THEN
    ASSIGN cClientResultCodes = "{&DEFAULT-RESULT-CODE}":U.

/* Cycle through all the result codes for the session, building our toolbars by overlaying result code toolbar items over each other */

RC_blk:
DO iResultCode = NUM-ENTRIES(cClientResultCodes) TO 1 BY -1:

  ASSIGN cCurrentResultCode = ENTRY(iResultCode, cClientResultCodes).

    /* The &DEFAULT-RESULT-CODE does not really exist, so trying to find it is not possible, so check to get the correct *
     * customization_result_obj to be used to find the ryc_smartobject record with                                       */

  IF cCurrentResultCode <> "{&DEFAULT-RESULT-CODE}":U 
  THEN DO:
      FIND ryc_customization_result NO-LOCK
           WHERE ryc_customization_result.customization_result_code = cCurrentResultCode 
           NO-ERROR.

      IF NOT AVAILABLE ryc_customization_result THEN /* If this record is not available, a smartobject record for the customization and menu structures should also not exist */
          NEXT RC_blk.

      ASSIGN dCustomizationResultObj = ryc_customization_result.customization_result_obj.
  END.
  ELSE DO:
      IF AVAILABLE ryc_customization_result THEN RELEASE ryc_customization_result.
      ASSIGN dCustomizationResultObj = 0.
  END.

  IF pcToolbar <> '':U THEN
      FIND ryc_smartobject NO-LOCK
           WHERE ryc_smartobject.object_filename          = pcToolbar
             AND ryc_smartobject.customization_result_obj = dCustomizationResultObj
           NO-ERROR.

  IF AVAILABLE ryc_smartobject 
  THEN DO:
      FOR EACH gsm_toolbar_menu_structure NO-LOCK
         WHERE gsm_toolbar_menu_structure.object_obj = ryc_smartobject.smartobject_obj,
         FIRST gsm_menu_structure NO-LOCK
         WHERE gsm_menu_structure.menu_structure_obj = gsm_toolbar_menu_structure.menu_structure_obj
           AND gsm_menu_structure.disabled <> YES
            BY gsm_toolbar_menu_structure.object_obj
            BY gsm_toolbar_menu_structure.menu_structure_sequence:

          IF NOT CAN-FIND(FIRST ttToolbarBand
                          WHERE ttToolbarBand.ToolbarName = ryc_smartobject.object_filename
                            AND ttToolbarBand.Band        = gsm_menu_structure.menu_structure_code)
          AND buildBand(gsm_menu_structure.menu_structure_code, lBuildTopOnly, pdUserObj, pdOrganisationObj) 
          THEN DO:
              CREATE ttToolbarBand.
              ASSIGN ttToolbarBand.ToolbarName = ryc_smartobject.object_filename
                     ttToolbarBand.Sequence    = gsm_toolbar_menu_structure.menu_structure_sequence
                     ttToolbarBand.Band        = gsm_menu_structure.menu_structure_code
                     ttToolbarBand.Alignment   = gsm_toolbar_menu_structure.menu_structure_alignment
                     ttToolbarBand.InsertRule  = gsm_toolbar_menu_structure.insert_rule
                     ttToolbarBand.RowPosition = gsm_toolbar_menu_structure.menu_structure_row
                     ttToolbarBand.Spacing     = gsm_toolbar_menu_structure.menu_structure_spacing
                     ttToolbarBand.ResultCode  = cCurrentResultCode.
          END. /* if buildband() */
      END. /* FOR EACH gsm_toolbar_menu_structure NO-LOCK */  
  END.

  IF pcObjectList <> '':U 
  THEN DO:
      object-blk:
      DO iObject = 1 TO NUM-ENTRIES(pcObjectList): 
          ASSIGN cObjectName   = ENTRY(iObject,pcObjectList)
                 cRunattribute = IF NUM-ENTRIES(cObjectName,';':U) > 1 THEN ENTRY(2,cObjectName,';':U) ELSE '':U
                 cObjectName   = ENTRY(1,cObjectName,';':U).
   
          /* Find the ryc_smartobject for the specific customization */
          FIND FIRST ryc_smartobject NO-LOCK
               WHERE ryc_smartobject.object_filename          = cObjectName 
                 AND ryc_smartobject.customization_result_obj = dCustomizationResultObj 
               NO-ERROR.
          
          /* If a ryc_smartobject record does not exist, it is obviously not necessary to proceed trying to find menu structures which would not exist */
          IF NOT AVAILABLE ryc_smartobject THEN
              NEXT object-blk.

          IF cRunAttribute <> '':U THEN
              FIND FIRST gsc_instance_attribute NO-LOCK 
                   WHERE gsc_instance_attribute.attribute_code = cRunAttribute 
                   NO-ERROR.
          ELSE 
              RELEASE gsc_instance_attribute.
        
          menu-blk:
          FOR EACH gsm_object_menu_structure NO-LOCK
             WHERE gsm_object_menu_structure.object_obj = ryc_smartobject.smartobject_obj,
             FIRST gsm_menu_structure NO-LOCK
             WHERE gsm_menu_structure.menu_structure_obj = gsm_object_menu_structure.menu_structure_obj
               AND gsm_menu_structure.disabled <> YES
                BY gsm_object_menu_structure.object_obj  
                BY gsm_object_menu_structure.menu_structure_sequence:   
            
              /* if menu structure allocated to the object only for a specific run attribute,
               * then check the run attribute passed in, and ignore the menu structure if it
               * does not match */
              IF gsm_object_menu_structure.instance_attribute_obj <> 0 
              AND AVAILABLE gsc_instance_attribute 
              AND cRunAttribute <> "":U
              AND gsc_instance_attribute.instance_attribute_obj <> gsm_object_menu_structure.instance_attribute_obj THEN
                  NEXT menu-blk.
            
              IF buildBand(gsm_menu_structure.menu_structure_code,lBuildTopOnly,pdUserObj,pdOrganisationObj) 
              THEN DO:
                  CREATE ttObjectBand.
                  ASSIGN ttObjectBand.ObjectName    = ryc_smartobject.object_filename
                         ttObjectBand.RunAttribute  = IF AVAILABLE gsc_instance_attribute
                                                      THEN gsc_instance_attribute.attribute_code 
                                                      ELSE '':U
                         ttObjectBand.ResultCode    = IF AVAILABLE ryc_customization_result
                                                      THEN ryc_customization_result.customization_result_code
                                                      ELSE '{&DEFAULT-RESULT-CODE}':U
                         ttObjectBand.Band          = gsm_menu_structure.menu_structure_code
                         ttObjectBand.Sequence      = gsm_object_menu_structure.menu_structure_sequence
                         ttObjectBand.InsertSubmenu = gsm_object_menu_structure.insert_submenu.    

                  IF gsm_object_menu_structure.menu_item_obj <> 0 THEN 
                    ASSIGN ttObjectBand.Action = createAction(gsm_object_menu_structure.menu_item_obj).                                                 
              END.
          END. /* FOR EACH gsm_toolbar_menu_structure NO-LOCK */  
      END.     /* iObject */
  END.
END.

DO iBand = 1 TO NUM-ENTRIES(pcBandList):
    FIND gsm_menu_structure NO-LOCK
         WHERE gsm_menu_structure.menu_structure_code = ENTRY(iBand,pcBandList)
           AND gsm_menu_structure.disabled <> YES
         NO-ERROR.

    IF AVAIL gsm_menu_structure THEN
        buildBand(gsm_menu_structure.menu_structure_code, lBuildTopOnly, pdUserObj, pdOrganisationObj).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


