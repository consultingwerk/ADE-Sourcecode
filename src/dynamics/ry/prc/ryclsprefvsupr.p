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
/*---------------------------------------------------------------------------------
  File: ryclsprefvsupr.p

  Description:  Class User Prefs Viewer Super Proc

  Purpose:      Class User Prefs Viewer Super Proc

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/25/2004  Author:     pjudge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryclsprefvsupr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-showPreferences) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD showPreferences Procedure 
FUNCTION showPreferences RETURNS LOGICAL PRIVATE
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-changePreference) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changePreference Procedure 
PROCEDURE changePreference :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PROTECTED
  Purpose:     Saves changed preferences away.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE input parameter phSelf                as handle            no-undo.
    
    DEFINE variable hAlways           as handle                       no-undo.
    DEFINE variable hNever            as handle                       no-undo.    
    DEFINE variable cProfileData      as character                    no-undo.
    
    hAlways = dynamic-function('internalWidgetHandle' in target-procedure,
                               'toAlways', '').
    
    hNever = dynamic-function('internalWidgetHandle' in target-procedure,
                              'toNever', '').
    
    /* make sure that both toggles aren't simulaneously checked.
      both toggles may be legitimately unchecked though.
     */
    if self eq hAlways and
       self:checked then
        hNever:checked = no.
    else
    if self:checked then
        hAlways:checked = no.
    
    /* Determine the setting */
    if hAlways:checked then cProfileData = 'Always'.
    else
    if hNever:checked then cProfileData = 'Never'.
    else
        cProfileData = ''.
    
    RUN setProfileData IN gshProfileManager (INPUT 'General',
                                             INPUT 'UpdCustCls':U,         /* Profile code */
                                             INPUT 'UpdCustCls',         /* Profile data key */
                                             INPUT ?,                   /* Rowid of profile data */
                                             INPUT cProfileData,        /* Profile data value */
                                             INPUT NO,                  /* Delete flag */
                                             INPUT "PER":u) no-error. /* Save flag (permanent) */                                             
    {fn showPreferences}.    
    
    return.
END PROCEDURE.    /* changePreference s*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearPreference) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearPreference Procedure 
PROCEDURE clearPreference :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PROTECTED
  Purpose:     clears all preferences.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN setProfileData IN gshProfileManager (INPUT 'General',
                                             INPUT 'UpdCustCls':U,         /* Profile code */
                                             INPUT 'UpdCustCls',         /* Profile data key */
                                             INPUT ?,                   /* Rowid of profile data */
                                             INPUT '',        /* Profile data value */
                                             INPUT NO,                  /* Delete flag */
                                             INPUT "PER":u) no-error. /* Save flag (permanent) */

    {fn showPreferences}.    
    
    return.
END PROCEDURE.    /* clearPreference */

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
    
    run super.
    
    if not valid-handle(gshProfileManager) then
        run disableObject in target-procedure.
        
    {fn showPreferences}.        
    
    return.
END PROCEDURE.    /* initializeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-showPreferences) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION showPreferences Procedure 
FUNCTION showPreferences RETURNS LOGICAL PRIVATE
        (  ):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes:
------------------------------------------------------------------------------*/
    DEFINE variable rRowid            as rowid                        no-undo.
    DEFINE variable cProfileData      as character                    no-undo.
    DEFINE variable hAlways           as handle                       no-undo.
    DEFINE variable hNever            as handle                       no-undo.    

    if valid-handle(gshProfileManager) then
        RUN getProfileData IN gshProfileManager (INPUT        "General":U,
                                                 INPUT        "UpdCustCls":U,
                                                 INPUT        "UpdCustCls":U,
                                                 INPUT        NO,
                                                 INPUT-OUTPUT rRowid,
                                                       OUTPUT cProfileData) no-error.
    
    hAlways = dynamic-function('internalWidgetHandle' in target-procedure,
                               'toAlways', '').
                               
    hNever = dynamic-function('internalWidgetHandle' in target-procedure,
                              'toNever', '').
    case cProfileData:
        when "Always" then
            assign hAlways:checked = yes
                   hNever:checked = no.
        when "Never" then
            assign hAlways:checked = no
                   hNever:checked = yes.
        otherwise
            assign hAlways:checked = no
                   hNever:checked = no.        
    end case.    /* profile data */
    
    return true.
END FUNCTION.    /* showPreferences */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

