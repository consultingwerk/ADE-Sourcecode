&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Include _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Include _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afttdynmenu.i

  Description:  Dynamic Menus Temp Tables

  Purpose:      Dynamic Menus Temp Tables

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6063   UserRef:    
                Date:   16/06/2000  Author:     Anthony Swindells

  Update Notes: Implement toolbar menus

  (v:010001)    Task:        6830   UserRef:    
                Date:   09/10/2000  Author:     Anthony Swindells

  Update Notes: Fix menu item exists errors

-----------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afttdynmenu.i
&scop object-version    010001


/* MIP object identifying preprocessor */
&glob   mip-structured-include  yes

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 5.57
         WIDTH              = 64.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

&IF DEFINED(ttdynmenu) = 0 &THEN
  /* temp table of which menu structures used by object
     NB: if object does not use any menu strutures, a blank menu structure code
     will be added to temp-table for object to prevent it from going and checking
     in the database again to see if it needs any menu structures.
  */
  DEFINE TEMP-TABLE ttObjectMenuStructure NO-UNDO
  FIELD cObjectName AS CHARACTER
  FIELD cMenuStructureCode AS CHARACTER
  INDEX key1 AS UNIQUE PRIMARY cObjectName cMenuStructureCode
  INDEX key2 AS UNIQUE cMenuStructureCode cObjectName
  .

  /* temp-table of menu structures - for client caching in toolbars */
  DEFINE TEMP-TABLE ttMenuStructure NO-UNDO
  FIELD dMenuStructureObj  AS DECIMAL
  FIELD cMenuStructureCode AS CHARACTER
  FIELD cMenuStructureDesc AS CHARACTER
  FIELD lUnderDevelopment  AS LOGICAL
  FIELD lTopOnly           AS LOGICAL
  INDEX key1 AS UNIQUE PRIMARY dMenuStructureObj
  INDEX key2 AS UNIQUE cMenuStructureCode
  INDEX key3 cMenuStructureDesc
  .

  /* temp-table if menu items - for client caching in toolbars
     We always cache a full menu structure when its menu is built, so we will
     never have incomplete menu items for a specfic structure - we either have
     all or none.
  */  
  DEFINE TEMP-TABLE ttMenuItem NO-UNDO LIKE gsm_menu_item
  FIELD cRunAttribute AS CHARACTER
  FIELD lSecurityCleared AS LOGICAL
  FIELD cPhysicalObjectFilename AS CHARACTER
  FIELD cLogicalObjectFilename AS CHARACTER
  FIELD cDbRequiredList AS CHARACTER
  FIELD lRunPersistent AS LOGICAL
  FIELD lNoChildren AS LOGICAL
  INDEX key1 AS UNIQUE PRIMARY MENU_structure_obj PARENT_menu_item_obj MENU_item_sequence
  INDEX key2 MENU_structure_obj toolbar_image_sequence MENU_item_sequence
  INDEX key3 AS UNIQUE MENU_item_reference
  INDEX key4 MENU_structure_obj PARENT_menu_item_obj lNoChildren
  .

  &GLOBAL-DEFINE ttdynmenu
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


