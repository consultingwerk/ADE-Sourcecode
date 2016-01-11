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
/*---------------------------------------------------------------------------------
  File: rytrenodep.p

  Description:  Child Node Retrival Procedure

  Purpose:      Child Node Retrival Procedure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:   101000001   UserRef:    
                Date:   08/13/2001  Author:     Mark Davies

  Update Notes: Created from Template rytemplipp.p
                Child Node Retrival Procedure

  (v:010001)    Task:           0   UserRef:    
                Date:   01/15/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3020 - 'Menu Item' security and Treeview.
                Added security check for menu items
  
  (v:010002)    Task:           0   UserRef:    
                Date:   04/10/2002  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3071 - It's not possible to translate menus
                Added menu translation features for TreeView Menu structures

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rytrenodep.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{af/sup2/afglobals.i}

/* Define temp-tables required - changed to use ADM2 temp-table as this originally pulled
   in the temp-table from ry/inc/rytrettdef.i which was defined LIKE and the temp table in the
   ADM2 include file was hard coded - causing mismatch errors after schema changes.
*/
{src/adm2/treettdef.i}

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


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-returnSDOName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD returnSDOName Procedure 
FUNCTION returnSDOName RETURNS CHARACTER
  ( INPUT pcSDOSBOName AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 10.33
         WIDTH              = 44.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm/method/attribut.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-cacheNodeTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cacheNodeTable Procedure 
PROCEDURE cacheNodeTable :
/*------------------------------------------------------------------------------
  Purpose:     This procedure loads all the node details into a temp-table that
               will be used to Cache the node details.
  Parameters:  I pcParentNodeCode - The root_node_code for this Instance (first
                                    time only) From TreeView
               I pdParentNodeObj  - Only used when called repearedly fro itself
  Notes:       O ttNode           - Temp table created to load data into.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcParentNodeCode  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pdParentNodeObj   AS DECIMAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER TABLE FOR ttNode.
  
  DEFINE BUFFER buNode FOR gsm_node.
  
  /* This will only be valid the first time this 
     procedure is called - Usually from the TreeView */
  IF pcParentNodeCode <> "":U THEN DO:
    EMPTY TEMP-TABLE ttNode.
    FIND FIRST gsm_node 
         WHERE gsm_node.node_code = pcParentNodeCode
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gsm_node THEN
      RETURN.
    ELSE DO:
      CREATE ttNode.
      BUFFER-COPY gsm_node TO ttNode.
      pdParentNodeObj = gsm_node.node_obj.
    END.
  END.
  
  FOR EACH  buNode
      WHERE buNode.parent_node_obj = pdParentNodeObj
      NO-LOCK:
    CREATE ttNode.
    BUFFER-COPY buNode TO ttNode.
    RUN cacheNodeTable (INPUT  "":U,
                        INPUT  buNode.node_obj,
                        OUTPUT TABLE ttNode).
  END.
  
  FOR EACH ttNode:
    IF ttNode.data_source_type = "SDO":U AND 
       ttNode.data_source <> "":U THEN
      ASSIGN ttNode.data_source = returnSDOName(ttNode.data_source).
    IF ttNode.primary_sdo <> "":U THEN
      ASSIGN ttNode.primary_sdo = returnSDOName(ttNode.primary_sdo).
  END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "TreeView Node AppServer Extract PLIP".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipsetu.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-readMenuStructure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readMenuStructure Procedure 
PROCEDURE readMenuStructure :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will read all the child menu items of a parent menu
               item and adds them to the node temp-table.
  Parameters:  I pcStructureCode - The code of the menu structure to be read.
                                   The code will only be passed if this is called
                                   the first time.
               I pcMenuItemObj   - The object number of the parent menu item
               O pcDetailList    - A string list returned with details required
                                   to populate the nodes. Is CHR(3) seperated
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

&IF DEFINED(EXCLUDE-translateMenuItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE translateMenuItem Procedure 
PROCEDURE translateMenuItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
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

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-returnSDOName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION returnSDOName Procedure 
FUNCTION returnSDOName RETURNS CHARACTER
  ( INPUT pcSDOSBOName AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will add a relative path to the SDO/SBO name passed to it
    Notes:  
------------------------------------------------------------------------------*/
  FIND FIRST ryc_smartobject 
       WHERE ryc_smartobject.object_filename = pcSDOSBOName
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ryc_smartobject THEN
    RETURN pcSDOSBOName.
  
  /* Dynamic objects have no object path, so we only check for the existence of the path
   * for static objects.  */
  IF LOGICAL(ryc_smartobject.static_object) AND (ryc_smartobject.object_path = "":U OR ryc_smartobject.object_path = ?) THEN
    RETURN pcSDOSBOName.
  ELSE
    ASSIGN pcSDOSBOName = ryc_smartobject.object_path + "/":U + pcSDOSBOName
           pcSDOSBOName = REPLACE(pcSDOSBOName,"~\":U,"/":U).
  
  IF ryc_smartobject.object_extension <> "":U AND
     NUM-ENTRIES(pcSDOSBOName,".":U) < 2 THEN
    pcSDOSBOName = pcSDOSBOName + ".":U + ryc_smartobject.object_extension.

  RETURN pcSDOSBOName.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

