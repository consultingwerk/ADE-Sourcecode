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
  File: secusrgrpp.p

  Description:  Security group creation from user

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   06/11/2003  Author:     

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       secusrgrpp.p
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
         HEIGHT             = 13.43
         WIDTH              = 43.8.
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

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cDescription                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hEditor                       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDummy                        AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  enableWidget("fiUser":U).
  cDescription = {aferrortxt.i 'AF' '147' '' ''}.

  RUN afmessagep IN gshSessionManager
                  (INPUT  cDescription,
                   INPUT  cDummy,
                   INPUT  "",
                   OUTPUT cDummy,
                   OUTPUT cDescription,
                   OUTPUT cDummy,
                   OUTPUT cDummy,
                   OUTPUT cDummy,
                   OUTPUT cDummy). 

  ASSIGN cDescription = SUBSTRING(cDescription,1, R-INDEX(cDescription, CHR(10))).

  hEditor               = widgetHandle("edDescription").
  hEditor:SCREEN-VALUE  = cDescription.
  

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

&IF DEFINED(EXCLUDE-processSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processSecurity Procedure 
PROCEDURE processSecurity :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hLookup         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cErrorMsg       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButtonPressed  AS CHARACTER  NO-UNDO.

  IF formattedwidgetValue("fiUser") = "" OR
     formattedwidgetValue("fiUser") = ? THEN
  ASSIGN cErrorMsg = {aferrortxt.i 'AF' '1' '' '' "'User'"}.

  IF widgetValue("fiSecurityGroup") = "" OR
     widgetValue("fiSecurityGroup") = ? THEN
  ASSIGN cErrorMsg = (IF cErrorMsg = "" THEN "" ELSE cErrorMsg + CHR(3)) + {aferrortxt.i 'AF' '1' '' '' "'New security group name'"}.

  IF cErrorMsg <> "" THEN
    RUN showMessages IN gshSessionManager (INPUT  cErrorMsg           /* message to display */
                                          ,INPUT  "ERR"               /* error type */
                                          ,INPUT  "&OK"               /* button list */
                                          ,INPUT  "&OK"               /* default button */ 
                                          ,INPUT  "&OK"               /* cancel button */
                                          ,INPUT  "Data error"        /* error window title */
                                          ,INPUT  YES                 /* display if empty */ 
                                          ,INPUT  ?                   /* container handle */
                                          ,OUTPUT cButtonPressed  ).  /* button pressed */
  ELSE
  IF VALID-HANDLE(gshSecurityManager) THEN
  DO:
    SESSION:SET-WAIT-STATE("general":U).
    RUN createGroupFromUser IN gshSecurityManager  (INPUT formattedwidgetValue("fiUser"), INPUT widgetValue("fiSecurityGroup")).
    SESSION:SET-WAIT-STATE("":U).
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "" THEN
      RUN showMessages IN gshSessionManager (INPUT  RETURN-VALUE        /* message to display */
                                            ,INPUT  "ERR"               /* error type */
                                            ,INPUT  "&OK"               /* button list */
                                            ,INPUT  "&OK"               /* default button */ 
                                            ,INPUT  "&OK"               /* cancel button */
                                            ,INPUT  "Data error"        /* error window title */
                                            ,INPUT  YES                 /* display if empty */ 
                                            ,INPUT  ?                   /* container handle */
                                            ,OUTPUT cButtonPressed  ).  /* button pressed */
    ELSE
    DO:
      ASSIGN cErrorMsg = {aferrortxt.i 'AF' '108' '' '' "'security group creation'" '' "''"}.
      RUN showMessages IN gshSessionManager (INPUT  cErrorMsg           /* message to display */
                                            ,INPUT  "ERR"               /* error type */
                                            ,INPUT  "&OK"               /* button list */
                                            ,INPUT  "&OK"               /* default button */ 
                                            ,INPUT  "&OK"               /* cancel button */
                                            ,INPUT  "Data error"        /* error window title */
                                            ,INPUT  YES                 /* display if empty */ 
                                            ,INPUT  ?                   /* container handle */
                                            ,OUTPUT cButtonPressed  ).  /* button pressed */
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

