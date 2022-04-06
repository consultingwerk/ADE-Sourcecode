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
  File: cachemainv.w

  Description:  Dynamic Cache Viewer

  Purpose:      Dynamic Cache Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/28/2002  Author:     

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

&scop object-name       cachemainv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{src/adm2/globals.i}

DEFINE VARIABLE ghCacheObjectQuery  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghCacheObjectBrowse AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghObjectBuffer      AS HANDLE     NO-UNDO.

{ry/app/ryobjretri.i}

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
&Scoped-Define ENABLED-OBJECTS fiInheritsFromClasses raFilter coContainer ~
buRefresh fiLogicalObjectName fiObjectPathedFilename fiSDOPathedFilename ~
fiResultCode fiRunAttribute fiClassName fiClassTableName fiClassBuffer ~
fiUserObj fiObjectInstanceName fiObjectInstanceDescription fiDBAware ~
fiLayoutPosition fiPageNumber fiInstanceOrder fiInstanceIsAContainer ~
fiContainerObjectName fiDestroyCustomSuper fiCustomSuperProcedure ~
fiRecordIdentifier fiContainerRecordIdentifier fiLabel fiLanguageObj 
&Scoped-Define DISPLAYED-OBJECTS fiInheritsFromClasses raFilter coContainer ~
fiLogicalObjectName fiObjectPathedFilename fiSDOPathedFilename fiResultCode ~
fiRunAttribute fiClassName fiClassTableName fiClassBuffer fiUserObj ~
fiObjectInstanceName fiObjectInstanceDescription fiDBAware fiLayoutPosition ~
fiPageNumber fiInstanceOrder fiInstanceIsAContainer fiContainerObjectName ~
fiDestroyCustomSuper fiCustomSuperProcedure fiRecordIdentifier ~
fiContainerRecordIdentifier fiLabel fiLanguageObj 

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
DEFINE BUTTON buRefresh 
     LABEL "&Refresh" 
     SIZE 15 BY 1.14 TOOLTIP "Refresh the cache view, to include any recently launched objects."
     BGCOLOR 8 .

DEFINE VARIABLE coContainer AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Container" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "Item1",0
     DROP-DOWN-LIST
     SIZE 76.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiClassBuffer AS CHARACTER FORMAT "X(256)":U 
     LABEL "Class Buffer" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE fiClassName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Class Name" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE fiClassTableName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Class Table Name" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE fiContainerObjectName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Container Object Name" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE fiContainerRecordIdentifier AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>9.999999999-":U INITIAL 0 
     LABEL "Container Identifier" 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE fiCustomSuperProcedure AS CHARACTER FORMAT "X(256)":U 
     LABEL "Super Procedure" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE fiInstanceOrder AS INTEGER FORMAT ">>9":U INITIAL ? 
     LABEL "Instance Order" 
     VIEW-AS FILL-IN 
     SIZE 12.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Inherits From Classes:" 
      VIEW-AS TEXT 
     SIZE 20.8 BY .62 NO-UNDO.

DEFINE VARIABLE fiLanguageObj AS DECIMAL FORMAT ">>,>>>,>>>,>>9.999999-":U INITIAL 0 
     LABEL "Language" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE fiLayoutPosition AS CHARACTER FORMAT "X(256)":U 
     LABEL "Layout Position" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE fiLogicalObjectName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Logical Object Name" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectInstanceDescription AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object Instance Description" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectInstanceName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object Instance Name" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectPathedFilename AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object Pathed Filename" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE fiPageNumber AS CHARACTER FORMAT "X(256)":U 
     LABEL "Page Number" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE fiRecordIdentifier AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>9.999999999-":U INITIAL 0 
     LABEL "Record Identifier" 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE fiResultCode AS CHARACTER FORMAT "X(256)":U 
     LABEL "Result Code" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE fiRunAttribute AS CHARACTER FORMAT "X(256)":U 
     LABEL "Run Attribute" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE fiSDOPathedFilename AS CHARACTER FORMAT "X(256)":U 
     LABEL "SDO Pathed Filename" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE fiUserObj AS DECIMAL FORMAT ">>,>>>,>>>,>>9.999999-":U INITIAL 0 
     LABEL "User" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE raFilter AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Containers and Object Instances", "container",
"Object Master Instances", "master",
"Entire cache (unfiltered)", "All"
     SIZE 100.4 BY .76 NO-UNDO.

DEFINE VARIABLE fiInheritsFromClasses AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 25 BY 3.52
     FONT 3 NO-UNDO.

DEFINE VARIABLE fiDBAware AS LOGICAL INITIAL no 
     LABEL "DB Aware" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.2 BY .81 NO-UNDO.

DEFINE VARIABLE fiDestroyCustomSuper AS LOGICAL INITIAL no 
     LABEL "Destroy Custom Super" 
     VIEW-AS TOGGLE-BOX
     SIZE 29.2 BY .81 NO-UNDO.

DEFINE VARIABLE fiInstanceIsAContainer AS LOGICAL INITIAL no 
     LABEL "Instance Is a Container" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.8 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiInheritsFromClasses AT ROW 19.76 COL 25.8 NO-LABEL
     raFilter AT ROW 1 COL 16.6 NO-LABEL
     coContainer AT ROW 1.81 COL 23.8 COLON-ALIGNED
     buRefresh AT ROW 1.81 COL 103
     fiLogicalObjectName AT ROW 11.1 COL 23.8 COLON-ALIGNED
     fiObjectPathedFilename AT ROW 12.1 COL 23.8 COLON-ALIGNED
     fiSDOPathedFilename AT ROW 13.1 COL 23.8 COLON-ALIGNED
     fiResultCode AT ROW 14.1 COL 23.8 COLON-ALIGNED
     fiRunAttribute AT ROW 15.1 COL 23.8 COLON-ALIGNED
     fiClassName AT ROW 16.62 COL 23.8 COLON-ALIGNED
     fiClassTableName AT ROW 17.62 COL 23.8 COLON-ALIGNED
     fiClassBuffer AT ROW 18.62 COL 23.8 COLON-ALIGNED
     fiUserObj AT ROW 21.67 COL 93 COLON-ALIGNED
     fiObjectInstanceName AT ROW 11.1 COL 93 COLON-ALIGNED
     fiObjectInstanceDescription AT ROW 12.1 COL 93 COLON-ALIGNED
     fiDBAware AT ROW 13.1 COL 95
     fiLayoutPosition AT ROW 14.1 COL 93 COLON-ALIGNED
     fiPageNumber AT ROW 15.1 COL 93 COLON-ALIGNED
     fiInstanceOrder AT ROW 16.1 COL 93 COLON-ALIGNED
     fiInstanceIsAContainer AT ROW 17.81 COL 95
     fiContainerObjectName AT ROW 18.62 COL 93 COLON-ALIGNED
     fiDestroyCustomSuper AT ROW 19.81 COL 95
     fiCustomSuperProcedure AT ROW 20.62 COL 93 COLON-ALIGNED
     fiRecordIdentifier AT ROW 24.14 COL 23.4 COLON-ALIGNED
     fiContainerRecordIdentifier AT ROW 25.14 COL 23.4 COLON-ALIGNED
     fiLabel AT ROW 20.67 COL 2.8 COLON-ALIGNED NO-LABEL
     fiLanguageObj AT ROW 22.71 COL 93 COLON-ALIGNED
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
         HEIGHT             = 25.57
         WIDTH              = 129.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE
       FRAME frMain:PRIVATE-DATA     = 
                "ShowPopups=NO".

ASSIGN 
       fiRecordIdentifier:PRIVATE-DATA IN FRAME frMain     = 
                "ShowPopup=no".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRefresh sObject
ON CHOOSE OF buRefresh IN FRAME frMain /* Refresh */
DO:
  DEFINE VARIABLE cSelectedContainer AS CHARACTER  NO-UNDO.

  ASSIGN cSelectedContainer = coContainer:SCREEN-VALUE NO-ERROR.

  RUN buildData.

  IF coContainer:NUM-ITEMS GT 0 THEN
  DO:
      ASSIGN coContainer:SCREEN-VALUE = cSelectedContainer NO-ERROR.
      APPLY "value-changed":U TO coContainer.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coContainer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coContainer sObject
ON VALUE-CHANGED OF coContainer IN FRAME frMain /* Container */
DO:
  RUN displayCacheBrowse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raFilter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raFilter sObject
ON VALUE-CHANGED OF raFilter IN FRAME frMain
DO:
  RUN buildData.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildData sObject 
PROCEDURE buildData :
/*------------------------------------------------------------------------------
  Purpose:     Build the container combo, and then rebuild the browser, which will
               rebuild the applicable browsers on other tabs.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hField        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField2       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField3       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hObjectBuffer AS HANDLE     NO-UNDO.
DEFINE VARIABLE cWhere        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cListItemPairs  AS CHARACTER    NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
/* Make sure anything left over from a previous call has been cleaned up */
ghCacheObjectQuery:QUERY-CLOSE() NO-ERROR.
DELETE OBJECT ghCacheObjectQuery NO-ERROR.
DELETE OBJECT ghCacheObjectBrowse NO-ERROR.
DELETE OBJECT ghObjectBuffer NO-ERROR.

ASSIGN ghCacheObjectQuery  = ?
       ghCacheObjectBrowse = ?
       ghObjectBuffer      = ?.

/* Get the buffer, build the query, build the combo */

IF raFilter:SCREEN-VALUE = ? THEN ASSIGN raFilter:SCREEN-VALUE = "container":U.

IF raFilter:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "container":U
THEN DO WITH FRAME {&FRAME-NAME}:
    ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT 0).
    CREATE BUFFER ghObjectBuffer FOR TABLE hObjectBuffer.
    
    ASSIGN cWhere = " WHERE " + ghObjectBuffer:NAME + ".tInstanceIsAContainer = YES ":U.

    CREATE QUERY ghCacheObjectQuery.
    ghCacheObjectQuery:SET-BUFFERS(ghObjectBuffer).
    ghCacheObjectQuery:QUERY-PREPARE("FOR EACH ":U + ghObjectBuffer:NAME + cWhere).
    ghCacheObjectQuery:QUERY-OPEN().
    
    ASSIGN hField  = ghObjectBuffer:BUFFER-FIELD("tContainerObjectName":U)
           hField2 = ghObjectBuffer:BUFFER-FIELD("tClassName":U)
           hField3 = ghObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U).
    
    ghCacheObjectQuery:GET-FIRST().

    ASSIGN coContainer:DELIMITER = CHR(3).

    DO WHILE ghObjectBuffer:AVAILABLE WITH FRAME {&FRAME-NAME}:
        IF INDEX(cListItemPairs, hField:BUFFER-VALUE) EQ 0 THEN
            ASSIGN cListItemPairs = cListItemPairs
                                  + hField:BUFFER-VALUE + "  (":U + hField2:BUFFER-VALUE + ")":U
                                  + coContainer:DELIMITER
                                  + STRING(hField3:BUFFER-VALUE)
                                  + coContainer:DELIMITER.
        ghCacheObjectQuery:GET-NEXT().
    END. 
    ghCacheObjectQuery:QUERY-CLOSE().

    DELETE OBJECT ghCacheObjectQuery NO-ERROR.
    ASSIGN ghCacheObjectQuery = ?.

    IF NUM-ENTRIES(cListItemPairs, coContainer:DELIMITER) EQ 0 THEN
        ASSIGN coContainer:LIST-ITEM-PAIRS = "Not Applicable":U + CHR(3) + STRING(0)
               coContainer:SCREEN-VALUE    = coContainer:ENTRY(1) 
               coContainer:SENSITIVE       = FALSE NO-ERROR.
    ELSE
    DO:
        ASSIGN cListItemPairs = RIGHT-TRIM(cListItemPairs, coContainer:DELIMITER)
               coContainer:LIST-ITEM-PAIRS = cListItemPairs.
    
        ASSIGN coContainer:SCREEN-VALUE = coContainer:ENTRY(1)
               coContainer:SENSITIVE    = YES 
               NO-ERROR.
    END.
END.
ELSE
    ASSIGN coContainer:LIST-ITEM-PAIRS = "Not Applicable":U + CHR(3) + STRING(0)
           coContainer:SCREEN-VALUE    = coContainer:ENTRY(1) 
           coContainer:SENSITIVE       = FALSE NO-ERROR.

APPLY "VALUE-CHANGED":U TO coContainer.
END.    /* with frame ... */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeFolderPage sObject 
PROCEDURE changeFolderPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iCurrentPage            AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iObjectPage             AS INTEGER                  NO-UNDO.

    {get CurrentPage iCurrentPage ghContainer}.
    {get ObjectPage iObjectPage}.

    IF iCurrentPage NE iObjectPage THEN
        RUN valueChanged IN TARGET-PROCEDURE.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* changeFolderPage */

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
      ghCacheObjectQuery:QUERY-CLOSE() NO-ERROR.

      DELETE OBJECT ghCacheObjectQuery  NO-ERROR.
      DELETE OBJECT ghCacheObjectBrowse NO-ERROR.
      DELETE OBJECT ghObjectBuffer      NO-ERROR.

      ASSIGN ghCacheObjectQuery  = ?
             ghCacheObjectBrowse = ?
             ghObjectBuffer      = ?.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayCacheBrowse sObject 
PROCEDURE displayCacheBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Create a browser from the session cache.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE hColumn       AS HANDLE     NO-UNDO.
DEFINE VARIABLE cColumnWidths AS CHARACTER  NO-UNDO INITIAL "30,30,20,30,30,30,15,30,30,30,25".
DEFINE VARIABLE iCnt          AS INTEGER    NO-UNDO.
DEFINE VARIABLE hObjectBuffer AS HANDLE     NO-UNDO.
DEFINE VARIABLE cWhere        AS CHARACTER  NO-UNDO.

/* Make sure anything left over from a previous call has been cleaned up */

ghCacheObjectQuery:QUERY-CLOSE() NO-ERROR.
DELETE OBJECT ghCacheObjectQuery NO-ERROR.
DELETE OBJECT ghCacheObjectBrowse NO-ERROR.
DELETE OBJECT ghObjectBuffer NO-ERROR.

ASSIGN ghCacheObjectQuery  = ?
       ghCacheObjectBrowse = ?
       ghObjectBuffer      = ?.

/* Get the buffer, build the query, build the browser */

ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT 0).
CREATE BUFFER ghObjectBuffer FOR TABLE hObjectBuffer.

CASE raFilter:SCREEN-VALUE IN FRAME {&FRAME-NAME}:
    WHEN "Master":U THEN
        ASSIGN cWhere = " WHERE " + ghObjectBuffer:NAME + ".tObjectInstanceObj = 0 ":U.
    WHEN "Container":U THEN
        ASSIGN cWhere = " WHERE ":U + ghObjectBuffer:NAME + '.tContainerRecordIdentifier = ':U + QUOTER(coContainer:SCREEN-VALUE)
                      + " OR ":U + ghObjectBuffer:NAME + '.tRecordIdentifier = ':U + QUOTER(coContainer:SCREEN-VALUE).
    OTHERWISE ASSIGN cWhere = "":U.
END CASE.   /* filter value */

CREATE QUERY ghCacheObjectQuery.
ghCacheObjectQuery:SET-BUFFERS(ghObjectBuffer).
ghCacheObjectQuery:QUERY-PREPARE("FOR EACH ":U + ghObjectBuffer:NAME + cWhere
                                 + " BY ":U + ghObjectBuffer:NAME + ".tContainerObjectName":U
                                 + " BY ":U + ghObjectBuffer:NAME + ".tInstanceOrder":U
                                 + " BY ":U + ghObjectBuffer:NAME + ".tLogicalObjectName":U   ).

CREATE BROWSE ghCacheObjectBrowse
    ASSIGN FRAME        = FRAME {&FRAME-NAME}:HANDLE
           COLUMN       = 1 
           ROW          = IF raFilter:SCREEN-VALUE = "container":U THEN 3.1 ELSE 1.8
           WIDTH        = FRAME {&FRAME-NAME}:WIDTH - 1
           HEIGHT       = IF raFilter:SCREEN-VALUE = "container":U THEN 7.62 ELSE 8.92
           TOOLTIP      = "Current objects cached"
           MULTIPLE     = FALSE
           SEPARATORS   = TRUE
           QUERY        = ghCacheObjectQuery
           ROW-MARKERS  = FALSE
           PRIVATE-DATA = ghCacheObjectQuery:PREPARE-STRING
    TRIGGERS:
        ON ANY-PRINTABLE PERSISTENT RUN anyPrintableInBrowse IN THIS-PROCEDURE (INPUT ghCacheObjectBrowse).
        ON START-SEARCH  PERSISTENT RUN startSearch          IN THIS-PROCEDURE (INPUT ghCacheObjectBrowse).
        ON 'VALUE-CHANGED':U PERSISTENT RUN valueChanged IN THIS-PROCEDURE.
    END TRIGGERS.

ghCacheObjectBrowse:ADD-LIKE-COLUMN(ghObjectBuffer:BUFFER-FIELD("tContainerObjectName":U)).
ghCacheObjectBrowse:ADD-LIKE-COLUMN(ghObjectBuffer:BUFFER-FIELD("tLogicalObjectName":U)).
ghCacheObjectBrowse:ADD-LIKE-COLUMN(ghObjectBuffer:BUFFER-FIELD("tClassName":U)).
ghCacheObjectBrowse:ADD-LIKE-COLUMN(ghObjectBuffer:BUFFER-FIELD("tSDOPathedFilename":U)).
ghCacheObjectBrowse:ADD-LIKE-COLUMN(ghObjectBuffer:BUFFER-FIELD("tCustomSuperProcedure":U)).
ghCacheObjectBrowse:ADD-LIKE-COLUMN(ghObjectBuffer:BUFFER-FIELD("tResultCode":U)).
ghCacheObjectBrowse:ADD-LIKE-COLUMN(ghObjectBuffer:BUFFER-FIELD("tRunAttribute":U)).
ghCacheObjectBrowse:ADD-LIKE-COLUMN(ghObjectBuffer:BUFFER-FIELD("tUserObj":U)).
ghCacheObjectBrowse:ADD-LIKE-COLUMN(ghObjectBuffer:BUFFER-FIELD("tLanguageObj":U)).
ghCacheObjectBrowse:ADD-LIKE-COLUMN(ghObjectBuffer:BUFFER-FIELD("tObjectInstanceName":U)).

ghCacheObjectQuery:QUERY-OPEN().

ASSIGN hColumn = ghCacheObjectBrowse:FIRST-COLUMN.

DO WHILE VALID-HANDLE(hColumn):
    ASSIGN iCnt              = iCnt + 1
           hColumn:RESIZABLE = YES
           hColumn:WIDTH     = INTEGER(ENTRY(iCnt,cColumnWidths))
           hColumn           = hColumn:NEXT-COLUMN.
END.

ghCacheObjectBrowse:SENSITIVE = YES.
ghCacheObjectBrowse:VISIBLE   = YES.

ghCacheObjectQuery:REPOSITION-TO-ROW(1).
APPLY "value-changed":U TO ghCacheObjectBrowse.

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
  DEFINE VARIABLE hPageSource AS HANDLE     NO-UNDO.

  {get ContainerSource ghContainer}.
  SUBSCRIBE TO "newCacheObject" IN ghContainer.
  SUBSCRIBE TO "changeFolderPage":U IN ghContainer.
  
  APPLY "VALUE-CHANGED":U TO raFilter IN FRAME {&FRAME-NAME}.

  RUN resizeObject (INPUT FRAME {&FRAME-NAME}:HEIGHT, INPUT FRAME {&FRAME-NAME}:WIDTH).

  ASSIGN fiLabel:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Inherits From Classes:":U.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  {get pageSource hPageSource ghContainer}. /* Make sure tab 1 (this viewer) is selected */
  RUN selectPage IN ghContainer (INPUT 1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE newCacheObject sObject 
PROCEDURE newCacheObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER ghObjectBuffer AS HANDLE     NO-UNDO.

DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBufferField AS HANDLE     NO-UNDO.

ASSIGN hField = FRAME {&FRAME-NAME}:FIRST-CHILD
       hField = hField:FIRST-CHILD.

DO WHILE VALID-HANDLE(hField):
    IF hField:TYPE = "FILL-IN":U 
    OR hField:TYPE = "TOGGLE-BOX":U
    OR hField:TYPE = "EDITOR":U
    OR hField:TYPE = "SELECTION-LIST":U
    THEN DO:
        IF hField:NAME = "fiClassBuffer":U THEN
            ASSIGN hBufferField               = ghObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
                   fiClassBuffer:SCREEN-VALUE = (IF VALID-HANDLE(hBufferField)
                                                 THEN hBufferField:NAME
                                                 ELSE "<Invalid Buffer Handle>") NO-ERROR.
        ELSE
        IF hField:TYPE EQ "SELECTION-LIST":U THEN
            ASSIGN hField:LIST-ITEMS = STRING(ghObjectBuffer:BUFFER-FIELD("t":U + SUBSTRING(hField:NAME, 3)):BUFFER-VALUE) NO-ERROR.
        ELSE
            ASSIGN hField:SCREEN-VALUE = STRING(ghObjectBuffer:BUFFER-FIELD("t":U + SUBSTRING(hField:NAME, 3)):BUFFER-VALUE) NO-ERROR.
    END.
    ASSIGN hField = hField:NEXT-SIBLING.
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
DEFINE INPUT  PARAMETER ipHeight  AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER ipWidth AS DECIMAL    NO-UNDO.

IF ipWidth = FRAME {&FRAME-NAME}:WIDTH THEN
    RETURN.

IF ipWidth < FRAME {&FRAME-NAME}:WIDTH 
THEN DO:
    IF VALID-HANDLE(ghCacheObjectBrowse) THEN
        ASSIGN ghCacheObjectBrowse:WIDTH = ipWidth - 1.

    ASSIGN FRAME {&FRAME-NAME}:WIDTH  = ipWidth.
END.
ELSE DO:
    ASSIGN FRAME {&FRAME-NAME}:WIDTH = ipWidth.

    IF VALID-HANDLE(ghCacheObjectBrowse) THEN
        ASSIGN ghCacheObjectBrowse:WIDTH  = ipWidth - 1.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChanged sObject 
PROCEDURE valueChanged :
/*------------------------------------------------------------------------------
  Purpose:     When the browser is repositioned, refresh the viewer.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

PUBLISH "newCacheObject" FROM ghContainer (INPUT ghObjectBuffer).

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

