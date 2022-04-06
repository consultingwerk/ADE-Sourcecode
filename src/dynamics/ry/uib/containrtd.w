&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER pcLayoutType          AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pdLayoutObj           AS DECIMAL      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcObjectFilename      AS CHARACTER    NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME gDialog
&Scoped-define BROWSE-NAME brObject

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ryc_smartobject gsc_object_type ryc_layout

/* Definitions for BROWSE brObject                                      */
&Scoped-define FIELDS-IN-QUERY-brObject ryc_smartobject.object_filename ~
gsc_object_type.object_type_code ryc_smartobject.object_description ~
ryc_smartobject.static_object ryc_smartobject.template_smartobject ~
ryc_layout.layout_type 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brObject 
&Scoped-define QUERY-STRING-brObject FOR EACH ryc_smartobject ~
      WHERE ryc_smartobject.layout_obj = pdLayoutObj  AND  ~
ryc_smartobject.object_filename BEGINS fiObjectName:INPUT-VALUE IN FRAME {&FRAME-NAME} AND  ~
ryc_smartobject.customization_result_obj = 0 AND  ~
ryc_smartobject.template_smartobject = TRUE NO-LOCK, ~
      EACH gsc_object_type WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj ~
 NO-LOCK, ~
      EACH ryc_layout WHERE ryc_layout.layout_obj = ryc_smartobject.layout_obj NO-LOCK ~
    BY ryc_smartobject.object_filename INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brObject OPEN QUERY brObject FOR EACH ryc_smartobject ~
      WHERE ryc_smartobject.layout_obj = pdLayoutObj  AND  ~
ryc_smartobject.object_filename BEGINS fiObjectName:INPUT-VALUE IN FRAME {&FRAME-NAME} AND  ~
ryc_smartobject.customization_result_obj = 0 AND  ~
ryc_smartobject.template_smartobject = TRUE NO-LOCK, ~
      EACH gsc_object_type WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj ~
 NO-LOCK, ~
      EACH ryc_layout WHERE ryc_layout.layout_obj = ryc_smartobject.layout_obj NO-LOCK ~
    BY ryc_smartobject.object_filename INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brObject ryc_smartobject gsc_object_type ~
ryc_layout
&Scoped-define FIRST-TABLE-IN-QUERY-brObject ryc_smartobject
&Scoped-define SECOND-TABLE-IN-QUERY-brObject gsc_object_type
&Scoped-define THIRD-TABLE-IN-QUERY-brObject ryc_layout


/* Definitions for DIALOG-BOX gDialog                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-gDialog ~
    ~{&OPEN-QUERY-brObject}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiObjectName coLayout brObject buSelect ~
buCancel 
&Scoped-Define DISPLAYED-OBJECTS fiObjectName 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON buCancel AUTO-END-KEY 
     LABEL "&Cancel" 
     SIZE 15 BY 1.14.

DEFINE BUTTON buSelect AUTO-GO 
     LABEL "&Select" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE coLayout AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Layout" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "0",0
     DROP-DOWN-LIST
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectName AS CHARACTER FORMAT "X(35)":U 
     LABEL "Object Name" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brObject FOR 
      ryc_smartobject, 
      gsc_object_type, 
      ryc_layout SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brObject gDialog _STRUCTURED
  QUERY brObject NO-LOCK DISPLAY
      ryc_smartobject.object_filename FORMAT "X(70)":U WIDTH 44
      gsc_object_type.object_type_code FORMAT "X(15)":U
      ryc_smartobject.object_description FORMAT "X(35)":U
      ryc_smartobject.static_object FORMAT "YES/NO":U
      ryc_smartobject.template_smartobject FORMAT "YES/NO":U
      ryc_layout.layout_type FORMAT "X(3)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 130.4 BY 12.38 ROW-HEIGHT-CHARS .71 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     fiObjectName AT ROW 1.1 COL 13.8 COLON-ALIGNED
     coLayout AT ROW 1.1 COL 80.2 COLON-ALIGNED
     brObject AT ROW 2.24 COL 1.8
     buSelect AT ROW 14.71 COL 100.2
     buCancel AT ROW 14.71 COL 115.4
     SPACE(2.20) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Lookup Page Templates"
         DEFAULT-BUTTON buSelect CANCEL-BUTTON buCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
                                                                        */
/* BROWSE-TAB brObject coLayout gDialog */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

ASSIGN 
       brObject:ALLOW-COLUMN-SEARCHING IN FRAME gDialog = TRUE
       brObject:COLUMN-RESIZABLE IN FRAME gDialog       = TRUE.

/* SETTINGS FOR COMBO-BOX coLayout IN FRAME gDialog
   NO-DISPLAY                                                           */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brObject
/* Query rebuild information for BROWSE brObject
     _TblList          = "icfdb.ryc_smartobject,icfdb.gsc_object_type WHERE icfdb.ryc_smartobject ...,icfdb.ryc_layout WHERE icfdb.ryc_smartobject ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ",,,"
     _OrdList          = "icfdb.ryc_smartobject.object_filename|yes"
     _Where[1]         = "ryc_smartobject.layout_obj = pdLayoutObj  AND 
ryc_smartobject.object_filename BEGINS fiObjectName:INPUT-VALUE IN FRAME {&FRAME-NAME} AND 
ryc_smartobject.customization_result_obj = 0 AND 
ryc_smartobject.template_smartobject = TRUE"
     _JoinCode[2]      = "gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj
"
     _JoinCode[3]      = "ryc_layout.layout_obj = ryc_smartobject.layout_obj"
     _FldNameList[1]   > icfdb.ryc_smartobject.object_filename
"ryc_smartobject.object_filename" ? ? "character" ? ? ? ? ? ? no ? no no "44" yes no no "U" "" ""
     _FldNameList[2]   = icfdb.gsc_object_type.object_type_code
     _FldNameList[3]   = icfdb.ryc_smartobject.object_description
     _FldNameList[4]   = icfdb.ryc_smartobject.static_object
     _FldNameList[5]   = icfdb.ryc_smartobject.template_smartobject
     _FldNameList[6]   = icfdb.ryc_layout.layout_type
     _Query            is OPENED
*/  /* BROWSE brObject */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* Lookup Page Templates */
DO:
    APPLY "GO":U TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brObject
&Scoped-define SELF-NAME brObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brObject gDialog
ON LEFT-MOUSE-DBLCLICK OF brObject IN FRAME gDialog
DO:
    APPLY "CHOOSE":U TO buSelect.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel gDialog
ON CHOOSE OF buCancel IN FRAME gDialog /* Cancel */
DO:
    ASSIGN pcObjectFilename = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSelect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSelect gDialog
ON CHOOSE OF buSelect IN FRAME gDialog /* Select */
DO:
    IF AVAILABLE ryc_smartObject THEN
        ASSIGN pcObjectFilename = ryc_smartObject.object_filename
               pdLayoutObj      = ryc_smartObject.layout_obj 
               .
    ELSE
        ASSIGN pcObjectFilename = "":U
               pdLayoutObj      = 0
               .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coLayout gDialog
ON VALUE-CHANGED OF coLayout IN FRAME gDialog /* Layout */
DO:
    ASSIGN pdLayoutObj = coLayout:INPUT-VALUE.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObjectName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectName gDialog
ON VALUE-CHANGED OF fiObjectName IN FRAME gDialog /* Object Name */
DO:
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY fiObjectName 
      WITH FRAME gDialog.
  ENABLE fiObjectName coLayout brObject buSelect buCancel 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    /* Populate combos. */
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN coLayout:DELIMITER = CHR(3).
        RUN populateCombos.
    END.    /* with frame ... */

    RUN SUPER.

    ASSIGN fiObjectName:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pcObjectFileName
           coLayout:SENSITIVE        IN FRAME {&FRAME-NAME} = NO
           .
    APPLY "VALUE-CHANGED":U TO fiObjectName IN FRAME {&FRAME-NAME}.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateCombos gDialog 
PROCEDURE populateCombos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hCombo              AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hQuery              AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hBuffer             AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hCodeField          AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hObjField           AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE cQueryPrepare       AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cLipString          AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE iObjectTypeLoop     AS INTEGER                      NO-UNDO.
    
    DEFINE BUFFER ryc_layout        FOR ryc_layout.
    
    /* Object Type */
    ASSIGN hCombo        = coLayout:HANDLE IN FRAME {&FRAME-NAME}
           cLipString    = "":U
           cQueryPrepare = " FOR EACH ryc_layout NO-LOCK ":U
           .

    CREATE WIDGET-POOL "PopulateCombo":U.
    CREATE QUERY hQuery.
    CREATE BUFFER hBuffer FOR TABLE "ryc_layout":U IN WIDGET-POOL "populateCombo":U.
    hQuery:ADD-BUFFER(hBuffer).
    hQuery:QUERY-PREPARE(cQueryPrepare).

    ASSIGN hCodeField = hBuffer:BUFFER-FIELD("layout_name":U)
           hObjField  = hBuffer:BUFFER-FIELD("layout_obj":U)
           .
    hQuery:QUERY-OPEN().

    hQuery:GET-FIRST(NO-LOCK).
    DO WHILE hBuffer:AVAILABLE:
        ASSIGN cLipString = cLipString + (IF NUM-ENTRIES(cLipString, hCombo:DELIMITER) EQ 0 THEN "":U ELSE hCombo:DELIMITER) 
                          + (hCodeField:BUFFER-VALUE + hCombo:DELIMITER + hObjField:STRING-VALUE).
        
        hQuery:GET-NEXT(NO-LOCK).
    END.    /* avail buffer */

    hQuery:QUERY-CLOSE().
    DELETE OBJECT hQuery NO-ERROR.
    ASSIGN hQuery = ?.

    DELETE WIDGET-POOL "PopulateCombo":U.
        
    ASSIGN hCombo:LIST-ITEM-PAIRS = cLipString
           NO-ERROR.

    IF pdLayoutObj EQ 0 THEN
        ASSIGN hCombo:SCREEN-VALUE = hCombo:ENTRY(1).
    ELSE
        ASSIGN hCombo:SCREEN-VALUE = STRING(pdLayoutObj).

    APPLY "VALUE-CHANGED":U TO hCombo.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

