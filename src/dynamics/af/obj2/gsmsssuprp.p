&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
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
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: gsmsssuprp.p

  Description:  Security Structure Super Procedure

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    MIP
                Date:   05/17/2003  Author:     Mark Davies

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gsmsssuprp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}

DEFINE VARIABLE gcUIBMode                  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcObjectQueryString        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcProductModuleCode        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gdProductModuleObj         AS DECIMAL      NO-UNDO.
DEFINE VARIABLE gcContainerMode            AS CHARACTER    NO-UNDO.

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
         HEIGHT             = 14.71
         WIDTH              = 74.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/customsuper.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord Procedure 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.

  RUN SUPER.
  
  {get containerSource hContainer}.
  
  IF VALID-HANDLE(hContainer) THEN
    {set ContainerMode 'Add' hContainer}.
  
  gcContainerMode = "Add":U.

  /* When a new gsm_security_structure record is being added, the object and *
   * attribute lookups need to be disabled until a product module code is    *
   * entered.                                                                */
  disableWidget("object_obj":U).
  disableWidget("instance_attribute_obj":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord Procedure 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.


  RUN SUPER.
  {get containerSource hContainer}.
  IF VALID-HANDLE(hContainer) THEN
    {set ContainerMode 'Copy' hContainer}.
  
  gcContainerMode = "Copy":U.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dispAllInCombos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dispAllInCombos Procedure 
PROCEDURE dispAllInCombos :
/*------------------------------------------------------------------------------
  Purpose:     We'll check the 3 combos, if any of their values are 0, set their display value to <All>
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dValue          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hLookupFillIn   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLoopLookup     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCnt            AS INTEGER    NO-UNDO.

  DO iCnt = 1 TO 3:

      CASE iCnt:
          WHEN 1 THEN DO:
            ASSIGN dValue = DECIMAL(formattedWidgetValue("product_module_obj":U)).
            hLoopLookup = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "product_module_obj":U, "ALL":U).
          END.
          WHEN 2 THEN DO:
            ASSIGN dValue = DECIMAL(formattedWidgetValue("object_obj":U)).
            hLoopLookup = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "object_obj":U, "ALL":U).
          END.
          WHEN 3 THEN DO:
            ASSIGN dValue = DECIMAL(formattedWidgetValue("instance_attribute_obj":U)).
            hLoopLookup = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "instance_attribute_obj":U, "ALL":U).
          END.
      END CASE.
      
      IF dValue = 0 
      THEN DO:
          {get lookupHandle hLookupFillIn hLoopLookup}.

          IF hLookupFillIn:SCREEN-VALUE <> "<All>":U
          THEN DO:
              ASSIGN hLookupFillIn:SCREEN-VALUE = "<All>".
              IF SELF = hLookupFillIn THEN
                  hLookupFillIn:SET-SELECTION(1,6).
          END.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields Procedure 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dProductModuleObj   AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dObjectObj          AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE hLookup             AS HANDLE     NO-UNDO.

  RUN SUPER.

  /* The object and attribute lookups need to be disabled if the product module
     obj is zero. */
  hLookup = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "product_module_obj":U, "ALL":U).

  dProductModuleObj = DECIMAL(DYNAMIC-FUNCTION('getKeyFieldValue':U IN hLookup)).
  IF dProductModuleObj = 0 
  THEN DO:
    disableWidget("object_obj":U).
    disableWidget("instance_attribute_obj":U).
  END.  /* if dProductModuleObj = 0 */
  ELSE DO:
    enableWidget("object_obj":U).
    enableWidget("instance_attribute_obj":U).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeBrowse Procedure 
PROCEDURE initializeBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER hLookup AS HANDLE     NO-UNDO.

DEFINE VARIABLE hFillIn AS HANDLE     NO-UNDO.

{get lookupHandle hFillIn hLookup}.
IF hFillIn:SCREEN-VALUE = "<All>":U THEN
    ASSIGN hFillIn:SCREEN-VALUE = "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cContainerClasses AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDynFrameClasses  AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  {get UIBMode gcUIBMode}.   

  /* Subscribe to lookup events */
  IF NOT (gcUIBMode BEGINS "DESIGN":U) 
  THEN DO: 
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "lookupComplete":U        IN TARGET-PROCEDURE.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "lookupDisplayComplete":U IN TARGET-PROCEDURE.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "lookupEntry":U           IN TARGET-PROCEDURE.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "initializeBrowse":U      IN TARGET-PROCEDURE.
  END.

  {get containerSource hContainer}.
  /* Default Container mode to MODIFY since it will always be created with the <All> record #3843 */
  {set ContainerMode 'Modify' hContainer}.

  /* Determine which container classes we're allowed to see */
  ASSIGN cContainerClasses   = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "smartDialog,smartFolder,smartWindow,window,folder,dyncontainer,dynobjc,staticobjc,dynmenc,staticmenc,staticcont,staticdiag,staticframe,smartcontainer":U)
         cContainerClasses   = REPLACE(cContainerClasses, CHR(3), ",":U)
         /* Exclude dyn frames */
         cDynFrameClasses    = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "dynFrame":U)
         cContainerClasses   = REPLACE(cContainerClasses, cDynFrameClasses, "":U)
         cContainerClasses   = REPLACE(cContainerClasses, ",,":U, ",":U).

  assignWidgetValue("fiContainerClasses":U, cContainerClasses).
  RUN SUPER.

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

&IF DEFINED(EXCLUDE-lookupComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupComplete Procedure 
PROCEDURE lookupComplete :
/*------------------------------------------------------------------------------
  Purpose:     Lookup complete hook 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcColumnNames           AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcColumnValues          AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcKeyFieldValue         AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcDisplayedFieldValue   AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcOldFieldValue         AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER plLookup                AS LOGICAL      NO-UNDO.
  DEFINE INPUT  PARAMETER phObject                AS HANDLE       NO-UNDO.
  
  DEFINE VARIABLE hLookup         AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hLookupField    AS HANDLE       NO-UNDO.
  DEFINE VARIABLE iEntry          AS INTEGER      NO-UNDO.
  DEFINE VARIABLE hProdModObj     AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hObjectObj      AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hInstAttrObj    AS HANDLE       NO-UNDO.

  hProdModObj  = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "product_module_obj":U, "ALL":U).
  hObjectObj   = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "object_obj":U, "ALL":U).
  hInstAttrObj = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "instance_attribute_obj":U, "ALL":U).


  /* The object and attribute lookups need to have their values removed 
     if the product module obj is zero. */
  IF phObject = hProdModObj THEN
  DO:
    ASSIGN gdProductModuleObj = DECIMAL(pcKeyFieldValue) NO-ERROR.
    ASSIGN gcProductModuleCode = pcDisplayedFieldValue.
    IF gdProductModuleObj = 0 THEN
    DO:
      hLookupField = DYNAMIC-FUNCTION('getLookupHandle':U IN hObjectObj).
      ASSIGN hLookupField:SCREEN-VALUE = "":U.
      DYNAMIC-FUNCTION('setKeyFieldValue':U IN hObjectObj, INPUT "0":U).
      DYNAMIC-FUNCTION('setDataModified':U IN hObjectObj, INPUT TRUE).
      hLookupField = DYNAMIC-FUNCTION('getLookupHandle':U IN hInstAttrObj).
      ASSIGN hLookupField:SCREEN-VALUE = "":U.
      DYNAMIC-FUNCTION('setKeyFieldValue':U IN hInstAttrObj, INPUT "0":U).
      DYNAMIC-FUNCTION('setDataModified':U IN hInstAttrObj, INPUT TRUE).
    END.  /* if gdProductModuleObj = 0 */
  END.  /* if hProdModObj */

  /* The attribute lookup needs to have its value removed if the object 
     obj has no value. */
  IF phObject = hObjectObj THEN
  DO:
    IF pcKeyFieldValue = "":U THEN
    DO:
      hLookupField = DYNAMIC-FUNCTION('getLookupHandle':U IN hInstAttrObj).
      ASSIGN hLookupField:SCREEN-VALUE = "":U.
      DYNAMIC-FUNCTION('setKeyFieldValue':U IN hInstAttrObj, INPUT "0":U).
      DYNAMIC-FUNCTION('setDataModified':U IN hInstAttrObj, INPUT TRUE).
    END.  /* if pcKeyFieldValue blank */
  END.  /* if hObjectObj */

  RUN dispAllInCombos IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lookupDisplayComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupDisplayComplete Procedure 
PROCEDURE lookupDisplayComplete :
/*------------------------------------------------------------------------------
  Purpose:     Lookup display complete hook 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcFieldNames     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcFieldValues    AS CHARACTER  NO-UNDO.  
  DEFINE INPUT PARAMETER pcKeyFieldValue  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phLookup         AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE iEntry          AS INTEGER      NO-UNDO.
  DEFINE VARIABLE lEnabled        AS LOGICAL      NO-UNDO.
  
  DEFINE VARIABLE hProdModObj     AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hObjectObj      AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hInstAttrObj    AS HANDLE       NO-UNDO.

  hProdModObj  = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "product_module_obj":U, "ALL":U).
  hObjectObj   = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "object_obj":U, "ALL":U).
  hInstAttrObj = DYNAMIC-FUNCTION("internalWidgetHandle":U IN TARGET-PROCEDURE, "instance_attribute_obj":U, "ALL":U).
  
  /* The object lookup needs to be enabled when the product module obj has   *
   * a value and the object and attribute lookups need to be disabled if the *
   * product module obj is zero.  The BaseQuerySring also needs to be set    *
   * for the object lookup.                                                  */  
  lEnabled = DYNAMIC-FUNCTION('getFieldEnabled':U IN hProdModObj).
  
  IF phLookup = hProdModObj 
  THEN DO:
      ASSIGN gdProductModuleObj = DECIMAL(pcKeyFieldValue) NO-ERROR.
  
      IF gdProductModuleObj > 0 
      THEN DO:
          IF lEnabled THEN
              enableWidget("object_obj":U).
      END.
      ELSE DO:
          disableWidget("object_obj":U).
          disableWidget("instance_attribute_obj":U).
      END.  /* else do */

      ASSIGN iEntry = LOOKUP("gsc_product_module.product_module_code":U, pcFieldNames).

      IF iEntry > 0 AND gdProductModuleObj > 0 THEN
          ASSIGN gcProductModuleCode = ENTRY(iEntry, pcFieldValues, CHR(1)).
      ELSE
          ASSIGN gcProductModuleCode = "":U.
  END.  /* if hProdModObj */
  
  /* The attribute lookup needs to be enabled when the object obj has a *
   * value and the attribute lookup needs to be disabled if the object  *
   * obj has not value.                                                 */
  IF phLookup = hObjectObj 
  THEN DO:
      ASSIGN iEntry = LOOKUP("ryc_smartobject.object_filename":U, pcFieldNames).
      IF iEntry > 0
      THEN DO:
          IF pcKeyFieldValue = "":U THEN
              disableWidget("instance_attribute_obj":U).
          ELSE
              IF lEnabled THEN
                  enableWidget("instance_attribute_obj":U).
      END.  /* if iEntry > 0 */
  END.  /* if hObjectObj */

  RUN dispAllInCombos IN TARGET-PROCEDURE.

  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lookupEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupEntry Procedure 
PROCEDURE lookupEntry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcScreenValue            AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER phLookup                 AS HANDLE       NO-UNDO. 
  
  DEFINE VARIABLE hContainer    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLookupFillIn AS HANDLE     NO-UNDO.

  {get containerSource hContainer}.
  {set ContainerMode gcContainerMode hContainer}.

  /* If the user is in a lookup with screen value <All>, select the whole string, *
   * so he can just start typing, instead of having to delete the <All> first.    */
  {get lookupHandle hLookupFillIn phLookup}.

  IF hLookupFillIn:SCREEN-VALUE = "<All>":U THEN
      hLookupFillIn:SET-SELECTION(1,6).

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

ASSIGN cDescription = "Dynamics Template PLIP".

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

&IF DEFINED(EXCLUDE-updateRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord Procedure 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLoopLookup   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLookupFillIn AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCnt          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hDataSource   AS HANDLE     NO-UNDO.

  /* Make sure the LEAVE trigger has fired if we're in a lookup */

  IF VALID-HANDLE(SELF) THEN
      APPLY "VALUE-CHANGED":U TO SELF.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  {get DataSource hDataSource}.
  IF VALID-HANDLE(hDataSource) THEN
      RUN refreshRow IN hDataSource.

  /* To prevent the security manager cache (for this session)  *
   * from getting out of sync with the actual db values, clear *
   * the security manager cache, forcing it to get fresh info  *
   * from the db.                                              */
  IF VALID-HANDLE(gshRepositoryManager) THEN
      RUN clearClientCache IN gshRepositoryManager.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState Procedure 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.

  {get containerSource hContainer}.

  /* Code placed here will execute PRIOR to standard behavior. */

  IF pcState = "UpdateComplete" THEN
    gcContainerMode = "Modify":U.
      {set ContainerMode gcContainerMode hContainer}.
    
  RUN SUPER( INPUT pcState).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

