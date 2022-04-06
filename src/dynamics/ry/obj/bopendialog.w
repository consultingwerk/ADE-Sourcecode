&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS bTableWin 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : bopendialog.w
    Purpose     : SmartDataBrowser, it is used in Open Dialog to 
                  view objects in the repository.

    Syntax      : 

    History     : 016/08/2001      created by          Yongjian Gu

                  11/10/2001      Updated by          John Palazzo (jep)
                  IZ 2467 - Open object cannot open Static SDV.
                  Fix: Added object_extension so AppBuilder can form
                  the file name to open correctly.
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

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE gcLastObject AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghPopupMenu  AS HANDLE        NO-UNDO.
DEFINE VARIABLE ghRepositoryDesignManager  AS HANDLE  NO-UNDO.
DEFINE VARIABLE mhColumn      AS HANDLE     NO-UNDO.

PROCEDURE SendMessageA EXTERNAL "user32" :
  DEFINE INPUT  PARAMETER hwnd        AS LONG.
  DEFINE INPUT  PARAMETER umsg        AS LONG.
  DEFINE INPUT  PARAMETER wparam      AS LONG.
  DEFINE INPUT  PARAMETER lparam      AS LONG.
  DEFINE RETURN PARAMETER ReturnValue AS LONG.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS TableIO-Target,Data-Target,Update-Source

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/dopendialog.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES rowObject

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table object_filename object_type_code ~
product_module_code object_description object_path object_extension ~
runnable_from_menu disabled run_persistent run_when container_object ~
static_object generic_object smartobject_obj 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH rowObject NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH rowObject NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table rowObject
&Scoped-define FIRST-TABLE-IN-QUERY-br_table rowObject


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table buButton 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getColumnWidth bTableWin 
FUNCTION getColumnWidth RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setColumnWidth bTableWin 
FUNCTION setColumnWidth RETURNS LOGICAL
  ( pcCols AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buButton 
     LABEL "" 
     SIZE 1 BY .24
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE TEMP-TABLE RowObject NO-UNDO
    {{&DATA-FIELD-DEFS}}
    {src/adm2/robjflds.i}.

DEFINE QUERY br_table FOR 
      rowObject SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table bTableWin _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      object_filename FORMAT "X(70)":U WIDTH 30
      object_type_code FORMAT "X(35)":U
      product_module_code FORMAT "X(35)":U
      object_description FORMAT "X(35)":U
      object_path FORMAT "X(70)":U
      object_extension FORMAT "X(35)":U
      runnable_from_menu FORMAT "YES/NO":U
      disabled FORMAT "YES/NO":U
      run_persistent FORMAT "YES/NO":U
      run_when FORMAT "X(3)":U
      container_object FORMAT "YES/NO":U
      static_object FORMAT "YES/NO":U
      generic_object FORMAT "YES/NO":U
      smartobject_obj FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN NO-AUTO-VALIDATE NO-ROW-MARKERS SEPARATORS SIZE 80 BY 8.1 ROW-HEIGHT-CHARS .62 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     buButton AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataBrowser
   Data Source: "ry/obj/dopendialog.w"
   Allow: Basic,Browse
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
  CREATE WINDOW bTableWin ASSIGN
         HEIGHT             = 8.48
         WIDTH              = 80.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB bTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW bTableWin
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 1
       br_table:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

ASSIGN 
       buButton:HIDDEN IN FRAME F-Main           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "rowObject"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > _<SDO>.rowObject.object_filename
"object_filename" ? ? "character" ? ? ? ? ? ? no ? no no "30" yes no no "U" "" ""
     _FldNameList[2]   = _<SDO>.rowObject.object_type_code
     _FldNameList[3]   = _<SDO>.rowObject.product_module_code
     _FldNameList[4]   = _<SDO>.rowObject.object_description
     _FldNameList[5]   = _<SDO>.rowObject.object_path
     _FldNameList[6]   = _<SDO>.rowObject.object_extension
     _FldNameList[7]   = _<SDO>.rowObject.runnable_from_menu
     _FldNameList[8]   = _<SDO>.rowObject.disabled
     _FldNameList[9]   = _<SDO>.rowObject.run_persistent
     _FldNameList[10]   = _<SDO>.rowObject.run_when
     _FldNameList[11]   = _<SDO>.rowObject.container_object
     _FldNameList[12]   = _<SDO>.rowObject.static_object
     _FldNameList[13]   = _<SDO>.rowObject.generic_object
     _FldNameList[14]   = _<SDO>.rowObject.smartobject_obj
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON CTRL-END OF br_table IN FRAME F-Main
DO:
  APPLY "END":U TO BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON CTRL-HOME OF br_table IN FRAME F-Main
DO:
  APPLY "HOME":U TO BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON DEFAULT-ACTION OF br_table IN FRAME F-Main
/* the user double-clicks on a row in the browser, which is equivalent to selecting 
   a row and clicking on Open button*/
DO:
  PUBLISH 'F2Pressed':U. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON END OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsend.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON GO OF br_table IN FRAME F-Main
DO:
  PUBLISH "F2Pressed":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON HOME OF br_table IN FRAME F-Main
DO:
  {src/adm2/brshome.i}
     APPLY 'VALUE-CHANGED' TO SELF.  
  /* doing this is to populate gcCurrentFileName with the first record 
     in the browser when the browser is first loaded. */
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON MOUSE-MENU-CLICK OF br_table IN FRAME F-Main
DO:
  DEFINE VARIABLE hcell       AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE icellHeight AS INTEGER       NO-UNDO.
  DEFINE VARIABLE ilastY      AS INTEGER       NO-UNDO.
  DEFINE VARIABLE irow        AS INTEGER       NO-UNDO.
  DEFINE VARIABLE lok         AS LOGICAL       NO-UNDO.
 
  DEFINE VARIABLE hPopupMenu1 AS HANDLE        NO-UNDO.
 
  /* Don't pop up menu if right click on labels */
  hcell = SELF:FIRST-COLUMN.
  
  IF VALID-HANDLE(hcell) THEN icellHeight = hcell:HEIGHT-PIXELS.
    ELSE icellHeight = 20.


  ilastY = LAST-EVENT:Y.
  
  IF ilastY >= icellHeight AND
     ilastY <= icellHeight * (SELF:NUM-ITERATIONS + 1) THEN
  DO:
    ASSIGN ilastY = ilastY - icellHeight / 2
           irow   = ilastY / icellHeight
           lok    = SELF:SELECT-ROW(irow) 
          .

  
  
    
    APPLY "MOUSE-SELECT-CLICK":U TO SELF.
    ASSIGN buButton:WIDTH-P  = 1
           buButton:HEIGHT-P = 1          
           buButton:HIDDEN = FALSE.
           buButton:POPUP-MENU = ghPopupMenu.

    RUN Apply-mouse-menu-click(buButton:HANDLE).
    

   /* SELF:POPUP-MENU = ?.    */
    
    APPLY "ENTRY":U TO SELF.
     ASSIGN FRAME {&FRAME-NAME}:POPUP-MENU = ?.
  END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON MOUSE-SELECT-CLICK OF br_table IN FRAME F-Main
DO:
  DEFINE VARIABLE cObject     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hcell       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE icellheight AS INTEGER    NO-UNDO.


  ASSIGN hcell = SELF:FIRST-COLUMN.
  IF VALID-HANDLE(hcell) THEN icellHeight = hcell:HEIGHT-PIXELS.
    ELSE icellHeight = 20.
  IF LAST-EVENT:Y < icellHeight  THEN
  DO:
     APPLY "START-SEARCH":U TO SELF.
     RETURN.
  END.

  ASSIGN
   cObject      = RowObject.object_filename:Screen-value IN BROWSE {&BROWSE-NAME}
   cObject      = IF cObject = ? THEN "" ELSE cObject
   gcLastObject = cObject .

  PUBLISH 'updateFileName':U  (INPUT cObject ). 

  
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON OFF-END OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsoffnd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON OFF-HOME OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsoffhm.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON RETURN OF br_table IN FRAME F-Main
DO:
  PUBLISH 'F2Pressed':U.   /* the user presses Return key when in browser, which is 
                              considered as Open is pressed, inform the smartwindow 
                              of the event. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON SCROLL-NOTIFY OF br_table IN FRAME F-Main
DO:
  {src/adm2/brsscrol.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON START-SEARCH OF br_table IN FRAME F-Main
DO:
  DEFINE VARIABLE cColumn     AS CHARACTER NO-UNDO.
  
  ASSIGN mhColumn = {&BROWSE-NAME}:CURRENT-COLUMN 
         cColumn  = mhColumn:NAME NO-ERROR.

  {fnarg setSort ccolumn}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:   
   DEFINE VARIABLE cObject AS CHARACTER  NO-UNDO.
  {src/adm2/brschnge.i}

  /* if the selected row has a valid object filename, update filename fill-in field in the smartwindow. */
  IF gcLastObject = "" 
       OR gcLastObject <> RowObject.OBJECT_filename:SCREEN-VALUE IN BROWSE {&Browse-name} THEN
   APPLY "MOUSE-SELECT-CLICK":U TO SELF.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK bTableWin 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN initializeObject.  
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE apply-mouse-menu-click bTableWin 
PROCEDURE apply-mouse-menu-click :
/*------------------------------------------------------------------------------
Purpose:     Programatic click the right mouse button on a widget
Parameters:  Widget-handle on which you want to click
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER  p-wh   AS WIDGET-HANDLE  NO-UNDO.
 
 DEFINE VARIABLE iReturnValue AS INTEGER NO-UNDO.
      /* messages */
 &scope  WM_LBUTTONDOWN 513
 &scope WM_LBUTTONUP 514
 &scope WM_RBUTTONDOWN 516
 &scope WM_RBUTTONUP 517
    
 /* mouse buttons */
 &scope MK_LBUTTON 1
 &scope MK_RBUTTON 2

 

 RUN SendMessageA  (INPUT p-wh:HWND, 
                    INPUT {&WM_RBUTTONDOWN},
                    INPUT {&MK_RBUTTON},
                    INPUT 0,
                    OUTPUT iReturnValue).
 RUN SendMessageA (INPUT p-wh:HWND, 
                   INPUT {&WM_RBUTTONUP},
                   INPUT 0, 
                   INPUT 0,
                   OUTPUT iReturnValue).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyKey bTableWin 
PROCEDURE applyKey :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcKey AS CHARACTER  NO-UNDO.

CASE pcKey:
   WHEN "PAGEUP":U THEN
       APPLY "PAGE-UP" TO  BROWSE {&BROWSE-NAME}.
   WHEN "PAGEDOWN":U THEN
          APPLY "PAGE-DOWN" TO  BROWSE {&BROWSE-NAME}.
   WHEN "CURSORUP":U THEN
      BROWSE {&BROWSE-NAME}:SELECT-PREV-ROW() NO-ERROR.
   WHEN "CURSORDOWN":U THEN
       BROWSE {&BROWSE-NAME}:SELECT-NEXT-ROW() NO-ERROR.         
END CASE.
APPLY "VALUE-CHANGED":U TO  BROWSE {&BROWSE-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteObject bTableWin 
PROCEDURE deleteObject :
/*------------------------------------------------------------------------------
  Purpose:     Removes the object from the repository
  Parameters:  <none>
  Notes:       Using API removeObject from DesignManager, this API will 
               not remove an object if it is used elsewhere.
------------------------------------------------------------------------------*/
DEFINE VARIABLE lDelete      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cErrorText   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cButton      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainer   AS HANDLE     NO-UNDO.

MESSAGE "You have selected object: " SKIP 
         "'" + RIGHT-TRIM(rowObject.OBJECT_filename:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) + 
         IF RowObject.Object_extension:SCREEN-VALUE = "" 
         THEN "'" 
         ELSE ("." + RowObject.Object_extension:SCREEN-VALUE + "'")
         IF RowObject.OBJECT_filename:SCREEN-VALUE = RowObject.OBJECT_description:SCREEN-VALUE 
            OR RowObject.OBJECT_filename:SCREEN-VALUE + "." + RowObject.Object_extension:SCREEN-VALUE
                     = RowObject.OBJECT_description:SCREEN-VALUE 
         THEN "" 
         ELSE  ("   " + RowObject.OBJECT_description:SCREEN-VALUE )   SKIP 
        "Are you sure you want to remove this object from the repository?"
   VIEW-AS ALERT-BOX INFO BUTTONS YES-NO TITLE "Remove Object" UPDATE lDelete.

IF lDelete THEN
DO:
   {get ContainerSource hContainer}.
   IF NOT VALID-HANDLE(ghRepositoryDesignManager) THEN
    ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                                                        INPUT "RepositoryDesignManager":U).
   RUN removeObject IN ghRepositoryDesignManager
                        (INPUT RowObject.OBJECT_filename:SCREEN-VALUE,
                         INPUT "") NO-ERROR.
   
   IF RETURN-VALUE NE "":U THEN
   DO:
      
      ASSIGN cErrorText = RETURN-VALUE.
      RUN showMessages IN gshSessionManager (INPUT  cErrorText,               /* message to display */
                                             INPUT  "ERR":U,                  /* error type */
                                             INPUT  "&OK":U,                  /* button list */
                                             INPUT  "&OK":U,                  /* default button */ 
                                             INPUT  "&OK":U,                  /* cancel button */
                                             INPUT  "Error from Object Deletion":U,                /* error window title */
                                             INPUT  YES,                      /* display if empty */ 
                                             INPUT  hContainer,               /* container handle */ 
                                             OUTPUT cButton                   /* button pressed */
                                            ).
  END.
  /* Refresh Query */
  ELSE DO:
    RUN updateBrowserContents IN hContainer NO-ERROR.
  END.
END.
RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI bTableWin  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject bTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hPopUpMenu1 AS HANDLE     NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
 /* Create pop up menu */
    CREATE MENU ghPopupMenu
      ASSIGN POPUP-ONLY = TRUE.

    CREATE MENU-ITEM hPopupMenu1
        ASSIGN Parent = ghPopupMenu
               Label  = "Open":U
        TRIGGERS:
           ON CHOOSE PERSISTENT
             RUN OpenObject IN THIS-PROCEDURE.
        END TRIGGERS.

    CREATE MENU-ITEM hPopupMenu1
        ASSIGN SUBTYPE   = "RULE":U
               PARENT    = ghpopupMenu.
                 
    CREATE MENU-ITEM hPopupMenu1
        ASSIGN Parent = ghPopupMenu
               Label  = "Remove from Repository":U
        TRIGGERS:
           ON CHOOSE PERSISTENT
             RUN DeleteObject IN THIS-PROCEDURE.
        END TRIGGERS.

    CREATE MENU-ITEM hPopupMenu1
        ASSIGN SUBTYPE   = "RULE":U
               PARENT    = ghpopupMenu.      

    CREATE MENU-ITEM hPopupMenu1
        ASSIGN Parent = ghPopupMenu
               Label  = "Properties...":U
        TRIGGERS:
           ON CHOOSE PERSISTENT
             RUN ObjectProperties IN THIS-PROCEDURE.
        END TRIGGERS.
    
   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ObjectProperties bTableWin 
PROCEDURE ObjectProperties :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hSDO AS HANDLE     NO-UNDO.
 {get DataSource hSDO}.

 DO ON ERROR UNDO, LEAVE:
   RUN ry/obj/gObjectPropd.w
      (INPUT RowObject.OBJECT_filename:SCREEN-VALUE IN BROWSE {&browse-name} ,
       INPUT hSDO) NO-ERROR.
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenObject bTableWin 
PROCEDURE OpenObject :
/*------------------------------------------------------------------------------
  Purpose:     Open the current selected Object
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.

 {get ContainerSource hContainer}.

  RUN OpenObject IN hContainer 
    (RowObject.OBJECT_filename:SCREEN-VALUE IN BROWSE {&browse-name}) NO-ERROR.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject bTableWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER dHeight AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER dWidth  AS DECIMAL    NO-UNDO.


ASSIGN FRAME {&FRAME-NAME}:WIDTH  = dWidth 
       FRAME {&FRAME-NAME}:HEIGHT = dHeight 
       BROWSE {&BROWSE-NAME}:WIDTH = dWidth -  {&BROWSE-NAME}:COL + 1
       BROWSE {&BROWSE-NAME}:HEIGHT = dHeight - {&BROWSE-NAME}:ROW + 1 
      NO-ERROR.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getColumnWidth bTableWin 
FUNCTION getColumnWidth RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCols      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cColWidths AS CHARACTER  NO-UNDO.

  DO icols = 1 TO BROWSE {&BROWSE-NAME}:NUM-COLUMNS:
       hColumn= BROWSE {&BROWSE-NAME}:GET-BROWSE-COLUMN(icols).
      cColWidths = cColWidths + (IF cColWidths = "" THEN "" ELSE ",")
                              + STRING(hColumn:WIDTH-PIXELS).
  END.
  
  RETURN cColWidths.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setColumnWidth bTableWin 
FUNCTION setColumnWidth RETURNS LOGICAL
  ( pcCols AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE iCols   AS INTEGER    NO-UNDO.
DEFINE VARIABLE hColumn AS HANDLE     NO-UNDO.

DO icols = 1 TO BROWSE {&BROWSE-NAME}:NUM-COLUMNS:
       hColumn= BROWSE {&BROWSE-NAME}:GET-BROWSE-COLUMN(icols).
       hColumn:WIDTH-PIXELS = INT(ENTRY(iCols,pcCols)) NO-ERROR.
END.
RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

