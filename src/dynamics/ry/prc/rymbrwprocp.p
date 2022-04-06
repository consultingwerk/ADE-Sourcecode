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
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rymbrwprocp.p

  Description:  Dynamic Browse Extract Procedure

  Purpose:      Dynamic Browse Extract Procedure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   02/08/2002  Author:     Mark Davies (MIP)

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rymbrwprocp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE INPUT  PARAMETER pctmp_propsheet_browobject_name AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pctmpdisplayedfields            AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pctmpenabledfields              AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pctmplaunchcontainer            AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcsdoname                       AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcCustomSuperProcedure          AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcObjectDescription             AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcObjectFilename                AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pdProductModuleObj              AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcError                         AS CHARACTER  NO-UNDO.

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
         HEIGHT             = 11.71
         WIDTH              = 77.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.

FIND LAST ryc_smartobject 
    WHERE ryc_smartobject.object_filename = pctmp_propsheet_browObject_name
    NO-LOCK NO-ERROR.

IF NOT AVAILABLE ryc_smartobject THEN DO:
  pcerror = "Ryc_smartobject is not available.".
  RETURN.
END.
ELSE DO:
   ASSIGN pcObjectDescription = ryc_smartobject.object_description
          pcObjectFileName    = ryc_smartobject.object_filename.

   FIND FIRST ryc_attribute_value 
        WHERE ryc_attribute_value.OBJECT_type_obj             = ryc_smartobject.object_type_obj 
        AND   ryc_attribute_value.smartobject_obj             = ryc_smartobject.smartobject_obj
        AND   ryc_attribute_value.object_instance_obj         = 0
        AND   ryc_attribute_value.attribute_label             = "displayedfields" 
        AND   ryc_attribute_value.container_smartobject_obj   = 0
        NO-LOCK NO-ERROR.

   IF AVAILABLE ryc_attribute_value THEN
      ASSIGN pctmpdisplayedfields = ryc_attribute_value.character_value.
   ELSE 
      ASSIGN pctmpdisplayedfields = "":U.

   FIND FIRST ryc_attribute_value 
        WHERE ryc_attribute_value.OBJECT_type_obj             = ryc_smartobject.object_type_obj 
        AND   ryc_attribute_value.smartobject_obj             = ryc_smartobject.smartobject_obj
        AND   ryc_attribute_value.object_instance_obj         = 0
        AND   ryc_attribute_value.attribute_label             = "enabledfields" 
        AND   ryc_attribute_value.container_smartobject_obj   = 0
        NO-LOCK NO-ERROR.

   IF AVAILABLE ryc_attribute_value THEN
      ASSIGN pctmpenabledfields = ryc_attribute_value.character_value.

   FIND FIRST ryc_attribute_value 
        WHERE ryc_attribute_value.OBJECT_type_obj             = ryc_smartobject.object_type_obj 
        AND   ryc_attribute_value.smartobject_obj             = ryc_smartobject.smartobject_obj
        AND   ryc_attribute_value.object_instance_obj         = 0
        AND   ryc_attribute_value.attribute_label             = "FolderWindowToLaunch"
        AND   ryc_attribute_value.container_smartobject_obj   = 0
        NO-LOCK NO-ERROR.

   IF AVAILABLE ryc_attribute_value THEN
       ASSIGN pctmplaunchcontainer   = ryc_attribute_value.character_value
              pdProductModuleObj     = ryc_smartobject.product_module_obj.

   /* Find the custom super procedure filename */
   ASSIGN pcCustomSuperProcedure = "":U.
    FIND FIRST ryc_attribute_value 
         WHERE ryc_attribute_value.OBJECT_type_obj             = ryc_smartobject.object_type_obj 
         AND   ryc_attribute_value.smartobject_obj             = ryc_smartobject.smartobject_obj
         AND   ryc_attribute_value.object_instance_obj         = 0
         AND   ryc_attribute_value.attribute_label             = "SuperProcedure":U
         AND   ryc_attribute_value.container_smartobject_obj   = 0
         NO-LOCK NO-ERROR.
    IF AVAILABLE ryc_attribute_value THEN
        ASSIGN pcCustomSuperProcedure = ryc_attribute_value.character_value.

   FIND FIRST bryc_smartobject
        WHERE bryc_smartobject.smartobject_obj = ryc_smartobject.sdo_smartobject_obj
        NO-LOCK NO-ERROR.
    IF AVAIL bryc_smartobject THEN
      ASSIGN pcsdoname = bryc_smartobject.object_filename.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


