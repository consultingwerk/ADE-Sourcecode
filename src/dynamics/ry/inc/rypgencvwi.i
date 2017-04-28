/* Copyright © 2006-2007 Progress Software Corporation.  
   All Rights Reserved. */
/*------------------------------------------------------------------------
    File        : rypgencvwi.i
    Purpose     : Contains contents of processLoop-createViewerWidgets
                  in ry/app/rygen4glhp.p.
    Author(s)   : pjudge
    Created     : 8/31/2006
    Notes       : Created from scratch
  ----------------------------------------------------------------------*/
    define variable cValue                 as character                no-undo.
    define variable cDataType              as character                no-undo.
    define variable hWidget                as handle                   no-undo.
    define variable lLocalField            as logical                  no-undo.
    define variable lEnableField           as logical                  no-undo.
    define variable lHasLabel              as logical                  no-undo.
    define variable lSideLabel             as logical                  no-undo.
    define variable lDisplayField          as logical                  no-undo.
    define variable iFont                  as integer                  no-undo.

    define variable cDataSourceNames      as character                no-undo.
    define variable cObjectName           as character                no-undo.
    define variable cExcludeProperties    as character                no-undo.
    define variable cInstanceType         as character                no-undo.
    define variable lThinRendering        as logical                  no-undo.
    define variable lVisible              as logical                  no-undo.
    define variable dWidth                as decimal                  no-undo.
    
    cExcludeProperties = 'Name,Label,Order,Visible,Hidden,JavaScriptFile,JavaScriptObject,'
                       + 'Data-Type,Format'.
    dynamic-function('setTokenValue' in target-procedure,
                     'InstanceExcludeProperties', cExcludeProperties).
    
    cObjectName = dynamic-function('getTokenValue' in target-procedure, 'ObjectName').
        
    find ttProperty where
         ttProperty.PropertyName = 'DataSourceNames' and
         ttProperty.PropertyOwner = cObjectName
         no-error.
    if not available ttProperty then
    do:
        create ttProperty.
        assign ttProperty.PropertyOwner = cObjectName
               ttProperty.PropertyName = 'DataSourceNames'
               ttProperty.PropertyValue = ''
               ttProperty.DataType = 'Character'.
    end.    /* no init value */
    
    cDataSourceNames = ttProperty.PropertyValue.
    
    for each ttInstance:
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceName', ttInstance.InstanceName).
        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceOrder', string(ttInstance.Order)).
        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceClass', ttInstance.ClassName).
        
        /* InitialValue */
        find ttProperty where
             ttProperty.PropertyName = 'InitialValue' and
             ttProperty.PropertyOwner = ttInstance.InstanceName
             no-error.
        if not available ttProperty then
        do:
            create ttProperty.
            assign ttProperty.PropertyOwner = ttInstance.InstanceName
                   ttProperty.PropertyName = 'InitialValue'
                   ttProperty.PropertyValue = ''
                   ttProperty.DataType = 'Character'.
        end.    /* no init value */
        
        /* Escape single quotes in the initial value. */
        cValue = replace(ttProperty.PropertyValue, "'", "~~'").
        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceInitialValue', cValue).
        
        /* Visible? */
        find ttProperty where
             ttProperty.PropertyName = 'Visible' and
             ttProperty.PropertyOwner = ttInstance.InstanceName
             no-error.
        if not available ttProperty then
        do:
            create ttProperty.
            assign ttProperty.PropertyOwner = ttInstance.InstanceName
                   ttProperty.PropertyName = 'Visible'
                   ttProperty.PropertyValue = string(Yes)
                   ttProperty.DataType = 'Logical'.
        end.    /* no visible */
        
        lVisible = logical(ttProperty.PropertyValue) no-error.
        if lVisible eq ? then
            assign lVisible = yes
                   ttProperty.PropertyValue = string(lVisible).
        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceVisible', string(lVisible)).
        
        /* Applies to both Widgets and Procedures/SDFs */
        /* Row */
        find ttProperty where
             ttProperty.PropertyName = 'Row' and
             ttProperty.PropertyOwner = ttInstance.InstanceName
             no-error.
        if not available ttProperty then
        do:
            create ttProperty.
            assign ttProperty.PropertyOwner = ttInstance.InstanceName
                   ttProperty.PropertyName = 'Row'
                   ttProperty.PropertyValue = string(1)
                   ttProperty.DataType = 'Decimal'.
        end.    /* no row */
        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceRow', ttProperty.PropertyValue).
        
        /* Column */        
        find ttProperty where
             ttProperty.PropertyName = 'Column' and
             ttProperty.PropertyOwner = ttInstance.InstanceName
             no-error.
        if not available ttProperty then
        do:
            create ttProperty.
            assign ttProperty.PropertyOwner = ttInstance.InstanceName
                   ttProperty.PropertyName = 'Column'
                   ttProperty.PropertyValue = string(1)
                   ttProperty.DataType = 'Decimal'.
        end.    /* no column */
        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceColumn', ttProperty.PropertyValue).
        
        /* Height */        
        find ttProperty where
             ttProperty.PropertyName = 'Height-Chars' and
             ttProperty.PropertyOwner = ttInstance.InstanceName
             no-error.
        
        if not available ttProperty then
        do:
            create ttProperty.
            assign ttProperty.PropertyOwner = ttInstance.InstanceName
                   ttProperty.PropertyName = 'Height-Chars'
                   ttProperty.DataType = 'Decimal'.
            ttProperty.PropertyValue = dynamic-function('findAttributeValue' in target-procedure,
                                                        'Height-Chars', ttInstance.ObjectName).                   
        end.    /* no Height  */
        
        if decimal(ttProperty.PropertyValue) eq ? then
            ttProperty.PropertyValue = string(1).            
        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceHeight', ttProperty.PropertyValue).
        
        /* DisplayField? */
        find ttProperty where
             ttProperty.PropertyName = 'DisplayField' and
             ttProperty.PropertyOwner = ttInstance.InstanceName
             no-error.
        if not available ttProperty then
        do:
            create ttProperty.
            assign ttProperty.PropertyOwner = ttInstance.InstanceName
                   ttProperty.PropertyName = 'DisplayField'
                   ttProperty.DataType = 'Logical'.
            ttProperty.PropertyValue = dynamic-function('findAttributeValue' in target-procedure,
                                                        'DisplayField', ttInstance.ObjectName).
        end.    /* no DisplayField  */
        
        lDisplayField = logical(ttProperty.PropertyValue) no-error.
        if lDisplayField eq ? then
            assign lDisplayField = no
                   ttProperty.PropertyValue = string(lDisplayField).
        
        /* What kind of viewer instance is this? */
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceIsSdf',
                         string(ttInstance.InstanceType eq 'Sdf')).
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceIsWidget',
                         string(ttInstance.InstanceType eq 'Widget')).

/** ------------------ SDF ---------------------- **/
        if ttInstance.InstanceType eq 'Sdf' then
        do:
            dynamic-function('setTokenValue' in target-procedure,
                             'InstanceObjectName', ttInstance.ObjectName).
            
            cInstanceType = 'SmartDataField'.
                        
            /* Width. Always try to find a width, since we
               pass this value into resizezObject. Before finding
               a default value, look at the master.
             */
            find ttProperty where
                 ttProperty.PropertyName = 'Width-Chars' and
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            if not available ttProperty then
            do:
                create ttProperty.
                assign ttProperty.PropertyOwner = ttInstance.InstanceName
                       ttProperty.PropertyName  = 'Width-Chars'
                       ttProperty.DataType      = 'Decimal'.
                ttProperty.PropertyValue = dynamic-function('findAttributeValue' in target-procedure,
                                                            'Width-Chars', ttInstance.ObjectName).                         
            end.    /* no Width */
            
            dWidth = decimal(ttProperty.PropertyValue).
            
            /* If truly nothing can be found, then look for */
            if dWidth eq ? then
                assign dWidth = 1
                       ttProperty.PropertyValue = string(dWidth).
            
            /* LocalField? */
            find ttProperty where
                 ttProperty.PropertyName = 'LocalField' and
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            if not available ttProperty then
            do:
                create ttProperty.
                assign ttProperty.PropertyOwner = ttInstance.InstanceName
                       ttProperty.PropertyName = 'LocalField'
                       ttProperty.DataType = 'Logical'.
                ttProperty.PropertyValue = dynamic-function('findAttributeValue' in target-procedure,
                                                            'LocalField', ttInstance.ObjectName).                          
            end.    /* no LocalField */

            lLocalField = logical(ttProperty.PropertyValue) no-error.
            if lLocalField eq ? then
                assign lLocalField = no
                       ttProperty.PropertyValue = string(lLocalField).
            
            /* Enabled? */
            find ttProperty where
                 ttProperty.PropertyName = 'EnableField' and
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            if not available ttProperty then
            do:
                create ttProperty.
                assign ttProperty.PropertyOwner = ttInstance.InstanceName
                       ttProperty.PropertyName = 'EnableField'
                       ttProperty.DataType = 'Logical'.
                ttProperty.PropertyValue = dynamic-function('findAttributeValue' in target-procedure,
                                                            'EnableField', ttInstance.ObjectName).                         
            end.    /* no EnableField */
                 
            lEnableField = logical(ttProperty.PropertyValue) no-error.
            if lEnableField eq ? then
                assign lEnableField = yes
                       ttProperty.PropertyValue = string(lEnableField).
            
            /* Set a little later, so there's only one set call for this token. */                
            
            /* Find a rendering procedure. */
            cValue = ''.
            if lThinRendering then
            do:
                /* InstanceRenderingProcedure */
                find ttProperty where
                     ttProperty.PropertyName = 'ThinRenderingProcedure' and
                     ttProperty.PropertyOwner = ttInstance.InstanceName
                     no-error.
                if available ttProperty then
                    cValue = ttProperty.PropertyValue.
                else
                    cValue = dynamic-function('findAttributeValue' in target-procedure,
                                              'ThinRenderingProcedure', ttInstance.ObjectName).
            end.    /* thin rendering */
                
            if cValue eq '' or cValue eq ? then
            do:            
                /* InstanceRenderingProcedure */
                find ttProperty where
                     ttProperty.PropertyName = 'RenderingProcedure' and
                     ttProperty.PropertyOwner = ttInstance.InstanceName
                     no-error.
                if available ttProperty then
                    cValue = ttProperty.PropertyValue.
                else
                    cValue = dynamic-function('findAttributeValue' in target-procedure,
                                              'RenderingProcedure', ttInstance.ObjectName).
            end.    /* find renderingprocedure */
            
            /* Some (static mainly) objects may use PhysicalObjectName 
               instead of RenderingProcedure
             */
            if cValue eq '' or cValue eq ? then
            do:
                find ttProperty where
                     ttProperty.PropertyName = 'PhysicalObjectName' and                            
                     ttProperty.PropertyOwner = ttInstance.InstanceName
                     no-error.
                if available ttProperty then
                    cValue = ttProperty.PropertyValue.
            end.    /* look for physical object */
            
            dynamic-function('setTokenValue' in target-procedure,
                             'InstanceRenderingProcedure', cValue).

            /* Previously, we built a list. Now we generated {set}s individually.
	           However, we must pass in LogicalObjectName so that  instances will
	           run pgen'ed files, if they exist. */
            cValue = 'LogicalObjectName' + chr(4) + ttInstance.ObjectName.
            dynamic-function('setTokenValue' in target-procedure,
                             'InstanceInstanceProperties',
                             quoter(cValue)).
        end.    /* SDF */
        else
/** ------------------ WIDGET ---------------------- **/
        do:
            /* Remember that the widget properties are instance, master & class props,
               because there is no procedure for datafields. */
            /* Visualization Type */
            find ttProperty where
                 ttProperty.PropertyName = 'VisualizationType' and
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            if not available ttProperty then
            do:
                create ttProperty.
                assign ttProperty.PropertyOwner = ttInstance.InstanceName
                       ttProperty.PropertyName = 'VisualizationType'
                       ttProperty.PropertyValue = 'Fill-In'
                       ttProperty.DataType = 'Character'.
            end.    /* no VisualizationType */
            assign cInstanceType = ttProperty.PropertyValue
                   ttInstance.InstanceType = cInstanceType.
            
            /* Enabled? */
            find ttProperty where
                 ttProperty.PropertyName = 'Enabled' and
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            if not available ttProperty then
            do:
                create ttProperty.
                assign ttProperty.PropertyOwner = ttInstance.InstanceName
                       ttProperty.PropertyName = 'Enabled'
                       ttProperty.PropertyValue = string(Yes)
                       ttProperty.DataType = 'Logical'.
            end.    /* no Enabled */
            
            lEnableField = logical(ttProperty.PropertyValue) no-error.
            if lEnableField eq ? then
                lEnableField = yes.
            
            /* LocalField? */
            find ttProperty where
                 ttProperty.PropertyName = 'TableName' and
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            if not available ttProperty then
            do:
                create ttProperty.
                assign ttProperty.PropertyOwner = ttInstance.InstanceName
                       ttProperty.PropertyName = 'TableName'
                       ttProperty.DataType = 'Character'.
                
                /* If the instance's class doesn't have the TableName attribute,
                   then this instance can never be provided with dats from an
                   SDO. Set the value of the property to ? to indicate to the
                   subsequent code that this field is, indeed, local.
                 */
                if dynamic-function('ClassHasAttribute' in gshRepositoryManager,
                                    ttInstance.ClassName, 'TableName', no) then
                    ttProperty.PropertyValue = ''.
                else
                    ttProperty.PropertyValue = ?.
            end.    /* no property */
            
            if ttProperty.PropertyValue eq ? then
                ttProperty.PropertyValue = ''.
            else
            if cDataSourceNames eq '' or
               dynamic-function('classIsA' in gshRepositoryManager,
                                ttInstance.ClassName, 'CalculatedField') then
                ttProperty.PropertyValue = 'rowObject'.
            
            dynamic-function('setTokenValue' in target-procedure,
                             'InstanceTableName', ttProperty.PropertyValue).
                        
            lLocalField = (ttProperty.PropertyValue eq '') no-error.
            if lLocalField eq ? then
                assign lLocalField = no
                       ttProperty.PropertyValue = string(lLocalField).
            
            /* Font */            
            find ttProperty where
                 ttProperty.PropertyName = 'Font' and
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            if not available ttProperty then
            do:
                create ttProperty.
                assign ttProperty.PropertyOwner = ttInstance.InstanceName
                       ttProperty.PropertyName = 'Font'
                       ttProperty.DataType = 'Integer'
                       ttProperty.PropertyValue = ?.
            end.    /* no Font */
                 
            iFont = integer(ttProperty.PropertyValue) no-error.
            
            dynamic-function('setTokenValue' in target-procedure,
                             'InstanceFont', string(iFont)).
            
            /* Width */
            find ttProperty where
                 ttProperty.PropertyName = 'Width-Chars' and
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            if not available ttProperty then
            do:
                /* Use a default width. Don't bother with
                   looking at the master props since we've already
                   got these in the ttProperty table for all non-SDF
                   viewer widgets.
                 */                
                create ttProperty.
                assign ttProperty.PropertyOwner = ttInstance.InstanceName
                       ttProperty.PropertyName = 'Width-Chars'
                       ttProperty.DataType = 'Integer'
                       ttProperty.PropertyValue = string(font-table:get-text-width-chars('wwwwwwww', iFont)).
            end.    /* no Font */

            dWidth = decimal(ttProperty.PropertyValue) no-error.            
            if dWidth eq 0 or dWidth eq ? then
                assign dWidth = 1
                       ttProperty.PropertyValue = string(dWidth).
            
            /* Data type */
            find ttProperty where
                 ttProperty.PropertyOwner = ttInstance.InstanceName and
                 ttProperty.PropertyName = 'Data-Type'
                 no-error.
            if not available ttProperty then
            do:
                create ttProperty.
                assign ttProperty.PropertyOwner = ttInstance.InstanceName
                       ttProperty.PropertyName = 'Data-Type'
                       ttProperty.PropertyValue = 'Character'
                       ttProperty.DataType = 'Character'.
            end.    /* no data type */
            
            cDataType = ttProperty.PropertyValue.
            if cDataType eq 'Clob' then
                assign cDataType = 'Longchar'
                       ttProperty.PropertyValue = cDataType.
            
            dynamic-function('setTokenValue' in target-procedure,
                             'InstanceDataType', cDataType).
            
            if cDataType eq 'Longchar' then
            do:
                dynamic-function('setTokenValue' in target-procedure,
                                 'InstanceIsLongChar', 'Yes').
                
                find ttProperty where
                     ttProperty.PropertyOwner = ttInstance.InstanceName and
                     ttProperty.PropertyName = 'Large'
                     no-error.
                if not available ttProperty then
                do:
                    create ttProperty.
                    assign ttProperty.PropertyOwner = ttInstance.InstanceName
                           ttProperty.PropertyName = 'Large'
                           ttProperty.DataType = 'Logical'.
                end.    /* n/a large */
                ttProperty.PropertyValue = 'Yes'.
            end.    /* LongChar */
            else
                dynamic-function('setTokenValue' in target-procedure,
                                 'InstanceIsLongChar', 'No').
            
            /* Font 
	           processLoop-createViewerObjects ensures that this record exists.
	         */
            find ttProperty where
                 ttProperty.PropertyName = 'Font' and
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            dynamic-function('setTokenValue' in target-procedure,
                             'InstanceFont', ttProperty.PropertyValue).
            
            /* Width 
	        processLoop-createViewerObjects ensures that this record exists.
	        */
            find ttProperty where
                 ttProperty.PropertyName = 'Width-Chars' and
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            dynamic-function('setTokenValue' in target-procedure,
                             'InstanceWidth', ttProperty.PropertyValue).
            
            /* Show Popups? */                    
            if cInstanceType eq 'Fill-In' and 
               can-do('Date,Decimal,Integer,INT64', cDataType) then
            do:
                find ttProperty where
                     ttProperty.PropertyName = 'ShowPopup' and
                     ttProperty.PropertyOwner = ttInstance.InstanceName
                     no-error.
                if available ttProperty then
                    cValue =  ttProperty.PropertyValue.
                else
                    cValue = 'Yes'.
            end.    /* fill-ins of date,deci,int type */
            else
                cValue = 'No'.
            
            dynamic-function('setTokenValue' in target-procedure,
                             'ShowWidgetPopup', cValue).
                          
            /* Labels */
            hWidget = dynamic-function('getWidgetHandle' in target-procedure, cInstanceType).
            lHasLabel = can-set(hWidget, 'Side-Label-Handle') or
                        can-set(hWidget, 'Label').
            if lHasLabel then
            do:
                find ttProperty where
                     ttProperty.PropertyName = 'Labels' and
                     ttProperty.PropertyOwner = ttInstance.InstanceName
                     no-error.
                if available ttProperty then
                    cValue =  ttProperty.PropertyValue.
                else
                    cValue = 'Yes'.
                lHasLabel = logical(cValue) no-error.
                if lHasLabel eq ? then
                    lHasLabel = yes.
            end.    /* widget has a label */
            
            /* Even if the LABELS property is set to true,
	           there may be no actual label for the widget.
	           Check this.
	         */            
            if lHasLabel then            
            do:
                find ttProperty where
                     ttProperty.PropertyName = 'Label' and
                     ttProperty.PropertyOwner = ttInstance.InstanceName
                     no-error.
                if available ttProperty then
                    cValue =  ttProperty.PropertyValue.
                
                lHasLabel = available ttProperty.            
            end.    /* has label */
            
            dynamic-function('setTokenValue' in target-procedure,
                             'WidgetHasLabel', string(lhasLabel)).
            
            if lHasLabel then
            do:                
                /* determine what kind of label to use */
                dynamic-function('setTokenValue' in target-procedure,
                                 'WidgetLabelSide',
                                 can-set(hWidget, 'Side-Label-Handle')).
                dynamic-function('setTokenValue' in target-procedure,
                                 'WidgetLabelNotSide',
                                 not can-set(hWidget, 'Side-Label-Handle')).            
                
                /* Escape single quotes in the label. */
                cValue = replace(cValue, "'", "~~'").
                
                /* some stuff only valid for side-label-handle */
                if can-set(hWidget, 'Side-Label-Handle') then
                do:
                    dynamic-function('setTokenValue' in target-procedure,
                                     'InstanceLabel', cValue + ':').
                    
                    find ttProperty where
                         ttProperty.PropertyName = 'LabelFont' and
                         ttProperty.PropertyOwner = ttInstance.InstanceName
                         no-error.
                    if available ttProperty then
                        iFont = integer(ttProperty.PropertyValue) no-error.
                    else
                        iFont = ?.
                    
                    dynamic-function('setTokenValue' in target-procedure,
                                     'InstanceLabelFont', string(iFont)).
                                                  
                    find ttProperty where
                         ttProperty.PropertyName = 'LabelFgColor' and
                         ttProperty.PropertyOwner = ttInstance.InstanceName
                         no-error.
                    if available ttProperty then
                        cValue = ttProperty.PropertyValue.
                    else
                        cValue= '?'.
                    
                    dynamic-function('setTokenValue' in target-procedure,
                                     'InstanceLabelFgColor', cValue).
                         
                    find ttProperty where
                         ttProperty.PropertyName = 'LabelBgColor' and
                         ttProperty.PropertyOwner = ttInstance.InstanceName
                         no-error.
                        if available ttProperty then
                            cValue = ttProperty.PropertyValue.
                        else
                            cvalue= '?'.
    
                    dynamic-function('setTokenValue' in target-procedure,
                                     'InstanceLabelBgColor', cValue).
                end.    /* side label only */
                else
                do:
                    dynamic-function('setTokenValue' in target-procedure,
                                     'InstanceLabel', cValue).
                    
                    if cInstanceType eq 'Button' then
                        cValue = dynamic-function('getInstanceHandleName' in target-procedure,
                                                  ttInstance.InstanceName) + ':Width-Chars'.
                    else
                        cValue = substitute('MAX(&1:WIDTH-CHARS,FONT-TABLE:GET-TEXT-WIDTH-CHARS('
                                            + '&1:LABEL, &1:FONT) + 4)',
                                            dynamic-function('getInstanceHandleName' in target-procedure,
                                                             ttInstance.InstanceName) ).
        
                    dynamic-function('setTokenValue' in target-procedure,
                                     'InstanceLabelWidth', cValue).                
                end.    /* non-side labels (eg button) */
            end.    /* LABEL-BLOCK: has a label */            
            
            /* Modified is set to true by the 4GL after setting visible to true up above.  Modified is set
	           to false for datafields when they are displayed.  When certain widgets that are not 
	           dataobject-based are enabled, modified is set to false by the 4GL, for others it is not
	           so we need to set it to false here. */            
            dynamic-function('setTokenValue' in target-procedure,
                             'InstanceLocalCanModify',
                             string(lLocalField and can-set(hWidget, 'Modified'))).
        
            dynamic-function('setTokenValue' in target-procedure,
                             'InstanceTextAndNotDisplay',
                             string(not lDisplayField and cInstanceType eq 'Text')).
            
            /* Find the Format */
            find ttProperty where
                 ttProperty.PropertyName = 'Format' and
                 ttProperty.PropertyOwner = ttInstance.InstanceName
                 no-error.
            if available ttProperty then
                cValue = ttProperty.PropertyValue.
            else
                cValue = ?.
            
            cValue = quoter(cValue).        
            dynamic-function('setTokenValue' in target-procedure,
                             'InstanceFormat', cValue).
            
            /* Does  the instance have an image? */
            case ttInstance.InstanceType:
                when 'Image' or when 'Button' then
                    find ttProperty where
                         ttProperty.PropertyName = 'Image-File' and
                         ttProperty.PropertyOwner = ttInstance.InstanceName
                         no-error.
                otherwise 
                    /* Force the find to fail (i.e. make sure the
	                   record buffer is empty).
	                 */
                    find ttProperty where
                         rowid(ttProperty) = ?
                         no-error.
            end case.    /* instance type */
            
            dynamic-function('setTokenValue' in target-procedure,
                             'WidgetHasImage',
                             available(ttProperty)).
            
            if available ttProperty then
                dynamic-function('setTokenValue' in target-procedure,
                                 'InstanceImageFile',
                                 quoter(ttProperty.PropertyValue)).
            
            /* Set the intial value, in certain cases. */
            if not lDisplayField and cInstanceType eq 'Text' then
            do:
                find ttProperty where
                     ttProperty.PropertyName = 'InitialValue' and
                     ttProperty.PropertyOwner = ttInstance.InstanceName
                     no-error.
                
                /* Escape single quotes in the initial value. */
                cValue = replace(ttProperty.PropertyValue, "'", "~~'").
                
                dynamic-function('setTokenValue' in target-procedure,
                                 'InstanceInitialValue', cValue).
            end.    /* Text widget and not display */
                       
        end.    /* widget */

        /* Common set of the name of the property to store the list of
           enabled field names. This is either cEnabledObjFlds (local
           fields) or cEnabledFields (Data-bound fields). Similarly
           the handles are stored in either cEnabledObjHdls or cEnabledHandles,
           depending on databound status.
         */
        if lLocalField then
            cValue = 'pcEnabledObjFlds'.
        else
            cValue = 'pcEnabledFields'.
        dynamic-function('setTokenValue' in target-procedure,
                         'EnabledNameList', cValue).
        
        if lLocalField then
            cValue = 'pcEnabledObjHdls'.
        else
            cValue = 'pcEnabledHandles'.
        
        dynamic-function('setTokenValue' in target-procedure,
                         'EnabledHandleList', cValue).
        
        /* Common set for InstanceDisplayAndNotLocal */
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceDisplayAndNotLocal',
                         string(lDisplayField and not lLocalField)).
        
        /* Common set of the InstanceEnabled token. The variable value
           has been determined above, in different ways depending on
           the InstanceType.
         */
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceEnabled', string(lEnableField)).
        
        /* Common set of the InstanceWidth token. The variable value
           has been determined above, in different ways depending on
           the InstanceType.
         */        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceWidth', string(dWidth)).
        
        /* Common set of the InstanceType token. */        
        dynamic-function('setTokenValue' in target-procedure,
                         'InstanceType', cInstanceType).
        
        /* .. and write ... */
        dynamic-function('processLoopIteration' in target-procedure).                
    end.    /* widget instances */
    
/* - E -O - F - */