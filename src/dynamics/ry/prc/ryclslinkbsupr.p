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
  File: ryclslinkbsupr.p

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

&scop object-name       ryclslinkbsupr.p
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

&IF DEFINED(EXCLUDE-adjustAttributeLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD adjustAttributeLinks Procedure 
FUNCTION adjustAttributeLinks RETURNS LOGICAL PRIVATE
    ( INPUT pcAction    AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildOverlayWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildOverlayWidgets Procedure 
FUNCTION buildOverlayWidgets RETURNS LOGICAL
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

&IF DEFINED(EXCLUDE-disableLabelColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD disableLabelColumn Procedure 
FUNCTION disableLabelColumn RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableLabelColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD enableLabelColumn Procedure 
FUNCTION enableLabelColumn RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkNameLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLinkNameLookup Procedure 
FUNCTION getLinkNameLookup RETURNS HANDLE PRIVATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkSdo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLinkSdo Procedure 
FUNCTION getLinkSdo RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLinkNameLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLinkNameLookup Procedure 
FUNCTION setLinkNameLookup RETURNS LOGICAL PRIVATE
  ( INPUT phLinkNameLookup AS HANDLE )  FORWARD.

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

&IF DEFINED(EXCLUDE-addRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord Procedure 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable hLookup            as handle                        no-undo.
        
    {fn enableLabelColumn}.
    
    run super.
    
    return.
END PROCEDURE.    /* addRecord */

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
    
    {fn disableLabelColumn}.
    
    return.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeColumnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeColumnValue Procedure 
PROCEDURE changeColumnValue :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PROTECTED
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable hSdo             as handle                        no-undo.
    DEFINE variable hColumn          as handle                        no-undo.
    DEFINE variable hOverlayWidget   as handle                        no-undo.
    DEFINE variable hFrame           as handle                        no-undo.
    DEFINE variable hBrowse          as handle                        no-undo.
    DEFINE variable cAttributeList   as character                     no-undo.
    DEFINE variable cDataTargets     as character                     no-undo.
    DEFINE variable iLoop            as integer                       no-undo.
    DEFINE variable lRowAvailable    as logical                       no-undo.
    
    {get LinkSdo hSdo}.
    {get ContainerHandle hFrame}.
    {get BrowseHandle hBrowse}.
    hColumn = {fnarg widgetHandle 'LinkName'}.
        
    /* if we try to do thi for blanks, we'll get everything. */
    if hColumn:SCREEN-VALUE eq '' or hColumn:SCREEN-VALUE eq ? then
        return.
    
    /* build the sdo query to find the relevant objects */
    {set QueryWhere '' hSdo}.
    if index(hColumn:screen-value, '*') eq 0 then 
        dynamic-function('assignQuerySelection':U IN hSdo,
                         'link_name':U, hColumn:SCREEN-VALUE,'Begins':U).   
    else
        dynamic-function('assignQuerySelection':U IN hSdo,
                         'link_name':U, hColumn:SCREEN-VALUE,'Matches':U).
    {fn openQuery hSdo}.
    
    /* get all matching attributes 
       and put them into the lookup list 
     */
    run fetchFirst in hSdo.
    lRowAvailable = {fnarg rowAvailable 'Current' hSdo}.
    
    /* allow a new attribute to be added */        
    do while lRowAvailable:
        cAttributeList = cAttributeList + chr(3)
                       + {fnarg columnValue 'link_name' hSdo}.
        
        lRowAvailable = {fnarg rowAvailable 'Next' hSdo}.
        if lRowAvailable then
            run fetchNext in hSdo.
    end.    /* row available true. */
    cAttributeList = left-trim(cAttributeList, chr(3)).
    
    {set QueryWhere '' hSdo}.
    if index(hColumn:screen-value, '*') eq 0 then 
        dynamic-function('removeQuerySelection':U IN hSdo,
                         'link_name':U, 'Begins':U).
    else
        dynamic-function('removeQuerySelection':U IN hSdo,
                         'link_name':U, 'Matches':U).
    
    {get LinkNameLookup hOverlayWidget}.
    if valid-handle(hOverlayWidget) then
    do:
        assign hOverlayWidget:HEIGHT = MAX(1,MIN(6,INT(NUM-ENTRIES(cAttributeList,CHR(3)) / 2 ) ))
               hOverlayWidget:WIDTH-Pixels = hColumn:WIDTH-Pixels + 6
               hOverlayWidget:Y = (IF hColumn:Y + hBrowse:Y + hColumn:HEIGHT-PIXELS + hOverlayWidget:HEIGHT-Pixels lt hFrame:HEIGHT-Pixels 
                                  THEN hColumn:Y + hBrowse:Y + hColumn:HEIGHT-PIXELS 
                                  ELSE hColumn:Y + hBrowse:Y - hOverlayWidget:HEIGHT-Pixels)
               hOverlayWidget:X = hColumn:X + hBrowse:X - 2
               no-error.
        hOverlayWidget:MOVE-TO-TOP().
        
        assign hOverlayWidget:DELIMITER = CHR(3)
               hOverlayWidget:LIST-ITEMS = cAttributeList.
        
        assign hOverlayWidget:hidden = no
               hOverlayWidget:SCREEN-VALUE = hColumn:SCREEN-VALUE
               no-error.
    end.    /* lookup value has value */
    
    return.
END PROCEDURE.    /* changeColumnValue */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord Procedure 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE variable hLookup            as handle                     no-undo.

    {fn enableLabelColumn}.
    
    run super.
    
    return.
END PROCEDURE.    /* copyRecord */

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
    
    DEFINE variable hSdo                     as handle                    no-undo.
    DEFINE variable cLinkName                as character                 no-undo.
    DEFINE variable cMode                    as character                 no-undo.

    run super (pcRelative).
    
    /* force the child (link type) data object to
       repository correctly. the child data doesn't 
       update correctly because there are no foreign fields
       available.
     */ 
    cLinkName = {fnarg widgetValue 'LinkName'}.
    
    {get LinkSdo hSdo}.
    if valid-handle(hSdo) then
        dynamic-function('findRowWhere' in hSdo, 'link_name', cLinkName, '=').
        
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
    {get TableioSource hToolbar}
    {get DataSource hDataSource}.
    &undefine xp-assign
    
    /* if the where stored is not the current class and 
       not the custom class then disallow deleted.       
     */         
    publish "findCustomizingClass" from hContainer (output cValidClasses).     
        
    assign cValidClasses = cValidClasses + ',' + {fnarg columnValue 'ClassName' hDataSource}
           cValidClasses = left-trim(cValidClasses, ',')
           cWhereStored = {fnarg columnValue 'WhereStored' hDataSource}.
    
    if not can-do(cValidClasses, cWhereStored) then
        RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'af' '40' '?' '?'
                                                      "'Only supported links stored at one of these classes:' + cValidClasses + ' can be deleted.'" },
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
    DEFINE variable hLinkNameLookup         as handle                    no-undo.
    
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
    DEFINE variable hLinkNameLookup        as handle                 no-undo.
    
    {get LinkNameLookup hLinkNameLookup}.
    if valid-handle(hLinkNameLookup) then
        hLinkNameLookup:hidden = yes.
    
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
    DEFINE variable hColumn            as handle                     no-undo.
    
    {fn buildOverlayWidgets}.
    
    run super.
    
    hColumn = {fnarg widgetHandle 'LinkName'}.
    on value-changed of hColumn persistent run changeColumnValue in target-procedure.
    on leave of hColumn persistent run selectLinkName in target-procedure.
    
    return.
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

&IF DEFINED(EXCLUDE-selectLinkName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectLinkName Procedure 
PROCEDURE selectLinkName :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:     Event procedure when an attribute is selected from the list of
               attributes presented.
  Parameters:  <None>
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE variable hColumn                  as handle                 no-undo.
    DEFINE variable hLinkNameLookup          as handle                 no-undo.
    
    /* Since the selection list is emulating a combo-box, only apply change when the
     * user either clicks on an item on presses enter. Not when using cursor.
     */
    {get LinkNameLookup hLinkNameLookup}.
    assign hColumn = {fnarg widgetHandle 'LinkName'}
           hColumn:SCREEN-VALUE = hLinkNameLookup:SCREEN-VALUE
           hLinkNameLookup:hidden = yes
           NO-ERROR.
    
    /* move on ... */
    hColumn = {fnarg widgetHandle 'IsLinkSource'}.
    apply 'Entry' to hColumn.
    
    return.
END PROCEDURE.    /* selectLinkName */

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
    DEFINE variable cLinkName           as character                    no-undo.
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
    
    /* The link name is used for a couple of things,
       so get it first.
     */
    cLinkName = {fnarg widgetValue 'LinkName'}.
    
    /* Make sure that a duplicate record is not being created.
       Obviously only do this in Add or Copy mode.
     */
    if {fn getNewRecord} ne 'no' then
    do:
        /* Search the rowobject buffer using a named buffer so as not 
	       to disturb the SDO's query (which findRowWhere() will do) since
	       that will cause the browser to reposition.	*/
        create buffer hROBuf for table hRowObjectBuffer buffer-name 'lbRO':u.
        
        hROBuf:find-first(' where ':u + hROBuf:name + '.LinkName = ':u + quoter(cLinkName)) no-error.
        lDup = hROBuf:available. 
        delete object hROBuf no-error.
        hROBuf = ?.
        
        if lDup then
        do:
            if valid-handle(gshSessionManager) then
                RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'AF' '40' '?' '?'
	                                                           "'An link called ' + cLinkName + ' already exists for this class'"},
	                                                   INPUT  "ERR", /* error type */
	                                                   INPUT  "&OK", /* button list */
	                                                   INPUT  "&OK", /* default button */ 
	                                                   INPUT  "&OK", /* cancel button */
	                                                   INPUT  "Duplicate link ~'" + cLinkName + "~'", /* window title */
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
            RUN getProfileData IN gshProfileManager (INPUT        "General":U,
                                                     INPUT        "UpdCustCls":U,
                                                     INPUT        "UpdCustCls":U,
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
    
    if return-value eq 'adm-error' then
        run resetRecord in target-procedure.
    else
    /* If the save event fails, don't kill off the updateable field.
     */
    do:
        /* we only need the label column enabled for adds and copies. */
        {fn disableLabelColumn}.
        
        /* Clear the client cache */
        run destroyClassCache in gshRepositoryManager.
        
        /* force the class data (and thus child data) to refresh. */
        run refreshRow in hClassDataSource.
        
        /* reposition */
        dynamic-function('findRowWhere' in hDataSource, 'LinkName', cLinkName, '=').
    end.    /* no error */
    
    error-status:error = no.
    return.
END PROCEDURE.    /* updateRecord */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-adjustAttributeLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION adjustAttributeLinks Procedure 
FUNCTION adjustAttributeLinks RETURNS LOGICAL PRIVATE
    ( INPUT pcAction    AS CHARACTER ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose: Remove or add the data links from the attribute sdo to 
           its visual object so that the UI behaves corectly.
    Notes:
------------------------------------------------------------------------------*/
    DEFINE variable hSdo            as handle                        no-undo.
    DEFINE variable iLoop           as integer                       no-undo.
    DEFINE variable cDataTargets    as character                     no-undo.
    
    {get LinkSdo hSdo}.
    {get DataTarget cDataTargets hSdo}.
    
    do iLoop = 1 to num-entries(cDataTargets):     
        dynamic-function('changeLinkState' in widget-handle(entry(iLoop, cDataTargets)),
                         pcAction, 'DataSource', hSdo).
    end.    /* loop through data targets */
    
    return true.
END FUNCTION.    /* adjustAttributeLinks */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildOverlayWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildOverlayWidgets Procedure 
FUNCTION buildOverlayWidgets RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Builds widgets used for overlaying the browse 'Link Name' column.
        Notes:
------------------------------------------------------------------------------*/
    DEFINE variable hWidget            as handle                no-undo.
    DEFINE variable hFrame             as handle                no-undo.
    
    {get ContainerHandle hFrame}.
        
    /* Link name list 
     */
    {get LinkNameLookup hWidget}.
    if not valid-handle(hWidget) then
    do:
        create selection-list hWidget
            assign name = "seselectLinkName"
                   frame = hFrame
                   multiple = no
                   scrollbar-vertical = yes
                   height-chars = 2.05
                   width-chars = 24
                   font = 3
                   sensitive = yes
                   visible = no
            triggers:
                on value-changed persistent run selectLinkName in target-procedure.
                on leave persistent run selectLinkName in target-procedure.
                on default-action persistent run selectLinkName in target-procedure.
            end triggers.
        {set LinkNameLookup hWidget}.
    end.    /* not valid sel list */

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
    
    {get LinkNameLookup hWidget}.          
    if valid-handle(hWidget) then
        delete object hWidget no-error.
    
    hWidget = ?.
        
    return true.
END FUNCTION.    /* destroyOverlayWidgets */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableLabelColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION disableLabelColumn Procedure 
FUNCTION disableLabelColumn RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Disables the 'Link Name' column.  
    Notes:  * this function disabled the column in the UI and also removes
              the column from the EnabledFields list
            * it also makes sure that the lik name lookup is hidden.
------------------------------------------------------------------------------*/
    DEFINE variable hLinkNameLookup            as handle                no-undo.
    
    {fnarg disableWidget 'LinkName'}.
    run modifyListProperty in target-procedure
        (target-procedure, 'Remove', 'EnabledFields', 'LinkName').
    
    {fnarg adjustAttributeLinks 'Active'}.
    
    {get LinkNameLookup hLinkNameLookup}.
    hLinkNameLookup:hidden = yes.
    
    return true.        
END FUNCTION.    /* disableLabelColumn */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableLabelColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION enableLabelColumn Procedure 
FUNCTION enableLabelColumn RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Enables the 'Link Name' column.  
    Notes:  * this function enables the column in the UI and also adds
                  the column to the EnabledFields list
------------------------------------------------------------------------------*/    
    {fnarg enableWidget 'LinkName'}.
    run modifyListProperty in target-procedure
        (target-procedure, 'Add', 'EnabledFields', 'LinkName').
    
    {fnarg adjustAttributeLinks 'Inactive'}.
    
    return true.
END FUNCTION.    /* enableLabelColumn */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkNameLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLinkNameLookup Procedure 
FUNCTION getLinkNameLookup RETURNS HANDLE PRIVATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    find ttLocalContext where
         ttLocalContext.TargetProcedure = target-procedure and
         ttLocalContext.ContextName = 'LinkNameLookup' no-error.
    if available ttLocalContext then
        return widget-handle(ttLocalContext.ContextValue).
    else
        return ?.
END FUNCTION.    /* getLinkNameLookup */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkSdo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLinkSdo Procedure 
FUNCTION getLinkSdo RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PROTECTED
  Purpose:  Returns the handle of the associated link SDO.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE variable hDataSource                as handle                no-undo.
    DEFINE variable hSdo                       as handle                no-undo.
    DEFINE variable cDataTargets               as character             no-undo.
    DEFINE variable iLoop                      as integer               no-undo.
    DEFINE variable lQueryObject               as logical               no-undo.
    
    find ttLocalContext where
         ttLocalContext.TargetProcedure = target-procedure and
         ttLocalContext.ContextName = 'LinkSdo' no-error.
    if available ttLocalContext then
        return widget-handle(ttLocalContext.ContextValue).
    else
    do:
        {get DataSource hDataSource}.
        {get DataTarget cDataTargets hDataSource}.
        
        do iLoop = 1 to num-entries(cDataTargets):
            hSdo = widget-handle(entry(iLoop, cDataTargets)).
            if valid-handle(hSdo) then
            do:
                {get QueryObject lQueryObject hSdo}.
                if lQueryObject then
                    leave.
                else
                    hSdo = ?.
            end.    /* valid sdo */
        end.    /* loop through data targets */
                
        /* create in context so we don't have to go through
           the whole rigmarole next time.
         */
        create ttLocalContext.
        assign ttLocalContext.TargetProcedure = target-procedure
               ttLocalContext.ContextName = 'LinkSdo'
               ttLocalContext.ContextValue = string(hSdo).
        
        return hSdo.
    end.    /* n/a LinkSdo */
END FUNCTION.    /* getLinkSdo */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLinkNameLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLinkNameLookup Procedure 
FUNCTION setLinkNameLookup RETURNS LOGICAL PRIVATE
  ( INPUT phLinkNameLookup AS HANDLE ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    find ttLocalContext where 
         ttLocalContext.TargetProcedure = target-procedure and
         ttLocalContext.ContextName = 'LinkNameLookup' no-error.
    if not available ttLocalContext then
    do:
        create ttLocalContext.
        assign ttLocalContext.TargetProcedure = target-procedure
               ttLocalContext.ContextName = 'LinkNameLookup'.
    end.
    
    ttLocalContext.ContextValue = string(phLinkNameLookup).    

    RETURN true.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

