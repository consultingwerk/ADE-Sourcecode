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
  File: rysdfusedp.p

  Description:  SmartDataField Where Used Viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/05/2002  Author:     Mark Davies (MIP)

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rysdfusedp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}

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
         HEIGHT             = 10
         WIDTH              = 47.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

ASSIGN cDescription = "SmartDataField Where Used Plip".

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

&IF DEFINED(EXCLUDE-whereSDFUsed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE whereSDFUsed Procedure 
PROCEDURE whereSDFUsed :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcSDFName   AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcWhereUsed AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cMessage    AS CHARACTER  NO-UNDO.
  
  DEFINE BUFFER bryc_smartobject FOR ryc_smartobject.

  /* Find where this SDF was assigned using the SDFFileName Attribute */
  FOR EACH  ryc_attribute_value
      WHERE ryc_attribute_value.attribute_label            = "SDFFileName":U
      AND   ryc_attribute_value.character_value            = pcSDFName
      AND   ryc_attribute_value.container_smartobject_obj <> 0
      AND   ryc_attribute_value.object_instance_obj       <> 0
      NO-LOCK,
      FIRST ryc_smartobject
      WHERE ryc_smartobject.smartobject_obj = ryc_attribute_value.smartobject_obj
      NO-LOCK,
      FIRST bryc_smartobject
      WHERE bryc_smartobject.smartobject_obj = ryc_attribute_value.container_smartobject_obj
      NO-LOCK:
    cMessage = "Container Object: " + bryc_smartobject.object_filename + 
               "~nObject Instance: " + ryc_smartobject.object_filename.
    pcWhereUsed = IF pcWhereUsed = "":U THEN cMessage ELSE pcWhereUsed + "~n~n":U + cMessage.
  END.

  IF pcWhereUsed <> "":U THEN
    pcWhereUsed = "In the following list it was added by adding an SDFFileName Attribute to the Object Instance and assigning the SDF name as the Attribute Value.~n~n" + pcWhereUsed.
  
  
  /* Find where this SDF was assigned to a viewer by creating an instance on the object */
  FIND FIRST ryc_smartobject
       WHERE ryc_smartobject.object_filename = pcSDFName
       NO-LOCK NO-ERROR.
  IF CAN-FIND(FIRST ryc_object_instance
              WHERE ryc_object_instance.smartobject_obj = ryc_smartobject.smartobject_obj
              NO-LOCK) THEN DO:
    IF pcWhereUsed <> "":U THEN
      pcWhereUsed = pcWhereUsed + "~n~n" + FILL("*":U,20) + "~n~nIn the following list it was added by adding the SDF as an instance directly onto the object.".
    ELSE
      pcWhereUsed = "In the following list it was added by adding the SDF as an instance directly onto the object.".
  END.
  
  FOR EACH  ryc_object_instance
      WHERE ryc_object_instance.smartobject_obj = ryc_smartobject.smartobject_obj
      NO-LOCK,
      FIRST bryc_smartobject
      WHERE bryc_smartobject.smartobject_obj = ryc_object_instance.container_smartobject_obj
      NO-LOCK:
    cMessage = "Container Object: " + bryc_smartobject.object_filename.
    pcWhereUsed = IF pcWhereUsed = "":U THEN cMessage ELSE pcWhereUsed + "~n~n":U + cMessage.
  END.

  
  IF pcWhereUsed <> "":U THEN
    pcWhereUsed = "The SmartDataField - '" + pcSDFName + "' is currently used on the following objects:~n~n" + pcWhereUsed.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

