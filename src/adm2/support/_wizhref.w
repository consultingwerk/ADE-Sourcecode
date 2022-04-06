&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
/* Procedure Description
"Query Wizard"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File:       _wizhref.w
  Description: Link page of wizard for HTML Report and Detail  

  Input Parameters:
      hWizard (handle) - handle of Wizard dialog

  Output Parameters:
      <none>

  Author : Haavard Danielsen
  Created: July 98 
  Modifed: Mars 20. 1999 
           Added Joincolumns  
  
     Note: This wizard stores and reads its data to/from xHTMLproc  
           using getField and setField functions.  
                                      
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
DEFINE INPUT  PARAMETER hWizard      AS HANDLE  NO-UNDO. 

DEFINE SHARED VARIABLE  fld-list     AS CHAR    NO-UNDO.

DEFINE VARIABLE         ghWizard     AS HANDLE  NO-UNDO.
DEFINE VARIABLE         ghHTML       AS HANDLE  NO-UNDO.
DEFINE VARIABLE         gcProc       AS CHAR    NO-UNDO.
DEFINE VARIABLE         gcTables     AS CHAR    NO-UNDO.
DEFINE VARIABLE         gcObjType    AS CHAR    NO-UNDO.
DEFINE VARIABLE         gcDataObject AS CHAR    NO-UNDO.
DEFINE VARIABLE         ghDataObject AS HANDLE  NO-UNDO.

DEFINE VARIABLE         xHTMLproc    AS CHAR   INIT 'adeweb/_genwpg.p':U  NO-UNDO.
DEFINE VARIABLE         xcmbInner    AS INT    INIT 16                 NO-UNDO.

/* Use this as label for a detail wizard instead of "Status Line"*/ 
DEFINE VARIABLE         xDetailLabel AS CHAR   INIT 'Button Label' NO-UNDO.

&SCOP detail gcObjType MATCHES "*Detail*":U 
&SCOP none   "<none>":U

FUNCTION getField RETURNS CHARACTER
  (pField AS CHAR) IN ghHTML.

FUNCTION setField RETURNS LOGICAL
  ( pField AS CHAR,
    pValue AS CHAR) IN ghHTML.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS e_msg coLinkColumn fiWebObject btnBrwsPage ~
fiTarget fiStatus btnHelp raJoinLink seJoinColumns btnAddColumn ~
btnRemoveColumn fiLinkLabel fiParamLabel 
&Scoped-Define DISPLAYED-OBJECTS e_msg coLinkColumn fiWebObject fiTarget ~
fiStatus raJoinLink seJoinColumns fiLinkLabel fiParamLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initJoinColumns C-Win 
FUNCTION initJoinColumns RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnAddColumn 
     LABEL "&Add Columns..." 
     SIZE 25 BY 1.14.

DEFINE BUTTON btnBrwsPage 
     LABEL "&Browse..." 
     SIZE 12 BY 1.14.

DEFINE BUTTON btnHelp 
     LABEL "&Help on Hyperlink" 
     SIZE 26 BY 1.14.

DEFINE BUTTON btnRemoveColumn 
     LABEL "&Remove Column" 
     SIZE 25 BY 1.14.

DEFINE VARIABLE coLinkColumn AS CHARACTER FORMAT "X(256)":U 
     LABEL "Column" 
     VIEW-AS COMBO-BOX 
     DROP-DOWN-LIST
     SIZE 38 BY 1 TOOLTIP "Select the Column that you want to use as the link" NO-UNDO.

DEFINE VARIABLE e_msg AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 26 BY 4.48
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE fiLinkLabel AS CHARACTER FORMAT "X(256)":U INITIAL "HyperLink" 
      VIEW-AS TEXT 
     SIZE 10 BY .62 NO-UNDO.

DEFINE VARIABLE fiParamLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Parameters" 
      VIEW-AS TEXT 
     SIZE 16 BY .62 NO-UNDO.

DEFINE VARIABLE fiStatus AS CHARACTER FORMAT "X(256)":U 
     LABEL "Status line" 
     VIEW-AS FILL-IN 
     SIZE 38 BY 1 TOOLTIP "Enter the text to display in the &1 for the Hyperlink Field" NO-UNDO.

DEFINE VARIABLE fiTarget AS CHARACTER FORMAT "X(256)":U 
     LABEL "Target frame" 
     VIEW-AS FILL-IN 
     SIZE 38 BY 1 TOOLTIP "Enter the name of the frame in which to run the linked Web Object." NO-UNDO.

DEFINE VARIABLE fiWebObject AS CHARACTER FORMAT "X(256)":U 
     LABEL "Web object" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 TOOLTIP "Enter the file name of the Web Object to run when a user selects the hyperlink" NO-UNDO.

DEFINE VARIABLE raJoinLink AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&Columns", "C",
"Row&ids", "R",
"&None", "N"
     SIZE 13 BY 2.86 TOOLTIP "Specify how to pass record information to the linked object" NO-UNDO.

DEFINE RECTANGLE recLink
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 6.14.

DEFINE RECTANGLE recParam
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 81 BY 4.05.

DEFINE VARIABLE seJoinColumns AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 38 BY 3.33 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     e_msg AT ROW 1.52 COL 57 NO-LABEL
     coLinkColumn AT ROW 2.14 COL 15 COLON-ALIGNED
     fiWebObject AT ROW 3.62 COL 15 COLON-ALIGNED
     btnBrwsPage AT ROW 3.62 COL 43
     fiTarget AT ROW 5.05 COL 15 COLON-ALIGNED
     fiStatus AT ROW 6.48 COL 15 COLON-ALIGNED
     btnHelp AT ROW 6.52 COL 57
     raJoinLink AT ROW 8.62 COL 3 NO-LABEL
     seJoinColumns AT ROW 8.62 COL 17 NO-LABEL
     btnAddColumn AT ROW 8.62 COL 57
     btnRemoveColumn AT ROW 10.05 COL 57
     fiLinkLabel AT ROW 1.24 COL 1 COLON-ALIGNED NO-LABEL
     fiParamLabel AT ROW 7.86 COL 1 COLON-ALIGNED NO-LABEL
     recParam AT ROW 8.14 COL 2
     recLink AT ROW 1.52 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.6 BY 11.24
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
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert title>"
         HEIGHT             = 11.19
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
ASSIGN C-Win = CURRENT-WINDOW.




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
ASSIGN 
       e_msg:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       fiParamLabel:AUTO-RESIZE IN FRAME DEFAULT-FRAME      = TRUE.

/* SETTINGS FOR RECTANGLE recLink IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE recParam IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert title> */
DO:
  /* These events will close the window and terminate the procedure.      */
  /* (NOTE: this will override any user-defined triggers previously       */
  /*  defined on the window.)                                             */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnAddColumn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAddColumn C-Win
ON CHOOSE OF btnAddColumn IN FRAME DEFAULT-FRAME /* Add Columns... */
DO:
  DEFINE VARIABLE cJoinColumns AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNumElements AS CHARACTER NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    cJoinColumns = seJoinColumns:LIST-ITEMS.
    IF VALID-HANDLE(ghdataObject) THEN 
    DO: /* Choosing from a SDO */
      RUN adecomm/_mfldsel.p ("", 
                              ghDataObject, 
                              ?, 
                              "1",
                              seJoinColumns:DELIMITER,
                              "",
                              INPUT-OUTPUT cJoinColumns).
       RUN adecomm/_setcurs.p ("":U).
    END.  /* IF valid h_do */
    ELSE IF gcTables <> "" THEN 
    DO:
      cNumElements = IF NUM-ENTRIES(gcTables) = 1 
                     THEN "1":U
                     /* if period in tablename qualify with db */
                     ELSE IF INDEX(ENTRY(1,gcTables),".":U) > 0                      
                     THEN "3":U 
                     ELSE "2":U.
      
      /* remove tables from joinColumns */
      IF cNumElements = "1" THEN 
        cJoinColumns = REPLACE(cJoinColumns,gcTables + ".","":U).
      
      RUN adecomm/_mfldsel.p (gcTables, 
                              ?, 
                              ?, 
                              cNumElements,
                              seJoinColumns:DELIMITER,
                              "",
                              INPUT-OUTPUT cJoinColumns).
       RUN adecomm/_setcurs.p ("":U).
       
        /* Add tables to joincolumns */     
       IF cJoinColumns <> "":U AND cNumElements = "1" THEN 
         cJoinColumns = gcTables + ".":U 
                        + REPLACE(cJoinColumns,",":U,"," + gcTables + ".":U).
          
    
    END. /* else if gctables <> '' */
    seJoinColumns:LIST-ITEMS = cJoinColumns.
    initJoinColumns().
  END. /* do with frame */ 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnBrwsPage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnBrwsPage C-Win
ON CHOOSE OF btnBrwsPage IN FRAME DEFAULT-FRAME /* Browse... */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiWebObject. 

    RUN adecomm/_opnfile.w ("Choose a Web Object",
        "HTML Files(*.html;*.htm),Compiled Web Objects(*.r),Web Objects(*.w),
All Source(*.w;*.p;*.i;*.html;*.htm),All Files(*.*)",
INPUT-OUTPUT fiWebObject).
  
    IF fiWebObject <> "":U THEN
      DISPLAY fiWebObject.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnHelp C-Win
ON CHOOSE OF btnHelp IN FRAME DEFAULT-FRAME /* Help on Hyperlink */
DO:
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&Help_on_Link}, ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnRemoveColumn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnRemoveColumn C-Win
ON CHOOSE OF btnRemoveColumn IN FRAME DEFAULT-FRAME /* Remove Column */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    seJoinColumns:DELETE(seJoinColumns:SCREEN-VALUE).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raJoinLink
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raJoinLink C-Win
ON VALUE-CHANGED OF raJoinLink IN FRAME DEFAULT-FRAME
DO:
  initJoinColumns().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seJoinColumns
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seJoinColumns C-Win
ON VALUE-CHANGED OF seJoinColumns IN FRAME DEFAULT-FRAME
DO:
  initJoincolumns().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
ASSIGN FRAME {&FRAME-NAME}:FRAME    = hwizard
       FRAME {&FRAME-NAME}:HEIGHT-P = FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P
       FRAME {&FRAME-NAME}:WIDTH-P  = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P
       
       ghWizard        = SOURCE-PROCEDURE
       ghHTML          = DYNAMIC-FUNCTION("getSupportHandle" in ghWizard,
                                           xHTMLProc)
   
       fiLinkLabel:WIDTH IN FRAME {&FRAME-NAME} = 
           FONT-TABLE:GET-TEXT-WIDTH-CHARS(fiLinkLabel,FRAME {&FRAME-NAME}:FONT)
       fiParamLabel:WIDTH IN FRAME {&FRAME-NAME} = 
           FONT-TABLE:GET-TEXT-WIDTH-CHARS(fiParamLabel,FRAME {&FRAME-NAME}:FONT)
     
       e_msg = "Add link to another Web object and"
              + " specify parameters to pass to the linked object"
              + " in order to join to this object.  This step is optional."
       /*
       /* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
       CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}
        */.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
  RUN ProcessPage NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
  RUN disable_UI.
  USE "". 
END.
 
/* Get context id of procedure */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT gcProc).

RUN adeuib/_uibinfo.p(?,"PROCEDURE ?":U,"TYPE":U, OUTPUT gcObjType). 

/* Get the name of the associated DataObject */
RUN adeuib/_uibinfo.p (INT(gcProc), "":U, "DataObject":U, OUTPUT gcDataObject).

IF gcDataObject <> "" THEN
  RUN getSDOHandle IN ghWizard (gcDataObject, OUTPUT ghDataObject).
ELSE 
  gcTables = getField("Tables":U).

DO WITH FRAME {&FRAME-NAME}:
  IF {&detail} THEN
    fiStatus:LABEL = xDetailLabel.
  fiStatus:TOOLTIP = SUBSTITUTE(fiStatus:TOOLTIP,fiStatus:LABEL).
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
  FRAME {&FRAME-NAME}:HIDDEN   = NO.    
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayPage C-Win 
PROCEDURE DisplayPage :
/*------------------------------------------------------------------------------
  Purpose:     Display 4GL query if any and sets button label.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cJoinColumns    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i               AS INTEGER   NO-UNDO.
      
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN       
      fiTarget:SCREEN-VALUE     = getField("TargetFrame":U)
      fiStatus:SCREEN-VALUE     = getField("StatusLine":U)
      coLinkColumn:LIST-ITEMS   = "<none>," + fld-list
      coLinkColumn:INNER-LINES  = MAX(xCmbInner,coLinkColumn:NUM-ITEMS)
      coLinkColumn              = getField("LinkColumn":U) 
      coLinkColumn:SCREEN-VALUE = IF coLinkColumn = "":U OR 
                                  coLinkColumn:LOOKUP(coLinkColumn) = 0 
                                  THEN {&none}
                                  ELSE coLinkColumn                  
      cJoinColumns              = getField("JoinColumns":U)                                                                 
      raJoinLink:SCREEN-VALUE   = IF cJoinColumns = "ROWID" 
                                  THEN "R":U
                                  ELSE IF cJoinColumns <> "" 
                                  THEN "C":U
                                  ELSE "N":U       
      seJoinColumns:LIST-ITEMS   = IF raJoinLink:SCREEN-VALUE = "C"
                                   THEN cJoinColumns
                                   ELSE ?                            
      fiWebObject:SCREEN-VALUE   = getField("WebObject":U).      
      initJoinColumns().    
  END. /* DO WITH FRAME */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY e_msg coLinkColumn fiWebObject fiTarget fiStatus raJoinLink 
          seJoinColumns fiLinkLabel fiParamLabel 
      WITH FRAME DEFAULT-FRAME.
  ENABLE e_msg coLinkColumn fiWebObject btnBrwsPage fiTarget fiStatus btnHelp 
         raJoinLink seJoinColumns btnAddColumn btnRemoveColumn fiLinkLabel 
         fiParamLabel 
      WITH FRAME DEFAULT-FRAME.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ProcessPage C-Win 
PROCEDURE ProcessPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF VAR LastButton AS CHAR NO-UNDO.
   DEF VAR lAnswer    AS LOG  NO-UNDO.

   LastButton = DYNAMIC-FUNCTION ("GetLastButton":U IN ghWizard).
   
   IF LastButton = "CANCEL":U THEN RETURN.   
   
   RUN adecomm/_setcurs.p("WAIT":U).
   DO WITH FRAME {&FRAME-NAME}:
     IF LastButton = "NEXT":U THEN 
     DO:
       /* 
       If the radio-set = "columns" but no columns is picked we must set 
       the radio-set to "none", to prevent caos in the generated code. 
       When going back we want to keep the radio-set as selected 
       when returning to this page.  
       (This works because displayPage sets the radio-set to "C" when <> '',
        which also covers the ? stored when the list is empty)           
       */      
       
       IF  coLinkColumn:SCREEN-VALUE <> ?
       AND coLinkColumn:SCREEN-VALUE <> {&none}
       AND fiWebObject:SCREEN-VALUE = "" THEN 
       DO:
         MESSAGE 
           "There are no Web Object specified for the link." SKIP(1)  
           "Do you want to browse for a Web Object?" 
             VIEW-AS ALERT-BOX QUESTION 
             BUTTONS YES-NO-CANCEL UPDATE lAnswer.
         
         IF lAnswer = ? THEN /* If cancel don't go to next page */
         DO:
           APPLY "ENTRY" TO fiwebObject.
           RETURN ERROR.  
         END.
         IF lanswer THEN
           APPLY "CHOOSE":U To BtnBrwsPage.
               
       END. /* linkselecteed, but no object */
        
       IF  raJoinLink:SCREEN-VALUE = "C":U
       AND seJoinColumns:LIST-ITEMS = ? THEN
       DO:
         lanswer = no.
         IF  coLinkColumn:SCREEN-VALUE <> ?
         AND coLinkColumn:SCREEN-VALUE <> {&none}
         AND fiWebObject:SCREEN-VALUE <> "" THEN 
           MESSAGE 
             "There are no columns selected to pass to the link target." SKIP(1)  
             "Do you want to select columns?" SKIP
             VIEW-AS ALERT-BOX QUESTION 
             BUTTONS YES-NO-CANCEL UPDATE lAnswer.
         
         IF lAnswer = ? THEN /* If cancel don't go to next page */  
         DO: 
           APPLY "ENTRY" TO raJoinLink.          
           RETURN ERROR.              
         END.
         
         IF lAnswer THEN  /* if yes choose columns */ 
           APPLY "choose":U TO btnAddColumn.
         
         /* if still no columns selected just set the radioset to none */ 
         IF seJoinColumns:LIST-ITEMS = ? THEN           
           raJoinLink:SCREEN-VALUE = "N":U.
         
       END. /* radioset = c for columns, but no columns in list */ 
                                                                  
       /*** 
       IF fiWebObject:SCREEN-VALUE <> "":U THEN
       DO:
         RUN adecomm/_relfile.p (fiWebObject:SCREEN-VALUE,
                                 YES, /* check remote if pref = remote */  
                                 "VerBose:Web Object":U, 
                                 OUTPUT fiWebobject).
         IF fiWebObject = ? THEN RETURN ERROR.
       END.
       IF fiStyleSheet:SCREEN-VALUE <> "":U THEN
       DO:             
         RUN adecomm/_relfile.p (fiStyleSheet:SCREEN-VALUE,
                                 YES, /* check remote if pref = remote */  
                                 "VerBose:Style Sheet":U, 
                                 OUTPUT fiStyleSheet).
         IF fiStyleSheet = ? THEN RETURN ERROR.      
       END.
       **/ 
     END.   /* if lastButtomn = 'next' */ 
     setField("TargetFrame":U,fiTarget:SCREEN-VALUE).
     setField("StatusLine":U,fiStatus:SCREEN-VALUE).
     setField("LinkColumn":U,IF coLinkColumn:SCREEN-VALUE = {&none} 
                             THEN "":U
                             ELSE coLinkColumn:SCREEN-VALUE).
     setField("WebObject":U,fiWebObject:SCREEN-VALUE).  
     setField("JoinColumns":U,IF raJoinLink:SCREEN-VALUE = "C":U
                              THEN seJoinColumns:LIST-ITEMS
                              ELSE IF raJoinLink:SCREEN-VALUE = "R":U
                              THEN "ROWID":U
                              ELSE "":U ).            
   END.      
   
   RUN adecomm/_setcurs.p("":U).    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initJoinColumns C-Win 
FUNCTION initJoinColumns RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      seJoinColumns:SENSITIVE    = raJoinLink:SCREEN-VALUE = "C":U  
      btnAddColumn:SENSITIVE     = seJoinColumns:SENSITIVE
      btnRemoveColumn:SENSITIVE  = (seJoinColumns:SCREEN-VALUE <> ?)
      seJoinColumns:SCREEN-VALUE = IF seJoinColumns:SENSITIVE 
                                   THEN seJoinColumns:SCREEN-VALUE
                                   ELSE ?.      
  END.
  RETURN TRUE.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

