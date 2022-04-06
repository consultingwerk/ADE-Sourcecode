&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sObject _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*---------------------------------------------------------------------------------
  File: cacheclasv.w

  Description:  Class Cache Viewer

  Purpose:      Class Cache Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/29/2002  Author:     

  Update Notes: Created from Template rysttsimpv.w

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

&scop object-name       cacheclasv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{src/adm2/globals.i}

/* These defs needed to display page cache */

DEFINE VARIABLE ghPageBuffer AS HANDLE NO-UNDO.
DEFINE VARIABLE ghPageQuery  AS HANDLE NO-UNDO.
DEFINE VARIABLE ghPageBrowse AS HANDLE NO-UNDO.

DEFINE VARIABLE ghPageInstanceBuffer AS HANDLE NO-UNDO.
DEFINE VARIABLE ghPageInstanceQuery  AS HANDLE NO-UNDO.
DEFINE VARIABLE ghPageInstanceBrowse AS HANDLE NO-UNDO.

DEFINE VARIABLE ghInstanceSourceBuffer AS HANDLE NO-UNDO.
DEFINE VARIABLE ghInstanceTargetBuffer AS HANDLE NO-UNDO.
DEFINE VARIABLE ghLinkBuffer           AS HANDLE NO-UNDO.
DEFINE VARIABLE ghLinkQuery            AS HANDLE NO-UNDO.
DEFINE VARIABLE ghLinkBrowse           AS HANDLE NO-UNDO.

DEFINE VARIABLE ghUIEventBuffer AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghUIEventQuery  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghUIEventBrowse AS HANDLE     NO-UNDO.

/* These defs needed to display class cache */

DEFINE VARIABLE ghCacheQuery         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghCacheBrowse        AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghCacheBuffer        AS HANDLE     NO-UNDO.

DEFINE TEMP-TABLE ttAttribute NO-UNDO RCODE-INFORMATION 
    FIELD attributeName  AS CHARACTER FORMAT "x(100)" COLUMN-LABEL "Attribute"      LABEL "Attribute" 
    FIELD attributeValue AS CHARACTER FORMAT "x(200)" COLUMN-LABEL "Value"          LABEL "Value"
    INDEX index1 attributeName.

DEFINE TEMP-TABLE ttMasterAttribute NO-UNDO LIKE ttAttribute RCODE-INFORMATION.

DEFINE VARIABLE ghStoreBrowse  AS HANDLE     NO-UNDO.
DEFINE VARIABLE gdLastEtime    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gcSearchString AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tContainerName tLogicalObjectName 
&Scoped-Define DISPLAYED-OBJECTS tContainerName tLogicalObjectName 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHeight sObject 
FUNCTION getHeight RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWidth sObject 
FUNCTION getWidth RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE tContainerName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Container Name" 
     VIEW-AS FILL-IN 
     SIZE 55.4 BY 1 NO-UNDO.

DEFINE VARIABLE tLogicalObjectName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Logical Object Name" 
     VIEW-AS FILL-IN 
     SIZE 55.4 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     tContainerName AT ROW 1 COL 30 COLON-ALIGNED
     tLogicalObjectName AT ROW 2 COL 30 COLON-ALIGNED
     "Cached Pages" VIEW-AS TEXT
          SIZE 38.8 BY .62 AT ROW 3.29 COL 1.2
     "Cached Paged Instances" VIEW-AS TEXT
          SIZE 38.8 BY .62 AT ROW 10.29 COL 1
     "Cached Links" VIEW-AS TEXT
          SIZE 38.8 BY .62 AT ROW 17.29 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 23.62
         WIDTH              = 133.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

ASSIGN 
       tContainerName:READ-ONLY IN FRAME frMain        = TRUE.

ASSIGN 
       tLogicalObjectName:READ-ONLY IN FRAME frMain        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anyPrintableInBrowse sObject 
PROCEDURE anyPrintableInBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phBrowseHandle AS HANDLE     NO-UNDO.

DEFINE VARIABLE hQuery        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBuffer       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField        AS HANDLE     NO-UNDO.
DEFINE VARIABLE cFieldName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hColumn       AS HANDLE     NO-UNDO.
DEFINE VARIABLE rRowid        AS ROWID      NO-UNDO EXTENT 18.
DEFINE VARIABLE iCnt          AS INTEGER    NO-UNDO.
DEFINE VARIABLE hQueryBuffer  AS HANDLE     NO-UNDO.

/* If the user hasn't pressed anything for .7 secs, start a new search, else continue with the old one */

IF ghStoreBrowse = phBrowseHandle
AND ETIME < gdLastEtime + 1000 THEN
    ASSIGN gcSearchString = gcSearchString + KEYFUNC(LASTKEY).
ELSE
    ASSIGN gcSearchString = KEYFUNC(LASTKEY).

/* Go through the query, and find the first occurance matching the search string */

IF VALID-HANDLE(phBrowsehandle:CURRENT-COLUMN) THEN
    ASSIGN hColumn = phBrowsehandle:CURRENT-COLUMN.
ELSE
    ASSIGN hColumn = phBrowsehandle:FIRST-COLUMN.

ASSIGN hQuery     = phBrowseHandle:QUERY
       hBuffer    = hColumn:BUFFER-FIELD:BUFFER-HANDLE
       hField     = hColumn:BUFFER-FIELD.

IF  hBuffer:AVAILABLE
AND SUBSTRING(hField:BUFFER-VALUE,1,LENGTH(gcSearchString)) = gcSearchString THEN. /* don't do a thing */
ELSE DO:
    hQuery:GET-FIRST().
    
    do-blk:
    DO WHILE hBuffer:AVAILABLE:
        IF SUBSTRING(hField:BUFFER-VALUE,1,LENGTH(gcSearchString)) = gcSearchString THEN
            LEAVE do-blk.
        ELSE
            IF SUBSTRING(hField:BUFFER-VALUE,1,LENGTH(gcSearchString)) > gcSearchString THEN
                LEAVE do-blk.
    
        hQuery:GET-NEXT().
    END.
    
    IF NOT hBuffer:AVAILABLE THEN
        hQuery:GET-LAST().
END.

/* Reposition the browse to the correct row */

IF hBuffer:AVAILABLE 
THEN DO:
    ASSIGN rRowid = ?.

    do-blk:
    DO iCnt = 1 TO hQuery:NUM-BUFFERS:
        ASSIGN hQueryBuffer = hQuery:GET-BUFFER-HANDLE(iCnt)
               rRowid[iCnt] = hQueryBuffer:ROWID.

        IF hBuffer = hQueryBuffer THEN
            LEAVE do-blk.
    END.

    hQuery:REPOSITION-TO-ROWID(rRowid).
    APPLY "VALUE-CHANGED":U TO phBrowseHandle.
END.

ASSIGN ghStoreBrowse = phBrowseHandle
       gdLastEtime   = ETIME.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject sObject 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/  

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  IF NOT ERROR-STATUS:ERROR 
  THEN DO:
      DELETE OBJECT ghPageBrowse NO-ERROR.
      DELETE OBJECT ghPageInstanceBrowse NO-ERROR.
      DELETE OBJECT ghLinkBrowse NO-ERROR.
      DELETE OBJECT ghCacheBrowse NO-ERROR.

      DELETE OBJECT ghPageQuery NO-ERROR.
      DELETE OBJECT ghLinkQuery NO-ERROR.
      DELETE OBJECT ghCacheQuery NO-ERROR.
      DELETE OBJECT ghPageInstanceQuery NO-ERROR.

      DELETE OBJECT ghPageBuffer           NO-ERROR.
      DELETE OBJECT ghLinkBuffer           NO-ERROR.
      DELETE OBJECT ghInstanceSourceBuffer NO-ERROR.
      DELETE OBJECT ghInstanceTargetBuffer NO-ERROR.
      DELETE OBJECT ghPageInstanceBuffer   NO-ERROR.
      DELETE OBJECT ghCacheBuffer          NO-ERROR.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imAClassBrowser sObject 
PROCEDURE imAClassBrowser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phObjectBuffer AS HANDLE     NO-UNDO.

DEFINE VARIABLE hClassTable   AS HANDLE     NO-UNDO.
DEFINE VARIABLE iFieldCnt     AS INTEGER    NO-UNDO.
DEFINE VARIABLE hColumn       AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCnt          AS INTEGER    NO-UNDO.
DEFINE VARIABLE cColumnWidths AS CHARACTER  NO-UNDO INITIAL "45,200".

/*----------------------* 
 * Instance Class Cache *
 *----------------------*/

ghCacheQuery:QUERY-CLOSE() NO-ERROR.

DELETE OBJECT ghCacheBrowse NO-ERROR.
DELETE OBJECT ghCacheQuery NO-ERROR.
DELETE OBJECT ghCacheBuffer NO-ERROR.

ASSIGN ghCacheBrowse = ?
       ghCacheQuery = ?
       ghCacheBuffer = ?.

EMPTY TEMP-TABLE ttAttribute.

IF NOT VALID-HANDLE(phObjectBuffer) THEN
    RETURN.

IF NOT phObjectBuffer:AVAILABLE THEN
    RETURN.

ASSIGN hClassTable = phObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.
CREATE BUFFER ghCacheBuffer FOR TABLE hClassTable.

/* Copy the class cache table to our attribute table, for nice display */

CREATE QUERY ghCacheQuery.
ghCacheQuery:SET-BUFFERS(ghCacheBuffer).
ghCacheQuery:QUERY-PREPARE("FOR EACH ":U + ghCacheBuffer:NAME + 
                             " WHERE ":U + ghCacheBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(phObjectBuffer:BUFFER-FIELD("tRecordIdentifier"):BUFFER-VALUE)).
ghCacheQuery:QUERY-OPEN().

ghCacheQuery:GET-FIRST().
DO WHILE ghCacheBuffer:AVAILABLE:
    DO iFieldCnt = 1 TO ghCacheBuffer:NUM-FIELDS:
        CREATE ttAttribute.
        ASSIGN ttAttribute.attributeName  = ghCacheBuffer:BUFFER-FIELD(iFieldCnt):COLUMN-LABEL
               ttAttribute.attributeValue = ghCacheBuffer:BUFFER-FIELD(iFieldCnt):BUFFER-VALUE.
    END.
    ghCacheQuery:GET-NEXT().
END.

ghCacheQuery:QUERY-CLOSE.

/* Now create a query on our attribute table */

CREATE QUERY ghCacheQuery.
ghCacheQuery:SET-BUFFERS("ttAttribute":U).
ghCacheQuery:QUERY-PREPARE("FOR EACH ttAttribute BY ttAttribute.attributeName":U).
ghCacheQuery:QUERY-OPEN().

CREATE BROWSE ghCacheBrowse
    ASSIGN FRAME                  = FRAME {&FRAME-NAME}:HANDLE
           COLUMN                 = 1
           ROW                    = 3.2
           WIDTH                  = FRAME {&FRAME-NAME}:WIDTH - 1
           HEIGHT                 = FRAME {&FRAME-NAME}:HEIGHT - 3.2
           TOOLTIP                = "Instance Class Cache for selected object"
           MULTIPLE               = FALSE
           SEPARATORS             = TRUE
           ALLOW-COLUMN-SEARCHING = NO
           QUERY                  = ghCacheQuery
           ROW-MARKERS            = FALSE
           PRIVATE-DATA           = "FOR EACH ttAttribute BY ttAttribute.attributeName":U
    TRIGGERS:
        ON ANY-PRINTABLE PERSISTENT RUN anyPrintableInBrowse IN THIS-PROCEDURE (INPUT ghCacheBrowse).
        ON START-SEARCH  PERSISTENT RUN startSearch          IN THIS-PROCEDURE (INPUT ghCacheBrowse).
    END TRIGGERS.

ghCacheBrowse:ADD-LIKE-COLUMN("ttAttribute.attributeName":U).
ghCacheBrowse:ADD-LIKE-COLUMN("ttAttribute.attributeValue":U).
ghCacheBrowse:NUM-LOCKED-COLUMNS = 1.
ghCacheBrowse:SENSITIVE = YES.

ASSIGN hColumn = ghCacheBrowse:FIRST-COLUMN.

DO WHILE VALID-HANDLE(hColumn):
    ASSIGN iCnt              = iCnt + 1
           hColumn:RESIZABLE = YES
           hColumn:WIDTH     = INTEGER(ENTRY(iCnt,cColumnWidths))
           hColumn           = hColumn:NEXT-COLUMN.
END.

ghCacheQuery:REPOSITION-TO-ROW(1).

APPLY "value-changed":U TO ghCacheBrowse.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imAPageBrowser sObject 
PROCEDURE imAPageBrowser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phObjectBuffer AS HANDLE     NO-UNDO.

DEFINE VARIABLE hClassTable   AS HANDLE     NO-UNDO.
DEFINE VARIABLE iFieldCnt     AS INTEGER    NO-UNDO.
DEFINE VARIABLE hColumn       AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCnt          AS INTEGER    NO-UNDO.
DEFINE VARIABLE cColumnWidths AS CHARACTER  NO-UNDO INITIAL "14,69,20,20,35,35".
DEFINE VARIABLE cLinkColumnWidths AS CHARACTER  NO-UNDO INITIAL "50,30,50".

DEFINE VARIABLE hPageBuffer         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hPageInstanceBuffer AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLinkBuffer         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hFolder             AS HANDLE     NO-UNDO.

ghPageQuery:QUERY-CLOSE() NO-ERROR.
ghPageInstanceQuery:QUERY-CLOSE() NO-ERROR.
ghLinkQuery:QUERY-CLOSE() NO-ERROR.

DELETE OBJECT ghPageBrowse NO-ERROR.
DELETE OBJECT ghPageInstanceBrowse NO-ERROR.
DELETE OBJECT ghLinkBrowse NO-ERROR.

DELETE OBJECT ghPageQuery         NO-ERROR.
DELETE OBJECT ghPageInstanceQuery NO-ERROR.
DELETE OBJECT ghLinkQuery         NO-ERROR.

DELETE OBJECT ghPageBuffer NO-ERROR.
DELETE OBJECT ghPageInstanceBuffer NO-ERROR.
DELETE OBJECT ghlinkBuffer NO-ERROR.

ASSIGN ghPageBrowse         = ?
       ghPageInstanceBrowse = ?
       ghLinkBrowse         = ?
       ghPageQuery          = ?
       ghPageInstanceQuery  = ?
       ghLinkQuery          = ?
       ghPageBuffer         = ?
       ghPageInstanceBuffer = ?
       ghlinkBuffer         = ?.

IF NOT VALID-HANDLE(phObjectBuffer) THEN
    RETURN.

IF NOT phObjectBuffer:AVAILABLE THEN
    RETURN.

/*-------------------------*
 * Create the Page Browser *
 *-------------------------*/

{get pageSource hFolder ghContainer}.

ASSIGN hPageBuffer = DYNAMIC-FUNCTION("getCachePageBuffer":U IN gshRepositoryManager).

IF VALID-HANDLE(hPageBuffer) 
THEN then-blk: DO:
    CREATE BUFFER ghPageBuffer FOR TABLE hPageBuffer.
    CREATE QUERY ghPageQuery.

    ghPageQuery:SET-BUFFERS(ghPageBuffer).
    ghPageQuery:QUERY-PREPARE("FOR EACH ":U + ghPageBuffer:NAME + 
                                " WHERE ":U + ghPageBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(phObjectBuffer:BUFFER-FIELD("tRecordIdentifier"):BUFFER-VALUE) +
                                   " BY ":U + ghPageBuffer:NAME + ".tPageNumber":U
                             ).

    CREATE BROWSE ghPageBrowse
    ASSIGN FRAME        = FRAME {&FRAME-NAME}:HANDLE
           COLUMN       = 1
           ROW          = 4
           WIDTH        = FRAME {&FRAME-NAME}:WIDTH - 1
           HEIGHT       = 6
           TOOLTIP      = "Page Cache for selected object"
           MULTIPLE     = FALSE
           SEPARATORS   = TRUE
           QUERY        = ghPageQuery
           ROW-MARKERS  = FALSE
           PRIVATE-DATA = ghPageQuery:PREPARE-STRING
           TRIGGERS:
               ON ANY-PRINTABLE PERSISTENT RUN anyPrintableInBrowse IN THIS-PROCEDURE (INPUT ghPageBrowse).
               ON START-SEARCH  PERSISTENT RUN startSearch          IN THIS-PROCEDURE (INPUT ghPageBrowse).
               ON VALUE-CHANGED PERSISTENT RUN pageValueChange      IN THIS-PROCEDURE.
           END TRIGGERS.

    ghPageQuery:QUERY-OPEN().

    IF ghPageQuery:NUM-RESULTS <> 0 THEN
        RUN enableFolderPage IN hFolder (INPUT 3).
    ELSE DO:
        RUN disableFolderPage IN hFolder (INPUT 3).
        LEAVE then-blk.
    END.

    ghPageBrowse:ADD-LIKE-COLUMN(ghPageBuffer:BUFFER-FIELD("tPageNumber")).
    ghPageBrowse:ADD-LIKE-COLUMN(ghPageBuffer:BUFFER-FIELD("tPageLabel")).
    ghPageBrowse:ADD-LIKE-COLUMN(ghPageBuffer:BUFFER-FIELD("tLayoutCode")).
    ghPageBrowse:ADD-LIKE-COLUMN(ghPageBuffer:BUFFER-FIELD("tPageInitialized")).    
    ghPageBrowse:ADD-LIKE-COLUMN(ghPageBuffer:BUFFER-FIELD("tPageObj")).

    ASSIGN hColumn = ghPageBrowse:FIRST-COLUMN.

    DO WHILE VALID-HANDLE(hColumn):
        ASSIGN iCnt              = iCnt + 1
               hColumn:RESIZABLE = YES
               hColumn:WIDTH     = INTEGER(ENTRY(iCnt,cColumnWidths))
               hColumn           = hColumn:NEXT-COLUMN.
    END.
   
    ghPageBrowse:SENSITIVE = YES.
    ghPageQuery:REPOSITION-TO-ROW(1).
    APPLY "VALUE-CHANGED":U TO ghPageBrowse. /* This will create the page instance browser in procedure pageValueChange */

    /*--------------------------------------------------------------------------------*
     * The Page Instance Browser will be created on value-changed of the page browser *
     *--------------------------------------------------------------------------------*/

    /*-------------------------*
     * Create the Link Browser *
     *-------------------------*/

    ASSIGN hLinkBuffer = DYNAMIC-FUNCTION("getCacheLinkBuffer":U IN gshRepositoryManager).           

    IF  VALID-HANDLE(hLinkBuffer) 
    THEN DO:
        CREATE BUFFER ghLinkBuffer           FOR TABLE hLinkBuffer.
        CREATE BUFFER ghInstanceSourceBuffer FOR TABLE phObjectBuffer BUFFER-NAME "bInstanceSourceBuffer":U.
        CREATE BUFFER ghInstanceTargetBuffer FOR TABLE phObjectBuffer BUFFER-NAME "bInstanceTargetBuffer":U.

        CREATE QUERY ghLinkQuery.

        ghLinkQuery:SET-BUFFERS(ghLinkBuffer,ghInstanceSourceBuffer,ghInstanceTargetBuffer).
        ghLinkQuery:QUERY-PREPARE("FOR EACH ":U + ghLinkBuffer:NAME + 
                                    " WHERE ":U + ghLinkBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(phObjectBuffer:BUFFER-FIELD("tRecordIdentifier"):BUFFER-VALUE) + ",":U +
                                    "  EACH ":U + ghInstanceSourceBuffer:NAME + 
                                    " WHERE ":U + ghInstanceSourceBuffer:NAME + ".tObjectInstanceObj = " + ghLinkBuffer:NAME + ".tSourceObjectInstanceObj," +
                                    "  EACH ":U + ghInstanceTargetBuffer:NAME + 
                                    " WHERE ":U + ghInstanceTargetBuffer:NAME + ".tObjectInstanceObj = " + ghLinkBuffer:NAME + ".tTargetObjectInstanceObj" + 
                                       " BY ":U + ghInstanceSourceBuffer:NAME + ".tObjectInstanceName":U
                                 ).

        CREATE BROWSE ghLinkBrowse
        ASSIGN FRAME        = FRAME {&FRAME-NAME}:HANDLE
               COLUMN       = 1
               ROW          = 18
               WIDTH        = FRAME {&FRAME-NAME}:WIDTH - 1
               HEIGHT       = 6
               TOOLTIP      = "Link Cache for selected object"
               MULTIPLE     = FALSE
               SEPARATORS   = TRUE
               QUERY        = ghLinkQuery
               ROW-MARKERS  = FALSE
               PRIVATE-DATA = ghLinkQuery:PREPARE-STRING
               TRIGGERS:
                   ON VALUE-CHANGED PERSISTENT RUN pageValueChange      IN THIS-PROCEDURE.
                   ON ANY-PRINTABLE PERSISTENT RUN anyPrintableInBrowse IN THIS-PROCEDURE (INPUT ghLinkBrowse).
                   ON START-SEARCH  PERSISTENT RUN startSearch          IN THIS-PROCEDURE (INPUT ghLinkBrowse).
               END TRIGGERS.

        ghLinkQuery:QUERY-OPEN().

        hColumn = ghLinkBrowse:ADD-LIKE-COLUMN(ghInstanceSourceBuffer:BUFFER-FIELD("tObjectInstanceName")).
        hColumn:LABEL = "Source Object Instance Name".
        ghLinkBrowse:ADD-LIKE-COLUMN(ghLinkBuffer:BUFFER-FIELD("tLinkName")).
        hColumn = ghLinkBrowse:ADD-LIKE-COLUMN(ghInstanceTargetBuffer:BUFFER-FIELD("tObjectInstanceName")).
        hColumn:LABEL = "Target Object Instance Name".

        ASSIGN hColumn = ghLinkBrowse:FIRST-COLUMN
               iCnt    = 0.

        DO WHILE VALID-HANDLE(hColumn):
            ASSIGN iCnt              = iCnt + 1
                   hColumn:RESIZABLE = YES
                   hColumn:WIDTH     = INTEGER(ENTRY(iCnt,cLinkColumnWidths))
                   hColumn           = hColumn:NEXT-COLUMN.
        END.

        ghLinkBrowse:SENSITIVE = YES.
        ghLinkQuery:REPOSITION-TO-ROW(1).
        APPLY "VALUE-CHANGED":U TO ghLinkBrowse.
    END.
END.
ELSE
    RUN disableFolderPage IN hFolder (INPUT 3).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imAUIEventBrowser sObject 
PROCEDURE imAUIEventBrowser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phObjectBuffer AS HANDLE     NO-UNDO.

DEFINE VARIABLE hUIEventBuffer AS HANDLE     NO-UNDO.
DEFINE VARIABLE iFieldCnt      AS INTEGER    NO-UNDO.
DEFINE VARIABLE hColumn        AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCnt           AS INTEGER    NO-UNDO.
/*
DEFINE VARIABLE cColumnWidths  AS CHARACTER  NO-UNDO INITIAL "45,200".
*/

/*----------------------* 
 * Instance Class Cache *
 *----------------------*/

ghUIEventQuery:QUERY-CLOSE() NO-ERROR.

DELETE OBJECT ghUIEventBrowse NO-ERROR.
DELETE OBJECT ghUIEventQuery  NO-ERROR.
DELETE OBJECT ghUIEventBuffer NO-ERROR.

ASSIGN ghUIEventBrowse = ?
       ghUIEventQuery  = ?
       ghUIEventBuffer = ?.

IF NOT VALID-HANDLE(phObjectBuffer) THEN
    RETURN.

IF NOT phObjectBuffer:AVAILABLE THEN
    RETURN.

ASSIGN hUIEventBuffer = DYNAMIC-FUNCTION("getCacheUIEventBuffer":U IN gshRepositoryManager).
CREATE BUFFER ghUIEventBuffer FOR TABLE hUIEventBuffer.
CREATE QUERY ghUIEventQuery.
ghUIEventQuery:SET-BUFFERS(ghUIEventBuffer).
ghUIEventQuery:QUERY-PREPARE("FOR EACH ":U + ghUIEventBuffer:NAME + 
                               " WHERE ":U + ghUIEventBuffer:NAME + ".tRecordIdentifier = '":U + STRING(phObjectBuffer:BUFFER-FIELD("tRecordIdentifier"):BUFFER-VALUE) + "'":U
                                + " BY ":U + ghUIEventBuffer:NAME + ".tEventName":U).
ghUIEventQuery:QUERY-OPEN().

CREATE BROWSE ghUIEventBrowse
    ASSIGN FRAME                  = FRAME {&FRAME-NAME}:HANDLE
           COLUMN                 = 1
           ROW                    = 3.2
           WIDTH                  = FRAME {&FRAME-NAME}:WIDTH - 1
           HEIGHT                 = FRAME {&FRAME-NAME}:HEIGHT - 3.2
           TOOLTIP                = "Instance UI Event Cache for selected object"
           MULTIPLE               = FALSE
           SEPARATORS             = TRUE
           ALLOW-COLUMN-SEARCHING = NO
           QUERY                  = ghUIEventQuery
           ROW-MARKERS            = FALSE
           PRIVATE-DATA           = "FOR EACH ":U + ghUIEventBuffer:NAME + 
                                      " WHERE ":U + ghUIEventBuffer:NAME + ".tRecordIdentifier = '":U + STRING(phObjectBuffer:BUFFER-FIELD("tRecordIdentifier"):BUFFER-VALUE) + "'":U
                                       + " BY ":U + ghUIEventBuffer:NAME + ".tEventName":U
    TRIGGERS:
        ON ANY-PRINTABLE PERSISTENT RUN anyPrintableInBrowse IN THIS-PROCEDURE (INPUT ghUIEventBrowse).
        ON START-SEARCH  PERSISTENT RUN startSearch          IN THIS-PROCEDURE (INPUT ghUIEventBrowse).
    END TRIGGERS.

ghUIEventBrowse:ADD-LIKE-COLUMN(ghUIEventBuffer:BUFFER-FIELD("tEventName")).
ghUIEventBrowse:ADD-LIKE-COLUMN(ghUIEventBuffer:BUFFER-FIELD("tActionTarget")).
ghUIEventBrowse:ADD-LIKE-COLUMN(ghUIEventBuffer:BUFFER-FIELD("tActionType")).
ghUIEventBrowse:ADD-LIKE-COLUMN(ghUIEventBuffer:BUFFER-FIELD("tEventAction")).
ghUIEventBrowse:ADD-LIKE-COLUMN(ghUIEventBuffer:BUFFER-FIELD("tEventParameter")).
ghUIEventBrowse:ADD-LIKE-COLUMN(ghUIEventBuffer:BUFFER-FIELD("tEventDisabled")).
ghUIEventBrowse:ADD-LIKE-COLUMN(ghUIEventBuffer:BUFFER-FIELD("tClassName")).

ghUIEventBrowse:NUM-LOCKED-COLUMNS = 1.
ghUIEventBrowse:SENSITIVE = YES.

/*
ASSIGN hColumn = ghUIEventBrowse:FIRST-COLUMN.

DO WHILE VALID-HANDLE(hColumn):
    ASSIGN iCnt              = iCnt + 1
           hColumn:RESIZABLE = YES
           hColumn:WIDTH     = INTEGER(ENTRY(iCnt,cColumnWidths))
           hColumn           = hColumn:NEXT-COLUMN.
END.
*/

ghUIEventQuery:REPOSITION-TO-ROW(1).

APPLY "value-changed":U TO ghUIEventBrowse.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  {get containerSource ghContainer}.

  /* These are the min height and widths in the repository as well */

  ASSIGN FRAME {&FRAME-NAME}:WIDTH  = 133
         FRAME {&FRAME-NAME}:HEIGHT = 24.52.

  RUN resizeObject (INPUT FRAME {&FRAME-NAME}:HEIGHT,
                    INPUT FRAME {&FRAME-NAME}:WIDTH).

  SUBSCRIBE TO "newCacheObject" IN ghContainer.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE newCacheObject sObject 
PROCEDURE newCacheObject :
/*------------------------------------------------------------------------------
  Purpose:     This event is published from the container by cachemainv.w, to indicate
               that a new cache object has been selected.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phObjectBuffer AS HANDLE     NO-UNDO.

DEFINE VARIABLE cRunAttribute AS CHARACTER  NO-UNDO.

tContainerName:SCREEN-VALUE IN FRAME {&FRAME-NAME}     = phObjectBuffer:BUFFER-FIELD("tContainerObjectName":U):BUFFER-VALUE NO-ERROR.
tLogicalObjectName:SCREEN-VALUE IN FRAME {&FRAME-NAME} = phObjectBuffer:BUFFER-FIELD("tLogicalObjectName":U):BUFFER-VALUE NO-ERROR.

{get runAttribute cRunAttribute}.

CASE cRunAttribute:
    WHEN "class":U      THEN RUN imAClassBrowser (INPUT phObjectBuffer).
    WHEN "uiEvent":U    THEN RUN imAUIEventBrowser (INPUT phObjectBuffer).
    WHEN "page":U       THEN RUN imAPageBrowser (INPUT phObjectBuffer).    
END CASE.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pageValueChange sObject 
PROCEDURE pageValueChange :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hPageInstanceBuffer AS HANDLE     NO-UNDO.
DEFINE VARIABLE cColumnWidths       AS CHARACTER  NO-UNDO INITIAL "20,45,40,20,20,20,20,20".
DEFINE VARIABLE hColumn             AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCnt                AS INTEGER    NO-UNDO.

IF VALID-HANDLE(ghPageInstanceQuery) THEN
    ghPageInstanceQuery:QUERY-CLOSE().

DELETE OBJECT ghPageInstanceBrowse NO-ERROR.
DELETE OBJECT ghPageInstanceQuery  NO-ERROR.
DELETE OBJECT ghPageInstanceBuffer NO-ERROR.

ASSIGN ghPageInstanceQuery  = ?
       ghPageInstanceBrowse = ?
       ghPageInstanceBuffer = ?
       hPageInstanceBuffer  = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).

IF VALID-HANDLE(hPageInstanceBuffer) 
AND ghPageBuffer:AVAILABLE
THEN DO:
    CREATE BUFFER ghPageInstanceBuffer FOR TABLE hPageInstanceBuffer.
    CREATE QUERY ghPageInstanceQuery.

    ghPageInstanceQuery:SET-BUFFERS(ghPageInstanceBuffer).
    ghPageInstanceQuery:QUERY-PREPARE("FOR EACH ":U + ghPageInstanceBuffer:NAME + 
                                        " WHERE ":U + ghPageInstanceBuffer:NAME + ".tContainerRecordIdentifier = ":U + QUOTER(ghPageBuffer:BUFFER-FIELD("tRecordIdentifier"):BUFFER-VALUE) +
                                          " AND ":U + ghPageInstanceBuffer:NAME + ".tPageNumber       = ":U + QUOTER(ghPageBuffer:BUFFER-FIELD("tPageNumber"):BUFFER-VALUE) + 
                                           " BY ":U + ghPageInstanceBuffer:NAME + ".tPageNumber":U
                                     ).
    CREATE BROWSE ghPageInstanceBrowse
    ASSIGN FRAME        = FRAME {&FRAME-NAME}:HANDLE
           COLUMN       = 1
           ROW          = 11
           WIDTH        = FRAME {&FRAME-NAME}:WIDTH - 1
           HEIGHT       = 6
           TOOLTIP      = "Page Instance Cache for selected object"
           MULTIPLE     = FALSE
           SEPARATORS   = TRUE
           QUERY        = ghPageInstanceQuery
           ROW-MARKERS  = FALSE
           PRIVATE-DATA = ghPageInstanceQuery:PREPARE-STRING
        TRIGGERS:
            ON ANY-PRINTABLE PERSISTENT RUN anyPrintableInBrowse IN THIS-PROCEDURE (INPUT ghPageInstanceBrowse).
            ON START-SEARCH  PERSISTENT RUN startSearch          IN THIS-PROCEDURE (INPUT ghPageInstanceBrowse).
        END TRIGGERS.

    ghPageInstanceQuery:QUERY-OPEN().

    ghPageInstanceBrowse:ADD-LIKE-COLUMN(ghPageInstanceBuffer:BUFFER-FIELD("tPageNumber")).
    ghPageInstanceBrowse:ADD-LIKE-COLUMN(ghPageInstanceBuffer:BUFFER-FIELD("tObjectInstanceName")).
    ghPageInstanceBrowse:ADD-LIKE-COLUMN(ghPageInstanceBuffer:BUFFER-FIELD("tLogicalObjectName")).
    ghPageInstanceBrowse:ADD-LIKE-COLUMN(ghPageInstanceBuffer:BUFFER-FIELD("tClassName")).
    ghPageInstanceBrowse:ADD-LIKE-COLUMN(ghPageInstanceBuffer:BUFFER-FIELD("tLayoutPosition")).  
    ghPageInstanceBrowse:ADD-LIKE-COLUMN(ghPageInstanceBuffer:BUFFER-FIELD("tObjectInstanceObj")).
    
    ASSIGN hColumn = ghPageInstanceBrowse:FIRST-COLUMN.

    DO WHILE VALID-HANDLE(hColumn):
        ASSIGN iCnt              = iCnt + 1
               hColumn:RESIZABLE = YES
               hColumn:WIDTH     = INTEGER(ENTRY(iCnt,cColumnWidths))
               hColumn           = hColumn:NEXT-COLUMN.
    END.

    ghPageInstanceBrowse:SENSITIVE = YES.
    IF NOT FRAME {&FRAME-NAME}:HIDDEN THEN
        ghPageInstanceBrowse:VISIBLE = YES.
    ghPageInstanceQuery:REPOSITION-TO-ROW(1).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject sObject 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER ipHeight AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER ipWidth  AS DECIMAL    NO-UNDO.

DEFINE VARIABLE hWidget AS HANDLE     NO-UNDO.

/* We only resize width */

IF ipWidth = FRAME {&FRAME-NAME}:WIDTH THEN
    RETURN.

IF ipWidth > FRAME {&FRAME-NAME}:WIDTH THEN
    ASSIGN FRAME {&FRAME-NAME}:WIDTH = ipWidth.

ASSIGN hWidget = FRAME {&FRAME-NAME}:FIRST-CHILD
       hWidget = hWidget:FIRST-CHILD.

DO WHILE VALID-HANDLE(hWidget):
    IF hWidget:TYPE = "BROWSE":U THEN
        ASSIGN hWidget:WIDTH = ipWidth - 1.
    ASSIGN hWidget = hWidget:NEXT-SIBLING.
END.

IF ipWidth < FRAME {&FRAME-NAME}:WIDTH THEN
    ASSIGN FRAME {&FRAME-NAME}:WIDTH = ipWidth.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startSearch sObject 
PROCEDURE startSearch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phBrowseHandle AS HANDLE     NO-UNDO.

DEFINE VARIABLE hQuery  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.
DEFINE VARIABLE cQuery  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iIndex  AS INTEGER    NO-UNDO.
DEFINE VARIABLE rRowid  AS ROWID      NO-UNDO.

ASSIGN hQuery  = phBrowseHandle:QUERY
       hBuffer = hQuery:GET-BUFFER-HANDLE(1)
       rRowid  = IF hBuffer:AVAILABLE
                 THEN hBuffer:ROWID
                 ELSE ?
       cQuery  = phBrowseHandle:PRIVATE-DATA /* The query open statement has been stored in here */
       iIndex  = INDEX(cQuery, "BY ")
       cQuery  = SUBSTRING(cQuery, 1, iIndex - 1)
       cQuery  = cQuery + " BY " + phBrowseHandle:CURRENT-COLUMN:BUFFER-FIELD:BUFFER-HANDLE:NAME + "." + phBrowseHandle:CURRENT-COLUMN:BUFFER-FIELD:NAME.

hQuery:QUERY-CLOSE().
hQuery:QUERY-PREPARE(cQuery).
hQuery:QUERY-OPEN().

IF rRowid <> ? THEN
    hQuery:REPOSITION-TO-ROWID(rRowid).
ELSE
    hQuery:REPOSITION-TO-ROW(1).

APPLY "value-changed":U TO phBrowseHandle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHeight sObject 
FUNCTION getHeight RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RETURN SUPER( ).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWidth sObject 
FUNCTION getWidth RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RETURN SUPER( ).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

