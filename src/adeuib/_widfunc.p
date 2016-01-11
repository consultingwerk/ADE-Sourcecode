/***********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights      *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------
    File        : _widfunc.p
    Purpose     : Get AppBuilder information to be used by the Widget-id
                  Assignment tool.

    Syntax      :

    Description : Library with functions required for the Widget-id
                  assignemt tool to get and set information in the
                  AppBuilder.

    Author(s)   : Marcelo Ferrante
    Created     : Thu Jun 14 11:05:07 EDT 2007
    Notes       : This procedure is run persistent in the 'Runtime
                  Widget-id Assignment Tool' (adecomm/_assign-wid.w).
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{adeuib/uniwidg.i}       /* Universal Widget TEMP-TABLE definition      */
{adecomm/dswid.i}
{adeuib/sharvars.i}

/*Objects like SmartToolbars or SmartFilters have the same object name at design time, their names are
  changed at runtime. So we have to be sure that we are not checking twice the same object.*/
DEFINE TEMP-TABLE ttSynchedObjects NO-UNDO
FIELD cObjectName AS CHARACTER
INDEX ckey cObjectName.

/*This temp-table is used in syncStaticObject to store the InstanceChildren record before
  the container is synchronized, and then detect the deletions.*/
DEFINE TEMP-TABLE beforeInstanceChildren NO-UNDO LIKE InstanceChildren.

/* ********************  Preprocessor Definitions  ******************** */

/* ************************  Function Prototypes ********************** */

FUNCTION refreshDPS RETURNS LOGICAL 
	(INPUT pcContainerObj AS CHARACTER,
	 INPUT pcObjectObj    AS CHARACTER,
     INPUT pcAttName      AS CHARACTER,
     INPUT pcValue        AS CHARACTER) FORWARD.


FUNCTION getAppBuilderStatus RETURNS CHARACTER 
	(  ) FORWARD.


FUNCTION setWidgetIDFileName RETURNS LOGICAL 
	(INPUT pcFileName         AS CHARACTER,
     INPUT pcWidgetIDFileName AS CHARACTER) FORWARD.

FUNCTION getContainerClasses RETURNS CHARACTER 
	(  ) FORWARD.

PROCEDURE getDesignObjectNames:
/*------------------------------------------------------------------------------
    Purpose: Returns the Container names that are opened in design mode.
    Parameters: OUTUPT TABLE ttObjectNames.
    Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcExcludeObject AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttObjectNames.

DEFINE VARIABLE cFileName  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDSLibrary AS HANDLE     NO-UNDO.

DEFINE BUFFER b_P FOR _P.

RUN adecomm/_dswidfunc.p PERSISTENT SET hDSLibrary.

FOR EACH b_P WHERE b_P._save-as-file NE ? AND
                   CAN-DO(getContainerClasses(), b_P._type):

    ASSIGN cFileName = IF b_P.static_object = TRUE THEN DYNAMIC-FUNCTION('getRelativeName':U IN hDSLibrary, INPUT (IF b_P.object_path NE "":U
                                                                     THEN REPLACE(b_P.object_path, "/":U, "~\":U) + "~\":U 
                                                                     ELSE "":U) + b_P._save-as-file)
                                                   ELSE b_P._save-as-file.

    IF NOT CAN-FIND(FIRST ttObjectNames WHERE ttObjectNames.cName = cFileName) THEN 
    DO:
        CREATE ttObjectNames.
        ASSIGN ttObjectNames.cName    = cFileName
               ttObjectNames.isStatic = b_P.static_object.

        IF CAN-DO(pcExcludeObject, cFileName) THEN
        ASSIGN ttObjectNames.lImport = FALSE.
    END.
END.

DELETE OBJECT hDSLibrary NO-ERROR.
RETURN.
END PROCEDURE.

PROCEDURE getStaticDesignObject:
/*------------------------------------------------------------------------------
    Purpose:
    Parameters: <none>
    Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER plAssignGaps AS LOGICAL    NO-UNDO.
DEFINE INPUT        PARAMETER TABLE   FOR ttObjectNames.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsWidgetID.

DEFINE VARIABLE cFile             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPath             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lIsVisual         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cActions          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iFileSeparatorPos AS INTEGER    NO-UNDO.
DEFINE VARIABLE lShowWarning      AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE lOk               AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lDuplicateName    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hDSLibrary        AS HANDLE     NO-UNDO.
DEFINE VARIABLE cOldObjectType    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLastWidgetID     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLastPage         AS INTEGER    NO-UNDO.
DEFINE VARIABLE lChanged          AS LOGICAL    NO-UNDO.

TEMP-TABLE Pages:TRACKING-CHANGES            = TRUE.
TEMP-TABLE Action:TRACKING-CHANGES           = TRUE.
TEMP-TABLE Instance:TRACKING-CHANGES         = TRUE.
TEMP-TABLE InstanceChildren:TRACKING-CHANGES = TRUE.

DEFINE BUFFER b_P FOR _P.
DEFINE BUFFER b_U FOR _U.
DEFINE BUFFER b_S FOR _S.

DEFINE BUFFER parent_U FOR _U.

RUN adecomm/_dswidfunc.p PERSISTENT SET hDSLibrary.

FOR EACH ttObjectNames WHERE ttObjectNames.lImport  = TRUE AND
                             ttObjectNames.isStatic = TRUE NO-LOCK:

    ASSIGN FILE-INFO:FILE-NAME = ttObjectNames.cName
           iFileSeparatorPos   = R-INDEX(ttObjectNames.cName, "/")
           lShowWarning        = TRUE
           lDuplicateName      = FALSE.

    FIND FIRST b_P WHERE b_P._save-as-file = IF FILE-INFO:FULL-PATHNAME NE ? THEN FILE-INFO:FULL-PATHNAME ELSE SUBSTRING(ttObjectNames.cName, iFileSeparatorPos + 1) NO-LOCK NO-ERROR.

    IF NOT AVAILABLE(b_P) THEN
    DO:
        MESSAGE "Information for container object '" + ttObjectNames.cName + "' cannot be retrieved."
             VIEW-AS ALERT-BOX.
        NEXT.
    END. /*IF NOT AVAILABLE(b_P) THEN*/

    /*If this is a static object, we have to get the data from the AppBuilder temp-tables*/
    IF b_P.static_object THEN
    DO:
        IF NOT DYNAMIC-FUNCTION('createContainer':U IN  hDSLibrary,
                   INPUT ttObjectNames.cName,
                   INPUT b_P._type,
                   INPUT TRUE,
                   OUTPUT cFile,
                   OUTPUT cPath,
                   INPUT DATASET dsWidgetID BY-REFERENCE)
        THEN NEXT.

        FIND FIRST parent_U WHERE parent_U._parent-recid = b_P._u-recid AND
                                  RECID(parent_U) NE b_P._u-recid NO-LOCK NO-ERROR.

        FOR EACH b_U NO-LOCK WHERE b_U._parent-recid = RECID(parent_U) AND b_U._type = "SmartObject":U:

            FIND FIRST b_S WHERE RECID(b_S) = b_U._x-recid NO-LOCK NO-ERROR.

            /*We are only interested in visual objects (instanceOf=visual), and smartobject (b_S=available).*/
            IF AVAILABLE(b_S) THEN
            DO:
                ASSIGN lIsVisual = DYNAMIC-FUNCTION('instanceOf' IN b_S._handle, INPUT "visual":U) NO-ERROR.

                IF NOT lIsVisual OR lIsVisual = ? THEN
                    NEXT.

                DYNAMIC-FUNCTION('createContainerDetails':U IN hDSLibrary,
                    INPUT cFile,
                    INPUT cPath,
                    INPUT b_S._handle,
                    INPUT "",
                    INPUT FALSE,
                    INPUT plAssignGaps,
                    INPUT DATASET dsWidgetID BY-REFERENCE,
                    OUTPUT lDuplicateName,
                    OUTPUT iLastPage,
                    OUTPUT lChanged,
                    INPUT-OUTPUT cActions,
                    INPUT-OUTPUT iLastWidgetID,
                    INPUT-OUTPUT cOldObjectType).

                IF iLastWidgetID > 65535 THEN
                    ASSIGN plAssignGaps = FALSE.
            END. /*IF AVAILABLE(b_S) AND DYNAMIC-FUNCTION('instanceOf' IN b_s._handle, INPUT "visual") */
        END. /* FOR EACH b_U NO-LOCK WHERE b_U._parent-recid = RECID(parent_U): */
    END. /*IF b_P.static_object THEN*/

    ELSE
        ASSIGN cFile = b_P._save-as-file
               cPath = b_p.object_path.

    /*If we have actions, we have to create them*/
    IF cActions NE "" THEN
    DO: 
        DYNAMIC-FUNCTION('createActions':U IN hDSLibrary,
            INPUT cFile,
            INPUT cPath,
            INPUT cActions,
            INPUT DATASET dsWidgetID BY-REFERENCE).

        ASSIGN cActions  = "". 
    END. /*IF cActions NE "" THEN*/

    IF lShowWarning = TRUE AND lDuplicateName THEN
    DO:
        MESSAGE "More than one object has the same 'Instance name' in the '" + ttObjectNames.cName + "' Container at design time," SKIP
                "it could cause conflicts with the widget-id values." SKIP
                "In order to avoid this problem use this option with the Container in runtime." SKIP(1)
                "Do you want to continue?" 
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lOk.

        IF NOT lOk THEN
        DO:
            DELETE Container.
            DATASET dsWidgetID:REJECT-CHANGES().
        END.

        ASSIGN lShowWarning = FALSE.
    END. /*IF lShowWarning = TRUE THEN*/
    DATASET dsWidgetID:ACCEPT-CHANGES().
    ASSIGN cOldObjectType = "":U
           iLastWidgetID  = 0.
END. /*FOR EACH ttObjectNames NO-LOCK WHERE ttObjectNames.lImport = TRUE:*/

TEMP-TABLE Pages:TRACKING-CHANGES            = FALSE.
TEMP-TABLE Action:TRACKING-CHANGES           = FALSE.
TEMP-TABLE Instance:TRACKING-CHANGES         = FALSE.
TEMP-TABLE InstanceChildren:TRACKING-CHANGES = FALSE.

DELETE OBJECT hDSLibrary.

RETURN.
END PROCEDURE.

FUNCTION getContainerClasses RETURNS CHARACTER 
    (  ):
/*------------------------------------------------------------------------------
    Purpose: Returns a list of known container objects.
    Notes:
------------------------------------------------------------------------------*/
RETURN "DynTree,DynObjc,DynMenc,DynFold,DynFrame,SmartWindow,SmartDialog,SmartFrame,SmartDataViewer":U.
END FUNCTION.

PROCEDURE syncStaticObject:
/*------------------------------------------------------------------------------
    Purpose:
    Parameters: <none>
    Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER pcFileName      AS CHARACTER  NO-UNDO.
DEFINE INPUT        PARAMETER pcFilePath      AS CHARACTER  NO-UNDO.
DEFINE INPUT        PARAMETER pcFileFullName  AS CHARACTER  NO-UNDO.
DEFINE INPUT        PARAMETER plAssignGaps    AS LOGICAL    NO-UNDO.
DEFINE       OUTPUT PARAMETER plChanged       AS LOGICAL    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsWidgetID.

DEFINE VARIABLE cObjectName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectType    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lIsVisual      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iInstance      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iField         AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFields        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE tmpChanged     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cInstanceList  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cToolbarBands  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iToolbarBand   AS INTEGER    NO-UNDO.
DEFINE VARIABLE cTempActions   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cActions       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iActions       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iAction        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cAction        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLastPage      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iCurrPage      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLastWidgetID  AS INTEGER    NO-UNDO.
DEFINE VARIABLE cOldObjectType AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDSLibrary     AS HANDLE     NO-UNDO.

DEFINE VARIABLE lWarning      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lShowWarning  AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE lOk           AS LOGICAL    NO-UNDO.

TEMP-TABLE Pages:TRACKING-CHANGES            = TRUE.
TEMP-TABLE Action:TRACKING-CHANGES           = TRUE.
TEMP-TABLE Instance:TRACKING-CHANGES         = TRUE.
TEMP-TABLE InstanceChildren:TRACKING-CHANGES = TRUE.

DEFINE BUFFER b_P FOR _P.
DEFINE BUFFER b_U FOR _U.
DEFINE BUFFER b_S FOR _S.

DEFINE BUFFER parent_U FOR _U.

EMPTY TEMP-TABLE ttSynchedObjects.

RUN adecomm/_dswidfunc.p PERSISTENT SET hDSLibrary.

    FIND FIRST b_P WHERE b_P._save-as-file = pcFileFullName NO-LOCK NO-ERROR.

    IF NOT AVAILABLE(b_P) THEN
    DO:
        MESSAGE "Information for container object '" + pcFileFullName + "' cannot be retrieved."
             VIEW-AS ALERT-BOX.
        RETURN ERROR.
    END. /*IF NOT AVAILABLE(b_P) THEN*/

    /*If this is a static object, we have to get the data from the AppBuilder temp-tables*/
    IF b_P.static_object THEN
    DO:
        FIND FIRST parent_U WHERE parent_U._parent-recid = b_P._u-recid AND
                                  RECID(parent_U) NE b_P._u-recid NO-LOCK NO-ERROR.

        FOR EACH b_U NO-LOCK WHERE b_U._parent-recid = RECID(parent_U) AND b_U._type = "SmartObject":U:

            FIND FIRST b_S WHERE RECID(b_S) = b_U._x-recid NO-LOCK NO-ERROR.

            ASSIGN lIsVisual = DYNAMIC-FUNCTION('instanceOf' IN b_S._handle, INPUT "visual":U) NO-ERROR.

            IF NOT lIsVisual OR lIsVisual = ? THEN
                NEXT.

            /*Detect if the instance is new*/
                &SCOPED-DEFINE xp-assign
                {get ObjectName cObjectName b_S._handle}
                {get ObjectType cObjectType b_S._handle}.
                &UNDEFINE xp-assign

            FIND FIRST ttSynchedObjects WHERE ttSynchedObjects.cObjectName = cObjectName NO-LOCK NO-ERROR.

            IF AVAILABLE(ttSynchedObjects)
            THEN DO:
                FIND LAST ttSynchedObjects WHERE ttSynchedObjects.cObjectName BEGINS cObjectName USE-INDEX cKey NO-LOCK NO-ERROR.
                ASSIGN iInstance = (IF INDEX(ttSynchedObjects.cObjectName, "(") GT 0 THEN INT(SUBSTRING(ttSynchedObjects.cObjectName, INDEX(ttSynchedObjects.cObjectName, "(") + 1, INDEX(ttSynchedObjects.cObjectName, ")") - INDEX(ttSynchedObjects.cObjectName, "(") - 1)) ELSE 1) + 1 
                       cObjectName = cObjectName + "(" + STRING(iInstance) + ")".

                CREATE ttSynchedObjects.
                ASSIGN ttSynchedObjects.cObjectName = cObjectName.

                IF lShowWarning = TRUE THEN
                DO:
                    MESSAGE "More than one object has the same 'Instance name' in this Container at design time," SKIP
                            "it could cause conflicts with the widget-id values." SKIP
                            "In order to avoid this problem use this option with the Container in runtime." SKIP(1)
                            "Do you want to continue?" 
                         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lOk.

                         IF NOT lOk THEN
                         DO:
                             ASSIGN plChanged = FALSE.
                             RETURN.
                         END.

                         ASSIGN lShowWarning = FALSE.
                END. /*IF lShowWarning = TRUE THEN*/
            END. /*IF AVAILABLE(ttSynchedObjects)*/
            ELSE DO:
                CREATE ttSynchedObjects.
                ASSIGN ttSynchedObjects.cObjectName = cObjectName.
            END.

            /*Make a list of instances, to later be used to check deletions*/
            ASSIGN cInstanceList = cInstanceList + "," + cObjectName.

            FIND LAST Instance WHERE Instance.contPath = pcFilePath AND
                                     Instance.contName = pcFileName
                                     USE-INDEX cWidgetID
                                     NO-LOCK NO-ERROR.

            IF AVAILABLE(instance) THEN
             ASSIGN iLastWidgetID  = Instance.WidgetID
                    cOldObjectType = Instance.ObjectType.

            /*Get the Instance Children to later check for deletions.*/
            IF DYNAMIC-FUNCTION('instanceOf' IN b_S._handle, INPUT "Filter":U) THEN
            DO: 
                {get DisplayedFields cFields b_S._handle}.
                REPEAT iField = 1 TO NUM-ENTRIES(cFields):
                    ASSIGN cField = ENTRY(iField, cFields).

                    CREATE beforeInstanceChildren.
                    ASSIGN beforeInstanceChildren.ID               = cField
                           beforeInstanceChildren.contPath         = pcFilePath
                           beforeInstanceChildren.contName         = pcFileName
                           beforeInstanceChildren.parentInstanceID = cObjectName
                           beforeInstanceChildren.ObjectType       = "SmartFilterField":U.

                END.
            END.

            DYNAMIC-FUNCTION('createContainerDetails':U IN hDSLibrary,
                INPUT pcFileName,
                INPUT pcFilePath,
                INPUT b_S._handle,
                INPUT cObjectName,
                INPUT FALSE,
                INPUT plAssignGaps,
                INPUT DATASET dsWidgetID BY-REFERENCE,
                OUTPUT lWarning,
                OUTPUT iCurrPage,
                OUTPUT tmpChanged,
                INPUT-OUTPUT cActions,
                INPUT-OUTPUT iLastWidgetID,
                INPUT-OUTPUT cOldObjectType).

            IF tmpChanged = TRUE AND plChanged = FALSE THEN
                ASSIGN plChanged = TRUE.
            IF iCurrPage > iLastPage THEN
                ASSIGN iLastPage = iCurrPage.
        END. /*FOR EACH b_U NO-LOCK WHERE b_U._parent-recid = RECID(parent_U) AND b_U._type = "SmartObject":U:*/

        /*Now delete the removed objects*/
        EMPTY TEMP-TABLE ttSynchedObjects.
        ASSIGN cInstanceList = TRIM(cInstanceList, ",":U).
        FOR EACH Instance WHERE Instance.contPath = pcFilePath AND Instance.contName = pcFileName:

            ASSIGN cObjectName = Instance.ID.

            FIND FIRST ttSynchedObjects WHERE ttSynchedObjects.cObjectName = cObjectName NO-LOCK NO-ERROR.

            IF AVAILABLE(ttSynchedObjects)
            THEN DO:
                ASSIGN iInstance = (IF INDEX(ttSynchedObjects.cObjectName, "(") GT 0 THEN INT(SUBSTRING(ttSynchedObjects.cObjectName, INDEX(ttSynchedObjects.cObjectName, "(") + 1, LENGTH(ttSynchedObjects.cObjectName) - 1)) ELSE 1) + 1
                       cObjectName = cObjectName + "(" + STRING(iInstance) + ")".
                IF lShowWarning = TRUE  AND lWarning THEN
                DO:
                    MESSAGE "More than one object has the same 'Instance name' in this Container at design time," SKIP
                            "it could cause conflicts with the widget-id values." SKIP
                            "In order to avoid this problem use this option with the Container in runtime." SKIP(1)
                            "Do you want to continue?" 
                         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lOk.

                         IF NOT lOk THEN
                         DO:
                             ASSIGN plChanged = FALSE.
                             RETURN.
                         END.

                         ASSIGN lShowWarning = FALSE.
                END. /*IF lShowWarning = TRUE THEN*/
            END. /*IF AVAILABLE(ttSynchedObjects)*/
            ELSE DO:
                CREATE ttSynchedObjects.
                ASSIGN ttSynchedObjects.cObjectName = cObjectName.
            END.

            IF NOT CAN-DO(cInstanceList, cObjectName) THEN
            DO:
                FOR EACH InstanceChildren WHERE InstanceChildren.contPath         = Instance.contPath AND
                                                InstanceChildren.contName         = Instance.contName AND
                                                InstanceChildren.parentInstanceID = Instance.ID:
                    DELETE InstanceChildren.
                END.

                DELETE Instance.
                ASSIGN plChanged = TRUE.
            END. /* IF NOT CAN-DO(cInstanceList, Instance.ID) THEN*/

        END. /*FOR EACH Instance WHERE Instance.contPath = pcFilePath AND Instance.contName = pcFileName:*/

    END. /*IF b_P.static_object THEN*/

    /*Handle the changes in the container actions (toolbar buttons)*/
    IF cActions NE "" THEN
        DYNAMIC-FUNCTION('createActions':U IN hDSLibrary,
            INPUT pcFileName,
            INPUT pcFilePath,
            INPUT cActions,
            INPUT DATASET dsWidgetID BY-REFERENCE).

    /*Check if some action was deleted from the container*/
    FOR EACH Action WHERE Action.contPath = pcFilePath AND
                          Action.contName = pcFileName
                          NO-LOCK:
        IF NOT CAN-DO(cActions, Action.actionID) THEN
        DO:
            DELETE Action.
            ASSIGN plChanged = TRUE.
        END.
    END. /* FOR EACH Action WHERE Action.contPath = pcFilePath AND*/

    /*Check if some Page was deleted from the container*/
    FOR EACH Pages WHERE Pages.contPath = pcFilePath AND
                         Pages.contName = pcFileName AND
                         Pages.pageNumber GT iLastPage:
            DELETE Pages.
            ASSIGN plChanged = TRUE.
    END. /* FOR EACH Action WHERE Action.contPath = pcFilePath AND*/

    /*Remove the deleted instance children.*/
    FOR EACH InstanceChildren WHERE InstanceChildren.contPath = pcFilePath AND
                                    InstanceChildren.contName = pcFileName:
        IF NOT CAN-FIND(beforeInstanceChildren WHERE
                        beforeInstanceChildren.contPath         = InstanceChildren.contPath         AND
                        beforeInstanceChildren.contName         = InstanceChildren.contName         AND
                        beforeInstanceChildren.parentInstanceID = InstanceChildren.parentInstanceID AND
                        beforeInstanceChildren.ID               = InstanceChildren.ID) THEN
        DO:
            DELETE InstanceChildren.
            ASSIGN plChanged = TRUE.
        END.
    END. /* FOR EACH InstanceChildren WHERE InstanceChildren.contPath = cPath AND */

TEMP-TABLE Pages:TRACKING-CHANGES            = FALSE.
TEMP-TABLE Action:TRACKING-CHANGES           = FALSE.
TEMP-TABLE Instance:TRACKING-CHANGES         = FALSE.
TEMP-TABLE InstanceChildren:TRACKING-CHANGES = FALSE.
EMPTY TEMP-TABLE beforeInstanceChildren.

DELETE OBJECT hDSLibrary.
RETURN.
END PROCEDURE.

FUNCTION setWidgetIDFileName RETURNS LOGICAL 
    (INPUT pcFileName         AS CHARACTER,
     INPUT pcWidgetIDFileName AS CHARACTER):
/*------------------------------------------------------------------------------
    Purpose: Assigns and saves the new WidgetID file name
    Notes: When the container is designed by the developer, a default or custom
           WidgetId file name could be assigned when the container is saved.
           If the container was added to the Widget-id assignment to a different
           XML Widget-id file, we have to save it in the file.
------------------------------------------------------------------------------*/
DEFINE VARIABLE lOk                   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cTempWidgetIDFileName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTempFileName         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDSLibrary            AS HANDLE     NO-UNDO.

DEFINE BUFFER b_P FOR _P.

RUN adecomm/_dswidfunc.p PERSISTENT SET hDSLibrary.

ASSIGN FILE-INFO:FILE-NAME = pcFileName
       pcWidgetIDFileName  = DYNAMIC-FUNCTION('getRelativeName':U IN hDSLibrary, INPUT pcWidgetIDFileName).

FIND FIRST b_P WHERE b_P._save-as-file = FILE-INFO:FULL-PATHNAME NO-LOCK NO-ERROR.

ASSIGN cTempFileName = b_P._widgetid-file-name.

IF cTempFileName = "":U THEN
    ASSIGN cTempFileName = REPLACE(pcFileName, ".w":U, ".xml":U).

IF cTempFileName NE pcWidgetIDFileName THEN
DO:
    IF b_P.static_object THEN
    DO: 
        MESSAGE "The WidgetID File Name assigned for the container '" + pcFileName + "' is different than the" SKIP
                "WidgetID file name being edited in this tool." SKIP(1)
                "Do you want to assign the new WidgetID file Name '" + pcWidgetIDFileName + "' to the selected Container?"
             VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lOk.

        IF NOT lOk THEN
        DO:
            DELETE OBJECT hDSLibrary NO-ERROR.
            RETURN FALSE.
        END.

        ASSIGN cTempWidgetIDFileName    = _widgetid_custom_filename
               b_P._widgetid-file-name  = pcWidgetIDFileName
              _widgetid_custom_filename = pcWidgetIDFileName.
        RUN choose_file_save IN _h_uib.
        
        ASSIGN _widgetid_custom_filename = cTempWidgetIDFileName.
    END. /*IF b_P.static_object THEN*/

    DELETE OBJECT hDSLibrary NO-ERROR.
    RETURN TRUE.
END. /*IF b_P._widgetid-file-name NE pcWidgetIDFileName THEN*/

DELETE OBJECT hDSLibrary NO-ERROR.
RETURN TRUE.
END FUNCTION.

FUNCTION getAppBuilderStatus RETURNS CHARACTER 
    (  ):
/*------------------------------------------------------------------------------
    Purpose: Returns if the objects are running in the appbuilder or not.
    Notes: If the 'Stop' button is NOT HIDDEN in the AppBuilder is because the
           design objects are in "Runtime" mode, otherwise they are in "Design". 
------------------------------------------------------------------------------*/
RETURN IF Stop_Button:HIDDEN THEN "Design":U ELSE "Runtime":U.    
END FUNCTION.


FUNCTION refreshDPS RETURNS LOGICAL 
    (INPUT pcContainerObj AS CHARACTER,
     INPUT pcObjectObj    AS CHARACTER,
     INPUT pcAttName      AS CHARACTER,
     INPUT pcValue        AS CHARACTER):
/*------------------------------------------------------------------------------
    Purpose: Refreshes the Dynamic Property Sheet with the new value.
    Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE hProcLib AS HANDLE NO-UNDO.
DEFINE VARIABLE hquery AS HANDLE   NO-UNDO.
DEFINE VARIABLE hbuffer AS HANDLE  NO-UNDO.

IF NOT VALID-HANDLE(hProcLib) THEN
DO:
    hProcLib = SESSION:FIRST-PROCEDURE.
    DO WHILE VALID-HANDLE(hProcLib) AND hProcLib:FILE-NAME NE "ry/prc/ryvobplipp.p":U:
        hProcLib = hProcLib:NEXT-SIBLING.
    END.  
END.

IF NOT VALID-HANDLE(hProcLib) THEN RETURN TRUE.

ASSIGN hBuffer = DYNAMIC-FUNCTION("getBuffer":U IN hProcLib, "ttAttribute":U).

CREATE QUERY hQuery.
hQuery:SET-BUFFERS(hBuffer).

hQuery:QUERY-PREPARE("FOR EACH ":U + hBuffer:NAME + " WHERE (":U 
                      + hBuffer:NAME + ".containerName = '":U + STRING(_h_win) + "' OR ":U
                      + hBuffer:NAME + ".containerName = '":U + pcContainerObj + "') AND (":U
                      + hBuffer:NAME + ".ObjectName    = '":U + STRING(_h_win) + "' OR ":U
                      + hBuffer:NAME + ".ObjectName    = '":U + pcObjectObj + "') AND ":U
                      + hBuffer:NAME + ".resultCode    = '":U + "'" + " AND ":U
                      + hBuffer:NAME + ".attrLabel     = '":U + pcAttName + "'").

hQuery:QUERY-OPEN().
hQuery:GET-FIRST().

DO WHILE hBuffer:AVAILABLE:
    ASSIGN hBuffer::setValue = pcValue.
    hQuery:GET-NEXT().
END.

RUN displayProperties IN hProcLib (?,?,?,?,?,?).
RETURN TRUE.
END FUNCTION.