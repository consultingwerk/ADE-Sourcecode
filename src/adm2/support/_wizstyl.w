&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
/* Procedure Description
"Query Wizard"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME Style
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Style 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _wizreps.w

  Description: Style data for report and detail HTML 

  Input Parameters:
      hWizard (handle) - handle of Wizard dialog

  Output Parameters:
      <none>

  Author : Haavard Danielsen
  Created: July 98 
   
     Note: This procedure has two alternate Layouts that corresponds with 
           the object types it is used for.
           WebDetail
           WebReport         
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* NEVER NEVER Create an unnamed pool to store all the widgets created 
     by this procedure. This only assures that everything dynamic 
     that is created in this procedure will die as soon as this proecure dies  
 CREATE WIDGET-POOL.    
     */
/* ***************************  Definitions  ************************** */
{ src/adm2/support/admhlp.i } /* ADM Help File Defs */

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER hWizard     AS HANDLE NO-UNDO. 

DEFINE SHARED VARIABLE fld-list     AS CHAR   NO-UNDO.

DEFINE VARIABLE         gProcrecStr AS CHAR   NO-UNDO.
DEFINE VARIABLE         gObjType    AS CHAR   NO-UNDO.
DEFINE VARIABLE         gTables     AS CHAR   NO-UNDO.
DEFINE VARIABLE         gSDO        AS CHAR   NO-UNDO.
DEFINE VARIABLE         gSDOHdl     AS HANDLE NO-UNDO.

DEFINE VARIABLE         gWizardHdl  AS HANDLE NO-UNDO.
DEFINE VARIABLE         gHTMLHdl    AS HANDLE NO-UNDO.
DEFINE VARIABLE         gNoValue    AS CHAR   INIT "<None>".

DEFINE VARIABLE         cQuery      AS CHAR   NO-UNDO.

DEFINE VARIABLE         xHTMLproc      AS CHAR   INIT 'adeweb/_genwpg.p'  NO-UNDO.
DEFINE VARIABLE         xCmbInnerLines AS INT    INIT 16                  NO-UNDO.

FUNCTION getField RETURNS CHARACTER
  (pField AS CHAR) IN gHTMLHdl.

FUNCTION setField RETURNS LOGICAL
  ( pField AS CHAR,
    pValue AS CHAR) IN gHTMLHdl.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

&Scoped-define LAYOUT-VARIABLE Style-layout

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiTitle fistyleSheet togAdd togSubmit ~
togReset togDelete fiRows fiBorder togHeadings togSearch togNavigation ~
e_msg btnHelp fiStyleLabel fiTableLabel fiOptionLabel recTable 
&Scoped-Define DISPLAYED-OBJECTS fiTitle fistyleSheet fiBorder togSearch ~
togNavigation coSearchColumn e_msg fiStyleLabel fiTableLabel fiOptionLabel ~
fiPanelLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initSearchColumn Style 
FUNCTION initSearchColumn RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Define a variable to store the name of the active layout.            */
DEFINE VAR Style-layout AS CHAR INITIAL "Master Layout":U NO-UNDO.

/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR Style AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnHelp 
     LABEL "Help on Style" 
     SIZE 26 BY 1.14.

DEFINE VARIABLE coSearchColumn AS CHARACTER FORMAT "X(256)":U 
     LABEL "Field" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 21 BY 1 TOOLTIP "Specify the Field to use in the Search Form" NO-UNDO.

DEFINE VARIABLE fiBorder AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Border" 
     VIEW-AS COMBO-BOX 
     LIST-ITEMS "0","1","2","3","4","5" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 TOOLTIP "Specify the size of the border for the table." NO-UNDO.

DEFINE VARIABLE e_msg AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 26 BY 5.67
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE fiOptionLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Optional Forms" 
      VIEW-AS TEXT 
     SIZE 15 BY .62 NO-UNDO.

DEFINE VARIABLE fiPanelLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Update Panel" 
      VIEW-AS TEXT 
     SIZE 16 BY .62 NO-UNDO.

DEFINE VARIABLE fiRows AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Rows" 
     VIEW-AS FILL-IN 
     SIZE 7.2 BY 1 TOOLTIP "Specify the number of rows you want to display in the report." NO-UNDO.

DEFINE VARIABLE fiStyleLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Style" 
      VIEW-AS TEXT 
     SIZE 7 BY .62 NO-UNDO.

DEFINE VARIABLE fistyleSheet AS CHARACTER FORMAT "X(256)":U 
     LABEL "Style sheet" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1 TOOLTIP "Enter the filename of the style sheet you want to link to this Web object." NO-UNDO.

DEFINE VARIABLE fiTableLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Table Layout" 
      VIEW-AS TEXT 
     SIZE 12.8 BY .62 NO-UNDO.

DEFINE VARIABLE fiTitle AS CHARACTER FORMAT "X(256)":U 
     LABEL "Title" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1 TOOLTIP "Enter the title you want to display at the top of the report" NO-UNDO.

DEFINE RECTANGLE recPanel
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 31.2 BY 2.86.

DEFINE RECTANGLE recPanel-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 49 BY 2.86.

DEFINE RECTANGLE recStyle
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 3.52.

DEFINE RECTANGLE recTable
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 3.29.

DEFINE VARIABLE togAdd AS LOGICAL INITIAL no 
     LABEL "Add" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.8 BY .76 NO-UNDO.

DEFINE VARIABLE togCancel AS LOGICAL INITIAL no 
     LABEL "Cancel" 
     VIEW-AS TOGGLE-BOX
     SIZE 10.8 BY .76 NO-UNDO.

DEFINE VARIABLE togDelete AS LOGICAL INITIAL no 
     LABEL "Delete" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.8 BY .76 NO-UNDO.

DEFINE VARIABLE togHeadings AS LOGICAL INITIAL no 
     LABEL "Column headings" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .76 TOOLTIP "Specify whether to use the database fields labels as column headings." NO-UNDO.

DEFINE VARIABLE togNavigation AS LOGICAL INITIAL no 
     LABEL "Navigation panel" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.2 BY .76 TOOLTIP "Specify whether to use a Navigation Panel to scroll through the report results" NO-UNDO.

DEFINE VARIABLE togReset AS LOGICAL INITIAL no 
     LABEL "Reset" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.8 BY .76 NO-UNDO.

DEFINE VARIABLE togSearch AS LOGICAL INITIAL no 
     LABEL "Search form" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.2 BY .76 TOOLTIP "Specify whether to use a search form." NO-UNDO.

DEFINE VARIABLE togSubmit AS LOGICAL INITIAL no 
     LABEL "Submit" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.8 BY .76 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     fiTitle AT ROW 2.14 COL 14 COLON-ALIGNED
     fistyleSheet AT ROW 3.62 COL 14 COLON-ALIGNED
     togAdd AT ROW 10 COL 55
     togSubmit AT ROW 10 COL 69
     togReset AT ROW 11.24 COL 55
     togDelete AT ROW 11.19 COL 69
     togCancel AT ROW 10.52 COL 73
     fiRows AT ROW 6.19 COL 10 COLON-ALIGNED
     fiBorder AT ROW 7.62 COL 4.6
     togHeadings AT ROW 6.24 COL 33
     togSearch AT ROW 10 COL 4
     togNavigation AT ROW 11.24 COL 4
     coSearchColumn AT ROW 10 COL 27 COLON-ALIGNED
     e_msg AT ROW 1.52 COL 57 NO-LABEL
     btnHelp AT ROW 7.71 COL 57
     fiStyleLabel AT ROW 1.24 COL 1 COLON-ALIGNED NO-LABEL
     fiTableLabel AT ROW 5.29 COL 3 NO-LABEL
     fiOptionLabel AT ROW 9.05 COL 3 NO-LABEL
     fiPanelLabel AT ROW 9.1 COL 52 COLON-ALIGNED NO-LABEL
     recPanel AT ROW 9.33 COL 53
     recPanel-2 AT ROW 9.33 COL 2
     recStyle AT ROW 1.52 COL 2
     recTable AT ROW 5.57 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.6 BY 11.29
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW Style ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert title>"
         HEIGHT             = 13.24
         WIDTH              = 83.8
         MAX-HEIGHT         = 37.57
         MAX-WIDTH          = 182.8
         VIRTUAL-HEIGHT     = 37.57
         VIRTUAL-WIDTH      = 182.8
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
                                                                        */
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME
ASSIGN Style = CURRENT-WINDOW.




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW Style
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   Custom                                                               */
/* SETTINGS FOR COMBO-BOX coSearchColumn IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       e_msg:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR COMBO-BOX fiBorder IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiOptionLabel IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiPanelLabel IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiRows IN FRAME DEFAULT-FRAME
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN fiTableLabel IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR RECTANGLE recPanel IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE recPanel-2 IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE recStyle IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX togAdd IN FRAME DEFAULT-FRAME
   NO-DISPLAY                                                           */
/* SETTINGS FOR TOGGLE-BOX togCancel IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX togDelete IN FRAME DEFAULT-FRAME
   NO-DISPLAY                                                           */
/* SETTINGS FOR TOGGLE-BOX togHeadings IN FRAME DEFAULT-FRAME
   NO-DISPLAY                                                           */
/* SETTINGS FOR TOGGLE-BOX togReset IN FRAME DEFAULT-FRAME
   NO-DISPLAY                                                           */
/* SETTINGS FOR TOGGLE-BOX togSubmit IN FRAME DEFAULT-FRAME
   NO-DISPLAY                                                           */

/* _MULTI-LAYOUT-RUN-TIME-ADJUSTMENTS */

/* LAYOUT-NAME: "WebDetail"
   LAYOUT-TYPE: GUI
   EXPRESSION:  
   COMMENT:     
                                                                        */
/* LAYOUT-NAME: "WebReport"
   LAYOUT-TYPE: GUI
   EXPRESSION:  
   COMMENT:     
                                                                        */
/* END-OF-LAYOUT-DEFINITIONS */

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Style
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Style Style
ON END-ERROR OF Style /* <insert title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Style Style
ON WINDOW-CLOSE OF Style /* <insert title> */
DO:
  /* These events will close the window and terminate the procedure.      */
  /* (NOTE: this will override any user-defined triggers previously       */
  /*  defined on the window.)                                             */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnHelp Style
ON CHOOSE OF btnHelp IN FRAME DEFAULT-FRAME /* Help on Style */
DO:
  DEFINE VARIABLE iHelpTopic AS INTEGER    NO-UNDO.
  iHelpTopic = (IF gObjType = "WebDetail" 
                THEN {&Help_on_Style_Detail_Wizard}
                ELSE {&Help_on_Style_Report_Wizard}).

  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, iHelpTopic, ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME togCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL togCancel Style
ON VALUE-CHANGED OF togCancel IN FRAME DEFAULT-FRAME /* Cancel */
DO:
  ASSIGN togCancel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME togSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL togSearch Style
ON VALUE-CHANGED OF togSearch IN FRAME DEFAULT-FRAME /* Search form */
DO:
  ASSIGN coSearchColumn:SENSITIVE = NOT coSearchColumn:SENSITIVE .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME togSubmit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL togSubmit Style
ON VALUE-CHANGED OF togSubmit IN FRAME DEFAULT-FRAME /* Submit */
DO:
  /* togCancel is always assigned on value-changed */ 
  ASSIGN
    togCancel:SENSITIVE = SELF:CHECKED
    togCancel:CHECKED   = IF SELF:CHECKED THEN togCancel ELSE FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Style 


/* ***************************  Main Block  *************************** */
ASSIGN 
  gWizardHdl   = SOURCE-PROCEDURE
  gHTMLHdl     = DYNAMIC-FUNCTION("getSupportHandle" in gWizardHdl,xHTMLProc)     
  FRAME {&FRAME-NAME}:FRAME    = hwizard
  FRAME {&FRAME-NAME}:HEIGHT-P = FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P
  FRAME {&FRAME-NAME}:WIDTH-P  = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P
   
  fiStyleLabel:WIDTH IN FRAME {&FRAME-NAME} = 
      FONT-TABLE:GET-TEXT-WIDTH-CHARS(fiStyleLabel,FRAME {&FRAME-NAME}:FONT)
  fiTableLabel:WIDTH IN FRAME {&FRAME-NAME} = 
      FONT-TABLE:GET-TEXT-WIDTH-CHARS(fiTableLabel,FRAME {&FRAME-NAME}:FONT)
  fiPanelLabel:WIDTH IN FRAME {&FRAME-NAME} = 
      FONT-TABLE:GET-TEXT-WIDTH-CHARS(fiPanelLabel,FRAME {&FRAME-NAME}:FONT)
  .
  
  /* Get context id of procedure */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT gProcRecStr).
  
/* Get procedure type (Web-Object, SmartBrowser) */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U, OUTPUT gObjType).

/* Get the name of the associated DataObject */
RUN adeuib/_uibinfo.p (INT(gProcRecStr), "":U, "DataObject":U, OUTPUT gSDO).

/* Get the handle of the data object */
IF gSDO ne "" and gSDO ne ? THEN
  RUN getSDOHandle IN gWizardHdl (gSDO, OUTPUT gSDOhdl).
ELSE DO:
  /* Assume that we are using a db and not sdo for the data source */
  /* Get context of the Query  */
  
  /* Get the query */
  RUN adeuib/_uibinfo.p (INT(gProcRecStr),?,
                         "CONTAINS QUERY RETURN CONTEXT":U, output cQuery).


  /* Get the tables in the query */
  IF cQuery <> "" THEN
    RUN adeuib/_uibinfo.p (INT(cQuery),?,
                         "TABLES":U, output gTables).  
END.


e_msg = "Use the options on this page to customize the design "                       
        + "and layout of your " + gObjType + ".":U.


/* Set the alternate layout for the object type */
RUN style-layouts (gObjType).  
                   
/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
  RUN ProcessPage NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
  RUN disable_UI.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  RUN DisplayPage.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ChooseImage Style 
PROCEDURE ChooseImage :
/*------------------------------------------------------------------------------
  Purpose:    Run Choose Background Image dialog from browse buttons.
  Parameters: pHdl - Handle of the related fill-in.
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pHdl AS HANDLE. 
 DEFINE VARIABLE FileName AS CHAR NO-UNDO.
 
 DO WITH FRAME {&FRAME-NAME}:
    ASSIGN FileName = pHdl:SCREEN-VALUE. 
    RUN adecomm/_opnfile.w 
                ("Choose a Background Image":U,
                 "GIF Files (*.gif), All Files (*.*)":U,
                 INPUT-OUTPUT FileName).
  
    IF FileName <> "":U THEN
      ASSIGN pHdl:SCREEN-VALUE = FileName.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Style  _DEFAULT-DISABLE
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
  HIDE FRAME DEFAULT-FRAME.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayPage Style 
PROCEDURE DisplayPage :
/*------------------------------------------------------------------------------
  Purpose:     Display 4GL query if any and sets button label.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR cColumn    AS CHAR NO-UNDO.  
  DEF VAR i          AS INT  NO-UNDO.  
  DEF VAR iNumInList AS INT  NO-UNDO.  
  DEF VAR iNumInCol  AS INT  NO-UNDO.  
 
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      togSearch:SENSITIVE         = fld-list <> "":U
      fiTitle:SCREEN-VALUE        = getField("PageTitle":U)
      fiStyleSheet:SCREEN-VALUE   = getField("StyleSheet":U)      
      togSearch:SCREEN-VALUE      = IF togSearch:SENSITIVE 
                                    THEN getField("UseSearchForm":U)
                                    ELSE "no":U
      togNavigation:SCREEN-VALUE  = getField("UseNavigationPanel":U)
      togHeadings:SCREEN-VALUE    = getField("UseColumnHeadings":U)
      togSubmit:SCREEN-VALUE      = getField("UseSubmit":U)
      togReset:SCREEN-VALUE       = getField("UseReset":U)
      togAdd:SCREEN-VALUE         = getField("UseAdd":U)
      togDelete:SCREEN-VALUE      = getField("UseDelete":U)
      togCancel:SCREEN-VALUE      = getField("UseCancel":U)
      fiRows:SCREEN-VALUE         = getField("TableRows":U) 
      fiBorder:SCREEN-VALUE       = getField("TableBorder":U) 
      togCancel:SENSITIVE         = togAdd:CHECKED      
      togCancel.    
      
  END. /* DO WITH FRAME */
  initSearchColumn(). 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Style  _DEFAULT-ENABLE
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
  DISPLAY fiTitle fistyleSheet fiBorder togSearch togNavigation coSearchColumn 
          e_msg fiStyleLabel fiTableLabel fiOptionLabel 
          fiPanelLabel WHEN NOT ({&LAYOUT-VARIABLE} = "WebReport":U) 
      WITH FRAME DEFAULT-FRAME.
  ENABLE fiTitle fistyleSheet 
         togAdd WHEN NOT ({&LAYOUT-VARIABLE} = "WebReport":U) 
         togSubmit WHEN NOT ({&LAYOUT-VARIABLE} = "WebReport":U) 
         togReset WHEN NOT ({&LAYOUT-VARIABLE} = "WebReport":U) 
         togDelete WHEN NOT ({&LAYOUT-VARIABLE} = "WebReport":U) 
         fiRows WHEN NOT ({&LAYOUT-VARIABLE} = "WebDetail":U) fiBorder 
         togHeadings WHEN NOT ({&LAYOUT-VARIABLE} = "WebDetail":U) togSearch 
         togNavigation e_msg btnHelp fiStyleLabel fiTableLabel fiOptionLabel 
         recTable 
      WITH FRAME DEFAULT-FRAME.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ProcessPage Style 
PROCEDURE ProcessPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF VAR LastButton   AS CHAR NO-UNDO.
   DEF VAR DataObject   AS CHAR NO-UNDO.
   DEF VAR HTMLTemplate AS CHAR NO-UNDO.

   LastButton = DYNAMIC-FUNCTION ("GetLastButton" IN gWizardHdl).
   
   IF LastButton = "CANCEL" THEN RETURN.
        
   RUN adecomm/_setcurs.p("WAIT":U).
   DO WITH FRAME {&FRAME-NAME}:     
     IF LastButton = "NEXT":U THEN 
     DO:
       IF togSearch:CHECKED 
       AND (   coSearchColumn:SCREEN-VALUE = ? 
            OR coSearchColumn:SCREEN-VALUE = gNoValue) THEN 
       DO:
         MESSAGE "You must specify a field to use for the Search Form,"  
                 " or uncheck the Search Form."  
         VIEW-AS ALERT-BOX WARNING.
         RETURN ERROR.          
       END.
     END.
  
     setField("ColumnList":U,fld-list). 
     setField("ProcId":U,gProcRecStr). 
     setField("PageTitle":U,fiTitle:SCREEN-VALUE).
     IF togSearch:SENSITIVE THEN
        setField("UseSearchForm":U,togSearch:SCREEN-VALUE).
     setField("UseNavigationPanel":U,togNavigation:SCREEN-VALUE).
     setField("UseColumnHeadings":U,togHeadings:SCREEN-VALUE).
     setField("UseSubmit":U,togSubmit:SCREEN-VALUE).
     setField("UseReset":U,togReset:SCREEN-VALUE).
     setField("UseAdd":U,togAdd:SCREEN-VALUE).
     setField("UseDelete":U,togDelete:SCREEN-VALUE).
     setField("UseCancel":U,togCancel:SCREEN-VALUE).
     
     /* If there is only one table in the query the combo box does not
        contain the db and table name so we add it */
     setField("SearchColumns":U,IF coSearchColumn:SCREEN-VALUE = ? 
                                OR coSearchColumn:SCREEN-VALUE = gNoValue  
                                THEN "":U
                                ELSE coSearchColumn:SCREEN-VALUE).
     setField("TableRows":U,fiRows:SCREEN-VALUE).
     setField("TableBorder":U,fiBorder:SCREEN-VALUE). 
     setField("StyleSheet":U,fistyleSheet:SCREEN-VALUE). 
   END.
   RUN adecomm/_setcurs.p("":U).    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK  _PROCEDURE Style-layouts _LAYOUT-CASES
PROCEDURE Style-layouts:
  DEFINE INPUT PARAMETER layout AS CHARACTER                     NO-UNDO.
  DEFINE VARIABLE lbl-hndl AS WIDGET-HANDLE                      NO-UNDO.
  DEFINE VARIABLE widg-pos AS DECIMAL                            NO-UNDO.

  /* Copy the name of the active layout into a variable accessible to   */
  /* the rest of this file.                                             */
  Style-layout = layout.

  CASE layout:
    WHEN "Master Layout" THEN DO:
      ASSIGN
         coSearchColumn:HIDDEN IN FRAME DEFAULT-FRAME      = yes
         coSearchColumn:WIDTH IN FRAME DEFAULT-FRAME       = 21
         coSearchColumn:HIDDEN IN FRAME DEFAULT-FRAME      = no.

      ASSIGN
         fiBorder:HIDDEN IN FRAME DEFAULT-FRAME            = yes
         widg-pos = fiBorder:COL IN FRAME DEFAULT-FRAME 
         fiBorder:COL IN FRAME DEFAULT-FRAME               = 12
         lbl-hndl = fiBorder:SIDE-LABEL-HANDLE IN FRAME DEFAULT-FRAME 
         lbl-hndl:COL = lbl-hndl:COL + fiBorder:COL IN FRAME DEFAULT-FRAME  - widg-pos
         widg-pos = fiBorder:ROW IN FRAME DEFAULT-FRAME 
         fiBorder:ROW IN FRAME DEFAULT-FRAME               = 7.62
         lbl-hndl = fiBorder:SIDE-LABEL-HANDLE IN FRAME DEFAULT-FRAME 
         lbl-hndl:ROW = lbl-hndl:ROW + fiBorder:ROW IN FRAME DEFAULT-FRAME  - widg-pos
         fiBorder:HIDDEN IN FRAME DEFAULT-FRAME            = no.

      ASSIGN
         fiPanelLabel:HIDDEN IN FRAME DEFAULT-FRAME        = yes
         fiPanelLabel:COL IN FRAME DEFAULT-FRAME           = 54
         fiPanelLabel:ROW IN FRAME DEFAULT-FRAME           = 9.1
         fiPanelLabel:HIDDEN IN FRAME DEFAULT-FRAME        = no
         fiPanelLabel:HIDDEN IN FRAME DEFAULT-FRAME        = no.

      ASSIGN
         fiRows:HIDDEN IN FRAME DEFAULT-FRAME              = no.

      ASSIGN
         fiTableLabel:HIDDEN IN FRAME DEFAULT-FRAME        = yes
         fiTableLabel:COL IN FRAME DEFAULT-FRAME           = 3
         fiTableLabel:HIDDEN IN FRAME DEFAULT-FRAME        = no.

      ASSIGN
         recPanel:HIDDEN IN FRAME DEFAULT-FRAME            = yes
         recPanel:COL IN FRAME DEFAULT-FRAME               = 53
         recPanel:HEIGHT IN FRAME DEFAULT-FRAME            = 2.86
         recPanel:ROW IN FRAME DEFAULT-FRAME               = 9.33
         recPanel:WIDTH IN FRAME DEFAULT-FRAME             = 31.2
         recPanel:HIDDEN IN FRAME DEFAULT-FRAME            = no
         recPanel:HIDDEN IN FRAME DEFAULT-FRAME            = no.

      ASSIGN
         recPanel-2:HIDDEN IN FRAME DEFAULT-FRAME          = yes
         recPanel-2:WIDTH IN FRAME DEFAULT-FRAME           = 49
         recPanel-2:HIDDEN IN FRAME DEFAULT-FRAME          = no.

      ASSIGN
         recTable:HIDDEN IN FRAME DEFAULT-FRAME            = yes
         recTable:COL IN FRAME DEFAULT-FRAME               = 2
         recTable:WIDTH IN FRAME DEFAULT-FRAME             = 54
         recTable:HIDDEN IN FRAME DEFAULT-FRAME            = no.

      ASSIGN
         togAdd:HIDDEN IN FRAME DEFAULT-FRAME              = yes
         togAdd:COL IN FRAME DEFAULT-FRAME                 = 55
         togAdd:ROW IN FRAME DEFAULT-FRAME                 = 10
         togAdd:HIDDEN IN FRAME DEFAULT-FRAME              = no
         togAdd:HIDDEN IN FRAME DEFAULT-FRAME              = no.

      ASSIGN
         togCancel:HIDDEN IN FRAME DEFAULT-FRAME           = no.

      ASSIGN
         togDelete:HIDDEN IN FRAME DEFAULT-FRAME           = yes
         togDelete:COL IN FRAME DEFAULT-FRAME              = 69
         togDelete:ROW IN FRAME DEFAULT-FRAME              = 11.19
         togDelete:HIDDEN IN FRAME DEFAULT-FRAME           = no
         togDelete:HIDDEN IN FRAME DEFAULT-FRAME           = no.

      ASSIGN
         togHeadings:HIDDEN IN FRAME DEFAULT-FRAME         = no.

      ASSIGN
         togReset:HIDDEN IN FRAME DEFAULT-FRAME            = yes
         togReset:COL IN FRAME DEFAULT-FRAME               = 55
         togReset:ROW IN FRAME DEFAULT-FRAME               = 11.24
         togReset:HIDDEN IN FRAME DEFAULT-FRAME            = no
         togReset:HIDDEN IN FRAME DEFAULT-FRAME            = no.

      ASSIGN
         togSubmit:HIDDEN IN FRAME DEFAULT-FRAME           = yes
         togSubmit:COL IN FRAME DEFAULT-FRAME              = 69
         togSubmit:ROW IN FRAME DEFAULT-FRAME              = 10
         togSubmit:HIDDEN IN FRAME DEFAULT-FRAME           = no
         togSubmit:HIDDEN IN FRAME DEFAULT-FRAME           = no.

    END.  /* Master Layout Layout Case */

    WHEN "WebDetail":U THEN DO:
      ASSIGN
         coSearchColumn:HIDDEN IN FRAME DEFAULT-FRAME      = yes
         coSearchColumn:WIDTH IN FRAME DEFAULT-FRAME       = 53
         coSearchColumn:HIDDEN IN FRAME DEFAULT-FRAME      = no.

      ASSIGN
         fiBorder:HIDDEN IN FRAME DEFAULT-FRAME            = yes
         widg-pos = fiBorder:COL IN FRAME DEFAULT-FRAME 
         fiBorder:COL IN FRAME DEFAULT-FRAME               = 47
         lbl-hndl = fiBorder:SIDE-LABEL-HANDLE IN FRAME DEFAULT-FRAME 
         lbl-hndl:COL = lbl-hndl:COL + fiBorder:COL IN FRAME DEFAULT-FRAME  - widg-pos
         widg-pos = fiBorder:ROW IN FRAME DEFAULT-FRAME 
         fiBorder:ROW IN FRAME DEFAULT-FRAME               = 6
         lbl-hndl = fiBorder:SIDE-LABEL-HANDLE IN FRAME DEFAULT-FRAME 
         lbl-hndl:ROW = lbl-hndl:ROW + fiBorder:ROW IN FRAME DEFAULT-FRAME  - widg-pos
         fiBorder:HIDDEN IN FRAME DEFAULT-FRAME            = no.

      ASSIGN
         fiPanelLabel:HIDDEN IN FRAME DEFAULT-FRAME        = yes
         fiPanelLabel:COL IN FRAME DEFAULT-FRAME           = 3
         fiPanelLabel:ROW IN FRAME DEFAULT-FRAME           = 5.29
         fiPanelLabel:HIDDEN IN FRAME DEFAULT-FRAME        = no.

      ASSIGN
         fiRows:HIDDEN IN FRAME DEFAULT-FRAME              = yes.

      ASSIGN
         fiTableLabel:HIDDEN IN FRAME DEFAULT-FRAME        = yes
         fiTableLabel:COL IN FRAME DEFAULT-FRAME           = 39
         fiTableLabel:HIDDEN IN FRAME DEFAULT-FRAME        = no.

      ASSIGN
         recPanel:HIDDEN IN FRAME DEFAULT-FRAME            = yes
         recPanel:COL IN FRAME DEFAULT-FRAME               = 2
         recPanel:HEIGHT IN FRAME DEFAULT-FRAME            = 3.29
         recPanel:ROW IN FRAME DEFAULT-FRAME               = 5.57
         recPanel:WIDTH IN FRAME DEFAULT-FRAME             = 34
         recPanel:HIDDEN IN FRAME DEFAULT-FRAME            = no.

      ASSIGN
         recPanel-2:HIDDEN IN FRAME DEFAULT-FRAME          = yes
         recPanel-2:WIDTH IN FRAME DEFAULT-FRAME           = 81
         recPanel-2:HIDDEN IN FRAME DEFAULT-FRAME          = no.

      ASSIGN
         recTable:HIDDEN IN FRAME DEFAULT-FRAME            = yes
         recTable:COL IN FRAME DEFAULT-FRAME               = 38
         recTable:WIDTH IN FRAME DEFAULT-FRAME             = 18
         recTable:HIDDEN IN FRAME DEFAULT-FRAME            = no.

      ASSIGN
         togAdd:HIDDEN IN FRAME DEFAULT-FRAME              = yes
         togAdd:COL IN FRAME DEFAULT-FRAME                 = 4
         togAdd:ROW IN FRAME DEFAULT-FRAME                 = 6.19
         togAdd:HIDDEN IN FRAME DEFAULT-FRAME              = no.

      ASSIGN
         togCancel:HIDDEN IN FRAME DEFAULT-FRAME           = yes.

      ASSIGN
         togDelete:HIDDEN IN FRAME DEFAULT-FRAME           = yes
         togDelete:COL IN FRAME DEFAULT-FRAME              = 18
         togDelete:ROW IN FRAME DEFAULT-FRAME              = 7.43
         togDelete:HIDDEN IN FRAME DEFAULT-FRAME           = no.

      ASSIGN
         togHeadings:HIDDEN IN FRAME DEFAULT-FRAME         = yes.

      ASSIGN
         togReset:HIDDEN IN FRAME DEFAULT-FRAME            = yes
         togReset:COL IN FRAME DEFAULT-FRAME               = 4
         togReset:ROW IN FRAME DEFAULT-FRAME               = 7.43
         togReset:HIDDEN IN FRAME DEFAULT-FRAME            = no.

      ASSIGN
         togSubmit:HIDDEN IN FRAME DEFAULT-FRAME           = yes
         togSubmit:COL IN FRAME DEFAULT-FRAME              = 18
         togSubmit:ROW IN FRAME DEFAULT-FRAME              = 6.19
         togSubmit:HIDDEN IN FRAME DEFAULT-FRAME           = no.

    END.  /* WebDetail Layout Case */

    WHEN "WebReport":U THEN DO:
      ASSIGN
         coSearchColumn:HIDDEN IN FRAME DEFAULT-FRAME      = yes
         coSearchColumn:WIDTH IN FRAME DEFAULT-FRAME       = 53
         coSearchColumn:HIDDEN IN FRAME DEFAULT-FRAME      = no.

      ASSIGN
         fiPanelLabel:HIDDEN IN FRAME DEFAULT-FRAME        = yes.

      ASSIGN
         recPanel:HIDDEN IN FRAME DEFAULT-FRAME            = yes.

      ASSIGN
         recPanel-2:HIDDEN IN FRAME DEFAULT-FRAME          = yes
         recPanel-2:WIDTH IN FRAME DEFAULT-FRAME           = 81
         recPanel-2:HIDDEN IN FRAME DEFAULT-FRAME          = no.

      ASSIGN
         togAdd:HIDDEN IN FRAME DEFAULT-FRAME              = yes.

      ASSIGN
         togCancel:HIDDEN IN FRAME DEFAULT-FRAME           = yes.

      ASSIGN
         togDelete:HIDDEN IN FRAME DEFAULT-FRAME           = yes.

      ASSIGN
         togReset:HIDDEN IN FRAME DEFAULT-FRAME            = yes.

      ASSIGN
         togSubmit:HIDDEN IN FRAME DEFAULT-FRAME           = yes.

    END.  /* WebReport Layout Case */

  END CASE.
END PROCEDURE.  /* Style-layouts */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initSearchColumn Style 
FUNCTION initSearchColumn RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: set the combo box sensitive if search is checked 
    Notes: 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOK        AS LOG NO-UNDO.
  DEFINE VARIABLE cColumn    AS CHAR NO-UNDO.  
  DEFINE VARIABLE cDB        AS CHAR NO-UNDO.  
  DEFINE VARIABLE cTable     AS CHAR NO-UNDO.  
  DEFINE VARIABLE iFld      AS INT  NO-UNDO.  
  DEFINE VARIABLE iNumInList AS INT  NO-UNDO.  
  DEFINE VARIABLE iNumInCol  AS INT  NO-UNDO.  
   
  DO WITH FRAME {&FRAME-NAME}: 
    IF VALID-HANDLE(gSDOHdl) THEN  
      ASSIGN 
        coSearchColumn:LIST-ITEMS  = DYNAMIC-FUNCTION('getDataColumns' IN gSDOHdl).
    
    ELSE 
    IF gTables <> "" THEN
    DO: 
      RUN adecomm/_mfldlst.p
       (INPUT coSearchColumn:HANDLE,
        INPUT gTables,
        INPUT ?,       /* No temp-tables  */
        INPUT yes,     /* Alpha sort      */ 
        INPUT "":U,    /* items (default) */
        INPUT TRUE,    /* Expand extents  */
        INPUT "":U,    /* Callback        */
        OUTPUT lOK).
      
      /* remove extent fields */
      DO iFLd = 1 TO coSearchColumn:NUM-ITEMS:
         IF INDEX(coSearchColumn:ENTRY(iFld),"[") <> 0 THEN
            coSearchColumn:DELETE(iFld).
      END.
      
      
    END. /* else if gtables <> '' */ 
    
    ASSIGN 
      coSearchColumn:SENSITIVE    = togSearch:CHECKED
      cColumn                     = getField("SearchColumns":U)
      cColumn                     = IF cColumn = "":U 
                                    THEN getField("firstSortColumn":U)
                                    ELSE cColumn   
      iNumInList = NUM-ENTRIES(coSearchColumn:ENTRY(1),".":U)
      iNumInCol  = NUM-ENTRIES(cColumn,".":U)
      .   
      coSearchColumn:ADD-FIRST(gNoValue).
       
    ASSIGN
      coSearchColumn:INNER-LINES  = MIN(xCmbInnerLines,coSearchColumn:NUM-ITEMS + 1)
      coSearchColumn:SCREEN-VALUE = IF cColumn <> "" 
                                    THEN cColumn 
                                    ELSE gNoValue NO-ERROR.    
  END. /* do with frame  */
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

