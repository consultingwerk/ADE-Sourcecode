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
  File: gsccpviewp.p

  Description:  Custom Procedure Viewer Super Procedure

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/26/2003  Author:     

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gsccpviewp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}

DEFINE VARIABLE glIgnoreLookupComplete  AS LOGICAL    NO-UNDO.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15.62
         WIDTH              = 46.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-displayFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields Procedure 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.

  DEFINE VARIABLE hLookup            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hObject            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ghDataSource       AS HANDLE     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcColValues).

  /* Code placed here will execute AFTER standard behavior. */

  ASSIGN hLookup = {fnarg internalWidgetHandle  "'procedure_name':U, 'ALL':U"}.
  ASSIGN hObject = {fn getLookupHandle hLookup}.

  {get DataSource ghDataSource}.

  ASSIGN hObject:SCREEN-VALUE = {fnarg columnStringValue 'procedure_name':U  ghDataSource}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "LookupComplete":U IN TARGET-PROCEDURE.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

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
  Purpose:     
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
  
  DEFINE VARIABLE hLookup                         AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hLookupFillIn                   AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cDisplayedValue                 AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lSuccess                        AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE cName                           AS CHARACTER  NO-UNDO.
  
  IF glIgnoreLookupComplete THEN
    RETURN.
  
  ASSIGN hLookup = {fnarg internalWidgetHandle "'procedure_name':U, 'ALL':U"}.
                 
  IF phObject = hLookup THEN
  DO:
    ASSIGN hLookupFillIn = {fn getLookupHandle hLookup}.
    
    IF pcColumnValues <> "":U AND
       pcColumnValues <> ?    THEN
    DO:
      
      ASSIGN
          cDisplayedValue            = ENTRY(LOOKUP("ryc_smartobject.object_path":U, pcColumnNames), pcColumnValues, CHR(1))
          cDisplayedValue            = TRIM(REPLACE(cDisplayedValue, "~\":U, "/":U), "/":U) + "/":U
                                     + ENTRY(LOOKUP("ryc_smartobject.object_filename":U,  pcColumnNames), pcColumnValues, CHR(1)).

      ASSIGN 
          cDisplayedValue            = cDisplayedValue + 
                                      (IF ENTRY(LOOKUP("ryc_smartobject.object_extension":U, pcColumnNames), pcColumnValues, CHR(1)) <> "":U
                                       THEN ".":U + ENTRY(LOOKUP("ryc_smartobject.object_extension":U, pcColumnNames), pcColumnValues, CHR(1))
                                       ELSE "":U)
          hLookupFillIn:SCREEN-VALUE = cDisplayedValue
          lSuccess                   = {fnarg setDataValue cDisplayedValue hLookup}.
    END.
    ELSE
    DO:
      ASSIGN
          cDisplayedValue            = pcDisplayedFieldValue
          cDisplayedValue            = REPLACE(cDisplayedValue, "~\":U, "/":U)
          /* We just add a '/' to ensure the num-entries does not fall over if there was no '/' in the string */
          cDisplayedValue            = (IF INDEX(cDisplayedValue, "/":U) = 0 THEN "/":U ELSE "":U) + cDisplayedValue
          cName                      = ENTRY(NUM-ENTRIES(cDisplayedValue, "/":U), cDisplayedValue, "/":U)
          hLookupFillIn:SCREEN-VALUE = cName
          glIgnoreLookupComplete     = TRUE.

      RUN leaveLookup IN hLookup.

      IF {fn getDataValue hLookup} = cName OR
         {fn getDataValue hLookup} = "":U  THEN
        ASSIGN
            hLookupFillIn:SCREEN-VALUE = pcDisplayedFieldValue
            lSuccess                   = {fnarg setDataValue pcDisplayedFieldValue hLookup}.
      ELSE
      DO:
        {set SavedScreenValue '':U hLookup}.
        glIgnoreLookupComplete = FALSE.
        RUN leaveLookup IN hLookup.
      END.
    END.
  END.

  glIgnoreLookupComplete = FALSE.

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

