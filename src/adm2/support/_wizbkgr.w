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

  File: _wizreps.w

  Description: Style page for HTML Report asnd Detail  

  Input Parameters:
      hWizard (handle) - handle of Wizard dialog

  Output Parameters:
      <none>

  Author : Haavard Danielsen
  Created: July 98 
  
      Note: This wizard stores and reads its data to/from xHTMLproc  
            using the getField and setField functions.  
                   
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{ src/adm2/support/admhlp.i } /* ADM Help File Defs */

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER hWizard     AS HANDLE NO-UNDO. 

DEFINE SHARED VARIABLE fld-list     AS CHAR   NO-UNDO.

DEFINE VARIABLE         gProcrecStr AS CHAR   NO-UNDO.
DEFINE VARIABLE         gObjType    AS CHAR   NO-UNDO.

DEFINE VARIABLE         gWizardHdl  AS HANDLE NO-UNDO.
DEFINE VARIABLE         gHTMLHdl    AS HANDLE NO-UNDO.

DEFINE VARIABLE         gTableRed   AS INT    NO-UNDO.
DEFINE VARIABLE         gTableGreen AS INT    NO-UNDO.
DEFINE VARIABLE         gTableBlue  AS INT    NO-UNDO.

DEFINE VARIABLE         gPageRed    AS INT    NO-UNDO.
DEFINE VARIABLE         gPageGreen  AS INT    NO-UNDO.
DEFINE VARIABLE         gPageBlue   AS INT    NO-UNDO.

DEFINE VARIABLE         glPageEdit  AS LOG    NO-UNDO.
DEFINE VARIABLE         glTableEdit AS LOG    NO-UNDO.

DEFINE VARIABLE         xHTMLproc   AS CHAR   INIT 'adeweb/_genwpg.p'  NO-UNDO.

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

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS e_msg fiPageColor BtnPageColor fiPageImage ~
fiTableColor BtnTableColor fiTableImage btnHelp fiPageLabel fiTableLabel 
&Scoped-Define DISPLAYED-OBJECTS e_msg fiPageColor fiPageImage fiTableColor ~
fiTableImage fiPageLabel fiTableLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD DisplayPageBgColor C-Win 
FUNCTION DisplayPageBgColor RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD DisplayTableBGColor C-Win 
FUNCTION DisplayTableBGColor RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD EditHex C-Win 
FUNCTION EditHex RETURNS LOGICAL
  (pChar AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initPageRGB C-Win 
FUNCTION initPageRGB RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initTableRGB C-Win 
FUNCTION initTableRGB RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD pasteData C-Win 
FUNCTION pasteData RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SavePageBgColor C-Win 
FUNCTION SavePageBgColor RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SavePageRGB C-Win 
FUNCTION SavePageRGB RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SaveTableBGcolor C-Win 
FUNCTION SaveTableBGcolor RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SaveTableRGB C-Win 
FUNCTION SaveTableRGB RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnHelp 
     LABEL "Help on Background" 
     SIZE 26 BY 1.14.

DEFINE BUTTON BtnPageColor 
     LABEL "Select &Color..." 
     SIZE 31 BY 1.14.

DEFINE BUTTON BtnTableColor 
     LABEL "Select C&olor..." 
     SIZE 31 BY 1.14.

DEFINE VARIABLE e_msg AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 26 BY 6.14
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE fiPageColor AS CHARACTER FORMAT "xxxxxx":U 
     LABEL "Color" 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1 TOOLTIP "Enter the color HEX value for the page background" NO-UNDO.

DEFINE VARIABLE fiPageImage AS CHARACTER FORMAT "X(256)":U 
     LABEL "Image" 
     VIEW-AS FILL-IN 
     SIZE 44 BY 1 TOOLTIP "Specify the image file to use for the background of the page." NO-UNDO.

DEFINE VARIABLE fiPageLabel AS CHARACTER FORMAT "X(256)":U INITIAL "&Page Background" 
      VIEW-AS TEXT 
     SIZE 18 BY .62 NO-UNDO.

DEFINE VARIABLE fiTableColor AS CHARACTER FORMAT "xxxxxx":U 
     LABEL "Color" 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1 TOOLTIP "Enter the color HEX value for the table background" NO-UNDO.

DEFINE VARIABLE fiTableImage AS CHARACTER FORMAT "X(256)":U 
     LABEL "Image" 
     VIEW-AS FILL-IN 
     SIZE 44 BY 1 TOOLTIP "Specify the image file to use for the background of the table." NO-UNDO.

DEFINE VARIABLE fiTableLabel AS CHARACTER FORMAT "X(256)":U INITIAL "&Table Background" 
      VIEW-AS TEXT 
     SIZE 18 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 3.52.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 3.52.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     e_msg AT ROW 1.52 COL 57 NO-LABEL
     fiPageColor AT ROW 2.19 COL 9 COLON-ALIGNED
     BtnPageColor AT ROW 2.19 COL 24
     fiPageImage AT ROW 3.62 COL 9 COLON-ALIGNED
     fiTableColor AT ROW 6.24 COL 9 COLON-ALIGNED
     BtnTableColor AT ROW 6.24 COL 24
     fiTableImage AT ROW 7.67 COL 9 COLON-ALIGNED
     btnHelp AT ROW 7.91 COL 57
     fiPageLabel AT ROW 1.24 COL 1 COLON-ALIGNED NO-LABEL
     fiTableLabel AT ROW 5.29 COL 1 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 5.52 COL 2
     RECT-1 AT ROW 1.52 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.57 BY 11.31
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert title>"
         HEIGHT             = 12.14
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

/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-2 IN FRAME DEFAULT-FRAME
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


&Scoped-define SELF-NAME btnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnHelp C-Win
ON CHOOSE OF btnHelp IN FRAME DEFAULT-FRAME /* Help on Background */
DO:
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&Help_on_Background}, ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnPageColor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnPageColor C-Win
ON CHOOSE OF BtnPageColor IN FRAME DEFAULT-FRAME /* Select Color... */
DO:
  DEF VAR iRed   AS INT NO-UNDO.
  DEF VAR iGreen AS INT NO-UNDO.
  DEF VAR iBlue  AS INT NO-UNDO.
  
  IF glPageEdit THEN 
    savePageBgColor().
  
  ASSIGN 
   iRed   = gPageRed
   iGreen = gPageGreen
   iBlue  = gPageBlue.
    
  Run adeweb/_htmlcol.p 
           ("PAGE":U, 
             INPUT-OUTPUT gPageRed,
             INPUT-OUTPUT gPageGreen,
             INPUT-OUTPUT gPageBlue,
             255, /* default is white */
             255,
             255).
  
  IF  iRed   <> gPageRed
  OR  iGreen <> gPageGreen
  OR  iBlue  <> gPageBlue THEN
    savePageRGB(). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnTableColor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnTableColor C-Win
ON CHOOSE OF BtnTableColor IN FRAME DEFAULT-FRAME /* Select Color... */
DO:
  DEF VAR iRed   AS INT NO-UNDO.
  DEF VAR iGreen AS INT NO-UNDO.
  DEF VAR iBlue  AS INT NO-UNDO.
  
  IF glTableEdit THEN 
    saveTableBgColor().
  
  ASSIGN 
   iRed   = gTableRed
   iGreen = gTableGreen
   iBlue  = gTableBlue.
     
  Run adeweb/_htmlcol.p 
          ("TABLE":U,
            INPUT-OUTPUT gTableRed,
            INPUT-OUTPUT gTableGreen,
            INPUT-OUTPUT gTableBlue,
            IF gPageRed   = ? THEN 255 ELSE gPageRed, /* default is page color */
            IF gPageGreen = ? THEN 255 ELSE gPageGreen,
            IF gPageBlue  = ? THEN 255 ELSE gPageBlue
           ).

  IF  iRed   <> gTableRed
  OR  iGreen <> gTableGreen
  OR  iBlue  <> gTableBlue THEN
    saveTableRGB(). 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPageColor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPageColor C-Win
ON ANY-KEY OF fiPageColor IN FRAME DEFAULT-FRAME /* Color */
DO:
  IF LAST-EVENT:LABEL = "CTRL-V":U THEN 
  DO:  
    IF NOT pasteData() THEN 
      RETURN NO-APPLY.
    glPageEdit = TRUE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPageColor C-Win
ON ANY-PRINTABLE OF fiPageColor IN FRAME DEFAULT-FRAME /* Color */
DO:
  DEF VAR ok AS LOG NO-UNDO.
  IF KEYFUNC(LASTKEY) <> " " THEN
  DO: 
    IF EditHex(CAPS(KEYFUNCTION(LASTKEY))) THEN 
    DO:
      glPageEdit = TRUE.
      APPLY CAPS(KEYFUNCTION(LASTKEY)).
    END.
    RETURN NO-APPLY.  
  END.
  glPageEdit = TRUE.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPageColor C-Win
ON DELETE-CHARACTER OF fiPageColor IN FRAME DEFAULT-FRAME /* Color */
OR BACKSPACE OF fiPageColor
DO:
  glPageEdit = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiTableColor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiTableColor C-Win
ON ANY-KEY OF fiTableColor IN FRAME DEFAULT-FRAME /* Color */
DO:
  IF LAST-EVENT:LABEL = "CTRL-V":U THEN 
  DO:  
    IF NOT pasteData() THEN 
      RETURN NO-APPLY.
    glTableEdit = TRUE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiTableColor C-Win
ON ANY-PRINTABLE OF fiTableColor IN FRAME DEFAULT-FRAME /* Color */
DO:
  DEF VAR ok AS LOG NO-UNDO.
  IF KEYFUNC(LASTKEY) <> " " THEN
  DO: 
    IF EditHex(CAPS(KEYFUNCTION(LASTKEY))) THEN 
    DO:
      glTableEdit = TRUE.
      APPLY CAPS(KEYFUNCTION(LASTKEY)).
    END.
    RETURN NO-APPLY.  
  END.
  glTableEdit = TRUE.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiTableColor C-Win
ON DELETE-CHARACTER OF fiTableColor IN FRAME DEFAULT-FRAME /* Color */
OR BACKSPACE OF fiTablecolor
DO:
  glTableEdit = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
ASSIGN gWizardHdl                   = SOURCE-PROCEDURE
       gHTMLHdl = DYNAMIC-FUNCTION("getSupportHandle" in gWizardHdl,xHTMLProc) 
       FRAME {&FRAME-NAME}:FRAME    = hwizard
       FRAME {&FRAME-NAME}:HEIGHT-P = FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P
       FRAME {&FRAME-NAME}:WIDTH-P  = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P
       fiPageLabel:WIDTH IN FRAME {&FRAME-NAME} = 
           FONT-TABLE:GET-TEXT-WIDTH-CHARS(fiPageLabel,FRAME {&FRAME-NAME}:FONT)
       fiTableLabel:WIDTH IN FRAME {&FRAME-NAME} = 
           FONT-TABLE:GET-TEXT-WIDTH-CHARS(fiTableLabel,FRAME {&FRAME-NAME}:FONT)
       /*
       /* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
       CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}
       */.

ON ALT-P OF FRAME {&FRAME-NAME} ANYWHERE 
  APPLY "ENTRY" TO fiPageColor. 

ON ALT-T OF FRAME {&FRAME-NAME} ANYWHERE 
  APPLY "ENTRY" TO fiTableColor. 

/* Get context id of procedure */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT gProcRecStr).
  
/* Get procedure type (Web-Object, SmartBrowser) */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U, OUTPUT gObjType).

ASSIGN 
 e_msg = "Use the options on this page to customize the background color "
       + "or image of your " + gObjType + ".":U.    

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
  
  initTableRGB().
  initPageRGB().
  RUN enable_UI.
  RUN DisplayPage.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ChooseImage C-Win 
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
  DO WITH FRAME {&FRAME-NAME}:
  
    ASSIGN 
      fiPageImage:SCREEN-VALUE   = getField("PageBackground":U) 
      fiTableImage:SCREEN-VALUE  = getField("TableBackground":U).  
  
  END. /* DO WITH FRAME */
  
  displayPageBgColor().
  displayTableBgColor().
  
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
  DISPLAY e_msg fiPageColor fiPageImage fiTableColor fiTableImage fiPageLabel 
          fiTableLabel 
      WITH FRAME DEFAULT-FRAME.
  ENABLE e_msg fiPageColor BtnPageColor fiPageImage fiTableColor BtnTableColor 
         fiTableImage btnHelp fiPageLabel fiTableLabel 
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
   DEF VAR LastButton   AS CHAR NO-UNDO.
   DEF VAR ProcIdStr    AS CHAR NO-UNDO.
   DEF VAR DataObject   AS CHAR NO-UNDO.
   DEF VAR HTMLTemplate AS CHAR NO-UNDO.

   LastButton = DYNAMIC-FUNCTION ("GetLastButton" IN gWizardHdl).
   
   IF LastButton = "CANCEL" THEN RETURN.
   
   /* Get context id of procedure */
   RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT ProcIdStr).
         
   RUN adecomm/_setcurs.p("WAIT":U).
   DO WITH FRAME {&FRAME-NAME}:
     IF LastButton = "NEXT":U THEn 
     DO:
       /**
       IF fiPageImage:SCREEN-VALUE <> "":U THEN
       DO:
         RUN adecomm/_relfile.p (fiPageImage:SCREEN-VALUE,
                                 YES, /* check remote if pref = remote */  
                                 "YES-NO":U, 
                                 OUTPUT fiPageImage).
         IF fiPageImage = ? THEN RETURN ERROR.
       END.
       IF fiTableImage:SCREEN-VALUE <> "":U THEN
       DO:             
         RUN adecomm/_relfile.p (fiTableImage:SCREEN-VALUE,
                                 YES, /* check remote if pref = remote */  
                                 "YES-NO":U, 
                                 OUTPUT fiTableImage).
         IF fiTableImage = ? THEN RETURN ERROR.      
       END.
        **/
     END.   /* if lastButtomn = 'next' */
     
     IF glPageEdit THEN 
       savePageBgColor().
     ELSE 
       savePageRGB().
  
     IF glTableEdit THEN
       saveTableBgColor().
     ELSE 
       saveTableRGB().

     setField("ProcId":U,ProcIdStr). 
     setField("PageBackground":U,fiPageImage:SCREEN-VALUE). 
     setField("TableBackground":U,fiTableImage:SCREEN-VALUE).
   END. /* do with frame */
   RUN adecomm/_setcurs.p("":U).    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION DisplayPageBgColor C-Win 
FUNCTION DisplayPageBgColor RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
   ASSIGN
     fiPageColor:SCREEN-VALUE  = SUBSTR(getField("PageBgColor":U),2).
  END. 
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION DisplayTableBGColor C-Win 
FUNCTION DisplayTableBGColor RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
   ASSIGN
     fiTableColor:SCREEN-VALUE  = SUBSTR(getField("TableBgColor":U),2).
  END. 
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION EditHex C-Win 
FUNCTION EditHex RETURNS LOGICAL
  (pChar AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Make sure the typed value is a HEX Value   
    Notes: Called from any-printable or any-key of color fields 
------------------------------------------------------------------------------*/
  IF INDEX("0123456789ABCDEF":U,pChar) = 0 THEN 
  DO:
    BELL.
    RETURN FALSE.
  END.  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initPageRGB C-Win 
FUNCTION initPageRGB RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Initialize the R G B values for the page background.  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN
    gPageRed    = INT(getField("PageBgRed":U))
    gPageGreen  = INT(getField("PageBgGreen":U))
    gPageBlue   = INT(getField("PageBgBlue":U)).
 
  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initTableRGB C-Win 
FUNCTION initTableRGB RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Initialize the R G B values for the table background. 
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN
    gTableRed    = INT(getField("TableBgRed":U))
    gTableGreen  = INT(getField("TableBgGreen":U))
    gTableBlue   = INT(getField("TableBgBlue":U)).

  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION pasteData C-Win 
FUNCTION pasteData RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Check if the user tries to paste data and if the data is legal to paste  
    Notes: Called from any-key if last-event:label = ctrl-v of color fields. 
------------------------------------------------------------------------------*/ 
  DEF VAR i  AS INT NO-UNDO. 
  DEF VAR ok AS LOG NO-UNDO. 
  DEF VAR ch AS CHAR NO-UNDO. 
  
  IF  CLIPBOARD:MULTIPLE      = FALSE 
  AND CLIPBOARD:ITEMS-PER-ROW = 1 THEN
  DO:
    DO i = 1 to LENGTH(CLIPBOARD:VALUE):
      ASSIGN 
        ch = SUBSTRING(CLIPBOARD:VALUE,i,1)        
        ok = ASC(ch) = (ASC(CAPS(ch))) AND EditHex(ch).
      
      IF NOT ok THEN
        LEAVE.
    END.
    IF ok THEN 
      RETURN TRUE. /* ok to paste */
  END.      
 
  BELL.
  RETURN FALSE. /* wrong data in clipboard */
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SavePageBgColor C-Win 
FUNCTION SavePageBgColor RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Save PAGE color value and reinitialize the Red Green Blue values   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColor AS CHAR No-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    cColor = IF fiPageColor:SCREEN-VALUE = "":U 
             THEN "??????":U /* unknown = default */
             ELSE fiPageColor:SCREEN-VALUE. 
  END.
  setField("PageBgColor":U,cColor).
  initPageRGB().
  
  RETURN TRUE.
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SavePageRGB C-Win 
FUNCTION SavePageRGB RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose: Save the page Red Green Blue values and display the new hex values.   
    Notes:  
------------------------------------------------------------------------------*/
  setField("PageBgRed",STRING(gPageRed)). 
  setField("PageBgGreen",STRING(gPageGreen)). 
  setField("PageBgBlue",STRING(gPageBlue)). 
  
  displayPageBgColor().
  glPageEdit = FALSE.
  RETURN TRUE. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SaveTableBGcolor C-Win 
FUNCTION SaveTableBGcolor RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Save table color value and reinitialize the Red Green Blue values   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColor AS CHAR No-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    cColor = IF fiTableColor:SCREEN-VALUE = "":U
             THEN "??????":U /* unknown = default */
             ELSE fiTableColor:SCREEN-VALUE. 
  END.      
  setField("TableBgColor":U,cColor).
  initTableRGB().
  
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SaveTableRGB C-Win 
FUNCTION SaveTableRGB RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose: Save the table Red Green Blue values and display the new hex values.   
    Notes:  
------------------------------------------------------------------------------*/
  setField("TableBgRed",STRING(gTableRed)). 
  setField("TableBgGreen",STRING(gTableGreen)). 
  setField("TableBgBlue",STRING(gTableBlue)). 
  
  displayTableBgColor().
  glTableEdit = FALSE.
  RETURN TRUE. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

