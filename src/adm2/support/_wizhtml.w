&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
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

  File: _wizhtml.w

  Description: HTML File wizard screen 

  Input Parameters:
      hWizard (hdl) - handle of Wizard dialog

  Output Parameters:
      <none>

  Author: Haavard Danielsen 

  Created: 2/13/98  
  
  Note:   The f_HTML fill-in is UNDO. 
          It is assigned in ProcessPage, but if something goes wrong
          it should be undone.      
            
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* 
DO NOT CREATE A WIDGET POOL TO store all the widgets created,
because they will disappear when the procedure is deleted. 

CREATE WIDGET-POOL.
*/

/* ***************************  Definitions  ************************** */
{ src/adm2/support/admhlp.i } /* ADM Help Defs */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER hWizard AS WIDGET-HANDLE NO-UNDO.

/** In some cases we don't want to delete procedures when going back,
    instead they will be hidden and stored here.
    
    Page procedures that need this functionality must have 
    a internal viewObject procedure.   
**/      
   
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE WizardHdl       AS HANDLE        NO-UNDO.
DEFINE VARIABLE proc-recid      AS CHARACTER     NO-UNDO.
DEFINE VARIABLE s-recid         AS INTEGER       NO-UNDO INIT ?.
DEFINE VARIABLE def-code        AS CHARACTER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS e_xtbl f_HTML b_Browse btnHelp fiHTMLLabel ~
RECT-1 
&Scoped-Define DISPLAYED-OBJECTS e_xtbl f_HTML fiHTMLLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnHelp 
     LABEL "Help on HTML files" 
     SIZE 26 BY 1.14.

DEFINE BUTTON b_Browse 
     LABEL "Browse..." 
     SIZE 15 BY 1.14.

DEFINE VARIABLE e_xtbl AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 26 BY 5.38
     BGCOLOR 8 FONT 4 NO-UNDO.

DEFINE VARIABLE fiHTMLLabel AS CHARACTER FORMAT "X(256)":U INITIAL "HTML File" 
      VIEW-AS TEXT 
     SIZE 10 BY .62 NO-UNDO.

DEFINE VARIABLE f_HTML AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY 1.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 2.14.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     e_xtbl AT ROW 1.52 COL 57 NO-LABEL
     f_HTML AT ROW 2.14 COL 3 NO-LABEL
     b_Browse AT ROW 2.14 COL 40
     btnHelp AT ROW 9.81 COL 57
     fiHTMLLabel AT ROW 1.24 COL 1 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1.52 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.86 BY 11.35.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Window
   Frames: 1
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert window title>"
         HEIGHT             = 11.14
         WIDTH              = 83.8
         MAX-HEIGHT         = 37.57
         MAX-WIDTH          = 182.8
         VIRTUAL-HEIGHT     = 37.57
         VIRTUAL-WIDTH      = 182.8
         SHOW-IN-TASKBAR    = no
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
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
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
ASSIGN 
       e_xtbl:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN f_HTML IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
ASSIGN 
       f_HTML:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnHelp C-Win
ON CHOOSE OF btnHelp IN FRAME DEFAULT-FRAME /* Help on HTML files */
DO:
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&Help_on_HTML_files}, ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Browse C-Win
ON CHOOSE OF b_Browse IN FRAME DEFAULT-FRAME /* Browse... */
DO:
  RUN getFilename. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
ASSIGN FRAME {&FRAME-NAME}:FRAME    = hwizard
       FRAME {&FRAME-NAME}:HEIGHT-P =  FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P
       FRAME {&FRAME-NAME}:WIDTH-P  =  FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P      
       FRAME {&FRAME-NAME}:HIDDEN   = NO 
/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
       CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}
       WizardHdl                     = SOURCE-PROCEDURE
       
       /* Workaropund for problems with size differences 
          with small fonts and large fonts */
       fiHTMLLabel:WIDTH IN FRAME {&FRAME-NAME} = 
           FONT-TABLE:GET-TEXT-WIDTH-CHARS(fiHTMLLabel,FRAME {&FRAME-NAME}:FONT)
       .
          
/* Get Procedure context (recid of procedure record in the UIB) */
RUN adeuib/_uibinfo.p(?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT proc-recid).

/* Get HTML filename (If we are going back ) */
RUN adeuib/_uibinfo.p(INT(proc-recid),?,"HTML-FILE-NAME", OUTPUT f_HTML). 

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO: 

  RUN ProcessPage NO-ERROR.
    
  IF ERROR-STATUS:ERROR THEN 
  DO:
    APPLY "U2" TO hWizard. /* ok to finish = false */
    RETURN NO-APPLY.
  END. 
  ELSE 
    APPLY "U1" TO hWizard.  /* ok to finish */
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
  Purpose:     Check the type of object associated with this Wizard page..
               Load appropriate images and set the message text.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE objtype AS CHARACTER NO-UNDO.
  DEFINE VARIABLE l       AS LOGICAL   NO-UNDO.
  e_xtbl = "Select an HTML File to map, then press Next.".    
  DISPLAY e_xtbl WITH FRAME {&FRAME-NAME}.
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
  DISPLAY e_xtbl f_HTML fiHTMLLabel 
      WITH FRAME DEFAULT-FRAME.
  ENABLE e_xtbl f_HTML b_Browse btnHelp fiHTMLLabel RECT-1 
      WITH FRAME DEFAULT-FRAME.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFilename C-Win 
PROCEDURE getFilename :
DEFINE VARIABLE FileName AS CHAR.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      FileName = TRIM(f_HTML:SCREEN-VALUE).
  
    RUN adecomm/_opnfile.w 
                ("Choose an HTML File",
                 "HTML Files (*.htm;*.html)",
                 INPUT-OUTPUT FileName).
  
    IF FileName <> "":U THEN
      ASSIGN
        f_HTML:SCREEN-VALUE = FileName.
  END.
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
  DEFINE VARIABLE lOk             AS LOGICAL   NO-UNDO. 
  DEFINE VARIABLE cFrameId        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cInfo           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lRemote         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cBrokerURL      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOffsetFile     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRelName        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSearchFileName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cLastButton     AS CHARACTER NO-UNDO.

  cLastButton = DYNAMIC-FUNCTION ("GetLastButton":U IN WizardHdl) NO-ERROR.
  
  IF cLastButton = "CANCEL":U OR cLastButton = ? THEN RETURN.
  
  /* check if f_html:screen-value is valid */
  IF cLastButton = "NEXT":U THEN
  DO WITH FRAME {&FRAME-NAME}:
    
    IF f_HTML:SCREEN-VALUE = '' THEN
    DO:
      MESSAGE "Please enter an HTML filename.":T VIEW-AS ALERT-BOX.  
      RETURN ERROR.         
    END.
    
    IF INDEX(f_HTML:SCREEN-VALUE,".") > 0 
    THEN 
    DO: 
      IF NOT CAN-DO("htm,html",
                 SUBSTR(f_HTML:SCREEN-VALUE,
                        R-INDEX(f_HTML:SCREEN-VALUE,".":U) + 1)
                ) THEN
      DO:              
        MESSAGE "You can only use HTML files with extention .htm or .html":T 
        VIEW-AS ALERT-BOX INFORMATION.           
        RETURN ERROR.         
      END.
    END.
    ELSE 
      ASSIGN f_HTML:SCREEN-VALUE = f_HTML:SCREEN-VALUE + ".htm":U.  
    
    RUN adecomm/_relfile.p (f_HTML:SCREEN-VALUE,
                            Yes, /* Check remote if preferences is set */
                            "Verbose,file-info":U, 
                            OUTPUT cRelName).
    
    IF RETURN-VALUE = "ERROR":U THEN RETURN ERROR. 
    
    IF cRelName = ? OR cRelName = "" THEN RETURN ERROR.
    
    /* The file is not readable if there is no R in the returned filetype */
    IF NUM-ENTRIES(cRelName,":") = 2 
    AND INDEX(ENTRY(2,cRelName,":"),"R":U) = 0 THEN 
    DO:        
       Message 
        "The HTML file" ENTRY(1,cRelName,":":U) "is not readable." skip
        "This will result in an error if a new offset file needs to be generated."
        skip
        "The permissions must be set to readable in order to run the file." skip(1)
        "Do you want to continue?"            
       VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lok.
       IF NOT lok THEN RETURN ERROR.  
    END.
      
    ASSIGN       
      /* remove the file-info added to the relname by _relfile.p */        
      ENTRY(NUM-ENTRIES(cRelName,":"),cRelName,":") = ""      
      cRelName            = RIGHT-TRIM(cRelName,":")
      f_HTML:SCREEN-VALUE = cRelName.
    
     
    RUN adecomm/_setcurs.p("WAIT":U).
  
  END. /* if last-button = b_next */  
  
  /* Everything relating to the .html must be stored also on BACK */  
  
  /* If HTML file is changed, delete the widgets of the old one */    
  IF  INPUT FRAME {&FRAME-NAME} f_HTML <> f_HTML  
  AND f_HTML <> "":U THEN
  DO: 
    RUN adeuib/_uibinfo.p
          (proc-recid, ?,
          "CONTAINS FRAME RETURN CONTEXT":U, 
          OUTPUT cFrameId).
        
     IF cFrameId <> "":U THEN          
        RUN adeuib/_uib_del.p(INTEGER(cFrameId)).        
      
     IF RETURN-VALUE = "FAIL" THEN RETURN ERROR.    
  END.
   
  ASSIGN f_HTML. /* This field is set to UNDO so that 
                    return ERROR undoes it */    
  
  RUN adeuib/_setwatr.w(INT(proc-recid),"HTMLFileName":U,f_HTML, OUTPUT lOk). 
     
  IF NOT lOk THEN RETURN ERROR. 
  
     
  IF cLastButton = "NEXT":U THEN
  DO:
    RUN adeuib/_uibinfo.p
    (?, 
     "SESSION":U,
     "REMOTE":U, 
     OUTPUT cInfo).
        
    ASSIGN 
      lRemote = CAN-DO("TRUE,YES":U,cInfo)
      lOk     = TRUE.
    
    /* If remote generate the offset file on the server 
       and fetch a tempfile copy */
    IF lRemote THEN 
    DO:          
      RUN adeuib/_uibinfo.p
          (?, 
           "SESSION":U,
           "BrokerURL":U, 
           OUTPUT cBrokerURL).
      
      RUN adeweb/_webcom.w(INT(proc-recid),
                           cBrokerURL,
                           f_HTML,
                           "offset":U, 
                           OUTPUT cRelName, 
                           INPUT-OUTPUT cOffSetFile).
      IF cRelName = ? THEN 
      DO:
        MESSAGE "The offset file was not successfully generated on the server."
        VIEW-AS ALERT-BOX.
        ASSIGN lok = FALSE.
      END.               
    END. 
    
    IF lOk THEN
    DO:
          /* _rdoffd.p handles .htm as input */
      RUN adeweb/_rdoffd.p (proc-recid, IF lRemote THEN cOffSetFile
                                        ELSE            f_HTML ).  
    
      RUN adeweb/_drwhtml.p(INT(proc-recid), no, OUTPUT lOk).    
    
      /* Delete the remote temp file */
      IF lRemote THEN 
        OS-DELETE VALUE(cOffsetFile).
  
      RUN adecomm/_setcurs.p("":U).
    END.
    
    IF NOt lOk THEN RETURN ERROR.      
  END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

