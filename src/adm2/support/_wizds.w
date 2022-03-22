&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
/* Procedure Description
"Data Source Wizard"
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

  File: _wizds.w

  Description: Data source wizard page  (Database or SDO)

  Input Parameters:
      hWizard (handle) - handle of Wizard dialog

  Output Parameters:
      <none>

  Author : Ross Hunter, Haavard Danielsen
  Created: Feb 98 
  
  Modified: 03/25/98 SLK Changed d-*.* to d*.*
  Modified: 05/03/98 HD  Check for include file on server if remote. 
  
      Note: This wizard is used for SmartBrowsers, HTML Reports and 
            Web-Objects with HTML Mapping. The Mapping objects has 
            some differences in the interface and query management.  
                   
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* NEVER NEVER Create an unnamed pool to store all the widgets created 
     by this procedure. This only assures that everything dynamic 
     that is created in this procedure will die as soon as this proecure dies  
 CREATE WIDGET-POOL.    
     */
     
/* ***************************  Definitions  ************************** */
{src/adm2/support/admhlp.i} /* ADM Help File Defs */

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER hWizard   AS WIDGET-HANDLE NO-UNDO.

/* Shared Variable Definitions ---                                      */
DEFINE SHARED VARIABLE fld-list AS CHARACTER             NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE gObjtype     AS CHARACTER NO-UNDO.
DEFINE VARIABLE gProcRecStr  AS CHARACTER NO-UNDO.
DEFINE VARIABLE gDataObject  AS CHARACTER NO-UNDO.
DEFINE VARIABLE gObjectType  AS CHARACTER NO-UNDO.
DEFINE VARIABLE gWeb         AS LOGICAL   NO-UNDO.
DEFINE Variable gWizardHdl   AS HANDLE    NO-UNDO.
DEFINE Variable gDataHdl     AS HANDLE    NO-UNDO.
DEFINE Variable gFirstRun    AS LOG       NO-UNDO.
 
    /* HTML Mapping objects have different query management 
       than SmartBrowsers and HTML REPORTS */         
DEFINE VARIABLE gHTMLMapping AS LOG       NO-UNDO. 

DEFINE Variable IsFirst     AS LOG       NO-UNDO.

/* Local Variables */  
DEFINE VARIABLE InfoData    AS CHAR      NO-UNDO. 

/* 
.cst entry to use when browsing for SmartDataObject.  
Current .cst implementation makes this hardcoding necessary 
*/ 
/* Constants */
DEFINE VARIABLE xSmartDataObject AS CHAR NO-UNDO INIT "SmartDataObject":U.
DEFINE VARIABLE xHTMLproc        AS CHAR NO-UNDO INIT "adeweb/_genwpg.p":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS e_msg btnHelp 
&Scoped-Define DISPLAYED-OBJECTS e_msg 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnHelp 
     LABEL "&Help on Data Sources" 
     SIZE 26 BY 1.14.

DEFINE BUTTON btnInstanceProperties 
     LABEL "&Instance Properties..." 
     SIZE 26 BY 1.14.

DEFINE VARIABLE e_msg AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 26 BY 6.86
     BGCOLOR 8  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     e_msg AT ROW 1.52 COL 57 NO-LABEL
     btnInstanceProperties AT ROW 8.62 COL 57
     btnHelp AT ROW 10.05 COL 57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.6 BY 10.42
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
         HEIGHT             = 10.81
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
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* SETTINGS FOR BUTTON btnInstanceProperties IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       e_msg:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

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
ON CHOOSE OF btnHelp IN FRAME DEFAULT-FRAME /* Help on Data Sources */
DO:
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&Help_on_Data_Sources}, ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnInstanceProperties
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnInstanceProperties C-Win
ON CHOOSE OF btnInstanceProperties IN FRAME DEFAULT-FRAME /* Instance Properties... */
DO:
  DEFINE VARIABLE hSDO    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cSDO    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRemote AS CHARACTER NO-UNDO.
    
  /* Ensure that the selected SDO is valid */
  RUN SaveData in gDataHDl(TRUE) NO-ERROR.
  
  IF NOT ERROR-STATUS:ERROR THEN
  DO:
    /* get the DataObject Name */
    RUN adeuib/_uibinfo.p (INT(gProcRecStr), ?, "DataObject":U, OUTPUT gDataObject).
    
    /* 
    The HTML mapping object acts as a container for the SDO and the SDO
    Instance Properties must be stored in adm-create-objects.
    Because of this we must find the SmartObject record used for the SDO and 
    run the AppBuilders Instance Property wrapper */ 
    
    IF gHTMLMapping THEN 
    DO:
      /* The SDO is a SmartObject in the HTML mapping object, get its id */
      RUN adeuib/_uibinfo.p (INT(gProcRecStr), ?,
                            "CONTAINS SmartObject":U, 
                             OUTPUT cSDO).
      /* Run the appbuilders property editor */  
      IF cSDO <> "" THEN                                 
        RUN adeuib/_edtsmar.p (INT(ENTRY(1,cSDO))).                
    END. /* if html mapping */
    ELSE /* if Embedded SpeedScript just call the support dialog */
    DO:       
      RUN getSDOHandle IN gWizardHdl(gDataObject, OUTPUT hSDO).      
      
      RUN editInstanceProperties IN hSdo NO-ERROR.                
      
    END.
    
  END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
ASSIGN FRAME {&FRAME-NAME}:FRAME    = hwizard
       FRAME {&FRAME-NAME}:HEIGHT-P = FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P
       FRAME {&FRAME-NAME}:WIDTH-P  = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P
       gWizardHdl                   = SOURCE-PROCEDURE.
       
/* VALUE-CHANGED of the radio-set in _datasrc applies 'U10' to its parent frame */
ON "U10" OF FRAME {&FRAME-NAME} ANYWHERE DO:
  btnInstanceProperties:SENSITIVE = NOT btnInstanceProperties:SENSITIVE. 
END. 
  
/* Get context id of procedure */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT gProcRecStr).

  /* Check if we have a DataObject */
RUN adeuib/_uibinfo.p (INT(gProcRecStr), ?, "DataObject":U, OUTPUT gDataObject).
  
  /* Check if this is a HTML file */
RUN adeuib/_uibinfo.p (INT(gProcRecStr), ?, "HTML-FILE-NAME":U, OUTPUT InfoData).

/* Get procedure type (Web-Object, SmartBrowser) */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U, OUTPUT gObjType).

/* WebReport uses &SCOP WEB-FILE  xxx.dat */ 
ASSIGN gHTMLMapping = (NUM-ENTRIES(InfoData,".") > 1 AND
                       ENTRY(2,InfoData,".") begins  "HTM") 
       gWeb = gObjType BEGINS "WEB":U. 

RUN adeuib/_datasrc.w PERSISTENT SET gDataHdl. 

SUBSCRIBE "ab_dataSourceRemoved":U IN gDataHdl.
SUBSCRIBE "ab_setSource":U IN gDataHdl RUN-PROCEDURE "initInstPropBtn".

IsFirst = DYNAMIC-FUNCTION("IsFirstRun" IN gWizardHdl, THIS-PROCEDURE:file-name).
  
DYNAMIC-FUNCTION('setHTMLMApping' IN gDataHdl,gHTMLMapping). 
DYNAMIC-FUNCTION('setParent' IN gDataHdl,FRAME {&FRAME-NAME}:HANDLE).
  
DYNAMIC-FUNCTION('setIsFirst' IN gDataHdl,IsFirst). 

RUN InitializeObject in gDataHdl.
         
ASSIGN
    
  FRAME {&FRAME-NAME}:HIDDEN   = NO    
  e_msg = "Specify a data source. Either choose a connected database, "                         
        + "or specify a SmartDataObject." 
 
  /* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
  CURRENT-WINDOW                = {&WINDOW-NAME} 
  THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
  RUN ProcessPage NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
  RUN destroyObject IN gDataHdl.
  RUN disable_UI.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN initPage. 
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ab_dataSourceRemoved C-Win 
PROCEDURE ab_dataSourceRemoved :
/*------------------------------------------------------------------------------
  Purpose:  API for publish from _datasrc.w     
  Parameters:  prId     - _P 
               pcTables - * delete all 
                          comma separated list of tables.
                           
  Notes:    The p_id input parameter is for future non-modal use.     
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER prID     AS RECID     NO-UNDO.
  DEF INPUT PARAMETER pcTables AS CHARACTER NO-UNDO.
  
  IF gHtmlMapping THEN       
    RUN adeweb/_unmapal.p (prId,pcTables). 
  ELSE
    ASSIGN fld-list = "":U.
  
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
  DISPLAY e_msg 
      WITH FRAME DEFAULT-FRAME.
  ENABLE e_msg btnHelp 
      WITH FRAME DEFAULT-FRAME.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initPage C-Win 
PROCEDURE initPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT gWeb THEN 
  DO WITH FRAMe {&FRAME-NAME}:
    ASSIGN 
      btnInstanceProperties:HIDDEN = TRUE
      e_msg:HEIGHT = e_msg:HEIGHT 
                     + (  btnInstanceProperties:ROW 
                        + btnInstanceProperties:HEIGHT)
                     - (e_msg:ROW                      
                        + e_msg:HEIGHT).
                         
  END.
  ELSE DO:
    btnInstanceProperties:SENSITIVE IN FRAME {&FRAME-NAME} = 
                                    /* unknown means that the radio-set is SDO*/  
       IsFirst OR gdataObject <> "" OR gDataObject = ?. 
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
   DEFINE VARIABLE LastButton  AS CHAR   NO-UNDO.
  
   LastButton = DYNAMIC-FUNCTION ("GetLastButton" IN gWizardHdl).
   
   IF LastButton = "CANCEL" THEN RETURN.
   RUN SaveData in gDataHDl(LastButton="NEXT":U) NO-ERROR.
   IF ERROR-STATUS:ERROR THEN RETURN ERROR.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

