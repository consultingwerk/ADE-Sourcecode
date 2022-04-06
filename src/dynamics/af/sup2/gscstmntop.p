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
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gscstmntop.p

  Description:  Service Type Maintenance Object Read

  Purpose:      Returns path and filename for the service type maintenance object

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000069   UserRef:    IZ939
                Date:   25/04/2001  Author:     Tammy St Pierre

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gscstmntop.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{af/sup2/afglobals.i}

DEFINE INPUT PARAMETER pdServiceTypeObj AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pcPath          AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcFileName      AS CHARACTER NO-UNDO.

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
         HEIGHT             = 5.95
         WIDTH              = 55.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

IF pdServiceTypeObj = 0 THEN 
DO:
  FOR EACH gsc_service_type NO-LOCK BY gsc_service_type.service_type_code:
    FIND ryc_smartobject WHERE ryc_smartobject.smartobject_obj = gsc_service_type.maintenance_object NO-LOCK NO-ERROR.
    IF AVAILABLE ryc_smartobject THEN 
    DO:
      ASSIGN pcPath = ryc_smartobject.object_path
             pcFileName = ryc_smartobject.object_filename
                          + (IF ryc_smartobject.object_extension <> "":U THEN "." + ryc_smartobject.object_extension
                                ELSE "":U).
      RETURN.
    END.
  END.
END.  /* if 0 */
ELSE DO:
  FIND gsc_service_type WHERE gsc_service_type.service_type_obj = pdServiceTypeObj NO-LOCK NO-ERROR.
  IF AVAILABLE gsc_service_type THEN
  DO:
    FIND ryc_smartobject WHERE ryc_smartobject.smartobject_obj = gsc_service_type.maintenance_object NO-LOCK NO-ERROR.
    IF AVAILABLE ryc_smartobject THEN
      ASSIGN pcPath = ryc_smartobject.object_path
             pcFileName = ryc_smartobject.object_filename
                          + (IF ryc_smartobject.object_extension <> "":U THEN "." + ryc_smartobject.object_extension
                                ELSE "":U).
  END.  /* if avail service type */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


