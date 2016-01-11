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
  File: rydyncontp.p

  Description:  Dynamic Container/Frame Super Procudure

  Purpose:      Dynamic Container/Frame Super Procudure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    3136
                Date:   01/29/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydynframp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}
{ af/app/afttsecurityctrl.i }

DEFINE VARIABLE gcCurrentObjectName         AS CHARACTER            NO-UNDO.

/* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{ ry/app/rydefrescd.i }

/* Define the container_* tables that local control the object. */
{ ry/app/ryobjretri.i &CONTAINER-TABLES=YES }

DEFINE VARIABLE ghLayoutManager                 AS HANDLE           NO-UNDO.

/* These are kept for backwards compatibilty. */
DEFINE NEW GLOBAL SHARED VARIABLE gshLayoutManager      AS HANDLE.
DEFINE NEW GLOBAL SHARED VARIABLE gshLayoutManagerID    AS INTEGER.


DEFINE VARIABLE ghQuery1                        AS HANDLE           NO-UNDO.

/* Define a handle to use for the ADMProps TT. We need to do this because 
 * this is not an ADM class procedure. */
DEFINE VARIABLE ghProp                          AS HANDLE           NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addAllLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addAllLinks Procedure 
FUNCTION addAllLinks RETURNS LOGICAL
    ( /* No parameters */   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildAllObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildAllObjects Procedure 
FUNCTION buildAllObjects RETURNS LOGICAL
    ( /* No Parameters */ ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildContainerTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildContainerTables Procedure 
FUNCTION buildContainerTables RETURNS LOGICAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildInitialPageList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildInitialPageList Procedure 
FUNCTION buildInitialPageList RETURNS CHARACTER
    ( /* No parameters */  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerObjectBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerObjectBuffer Procedure 
FUNCTION getContainerObjectBuffer RETURNS HANDLE
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerPageBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerPageBuffer Procedure 
FUNCTION getContainerPageBuffer RETURNS HANDLE
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainingWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainingWindow Procedure 
FUNCTION getContainingWindow RETURNS HANDLE
    ( /* No Parameters */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLayoutManagerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLayoutManagerHandle Procedure 
FUNCTION getLayoutManagerHandle RETURNS HANDLE
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPageLinkList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPageLinkList Procedure 
FUNCTION getPageLinkList RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRawAttributeValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRawAttributeValues Procedure 
FUNCTION getRawAttributeValues RETURNS HANDLE
    ( INPUT pdInstanceId        AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getResizeOnPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getResizeOnPage Procedure 
FUNCTION getResizeOnPage RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarHandles Procedure 
FUNCTION getToolbarHandles RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWindowName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWindowName Procedure 
FUNCTION getWindowName RETURNS CHARACTER ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBox) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBox Procedure 
FUNCTION setBox RETURNS LOGICAL
    ( INPUT plBox       AS LOGICAL   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWindowName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWindowName Procedure 
FUNCTION setWindowName RETURNS LOGICAL
    ( INPUT pcWindowName        AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateWindowSizes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateWindowSizes Procedure 
FUNCTION updateWindowSizes RETURNS LOGICAL
    ( INPUT piStartPage             AS INTEGER,
      INPUT pcInitialPageList       AS CHARACTER )  FORWARD.

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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 16
         WIDTH              = 73.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
ASSIGN ghLayoutManager = DYNAMIC-FUNCTION("getLayoutManagerHandle":U IN TARGET-PROCEDURE).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buildPageLinkRecursive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildPageLinkRecursive Procedure 
PROCEDURE buildPageLinkRecursive :
/*------------------------------------------------------------------------------
  Purpose:     For a given object, this procedure calculates those pages
               that are dependent on that object. The system checks whether there
               exist any ADM DATA or GROUP-ASSIGN links that would necessitate the initialization of
               those objects across the link.
               
  Parameters:  INPUT        piCurrentPage   The current page that is being contstructed
               INPUT        pdSourceObject  ObjectID of object    
               INPUT-OUTPUT pcPageList      Comma delimited list of relative pages
  Notes:       This procedure is called from buildPageLinks and is recursivly called.
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER piCurrentPage         AS INTEGER        NO-UNDO.
    DEFINE INPUT        PARAMETER pdSourceObj           AS DECIMAL        NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pcPageList            AS CHARACTER      NO-UNDO.

    DEFINE VARIABLE cObjects                AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE dSourceInstanceObj      AS DECIMAL                      NO-UNDO.

    DEFINE BUFFER container_Object      FOR container_Object.
    DEFINE BUFFER container_Link        FOR container_Link.

    /* Make sure that the widget pool  has a unique name, especially since we
     * are calling this procedure recursively.                                 */
    FIND FIRST container_Object WHERE
               container_Object.tTargetProcedure   = TARGET-PROCEDURE AND
               container_Object.tObjectInstanceObj = pdSourceObj
               NO-ERROR.
    IF AVAILABLE container_Object THEN
    DO:
        IF container_Object.tPageNumber                             GT 0             AND
           container_Object.tPageNumber                             NE piCurrentPage AND
           LOOKUP(STRING(container_Object.tPageNumber), pcPageList) EQ 0            THEN
        DO:
            ASSIGN cObjects = DYNAMIC-FUNCTION("pageNTargets":U IN TARGET-PROCEDURE,INPUT TARGET-PROCEDURE, INPUT container_Object.tPageNumber).
            IF cObjects EQ "":U THEN
                ASSIGN pcPageList = pcPageList + (IF NUM-ENTRIES(pcPageList) EQ 0 THEN "":U ELSE ",":U) + STRING(container_Object.tPageNumber).
        END.    /* page nuber not in list. */

        FOR EACH container_Link WHERE
                 container_Link.tTargetProcedure         = TARGET-PROCEDURE                    AND
                 container_Link.tTargetObjectInstanceObj = container_Object.tObjectInstanceObj AND
                 (container_Link.tLinkName = "DATA":U OR container_Link.tLinkName = "GROUP-ASSIGN":U ) :
            RUN buildPageLinkRecursive IN TARGET-PROCEDURE ( INPUT        piCurrentPage,
                                                             INPUT        container_Link.tSourceObjectInstanceObj,
                                                             INPUT-OUTPUT pcPageList                               ).
        END.    /* each link */
    END.    /* object available */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* buildPageLinkRecursive */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildPageLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildPageLinks Procedure 
PROCEDURE buildPageLinks :
/*------------------------------------------------------------------------------
  Purpose:     For a given page, this procedure calculates those pages
               that are dependent on that page. The system checks whether there
               exist any ADM DATA links that would necessitate the initialization of
               those objects across the link.
               
  Parameters:  INPUT  piCurrentPage  Current selected page
               OUTPUT pcPageList     Comma delimited list of relative pages
  Notes:       This procedure is called from createObjects and calls procedure
               buildPageLinkrecursive.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piCurrentPage               AS INTEGER      NO-UNDO.
    DEFINE OUTPUT PARAMETER pcPageList                  AS CHARACTER    NO-UNDO.
    
    DEFINE VARIABLE cPageList                   AS CHARACTER            NO-UNDO.
    
    DEFINE BUFFER container_Object      FOR container_Object.
    DEFINE BUFFER container_Link        FOR container_Link.
    
    FOR EACH container_Object WHERE
             container_Object.tTargetProcedure = TARGET-PROCEDURE AND
             container_Object.tPageNumber      = piCurrentPage
             BY container_Object.tInstanceOrder
             BY container_Object.tLayoutPosition :

        FOR EACH container_Link WHERE
                 container_Link.tTargetProcedure         = TARGET-PROCEDURE                    AND
                 container_Link.tTargetObjectInstanceObj = container_Object.tObjectInstanceObj AND
                 container_Link.tLinkName                = "DATA":U    :
            
            IF container_Object.tObjectInstanceObj > 0 THEN
                RUN buildPageLinkRecursive IN TARGET-PROCEDURE( INPUT        piCurrentPage,
                                                                INPUT        container_Object.tObjectInstanceObj,
                                                                INPUT-OUTPUT cPageList).
        END.    /* available link buffer */
    END.    /* avail objects */

    ASSIGN pcPageList = cPageList.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* buildPageLinks */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects Procedure 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iCurrentPage                AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iPageToStart                AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iStartPage                  AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iEntry                      AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cDataTargets                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSdoForeignFields           AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInitialPageList            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hDataTarget                 AS HANDLE               NO-UNDO.
    DEFINE VARIABLE dInstanceID                 AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE cContainerType              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hContainerHandle            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hDefaultFrame               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hContainer                  AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hContainerSource            AS HANDLE               NO-UNDO.

    DEFINE BUFFER container_Object          FOR container_Object.
    DEFINE BUFFER container_Page            FOR container_Page.

    {get CurrentPage     iCurrentPage    }.
    {get InstanceId      dInstanceId     }.
    {get ContainerHandle hContainerHandle}.
    {get ContainerType   cContainerType  }.

    IF cContainerType EQ "Window":U THEN
        {get WindowFrameHandle hDefaultFrame}.
    ELSE
        ASSIGN hDefaultFrame = hContainerHandle.

    ASSIGN iStartPage = iCurrentPage.

    /** We have already retrieved the object from the cache, in prepareInstance 
     *  which is called on sinstantiation of this object. This sets the instanceID
     *  property which stores the rRecordIdentifier property.
     *  ----------------------------------------------------------------------- **/    

    /* Get the information out of the Repository Cache and keep it local. */
    IF NOT CAN-FIND(FIRST container_Object WHERE 
                          container_Object.tTargetProcedure  = TARGET-PROCEDURE AND
                          container_Object.tRecordIdentifier = dInstanceId          ) THEN
        DYNAMIC-FUNCTION("buildContainerTables":U IN TARGET-PROCEDURE).

    IF NOT CAN-FIND(FIRST container_Object WHERE 
                          container_Object.tTargetProcedure  = TARGET-PROCEDURE AND
                          container_Object.tRecordIdentifier = dInstanceId          ) THEN
    DO:
        /* First get the error messages. */
        {afcheckerr.i &NO-RETURN=YES }

        IF cContainerType EQ "Frame":U THEN
        DO:
            ASSIGN hContainerSource = DYNAMIC-FUNCTION("getContainingWindow":U IN TARGET-PROCEDURE).

            /* Get the window handle of the container .*/
            {get ContainerHandle hContainerHandle hContainerSource}.
        END.    /* Frame container. */
        ELSE
            {get ContainerHandle hContainerHandle}.

        /* Then window controls its self-destruction. This will cause all
         * objects contained on it to be destroyed, too.                 */
        ASSIGN hContainerHandle:PRIVATE-DATA = "ForcedExit":U + CHR(3) + cMessageList.
        RETURN.
    END.    /* errors fetching object detail. */

    IF iCurrentPage EQ 0 THEN
    DO:
        /* Set any attributes for the container. There may be attributes which need to pe explicitly set (instead of just
         * assigned into the ADMProps TT.                                                                                */
        FIND FIRST container_Object WHERE
                   container_Object.tTargetProcedure  = TARGET-PROCEDURE AND
                   container_Object.tRecordIdentifier = dInstanceId.

        RUN setAttributesInObject IN gshSessionManager ( INPUT TARGET-PROCEDURE,
                                                         INPUT container_Object.tAttributeList ).
        
        FIND FIRST container_Page WHERE
                   container_Page.tTargetProcedure = TARGET-PROCEDURE AND
                   container_Page.tPageNumber      = 0 
                   NO-ERROR.
        IF AVAILABLE container_Page THEN
        DO:
            &SCOPED-DEFINE xpPage0LayoutManager
            {set Page0LayoutManager container_Page.tLayoutCode}.
            &UNDEFINE xpPage0LayoutManager
        END.    /* available container page */

        ASSIGN cInitialPageList = DYNAMIC-FUNCTION("buildInitialPageList":U IN TARGET-PROCEDURE).
    END.    /* page 0 */

    /* If we are on page 0, and a start page other than page 0 has been specified, ensure it is a valid page. If not, set the StartPage to page 0 */
    IF iCurrentPage EQ 0 THEN
    DO:        
        &SCOPED-DEFINE xpStartPage
        {get StartPage iPageToStart}.

        IF iPageToStart NE 0 AND iPageToStart NE ? THEN
        DO:
            FIND FIRST container_Page WHERE
                       container_Page.tTargetProcedure EQ TARGET-PROCEDURE AND
                       container_Page.tPageNumber      EQ iPageToStart
                       NO-ERROR.
            IF NOT AVAILABLE container_Page THEN
                {set StartPage 0}.
        END.    /* valid page to start */

        &UNDEFINE xpStartPage
    END.    /* current page zero */

    /* Exit if invalid page */
    FIND FIRST container_Page WHERE
               container_Page.tTargetProcedure EQ TARGET-PROCEDURE AND
               container_Page.tPageNumber      EQ iCurrentPage
               NO-ERROR.
    IF iCurrentPage GT 0 AND NOT AVAILABLE container_Page THEN RETURN.

    /* Work out start page and if pages exist */
    FIND FIRST container_Page WHERE
               container_Page.tTargetProcedure EQ TARGET-PROCEDURE AND
               container_Page.tPageNumber      GT 0
               NO-ERROR.
    IF AVAILABLE container_Page THEN
    DO:
        ASSIGN iStartPage = container_Page.tPageNumber.
        &SCOPED-DEFINE xpStartPage
        {set StartPage iStartPage}.
        &UNDEFINE xpStartPage
    END.    /* available start */

    /* set resize on page to start page */
    IF iCurrentPage EQ 0 THEN
    DO:
        FIND FIRST container_Object WHERE
                   container_Object.tTargetProcedure  = TARGET-PROCEDURE AND
                   container_Object.tRecordIdentifier = dInstanceId
                   NO-ERROR.
        ASSIGN container_Object.tResizeOnPage = iStartPage.
    END.    /* current page not 0 */

    /* Set page initialized flag */
    FIND FIRST container_Page WHERE
               container_Page.tTargetProcedure EQ TARGET-PROCEDURE AND
               container_Page.tPageNumber      EQ iCurrentPage
               NO-ERROR.

    /* If the page is initialized then return */
    IF AVAILABLE container_Page THEN
      IF container_Page.tPageInitialized THEN
        RETURN.
      ELSE
        container_Page.tPageInitialized = YES.

    /** Build all of the objects on this container.
     *  ----------------------------------------------------------------------- **/
    IF NOT DYNAMIC-FUNCTION("buildAllObjects":U IN TARGET-PROCEDURE) THEN
    DO:
        IF cContainerType EQ "Frame":U THEN
            ASSIGN hContainerSource = DYNAMIC-FUNCTION("getContainingWindow":U IN TARGET-PROCEDURE).
        ELSE
            ASSIGN hContainerSource = TARGET-PROCEDURE.

        /* Get the window handle of the container .*/
        {get ContainerHandle hContainerHandle hContainerSource}.
        
        /* The window controls its self-destruction. This will cause all
         * objects contained on it to be destroyed, too.                 */
        ASSIGN hContainerHandle:PRIVATE-DATA = "ForcedExit":U + CHR(3) + "Unable to create all the objects needed to run this container.":U.
        RETURN.
    END.    /* buildAllObjects failed */

    /** Add all links for this container/object.
     *  ----------------------------------------------------------------------- **/
    DYNAMIC-FUNCTION("addAllLinks":U IN TARGET-PROCEDURE).

    {get DataTarget cDataTargets}.
    {get SdoForeignFields cSdoForeignFields}.
    
    IF cSdoForeignFields NE "":U THEN
    DO iEntry = 1 TO NUM-ENTRIES(cDataTargets):
        ASSIGN hDataTarget = WIDGET-HANDLE(ENTRY(iEntry,cDataTargets)).

        IF DYNAMIC-FUNCTION("getInternalEntryExists":U IN gshSessionManager, "setForeignFields":U, hDataTarget) THEN
            DYNAMIC-FUNCTION("setForeignFields":U IN hDataTarget, cSdoForeignFields).
    END.    /* there are SDO foreign fields */

    /* The call to run the SUPER has been moved to here. The reason is that the createObjects in
       containr.p does a select of the specified StartPage. When the call to the SUPER was at the
       top of the procedure, page 0 never had a chance to initialize, meaning that the container
       was broken. Let all the objects on page 0 initialize before the SUPER is called in. That
       way, objects on page zero will be initialized completely before running the select of the
       StartPage */
    RUN SUPER.

    /* We need to ensure that any pass-through stuff is done. */
    FIND FIRST container_Object WHERE
               container_Object.tTargetProcedure  = TARGET-PROCEDURE AND
               container_Object.tRecordIdentifier = dInstanceId .
    DO iEntry = 1 TO NUM-ENTRIES(container_Object.tContainerHandles):
        ASSIGN hContainer = WIDGET-HANDLE(ENTRY(iEntry, container_Object.tContainerHandles)) NO-ERROR.
        IF VALID-HANDLE(hContainer) THEN
        DO:
            IF NOT {fn getObjectInitialized hContainer} THEN
                RUN createLinks IN gshSessionManager ( INPUT hContainer:FILE-NAME,
                                                       INPUT hContainer,
                                                       INPUT TARGET-PROCEDURE,
                                                       INPUT NO                    ) NO-ERROR.
        END.    /* valid container. */
    END.    /* All containers */

    /** Ensure that the correct minimum and mazimum height and width are set. 
     *  ----------------------------------------------------------------------- **/
    &SCOPED-DEFINE xpStartPage
    {get StartPage iStartPage}.
    &UNDEFINE xpStartPage
    
    IF NOT DYNAMIC-FUNCTION("updateWindowSizes":U IN TARGET-PROCEDURE, INPUT iStartPage, INPUT cInitialPageList) THEN
        ASSIGN hContainerHandle:PRIVATE-DATA = "ForcedExit":U + CHR(3) + "Window sizing failure.":U.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* createObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:        
------------------------------------------------------------------------------*/
    RUN SUPER.
    
    IF NOT ERROR-STATUS:ERROR /* confirmExit could have cancelled the exit process */
    THEN DO:
        /* Destroy all custom super procedures. */
        FOR EACH container_Object WHERE container_Object.tTargetProcedure = TARGET-PROCEDURE:         
            IF container_Object.tDestroyCustomSuper EQ YES THEN
            DO:
                /* Use the API to kill the PLIP, since it was started by launch.i */
                RUN killPlips IN gshSessionManager ( INPUT "":U, INPUT STRING(container_Object.tCustomSuperHandle)) NO-ERROR.
        
                IF VALID-HANDLE(container_Object.tCustomSuperHandle) THEN 
                    DELETE OBJECT container_Object.tCustomSuperHandle NO-ERROR.
            END.    /* has a super procedure */
    
            DELETE container_Object.
        END.    /* each container object. */
        
        FOR EACH container_Page WHERE container_Page.tTargetProcedure = TARGET-PROCEDURE:
            DELETE container_Page.
        END.
    
        FOR EACH container_Link WHERE container_Link.tTargetProcedure = TARGET-PROCEDURE:
            DELETE container_Link.
        END.
    END.
END PROCEDURE.  /* destroyObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTabEnabled                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iCurrentPageNumber          AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iNumToolbars                AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iPage                       AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cSavedContainerMode         AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cErrorMessage               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cButton                     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hContainerToolbar           AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hTableioTarget              AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hFolder                     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hToolbar                    AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hNavigateSdo                AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cContainerToolbars          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cContainerMode              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cContainerType              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hDefaultFrame               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hContainerSource            AS HANDLE               NO-UNDO.

    /* Don't initialize more than once */
    IF {fn getObjectInitialized} THEN RETURN.

    /* Make sure that all the objects are created first. */
    IF NOT {fn getObjectsCreated} THEN
        RUN createObjects IN TARGET-PROCEDURE.

    /* Retrieve container mode set already, i.e. from where window was launched from
     * and before initializeObject was run. If a mode is retrieved here, we will not
     * overwrite it with the default mode from the object properties.                */ 
    {get ContainerMode   cContainerMode   }.
    {get ContainerHandle hDefaultFrame    }.
    {get ContainerType   cContainerType   }.   

    RUN SUPER.

    IF cContainerType NE "Window":U THEN
    DO:        
        {get ContainerSource hContainerSource }.

        SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "setContainerModifyMode":U IN hContainerSource.
        SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "setContainerModifyView":U IN hContainerSource.
    END.    /* container is not a Window */

    {get CurrentPage iCurrentPageNumber}.

    FOR EACH container_Page WHERE
             container_Page.tTargetProcedure = TARGET-PROCEDURE AND
             container_Page.tPageNumber      <> iCurrentPageNumber:
        RUN hidePage IN TARGET-PROCEDURE ( INPUT container_Page.tPageNumber ).
    END.  /* each page */

    /* Check if any enabled tabs and if not - exit the program */
    ASSIGN hFolder = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, "Page-Source":U)).

    /* Check if the first selected page has been disabled by security or some other reason. */
    IF VALID-HANDLE(hFolder) THEN
    DO:
        {get TabEnabled cTabEnabled  hFolder}.

        /* %%% */
        
        IF iCurrentPageNumber EQ 0 THEN
            ASSIGN iCurrentPageNumber = 1.

        /* If the current tab is disabled, then move to the next available one. */
        IF LOGICAL(ENTRY(iCurrentPageNumber, cTabEnabled, "|":U)) EQ NO THEN
        DO:
            DO iLoop = iCurrentPageNumber + 1 TO NUM-ENTRIES(cTabEnabled, "|":U):
                IF LOGICAL(ENTRY(iLoop, cTabEnabled, "|":U)) EQ YES THEN
                    LEAVE.
            END.    /* loop through pages */

            IF LOGICAL(ENTRY(iLoop, cTabEnabled, "|":U)) EQ NO THEN
            DO iLoop = MAX(1, iCurrentPageNumber - 1) TO 1:
                IF LOGICAL(ENTRY(iLoop, cTabEnabled, "|":U)) EQ YES THEN
                    LEAVE.
            END.    /* loop through pages */

            IF LOGICAL(ENTRY(iLoop, cTabEnabled, "|":U)) EQ YES THEN
                ASSIGN iCurrentPageNumber = iLoop.

            RUN selectPage IN TARGET-PROCEDURE (INPUT iCurrentPageNumber).
        END.    /* current page not enabled */
    END.    /* valid folder */

    IF VALID-HANDLE(hFolder) AND DYNAMIC-FUNCTION("getTabsEnabled" IN hFolder) EQ NO THEN
    DO:
        RUN showMessages IN gshSessionManager ( INPUT  {aferrortxt.i 'RY' '11'},
                                                INPUT  "ERR":U,                  /* error type */
                                                INPUT  "&OK":U,                  /* button list */
                                                INPUT  "&OK":U,                  /* default button */
                                                INPUT  "&OK":U,                  /* cancel button */
                                                INPUT  "Folder window error":U,  /* error window title */
                                                INPUT  YES,                      /* display if empty */
                                                INPUT  TARGET-PROCEDURE,         /* container handle */
                                                OUTPUT cButton                   /* button pressed */      ).
        /* Shut down the folder window */
        RUN exitObject IN TARGET-PROCEDURE.
        RETURN.
    END.    /* no tabs enabled */
    
    {get ToolbarSource cContainerToolbars}.
    ContainerToolBarLoop:
    DO iNumToolbars = 1 TO NUM-ENTRIES(cContainerToolbars):
        ASSIGN hToolbar = WIDGET-HANDLE(ENTRY(iNumToolbars, cContainerToolbars)).

        IF VALID-HANDLE(hToolbar) THEN
        DO:
            /* If there are multiple toolbars linked to the container with Toolbar links, the first
             * toolbar found with a tableio target on page 0 or 1 is used for container mode logic
             * below.  If there is only one toolbar linked to the container with a Toolbar link,
             * that toolbar is used.                                                                 */
            IF NUM-ENTRIES(cContainerToolbars) > 1 THEN
            DO:
                {get TableioTarget hTableioTarget hToolbar}.
                IF VALID-HANDLE(hTableioTarget) THEN
                DO:
                    {get ObjectPage iPage hTableioTarget}.
                    IF iPage > 1 THEN
                        NEXT ContainerToolBarLoop.
                    ASSIGN hContainerToolbar = hToolbar.
                    LEAVE.
                END.  /* if valid TableioTarget */
            END.  /* if more than one toolbar */
            ELSE
                ASSIGN hContainerToolbar = hToolbar.
        END.  /* if valid ContainerToolbar */
    END.  /* do to number container toolbars */

    IF VALID-HANDLE (hContainerToolbar) THEN
    DO:
        CASE cContainerMode:
            WHEN "Copy":U   THEN PUBLISH "copyRecord":U FROM hContainerToolbar.
            WHEN "Add":U    THEN PUBLISH "addRecord":U  FROM hContainerToolbar.
        END CASE.   /* container mode */

        /* If Container mode was add or copy, we reread it to see if it was a 
         * success. This will ensure correction of windowtitle by the view or 
         * modify mode below if necessary */
        IF cContainerMode = 'Add':U OR cContainerMode = 'Copy':U THEN  
            {get ContainerMode cContainerMode}.

        CASE cContainerMode:
            WHEN "View":U   THEN RUN setContainerViewMode IN TARGET-PROCEDURE.
            WHEN "Modify":U THEN RUN setContainerModifyMode IN TARGET-PROCEDURE.
        END. /* another case of container mode .. */
    END.    /* valid containber toolbar */

    /* see if navigation target of container toolbar is a valid SDO. If this is the case, then
     * enable the navigation buttons on the container toolbar.                                   */
    IF VALID-HANDLE(hContainerToolbar) THEN
        ASSIGN hNavigateSdo = DYNAMIC-FUNCTION("linkHandles" IN hContainerToolbar, "Navigation-Target":U) NO-ERROR.

    /* I the case of a window, these actions are performed in ydynwindp.p */
    IF NOT cContainerType EQ "Window":U THEN
    DO:
        ASSIGN hDefaultFrame:VISIBLE = TRUE.

        RUN applyEntry IN TARGET-PROCEDURE(?).
    END.    /* not a Window */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* initializeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-manualInitializeObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE manualInitializeObjects Procedure 
PROCEDURE manualInitializeObjects :
/*------------------------------------------------------------------------------
  Purpose:     To instantiate objects on container in controlled order.
  Parameters:  <none>
  Notes:       Called from initializeObject  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iLoop                   AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE hHandle                 AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE dInstanceId             AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE lInitialized            AS LOGICAL                  NO-UNDO.

    DEFINE BUFFER frame_Object FOR container_Object.

    {get InstanceId dInstanceId}.
    
    FIND FIRST frame_Object WHERE
               frame_Object.tRecordIdentifier = dInstanceId    AND
               frame_Object.tTargetProcedure  = TARGET-PROCEDURE
               NO-LOCK.

    IF NUM-ENTRIES(frame_Object.tObjectHandles) > 0 THEN
    DO iLoop = 1 TO NUM-ENTRIES(frame_Object.tObjectHandles):
      ASSIGN hHandle = WIDGET-HANDLE(ENTRY(iLoop, frame_Object.tObjectHandles)).
      IF VALID-HANDLE(hHandle) THEN
      DO:
        /* Do not initialize already initialized objects.. 
           dataobjects are for example initialized earlier if inside a 
           DataContainer and even if  data.p has protection, this method 
           is commonly overidden to for example populate temp-tables so we 
           better don't call it twice */              
        {get ObjectInitialized lInitialized hHandle}.
        IF NOT lInitialized THEN
          RUN initializeObject IN hHandle.
      END.

        /* There may be a forced exit. */
      IF NOT VALID-HANDLE(hHandle) THEN
        LEAVE.
    END.    /* loop through object handles */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* manualInitializeObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-packWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE packWindow Procedure 
PROCEDURE packWindow :
/*------------------------------------------------------------------------------
  Purpose:     packs the window. 
  Parameters:  piPage   -
               plResize -
  Notes:       * This procedure will run up  the containers until it hits a window
                 container, which is where the packing will take place.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piPage           AS INTEGER                  NO-UNDO.
    DEFINE INPUT PARAMETER plResize         AS LOGICAL                  NO-UNDO.

    DEFINE VARIABLE hContainerSource                AS HANDLE           NO-UNDO.
    DEFINE VARIABLE cContainerType                  AS CHARACTER        NO-UNDO.

    {get ContainerType cContainerType}.

    IF cContainerType EQ "Frame":U THEN
    DO:
        {get ContainerSource hContainerSource}.
        RUN packWindow IN hContainerSource ( INPUT piPage, INPUT plResize).
    END.    /* frame */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* packWindow */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:    Resizes the DynFrame
  Parameters: pdHeightChars - 
              pdWidthChars  -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdHeightChars            AS DECIMAL          NO-UNDO.
    DEFINE INPUT PARAMETER pdWidthChars             AS DECIMAL          NO-UNDO.

    DEFINE VARIABLE cContainerType          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cResizeMe               AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE lPreviouslyHidden       AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE lResizeSmaller          AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE lResizeNow              AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE hFrameHandle            AS HANDLE                   NO-UNDO.

    {get ContainerType cContainerType}.

    IF cContainerType EQ "Frame":U THEN
    DO:
        {get ContainerHandle hFrameHandle}.

        /* Check whether we should be resizing now, or whether to wait. */
        ASSIGN cResizeMe = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, INPUT "ResizeMe":U).

        IF cResizeMe EQ "Pending":U THEN
            ASSIGN cResizeMe = "OK":U.
        ELSE
        IF (pdHeightChars LT hFrameHandle:HEIGHT-CHARS) OR (pdWidthChars LT hFrameHandle:WIDTH-CHARS) THEN
            ASSIGN cResizeMe = "Pending":U.
        ELSE
            ASSIGN cResizeMe = "OK":U.

        /* Keep this value for later. */
        DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, INPUT "ResizeMe", INPUT cResizeMe). 

        ASSIGN lPreviouslyHidden                 = hFrameHandle:HIDDEN
               hFrameHandle:HIDDEN               = YES
               hFrameHandle:SCROLLABLE           = TRUE
               hFrameHandle:VIRTUAL-HEIGHT-CHARS = SESSION:HEIGHT-CHARS
               hFrameHandle:VIRTUAL-WIDTH-CHARS  = SESSION:WIDTH-CHARS
               NO-ERROR.

        IF cResizeMe NE "Pending":U THEN
        DO:
            ASSIGN hFrameHandle:HEIGHT-CHARS = pdHeightChars
                   hFrameHandle:WIDTH-CHARS  = pdWidthChars
                   NO-ERROR.

            ASSIGN hFrameHandle:VIRTUAL-HEIGHT-CHARS = hFrameHandle:HEIGHT-CHARS
                   hFrameHandle:VIRTUAL-WIDTH-CHARS  = hFrameHandle:WIDTH-CHARS
                   NO-ERROR.

            /* The resize is complete. */
            DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE, INPUT "ResizeMe", INPUT "Done":U).
        END.    /* resize pending */

        ASSIGN hFrameHandle:SCROLLABLE = NO
               hFrameHandle:HIDDEN     = lPreviouslyHidden
               NO-ERROR.

    END.    /* Frame container. */
    
    /* We don't check for errors because there will be many cases where
     * there is no resizeObject for the viewer. In this cse, simply ignore 
     * any errors.                                                         */    
    RUN SUPER (INPUT pdHeightChars, INPUT pdWidthChars) NO-ERROR.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* resizeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeWindow Procedure 
PROCEDURE resizeWindow :
/*------------------------------------------------------------------------------
  Purpose:     Resizes the window
  Parameters:  <none>
  Notes:       * Since this procedure is in a super procedure of the physical
                 window (the .W file) we run the resizeWindowFromSuper() API.
                 This is necessary because the resizeWindow() API in the Layout
                 Manager uses the SOURCE-PROCEDURE to determine where it was
                 run from. This will return the name of this procedure (rydynwindp.p)
                 which is incorrect. The resizeWindowFromSuper() API gives a chance
                 to explicitly pass in the TARGET-PROCEDURE and ensure that the
                 correct resizing occurs.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cLayoutCode         AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cContainerType      AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE dInstanceId         AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE hObjectBuffer       AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hPageBuffer         AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hWindow             AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hDefaultFrame       AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hContainerWindow    AS HANDLE                       NO-UNDO.

    ASSIGN hObjectBuffer = BUFFER container_Object:HANDLE
           hPageBuffer   = BUFFER container_Page:HANDLE
           .
    &SCOPED-DEFINE xpPage0LayoutManager
    {get Page0LayoutManager cLayoutCode}.
    &UNDEFINE xpPage0LayoutManager
    
    {get ContainerType cContainerType}.
    {get InstanceId dInstanceId}.
    {get ContainerHandle hWindow}.

    IF cContainerType EQ "Window":U THEN        
        {get WindowFrameHandle hDefaultFrame}.
    ELSE
        ASSIGN hDefaultFrame = hWindow.

    /* Get the handle of the window object. */
    ASSIGN hContainerWindow = DYNAMIC-FUNCTION("getContainingWindow":U IN TARGET-PROCEDURE).

    IF VALID-HANDLE(hContainerWindow) THEN
        PUBLISH "windowToBeSized":U FROM hContainerWindow.

    IF NOT VALID-HANDLE(ghLayoutManager) THEN
        ASSIGN ghLayoutManager = DYNAMIC-FUNCTION("getLayoutManagerHandle":U IN TARGET-PROCEDURE).

    IF VALID-HANDLE(ghLayoutManager) THEN
        RUN resizeWindowFromSuper IN ghLayoutManager ( INPUT cLayoutCode,
                                                       INPUT hWindow,       /* This could also be a frame widget. */
                                                       INPUT hDefaultFrame,
                                                       INPUT dInstanceId,
                                                       INPUT hObjectBuffer,
                                                       INPUT hPageBuffer,
                                                       INPUT TARGET-PROCEDURE ).
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* resizeWindow */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-selectPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectPage Procedure 
PROCEDURE selectPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  piPageNum - 
  Notes:       * We only need to lock the window if the page being displayed has not
                 yet been initialised, because the locking prevents flashing etc.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piPageNum            AS INTEGER              NO-UNDO.

    DEFINE VARIABLE hContainerWindow        AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hContainerHandle        AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE lLockWindow             AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE cErrorMessage           AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cButton                 AS CHARACTER                NO-UNDO.

    DEFINE BUFFER container_Page    FOR container_Page.

    /* We only need to lock this window when the page has not yet been initialized. */
    FIND FIRST container_Page WHERE
               container_Page.tTargetProcedure = TARGET-PROCEDURE AND
               container_Page.tPageNumber      = piPageNum
               NO-ERROR.
    IF AVAILABLE container_Page AND container_Page.tPageInitialized = NO THEN
        ASSIGN lLockWindow = YES.
    ELSE
        ASSIGN lLockWindow = NO.

    IF lLockWindow EQ YES THEN
        ASSIGN hContainerWindow = DYNAMIC-FUNCTION("getContainingWindow":U IN TARGET-PROCEDURE)
               /* Double check that we have a window handle. */
               lLockWindow      = VALID-HANDLE(hContainerWindow)
               .
    /* This second check is in case the containing window could not be found. */
    IF lLockWindow EQ YES THEN
        /* Now lock the window */
        {fnarg lockContainingWindow TRUE hContainerWindow}.
    
    RUN SUPER ( INPUT piPageNum ).

    IF lLockWindow EQ YES THEN
        {fnarg lockContainingWindow FALSE hContainerWindow}.

    ASSIGN hContainerWindow = DYNAMIC-FUNCTION("getContainingWindow":U IN TARGET-PROCEDURE).
    {get ContainerHandle hContainerHandle hContainerWindow}.

    IF LENGTH(hContainerHandle:PRIVATE-DATA)         GT 0              AND
       ENTRY(1,hContainerHandle:PRIVATE-DATA,CHR(3)) EQ "ForcedExit":U THEN
    DO:
        IF NUM-ENTRIES(hContainerHandle:PRIVATE-DATA,CHR(3)) EQ 2 THEN
            ASSIGN cErrorMessage = ENTRY(2,hContainerHandle:PRIVATE-DATA,CHR(3)).
        ELSE 
            ASSIGN cErrorMessage = "Program aborted due to unknown reason.":U.

        RUN showMessages IN gshSessionManager ( INPUT  cErrorMessage,            /* message to display */
                                                INPUT  "ERR":U,                  /* error type */
                                                INPUT  "&OK":U,                  /* button list */
                                                INPUT  "&OK":U,                  /* default button */ 
                                                INPUT  "&OK":U,                  /* cancel button */
                                                INPUT  "Error on folder page initialization":U,  /* error window title */
                                                INPUT  YES,                      /* display if empty */ 
                                                INPUT  TARGET-PROCEDURE,         /* container handle */ 
                                                OUTPUT cButton                   /* button pressed */       ).
        RUN destroyObject IN hContainerWindow.
        RETURN.
    END.    /* forced exit */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* selectPage */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerModifyMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setContainerModifyMode Procedure 
PROCEDURE setContainerModifyMode :
/*------------------------------------------------------------------------------
  Purpose:     Force whole container into modify mode - including header/detail
               windows where they have many toolbars.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.
    DEFINE VARIABLE hHandle                     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE dInstanceId                 AS DECIMAL              NO-UNDO.

    DEFINE BUFFER frame_Object FOR container_Object.

    {get InstanceId dInstanceId}.

    FIND FIRST frame_Object WHERE
               frame_Object.tRecordIdentifier = dInstanceId    AND
               frame_Object.tTargetProcedure  = TARGET-PROCEDURE 
               NO-LOCK.
    
    IF NUM-ENTRIES(frame_Object.tToolbarHandles) > 0 THEN
    DO iLoop = 1 TO NUM-ENTRIES(frame_Object.tToolbarHandles):
        ASSIGN hHandle = WIDGET-HANDLE(ENTRY(iLoop, frame_Object.tToolbarHandles)).
        PUBLISH "updateMode" FROM hHandle ("Enable":U).
    END.    /* loop through handles */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* setContainerModifyMode */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerViewMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setContainerViewMode Procedure 
PROCEDURE setContainerViewMode :
/*------------------------------------------------------------------------------
  Purpose:     Force whole container intio view mode - including header/detail
               windows where they have many toolbars.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iLoop                   AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE hHandle                 AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE dInstanceId             AS DECIMAL                  NO-UNDO.

    DEFINE BUFFER frame_Object FOR container_Object.

    {get InstanceId dInstanceId}.

    FIND FIRST frame_Object WHERE
               frame_Object.tRecordIdentifier = dInstanceId    AND
               frame_Object.tTargetProcedure  = TARGET-PROCEDURE
               NO-LOCK.

    IF NUM-ENTRIES(frame_Object.tToolbarHandles) > 0 THEN
    DO iLoop = 1 TO NUM-ENTRIES(frame_Object.tToolbarHandles):
        ASSIGN hHandle = WIDGET-HANDLE(ENTRY(iLoop, frame_Object.tToolbarHandles)).
        PUBLISH "updateMode" FROM hHandle ("View").
    END.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* setContainerViewMode */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addAllLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addAllLinks Procedure 
FUNCTION addAllLinks RETURNS LOGICAL
    ( /* No parameters */   ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hSourceObject               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hTargetObject               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE dInstanceId                 AS DECIMAL              NO-UNDO.

    DEFINE BUFFER source_Object         FOR container_Object.
    DEFINE BUFFER target_Object         FOR container_Object.
    DEFINE BUFFER container_Link        FOR container_Link.

    FOR EACH container_Link WHERE
             container_Link.tTargetProcedure = TARGET-PROCEDURE AND
             container_Link.tLinkCreated     = NO                    :

        FIND FIRST source_Object WHERE
                   source_Object.tTargetProcedure   = TARGET-PROCEDURE AND
                   source_Object.tObjectInstanceObj = container_Link.tSourceObjectInstanceObj
                   NO-ERROR.
        FIND FIRST target_Object WHERE
                   target_Object.tTargetProcedure   = TARGET-PROCEDURE AND
                   target_Object.tObjectInstanceObj = container_Link.tTargetObjectInstanceObj
                   NO-ERROR.

        ASSIGN hSourceObject = ( IF AVAILABLE source_Object AND container_Link.tSourceObjectInstanceObj GT 0 THEN 
                                    source_Object.tObjectInstanceHandle
                                 ELSE
                                    TARGET-PROCEDURE
                               ).
        ASSIGN hTargetObject = ( IF AVAILABLE target_Object  AND container_Link.tTargetObjectInstanceObj GT 0 THEN 
                                    target_Object.tObjectInstanceHandle
                                 ELSE
                                    TARGET-PROCEDURE
                               ).
        IF VALID-HANDLE(hSourceObject) AND VALID-HANDLE(hTargetObject) AND hSourceObject NE hTargetObject THEN
        DO:
            RUN addLink IN TARGET-PROCEDURE (hSourceObject, container_Link.tLinkName, hTargetObject) NO-ERROR.            
            ASSIGN container_Link.tLinkCreated = YES.
        END.    /* valid souirce and target */
    END.    /* each link */

    RETURN TRUE.
END FUNCTION.   /* addAllLinks */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildAllObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildAllObjects Procedure 
FUNCTION buildAllObjects RETURNS LOGICAL
    ( /* No Parameters */ ):
/*------------------------------------------------------------------------------
  Purpose:  Builds all objects on this window using constructObject.
    Notes:  * returning FALSE from the function results in the container's creation
              being aborted, as well as that of the containing window.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hObjectProcedure        AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE iCurrentPage            AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE dInstanceId             AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE hSuper                  AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hDefaultFrame           AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE iSuperCnt               AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cSuper                  AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cContainerType          AS CHARACTER                NO-UNDO.

    DEFINE BUFFER frame_Object          FOR container_Object.
    DEFINE BUFFER container_Object      FOR container_Object.

    {get CurrentPage iCurrentPage}.
    {get InstanceID dInstanceId}.   
    {get ContainerType cContainerType}.

    IF cContainerType EQ "Window":U THEN
        {get WindowFrameHandle hDefaultFrame}.
    ELSE
        {get ContainerHandle hDefaultFrame}.

    /* The Container itself. */
    FIND FIRST frame_Object WHERE
               frame_Object.tRecordIdentifier = dInstanceId    AND
               frame_Object.tTargetProcedure  = TARGET-PROCEDURE
               NO-LOCK NO-ERROR.

    FOR EACH container_Object WHERE
             container_Object.tContainerRecordIdentifier = dInstanceId      AND
             container_Object.tTargetProcedure           = TARGET-PROCEDURE AND
             container_Object.tPageNumber                = iCurrentPage
             NO-LOCK
             BY container_Object.tPageNumber
             BY container_Object.tInstanceOrder
             BY container_Object.tLayoutPosition
             /* This in case something goes wrong with the constructObject call. */
             ON STOP UNDO, RETURN FALSE:

        /* If the physical object name cannot be found, then don't even bother going any further. 
         * If an error is raised here, then the window will shut down gracefully ith an error message. */
        IF container_Object.tObjectPathedFilename EQ ?    OR
           container_Object.tObjectPathedFilename EQ "":U THEN
            RETURN FALSE.

        /* Create the object.
         * We set the current logical name to the InstanceID of the instance we are creating,
         * so that the correct instance can be retrieved.                                       */
        ASSIGN gcCurrentObjectName = "InstanceID=":U + STRING(container_Object.tRecordIdentifier) + CHR(1) + container_Object.tLogicalObjectName.

        /* Even though the ADMProps TT is populated with the values from the Repository, there 
         * may be attributes which need to be explicitly set. The list of attributes returned
         * buildAttributeList contains those attributes which are to be set.                  */
        RUN constructObject IN TARGET-PROCEDURE ( INPUT  (container_Object.tObjectPathedFilename + (IF container_Object.tDbAware THEN CHR(3) + "DBAWARE" ELSE "":U)),
                                                  INPUT  hDefaultFrame,
                                                  INPUT  container_Object.tAttributeList,
                                                  OUTPUT hObjectProcedure                   ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN FALSE.
        /* Something may have gone wrong and the handle may be invalid. */
        IF NOT VALID-HANDLE(hObjectProcedure) THEN RETURN FALSE.

        /* Keep ordered list of objects constructed on container */
        ASSIGN container_Object.tObjectInstanceHandle = hObjectProcedure.

        ASSIGN frame_Object.tObjectHandles = frame_Object.tObjectHandles + STRING(hObjectProcedure) + ",":U
               gcCurrentObjectName         = "":U.

        /* Store the contained Toolbar handles */
        IF {fnarg instanceOf 'SmartToolbar' hObjectProcedure} THEN
            ASSIGN frame_Object.tToolbarHandles = frame_Object.tToolbarHandles + STRING(hObjectProcedure) + ",":U.

        /* Store the contained toolbar handles */
        IF {fnarg instanceOf 'DynFrame' hObjectProcedure} THEN
            ASSIGN frame_Object.tContainerHandles = frame_Object.tContainerHandles + STRING(hObjectProcedure) + ",":U.

        IF container_Object.tCustomSuperProcedure NE "":U THEN
        DO:
            {launch.i
                &PLIP        = container_Object.tCustomSuperProcedure
                &OnApp       = 'NO' 
                &Iproc       = ''
                &NewInstance = YES
            }
            IF VALID-HANDLE(hPlip) THEN
            DO:
                DYNAMIC-FUNCTION("addAsSuperProcedure":U IN gshSessionManager,
                                 INPUT hPlip, INPUT hObjectProcedure).
                ASSIGN container_Object.tCustomSuperHandle  = hPlip.
            END.    /* custom super created OK */
        END.    /* object created ok, and super exists. */       
    END.    /* objects on a page. */

    /* Get the container object and assign the super procedure to the temp table field tCustomSuperHandle */
    IF frame_Object.tCustomSuperProcedure > "" THEN
    DO iSuperCnt = 1 TO NUM-ENTRIES(TARGET-PROCEDURE:SUPER-PROCEDURES):
        ASSIGN hSuper = WIDGET-HANDLE(ENTRY(iSuperCnt,TARGET-PROCEDURE:SUPER-PROCEDURES)) NO-ERROR.

        IF VALID-HANDLE(hSuper) THEN
        DO:
            IF REPLACE(hSuper:FILE-NAME,"~\":U,"/") = REPLACE(frame_Object.tCustomSuperProcedure,"~\":U,"/") THEN
            DO:
                ASSIGN frame_Object.tCustomSuperHandle  = hSuper.
                LEAVE.
            END.
        END.
    END.    /* there are super procedures. */

    RETURN TRUE.
END FUNCTION.   /* buildAllObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildContainerTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildContainerTables Procedure 
FUNCTION buildContainerTables RETURNS LOGICAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates information which will be used by this container to construct
            objects on the container.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hObjectBuffer           AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hPageBuffer             AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hLinkBuffer             AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hContainerObject        AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hContainerPage          AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hContainerLink          AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer        AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE dInstanceInstanceId     AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE dInstanceId             AS DECIMAL                  NO-UNDO.    
    
    FOR EACH container_Object WHERE container_Object.tTargetProcedure = TARGET-PROCEDURE:         
        DELETE container_Object.
    END.    /* each container object. */
    
    FOR EACH container_Page WHERE container_Page.tTargetProcedure = TARGET-PROCEDURE:
        DELETE container_Page.
    END.

    FOR EACH container_Link WHERE container_Link.tTargetProcedure = TARGET-PROCEDURE:
        DELETE container_Link.
    END.

    ASSIGN hContainerObject = BUFFER container_Object:HANDLE
           hContainerPage   = BUFFER container_Page:HANDLE
           hContainerLink   = BUFFER container_Link:HANDLE
           .
    {get InstanceID dInstanceId}.
    
    ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT dInstanceId)
           hPageBuffer   = DYNAMIC-FUNCTION("getCachePageBuffer":U IN gshRepositoryManager)
           hLinkBuffer   = DYNAMIC-FUNCTION("getCacheLinkBuffer":U IN gshRepositoryManager)
           .
    /* We create a local buffer here because we don't want it to go out of scope. 
     * constructObject results i the hObjectBuffer going out of scope, since there are FINDs
     * performed on that buffer.                                                            */
    IF NOT VALID-HANDLE(ghQuery1) THEN
        CREATE QUERY ghQuery1.

    ghQuery1:SET-BUFFERS(hObjectBuffer).
    ghQuery1:QUERY-PREPARE(" FOR EACH ":U + hObjectBuffer:NAME + " WHERE ":U
                           + hObjectBuffer:NAME + ".tContainerRecordIdentifier = " + QUOTER(dInstanceId) + " OR ":U 
                           + hObjectBuffer:NAME + ".tRecordIdentifier = "          + QUOTER(dInstanceId) ).
    ghQuery1:QUERY-OPEN().

    ghQuery1:GET-FIRST().
    DO WHILE hObjectBuffer:AVAILABLE:
        hContainerObject:BUFFER-CREATE().
        hContainerObject:BUFFER-COPY(hObjectBuffer).

        ASSIGN dInstanceInstanceId = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
               hAttributeBuffer    = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
               .
        hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dInstanceInstanceId) ).

        /* Store the list of settable attributes. */
        ASSIGN hContainerObject:BUFFER-FIELD("tAttributeList":U):BUFFER-VALUE = DYNAMIC-FUNCTION("buildAttributeList":U IN gshRepositoryManager,
                                                                                                 INPUT hAttributeBuffer,
                                                                                                 INPUT dInstanceInstanceId).
        /* Store all of the attributes in RAW format */
        hAttributeBuffer:RAW-TRANSFER(TRUE, hContainerObject:BUFFER-FIELD("tRawAttributes":U)).
        ASSIGN hContainerObject:BUFFER-FIELD("tTargetProcedure":U):BUFFER-VALUE = TARGET-PROCEDURE.

        hContainerObject:BUFFER-RELEASE().
        ghQuery1:GET-NEXT().
    END.    /* available buffer */
    ghQuery1:QUERY-CLOSE().

    ghQuery1:SET-BUFFERS(hPageBuffer).
    ghQuery1:QUERY-PREPARE(" FOR EACH ":U + hPageBuffer:NAME + " WHERE ":U + hPageBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dInstanceId) ).
    ghQuery1:QUERY-OPEN().

    ghQuery1:GET-FIRST().
    DO WHILE hPageBuffer:AVAILABLE:
        hContainerPage:BUFFER-CREATE().
        hContainerPage:BUFFER-COPY(hPageBuffer).
        ASSIGN hContainerPage:BUFFER-FIELD("tTargetProcedure":U):BUFFER-VALUE = TARGET-PROCEDURE.
        hContainerPage:BUFFER-RELEASE().

        ghQuery1:GET-NEXT().
    END.    /* available page */
    ghQuery1:QUERY-CLOSE().

    ghQuery1:SET-BUFFERS(hLinkBuffer).
    ghQuery1:QUERY-PREPARE(" FOR EACH ":U + hLinkBuffer:NAME + " WHERE ":U + hLinkBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(dInstanceId) ).
    ghQuery1:QUERY-OPEN().

    ghQuery1:GET-FIRST().
    DO WHILE hLinkBuffer:AVAILABLE:
        hContainerLink:BUFFER-CREATE().
        hContainerLink:BUFFER-COPY(hLinkBuffer).
        ASSIGN hContainerLink:BUFFER-FIELD("tTargetProcedure":U):BUFFER-VALUE = TARGET-PROCEDURE.
        hContainerLink:BUFFER-RELEASE().

        ghQuery1:GET-NEXT().
    END.    /* available link */
    ghQuery1:QUERY-CLOSE().

    RETURN TRUE.
END FUNCTION.   /* buildContainerTables */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildInitialPageList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildInitialPageList Procedure 
FUNCTION buildInitialPageList RETURNS CHARACTER
    ( /* No parameters */  ) :
/*------------------------------------------------------------------------------
  Purpose:  Builds a list of the pages to be instantiated when the container is
            created.
    Notes:  * The list is a comma delimited list of initial pages, or * for all or
              empty for just the start page and page 0, which is the default
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cInitialPageList            AS CHARACTER            NO-UNDO.
    
    {get InitialPageList cInitialPageList}.
    
    IF cInitialPageList EQ "*":U THEN /* Deal with all pages option */
    DO:
        ASSIGN cInitialPageList = "":U.

        FOR EACH container_Page WHERE
                 container_Page.tTargetProcedure = TARGET-PROCEDURE AND 
                 container_Page.tPageNumber      > 0
                 BY container_Page.tPageNumber:
            ASSIGN  cInitialPageList = cInitialPageList + (IF NUM-ENTRIES(cInitialPageList) EQ 0 THEN "":U ELSE ",":U)
                                     + STRING(container_Page.tPageNumber).
        END.    /* available page */

        /* Set the new initial page list. */
        {set InitialPageList cInitialPageList}.
    END.    /* all page initialized on start up */

    RETURN cInitialPageList.
END FUNCTION.   /* buildInitialPageList */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerObjectBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerObjectBuffer Procedure 
FUNCTION getContainerObjectBuffer RETURNS HANDLE
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBuffer                     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE dInstanceId                 AS DECIMAL              NO-UNDO.

    {get InstanceId dInstanceId}.

    FIND FIRST container_Object WHERE
               container_Object.tTargetProcedure  = TARGET-PROCEDURE AND
               container_Object.tRecordIdentifier = dInstanceId
               NO-ERROR.

    ASSIGN hBuffer = BUFFER container_Object:HANDLE.

    RETURN hBuffer.
END FUNCTION.   /* getContainerObjectBuffer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerPageBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerPageBuffer Procedure 
FUNCTION getContainerPageBuffer RETURNS HANDLE
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBuffer                     AS HANDLE                   NO-UNDO.

    ASSIGN hBuffer = BUFFER container_Page:HANDLE.

    RETURN hBuffer.
END FUNCTION.   /* getContainerPageBuffer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainingWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainingWindow Procedure 
FUNCTION getContainingWindow RETURNS HANDLE
    ( /* No Parameters */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the window object. Because DynFrames may be nested
            we may need to go up a couple of container levels.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hContainerSource        AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hCurrentContainer       AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cContainerType          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE lLockWindow             AS LOGICAL                  NO-UNDO.

    {get ContainerType cContainerType}.

    /* Determine the window procedure handle. */
    IF cContainerType EQ "Window":U THEN
        ASSIGN hContainerSource = TARGET-PROCEDURE.
    ELSE
    DO:
        {get ContainerSource hContainerSource}.

        DO WHILE VALID-HANDLE(hContainerSource):
            {get ContainerType cContainerType hContainerSource}.
            IF cContainerType EQ "Window":U THEN
                LEAVE.

            ASSIGN hCurrentContainer = hContainerSource.
            {get ContainerSource hContainerSource hCurrentContainer}.
        END.    /* loop up container stack */

        /* Double check that this is a container Window. */
        {get ContainerType cContainerType hContainerSource}.
        IF cContainerType NE "Window":U THEN
            ASSIGN hContainerSource = ?.
    END.    /* not a window. */

    RETURN hContainerSource.
END FUNCTION.   /* getContainingWindow */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Used by prepareInstance in the Repository Manager.
    Notes:  
------------------------------------------------------------------------------*/
    RETURN gcCurrentObjectName.
END FUNCTION.   /* getCurrentLogicalName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLayoutManagerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLayoutManagerHandle Procedure 
FUNCTION getLayoutManagerHandle RETURNS HANDLE
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Retrieves the handle to the layout manager.
    Notes:  * This code uses 3 methods to determine the handle, including the
              shared global vars whicha re used for backwards compatibility.
              (1) Check for the LayoutManager specified in the icfconfig.xml file
              (2) Check the value of the global shared variable
              (3) Search the proceduretry
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hLayoutManager          AS HANDLE                   NO-UNDO.

    ASSIGN hLayoutManager = DYNAMIC-FUNCTION("getManagerHandle":U IN TARGET-PROCEDURE, INPUT "LayoutManager":U).

    IF NOT VALID-HANDLE(hLayoutManager) THEN
    DO:
        IF NOT VALID-HANDLE(gshLayoutManager) OR gshLayoutManager:UNIQUE-ID <> gshLayoutManagerID THEN 
        DO: 
            RUN ry/prc/rylayoutsp.p PERSISTENT SET gshLayoutManager.
            IF VALID-HANDLE(gshLayoutManager) THEN
                ASSIGN gshLayoutManagerID = gshLayoutManager:UNIQUE-ID.
        END.
    END.

    IF NOT VALID-HANDLE(hLayoutManager) THEN
    DO:
        ASSIGN hLayoutManager = SESSION:FIRST-PROCEDURE.

        DO WHILE VALID-HANDLE(hLayoutManager) AND NOT hLayoutManager:FILE-NAME BEGINS "ry/prc/rylayoutsp.":U:
            ASSIGN hLayoutManager = hLayoutManager:NEXT-SIBLING.
        END.    /* procedure walking */

        IF NOT VALID-HANDLE(hLayoutManager) THEN
            RUN ry/prc/rylayoutsp.p PERSISTENT SET hLayoutManager.
    END.    /* not valid layout manager. */

    IF VALID-HANDLE(hLayoutManager) THEN
        ASSIGN gshLayoutManager   = hLayoutManager
               gshLayoutManagerID = hLayoutManager:UNIQUE-ID.

    RETURN hLayoutManager.
END FUNCTION.   /* getLayoutManagerHandle */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPageLinkList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPageLinkList Procedure 
FUNCTION getPageLinkList RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a CSV list of all toolbar object handles.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dInstanceId                 AS DECIMAL              NO-UNDO.

    {get InstanceId dInstanceId}.

    FIND FIRST container_Object WHERE
               container_Object.tTargetProcedure  = TARGET-PROCEDURE AND
               container_Object.tRecordIdentifier = dInstanceId
               NO-ERROR.

    RETURN (IF AVAILABLE container_Object THEN container_Object.tPageLinkList ELSE "":U).
END FUNCTION.   /* getPageLinkList */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRawAttributeValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRawAttributeValues Procedure 
FUNCTION getRawAttributeValues RETURNS HANDLE
    ( INPUT pdInstanceId        AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FIND FIRST container_Object WHERE
               container_Object.tTargetProcedure  = TARGET-PROCEDURE AND
               container_Object.tRecordIdentifier = pdInstanceId
               NO-ERROR.
    IF AVAILABLE container_Object THEN
        RETURN BUFFER container_Object:HANDLE.

    RETURN ?.
END FUNCTION.   /* getRawAttributeValues */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getResizeOnPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getResizeOnPage Procedure 
FUNCTION getResizeOnPage RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dInstanceId                 AS DECIMAL              NO-UNDO.

    {get InstanceId dInstanceId}.

    FIND FIRST container_Object WHERE
               container_Object.tTargetProcedure  = TARGET-PROCEDURE AND
               container_Object.tRecordIdentifier = dInstanceId
               NO-ERROR.

    RETURN (IF AVAILABLE container_Object THEN container_Object.tResizeOnPage ELSE 0).
END FUNCTION.   /* getPageLinkList */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarHandles Procedure 
FUNCTION getToolbarHandles RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dInstanceId                 AS DECIMAL              NO-UNDO.

    {get InstanceId dInstanceId}.

    FIND FIRST container_Object WHERE
               container_Object.tTargetProcedure  = TARGET-PROCEDURE AND
               container_Object.tRecordIdentifier = dInstanceId
               NO-ERROR.

    RETURN (IF AVAILABLE container_Object THEN container_Object.tToolbar ELSE "":U).
END FUNCTION.   /* getToolbarHandles */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWindowName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWindowName Procedure 
FUNCTION getWindowName RETURNS CHARACTER ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Retrieves the title of the window 
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hWindow                 AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hContainerSource        AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cContainerType          AS CHARACTER                NO-UNDO.

    {get ContainerType cContainerType}.

    IF cContainerType EQ "Window":U THEN
        {get ContainerHandle hWindow}.
    ELSE
    DO:
        {get ContainerSource hContainerSource}.
        {get ContainerHandle hWindow hContainerSource}.
    END.    /* not a window */

    RETURN hWindow:TITLE.
END FUNCTION.   /* getWindowName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBox) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBox Procedure 
FUNCTION setBox RETURNS LOGICAL
    ( INPUT plBox       AS LOGICAL   ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the BOX attribute on the Frame
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hFrame                  AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cContainerType          AS CHARACTER                NO-UNDO.

    {get ContainerType cContainerType}.

    IF cContainerType EQ "Window":U THEN
        {get WindowFrameHandle hFrame}.
    ELSE
        {get ContainerHandle hFrame}.

    ASSIGN hFrame:BOX = plBox NO-ERROR.
    
    RETURN (ERROR-STATUS:ERROR EQ NO).
END FUNCTION.   /* setBox */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWindowName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWindowName Procedure 
FUNCTION setWindowName RETURNS LOGICAL
    ( INPUT pcWindowName        AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hWindow                 AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hContainerSource        AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cContainerType          AS CHARACTER                NO-UNDO.

    {get ContainerType cContainerType}.

    IF cContainerType EQ "Window":U THEN
        {get ContainerHandle hWindow}.
    ELSE
    DO:
        {get ContainerSource hContainerSource}.
        {get ContainerHandle hWindow hContainerSource}.
    END.    /* not a window */

    ASSIGN hWindow:TITLE = pcWindowName.

    RETURN TRUE.   
END FUNCTION.   /* setWindowName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateWindowSizes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateWindowSizes Procedure 
FUNCTION updateWindowSizes RETURNS LOGICAL
    ( INPUT piStartPage             AS INTEGER,
      INPUT pcInitialPageList       AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Performas sizing functions on the current window, as well as ensuring
            that the window conforms to any saved sizes.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iCurrentPage                AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iEntry                      AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cPageLinkList               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInitPages                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cWidth                      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cHeight                     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cColumn                     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cRow                        AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cProfileData                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cContainerType              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE rProfileRid                 AS ROWID                NO-UNDO.
    DEFINE VARIABLE lReturnError                AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lResized                    AS LOGICAL              NO-UNDO.     
    DEFINE VARIABLE dInstanceId                 AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE hContainerWindow            AS HANDLE               NO-UNDO.

    DEFINE BUFFER container_Object      FOR container_Object.

    ASSIGN lReturnError = NO
           lResized     = NO
           .
    {get CurrentPage   iCurrentPage}.
    {get InstanceId    dInstanceId}.
    {get ContainerType cContainerType}.

    FIND FIRST container_Object WHERE
               container_Object.tTargetProcedure  = TARGET-PROCEDURE AND
               container_Object.tRecordIdentifier = dInstanceId
               NO-ERROR.

    /* If not on page 0 (ie there is a SmartFolder) then init all of the relevant pages. */
    IF iCurrentPage GT 0 THEN
    DO:
        ASSIGN cInitPages = "":U.

        /* If no initial page list has been specified, make sure that at
         * at least Page 0 and the start page are initialised.           */
        IF pcInitialPageList EQ "":U OR pcInitialPageList EQ ? THEN
            ASSIGN pcInitialPageList = "0,":U + STRING(piStartPage).

        page-loop:
        DO iLoop = 1 TO NUM-ENTRIES(pcInitialPageList):
            ASSIGN iEntry = INTEGER(ENTRY(iLoop, pcInitialPageList)) NO-ERROR.
            IF ERROR-STATUS:ERROR OR iEntry EQ 0 THEN NEXT page-loop.

            ASSIGN cInitPages = cInitPages + (IF NUM-ENTRIES(cInitPages) EQ 0 THEN "":U ELSE ",":U) + STRING(iEntry)
                   /* Ensure only resize on last page being initialized */
                   container_Object.tResizeOnPage = iEntry.
        END.    /* PAGE-LOOP */

        IF LOOKUP(STRING(piStartPage),cInitPages) EQ 0 THEN
            /* Start page not in list so resize on start page */
            ASSIGN container_Object.tResizeOnPage = piStartPage. 

        IF cInitPages NE "":U THEN
            RUN initPages IN TARGET-PROCEDURE(cInitPages).

        /* Build string 'cPageLinkList' containing delimited list of pages that 
         * are dependent on the current page, then run initpages                 */
        RUN buildPageLinks IN TARGET-PROCEDURE( INPUT iCurrentPage, OUTPUT cPageLinkList).

        ASSIGN container_Object.tPageLinkList = container_Object.tPageLinkList + cPageLinkList + ",":U
               container_Object.tPageLinkList = RIGHT-TRIM(container_Object.tPageLinkList, ",":U)
               .
        IF cPageLinkList <> "":U THEN
            RUN initPages IN TARGET-PROCEDURE (cPageLinkList).

        /* Pack and resize. */
        IF cContainerType EQ "Frame":U THEN
        DO:
            ASSIGN hContainerWindow = DYNAMIC-FUNCTION("getContainingWindow":U IN TARGET-PROCEDURE).

            /* Only do this separately once the container window has completed its initialization
             * because the window will pack/resize itself. We need to do this separately when we
             * change pages in this frame container.                                              */
            IF {fn getObjectInitialized hContainerWindow} THEN
            DO:
                /* Pass a null value into the window's packing procedure. See packWindow in 
                 * rydynwindp for more details.                                             */
                RUN packWindow IN hContainerWindow ( INPUT ?, INPUT NO).

                /* And now resize the window so that everything fits properly. */
                RUN resizeWindow IN hContainerWindow.
            END.    /* Containing window is completely initialized. */
        END.    /* Frame. */
    END.    /* Current page is not 0 */

    RETURN (lReturnError EQ NO).
END FUNCTION.   /*  updateWindowSizes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

