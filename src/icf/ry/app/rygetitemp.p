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
                
  Parameters:   pcCategories     - Comma-separated list of Categories to load.  
                pcActionList     - Comma-separated list of Actions to load. 
                ttAction         = gsm_menu_item 
                ttCategory       = gsc_item_category
  
   Notes:      The two first parameters are independent of each other. 
 -----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&scop object-name       rygetitemp.p
&scop object-version    010200

/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

{af/sup2/afglobals.i}     /* Astra global shared variables */

{src/adm2/ttaction.i}


DEFINE INPUT PARAMETER  pcCategories            AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcActions               AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pdUserObj               AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdOrganisationObj       AS DECIMAL    NO-UNDO.

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
DEFINE VARIABLE cCategory AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAction   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCategory AS INTEGER    NO-UNDO.
DEFINE VARIABLE iAction   AS INTEGER    NO-UNDO.
 
EMPTY TEMP-TABLE ttAction.
EMPTY TEMP-TABLE ttCategory.

IF pcCategories <> '':U THEN
DO iAction = 1 TO NUM-ENTRIES(pcCategories):
  cCategory = ENTRY(iAction,pcCategories).
  FIND gsc_item_category NO-LOCK 
       WHERE gsc_item_category.item_category_label = cCategory NO-ERROR.
  
  IF AVAIL gsc_item_category THEN
  DO:
    FOR EACH gsm_menu_item NO-LOCK 
             WHERE gsm_menu_item.ITEM_category_obj = gsc_item_category.ITEM_category_obj:
      buildAction(gsm_menu_item.menu_item_obj,
                  pdUserObj,
                  pdOrganisationObj).
    END.
  END.
END.

IF pcActions <> '':U THEN
DO iAction = 1 TO NUM-ENTRIES(pcActions): 
  cAction = ENTRY(iAction,pcActions).
  FIND gsm_menu_item NO-LOCK 
       WHERE gsm_menu_item.menu_item_reference = cAction NO-ERROR.
  IF AVAIL gsm_menu_item THEN
    buildAction(gsm_menu_item.menu_item_obj,
                pdUserObj,
                pdOrganisationObj).
                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


