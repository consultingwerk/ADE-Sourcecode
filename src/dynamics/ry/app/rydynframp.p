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
/*************************************************************/  
/* Copyright (c) 1984-2007 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: rydynframp.p

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

/* Tell *attr.i that this is the Super procedure. */
&SCOP ADMSuper rydynframp.p

/* object identifying preprocessor */
&glob   AstraProcedure    yes

/* This variable should NEVER be accessed directly; it should always be 
   accessed using the {getCurrentLogicalName} and {setCurrentLogicalName} 
   functions.
 */
DEFINE VARIABLE gcCurrentObjectName             AS CHARACTER        NO-UNDO.

DEFINE VARIABLE ghLayoutManager                 AS HANDLE           NO-UNDO.
/* These are kept for backwards compatibilty. */
DEFINE NEW GLOBAL SHARED VARIABLE gshLayoutManager      AS HANDLE.
DEFINE NEW GLOBAL SHARED VARIABLE gshLayoutManagerID    AS INTEGER.

DEFINE VARIABLE ghQuery1                    AS HANDLE               NO-UNDO.

/* These handles store the buffers of the cacheObject, cachePage and cacheLink
 * temp-tables in the Repository Manager. We use these to build the objects.
 * These are global variables since this is more efficient that re-fetching the,
 * every time they are needed, and also the tables in the cache don't change (even
 * though the contents of those tables change).
 */
DEFINE VARIABLE ghCacheObject              AS HANDLE                    NO-UNDO.
DEFINE VARIABLE ghCachePage                AS HANDLE                    NO-UNDO.
DEFINE VARIABLE ghCacheLink                AS HANDLE                    NO-UNDO.
DEFINE VARIABLE glUseThinRendering         AS LOGICAL                   NO-UNDO.

/* Delimiter for the AttrValues field in the cacheObject temp-table. */
&SCOPED-DEFINE Value-Delimiter CHR(1)

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
    ( INPUT pcPageList    AS CHARACTER   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildAllObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildAllObjects Procedure 
FUNCTION buildAllObjects RETURNS LOGICAL
    ( INPUT pcContainerName       AS CHARACTER,
      INPUT pcPageList            AS CHARACTER  ) FORWARD.

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

&IF DEFINED(EXCLUDE-calculateStartPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD calculateStartPage Procedure 
FUNCTION calculateStartPage RETURNS INTEGER
        ( ) FORWARD.

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

&IF DEFINED(EXCLUDE-getRunTimeAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRunTimeAttribute Procedure 
FUNCTION getRunTimeAttribute RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-getTreeRunAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTreeRunAttribute Procedure 
FUNCTION getTreeRunAttribute RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-newHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newHeight Procedure 
FUNCTION newHeight RETURNS LOGICAL
  ( pdHeight AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newWidth Procedure 
FUNCTION newWidth RETURNS CHARACTER
  ( pdWidth AS DECIMAL )  FORWARD.

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

&IF DEFINED(EXCLUDE-setContainerInitialMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainerInitialMode Procedure 
FUNCTION setContainerInitialMode RETURNS LOGICAL
    ( INPUT pcContainerMode        AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentLogicalName Procedure 
FUNCTION setCurrentLogicalName RETURNS LOGICAL
    ( pcCurrentObjectName AS CHARACTER )  FORWARD.

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
         WIDTH              = 63.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/cntnprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
ASSIGN glUseThinRendering = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                             INPUT "UseThinRendering":U ).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  Notes:       * This procedure is called from createObjects 
                 * Page 0 is never added to this list.
                 * Pages that are already running/init'ed are not added to this list.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piCurrentPage               AS INTEGER      NO-UNDO.
    DEFINE OUTPUT PARAMETER pcPageList                  AS CHARACTER    NO-UNDO.
    
    DEFINE VARIABLE dInstanceId                  AS DECIMAL             NO-UNDO.        
    DEFINE VARIABLE cLinkName                    AS CHARACTER           NO-UNDO.    
    DEFINE VARIABLE cInstanceName                AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE hLinkBuffer                  AS HANDLE              NO-UNDO.
    DEFINE VARIABLE iPageNumber                  AS INTEGER             NO-UNDO.
    
    IF NOT VALID-HANDLE(ghCacheObject) THEN
        RUN returnCacheBuffers IN gshRepositoryManager ( OUTPUT ghCacheObject,
                                                         OUTPUT ghCachePage,
                                                         OUTPUT ghCacheLink     ).
    
    {get InstanceID dInstanceId}.
                
    CREATE BUFFER hLinkBuffer        FOR TABLE ghCacheLink    BUFFER-NAME "LocalLink":U.
        
    IF NOT VALID-HANDLE(ghQuery1) THEN
        CREATE QUERY ghQuery1.
        
    ghQuery1:SET-BUFFERS(ghCacheLink).
    
    /* Look upstream for any Data-Sources or GroupAssign-Sources that are associated with this
       page.
     */
    ghQuery1:QUERY-PREPARE(" FOR EACH ":U + ghCacheLink:NAME + " WHERE ":U
                           + " ( ":U + ghCacheLink:NAME + ".InstanceId = ":U + QUOTER(dInstanceId) + " AND ":U
                                     + ghCacheLink:NAME + ".LinkName   = 'GroupAssign' AND ":U
                                     + ghCacheLink:NAME + ".TargetPage = ":U + QUOTER(piCurrentPage) + " ) OR ":U
                           + " ( ":U + ghCacheLink:NAME + ".InstanceId = ":U + QUOTER(dInstanceId) + " AND ":U
                                     + ghCacheLink:NAME + ".LinkName   = 'Data' AND ":U
                                     + ghCacheLink:NAME + ".TargetPage = ":U + QUOTER(piCurrentPage) + " ) ":U ).
    ghQuery1:QUERY-OPEN().
    ghQuery1:GET-FIRST().
    DO WHILE ghCacheLink:AVAILABLE:
        ASSIGN iPageNumber   = ghCacheLink:BUFFER-FIELD("SourcePage"):BUFFER-VALUE
               cLinkName     = ghCacheLink:BUFFER-FIELD("LinkName"):BUFFER-VALUE
               cInstanceName = ghCacheLink:BUFFER-FIELD("SourceInstanceName"):BUFFER-VALUE.
        
        /* Ignore this page - we know about it already. */
        IF iPageNumber EQ piCurrentPage OR
           iPageNumber EQ 0             OR
           DYNAMIC-FUNCTION("PageNTargets":U IN TARGET-PROCEDURE,
                            TARGET-PROCEDURE, iPageNumber) NE "":U THEN
        DO:
            ghQuery1:GET-NEXT().
            NEXT.
        END.    /* the other end of the link is on this page. */
        
        /* Add it to the list */
        IF NOT CAN-DO(pcPageList, STRING(iPageNumber)) THEN
            ASSIGN pcPageList = pcPageList + ",":U + STRING(iPageNumber).
        
        /* Follow the selected link as far as possible, until there is no longer a new source.
         */
        hLinkBuffer:FIND-FIRST(" WHERE ":U
                               + hLinkBuffer:NAME + ".InstanceId         = ":U + QUOTER(dInstanceId)   + " AND ":U
                               + hLinkBuffer:NAME + ".TargetInstanceName = ":U + QUOTER(cInstanceName) + " AND ":U
                               + hLinkBuffer:NAME + ".LinkName           = ":U + QUOTER(cLinkName)     + " AND ":U
                               + hLinkBuffer:NAME + ".TargetPage         = ":U + QUOTER(iPageNumber) ) NO-ERROR.
        DO WHILE hLinkBuffer:AVAILABLE:
            ASSIGN iPageNumber   = hLinkBuffer:BUFFER-FIELD("SourcePage"):BUFFER-VALUE
                   cInstanceName = hLinkBuffer:BUFFER-FIELD("SourceInstanceName"):BUFFER-VALUE.
                   
            /* Add it to the list */
            IF iPageNumber NE 0                                         AND
               NOT CAN-DO(pcPageList, STRING(iPageNumber))              AND
               DYNAMIC-FUNCTION("PageNTargets":U IN TARGET-PROCEDURE, 
                                TARGET-PROCEDURE, iPageNumber) EQ "":U  THEN
                ASSIGN pcPageList = pcPageList + ",":U + STRING(iPageNumber).
            
            /* Go further up the stream. */
            hLinkBuffer:FIND-FIRST(" WHERE ":U
                                   + hLinkBuffer:NAME + ".InstanceId         = ":U + QUOTER(dInstanceId)   + " AND ":U
                                   + hLinkBuffer:NAME + ".TargetInstanceName = ":U + QUOTER(cInstanceName) + " AND ":U
                                   + hLinkBuffer:NAME + ".LinkName           = ":U + QUOTER(cLinkName)     + " AND ":U
                                   + hLinkBuffer:NAME + ".TargetPage         = ":U + QUOTER(iPageNumber) ) NO-ERROR.
            NEXT.
        END.    /* available buffer */
        
        ghQuery1:GET-NEXT().
    END.    /* available link */
    ghQuery1:QUERY-CLOSE().
    
    /* Look downstream for any GroupAssign-Targets that may be associated
     * with this page. */
    ghQuery1:QUERY-PREPARE(" FOR EACH ":U + ghCacheLink:NAME + " WHERE ":U                            
                           + ghCacheLink:NAME + ".InstanceId = ":U + QUOTER(dInstanceId) + " AND ":U
                           + ghCacheLink:NAME + ".LinkName   = 'GroupAssign' AND ":U
                           + ghCacheLink:NAME + ".SourcePage = ":U + QUOTER(piCurrentPage) ).
    ghQuery1:QUERY-OPEN().
    ghQuery1:GET-FIRST().
    DO WHILE ghCacheLink:AVAILABLE:
        ASSIGN iPageNumber   = ghCacheLink:BUFFER-FIELD("TargetPage"):BUFFER-VALUE
               cLinkName     = ghCacheLink:BUFFER-FIELD("LinkName"):BUFFER-VALUE
               cInstanceName = ghCacheLink:BUFFER-FIELD("TargetInstanceName"):BUFFER-VALUE.
        
        /* Ignore this page - we know about it already. */
        IF iPageNumber EQ piCurrentPage OR
           iPageNumber EQ 0             OR
           DYNAMIC-FUNCTION("PageNTargets":U IN TARGET-PROCEDURE,
                            TARGET-PROCEDURE, iPageNumber) NE "":U THEN        
        DO:
            ghQuery1:GET-NEXT().
            NEXT.
        END.    /* the other end of the link is on this page. */
        
        /* Follow the selected link as far as possible, until there is no longer a new source.
           */
        hLinkBuffer:FIND-FIRST(" WHERE ":U
                               + hLinkBuffer:NAME + ".InstanceId         = ":U + QUOTER(dInstanceId)   + " AND ":U
                               + hLinkBuffer:NAME + ".SourceInstanceName = ":U + QUOTER(cInstanceName) + " AND ":U
                               + hLinkBuffer:NAME + ".LinkName           = ":U + QUOTER(cLinkName)     + " AND ":U
                               + hLinkBuffer:NAME + ".SourcePage         = ":U + QUOTER(iPageNumber) ) NO-ERROR.
        DO WHILE hLinkBuffer:AVAILABLE:
            ASSIGN iPageNumber   = hLinkBuffer:BUFFER-FIELD("TargetPage"):BUFFER-VALUE
                   cInstanceName = hLinkBuffer:BUFFER-FIELD("TargetInstanceName"):BUFFER-VALUE.
            
            /* Add it to the list. */
            IF iPageNumber NE 0                                         AND
               NOT CAN-DO(pcPageList, STRING(iPageNumber))              AND
               DYNAMIC-FUNCTION("PageNTargets":U IN TARGET-PROCEDURE, 
                                TARGET-PROCEDURE, iPageNumber) EQ "":U  THEN            
                ASSIGN pcPageList = pcPageList + ",":U + STRING(iPageNumber).
            
            /* Go further down the stream. */
            hLinkBuffer:FIND-FIRST(" WHERE ":U
                                   + hLinkBuffer:NAME + ".InstanceId         = ":U + QUOTER(dInstanceId)   + " AND ":U
                                   + hLinkBuffer:NAME + ".SourceInstanceName = ":U + QUOTER(cInstanceName) + " AND ":U
                                   + hLinkBuffer:NAME + ".LinkName           = ":U + QUOTER(cLinkName)     + " AND ":U
                                   + hLinkBuffer:NAME + ".SourcePage         = ":U + QUOTER(iPageNumber) ) NO-ERROR.
            NEXT.
        END.    /* available buffer */
                        
        /* Add it to the list. */
        IF iPageNumber NE 0 AND NOT CAN-DO(pcPageList, STRING(iPageNumber)) THEN
            ASSIGN pcPageList = pcPageList + ",":U + STRING(iPageNumber).
        
        /* Get the page that the other*/
        ghQuery1:GET-NEXT().
    END.    /* available link */
    ghQuery1:QUERY-CLOSE().
     
    DELETE OBJECT hLinkBuffer NO-ERROR.
         
    ASSIGN hLinkBuffer = ?
           pcPageList  = LEFT-TRIM(pcPageList, ",":U).
    
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
    DEFINE VARIABLE iStartPage                  AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iEntry                      AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iResizeOnPage               AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iNumberofPages              AS integer              NO-UNDO.
    DEFINE VARIABLE cDataTargets                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSdoForeignFields           AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInitialPageList            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cObjectName                 AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInitPages                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cRequiredPages              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cAllRequiredPages           AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hDataTarget                 AS HANDLE               NO-UNDO.
    DEFINE VARIABLE dInstanceID                 AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE cContainerType              AS CHARACTER            NO-UNDO.    
    DEFINE VARIABLE hDefaultFrame               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hContainerHandle            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hContainingWindow           AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hWindow                     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE lPageObjectsCreated         AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE lInitPage        AS logical    EXTENT 100           NO-UNDO.
    
    /* Is this viewer a generated object? If so, then we don't need
       to create the widgets dynamically, since they are created in the
       generated procedure itself.
     */
    IF NOT CAN-DO(TARGET-PROCEDURE:internal-entries, 'adm-assignObjectProperties') THEN
    do:
        &SCOPED-DEFINE xp-assign
        {get CurrentPage iCurrentPage}
        {get InstanceId dInstanceId}
        {get ContainerHandle hDefaultFrame}
        {get ContainerType cContainerType}.
        &UNDEFINE xp-assign

        /* Only run createObjects once per page. We can check the 
           ObjectsCreated property for page 0, but need to be a little 
           more careful for pages 1+. Emulate the behaviour in selectPage()
           where the PageNTargets are checked for the existence of objects.
           If there are none, then the page has not yet been constructed.
         */
       IF iCurrentPage EQ 0 THEN
        DO:
            {get ObjectsCreated lPageObjectsCreated}.
            IF lPageObjectsCreated THEN
                RETURN.
        END.    /* Page 0 */
        ELSE
        IF DYNAMIC-FUNCTION("PageNTargets":U IN TARGET-PROCEDURE, TARGET-PROCEDURE, iCurrentPage) NE "":U THEN
            RETURN.
            
        IF cContainerType EQ "Window":U THEN
            {get WindowFrameHandle hDefaultFrame}.
            
        /** We have already retrieved the object from the cache, in prepareInstance 
         *  which is called on instantiation of this object. This sets the instanceID
         *  property which stores the dInstanceId property.
         *  ----------------------------------------------------------------------- **/
        IF NOT VALID-HANDLE(ghCacheObject) THEN
            RUN returnCacheBuffers IN gshRepositoryManager ( OUTPUT ghCacheObject,
                                                             OUTPUT ghCachePage,
                                                             OUTPUT ghCacheLink     ) NO-ERROR.
            
        ghCacheObject:FIND-FIRST(" WHERE ":U + ghCacheObject:NAME + ".InstanceId = ":U
                                 + QUOTER(dInstanceId) ) NO-ERROR.
            
        /* Something may have happened to clear the repository cache,
           particularly if this is no the first page (0 and 1 for instance).
           In this case we need to re-fetch the container itself (Page 0). We
           can't use context since there are a number of functions that use
           link and page information which is currently not stored in context.
         */
        IF NOT ghCacheObject:AVAILABLE THEN
        do:
            /* Always use the logical object name because
               we want to get the contents of this container. 
               The instance properties of this container have
               already been set by the procedure that ran this
               container.
             */
            {get LogicalObjectName cObjectName}.
            RUN cacheRepositoryObject IN gshRepositoryManager ( INPUT cObjectName,
                                                                INPUT "Page:0," + STRING(iCurrentPage),
                                                                INPUT ?, /* pcRunAttribute */
                                                                INPUT ? /* pcResultCode */ ) NO-ERROR.
                
            /* Because something went wonky and we had to re-retrieve
               the object from the repository, the InstanceId is going to
               differ from that stored in context. We need to set it to the 
               correct value.
             */
            ghCacheObject:FIND-FIRST(" WHERE ":U
                                     + ghCacheObject:NAME + ".ObjectName = ":U + QUOTER(cObjectName) + " and "
                                     + ghCacheObject:name + '.ContainerInstanceId = 0 ' ) NO-ERROR.
            IF ghCacheObject:AVAILABLE THEN
            do:
                dInstanceId = ghCacheObject:buffer-field('InstanceId'):buffer-value.
                {set InstanceId dInstanceId}.
            END.    /* cached record available. */
            /* no ELSE required. if the record is not available,
               it will be caught a little later and reported.
             */
        END.    /* container not cached */
        
        IF NOT ghCacheObject:AVAILABLE THEN
        DO:
            /* First get the error messages. */
            {afcheckerr.i &NO-RETURN=YES}
                
            IF cContainerType EQ "Frame":U THEN
            DO:
                ASSIGN hContainingWindow = {fn getContainingWindow}.
                    
                /* Get the window handle of the container. */
                {get ContainerHandle hContainerHandle hContainerHandle}.
            END.    /* Frame container. */
            ELSE
                {get ContainerHandle hContainerHandle}.
                
            /* Then window controls its self-destruction. This will cause all * objects contained on
               it to be destroyed, too. Don't overwrite any forced exit statements already there      */
            IF VALID-HANDLE(hContainerHandle) THEN
                IF NOT hContainerHandle:PRIVATE-DATA BEGINS "ForcedExit":U OR hContainerHandle:PRIVATE-DATA = ? THEN
                    ASSIGN hContainerHandle:PRIVATE-DATA = "ForcedExit":U + CHR(3) + cMessageList.
                
            RETURN.
        END.    /* errors fetching object detail. */
            
        /* Decide which pages to retrieve from the cache. If on page zero,
           make sure that page 0 objects are retrieved, too.                   
         */
        IF iCurrentPage EQ 0 THEN
            ASSIGN cInitialPageList = {fn buildInitialPageList}
                   cInitialPageList = "0,":U + cInitialPageList    WHEN NOT CAN-DO(cInitialPageList, STRING(0)).
        ELSE
            ASSIGN cInitialPageList = STRING(iCurrentPage).
            
        /* Also build the list of linked pages, which are a list of linked pages;
           these will be all pages that are GroupAssigned (in either direction, source
           or target) from this page, and all pages that contain Data-sources to this
           page.
           
           This is done early so that all relevant pages are requested from the Repository 
           in one hit.
         */
        ASSIGN cInitPages    = "":U
               cRequiredPages = "":U.
                   
        /* If we are on page 0, we need to make sure that the RequiredPages
           property has the right number of |-entries.
           We also need this property tyo be able to update it if there
           are no linked pages.
         */
        IF iCurrentPage EQ 0 THEN
        DO:
            {get PageLayoutInfo cRequiredPages}.
            IF cRequiredPages EQ "":U THEN
                ASSIGN cAllRequiredPages = "?|":U.
            ELSE
                ASSIGN cAllRequiredPages = FILL('|?', NUM-ENTRIES(cRequiredPages, '|') + 1)
                       cAllRequiredPages = LEFT-TRIM(cAllRequiredPages, "|":U).
                
            {set RequiredPages cAllRequiredPages}.
        END.    /* page 0 */
        ELSE
            {get RequiredPages cAllRequiredPages}.
            
        DO iLoop = 1 TO NUM-ENTRIES(cInitialPageList):
            ASSIGN iResizeOnPage = INTEGER(ENTRY(iLoop, cInitialPageList))
                   cRequiredPages = {fnarg pageNRequiredPages iResizeOnPage}.
                
            IF cRequiredPages EQ "?":U THEN
            DO:
                /* Get the linked pages for the current page.
                 */
                RUN buildPageLinks IN TARGET-PROCEDURE (INPUT  iResizeOnPage,
                                                        OUTPUT cRequiredPages).
                    
                /* Update the stored list of linked pages.
                 */
                DYNAMIC-FUNCTION("addPageNRequiredPages":U IN TARGET-PROCEDURE, 
                                 INPUT iResizeOnPage, INPUT cRequiredPages).
                    
                /* Build a list of all required pages without repeating any. */
                DO iEntry = 1 TO NUM-ENTRIES(cRequiredPages):
                    IF NOT CAN-DO(cInitPages, ENTRY(iEntry, cRequiredPages)) THEN
                        ASSIGN cInitPages = cInitPages + ",":U + ENTRY(iEntry, cRequiredPages).
                END.    /* loop through linked pages. */
                    
                IF NOT CAN-DO(cInitPages, ENTRY(iLoop, cInitialPageList)) THEN
                    ASSIGN cInitPages = cInitPages + ",":U + ENTRY(iLoop, cInitialPageList).
            END.    /* don't have the linked pages for this page. */
        END.    /* loop through initial page list. */
        
        ASSIGN cInitPages = LEFT-TRIM(cInitPages, ",":U).
            
        /* Make pages init in numerical order. */
        ASSIGN lInitPage = NO
               iNumberOfPages = NUM-ENTRIES(cInitPages).
        IF iNumberOfPages GT 1 THEN
        do:           
            /* store the ordered list.
               we need to add 1 to the extent because page 0 may be
               in this list.
             */        
            DO iEntry = 1 TO iNumberOfPages:
                lInitPage[integer(entry(iEntry, cInitPages)) + 1] = YES.
            END.    /* loop through initPages */
                    
            /* rebuild the initpages list */
            cInitPages = ''.
            DO iEntry = 1 TO EXTENT(lInitPage) WHILE iNumberOfPages GT 0:
                IF lInitPage[iEntry] THEN
                    ASSIGN cInitPages = cInitPages + ',' + STRING(iEntry - 1)
                           iNumberOfPages = iNumberOfPages - 1.
            END.    /* loop through */
            cInitPages = LEFT-TRIM(cInitPages, ',').
        END.    /* more than on page being init'ed. */
                    
        /* Now make sure that we have all of these pages cached.
           The Repository API accepts the InstanceId as an object name;
           this makes for faster retrieval of the objects.
         */
        ASSIGN cObjectName = STRING(dInstanceId).
        RUN cacheRepositoryObject IN gshRepositoryManager ( INPUT cObjectName,
                                                            INPUT "PAGE:" + cInitPages,
                                                            INPUT ?,        /* pcRunattribute */
                                                            INPUT ?         /* pcResultCode   */ ) NO-ERROR.
        IF RETURN-VALUE NE "":U OR ERROR-STATUS:ERROR THEN
        DO:
            IF cContainerType EQ "Frame":U THEN
            DO:
                ASSIGN hContainingWindow = {fn getContainingWindow}.
                    
                /* Get the window handle of the container. */
                {get ContainerHandle hContainerHandle hContainingWindow}.
            END.    /* Frame container. */
            ELSE
                {get ContainerHandle hContainerHandle}.
                
            /* The window controls its self-destruction. This will cause all objects contained on
               it to be destroyed, too. Don't overwrite any forced exit statements already there.
             */
            IF VALID-HANDLE(hContainerHandle) THEN
                IF NOT hContainerHandle:PRIVATE-DATA BEGINS "ForcedExit":U OR hContainerHandle:PRIVATE-DATA = ? THEN
                    ASSIGN hContainerHandle:PRIVATE-DATA = "ForcedExit":U + CHR(3) 
                                                         + (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
            RETURN.
        END.    /* unable to get all relevant pages. */
            
        /* Make sure we have a proper value for the StartPage property,
           but only on page 0.
         */
        IF iCurrentPage EQ 0 THEN
            /* Don't set the startpage attribute. If we do, then the RUN SUPER() call will
               attempt to change pages to that page before we have complete the initialisation
               of all object on page 0.
             */
            ASSIGN iStartPage = {fn calculateStartPage}.
            
        /* Exit if invalid page */
        ghCachePage:FIND-FIRST(" WHERE ":U    
                               + ghCachePage:NAME + ".InstanceId = ":U + QUOTER(dInstanceId) + " AND ":U
                               + ghCachePage:NAME + ".PageNumber = ":U + QUOTER(iCurrentPage) ) NO-ERROR.
            
        IF iCurrentPage GT 0 AND NOT ghCachePage:AVAILABLE THEN
            RETURN.
        
        /* Set the frame sizes. Make it massive - the resizing will take care of 
           making it smaller. However, we need a very large canvas to paint on
           because we don't know at this stage exactly how big all of the bits
           are that will be painted on this frame.    
                 */
        ASSIGN hContainingWindow = {fn getContainingWindow}.
        IF VALID-HANDLE(hContainingWindow) THEN
            {get ContainerHandle hWindow hContainingWindow}.
            
        IF VALID-HANDLE(hDefaultFrame) AND hDefaultFrame:TYPE EQ "FRAME":U THEN
            ASSIGN hDefaultFrame:SCROLLABLE     = TRUE
                   hWindow:VIRTUAL-WIDTH        = SESSION:WIDTH-CHARS
                   hWindow:VIRTUAL-HEIGHT       = SESSION:HEIGHT-CHARS
                   hDefaultFrame:VIRTUAL-WIDTH  = SESSION:WIDTH-CHARS
                   hDefaultFrame:VIRTUAL-HEIGHT = SESSION:HEIGHT-CHARS
                   hDefaultFrame:WIDTH          = SESSION:WIDTH-CHARS
                   hDefaultFrame:HEIGHT         = SESSION:HEIGHT-CHARS
                   hDefaultFrame:SCROLLABLE     = FALSE
                   NO-ERROR.
 
         /* Build all objects on the current page.
         */
        IF NOT DYNAMIC-FUNCTION("buildAllObjects":U IN TARGET-PROCEDURE,
                                INPUT cObjectName, INPUT cInitPages      ) THEN
        /* the below is all error handling */
        DO:
            ASSIGN hContainingWindow = {fn getContainingWindow}.
                
            /* Get the window handle of the container .*/
            {get ContainerHandle hContainerHandle hContainingWindow}.
                
            /* The window controls its self-destruction. This will cause all
               objects contained on it to be destroyed, too.
             */
            IF VALID-HANDLE(hContainerHandle) THEN
                ASSIGN hContainerHandle:PRIVATE-DATA = "ForcedExit":U + CHR(3) + "Unable to create all the objects needed to run this container.":U.
            RETURN.
        END.    /* buildAllObjects failed */
            
        /* Add all the links for the current page's objects.
         */
        IF NOT {fnarg addAllLinks cInitPages} THEN
        /* the below is all error handling */
        DO:
            ASSIGN hContainingWindow = {fn getContainingWindow}.
                
            /* Get the window handle of the container .*/
            {get ContainerHandle hContainerHandle hContainingWindow}.
                
            /* The window controls its self-destruction. This will cause all
             * objects contained on it to be destroyed, too.                 */
            IF VALID-HANDLE(hContainerHandle) THEN
                ASSIGN hContainerHandle:PRIVATE-DATA = "ForcedExit":U + CHR(3) + "Unable to add all the links needed to run this container.":U.
            RETURN.
        END.    /* addAllLinks failed */
    END.    /* not a generated object */     

    /* Set up the ForeignFields for all SDOs that have been
       started already.                                     */
    &SCOPED-DEFINE xp-assign     
    {get DataTarget cDataTargets}
    {get SdoForeignFields cSdoForeignFields}.
    &UNDEFINE xp-assign
    
    IF cSdoForeignFields NE "":U THEN
    DO iEntry = 1 TO NUM-ENTRIES(cDataTargets):
        ASSIGN hDataTarget = WIDGET-HANDLE(ENTRY(iEntry,cDataTargets)).
        
        IF DYNAMIC-FUNCTION("getInternalEntryExists":U IN gshSessionManager, hDataTarget, "setForeignFields":U) THEN
            {fnarg setForeignFields cSdoForeignFields hDataTarget}.
    END.    /* there are SDO foreign fields */
            
    /* The call to run the SUPER has been moved to here. The reason is that the createObjects in
       containr.p does a select of the specified StartPage. When the call to the SUPER was at the
       top of the procedure, page 0 never had a chance to initialize, meaning that the container
       was broken. Let all the objects on page 0 initialize before the SUPER is called in. That
       way, objects on page zero will be initialized completely before running the select of the
       StartPage */
    RUN SUPER.

    IF NOT CAN-DO(TARGET-PROCEDURE:internal-entries, 'adm-assignObjectProperties') THEN
    do:
        /* Make sure that we get the current StartPage. If this is page 0,
           then set the property. We can do this since we are past the RUN
           SUPER, and we will need to StartPage.
           For non-zero pages, simply retrieve this value from the property. 
        */
        IF iCurrentPage EQ 0 THEN
            {set StartPage iStartPage}.
    END.    /* not a generated object */
    
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
    DEFINE VARIABLE iInstanceLoop             AS INTEGER      NO-UNDO.
    DEFINE VARIABLE cInstanceHandles          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cSuperProcedures          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cChildrenSuperProcedures  AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cContainerSuperProcedures AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hInstance                 AS HANDLE       NO-UNDO.
    
    /* Before running the super, the handles to the superprocedures needs 
       to be obtained as once the super is invoked the container is killed 
       and we can't get the supers to the container. Also the super's 
       can't be killed before container is killed as super's might override 
       the destroyObject of container.
       
       1. We first collect the super handles for the children and container 
          - We need two lists as there might be a dependency with children and 
          container supers. So first kill children supers and then container 
          super
       2. Kill the container by calling run super and 
       3. Kill supers for children
       4. Then finally kill contianer super.
    */

    /* First get any contained children supers. - The list separator should be CHR(3) as 
       KillPlips expects a CHR(3) list */
       
    {get ContainerTarget cInstanceHandles}.
    
    DO iInstanceLoop = 1 TO NUM-ENTRIES(cInstanceHandles):
        ASSIGN hInstance = WIDGET-HANDLE(ENTRY(iInstanceLoop, cInstanceHandles)) NO-ERROR.
        {get SuperProcedureHandle cSuperProcedures hInstance} NO-ERROR.
        IF cSuperProcedures NE ? OR cSuperProcedures NE "":U THEN
          ASSIGN cChildrenSuperProcedures = cChildrenSuperProcedures + ",":U + cSuperProcedures.
    END.    /* loop through cInstanceHandles */                        
    ASSIGN cChildrenSuperProcedures = LEFT-TRIM(cChildrenSuperProcedures, ",":U)
           cChildrenSuperProcedures = REPLACE(cChildrenSuperProcedures, ",":U, CHR(3)).

    /* Now get container supers - The list separator should be CHR(3) as 
       KillPlips expects a CHR(3) list  */
       
    {get SuperProcedureHandle cContainerSuperProcedures}.
    ASSIGN cContainerSuperProcedures = LEFT-TRIM(cContainerSuperProcedures, ",":U)
           cContainerSuperProcedures = REPLACE(cContainerSuperProcedures, ",", CHR(3)).

    /* now run the super */
    RUN SUPER.

    /* confirmExit could have cancelled the exit process */
    IF NOT (ERROR-STATUS:ERROR OR RETURN-VALUE = "ADM-ERROR":U) THEN
    DO:
      /* Use the API to kill the PLIP, since it was started by launch.i */
      RUN killPlips IN gshSessionManager ( INPUT "":U, INPUT cChildrenSuperProcedures ) NO-ERROR.

      /* Use the API to kill the PLIP, since it was started by launch.i */
      RUN killPlips IN gshSessionManager ( INPUT "":U, INPUT cContainerSuperProcedures ) NO-ERROR.
      
      /* Reset error - as the super had no errors that we care about and 
         we invoked the killPlips with no-error */
      ASSIGN ERROR-STATUS:ERROR = NO.
      RETURN.
    END.    /* no other errors */
    
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
    DEFINE VARIABLE iStartPage                  AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iHidePage                   AS integer              NO-UNDO.
    DEFINE VARIABLE cErrorMessage               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cButton                     AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hFolder                     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cContainerType              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInitialPageList            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cContainerMode              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE hContainerSource            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE lObjectInitted              AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE hContainerHandle            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cDisabledTabs               AS CHARACTER            NO-UNDO.
    
    /* Retrieve container mode set already, i.e. from where window was launched from
       and before initializeObject was run. If a mode is retrieved here, we will not
       overwrite it with the default mode from the object properties.
     */
    &SCOPED-DEFINE xp-assign
    {get CurrentPage iCurrentPageNumber}
    {get ObjectInitialized lObjectInitted}
    {get ContainerType cContainerType}
    {get ContainerMode cContainerMode}
    {get ContainerHandle hContainerHandle}.
    &UNDEFINE xp-assign

    /* Make sure that all the objects are created first. */
    IF NOT {fn getObjectsCreated} THEN
        RUN createObjects IN TARGET-PROCEDURE.

/*CreateObjects may set 'forcedExit', so we have to check it here*/
    IF VALID-HANDLE(hContainerHandle) AND hContainerHandle:PRIVATE-DATA BEGINS "ForcedExit":U THEN
       RETURN.

    /* ensure child frame realization in this window or this container's window */
    CURRENT-WINDOW = hContainerHandle:WINDOW NO-ERROR.  

    RUN SUPER.

    /*'forcedExit' is may be set in the super procedures stack, so we have to check it here*/
    IF VALID-HANDLE(hContainerHandle) AND hContainerHandle:PRIVATE-DATA BEGINS "ForcedExit":U THEN
       RETURN.
    
    IF NOT LOOKUP(cContainerType, "WINDOW,VIRTUAL":U) > 0 THEN
    DO:
        {get ContainerSource hContainerSource}.
        SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "setContainerModifyMode":U IN hContainerSource.
        SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "setContainerModifyView":U IN hContainerSource.
    END.    /* container is not a Window */
    
    /* Check if any enabled tabs and if not - exit the program */
    IF cContainerType NE "VIRTUAL":U THEN
      ASSIGN hFolder = WIDGET-HANDLE({fnarg linkHandles 'Page-Source'}).
    
    /*  At least one tab needs to be enabled for this window to run. */    
    IF VALID-HANDLE(hFolder) THEN
    do:
        {get TabEnabled cTabEnabled hFolder}.
        if {fn getTabsEnabled hFolder} EQ NO THEN
        DO:
            /* Hide all pages */
            DO iLoop = 1 TO NUM-ENTRIES(cTabEnabled,"|":U):
                RUN hidePage IN TARGET-PROCEDURE (iLoop).
            END.
            
            /* The window controls its self-destruction. This will cause all * objects contained on
                   it to be destroyed, too. Don't overwrite any forced exit statements already there      */
            IF VALID-HANDLE(hContainerHandle) THEN
                IF NOT hContainerHandle:PRIVATE-DATA BEGINS "ForcedExit":U OR hContainerHandle:PRIVATE-DATA = ? THEN
                    ASSIGN hContainerHandle:PRIVATE-DATA = "ForcedExit":U + CHR(3) + {aferrortxt.i 'RY' '11'}.
            
            ERROR-STATUS:error = NO.
            RETURN.
        END.    /* no tabs enabled */
        
        /* Determine the disabled pages */
        DO iLoop = 1 TO NUM-ENTRIES(cTabEnabled,"|":U):
            IF NOT LOGICAL(ENTRY(iLoop, cTabEnabled, '|':u)) THEN
                cDisabledTabs = cDisabledTabs + ',':u + STRING(iLoop).
        END.
        cDisabledTabs = LEFT-TRIM(cDisabledTabs, ',':u).
        
        /* Set the secured tabs in the container and folder object.
               this is convoluted, yes, but there's a variable in the folder
               object that is never set otherwise for dynamic containers and
               so cannot be relied upon. */
        {fnarg disablePagesInFolder "'security,' + cDisabledTabs"}.
    END.    /* no tabs enabled */
            
    &SCOPED-DEFINE xp-assign
    {get CurrentPage iCurrentPageNumber}
    {get StartPage iStartPage}.
    &UNDEFINE xp-assign
    
    /* Check if the first selected page has been disabled by security or some other reason.
       Only do this check on page 0, since after this we will no be able to select a disabled
       page. The only way we can select a disabled page is by the StartPage property when
       the container is first initialised, i.e on page 0.
     */
    IF VALID-HANDLE(hFolder) AND iCurrentPageNumber EQ 0 THEN
    DO:
        /* This is a list of logical values representing each page. */
        {get TabEnabled cTabEnabled hFolder}.
        
        /* If the start current tab is disabled, then move to the next available one. */
        IF cTabEnabled <> "":U AND cTabEnabled <> ? THEN
        DO:
            /* If the start page is not enabled, then look for the first one that is.
               We know that there is at least one tab enabled (else the check above would 
               have failed).
             */
            IF LOGICAL(ENTRY(iStartPage, cTabEnabled, "|":U)) EQ NO THEN
            DO:
                DO iLoop = iStartPage + 1 TO NUM-ENTRIES(cTabEnabled, "|":U):
                    IF LOGICAL(ENTRY(iLoop, cTabEnabled, "|":U)) EQ YES THEN
                        LEAVE.
                END.    /* loop through pages */
              
                IF iLoop > NUM-ENTRIES(cTabEnabled,"|":U) THEN
                DO iLoop = MAX(1, iStartPage - 1) TO 1 BY -1:
                    IF LOGICAL(ENTRY(iLoop, cTabEnabled, "|":U)) EQ YES THEN
                        LEAVE.
                END.    /* loop through pages */

                IF iLoop > 0 THEN 
                    iStartPage = iLoop.
          END.    /* start page not enabled */
        END.    /* the TabEnabled property has values. */
    END.    /* valid folder */
    
    /* Select the start page.
     */     
    IF iCurrentPageNumber EQ 0 AND iStartPage GT 0 THEN
    DO:
        /* If there are multiple entries in the InitialPageList property,
           all of those pages will have been initialised. We need to make
           sure that we hide all pages except for the StartPage.
           
           There will always be a value in the InitialPageList property that
           corresponds to at least one page.
           
           Also hide any required pages. These are not part of the InitialPageList
           property but will also have been constructed at this stage. This includes
           the pages required for the start page and for page zero.
         */
        {get InitialPageList cInitialPageList}.
        
        ASSIGN cInitialPageList = cInitialPageList + ",":U
                                + {fnarg pageNrequiredpages iStartPage} + ','
                                + {fnarg pageNRequiredPages 0}
               cInitialPageList = TRIM(cInitialPageList, ',').
        
        IF cInitialPageList NE "":U THEN
        DO iLoop = 1 TO NUM-ENTRIES(cInitialPageList):
            iHidePage = INTEGER(ENTRY(iLoop, cInitialPageList)) NO-ERROR.
            
            /* Don't waste time hiding the start page or page 0.
               Also skip any invalid entries.            
             */
            IF iHidePage EQ ? OR
               iHidePage EQ iStartPage OR
               iHidePage EQ 0 THEN
                NEXT.
            
            RUN hidePage IN TARGET-PROCEDURE (INPUT iHidePage).
        END.    /* loop through page list */
                
        /* Now select the start page. */
        RUN selectPage IN TARGET-PROCEDURE (INPUT iStartPage).
    END.    /* Select the start page. */
            
    /* Make sure that the mode of this container (add, copy etc) is
       correct for the current page.
     */
    {fnarg setContainerInitialMode cContainerMode}.
    
    RUN applyEntry IN TARGET-PROCEDURE(?).
    
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
    DEFINE VARIABLE lInitialized            AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE cContainerTargets       AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE lQuery                  AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE cNonQueryObjects        AS CHARACTER                NO-UNDO.
    
    {get ContainerTarget cContainerTargets}.

  /* If intitializing ensure that SDOs are initialized first. This is important 
     since dynamic SDOs create the TT during initialization and visual objects 
     traditionally assume that their datasource's rowobject is valid */ 
    
    IF NUM-ENTRIES(cContainerTargets) GT 0 THEN
    DO:
      DO iLoop = 1 TO NUM-ENTRIES(cContainerTargets):
          ASSIGN hHandle = WIDGET-HANDLE(ENTRY(iLoop, cContainerTargets)).
          IF VALID-HANDLE(hHandle) THEN
          DO:
              /* Do not initialize already initialized objects.               
                 dataobjects are for example initialized earlier if inside a 
                 DataContainer and even if  data.p has protection, this method 
                 is commonly overidden to for example populate temp-tables so we 
                 better don't call it twice
               */
              {get ObjectInitialized lInitialized hHandle}.
              {get QueryObject lQuery hHandle}.
              
              IF lQuery AND NOT lInitialized THEN
                  RUN initializeObject IN hHandle.
              ELSE IF NOT lInitialized THEN
                  ASSIGN cNonQueryObjects = cNonQueryObjects + ",":U + STRING(hHandle).
          END.    /* valid handle */
          
          /* There may be a forced exit. */
          IF NOT VALID-HANDLE(hHandle) THEN
              LEAVE.
      END.    /* loop through query object handles */

      ASSIGN cNonQueryObjects = TRIM(cNonQueryObjects,",":U).

      IF NUM-ENTRIES(cNonQueryObjects) > 0 THEN
      DO iLoop = 1 TO NUM-ENTRIES(cNonQueryObjects):
          ASSIGN hHandle = WIDGET-HANDLE(ENTRY(iLoop, cNonQueryObjects)).
          IF VALID-HANDLE(hHandle) THEN
            RUN initializeObject IN hHandle.
      END.    /* loop through non query object handles */

    END.  /* NUM-ENTRIES(cContainerTargets) GT 0 */
    
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
        ASSIGN hContainerSource = {fn getContainingWindow}.
        {get CurrentPage piPage hContainerSource}.
        RUN packWindow IN hContainerSource (INPUT piPage, INPUT plResize).
        IF piPage NE 0 THEN
            RUN packWindow IN hContainerSource (INPUT 0, INPUT plResize).
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
       there is no resizeObject for the viewer. In this case, simply ignore 
       any errors.
         */       
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
    DEFINE VARIABLE hWindow             AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hDefaultFrame       AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hContainerWindow    AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE lObjectInitted      AS LOGICAL                      NO-UNDO.
    
    &SCOPED-DEFINE xp-assign
    {get ObjectInitialized lObjectInitted}
    {get Page0LayoutManager cLayoutCode}
    {get ContainerType cContainerType}
    {get ContainerHandle hWindow}.
    &UNDEFINE xp-assign
    
    /* Don't resize until this window until it has completely initialised.
     */
    IF NOT lObjectInitted THEN
        RETURN.
    
    /* Get the handle of the window object. */
    ASSIGN hContainerWindow = {fn getContainingWindow}.
    
    IF cContainerType EQ "Window":U THEN
        {get WindowFrameHandle hDefaultFrame}.
    ELSE
        ASSIGN hDefaultFrame = hWindow.
    
    IF VALID-HANDLE(hContainerWindow) THEN
        PUBLISH "windowToBeSized":U FROM hContainerWindow.
    
    IF NOT VALID-HANDLE(ghLayoutManager) THEN
        ASSIGN ghLayoutManager = {fn getLayoutManagerHandle}.
    
    /* Lock the window on resize to stop flashing */
    {fnarg lockContainingWindow TRUE hContainerWindow}.
    
    IF VALID-HANDLE(ghLayoutManager) THEN
        RUN resizeWindowFromSuper IN ghLayoutManager ( INPUT cLayoutCode,
                                                       INPUT hWindow,       /* This could also be a frame widget. */
                                                       INPUT hDefaultFrame,
                                                       INPUT 0,     /* pdInstanceId: not req'd */
                                                       INPUT ?,     /* ghCacheObject */
                                                       INPUT ?,     /* ghCachePage */
                                                       INPUT hContainerWindow        ).
    
    {fnarg lockContainingWindow FALSE hContainerWindow}.
    
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
    
    ASSIGN lLockWindow      = YES
           hContainerWindow = {fn getContainingWindow}
           /* Double check that we have a window handle. */
           lLockWindow      = VALID-HANDLE(hContainerWindow).
    
    /* This second check is in case the containing window could not be found. */
    IF lLockWindow THEN
        /* Now lock the window */
        {fnarg lockContainingWindow TRUE hContainerWindow}.

    RUN SUPER ( INPUT piPageNum ).
    
    IF lLockWindow THEN
        {fnarg lockContainingWindow FALSE hContainerWindow}.
    
    /* Check for errors caused by the instantiation of the page.
     */    
    {get ContainerHandle hContainerHandle hContainerWindow}.

    IF LENGTH(hContainerHandle:PRIVATE-DATA)         GT 0              AND
       ENTRY(1,hContainerHandle:PRIVATE-DATA,CHR(3)) EQ "ForcedExit":U THEN
    DO:
        IF NUM-ENTRIES(hContainerHandle:PRIVATE-DATA,CHR(3)) >= 2 THEN
            ASSIGN cErrorMessage                 = ENTRY(2, hContainerHandle:PRIVATE-DATA, CHR(3))
                   hContainerHandle:PRIVATE-DATA = hContainerHandle:PRIVATE-DATA + CHR(3) + "MessageShown-YES":U.
        ELSE 
            ASSIGN cErrorMessage = "Program aborted due to unknown reason.":U.

        RUN showMessages IN gshSessionManager ( INPUT  cErrorMessage,
                                                INPUT  "ERR":U,                  /* error type */
                                                INPUT  "&OK":U,                  /* button list */
                                                INPUT  "&OK":U,                  /* default button */ 
                                                INPUT  "&OK":U,                  /* cancel button */
                                                INPUT  "Error on initialization of page ":U + STRING(piPageNum),
                                                INPUT  YES,                      /* display if empty */ 
                                                INPUT  TARGET-PROCEDURE,         /* container handle */ 
                                                OUTPUT cButton                          ).

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
    DEFINE VARIABLE cToolbarHandles             AS CHARACTER            NO-UNDO.
    
    {get ContainerToolbarSource cToolbarHandles}.

    IF NUM-ENTRIES(cToolbarHandles) > 0 THEN
    DO iLoop = 1 TO NUM-ENTRIES(cToolbarHandles):
        ASSIGN hHandle = WIDGET-HANDLE(ENTRY(iLoop, cToolbarHandles)).
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
    DEFINE VARIABLE cToolbarHandles            AS CHARACTER                NO-UNDO.

    {get ContainerToolbarSource cToolbarHandles}.

    IF NUM-ENTRIES(cToolbarHandles) > 0 THEN
    DO iLoop = 1 TO NUM-ENTRIES(cToolbarHandles):
        ASSIGN hHandle = WIDGET-HANDLE(ENTRY(iLoop, cToolbarHandles)).
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
    ( INPUT pcPageList    AS CHARACTER   ) :
/*------------------------------------------------------------------------------
  Purpose:  Adds links for the relevant objects.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hSourceObject               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hTargetObject               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE dInstanceId                 AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE iCurrentPage                AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.    
    DEFINE VARIABLE cInstanceName               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInstanceNames              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInstanceHandles            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cPageLinks                  AS CHARACTER            NO-UNDO.
    
    IF NOT VALID-HANDLE(ghCacheObject) THEN
        RUN returnCacheBuffers IN gshRepositoryManager ( OUTPUT ghCacheObject,
                                                         OUTPUT ghCachePage,
                                                         OUTPUT ghCacheLink     ).
    
    /* Ain't gonna do nuttin' without the cache records. */
    IF NOT VALID-HANDLE(ghCacheObject) THEN
        RETURN FALSE.
    
    &SCOPED-DEFINE xp-assign
    {get CurrentPage iCurrentPage}
    {get InstanceID dInstanceId}
    {get InstanceNames cInstanceNames}
    {get ContainerTarget cInstanceHandles}.
    &UNDEFINE xp-assign
    
    IF NOT VALID-HANDLE(ghQuery1) THEN
        CREATE QUERY ghQuery1.
    
    /* The data retrieval request was made in createObjects(). There is no need to 
       repeat that call here.
     */
    ghQuery1:SET-BUFFERS(ghCacheLink).
    
    /* Make sure that the current page is in the list of pages to link.
     */
    IF NOT CAN-DO(pcPageList, STRING(iCurrentPage)) THEN
        ASSIGN pcPageList = STRING(iCurrentPage) + ",":U + pcPageList
               pcPageList = TRIM(pcPageList, ",":U).
    
    DO iLoop = 1 TO NUM-ENTRIES(pcPageList):                
      ASSIGN iCurrentPage = INTEGER(ENTRY(iLoop, pcPageList)).
      
      ghQuery1:QUERY-PREPARE(" FOR EACH " + ghCacheLink:NAME + " WHERE ":U
                             + ghCacheLink:NAME + ".InstanceId = ":U + QUOTER(dInstanceId) + " AND ":U
                             + " ( " + ghCacheLink:NAME + ".SourcePage = ":U + QUOTER(iCurrentPage) + " OR ":U
                             +         ghCacheLink:NAME + ".TargetPage = ":U + QUOTER(iCurrentPage) + " ) ":U ).
      ghQuery1:QUERY-OPEN().
      
      ghQuery1:GET-FIRST().
      DO WHILE ghCacheLink:AVAILABLE:
        ASSIGN hSourceObject = ?
               hTargetObject = ?.
        /* A link across pages will be encountered twice, so we add it 
           to cPageLinks below and check it here to avoid adding it twice
           (This protection is needed when more than one page is passed in
            to this function. When the two pages are not created simultaneously 
            the link will be created with the last page and there's no 
            risk of conflict.. as long as this only is called once for each 
            page) */
        IF ghCacheLink::SourcePage = ghCacheLink::TargetPage
        OR LOOKUP(STRING(ghCacheLink:ROWID),cPageLinks) = 0 THEN
        DO:
          /* Source */
          cInstanceName = ghCacheLink::SourceInstanceName.
          IF cInstanceName EQ "THIS-OBJECT":U THEN
            hSourceObject = TARGET-PROCEDURE.
          ELSE
            hSourceObject = WIDGET-HANDLE(ENTRY(LOOKUP(cInstanceName,cInstanceNames), cInstanceHandles)) NO-ERROR.
          
          /* Target */
          cInstanceName = ghCacheLink::TargetInstanceName.
          IF cInstanceName EQ "THIS-OBJECT":U THEN
            hTargetObject = TARGET-PROCEDURE.
          ELSE
            hTargetObject = WIDGET-HANDLE(ENTRY(LOOKUP(cInstanceName,cInstanceNames),cInstanceHandles)) NO-ERROR.
          
          IF VALID-HANDLE(hSourceObject) AND VALID-HANDLE(hTargetObject) 
          AND hSourceObject NE hTargetObject THEN
          DO:
            RUN addLink IN TARGET-PROCEDURE ( hSourceObject, 
                                              ghCacheLink::LinkName, 
                                              hTargetObject ).
            /* store rowid for cross page links to ensure that we don't try again */
            IF ghCacheLink::SourcePage <> ghCacheLink::TargetPage THEN
              cPageLinks = cPageLinks + ",":U + STRING(ghCacheLink:ROWID).  
          END.    /* we should try to create the link. */
        END. /* same page link or page link not already added */
        ghQuery1:GET-NEXT().
      END.    /* available link */
      ghQuery1:QUERY-CLOSE().
    END.    /* Page loop */
    
    RETURN TRUE.
END FUNCTION.   /* addAllLinks */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildAllObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildAllObjects Procedure 
FUNCTION buildAllObjects RETURNS LOGICAL
    ( INPUT pcContainerName       AS CHARACTER,
      INPUT pcPageList            AS CHARACTER  ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Builds all objects on this window using constructObject.
    Notes:  * Returning FALSE from the function results in the container's creation
              being aborted, as well as that of the containing window.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hObjectProcedure        AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE dContainerInstanceId    AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE hSuper                  AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hDefaultFrame           AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hClassBuffer            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE iSuperCnt               AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iPageLoop               AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iCurrentPage            AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iInstanceLoop           AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iPageNumber             AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cContainerType          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cAttributeValue         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cPhysicalFile           AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cSuperHandles           AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cSuperProcedureMode     AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cInstanceNames          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cPropertynames          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cPropertyValues         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE lAttributeValue         AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE lQueryObject            AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE cLogicalName            AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cThinRenderingProcedure AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cClassName              AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cSuperProcedure         AS CHARACTER                NO-UNDO.
    
    &SCOPED-DEFINE xp-assign
    {get CurrentPage iCurrentPage}
    {get InstanceID dContainerInstanceId}
    {get ContainerType cContainerType}.
    &UNDEFINE xp-assign
    
    IF cContainerType EQ "Window":U THEN
        {get WindowFrameHandle hDefaultFrame}.
    ELSE
        {get ContainerHandle hDefaultFrame}.

    /* The data retrieval requestwas made in createObjects(). There is no need to 
       repeat that call here.
     */
    DO iPageLoop = 1 TO NUM-ENTRIES(pcPageList):
        ASSIGN iPageNumber = INTEGER(ENTRY(iPageLoop, pcPageList)).
        
        /* Don't build the objects on a page more than once. We need
           protection here in addition to that in createObjects() because it 
           is possible that an already-created page is linked with a Data or GroupAssign
           link to the requested page, and so will be passed in as a parameter.
         */
        IF DYNAMIC-FUNCTION("PageNTargets":U IN TARGET-PROCEDURE, TARGET-PROCEDURE, iPageNumber) NE "":U THEN
            NEXT.
        
        /* Get an ordered list of instances on this page. 
         */
        RUN getContainedInstanceNames IN gshRepositoryManager ( INPUT STRING(dContainerInstanceId)
                                                                      + "::":U + STRING(iPageNumber),
                                                                OUTPUT cInstanceNames        ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
            RETURN FALSE.
            
        /* Set the value of the CurrentPage property so that the objects
           are created on the correct pages.
         */
        {set CurrentPage iPageNumber}.
        
        /* Loop through the objects and create them.
         */
        DO iInstanceLoop = 1 TO NUM-ENTRIES(cInstanceNames)
           /* This in case something goes wrong with the constructObject call. */
           ON STOP UNDO, RETURN FALSE:
            ASSIGN cPhysicalFile           = "":U
                   cThinRenderingProcedure = "":U
                   cLogicalName            = "?":U
                   cSuperHandles           = "":U
                   cSuperProcedureMode     = "":U
                   
                   cPropertyNames = "SuperProcedure,SuperProcedureMode,ClassName,ThinRenderingProcedure,":U
                                  + "RenderingProcedure,PhysicalObjectName,InstanceId,LogicalObjectName,DbAware":U.
            
            RUN getInstanceProperties IN gshRepositoryManager ( INPUT        STRING(dContainerInstanceId),
                                                                INPUT        ENTRY(iInstanceLoop, cInstanceNames),
                                                                INPUT-OUTPUT cPropertyNames,
                                                                      OUTPUT cPropertyValues  ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN 
                RETURN FALSE.
            
            IF glUseThinRendering THEN
                ASSIGN cThinRenderingProcedure = ENTRY(LOOKUP("ThinRenderingProcedure":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
            
            /* If thin redering is not being used or it is being used and a thin rendering procedure
               has not been set then rendering procedure should be used.
             */
            IF cThinRenderingProcedure EQ "":U OR cThinRenderingProcedure EQ ? THEN
                ASSIGN cPhysicalFile = ENTRY(LOOKUP("RenderingProcedure":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
            ELSE
                ASSIGN cPhysicalFile = cThinRenderingProcedure.
            
            IF cPhysicalFile EQ "":U OR cPhysicalFile EQ ? THEN
                ASSIGN cPhysicalFile = ENTRY(LOOKUP("PhysicalObjectName":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
            
            /* If the physical object name cannot be found, then don't even bother going any further. 
               If an error is raised here, then the window will shut down gracefully ith an error message.
             */
            IF cPhysicalFile EQ "":U OR cPhysicalFile EQ ? THEN                        
                RETURN FALSE.
            
            /* Create the object.
               We set the current logical name to the InstanceID of the instance we are creating,
               so that the correct instance can be retrieved.
               
               Use the cLogicalName variable as a scratch variable in this case.
             */
            cLogicalName = ENTRY(LOOKUP("InstanceId":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
            {set CurrentLogicalName cLogicalName}.
            cLogicalName = '?'.
            
            /* Get the LogicalObjectName attribute. It's used by 'constructObject
               to search for SDOs that are kept alive.
             */
            ASSIGN cLogicalName = ENTRY(LOOKUP("LogicalObjectName":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
            
            /* Get the DBAware attribute. */
            ASSIGN lAttributeValue = LOGICAL(ENTRY(LOOKUP("DbAware":U, cPropertyNames), cPropertyValues, {&Value-Delimiter})) NO-ERROR.
            IF lAttributeValue EQ TRUE THEN
                ASSIGN cPhysicalFile = cPhysicalFile + CHR(3) + "DBAWARE":U.
        
            /* We do not pass any attributes, prepareInstance will apply all attributes from the cache */
            RUN constructObject IN TARGET-PROCEDURE ( INPUT  cPhysicalFile,
                                                      INPUT  hDefaultFrame,
                                                      INPUT  "LogicalObjectName":U + CHR(4) + cLogicalName,
                                                      OUTPUT hObjectProcedure ) NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
                RETURN FALSE.

            /*There is a core behavior, in which HEIGH-CHARS realizes combo-box, editor and selection-list widgets. Because that attribute is
              used in createObjects for the dynView, and because the widget-id cannot be set after the widget is realized, we have
              to set the field widget-ids before createObject is executed, and assign widget-ids in create objects befor HEIGH-CHARS is used.*/
            IF DYNAMIC-FUNCTION("getUseWidgetID":U IN TARGET-PROCEDURE) AND
               DYNAMIC-FUNCTION('instanceOf' IN hObjectProcedure, INPUT "DynView") THEN
                    RUN assignWidgetIDs IN hObjectProcedure (INPUT DYNAMIC-FUNCTION('pageNTargets':U IN hObjectProcedure, INPUT hObjectProcedure, INPUT 0), 0).


            /* Something may have gone wrong and the handle may be invalid. */
            IF NOT VALID-HANDLE(hObjectProcedure) THEN
                RETURN FALSE.
            
            /* Clear the callback variable. */
            {set CurrentLogicalName ''}.
            
            /* Get the super procedure information.
             */
            ASSIGN cAttributeValue = ENTRY(LOOKUP("SuperProcedure":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
            IF cAttributeValue NE "":U AND cAttributeValue NE ? THEN
            DO:
                /* Make sure that we don't add the class supers more than once. */
                ASSIGN cClassName = ENTRY(LOOKUP("ClassName":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
                ASSIGN hClassBuffer = {fnarg getCacheClassBuffer cClassName gshRepositoryManager}.
                
                /* Don't start the class supers again. */
                IF LOOKUP(cAttributeValue, hClassBuffer:BUFFER-FIELD("SuperProcedures"):BUFFER-VALUE) EQ 0 THEN
                DO:
                    /* If the mode is not STATELESS then we launch a new super every time.
                       Otherwise we use any running instances.
                     */
                    ASSIGN cSuperProcedureMode = ENTRY(LOOKUP("SuperProcedureMode":U, cPropertyNames), cPropertyValues, {&Value-Delimiter}) NO-ERROR.
                    
                    /* Default to STATEFUL mode because that is historically our default. */
                    IF cSuperProcedureMode EQ ? OR cSuperProcedureMode EQ "":U THEN
                        ASSIGN cSuperProcedureMode = "STATEFUL":U.
                    
                    /* Supers are added as SEARCH-TARGET; we add them backwards. */                            
                    DO iSuperCnt = NUM-ENTRIES(cAttributeValue) TO 1 BY -1:
                        ASSIGN cSuperProcedure = ENTRY(iSuperCnt, cAttributeValue) NO-ERROR.
                        
                        /* Weed out the obviously bad apples. */
                        IF cSuperProcedure EQ "":U  OR
                           cSuperProcedure EQ ?     OR
                           cSuperProcedure EQ "?":U THEN
                            NEXT.
                        
                        /* Start the procedure. */
                        {launch.i
                            &PLIP        = cSuperProcedure
                            &OnApp       = 'NO'
                            &Iproc       = ''
                            &NewInstance = "(cSuperProcedureMode NE 'STATELESS')"
                        }
                        IF VALID-HANDLE(hPlip) THEN
                        DO:
                            DYNAMIC-FUNCTION("addAsSuperProcedure":U IN gshSessionManager,
                                             INPUT hPlip, INPUT hObjectProcedure).
                            
                            /* Only store the handles if this is run not run in STATELESS mode. */
                            IF cSuperProcedureMode NE "STATELESS":U THEN
                                ASSIGN cSuperHandles = cSuperHandles + ",":U + STRING(hPlip).
                        END.    /* the super procedure launched successfully. */
                        ELSE
                            RETURN FALSE.
                    END.    /* loop through super procedures */

                    /* Store the list of super procedures in context. */
                    ASSIGN cSuperHandles = LEFT-TRIM(cSuperHandles, ",":U).
                    {set SuperProcedureHandle cSuperHandles hObjectProcedure}.
                 END.    /* these are not class supers. */
            END.    /* There is a SuperProcedure */
        END.    /* loop through instances on this page. */

        /*DynSBO inherits from SBO, which also inherits from visual, therefore this procedure is executed
          for SBOs or DynSBOs. DynSBOs are in fact, not visual objects from the GUI perspective, so we don;t
          assign widget-ids for SBOs. We have to avoid calling assignWidgetIDs for SBOs.*/
        IF DYNAMIC-FUNCTION("getUseWidgetID":U IN TARGET-PROCEDURE) AND
           NOT DYNAMIC-FUNCTION('instanceOF' IN TARGET-PROCEDURE, INPUT 'SBO':U )THEN
        RUN assignWidgetIDs IN TARGET-PROCEDURE (INPUT DYNAMIC-FUNCTION('pageNTargets':U IN TARGET-PROCEDURE, INPUT TARGET-PROCEDURE, INPUT iPageNumber), iPageNumber).

    END.    /* loop through pages requested */

    /* Set the CurrentPage to the 'proper' current page.*/
    {set CurrentPage iCurrentPage}.

    RETURN TRUE.
END FUNCTION.   /* buildAllObjects */

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
              empty for just the start page and page 0, which is the default.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cInitialPageList            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cPageLayoutInfo             AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.
    DEFINE VARIABLE iStartPage                  AS INTEGER              NO-UNDO.
    
    {get InitialPageList cInitialPageList}.
    
    /* Make sure that we at least have a blank value, rather than a null. */
    IF cInitialPageList EQ ? THEN
        ASSIGN cInitialPageList = "":U.
    
    /* Deal with all pages option */
    CASE cInitialPageList:
        WHEN "*":U THEN
        DO:
            /* The PageLayoutInfo property tells us how many pages there are.
               There is no property in the ADM that indicates how many pages there are
               so this is derived from the PageLayoutInfo property. This property
               contains a pipe-delimited list of layout codes.
             */
            {get PageLayoutInfo cPageLayoutInfo}.            
            ASSIGN cInitialPageList = "":U.
            DO iLoop = 1 TO NUM-ENTRIES(cPageLayoutInfo, "|":U):
                ASSIGN cInitialPageList = cInitialPageList + ",":U + STRING(iLoop).
            END.    /* loop through folder labels */
            ASSIGN cInitialPageList = LEFT-TRIM(cInitialPageList, ",":U).
        END.    /* * */
        WHEN "":U THEN
            /* Don't duplicate page zero */
            ASSIGN iStartPage       = {fn calculateStartPage}
                   cInitialPageList = "0":U + IF iStartPage EQ 0 THEN "":U ELSE (",":U + STRING(iStartPage)).
    END CASE.    /* initial page list from property */
    
    /* Set the new initial page list. */
    {set InitialPageList cInitialPageList}.
    
    RETURN cInitialPageList.
END FUNCTION.   /* buildInitialPageList */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calculateStartPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION calculateStartPage Procedure 
FUNCTION calculateStartPage RETURNS INTEGER
        ( ):
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Determines the value of the start page.
    Notes:  * This function should only be called on page 0, from createObjects().
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iStartPage             AS INTEGER                    NO-UNDO.
    DEFINE VARIABLE iEntry                 AS INTEGER                    NO-UNDO.
    DEFINE VARIABLE dInstanceId            AS DECIMAL                    NO-UNDO.
    DEFINE VARIABLE cInitialPageList       AS CHARACTER                  NO-UNDO.
    
    IF NOT VALID-HANDLE(ghCacheObject) THEN
        RUN returnCacheBuffers IN gshRepositoryManager ( OUTPUT ghCacheObject,
                                                         OUTPUT ghCachePage,
                                                         OUTPUT ghCacheLink     ) NO-ERROR.
    
    /* If we are on page 0, and a start page other than page 0 has been specified, ensure 
       it is a valid page. If not, set the StartPage to page 0.
       Also make sure that if there is an initial page list, that the StartPage 
       is part of that list.
     */
    &SCOPED-DEFINE xp-assign
    {get StartPage iStartPage}
    {get InitialPageList cInitialPageList}
    {get InstanceId dInstanceId}.
    &UNDEFINE xp-assign
    
    /* Make sure that we are working with a valid value. */
    IF iStartPage EQ ? OR iStartPage LT 0 THEN
        ASSIGN iStartPage = 0.
    
    /* If there is an initial page list set, we must be sure that the
       start page is in that initial list. If not, we set the start page to 
       the first available page in the that list.
     */
    IF cInitialPageList NE "":U THEN
    DO:
        /* Only check if the StartPage has a value */
        IF iStartPage NE 0 AND CAN-DO(cInitialPageList, STRING(iStartPage)) THEN
        DO:
            ghCachePage:FIND-FIRST(" WHERE ":U
                                    + ghCachePage:NAME + ".InstanceId = ":U + QUOTER(dInstanceId) + " AND ":U
                                    + ghCachePage:NAME + ".PageNumber = ":U + QUOTER(iStartPage) ) NO-ERROR.
            
            /* If the record is not available here, it means that there is something
               wrong with the StartPage property. We now need to find a page that is
               in the InitialPageList property.
             */
            IF NOT ghCachePage:AVAILABLE THEN
            DO:
                INITIAL-PAGE-LOOP:
                DO iEntry = 1 TO NUM-ENTRIES(cInitialPageList):
                    ASSIGN iStartPage = INTEGER(ENTRY(iEntry, cInitialPageList)) NO-ERROR.
                    ghCachePage:FIND-FIRST(" WHERE ":U
                                           + ghCachePage:NAME + ".InstanceId = ":U + QUOTER(dInstanceId) + " AND ":U
                                           + ghCachePage:NAME + ".PageNumber = ":U + QUOTER(iStartPage) ) NO-ERROR.
                    
                    /* There is a valid page, so get out of here now. */
                    IF ghCachePage:AVAILABLE THEN
                        LEAVE INITIAL-PAGE-LOOP.
                END.    /* INITIAL-PAGE-LOOP: loop through initial entries */
            END.    /* not page record available */
        END.    /* there is a start page */
    END.    /* There is an InitialPageList property set. */
    ELSE
        ghCachePage:FIND-FIRST(" WHERE ":U
                               + ghCachePage:NAME + ".InstanceId = ":U + QUOTER(dInstanceId) + " AND ":U
                               + ghCachePage:NAME + ".PageNumber = ":U + QUOTER(iStartPage) ) NO-ERROR.
        
    /* If there still is no record available, then we start at the first available page.
       At this stage we just need to make sure that we start with any page. If there are no
       pages on the container though, then we start with page 0. This means that if iStartPage 
       is zero, we also perform this check, otherwise we may attempt to start with page zero,
       which may cause errors.
     */
    IF NOT ghCachePage:AVAILABLE OR iStartPage EQ 0 THEN
        ghCachePage:FIND-FIRST(" WHERE ":U
                               + ghCachePage:NAME + ".InstanceId = ":U + QUOTER(dInstanceId) + " AND ":U
                               + ghCachePage:NAME + ".PageNumber > 0 ":U  ) NO-ERROR.
    
    IF ghCachePage:AVAILABLE THEN
        ASSIGN iStartPage = ghCachePage:BUFFER-FIELD("PageNumber":U):BUFFER-VALUE.
    ELSE
        ASSIGN iStartPage = 0.
    
    RETURN iStartPage.
END FUNCTION.    /* calculateStartPage */

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
            IF VALID-HANDLE(hCurrentContainer) THEN
              {get ContainerSource hContainerSource hCurrentContainer}.
        END.    /* loop up container stack */
        
        /* Double check that this is a container Window. */
        IF VALID-HANDLE(hContainerSource) THEN
        DO:
          {get ContainerType cContainerType hContainerSource}.
          IF cContainerType NE "Window":U THEN
              ASSIGN hContainerSource = ?.
        END.
        ELSE
          hContainerSource = ?.
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

&IF DEFINED(EXCLUDE-getRunTimeAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRunTimeAttribute Procedure 
FUNCTION getRunTimeAttribute RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Since the DynTree now launches a DynFrame any older code that called
            the 'getRunTimeAttribute' function would have done so by finding the
            container source which would have been the TreeView container, but now
            this would be the container. Adding these functions here and then
            checking to see of we can find the function in the frame's container.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hFrameContainer   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRunTimeAttribute AS CHARACTER  NO-UNDO.

  {get ContainerSource hFrameContainer}.

  IF VALID-HANDLE(hFrameContainer) THEN
    cRunTimeAttribute = DYNAMIC-FUNCTION("getRunTimeAttributeTree":U IN hFrameContainer) NO-ERROR.

  IF cRunTimeAttribute = ? THEN
    cRunTimeAttribute = "":U.

  ERROR-STATUS:ERROR = FALSE.

  RETURN cRunTimeAttribute.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarHandles Procedure 
FUNCTION getToolbarHandles RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:  Returns certain toolbar handles.
    Notes:  * This function should not be used; it is only included for backwards
              compatibility.   
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cToolbarHandles         AS CHARACTER            NO-UNDO.    
    
    {get ContainerToolbarSource cToolbarHandles}.

    RETURN cToolbarHandles.
END FUNCTION.   /* getToolbarHandles */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTreeRunAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTreeRunAttribute Procedure 
FUNCTION getTreeRunAttribute RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Since the DynTree now launches a DynFrame any older code that called
            the 'getTreeRunAttribute' function would have done so by finding the
            container source which would have been the TreeView container, but now
            this would be the container. Adding these functions here and then
            checking to see of we can find the function in the frame's container.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hFrameContainer   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTreeRunAttribute AS CHARACTER  NO-UNDO.

  {get ContainerSource hFrameContainer}.
  
  IF VALID-HANDLE(hFrameContainer) THEN
    cTreeRunAttribute = DYNAMIC-FUNCTION("getTreeRunAttributeTree":U IN hFrameContainer) NO-ERROR.

  IF cTreeRunAttribute = ? THEN
    cTreeRunAttribute = "":U.

  ERROR-STATUS:ERROR = FALSE.

  RETURN cTreeRunAttribute.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWindowName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWindowName Procedure 
FUNCTION getWindowName RETURNS CHARACTER ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Retrieves the title of the window/container  
    Notes:  Stored as property if the object is realized as a frame    
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cWindowName AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cClassName  AS CHARACTER  NO-UNDO.
    
    /* Look to see if this container is a window, and try to
       retrieve the title from the window. If not, then use
           the WindowName property from the ADMProps table.
     */
    cWindowName = SUPER().
    
    IF cWindowName EQ ? THEN
    do:
    {get ClassName cClassName}.      

    IF DYNAMIC-FUNCTION("ClassHasAttribute":U IN gshRepositoryManager,
                        INPUT cClassName, INPUT "WindowName":U, INPUT NO /* not an event */ ) THEN
            &SCOPED-DEFINE xpWindowName
            {get WindowName cWindowName}.
            &UNDEFINE xpWindowName
    END.    /* object realised as a frame */
        
      RETURN cWindowName.
END FUNCTION.   /* getWindowName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newHeight Procedure 
FUNCTION newHeight RETURNS LOGICAL
  ( pdHeight AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose: Override container   
    Notes: Do nothing. 
           - This is not supported when using a dynamic Layout Managed container
           - And would not have any effect even if it did increase the 
             frame/window, since this typically is called during 
             initialization and resizing/) 
           - Most likely also unnecessary when the layout manager is used.
             since the virtual sizes are set very large during initialize/resize.
           - We return ? as we do not really know if it is ok...      
------------------------------------------------------------------------------*/

  RETURN ?.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newWidth Procedure 
FUNCTION newWidth RETURNS CHARACTER
  ( pdWidth AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose: Override container   
    Notes: Do nothing. 
           - This is not supported when using a dynamic Layout Managed container
           - And would not have any effect even if it did increase the 
             frame/window, since this typically is called during 
             initialization and resizing/) 
           - Most likely also unnecessary when the layout manager is used.
             since the virtual sizes are set very large during initialize/resize.
           - We return ? as we do not really know if it is ok...      
------------------------------------------------------------------------------*/
  RETURN "".   /* Function return value. */

END FUNCTION.

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

&IF DEFINED(EXCLUDE-setContainerInitialMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainerInitialMode Procedure 
FUNCTION setContainerInitialMode RETURNS LOGICAL
    ( INPUT pcContainerMode        AS CHARACTER ):
/*------------------------------------------------------------------------------
  Purpose:  Sets the intial mode of the window to Add, Copy etc.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cContainerToolbars         AS CHARACTER              NO-UNDO.
    DEFINE VARIABLE iNumToolbars               AS INTEGER                NO-UNDO.
    DEFINE VARIABLE hToolbar                   AS HANDLE                 NO-UNDO.
    DEFINE VARIABLE hTableioTarget             AS HANDLE                 NO-UNDO.
    DEFINE VARIABLE hContainerToolbar          AS HANDLE                 NO-UNDO.
    DEFINE VARIABLE iPage                      AS INTEGER                NO-UNDO.
    
    {get ContainerToolbarSource cContainerToolbars}.
    
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
                    IF iPage GT 1 THEN
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
        CASE pcContainerMode:
            WHEN "Copy":U   THEN PUBLISH "copyRecord":U FROM hContainerToolbar.
            WHEN "Add":U    THEN PUBLISH "addRecord":U  FROM hContainerToolbar.
        END CASE.   /* container mode */

        /* If Container mode was add or copy, we reread it to see if it was a 
         * success. This will ensure correction of windowtitle by the view or 
         * modify mode below if necessary */
        IF pcContainerMode EQ 'Add':U OR pcContainerMode EQ 'Copy':U THEN  
            {get ContainerMode pcContainerMode}.
        
        CASE pcContainerMode:
            WHEN "View":U   THEN RUN setContainerViewMode IN TARGET-PROCEDURE.
            WHEN "Modify":U THEN RUN setContainerModifyMode IN TARGET-PROCEDURE.
        END. /* another case of container mode .. */
    END.    /* valid containber toolbar */
    
    RETURN TRUE.
END FUNCTION.    /* setContainerInitialMode */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentLogicalName Procedure 
FUNCTION setCurrentLogicalName RETURNS LOGICAL
    ( pcCurrentObjectName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: This function is called from the rendering before the calls are 
                   made to constructObject. This value is used by the prepareInstance
                   bootstrapping API.
    Notes: 
------------------------------------------------------------------------------*/
    gcCurrentObjectName = pcCurrentObjectName.
    
    RETURN TRUE.
END FUNCTION.    /* setCurrentLogicalName */

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
    DEFINE VARIABLE cClassName              AS CHARACTER                NO-UNDO.
    
    /* Try to set the window's title property. If that fails,
       then set the property in the ADMProps table. This is 
       possible when the current container is a DynFrame object,
       as when a container is used in a treeview.
     */
    IF NOT super(pcWindowName) THEN
    DO:
        {get ClassName cClassName}.
        IF DYNAMIC-FUNCTION("ClassHasAttribute":U IN gshRepositoryManager,
                            INPUT cClassName, INPUT "WindowName":U, INPUT NO /* not an event */ ) THEN
            /* Set the value in the ADMProps table */                                
            &SCOPED-DEFINE xpWindowName
            {set WindowName pcWindowName}.
            &UNDEFINE xpWindowName
    END.    /* not a window */
    
    RETURN TRUE.   
END FUNCTION.   /* setWindowName */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

