&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
         HEIGHT             = 13.67
         WIDTH              = 63.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


RUN extractMenuItems (INPUT pcStructureCode, INPUT pdMenuItemObj, OUTPUT pcDetailList).


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-extractMenuItems) = 0 AND (DEFINED(EXCLUDE-ALL) = 0 OR DEFINED(INCLUDE-extractMenuItems) <> 0) &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extractMenuItems Procedure 
PROCEDURE extractMenuItems :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcStructureCode AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdMenuItemObj   AS DECIMAL    NO-UNDO.
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
  
  IF pcStructureCode = "":U AND
     pdMenuItemObj = 0 THEN
    RETURN.
  
  ASSIGN cUserProperties = "currentUserObj,currentOrganisationObj".
  cUserValues = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                     INPUT cUserProperties,
                                                     INPUT NO).
  
  ASSIGN dCurrentUserObj  = DECIMAL(ENTRY(1,cUserValues,CHR(3)))
         dLoginCompanyObj = DECIMAL(ENTRY(1,cUserValues,CHR(3))) NO-ERROR.
  
  pcDetailList = "":U.
  
  IF pcStructureCode <> "":U THEN DO:
    FIND FIRST gsm_menu_structure NO-LOCK
         WHERE gsm_menu_structure.menu_structure_code = pcStructureCode 
         NO-ERROR.
    IF NOT AVAILABLE gsm_menu_structure THEN
      RETURN.
    FOR EACH  gsm_menu_structure_item
        WHERE gsm_menu_structure_item.menu_structure_obj = gsm_menu_structure.menu_structure_obj NO-LOCK,
        EACH  gsm_menu_item 
        WHERE gsm_menu_item.menu_item_obj   = gsm_menu_structure_item.menu_item_obj
        NO-LOCK:
      /* Security Check */
      RUN userSecurityCheck IN gshSecurityManager
          (INPUT dCurrentUserObj,
           INPUT dLoginCompanyObj,
           INPUT "GSMMI":U,
           INPUT gsm_menu_item.menu_item_obj,
           INPUT TRUE,
           OUTPUT lRestrict,
           OUTPUT cSecVal1,
           OUTPUT cSecVal2).
      IF lRestrict THEN
        NEXT.
      ASSIGN cLogicalObject = "":U
             cRunAttributes = "":U
             cPrivateData   = "":U.
      FIND FIRST gsc_instance_attribute NO-LOCK
           WHERE gsc_instance_attribute.instance_attribute_obj = gsm_menu_item.instance_attribute_obj NO-ERROR.
      IF AVAILABLE gsc_instance_attribute THEN 
        cRunAttributes = gsc_instance_attribute.attribute_code.
      FIND FIRST ryc_smartobject
           WHERE ryc_smartobject.smartobject_obj = gsm_menu_item.object_obj
           NO-LOCK NO-ERROR.
      IF AVAILABLE ryc_smartobject THEN
        ASSIGN cLogicalObject = ryc_smartobject.object_filename.
      ASSIGN cPrivateData = "LogicalObject" + CHR(6) + cLogicalObject + CHR(7) + "RunAttribute" + CHR(6) + cRunAttributes + CHR(7) + "Obj":U + CHR(6) + STRING(gsm_menu_structure_item.child_menu_structure_obj) + CHR(7) + "MNU" + CHR(6) + "YES".
      RUN translateMenuItem IN TARGET-PROCEDURE
                            (INPUT  gsm_menu_item.menu_item_obj,
                             INPUT  gsm_menu_item.source_language_obj,
                             OUTPUT cMenuItemLabel).
      IF cMenuItemLabel = "":U THEN
        cMenuItemLabel = gsm_menu_item.menu_item_label.
      /* Look for submenus */
      cSubMenu = "":U.
      
      IF gsm_menu_structure_item.child_menu_structure_obj > 0 THEN
        RUN extractMenuItems (INPUT "":U, INPUT gsm_menu_structure_item.child_menu_structure_obj, OUTPUT cSubMenu).
      IF cSubMenu <> "":U THEN 
      DO:
        ASSIGN cSubMenu = REPLACE(cSubMenu,CHR(3),CHR(1))
               cSubMenu = REPLACE(cSubMenu,CHR(4),"^":U)
               cSubMenu = REPLACE(cSubMenu,CHR(7),"@":U)
               cSubMenu = REPLACE(cSubMenu,CHR(6),"#":U).
        ASSIGN cPrivateData = cPrivateData + CHR(7) + "SubMenu" + CHR(6) + cSubmenu.
      END.
      
      ASSIGN pcDetailList = IF pcDetailList = "":U 
                               THEN REPLACE(cMenuItemLabel,"&":U,"":U) + CHR(4) + cPrivateData
                               ELSE pcDetailList + CHR(3) + REPLACE(cMenuItemLabel,"&":U,"":U) + CHR(4) + cPrivateData.


    END.
  END.
  
  IF pdMenuItemObj <> 0 THEN DO:
    FOR EACH  gsm_menu_structure_item
        WHERE gsm_menu_structure_item.menu_structure_obj = pdMenuItemObj NO-LOCK,
        EACH  gsm_menu_item 
        WHERE gsm_menu_item.menu_item_obj   = gsm_menu_structure_item.menu_item_obj
        NO-LOCK:
        /* Security Check */
        RUN userSecurityCheck IN gshSecurityManager
            (INPUT dCurrentUserObj,
             INPUT dLoginCompanyObj,
             INPUT "GSMMI":U,
             INPUT gsm_menu_item.menu_item_obj,
             INPUT TRUE,
             OUTPUT lRestrict,
             OUTPUT cSecVal1,
             OUTPUT cSecVal2).
        IF lRestrict THEN
          NEXT.
  
        ASSIGN cLogicalObject = "":U
               cRunAttributes = "":U
               cPrivateData   = "":U.
        FIND FIRST gsc_instance_attribute NO-LOCK
             WHERE gsc_instance_attribute.instance_attribute_obj = gsm_menu_item.instance_attribute_obj NO-ERROR.
        IF AVAILABLE gsc_instance_attribute THEN 
          cRunAttributes = gsc_instance_attribute.attribute_code.
        FIND FIRST ryc_smartobject
             WHERE ryc_smartobject.smartobject_obj = gsm_menu_item.object_obj
             NO-LOCK NO-ERROR.
        IF AVAILABLE ryc_smartobject THEN
          ASSIGN cLogicalObject = ryc_smartobject.object_filename.
        
        ASSIGN cPrivateData = "LogicalObject" + CHR(6) + cLogicalObject + CHR(7) + "RunAttribute" + CHR(6) + cRunAttributes + CHR(7) + "Obj":U + CHR(6) + STRING(gsm_menu_structure_item.child_menu_structure_obj) + CHR(7) + "MNU" + CHR(6) + "YES".
        RUN translateMenuItem (INPUT  gsm_menu_item.menu_item_obj,
                               INPUT  gsm_menu_item.source_language_obj,
                               OUTPUT cMenuItemLabel).
        IF cMenuItemLabel = "":U THEN
          cMenuItemLabel = gsm_menu_item.menu_item_label.
        ASSIGN pcDetailList = IF pcDetailList = "":U 
                                 THEN REPLACE(gsm_menu_item.menu_item_label,"&":U,"":U) + CHR(4) + cPrivateData
                                 ELSE pcDetailList + CHR(3) + REPLACE(gsm_menu_item.menu_item_label,"&":U,"":U) + CHR(4) + cPrivateData.
      
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-translateMenuItem) = 0 AND (DEFINED(EXCLUDE-ALL) = 0 OR DEFINED(INCLUDE-translateMenuItem) <> 0) &THEN

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
  IF dLoginLanguageObj <> pdSourceLanguageObj THEN DO:
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
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

