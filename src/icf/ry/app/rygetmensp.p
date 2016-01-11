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

EMPTY TEMP-TABLE ttToolbarBand.
EMPTY TEMP-TABLE ttObjectBand.
EMPTY TEMP-TABLE ttBand.
EMPTY TEMP-TABLE ttBandAction.
EMPTY TEMP-TABLE ttAction.
EMPTY TEMP-TABLE ttCategory.

FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
ASSIGN
  lBuildTopOnly = (IF AVAILABLE gsc_security_control
                   AND gsc_security_control.build_top_menus_only = NO
                   THEN NO
                   ELSE YES).

IF pcToolbar <> '':U THEN 
  FIND gsc_object NO-LOCK
     WHERE gsc_object.object_filename = pcToolbar NO-ERROR.
IF AVAILABLE gsc_object THEN
DO:     
  FOR EACH gsm_toolbar_menu_structure NO-LOCK
       WHERE gsm_toolbar_menu_structure.object_obj = gsc_object.object_obj,
      FIRST gsm_menu_structure NO-LOCK
       WHERE gsm_menu_structure.menu_structure_obj = gsm_toolbar_menu_structure.menu_structure_obj
       AND   gsm_menu_structure.disabled <> YES
  BY gsm_toolbar_menu_structure.object_obj
  BY gsm_toolbar_menu_structure.menu_structure_sequence:
     
    IF buildBand(gsm_menu_structure.menu_structure_code,
                 lBuildTopOnly,
                 pdUserObj,
                 pdOrganisationObj) THEN
    DO:                 
      CREATE ttToolbarBand.
      ASSIGN 
       ttToolbarBand.ToolbarName = gsc_object.object_filename
       ttToolbarBand.Sequence    = gsm_toolbar_menu_structure.menu_structure_sequence
       ttToolbarBand.Band        = gsm_menu_structure.menu_structure_code
       ttToolbarBand.Alignment   = gsm_toolbar_menu_structure.menu_structure_alignment
       ttToolbarBand.InsertRule  = gsm_toolbar_menu_structure.insert_rule
       ttToolbarBand.RowPosition = gsm_toolbar_menu_structure.menu_structure_row
       ttToolbarBand.Spacing     = gsm_toolbar_menu_structure.menu_structure_spacing
      .
    END. /* if buildband() */
  END. /* FOR EACH gsm_toolbar_menu_structure NO-LOCK */  
END.

IF pcObjectList <> '':U THEN 
DO iObject = 1 TO NUM-ENTRIES(pcObjectList): 
  ASSIGN 
    cObjectName   = ENTRY(iObject,pcObjectList)
    cRunattribute = IF NUM-ENTRIES(cObjectName,';':U) > 1 
                    THEN ENTRY(2,cObjectName,';':U)
                    ELSE '':U
    cObjectName   = ENTRY(1,cObjectName,';':U).

  FIND gsc_object NO-LOCK
     WHERE gsc_object.object_filename = cObjectName NO-ERROR.
  
  IF cRunAttribute <> '':U THEN
    FIND FIRST gsc_instance_attribute NO-LOCK 
         WHERE gsc_instance_attribute.attribute_code = cRunAttribute 
         NO-ERROR.
  ELSE 
    RELEASE gsc_instance_attribute.

  FOR EACH gsm_object_menu_structure NO-LOCK
     WHERE gsm_object_menu_structure.object_obj = gsc_object.object_obj,
     FIRST gsm_menu_structure NO-LOCK
     WHERE gsm_menu_structure.menu_structure_obj = gsm_object_menu_structure.menu_structure_obj
       AND gsm_menu_structure.disabled <> YES
  BY gsm_object_menu_structure.object_obj  
  BY gsm_object_menu_structure.menu_structure_sequence:   
    
    /* if menu structure allocated to the object only for a specific run attribute,
       then check the run attribute passed in, and ignore the menu structure if it
       does not match */
    IF gsm_object_menu_structure.instance_attribute_obj <> 0 THEN
    DO:
      IF AVAILABLE gsc_instance_attribute AND cRunAttribute <> "":U 
      AND gsc_instance_attribute.instance_attribute_obj
          <> gsm_object_menu_structure.instance_attribute_obj THEN
          NEXT.
    END.
    
    /* check if user has security clearance for menu structure */
    RUN userSecurityCheck IN gshSecurityManager (INPUT pdUserObj,
                                                 INPUT pdOrganisationObj,
                                                 INPUT "gsmms":U,
                                                 INPUT gsm_menu_structure.menu_structure_obj,
                                                 INPUT  NO,
                                                 OUTPUT lRestricted,
                                                 OUTPUT cSecurityValue1,
                                                 OUTPUT cSecurityValue2).

    IF lRestricted THEN NEXT.

    IF buildBand(gsm_menu_structure.menu_structure_code,
                 lBuildTopOnly,
                 pdUserObj,
                 pdOrganisationObj) THEN
    DO:    
      CREATE ttObjectBand.
      ASSIGN 
        ttObjectBand.ObjectName    = gsc_object.object_filename
        ttObjectBand.RunAttribute  = IF AVAILABLE gsc_instance_attribute
                                     THEN gsc_instance_attribute.attribute_code 
                                     ELSE '':U
        ttObjectBand.Band          = gsm_menu_structure.menu_structure_code
        ttObjectBand.Sequence      = gsm_object_menu_structure.menu_structure_sequence
        ttObjectBand.InsertSubmenu = gsm_object_menu_structure.insert_submenu
        .    
      IF gsm_object_menu_structure.menu_item_obj <> 0 THEN 
        ttObjectBand.Action = createAction(gsm_object_menu_structure.menu_item_obj).
                                         
    END.
  END. /* FOR EACH gsm_toolbar_menu_structure NO-LOCK */  
END.

DO iBand = 1 TO NUM-ENTRIES(pcBandList):
  FIND gsm_menu_structure NO-LOCK
       WHERE gsm_menu_structure.menu_structure_code = ENTRY(iBand,pcBandList)
       AND   gsm_menu_structure.disabled <> YES
  NO-ERROR.
  IF AVAIL gsm_menu_structure THEN
    buildBand(gsm_menu_structure.menu_structure_code,
              lBuildTopOnly,
              pdUserObj,
              pdOrganisationObj).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


