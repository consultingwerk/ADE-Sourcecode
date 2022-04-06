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
  File: gsmsesuprp.p

  Description:  Security Control Viewer Super Procedure

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

&scop object-name       gsmsesuprp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}
{af/app/afsecttdef.i}

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
         HEIGHT             = 10.86
         WIDTH              = 46.4.
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

&IF DEFINED(EXCLUDE-cancelRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord Procedure 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.
  
  RUN setButtonState IN TARGET-PROCEDURE.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-chooseClear) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chooseClear Procedure 
PROCEDURE chooseClear :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is run when the Clear Security Allocation button
               is pressed.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cButton       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageList  AS CHARACTER  NO-UNDO.
  /* Default answer to NO */
  
  cMessageList = {af/sup2/aferrortxt.i 'AF' '47' 'gsc_security_control' 'full_access_by_default'}.
  RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                         INPUT "QUE":U,
                                         INPUT "&YES,&NO":U,
                                         INPUT "&NO":U,
                                         INPUT "&NO":U,
                                         INPUT "Remove Security Allocations",
                                         INPUT TRUE,
                                         INPUT ?,
                                         OUTPUT cButton).
  IF cButton = "&YES":U THEN DO:
    EMPTY TEMP-TABLE ttUpdatedAllocations.
    CREATE ttUpdatedAllocations.
    ASSIGN ttUpdatedAllocations.owning_entity_mnemonic = "ALL":U
           ttUpdatedAllocations.lDeleteAll             = TRUE.
    SESSION:SET-WAIT-STATE("GENERAL":U).
    /* Go and remove all allocations */
    RUN updateUserAllocations IN gshSecurityManager (INPUT 0,
                                                     INPUT 0,
                                                     INPUT TABLE ttUpdatedAllocations).

    SESSION:SET-WAIT-STATE("":U).
    IF ERROR-STATUS:ERROR OR
       RETURN-VALUE <> "":U THEN DO:
      cMessageList = RETURN-VALUE.
      IF cMessageList <> "":U THEN DO:
        RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                               INPUT "ERR":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "OK":U,
                                               INPUT "Error Saving Security Allocations",
                                               INPUT YES,
                                               INPUT ?,
                                               OUTPUT cButton).
        SESSION:SET-WAIT-STATE("":U).
        RETURN.
      END.
    END.
  END.

  RETURN.
  
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

&IF DEFINED(EXCLUDE-resetRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord Procedure 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  RUN setButtonState IN TARGET-PROCEDURE.
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setButtonState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setButtonState Procedure 
PROCEDURE setButtonState :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will determine if the Add buttons should be 
               enabled or not.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource   AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hTableIO      AS HANDLE   NO-UNDO.
  DEFINE VARIABLE lRowAvailable AS LOGICAL  NO-UNDO.
  
  {get dataSource hDataSource}.
  {get TableIOSource hTableIO}.
  
  IF VALID-HANDLE(hDataSource) THEN DO:
    lRowAvailable = DYNAMIC-FUNCTION("rowAvailable":U IN hDataSource, "CURRENT":U).
    IF VALID-HANDLE(hTableIO) THEN DO:
      IF lRowAvailable THEN
        DYNAMIC-FUNCTION("sensitizeActions":U IN hTableIO ,"Add,Copy", FALSE).    
      ELSE
        DYNAMIC-FUNCTION("sensitizeActions":U IN hTableIO ,"Add", TRUE).    
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateMode Procedure 
PROCEDURE updateMode :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcMode AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcMode).

  RUN setButtonState IN TARGET-PROCEDURE.
  
  /* Code placed here will execute AFTER standard behavior.    */

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
  DEFINE VARIABLE cMinimiseSiblings      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDummy                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBeforeSecurityEnabled AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAfterSecurityEnabled  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecurityModel         AS CHARACTER  NO-UNDO.

  ASSIGN cBeforeSecurityEnabled = formattedWidgetValue("security_enabled":U).

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.
  
  RUN setButtonState IN TARGET-PROCEDURE.
  
  /* Code placed here will execute AFTER standard behavior.    */

  /* Make sure our minimiseSiblings session property is in line with what it was set to here */
  cMinimiseSiblings = formattedWidgetValue("minimise_siblings":U).
  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager, 
                                       INPUT "minimiseSiblings":U,
                                       INPUT cMinimiseSiblings,
                                       INPUT YES). /* Set in client session only */

  /* Refresh the security properties for this session */
  RUN setSecurityProperties IN gshSecurityManager (OUTPUT cDummy,  /* Properties      */
                                                   OUTPUT cDummy). /* Property Values */

  PUBLISH "securityModelUpdated":U FROM gshSecurityManager.

  /* Check if security has been disabled on the server */
  ASSIGN cAfterSecurityEnabled = formattedWidgetValue("security_enabled":U).

  IF cBeforeSecurityEnabled = "YES":U
  AND cAfterSecurityEnabled = "NO":U 
  THEN DO:
      ASSIGN cSecurityModel = formattedWidgetValue("full_access_by_default":U).
      IF cSecurityModel = "NO":U 
      THEN DO:
          DEFINE VARIABLE cButton  AS CHARACTER  NO-UNDO.
          RUN showMessages IN gshSessionManager (INPUT "Security has been disabled.  No user security allocations have been assigned, and "
                                                     + "the security model has been set to a grant model.  If security is left enabled, "
                                                     + "no access will be granted to any functionality for any users.  This would result in "
                                                     + "the system becoming inaccessible.",
                                                 INPUT "INFO",
                                                 INPUT "&OK",
                                                 INPUT "&OK",
                                                 INPUT "&OK",
                                                 INPUT "Security Model Updated",
                                                 INPUT NO,
                                                 INPUT ?,
                                                OUTPUT cButton). 
      END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

