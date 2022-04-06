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
  File: rycboblocv.w

  Description:  Container Builder Object Locator

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   06/18/2002  Author:     Chris Koster

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

&scop object-name       rycboblocv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{src/adm2/globals.i}

DEFINE VARIABLE gcColumnWidths      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCurrentSort       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBaseQuery         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTitle             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghttObjectInstance  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghGridObjectViewer  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerSource   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghParentContainer   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghttObjectType      AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBrowse            AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghColumn            AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghQuery             AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS raPage toVisibleObjects toNonVisibleObjects ~
fiInstanceName fiObjectTypeCode buGotoObject buClear fiFilter fiName fiType 
&Scoped-Define DISPLAYED-OBJECTS raPage fiPage toVisibleObjects ~
toNonVisibleObjects fiInstanceName fiObjectTypeCode fiObjectLocator ~
fiFilter fiWhichPage fiInclude fiName fiType 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 buTransfer 
&Scoped-define List-2 buTransfer 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateUpDown sObject 
FUNCTION evaluateUpDown RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD reopenBrowseQuery sObject 
FUNCTION reopenBrowseQuery RETURNS LOGICAL
    (pcSubstituteList AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buClear  NO-FOCUS FLAT-BUTTON
     LABEL "Clear" 
     SIZE 9.2 BY .71 TOOLTIP "Clear the current filter (if any) / refresh the query"
     BGCOLOR 8 .

DEFINE BUTTON buDown 
     IMAGE-UP FILE "ry/img/afarrwdn.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 3.2 BY .52 TOOLTIP "Decrease page number by 1"
     BGCOLOR 8 .

DEFINE BUTTON buGotoObject  NO-FOCUS FLAT-BUTTON
     LABEL "Select the object..." 
     SIZE 54.8 BY 1.14 TOOLTIP "Select the specified object instance"
     BGCOLOR 8 .

DEFINE BUTTON buTransfer 
     IMAGE-UP FILE "ry/img/aftoexcel.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Move Up" 
     SIZE 4.8 BY 1.14 TOOLTIP "Export"
     BGCOLOR 8 .

DEFINE BUTTON buUp 
     IMAGE-UP FILE "ry/img/afarrwup.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 3.2 BY .52 TOOLTIP "Increase page number by 1"
     BGCOLOR 8 .

DEFINE VARIABLE fiFilter AS CHARACTER FORMAT "X(256)":U INITIAL "  Filter" 
      VIEW-AS TEXT 
     SIZE 28.4 BY .86
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiInclude AS CHARACTER FORMAT "X(256)":U INITIAL " Show" 
      VIEW-AS TEXT 
     SIZE 6.6 BY .62 NO-UNDO.

DEFINE VARIABLE fiInstanceName AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiName AS CHARACTER FORMAT "X(256)":U INITIAL " Instance name BEGINS ..." 
      VIEW-AS TEXT 
     SIZE 25.8 BY .62 NO-UNDO.

DEFINE VARIABLE fiObjectLocator AS CHARACTER FORMAT "X(256)":U INITIAL " Object locator" 
      VIEW-AS TEXT 
     SIZE 14.8 BY .62 NO-UNDO.

DEFINE VARIABLE fiObjectTypeCode AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiPage AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 4.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiType AS CHARACTER FORMAT "X(256)":U INITIAL " Object type BEGINS ..." 
      VIEW-AS TEXT 
     SIZE 23.4 BY .62 NO-UNDO.

DEFINE VARIABLE fiWhichPage AS CHARACTER FORMAT "X(256)":U INITIAL " Objects on page ..." 
      VIEW-AS TEXT 
     SIZE 19 BY .62 NO-UNDO.

DEFINE VARIABLE raPage AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "All", "A",
"Current", "C",
"Page", "P"
     SIZE 12 BY 2.52 NO-UNDO.

DEFINE RECTANGLE rctInclude
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28.4 BY 2.29.

DEFINE RECTANGLE rctLocator
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 64.4 BY 13.29.

DEFINE RECTANGLE rctName
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28.4 BY 1.76.

DEFINE RECTANGLE rctPage
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28.4 BY 3.29.

DEFINE RECTANGLE rctSeperator1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE .4 BY 1.14.

DEFINE RECTANGLE rctToolbar
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 62.4 BY 1.33.

DEFINE RECTANGLE rctType
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28.4 BY 1.76.

DEFINE VARIABLE toNonVisibleObjects AS LOGICAL INITIAL yes 
     LABEL "Non-visible objects" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE toVisibleObjects AS LOGICAL INITIAL yes 
     LABEL "Visible objects" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buTransfer AT ROW 13 COL 3
     raPage AT ROW 3.91 COL 68.6 NO-LABEL
     fiPage AT ROW 5.48 COL 78.8 COLON-ALIGNED NO-LABEL
     toVisibleObjects AT ROW 7.52 COL 68.6
     toNonVisibleObjects AT ROW 8.38 COL 68.6
     fiInstanceName AT ROW 10.29 COL 66.6 COLON-ALIGNED NO-LABEL
     fiObjectTypeCode AT ROW 12.43 COL 66.6 COLON-ALIGNED NO-LABEL
     buGotoObject AT ROW 13 COL 9
     buClear AT ROW 2.76 COL 86.2
     buDown AT ROW 5.95 COL 85
     buUp AT ROW 5.43 COL 85
     fiObjectLocator AT ROW 1.05 COL 2.2 NO-LABEL
     fiFilter AT ROW 1.81 COL 65 COLON-ALIGNED NO-LABEL
     fiWhichPage AT ROW 3.24 COL 68 NO-LABEL
     fiInclude AT ROW 6.91 COL 68 NO-LABEL
     fiName AT ROW 9.57 COL 68 NO-LABEL
     fiType AT ROW 11.71 COL 68 NO-LABEL
     rctSeperator1 AT ROW 13 COL 8
     rctLocator AT ROW 1.33 COL 1
     rctType AT ROW 12 COL 67
     rctPage AT ROW 3.52 COL 67
     rctName AT ROW 9.86 COL 67
     rctInclude AT ROW 7.19 COL 67
     rctToolbar AT ROW 12.91 COL 2.2
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
         HEIGHT             = 13.62
         WIDTH              = 95.2.
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

/* SETTINGS FOR BUTTON buDown IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buTransfer IN FRAME frMain
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR BUTTON buUp IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiInclude IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fiName IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiObjectLocator IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fiPage IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiPage:PRIVATE-DATA IN FRAME frMain     = 
                "0".

/* SETTINGS FOR FILL-IN fiType IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiWhichPage IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR RECTANGLE rctInclude IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctLocator IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctName IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctPage IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctSeperator1 IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctToolbar IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctType IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       toNonVisibleObjects:PRIVATE-DATA IN FRAME frMain     = 
                "yes".

ASSIGN 
       toVisibleObjects:PRIVATE-DATA IN FRAME frMain     = 
                "yes".

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

&Scoped-define SELF-NAME buClear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buClear sObject
ON CHOOSE OF buClear IN FRAME frMain /* Clear */
DO:
  ASSIGN
      toNonVisibleObjects:CHECKED   = TRUE
      toVisibleObjects:CHECKED      = TRUE
      fiObjectTypeCode:SCREEN-VALUE = "":U
      fiInstanceName:SCREEN-VALUE   = "":U
      fiPage:SCREEN-VALUE           = "0":U
      raPage:SCREEN-VALUE           = "A":U.
  
  DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDown sObject
ON CHOOSE OF buDown IN FRAME frMain
DO:
  ASSIGN
      fiPage
      fiPage:SCREEN-VALUE = STRING(INTEGER(fiPage:SCREEN-VALUE) - 1).

  DYNAMIC-FUNCTION("evaluateUpDown":U).
  APPLY "VALUE-CHANGED":U TO fiPage.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buGotoObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buGotoObject sObject
ON CHOOSE OF buGotoObject IN FRAME frMain /* Select the object... */
DO:
  RUN chooseObject.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buTransfer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buTransfer sObject
ON CHOOSE OF buTransfer IN FRAME frMain /* Move Up */
DO:
  RUN transferToExcel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buUp sObject
ON CHOOSE OF buUp IN FRAME frMain
DO:
  ASSIGN
      fiPage
      fiPage:SCREEN-VALUE = STRING(INTEGER(fiPage:SCREEN-VALUE) + 1).

  DYNAMIC-FUNCTION("evaluateUpDown":U).
  APPLY "VALUE-CHANGED":U TO fiPage.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiInstanceName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiInstanceName sObject
ON VALUE-CHANGED OF fiInstanceName IN FRAME frMain
DO:
  DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObjectTypeCode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectTypeCode sObject
ON VALUE-CHANGED OF fiObjectTypeCode IN FRAME frMain
DO:
  DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPage sObject
ON VALUE-CHANGED OF fiPage IN FRAME frMain
DO:
  DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raPage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raPage sObject
ON VALUE-CHANGED OF raPage IN FRAME frMain
DO:
  ASSIGN
      raPage.
  
  IF raPage:SCREEN-VALUE = "P":U THEN
    DYNAMIC-FUNCTION("evaluateUpDown":U).
  ELSE
    ASSIGN
        fiPage:SENSITIVE = FALSE
        buDown:SENSITIVE = FALSE
        buUp:SENSITIVE   = FALSE.

  DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toNonVisibleObjects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toNonVisibleObjects sObject
ON VALUE-CHANGED OF toNonVisibleObjects IN FRAME frMain /* Non-visible objects */
DO:
  DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toVisibleObjects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toVisibleObjects sObject
ON VALUE-CHANGED OF toVisibleObjects IN FRAME frMain /* Visible objects */
DO:
  DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chooseObject sObject 
PROCEDURE chooseObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectLocation AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hPublishFrom    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindow         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hOwner          AS HANDLE     NO-UNDO.

  /* When the preference is set to hide sub-tools instead of closing, this block
     is iterated again and again and again because of and error-status which is
     raised to prevent super procedures from being killed the return-value is alse
     set to "ERROR". So if the return value is "ERROR" exit the block and don't
     publish objectLocated again */
  IF RETURN-VALUE = "ERROR":U THEN
    RETURN "":U.

  ASSIGN
      hPublishFrom = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "PublishFrom":U))
      hOwner       = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "Owner":U)).

  PUBLISH "objectLocated":U FROM hPublishFrom (INPUT ghttObjectInstance:BUFFER-FIELD("d_object_instance_obj":U):BUFFER-VALUE).

  {get WindowFrameHandle hWindow hOwner}.

  RUN destroyObject IN ghContainerSource.

  hWindow:PARENT:MOVE-TO-TOP() NO-ERROR.

  RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearFilters sObject 
PROCEDURE clearFilters :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  APPLY "CHOOSE":U TO buClear IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createBrowse sObject 
PROCEDURE createBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Creates the page browse.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEntry            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFieldLoop        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE httObjectInstance AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectType     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hColumn           AS HANDLE     NO-UNDO EXTENT 7.

  IF NOT VALID-HANDLE(ghttObjectInstance) OR
     NOT VALID-HANDLE(ghttObjectType)     THEN
    RETURN.

  CREATE BUFFER ghttObjectInstance FOR TABLE ghttObjectInstance.
  CREATE BUFFER ghttObjectType     FOR TABLE ghttObjectType.
  CREATE QUERY  ghQuery.

  ghQuery:SET-BUFFERS(ghttObjectInstance, ghttObjectType).

  DO WITH FRAME {&FRAME-NAME}:
    gcBaseQuery    = "FOR EACH ttObjectInstance":U
                   + "   WHERE ttObjectInstance.c_action                  <> 'D'":U
                   + "     AND ttObjectInstance.d_object_instance_obj     <> 0":U
                   + "     AND ttObjectInstance.d_customization_result_obj = &1":U
                   + "     AND ttObjectInstance.l_visible_object           = ttObjectInstance.l_visible_object":U
                   + "     AND ttObjectInstance.c_instance_name       BEGINS ttObjectInstance.c_instance_name":U
                   + "     AND ttObjectInstance.i_page                     = ttObjectInstance.i_page,":U
                   + "   FIRST ttObjectType":U
                   + "   WHERE ttObjectType.d_object_type_obj       = ttObjectInstance.d_object_type_obj":U
                   + "     AND ttObjectType.c_object_type_code BEGINS ttObjectType.c_object_type_code":U
                   .

    CREATE BROWSE ghBrowse
    ASSIGN FRAME                  = FRAME {&FRAME-NAME}:HANDLE
           NAME                   = "LocatorBrowse"
           SEPARATORS             = TRUE
           ROW-MARKERS            = FALSE
           EXPANDABLE             = TRUE
           COLUMN-RESIZABLE       = TRUE
           ALLOW-COLUMN-SEARCHING = TRUE
           QUERY                  = ghQuery
           REFRESHABLE            = YES
    TRIGGERS:            
        ON "MOUSE-SELECT-DBLCLICK":U  PERSISTENT RUN trgMouseDblClick IN THIS-PROCEDURE.
        ON "VALUE-CHANGED":U          PERSISTENT RUN trgValueChanged  IN THIS-PROCEDURE.
        ON "START-SEARCH":U           PERSISTENT RUN trgStartSearch   IN THIS-PROCEDURE.
        ON "ROW-DISPLAY":U            PERSISTENT RUN trgRowDisplay    IN THIS-PROCEDURE.
    END TRIGGERS.
    
    ASSIGN
        hColumn[1] = ghBrowse:ADD-LIKE-COLUMN(ghttObjectInstance:BUFFER-FIELD("i_page":U))
        hColumn[2] = ghBrowse:ADD-LIKE-COLUMN(ghttObjectInstance:BUFFER-FIELD("i_row":U))
        hColumn[3] = ghBrowse:ADD-CALC-COLUMN("CHAR":U, "X":U, "":U, "C":U)
        hColumn[4] = ghBrowse:ADD-LIKE-COLUMN(ghttObjectInstance:BUFFER-FIELD("c_instance_name":U))
        hColumn[5] = ghBrowse:ADD-LIKE-COLUMN(ghttObjectType:BUFFER-FIELD("c_object_type_code":U))
        hColumn[6] = ghBrowse:ADD-LIKE-COLUMN(ghttObjectInstance:BUFFER-FIELD("l_visible_object":U))
        hColumn[7] = ghBrowse:ADD-LIKE-COLUMN(ghttObjectInstance:BUFFER-FIELD("c_instance_description":U))
        
        ghColumn           = hColumn[3]
        hColumn[3]:NAME    = "i_column":U
        ghBrowse:SENSITIVE = TRUE
        ghBrowse:VISIBLE   = YES
        
        toNonVisibleObjects:CHECKED   = TRUE
        toVisibleObjects:CHECKED      = TRUE
        fiPage:SCREEN-VALUE           = "0":U
        fiObjectLocator:SCREEN-VALUE = " Object locator":U
        fiWhichPage:SCREEN-VALUE     = " Objects on page ...":U
        fiInclude:SCREEN-VALUE       = " Show":U
        fiFilter:SCREEN-VALUE        = "  Filter":U
        fiName:SCREEN-VALUE          = " Instance name BEGINS ...":U
        fiType:SCREEN-VALUE          = " Object type BEGINS ...":U.

    DO iFieldLoop = 1 TO ghBrowse:NUM-COLUMNS:
      cEntry = ENTRY(iFieldLoop, gcColumnWidths, "^":U).
  
      IF INTEGER(cEntry) <> 0 THEN
        hColumn[iFieldLoop]:WIDTH-PIXELS = INTEGER(cEntry).
    END.
  END.

  RETURN.

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
  DEFINE VARIABLE cPreferences  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColumn       AS INTEGER    NO-UNDO.

  cPreferences = "DefaultSort":U  + "|":U + gcCurrentSort + "|":U
               + "ColumnWidths":U + "|":U.

  DO iColumn = 1 TO ghBrowse:NUM-COLUMNS:
    cPreferences = cPreferences + STRING(ghBrowse:GET-BROWSE-COLUMN(iColumn):WIDTH-PIXELS) + "^":U.
  END.

  cPreferences = TRIM(cPreferences, "^":U).

  IF VALID-HANDLE(gshProfileManager) THEN
    RUN setProfileData IN gshProfileManager (INPUT "Window":U,        /* Profile type code      */
                                             INPUT "CBuilder":U,      /* Profile code           */
                                             INPUT "ObjLPreferences", /* Profile data key       */
                                             INPUT ?,                 /* Rowid of profile data  */
                                             INPUT cPreferences,      /* Profile data value     */
                                             INPUT NO,                /* Delete flag            */
                                             INPUT "PER":U).          /* Save flag (permanent)  */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DELETE OBJECT ghttObjectInstance.
  DELETE OBJECT ghttObjectType.
  DELETE OBJECT ghBrowse.
  DELETE OBJECT ghQuery.

  ASSIGN
      ghttObjectInstance = ?
      ghttObjectType     = ?
      ghBrowse           = ?
      ghQuery            = ?.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getProfileData sObject 
PROCEDURE getProfileData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPrefs  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE rRowId  AS ROWID      NO-UNDO.

  ASSIGN
      gcColumnWidths = "0^0^0^0^0^0^0":U
      gcCurrentSort  = " BY ttObjectInstance.c_instance_name":U.
  
  IF VALID-HANDLE(gshProfileManager) THEN
    RUN getProfileData IN gshProfileManager (INPUT "Window":U,          /* Profile type code     */
                                             INPUT "CBuilder":U,        /* Profile code          */
                                             INPUT "ObjLPreferences":U, /* Profile data key      */
                                             INPUT "NO":U,              /* Get next record flag  */
                                             INPUT-OUTPUT rRowid,       /* Rowid of profile data */
                                             OUTPUT cPrefs).            /* Found profile data.   */

  /* --- Preference lookup --------------------- */ /* --- Preference value assignment --------------------------------- */
  iEntry = LOOKUP("ColumnWidths":U, cPrefs, "|":U). IF iEntry <> 0 THEN gcColumnWidths  = ENTRY(iEntry + 1, cPrefs, "|":U).
  iEntry = LOOKUP("DefaultSort":U,  cPrefs, "|":U). IF iEntry <> 0 THEN gcCurrentSort   = ENTRY(iEntry + 1, cPrefs, "|":U).

  RETURN.

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

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE hWindow AS HANDLE     NO-UNDO.

  RUN SUPER.

  {get ContainerSource ghContainerSource}.
  {get ContainerSource ghParentContainer ghContainerSource}.

  {get WindowFrameHandle hWindow ghContainerSource}.

  ASSIGN
      ghGridObjectViewer = DYNAMIC-FUNCTION("linkHandles":U IN ghParentContainer, "gridv-Source":U)
      hWindow            = hWindow:PARENT
      gcTitle            = hWindow:TITLE

      ghttObjectInstance = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectInstance":U))
      ghttObjectType     = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectType":U)).

  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "refreshData":U IN ghParentContainer.
  SUBSCRIBE TO "clearFilters":U IN ghParentContainer.

  RUN getProfileData.
  RUN createBrowse.

  hWindow = DYNAMIC-FUNCTION("getContainerToolbarSource":U IN ghContainerSource).
  SUBSCRIBE TO "toolbar":U IN hWindow.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN resizeObject (INPUT FRAME {&FRAME-NAME}:HEIGHT-CHARS, INPUT FRAME {&FRAME-NAME}:WIDTH-CHARS).
  RUN refreshData  (INPUT "NewData":U, INPUT 0.00).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshData sObject 
PROCEDURE refreshData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdObjNumber  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE httSmartObject    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectType     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToolbar          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindow           AS HANDLE     NO-UNDO.
  
  {get ContainerToolbarSource hToolbar ghContainerSource}.
  
  DO WITH FRAME {&FRAME-NAME}:
    IF pcAction            = "PageChange":U AND 
       raPage:SCREEN-VALUE = "C":U          THEN
      DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U).
    ELSE
    DO:
      IF ghQuery:NUM-RESULTS > 0 THEN
        ghBrowse:REFRESH().
      ELSE
        ASSIGN
            buGotoObject:SENSITIVE = FALSE
            buTransfer:SENSITIVE   = FALSE.
    END.

    IF pcAction = "NewData":U THEN
    DO:
      {get WindowFrameHandle hWindow ghContainerSource}.
      
      ASSIGN
          httSmartObject = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttSmartObject":U))
          httObjectType  = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectType":U))
          hWindow        = hWindow:PARENT.

      httSmartObject:FIND-FIRST("WHERE d_smartobject_obj <> 0":U) NO-ERROR.
      
      IF httSmartObject:AVAILABLE THEN
        httObjectType:FIND-FIRST("WHERE d_object_type_obj = ":U + QUOTER(httSmartObject:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE)) NO-ERROR.

      IF httObjectType:AVAILABLE THEN
        hWindow:TITLE = gcTitle
                      + " ":U  + httSmartObject:BUFFER-FIELD("c_object_filename":U):BUFFER-VALUE
                      + " (":U + httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE + ")":U.
      ELSE
        hWindow:TITLE = gcTitle.
      
      DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U).
    END.

    IF ghQuery:NUM-RESULTS = 0 OR
       ghQuery:NUM-RESULTS = ? THEN
    DO:
      {set   DisabledActions 'export':U hToolbar}.
      {fnarg disableActions  'export':U hToolbar}.
    END.
    ELSE
    DO:
      {set   DisabledActions '':U     hToolbar}.
      {fnarg enableActions 'export':U hToolbar}.
    END.
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
  DEFINE INPUT PARAMETER pdHeight   AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth    AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE lResizedObjects   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dFrameHeight      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFrameWidth       AS DECIMAL    NO-UNDO.

  HIDE FRAME {&FRAME-NAME}.

  ASSIGN
      dFrameHeight = FRAME {&FRAME-NAME}:HEIGHT-CHARS + 0.25
      dFrameWidth  = FRAME {&FRAME-NAME}:WIDTH-CHARS.
  
  /* If the height OR width of the frame was made smaller */
  IF pdHeight < dFrameHeight OR
     pdWidth  < dFrameWidth  THEN
  DO:
    /* Just in case the window was made longer or wider, allow for the new length or width */
    IF pdHeight > dFrameHeight THEN FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight.
    IF pdWidth  > dFrameWidth  THEN FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth.
    
    lResizedObjects = TRUE.
    
    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth).
  END.
  
  ASSIGN    
      FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight + 0.25
      FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth.

  IF lResizedObjects = FALSE THEN
    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth).

  VIEW FRAME {&FRAME-NAME}.

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeViewerObjects sObject 
PROCEDURE resizeViewerObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE dDifference AS DECIMAL    NO-UNDO.

  IF VALID-HANDLE(ghBrowse) THEN
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        rctLocator:HEIGHT-CHARS   = pdHeight - 0.45
        rctLocator:WIDTH-CHARS    = pdWidth /*- rctPage:WIDTH-CHARS*/
        ghBrowse:ROW              = rctLocator:ROW + 0.50
        ghBrowse:COLUMN           = 3.00
        ghBrowse:HEIGHT-CHARS     = rctLocator:HEIGHT-CHARS - buGotoObject:HEIGHT-CHARS - 1.20
        ghBrowse:WIDTH-CHARS      = rctLocator:WIDTH-CHARS  - rctPage:WIDTH-CHARS       - 6.00
        rctToolbar:COLUMN         = ghBrowse:COLUMN
        rctToolbar:WIDTH-CHARS    = ghBrowse:WIDTH-CHARS
        rctToolbar:Y              = ghBrowse:Y + ghBrowse:HEIGHT-PIXELS + 5
        buTransfer:X              = rctToolbar:X + 7
        buTransfer:Y              = rctToolbar:Y + 2

        buGotoObject:X            = buTransfer:X + buTransfer:WIDTH-PIXELS + 2
        buGotoObject:Y            = rctToolbar:Y + 2
        buGotoObject:WIDTH-PIXELS = rctToolbar:WIDTH-PIXELS - (buTransfer:WIDTH-PIXELS + buTransfer:X) + 6
        
        dDifference = ghBrowse:WIDTH-CHARS
                    + ghBrowse:COLUMN + 2.00
                    - rctPage:COLUMN

        toNonVisibleObjects:COLUMN = toNonVisibleObjects:COLUMN + dDifference
        toVisibleObjects:COLUMN    = toVisibleObjects:COLUMN    + dDifference
        fiObjectTypeCode:COLUMN    = fiObjectTypeCode:COLUMN    + dDifference
        fiInstanceName:COLUMN      = fiInstanceName:COLUMN      + dDifference
        fiWhichPage:COLUMN         = fiWhichPage:COLUMN         + dDifference
        rctInclude:COLUMN          = rctInclude:COLUMN          + dDifference
        fiInclude:COLUMN           = fiInclude:COLUMN           + dDifference
        fiFilter:COLUMN            = fiFilter:COLUMN            + dDifference
        rctPage:COLUMN             = rctPage:COLUMN             + dDifference
        rctName:COLUMN             = rctName:COLUMN             + dDifference
        rctType:COLUMN             = rctType:COLUMN             + dDifference
        buClear:COLUMN             = buClear:COLUMN             + dDifference
        fiPage:COLUMN              = fiPage:COLUMN              + dDifference
        raPage:COLUMN              = raPage:COLUMN              + dDifference
        fiName:COLUMN              = fiName:COLUMN              + dDifference
        fiType:COLUMN              = fiType:COLUMN              + dDifference
        buDown:COLUMN              = buDown:COLUMN              + dDifference
        buUp:COLUMN                = buUp:COLUMN                + dDifference
        rctSeperator1:Y            = rctToolbar:Y   + 2
        rctSeperator1:X            = buGotoObject:X - 2

        .
        buClear:MOVE-TO-TOP().
  END.

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setupObjectLocator sObject 
PROCEDURE setupObjectLocator :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
  DEFINE VARIABLE cListItemPairs          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScreenValue            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lVisibleObject          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCurrentPage            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectType           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery                  AS HANDLE     NO-UNDO.

  CREATE QUERY hQuery.

  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "CustomizationResultObj":U))
      httObjectInstance       = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectInstance":U))
      httObjectType           = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectType":U)).

  IF NOT VALID-HANDLE(httObjectInstance) OR
     NOT VALID-HANDLE(httObjectType)     THEN
    RETURN.

  CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.
  CREATE BUFFER httObjectType     FOR TABLE httObjectType.
  
  hQuery:SET-BUFFERS(httObjectInstance, httObjectType).

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        toOnlyVisibleObjects
        toSortByRowColumn
        coObjectLocator
        toAllPages
        cListItemPairs = "":U
        cScreenValue   = coObjectLocator:SCREEN-VALUE
        iCurrentPage   = DYNAMIC-FUNCTION("getPageSequence":U IN ghContainerSource, ?).

    hQuery:QUERY-PREPARE("FOR EACH ttObjectInstance":U
                         + " WHERE ttObjectInstance.c_action                 <> 'D'":U
                         + "   AND ttObjectInstance.d_customization_result_obj = DECIMAL('":U + STRING(dCustomizationResultObj) + "')":U
                         + "   AND ttObjectInstance.d_object_instance_obj     <> 0.00,":U
                         + " FIRST ttObjectType":U
                         + " WHERE ttObjectType.d_object_type_obj = ttObjectInstance.d_object_type_obj":U
                         + "    BY ttObjectInstance.i_page":U
                         + "    BY DYNAMIC-FUNCTION('isVisibleObjectType':U IN WIDGET-HANDLE('":U + STRING(ghContainerSource) + "'), ttObjectType.c_object_type_code)":U
                         + "    BY ":U + (IF toSortByRowColumn:CHECKED THEN "ttObjectInstance.i_row":U ELSE "ttObjectInstance.c_instance_name":U)
                         + "    BY ttObjectInstance.i_column":U).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().
    
    DO WHILE NOT hQuery:QUERY-OFF-END:

      lVisibleObject = DYNAMIC-FUNCTION("isVisibleObjectType":U IN ghContainerSource, httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE).

      IF (toOnlyVisibleObjects:CHECKED = TRUE          AND
          lVisibleObject               = FALSE)        OR

         (toAllPages:CHECKED                                       = FALSE         AND
          httObjectInstance:BUFFER-FIELD("i_page":U):BUFFER-VALUE <> iCurrentPage) THEN
        .
      ELSE
        cListItemPairs = cListItemPairs
                       + (IF cListItemPairs = "":U THEN "":U ELSE coObjectLocator:DELIMITER)
                       + "Pg. ":U + STRING(httObjectInstance:BUFFER-FIELD("i_page":U):BUFFER-VALUE, ">9":U)
                       + (IF lVisibleObject = FALSE THEN "  ":U   ELSE ", ":U)
                       + (IF lVisibleObject = FALSE THEN "  ":U   ELSE STRING(httObjectInstance:BUFFER-FIELD("i_row":U):BUFFER-VALUE, "R9"))
                       + (IF lVisibleObject = FALSE THEN "    ":U ELSE STRING(httObjectInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE, ", C9":U))
                       + " - ":U + httObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE
                       + " (":U  + httObjectInstance:BUFFER-FIELD("c_instance_description":U):BUFFER-VALUE + ")":U
                       + coObjectLocator:DELIMITER
                       + STRING(httObjectInstance:BUFFER-FIELD("i_page":U):BUFFER-VALUE + 1)
                       + "|":U + STRING(httObjectInstance:BUFFER-FIELD("i_row":U):BUFFER-VALUE)
                       + "|":U + STRING(httObjectInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE)
                       + "|":U + IF lVisibleObject THEN "Y":U ELSE "N":U.

      hQuery:GET-NEXT().
    END.

    DELETE OBJECT httObjectInstance.
    DELETE OBJECT httObjectType.
    DELETE OBJECT hQuery.
    
    ASSIGN
        httObjectInstance = ?
        httObjectType     = ?
        hQuery            = ?.

    coObjectLocator:LIST-ITEM-PAIRS = (IF TRIM(cListItemPairs) <> "":U THEN cListItemPairs ELSE coObjectLocator:DELIMITER).

    /* If the screen value object is on the same page as we are on, then it is possible
       to set the screen value of the locator back to what was selected previously */
    IF LOOKUP(cScreenValue, cListItemPairs, coObjectLocator:DELIMITER) <> 0 THEN
      coObjectLocator:SCREEN-VALUE = cScreenValue.

    APPLY "VALUE-CHANGED":U TO coObjectLocator.
  END.

  RETURN.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbar sObject 
PROCEDURE toolbar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction AS CHARACTER  NO-UNDO.

  IF pcAction = "Export":U THEN
    RUN transferToExcel.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE transferToExcel sObject 
PROCEDURE transferToExcel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN transferToExcel IN ghParentContainer (INPUT ghBrowse, INPUT ghContainerSource).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgMouseDblClick sObject 
PROCEDURE trgMouseDblClick :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  APPLY "CHOOSE":U TO buGotoObject IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgRowDisplay sObject 
PROCEDURE trgRowDisplay :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ghColumn:SCREEN-VALUE = KEY-LABEL(KEY-CODE("A") + ghttObjectInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE - 1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgStartSearch sObject 
PROCEDURE trgStartSearch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCurrentSort        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dObjectInstanceObj  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hColumn             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer             AS HANDLE     NO-UNDO.

  IF ghQuery:NUM-RESULTS > 0 THEN
  DO:
    IF NOT ghBrowse:SELECT-FOCUSED-ROW() THEN
      ghBrowse:SELECT-ROW(1).

    ASSIGN
        hColumn            = ghttobjectInstance:BUFFER-FIELD("d_object_instance_obj":U)
        dObjectInstanceObj = hColumn:BUFFER-VALUE.
  END.    /* records available */
  ELSE
     dObjectInstanceObj = 0.00.

  /* Determine the new row. */
  hColumn = ghBrowse:CURRENT-COLUMN.
  
  IF hColumn = ghColumn THEN
    ASSIGN
        cCurrentSort = " BY ttObjectInstance.i_column ":U.
  ELSE
    ASSIGN
        hBuffer       = hColumn:BUFFER-FIELD
        hBuffer       = hBuffer:BUFFER-HANDLE
        cColumnName   = hColumn:NAME
        cTableName    = hBuffer:NAME
        cCurrentSort = " BY ":U  + cTableName + (IF cTableName = ? THEN "":U ELSE ".":U) + cColumnName + " ":U
        .
/*
  ASSIGN
      cLabel = hColumn:LABEL
      cLabel = IF INDEX(cLabel, " ^":U) <> 0 THEN REPLACE(cLabel, " ^":U, "":U) ELSE cLabel
      cLabel = IF INDEX(cLabel, " v":U) <> 0 THEN REPLACE(cLabel, " v":U, "":U) ELSE cLabel.
*/
  IF cCurrentSort = gcCurrentSort THEN
    ASSIGN
        gcCurrentSort = cCurrentSort + "DESC":U
/*      hColumn:LABEL = cLabel +  " ^":U*/ .
  ELSE
    ASSIGN
        gcCurrentSort = cCurrentSort
/*      hColumn:LABEL = cLabel + " v":U*/ .

  /* Reopen Query */
  DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgValueChanged sObject 
PROCEDURE trgValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    IF ghQuery:NUM-RESULTS > 0 THEN
      ASSIGN
          buGotoObject:SENSITIVE = TRUE
          buTransfer:SENSITIVE   = TRUE.
    ELSE
      ASSIGN
          buGotoObject:SENSITIVE = FALSE
          buTransfer:SENSITIVE   = FALSE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateUpDown sObject 
FUNCTION evaluateUpDown RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFolderLabels AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hPageSource   AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    {get PageSource hPageSource ghParentContainer}.
    
    ASSIGN
        fiPage

        cFolderLabels    = DYNAMIC-FUNCTION("getFolderLabels":U IN hPageSource)
        buDown:SENSITIVE = (IF INTEGER(fiPage:SCREEN-VALUE)  = 0 THEN FALSE ELSE TRUE)
        buUp:SENSITIVE   = (IF INTEGER(fiPage:SCREEN-VALUE) >= (NUM-ENTRIES(cFolderLabels, "|":U) - 1) THEN FALSE ELSE TRUE).
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION reopenBrowseQuery sObject 
FUNCTION reopenBrowseQuery RETURNS LOGICAL
    (pcSubstituteList AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Opens the query for the specified browse.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSubstituteList         AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE cBaseQuery              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iCurrentPage            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntries                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSuccess                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    /* Make the relevant substitutions. */
    iEntries = NUM-ENTRIES(pcSubstituteList, CHR(3)).

    IF iEntries > 0 THEN ASSIGN cSubstituteList[1] = ENTRY(1, pcSubstituteList, CHR(3)).
    IF iEntries > 1 THEN ASSIGN cSubstituteList[2] = ENTRY(2, pcSubstituteList, CHR(3)).
    IF iEntries > 2 THEN ASSIGN cSubstituteList[3] = ENTRY(3, pcSubstituteList, CHR(3)).
    IF iEntries > 3 THEN ASSIGN cSubstituteList[4] = ENTRY(4, pcSubstituteList, CHR(3)).
    IF iEntries > 4 THEN ASSIGN cSubstituteList[5] = ENTRY(5, pcSubstituteList, CHR(3)).
    IF iEntries > 5 THEN ASSIGN cSubstituteList[6] = ENTRY(6, pcSubstituteList, CHR(3)).
    IF iEntries > 6 THEN ASSIGN cSubstituteList[7] = ENTRY(7, pcSubstituteList, CHR(3)).
    IF iEntries > 7 THEN ASSIGN cSubstituteList[8] = ENTRY(8, pcSubstituteList, CHR(3)).
    IF iEntries > 8 THEN ASSIGN cSubstituteList[9] = ENTRY(9, pcSubstituteList, CHR(3)).
  
    ASSIGN
        toNonVisibleObjects
        toVisibleObjects
        fiObjectTypeCode
        fiInstanceName
        raPage
        fiPage

        dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultObj":U))
        httObjectInstance       = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttSmartObject":U))
        iCurrentPage            = DYNAMIC-FUNCTION("getPageSequence":U IN ghParentContainer, ?)
        cBaseQuery              = SUBSTITUTE(gcBaseQuery, QUOTER(dCustomizationResultObj)).

    IF raPage:SCREEN-VALUE = "C":U THEN /* Current Page */
      cBaseQuery = REPLACE(cBaseQuery, "= ttObjectInstance.i_page":U, "= ":U + STRING(iCurrentPage)).
    
    IF raPage:SCREEN-VALUE = "P":U THEN /* Current Page */
      cBaseQuery = REPLACE(cBaseQuery, "= ttObjectInstance.i_page":U, "= ":U + STRING(DYNAMIC-FUNCTION("getPageSequence":U IN ghParentContainer, INTEGER(fiPage:SCREEN-VALUE)))).

    IF toNonVisibleObjects:CHECKED = TRUE  AND
       toVisibleObjects:CHECKED    = FALSE THEN
      cBaseQuery = REPLACE(cBaseQuery, "= ttObjectInstance.l_visible_object":U, "= NO":U).

    IF toNonVisibleObjects:CHECKED = FALSE AND
       toVisibleObjects:CHECKED    = TRUE  THEN
      cBaseQuery = REPLACE(cBaseQuery, "= ttObjectInstance.l_visible_object":U, "= YES":U).

    IF toNonVisibleObjects:CHECKED = FALSE AND
       toVisibleObjects:CHECKED    = FALSE THEN
      cBaseQuery = REPLACE(cBaseQuery, "= ttObjectInstance.l_visible_object":U, "= ?":U).

    IF fiInstanceName:SCREEN-VALUE <> ? AND
       fiInstanceName:SCREEN-VALUE <> "":U THEN
      cBaseQuery = REPLACE(cBaseQuery, "BEGINS ttObjectInstance.c_instance_name":U, "BEGINS '":U + fiInstanceName:SCREEN-VALUE + "'":U).

    IF fiObjectTypeCode:SCREEN-VALUE <> ? AND
       fiObjectTypeCode:SCREEN-VALUE <> "":U THEN
      cBaseQuery = REPLACE(cBaseQuery, "BEGINS ttObjectType.c_object_type_code":U, "BEGINS '":U + fiObjectTypeCode:SCREEN-VALUE + "'":U).

    cBaseQuery = SUBSTITUTE(cBaseQuery,
                            cSubstituteList[1],
                            cSubstituteList[2],
                            cSubstituteList[3],
                            cSubstituteList[4],
                            cSubstituteList[5],
                            cSubstituteList[6],
                            cSubstituteList[7],
                            cSubstituteList[8],
                            cSubstituteList[9]).

    /* Always reopen, in case the sort has changed. */
    ghQuery:QUERY-PREPARE(cBaseQuery + gcCurrentSort).
    
    IF ghQuery:IS-OPEN THEN
       ghQuery:QUERY-CLOSE().
  
    ghQuery:QUERY-OPEN().
/*    
    IF ghQuery:NUM-RESULTS > 0 THEN
    DO:
      CREATE BUFFER httObjectInstance FOR TABLE ghttObjectInstance.

      httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = DECIMAL('":U + STRING(gdObjectInstanceObj) + "')":U) NO-ERROR.

      IF httObjectInstance:AVAILABLE THEN
        lSuccess = ghQuery:REPOSITION-TO-ROWID(httObjectInstance:ROWID) NO-ERROR.

      IF lSuccess = FALSE THEN
        APPLY "VALUE-CHANGED":U TO ghBrowse.

      DELETE OBJECT httObjectInstance.
      httObjectInstance = ?.

        /*ghBrowse:SELECT-ROW(ghBrowse:CURRENT).*/
    END.
*/
    RUN trgValueChanged.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

