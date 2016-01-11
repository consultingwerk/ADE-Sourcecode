&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* Update Version Notes Wizard
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
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: rytemcustomsuper.p

  Description:  

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/08/2004  Author:     

  Update Notes: Created from Template rytemcustomsuper.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afcomsupr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE VARIABLE gcOwningEntityMnemonic AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glTableHasObjField     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gcOwningReference      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDisplayFieldLabel    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDisplayFieldValue    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcUserId               AS CHARACTER  NO-UNDO.

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
         HEIGHT             = 8.67
         WIDTH              = 56.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/customsuper.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-collectChanges) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE collectChanges Procedure 
PROCEDURE collectChanges :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER pcChanges AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcInfo    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE hHandle                 AS HANDLE     NO-UNDO.

  /* If this procedure is run we know that a change was made to the
     comments and we then need to ensure that we save the name of 
     the user that changed this record and the data it was changed */

  hHandle = WidgetHandle('last_updated_by_user').
  hhandle:SCREEN-VALUE = gcUserId.
  hHandle:MODIFIED     = TRUE.
  
  hHandle = WidgetHandle('last_updated_date').
  hhandle:SCREEN-VALUE = STRING(TODAY).
  hHandle:MODIFIED     = TRUE.
  
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT-OUTPUT pcChanges, INPUT-OUTPUT pcInfo).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcRelative        as character            no-undo.
    
    define variable hDataSource        as handle                     no-undo.
    define variable cKeyVal            as character                  no-undo.
    
    /* This needs to be run every time that the parent SDO changes value.
       We can't tell this, so get these values every time the row changes.
       Its a little inefficient, but there are no AppServer hits involved.
       
       Do this before the RUN SUPER because this information is used in
       displayFields
     */
    {get DataSource hDataSource}.
    cKeyVal = {fn getEntityInfo hDataSource}.
        
    ASSIGN gcOwningEntityMnemonic = ENTRY(LOOKUP("OwningEntityMnemonic", cKeyVal, "|":U) + 1, cKeyVal, "|":U)
           glTableHasObjField = (ENTRY(LOOKUP("TableHasObjField", cKeyVal, "|":U) + 1, cKeyVal, "|":U) = "YES")
           gcOwningReference = ENTRY(LOOKUP("OwningReference", cKeyVal, "|":U) + 1, cKeyVal, "|":U)
           gcDisplayFieldLabel = ENTRY(LOOKUP("DisplayFieldLabel", cKeyVal, "|":U) + 1, cKeyVal, "|":U)
           gcDisplayFieldValue = ENTRY(LOOKUP("DisplayFieldValue", cKeyVal, "|":U) + 1, cKeyVal, "|":U)
           gcUserId            = ENTRY(LOOKUP("UserId", cKeyVal, "|":U) + 1, cKeyVal, "|":U).
        
    run super (pcRelative).
    
END PROCEDURE.    /* dataAvailable */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields Procedure 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcColValues    AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hHandle               AS HANDLE     NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcColValues).

    /* The gcOwningEntityMnemonic and other variables are set in DataAvailable. */
    
  IF WidgetValue('owning_entity_mnemonic') = "":U THEN 
     assignWidgetValue('owning_entity_mnemonic', gcOwningEntityMnemonic).
  
  /* This code tries to right alight the LABEL but does not seem to work */
  gcDisplayFieldLabel = gcDisplayFieldLabel + ":":U.
  IF LENGTH(gcDisplayFieldLabel) < 23 THEN
    gcDisplayFieldLabel = FILL(" ", (23 - LENGTH(gcDisplayFieldLabel))) + gcDisplayFieldLabel.
  
  /* The owning_obj field is never used. */
  assignWidgetValue('owning_reference', gcOwningReference).
  assignWidgetValue('owning_obj', STRING(0)).
  
  hHandle = WidgetHandle('cOwningEntityKeyField').
  hHandle:LABEL = gcDisplayFieldLabel.
  assignWidgetValue('cOwningEntityKeyField', gcDisplayFieldValue).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

