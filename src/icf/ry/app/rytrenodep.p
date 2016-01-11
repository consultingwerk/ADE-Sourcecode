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
/* Define temp-tables required */
{ry/inc/rytrettdef.i}

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
      FIND FIRST gsc_object
           WHERE gsc_object.object_obj = gsm_menu_item.object_obj
           NO-LOCK NO-ERROR.
      IF AVAILABLE gsc_object THEN
        ASSIGN cLogicalObject = gsc_object.object_filename.
      ASSIGN cPrivateData = "LogicalObject" + CHR(6) + cLogicalObject + CHR(7) + "RunAttribute" + CHR(6) + cRunAttributes + CHR(7) + "Obj":U + CHR(6) + STRING(gsm_menu_structure_item.child_menu_structure_obj) + CHR(7) + "MNU" + CHR(6) + "YES".
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
        FIND FIRST gsc_object
             WHERE gsc_object.object_obj = gsm_menu_item.object_obj
             NO-LOCK NO-ERROR.
        IF AVAILABLE gsc_object THEN
          ASSIGN cLogicalObject = gsc_object.object_filename.
        
        ASSIGN cPrivateData = "LogicalObject" + CHR(6) + cLogicalObject + CHR(7) + "RunAttribute" + CHR(6) + cRunAttributes + CHR(7) + "Obj":U + CHR(6) + STRING(gsm_menu_structure_item.child_menu_structure_obj) + CHR(7) + "MNU" + CHR(6) + "YES".
        ASSIGN pcDetailList = IF pcDetailList = "":U 
                                 THEN REPLACE(gsm_menu_item.menu_item_label,"&":U,"":U) + CHR(4) + cPrivateData
                                 ELSE pcDetailList + CHR(3) + REPLACE(gsm_menu_item.menu_item_label,"&":U,"":U) + CHR(4) + cPrivateData.
      
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

