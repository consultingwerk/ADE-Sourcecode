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
  File: afomsdumpp.p

  Description:  Object Menu Structure Dump Procedure

  Purpose:      This procedure dumps all object menu structure records to the specified
                flat file for subsequent loading into a new database via
                af/sup/afomsloadp.p
                The flat file contains denormalised data as object numbers between
                databases can not be used.

  Parameters:   ip_dump_file_name

  History:
  --------
  (v:010000)    Task:        1277   UserRef:    
                Date:   28/04/1999  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

  (v:010001)    Task:        3429   UserRef:    
                Date:   05/11/1999  Author:     Anthony Swindells

  Update Notes: Fix system owned data / imports from RTB. Modify system owned data in
                take-on tables and associated load programs to reflect new database changes
                for system owned data enhancements.

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afomsdumpp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE INPUT PARAMETER ip_dump_file_name                AS CHARACTER    NO-UNDO.

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
         HEIGHT             = 11.67
         WIDTH              = 42.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

OUTPUT TO VALUE(ip_dump_file_name).

RUN object-menu-structure-dump.

OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-object-menu-structure-dump) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE object-menu-structure-dump Procedure 
PROCEDURE object-menu-structure-dump :
/*------------------------------------------------------------------------------
  Purpose:     Dump object menu structures to flat file
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lv_attribute_code AS CHARACTER NO-UNDO.

FOR EACH gsm_object_menu_structure NO-LOCK,
   FIRST ryc_smartobject NO-LOCK
   WHERE ryc_smartobject.smartobject_obj = gsm_object_menu_structure.object_obj,
   FIRST gsm_menu_structure NO-LOCK
   WHERE gsm_menu_structure.menu_structure_obj = gsm_object_menu_structure.menu_structure_obj:

    FIND FIRST gsc_instance_attribute NO-LOCK
         WHERE gsc_instance_attribute.instance_attribute_obj = gsm_object_menu_structure.instance_attribute_obj
         NO-ERROR.
    IF AVAILABLE gsc_instance_attribute AND gsm_object_menu_structure.instance_attribute_obj <> 0 THEN
      ASSIGN lv_attribute_code = gsc_instance_attribute.attribute_code.
    ELSE
      ASSIGN lv_attribute_code = "":U.

    EXPORT
        ryc_smartobject.object_filename
        gsm_menu_structure.menu_structure_code
        lv_attribute_code
        .        
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

