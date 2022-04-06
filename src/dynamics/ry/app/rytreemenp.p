&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
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
/*---------------------------------------------------------------------------------
  File: rytreemenp.p

  Description:  DynTree Menu Structure retrieval proc

  Purpose:     This procedure will read all the child menu items of a parent menu
               item and adds them to the node temp-table.
  Parameters:  I pcStructureCode - The code of the menu structure to be read.
                                   The code will only be passed if this is called
                                   the first time.
               I pcMenuItemObj   - The object number of the parent menu item
               O pcDetailList    - A string list returned with details required
                                   to populate the nodes. Is CHR(3) seperated

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/06/2003  Author:     Mark Davies (MIP)

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rytreemenp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

&IF DEFINED(server-side) = 0 &THEN
   {ry/app/rymenufunc.i}
&ENDIF

DEFINE INPUT  PARAMETER pcStructureCode AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pdMenuItemObj   AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER piMenuLevel     AS INTEGER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcDetailList    AS CHARACTER  NO-UNDO.

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
         HEIGHT             = 12.95
         WIDTH              = 48.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


RUN extractMenuItems (INPUT pcStructureCode, 
                      INPUT pdMenuItemObj, 
                      INPUT piMenuLevel,
                      OUTPUT pcDetailList).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-extractMenuItems) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extractMenuItems Procedure 
PROCEDURE extractMenuItems :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcStructureCode AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdMenuItemObj   AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER piMenuLevel     AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcDetailList    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cLogicalObject        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cRunAttributes        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cPrivateData          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cDetailList           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cUserProperties       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cUserValues           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE dCurrentUserObj       AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dLoginCompanyObj      AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE lRestrict             AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE cSecVal1              AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cSecVal2              AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cMenuItemLabel        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cSubMenu              AS CHARACTER    NO-UNDO.
  
  DEFINE BUFFER bMenuStruct     FOR gsm_menu_structure.
  DEFINE BUFFER bMenuStructItem FOR gsm_menu_structure_item.
  DEFINE BUFFER bMenuItem       FOR gsm_menu_item.

  IF pdMenuItemObj = 0 THEN
  DO:
    FIND FIRST bMenuStruct NO-LOCK
         WHERE bMenuStruct.menu_structure_code = pcStructureCode 
         NO-ERROR.
    IF AVAILABLE bMenuStruct THEN
      pdMenuItemObj = bMenuStruct.menu_structure_obj.
  END.

  IF pdMenuItemObj <> 0 THEN
  DO:
    ASSIGN 
      cUserProperties = "currentUserObj,currentOrganisationObj"
      cUserValues = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                       INPUT cUserProperties,
                                                       INPUT NO)
      dCurrentUserObj  = DECIMAL(ENTRY(1,cUserValues,CHR(3)))
      dLoginCompanyObj = DECIMAL(ENTRY(2,cUserValues,CHR(3))) NO-ERROR.

    FOR EACH  bMenuStructItem WHERE bMenuStructItem.menu_structure_obj = pdMenuItemObj NO-LOCK,
        EACH  bMenuItem WHERE bMenuItem.menu_item_obj   = bMenuStructItem.menu_item_obj
        NO-LOCK:

      /* Security Check */
      RUN userSecurityCheck IN gshSecurityManager (INPUT dCurrentUserObj,
                                                   INPUT dLoginCompanyObj,
                                                   INPUT "GSMMI":U,
                                                   INPUT bMenuItem.menu_item_obj,
                                                   INPUT TRUE,
                                                   OUTPUT lRestrict,
                                                   OUTPUT cSecVal1,
                                                   OUTPUT cSecVal2).
      IF lRestrict THEN NEXT.

      ASSIGN cLogicalObject = "":U
             cRunAttributes = "":U
             cPrivateData   = "":U.
      FIND FIRST gsc_instance_attribute NO-LOCK
           WHERE gsc_instance_attribute.instance_attribute_obj = bMenuItem.instance_attribute_obj NO-ERROR.
      IF AVAILABLE gsc_instance_attribute THEN 
        cRunAttributes = gsc_instance_attribute.attribute_code.
      FIND FIRST ryc_smartobject
           WHERE ryc_smartobject.smartobject_obj = bMenuItem.object_obj
           NO-LOCK NO-ERROR.
      IF AVAILABLE ryc_smartobject THEN
        cLogicalObject = ryc_smartobject.object_filename.

      /* get possible translation of the label */
      RUN translateMenuItem IN TARGET-PROCEDURE (INPUT  bMenuItem.menu_item_obj,
                                                 INPUT  bMenuItem.source_language_obj,
                                                 OUTPUT cMenuItemLabel).
      IF cMenuItemLabel = "":U THEN
         cMenuItemLabel = bMenuItem.menu_item_label.


      /* construct one node entry in the list */
      ASSIGN
        cPrivateData = "LogicalObject":U + CHR(6) + cLogicalObject + CHR(6) + 
                       "RunAttribute":U + CHR(6) + cRunAttributes + CHR(6) + 
                       "Obj":U + CHR(6) + STRING(bMenuStructItem.child_menu_structure_obj) + CHR(6) + 
                       "MNU":U + CHR(6) + "YES"
        cMenuItemLabel = REPLACE(cMenuItemLabel,"&":U,"":U)
        pcDetailList = pcDetailList + 
                       (IF pcDetailList = "" THEN "" ELSE CHR(3)) +
                       STRING(piMenuLevel) + CHR(4) + cMenuItemLabel + CHR(4) + cPrivateData.

      /* Check for submenu and add it to the list */
      cSubMenu = "":U.
      IF bMenuStructItem.child_menu_structure_obj > 0 THEN 
      DO:
        RUN extractMenuItems (INPUT "":U, 
                              INPUT bMenuStructItem.child_menu_structure_obj, 
                              INPUT piMenuLevel + 1,
                              OUTPUT cSubMenu).
        IF cSubMenu > "":U THEN 
          pcDetailList = pcDetailList + CHR(3) + cSubMenu.
      END.
    END.  /* FOR EACH Menu_Structure_Item */
  END.
  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-translateMenuItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE translateMenuItem Procedure 
PROCEDURE translateMenuItem :
/*------------------------------------------------------------------------------
  Purpose:     Translates the given menu items
  Parameters:  pdMenuItemObj - The object id of the menu item to be translated.
               pdSourceLanguageObj - The source language of the language to
                                     translate from.
               pcMenuItemLabel - The translated label of the passed in menu item
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdMenuItemObj       AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdSourceLanguageObj AS DECIMAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcMenuItemLabel     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE dTransLanguageObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dLoginLanguageObj AS DECIMAL    NO-UNDO.
  
  pcMenuItemLabel = "":U.

  /* Get the current login language */
  dLoginLanguageObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                INPUT "CurrentLanguageObj":U,
                                                INPUT NO)) NO-ERROR.
  /* If the login language is not the same as the menu item's source language
     then we will attempt to try and find a translated menu item */
  dTransLanguageObj = canFindTranslation(pdMenuItemObj,dLoginLanguageObj).
  IF dTransLanguageObj <> 0 AND
     dTransLanguageObj <> ? THEN DO:
    FIND FIRST gsm_translated_menu_item
         WHERE gsm_translated_menu_item.menu_item_obj = pdMenuItemObj
         AND   gsm_translated_menu_item.language_obj  = dTransLanguageObj
         NO-LOCK NO-ERROR.
    IF AVAILABLE gsm_translated_menu_item THEN
      pcMenuItemLabel = gsm_translated_menu_item.menu_item_label.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

