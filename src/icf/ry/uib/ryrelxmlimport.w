&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" wiWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" wiWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wiWin 
/*---------------------------------------------------------------------------------
  File: ryrelxmlimport.w

  Description:  Tests the loading of a relationship XML

  Purpose:      Tests the loading of a relationship XML file.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   06/22/2002  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rysttbconw.w

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

&scop object-name       ryrelxmlimport.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* object identifying preprocessor */
&glob   astra2-staticSmartWindow yes

{src/adm2/globals.i}

DEFINE VARIABLE ghRelXML        AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTable       AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghRelate      AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain
&Scoped-define BROWSE-NAME BrChild

/* Definitions for FRAME frMain                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BrTables fiFile buBrowse buLoad buErrors ~
buApply BrParent BrChild RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS fiFile 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wiWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buApply 
     LABEL "Apply" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buBrowse 
     LABEL "&Browse" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buErrors 
     LABEL "&Show Errors" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buLoad 
     LABEL "&Load" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE fiFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "File to load" 
     VIEW-AS FILL-IN 
     SIZE 68.8 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 178.8 BY 7.91.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 178.8 BY 7.43.


/* Browse definitions                                                   */
DEFINE BROWSE BrChild
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrChild wiWin _STRUCTURED
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 176.8 BY 6.95.

DEFINE BROWSE BrParent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrParent wiWin _STRUCTURED
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 176.8 BY 7.24.

DEFINE BROWSE BrTables
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrTables wiWin _STRUCTURED
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 74.4 BY 5.62 ROW-HEIGHT-CHARS .67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     BrTables AT ROW 1.29 COL 104.6
     fiFile AT ROW 1.43 COL 15 COLON-ALIGNED
     buBrowse AT ROW 1.43 COL 86.6
     buLoad AT ROW 2.76 COL 86.6
     buErrors AT ROW 4.14 COL 86.6
     buApply AT ROW 5.52 COL 86.6
     BrParent AT ROW 7.76 COL 2.2
     BrChild AT ROW 15.81 COL 2.2
     RECT-1 AT ROW 7.33 COL 1.4
     RECT-2 AT ROW 15.57 COL 1.6
     "Table is a parent in:" VIEW-AS TEXT
          SIZE 22 BY .62 AT ROW 7 COL 3
     "Table is a child in:" VIEW-AS TEXT
          SIZE 19.2 BY .62 AT ROW 15.24 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 179.6 BY 22.1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wiWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Browse Relationship XML file"
         HEIGHT             = 22.1
         WIDTH              = 179.6
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 179.6
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 179.6
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wiWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wiWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
                                                                        */
/* BROWSE-TAB BrTables 1 frMain */
/* BROWSE-TAB BrParent buApply frMain */
/* BROWSE-TAB BrChild BrParent frMain */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
THEN wiWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON END-ERROR OF wiWin /* Browse Relationship XML file */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON WINDOW-CLOSE OF wiWin /* Browse Relationship XML file */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrTables
&Scoped-define SELF-NAME BrTables
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrTables wiWin
ON VALUE-CHANGED OF BrTables IN FRAME frMain
DO:
  RUN openDependentQueries.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buApply
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buApply wiWin
ON CHOOSE OF buApply IN FRAME frMain /* Apply */
DO:
  RUN applyChanges.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buBrowse wiWin
ON CHOOSE OF buBrowse IN FRAME frMain /* Browse */
DO:
  RUN getFile.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buErrors
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buErrors wiWin
ON CHOOSE OF buErrors IN FRAME frMain /* Show Errors */
DO:
  RUN showErrors.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buLoad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buLoad wiWin
ON CHOOSE OF buLoad IN FRAME frMain /* Load */
DO:
  RUN loadXMLDoc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrChild
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wiWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wiWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyChanges wiWin 
PROCEDURE applyChanges :
/*------------------------------------------------------------------------------
  Purpose:     Apply the changes to the database.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN applyData IN ghRelXML.
    IF RETURN-VALUE <> "" THEN
      MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE associateQueryWithBrowse wiWin 
PROCEDURE associateQueryWithBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBrowse AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcWhere  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hQuery  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.

  RUN closeQuery(INPUT phBrowse, YES).
  
  CREATE BUFFER hBuffer FOR TABLE ghRelate:DEFAULT-BUFFER-HANDLE.
  
  CREATE QUERY hQuery.
  hQuery:ADD-BUFFER(hBuffer).
  hQuery:QUERY-PREPARE("FOR EACH ":U + hBuffer:NAME + " ":U + pcWhere).
  hQuery:QUERY-OPEN().
  phBrowse:QUERY = hQuery.
  phBrowse:ADD-COLUMNS-FROM(hBuffer).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE closeQueries wiWin 
PROCEDURE closeQueries :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-----------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    RUN closeQuery(INPUT BROWSE BrChild:HANDLE, YES).
    RUN closeQuery(INPUT BROWSE BrParent:HANDLE, YES).
    RUN closeQuery(INPUT BROWSE BrTables:HANDLE, NO).

  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE closeQuery wiWin 
PROCEDURE closeQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER hBrowse    AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER lDelBuffer AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery  AS HANDLE     NO-UNDO.

  IF NOT VALID-HANDLE(hBrowse) OR
     NOT VALID-HANDLE(hBrowse:QUERY) THEN 
    RETURN.

  IF lDelBuffer THEN
    hBuffer = hBrowse:QUERY:GET-BUFFER-HANDLE(1).

  hQuery = hBrowse:QUERY.
  hBrowse:QUERY = ?.  
  hQuery:QUERY-CLOSE().
  DELETE OBJECT hQuery.

  IF lDelBuffer THEN
    DELETE OBJECT hBuffer.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wiWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
  THEN DELETE WIDGET wiWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wiWin  _DEFAULT-ENABLE
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
  DISPLAY fiFile 
      WITH FRAME frMain IN WINDOW wiWin.
  ENABLE fiFile buBrowse buLoad buErrors buApply RECT-1 RECT-2 
      WITH FRAME frMain IN WINDOW wiWin.
  {&OPEN-BROWSERS-IN-QUERY-frMain}
  VIEW wiWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wiWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFile wiWin 
PROCEDURE getFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lAns  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cFile AS CHARACTER  NO-UNDO.

  SYSTEM-DIALOG GET-FILE cFile   
    FILTERS "XML Files (*.xml)" "*.xml",
            "All Files (*.*)" "*.*"
    MUST-EXIST 
    RETURN-TO-START-DIR
    TITLE "Open"
    USE-FILENAME
    UPDATE lAns
    IN WINDOW {&WINDOW-NAME}
  .

  DO WITH FRAME {&FRAME-NAME}:
    IF lAns THEN
      fiFile:SCREEN-VALUE = cFile.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wiWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Start the XML helper API */
  RUN startProcedure IN THIS-PROCEDURE ("ONCE|ry/prc/ryrelxmlp.p":U, 
                                        OUTPUT ghRelXML).


  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadXMLDoc wiWin 
PROCEDURE loadXMLDoc :
/*------------------------------------------------------------------------------
  Purpose:     Loads the XML doc into the temp-tables and obtains the handles
               to the temp-table to display in the browses.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTableBrowse AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTableQuery  AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    RUN closeQueries. 

    RUN loadRelationshipXML IN ghRelXML
      (INPUT fiFile:SCREEN-VALUE).
    
    RUN prepareDataForLoad IN ghRelXML.

    RUN obtainRelationTables IN ghRelXML
      (OUTPUT ghTable, OUTPUT ghRelate).

    hTableBrowse = BROWSE BrTables:HANDLE.

    CREATE QUERY hTableQuery.
    hTableQuery:ADD-BUFFER(ghTable:DEFAULT-BUFFER-HANDLE).
    hTableQuery:QUERY-PREPARE("FOR EACH ":U + ghTable:DEFAULT-BUFFER-HANDLE:NAME).
    hTableQuery:QUERY-OPEN().
    hTableBrowse:QUERY = hTableQuery.
    hTableBrowse:ADD-COLUMNS-FROM(ghTable:DEFAULT-BUFFER-HANDLE).

  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openDependentQueries wiWin 
PROCEDURE openDependentQueries :
/*------------------------------------------------------------------------------
  Purpose:     Opens the queries for the parent and child relationships.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBrowse AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cWhere  AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    hBuffer = BROWSE BrTables:QUERY:GET-BUFFER-HANDLE(1).

    hBrowse = BROWSE BrParent:HANDLE.
    IF  hBuffer:BUFFER-FIELD("cEntityMnemonic"):BUFFER-VALUE <> ? AND
        hBuffer:BUFFER-FIELD("cEntityMnemonic"):BUFFER-VALUE <> "":U THEN
      cWhere = "WHERE parent_entity = '" + hBuffer:BUFFER-FIELD("cEntityMnemonic"):BUFFER-VALUE + "'".
    ELSE
      cWhere =  "WHERE ParentDBName = '" + hBuffer:BUFFER-FIELD("cTableDB"):BUFFER-VALUE + "' AND " + "parent_entity = '" + hBuffer:BUFFER-FIELD("cTableName"):BUFFER-VALUE + "'".
    RUN associateQueryWithBrowse
      (hBrowse,cWhere ).

    hBrowse = BROWSE BrChild:HANDLE.
    IF  hBuffer:BUFFER-FIELD("cEntityMnemonic"):BUFFER-VALUE <> ? AND
        hBuffer:BUFFER-FIELD("cEntityMnemonic"):BUFFER-VALUE <> "":U THEN
      cWhere = "WHERE child_entity = '" + hBuffer:BUFFER-FIELD("cEntityMnemonic"):BUFFER-VALUE + "'".
    ELSE
      cWhere = "WHERE ChildDBName = '" + hBuffer:BUFFER-FIELD("cTableDB"):BUFFER-VALUE + "' AND " + "child_entity = '" + hBuffer:BUFFER-FIELD("cTableName"):BUFFER-VALUE + "'".
    RUN associateQueryWithBrowse
      (hBrowse, cWhere).
  

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showErrors wiWin 
PROCEDURE showErrors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBrowse AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cWhere  AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    hBuffer = BROWSE BrTables:QUERY:GET-BUFFER-HANDLE(1).

    hBrowse = BROWSE BrParent:HANDLE.
    cWhere = "WHERE DataError <> ''".
    RUN associateQueryWithBrowse
      (hBrowse,cWhere ).

    RUN closeQuery(INPUT BROWSE BrChild:HANDLE, YES).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

