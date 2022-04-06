"ActionEvent" 436.7063 1 "The event to publish on Default-action of the browse. The caller should also subscribe to the event." "SET" no no "" no "" "" no yes 486.7063
"ActionGroups" 430.7063 1 "Comma separated list of actionGroups.
Repository toolbar uses categories while non-repository objects
uses parent actions" "" no no "" no "" "" no yes 1003498429
"ActionWidgetIDs" 430.7063 1 "Comma separated list containing the action names and their widget-ids." "" no no "" no "" "" no yes 4606.84251
"AddFunction" 438.7063 1 "" "SET" yes no "" no "" "" no yes 684.7063
"AllFieldHandles" 7.7063 1 "Contains the handles of all objects and widgets on the visual objects. The list corresponds to AllFieldNames. The list has the procedure-handles of SDF containerTargets and widget-handles of widgets." "" yes no "" no "" "" no yes 88.7063
"AllFieldNames" 7.7063 1 "Contains a comma-separated list of names of all objects and widgets on the visual objects. The corresponding handles are stored in AllFieldHandles. The list stores the FieldName of SmartDataFields and the NAME attribute of widgets." "" yes no "" no "" "" no yes 90.7063
"ALLOW-COLUMN-SEARCHING" 1005078412.09 3 "Browser columns are searchable if true" "" no no "" no "" "" no no 14629.409
"AltValueOnAdd" 432.7063 1 "Specifies the alternate value to display in the case the viewer data source initial value does not exist in the list of values. 
- <Clear> = Clear the combo box  
- <First>   = Select first item in list of values  
- <Last>   = Select last item in list of values  
" "" no no "" no "" "" no yes 62611.66
"AltValueOnRebuild" 432.7063 1 "Specifies the alternate value to display if the current value does not exist in the list after it is rebuilt (in edit mode), for example as a result of a value change in a parent combo. 
- <Clear> = Clear the combo box  
- <First>   = Select first item in list of values  
- <Last>   = Select last item in list of values" "" no no "" no "" "" no yes 62613.66
"AppBuilderTabbing" 1005095446.101 1 "Stores the AppBuilder tabbing option for a dynamic viewer." "" no no "Master" no "" "" yes yes 7222.5498
"ApplyActionOnExit" 436.7063 3 "TRUE if exit is to perform the same action as the DEFAULT-ACTION. Currently used by the SmartSelect." "" no no "" no "" "" no yes 488.7063
"ApplyExitOnAction" 436.7063 3 "TRUE if DEFAULT-ACTION is to exit the browse. Currently used by the SmartSelect.
The logic is not performed in the trigger, but in the defaultAction
procedure that gets defined as a persitent DEFAULT-ACTION event when setActionEvent is defined. 
Local DEFAULT-ACTION events could be set up to run defaultAction." "" no no "" no "" "" no yes 490.7063
"AppService" 1003183341 1 "Stores the AppService name to use when connecting to the AppServer. The get is mandatory to resolve '(none)' value as blank. This may have been stored from the Instance Property Dialog in older versions." "GET" no no "" no "" "" no yes 1003183455
"ASDivision" 11.7063 1 "Property indicating which side of the AppServer this object is running on; 'Client', 'Server', or none.
This is the main condition used in code to separate/trigger client or server specific logic.  It's immediately set to 'server' at start up if session:remote. On the client, we traditionally connected in initializeObject and immediately set this property there, but as we now postpone the connection, this value may be unknown. Get is enforced to ensure that unknown never is exposed." "GET" yes no "" no "" "" no yes 130.7063
"ASHandle" 11.7063 10 "The handle to this object's companion procedure (the copy of itself) running on the AppServer. This binds the server and should be avoided alltogether to utilize the one-hit appserver data requests.  If it is used then use unbindServer to unbind the server again." "get" yes no "" no "" "" no yes 135.7063
"ASHasConnected" 11.7063 3 "Indicates whether the object has done a connection to the defined AppService. This is mainly used to avoid calling the connect method APIs  in the standard Appserver utility or Dynamics Connection Manager unnecessarily." "" yes no "" no "" "" no yes 55423.66
"ASHasStarted" 11.7063 3 "Indicates whether the object has done its first call to its server side object." "" yes no "" no "" "" no yes 137.7063
"ASInfo" 11.7063 1 "The value of the AppServer Information string which is passed to the AppServer connection as a parameter." "" no no "" no "" "" no yes 1003183460
"ASInitializeOnRun" 11.7063 3 "Indicates whether 'runServerObject'  should call 'initializeServerObject'. 'InitializeServerObject is called on the client, but will call the server to set and/or retrieve context if this property is true. Use with caution." "" no no "" no "" "" no yes 139.7063
"AssignList" 154.7063 1 "List of updatable columns whose names have been modified in the SmartDataObject.
Value format:
<RowObjectFieldName>,<DBFieldName>[,...][CHR(1)...]
with a comma separated list of pairs of fields for each db table,
and CHR(1) between the lists of pairs." "" no no "" no "" "" no yes 529.7063
"ASUsePrompt" 11.7063 3 "Flag which indicates whether the support code should prompt for a Username and Password when connecting to an AppServer session." "" no no "" no "" "" no yes 1003183458
"AsynchronousSDO" 152.7063 3 "Not in use" "" no no "" no "" "" no yes 1004959733.09
"ATTR-SPACE" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099316.101
"AuditEnabled" 154.7063 3 "Indicates that auditing is enabled for the entity." "" yes no "" no "" "" no yes 2701.5498
"AuditingEnabled" 36427.48 3 "If set to YES, auditing will be enabled for this table and will be done via the generic triggers generated from" "" yes no "" no "" "" no no 36431.48
"AUTO-COMPLETION" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099332.101
"AUTO-END-KEY" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099320.101
"AUTO-GO" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099319.101
"AUTO-INDENT" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099275.101
"AUTO-RESIZE" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099296.101
"AUTO-RETURN" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099315.101
"AUTO-VALIDATE" 1005078412.09 3 "Browser input is automatically validated" "" no no "" no "" "" no no 14631.409
"AUTO-ZAP" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099313.101
"AutoCommit" 152.7063 3 "Sets the AutoCommit flag on or off; when On, every call to 'submitRow' will result in a Commit.
When applied to a DataContainer (SBO), it is always set to
FALSE for the contained SDOs because they never initiate their own Commit when contained in an SBO." "set" no no "" no "" "" no yes 168.7063
"AutoFill" 432.7063 3 "Indicates whether the object's data storage should be filled automatically when the data source is repositioned.  
- Yes - fill on position change. 
- No  - fill on demand. e.g when fillData is executed." "" no no "" no "" "" no yes 54734.66
"AutoProperformStrings" 36427.48 3 "Should all character fields be properformed, i.e. automatically tidy up the case of the value into correct upper and lower case." "" yes no "" no "" "" no no 36429.48
"AutoRefresh" 434.7063 3 "For future use." "" no no "" no "" "" no yes 562.7063
"AutoSort" 1005097792.101 3 "Used to set the property of a SmartTreeView object to Automatically sort the nodes." "SET" no no "" no "" "" no yes 1005081438.28
"AvailMenuActions" 430.7063 1 "The actions that are available in the menu of the toolbar object.
Updated internally from insertMenu. The Instance Property dialog shows these and AvailToolbarActions. 
The actions that are selected will be saved as ActionGroups." "" yes no "" no "" "" no yes 705.7063
"AvailToolbarActions" 430.7063 1 "The actions that are available in the toolbar.
Updated internally from createToolbar. The Instance Property dialog shows these and AvailToolbarActions. 
The actions that are selected will be saved as ActionGroups." "" yes no "" no "" "" no yes 707.7063
"BaseQuery" 154.7063 1 "This is used internally by OpenQuery, and directly on client context management. Because setOpenQuery also calls setQueryWhere and wipes out all other query data it cannot be used when setting this when received from server ." "" no no "" no "" "" no yes 505.7063
"BaseQueryString" 1005095447.101 1 "Dynamic Lookup/Combo Base Browse query string (design time)" "" no no "" no "" "" no yes 1005089874.28
"BGCOLOR" 1005078412.09 4 "" "SET" no no "" no "DIALOG" "af/sup2/afspgetcow.w" no no 1005099282.101
"BindScope" 11.7063 1 "Define the scope of an stateless appserver connection. (See 'setBindScope' function for details on use)" "set" yes no "" no "" "" no yes 143.7063
"BindSignature" 11.7063 1 "Used internally to resolve whether to unbind in unbindServer." "" yes yes "" no "" "" no yes 141.7063
"BLANK" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099318.101
"BlankOnNotAvail" 432.7063 3 "Indicates that the field should be blanked when the typed value has no match rather than leaving the value in the field - providing the field value was modified. The rule is normally applied on the leave event, but some UIs may require a more explicit user action.  
" "" no no "" no "" "" no yes 18282.66
"BLOBColumns" 154.7063 1 "A comma-separated list of the DataObject's BLOB data-type columns." "GET" yes no "" no "" "" no yes 53556.66
"BlockDataAvailable" 428.7063 3 "TRUE if DataAvailable messages from contained SDOs are to be ignored and not republished  (usually during updates)." "" yes yes "" no "" "" no yes 458.7063
"BlockQueryPosition" 428.7063 3 "TRUE to block outgoing (from contained SDOs) queryPosition requests." "get" yes yes "" no "" "" no yes 464.7063
"BOX" 1005078412.09 3 "" "SET" no no "" no "" "" no no 1005099272.101
"BOX-SELECTABLE" 1005078412.09 3 "Frame attribute to allow objects to be selected by drawing a box around them" "" no no "" no "" "" no no 14813.409
"BoxRectangle" 438.7063 10 "The handle to the rectangle, if any, which draws a  ""box"" around the buttons in the Panel -- used by resizeObject." "" yes no "" no "" "" no yes 666.7063
"BoxRectangle2" 438.7063 10 "The handle to the rectangle, if any, which draws a  ""box"" around the buttons in the Panel -- used for the lower rectangle by a toolbar that has SizeToFit set to true." "" yes no "" no "" "" no yes 668.7063
"BrowseColumnAutoCompletions" 436.7063 1 "CHR(5) delimited list specifying if the auto-completion attribute for the combo-box. The following are the possible values:

? (Null): The column is not a combo-box; or if the column is a combo-box, the auto-completion attribute value is set to the default.

y (yes): The column is a combo-box and its auto-completion attribute is set to TRUE.

n (no):  The column is a combo-box and its auto-completion attribute is set to FALSE." "" no no "" no "" "" no yes 3301.74251
"BrowseColumnBGColors" 436.7063 1 "CHR(5) list of browse column BGCOLORS" "" no no "" no "" "" no yes 14645.409
"BrowseColumnDelimiters" 436.7063 1 "CHR(5) delimited list containing the delimiters for the combo-box list-items" "" no no "" no "" "" no yes 3265.74251
"BrowseColumnFGColors" 436.7063 1 "CHR(5) list of browse column FGColors" "" no no "" no "" "" no yes 14643.409
"BrowseColumnFonts" 436.7063 1 "CHR(5) list of fonts for browser columns" "" no no "" no "" "" no yes 14656.409
"BrowseColumnFormats" 436.7063 1 "CHR(5) list of dynamic browse column formats" "" no no "" no "" "" yes yes 14801.409
"BrowseColumnInnerLines" 436.7063 1 "CHR(5) delimited list specifying the inner lines for a combo-box. The following are the possible values:

? (Null)=The column is not a combo-box; or if the column is a               combo-box, the inner-lines value is set to the default of five.
n: any integer number." "" no no "" no "" "" no yes 3292.74251
"BrowseColumnItemPairs" 436.7063 1 "CHR(5) delimited list with the LIST-ITEM-PAIRS for a combo-box" "" no no "" no "" "" no yes 3271.74251
"BrowseColumnItems" 436.7063 1 "CHR(5) delimited list with the LIST-ITEMS for a combo-box" "" no no "" no "" "" no yes 3268.74251
"BrowseColumnLabelBGColors" 436.7063 1 "CHR(5) list of BGCOLORs from browse column labels" "" no no "" no "" "" no yes 14652.409
"BrowseColumnLabelFGColors" 436.7063 1 "CHR(5) list of FGCOLORs for browse column labels" "" no no "" no "" "" no yes 14650.409
"BrowseColumnLabelFonts" 436.7063 1 "CHR(5) list of fonts for browse column labels" "" no no "" no "" "" no yes 14654.409
"BrowseColumnLabels" 436.7063 1 "CHR(5) Delimited list of browser labels" "" no no "" no "" "" no yes 14633.409
"BrowseColumnMaxChars" 436.7063 1 "CHR(5) delimited list specifying the maximum number of characters that the combo-box widget can hold.

? (Null): The column is not a combo-box; or if the column is a combo-box, the max-chars value is set to the default.

n: any integer number." "" no no "" no "" "" no yes 3298.74251
"BrowseColumnSorts" 436.7063 1 "CHR(5) delimited list specifying if the combo-box items are sorted. The following are the possible values:

? (Null): The column is not a combo-box; or if the column is a combo-box, the sort attribute value is set to the default.

y (yes): The column is a combo-box and its items are sorted.
n (no):  The column is a combo-box and its items are not sorted." "" no no "" no "" "" no yes 3295.74251
"BrowseColumnTypes" 436.7063 1 "CHR(5) delimited list containing the column type. Possible values are:

?=default value set to FILL-IN
FI=FILL-IN
DD=DROP-DOWN combo-box
DDL=DROP-DOWN-LIST combo-box
TB=TOGGLE-BOX" "" no no "" no "" "" no yes 3262.74251
"BrowseColumnUniqueMatches" 436.7063 1 "CHR(5) delimited list specifying if the unique-match attribute for the combo-box. The following are the possible values:

? (Null): The column is not a combo-box; or if the column is a combo-box, the unique-match attribute value is set to the default.
y (yes): The column is a combo-box and its unique-match attribute is set to TRUE.
n (no):  The column is a combo-box and its unique-match attribute is set to FALSE." "" no no "" no "" "" no yes 3304.74251
"BrowseColumnWidths" 436.7063 1 "CHR(5) list of browse column widths (integer values only)" "" no no "" no "" "" no yes 14648.409
"BrowseContainer" 434.7063 10 "" "" yes no "" no "" "" no yes 594.7063
"BrowseFieldDataTypes" 1005095447.101 1 "Dynamic Lookup Data types of fields to display in lookup browser, comma list." "" no no "" no "" "" no no 1005089877.28
"BrowseFieldFormats" 1005095447.101 1 "Dynamic Lookup Formats of fields to display in lookup browser, comma list. (Default Formats)" "" no no "" no "" "" no no 1005089878.28
"BrowseFields" 1005095447.101 1 "Dynamic Lookup Fields to display in lookup browser, comma list of table.field." "" no no "" no "" "" no no 1005089876.28
"BrowseHandle" 436.7063 10 "The handle of the browse control." "" yes no "" no "" "" no yes 470.7063
"BrowseInitted" 436.7063 3 "TRUE if the SmartBrowse has been initialized." "" yes no "" no "" "" no yes 472.7063
"BrowseObject" 434.7063 10 "" "" yes no "" no "" "" no yes 596.7063
"BrowseProcedure" 1005095447.101 1 "The name of the browser to use for lookup" "" no no "" no "" "" no yes 1005089890.28
"BrowseTitle" 1005095447.101 1 "Title for lookup browser for Dynamic Lookups." "" no no "" no "" "" no yes 1005089879.28
"BrowseWindowProcedure" 1005095447.101 1 "The name of the window to display the browse on for Dynamic Lookups" "" no no "" no "" "" no yes 1005089889.28
"BUFFER-CHARS" 1005078412.09 4 "" "" no no "" no "" "" no no 1005099297.101
"BUFFER-LINES" 1005078412.09 4 "" "" no no "" no "" "" no no 1005099298.101
"BufferHandles" 154.7063 1 "Comma-separated list of the handles of the query buffers." "" yes no "" no "" "" no yes 511.7063
"BuildSequence" 1005095447.101 4 "The sequence number in which the Dynamic Combo's data should be build." "SET" no no "" no "" "" no yes 1005115831.101
"BusinessEntity" 152.7063 1 "Defines the logical name of the Business Entity that the DataView operates on. The realization of the Business Entity is the responsibility of the data request service accessed through the Service Adapter. The ADM expects the service to return and accept Business Entity data as dataset references and has no requirement to how or where the Business Entity is realized." "" no no "" no "" "" no yes 68842.66
"ButtonCount" 438.7063 4 "The number of buttons in a SmartPanel, for resizeObject." "" yes no "" no "" "" no yes 658.7063
"ButtonHandle" 434.7063 10 "" "" yes no "" no "" "" no yes 592.7063
"CacheDuration" 152.7063 4 "Specifies the number of seconds the cache is valid. Any value gt than 0 is a directive to use caching while 0 means don't cache. A value of ? or -1 indicates that the data is valid throughout the session. The duration is applied when no instances are using the cached data. New instances that has ShareData set to true will disregard this property if another instance still is running. The property applies to a client proxy running against a stateless appserver or when ForceClientProxy = yes." "" no no "" no "" "" no yes 55429.66
"CalcFieldList" 154.7063 1 "A comma-separated list of calculated field instance names and their master object names.  This is for use by the AppBuilder at design time and should not be used by application code.

Value format:

<InstaneName>,<MasterName>,..." "" no no "" no "" "" no yes 13081.5498
"CalcWidth" 436.7063 3 "Determines whether the width of the browse is calculated to the exact width it should be for the fields it contains." "" no no "" no "" "" no yes 474.7063
"CallerObject" 347.7063 10 "" "" yes no "" no "" "" no yes 404.7063
"CallerProcedure" 347.7063 10 "" "" yes no "" no "" "" no yes 402.7063
"CallerWindow" 347.7063 10 "" "" yes no "" no "" "" no yes 400.7063
"CANCEL-BUTTON" 1005078412.09 3 "A button widget in the frame or dialog box to receive the CHOOSE event when a user cancels the current frame or dialog box by pressing the ESC key." "" no no "" no "" "" no no 785.7692
"CancelBrowseOnExit" 434.7063 3 "Set to true if the value in the browse is NOT to be selected on Exit.
This setting should probably be set to true when ExitBrowseOnAction also is true. Because when the user Exits the browse when a value is selected the close button can function as a Cancel." "" no no "" no "" "" no yes 600.7063
"CanFilter" 1005078412.09 3 "Set to FALSE if this field should not be used to filter the data object query." "" no no "" no "" "" no yes 32986.66
"CanSort" 1005078412.09 3 "Set to FALSE if this field should not be used to sort the data object query." "" no no "" no "" "" no yes 32984.66
"CascadeOnBrowse" 428.7063 3 "Determines whether data will be retrieved from a dependent SDO if the parent SDO has more than one row in its current dataset; if TRUE (the default), data will be retrieved for the first row in the parent dataset, otherwise not." "" no no "" no "" "" no yes 450.7063
"ChangedEvent" 434.7063 1 "Stores an optional event to publish on value-changed.
The developer must make sure to define the corresponding SUBSCRIBE, usually in the SmartDataViewer container ." "" no no "" no "" "" no yes 570.7063
"Chars" 1005098168.101 1 "The number of characters in an editor. This is denominated in units as
determined by the SizeUnits attribute value." "" no no "" no "" "" no no 1005098170.101
"CheckCurrentChanged" 152.7063 3 "Indicates whether the DataObject should check if database record(s) have been changed since read, before doing an update." "" no no "" no "" "" no yes 1003183466
"CHECKED" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099329.101
"CheckLastOnOpen" 154.7063 3 "Flag indicating whether a get-last should be performed on an open in order for fetchNext to be able to detect that we are on the last row. This is necessary to make the QueryPosition 
attribute reliable." "" no no "" no "" "" no yes 521.7063
"ChildDataKey" 5.7063 1 "" "" no no "" no "" "" no yes 66.7063
"ClassName" 3000002003.09 1 "The name of the Repository class that an object belongs to. This may differ from the value of the ObjectType property." "" yes no "" no "" "" no yes 66854.48
"ClientID" 731.7063 1 "The Client ID for the JMS broker connection." "" no no "" no "" "" no yes 898.7063
"ClientNames" 347.7063 1 "Lst that corresponds to InstanceNames, with the proxy's ObjectName on the client.
It is set in a server side container, so that containedProperties and assignContainedProperties can receive and return properties to and from a client with a different container structure.
This is required in the dynamic server container, which constructs server side objects for all data objects in the caller container tree, without recreating the child-containers that are not QueryObjects." "" yes no "" no "" "" no yes 418.7063
"CLOBColumns" 154.7063 1 "A comma-separated list of the DataObject's CLOB data-type columns." "GET" yes no "" no "" "" no yes 53554.66
"ColorErrorBG" 7.7063 4 "Stores error background color number for use by the highlightWidget function.  Should match entry in the color table." "" no no "" no "" "" no no 9927.009
"ColorErrorFG" 7.7063 4 "Stores error foreground color number for use by the highlightWidget function.  Should match entry in the color table." "" no no "" no "" "" no no 9925.009
"ColorInfoBG" 7.7063 4 "Stores information background color number for use by the highlightWidget function.  Should match entry in the color table." "" no no "" no "" "" no no 9917.009
"ColorInfoFG" 7.7063 4 "Stores information foreground color number for use by the highlightWidget function.  Should match entry in the color table." "" no no "" no "" "" no no 9919.009
"ColorWarnBG" 7.7063 4 "Stores warning background color number for use by the highlightWidget function.  Should match entry in the color table." "" no no "" no "" "" no no 9921.009
"ColorWarnFG" 7.7063 4 "Stores warning foreground color number for use by the highlightWidget function.  Should match entry in the color table." "" no no "" no "" "" no no 9923.009
"COLUMN" 1005078412.09 5 "Column position. This may currently be used when rendering some objects. There is no getColumns function, use getCol to retrieve the realized value from an object." "" no no "" no "" "" no no 1005078421.09
"COLUMN-MOVABLE" 1005078412.09 3 "Browse columns can be moved at run-time" "" no no "" no "" "" no no 14635.409
"COLUMN-RESIZABLE" 3000002003.09 3 "Browse columns can be resized at run-time" "" no no "" no "" "" no no 14637.409
"COLUMN-SCROLLING" 1005078412.09 3 "Browse column scrolling attribute" "" no no "" no "" "" no no 14639.409
"ColumnFormat" 1005095447.101 1 "Dynamic Lookup browse column format override - comma list." "" no no "" no "" "" no no 1005089895.28
"ColumnLabel" 3000002003.09 1 "WidgetAttributes ColumnLabel" "" no no "" no "" "" no no 3000000341.09
"ColumnLabels" 1005095447.101 1 "Dynamic Lookup browse override labels - comma list" "" no no "" no "" "" no no 1005089894.28
"ColumnNumber" 3000002003.09 4 "The column number of the widget" "" no no "" no "" "" no no 1005093795.101
"COLUMNS" 1005078412.09 4 "" "" no no "" no "" "" no no 1005099309.101
"ColumnSequence" 3000002003.09 4 "The sequence number of the widget within a column" "" no no "" no "" "" no no 1005093796.101
"ColumnsMovable" 436.7063 3 "Determines whether the browser's columns are movable" "SET" no no "" no "" "" no yes 263.009
"ColumnsSortable" 436.7063 3 "Determines whether the browser's columns are sortable" "SET" no no "" no "" "" no yes 271.009
"ComboDelimiter" 1005095447.101 1 "" "SET" no no "" no "" "" no yes 831.7063
"ComboFlag" 1005095447.101 1 "Optional Dynamic Combo flags - Contains 'A' for <All> or 'N' for <None> - Blank will indicate that no extra option should be added to combo." "SET" no no "" no "" "" no no 1005111017.101
"ComboFlagValue" 1005095447.101 1 "The value for the optional Dynamic Combo flags <All> and <None>" "" no no "" no "" "" no no 1005114147.101
"ComboHandle" 1005095447.101 10 "" "" yes no "" no "" "" no yes 837.7063
"ComboSort" 1005095447.101 1 "YES or NO to set a Dynamic Combo's COMBO-BOX sort option." "" no no "" no "" "" no no 1005111019.101
"CommitSource" 152.7063 10 "The handle of CommitSource object" "" yes no "" no "" "" no yes 180.7063
"CommitSourceEvents" 152.7063 1 "The list of events this object subscribes to in its Commit-Source" "" no no "Class" no "" "" no yes 186.7063
"CommitTarget" 152.7063 1 "The handle of the object's CommitTarget, in character form" "" yes no "" no "" "" no yes 182.7063
"CommitTargetEvents" 152.7063 1 "The list of events this object subscribes to in its Commit-Target" "" no no "Class" no "" "" no yes 184.7063
"ContainedAppServices" 347.7063 1 "List of the Appservices of the Data Objects contained in this container.
The container class uses this to manage dataobjects in the stateless server side APIs." "" yes no "" no "" "" no yes 422.7063
"ContainedDataColumns" 428.7063 1 "List of all the DataColumns of all the DataObjects in this SBO.
The list of columns for each contained Data Object is comma-delimited, with a semicolon between lists for each Data Object (in the same order as the ContainedDataObjects property)." "" yes no "" no "" "" no yes 442.7063
"ContainedDataObjects" 347.7063 1 "List of the handles of the Data Objects contained in this object.
The container class uses this to keep track of the dataobjects in 
the stateless server side APIs. 
The sbo class uses it on both client and server in almost all logic
also at design time to get names and column lists from the 
individual Data Objects." "" yes no "" no "" "" no yes 420.7063
"ContainerHandle" 5.7063 10 "The widget handle of this object's Window or Frame container" "" yes no "" no "" "" no yes 25.7063
"ContainerHidden" 5.7063 3 "Flag indicating whether this object's *parent* container is hidden.
This function also sets the ObjectHidden property, because when a container is hidden or viewed, hideObject and viewObject are not run in the contained objects, since they are hidden implicitly when the container is hidden. However, code in various places checks the ObjectHidden property, and this needs to be set to match ContainerHidden. ContainerHidden is not referenced in the ADM code, and is preserved for compatibility." "" yes no "" no "" "" no yes 29.7063
"ContainerMode" 347.7063 1 "" "" no no "" no "" "" no yes 1003585204
"ContainerSource" 5.7063 10 "The handle of this object's ContainerSource, if any.
'Set' for this property should be run only from add/removeLink and modifyListProperty.
It's needed because the callers get a variable link name for which {set} can't be used." "" yes no "" no "" "" no yes 39.7063
"ContainerSourceEvents" 5.7063 1 "A comma-separated list of the events this object needs to subscribe to in its ContainerSource." "" no no "Class" no "" "" no yes 41.7063
"ContainerTarget" 347.7063 1 "A comma-separated list of the handles of this object's contained objects.
It should be modified using modifyListProperty, and is normally maintained by 'addLink'." "" yes no "" no "" "" no yes 351.7063
"ContainerTargetEvents" 347.7063 1 "A comma-separated list of the events this object needs to subscribe to in its ContainerTarget
" "" no no "Class" no "" "" no yes 353.7063
"ContainerToolbarSource" 347.7063 1 "A comma-separated list of the handle(s) of the object's containertoolbar-source" "" yes no "" no "" "" no yes 453.5498
"ContainerToolbarSourceEvents" 347.7063 1 "The list of events to be subscribed to in the ContainerToolbar-Source" "" no no "Class" no "" "" no yes 455.5498
"ContainerToolbarTarget" 430.7063 1 "The handle of the object's containertoolbar-target. This may be a
delimited list of handles." "" yes no "" no "" "" no yes 449.5498
"ContainerToolbarTargetEvents" 430.7063 1 "The list of events to be subscribed to in the ContainerToolbar-target." "" no no "Class" no "" "" no yes 451.5498
"ContainerType" 5.7063 1 "The Type of Container which this SmartObject is --
blank if the object is not a container, otherwise ""WINDOW"" for
a SmartWindow , ""FRAME"" for a SmartFrame." "" yes no "" no "" "" no yes 19.7063
"ContainerWidgetIDs" 1005097792.101 1 "Comma sepparated list that stores the container names and their widget-id values.
Container names and widget-ids are created using the Runtime Widget-id assignment tool'." "" no no "" no "" "" no no 4781.84251
"CONTEXT-HELP-ID" 1005078412.09 4 "" "" no no "" no "" "" no no 1005099306.101
"CONVERT-3D-COLORS" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099322.101
"CreateHandles" 9.7063 1 "A comma-separated list of the handles of the fields in the data visualization object which should be enabled for an Add or Copy operation." "" yes no "" no "" "" no yes 104.7063
"CreateSubMenuOnConflict" 430.7063 3 "Yes - Create a submenu when a band already has linked actions for another toolbar. 
No - Insert conflicting bands" "" no no "" no "" "" no yes 47333.66
"CurrentMessage" 507.49 10 "Stores the handle to the current message." "" yes no "" no "" "" no yes 924.7063
"CurrentMessageId" 509.49 1 "The Current Message Id holds the id from the last sendMessage 
with ReplyRequired." "" yes no "" no "" "" no yes 922.7063
"CurrentPage" 347.7063 4 "The current page number of the Container" "" yes no "" no "" "" no yes 349.7063
"CurrentQueryString" 1005095447.101 1 "" "" no no "" no "" "" no yes 827.7063
"CurrentRowid" 152.7063 9 "Current ROWID of the RowObject query." "" yes no "" no "" "" no yes 174.7063
"CurrentUpdateSource" 152.7063 10 "The current updateSource.
This is just set temporarily in updateState before re-publishing updateState, so that the updateSource/DataTarget can avoid a  republish when it is the original publisher." "" yes no "" no "" "" no yes 178.7063
"CURSOR-CHAR" 1005078412.09 4 "" "" no no "" no "" "" no no 1005099278.101
"CURSOR-LINE" 1005078412.09 4 "" "" no no "" no "" "" no no 1005099277.101
"CURSOR-OFFSET" 1005078412.09 4 "" "" no no "" no "" "" no no 1005099276.101
"CustomSuperProc" 432.7063 1 "A custom super procedure for the object." "" yes no "" no "" "" no yes 560.7063
"DATA-TYPE" 1005078412.09 1 "WidgetAttributes Data-Type" "" no no "" no "" "" no no 1005078413.09
"DatabaseName" 3000002003.09 1 "WidgetAttributes DataBaseName" "" no no "" no "" "" no no 1005078711.09
"DataColumns" 428.7063 1 "A list of all the DataColumns of all the Data Objects in this SBO, each qualified by the SDO ObjectName.
The list of columns for each contained Data Object is comma-delimited, and qualified by Object Names, as an alternative to the ContainedDataColumns form of the list which divides the list by SDO." "" no no "" no "" "" no yes 446.7063
"DataColumnsByTable" 154.7063 1 "A comma-delimited list of the columnNames separated
by CHR(1) to identify groups of columns that belong to the same table. If grouping is not required, use DataColums to get a comma separated summary list." "" no no "" no "" "" no yes 507.7063
"DataContainer" 347.7063 3 "Indicates whether or not this container is a Data Container." "" no no "" no "" "" no yes 424.7063
"DataContainerName" 152.7063 1 "The DataContainerName is passed to getManagerHandle to start the DataContainer for an instance. The DataContainer and the Service Adpater has a one-to-one relationship. This property allows applications to run in the same session with separate Service Adapters. This might be necessary if Business Entity references need different namepaces because the applications have been developed separately." "" no no "" no "" "" no yes 90725.66
"DataDelimiter" 152.7063 1 "The delimiter to use for data values passed to the registered DataReadHandler when traversing the query." "" no no "" no "" "" no yes 200000003010.66
"DataFieldDefs" 152.7063 1 "The name of the include file in which the field definitions for this SDO's RowObject table are stored" "" yes no "Master" no "" "" no yes 204.7063
"DataHandle" 152.7063 10 "The handle to the temp-table (RowObject) query" "" yes no "" no "" "" no yes 170.7063
"DataIsFetched" 428.7063 3 "The SBO sets this to true in the SDO when it has fethed  data on the SDOs behalf in order to prevent that the SDO does 
another server call to fetch the data it already has. 
This is checked in query.p dataAvailable and openQuery is skipped if its true. It's immediately turned off after it is checked." "" yes no "" no "" "" no yes 468.7063
"DataLinksEnabled" 5.7063 3 "Not in use" "" no no "" no "" "" no yes 70.7063
"DataLogicObject" 152.7063 10 "The handle of the logic procedure that contains business logic for the data object." "" yes no "" no "" "" no yes 200000003004.66
"DataLogicProcedure" 152.7063 1 "The name of the logic procedure that contains business logic for the data object." "SET" no no "Master" no "" "" no yes 200000003002.66
"DataModified" 9.7063 3 "Indicates whether the current SCREEN-VALUES have been modified but not saved.
This property is set when the user modifies some data on the screen." "set" yes no "" no "" "" no yes 96.7063
"DataObject" 608.7063 1 "The name of the filter used at design time." "" no no "" no "" "" no yes 614.7063
"DataObjectNames" 428.7063 1 "Ordered list of ObjectNames of contained SDOs.
It is normally changed through the SBO Instance Property Dialog. Change only after the Object names for the SDOs within the SBO have been set.
Must be run to retrieve the value so that it can check whether the value is still valid, which may not be the case if objects have been removed, added, or replaced since the SBO was last saved. If it no longer matches the list of contained SDOs, then it is blanked and the default value recalculated." "get" no no "" no "" "" no yes 444.7063
"DataObjectOrdering" 428.7063 1 "Mapping of the order of Update Tables as generated by the AppBuilder to the developer-defined update order." "" no no "" no "" "" no yes 454.7063
"DataQueryBrowsed" 152.7063 3 "TRUE if this SmartDataObject's Query is being browsed by a SmartDataBrowser.
This is used to prevent two SmartDataBrowsers from attempting to browse the same query, which is not allowed because conflicts would occur." "set" yes no "" no "" "" no yes 190.7063
"DataQueryString" 152.7063 1 "The string used to prepare the RowObject query." "" no no "" no "" "" no yes 172.7063
"DataReadBuffer" 152.7063 10 "Specifies a buffer for the receive event. This buffer will only have one record and be used as a transport buffer for data from the data object to the ReadEventHandler's receiveBuffer event procedure" "" yes no "" no "" "" no yes 116
"DataReadColumns" 152.7063 1 "A comma-separated list of columns to pass to the registered DataReadHandler when traversing the query." "" no no "" no "" "" no yes 200000003008.66
"DataReadFormat" 152.7063 1 "Specifies the format for read event and updateData and createData APIs. 
-  Blank =  No formatting, just buffer values 
- 'Formatted' =  Formatted according to the columnFormat with right
                        justified numeric values.
- 'TrimNumeric' =  Formatted according to the columnFormat with LEFT 
                            justified numeric data" "" no no "" no "" "" no yes 114
"DataReadHandler" 152.7063 10 "The handle of a procedure that has been registered to receive 
output from the object." "" yes no "" no "" "" no yes 200000003006.66
"DataSetName" 152.7063 1 "Defines an instance name in the container for the DataSet that manages the prodataset the DataView operates on. Defaults to the BusinessEntity. Can be set to allow multiple instances of a DataSet for the same Business Entity." "" no no "" no "" "" no yes 68844.66
"DataSetSource" 152.7063 10 "The handle of the DataSet object that manages the prodataset for this object." "" yes no "" no "" "" no yes 68847.66
"DataSource" 5.7063 10 "WidgetAttributes DataSource" "" yes no "" no "" "" no yes 1005109051.101
"DataSourceEvents" 5.7063 1 "A comma-separated list of the events this object needs to subscribe to in its DataSource.
Because this is a comma-separated list, it should normally be
invoked indirectly, through 'modifyListProperty'" "" no no "Class" no "" "" no yes 44.7063
"DataSourceFilter" 434.7063 1 "An optional filter expression for the data-source." "" no no "" no "" "" no yes 572.7063
"DataSourceName" 3000002003.09 1 "Specifies the DataSource by name. The specified object will be started and linked as the DataSource of this object at runtime. The property will  be ignored if a data-source link to a DataObject instance is specified." "" no no "" no "" "" no yes 1005104898.101
"DataSourceNames" 5.7063 1 "Stores the ObjectName of the Data Object that sends data to this object. This would be set if the data-Source is an SBO or other Container with DataObjects.
See the SBOs addDataTarget for more details on how this is set." "" no no "" no "" "" no yes 1004945563.09
"DataTable" 152.7063 1 "The physical name of the temp-table that is being navigated, viewed and/or updated.  Can also define a view to other temp-tables when a prodataset defines the temp-table." "" no no "" no "" "" no yes 68810.66
"DataTarget" 5.7063 1 "The DataTarget object handle, normally for pass-through support.
Because this can be a list, it should normally be changed using
'modifyListProperty'." "" yes no "" no "" "" no yes 55.7063
"DataTargetEvents" 5.7063 1 "A comma-separated list of events to subscribe to.
Normally modifyListProperty should be used to ADD or REMOVE 
events from this list." "" no no "Class" no "" "" no yes 57.7063
"DataValidationOperator" 1005078412.09 1 "Specifies the operator used to validate the value against the DataValidationValue. Currently supported values are RANGE, BEGINS and MATCHES." "" no no "" no "" "" no yes 32992.66
"DataValidationValue" 1005078412.09 1 "Specifies valid value(s) for the field. The DataValidationOperator specifies 
the validation expression." "" no no "" no "" "" no yes 32994.66
"DataValue" 432.7063 1 "Holds the value of the SmartDataField." "get,set" yes no "" no "" "" no yes 551.7063
"DBAware" 5.7063 3 "Flag indicating whether this object is dependent on being connected to a database or not, to allow some code to execute two different ways (for DataObjects, e.g.)" "" no no "" no "" "" no yes 50.7063
"DBNames" 154.7063 1 "Comma-separated list of the database names associated with the query buffers. Used actively in all column functions to be able to resolve calls that are qualified differently than the design time setting. The mandatory use of the get function is to ensure that the client side data object calls the server if the value is not present, which only will be the case if the get function is called before initialization as this is one of the 'first-time' attributes.  Qualify properly before init !" "get" yes no "" no "" "" no yes 513.7063
"DCOLOR" 1005078412.09 4 "" "" no no "" no "" "" no no 1005099287.101
"DeactivateTargetOnHide" 438.7063 3 "The string used to prepare the RowObject query" "" no no "" no "" "" no yes 1779.66
"DEBLANK" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099317.101
"DEFAULT" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099324.101
"DefaultCharWidth" 608.7063 5 "Defalt width for character fields." "" no no "" no "" "" no yes 632.7063
"DefaultColumnData" 436.7063 1 "Stores default column positions and sizes to support reset" "" yes no "" no "" "" no yes 261.009
"DefaultEditorLines" 608.7063 4 "The default inner-lines for editor fields.
Editors are used for fields with word-index." "" no no "" no "" "" no yes 636.7063
"DefaultHeight" 608.7063 5 "" "" no no "" no "" "" no yes 634.7063
"DefaultLayout" 7.7063 1 "The default layout name for this object." "" no no "Class" no "" "" no yes 80.7063
"DefaultValue" 1005078412.09 1 "Specifies the default value for a new record. This can be any value that matches the field's data type as well as TODAY for date fields." "" no no "" no "" "" no yes 33010.66
"DefaultWidth" 608.7063 5 "Defualt width for fields that are non-char." "" no no "" no "" "" no yes 630.7063
"DefineAnyKeyTrigger" 434.7063 3 "Set to true if a persistent trigger is to be defined on ANY-KEY.
Only used for the fill-in that are generated for the view-as browse 
option." "" no no "" no "" "" no yes 604.7063
"DELIMITER" 1005078412.09 1 "" "" no no "" no "" "" no no 1005099335.101
"DeployData" 36427.48 3 "If set to yes, then data in this table needs to be deployed.

Whether data has changed and needs to be deployed is identified by the existence of records in the gst_record_version table for this entity.

What data gets deployed and how it relates to other data is specified via setting up deployment datasets." "" yes no "" no "" "" no no 36433.48
"DescSubstitute" 1005095447.101 1 "The field substitution list for Dynamic Combos" "SET" no no "" no "" "" no no 1005111016.101
"DesignDataObject" 5.7063 1 "The name of the design time SDO for objects that need SDO data but cannot be linked." "" no no "" no "" "" no yes 52.7063
"Destination" 509.49 1 "The Destination for the current message" "" no no "" no "" "" no yes 912.7063
"DestinationList" 515.49 1 "The list of Destinations this B2B uses as a producer." "" no no "" no "" "" no yes 841.7063
"Destinations" 505.49 1 "Stores the Destinations (Topics or Queues) this consumer can 
receive messages from." "" no no "" no "" "" no yes 874.7063
"DestroyStateless" 152.7063 3 "Defines if the persistent SDO should be destroyed on stateless requests." "" no no "" no "" "" no yes 1003183472
"DirectionList" 515.49 1 "The list of Directions this B2B uses" "" no no "" no "" "" no yes 843.7063
"DISABLE-AUTO-ZAP" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099314.101
"DisabledActions" 438.7063 1 "A comma separated list of disabled actions.
- The actions will be immediately disabled and subsequent calls 
to enableActions will not enable them again. This makes it 
possible to permanently disable actions independent of state 
changes.
- If you remove actions from the list they will be enabled the next
time enableActions is used on them.
- Use the modifyDisabledActions to add or remove actions." "" no no "" no "" "" no yes 181
"DisabledAddModeTabs" 347.7063 1 "" "" yes no "" no "" "" no yes 406.7063
"DisableOnInit" 7.7063 3 "Flag indicating whether the object should be disabled when it's first realized." "" no no "" no "" "" no yes 1003183449
"DisableStates" 1003183341 1 "" "" no no "" no "" "" no yes 1003202028
"DisconnectAppServer" 152.7063 3 "Should the persistent SDO disconnect the AppServer.  
This is only used for stateless WebSpeed SDO's that are never destroyed" "" no no "" no "" "" no yes 1003183474
"DisplayDataType" 1005095447.101 1 "Datatype of Dynamic Lookup display field." "" no no "" no "" "" no yes 1005089873.28
"DisplayedField" 1005095447.101 1 "For Dynamic Lookups. The name of the field being displayed from the query. (Table.Field). For Dynamic Combo's a comma seperated list of table.field name of the fields to be displayed as description values in the combo-box." "" no no "" no "" "" no yes 1005089864.28
"DisplayedFields" 9.7063 1 "A comma-separated list of the columns displayed by the visualization object." "" no no "" no "" "" no yes 1003466914
"DisplayedTables" 9.7063 1 "The list of SDO table names used by the visualization.
May be just ""RowObject"" or if the object was built against an SBO, will be the list of SDO ObjectNames whose fields are used." "" no no "Class" no "" "" no yes 126.7063
"DisplayField" 432.7063 3 "This property determines whether the field is to be displayd
along with other fields in its Container." "" no no "" no "" "" no yes 1005078597.09
"DisplayFormat" 1005095447.101 1 "Format of Dynamic Lookup/Dynamic Combo display field. In the case of the Dynamic Combo, if more than one field is being displayed in the combo-box - the default value must always be CHARACTER" "" no no "" no "" "" no yes 1005089872.28
"DisplayValue" 432.7063 1 "Holds the saved screen/display value of the SmartDataField." "" no no "" no "" "" no yes 553.7063
"DocTypeList" 515.49 1 "The list of Document Types this B2B uses." "" no no "" no "" "" no yes 845.7063
"DocumentElement" 511.49 1 "The Id of the root element" "get" no no "" yes "" "" no yes 944.7063
"DocumentHandle" 511.49 10 "The handle of the current document." "" yes no "" no "" "" no yes 942.7063
"Domain" 731.7063 1 "The domain for messages being sent.
Once a session has been started, the messaging Domain cannot change." "" no no "" no "" "" no yes 900.7063
"DRAG-ENABLED" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099337.101
"DROP-TARGET" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099307.101
"DTDPublicId" 511.49 1 "The Public Id of the next document that is being created.
This property is stored until a document is produced. 
It will then be used as the DTD publicId in the call to the 
nitialize-document-type method. This method MUST run as soon 
as the document is created. 
The get version of this property will return the adm property when DocumentInitialized is false, but otherwise read from the actual document PUBLIC-ID." "get,set" no no "" no "" "" no yes 946.7063
"DTDPublicIdList" 515.49 1 "Stores a CHR(1) separated list of DTD PublicIds for producer. 
If this or DTDSystemId is defined, a DTD reference will be produced instead of an XML namespace." "" no no "" no "" "" no yes 847.7063
"DTDSystemId" 511.49 1 "The System Id of the next document that is being created.
This property is stored until a document is produced. 
It will then be used as the DTD SystemId in the call to the 
initialize-document-type method. This method MUST run as soon as the document is created. 
The get version of this property will return the adm property when DocumentInitialized is false, but otherwise read from the actual document System-ID." "get,set" no no "" no "" "" no yes 948.7063
"DTDSystemIdList" 515.49 1 "Stores a CHR(1) separated list of DTD SystemIds for producer. 
If this or DTDPublicId is defined, a DTD reference will be produced instead of an XML namespace." "" no no "" no "" "" no yes 849.7063
"DynamicData" 152.7063 3 "Indicates whether the data management temp-tables (RowObject, RowObjUpd) are static or dynamic." "" yes no "" no "" "" no yes 40001.7063
"DynamicObject" 1003183341 3 "Whether an object ins a dynamic object.." "" no no "" no "" "" no no 1005109093.101
"DynamicSDOProcedure" 347.7063 1 "The name of the dynamic SDO procedure, 'adm2/dyndata.w'
by default.  Can be modified if the dynamic SDO is customized." "" no no "" no "" "" no yes 373.7063
"EDGE-CHARS" 1005078412.09 4 "" "" no no "" no "" "" no no 1005099326.101
"EDGE-PIXELS" 1005078412.09 4 "" "" no no "" no "" "" no no 1005099327.101
"EdgePixels" 430.7063 4 "" "" no no "" no "" "" no yes 1003498439
"EDIT-CAN-UNDO" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099305.101
"Editable" 9.7063 3 "Indicates whether this object can be edited (add/copy/save/update).
Used by the toolbar to indicate whether actions like add/copy etc. should be enabled." "GET" no no "" no "" "" no yes 94.7063
"ENABLED" 1005078412.09 3 "WidgetAttributes Enabled" "" no no "" no "" "" no no 1005078422.09
"EnabledField" 3000002003.09 1 "Whether the fields should be enabled" "" no no "" no "" "" no yes 1005078596.09
"EnabledFields" 9.7063 1 "A comma-separated list of the enabled fields (name) in this object which map to fields in the SmartDataObject." "" no no "" no "" "" no yes 1003466921
"EnabledHandles" 9.7063 1 "A comma-separared list of the handles of the enabled fields in the visualization object." "" yes no "" no "" "" no yes 102.7063
"EnabledObjFlds" 7.7063 1 "A comma-separated list of the field names of widgets enabled in this object NOT associated with data fields." "" no no "" no "" "" no yes 84.7063
"EnabledObjFldsToDisable" 9.7063 1 "This property decides whether non-db objects should be disabled/enabled 
when the fields are disabled. The supported values are:   
1. (All) - All EnabledObjects should be disabled in view mode
2. (None)  - All EnabledObjects should remain enabled when the                fields are disabled.  
3. Comma separated list of object names to disable/enable. 

? as repository value tells the get function to return default;  (All) for normal viewers and (none) for viewers with no db fields." "" no no "" no "" "" no yes 9071.66
"EnabledObjHdls" 7.7063 1 "A comma-separated list of the handles of widgets enabled in this object NOT associated with data fields" "" yes no "" no "" "" no yes 82.7063
"EnabledWhenNew" 9.7063 1 "A comma separated list of fields that only should be enabled in new mode.  Defaults to  unknown as a signal to set this from the UpdateTarget's UpdatableWhenNew property. The list can also be set and can also contain non data bound objects in a SmartDataViewer. Non data bound objects works if the objects also are defined in the EnabledObjFlds property and are specified to work as data fields in the EnabledObjFldsToDisable property." "GET" no no "" no "" "" no yes 100667.66
"EnableField" 432.7063 3 "TRUE if the SmartDataField is to be enabled for user input along with other fields in its Container, otherwise false.
This instance property is initialized by the AppBuilder in adm-create-objects." "" no no "" no "" "" no yes 1005101029.101
"ENableStates" 1003183341 1 "" "" no no "" no "" "" no no 1003202026
"EntityDbname" 36427.48 1 "This is the logical database name in which this table resides." "" yes no "" no "" "" no no 36486.48
"EntityDescriptionField" 36427.48 1 "The name of the description field for this entity. Armed with this information and the object number, we can dynamically return the description of any record in any table." "" yes no "" no "" "" no no 36456.48
"EntityDescriptionProcedure" 36427.48 1 "The name of a procedure to run in order to work out the description of the entity. This is only required in the event that the entity description spans multiple fields (potentially from related entities). If this field is specified, it will override the entity description field.

A relative path to the procedure must be included. The procedure written must take the object number as an input parameter, and output a single character string containing the object description." "" yes no "" no "" "" no no 36435.48
"EntityFields" 154.7063 1 "Comma separated list of fields that is to be read from the Entity Mnemonic table at run time. This list is currently set at start up based on CAN-FIND of related tables. Currently supported values are HasComment, HasAudit and AutoComment." "" yes no "" no "" "" no yes 549.7063
"EntityKeyField" 36427.48 1 "The name of the unique key field or fields for this entity. This should be a field or fields other than the object field that could be used to uniquely find information in this entity. This would often be used in lookups, etc. so the code and description can be displayed to the user.
If more than one field is necesarry to uniquely identify a record, the field names will be stored in a comma seperated list" "" yes no "" no "" "" no no 36437.48
"EntityMnemonic" 36427.48 1 "The code allocated to every table in the database that uniquely identifies the database table. This code is used when generically joining to tables, as the basis for naming conventions (e.g. a prefix to all objects that maintain this table), etc. 
This code is usually stored in the dump name of the table." "" yes no "" no "" "" no no 48711.48
"EntityMnemonicDescription" 36427.48 1 "This field should store the actual table name in full, e.g. gsm_user. The fact that this field contains the table name is relied upon within the framework." "" yes no "" no "" "" no no 36482.48
"EntityMnemonicLabelPrefix" 36427.48 1 "An optional prefix to selectively replace the first word of screen labels for fields in the associated table. This will primarily be used for tables in the framework to provide more meaningful labels.

For example a table gsm_region in a specfic application may be used for suburbs and have a label prefix of ""suburb"" rather than ""region"".

The label prefix will actually replace the first word in the field label defined on the database.

Where the table has more than one meaning, e.g. a gsm_" "" yes no "" no "" "" no no 36458.48
"EntityMnemonicShortDesc" 36427.48 1 "A short reference for the table used to lookup the table - this is a free text description" "" yes no "" no "" "" no no 36484.48
"EntityObjectField" 36427.48 1 "The name of the unique object field for this entity used to join to other tables. Usually this field is the same as the tablename without the 4 character prefix and ends in _obj. The datatype of this field should be a decimal with at least decimals 9. 

If left blank, then the above assumption will be used to find the object field where required.
" "" yes no "" no "" "" no no 36462.48
"ErrorConsumer" 731.7063 10 "" "" yes no "" no "" "" no yes 876.7063
"ExitBrowseOnAction" 434.7063 3 "TRUE if the selection of a value in the browse also should  Exit the browse.
The selection of a value is triggered by DEFAULT-ACTION 
 (RETURN or double-click )" "" no no "" no "" "" no yes 598.7063
"EXPAND" 1005078412.09 3 "When TRUE, horizontal Radio-Set expand labels to evenly space the buttons." "" no no "" no "" "" no no 13479.409
"ExpandOnAdd" 1005097792.101 3 "If Yes, nodes will always be expanded when added to node" "" no no "" no "" "" no yes 3507.66
"ExternalRefList" 513.49 1 "Stores the External References this router uses to determine
how external target namespaces map to internal XML mapping
schemas" "" no no "" no "" "" no yes 936.7063
"FetchAutoComment" 154.7063 3 "TRUE if auto comments flag should be retrieved with the data.
This is used in transferRows and transferDbRow .
These comments will be automatically displayed by visual objects and will be set to true by the visual object's LinkStateHandler if the property value is unknown." "" no no "" no "" "" no yes 547.7063
"FetchHasAudit" 154.7063 3 "TRUE if Audit exists flag should be retrieved with the data.
This is used in transferRows and transferDbRow ." "" no no "" no "" "" no yes 545.7063
"FetchHasComment" 154.7063 3 "TRUE if 'comments exists' flag should be retrieved with the data." "" no no "" no "" "" no yes 1130.7063
"FetchOnOpen" 154.7063 1 "- A blank value means don't fetch on open, any other value is just being run as fetch + <property value>
- Unknown value indicates default which is blank on 'server' and'first' otherwise.
- This is a replacement of the return that used to be in data.p 
fetchFirst. The blank gives the same effect as it prevents openQuery from calling fetchFirst." "" no no "" no "" "" no yes 541.7063
"FetchOnReposToEnd" 436.7063 3 "TRUE if the browse should fetch more data from the server to 
fill the batch when repositioing to the end of a batch.
This gives the correct visual appearance, but will require an 
additional request to the server." "" no no "" no "" "" no yes 503.7063
"FGCOLOR" 1005078412.09 4 "" "SET" no no "" no "DIALOG" "af/sup2/afspgetcow.w" no no 1005099283.101
"FieldColumn" 608.7063 5 "Stores the Column position of the fields" "" no no "" no "" "" no yes 638.7063
"FieldEnabled" 432.7063 3 "TRUE if the SmartDataField is enabled for user input, otherwise false.
This property is set from user-defined procedures enableField and disableField." "" no no "" no "" "" no yes 557.7063
"FieldFormats" 608.7063 1 "Stores the internal list of overridden fields and formats" "" yes no "" no "" "" no yes 644.7063
"FieldHandles" 9.7063 1 "A comma-separated list of Data Field handles in the visualization object" "" yes no "" no "" "" no yes 106.7063
"FieldHelpIds" 608.7063 1 "Stores the internal list of fields and helpids." "" yes no "" no "" "" no yes 652.7063
"FieldLabel" 1005095447.101 1 "Label for the Dynamic Lookup/Dynamic Combo field on the viewer." "" no no "" no "" "" no yes 1005089868.28
"FieldLabels" 608.7063 1 "Store the internal list of overridden fields and labels." "" yes no "" no "" "" no yes 648.7063
"FieldName" 432.7063 1 "The name of the associated SDO field this SmartDataField maps to. This is usually 'set' from the containing SmartDataViewer." "" no no "" no "" "" no yes 1005078709.09
"FieldNameSeparator" 36427.48 1 "The basis of identifying what is used to break up field names into words.
The framework standard is to separate fields with an underscore so this field would be set to ""_"".
Some database designs separate fields by uppercasing the first character of each word and in this case the value of this field would be ""upper""." "" yes no "" no "" "" no no 36464.48
"FieldPopupMapping" 1005095446.101 1 "Stores the mapping of field and object handles and their dynamically created popup handle. The list can be used directly, but is also used by functions that take the field name as input." "" yes no "" no "" "" no yes 34784.66
"FieldSecurity" 7.7063 1 "For viewers, this attribute contains a comma-separated list of the security type corresponding to AllFieldHandles. For browsers the list corresponds to DisplayedFields.
<security type>,<security type>...

" "" no no "" no "" "" no yes 86.7063
"FieldsEnabled" 9.7063 3 "Indicates whether the fields in this visualization object are enabled or not." "" no no "" no "" "" no yes 92.7063
"FieldSeparatorPxl" 608.7063 4 "" "" no no "" no "" "" no yes 642.7063
"FieldSpacingPxl" 608.7063 4 "" "" no no "" no "" "" no yes 640.7063
"FieldTooltip" 1005095447.101 1 "Tooltip for displayed Dynamic Lookup/Dynamic Combo field." "" no no "" no "" "" no no 1005089869.28
"FieldTooltips" 608.7063 1 "Stores the internal list of fields and TOOLTIPs" "" yes no "" no "" "" no yes 650.7063
"FieldWidgetIDs" 1005095446.101 1 "Comma separated list with the field name and its widget-id." "" no no "" no "" "" no yes 4686.84251
"FieldWidths" 608.7063 1 "Stores the internal list of overridden field widths." "" yes no "" no "" "" no yes 646.7063
"FillBatchOnRepos" 152.7063 3 "Sets the flag on or off which indicates whether 'fetchRowIdent'
will fetch enough rows to fill a batch when repositioning to (or near) the end of a dataset where an entire batch wouldn't be retrieved." "" no no "" no "" "" no yes 213.7063
"FILLED" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099325.101
"FilterActive" 428.7063 3 "Flag to indicate that filter is active.
'getFilterActive' also checks the  caller's DataTargetNames." "get" yes no "" no "" "" no yes 462.7063
"FilterAvailable" 428.7063 3 "Flag to indicate that filter is available." "set" yes no "" no "" "" no yes 460.7063
"FilterSource" 347.7063 10 "The handle of the Filter Source for Pass-through support." "" yes no "" no "" "" no yes 365.7063
"FilterTarget" 608.7063 1 "The linked filter object handle. Currently supports only one.
Use columnFilterTarget for a column." "" yes no "" no "" "" no yes 610.7063
"FilterTargetEvents" 608.7063 1 "A comma-separated list of the events this object needs to subscribe to in its FilterTarget." "" no no "Class" no "" "" no yes 612.7063
"FilterType" 436.7063 1 "" "" no no "" no "" "" no no 526.1713
"FilterWindow" 428.7063 1 "The name of the filter container, if any." "" no no "" no "" "" no yes 466.7063
"FirstResultRow" 152.7063 1 "Unknown if the first row has not been fetched.  Otherwise '1' concatenated with the rowid, if it has been fetched." "" yes no "" no "" "" no yes 192.7063
"FirstRowNum" 152.7063 4 "The temp-table row number of the first row" "" yes no "" no "" "" no yes 164.7063
"FIT-LAST-COLUMN" 1005078412.09 3 "Browse will fit last column to exactly fit in the browse.  This will result in the last field narrowing or expanding to fit." "" no no "" no "" "" no no 14641.409
"FlagValue" 1005095447.101 1 "Dynamic Combo. This field contains the default optional combo flag value for the <All> and <None> options. This allows the user to override the default values like . or 0." "SET" no no "" no "" "" no no 1005111018.101
"FLAT-BUTTON" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099323.101
"FlatButtons" 430.7063 3 "" "" no no "" no "" "" no yes 1003498425
"FolderFont" 3000002003.09 4 "Font for tabs" "" no no "" no "" "" no no 3483.66
"FolderLabels" 3000002003.09 1 "This attribute is used to store the FolderLabels when construct" "" no no "" no "" "" no no 1000000276.48
"FolderMenu" 3000002003.09 1 "SmartPak Folder" "" no no "" no "" "" no no 3495.66
"FolderTabHeight" 3000002003.09 5 "Height for tabs" "" no no "" no "" "" no no 3485.66
"FolderTabType" 1003183341 4 "" "" no no "" no "" "" no yes 1003202016
"FolderTabWidth" 3000002003.09 5 "Optional width for tabs" "" no no "" no "" "" no no 3484.66
"FolderType" 1003183341 1 "" "" no no "" no "" "" no no 528.1713
"FolderWidgetIDs" 3000002003.09 1 "Widget-ids for the folder pages." "" no no "" no "" "" no yes 4613.84251
"FolderWindowToLaunch" 436.7063 1 "If Dynamics is running, this property specifies a window to launch upon the occurence of toolbar events ""View"", ""Copy"", ""Modify"" or ""Add""." "" no no "" no "" "" no yes 1003466958
"FONT" 1005078412.09 4 "WidgetAttributes Font" "GET,SET" no no "" no "" "" no yes 1005099311.101
"ForeignFields" 154.7063 1 "A comma-separated list, consisting of thefirst local db fieldname, followed by the matching source temp-table field name, followed by more pairs if there is more than one field to match." "" no no "" no "" "" no yes 1003183462
"ForeignValues" 154.7063 1 "The values are character strings formatted according to the field format specification and they are separated by the CHR(1) character." "" yes no "" no "" "" no yes 519.7063
"FORMAT" 1005078412.09 1 "WidgetAttributes Format" "" no no "" no "" "" no no 1005078460.09
"FRAME" 1005078412.09 1 "" "" no no "" no "" "" no no 1005099310.101
"FrameMinHeightChars" 1005095446.101 5 "The calculated minimum height of the viewer's frame, in characters." "" no no "" no "" "" no no 1005109052.101
"FrameMinWidthChars" 1005095446.101 5 "The calculated minimum width of the viewer's frame, in characters." "" no no "" no "" "" no no 1005109053.101
"FrameWidgetID" 432.7063 4 "Widget-id of the field frame" "" no no "" no "" "" no yes 4689.84251
"FullRowSelect" 1005097792.101 3 "If yes, the entire row of the node is selected. If no, only the text is selected." "SET" no no "" no "" "" no yes 3508.66
"GenerationTemplate" 5.7063 1 "The template file used generate static objects." "" no no "Class" no "" "" yes yes 30000000030001.53733
"GRAPHIC-EDGE" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099328.101
"GROUP-BOX" 1005078412.09 3 "Whether a rectangle acts as a group-box or not." "" no no "" no "" "" no no 23002.5498
"GroupAssignSource" 9.7063 10 "" "" yes no "" no "" "" no yes 118.7063
"GroupAssignSourceEvents" 9.7063 1 "" "" no no "Class" no "" "" no yes 122.7063
"GroupAssignTarget" 9.7063 1 "" "" yes no "" no "" "" no yes 120.7063
"GroupAssignTargetEvents" 9.7063 1 "" "" no no "Class" no "" "" no yes 124.7063
"HasDBAwareObjects" 347.7063 3 "Tells whether the container has DBAware data objects or not. The value reflects the DBAware property of the contained data objects and is used to decide how and whether multi data object data requests should be managed." "" no no "" no "" "" no yes 70459.66
"HasDynamicProxy" 347.7063 3 "Indicates whether or not this container has a dynamic client proxy. Maintained from constructObject." "" yes no "" no "" "" no yes 426.7063
"HasObjectMenu" 347.7063 3 "Indicates that an object has menus to extract.  If set to NO, no menus (apart from the default menus) will be rendered for the object.  The attribute is populated by the repository APIs." "" yes no "Master" no "" "" no no 6005.6893
"Height" 3000002003.09 1 "A widget's height. The unit of measurement is determined by another 
parameter." "" no no "" no "" "" no yes 1005078415.09
"HEIGHT-CHARS" 1005078412.09 5 "Height in characters. This may currently be used when rendering some objects. There is no get function, use getHeight to retrieve the realized value from an object." "" no no "" no "" "" no no 1005099284.101
"HEIGHT-PIXELS" 1005078412.09 4 "" "" no no "" no "" "" no no 1005099264.101
"HELP" 1005078412.09 1 "WidgetAttributes Help" "" no no "" no "" "" no no 1005099308.101
"HelpId" 434.7063 4 "Stores the optionally defined HelpId of the selection ." "" no no "" no "" "" no yes 568.7063
"HIDDEN" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099301.101
"HiddenActions" 430.7063 1 "A comma separated list of hidden actions.
The actions will be immediately hidden or viewed." "" no no "" no "" "" no yes 183
"HiddenMenuBands" 430.7063 1 "A comma separated list of hidden menu bands.
This must be set before initialization." "" no no "" no "" "" no yes 187
"HiddenToolbarBands" 430.7063 1 "A comma separated list of hidden toolbar bands.
This must be set before initialization." "" no no "" no "" "" no yes 185
"HideChildContainersOnClose" 1005097792.101 3 "This property is used to indicate whether child containers launched should only remain hidden when closed, but they should also take in consideration how many hidden containers are allowed per session by checking the MaxHiddenContainers session property. For the Dynamic TreeView the default for this property will be TRUE." "" no no "" no "" "" no yes 149990.9875
"HideOnClose" 347.7063 3 "This property is used to indicate whether a container should only be hidden when closed, but should also take in consideration how many hidden containers are allowed per session by checking the MaxHiddenContainers session property.
Possible values:
Yes   - Always hide on close.
(ignore parents HideChildContainersOnClose and session MaxHiddenContainers)
No    - Never hide on close.
(ignore parents HideChildContainersOnClose)
Null  - Follow rules (Default)" "" no no "" no "" "" no yes 149992.9875
"HideOnInit" 5.7063 3 "Flag indicating whether to visualize at initialization.
Also used for non visual object in order to publish LinkState correctly for activation and deactivation of links.   
Defaults to 'NO', set to 'YES' from the container when it runs initPages to initialize non visible pages" "GET" no no "" no "" "" no yes 1003183447
"HideSelection" 1005097792.101 3 "Used to set the property of a SmartTreeView object to indicate that a node should appear as selected or not." "SET" no no "" no "" "" no yes 1005081439.28
"HORIZONTAL" 1005078412.09 3 "When TRUE, radio-sets are oriented horizontally." "" no no "" no "" "" no no 13481.409
"HotKey" 3000002003.09 1 "For SmartPak folder" "" no no "" no "" "" no no 3496.66
"HtmlClass" 1005078412.09 1 "CLASS property for an HTML tag" "" no no "" no "" "" no no 522.1713
"HtmlStyle" 1005078412.09 1 "STYLE property for an HTML tag" "" no no "" no "" "" no no 3012.1713
"IgnoreTreeViewFilter" 152.7063 3 "Decides whether general filter criteria applied to a TreeView should be applied to the data object. A TRUE value overrides default behaviour and ignores the criteria. This property supports the behaviour that previously was achieved by adding an empty NoTreeFilter procedure stub to a static SDO. Note that data sources on TreeView nodes do not support the notion of instances and instance attributes, so the property must typically be defined at the master level." "GET" no no "" no "" "" no yes 1000096124.66
"IMAGE-DOWN-FILE" 1005078412.09 1 "" "" no no "" no "" "" no no 3000040674.09
"IMAGE-FILE" 1005078412.09 1 "" "" no no "" no "" "" no no 3000040675.09
"IMAGE-INSENSITIVE-FILE" 1005078412.09 1 "" "" no no "" no "" "" no no 3000040676.09
"ImageDisabled" 3000002003.09 1 "SmartPak Folder" "" no no "" no "" "" no no 3494.66
"ImageEnabled" 3000002003.09 1 "SmartPak Folder" "" no no "" no "" "" no no 3493.66
"ImageHeight" 1003183341 4 "" "SET" no no "" no "" "" no yes 1003202044
"ImagePath" 430.7063 1 "" "" no no "" no "" "" no yes 702.7063
"ImageWidth" 1003183341 4 "" "SET" no no "" no "" "" no yes 1003202042
"ImageXOffset" 1003183341 4 "" "" no no "" no "" "" no yes 1003202046
"ImageYOffset" 1003183341 4 "" "" no no "" no "" "" no yes 1003202048
"InactiveLinks" 5.7063 1 "" "" yes no "" no "" "" no yes 72.7063
"IncludeInDefaultListView" 1005078412.09 3 "Indicates whether the field should be included in default list oriented views, like the browse. This applies to runtime list oriented views if not other field list is specified and is also used by object generators to decide which fields to add to generated browsers. The attribute defaults to unknown, which means that the IncludeInDefaultView setting should be used." "" no no "Master" no "" "" no yes 35975.66
"IncludeInDefaultView" 1005078412.09 3 "Indicates whether the field should be included in default views of the entity. This applies to runtime created views when no other field list is specified and is also used by object generators to decide which fields to add to generated visual objects." "" no no "Master" no "" "" no yes 35973.66
"Indentation" 1005097792.101 4 "Number of pixels of indentation between a node and it's child node." "SET" no no "" no "" "" no yes 3509.66
"IndexInformation" 152.7063 1 "Stores indexInormation formatted as the 4GL index-information attribute, but with RowObject column names and chr(1) as index 
separator and chr(2) as table separator.  See 'getIndexInformation' ovrride for more info." "get" yes no "" no "" "" no yes 208.7063
"InheritColor" 1003183341 3 "" "" no no "" no "" "" no yes 1003202064
"InitialPageList" 347.7063 1 "A comma-separated list of pages to construct at startup.
A special value of * will indicate all pages must be initialized at startup." "" no no "" no "" "" no yes 377.7063
"InitialValue" 1005078412.09 1 "WidgetAttributes InitialValue" "" no no "" no "" "" no no 3000000338.09
"InMessageSource" 509.49 10 "The handle of the In Message source" "" yes no "" no "" "" no yes 914.7063
"InMessageTarget" 505.49 10 "The handle of the In Message target." "" yes no "" no "" "" no yes 878.7063
"INNER-CHARS" 1005078412.09 4 "" "" no no "" no "" "" no no 1005099289.101
"INNER-LINES" 1005078412.09 4 "" "" no no "" no "" "" no no 1005099288.101
"InnerLines" 1005095447.101 4 "Sets the INNER-LINES property of a Dynamic Combo" "" no no "" no "" "" no yes 10.101
"InstanceId" 3000002003.09 5 "The unique identifer of the running instance in the Repository Manager. The Repository Manager ensures that this is set when the object is fetched from the Repository so that the object can use it as input to Repository Manager APIs." "" yes no "" no "" "" no no 4250.66
"InstanceNames" 347.7063 1 "Ordered list of ObjectNames of Container-Targets.
The list is in ContainerTarget order and each name is currently also stored in each object's ObjectName property.
It is used to enforce unique instance names in the container and is updated in constructObject and destroyObject together with the container link." "" yes no "" no "" "" no yes 416.7063
"InstanceProperties" 5.7063 1 "" "" yes no "" no "" "" yes yes 27.7063
"InternalDisplayFromSource" 9.7063 1 "Decides which fields the displayFields method should retrieve directly from the data source instead of from the input parameter. This attribute's purpose is to support Large data-types in the character based displayFields method, but '(all)'  will give a general performance improvement also for viewers that display very large character data.   
- (Large) - The DataSource's LargeDataColumns
- (All)      - All fields (Ignore input parameter)  
- Comma separated list of columns" "" no no "" no "" "" no yes 53087.66
"InternalRefList" 513.49 1 "Stores the Internal References this router uses to determine how external target namespaces map to internal XML mapping schemas." "" no no "" no "" "" no yes 938.7063
"IsRowObjectExternal" 152.7063 3 "Decides whether a dynamic RowObject table should be deleted on destroy of the object. Set to true in prepareRowObject, which is called to prepare an externally created RowObject in non-persistent procedures that outputs the RowObject as table-handle." "" yes no "" no "" "" no yes 3228.66
"IsRowObjUpdExternal" 152.7063 3 "Indicates that the RowObjUpd is external, usually from a client. This flag is currently set to true in setRowObjUpdTable if called BEFORE the object has been initialized. The flag then tells the dynamic SDO that it must skip the creation of this temp-table during initialization." "" yes no "" no "" "" no yes 4275.66
"JavaScriptFile" 347.7063 1 "" "" no no "" no "" "" no no 530.1713
"JavaScriptObject" 1005078412.09 1 "JavaScript object to be used for rendering/behavior support" "" no no "" no "" "" no no 5338.1713
"JMSpartition" 731.7063 1 "The JMS partition for the JMS session." "" no no "" no "" "" no yes 902.7063
"JMSPassword" 731.7063 1 "The JMS Password for the JMS session." "" no no "" no "" "" no yes 882.7063
"JMSUser" 731.7063 1 "The JMS User for the JMS session." "" no no "" no "" "" no yes 880.7063
"KeepChildPositions" 1005095446.101 3 "Determines whether the widgets/objects contained by a viewer should be allowed to deviate from their design positions." "" no no "" no "LIST" "YesTRUENoFALSE" no yes 80651.48
"KeyDataType" 1005095447.101 1 "Data type of Dynamic Lookup/Dynamic Combo key field." "" no no "" no "" "" no no 1005089871.28
"KeyField" 1005095447.101 1 "Name of the Dynamic Lookup/Dynamic Combo key field to assign value from (Table.Field)" "" no no "" no "" "" no no 1005089867.28
"KeyFields" 154.7063 1 "The indexInformation will be used to try to figure out the
default KeyFields list, but this is currently restricted to cases 
where: 
     - The First Table in the join is the Only enabled table.
     - All the fields of the index is present is the SDO.             
The following index may be selected.                          
            1. Primary index if unique.
            2. First Unique index." "get" no no "" no "" "" no yes 537.7063
"KeyFormat" 1005095447.101 1 "Format of Dynamic Lookup/Dynaic Combo key field." "" no no "" no "" "" no no 1005089870.28
"KeyTableId" 154.7063 1 "This is a unique Table identifier across databases for all tables 
used by the framework (Dynamics FiveLetterAcronym)." "" no no "" no "" "" no yes 539.7063
"LABEL" 1005078412.09 1 "WidgetAttributes Label" "" no no "" no "" "" no no 1005095224.101
"LabelBgColor" 1005078412.09 4 "WidgetAttributes LabelBgColor" "" no no "" no "DIALOG" "af/sup2/afspgetcow.w" no no 1005104906.101
"LabelEdit" 1005097792.101 4 "Is the node label editable. 1 = yes" "SET" no no "" no "" "" no yes 3510.66
"LabelFgColor" 1005078412.09 4 "WidgetAttributes LabelFgColor" "" no no "" no "DIALOG" "af/sup2/afspgetcow.w" no no 1005104908.101
"LabelFont" 1005078412.09 4 "WidgetAttributes LabelFont" "" no no "" no "" "" no no 1005104904.101
"LabelHandle" 432.7063 10 "" "" yes no "" no "" "" no yes 586.7063
"LabelOffset" 1003183341 4 "" "" no no "" no "" "" no no 1003202040
"LABELS" 1005078412.09 3 "If false then NO-LABEL is used.  This attribute applies to most field level widgets and frames" "" no no "" no "" "" no no 13470.409
"LARGE" 1005078412.09 3 "Whether the editor is a large editor." "" no no "" no "" "" no no 1005098171.101
"LargeColumns" 152.7063 1 "A comma-separated list of the DataObject's large (CLOB and BLOB) data-type columns." "GET" yes no "" no "" "" no yes 53085.66
"LastCommitErrorKeys" 152.7063 1 "Stores a comma-separated list of key values of every record that failed to be committed the last time data was committed. Blank indicates that the last commit was successful while unkown indicates that a commit never has been attempted since the object was initialized." "" yes no "" no "" "" no yes 49813.7063
"LastCommitErrorType" 152.7063 1 "Stores the type of error encountered the last time data was committed. Blank indicates that the last commit was successful, while unkown indicates that a commit never has been attempted since the object was initialized. 

Currently supported values 
- Conflict, locking conflict.  
- Error, unspecified error type" "" yes no "" no "" "" no yes 18288.66
"LastDBRowIdent" 154.7063 1 "Unknown if the last row has not been fetched. Otherwise it is the database rowid(s) for the last row." "" yes no "" no "" "" no yes 527.7063
"LastResultRow" 152.7063 1 "Unknown if the last row has not been fetched. Otherwise its 'rownum' concatinated with the rowid, if it has been fetched." "" yes no "" no "" "" no yes 194.7063
"LastRowNum" 152.7063 4 "The temp-table row number of the last row" "" yes no "" no "" "" no yes 166.7063
"LayoutOptions" 7.7063 1 "List of multi-layout options for the object." "" no no "" no "" "" no yes 74.7063
"LayoutPosition" 5.7063 1 "Contains the layout position of an object, indicating the position on a container. In Dynamics, this value is derived at runtime from the object instance record.
At runtime, this attribute only has meaning in the context of an instance." "" yes no "" no "" "" no yes 64930.48
"LayoutType" 1005095446.101 1 "The type of layout to use. Valid values include Manager, Widget and 
Column." "" no no "" no "" "" no no 1005095450.101
"LayoutUnits" 1005095446.101 1 "The units to use for layout purposes." "" no no "" no "" "" no no 1005095452.101
"LayoutVariable" 7.7063 1 "" "" no no "" no "" "" no yes 78.7063
"Lines" 1005098168.101 1 "The number of lines in an editor. This is denominatd in SizeUnits units,
which are an attribute of the widget." "" no no "" no "" "" no no 1005098169.101
"LineStyle" 1005097792.101 4 "0 -  (Default) Tree lines. Displays lines between Node siblings and their parent Node. 
1 - Root Lines. In addition to displaying lines between Node siblings and their parent Node, also displays lines between the root nodes." "SET" no no "" no "" "" no yes 3511.66
"LinkedFieldDataTypes" 1005095447.101 1 "Dynamic Lookup linked fields data types to display in viewer, comma list." "" no no "" no "" "" no no 1005089881.28
"LinkedFieldFormats" 1005095447.101 1 "Dynamic Lookup linked field formats from lookup to display in viewer, comma list." "" no no "" no "" "" no no 1005089882.28
"LinkTargetNames" 430.7063 1 "The list of the supported toolbar links. This is based on either the tool's specified item-Link, or the Category the tools
belong to.
" "" yes no "" no "" "" no yes 729.7063
"LIST-ITEM-PAIRS" 1005078412.09 1 "" "" no no "" no "" "" no no 1005099334.101
"LIST-ITEMS" 1005078412.09 1 "" "" no no "" no "" "" no no 1005099330.101
"ListInitialized" 434.7063 3 "" "" yes no "" no "" "" no yes 584.7063
"ListItemPairs" 1005095447.101 1 "" "" no no "" no "" "" no yes 833.7063
"LoadedByRouter" 515.49 3 "Set to true from the router to indicate that XML and Schema already  is loaded by the router." "" yes no "" no "" "" no yes 864.7063
"LOBFileName" 432.7063 1 "Stores the FileName that stores the current BLOB value" "" no no "" no "" "" no yes 54729.66
"LocalField" 432.7063 3 "Indicates that the field is providing data to a local field rather than a data field." "GET" no no "" no "" "" no yes 10477.009
"LogFile" 505.49 1 "The LogFile used to log errors for the consumer when running
in batch mode." "" no no "" no "" "" no yes 884.7063
"LogicalObjectName" 5.7063 1 "Maps to the object name in the Repository. Managed by the Repository manager at runtime." "" yes no "" no "" "" no yes 1003299781
"LogicalVersion" 3000002003.09 1 "The version of a logical (non-static) object." "" no no "" no "" "" no no 1000000272.48
"LookupFilterValue" 3000002003.09 1 "Filter value for the lookup" "SET" no no "" no "" "" no no 3232.66
"LookupHandle" 1005095447.101 10 "" "" yes no "" no "" "" no yes 825.7063
"LookupImage" 1005095447.101 1 "Image to use for Dynamic Lookup button (binoculars) - default will always be adeicon/select.bmp" "" no no "" no "" "" no yes 1005089887.28
"MaintenanceObject" 1005095447.101 1 "The logical object name of the object to be used when data for the table being queried using Dynamic Lookups can be maintained." "" no no "" no "" "" no no 1005089898.28
"MaintenanceSDO" 1005095447.101 1 "This attribute contains the name of an SDO to be assosiated with a maintenance folder for the Dynamic Lookups." "" no no "" no "" "" no no 1005101356.101
"Mandatory" 3000002003.09 3 "WidgetAttributes Mandatory" "" no no "" no "" "" no no 1005104900.101
"MANUAL-HIGHLIGHT" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099291.101
"ManualAddQueryWhere" 152.7063 1 "Store manual calls to addQueryWhere so that filter can reapply this when filter is changed, thus ensuring the original query stays intact. 
See 'setManualAddQueryWhere' for more info." "" no no "" no "" "" no yes 219.7063
"MapNameProducer" 515.49 1 "" "" no no "" no "" "" no yes 870.7063
"MapObjectProducer" 515.49 1 "" "" no no "" no "" "" no yes 866.7063
"MappedFields" 1005095447.101 1 "A comma separated paired list of data source field names and widget names on a viewer to be used to map fields from a data source with widgets on a viewer when linked fields are used in a Dynamic Lookup." "" no no "" no "" "" no no 156259.9875
"MapTypeProducer" 515.49 1 "" "" no no "" no "" "" no yes 868.7063
"MarginPixels" 438.7063 4 "The number of pixels to reserve for the Panel margin -- used by resizeObject." "" no no "" no "" "" no yes 664.7063
"MasterDataObject" 428.7063 10 "The handle of the ""Master"" SDO, the one which has no data source of its own and is the parent to other SDOs." "" yes no "" no "" "" no yes 440.7063
"MasterFile" 1005095447.101 1 "The physical file used to launch the SmartDataField. The default value for a Dynamic Lookup is adm2/dynlookup.w; and for a Dynamic Combo it is adm2/dyncombo.w." "" no no "" no "" "" no no 1005101640.101
"MAX-CHARS" 1005078412.09 4 "" "" no no "" no "" "" no no 1005099271.101
"MAX-DATA-GUESS" 1005078412.09 4 "Guess to help accuracy of the browser ""thumb"" position." "" no no "" no "" "" no no 14658.409
"MaxWidth" 436.7063 5 "The maximum value to use for setting the width of the browse when CalcWidth is TRUE." "" no no "" no "" "" no yes 476.7063
"Menu" 430.7063 3 "TRUE if a menu is to be generated." "" no no "" no "" "" no yes 1003498426
"MENU-KEY" 1005078412.09 1 "" "" no no "" no "" "" no no 1005099292.101
"MENU-MOUSE" 1005078412.09 4 "" "" no no "" no "" "" no no 1005099293.101
"MenuBarHandle" 430.7063 10 "" "" yes no "" no "" "" no yes 690.7063
"MenuMergeOrder" 430.7063 4 "Decides the order of which the menus will be merged with other 
toolbar instances." "" no no "" no "" "" no yes 189
"MenuObject" 430.7063 1 "" "" no no "" no "" "" no no 532.1713
"MessageType" 731.7063 1 "The type for messages being sent" "" no no "" no "" "" no yes 904.7063
"MinHeight" 7.7063 5 "The pre-determined minimum height of a visual object" "" no no "" no "" "" no yes 12.101
"MinWidth" 7.7063 5 "The pre-determined minimum width of a visual object." "" no no "" no "" "" no yes 11.101
"MODIFIED" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099279.101
"ModifiedFields" 436.7063 1 "A comma-separated list of browse cell handles whose value has been modified. The first entry is the RowIdent for the row." "" yes no "" no "" "" no yes 478.7063
"Modify" 434.7063 3 "Used  internally to identify wheter a value changed triggers the cahnge of the field or vice versa" "" yes no "" no "" "" no yes 566.7063
"ModifyFields" 9.7063 1 "Decides whether enabled fields should set DataModified in their container viewer when they are modified. (DataModified true in viewer will enable Save and Reset in the TableioSource toolbar).  The supported values are:  
- (All) - All enabled fields 
- (EnabledFields) - EnabledFields (from Data Source) 
- (Updatable) - EnabledFields that are updatable in the DataSource  
- (None) - No fields
- Comma separated list of object names that should set DataModified." "" no no "" no "" "" no yes 45301.66
"MouseCursor" 1003183341 1 "" "" no no "" no "" "" no no 1003202062
"MOVABLE" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099268.101
"MovableHandle" 436.7063 10 "Stores handle of movable columns popup menu" "" yes no "" no "" "" no yes 265.009
"MultiInstanceActivated" 347.7063 3 "" "" no no "" no "" "" no yes 385.7063
"MultiInstanceSupported" 347.7063 3 "" "" no no "" no "" "" no yes 383.7063
"MULTIPLE" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099336.101
"NAME" 1005078412.09 1 "The NAME attribute uniquely identifes the widget in its container." "" yes no "" no "" "" no yes 1005099281.101
"NameDefault" 1003183341 1 "Default name of object used in design time environment. Used in conjunction with palette items." "" no no "" no "" "" yes no 2127.7692
"NameList" 515.49 1 "Stores the list of logical schema Names this B2B uses." "" no no "" no "" "" no yes 851.7063
"NameSpaceHandle" 515.49 10 "The handle of the loaded XML mapping schema namespaces" "" yes no "" no "" "" no yes 858.7063
"NavigationSource" 347.7063 1 "The handle of the object's Navigation Source.
Used for pass-thru for regular containers, but also inherited by the SBO that uses it for 'real'.
Because multiple Navigation-Sources are supported, this is a 
comma-separated list of strings." "" yes no "" no "" "" no yes 392.7063
"NavigationSourceEvents" 347.7063 1 "List of events to be subscribed to in the Navigation Panel or other Navigation-Source." "" no no "Class" no "" "" no yes 398.7063
"NavigationTarget" 347.7063 1 "Used for pass-thru for regular containers, but also inherited by the SBO that uses it for 'real'." "" yes no "" no "" "" no yes 394.7063
"NavigationTargetEvents" 438.7063 1 "" "" no no "Class" no "" "" no yes 676.7063
"NavigationTargetName" 438.7063 1 "The ObjectName of the Data Object to be navigated by this
panel. This would be set if the Navigation-Target is an SBO
or other Container with DataObjects." "" no no "" no "" "" no yes 1004979019.09
"NavigationType" 438.7063 1 "" "" no no "" no "" "" no no 534.1713
"NeedContext" 11.7063 3 "Set to true to indicate that the object requires context to be passed back and forth between client and server" "get" no no "" no "" "" no yes 150.7063
"NewBatchInfo" 152.7063 1 "A characer expression based on RowNum that identifies the RowObject rows that were just retrieved. I.e. 'RowNum <= 2000000'" "" yes no "" no "" "" no no 20001.7063
"NewRecord" 9.7063 1 "Is 'ADD' or 'COPY' when the current record is a new unsaved record.  Otherwise the value is 'NO'." "set" yes no "" no "" "" no yes 98.7063
"NO-EMPTY-SPACE" 1005078412.09 3 "Browse last column will widen, if necessary, to fill any empty space in the right of the browse." "" no no "" no "" "" no no 14660.409
"NO-FOCUS" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099321.101
"NoLockReadOnlyTables" 152.7063 1 "Read only (no updatable columns) tables specified in this comma separated list will remain NO-LOCKed during the transaction and not be included in the optimistic locking check. The property can be set to 'ALL' to indicate that this applies to all read only tables. The default behavior, when this property is blank, is to apply EXCLUSIVE-LOCK to joined read only tables during the transaction and to include them in the optimistic lock conflict check." "" no no "" no "" "" no yes 101793.66
"NoLookups" 3000002003.09 3 "Whether to display a lookup or not" "" no no "" no "" "" no no 1005095449.101
"NotEmpty" 1005078412.09 3 "Set to TRUE if this field cannot be empty. Not empty means not blank for a character field and not 0 for an integer or a decimal." "" no no "" no "" "" no yes 32990.66
"NotNull" 1005078412.09 3 "Set to TRUE if a null value (unknown value) is not allowed in this field." "" no no "" no "" "" no yes 32988.66
"NUM-LOCKED-COLUMNS" 1005078412.09 4 "Browser attributes to keep left-most columns from scrolling off the viewport." "" no no "" no "" "" no no 14662.409
"NumDown" 436.7063 4 "The number of rows that are displayed DOWN in the browse." "" no no "" no "" "" no yes 480.7063
"NumRows" 434.7063 4 "The number of rows to use in the selection." "" no no "" no "" "" no yes 574.7063
"ObjectEnabled" 7.7063 3 "Flag indicating whether the current object is enabled." "" yes no "" no "" "" no yes 76.7063
"ObjectHidden" 5.7063 3 "Returns a flag indicating whether the current object is hidden.
Note that ""Hidden"" is a logical concept in the ADM. A non-visual object can be ""hidden"" to indicate that it is not currently active in some way (e.g.  a Container-Target of some visual object that is hidden)." "" yes no "" no "" "" no yes 33.7063
"ObjectInitialized" 5.7063 3 "Flag indicating whether this object has been initialized" "" yes no "" no "" "" no yes 31.7063
"ObjectLayout" 7.7063 1 "Stores the Layout of the object for Alternate Layout support." "" no no "" no "" "" no yes 1003183452
"ObjectMapping" 428.7063 1 "Lst of handles of Navigation-Source objects (panels) or other objects which are mapped to contained Data Objects,and the SDOs the SBO has connected them up to, per their NavigationTargetName property or setCurrentMappedObject request.
Used by queryPosition to identify which Object a queryPosition event should get passed on to. 
    Format is hNavSource,hSDOTarget[,...]
Application code can run getCurrentMappedObject to get back the name of the object they are currently linked to." "" yes no "" no "" "" no yes 452.7063
"ObjectMode" 9.7063 1 "Store the mode of the object 
MODIFY: This is a non-modal mode that can be turned off with view,  UPDATE: This is a modal mode that is turned off with save or cancel, VIEW: Non-editable
Note that 'setting' this attribute is not actually changing the mode. This happens with updateMode and sometimes enable and disable." "" yes no "" no "" "" no yes 128.7063
"ObjectName" 5.7063 1 "This name uniquely identifies an object instance in a container, so it is  really the object instance name." "" yes no "" no "" "" no yes 3.7063
"ObjectPage" 5.7063 4 "The logical page on which this object has been placed." "" yes no "" no "" "" no yes 48.7063
"ObjectParent" 5.7063 10 "The widget handle of this SmartObject's Container-Source's Frame or Window" "get,set" yes no "" yes "" "" no yes 230.7063
"ObjectsCreated" 347.7063 3 "Flag indicating whether this object has run createObjects for page 0.
Some containers run createObjects from the main block while othersstart them from initializeObject. The create initializeObject is often too late so this flag was introduced to allow us to have more control over when the objects are created and run createObjects before initializeObject for all objects" "" yes no "" no "" "" no yes 414.7063
"ObjectSecured" 7.7063 3 "This indicates whether the object has had security applied to it already." "" yes no "" no "" "" no no 3000040660.09
"ObjectTranslated" 7.7063 3 "This indicates whether an object has had translations applied to it." "" yes no "" no "" "" no no 3000040662.09
"ObjectType" 5.7063 1 "" "" no no "" no "" "" no yes 17.7063
"ObjectVersion" 5.7063 1 "" "" no no "" no "" "" no yes 15.7063
"OLEDrag" 3000002003.09 3 "Accept OLE drag operations" "SET" no no "" no "" "" no yes 3513.66
"OLEDrop" 3000002003.09 3 "Accept OLE drop operations" "SET" no no "" no "" "" no yes 3514.66
"OpenOnInit" 154.7063 3 "" "" no no "" no "" "" no no 3225.66
"Operator" 608.7063 1 "The default operator when OperatorStyle eq ""Implicit""" "" no no "" no "" "" no yes 620.7063
"OperatorLongValues" 608.7063 1 "A list of operators and long text." "" no no "" no "" "" no yes 626.7063
"OperatorShortValues" 608.7063 1 "" "" no no "" no "" "" no yes 628.7063
"OperatorStyle" 608.7063 1 "- ""Explicit""  - specify operator in a separate widget
- ""Implicit""  - Use the Operator and UseBegins property 
- ""Range""     - Use two fill-ins and specify GE and LE values
- ""Inline""    - Type the operator in the field (Defualt Equals or BEGINS if UseBegins eq true)     
" "" no no "" no "" "" no yes 616.7063
"OperatorViewAs" 608.7063 1 "The view-as type used to define the operator when  OperatorStyle equals ""Explicit""." "" no no "" no "" "" no yes 618.7063
"Optional" 434.7063 3 "TRUE if the selection is supposed to be optional.
If optional is TRUE the OptionalString defines the value to display." "" no no "" no "" "" no yes 576.7063
"OptionalBlank" 434.7063 3 "TRUE if the optional value is a Blank value." "" no no "" no "" "" no yes 580.7063
"OptionalString" 434.7063 1 "The value to display as an optional value  when the Optional property is set to true." "" no no "" no "" "" no yes 578.7063
"Order" 1005078412.09 4 "Generic order attribute.  Typically used for TAB-POSITION." "" no no "" no "" "" no no 13468.409
"OutMessageSource" 507.49 10 "The handle of the Out Message source" "" yes no "" no "" "" no yes 926.7063
"OutMessageTarget" 509.49 10 "The handle of the Out Message target" "" yes no "" no "" "" no yes 916.7063
"OVERLAY" 1005078412.09 3 "Frame attribute to allow a frame to cover all or part of another." "" no no "" no "" "" no no 14817.409
"PAGE-BOTTOM" 1005078412.09 3 "Frame attribute used for forcing a frame to the bottom of a printed page" "" no no "" no "" "" no no 14819.409
"PAGE-TOP" 1005078412.09 3 "Frrame attribute used to force a frame at the top of a printed page." "" no no "" no "" "" no no 14821.409
"Page0LayoutManager" 347.7063 1 "" "" no no "" no "" "" no yes 381.7063
"PageLayoutInfo" 5.7063 1 "This attribute contains a pipe-delimited list of layout codes, each relating to a non-zero page of a container." "" yes no "" no "" "" no yes 64936.48
"PageNTarget" 347.7063 1 "The list of objects which are on some page other than 0.
This property has a special format of ""handle|page#' for each entry, and should not be manipulated directly. Use 'addLink'." "" yes no "" no "" "" no yes 361.7063
"PageSource" 347.7063 10 "The handle of the object's Page-Source (folder), if any." "" yes no "" no "" "" no yes 363.7063
"PageTarget" 3000002003.09 10 "Link to container for paging" "" yes no "" no "" "" no no 3481.66
"PageTargetEvents" 3000002003.09 1 "Subscribed events from pagetarget" "" no no "Class" no "" "" no no 3482.66
"PageTokens" 347.7063 1 "Contains a pipe-delimited list of security tokens for the pages on a container. The order or the items corresponds to the order of the pages." "" no no "Master" no "" "" no no 5782.0575
"PaletteControl" 700.7692 1 "Control information for OCX's" "" no no "" no "" "" yes no 728.7692
"PaletteDBConnect" 700.7692 3 "If Yes, specifies the DB must be connected before using this item" "" no no "" no "" "" yes no 730.7692
"PaletteDirectoryList" 700.7692 1 "Comma delimited list of directories displayed in choose dialog" "" no no "" no "" "" yes no 720.7692
"PaletteEditOnDrop" 700.7692 3 "Indicates whether to automatically display the property sheet when the object is dropped onto the appBuilder design window." "" no no "" no "" "" no no 1357.7692
"PaletteFilter" 700.7692 1 "Comma delimited filter lists availabel in the choose dialog (i.e. *.w, d*.p)" "" no no "" no "" "" yes no 722.7692
"PaletteImageDown" 700.7692 1 "This is the down image to use in the palette" "" no no "" no "" "" yes no 716.7692
"PaletteImageUp" 700.7692 1 "This is the Up image to use in the palette" "" no no "" no "" "" yes no 714.7692
"PaletteIsDefault" 700.7692 3 "If Yes, that item is used as the default when pressing the icon in the palette" "" no no "" no "" "" yes no 726.7692
"PaletteLabel" 700.7692 1 "Label displayed in drop-down menu. This must be unique." "" no no "" no "" "" yes no 706.7692
"PaletteNewTemplate" 700.7692 1 "This is the static file used for rendering smartObjects" "" no no "" no "" "" yes no 718.7692
"PaletteOrder" 700.7692 4 "Order of palette icon in paltte" "" no no "" no "" "" yes no 745.7692
"PaletteRenderer" 700.7692 1 "This is the static file used for rendering objects when chosen from the palette." "" no no "" no "" "" yes no 4501.7692
"PaletteTitle" 700.7692 1 "Title used in the choose dialog" "" no no "" no "" "" yes no 724.7692
"PaletteTooltip" 700.7692 1 "Tooltip used for the palette button. If not defined, the paletteLabel is used." "" no no "" no "" "" yes no 708.7692
"PaletteTriggerCode" 700.7692 1 "This is a PIPE delimited list of CODE to write out in the trigger. It must correspond to PaletteTriggerEvent" "" no no "" no "" "" yes no 712.7692
"PaletteTriggerEvent" 700.7692 1 "This is a PIPE delimited list of static trigger events. Must correspond to the number of pipe delimited items in PaletteTriggerCode" "" no no "" no "" "" yes no 710.7692
"PaletteType" 700.7692 1 "Type of Palette widget (i.e. Button,Editor, SmartFolder,etc)" "" no no "" no "" "" yes no 704.7692
"PanelFrame" 438.7063 10 "Returns the Frame handle of the SmartPanel, for resizeObject." "" yes no "" no "" "" no yes 662.7063
"PanelLabel" 438.7063 10 "The handle of the Panel's Label, if any." "" yes no "" no "" "" no yes 670.7063
"PanelOffset" 1003183341 4 "" "" no no "" no "" "" no no 1003202032
"PanelState" 438.7063 1 "Deprecated." "set" yes no "" no "" "" no yes 672.7063
"PanelType" 438.7063 1 "The type of Panel: Navigation, Save, Update" "" no no "" no "" "" no yes 1003498440
"PARENT" 1005078412.09 1 "" "" no no "" no "" "" no no 1005099269.101
"ParentClassSubstitute" 5.7063 1 "Temporary (V2) bypass of the repository-defined class hierarchy to accomodate the current ADM2 conditional class parenting.
" "" no no "" no "" "" no yes 1283.7063
"ParentDataKey" 5.7063 1 "" "" no no "" no "" "" no yes 68.7063
"ParentField" 1005095447.101 1 "A field or widget name to a parent field on the viewer that will determine the filter query for a Dynamic Lookup/Dynamic Combo." "SET" no no "" no "" "" no no 1005089896.28
"ParentFilterQuery" 1005095447.101 1 "A Query sting used to filter the Base query of Dynamic Lookups/Dynamic Combos that depends on a parent field." "SET" no no "" no "" "" no no 1005089897.28
"PASSWORD-FIELD" 1005078412.09 3 "" "" no no "" no "" "" no no 1.2214
"PendingPage" 347.7063 4 "The pending page number is set immediately in selectPage so that objects can check what will become the new current page before the CurrentPage
is set. This was specifically implemented so that hideObject -> linkState  can avoid disabling links for objects that will become active/visible.
It is set to ? when CurrentPage is set. This should ONLY be set by selectPage." "" yes no "" no "" "" no yes 18292.66
"Persistency" 507.49 1 "Stores Persistency value for messages being sent" "" no no "" no "" "" no yes 930.7063
"PFCOLOR" 1005078412.09 4 "" "" no no "" no "" "" no no 1005099295.101
"PhysicalObjectName" 5.7063 1 "" "" yes no "" no "" "" no yes 59.7063
"PhysicalTableNames" 152.7063 1 "This list contains the names of the actual database tables." "SET" no no "" no "" "" no yes 3000031111.09
"PhysicalTables" 154.7063 1 "List of actual physical tables used to store the actual names against buffers. This is a comma delimited list which corresponds to the Tables property." "" no no "" no "" "" no no 4248.7692
"PhysicalVersion" 5.7063 1 "" "" yes no "Class" no "" "" no yes 62.7063
"PingInterval" 731.7063 4 "The Ping Interval for the JMS session." "" no no "" no "" "" no yes 906.7063
"POPUP-MENU" 1005078412.09 1 "" "" no no "" no "" "" no no 1005099294.101
"PopupActive" 436.7063 3 "Determines whether the browse popup is active" "" no no "" no "" "" no yes 267.009
"PopupButtonsInFields" 7.7063 3 "When set to YES, calendar and calculator popup buttons will be placed inside, on the right hand side of the field.  When NO, the popup button will be placed outside, to the right of the field.
" "" no no "" no "" "" no no 4.6893
"PopupOnAmbiguous" 432.7063 3 "Indicates that the lookup should popup automatically when a field is modified and the value is ambiguous, i.e. partially entered some data and no record could be uniquely identified. The rule is normally applied on the leave event, but some UIs may require a more explicit user action." "SET" no no "" no "" "" no yes 18276.66
"PopupOnNotAvail" 432.7063 3 "Indicates that the lookup should popup automatically when a field is modified and the value does not match any existing record. The rule is normally applied on the leave event, but some UIs may require a more explicit user action." "" no no "" no "" "" no yes 18280.66
"PopupOnUniqueAmbiguous" 432.7063 3 "Indicates that the lookup should popup automatically when a field is modified and the value uniquely identifies a record, if one or more other records exists that begins with that value. The rule is normally applied on the leave event, but some UIs may require a more explicit user action." "SET" no no "" no "" "" no yes 18278.66
"PopupSelectionEnabled" 3000002003.09 3 "Set this to TRUE to allow the building of a popup-menu (on MOUSE-MENU-DOWN - right-clicking) in the tab area, of all the tabs available on the SmartFolder sorted in page sequence order. Upon selection of a popup-menu item, the page would be selected. The current page will be shown with a tick mark.

Popup-menu items of disabledPages will be disabled." "" no no "" no "LIST" "YesyesNono" no no 178000000721.5566
"PositionForClient" 154.7063 1 "This property is set on the server and returned to the client so that it is able to position correctly in the new batch of data. The client need this information under certain cicumstances, for example when other settings decides that a full batch of data always is needed." "" yes no "" no "" "" no yes 29682.66
"PrimarySDOSource" 152.7063 10 "The handle of PrimarySDOSource object" "" yes no "" no "" "" no yes 3781.5498
"PrimarySDOTarget" 347.7063 10 "The handle of the 'master' SDO in an SBO container." "" yes no "" no "" "" no yes 396.7063
"PrintPreviewActive" 436.7063 3 "Indicates whether print preview functionality is active.
The 'get' function for this property starts an OLE object (Crystal)." "get" yes no "" no "" "" no yes 501.7063
"Priority" 507.49 4 "Priority value for messages being sent" "" no no "" no "" "" no yes 932.7063
"PRIVATE-DATA" 1005078412.09 1 "" "" no no "" no "" "" no no 1005099265.101
"ProcessList" 347.7063 1 "Run-time list of temporary objects to process." "" yes no "" no "" "" no no 58165.7063
"PROGRESS-SOURCE" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099300.101
"PromptColumns" 152.7063 1 "Specifies contents of a standard message prompt like the confirm delete. Values is '(None)', '(All)' or a specific list of columns." "" no no "" no "" "" no no 200000003021.66
"PromptLogin" 731.7063 3 "This property determines whether the producer or consumer will prompt the user for JMS broker login." "" no no "" no "" "" no yes 908.7063
"PromptOnDelete" 152.7063 3 "Specifies whether a delete requires a prompt to confirm the deletion." "" no no "" no "LIST" "" no no 200000003019.66
"PropertyDialog" 5.7063 1 "The name of the dialog procedure that sets 'InstanceProperties'.
This property is usually used only internally, but must be callable
from the AppBuilder to determine whether to enable the InstanceProperties menu item." "" no no "Class" no "" "" no yes 21.7063
"QueryBuilderDBNames" 154.7063 1 "Design only attribute string containing query information to support calculated fields in SDOs" "" no no "" no "" "" yes no 20023.409
"QueryBuilderFieldDataTypes" 154.7063 1 "Design only attribute string containing query information to support calculated fields in SDOs" "" no no "" no "" "" yes no 20021.409
"QueryBuilderFieldFormatList" 154.7063 1 "Design Only string containing the current SDO field formats to support AppBuilder SDO editor" "" no no "" no "" "" yes no 19719.409
"QueryBuilderFieldHelp" 154.7063 1 "Design only attribute string containing query information to support customer helps strings in SDOs" "" no no "" no "" "" yes no 20027.409
"QueryBuilderFieldLabelList" 154.7063 1 "Design Only string containing the current SDO labels to support AppBuilder SDO editor" "" no no "" no "" "" yes no 19717.409
"QueryBuilderFieldWidths" 154.7063 1 "Design only attribute string containing query information to support custom field widths in SDOs" "" no no "" no "" "" yes no 20029.409
"QueryBuilderInheritValidations" 154.7063 1 "Design only attribute string containing query information to support SDOs" "" no no "" no "" "" yes no 20031.409
"QueryBuilderJoinCode" 154.7063 1 "Design Only string containing the current query join information to support AppBuilder Query Builder" "" no no "" no "" "" yes no 19725.409
"QueryBuilderOptionList" 154.7063 1 "Design Only string containing the current query option to support AppBuilder Query Builder" "" no no "" no "" "" yes no 19723.409
"QueryBuilderOrderList" 154.7063 1 "Design Only string containing the current query break by and by clauses to support AppBuilder Query Builder" "" no no "" no "" "" yes no 19721.409
"QueryBuilderTableList" 154.7063 1 "Design Only string containing the current table list  to support AppBuilder Query Builder" "" no no "" no "" "" yes no 6140.009
"QueryBuilderTableOptionList" 154.7063 1 "Design Only string containing the current query table options to support AppBuilder Query Builder" "" no no "" no "" "" yes no 19727.409
"QueryBuilderTuneOptions" 154.7063 1 "Design Only string containing the current query tuning options to support AppBuilder Query Builder" "" no no "" no "" "" yes no 19731.409
"QueryBuilderWhereClauses" 154.7063 1 "Design Only string containing the current query where clauses to support AppBuilder Query Builder" "" no no "" no "" "" yes no 19729.409
"QueryColumns" 154.7063 1 "Keeps track of the position for each column/operator combination added with assignQuerySelection." "" yes yes "" no "" "" no yes 525.7063
"QueryContainer" 152.7063 3 "Indicates whether our Container is itself a QueryObject. It is used to determine whether we're in an SBO which handles the transaction for us." "" yes no "" no "" "" no yes 206.7063
"QueryContext" 152.7063 1 "Stores the Query Context on the Client. For internal use only." "" yes no "" no "" "" no yes 211.7063
"QueryHandle" 154.7063 10 "The handle of the database query." "" yes no "" no "" "" no yes 515.7063
"QueryObject" 5.7063 3 "" "" no no "" no "" "" no yes 23.7063
"QueryPosition" 154.7063 1 "Valid return values are:
FirstRecord, LastRecord, NotFirstOrLast, NoRecordAvailable and NoRecordAvailableExt" "set" yes no "" no "" "" no yes 509.7063
"QueryRowIdent" 154.7063 1 "Rowid or comma-separated list of Rowids of the database record(s) to be positioned to.
Generally used to save the position of a query when it is closed so that position can be restored on re-open." "" yes no "" no "" "" no yes 517.7063
"QueryRowObject" 436.7063 10 "The buffer handle of the RowObject temp-table associated with the browse's query." "" yes no "" no "" "" no yes 494.7063
"QueryString" 154.7063 1 "Working storage for all query manipulation methods.
If the QueryString property has not been set then the current where clause will be used (QueryWhere).
If there's no current QueryWhere then the design where clause will be used (OpenQuery) -> (BaseQuery). 
The openQuery will call prepareQuery with the value." "" yes no "" no "" "" no yes 523.7063
"QueryTables" 1005095447.101 1 "Comma list of query tables for Dynamic Lookups/Dynamic Combos (Buffers)" "SET" no no "" no "" "" no no 1005089875.28
"QueryTempTableDefinitions" 154.7063 1 "Stores information needed to construct a temp table in a chr(3) delimited string for multiple tables using the same format as specified in a static SDO's procedure setting section:  <name> <type> <share-type> <undo-type> <like-db> <like-table> <additional fields chr(10) delimited>" "" no no "" no "" "" yes yes 4176.7692
"RADIO-BUTTONS" 1005078412.09 1 "Label- value pairs of a radio-set" "" no no "" no "" "" no no 13483.409
"READ-ONLY" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099280.101
"RebuildOnRepos" 152.7063 3 "If TRUE, the RowObject temp-table will be rebuilt when a reposition is done which is outside the bounds of the current result set." "" no no "" no "" "" no yes 1003183468
"RecordState" 9.7063 1 "Indicates whether a record is available or not.
Possible values are: RecordAvailable, NoRecorAvailable" "" yes no "" no "" "" no yes 114.7063
"ReEnableDataLinks" 347.7063 1 "Not in use" "" yes no "" no "" "" no yes 408.7063
"RemoveMenuOnHide" 3000002003.09 3 "Decides whether the object's menu should be removed from the menubar when the object is hidden." "" no no "" no "" "" no yes 47336.66
"RenderingProcedure" 3000002003.09 1 "This procedure specifies the name of the procedure that will be used to render an object. The value of this attribute will match that of the object name in the Repository, and will be resolved into a pathed filename capable of being run." "" no no "" no "" "" no yes 18564.48
"ReplicateEntityMnemonic" 36427.48 1 "If SCM data versioning is to be enabled for this entity, then the FLA of the primary replication table should be specified, e.g. RYCSO for the ryc_smartobject table.
For the primary table, the entity_mnemonic and this field will be the same.
This field corresponds to the entity level UDP setup in ERwin as ReplicateFLA.
If this field is defined and scm checking is enabled via the flag in the security control table, then modifications to data in this table will be prevented without a valid task" "" yes no "" no "" "" no no 36466.48
"ReplicateKey" 36427.48 1 "This field is only applicable if the replicate_entity_mnemonic field has been specified turning on SCM data versioning for this entity.This is the join field to the primary replication table being versioned Usually this will be the same field as the primary key of the primary table, e.g. smartobject_obj, but if the foreign key field has been role named, as is the case with page table, it could be something else, e.g. container_smartobject_obj. Multiple primary key fields are supported." "" yes no "" no "" "" no no 36468.48
"ReplyConsumer" 507.49 10 "" "" yes no "" no "" "" no yes 928.7063
"ReplyReqList" 515.49 1 "Stores the list of Reply Required flags this B2B uses as a producer to determine if a reply is required for an outgoing message." "" no no "" no "" "" no yes 853.7063
"ReplyRequired" 509.49 3 "Stores the Reply Required flag for the current message" "" no no "" no "" "" no yes 918.7063
"ReplySelector" 509.49 1 "The Reply Selector for the current message" "" no no "" no "" "" no yes 920.7063
"RepositionDataSource" 434.7063 3 "Set to true if the data-source is to be repositioned on VALUE-CHANGED. 
This is not needed for the view-as browse option.
This must be set to true if for example the data-source also 
 is a data-source for other objects and those objects need to be 
refreshed when a value is changed in the combo-box." "" no no "" no "" "" no yes 602.7063
"RequiredPages" 347.7063 1 "This property contains a list of comma-delimited pages that are linked to a page. These are pages that contain Data-source objects for objects on this page, or which contain GroupAssign sources or targets. If there are multiple pages on a container, this property will contain a set of pipe-delimited sets of comma-delimited pages. The pipe-delimited lists will be in order, so the first entry corresponds to page 1 etc." "" yes no "" no "" "" no yes 78021.48
"RequiredProperties" 3000002003.09 1 "Properties that are required to run an object. These properties has to be defined at object or instance level and must be set in the object to be 
able to run it." "" no no "" no "" "" no yes 121
"RESIZABLE" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099270.101
"ResizeHorizontal" 7.7063 3 "Indicates if an object is Horizontally Resizable." "" no no "" no "" "" no yes 102.28
"ResizeVertical" 7.7063 3 "Indicates if an object is Vertically Resizable." "" no no "" no "" "" no yes 103.28
"ResortOnSave" 152.7063 3 "Yes - Resort and reopen the client query on save of a row. This applies to both AutoCommit and non-AutoCommit sources, but may require an additional server request if the datasource is batching and is thus ignored if batching with AutoCommit set to false. 
No - Do not resort on save of row." "" no no "" no "" "" no yes 90686.66
"RETAIN-SHAPE" 1005078412.09 3 "When TRUE, IMAGES automatically maintain a constant aspect ratio." "" no no "" no "" "" no no 13473.409
"RETURN-INSERTED" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099302.101
"ReuseDeletedKeys" 36427.48 3 "This flag is only relevant for entities that have record versioning enabled and the table has obj field is true - i.e. this is a table that has an object id field and some other unique key field(s). If this flag is set to YES, then if a record is created with a key value that has been previously deleted, then the new record will be created with the deleted records object id and key value, ensuring the link between a key value and an object id are never broken." "" yes no "" no "" "" no no 36470.48
"RightToLeft" 438.7063 1 "" "" no no "" no "" "" no yes 678.7063
"RootNodeCode" 1005097792.101 1 "The Root Node Code to be used when populating a SmartTreeView object on a Dynamic TreeView object." "SET" no no "" no "" "" no no 1005081437.28
"ROUNDED" 1005078412.09 3 "Whether the corners of a rectangle are rounded or not." "" no no "" no "" "" no no 23004.5498
"RouterSource" 513.49 1 "Stores a list of handles for router-source objects." "" yes no "" no "" "" no yes 940.7063
"RouterTarget" 505.49 10 "The handle of the RouterTarget" "" yes no "" no "" "" no yes 886.7063
"ROW" 1005078412.09 5 "Row position." "" no no "" no "" "" no no 1005078420.09
"ROW-HEIGHT-CHARS" 1005078412.09 5 "Height of a row in a browse or down frame" "" no no "" no "" "" no no 14664.409
"ROW-MARKERS" 1005078412.09 3 "Browser will have row markers on the left side" "" no no "" no "" "" no no 14666.409
"ROW-RESIZABLE" 1005078412.09 3 "Browser's row can be resized at run-time" "" no no "" no "" "" no no 14668.409
"RowIdent" 9.7063 1 "The RowIdent of the current row in the visualization.
The DB rowids may be stored as the second entry of the list, if the updateTarget is an SDO.
When connected to an SBO the rowids returned are a semi-colon separated list corresponding to the SBOs DataObjectNames, if the SBO is a valid UpdateTarget the rowids are for the UpdateTargetNames, otherwise the DataSourceNames are used." "get" yes no "" no "" "" no yes 100.7063
"RowObject" 152.7063 10 "The handle of the RowObject Temp-Table buffer" "" yes no "" no "" "" no yes 156.7063
"RowObjectState" 152.7063 1 "Signals whether there are uncommitted updates in the object.
The two possible return values are: 'NoUpdates' and 'RowUpdated'" "set" yes no "" no "" "" no yes 197.7063
"RowObjectTable" 152.7063 10 "This is the handle to the temp-table itself, not its buffer.
Supports dynamic SDO (not valid RowObject) by also setting RowObject and DataHandle if it is unknown or different." "set" yes no "" no "" "" no yes 162.7063
"RowObjUpd" 152.7063 10 "The handle of the RowObjUpd Temp-Table buffer" "" yes no "" no "" "" no yes 158.7063
"RowObjUpdTable" 152.7063 10 "This is the handle to the temp-table itself, not its buffer.
Supports dynamic SDO (not valid RowObject) by also setting RowObject and DataHandle if it is unknown or different." "set" yes no "" no "" "" no yes 160.7063
"RowsToBatch" 152.7063 4 "The number of rows to be transferred from the database query into the RowObject temp-table at a time.
Setting RowsToBatch to 0 indicates that ALL records should be  read." "" no no "" no "" "" no yes 1003183464
"RunAttribute" 5.7063 1 "" "" no no "" no "" "" no yes 64.7063
"RunDataLogicProxy" 152.7063 3 "If TRUE, only the ""_cl.r"" version of the data logic procedure should be run. If it cannot be found, the associated Data Object is not run." "" no no "" no "" "" no no 35001.7063
"RunDOOptions" 347.7063 1 "A comma-separated list with options that determine how Data Objects are run from constructObject
The options available are:
     dynamicOnly - this runs dynamic data objects only and supercedes all other options
     sourceSearch - this searches for source code if rcode is not found 
    clientOnly - this runs proxy (_cl) code only (for both rcode and source code)" "" no no "" no "" "" no yes 375.7063
"RunMultiple" 347.7063 3 "" "" no no "" no "" "" no yes 369.7063
"SavedColumnData" 436.7063 1 "Stores saved column data for setting column positions and sizes, format is

column1ame CHR(4) column1width CHR(3) column2name CHR(4) column2width, etc..." "" no no "" no "" "" no yes 269.009
"SavedContainerMode" 347.7063 1 "" "" yes no "" no "" "" no yes 388.7063
"SaveSource" 9.7063 3 "Used internally to indicate the state of the Tableio-Source. TRUE if the Tableio-Source is a 'Save' and false if 'Update'.
Can be set to FALSE to override the default enabling of a viewer that has an Update-Source, but has no Tableio-Source" "" no no "" no "" "" no yes 112.7063
"SCHEMA-CASE-SENSITIVE" 1005078412.09 3 "The Case Sensitive flag imported from the Data Dictionary." "" no no "" no "" "" yes yes 32980.66
"SCHEMA-COLUMN-LABEL" 1005078412.09 1 "The column-label imported from the Data Dictionary." "" no no "" no "" "" yes yes 4317.66
"SCHEMA-DECIMALS" 1005078412.09 4 "The Decimals value imported from the Data Dictionary." "" no no "" no "" "" yes yes 32976.66
"SCHEMA-DESCRIPTION" 1005078412.09 1 "The Description imported from the Data Dictionary." "" no no "" no "" "" yes yes 32978.66
"SCHEMA-FORMAT" 1005078412.09 1 "The format imported from the Data Dictionary." "" no no "" no "" "" yes yes 4313.66
"SCHEMA-HELP" 1005078412.09 1 "The help imported from the Data Dictionary." "" no no "Master" no "" "" yes yes 4311.66
"SCHEMA-INITIAL" 1005078412.09 1 "The initial value imported from the Data Dictionary." "" no no "Master" no "" "" yes yes 4319.66
"SCHEMA-LABEL" 1005078412.09 1 "The label imported from the Data Dictionary." "" no no "" no "" "" yes yes 4315.66
"SCHEMA-MANDATORY" 1005078412.09 3 "The Mandatory flag imported from the Data Dictionary." "" no no "" no "" "" yes yes 32974.66
"SCHEMA-ORDER" 1005078412.09 4 "The Order imported from the Data Dictionary." "" no no "" no "" "" yes yes 32982.66
"SCHEMA-VALIDATE-EXPRESSION" 1005078412.09 1 "The validate expression imported from the Data Dictionary." "" no no "Master" no "" "" yes yes 4321.66
"SCHEMA-VALIDATE-MESSAGE" 1005078412.09 1 "The validate message imported from the Data Dictionary." "" no no "Master" no "" "" yes yes 4325.66
"SCHEMA-VIEW-AS" 1005078412.09 1 "The view-as expression imported from the Data Dictionary." "" no no "Master" no "" "" yes yes 4327.66
"SchemaHandle" 515.49 10 "Stores the handle of the loaded XML mapping schema" "" yes no "" no "" "" no yes 855.7063
"SchemaList" 515.49 1 "The list of Schemas this B2B uses." "" no no "" no "" "" no yes 862.7063
"SchemaLocation" 152.7063 1 "Decides how the RowObject columns is defined in dynamic SDOs
- 'ENT' - From Entity Cache. (Also Default behavior for blank)
- 'DLP' - Use DataLogicProcedure
- 'BUF' - Use the buffer in the query  
If using ENTity cache all fields must exist in the entity cache.
If using DLP any missing field will be searched for in the query's buffer.   
Setting it to 'DLP' or 'BUF', (no difference) for static will avoid retrieaval of formats and labels fromt he Entity Cache." "" no no "" no "" "" no yes 47326.66
"SchemaName" 515.49 1 "" "" no no "" no "" "" no yes 860.7063
"ScmFieldName" 36427.48 1 "This field is only applicable if the replicate_entity_mnemonic field has been specified turning on SCM data versioning for this entity
This is only required for the primary entity being versioned and is the unique field for the data that is also used as the object name in the SCM Tool. E.g. for ryc_smartobject this would be the object_filename, but in other tables it may be some unique reference field that identifies the data." "" yes no "" no "" "" no no 36472.48
"SCREEN-VALUE" 1005078412.09 1 "" "" no no "" no "" "" no no 1005099299.101
"Scroll" 3000002003.09 3 "Scroll property of the tree." "SET" no no "" no "" "" no no 3516.66
"SCROLLABLE" 1005078412.09 3 "Frame attribute to allow a down frame to scroll" "" no no "" no "" "" no no 14823.409
"SCROLLBAR-HORIZONTAL" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099273.101
"SCROLLBAR-VERTICAL" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099274.101
"ScrollRemote" 436.7063 3 "" "" no no "" no "" "" no yes 492.7063
"SDFFileName" 1005095447.101 1 "The SmarObject file name of the file used for the SmartLookupObject/SmartComboObject." "" no no "" no "" "" no no 1005089865.28
"SDFTemplate" 1005095447.101 1 "The template SmartObject used to create a Dynamic Lookup/Dynamic Combo." "" no no "" no "" "" no no 1005090095.28
"SDOForeignFields" 347.7063 1 "" "" no no "" no "" "" no yes 390.7063
"SearchField" 436.7063 1 "The name of a field on which can be searched on for repositioning the query the browse is attached to.
The field name is the actual field name in the SmartDataObject NOT the one referenced in the Data Dictionnary." "" no no "" no "" "" no yes 482.7063
"SearchHandle" 436.7063 10 "The handle of the field whose name is stored in 'SearchField'." "" yes no "" no "" "" no yes 484.7063
"Secured" 1005095447.101 3 "" "" no no "" no "" "" no yes 839.7063
"SecuredTokens" 430.7063 1 "The list of secured tokens (from the container really).
SET from 'getSecuredTokens' the first time (when the value is ?)" "" no no "" no "" "" no yes 727.7063
"SELECTABLE" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099266.101
"SELECTED" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099267.101
"SelectionHandle" 434.7063 10 "" "" yes no "" no "" "" no yes 588.7063
"SelectionImage" 434.7063 1 "" "" no no "" no "" "" no yes 590.7063
"SelectorBGcolor" 3000002003.09 1 "Set the background color of the folder" "" no no "" no "DIALOG" "af/sup2/afspgetcow.w" no no 1003202054
"SelectorFGcolor" 1005095446.101 1 "Set the foreground color of the folder" "" no no "" no "DIALOG" "af/sup2/afspgetcow.w" no no 1003202052
"SelectorFont" 1003183341 4 "" "" no no "" no "" "" no no 1003202056
"Selectors" 505.49 1 "Stores the Message Selectors used for receiving messages." "" no no "" no "" "" no yes 888.7063
"SelectorWidth" 1003183341 4 "" "" no no "" no "" "" no no 1003202058
"SENSITIVE" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099263.101
"SEPARATOR-FGCOLOR" 1005078412.09 4 "The color of a browse's separator lines" "" no no "" no "DIALOG" "af/sup2/afspgetcow.w" no no 14672.409
"SeparatorFGColor" 1005078412.09 4 "The color of the separator lines in a SmartBrowser" "SET" no no "" no "DIALOG" "af/sup2/afspgetcow.w" no no 33688.409
"Separators" 436.7063 3 "Decides whether the browser will have separator lines to demark rows and columns." "GET,SET" no no "" no "" "" no yes 14670.409
"ServerFileName" 11.7063 1 "The actual server-side object filename to run on the AppServer -- may not be the ObjectName if that has been modified.
Defaults to the target-procedure file-name without the _cl." "get" no no "" no "" "" no yes 146.7063
"ServerFirstCall" 11.7063 3 "Indicates that this is the first call to the server side object.
It's the client's responsibility to tell the server when is the first call." "" yes no "" no "" "" no yes 148.7063
"ServerOperatingMode" 11.7063 1 "" "set" no no "" no "LIST" "Set from serverNoneForce to stateful operating modeState-reset" no yes 1003183470
"ServerSubmitValidation" 152.7063 3 "Signals whether the column and RowObject Validation procedures done as part of client validation should be executed on the server. 
It is 'NO' by default; an SDO which uses client validation and which may be run from the open client interface should set it to 'YES', either in the SDO itself or at runtime.
If it is *no* when serverCommit executes, it will execute 'submitValidation' itself." "set" no no "" no "" "" no yes 1003586096
"ShareData" 152.7063 3 "Can the data be shared with other instances. The property only applies to the client proxy running against a stateless appserver or when ForceClientProxy is true." "" no no "" no "" "" no yes 55427.66
"ShowBorder" 430.7063 3 "" "" no no "" no "" "" no yes 1003498427
"ShowCheckBoxes" 1005097792.101 3 "Used to set the property of a SmartTreeView object to indicate that check boxes should appear next to each node." "SET" no no "" no "" "" no no 1005081440.28
"ShowPopup" 1005078412.09 3 "WidgetAttributes ShowPopup" "" no no "" no "" "" no no 3000000298.09
"ShowRootLines" 1005097792.101 3 "Used to set the property of a SmartTreeView object to indicate that root lines should appear on the OCX." "SET" no no "" no "" "" no no 1005081441.28
"ShutDownDest" 505.49 1 "Stores the Shut Down Destination used to consume a shut down  message which shuts down the consumer." "" no no "" no "" "" no yes 890.7063
"SIDE-LABEL-HANDLE" 1005078412.09 1 "" "" no no "" no "" "" no no 1005099286.101
"SIDE-LABELS" 1005078412.09 3 "Frame attribute to allow a frame to have labels to the left of an object." "" no no "" no "" "" no no 14825.409
"SingleSel" 3000002003.09 3 "If yes, the node is expanded when the node is selected or clicked." "GET" no no "" no "" "" no no 3517.66
"SizeToFit" 1005095446.101 3 "If a Viewer is marked ""SizeToFit"", it will be sized to the minimum dimensions that will accomodate all included widgets.  Otherwise, the viewer will retain its design-time size." "" no no "" no "" "" yes yes 25001.409
"SizeUnits" 1005095446.101 1 "The units to use when sizing the widgets on a viewer." "" no no "" no "" "" no no 1005095451.101
"SkipTransferDBRow" 154.7063 3 "Internal flag used for performance optimization. It is used to avoid the call to the transferDBRow function for each record. The property is set to true in transferDBRow if the function is not overridden. transferRows then avoids calling it for the rest of the batch. Although a function call is fast, the performance gain by skipping it is substantial due to the fact that inline logic and query navigation is very fast." "" yes yes "" no "" "" no yes 543.7063
"SORT" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099331.101
"SortableHandle" 436.7063 10 "Handle for sortable popup menu item" "" yes no "" no "" "" no yes 273.009
"Starting" 434.7063 3 "" "" yes no "" no "" "" no yes 564.7063
"StartPage" 347.7063 4 "The page number of the initial container page to be made visible." "" no no "" no "" "" no yes 367.7063
"StatelessSavedProperties" 152.7063 1 "" "" no no "" no "" "" no yes 199.7063
"StaticPrefix" 438.7063 1 "The prefix used before the action name in static definitions.
This allows static panels to use action/repository data." "" no no "" no "" "" no yes 660.7063
"StatusArea" 1003183341 3 "Indicates if a window is should have a status area." "SET" no no "" no "" "" no no 12937.5053
"StopConsumer" 505.49 10 "" "" yes no "" no "" "" no yes 892.7063
"STRETCH-TO-FIT" 1005078412.09 3 "When TRUE, images are automatically resized to fit the available space." "" no no "" no "" "" no no 13475.409
"StyleSheetFile" 347.7063 1 "Cascading StyleSheet include file(s)" "" no no "" no "" "" no no 524.1713
"SubMenuLabelRetrieval" 430.7063 1 "Decides where to retrieve the label for a submenu created for conflict 
Currently supported
- Label -  The Label in the first linked object on the Band. 
- PageLabel  -  The FolderPage Label if on page > 0." "" no no "" no "LIST" "Label in first linked objectLabelPage label (if on page)PageLabel" no yes 47331.66
"SubmitParent" 152.7063 3 "Yes - Include parent record(s) when submitting this object's changes to the service.
No - Only submit this object's changes to the service." "GET" no no "" no "" "" no yes 84535.66
"SubModules" 430.7063 1 "NOT IN USE" "" no no "" no "" "" no yes 1003498431
"Subscriptions" 505.49 1 "Stores the Subscriptions this consumer uses when subscribing
to topics (only for Pub/Sub domain)" "" no no "" no "" "" no yes 894.7063
"SUBTYPE" 1005078412.09 1 "" "" no no "" no "" "" no no 1005099312.101
"SuperProcedure" 5.7063 1 "The class super procedure." "" no no "Master" no "" "" no no 13156.7063
"SuperProcedureHandle" 5.7063 1 "Stores the handle(s) of any stateful (stateaware)  super procedures started for an object." "" yes no "" no "" "" no yes 64932.48
"SuperProcedureMode" 5.7063 1 "Indicates how the class or object super procedure(s) should be started.

Valid current values: 
STATELESS - super procedure starts once per session; stays alive after object shutdown. There should only be one instance of the super running in any given session.
STATEFUL - one instance of the super procedure started per object. The super procedure is shut down when the object is destroyed. Multiple copies may run per session, depending on the number of concurrently running objects." "" no no "Master" no "" "" no no 15002.7063
"SupportedLinks" 5.7063 1 "A comma-seaprated list of links that this object supports. The links must be specified as <linktype>-target or <linktype>-source" "" yes no "Class" no "" "" no yes 1003498433
"SupportedMessageTypes" 731.7063 1 "" "" no no "" no "" "" no yes 910.7063
"TAB-STOP" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099303.101
"TabBGcolor" 3000002003.09 1 "Set the background color of the selectd tab" "" no no "" no "DIALOG" "af/sup2/afspgetcow.w" no no 1003202020
"TabEnabled" 3000002003.09 1 "This attribute contains a pipe-delimited list of logical values which indicate whether a particular tab page is enabled or not." "" yes no "" no "" "" no no 3000040656.09
"TabFGcolor" 3000002003.09 1 "Set the foreground color of the selected tab" "" no no "" no "DIALOG" "af/sup2/afspgetcow.w" no no 1003202018
"TabFont" 1003183341 4 "" "" no no "" no "" "" no no 1003202038
"TabHeight" 1003183341 4 "" "" no no "" no "" "" no no 1003202036
"TabHidden" 1003183341 1 "This attribute contains a pipe-delimited list of logical values which indicate whether a particular tab page is hidden or not." "" no no "" no "" "" no no 1003202024
"TabINcolor" 1003183341 1 "" "" no no "" no "" "" no no 1003202022
"TableHasObjectField" 36427.48 3 "If set to NO, this table does not contain a generic object field used to join to generic tables, e.g. comments, auditing, etc." "" yes no "" no "" "" no no 36474.48
"TableIOSource" 9.7063 10 "" "" yes no "" no "" "" no yes 108.7063
"TableIOSourceEvents" 9.7063 1 "" "" no no "Class" no "" "" no yes 110.7063
"TableioTarget" 438.7063 1 "" "" yes no "" no "" "" no yes 680.7063
"TableioTargetEvents" 438.7063 1 "" "" no no "" no "" "" no yes 682.7063
"TableIOType" 430.7063 1 "The TableIOType link value.
This is the same as PanelType in the update panel." "" no no "" no "" "" no yes 1003498432
"TableName" 3000002003.09 1 "WidgetAttributes TableName" "" no no "" no "" "" no no 1005078710.09
"TablePrefixLength" 36427.48 4 "This is the length of the table prefix appended to all table names as per the framework standards. The framework uses a 4 character table prefix - see the standards documentation for further details." "" yes no "" no "" "" no no 36476.48
"Tables" 154.7063 1 "A comma delimited list of tables in the Query Object. Qualified with database name if the query is defined with dbname.
It is a design time property, as it's very expensive to resolve on the server at run-time.
There is no way to change the order of the tables at run time. But it would be even more important to have this as a property
if the order of the tables were changed dynamically, because several other properties have table delimiters and are depending on the design-time order of this." "" no no "" no "" "" no yes 535.7063
"TabPosition" 3000002003.09 1 "Set the position of the tabs (either top [""Upper""] or bottom [""Lower""])" "" no no "" no "LIST" "UpperUpperLowerLower" no no 1003202060
"TabSize" 3000002003.09 1 "Set the sizing method of the folder" "" no no "" no "LIST" "AutosizeAutosizeProportionalProportionalJustifiedJustified" no no 1003202050
"TabsPerRow" 1003183341 4 "" "" no no "" no "" "" no no 1003202034
"TabVisualization" 3000002003.09 1 "This could have a value of ""Tabs"", ""Combo-Box"" or ""Radio-Set"" and will determine how the tabs on the SmartFolder objects are visualized.

When TabVisualization is ""Combo-Box"", disabledPages will NOT appear in the combo. If pages are re-enabled, they will be re-added to the list." "" no no "" no "LIST" "TabsTABSCombo-BoxCOMBO-BOXRadio-SetRADIO-SET" no no 178000000719.5566
"TemplateControl" 505.7692 1 "Stores OCX control information" "" no no "" no "" "" yes no 702.7692
"TemplateDescription" 505.7692 1 "The description of the template" "" no no "" no "" "" yes no 515.7692
"TemplateFile" 505.7692 1 "The relative path and filename of the static object used as the template at design time" "" no no "" no "" "" yes no 507.7692
"TemplateGroup" 505.7692 1 "Used for grouping templates into one of 4 groups: Container, SmartObject, Procedure and WebObject" "" no no "" no "" "" yes no 509.7692
"TemplateImageFile" 505.7692 1 "Specifies the image to use in the design window." "" no no "" no "" "" yes no 519.7692
"TemplateLabel" 505.7692 1 "The label used for display in the new dialog and in the popup menu" "" no no "" no "" "" yes no 513.7692
"TemplateObjectName" 1003183341 1 "Used by the Dynamic Container Builder Property Sheet." "" no no "" no "" "" yes yes 1007500648.09
"TemplateOrder" 505.7692 4 "Order of the template within it's group" "" no no "" no "" "" yes no 517.7692
"TemplatePropertySheet" 505.7692 1 "Used to associate the dynamic property sheet file to use for the template object." "" no no "" no "" "" yes no 521.7692
"TemplateType" 505.7692 1 "For static and dynamic smartObjects, refers to the data type: (i.e 
SmartDataField, SmartDataBrowser, SmartDataViewer, DynView, etc..)" "" no no "" no "" "" yes no 511.7692
"TempLocation" 432.7063 1 "Decides the temporary location of the LOB Data at runtime.
Values: 
- File - External File in temp-directory
- Memptr - Memptr in instance 
- Longchar - Longchar in instance" "" no no "" no "" "" no yes 54837.66
"TempTables" 152.7063 1 "This property contains a list of temp-table info corresponding to the Tables property or QueryTables property" "SET" no no "" no "" "" no yes 3000031113.09
"ThinRenderingProcedure" 3000002003.09 1 "This procedure specifies the name of the thin procedure that will be used to render an object.  If defined, this thin procedure will be used to render an object when UseThinRendering property is true, otherwise RenderingProcedure will be used.  The value of this attribute will match that of the object name in the Repository, and will be resolved into a pathed filename capable of being run." "" no no "" no "" "" no yes 4620.5498
"THREE-D" 1005078412.09 3 "IF TRUE then Buttons have the 3-D look" "" no no "" no "" "" no no 13517.409
"TimeToLive" 507.49 5 "Time To Live value for messages being sent" "" no no "" no "" "" no yes 934.7063
"TITLE" 1005078412.09 1 "Browser, Frame, Dialog and Window title" "" no no "" no "" "" no no 14674.409
"ToggleDataTargets" 152.7063 3 "Set to FALSE if dataTargets should not be toggled on/of in LinkStatebased based on the passed 'active' or 'inactive' parameter." "" no no "" no "" "" no yes 217.7063
"Toolbar" 430.7063 3 "TRUE if a Toolbar is to be generated." "" no no "" no "" "" no yes 1003498428
"ToolbarAutoSize" 430.7063 3 "Indicates whether the toolbar should be auto-sized to the width of the window at run-time." "" no no "" no "" "" no yes 1003498436
"ToolbarBands" 430.7063 1 "Comma separated list of Toolbar Bands.
NOT USED" "" no no "" no "" "" no yes 1003498434
"ToolbarDrawDirection" 430.7063 1 "The draw direction of the toolbar (horizontal or vertical)." "" no no "" no "" "" no yes 1003498437
"ToolbarInitialState" 430.7063 1 "" "" no no "" no "" "" no yes 1003498438
"ToolbarParentMenu" 430.7063 1 "Only required if any toolbar menus need to be added under a specific submenu, which will also be created if it does not exist." "" no no "" no "" "" no yes 1003498435
"ToolbarSource" 347.7063 1 "A comma-separated list of the handle(s) of the object's toolbar-source" "" yes no "" no "" "" no yes 355.7063
"ToolbarSourceEvents" 347.7063 1 "The list of events to be subscribed to in the Toolbar-Source" "" no no "Class" no "" "" no yes 357.7063
"ToolbarTarget" 430.7063 1 "The handle of the object's toolbar-target. This may be a
delimited list of handles." "" yes no "" no "" "" no yes 723.7063
"ToolbarTargetEvents" 430.7063 1 "The list of events to be subscribed to in the Toolbar-target." "" no no "Class" no "" "" no yes 725.7063
"ToolHeightPxl" 430.7063 4 "" "" no no "" no "" "" no yes 700.7063
"ToolMarginPxl" 430.7063 4 "" "" no no "" no "" "" no yes 1003504309
"ToolMaxWidthPxl" 430.7063 4 "" "" no no "" no "" "" no yes 719.7063
"ToolSeparatorPxl" 430.7063 4 "" "" no no "" no "" "" no yes 696.7063
"ToolSpacingPxl" 430.7063 4 "" "" no no "" no "" "" no yes 694.7063
"TOOLTIP" 1005078412.09 1 "" "" no no "" no "" "" no no 1005099304.101
"ToolWidthPxl" 430.7063 4 "" "" no no "" no "" "" no yes 698.7063
"TopOnly" 1003183341 3 "Indicates if a window is always on top of any other running windows." "SET" no no "" no "" "" no no 2000000085.82
"TransferChildrenForAll" 152.7063 3 "This flag decides whether children for all records (of the batch) is to be transferred from the database. Currently only supported for read event handlers during a fetch. The child SDO is only left with temp-table records for one parent when the fetch*batch is finished." "" no no "" no "" "" no yes 124
"TranslatableProperties" 5.7063 1 "The list of translatable properties, those which should not have a "":U"" following their literal values when code is generated in adm-create-objects.
Because this is a comma-separated list, it should normally be
 invoked indirectly, through modifyListAttribute." "" no no "Class" no "" "" yes yes 46.7063
"TRANSPARENT" 1005078412.09 3 "When TRUE, image background color changes to match the backgorund color of its parent." "" no no "" no "" "" no no 13477.409
"TreeStyle" 1005097792.101 4 "Used to set the property of a SmartTreeView object to indicate the style of the TreeView. The following options are supported:
0 - Text only
1 - Pictures & Text
2 - Text only (Plus/Minus)
3 - Pictures & Text (Plus/Minus)
4 - Text only with tree lines
5 - Pictures & Text with tree lines
6 - Text only with tree lines & plus/minus
7 - Pictures & text with tree lines & plus/minus" "SET" no no "" no "" "" no no 1005081442.28
"TVControllerSource" 3000002003.09 10 "Treeview pointer to the special TVcontainer" "" yes no "" no "" "" no yes 3506.66
"TypeName" 515.49 1 "The name that identifes the document/destination for multi 
document producers" "" no no "" no "" "" no yes 872.7063
"UIBMode" 5.7063 1 "" "" yes no "" no "" "" no yes 35.7063
"UndoDeleteOnSubmitError" 152.7063 1 "Decides whether to immediately undo deleted records after a failed submit. - ERROR - Only undo deletions that causes an error and keep deletions that was rejected just because the transaction failed. Allows immediate resubmit.  (Default) - ALL - Undo all deleted records. - NONE - Keep all deletions. Fix the problem and resave or use the UndoTransaction action to undo." "" no no "" no "" "" no yes 90720.66
"UndoNew" 9.7063 3 "No - Use Cancel to exit Add and Copy mode. 
Yes - Use UndoChange to exit Add and Copy mode.
The option applies to objects where SaveSource is TRUE (TableioSource's TableioType = 'Save') and is set to TRUE in initializeObject if the TableioSource's TableioUndoNew is true (has the UndoChange action with he Cancel action hidden or missing)." "" no no "" no "" "" no yes 84525.66
"UndoOnConflict" 152.7063 1 "Decides which client changes to undo when the save failed due to an optimistic locking conflict. - BEFORE - Overwrite before-image changes only. This mode keeps changes and allows resave. Requires Undo/Reset to show server changes.- NONE - Keeps all changes as well as the previous before-image record. A reread of data is required to save the record.       - CONFLICT - Loose only conflicting field changes.- ALL - Loose all changes on confliciting record." "" no no "" no "" "" no yes 90718.66
"UNIQUE-MATCH" 1005078412.09 1 "" "" no no "" no "" "" no no 1005099333.101
"UpdatableColumns" 154.7063 1 "A comma-separated list of updatable columns in all tables of the query. Note that the data class does not store this, but derrives it from  'UpdatableColumnsByTable'." "" no no "" no "" "" no yes 533.7063
"UpdatableColumnsByTable" 154.7063 1 "A comma-separated list of updatable columns grouped by table and delimited by {&adm-datadelimiter} (defined in the globals include)." "" no no "" no "" "" no yes 531.7063
"UpdatableWhenNew" 152.7063 1 "A comma separated list of columns that only should be updatable in new mode.  The DataVisual class uses this as default in its corresponding EnabledWhenNew property. The client side data object will only accept changes to these columns when the record is new. There is no attempt to enforce this in the transaction logic on the server side." "" no no "" no "" "" no yes 100670.66
"UpdateActive" 347.7063 3 "TRUE if ANY of the contained object's have active updates.
- Updating objects publishes 'updateActive' (true or false) to their  container targets. (from setDataModified, setNewRecord or setRowObjectState).
- If the value is FALSE updateActive turns around and publishes 
 'isUpdateActive', which checks properties involved, to ALL ContainerTargets before it is stored in the UpdateActive property." "" yes no "" no "" "" no yes 412.7063
"UpdateFromSource" 154.7063 3 "'TRUE' if this object should be updated as one-to-one with the datasource updates (one-to-one)" "" no no "" no "" "" no yes 215.7063
"UpdateOrder" 3000002003.09 1 "" "" no no "" no "" "" no no 64529.7063
"UpdateSource" 152.7063 1 "The handle of the object's Update-Source.
This can be defined with pass-through links, to connect an object inside the container with an object outside the container. It is CHARACTER because at least one type of container (SBO)
supports multiple update sources" "" yes no "" no "" "" no yes 176.7063
"UpdateStateInProcess" 428.7063 3 "" "" yes no "" no "" "" no yes 456.7063
"UpdateTables" 428.7063 1 "List of RowObjUpd table handles for contained SDOs" "" yes no "" no "" "" no yes 30044.7063
"UpdateTarget" 9.7063 1 "A character value of the handle of the object's Update Target." "" no no "" no "" "" no yes 116.7063
"UpdateTargetNames" 9.7063 1 "The ObjectName of the Data Object to be updated by this
visual object. This would be set if the Update-Target is an SBO
or other Container with DataObjects.
Currently used when visual objects designed against an SDO with RowObject is linked to an SBO." "get" no no "" no "" "" no yes 1004945564.09
"UpdatingRecord" 438.7063 3 "" "" yes no "" no "" "" no yes 686.7063
"UseBegins" 608.7063 3 "TRUE when BEGINS is supposed to be used as operator  for character values.
NOT used for OperatorStyle ""RANGE"" or ""EXPLICIT""." "" no no "" no "" "" no yes 622.7063
"UseCache" 1005095447.101 3 "When set to TRUE an attempt would be made to read SmartDataField data from a local client cache before fetching the data from the server." "SET" no no "" no "" "" no yes 159199.9875
"UseContains" 608.7063 3 "TRUE when CONTAINS is supposed to be used as operator  for character values.
NOT used for OperatorStyle ""EXPLICIT""." "" no no "" no "" "" no yes 624.7063
"UseSortIndicator" 436.7063 3 "Decides whether the browser should use a graphical arrow in the column label to show sort column and sort direction." "" no no "" no "" "" no yes 78426.66
"ValidateOnLoad" 511.49 3 "Defines whether the document should be validated on load.
See help for X-DOCUMENT:LOAD" "" no no "" no "" "" no yes 950.7063
"VersionData" 36427.48 3 "If set to YES, this field indicates that the data in the table should be version-stamped.This will result in replication triggers on the table writing data to the gst_record_version table. This field corresponds to the entity level UDP setup in ERwin as VersionData. The version information is used to identify which records have changed for deployment purposes. This flag is used in conjunction with the enable_data_versioning on the dataset entity to determine exactly how the entity is versioned." "" yes no "" no "" "" no no 36478.48
"ViewAs" 434.7063 1 "The 'ViewAs' definition  of the selection.
- combo-box,radio-set,selection-list OR browse 
- Uses colon as separator to define SUB-TYPE for combo-box or 
horizontal/vertical radio-set," "" no no "" no "" "" no yes 582.7063
"ViewerLinkedFields" 1005095447.101 1 "Dynamic Lookup Linked fields to update value of on viewer, comma list of table.fieldname." "" no no "" no "" "" no no 1005089880.28
"ViewerLinkedWidgets" 1005095447.101 1 "Dynamic Lookup linked field corresponding widget names to update value of in viewer, comma list, ? if not widget" "" no no "" no "" "" no no 1005089883.28
"VISIBLE" 1005078412.09 3 "WidgetAttributes Visible" "" no no "" no "" "" no no 1005078423.09
"VisibleRowids" 436.7063 1 "This property is used for the scrolling of the browse to trap the 
scroll notify event properly." "" yes no "" no "" "" no yes 496.7063
"VisibleRowReset" 436.7063 3 "Used to reset the list of rowids (VisibleRowids) in rowDisplay." "" yes no "" no "" "" no yes 498.7063
"VisibleRows" 1003183341 4 "" "" no no "" no "" "" no no 1003202030
"VisualBlank" 608.7063 1 "The value that are used to visualize that we actually are 
searching for BLANK values. 
Toggles on and off with space-bar and off with back-space." "" yes no "" no "" "" no yes 654.7063
"VisualizationType" 1005078412.09 1 "WidgetAttributes VisualizationType" "" no no "" no "" "" no no 1005095448.101
"WaitForObject" 347.7063 10 "The handle of the object (most likely a SmartConsumer)  in the container that contains a WAIT-FOR that needs to be started 
with 'startWaitFor'" "" yes no "" no "" "" no yes 371.7063
"Waiting" 505.49 3 "Stores the Waiting property which is used by the adapter's waitForMessages to determne whether to continue waiting for messages." "" no no "" no "" "" no yes 896.7063
"WidgetIDFileName" 347.7063 1 "Name of the XML file used to store the container widget-id values." "" no no "" no "" "" no yes 4542.84251
"Width" 3000002003.09 1 "A widget's width. The unit of measurement is determined by another
parameter." "" no no "" no "" "" no no 1005078416.09
"WIDTH-CHARS" 1005078412.09 5 "Width in characters. This may currently be used when rendering some objects. There is no get function, use getWidth to retrieve the realized value from an object." "" no no "" no "" "" no no 1005099285.101
"WIDTH-PIXELS" 1005078412.09 4 "" "" no no "" no "" "" no no 1005099262.101
"WindowFrameHandle" 347.7063 10 "Stores the optional frame of a Window container.
The somewhat strange name is used because this property ONLY  identifies the frame of a window container and must not be confused with the important ContainerHandle, which is the
widget handle of the container in all objects and in most cases 
stores the frame handle also for a SmartContainer.  
" "" yes no "" no "" "" no yes 379.7063
"WindowName" 1003183341 1 "" "SET" no no "" no "" "" no no 1003571459
"WindowTitleField" 1003183341 1 "" "" no no "" no "" "" no no 1003591184
"WindowTitleViewer" 347.7063 1 "" "" yes no "" no "" "" no yes 410.7063
"WORD-WRAP" 1005078412.09 3 "" "" no no "" no "" "" no no 1005099290.101
"WordIndexedFields" 152.7063 1 "WordIndexedFields is derived from index information, but stored as a property on the client, since it cannot be derived from the client IndexInformation, which typically only has info for the primary table." "GET" no no "" no "" "" no yes 108105.66
"X" 1005078412.09 4 "A widget's X coordinate" "" no no "" no "" "" no no 1005078417.09
"Y" 1005078412.09 4 "A widget's Y coordinate" "" no no "" no "" "" no no 1005078419.09
.
PSC
filename=ryc_attribute
records=0000000000854
ldbname=ICFDB
timestamp=2008/09/16-15:54:31
numformat=44,46
dateformat=mdy-1950
map=NO-MAP
cpstream=UTF-8
.
0000148169
