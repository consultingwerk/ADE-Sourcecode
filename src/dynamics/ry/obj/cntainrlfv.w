&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"ry/obj/ryemptysdo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*---------------------------------------------------------------------------------
  File: cntainrliv.w

  Description:  Container Links Viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   03/06/2002  Author:     

  Update Notes: Created from Template rysttviewv.w

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

&scop object-name       cntainrlfv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}
/*
  {ry/inc/rycntnerbi.i}
  {af/sup2/afttcombo.i}
*/

DEFINE VARIABLE gcUserDefinedLinks  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLocatorRequest    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOldSourceValue     AS CHARACTER  NO-UNDO INITIAL "<All>":U.
DEFINE VARIABLE cOldTargetValue     AS CHARACTER  NO-UNDO INITIAL "<All>":U.
DEFINE VARIABLE gcColumnWidths      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBaseQueryAll      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBaseQueryTF       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCurrentSort       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLinkNames         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTitle             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdSmartLinkObj      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE glShowFilter        AS LOGICAL    NO-UNDO INITIAL FALSE.
DEFINE VARIABLE ghContainerSource   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerHandle   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghParentContainer   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSmartLink         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSOInstance        AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTOInstance        AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSColumn           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTColumn           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBrowse            AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghQuery             AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/ryemptysdo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiFilter rctBorder 
&Scoped-Define DISPLAYED-OBJECTS coFilterSource coLink coFilterTarget ~
raShow coShow coToPage coFromPage fiFilter fiShow 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHasData vTableWin 
FUNCTION getHasData RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLinkNames vTableWin 
FUNCTION getLinkNames RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getListItemPairs vTableWin 
FUNCTION getListItemPairs RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPageItemPairs vTableWin 
FUNCTION getPageItemPairs RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getShowFilter vTableWin 
FUNCTION getShowFilter RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUserDefinedLinks vTableWin 
FUNCTION getUserDefinedLinks RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD reopenBrowseQuery vTableWin 
FUNCTION reopenBrowseQuery RETURNS LOGICAL
    (pcSubstituteList AS CHARACTER,
     pdSmartLinkObj   AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseSensitivity vTableWin 
FUNCTION setBrowseSensitivity RETURNS LOGICAL
  (plSensitive AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFilterSensitivity vTableWin 
FUNCTION setFilterSensitivity RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setShowFilter vTableWin 
FUNCTION setShowFilter RETURNS LOGICAL
  (plShowFilter AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD transferToExcel vTableWin 
FUNCTION transferToExcel RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buShow 
     IMAGE-UP FILE "ry/img/objectlocator.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.4 BY 1.05
     BGCOLOR 8 .

DEFINE BUTTON buSource 
     IMAGE-UP FILE "ry/img/objectlocator.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.4 BY 1.05
     BGCOLOR 8 .

DEFINE BUTTON buTarget 
     IMAGE-UP FILE "ry/img/objectlocator.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4.4 BY 1.05
     BGCOLOR 8 .

DEFINE VARIABLE coFilterSource AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Source" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 34.8 BY 1 NO-UNDO.

DEFINE VARIABLE coFilterTarget AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Target" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 34.8 BY 1 NO-UNDO.

DEFINE VARIABLE coFromPage AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "0","0"
     DROP-DOWN-LIST
     SIZE 27.2 BY 1 NO-UNDO.

DEFINE VARIABLE coLink AS CHARACTER 
     LABEL "Link" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN
     SIZE 34.8 BY 1 NO-UNDO.

DEFINE VARIABLE coShow AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 27.2 BY 1 NO-UNDO.

DEFINE VARIABLE coToPage AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "0","0"
     DROP-DOWN-LIST
     SIZE 27.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiFilter AS CHARACTER FORMAT "X(256)":U INITIAL "  Filter" 
      VIEW-AS TEXT 
     SIZE 48.2 BY .86
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiShow AS CHARACTER FORMAT "X(256)":U INITIAL " Show" 
      VIEW-AS TEXT 
     SIZE 6.8 BY .62 NO-UNDO.

DEFINE VARIABLE raShow AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "All links", "1",
"To/From", "2",
"To page", "3",
"From page", "4"
     SIZE 14.6 BY 3.81 NO-UNDO.

DEFINE RECTANGLE rctBorder
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 106.4 BY 10.

DEFINE RECTANGLE rctShow
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48.6 BY 4.57.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buShow AT ROW 7.14 COL 100.4
     coFilterSource AT ROW 2.29 COL 63.8 COLON-ALIGNED
     coLink AT ROW 3.38 COL 63.8 COLON-ALIGNED
     coFilterTarget AT ROW 4.48 COL 63.8 COLON-ALIGNED
     raShow AT ROW 6.33 COL 58.4 NO-LABEL
     coShow AT ROW 7.14 COL 71 COLON-ALIGNED NO-LABEL
     coToPage AT ROW 8.19 COL 71 COLON-ALIGNED NO-LABEL
     coFromPage AT ROW 9.24 COL 71 COLON-ALIGNED NO-LABEL
     buSource AT ROW 2.29 COL 101
     buTarget AT ROW 4.48 COL 101
     fiFilter AT ROW 1.33 COL 55.2 COLON-ALIGNED NO-LABEL
     fiShow AT ROW 5.67 COL 56.6 COLON-ALIGNED NO-LABEL
     rctShow AT ROW 5.95 COL 57.4
     rctBorder AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/ryemptysdo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/ryemptysdo.i}
      END-FIELDS.
   END-TABLES.
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
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 10
         WIDTH              = 106.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON buShow IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buSource IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buTarget IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coFilterSource IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coFilterTarget IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coFromPage IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coLink IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coShow IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coToPage IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiShow IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET raShow IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctShow IN FRAME frMain
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME buShow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buShow vTableWin
ON CHOOSE OF buShow IN FRAME frMain
DO:
  gcLocatorRequest = "SHOW":U.
  
  RUN launchLocator IN ghParentContainer (INPUT ghContainerSource, THIS-PROCEDURE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSource vTableWin
ON CHOOSE OF buSource IN FRAME frMain
DO:
  gcLocatorRequest = "SOURCE":U.
  
  RUN launchLocator IN ghParentContainer (INPUT ghContainerSource, THIS-PROCEDURE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buTarget vTableWin
ON CHOOSE OF buTarget IN FRAME frMain
DO:
  gcLocatorRequest = "TARGET":U.
  
  RUN launchLocator IN ghParentContainer (INPUT ghContainerSource, THIS-PROCEDURE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coFilterSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coFilterSource vTableWin
ON VALUE-CHANGED OF coFilterSource IN FRAME frMain /* Source */
DO:
  IF coFilterSource:SENSITIVE = TRUE THEN
    ASSIGN coFilterSource
           cOldSourceValue = coFilterSource:SCREEN-VALUE.
  
  DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U, 0.00).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coFilterTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coFilterTarget vTableWin
ON VALUE-CHANGED OF coFilterTarget IN FRAME frMain /* Target */
DO:
  IF coFilterTarget:SENSITIVE = TRUE THEN
    ASSIGN coFilterTarget
           cOldTargetValue = coFilterTarget:SCREEN-VALUE.
  
  DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U, 0.00).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coFromPage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coFromPage vTableWin
ON VALUE-CHANGED OF coFromPage IN FRAME frMain
DO:
  ASSIGN
      coFilterSource:SCREEN-VALUE   = coShow:SCREEN-VALUE
      coFilterTarget:SCREEN-VALUE   = coShow:SCREEN-VALUE.
  
  DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U, 0.00).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coLink
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coLink vTableWin
ON VALUE-CHANGED OF coLink IN FRAME frMain /* Link */
DO:
  ASSIGN coLink.

  DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U, 0.00).

  APPLY "ENTRY":U TO SELF.
  SELF:CLEAR-SELECTION().

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coShow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coShow vTableWin
ON VALUE-CHANGED OF coShow IN FRAME frMain
DO:
  ASSIGN
      coFilterSource:SCREEN-VALUE   = coShow:SCREEN-VALUE
      coFilterTarget:SCREEN-VALUE   = coShow:SCREEN-VALUE.
  
  DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U, 0.00).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coToPage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coToPage vTableWin
ON VALUE-CHANGED OF coToPage IN FRAME frMain
DO:
  ASSIGN
      coFilterSource:SCREEN-VALUE   = coShow:SCREEN-VALUE
      coFilterTarget:SCREEN-VALUE   = coShow:SCREEN-VALUE.
  
  DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U, 0.00).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raShow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raShow vTableWin
ON VALUE-CHANGED OF raShow IN FRAME frMain
DO:
  ASSIGN raShow.
  
  DYNAMIC-FUNCTION("setFilterSensitivity":U).
  DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U, 0.00).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects vTableWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildCombo vTableWin 
PROCEDURE buildCombo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLinkNames  AS CHARACTER  NO-UNDO.

  ASSIGN
      cLinkNames = DYNAMIC-FUNCTION("getLinkNames":U)
      clinkNames = "<All>":U + CHR(3) + cLinkNames

      coLink:DELIMITER  IN FRAME {&FRAME-NAME} = CHR(3)
      coLink:LIST-ITEMS IN FRAME {&FRAME-NAME} = cLinkNames.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearFilters vTableWin 
PROCEDURE clearFilters :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  coLink:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = ENTRY(1, coLink:LIST-ITEMS, coLink:DELIMITER).

  RUN setupMaintenance.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createBrowse vTableWin 
PROCEDURE createBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Creates the page browse.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryPrepare     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFieldLoop        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE httObjectInstance AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httSmartLink      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hColumn           AS HANDLE     NO-UNDO EXTENT 11.
  DEFINE VARIABLE hBuffer           AS HANDLE     NO-UNDO.
  
  SESSION:SET-WAIT-STATE("GENERAL":U).

  ASSIGN
      httObjectInstance = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectInstance":U))
      httSmartLink      = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttSmartLink":U)).
  
  CREATE BUFFER ghSOInstance  FOR TABLE httObjectInstance BUFFER-NAME "ttSourceObjectInstance":U.
  CREATE BUFFER ghTOInstance  FOR TABLE httObjectInstance BUFFER-NAME "ttTargetObjectInstance":U.
  CREATE BUFFER ghSmartLink   FOR TABLE httSmartLink.
  CREATE QUERY  ghQuery.

  ghQuery:SET-BUFFERS(ghSmartLink,
                      ghSOInstance,
                      ghTOInstance).

  CREATE BROWSE ghBrowse
  ASSIGN FRAME                  = FRAME {&FRAME-NAME}:HANDLE
         NAME                   = "LinkBrowse"
         SEPARATORS             = TRUE
         ROW-MARKERS            = FALSE
         EXPANDABLE             = TRUE
         COLUMN-RESIZABLE       = TRUE
         ALLOW-COLUMN-SEARCHING = TRUE
         QUERY                  = ghQuery
         REFRESHABLE            = YES
  TRIGGERS:            
      ON "START-SEARCH":U   PERSISTENT RUN trgStartSearch   IN THIS-PROCEDURE.
      ON "VALUE-CHANGED":U  PERSISTENT RUN trgValueChanged  IN THIS-PROCEDURE.
      ON "ROW-DISPLAY":U    PERSISTENT RUN trgRowDisplay    IN THIS-PROCEDURE.
  END TRIGGERS.

  ASSIGN
      hColumn[1]  = ghBrowse:ADD-LIKE-COLUMN(ghSOInstance:BUFFER-FIELD("c_instance_name":U))
      hColumn[2]  = ghBrowse:ADD-LIKE-COLUMN(ghSOInstance:BUFFER-FIELD("i_page":U))
      hColumn[3]  = ghBrowse:ADD-LIKE-COLUMN(ghSOInstance:BUFFER-FIELD("i_row":U))
      hColumn[4]  = ghBrowse:ADD-CALC-COLUMN("CHAR":U, "X":U, "":U, "C":U)
      hColumn[5]  = ghBrowse:ADD-LIKE-COLUMN(ghSOInstance:BUFFER-FIELD("c_lcr":U))
      hColumn[6]  = ghBrowse:ADD-LIKE-COLUMN( ghSmartLink:BUFFER-FIELD("c_link_name":U))
      hColumn[7]  = ghBrowse:ADD-LIKE-COLUMN(ghTOInstance:BUFFER-FIELD("c_instance_name":U))
      hColumn[8]  = ghBrowse:ADD-LIKE-COLUMN(ghTOInstance:BUFFER-FIELD("i_page":U))
      hColumn[9]  = ghBrowse:ADD-LIKE-COLUMN(ghTOInstance:BUFFER-FIELD("i_row":U))
      hColumn[10] = ghBrowse:ADD-CALC-COLUMN("CHAR":U, "X":U, "":U, "C":U)
      hColumn[11] = ghBrowse:ADD-LIKE-COLUMN(ghTOInstance:BUFFER-FIELD("c_lcr":U))

      hColumn[1]:LABEL = "Source"
      hColumn[7]:LABEL = "Target"
      hColumn[4]:NAME  = "i_scolumn":U
      hColumn[10]:NAME = "i_tcolumn":U
      ghSColumn        = hColumn[4]
      ghTColumn        = hColumn[10].

  DO iFieldLoop = 1 TO ghBrowse:NUM-COLUMNS:
    cEntry = ENTRY(iFieldLoop, gcColumnWidths, "^":U).

    IF INTEGER(cEntry) <> 0 THEN
      hColumn[iFieldLoop]:WIDTH-PIXELS = INTEGER(cEntry).
  END.

  /* And show the browse to the user */
  ASSIGN
      ghBrowse:SENSITIVE = TRUE
      ghBrowse:VISIBLE   = YES
      gcBaseQueryAll     = "FOR EACH ttSmartLink":U
                         + "   WHERE ttSmartLink.c_action <> 'D'":U
                         + "     AND ttSmartLink.c_link_name = ttSmartLink.c_link_name,":U
                         + "   FIRST ttSourceObjectInstance":U
                         + "   WHERE ttSourceObjectInstance.d_object_instance_obj = ttSmartLink.d_source_object_instance_obj":U
                         + "     AND ttSourceObjectInstance.c_instance_name       = ttSourceObjectInstance.c_instance_name":U
                         + "     AND ttSourceObjectInstance.c_action             <> 'D',":U
                         + "   FIRST ttTargetObjectInstance":U
                         + "   WHERE ttTargetObjectInstance.d_object_instance_obj = ttSmartLink.d_target_object_instance_obj":U
                         + "     AND ttTargetObjectInstance.c_instance_name       = ttTargetObjectInstance.c_instance_name":U
                         + "     AND ttTargetObjectInstance.c_action             <> 'D'":U.

  SESSION:SET-WAIT-STATE("":U).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject vTableWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE cPreferences  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColumn       AS INTEGER    NO-UNDO.

  cPreferences = "DefaultSort":U  + "|":U + gcCurrentSort        + "|":U
               + "ShowFilter":U   + "|":U + STRING(glShowFilter) + "|":U
               + "ColumnWidths":U + "|":U.

  DO iColumn = 1 TO ghBrowse:NUM-COLUMNS:
    cPreferences = cPreferences + STRING(ghBrowse:GET-BROWSE-COLUMN(iColumn):WIDTH-PIXELS) + "^":U.
  END.

  cPreferences = TRIM(cPreferences, "^":U).

  IF VALID-HANDLE(gshProfileManager) THEN
    RUN setProfileData IN gshProfileManager (INPUT "Window":U,        /* Profile type code      */
                                             INPUT "CBuilder":U,      /* Profile code           */
                                             INPUT "LinkPreferences", /* Profile data key       */
                                             INPUT ?,                 /* Rowid of profile data  */
                                             INPUT cPreferences,      /* Profile data value     */
                                             INPUT NO,                /* Delete flag            */
                                             INPUT "PER":U).          /* Save flag (permanent)  */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  IF VALID-HANDLE(ghSOInstance) THEN DELETE OBJECT ghSOInstance.
  IF VALID-HANDLE(ghTOInstance) THEN DELETE OBJECT ghTOInstance.
  IF VALID-HANDLE(ghSmartLink)  THEN DELETE OBJECT ghSmartLink.
  IF VALID-HANDLE(ghBrowse)     THEN DELETE OBJECT ghBrowse.
  IF VALID-HANDLE(ghQuery)      THEN DELETE OBJECT ghQuery.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getProfileData vTableWin 
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
      gcColumnWidths  = "0^0^0^0^0^0^0^0^0^0^0":U
      gcCurrentSort   = " BY ttSmartLink.c_link_name ":U.
  
  IF VALID-HANDLE(gshProfileManager) THEN
    RUN getProfileData IN gshProfileManager (INPUT "Window":U,          /* Profile type code     */
                                             INPUT "CBuilder":U,        /* Profile code          */
                                             INPUT "LinkPreferences":U, /* Profile data key      */
                                             INPUT "NO":U,              /* Get next record flag  */
                                             INPUT-OUTPUT rRowid,       /* Rowid of profile data */
                                             OUTPUT cPrefs).            /* Found profile data.   */

  /* --- Preference lookup --------------------- */ /* --- Preference value assignment -------------------------------------------- */
  iEntry = LOOKUP("ColumnWidths":U, cPrefs, "|":U). IF iEntry <> 0 THEN gcColumnWidths = ENTRY(iEntry + 1, cPrefs, "|":U).
  iEntry = LOOKUP("DefaultSort":U,  cPrefs, "|":U). IF iEntry <> 0 THEN gcCurrentSort  = ENTRY(iEntry + 1, cPrefs, "|":U).
  iEntry = LOOKUP("ShowFilter":U,   cPrefs, "|":U). IF iEntry <> 0 THEN glShowFilter   = (ENTRY(iEntry + 1, cPrefs, "|":U) = "yes":U).

  /* glShowFilter is inverted because a call to toolbar in the container is made as part of initialization. This will have the same
     effect as clicking on the filter icon which will then hide / show the filter again */
  glShowFilter = NOT glShowFilter.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTSmartLink vTableWin 
PROCEDURE getTTSmartLink :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*  DEFINE INPUT PARAMETER TABLE FOR ttSmartLink.
  DEFINE       PARAMETER BUFFER    ttSmartLink FOR ttSmartLink.
  
  DEFINE BUFFER bttSmartLink FOR ttSmartLink.

  FIND FIRST bttSmartLink
       WHERE bttSmartLink.d_source_object_instance_obj = ttSmartLink.d_source_object_instance_obj
         AND bttSmartLink.d_target_object_instance_obj = ttSmartLink.d_target_object_instance_obj
         AND bttSmartLink.d_smartlink_type_obj         = ttSmartLink.d_smartlink_type_obj.

  DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U, bttSmartLink.d_smartlink_obj).
  
  RUN getTTSmartLink IN ghParentContainer (INPUT TABLE ttSmartLink).
*/  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        coShow:DELIMITER         = CHR(3)
        coFilterSource:DELIMITER = CHR(3)
        coFilterTarget:DELIMITER = CHR(3)
        coFromPage:DELIMITER     = CHR(3)
        coToPage:DELIMITER       = CHR(3).
  END.

  {get ContainerSource ghContainerSource}.
  {get ContainerHandle ghContainerHandle ghContainerSource}.
  {get ContainerSource ghParentContainer ghContainerSource}.

  SUBSCRIBE TO "objectLocated":U IN THIS-PROCEDURE.
  SUBSCRIBE TO "clearFilters":U  IN ghParentContainer.

  gcTitle = ghContainerHandle:TITLE.

  RUN getProfileData.
  RUN createBrowse.
  RUN buildCombo.
  RUN toolbar IN ghContainerSource (INPUT "ShowFilter":U).

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN resizeObject (INPUT FRAME {&FRAME-NAME}:HEIGHT-CHARS, INPUT FRAME {&FRAME-NAME}:WIDTH-CHARS).
  coLink:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "<All>":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectLocated vTableWin 
PROCEDURE objectLocated :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdObjectInstanceObj  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE httObjectInstance AS HANDLE     NO-UNDO.

  httObjectInstance = WIDGET-HANDLE(DYNAMIC-FUNCTIOn("getUserProperty":U IN ghParentContainer, "ttObjectInstance":U)).

  CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.

  httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = ":U + QUOTER(pdObjectInstanceObj)).

  DO WITH FRAME {&FRAME-NAME}:

    CASE gcLocatorRequest:
      WHEN "SOURCE":U THEN
      DO:
        coFilterSource:SCREEN-VALUE = httObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE.
        APPLY "VALUE-CHANGED":U TO coFilterSource.
      END.

      WHEN "TARGET":U THEN
      DO:
        coFilterTarget:SCREEN-VALUE = httObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE.
        APPLY "VALUE-CHANGED":U TO coFilterTarget.
      END.

      WHEN "SHOW":U THEN
      DO:
        coShow:SCREEN-VALUE = httObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE.
        APPLY "VALUE-CHANGED":U TO coShow.
      END.
    END CASE.
  END.

  DELETE OBJECT httObjectInstance.
  httObjectInstance = ?.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshData vTableWin 
PROCEDURE refreshData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdObjNumber  AS DECIMAL    NO-UNDO.

  IF {fnarg getUserProperty 'DisplayNow':U ghContainerSource} <> "No":U THEN
    gdSmartLinkObj = pdObjNumber.
  
  CASE pcAction:
    WHEN "NewData":U THEN
    DO:
      IF {fnarg getUserProperty 'DisplayNow':U ghContainerSource} <> "No":U THEN
        RUN setupMaintenance.
      ELSE
        DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U, gdSmartLinkObj).
    END.
    
    WHEN "Updated":U THEN
      IF ghQuery:NUM-RESULTS > 0 THEN
        ghBrowse:REFRESH().
  END CASE.

  IF ghContainerHandle   = CURRENT-WINDOW AND
     ghQuery:NUM-RESULTS > 0              THEN
    APPLY "ENTRY":U TO ghBrowse.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject vTableWin 
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
      dFrameHeight = FRAME {&FRAME-NAME}:HEIGHT-CHARS
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
      FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight
      FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth.

  IF lResizedObjects = FALSE THEN
    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth).

  VIEW FRAME {&FRAME-NAME}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeViewerObjects vTableWin 
PROCEDURE resizeViewerObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight   AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth    AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE dDifference AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hSideLabel  AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        rctBorder:HEIGHT-CHARS = pdHeight
        rctBorder:WIDTH-CHARS  = pdWidth
        dDifference            = (pdWidth - fiFilter:WIDTH-CHARS - 0.75) - fiFilter:COLUMN

        coFilterSource:COLUMN  = coFilterSource:COLUMN + dDifference
        coFilterTarget:COLUMN  = coFilterTarget:COLUMN + dDifference
        coFromPage:COLUMN      = coFromPage:COLUMN     + dDifference
        coToPage:COLUMN        = coToPage:COLUMN       + dDifference
        fiFilter:COLUMN        = fiFilter:COLUMN       + dDifference
        buSource:COLUMN        = buSource:COLUMN       + dDifference
        buTarget:COLUMN        = buTarget:COLUMN       + dDifference
        coLink:COLUMN          = coLink:COLUMN         + dDifference
        fiShow:COLUMN          = fiShow:COLUMN         + dDifference
        raShow:COLUMN          = raShow:COLUMN         + dDifference
        coShow:COLUMN          = coShow:COLUMN         + dDifference
        buShow:COLUMN          = buShow:COLUMN         + dDifference
        rctShow:COLUMN         = fiFilter:COLUMN       - 0.25

        coFilterSource:SIDE-LABEL-HANDLE:COLUMN = coFilterSource:SIDE-LABEL-HANDLE:COLUMN + dDifference
        coFilterTarget:SIDE-LABEL-HANDLE:COLUMN = coFilterTarget:SIDE-LABEL-HANDLE:COLUMN + dDifference
        coLink:SIDE-LABEL-HANDLE:COLUMN         = coLink:SIDE-LABEL-HANDLE:COLUMN         + dDifference.

    IF VALID-HANDLE(ghBrowse) THEN
      ASSIGN
          ghBrowse:ROW          = fiFilter:ROW /*rctFilter:ROW + rctFilter:HEIGHT-CHARS +*/
          ghBrowse:COLUMN       = 2.35
          ghBrowse:WIDTH-CHARS  = (IF glShowFilter = TRUE THEN fiFilter:COLUMN - 4.00 ELSE pdWidth - 3.00)
          ghBrowse:HEIGHT-CHARS = pdHeight - (2 * (ghBrowse:ROW - rctBorder:ROW)) /*- fiFilter:ROW*/ .
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setupMaintenance vTableWin 
PROCEDURE setupMaintenance :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContainerMode    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cListItemPairs    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTitle            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainerHandle  AS HANDLE     NO-UNDO.
  
  {get ContainerHandle hContainerHandle ghParentContainer}.

  ghContainerHandle:TITLE = gcTitle + " ":U + (IF NUM-ENTRIES(hContainerHandle:TITLE, "-") >= 2 THEN TRIM(ENTRY(2, hContainerHandle:TITLE, "-":U)) ELSE "":U).

  IF {fnarg getUserProperty 'SameContainer'} <> "yes":U THEN
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        cListItemPairs              = DYNAMIC-FUNCTION("getListItemPairs":U)
        coFilterSource:LIST-ITEMS   = "<All>":U + coFilterSource:DELIMITER + cListItemPairs
        coFromPage:LIST-ITEM-PAIRS  = DYNAMIC-FUNCTION("getPageItemPairs":U)
        coToPage:LIST-ITEM-PAIRS    = coFromPage:LIST-ITEM-PAIRS
        coFilterSource:SCREEN-VALUE = "<All>":U
        coFilterTarget:LIST-ITEMS   = coFilterSource:LIST-ITEMS
        coFilterTarget:SCREEN-VALUE = "<All>":U
        coShow:LIST-ITEMS           = "<All>":U + coFilterSource:DELIMITER + cListItemPairs
        coFromPage:SCREEN-VALUE     = ENTRY(2, coFromPage:LIST-ITEM-PAIRS, coFromPage:DELIMITER)
        coToPage:SCREEN-VALUE       = ENTRY(2, coToPage:LIST-ITEM-PAIRS,   coToPage:DELIMITER)
        coShow:SCREEN-VALUE         = "<All>":U
        raShow:SCREEN-VALUE         = "1":U
        .

  END.

  APPLY "VALUE-CHANGED":U TO raShow.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgRowDisplay vTableWin 
PROCEDURE trgRowDisplay :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ghSColumn:SCREEN-VALUE = KEY-LABEL(KEY-CODE("A") + ghSOInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE - 1).
  ghTColumn:SCREEN-VALUE = KEY-LABEL(KEY-CODE("A") + ghTOInstance:BUFFER-FIELD("i_column":U):BUFFER-VALUE - 1).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgStartSearch vTableWin 
PROCEDURE trgStartSearch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumnName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dSmartLinkObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hColumn       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer       AS HANDLE     NO-UNDO.

  IF ghQuery:NUM-RESULTS > 0 THEN
  DO:
    IF NOT ghBrowse:SELECT-FOCUSED-ROW() THEN
      ghBrowse:SELECT-ROW(1).

    dSmartLinkObj = ghSmartLink:BUFFER-FIELD("d_smartlink_obj":U):BUFFER-VALUE.
  END.    /* records available */
  ELSE
    dSmartLinkObj = 0.00.

  /* Determine the new row. */
  ASSIGN
      hColumn       = ghBrowse:CURRENT-COLUMN
      cColumnName   = hColumn:NAME
      cColumnName   = (IF cColumnName = "i_scolumn":U OR cColumnName = "i_tcolumn":U THEN "i_column":U ELSE cColumnName).

  IF VALID-HANDLE(hColumn:BUFFER-FIELD) THEN
    cTableName = hColumn:BUFFER-FIELD:BUFFER-HANDLE:NAME.
  ELSE
    IF hColumn:NAME = "i_scolumn":U THEN
      cTableName = ghSOInstance:NAME.
    ELSE
      cTableName = ghTOInstance:NAME.

      gcCurrentSort = " BY ":U  + cTableName + (IF cTableName = ? THEN "":U ELSE ".":U) + cColumnName + " ":U.

  DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U, dSmartLinkObj).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgValueChanged vTableWin 
PROCEDURE trgValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF {fnarg getUserProperty 'DisplayNow':U ghContainerSource} = "No":U THEN
    RETURN.

  IF DYNAMIC-FUNCTION("transferActive":U IN ghParentContainer) = TRUE THEN
    RETURN.

  IF ghSmartLink:AVAILABLE  = FALSE OR
     ghQuery:NUM-RESULTS   <= 0     THEN
    gdSmartLinkObj = ?.
  ELSE
  DO:
    ghBrowse:SELECT-FOCUSED-ROW() NO-ERROR.
    
    gdSmartLinkObj = ghSmartLink:BUFFER-FIELD("d_smartlink_obj":U):BUFFER-VALUE.
  END.

  PUBLISH "RowSelected":U FROM THIS-PROCEDURE (INPUT gdSmartLinkObj).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHasData vTableWin 
FUNCTION getHasData RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lHasData  AS LOGICAL      NO-UNDO INITIAL FALSE.
  
  IF ghQuery:NUM-RESULTS <> ? AND
     ghQuery:NUM-RESULTS  > 0 THEN
    lHasData = TRUE.
  
  RETURN lHasData.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLinkNames vTableWin 
FUNCTION getLinkNames RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE httSmartLinkType  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery            AS HANDLE     NO-UNDO.
  
  IF gcLinkNames = "":U THEN
  DO:
    httSmartLinkType = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttSmartLinkType":U)).

    CREATE BUFFER httSmartLinkType FOR TABLE httSmartLinkType.
    CREATE QUERY  hQuery.

    hQuery:SET-BUFFERS(httSmartLinkType).
    hQuery:QUERY-PREPARE("FOR EACH ttSmartLinkType BY ttSmartLinkType.c_link_name":U).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().

    DO WHILE NOT hQuery:QUERY-OFF-END:
      gcLinkNames = gcLinkNames + (IF gcLinkNames = "":U THEN "":U ELSE CHR(3))
                  + httSmartLinkType:BUFFER-FIELD("c_link_name":U):BUFFER-VALUE.

      IF httSmartLinkType:BUFFER-FIELD("l_user_defined_link":U):BUFFER-VALUE THEN
        ASSIGN
            gcUserDefinedLinks = gcUserDefinedLinks + (IF gcUserDefinedLinks = "":U THEN "":U ELSE CHR(3))
                               + httSmartLinkType:BUFFER-FIELD("c_link_name":U):BUFFER-VALUE.

      hQuery:GET-NEXT().
    END.
    
    DELETE OBJECT httSmartLinkType.
    DELETE OBJECT hQuery.

    ASSIGN
        httSmartLinkType = ?
        hQuery           = ?.
  END.

  RETURN gcLinkNames.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getListItemPairs vTableWin 
FUNCTION getListItemPairs RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cListItemPairs          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInstanceName           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE bhttObjectInstance      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery                  AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultObj":U))
        httObjectInstance       = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectInstance":U))
        cListItemPairs          = "":U
        cListItemPairs          = "THIS-OBJECT":U /*
                                + coFilterSource:DELIMITER + "THIS-OBJECT":U*/ .
    
    CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.
    CREATE QUERY  hQuery.

    hQuery:SET-BUFFERS(httObjectInstance).
    hQuery:QUERY-PREPARE("FOR EACH ttObjectInstance":U
                         + " WHERE ttObjectInstance.d_object_instance_obj <> 0":U
                         + "   AND ttObjectInstance.c_action              <> 'D'":U
                         + "    BY ttObjectInstance.c_instance_name":U).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().

    DO WHILE NOT hQuery:QUERY-OFF-END:
      cInstanceName = httObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE.

      IF LOOKUP(cInstanceName, cListItemPairs, coFilterSource:DELIMITER) = 0 THEN
        ASSIGN
            cListItemPairs = cListItemPairs
                           + (IF cListItemPairs = "":U THEN "":U ELSE coFilterSource:DELIMITER)
                           + TRIM(cInstanceName) /*+ coFilterSource:DELIMITER
                           + TRIM(cInstanceName)*/ .

      hQuery:GET-NEXT().
    END.

    DELETE OBJECT httObjectInstance.
    DELETE OBJECT hQuery.

    ASSIGN
        httObjectInstance = ?
        hQuery            = ?.
  END.

  RETURN cListItemPairs.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPageItemPairs vTableWin 
FUNCTION getPageItemPairs RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cListItemPairs          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPageSequence           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE bhttPage                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httPage                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery                  AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultObj":U))
        httPage                 = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttPage":U))
        cListItemPairs          = "":U.
    
    CREATE BUFFER httPage FOR TABLE httPage.
    CREATE QUERY  hQuery.

    hQuery:SET-BUFFERS(httPage).
    hQuery:QUERY-PREPARE("FOR EACH ttPage":U
                         + " WHERE ttPage.d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)
                         + "   AND ttPage.c_action              <> 'D'":U
                         + "    BY ttPage.i_page_sequence":U).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().

    DO WHILE NOT hQuery:QUERY-OFF-END:
      iPageSequence = httPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE.

      IF LOOKUP(iPageSequence, cListItemPairs, coFromPage:DELIMITER) = 0 THEN
        ASSIGN
            cListItemPairs = cListItemPairs
                           + (IF cListItemPairs = "":U THEN "":U ELSE coFromPage:DELIMITER)
                           + TRIM(REPLACE(httPage:BUFFER-FIELD("c_page_label":U):BUFFER-VALUE, "&":U, "":U)) + coFromPage:DELIMITER
                           + TRIM(STRING(iPageSequence)) .

      hQuery:GET-NEXT().
    END.

    DELETE OBJECT httPage.
    DELETE OBJECT hQuery.

    ASSIGN
        httPage = ?
        hQuery  = ?.
  END.

  RETURN cListItemPairs.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getShowFilter vTableWin 
FUNCTION getShowFilter RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN glShowFilter.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUserDefinedLinks vTableWin 
FUNCTION getUserDefinedLinks RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcUserDefinedLinks.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION reopenBrowseQuery vTableWin 
FUNCTION reopenBrowseQuery RETURNS LOGICAL
    (pcSubstituteList AS CHARACTER,
     pdSmartLinkObj   AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  Opens the query for the specified browse.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSubstituteList AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE cBaseQuery      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntries        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSuccess        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httSmartLink    AS HANDLE     NO-UNDO.
  
  httSmartLink = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttSmartLink":U)).

  IF NOT VALID-HANDLE(httSmartLink) THEN
    RETURN FALSE.

  CREATE BUFFER httSmartLink FOR TABLE httSmartLink.
/*
  DEFINE BUFFER ttSmartLink FOR ttSmartLink.
*/  
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
          coFilterSource
          coFilterTarget
          coLink
          raShow

          cBaseQuery = gcBaseQueryAll.

    CASE raShow:SCREEN-VALUE:
      /* All */
      WHEN "1":U THEN
      DO:
        IF coFilterSource:SCREEN-VALUE <> "<All>":U THEN
          cBaseQuery = REPLACE(cBaseQuery, "= ttSourceObjectInstance.c_instance_name":U, "= '":U + coFilterSource:SCREEN-VALUE + "'":U).
          
        IF coFilterTarget:SCREEN-VALUE <> "<All>":U THEN
          cBaseQuery = REPLACE(cBaseQuery, "= ttTargetObjectInstance.c_instance_name":U, "= '":U + coFilterTarget:SCREEN-VALUE + "'":U).
      END.
      
      /* To/From */
      WHEN "2":U THEN
      DO:
        IF coShow:SCREEN-VALUE <> "<All>":U THEN
          cBaseQuery = cBaseQuery
                     + " AND (ttSourceObjectInstance.c_instance_name = '":U + coShow:SCREEN-VALUE + "'":U
                     + "  OR  ttTargetObjectInstance.c_instance_name = '":U + coShow:SCREEN-VALUE + "')":U.
      END.
      
      /* To page */
      WHEN "3":U THEN
        cBaseQuery = cBaseQuery + " AND ttTargetObjectInstance.i_page = ":U + coToPage:SCREEN-VALUE.

      /* From page */
      WHEN "4":U THEN
        cBaseQuery = cBaseQuery + " AND ttSourceObjectInstance.i_page = ":U + coFromPage:SCREEN-VALUE.
    END CASE.
    
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

    IF coLink:SCREEN-VALUE <> "<All>":U AND
       coLink:SCREEN-VALUE <> ?         THEN
      cBaseQuery = REPLACE(cBaseQuery, "= ttSmartLink.c_link_name":U, "= '":U + coLink:SCREEN-VALUE + "'":U).

    /* Always reopen, in case the sort has changed. */
    gcCurrentSort = (IF INDEX(gcCurrentSort, ".i_scolumn":U) <> 0 THEN REPLACE(gcCurrentSort, ".i_scolumn":U, ".i_column":U) ELSE gcCurrentSort).
    gcCurrentSort = (IF INDEX(gcCurrentSort, ".i_tcolumn":U) <> 0 THEN REPLACE(gcCurrentSort, ".i_tcolumn":U, ".i_column":U) ELSE gcCurrentSort).

    lSuccess = ghQuery:QUERY-PREPARE(cBaseQuery + gcCurrentSort) NO-ERROR.

    IF NOT lSuccess THEN
      ghQuery:QUERY-PREPARE(cBaseQuery).

    IF ghQuery:IS-OPEN THEN
       ghQuery:QUERY-CLOSE().
  
    ghQuery:QUERY-OPEN().

    IF ghContainerHandle = CURRENT-WINDOW THEN
      APPLY "ENTRY":U TO ghBrowse.

    IF ghQuery:NUM-RESULTS > 0 THEN
    DO:
      httSmartLink:FIND-FIRST("WHERE d_smartlink_obj = ":U + QUOTER(gdSmartLinkObj)) NO-ERROR.

      IF httSmartLink:AVAILABLE THEN
        lSuccess = ghQuery:REPOSITION-TO-ROWID(httSmartLink:ROWID) NO-ERROR.

      IF lSuccess = FALSE THEN
        APPLY "VALUE-CHANGED":U TO ghBrowse.
    END.
  
    RUN trgValueChanged.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseSensitivity vTableWin 
FUNCTION setBrowseSensitivity RETURNS LOGICAL
  (plSensitive AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ghBrowse:SENSITIVE = plSensitive.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFilterSensitivity vTableWin 
FUNCTION setFilterSensitivity RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    CASE raShow:SCREEN-VALUE:
      WHEN "1":U THEN
      DO:
        ASSIGN
            coFilterSource:SENSITIVE    = TRUE
            coFilterTarget:SENSITIVE    = TRUE
            buSource:SENSITIVE          = TRUE
            buTarget:SENSITIVE          = TRUE
            coShow:SENSITIVE            = FALSE
            buShow:SENSITIVE            = FALSE
            coFromPage:SENSITIVE        = FALSE
            coToPage:SENSITIVE          = FALSE.
            
        IF INDEX(coFilterSource:LIST-ITEMS, cOldSourceValue) <> 0 THEN coFilterSource:SCREEN-VALUE = cOldSourceValue.
        IF INDEX(coFilterTarget:LIST-ITEMS, cOldTargetValue) <> 0 THEN coFilterTarget:SCREEN-VALUE = cOldTargetValue.
      END.
      
      WHEN "2":U THEN
        ASSIGN
            coFilterSource:SCREEN-VALUE = coShow:SCREEN-VALUE
            coFilterTarget:SCREEN-VALUE = coShow:SCREEN-VALUE
            coFilterSource:SENSITIVE    = FALSE
            coFilterTarget:SENSITIVE    = FALSE
            buSource:SENSITIVE          = FALSE
            buTarget:SENSITIVE          = FALSE
            coShow:SENSITIVE            = TRUE
            buShow:SENSITIVE            = TRUE
            coFromPage:SENSITIVE        = FALSE
            coToPage:SENSITIVE          = FALSE.
      
      WHEN "3":U THEN
        ASSIGN
            coFilterSource:SCREEN-VALUE = coShow:SCREEN-VALUE
            coFilterTarget:SCREEN-VALUE = coShow:SCREEN-VALUE
            coFilterSource:SENSITIVE    = FALSE
            coFilterTarget:SENSITIVE    = FALSE
            buSource:SENSITIVE          = FALSE
            buTarget:SENSITIVE          = FALSE
            coShow:SENSITIVE            = FALSE
            buShow:SENSITIVE            = FALSE
            coFromPage:SENSITIVE        = FALSE
            coToPage:SENSITIVE          = TRUE.
      
      WHEN "4":U THEN
        ASSIGN
            coFilterSource:SCREEN-VALUE = coShow:SCREEN-VALUE
            coFilterTarget:SCREEN-VALUE = coShow:SCREEN-VALUE
            coFilterSource:SENSITIVE    = FALSE
            coFilterTarget:SENSITIVE    = FALSE
            buSource:SENSITIVE          = FALSE
            buTarget:SENSITIVE          = FALSE
            coShow:SENSITIVE            = FALSE
            buShow:SENSITIVE            = FALSE
            coToPage:SENSITIVE          = FALSE
            coFromPage:SENSITIVE        = TRUE.
    END CASE.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setShowFilter vTableWin 
FUNCTION setShowFilter RETURNS LOGICAL
  (plShowFilter AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  glShowFilter = plShowFilter.

  DO WITH FRAME {&FRAME-NAME}:
    IF NOT glShowFilter THEN
    DO:
      DISABLE
          coFilterSource  buSource
          coFilterTarget  buTarget
          coShow          buShow
          coLink
          raShow.
    END.
    ELSE
    DO:
      ENABLE coLink
             raShow.

      DYNAMIC-FUNCTION("setFilterSensitivity":U).
    END.
  END.

  RUN resizeObject (INPUT FRAME {&FRAME-NAME}:HEIGHT-CHARS, INPUT FRAME {&FRAME-NAME}:WIDTH-CHARS).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION transferToExcel vTableWin 
FUNCTION transferToExcel RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {fnarg lockWindow TRUE ghContainerSource}.

  RUN transferToExcel IN ghParentContainer (INPUT ghBrowse,
                                            INPUT ghContainerSource).

  {fnarg lockWindow FALSE ghContainerSource}.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

