&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
/* Procedure Description
"Super Procedure for User Maintenance - Detail viewer"
*/
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
/* Copyright (c) 1984-2015 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: gsmussupr1.p

  Description:  User Maintenance - Detail viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/19/2003  Author:     

  Update Notes: Created from Template viewv
  rkamboj 11/30/2012. User was able to create users in unauthorized company.
---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gsmussupr1.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE dLoginUser        AS DECIMAL    NO-UNDO.
define variable cAllowedCompany   as character no-undo.
define variable h_fiAllowedCompany as handle no-undo.    /* fiAllowedCompany */
define variable h_default_login_company_obj as handle    no-undo.

/*  object identifying preprocessor */
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



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: Basic,Browse,DB-Fields
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 17
         WIDTH              = 74.6.
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

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    /* RUN initializeObject. */  /* Commented out by migration progress */
  &ENDIF
   
  /************************ INTERNAL PROCEDURES ********************/

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

  /* Code placed here will execute PRIOR to standard behavior. */
  
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  RUN valueChangedProfileUser IN TARGET-PROCEDURE.

  /* Default save window pos and sizes to yes for new user */
  assignWidgetValue('create_user_profile_data':U, 'yes':U).
  run setAllowedCompany.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

  /* Code placed here will execute AFTER standard behavior.    */

  RUN valueChangedProfileUser IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeProfileUser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeProfileUser Procedure 
PROCEDURE changeProfileUser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   {set DataModified TRUE}.
   RUN valueChangedProfileUser IN TARGET-PROCEDURE.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-chooseButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chooseButton Procedure 
PROCEDURE chooseButton :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcButton AS CHARACTER  NO-UNDO.
  
  CASE pcButton:
    WHEN "Password":U THEN
      assignWidgetValue("user_password":U, "":U).
    OTHERWISE 
      assignWidgetValue("confirm_password":U, "":U).
  END CASE.
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

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  RUN valueChangedProfileUser IN TARGET-PROCEDURE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  
  
  RUN SUPER( INPUT pcRelative).

  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN valueChangedProfileUser IN TARGET-PROCEDURE.
  run setAllowedCompany.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-leaveLoginName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveLoginName Procedure 
PROCEDURE leaveLoginName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* If a new user record and the full name has not yet been entered then,
     default full name to login name upon leave */
  DEFINE VARIABLE cNewRecord      AS CHARACTER      NO-UNDO.
  {get newRecord cNewRecord}.

  IF cNewRecord EQ "ADD":U AND widgetValue("user_full_name":U) EQ "":U THEN
      assignWidgetValue("user_full_name":U, widgetValue("user_login_name":U)).
  
  run setAllowedCompany.
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

  /* Code placed here will execute AFTER standard behavior.    */

  RUN valueChangedProfileUser IN TARGET-PROCEDURE.

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

  /* Code placed here will execute PRIOR to standard behavior. */

   define variable dEnteredCompany     as character no-undo.
   define variable lSecurityRestricted as logical no-undo.
   define variable cSecurityValue1     as character no-undo.
   define variable cSecurityValue2     as character no-undo.
   define variable cButtonPressed      as character no-undo.
                                       
  dLoginUser        = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                INPUT "currentUserObj":U,
                                                INPUT NO)) NO-ERROR.
                                                
  dEnteredCompany =  widgetValue("default_login_company_obj":U).  
  RUN userSecurityCheck IN gshSecurityManager (INPUT dLoginUser,
                                               INPUT 0,                      /* All companies */
                                               INPUT "gsmlg":U,              /* login company FLA */
                                               INPUT decimal(dEnteredCompany),
                                               INPUT NO,                     /* Return security values - NO */
                                               OUTPUT lSecurityRestricted,   /* Restricted yes/no ? */
                                               OUTPUT cSecurityValue1,       /* clearance value 1 */
                                               OUTPUT cSecurityValue2).      /* clearance value 2 */    
   IF lSecurityRestricted THEN 
   DO:
       run showMessages in gshSessionManager ({errortxt.i 'AF' '40' '?' '?' '"User does not have access to selected login company"'},
                                              'INF',
                                              '&Ok',
                                              '&Ok',
                                              '&Ok',
                                              '',
                                              Yes,
                                              ?,
                                              output cButtonPressed) no-error.
       RETURN.
   END.                                                                        
                                                

  RUN SUPER.
 
  /* Code placed here will execute AFTER standard behavior.    */

  RUN valueChangedProfileUser IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-valueChangedProfileUser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChangedProfileUser Procedure 
PROCEDURE valueChangedProfileUser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFolderHandle    AS HANDLE     NO-UNDO.
  {get ContainerSource hContainerSource}.
  {get PageSource hFolderHandle hContainerSource}.

  /* Enable second Tab Page */
  IF widgetIsTrue("profile_user":U) THEN
    RUN enableFolderPage IN hFolderHandle (INPUT 5).
  ELSE
    RUN disableFolderPage IN hFolderHandle (INPUT 5).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-createObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects  Procedure 
procedure createObjects:    

/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define variable cProperties as character no-undo.
    define variable cCurrentLanguage as character no-undo.
    define variable lTranslationEnabled as logical no-undo.
    define variable lViewerTranslated as logical no-undo initial no.
    define variable lSecurityEnabled as logical no-undo. 
    define variable hContainer as handle no-undo.
    define variable cContainerName as character no-undo.
    define variable cRunAttribute as character no-undo.
    define variable hWidgetBuffer as handle no-undo.
    define variable cSecuredFields as character no-undo.
    define variable cSecuredTokens as character no-undo.
    define variable dFrameHeight as decimal no-undo.
    define variable dFrameWidth as decimal no-undo.            
    define variable dFrameMinHeight as decimal no-undo.
    define variable dFrameMinWidth as decimal no-undo.
    define variable lShowPopup as logical no-undo.
    define variable lPopupButtonInField as logical no-undo.
    define variable cFieldPopupMapping as character no-undo.    
    define variable iCurrentPage as integer no-undo.    
    define variable cAllFieldNames as character no-undo.
    define variable cAllFieldHandles as character no-undo.
    define variable cEnabledFields as character no-undo.
    define variable cEnabledHandles as character no-undo.
    define variable cEnabledObjFlds as character no-undo.
    define variable cEnabledObjHdls as character no-undo.
    define variable cDisplayedFields as character no-undo.
    define variable cFieldHandles as character no-undo.
    define variable cFieldSecurity as character no-undo.
    define variable lKeepChildPositions as logical no-undo.
    define variable lHideOnInit as logical no-undo.

      
      
    run super.
    
    cProperties = dynamic-function('getPropertyList':U IN gshSessionManager,
                                   'TranslationEnabled,CurrentLanguageCode,SecurityEnabled',
                                    No).
    assign cCurrentLanguage = entry(2, cProperties, chr(3))
           lTranslationEnabled = logical(entry(1, cProperties, chr(3)))
           no-error.
    if lTranslationEnabled eq ? then lTranslationEnabled = yes.
    lSecurityEnabled = logical(entry(3, cProperties, chr(3))) no-error.
    if lSecurityEnabled eq ? then lSecurityEnabled = yes.

    if lSecurityEnabled then
    do:
       {get ContainerSource hContainer}.
       &scoped-define xp-Assign
       {get LogicalObjectName cContainerName hContainer}
       {get RunAttribute cRunAttribute hContainer}
       .
       &undefine xp-Assign
       run fieldAndTokenSecurityCheck in gshSecurityManager (input  cContainerName,
                                                             input  cRunAttribute,
                                                             input  YES,
                                                             input  YES,
                                                             output cSecuredFields,
                                                             output cSecuredTokens  ).                 
    end.    /* security enabled */
    
    hWidgetBuffer = {fn getWidgetTableBuffer}.                
    
    &scoped-define xp-Assign
    {get ShowPopup lShowPopup}
    {get KeepChildPositions lKeepChildPositions}
    {get PopupButtonsInFields lPopupButtonInField}
    {get HideOnInit lHideOnInit}
    .
    &undefine xp-Assign
  
    run adm-create-h_fiAllowedCompany
      ( input       lShowPopup,
       input        lHideOnInit,
       input        lKeepChildPositions,
       input        lPopupButtonInField,
       input        cSecuredFields,
       input        cSecuredTokens,
       input        hWidgetBuffer,
       input-output dFrameWidth,
       input-output dFrameHeight,
       input-output cFieldPopupMapping,
       input-output cAllFieldHandles,
       input-output cAllFieldNames,
       input-output cFieldSecurity,
       input-output cDisplayedFields,
       input-output cEnabledFields,
       input-output cEnabledHandles,
       input-output cEnabledObjFlds,
       input-output cEnabledObjHdls,
       input-output cFieldHandles).
      
    
    dLoginUser = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                           INPUT "currentUserObj":U,
                                           INPUT NO)) NO-ERROR.
    h_default_login_company_obj = widgetHandle("default_login_company_obj").                                                
    run setAllowedCompany.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 

&ENDIF

procedure adm-create-h_fiAllowedCompany :
    /* Creates instance fiAllowedCompany */
    define input        parameter plShowPopup            as logical      no-undo.
    define input        parameter plHideOnInit           as logical      no-undo.
    define input        parameter plKeepChildPositions   as logical      no-undo.
    define input        parameter plPopupButtonInField   as logical      no-undo.
    define input        parameter pcSecuredFields        as character    no-undo.
    define input        parameter pcSecuredTokens        as character    no-undo.
    define input        parameter phWidgetBuffer         as handle       no-undo.
    define input-output parameter pdFrameWidth           as decimal      no-undo.    
    define input-output parameter pdFrameHeight          as decimal      no-undo.
    define input-output parameter pcFieldPopupMapping    as character    no-undo.
    define input-output parameter pcAllFieldHandles      as character    no-undo.    
    define input-output parameter pcAllFieldNames        as character    no-undo.
    define input-output parameter pcFieldSecurity        as character    no-undo.
    define input-output parameter pcDisplayedFields      as character    no-undo.
    define input-output parameter pcEnabledFields        as character    no-undo.
    define input-output parameter pcEnabledHandles       as character    no-undo.
    define input-output parameter pcEnabledObjFlds       as character    no-undo.
    define input-output parameter pcEnabledObjHdls       as character    no-undo.
    define input-output parameter pcFieldHandles         as character    no-undo.

    define variable iFont                as integer                      no-undo.
    define variable iLabelWidthPixels    as integer                      no-undo.
    define variable dLabelMinHeight      as decimal                      no-undo.
    define variable hLabel               as handle                       no-undo.
    define variable hPopup               as handle                       no-undo.
    define variable iPos as integer no-undo.
    define variable lVisible as logical no-undo.
    define variable cSecurityAction as character no-undo.
    define variable dWidgetWidth as decimal no-undo.
    define variable dWidgetHeight as decimal no-undo.
    define variable locNotAllowedCompany as character no-undo.
    define variable hFrame               as handle no-undo.
    
    lVisible = no.
    /* All widgets default to being visible */
    if lVisible eq ? then lVisible = yes.

    
    /* Apply security */
    iPos = lookup('fiAllowedCompany', pcSecuredFields).
    if iPos gt 0 then
    do:
        cSecurityAction = entry(iPos + 1, pcSecuredFields).
        if cSecurityAction eq 'Hidden' then
            lVisible = no.
    end.    /* field security found */
    else
    /* if no field security, check for token security. */
    do:
        iPos = lookup('fiAllowedCompany', pcSecuredTokens).
        if iPos ne 0 then
            cSecurityAction = 'ReadOnly'.
    end.    /* token security */


/*    hFrame = FOCUS:FRAME.*/
   
    create FILL-IN h_fiAllowedCompany
        assign name = 'fiAllowedCompany'
               data-type = 'Character'
        triggers:
        end triggers.
    /* CAN-SET() is performed by the generation, so
       all the attributes here can be set.

       Format is explicitly set in this ASSIGN so as to use 
       the NO-ERROR on the end.
 */
     
    assign
    h_fiAllowedCompany:format = "X(256)"
    h_fiAllowedCompany:COLUMN = 95
    h_fiAllowedCompany:ROW = 12.43
    h_fiAllowedCompany:WIDTH-CHARS = 5
    h_fiAllowedCompany:AUTO-RESIZE = no
    h_fiAllowedCompany:AUTO-RETURN = no
    h_fiAllowedCompany:BLANK = no
    h_fiAllowedCompany:CONTEXT-HELP-ID = 0
    h_fiAllowedCompany:DEBLANK = no
    h_fiAllowedCompany:DISABLE-AUTO-ZAP = no
    h_fiAllowedCompany:DROP-TARGET = no
    h_fiAllowedCompany:FONT = ?
    h_fiAllowedCompany:PASSWORD-FIELD = no
    h_fiAllowedCompany:READ-ONLY = no
    h_fiAllowedCompany:SUBTYPE = "PROGRESS"
    h_fiAllowedCompany:TAB-STOP = yes
    h_fiAllowedCompany:BGCOLOR = ?
    h_fiAllowedCompany:FGCOLOR = ?
    h_fiAllowedCompany:HEIGHT-CHARS = 1
    h_fiAllowedCompany:HELP = ""
    h_fiAllowedCompany:MANUAL-HIGHLIGHT = no
    h_fiAllowedCompany:MOVABLE = no
    h_fiAllowedCompany:PRIVATE-DATA = ""
    h_fiAllowedCompany:RESIZABLE = no
    h_fiAllowedCompany:SELECTABLE = no
    h_fiAllowedCompany:TOOLTIP = ""
    h_fiAllowedCompany:screen-value = "0"
    no-error.
    
    iFont = ?.
    iLabelWidthPixels = font-table:get-text-width-pixels('fiAllowedCompany:', iFont) + 3.
    dLabelMinHeight = if h_fiAllowedCompany:height-chars ge 1 then 1 else font-table:get-text-height(iFont).

    if iLabelWidthPixels gt 0 then
    do:
        create text hLabel
            assign format = 'x(' + string(length('fiAllowedCompany:', 'Column') + 1) + ')'
                   height-chars = min(h_fiAllowedCompany:height-chars, dLabelMinHeight)
                   name = 'Label_h_fiAllowedCompany'
                   tab-stop = no    /* labels don't belong in the tab order */
                   row = h_fiAllowedCompany:row
                   screen-value = 'fiAllowedCompany:'
                   width-pixels = iLabelWidthPixels.
        if h_fiAllowedCompany:x - hLabel:width-pixels gt 0 then
            hLabel:x = h_fiAllowedCompany:x - hLabel:width-pixels.
        else
            hLabel:x = 1.

        assign hLabel:font = ? WHEN '?' NE '?'
               hLabel:fgcolor = ? WHEN '?' NE '?'
               hLabel:bgcolor = ? WHEN '?' NE '?'
               h_fiAllowedCompany:side-label-handle = hLabel.
    end.    /* there is a side-label-handle */

  
    /* Always populate this list, even if no popups have been created.
       This is to prevent duplicates when widgetWalk runs. */
    pcFieldPopupMapping = pcFieldPopupMapping + ',':u
                        + string(h_fiAllowedCompany) + ',':u
                        + (if hPopup eq ? then '?':u else string(hPopup)).


    if h_fiAllowedCompany:type eq 'Editor' then
        h_fiAllowedCompany:read-only = yes.

/*    h_fiAllowedCompany:sensitive = (if h_fiAllowedCompany:type eq 'Editor' then yes else no).*/

    /* Modified is set to true by the 4GL after setting visible to true up above.  Modified is set
       to false for datafields when they are displayed.  When certain widgets that are not 
       dataobject-based are enabled, modified is set to false by the 4GL, for others it is not
       so we need to set it to false here. */
    if lVisible then
        h_fiAllowedCompany:modified = no.

    /* Special handling for images. Load the image so that we can see it. */
    h_fiAllowedCompany:load-image("") no-error.

    /* If the field is to be made visible, then the label should be, too. However, we cannot set the
       VISIBLE attribute to YES without the viewer's frame's VISIBLE attribute also being set to YES
       by the 4GL.  This behaviour is not acceptable if the viewer's HideOnInit property is true.
       We also need to ensure that all hidden widgets are actually hidden, so we explicitly set
       their VISIBLE property to NO.                                                                 
     */
    if can-set(h_fiAllowedCompany, 'Hidden') and
         (not plHideOnInit or lVisible eq no) then
        assign h_fiAllowedCompany:hidden = not lVisible
               h_fiAllowedCompany:side-label-handle:hidden = h_fiAllowedCompany:hidden
               no-error.

    dWidgetHeight = 1.
    dWidgetWidth = 5.
    
    /* Build lists of the fields to display and enable */
            
    assign pcFieldSecurity   =   cSecurityAction
           pcEnabledObjFlds  =  'fiAllowedCompany'
           pcEnabledObjHdls  =  string(h_fiAllowedCompany)
           pcFieldHandles    =  string(h_fiAllowedCompany)
           pcDisplayedFields =  pcDisplayedFields +  "fiAllowedCompany"
           pcAllFieldHandles =  string(h_fiAllowedCompany)
           pcEnabledFields   =  'fiallowedCompany'
           pcEnabledObjFlds  =  'fiallowedCompany'
           pcEnabledObjHdls  =  string(h_fiAllowedCompany)
           pcAllFieldNames   =  'fiAllowedCompany'.

    assign pdFrameWidth = max(pdFrameWidth, 95 + dWidgetWidth - 1)
           pdFrameHeight = max(pdFrameHeight, 12.43 + dWidgetHeight - 1).

    /* Create ttWidget records for repositioning after translation. */            
    phWidgetBuffer:buffer-create().
    assign phWidgetBuffer:buffer-field('tWidgetHandle'):buffer-value = h_fiAllowedCompany
           phWidgetBuffer:buffer-field('tTargetProcedure'):buffer-value = target-procedure
           phWidgetBuffer:buffer-field('tWidth'):buffer-value = 5
           phWidgetBuffer:buffer-field('tRow'):buffer-value = 12.43
           phWidgetBuffer:buffer-field('tEndRow'):buffer-value = 12.43 + 1
           phWidgetBuffer:buffer-field('tColumn'):buffer-value = 95
           phWidgetBuffer:buffer-field('tRow'):buffer-value = 12.43
           phWidgetBuffer:buffer-field('tWidgetType'):buffer-value = 'FILL-IN'
           phWidgetBuffer:buffer-field('tTabOrder'):buffer-value = 0
           phWidgetBuffer:buffer-field('tVisible'):buffer-value = lVisible
           phWidgetBuffer:buffer-field('tFont'):buffer-value = ?
           phWidgetBuffer:buffer-field('tTableName'):buffer-value = ''
           phWidgetBuffer:buffer-field('tInitialValue'):buffer-value = '0'.
    phWidgetBuffer:buffer-release().

    error-status:error = no.
    return.
end procedure.    /* adm-create-h_fiAllowedCompany */

procedure setAllowedCompany:
   define variable Cntr                        as Integer   no-undo.
   define variable cLoginCompanyObject         as character no-undo.
   define variable cAllowedCompany             as character no-undo.     
  
    run userLoginOrganisations IN gshSecurityManager (INPUT dLoginUser, output cAllowedCompany).
    /* PSC00328149:
    previously cAllowedCompany returned the result with comma(,) separated values, 
    this will fail to fetch the correct companies on below code with European settings 
    since cLoginCompanyObject returns the decimal values with comma(,) as numeric-decimal-point(with European settings).
    To fix this we will be using hash(#) to separate cAllowedCompany values.
    Now cAllowedCompany will return the result with hash(#) separated values and below code will look for hash(#).
    */
    do Cntr = 2 to num-entries(cAllowedCompany,"#") by 2:
        if Cntr > 2 then cLoginCompanyObject = cLoginCompanyObject + "#".
           cLoginCompanyObject = cLoginCompanyObject + entry(Cntr,cAllowedCompany,"#").
    end.    
  
    {set ParentField 'fiAllowedCompany' h_default_login_company_obj}.
    {set ParentFilterQuery '"lookup(string(gsm_login_company.login_company_obj), ""' + cLoginCompanyObject + '"",""#"")  > 0"' h_default_login_company_obj}.
    

end procedure.    