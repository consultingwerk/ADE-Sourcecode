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
/* Copyright (C) 2007 by Progress Software Corporation. All rights    
   reserved.  Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: ryclspropbsupr.p

  Description:  Class Properties Browser Super

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   04/22/2004  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryclsevntbsupr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

/* ttLocalContext stores local/temporary properties 
   that are not in the repository, particularly things
   like the handles of widgets created on-the-fly.
 */
DEFINE temp-table ttLocalContext        no-undo
    field TargetProcedure    as handle
    field ContextName        as character
    field ContextValue       as character
    index idxName    as primary unique
        TargetProcedure
        ContextName.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-buildManagerList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildManagerList Procedure PRIVATE
FUNCTION buildManagerList RETURNS CHARACTER PRIVATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildOverlayWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildOverlayWidgets Procedure PRIVATE
FUNCTION buildOverlayWidgets RETURNS LOGICAL PRIVATE
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyOverlayWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyOverlayWidgets Procedure 
FUNCTION destroyOverlayWidgets RETURNS LOGICAL PRIVATE
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTargetCombo Procedure 
FUNCTION getTargetCombo RETURNS HANDLE PRIVATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTypeCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTypeCombo Procedure 
FUNCTION getTypeCombo RETURNS HANDLE PRIVATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideOverlayWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hideOverlayWidgets Procedure 
FUNCTION hideOverlayWidgets RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTargetCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTargetCombo Procedure 
FUNCTION setTargetCombo RETURNS LOGICAL PRIVATE
  ( INPUT phTargetCombo AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTypeCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTypeCombo Procedure 
FUNCTION setTypeCombo RETURNS LOGICAL PRIVATE
  ( INPUT phTypeCombo AS HANDLE )  FORWARD.

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
&IF DEFINED(EXCLUDE-resetRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord Procedure 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    run super.
    
    /* on reset, get the values back. this includes the
       attribute lookup.
     */
    {fn hideOverlayWidgets}.
    run overlayWidget in target-procedure.
    
    return.
END PROCEDURE.    /* resetRecord */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord Procedure 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    run super.
    
    {fn hideOverlayWidgets}.
    
    return.
END PROCEDURE.    /* cancelRecord */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-changeComboValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeComboValue Procedure 
PROCEDURE changeComboValue :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE input parameter phCombo            as handle                no-undo.
    
    DEFINE variable hValueColumn             as handle                 no-undo.    
    DEFINE variable hBrowse                  as handle                 no-undo.
    DEFINE variable cColumnChanged           as character              no-undo.
    DEFINE VARIABLE cOriginalValue           AS CHARACTER              NO-UNDO.
    
    /* Since the selection list is emulating a combo-box, only apply change when the
     * user either clicks on an item on presses enter. Not when using cursor.
     */
    case phCombo:name:
        when 'coType' then cColumnChanged = 'tActionType'.
        when 'coTarget' then cColumnChanged = 'tActionTarget'.        
    end case.    /* combo name */
    
    assign hValueColumn = {fnarg widgetHandle cColumnChanged}
           cOriginalValue = hValueColumn:SCREEN-VALUE
           hValueColumn:SCREEN-VALUE = phCombo:SCREEN-VALUE
           NO-ERROR.
    
    /* apply the changes */
    if cOriginalValue ne hValueColumn:SCREEN-VALUE then
        {set DataModified yes}.
    
    return.    
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
    DEFINE input parameter pcRelative        as character                no-undo.
    
    DEFINE variable cMode             as character                       no-undo.

    run super (pcRelative).
    
    {get ObjectMode cMode}.
    if cMode ne "view" then
        run overlayWidget in target-procedure.
    else
        {fn hideOverlayWidgets}.
    
    return.
END PROCEDURE.    /* dataAvailable */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecord Procedure 
PROCEDURE deleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable hContainer            as handle                    no-undo.
    DEFINE variable hToolbar              as handle                    no-undo.
    DEFINE variable hDataSource           as handle                    no-undo.
    DEFINE variable hClassDataSource      as handle                    no-undo.
    DEFINE variable cButtonPressed        as character                 no-undo.
    DEFINE variable cValidClasses         as character                 no-undo.
    DEFINE variable cWhereStored          as character                 no-undo.
    
    &scoped-define xp-assign
    {get ContainerSource hContainer}
    {get DataSource hDataSource}.
    &undefine xp-assign
    
    /* if the where stored is not the current class and 
       not the custom class then disallow deleted.       
     */         
    publish "findCustomizingClass" from hContainer (output cValidClasses).
    
    assign cValidClasses = cValidClasses + ',' + {fnarg columnValue 'tClassName' hDataSource}
           cValidClasses = left-trim(cValidClasses, ',')
           cWhereStored = {fnarg columnValue 'tWhereStored' hDataSource}.
    
    if not can-do(cValidClasses, cWhereStored) then
        RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'af' '40' '?' '?'
                                                      "'Only events stored at one of these classes:' + cValidClasses + ' can be deleted.'" },
                                               INPUT  "ERR",          /* error type */
                                               INPUT  "&OK",    /* button list */
                                               INPUT  "&OK",           /* default button */ 
                                               INPUT  "&OK",       /* cancel button */
                                               INPUT  "Delete disallowed", /* error window title */
                                               INPUT  YES, /* display if empty */ 
                                               INPUT  hContainer,
                                               OUTPUT cButtonPressed       ).
    else
    do:
        run super.
        
        if return-value ne 'adm-error' then
        do:
            /* Clear the client cache */
            run destroyClassCache in gshRepositoryManager.
            
            {get DataSource hClassDataSource hDataSource}.
            
            /* force the class data (and thus child data) to refresh. */
            run refreshRow in hClassDataSource.            
        end.    /* no delete errors */
    end.    /*delete the record */
    
    return.
END PROCEDURE.    /* deleteRecord */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable hAttributeLookup         as handle                    no-undo.
    
    run super.
    
    {fn destroyOverlayWidgets}.
    
    return.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideObject Procedure 
PROCEDURE hideObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {fn hideOVerlayWidgets}.
    
    run super.
    return.
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
    DEFINE variable hColumn            as handle                        no-undo.
    
    {fn buildOverlayWidgets}.
    
    run super.
    
    /* Add sizing triggers so that the overlay widgets resize nicely. */        
    hColumn = {fnarg widgetHandle 'tActionType'}.
    on 'end-resize' of hColumn persistent run overlayWidget in target-procedure.
    
    hColumn = {fnarg widgetHandle 'tActionTarget'}.
    on 'end-resize' of hColumn persistent run overlayWidget in target-procedure.

    return.
END PROCEDURE.    /* initializeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-overlayWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE overlayWidget Procedure 
PROCEDURE overlayWidget :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Positions either the lookup button or the dialog button
               within the value field for the attribute browse
  Notes:      
------------------------------------------------------------------------------*/
    DEFINE variable hFrame               as handle                    no-undo.
    DEFINE variable hBrowse              as handle                    no-undo.
    DEFINE variable hCol                 as handle                    no-undo.
    DEFINE variable hOverlayWidget       as handle                    no-undo.
    DEFINE variable hValueColumn         as handle                    no-undo.
    DEFINE variable hDataSource          as handle                    no-undo.
    DEFINE VARIABLE cLookupType          AS CHARACTER                 NO-UNDO.
    DEFINE variable iDataType            as integer                   no-undo.
    
    /* Hide all overlay widgets */
    {fn hideOverlayWidgets}.
        
    /* Overlay the TYPE combo */
    {get TypeCombo hOverlayWidget}.
    if valid-handle(hOverlayWidget) then
    do:
        {get ContainerHandle hFrame}.
        {get BrowseHandle hBrowse}.
        
        hValueColumn = {fnarg widgetHandle 'tActionType'}.
        
        IF hValueColumn:Y lt 0 OR
           hValueColumn:X lt 0 OR 
           hValueColumn:X + hValueColumn:WIDTH-Pixels + hOverlayWidget:WIDTH-Pixels gt hBrowse:WIDTH-Pixels THEN
           hOverlayWidget:hidden = yes.
        ELSE
        DO:
            ASSIGN hOverlayWidget:WIDTH-Pixels = hValueColumn:WIDTH-Pixels + 6
                   hOverlayWidget:height-pixels = hValueColumn:height-pixels
                   hOverlayWidget:Y = hValueColumn:Y + hBrowse:Y
                   hOverlayWidget:X = hValueColumn:X + hBrowse:X + hValueColumn:WIDTH-PIXELS
                                - hOverlayWidget:WIDTH-PIXELS + 4
                   hOverlayWidget:hidden = no
                   NO-ERROR.
            
            hOverlayWidget:MOVE-TO-TOP().
            hOverlayWidget:screen-value = hValueColumn:screen-value.
        end.    /* make it visible */
    end.    /* valid overlay widget */
    
    {get TargetCombo hOverlayWidget}.
    if valid-handle(hOverlayWidget) then
    do:
        {get ContainerHandle hFrame}.
        {get BrowseHandle hBrowse}.
        
        hValueColumn = {fnarg widgetHandle 'tActionTarget'}.
        
        IF hValueColumn:Y lt 0 OR
           hValueColumn:X lt 0 OR 
           hValueColumn:X + hValueColumn:WIDTH-Pixels + hOverlayWidget:WIDTH-Pixels gt hBrowse:WIDTH-Pixels THEN
           hOverlayWidget:hidden = yes.
        ELSE
        DO:
            ASSIGN hOverlayWidget:WIDTH-Pixels = hValueColumn:WIDTH-Pixels + 6
                   hOverlayWidget:height-pixels = hValueColumn:height-pixels
                   hOverlayWidget:Y = hValueColumn:Y + hBrowse:Y
                   hOverlayWidget:X = hValueColumn:X + hBrowse:X + hValueColumn:WIDTH-PIXELS
                                - hOverlayWidget:WIDTH-PIXELS + 4
                   hOverlayWidget:hidden = no
                   NO-ERROR.

            hOverlayWidget:MOVE-TO-TOP().
            hOverlayWidget:screen-value = hValueColumn:screen-value.
        end.    /* make it visible */
    end.    /* valid overlay widget */

    ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE input parameter pdHeight            as decimal                 no-undo.
    DEFINE input parameter pdWidth             as decimal                 no-undo.
    
    DEFINE variable hFrame            as handle                         no-undo.
    DEFINE variable hBrowse           as handle                         no-undo.
    
    /* The standard browser resizing code checks for the existence of 
       other widgets on the browser and doesn't resize if it can find 
       any. This means that the browser resizing should be managed here.
       
       The resizing code is taken from browser.p's resizeObject and 
       does the same as there, except that it doesn't care about other
       widgets. 
     */
    {get BrowseHandle hBrowse}.
    {get ContainerHandle hFrame}.
    
    /* Assure that it doesn't get too small */
    ASSIGN pdHeight = MAX(pdHeight, 2)
           pdWidth  = MAX(pdWidth, 2).
           
    IF pdWidth lt hBrowse:WIDTH THEN
        ASSIGN hBrowse:WIDTH = pdWidth - (hBrowse:COLUMN - 1)
               hFrame:WIDTH  = pdWidth
               NO-ERROR.
    ELSE
        ASSIGN hFrame:WIDTH  = pdWidth
               hBrowse:WIDTH = pdWidth - (hBrowse:COLUMN - 1)
               NO-ERROR.           
               
    /* If the height is getting smaller, do the browse first else the frame */
    IF pdHeight < hBrowse:HEIGHT THEN                                                            
        ASSIGN hBrowse:HEIGHT = pdHeight - (hBrowse:ROW - 1)
               hFrame:HEIGHT  = pdHeight
               NO-ERROR.
    ELSE
        ASSIGN hFrame:HEIGHT  = pdHeight
               hBrowse:HEIGHT = pdHeight - (hBrowse:ROW - 1)
               NO-ERROR.
    
    run super(pdHeight,pdWidth).
    
    /* Don't try to show stuff if the frame is hidden at the moment.
     */    
    if not hFrame:hidden then
    do:
        if {fn getObjectMode} eq 'View' then
            {fn hideOverlayWidgets}.
        else        
            run overlayWidget in target-procedure.
    end.    /* frame visible */
        
    return.
END PROCEDURE.    /* resizeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowLeave) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowLeave Procedure 
PROCEDURE rowLeave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable hEntered             as handle                     no-undo.
    DEFINE variable hParent              as handle                     no-undo.
    DEFINE variable hFrame               as handle                     no-undo.
    DEFINE variable hThisFrame           as handle                     no-undo.    
    DEFINE variable lRunSuper            as logical                    no-undo.
    
    /* Check where we've gone. If we've left
       the row to select something from a lookup,
       then don't leave the row.
     */
    hEntered = LAST-EVENT:WIDGET-ENTER.                
    IF VALID-HANDLE(hEntered) THEN
        hParent = hEntered:PARENT.
    
    IF VALID-HANDLE(hParent) AND hParent:TYPE NE "BROWSE":U THEN
        hFrame = hEntered:FRAME.  /* Can't check FRAME on Brs flds */
    
    /* get the handle of the lookup. */
    {get ContainerHandle hThisFrame}.
    
    /* if we have left the browse column to
       pick an attribute, then don't do the default
       behaviour.
         */
    if valid-handle(hThisFrame) and 
       valid-handle(hFrame) and 
       hThisFrame eq hFrame then
           lRunSuper = no.
    else
        lRunSuper = yes.
    
    if lRunSuper then
        run super.
    
    return.
END PROCEDURE.    /* rowLeave */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateMode Procedure 
PROCEDURE updateMode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE input parameter pcMode            as character            no-undo.
    
    run super (pcMode).
    
    if pcMode eq 'View' then
        {fn hideOverlayWidgets}.
    else
        run overlayWidget in target-procedure.        
    
    return.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord Procedure 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable cTagCode            as character                    no-undo.
    DEFINE variable cClassName          as character                    no-undo.
    DEFINE variable cAnswer             as character                    no-undo.
    DEFINE variable cButton             as character                    no-undo.
    DEFINE variable cCustomClass        as character                    no-undo.
    DEFINE variable cEventName          as character                    no-undo.
    DEFINE variable hDataSource         as handle                       no-undo.
    DEFINE variable hClassDataSource    as handle                       no-undo.
    DEFINE variable hContainer          as handle                       no-undo.
    DEFINE variable hRDM                as handle                       no-undo.
    DEFINE variable hRowObjectBuffer    as handle                       no-undo.    
    DEFINE variable dClassObj           as decimal                      no-undo.    
    DEFINE VARIABLE rRowid              AS ROWID                        NO-UNDO.
    DEFINE VARIABLE cProfileData        AS CHARACTER                    NO-UNDO.
    DEFINE variable lCreateCustomClass  as logical                      no-undo.
    define variable hROBuf              as handle no-undo.
    define variable lDup                as logical no-undo.
        
    {get ContainerSource hContainer}.
    
    /* If we are customising a standard Dynamics class - one that has the 
       RY_OWN tag - by changing attribute values, ask first whether to 
       create a new custom class. This is so that customers are prevented
       from losing customisations.
       This should apply to all actions (including deletes) since all actions
       change the behaviour of a class.
     */
    {get DataSource hDataSource}.
    {get DataSource hClassDataSource hDataSource}.
    {get RowObject hRowObjectBuffer hDataSource}.
    
    /* The event name is used for a couple of things,
       so get it first.
     */
    cEventName = {fnarg widgetValue 'tEventName'}.    
        
    /* Make sure that a duplicate record is not being created.
       Obviously only do this in Add or Copy mode.
     */
    if {fn getNewRecord} ne 'no' then
    do:
        /* There needs to be a valid event name. */
        if cEventName eq '' or cEventName eq ? then
        do:
            if valid-handle(gshSessionManager) then
	            RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'AF' '1' '?' '?' '"event name"'},
	                                                   INPUT  "ERR", /* error type */
	                                                   INPUT  "&OK", /* button list */
	                                                   INPUT  "&OK", /* default button */ 
	                                                   INPUT  "&OK", /* cancel button */
	                                                   INPUT  "Invalid event name", /* window title */
	                                                   INPUT  YES, /* display if empty */ 
	                                                   INPUT  hContainer,
	                                                   OUTPUT cButton       ).
	        return 'adm-error'.
        end.    /* blank event name */
        
        /* Search the rowobject buffer using a named buffer so as not 
	       to disturb the SDO's query (which findRowWhere() will do) since
	       that will cause the browser to reposition.	*/
        create buffer hROBuf for table hRowObjectBuffer buffer-name 'lbRO':u.
        
        hROBuf:find-first(' where ':u + hROBuf:name + '.tEventName = ':u + quoter(cEventName)) no-error.
        lDup = hROBuf:available. 
        delete object hROBuf no-error.
        hROBuf = ?.
        
        if lDup then
        do:
            if valid-handle(gshSessionManager) then
                RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'AF' '40' '?' '?'
                                                              "'An event called ' + cEventName + ' already exists for this class'"},
                                                       INPUT  "ERR", /* error type */
                                                       INPUT  "&OK", /* button list */
                                                       INPUT  "&OK", /* default button */ 
                                                       INPUT  "&OK", /* cancel button */
                                                       INPUT  "Duplicate event ~'" + cEventName + "~'", /* window title */
                                                       INPUT  YES, /* display if empty */ 
                                                       INPUT  hContainer,
                                                       OUTPUT cButton       ).
            return 'adm-error'.
        end.    /* found a duplicate */
    end.    /* add or copy */        
    
    /* Get the tags off the class.
     */
    cTagCode = {fnarg columnValue 'DataTags' hClassDataSource}.
    
    publish "findCustomizingClass" from hContainer (output cCustomClass).
    
    if cCustomClass eq '' and can-do(cTagCode, 'RY_OWN') then
    do:
        /* Get the user profile as to whether a new class should be created. 
        */
        if valid-handle(gshProfileManager) then
            RUN getProfileData IN gshProfileManager (INPUT                "General":U,
                                                     INPUT                "UpdCustCls":U,
                                                     INPUT                "UpdCustCls":U,
                                                     INPUT        NO,
                                                     INPUT-OUTPUT rRowid,
                                                           OUTPUT cProfileData) no-error.
        
        case cProfileData:
            when "Always" then lCreateCustomClass = yes.
            when "Never" then lCreateCustomClass = no.
            otherwise lCreateCustomClass = ?.
        end case.    /* profile data */
        
        /* ask if to need to create a new class */
        if lCreateCustomClass eq ? then
        do:
            cClassName = {fnarg columnValue 'object_type_code' hClassDataSource}.
            
            if valid-handle(gshSessionManager) then
                RUN askQuestion IN gshSessionManager (INPUT ('You have changed the ' + cClassName
                                                            + ' class that is owned by the central Dynamics repository.'
                                                            + ' Would you like to create a custom class for it?'
                                                            + '~nThis is the recommended approach.'),
                                                      INPUT '&Yes,&Always,&No,Ne&ver,&Cancel':U,    /* button list */
                                                      INPUT '&Always':U, /* default button */ 
                                                      INPUT '&Cancel',       /* cancel button */
                                                      INPUT 'Create custom class',             /* window title */
                                                      INPUT '':U,      /* data type of question */ 
                                                      INPUT '':U,          /* format mask for question */ 
                                                      INPUT-OUTPUT cAnswer,
                                                      OUTPUT cButton         ) no-error.
            /* get rid of the ampersand */
            cButton = replace(cButton, '&', '').
            
            /* Give a way out. */
            if cButton eq 'Cancel' then
                return 'adm-error'.
            
            /* decide whether to create a class or not. */
            if can-do('Yes,Always', cButton) then
                lCreateCustomClass = yes.
            else
            if can-do('No,Never', cButton) then
                lCreateCustomClass = no.
                                
            /* always and never are stored as profile data */
            if can-do('Always,Never', cButton) then
            do:
                IF VALID-HANDLE(gshProfileManager) THEN
                    RUN setProfileData IN gshProfileManager (INPUT 'General',
                                                             INPUT 'UpdCustCls':U,         /* Profile code */
                                                             INPUT 'UpdCustCls',         /* Profile data key */
                                                             INPUT ?,                   /* Rowid of profile data */
                                                             INPUT cButton,        /* Profile data value */
                                                             INPUT NO,                  /* Delete flag */
                                                             INPUT "PER":u) no-error. /* Save flag (permanent) */
            end.    /* always or never. */                
        end.    /* ask whether to create a custom class */
        
        /* create class */
        if lCreateCustomClass then
        do:
            /* need the container to store the
               custom class name and for error
               messages, if any.
             */
            {get ContainerSource hContainer}.
                        
            /* we may not have a class name yet, especially
               if the 'Always' option has been chosen.
             */             
            if cClassName eq '' then
                cClassName = {fnarg columnValue 'object_type_code' hClassDataSource}.
            
            /* create a default value */
            cAnswer = cClassName + '_Custom'.
            if valid-handle(gshSessionManager) then
                RUN askQuestion IN gshSessionManager (INPUT 'Enter the name of the customizing class',
                                                      INPUT '&Ok,&Cancel':U, /* button list */
                                                      INPUT '&Ok':U, /* default button */ 
                                                      INPUT '&Cancel', /* cancel button */
                                                      INPUT 'Custom class name', /* window title */
                                                      INPUT 'Character':U,      /* data type of question */ 
                                                      INPUT 'x(35)':U,          /* format mask for question */ 
                                                      INPUT-OUTPUT cAnswer,
                                                            OUTPUT cButton         ) no-error.
            /* Give a way out. */
            if replace(cButton, '&','') eq 'Cancel' then
                return 'adm-error'.
            
            /* create the class */
            hRDM = {fnarg getManagerHandle 'RepositoryDesignManager'}.
            if valid-handle(hRDM) then
            do:
                /* Add a new class. Default as many values as possible 
                   to the current class.
                 */
                run insertClass in hRDM ( input  cAnswer,    /* class name */
                                          input  ('Customizing class for ' + cClassName), /*pcClassDescription*/
                                          input  '', /* no parent class by default; pcExtendsClassName */
                                          input  '', /* no custom class by default; pcCustomClassName */
                                          input  {fnarg columnValue 'disabled' hClassDataSource},
                                          input  {fnarg columnValue 'layout_supported' hClassDataSource},
                                          input  {fnarg columnValue 'deployment_type' hClassDataSource},
                                          input  {fnarg columnValue 'static_object' hClassDataSource},
                                          input  {fnarg columnValue 'cache_on_client' hClassDataSource},
                                          input  '', /* no class object name; pcClassObjectName */
                                          output dClassObj ) no-error.
                if error-status:error or return-value ne '' then
                do:
                    if valid-handle(gshSessionManager) then
	                    RUN showMessages IN gshSessionManager (INPUT  return-value,
	                                                           INPUT  "ERR", /* error type */
	                                                           INPUT  "&OK", /* button list */
	                                                           INPUT  "&OK", /* default button */ 
	                                                           INPUT  "&OK", /* cancel button */
	                                                           INPUT  "Error creating class " + cAnswer, /* window title */
	                                                           INPUT  YES, /* display if empty */ 
	                                                           INPUT  hContainer,
	                                                           OUTPUT cButton       ).
                    return 'adm-error'.
                end.    /* error creating custom class. */
                
                /* Add the new custom class to the existing class 
                   unknown values mean use what's there.
                 */
                run insertClass in hRDM ( input  cClassName,
                                          input  ?,
                                          input  ?,
                                          input  cAnswer, /* pcCustomClassName */
                                          input  ?, /* disabled */
                                          input  ?,     /* layout supported */
                                          input  ?, /* deployment type */
                                          input  ?, /* static object */
                                          input  ?, /* cache on client */
                                          input  ?, /* pcClassObjectName */
                                          output dClassObj ) no-error.
                if error-status:error or return-value ne '' then
                do:
                    if valid-handle(gshSessionManager) then
	                    RUN showMessages IN gshSessionManager (INPUT  return-value,
	                                                           INPUT  "ERR", /* error type */
	                                                           INPUT  "&OK", /* button list */
	                                                           INPUT  "&OK", /* default button */ 
	                                                           INPUT  "&OK", /* cancel button */
	                                                           INPUT  "Error updating class " + cClassName, /* window title */
	                                                           INPUT  YES, /* display if empty */ 
	                                                           INPUT  hContainer,
	                                                           OUTPUT cButton       ).
                    return 'adm-error'.
                end.    /* error creating custom class. */
                
                /* store the name of the custom class for use 
                   by the data obejct.
                 */
                dynamic-function('setUserProperty' in hContainer,
                                 'CustomClass', cAnswer).
            end.    /* valid RDM */
        end.    /* create custom class */
    end.    /* warn re customisation */
    
    run super.
    
    if return-value ne 'adm-error' then   
    do:
        /* clear out the client cache */
        run destroyClassCache in gshRepositoryManager.
        
        /* force the class data (and thus child data) to refresh. */
        run refreshRow in hClassDataSource.
        
        /* reposition */
        dynamic-function('findRowWhere' in hDataSource, 'tEventName', cEventName, '=').
    end.    /* no update error */
    
    error-status:error = no.            
    return.
END PROCEDURE.    /* updateRecord */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject Procedure 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    run super.
    
    if {fn getObjectMode} eq 'View' then
        {fn hideOverlayWidgets}.
    else
        run overlayWidget in target-procedure.
    
    return.
END PROCEDURE.    /* viewobject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-buildManagerList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildManagerList Procedure  PRIVATE
FUNCTION buildManagerList RETURNS CHARACTER PRIVATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Returns a list of valid managers that may be used
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hParam           AS HANDLE     NO-UNDO. 
    DEFINE VARIABLE hManager         AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hManagerBuffer   AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cManagerList     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hQuery           AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cFieldName       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFieldHName      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hField           AS HANDLE     NO-UNDO.
 
    RUN obtainCFMTables IN target-PROCEDURE (OUTPUT hParam, OUTPUT hManager).
    
    ASSIGN hManagerBuffer = hManager:DEFAULT-BUFFER-HANDLE.
    
    CREATE QUERY hQuery.
    hQuery:ADD-BUFFER(hManagerBuffer).
    hQuery:QUERY-PREPARE("FOR EACH ":U + hManagerBuffer:NAME + " NO-LOCK ":U).
    hQuery:QUERY-OPEN() NO-ERROR.
    
    hQuery:get-first().
    do while hManagerBuffer:available:
        ASSIGN cFieldName   = hManagerBuffer:BUFFER-FIELD("cHandleName":U):BUFFER-VALUE
               cManagerList = cManagerList + CHR(3) 
                            + hManagerBuffer:BUFFER-FIELD("cManagerName":U):BUFFER-VALUE + chr(3)
                            + (if cFieldName eq '' or cFieldName eq 'Non' then 
                                    hManagerBuffer:BUFFER-FIELD("cManagerName":U):BUFFER-VALUE
                               else cFieldName).
        hQuery:get-next().
    END.    /* query manager names */
    hQuery:query-close().    
    delete object hQuery.
    
    RETURN left-trim(cManagerList, chr(3)).
END FUNCTION.    /* buildManagerList */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildOverlayWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildOverlayWidgets Procedure  PRIVATE
FUNCTION buildOverlayWidgets RETURNS LOGICAL PRIVATE
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Builds widgets used for overlaying the browse 'Value' column.
        Notes:
------------------------------------------------------------------------------*/
    DEFINE variable hWidget            as handle                no-undo.
    DEFINE variable hFrame             as handle                no-undo.
    DEFINE variable cListItems         as character             no-undo.
    
    {get ContainerHandle hFrame}.
        
    /* Action type combo */
    {get TypeCombo hWidget}.
    if not valid-handle(hWidget) then
    do:
        create combo-box hWidget
            assign frame = hFrame
                   name = 'coType'
                   sensitive = yes
                   visible = no
                   delimiter = chr(3)
                   sort = yes
            triggers:
                on value-changed persistent run changeComboValue in target-procedure (hWidget).
            end triggers.
        {set TypeCombo hWidget}.
        
        cListItems = 'Run' + chr(3) + 'RUN' + chr(3)
                   + 'Publish' + chr(3) + 'PUB'.
        hWidget:list-item-pairs = cListItems.
    end.    /* not type combo */
    
    /* Action target combo */
    {get TargetCombo hWidget}.
    if not valid-handle(hWidget) then
    do:
        create combo-box hWidget
            assign frame = hFrame
                   name = 'coTarget'
                   sensitive = yes
                   visible = no
                   delimiter = chr(3)
                   sort = yes
            triggers:
                on value-changed persistent run changeComboValue in target-procedure (hWidget).
            end triggers.
        {set TargetCombo hWidget}.
        
        cListItems = {fn buildManagerList}.
        cListItems = cListItems + chr(3)
                   + "Self" + chr(3) + 'SELF' + chr(3)
                   + "Container" + chr(3) + 'CONTAINER' + chr(3)
                   + "Anywhere" + chr(3) + "ANYWHERE".
        hWidget:list-item-pairs = cListItems.                   
    end.    /* not target combo */
    
    return true.
END FUNCTION.    /* buildOverlayWidgets */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyOverlayWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyOverlayWidgets Procedure 
FUNCTION destroyOverlayWidgets RETURNS LOGICAL PRIVATE
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:
------------------------------------------------------------------------------*/
    DEFINE variable hWidget            as handle                        no-undo.
    
    {get TypeCombo hWidget}.
    if valid-handle(hWidget) then
        delete object hWidget no-error.
    
    {get TargetCombo hWidget}.  
    if valid-handle(hWidget) then
        delete object hWidget no-error.
    
    hWidget = ?.
        
    return true.
END FUNCTION.    /* destroyOverlayWidgets */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTargetCombo Procedure 
FUNCTION getTargetCombo RETURNS HANDLE PRIVATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    find ttLocalContext where
         ttLocalContext.TargetProcedure = target-procedure and
         ttLocalContext.ContextName = 'TargetCombo' no-error.
    if available ttLocalContext then
        return widget-handle(ttLocalContext.ContextValue).
    else
        return ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTypeCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTypeCombo Procedure 
FUNCTION getTypeCombo RETURNS HANDLE PRIVATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    find ttLocalContext where 
         ttLocalContext.TargetProcedure = target-procedure and
         ttLocalContext.ContextName = 'TypeCombo' no-error.
    if available ttLocalContext then
        return widget-handle(ttLocalContext.ContextValue).
    else
        return ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideOverlayWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hideOverlayWidgets Procedure 
FUNCTION hideOverlayWidgets RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Hides overlay widgets.
    Notes:
------------------------------------------------------------------------------*/
    DEFINE variable hWidget        as handle                        no-undo.
    
    {get TypeCombo hWidget}.
    if valid-handle(hWidget) then
        hWidget:hidden = yes.

    {get TargetCombo hWidget}.
    if valid-handle(hWidget) then
        hWidget:hidden = yes.

    return true.
END FUNCTION.    /* hideOverlayWidgets */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTargetCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTargetCombo Procedure 
FUNCTION setTargetCombo RETURNS LOGICAL PRIVATE
  ( INPUT phTargetCombo AS HANDLE ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    find ttLocalContext where
         ttLocalContext.TargetProcedure = target-procedure and
         ttLocalContext.ContextName = 'TargetCombo' no-error.
    if not available ttLocalContext then
    do:
        create ttLocalContext.
        assign ttLocalContext.TargetProcedure = target-procedure
               ttLocalContext.ContextName = 'TargetCombo'.
    end.
    
    ttLocalContext.ContextValue = string(phTargetCombo).
    
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTypeCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTypeCombo Procedure 
FUNCTION setTypeCombo RETURNS LOGICAL PRIVATE
  ( INPUT phTypeCombo AS HANDLE ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    find ttLocalContext where
             ttLocalContext.TargetProcedure = target-procedure and
         ttLocalContext.ContextName = 'TypeCombo' no-error.
    if not available ttLocalContext then
    do:
        create ttLocalContext.
        assign ttLocalContext.TargetProcedure = target-procedure
               ttLocalContext.ContextName = 'TypeCombo'.
    end.
    
    ttLocalContext.ContextValue = string(phTypeCombo).
    
    return true.    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

