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
  File: affldschkp.p

  Description:  Field Security Check Procedure

  Purpose:      Field Security Check Procedure
                Check user security for fields permitted access to
                The procedure is run on the Appserver as an external procedure non
                persistently from the Client Security Manager, and is included as in internal
                procedre in the Server Security Manager.

  Parameters:   input current program name for security check (no path)
                input current instance attribute posted to program
                output security options as comma delimited list of secured
                fields, each with 2 entries. Entry 1 = table.fieldname,
                Entry 2 = hidden / view

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   01/06/2000  Author:     Anthony Swindells

  Update Notes: Write Astra2 Toolbar

  (v:010001)    Task:        6066   UserRef:    
                Date:   19/06/2000  Author:     Anthony Swindells

  Update Notes: Fix Security Manager.
                Was not checking property values using chr(3)

  (v:010002)    Task:        6067   UserRef:    
                Date:   19/06/2000  Author:     Anthony Swindells

  Update Notes: Security Mods. Get product module rather than pass in product module.

  (v:010100)    Task:    90000045   UserRef:    POSSE
                Date:   21/04/2001  Author:     Phil Magnay

  Update Notes: Logic changes due to new security allocations method

------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       affldschkp.p
&scop object-version    000000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes


{af/sup2/afglobals.i}     /* Astra global shared variables */

DEFINE INPUT PARAMETER  pcObjectName                    AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  pcAttributeCode                 AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcSecurityOptions               AS CHARACTER    NO-UNDO.

DEFINE VARIABLE         dAttributeObj                   AS DECIMAL      NO-UNDO.
DEFINE VARIABLE         lSecurityRestricted             AS LOGICAL      NO-UNDO.
DEFINE VARIABLE         cSecurityValue1                 AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         cSecurityValue2                 AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         dProductModuleObj               AS DECIMAL      NO-UNDO.
DEFINE VARIABLE         dSecurityObjectObj              AS DECIMAL      NO-UNDO.
DEFINE VARIABLE         cObjectExt                      AS CHARACTER    NO-UNDO. /* File extension */
DEFINE VARIABLE         cObjectFileName                 AS CHARACTER    NO-UNDO. /* Filename without the path and extension */

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
         HEIGHT             = 11.95
         WIDTH              = 54.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE cUserValues      AS CHARACTER NO-UNDO.
DEFINE VARIABLE dUserObj         AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dOrganisationObj AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cObjsSecured     AS CHARACTER  NO-UNDO.

DEFINE BUFFER gsc_security_control   FOR gsc_security_control.
DEFINE BUFFER b2ryc_smartobject      FOR ryc_smartobject.
DEFINE BUFFER b1ryc_smartobject      FOR ryc_smartobject.
DEFINE BUFFER gsm_security_structure FOR gsm_security_structure.
DEFINE BUFFER gsm_field              FOR gsm_field.

/* If security is disabled or the security object is not passed in then "" is
   returned indicating full access is permitted.
   The routine loops around the available fields. If a field is disabled or no
   security structure exists for it, i.e. it is not used, then it is assumed
   that the user is simply ignored - indicating full access to the field.
   For each field that is enabled and used, checks are made to see whether
   the user has restricted access to the field, and if so, what actions may be
   taken on the field.
   For fields - only secured fields are returned in the list. If the field is
   not in the returned list, then full access is assumed.
*/
FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
IF NOT AVAILABLE gsc_security_control
OR gsc_security_control.security_enabled = NO THEN
    RETURN. /* Security off */

/* Check if security is turned on for the object (the object will have a security object   *
 * specified), and if it is, work out what the security object is (probably itself but can *
 * be set-up as something else).                                                           */
FIND FIRST b1ryc_smartobject NO-LOCK
     WHERE b1ryc_smartobject.object_filename = pcObjectName
     NO-ERROR.

/* If not found then check with separated extension */
IF NOT AVAILABLE b1ryc_smartobject 
THEN DO:
    IF R-INDEX(pcObjectName,".") > 0 
    THEN DO:
        ASSIGN cObjectExt      = ENTRY(NUM-ENTRIES(pcObjectName,"."),pcObjectName,".")
               cObjectFileName = REPLACE(pcObjectName,("." + pcObjectName),"").

        FIND FIRST b1ryc_smartobject WHERE
                   b1ryc_smartobject.object_filename  = cObjectFileName AND
                   b1ryc_smartobject.object_Extension = cObjectExt
                   NO-LOCK NO-ERROR.
    END.
END.

/* Is this object secured by another object? */
IF AVAILABLE b1ryc_smartobject 
THEN DO:
    IF b1ryc_smartobject.smartobject_obj <> b1ryc_smartobject.security_smartobject_obj
    THEN DO:
        FIND FIRST b2ryc_smartobject NO-LOCK
             WHERE b2ryc_smartobject.smartobject_obj = b1ryc_smartobject.security_smartobject_obj
             NO-ERROR.

        IF AVAILABLE b2ryc_smartobject THEN
            ASSIGN dSecurityObjectObj = b2ryc_smartobject.smartobject_obj
                   dProductModuleObj  = b2ryc_smartobject.product_module_obj.
        ELSE
            RETURN.
    END.
    ELSE
        ASSIGN dSecurityObjectObj = b1ryc_smartobject.smartobject_obj
               dProductModuleObj  = b1ryc_smartobject.product_module_obj.
END.
ELSE
    RETURN.

/* Get the attribute obj */
IF pcAttributeCode <> "":U
THEN DO:
    FIND FIRST gsc_instance_attribute NO-LOCK
         WHERE gsc_instance_attribute.attribute_code = pcAttributeCode
         NO-ERROR.

    IF AVAILABLE gsc_instance_attribute THEN
        ASSIGN dAttributeObj = gsc_instance_attribute.instance_attribute_obj.
END.

/* Get current up-to-date user information to be sure */
ASSIGN cUserValues      = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                           INPUT "currentUserObj,currentOrganisationObj":U,
                                           INPUT NO)
       dUserObj         = DECIMAL(ENTRY(1,cUserValues,CHR(3)))
       dOrganisationObj = DECIMAL(ENTRY(2,cUserValues,CHR(3))) 
       NO-ERROR.

/* Check which fields user has restricted access to. In the case of field security,  *
 * attributes are passed back indicating what actions may be performed on the field, *
 * so it is important to check specific object instance details first.               */

/* Check for specific object instance */
IF dAttributeObj <> 0 THEN /* This test only makes sense if we're running with an attribute.  Otherwise, we're just duplicating the check below */
    fe-blk:
    FOR EACH gsm_security_structure NO-LOCK
       WHERE gsm_security_structure.owning_entity_mnemonic = "GSMFF":U            
         AND gsm_security_structure.product_module_obj      = dProductModuleObj   
         AND gsm_security_structure.object_obj              = dSecurityObjectObj  
         AND gsm_security_structure.instance_attribute_obj  = dAttributeObj       
         AND gsm_security_structure.DISABLED                = NO:
    
        /* If the field is secured already, then do nothing. */
        IF CAN-DO(cObjsSecured, STRING(gsm_security_structure.owning_obj)) THEN
            NEXT fe-blk.
    
        RUN userSecurityCheck IN gshSecurityManager (INPUT  dUserObj,                      /* logged in as user */
                                                     INPUT  dOrganisationObj,              /* logged into organisation */
                                                     INPUT  "GSMSS":U,                     /* Security Structure FLA */
                                                     INPUT  gsm_security_structure.security_structure_obj,
                                                     INPUT  YES,                           /* Return security values - YES */
                                                     OUTPUT lSecurityRestricted,           /* Restricted yes/no ? */
                                                     OUTPUT cSecurityValue1,               /* clearance value 1 */
                                                     OUTPUT cSecurityValue2).              /* clearance value 2 */
    
        IF lSecurityRestricted AND cSecurityValue1 <> "":U 
        THEN DO:
            FIND FIRST gsm_field NO-LOCK
                 WHERE gsm_field.field_obj = gsm_security_structure.owning_obj
                 NO-ERROR.
    
            IF AVAILABLE gsm_field THEN
                ASSIGN pcSecurityOptions = pcSecurityOptions + (IF pcSecurityOptions <> "":U THEN ",":U ELSE "":U)
                                         + gsm_field.field_name + ",":U + cSecurityValue1
                       cObjsSecured      = cObjsSecured + (IF cObjsSecured <> "":U THEN ",":U ELSE "":U)
                                         + STRING(gsm_field.field_obj).
        END.
    END.

/* Check for specific object, no attribute. */
fe-blk:
FOR EACH gsm_security_structure NO-LOCK
   WHERE gsm_security_structure.owning_entity_mnemonic = "GSMFF":U            
     AND gsm_security_structure.product_module_obj      = dProductModuleObj   
     AND gsm_security_structure.object_obj              = dSecurityObjectObj  
     AND gsm_security_structure.instance_attribute_obj  = 0                   
     AND gsm_security_structure.disabled                = NO:

    /* If the field is secured already, then do nothing. */
    IF CAN-DO(cObjsSecured, STRING(gsm_security_structure.owning_obj)) THEN
        NEXT fe-blk.
 
    RUN userSecurityCheck IN gshSecurityManager (INPUT  dUserObj,                      /* logged in as user */
                                                 INPUT  dOrganisationObj,              /* logged into organisation */
                                                 INPUT  "GSMSS":U,                     /* Security Structure FLA */
                                                 INPUT  gsm_security_structure.security_structure_obj,
                                                 INPUT  YES,                           /* Return security values - YES */
                                                 OUTPUT lSecurityRestricted,           /* Restricted yes/no ? */
                                                 OUTPUT cSecurityValue1,               /* clearance value 1 */
                                                 OUTPUT cSecurityValue2).              /* clearance value 2 */

    IF lSecurityRestricted AND cSecurityValue1 <> "":U 
    THEN DO:
        FIND FIRST gsm_field NO-LOCK
             WHERE gsm_field.field_obj = gsm_security_structure.owning_obj
             NO-ERROR.

        IF AVAILABLE gsm_field THEN
            ASSIGN pcSecurityOptions = pcSecurityOptions + (IF pcSecurityOptions <> "":U THEN ",":U ELSE "":U)
                                     + gsm_field.field_name + ",":U + cSecurityValue1
                   cObjsSecured      = cObjsSecured + (IF cObjsSecured <> "":U THEN ",":U ELSE "":U)
                                     + STRING(gsm_field.field_obj).
    END.
END.

/* Check for product module */
fe-blk:
FOR EACH gsm_security_structure NO-LOCK
   WHERE gsm_security_structure.owning_entity_mnemonic = "GSMFF":U            
     AND gsm_security_structure.product_module_obj      = dProductModuleObj   
     AND gsm_security_structure.object_obj              = 0                   
     AND gsm_security_structure.instance_attribute_obj  = 0                   
     AND gsm_security_structure.disabled                = NO:

    /* If the field is secured already, then do nothing. */
    IF CAN-DO(cObjsSecured, STRING(gsm_security_structure.owning_obj)) THEN
        NEXT fe-blk.

    RUN userSecurityCheck IN gshSecurityManager (INPUT  dUserObj,                      /* logged in as user */
                                                 INPUT  dOrganisationObj,              /* logged into organisation */
                                                 INPUT  "GSMSS":U,                     /* Security Structure FLA */
                                                 INPUT  gsm_security_structure.security_structure_obj,
                                                 INPUT  YES,                           /* Return security values - YES */
                                                 OUTPUT lSecurityRestricted,           /* Restricted yes/no ? */
                                                 OUTPUT cSecurityValue1,               /* clearance value 1 */
                                                 OUTPUT cSecurityValue2).              /* clearance value 2 */

    IF lSecurityRestricted AND cSecurityValue1 <> "":U 
    THEN DO:
        FIND FIRST gsm_field NO-LOCK
             WHERE gsm_field.field_obj = gsm_security_structure.owning_obj
             NO-ERROR.

        IF AVAILABLE gsm_field THEN
            ASSIGN pcSecurityOptions = pcSecurityOptions + (IF pcSecurityOptions <> "":U THEN ",":U ELSE "":U)
                                     + gsm_field.field_name + ",":U + cSecurityValue1
                   cObjsSecured      = cObjsSecured + (IF cObjsSecured <> "":U THEN ",":U ELSE "":U)
                                     + STRING(gsm_field.field_obj).
    END.
END.

/* Check for all */
fe-blk:
FOR EACH gsm_security_structure NO-LOCK
   WHERE gsm_security_structure.owning_entity_mnemonic = "GSMFF":U  
     AND gsm_security_structure.product_module_obj      = 0         
     AND gsm_security_structure.object_obj              = 0         
     AND gsm_security_structure.instance_attribute_obj  = 0         
     AND gsm_security_structure.disabled                = NO:

    /* If the field is secured already, then do nothing. */
    IF CAN-DO(cObjsSecured, STRING(gsm_security_structure.owning_obj)) THEN
        NEXT fe-blk.

    RUN userSecurityCheck IN gshSecurityManager (INPUT  dUserObj,                      /* logged in as user */
                                                 INPUT  dOrganisationObj,              /* logged into organisation */
                                                 INPUT  "GSMSS":U,                     /* Security Structure FLA */
                                                 INPUT  gsm_security_structure.security_structure_obj,
                                                 INPUT  YES,                           /* Return security values - YES */
                                                 OUTPUT lSecurityRestricted,           /* Restricted yes/no ? */
                                                 OUTPUT cSecurityValue1,               /* clearance value 1 */
                                                 OUTPUT cSecurityValue2).              /* clearance value 2 */
    IF lSecurityRestricted AND cSecurityValue1 <> "":U 
    THEN DO:
        FIND FIRST gsm_field NO-LOCK
             WHERE gsm_field.field_obj = gsm_security_structure.owning_obj
             NO-ERROR.

        IF AVAILABLE gsm_field THEN
            ASSIGN pcSecurityOptions = pcSecurityOptions + (IF pcSecurityOptions <> "":U THEN ",":U ELSE "":U)
                                     + gsm_field.field_name + ",":U + cSecurityValue1
                   cObjsSecured      = cObjsSecured + (IF cObjsSecured <> "":U THEN ",":U ELSE "":U)
                                     + STRING(gsm_field.field_obj).
    END.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
