/***********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights      *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------
    File        : _dswidfunc.p
    Purpose     : Manipulate the widget-id dataset temp-tables 

    Author(s)   : Marcelo Ferrante
    Created     : Thu Jul 19 10:43:39 EDT 2007
    Notes       : This library is run persistent by _widfunc.p and
                  _getwidobjs.w.
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */
{adecomm/dswid.i}
{src/adm2/globals.i}
{src/adm2/tttoolbar.i}
{src/adm2/ttaction.i}
{src/adm2/treettdef.i}

/* ************************  Function Prototypes ********************** */

FUNCTION getRelativeName RETURNS CHARACTER 
	(INPUT pcFullFileName AS CHARACTER) FORWARD.


FUNCTION splitFileName RETURNS LOGICAL 
	(INPUT  pcFileName AS CHARACTER,
     OUTPUT pcPath     AS CHARACTER,
     OUTPUT pcFIle     AS CHARACTER) FORWARD.


FUNCTION createDynContainerDetails RETURNS LOGICAL 
	(INPUT pcObjectName     AS CHARACTER,
     INPUT pdObjectID       AS DECIMAL,
     INPUT pcRootNodeCode   AS CHARACTER,
     INPUT plAssignGaps     AS LOGICAL,
     INPUT DATASET dsWidgetID,
     OUTPUT piLastPage      AS INTEGER,
     OUTPUT plChanged       AS LOGICAL,
     OUTPUT pcNodes         AS CHARACTER,
     INPUT-OUTPUT pcActions AS CHARACTER) FORWARD.


FUNCTION createActions RETURNS LOGICAL 
	(INPUT pcFile AS CHARACTER,
     INPUT pcPath AS CHARACTER,
     INPUT pcActions AS CHARACTER,
     INPUT DATASET dsWidgetID) FORWARD.


FUNCTION createContainerDetails RETURNS LOGICAL 
	(INPUT  pcFile          AS CHARACTER,
     INPUT  pcPath          AS CHARACTER,
     INPUT  phInstance      AS HANDLE,
     INPUT  pcInstance      AS CHARACTER,
     INPUT  plRuntime       AS LOGICAL,
     INPUT  plAssignGaps    AS LOGICAL,
     INPUT  DATASET dsWidgetID,
     OUTPUT plDuplicateName AS LOGICAL,
     OUTPUT piTotalPages    AS INTEGER,
     OUTPUT plChanged       AS LOGICAL,
     INPUT-OUTPUT pcActions       AS CHARACTER,
     INPUT-OUTPUT piLastWidgetID  AS INTEGER,
     INPUT-OUTPUT pcOldObjectType AS CHARACTER) FORWARD.


FUNCTION createContainer RETURNS LOGICAL 
	(INPUT pcFileName        AS CHARACTER,
     INPUT pcObjectType      AS CHARACTER,
     INPUT plCheckDuplicates AS LOGICAL,
     OUTPUT pcFile           AS CHARACTER,
     OUTPUT pcPath           AS CHARACTER,
     INPUT DATASET dsWidgetID) FORWARD.
/* ***************************  Main Block  *************************** */



/* ************************  Function Implementations ***************** */

FUNCTION getRelativeName RETURNS CHARACTER 
    (INPUT pcFullFileName AS CHARACTER):
/*------------------------------------------------------------------------------
    Purpose:
    Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFileName       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTempFileName   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iFileEntries    AS INTEGER    NO-UNDO.
DEFINE VARIABLE iFileEntry      AS INTEGER    NO-UNDO.

ASSIGN pcFullFileName = REPLACE(pcFullFileName, "~\", "/")
       iFileEntries   = NUM-ENTRIES(pcFullFileName, "/").

REPEAT iFileEntry = iFileEntries TO 1 BY -1:
    ASSIGN cTempFileName = ENTRY(iFileEntry, pcFullFileName, "/") + "~\" + cTempFileName
           cTempFileName = TRIM(cTempFileName, "~\").

    IF cTempFileName NE ? THEN ASSIGN cFileName = cFileName + cTempFileName.
    ASSIGN cFileName = LEFT-TRIM(TRIM(REPLACE(SEARCH(cTempFileName), "~\", "/"), "."), "/").

    IF cFileName NE ? THEN RETURN cFileName.
END.

RETURN "".
END FUNCTION.

FUNCTION splitFileName RETURNS LOGICAL 
    (INPUT  pcFileName AS CHARACTER,
     OUTPUT pcPath     AS CHARACTER,
     OUTPUT pcFIle     AS CHARACTER):
/*------------------------------------------------------------------------------
    Purpose:
    Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE iFileSeparatorPos AS INTEGER    NO-UNDO.
ASSIGN iFileSeparatorPos = R-INDEX(pcFileName, "/").

IF iFileSeparatorPos = 0 THEN
    ASSIGN pcFile = pcFileName
           pcPath = "":U.
ELSE
    ASSIGN pcFile = SUBSTRING(pcFileName, iFileSeparatorPos + 1)
           pcPath = SUBSTRING(pcFileName, 1, iFileSeparatorPos - 1).

RETURN TRUE.
END FUNCTION.

FUNCTION createContainer RETURNS LOGICAL 
    (INPUT pcFileName        AS CHARACTER,
     INPUT pcObjectType      AS CHARACTER,
     INPUT plCheckDuplicates AS LOGICAL,
     OUTPUT pcFile           AS CHARACTER,
     OUTPUT pcPath           AS CHARACTER,
     INPUT DATASET dsWidgetID):
/*------------------------------------------------------------------------------
    Purpose: Creates the container record.
    Parameters:
      pcFileName: relative file name of the container.
      pcObjectType: SmartObject type of the container
      plCheckDuplicates: If true, checks if the container already exists and shows
                         a message to the user, to confirm that he/she wants to
                         override the old values.
      OUTPUT pcFile: File name of the container
      OUTPUT pcPath: Relative path of the container
      INPUT-OUTPUT TABLE Container: container temp-table.
    Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE lOk               AS LOGICAL    NO-UNDO.

splitFileName(INPUT pcFileName, OUTPUT pcPath, OUTPUT pcFile).

FIND FIRST Container WHERE Container.contPath = pcPath AND Container.contName = pcFile NO-LOCK NO-ERROR.

IF AVAILABLE Container AND plCheckDuplicates THEN
DO:
    MESSAGE "Container '" pcPath + "/":U + pcFile "' already exists in the Widget-id file." SKIP(1)
            "Do you want to override it?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lOk.

    IF NOT lOk THEN RETURN FALSE.

    FOR EACH Instances OF Container:        DELETE Instances.        END.
    FOR EACH Instance OF Container:         DELETE Instance.         END.
    FOR EACH InstanceChildren OF Container: DELETE InstanceChildren. END.
    FOR EACH ParentPages OF Container:      DELETE ParentPages.      END.
    FOR EACH Pages OF Container:            DELETE Pages.            END.
    FOR EACH Actions OF Container:          DELETE Actions.          END.
    FOR EACH Action OF Container:           DELETE Action.           END.
    FOR EACH TreeNodes OF Container:        DELETE TreeNodes.        END.
    FOR EACH TreeNode OF Container:         DELETE TreeNode.         END.
END. /*IF AVAILABLE Container THEN*/

ELSE DO:
    CREATE Container.
    ASSIGN Container.contName   = pcFile
           Container.contPath   = pcPath
           Container.ObjectType = pcObjectType.
END.

RETURN TRUE.
END FUNCTION.

FUNCTION createContainerDetails RETURNS LOGICAL 
    (INPUT  pcFile          AS CHARACTER,
     INPUT  pcPath          AS CHARACTER,
     INPUT  phInstance      AS HANDLE,
     INPUT  pcInstance      AS CHARACTER,
     INPUT  plRuntime       AS LOGICAL,
     INPUT  plAssignGaps    AS LOGICAL,
     INPUT  DATASET dsWidgetID,
     OUTPUT plDuplicateName AS LOGICAL,
     OUTPUT piTotalPages    AS INTEGER,
     OUTPUT plChanged       AS LOGICAL,
     INPUT-OUTPUT pcActions       AS CHARACTER,
     INPUT-OUTPUT piLastWidgetID  AS INTEGER,
     INPUT-OUTPUT pcOldObjectType AS CHARACTER):
/*------------------------------------------------------------------------------
    Purpose: Create all the container details.
    Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE cObjectType    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cInstanceID    AS CHARACTER NO-UNDO.
DEFINE VARIABLE iInstance      AS INTEGER   NO-UNDO.
DEFINE VARIABLE iObjectGap     AS INTEGER   NO-UNDO.
DEFINE VARIABLE hProcGap       AS HANDLE    NO-UNDO.
DEFINE VARIABLE cTempActions   AS CHARACTER NO-UNDO.
DEFINE VARIABLE iActions       AS INTEGER   NO-UNDO.
DEFINE VARIABLE cPage          AS CHARACTER NO-UNDO.
DEFINE VARIABLE iPage          AS INTEGER   NO-UNDO.
DEFINE VARIABLE cPages         AS CHARACTER NO-UNDO.
DEFINE VARIABLE iField         AS INTEGER   NO-UNDO.
DEFINE VARIABLE cFields        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cField         AS CHARACTER  NO-UNDO.

RUN adecomm/_widgaps.p PERSISTENT SET hProcGap.

IF NOT CAN-FIND(FIRST Instances WHERE Instances.contName = pcFile AND Instances.contPath = pcPath) THEN
DO:
    CREATE Instances.
    ASSIGN Instances.contName = pcFile
           Instances.contPath = pcPath
           plChanged          = TRUE.
END. /* IF NOT CAN-FIND(FIRST Instances WHERE Instances.contName = pcFile AND Instances.contPath = pcPath) THEN */

&SCOPED-DEFINE xp-assign

{get ObjectType cObjectType phInstance}.
&UNDEFINE xp-assign

IF pcInstance NE "" AND pcInstance NE ? THEN
    ASSIGN cInstanceID = pcInstance.
ELSE
{get ObjectName cInstanceID phInstance}.    

ASSIGN iObjectGap     = DYNAMIC-FUNCTION('getWidgetIDGap':U IN hProcGap, INPUT IF pcOldObjectType = "":U THEN "FRAME":U ELSE pcOldObjectType)
       piLastWidgetID = piLastWidgetID + iObjectGap.

        IF piLastWidgetID > 65535 AND plAssignGaps THEN
        DO:
            MESSAGE "The maximum value of 65535 for the widget-id attribute has been reached." SKIP
                    "Widget-id for the remaining objects won't be assigned." SKIP
                    "Review and assign the widget-ids manually." 
                 VIEW-AS ALERT-BOX WARNING
                 TITLE "Runtime Widget-id Assignment tool".
            ASSIGN plAssignGaps = FALSE.
        END.

/*If the object is in design mode, we have to check for duplicate names.*/
IF NOT plRuntime AND (pcInstance = "" OR pcInstance = ?) THEN
DO:
    FIND LAST Instance WHERE Instance.ID BEGINS cInstanceID AND
                             Instance.contPath = pcPath AND
                             Instance.contName = pcFile
                             USE-INDEX cWidgetID
                             NO-LOCK NO-ERROR.
    IF AVAILABLE(Instance) THEN
    DO:
        ASSIGN iInstance       = (IF INDEX(Instance.ID, "(") GT 0 THEN INT(SUBSTRING(Instance.ID, INDEX(Instance.ID, "(") + 1, INDEX(Instance.ID, ")") - INDEX(Instance.ID, "(") - 1)) ELSE 1) + 1
               cInstanceID     = cInstanceID + "(" + STRING(iInstance) + ")"
               plDuplicateName = TRUE.
    END. /* IF CAN-FIND(FIRST Instance WHERE Instance.ID = cInstanceID AND Instance.contPath = pcPath AND Instance.contName = pcFile) THEN */
END. /* IF NOT plRuntime THEN */

FIND FIRST Instance WHERE Instance.ID       = cInstanceID AND
                          Instance.contPath = pcPath AND
                          Instance.contName = pcFile
                          NO-LOCK NO-ERROR.

IF NOT AVAILABLE(Instance) THEN
DO:
    CREATE Instance.
    ASSIGN Instance.ID         = cInstanceID
           Instance.contPath   = pcPath
           Instance.contName   = pcFile
           Instance.ObjectType = cObjectType
           Instance.WidgetID   = IF plAssignGaps THEN piLastWidgetID ELSE 0
           plChanged           = TRUE NO-ERROR.
END.

/*If the instance is a toolbar, we build a variable with all the action names
  in all toolbars, avoiding duplicates.*/
IF DYNAMIC-FUNCTION('instanceOf' IN phInstance, INPUT "toolbar":U) THEN
DO:
    ASSIGN cTempActions = DYNAMIC-FUNCTION('actions':U IN phInstance, INPUT "toolbar":U).  
    REPEAT iActions = 1 TO NUM-ENTRIES(cTempActions):
        IF NOT CAN-DO(pcActions, ENTRY(iActions, cTempActions)) THEN
            ASSIGN pcActions = pcActions + ENTRY(iActions, cTempActions) + ",".
    END. /*REPEAT iActions = 1 TO NUM-ENTRIES(cTempActions):*/
END. /* IF DYNAMIC-FUNCTION('instanceOf' IN phInstance, INPUT "toolbar":U) THEN */

/*If the Instance is a Folder, we have to get the pages in the container.*/
IF DYNAMIC-FUNCTION('instanceOf' IN phInstance, INPUT "SmartFolder":U) THEN
DO:
    {get FolderLabels cPages phInstance}.

    ASSIGN piTotalPages = NUM-ENTRIES(cPages, "|":U)
           iObjectGap   = DYNAMIC-FUNCTION('getWidgetIDGap':U IN hProcGap, INPUT "SmartFolderPage":U).

    IF piTotalPages GT 0 AND NOT CAN-FIND(FIRST ParentPages WHERE ParentPages.contPath = pcPath AND ParentPages.contName = pcFile) THEN
    DO:
        CREATE ParentPages.
        ASSIGN ParentPages.contPath = pcPath
               ParentPages.contName = pcFile
               plChanged            = TRUE.
    END.

    REPEAT iPage = 1 TO piTotalPages:
        ASSIGN cPage = ENTRY(iPage, cPages, "|":U).

        FIND FIRST Pages WHERE Pages.contPath   = pcPath AND
                               Pages.contName   = pcFile AND
                               Pages.PageNumber = iPage NO-ERROR.
        IF NOT AVAILABLE(Pages) THEN
        DO:
            CREATE Pages.
            ASSIGN Pages.contPath   = pcPath
                   Pages.contName   = pcFile
                   Pages.PageNumber = iPage
                   Pages.WidgetID   = iObjectGap * iPage
                   plChanged        = TRUE.
        END. /*IF NOT AVAILABLE(Pages) THEN*/
        ASSIGN Pages.pageLabel  = cPage.
    END. /* REPEAT iPage = 1 TO NUM-ENTRIES(iPages): */
END. /*IF DYNAMIC-FUNCTION('instanceOf' IN b_S._handle, INPUT "folder":U) THEN*/ 

IF DYNAMIC-FUNCTION('instanceOf' IN phInstance, INPUT "Filter":U) THEN
DO: 
    {get DisplayedFields cFields phInstance}.
    ASSIGN iObjectGap = DYNAMIC-FUNCTION('getWidgetIDGap':U IN hProcGap, INPUT "FilterField":U).

    REPEAT iField = 1 TO NUM-ENTRIES(cFields):
        ASSIGN cField = ENTRY(iField, cFields).

        IF NOT CAN-FIND(InstanceChildren WHERE InstanceChildren.contPath         = pcPath      AND 
                                               InstanceChildren.contName         = pcFile      AND 
                                               InstanceChildren.parentInstanceID = Instance.ID AND
                                               InstanceChildren.ID               = cField) THEN 
        DO:
            CREATE InstanceChildren.
            ASSIGN InstanceChildren.ID               = cField
                   InstanceChildren.contPath         = pcPath
                   InstanceChildren.contName         = pcFile
                   InstanceChildren.parentInstanceID = Instance.ID
                   InstanceChildren.ObjectType       = "SmartFilterField":U
                   InstanceChildren.WidgetID         = IF iField = 1 THEN 8 ELSE iObjectGap * (iField - 1) + 8
                   plChanged                         = TRUE.
        END.
    END. /* REPEAT iField = 1 TO NUM-ENTRIES(cFields): */
END. /* IF DYNAMIC-FUNCTION('instanceOf' IN phInstance, INPUT "Filter":U) THEN*/

ASSIGN pcOldObjectType = cObjectType.

DELETE OBJECT hProcGap.

RETURN TRUE.
END FUNCTION.

FUNCTION createActions RETURNS LOGICAL 
    (INPUT pcFile AS CHARACTER,
     INPUT pcPath AS CHARACTER,
     INPUT pcActions AS CHARACTER,
     INPUT DATASET dsWidgetID):
/*------------------------------------------------------------------------------
    Purpose:
    Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE iAction    AS INTEGER   NO-UNDO.
DEFINE VARIABLE cAction    AS CHARACTER NO-UNDO.
DEFINE VARIABLE iObjectGap AS INTEGER   NO-UNDO.
DEFINE VARIABLE iActions   AS INTEGER   NO-UNDO.
DEFINE VARIABLE hProcGap   AS HANDLE    NO-UNDO.

RUN adecomm/_widgaps.p   PERSISTENT SET hProcGap.

IF NOT CAN-FIND(FIRST Actions WHERE Actions.contPath = pcPath AND Actions.contName = pcFile) THEN
DO:
    CREATE Actions.
    ASSIGN Actions.contPath = pcPath
           Actions.contName = pcFile.
END.

ASSIGN pcActions   = TRIM(pcActions, ",":U)
       iActions   = NUM-ENTRIES(pcActions)
       iObjectGap = DYNAMIC-FUNCTION('getWidgetIDGap':U IN hProcGap, INPUT "SmartToolbarActions":U).

REPEAT iAction = 1 TO iActions:
    ASSIGN cAction = ENTRY(iAction, pcActions).

    IF NOT CAN-FIND(FIRST Action WHERE Action.contPath = pcPath AND
                                       Action.contName = pcFile AND
                                       Action.actionID = cAction) THEN
    DO:
        CREATE Action.
        ASSIGN Action.contPath    = pcPath
               Action.contName    = pcFile
               Action.actionID    = cAction
               Action.actionLabel = cAction
               Action.WidgetID    = iObjectGap * iAction.
    END.
END. /* REPEAT iAction = 1 TO iActions: */

DELETE OBJECT hProcGap.

RETURN TRUE. 
END FUNCTION.

FUNCTION createDynContainerDetails RETURNS LOGICAL 
    (INPUT pcObjectName     AS CHARACTER,
     INPUT pdObjectID       AS DECIMAL,
     INPUT pcRootNodeCode   AS CHARACTER,
     INPUT plAssignGaps     AS LOGICAL,
     INPUT DATASET dsWidgetID,
     OUTPUT piLastPage      AS INTEGER,
     OUTPUT plChanged       AS LOGICAL,
     OUTPUT pcNodes         AS CHARACTER,
     INPUT-OUTPUT pcActions AS CHARACTER):
/*------------------------------------------------------------------------------
    Purpose:
    Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE hProcGap        AS HANDLE    NO-UNDO.
DEFINE VARIABLE cInstances      AS CHARACTER NO-UNDO.
DEFINE VARIABLE iInstances      AS INTEGER   NO-UNDO.
DEFINE VARIABLE cInstance       AS CHARACTER NO-UNDO.
DEFINE VARIABLE iInstance       AS INTEGER   NO-UNDO.
DEFINE VARIABLE cPropertyNames  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPropertyValues AS CHARACTER NO-UNDO.
DEFINE VARIABLE dInstanceID     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dOldObjectType  AS DECIMAL NO-UNDO.
DEFINE VARIABLE cLogicalName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cInstanceType   AS CHARACTER NO-UNDO.
DEFINE VARIABLE iObjectGap      AS INTEGER   NO-UNDO.
DEFINE VARIABLE iLastWidgetID   AS INTEGER   NO-UNDO.
DEFINE VARIABLE cFolderPages    AS CHARACTER NO-UNDO.
DEFINE VARIABLE iItems          AS INTEGER   NO-UNDO.
DEFINE VARIABLE iItem           AS INTEGER   NO-UNDO.
DEFINE VARIABLE cItem           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOldObjectType  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNodeKey        AS CHARACTER NO-UNDO.
DEFINE VARIABLE iActions        AS INTEGER   NO-UNDO.
DEFINE VARIABLE cUsedToolbars   AS CHARACTER NO-UNDO.
DEFINE VARIABLE lIsLocalWidget  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lIsOldLocalWidget  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lIsDynView      AS LOGICAL   NO-UNDO.

RUN adecomm/_widgaps.p PERSISTENT SET hProcGap.

    /*Gets the instance names contained in the current container*/
    RUN getContainedInstanceNames IN gshRepositoryManager (
        INPUT  pcObjectName,
        OUTPUT cInstances) NO-ERROR.

    ASSIGN cInstances = TRIM(cInstances, ",")
           iInstances  = NUM-ENTRIES(cInstances).

    /*Loop to navigate every instance.*/
    REPEAT iInstance = 1 TO iInstances:
        ASSIGN cInstance      = ENTRY(iInstance, cInstances)
               cPropertyNames = "InstanceId,ClassName,ActionGroups,FolderLabels,LogicalObjectName":U.

        IF cInstance = "":U THEN NEXT.

        /*Gets the required properties for the current instance*/
        RUN getInstanceProperties IN gshRepositoryManager (
            INPUT        pcObjectName,
            INPUT        cInstance, 
            INPUT-OUTPUT cPropertyNames,
                  OUTPUT cPropertyValues) NO-ERROR.

        ASSIGN dInstanceId       = DECIMAL(ENTRY(LOOKUP("InstanceId":U, cPropertyNames), cPropertyValues, CHR(1)))
               cInstanceType     = ENTRY(LOOKUP("ClassName":U, cPropertyNames), cPropertyValues, CHR(1))
               lIsLocalWidget    = DYNAMIC-FUNCTION('isA' IN gshRepositoryManager, INPUT dInstanceId, "ProgressWidget":U)
               lIsOldLocalWidget = DYNAMIC-FUNCTION('isA' IN gshRepositoryManager, INPUT dOldObjectType, "ProgressWidget":U)
               lIsDynView        = DYNAMIC-FUNCTION('isA' IN gshRepositoryManager, INPUT pdObjectID, "DynView":U).

        /*If the widget is a local widget (i.e.: button, fill-in, etc), then we have to treat it as a DataField.*/
        IF lIsOldLocalWidget THEN
            ASSIGN iObjectGap = DYNAMIC-FUNCTION('getWidgetIDGap':U IN hProcGap, INPUT "DataField":U).
        ELSE IF lIsDynView AND cOldObjectType = "":U THEN
            iObjectGap = DYNAMIC-FUNCTION('getWidgetIDGap':U IN hProcGap, INPUT "DataField":U).
        ELSE
            ASSIGN iObjectGap = DYNAMIC-FUNCTION('getWidgetIDGap':U IN hProcGap, INPUT IF cOldObjectType = "":U THEN "FRAME":U ELSE cOldObjectType).

        ASSIGN iLastWidgetID = iLastWidgetID + iObjectGap.

        IF CAN-DO(cPropertyNames, "LogicalObjectName":U) THEN
             ASSIGN cLogicalName  = ENTRY(LOOKUP("LogicalObjectName":U, cPropertyNames), cPropertyValues, CHR(1)).

        IF iLastWidgetID > 65535 AND plAssignGaps THEN
        DO:
            MESSAGE "The maximum value of 65535 for the widget-id attribute has been reached." SKIP
                    "Widget-id for the remaining objects won't be assigned." SKIP
                    "Review and assign the widget-ids manually." 
                 VIEW-AS ALERT-BOX WARNING
                 TITLE "Runtime Widget-id Assignment tool".
            ASSIGN plAssignGaps = FALSE.
        END.

        IF DYNAMIC-FUNCTION('isA' IN gshRepositoryManager, INPUT dInstanceId, "SBO":U) THEN NEXT.

        /*We only need Visual and DataField objects*/
        IF NOT DYNAMIC-FUNCTION('isA' IN gshRepositoryManager, INPUT dInstanceId, "Visual") AND 
           NOT DYNAMIC-FUNCTION('isA' IN gshRepositoryManager, INPUT dInstanceId, "DataField") AND 
           NOT lIsLocalWidget THEN NEXT.

        /*Creates the Instance parent node for the container, if this does not exist.*/
        IF NOT CAN-FIND(FIRST Instances WHERE Instances.contName = pcObjectName AND Instances.contPath = "") THEN
        DO:
            CREATE Instances.
            ASSIGN Instances.contName = pcObjectName
                   Instances.contPath = ""
                   plChanged          = TRUE.
        END.

        /*Create the instance record*/
        IF NOT CAN-FIND(FIRST Instance WHERE Instance.contPath = "" AND
                                             Instance.contName = pcObjectName AND
                                             Instance.ID = cInstance) THEN
        DO:
            CREATE Instance.
            ASSIGN Instance.ID         = cInstance
                   Instance.contPath   = ""
                   Instance.contName   = pcObjectName
                   Instance.ObjectType = cInstanceType
                   plChanged           = TRUE
                   Instance.WidgetID   = IF plAssignGaps THEN iLastWidgetID ELSE 0 NO-ERROR.
        END.

        /*If the instance is a folder, then get and create the folder pages*/
        IF DYNAMIC-FUNCTION('isA' IN gshRepositoryManager, INPUT dInstanceId, "SmartFolder") THEN
        DO:
            ASSIGN cFolderPages = ENTRY(LOOKUP("FolderLabels":U, cPropertyNames), cPropertyValues, CHR(1))
                   iItems       = NUM-ENTRIES(cFolderPages, "|")
                   piLastPage   = iItems
                   iObjectGap   = DYNAMIC-FUNCTION('getWidgetIDGap':U IN hProcGap, INPUT "SmartFolderPage":U).

            IF iItems GT 0 AND NOT CAN-FIND(FIRST ParentPages WHERE ParentPages.contPath = "" AND ParentPages.contName = pcObjectName) THEN
            DO:
                CREATE ParentPages.
                ASSIGN ParentPages.contPath = ""
                       ParentPages.contName = pcObjectName
                       plChanged            = TRUE.
            END.

            REPEAT iItem = 1 TO iItems:
                ASSIGN cItem = ENTRY(iItem, cFolderPages, "|").

                FIND FIRST Pages WHERE Pages.contPath   = ""           AND
                                       Pages.contName   = pcObjectName AND
                                       Pages.pageNumber = iItem NO-ERROR.
                IF NOT AVAILABLE(Pages) THEN
                DO:
                    CREATE Pages.
                    ASSIGN Pages.contPath   = ""
                           Pages.contName   = pcObjectName
                           Pages.PageNumber = iItem
                           Pages.WidgetID   = iObjectGap * iItem
                           plChanged        = TRUE.
                END.
                ASSIGN Pages.pageLabel  = cItem.
            END. /*REPEAT iItem = 1 TO iItems:*/
        END. /*IF cInstance = "SmartFolder":U THEN*/

        /*If the instance is a Toolbar, we build a variable with the toolbar names, to later get all the
          toolbar actions in one call to the API*/
        IF DYNAMIC-FUNCTION('isA' IN gshRepositoryManager, INPUT dInstanceId, "Toolbar") THEN
        DO:
            /*Avoid to get duplicate toolbar actions*/
            IF CAN-DO(cUsedToolbars, cLogicalName) THEN NEXT.

            /*Get and create all the toolbar actions that are involved in the current container*/
            ASSIGN iObjectGap = DYNAMIC-FUNCTION('getWidgetIDGap':U IN hProcGap, INPUT "SmartToolbarActions":U)
                   cUsedToolbars = cUsedToolbars + "," + cLogicalName
                   cUsedToolbars = TRIM(cUsedToolbars, ",").

            /*Create the action parent node, if this does not exist.*/
            IF NOT CAN-FIND(FIRST Actions WHERE Actions.contPath = "":U AND Actions.contName = pcObjectName) THEN
            DO:
                CREATE Actions.
                ASSIGN Actions.contPath = ""
                       Actions.contName = pcObjectName
                       plChanged        = TRUE.
            END.

            /*Gets all the actions that are in all the toolbars in the selected container.*/
            RUN getToolbarBandActions IN gshRepositoryManager (
                INPUT cLogicalName,
                INPUT "Actions":U,
                INPUT ENTRY(LOOKUP("ActionGroups":U, cPropertyNames), cPropertyValues, CHR(1)),
                OUTPUT TABLE ttToolbarBand,
                OUTPUT TABLE ttObjectBand,
                OUTPUT TABLE ttBand,
                OUTPUT TABLE ttBandAction,    
                OUTPUT TABLE ttAction,
                OUTPUT TABLE ttCategory) NO-ERROR.

            /*Creates the actions*/
            FOR EACH ttToolbarBand NO-LOCK WHERE ttToolbarBand.ToolbarName = cLogicalName, 
                EACH ttBand NO-LOCK WHERE ttBand.Band = ttToolbarBand.Band AND
                                          (ttBand.bandType = "Toolbar":U OR
                                           ttBand.bandType = "Menu&Toolbar":U),
                EACH ttBandAction NO-LOCK OF ttBand,
                EACH ttAction     NO-LOCK OF ttBandAction:

                IF NOT CAN-DO(pcActions, ttAction.Action) THEN
                    ASSIGN pcActions = pcActions + ttAction.Action + ",":U.

                IF CAN-FIND(FIRST Action WHERE Action.contPath = "" AND 
                                               Action.contName = pcObjectName AND
                                               Action.actionID = ttAction.Action)
                THEN NEXT.

                CREATE Action.
                ASSIGN iActions           = iActions + 1
                       Action.contPath    = ""
                       Action.contName    = pcObjectName
                       Action.actionID    = ttAction.Action
                       Action.actionLabel = ttAction.Action
                       Action.WidgetID    = iObjectGap * iActions
                       plChanged          = TRUE.
            END. /*FOR EACH ttToolbarBand NO-LOCK:*/
        END. /*IF DYNAMIC-FUNCTION('isA' IN gshRepositoryManager, INPUT dInstanceId, "Toolbar") THEN*/

        ASSIGN cOldObjectType = cInstanceType
               dOldObjectType = dInstanceID.
    END. /*REPEAT iInstance = 1 TO iInstances:*/

    /*If the object is a DynTree, we have to get the containers to be launched for each node.*/
    IF DYNAMIC-FUNCTION('isA' IN gshRepositoryManager, INPUT pdObjectId, "DynTree") THEN
    DO:
        ASSIGN iObjectGap = DYNAMIC-FUNCTION('getWidgetIDGap':U IN hProcGap, INPUT "TreeNode":U).
        FIND LAST TreeNode WHERE TreeNode.contPath = "":U AND
                                 TreeNode.contName = pcObjectName
                                 USE-INDEX cWidgetID NO-LOCK NO-ERROR.
        IF AVAILABLE(TreeNode) THEN
            ASSIGN iLastWidgetID = TreeNode.widgetID + iObjectGap.

        RUN ry/app/rytrenodep.p (INPUT pcRootNodeCode,
                                 INPUT ?,
                                 OUTPUT TABLE ttNode ).

        /*Creates the Instance parent node for the container, only if nodes were found, and it was not previously created.*/
        IF NOT CAN-FIND(FIRST TreeNodes WHERE TreeNodes.contName = pcObjectName AND TreeNodes.contPath = "") AND
               CAN-FIND(FIRST ttNode) THEN
        DO:
            CREATE TreeNodes.
            ASSIGN TreeNodes.contName = pcObjectName
                   TreeNodes.contPath = ""
                   plChanged          = TRUE.
        END.

        FOR EACH ttNode NO-LOCK WHERE ttNode.LOGICAL_object NE "":U:

            ASSIGN cNodeKey = ttNode.node_code + "_":U + ttNode.logical_object.
            IF NOT CAN-DO(pcNodes, cNodeKey) THEN
                ASSIGN pcNodes = pcNodes + cNodeKey + ",":U.

            IF NOT CAN-FIND(FIRST TreeNode WHERE TreeNode.contPath = "":U AND
                                                 TreeNode.contName = pcObjectName AND
                                                 TreeNode.ID       = cNodeKey) THEN
            DO:
                ASSIGN iLastWidgetID       = iLastWidgetID + iObjectGap.
                IF iLastWidgetID > 65535 AND plAssignGaps THEN
                DO:
                    MESSAGE "The maximum value of 65535 for the widget-id attribute has been reached." SKIP
                            "Widget-id for the remaining objects won't be assigned." SKIP
                            "Review and assign the widget-ids manually." 
                         VIEW-AS ALERT-BOX WARNING
                         TITLE "Runtime Widget-id Assignment tool".
                    ASSIGN plAssignGaps = FALSE.
                END.

                CREATE TreeNode.
                ASSIGN TreeNode.ID         = cNodeKey
                       TreeNode.cLabel     = ttNode.node_code + " (" + ttNode.logical_object + ")"
                       TreeNode.contPath   = "":U
                       TreeNode.contName   = pcObjectName
                       TreeNode.ObjectType = "TreeNode":U
                       TreeNode.WidgetID   = IF plAssignGaps THEN iLastWidgetID ELSE 0 
                       plChanged           = TRUE
                       NO-ERROR.
            END. /* IF NOT CAN-FIND(FIRST TreeNode */
        END. /*FOR EACH ttNode NO-LOCK:*/
    END. /*IF DYNAMIC-FUNCTION('isA' IN gshRepositoryManager, INPUT dObjectId, "DynTree") THEN*/

    ASSIGN iLastWidgetID  = 0
           iObjectGap     = 0
           cOldObjectType = "":U
           pcActions      = TRIM(pcActions, ",":U)
           pcNodes        = TRIM(pcNodes, ",":U).

IF VALID-HANDLE(hProcGap) THEN
   DELETE OBJECT hProcGap.
   
RETURN TRUE.

END FUNCTION.



/* **********************  Internal Procedures  *********************** */

PROCEDURE getRuntimeObjectNames:
/*------------------------------------------------------------------------------
    Purpose: Returns the SmartObject container names that are running
             in the session.
    Parameters: <none>
    Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phParent        AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER pcExcludeObject AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttObjectNames.

DEFINE VARIABLE cValidContainers AS CHARACTER  NO-UNDO INITIAL
    "DynTree,DynObjc,DynMenc,DynFold,DynFrame,SmartWindow,SmartDialog,SmartFrame,SmartDataViewer":U.
DEFINE VARIABLE isContainer AS LOGICAL   NO-UNDO.
DEFINE VARIABLE iContainers AS INTEGER   NO-UNDO.
DEFINE VARIABLE iContainer  AS INTEGER   NO-UNDO.
DEFINE VARIABLE hChild      AS HANDLE    NO-UNDO.
DEFINE VARIABLE hProc       AS HANDLE    NO-UNDO.
DEFINE VARIABLE cObjectType AS CHARACTER NO-UNDO.
DEFINE VARIABLE cObjectName AS CHARACTER NO-UNDO.
DEFINE VARIABLE lStatic     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cTargets    AS CHARACTER NO-UNDO.
DEFINE VARIABLE hTarget     AS HANDLE    NO-UNDO.
DEFINE VARIABLE iTarget     AS INTEGER   NO-UNDO.
DEFINE VARIABLE hTVSource   AS HANDLE    NO-UNDO.
DEFINE VARIABLE cTVSource   AS CHARACTER NO-UNDO.

REPEAT WHILE VALID-HANDLE(phParent):
    IF phParent:TYPE EQ "PROCEDURE":U THEN
    ASSIGN hProc = phParent.
    ELSE
    ASSIGN hProc = phParent:INSTANTIATING-PROCEDURE.
    IF hProc NE ? THEN
    DO:
        {get ObjectType cObjectType hProc} NO-ERROR.
        IF NOT ERROR-STATUS:ERROR AND cObjectType NE ? AND cObjectType NE 'SUPER':U THEN
        DO:
           /*We have to validate that the container is one of the valid container classes.
             For example, DynBrow inherits from container, but this is not considered as container in
             the widget-id assignment tool. So we have to filter that.*/
           ASSIGN iContainers = NUM-ENTRIES(cValidContainers).
           REPEAT iContainer = 1 TO iContainers:
               ASSIGN isContainer = DYNAMIC-FUNCTION('instanceOf':U IN hProc, INPUT ENTRY(iContainer, cValidContainers)) NO-ERROR.
               IF isContainer = TRUE THEN LEAVE.
           END.
           IF NOT ERROR-STATUS:ERROR AND isContainer THEN
           DO:
               {get LogicalObjectName cObjectName hProc} NO-ERROR.
               ASSIGN lStatic = (cObjectName = "":U).

               IF cObjectName = "":U THEN
               ASSIGN cObjectName = hProc:FILE-NAME.

               ASSIGN cObjectName = REPLACE(cObjectName, "~\":U, "/":U).

               IF NOT CAN-FIND(FIRST ttObjectNames WHERE ttObjectNames.cName = cObjectName) THEN
               DO:
                   CREATE ttObjectNames.
                   ASSIGN ttObjectNames.cName    = cObjectName
                          ttObjectNames.isStatic = lStatic
                          ttObjectNames.lImport  = NOT CAN-DO(cObjectName, pcExcludeObject)
                          ttObjectNames.hHandle  = hProc.
               END.

               {get ContainerTarget cTargets hProc} NO-ERROR.
               IF cTargets NE "" AND NOT ERROR-STATUS:ERROR THEN
               DO:
                   REPEAT iTarget = 1 TO NUM-ENTRIES(cTargets):
                       ASSIGN hTarget = WIDGET-HANDLE(ENTRY(iTarget, cTargets)).

                       /*Due to the DynTree structure and the way it is created, if the running object is a folder in
                         a treeview, we get the folder name but not the treeview container name. So we have to check if the
                         the running object has a TVController-source link. If yes, is because we are running a DynTree,
                         so we have to get the name of the Container that handles the treeview.*/
                       ASSIGN cTVSource = DYNAMIC-FUNCTION('linkhandles' IN hProc, INPUT "TVController-source") NO-ERROR.
                       IF NOT ERROR-STATUS:ERROR AND cTVSource NE "":U THEN                       DO: 
                           ASSIGN hTVSource = WIDGET-HANDLE(cTVSource)
                                  hTVSource = DYNAMIC-FUNCTION('getContainerSource' IN hTVSource)
                                  cTVSource = DYNAMIC-FUNCTION('getTreeLogicalName' IN hTVSource).

                           IF cTVSource NE "":U AND cTVSource NE ? THEN                           DO:
                               IF NOT CAN-FIND(FIRST ttObjectNames WHERE ttObjectNames.cName = cTVSource) THEN
                               DO:
                                   CREATE ttObjectNames.
                                   ASSIGN ttObjectNames.cName    = cTVSource
                                          ttObjectNames.isStatic = FALSE /*Force the TreeView container to be dynamic*/
                                          ttObjectNames.lImport  = NOT CAN-DO(cTVSource, pcExcludeObject)
                                          ttObjectNames.hHandle  = hTVSource.
                               END.
                           END. /*IF cTVSource NE "":U AND cTVSource NE ? THEN*/
                       END. /* IF NOT ERROR-STATUS:ERROR AND cTVSource NE "":U THEN */
                       IF DYNAMIC-FUNCTION('instanceOf':U IN hTarget, INPUT 'Container':U) THEN
                           RUN getRuntimeObjectNames (INPUT hTarget, INPUT pcExcludeObject, INPUT-OUTPUT TABLE ttObjectNames).
                   END.
               END. /*IF cTargets NE "" THEN*/
           END. /*IF DYNAMIC-FUNCTION('instanceOf':U IN hProc, INPUT 'Container':U) THEN*/
        END. /*IF NOT ERROR-STATUS:ERROR AND cObjectType NE ? THEN*/
    END. /* IF hProc NE ? THEN */

    ASSIGN phParent = phParent:NEXT-SIBLING NO-ERROR.
    IF ERROR-STATUS:ERROR THEN LEAVE.
END. /*REPEAT WHILE VALID-HANDLE(phParent):*/

RETURN.
END PROCEDURE.