##Include:[StandardHeaderComment]##

&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
##If:[GenerateThinRendering]##
/* ThinRendering Enabled */
&GLOBAL-DEFINE ADM-EXCLUDE-PROTOTYPES
&GLOBAL-DEFINE ADM-EXCLUDE-STATIC
&SCOPED-DEFINE exclude-start-super-proc
/* ThinRendering */
##If:End##

&scoped-define adm-prepare-static-object yes
&scoped-define adm-prepare-class-name ##[ClassName]##
##If:generateSuperInConstructor()##
&scoped-define adm-prepare-super-procedure ##[ObjectSuperProcedure]##
&scoped-define adm-prepare-super-procedure-mode ##[ObjectSuperProcedureMode]##
##If:End##

/* tell smart.i that we can use the default destroyObject */ 
&SCOPED-DEFINE include-destroyobject

/* The displayObjects procedure is contained in datavis.i and
   displays the initial values for non-database widgets when the
   viewer is first instantiated. This uses the {&DISPLAYED-OBJECTS}
   pre-processor.
   However, in a dynamic viewer, all of this information is contained
   in the Repository, and there is an displayObjects override in the
   viewer's rendering super (rydynviewp.p). We need to exclude the
   static behaviour completely.
 */
&SCOPED-DEFINE EXCLUDE-displayObjects

/* Astra 2 object identifying preprocessor */
&glob   astra2-dynamicviewer YES

&Scoped-define FRAME-NAME frMain
&Scoped-define ADM-CONTAINER-HANDLE frame {&Frame-Name}:handle
&scoped-define ADM-CONTAINER Frame

##Loop:ListContainerObjects##
define variable ##getInstanceHandleName([InstanceName])## as handle no-undo.    /* ##[InstanceName]## */
##Loop:End##


/* ************************  Frame Definitions  *********************** */
DEFINE FRAME frMain
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1
         SIZE ##[ObjectWidth]## BY ##[ObjectHeight]##.


/* *********************** Procedure Settings ************************ */
/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

&scoped-define xp-Assign
{set ContainerType '{&ADM-CONTAINER}'}
{set ObjectType 'SmartDataViewer'}.
&undefine xp-Assign

/* ***********  Runtime Attributes and AppBuilder Settings  *********** */
FRAME {&Frame-Name}:HIDDEN = TRUE.

/* **********************  Internal Procedures  *********************** */
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     Resize procedure.
  Parameters:  pdHeight -
               pcWidth  -
  Notes:       * This procedure is here because resizeObject is not part of the ADM
                 procedures and is thus not 'visible' from the INTERNAL-ENTRIES
                 attribute. This API is needed so that resizing will happen for 
                 dynamic viewers.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdHeight             AS DECIMAL              NO-UNDO.
    DEFINE INPUT PARAMETER pdWidth              AS DECIMAL              NO-UNDO.
    
    /* We don't check for errors because there will be many cases where
     * there is no resizeObject for the viewer. In this case, simply ignore 
     * any errors.                                                         */
    RUN SUPER (INPUT pdHeight, INPUT pdWidth) NO-ERROR.
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* resizeObject */

procedure adm-create-objects :    
    define variable cProperties as character no-undo.
    ##If:[GenerateTranslations]##
    define variable cCurrentLanguage as character no-undo.
    define variable lTranslationEnabled as logical no-undo.
    define variable lViewerTranslated as logical no-undo initial no.
    ##If:End##    
    ##If:[GenerateSecurity]##
    define variable lSecurityEnabled as logical no-undo. 
    define variable hContainer as handle no-undo.
    define variable cContainerName as character no-undo.
    define variable cRunAttribute as character no-undo.
    ##If:End##
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
    
    {get CurrentPage iCurrentPage}.
    case iCurrentPage:
        when 0 then
        do:
            cProperties = dynamic-function('getPropertyList':U IN gshSessionManager,
                                           'TranslationEnabled,CurrentLanguageCode,SecurityEnabled',
                                           No).
            ##If:[GenerateTranslations]##
            assign cCurrentLanguage = entry(2, cProperties, chr(3))
                   lTranslationEnabled = logical(entry(1, cProperties, chr(3)))
                   no-error.
            if lTranslationEnabled eq ? then lTranslationEnabled = yes.
            ##If:End##    /* gen translations */
            ##If:[GenerateSecurity]##
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
            ##If:End##    /* generate security */
            
            hWidgetBuffer = {fn getWidgetTableBuffer}.                

            &scoped-define xp-Assign
            {get ShowPopup lShowPopup}
            {get KeepChildPositions lKeepChildPositions}
            {get PopupButtonsInFields lPopupButtonInField}
            {get HideOnInit lHideOnInit}
            .
            &undefine xp-Assign
            
            ##Loop:CreateViewerObjects##
            /* Create the instance in a separate call to avoide a-code segment limits */
            run adm-create-##getInstanceHandleName([InstanceName])##
                    ( input        lShowPopup,
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
                      input-output cFieldHandles    ).
            
            ##Loop:End##    /* createviewerobjects */            
            ##If:[GenerateTranslations]##
            if lTranslationEnabled and
               can-do(this-procedure:internal-entries, 'translate-' + cCurrentLanguage) then
            do:
                run value('translate-' + cCurrentLanguage).
                lViewerTranslated = yes.
            end.    /* translate viewer */
            ##If:End##
            
            /* Set the Enabled~ and DisplayedFields properties. */
            assign cAllFieldHandles   = left-trim(cAllFieldHandles, ',')
                   cAllFieldNames     = left-trim(cAllFieldNames, ',')                   
                   cFieldSecurity     = substring(cFieldSecurity, 2)
                   cDisplayedFields   = left-trim(cDisplayedFields, ',')
                   cFieldHandles      = left-trim(cFieldHandles, ',')
                   cEnabledFields     = left-trim(cEnabledFields, ',')
                   cEnabledHandles    = left-trim(cEnabledHandles, ',')
                   cEnabledObjFlds    = left-trim(cEnabledObjFlds, ',')
                   cEnabledObjHdls    = left-trim(cEnabledObjHdls, ',')
                   cFieldPopupMapping = left-trim(cFieldPopupMapping, ',').
                        
            &SCOPED-DEFINE xp-Assign
            {set AllFieldHandles cAllFieldHandles}
            {set AllFieldNames cAllFieldNames}
            {set FieldSecurity cFieldSecurity}
            {set ObjectSecured ##[GenerateSecurity]##}
            {set DisplayedFields cDisplayedFields}
            {set FieldHandles cFieldHandles}
            {set EnabledFields cEnabledFields}
            {set EnabledHandles cEnabledHandles}
            {set EnabledObjFlds cEnabledObjFlds}
            {set EnabledObjHdls cEnabledObjHdls}
            {set FieldPopupMapping cFieldPopupMapping}
            /* Ensure that the viewer is disabled if it is an update-target without tableio-source (? will enable ) */
            {set SaveSource NO}. 
            &UNDEFINE xp-assign
            
            /* If there *are* no enabled fields, don't let the viewer be an Update-Source or TableIO-Target.
               NOTE: This in principle belongs in datavis.i because it's generic but EnabledFields has just been set.
             */
            if cEnabledFields eq '' then
            do:
                run modifyListProperty in target-procedure (target-procedure, "REMOVE", "SupportedLinks", "Update-Source").
                run modifyListProperty in target-procedure (target-procedure, "REMOVE", "SupportedLinks", "TableIO-Target").
            end.
            else
                /* If there are EnabledFields, set the Editable Property to true.
                 * This is because the 'Add', 'Update' and 'Copy' actions require 
                 * this property to be set as part of their ENABLE_RULEs.
                 * This property is usually determined by reading the EnabledFields
                 * property, but because we are only setting this property here, as
                 * opposed to when the viewer is RUN, we need to explicitly set the
                 * Editable property to true.                                      */
                {set Editable YES}.
                
            ##If:[GenerateTranslations]##
            /* If translation was done - then we need to check if we need to adjust any 
               columns for larger labels. However, only do this if allowed to by the KeepChildPositions
               attribute.
             */
            if not lKeepChildPositions and lViewerTranslated then
                run repositionWidgetForTranslation in target-procedure (input-output dFrameWidth).
            ##If:End##   /* gen translations */

            /* get the MinWidth and MinHeight attributes. */
            &SCOPED-DEFINE xp-assign
            {get MinHeight dFrameMinHeight}
            {get MinWidth  dFrameMinWidth}.
            &UNDEFINE xp-assign
            
            if dFrameWidth lt 10 then dFrameWidth = 10.
            
            /* Set the frame width */
            if dFrameHeight gt dFrameMinHeight or dFrameWidth gt dFrameMinWidth then
            do:   
                /* Update the Frame MinWidth and Frame MinHeight.
                   We don't particularly care of there are errors
                   here, since we can update the records at a later
                   stage.
                 */
                if dFrameHeight ne dFrameMinHeight then
                    {set MinHeight dFrameHeight}.
                
                if dFrameWidth ne dFrameMinWidth then
                    {set MinWidth dFrameWidth}.
                
                assign frame {&Frame-Name}:SCROLLABLE     = YES
                       frame {&Frame-Name}:WIDTH          = dFrameWidth
                       frame {&Frame-Name}:HEIGHT         = dFrameHeight           
                       frame {&Frame-Name}:VIRTUAL-WIDTH  = frame {&Frame-Name}:width-chars
                       frame {&Frame-Name}:VIRTUAL-HEIGHT = frame {&Frame-Name}:height-chars
                       frame {&Frame-Name}:SCROLLABLE     = NO.
            end.    /* frame got bigger */
            else
            do:
                frame {&Frame-Name}:scrollable = yes.
                
                /* If we get here, we know minWidth and minHeight were greater than the calculated width and height. *
                 * Set the frame width */
                IF dFrameMinWidth < frame {&Frame-Name}:WIDTH-CHARS THEN
                    ASSIGN frame {&Frame-Name}:WIDTH-CHARS          = dFrameMinWidth
                           frame {&Frame-Name}:VIRTUAL-WIDTH-CHARS  = frame {&Frame-Name}:WIDTH-CHARS.
                ELSE
                    ASSIGN frame {&Frame-Name}:VIRTUAL-WIDTH-CHARS  = dFrameMinWidth
                           frame {&Frame-Name}:WIDTH-CHARS          = frame {&Frame-Name}:VIRTUAL-WIDTH-CHARS.
                        
                /* Set the frame height */
                IF dFrameMinHeight < frame {&Frame-Name}:HEIGHT-CHARS THEN
                    ASSIGN frame {&Frame-Name}:HEIGHT-CHARS         = dFrameMinHeight
                           frame {&Frame-Name}:VIRTUAL-HEIGHT-CHARS = frame {&Frame-Name}:HEIGHT-CHARS.
                ELSE
                    ASSIGN frame {&Frame-Name}:VIRTUAL-HEIGHT-CHARS = dFrameMinHeight
                           frame {&Frame-Name}:HEIGHT-CHARS         = frame {&Frame-Name}:VIRTUAL-HEIGHT-CHARS.
                            
                frame {&Frame-Name}:scrollable = no no-error.
            end.    /* frame is smaller than min size. */            
        end.    /* page 0 */
    end case.    /* current page */
    
    error-status:error = no.
    return.
end procedure.    /* adm-create-objects */

##Loop:createViewerWidgets##
        
procedure adm-create-##getInstanceHandleName([InstanceName])## :
    /* Creates instance ##[InstanceName]## */
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
    
    ##If:[InstanceIsWidget]##
    define variable iFont                as integer                      no-undo.
    define variable iLabelWidthPixels    as integer                      no-undo.
    define variable dLabelMinHeight      as decimal                      no-undo.
    define variable hLabel               as handle                       no-undo.
    define variable hPopup               as handle                       no-undo.
    ##If:End##    /* instance is widget */
    ##If:[GenerateSecurity]##
    define variable iPos as integer no-undo.
    ##If:End##    
    define variable lVisible as logical no-undo.
    define variable cSecurityAction as character no-undo.
    define variable dWidgetWidth as decimal no-undo.
    define variable dWidgetHeight as decimal no-undo.
    
    lVisible = ##[InstanceVisible]##.
    /* All widgets default to being visible */
    if lVisible eq ? then lVisible = yes.
    
    ##If:[InstanceIsSDF]##
    {fnarg setCurrentLogicalName '##[InstanceObjectName]##'}.
    RUN constructObject IN TARGET-PROCEDURE (INPUT  '##[InstanceRenderingProcedure]##',
                                             INPUT  frame {&Frame-Name}:handle,
                                             INPUT  ##[InstanceInstanceProperties]##,
                                             OUTPUT ##getInstanceHandleName([InstanceName])##).
    &scoped-define xp-Assign
    {set LogicalObjectName '##[InstanceObjectName]##' ##getInstanceHandleName([InstanceName])##}
    ##Loop:InstanceProperties-Assign##
    {set ##[PropertyName]## ##[PropertyValue]## ##getInstanceHandleName([InstanceName])##}
    ##Exclude:##
    /* Break up the assign statement every 50 properties or so,
       since they all make up one assign statement. */
    ##Exclude:End##    
    ##Every:50##
    .
    &undefine xp-Assign
    &scoped-define xp-Assign
    ##Every:End##    
    ##Loop:End##
    .
    &undefine xp-Assign
        
    /* Keep forced 'Set' properties separate. */
    &scoped-define xp-Assign
    ##Loop:InstanceProperties-Set##
    {set ##[PropertyName]## ##[PropertyValue]## ##getInstanceHandleName([InstanceName])##}
    ##Loop:End##
    .
    &undefine xp-Assign                                             
            
    RUN repositionObject IN ##getInstanceHandleName([InstanceName])## (##[InstanceRow]##, ##[InstanceColumn]##) NO-ERROR.
    RUN resizeObject     IN ##getInstanceHandleName([InstanceName])## (##[InstanceHeight]##, ##[InstanceWidth]##) NO-ERROR.
    {fnarg setCurrentLogicalName ''}.
    &scoped-define xp-assign 
    {get Width dWidgetWidth ##getInstanceHandleName([InstanceName])##}
    {get Height dWidgetHeight ##getInstanceHandleName([InstanceName])##}
    .
    &undefine xp-assign     
    
    ##If:instanceIsVisual([InstanceClass])##
    /* If this is not a generated object, then make sure it will be secured and translated.
       the retrieval will have set the ObjectTranslated and ObjectSecured flags correctly,
       but the translations will not have been applied correctly in all cases.
     */
    if not can-do(##getInstanceHandleName([InstanceName])##:internal-entries, 'adm-assignObjectProperties') then
    do:
        &scoped-define xp-Assign
        {set ObjectTranslated no ##getInstanceHandleName([InstanceName])##}
        {set ObjectSecured no ##getInstanceHandleName([InstanceName])##}.
        &undefine xp-Assign
    end.    /* not a generated object */            
    ##If:End##    /* instance is Visual */            
    ##If:End##     /* instance is sdf */
    
    ##If:[GenerateSecurity]##
    /* Apply security */
    iPos = lookup('##[InstanceName]##', pcSecuredFields).
    if iPos gt 0 then
    do:
        cSecurityAction = entry(iPos + 1, pcSecuredFields).
        if cSecurityAction eq 'Hidden' then
            lVisible = no.
    end.    /* field security found */
    ##If:[InstanceIsWidget]##
    else
    /* if no field security, check for token security. */
    do:
        iPos = lookup('##[InstanceName]##', pcSecuredTokens).
	    if iPos ne 0 then
	        cSecurityAction = 'ReadOnly'.
    end.    /* token security */
    ##If:End##    /* instance is widget */    
    ##If:End##    /* generate security */
    
    ##If:[InstanceIsWidget]##
    create ##[InstanceType]## ##getInstanceHandleName([InstanceName])##
        assign frame = frame {&Frame-Name}:handle
               name = '##[InstanceName]##'
               ##If:[InstanceIsLongChar]##
               /* When using a LongChar, the LARGE attribute must be set to
                  true BEFORE setting the DataType, else message 11212 
                  results. */
               large = yes
               ##If:End##    /* LongChar data type */
               ##If:widgetCanSetDataType([InstanceType])##
               data-type = '##[InstanceDataType]##'
               ##If:End##    /* can-set data type */
        triggers:
        ##Loop:ViewerInstanceEvents##
            on ##[EventName]## persistent run processEventProcedure in target-procedure ( input ##[EventActionType]##,
                                                                                          input ##[EventEventAction]##,
                                                                                          input ##[EventActionTarget]##,
                                                                                          input ##[EventEventParameter]## ).
        ##Loop:End##    /* ViewerInstanceEvents */
        end triggers.
    /* CAN-SET() is performed by the generation, so
       all the attributes here can be set.
       
       Format is explicitly set in this ASSIGN so as to use 
       the NO-ERROR on the end.
     */
    assign
    ##If:widgetCanSetFormat([InstanceType])##
    ##getInstanceHandleName([InstanceName])##:format = ##[InstanceFormat]##
    ##If:End##    /* can-set data type */
    ##Loop:createWidgetAttributes##
    ##getInstanceHandleName([InstanceName])##:##[InstanceAttributeName]## = ##[InstanceAttributeValue]##
    ##Loop:End##
    no-error.
    
    ##If:[WidgetHasLabel]##
    ##If:[WidgetLabelSide]##
    iFont = ##[InstanceLabelFont]##.
    iLabelWidthPixels = font-table:get-text-width-pixels('##[InstanceLabel]##', iFont) + 3.
    dLabelMinHeight = if ##getInstanceHandleName([InstanceName])##:height-chars ge 1 then 1 else font-table:get-text-height(iFont).
    
    if iLabelWidthPixels gt 0 then
    do:
        create text hLabel
            assign frame = frame {&Frame-Name}:handle
                   format = 'x(' + string(length('##[InstanceLabel]##', 'Column') + 1) + ')'
                   height-chars = min(##getInstanceHandleName([InstanceName])##:height-chars, dLabelMinHeight)
                   name = 'Label_##getInstanceHandleName([InstanceName])##'
                   tab-stop = no    /* labels don't belong in the tab order */
                   row = ##getInstanceHandleName([InstanceName])##:row
                   screen-value = '##[InstanceLabel]##'
                   width-pixels = iLabelWidthPixels.
        if ##getInstanceHandleName([InstanceName])##:x - hLabel:width-pixels gt 0 then
            hLabel:x = ##getInstanceHandleName([InstanceName])##:x - hLabel:width-pixels.
        else
            hLabel:x = 1.
            
        assign hLabel:font = ##[InstanceLabelFont]## WHEN '##[InstanceLabelFont]##' NE '?'
               hLabel:fgcolor = ##[InstanceLabelFgColor]## WHEN '##[InstanceLabelFgColor]##' NE '?'
               hLabel:bgcolor = ##[InstanceLabelBgColor]## WHEN '##[InstanceLabelbgColor]##' NE '?'
               ##getInstanceHandleName([InstanceName])##:side-label-handle = hLabel.
    end.    /* there is a side-label-handle */
    ##If:End##
    ##If:[WidgetLabelNotSide]##
    assign ##getInstanceHandleName([InstanceName])##:label = '##[InstanceLabel]##'
           ##getInstanceHandleName([InstanceName])##:width-chars = ##[InstanceLabelWidth]##.
    ##If:End##    /* not side-label */
    ##If:End##    /* WidgetHasLabel */
                            
    ##If:[ShowWidgetPopup]##
    /* Create a popup button for pop-up calendar or calculator */
    if plShowPopup and lVisible then
    do:
        create button hPopup
            assign frame = frame {&Frame-Name}:handle
                   no-focus = yes
                   width-pixels = 15
                   label = '...'
                   private-data = 'Popup'
                   height-pixels = ##getInstanceHandleName([InstanceName])##:height-pixels - 4
                   y = ##getInstanceHandleName([InstanceName])##:y + 2
                   hidden = false
            triggers:
                on choose persistent run runLookup in gshSessionManager (##getInstanceHandleName([InstanceName])##).
            end triggers.
        
        /* The lookup widget should be placed outside of the fill-in */
        if not plPopupButtonInField then
            assign hPopup:x = ##getInstanceHandleName([InstanceName])##:x + ##getInstanceHandleName([InstanceName])##:width-pixels - 2
                   ##getInstanceHandleName([InstanceName])##:width-pixels = ##getInstanceHandleName([InstanceName])##:width-pixels + 15
                    /* Make sure the calced frame width is correct */
                   pdFrameWidth = max(pdFrameWidth, ##[InstanceColumn]## + ##[InstanceWidth]## + hPopup:WIDTH-CHARS)
                   no-error.
        else
            assign hPopup:x = (##getInstanceHandleName([InstanceName])##:x + ##getInstanceHandleName([InstanceName])##:width-pixels) - 17
                   no-error.
        
        hPopup:move-to-top().
        
        /* Add F4 trigger to widget */
        on F4 of ##getInstanceHandleName([InstanceName])## persistent run runLookup in gshSessionManager (##getInstanceHandleName([InstanceName])##).
    end.    /* viewer show popup */
    ##If:End##    /* show popup*/
        
    /* Always populate this list, even if no popups have been created.
       This is to prevent duplicates when widgetWalk runs. */
    pcFieldPopupMapping = pcFieldPopupMapping + ',':u
                        + string(##getInstanceHandleName([InstanceName])##) + ',':u
                        + (if hPopup eq ? then '?':u else string(hPopup)).
    
    ##If:[InstanceTextAndNotDisplay]##         
    /* Text widgets are usually meant to display one piece of data, and are not generally used for displaying data from an SDO.
	   It is however, possible to display data from an SDO in a text widget. In this case, the format and value is taken from the
       DataField. We know which fields these are because of the value of the DisplayField attribute.

	   The code below is only for those text widgets that are not going to display data from a data source (ie things like the 
       labels on rectangles) */
    ##getInstanceHandleName([InstanceName])##:screen-value = '##[InstanceInitialValue]##'.
    ##If:End##
    
    if ##getInstanceHandleName([InstanceName])##:type eq 'Editor' then
        ##getInstanceHandleName([InstanceName])##:read-only = yes.
        
    ##getInstanceHandleName([InstanceName])##:sensitive = (if ##getInstanceHandleName([InstanceName])##:type eq 'Editor' then yes else no).                            
    
    ##If:[InstanceLocalCanModify]##
    /* Modified is set to true by the 4GL after setting visible to true up above.  Modified is set
       to false for datafields when they are displayed.  When certain widgets that are not 
       dataobject-based are enabled, modified is set to false by the 4GL, for others it is not
       so we need to set it to false here. */
    if lVisible then
        ##getInstanceHandleName([InstanceName])##:modified = no.
    ##If:End##
    
    ##If:[WidgetHasImage])##
    /* Special handling for images. Load the image so that we can see it. */
    ##getInstanceHandleName([InstanceName])##:load-image(##[InstanceImageFile]##) no-error.
    ##If:End##    /* widget has image */
    
    /* If the field is to be made visible, then the label should be, too. However, we cannot set the
       VISIBLE attribute to YES without the viewer's frame's VISIBLE attribute also being set to YES
       by the 4GL.  This behaviour is not acceptable if the viewer's HideOnInit property is true.
       We also need to ensure that all hidden widgets are actually hidden, so we explicitly set
       their VISIBLE property to NO.                                                                 
     */
    if can-set(##getInstanceHandleName([InstanceName])##, 'Hidden') and
         (not plHideOnInit or lVisible eq no) then
        assign ##getInstanceHandleName([InstanceName])##:hidden = not lVisible
               ##getInstanceHandleName([InstanceName])##:side-label-handle:hidden = ##getInstanceHandleName([InstanceName])##:hidden
               no-error.
    
    dWidgetHeight = ##[InstanceHeight]##.
    dWidgetWidth = ##[InstanceWidth]##.
    ##If:End## /* instance is widget */
            
    /* Build lists of the fields to display and enable */
    assign pcFieldSecurity = pcFieldSecurity + ',' + cSecurityAction
    ##If:[InstanceDisplayAndNotLocal]##
           pcDisplayedFields = pcDisplayedFields + ',##[InstanceName]##'
           pcFieldHandles = pcFieldHandles + ',' + string(##getInstanceHandleName([InstanceName])##)
    ##If:End##    /* display and non-local */            
    ##If:[InstanceEnabled]##
           ##[EnabledNameList]## = ##[EnabledNameList]## + ',##[InstanceName]##'
           ##[EnabledHandleList]## = ##[EnabledHandleList]## + ',' + string(##getInstanceHandleName([InstanceName])##)
    ##If:End##    /* instance enabled */                
           pcAllFieldHandles = pcAllFieldHandles + ',' + string(##getInstanceHandleName([InstanceName])##).
           pcAllFieldNames = pcAllFieldNames + ',##[InstanceName]##'.
    
    assign pdFrameWidth = max(pdFrameWidth, ##[InstanceColumn]## + dWidgetWidth - 1)
           pdFrameHeight = max(pdFrameHeight, ##[InstanceRow]## + dWidgetHeight - 1).
    
    /* Create ttWidget records for repositioning after translation. */            
    phWidgetBuffer:buffer-create().
    assign phWidgetBuffer:buffer-field('tWidgetHandle'):buffer-value = ##getInstanceHandleName([InstanceName])##
           phWidgetBuffer:buffer-field('tTargetProcedure'):buffer-value = target-procedure
           phWidgetBuffer:buffer-field('tWidth'):buffer-value = ##[InstanceWidth]##
           phWidgetBuffer:buffer-field('tRow'):buffer-value = ##[InstanceRow]##
           phWidgetBuffer:buffer-field('tEndRow'):buffer-value = ##[InstanceRow]## + ##[InstanceHeight]##
           phWidgetBuffer:buffer-field('tColumn'):buffer-value = ##[InstanceColumn]##
           phWidgetBuffer:buffer-field('tRow'):buffer-value = ##[InstanceRow]##
           phWidgetBuffer:buffer-field('tWidgetType'):buffer-value = '##[InstanceType]##'
           phWidgetBuffer:buffer-field('tTabOrder'):buffer-value = ##[InstanceOrder]##
           phWidgetBuffer:buffer-field('tVisible'):buffer-value = lVisible
           phWidgetBuffer:buffer-field('tFont'):buffer-value = ##[InstanceFont]##
           phWidgetBuffer:buffer-field('tTableName'):buffer-value = '##[InstanceTableName]##'
           phWidgetBuffer:buffer-field('tInitialValue'):buffer-value = '##[InstanceInitialValue]##'.
    phWidgetBuffer:buffer-release().
    
    error-status:error = no.
    return.
end procedure.    /* adm-create-##getInstanceHandleName([InstanceName])## */
##Loop:End##    /* create viewer widgets */
    
##If:[GenerateTranslations]##
##Loop:translateViewer##
procedure translate-##[LanguageCode]##:
    define variable hWidgetBuffer as handle no-undo.
    define variable hLabel as handle no-undo.
    define variable iFont as integer no-undo.
    define variable iLabelWidthPixels as integer no-undo.
    define variable dLabelMinHeight as decimal no-undo.
    define variable cLabel as character no-undo.
    define variable lKeepChildPositions as logical no-undo.
    
    hWidgetBuffer = {fn getWidgetTableBuffer}.
    {get KeepChildPositions lKeepChildPositions}.
    
    ##Loop:translateViewerItem##
    /* Translation for ##[InstanceName]## */
    hWidgetBuffer:find-first('where ' + hWidgetBuffer:name
                             + '.tWidgetHandle = widget-handle(' + quoter(##getInstanceHandleName([InstanceName])##) + ')').
    hWidgetBuffer:buffer-field('tTranslated'):buffer-value = yes.
    cLabel= '##[TranslatedLabel]##'.
    ##If:[InstanceIsSdf]##
    ##If:[InstanceLabelTranslated]##
    ##Exclude:##
    /* Use a dyn-function here instead of {set} since it makes dealing with quotes way way easier. */
    ##Exclude:End##
    dynamic-function('set##[LabelAttribute]##' in ##getInstanceHandleName([InstanceName])##, cLabel).
    ##If:End##    /* label translated */
    ##If:[InstanceTooltipTranslated]##
    {set ##[TooltipAttribute]## ##[TranslatedTooltip]## ##getInstanceHandleName([InstanceName])##}.
    ##If:End##    /* tooltip translated */
    ##If:End##    /* instance is sdf */
    ##If:[InstanceIsWidget]##
    ##If:[InstanceLabelTranslated]##
    iFont = ##getInstanceHandleName([InstanceName])##:Font.
    if can-set(##getInstanceHandleName([InstanceName])##, 'Side-Label-Handle') then
    do:
        assign cLabel = cLabel + ':':u
               hLabel = ##getInstanceHandleName([InstanceName])##:Side-Label-Handle               
               iLabelWidthPixels = font-table:get-text-width-pixels(cLabel, iFont) + 3
               dLabelMinHeight = if ##getInstanceHandleName([InstanceName])##:height-chars ge 1 then 1 else font-table:get-text-height(iFont)
               hLabel:format = 'x(' + string(length(cLabel, 'Column') + 1) + ')'
               hLabel:height-chars = min(##getInstanceHandleName([InstanceName])##:height-chars, dLabelMinHeight)
               hLabel:width-pixels = iLabelWidthPixels
               hLabel:screen-value = cLabel.
        
        /* If this viewer has the KeepChildPositions set to yes,
           make sure that the label doesn't overwrite the widget.           
           The tooltip of the label is set to the whole label's value 
           so that we can see what the correct label is. */
        if lKeepChildPositions then
            assign hLabel:width-pixels = ##getInstanceHandleName([InstanceName])##:x - hLabel:x - 2
                   hLabel:tooltip = cLabel.
    end.    /* side-label-handle */
    else
    if ##getInstanceHandleName([InstanceName])##:type eq 'Button' then
        ##getInstanceHandleName([InstanceName])##:Label = '##[TranslatedLabel]##'.
    else
        assign ##getInstanceHandleName([InstanceName])##:Label = cLabel
               ##getInstanceHandleName([InstanceName])##:Width-Chars = MAX(##getInstanceHandleName([InstanceName])##:WIDTH-CHARS,
                                                                       FONT-TABLE:GET-TEXT-WIDTH-CHARS(cLabel, iFont) + 4).
    ##If:End##    /* label translated */       
    ##If:[InstanceDataTranslated]##
    ##getInstanceHandleName([InstanceName])##:##[TranslatedDataAttribute]## = '##[TranslatedData]##'.
    ##If:End##    /* data translated */
    ##If:[InstanceTooltipTranslated]##
    ##getInstanceHandleName([InstanceName])##:##[TooltipAttribute]## = '##[TranslatedTooltip]##'.
    ##If:End##    /* tooltip translated */
    ##If:End##    /* instance is widget */
    ##Loop:End##  /* viewer item loop */

    {set ObjectTranslated yes}.    
    error-status:error = no.
    return.
end procedure.    /* translate-##[LanguageCode]## */
##Loop:End##
##If:End##    /* generate translations */

procedure displayObjects :    
/*------------------------------------------------------------------------------
  Purpose:  Sets the initial (on viewer instantiation) value for various widgets.
    Notes:  * Only widgets that are not dataobject-based will have their initial
              values displayed.
            * MODIFIED needs to be set to false for widgets where screen-value
              is being set because this does not get done for all widget types
              when the widget is enabled.  
            * The value in the InitialValue attribute/field is assumed to be the
              key value in cases where there is a key and display value, like 
              combos and DynLookups.
            * Called from datavis.p initializeObject.  
------------------------------------------------------------------------------*/

##Loop:createViewerDisplayObjects##
    ##If:[InstanceIsLocal]##
    ##If:[InstanceIsSdf]##
    run assignNewValue in ##getInstanceHandleName([InstanceName])##
                    ('##[InstanceInitialValue]##',
                     '',                /* pcDisplayedValue */
                     no   ) no-error.   /* plSetModified */
    ##If:End##    /* instance is sdf */
    ##If:[InstanceIsWidget]##
    ##getInstanceHandleName([InstanceName])##:screen-value = '##[InstanceInitialValue]##'.
    if can-set(##getInstanceHandleName([InstanceName])##, 'Modified') then
        ##getInstanceHandleName([InstanceName])##:modified = no.
    ##If:End##    /* instance widget */
    ##If:End##    /* instance local */    
##Loop:End##

    error-status:error = no.
    return.
end procedure.    /* displayObjects */

/* ************************  Function Implementations ***************** */
FUNCTION getHeight RETURNS DECIMAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       * This function must appear here because the Dynamics viewer super
                 procedure is not an ADM2 procedure and thus doesn't have the 
                 ghProp variable defined.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dHeight             AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE dMinHeight          AS DECIMAL                      NO-UNDO.

    /* Code placed here will execute PRIOR to standard behavior. */
    ASSIGN dHeight = SUPER( ).

    IF dHeight NE 0 AND dHeight NE ? THEN
    DO:
        /* We take the code from getMinHeight in visual.p and put it here since
         * that API causes a recursive call if the Height and MinHeight values 
         * differ. */
        &SCOPED-DEFINE xpMinHeight
        {get MinHeight dMinHeight}.
        &UNDEFINE xpMinHeight
        
        IF dMinHeight EQ 0 OR dMinHeight EQ ? THEN
            {set MinHeight dHeight}.
        ELSE
        IF dHeight LT dMinHeight THEN
            ASSIGN dHeight = dMinHeight.
    END.
    ELSE
    IF dHeight EQ 0 OR dHeight EQ ? THEN
        ASSIGN dHeight = 0.1.

    RETURN dHeight.
END FUNCTION.   /* getHeight */

FUNCTION getWidth RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       * This function must appear here because the Dynamics viewer super
                 procedure is not an ADM2 procedure and thus doesn't have the 
                 ghProp variable defined.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dWidth     AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dMinWidth  AS DECIMAL    NO-UNDO.

    /* Code placed here will execute PRIOR to standard behavior. */
    ASSIGN dWidth = SUPER( ).

    IF dWidth NE 0 AND dWidth NE ? THEN
    DO:
        /* We take the code from getMinWidth in visual.p and put it here since
         * that API causes a recursive call if the Width and MinWidth values 
         * differ. */
        &SCOPED-DEFINE xpMinWidth
        {get MinWidth dMinWidth}.
        &UNDEFINE xpMinWidth
        
        IF dMinWidth EQ 0 OR dMinWidth EQ ? THEN
            {set MinWidth dWidth}.
        ELSE
        IF dWidth LT dMinWidth THEN
            ASSIGN dWidth = dMinWidth.
    END.
    ELSE
    IF dWidth EQ 0 OR dWidth EQ ? THEN
        ASSIGN dWidth = 0.1.

    RETURN dWidth.
END FUNCTION.   /* getWidth */

FUNCTION adm-assignObjectProperties returns logical:
 /*------------------------------------------------------------------------------ 
  Purpose:  Sets the properties for the object.
    Notes: 
  ------------------------------------------------------------------------------*/ 
    /* Assignable properties */
    &scoped-define xp-Assign
    {set LogicalObjectName '##[ObjectName]##'}
    {set ObjectTranslated ##initialObjectTranslated([ObjectName])##}
    {set ObjectSecured ##initialObjectSecured([ObjectName])##}
    ##If:generateSuperInProperty()##
    {set SuperProcedure '##[ObjectSuperProcedure]##'}
    {set SuperProcedureMode '##[ObjectSuperProcedureMode]##'} 
    ##If:End##
    ##If:generateSuperInLine()##
    {set SuperProcedure ''}
    {set SuperProcedureMode ''} 
    ##If:End##
    ##If:generateSuperInConstructor()##
    {set SuperProcedure ''}
    {set SuperProcedureMode ''} 
    ##If:End##
            
    ##Loop:ObjectProperties-Assign##
    {set ##[PropertyName]## ##[PropertyValue]##}
    ##Exclude:##
    /* Break up the assign statement every 50 properties or so,
       since they all make up one assign statement.
    */
    ##Exclude:End##    
    ##Every:50##
    .
    &undefine xp-Assign
    &scoped-define xp-Assign
    ##Every:End##    
    ##Loop:End##
    .
    &undefine xp-Assign
        
    /* Keep forced 'Set' properties separate. */
    &scoped-define xp-Assign
    {set LogicalVersion '##[ObjectVersion]##'}
    {set PhysicalObjectName ##[PhysicalObjectName]##}
    {set PhysicalVersion '##[ObjectVersion]##'}    
    ##Loop:ObjectProperties-Set##
    {set ##[PropertyName]## ##[PropertyValue]##}    
    ##Loop:End##
    .
    &undefine xp-Assign

    RETURN TRUE.
END FUNCTION.        /* adm-assignObjectProperties */

##If:generateSuperInline()##
{##[ObjectSuperProcedure]##}
##If:End##
    
/* ---oo00oo--- */
