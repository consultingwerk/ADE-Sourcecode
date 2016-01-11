&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
/* Procedure Description
"Query Wizard"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------

  File: _datasrc.w

  Description: Select DataSource 

  Output Parameters:
      
  PUBLISHED events.          
       - ab_dataSourceRemoved
          
         This procedure may be used both from the treeview and the wizards
         If the wizards are used for embedded speedscript the data are stored 
         in _genwpg.w. 
          
         publish is used in order not to have to keep track of the handles in 
         all these different cases. (This procedure is sometimes rumning from a wizard and
         sometimes from a dialog).  
                        
         Known subscribers  
           _wizds.w  
           _genwpg.p  
           _tview.w 
        
       - ab_setDataObject  
        
        (see comments in code)          
         Known subscribers  
          _tview.w                           
          
  Author : Ross Hunter, Haavard Danielsen
  Created: Feb 98 
  
  Modified: 03/25/98 SLK Changed d-*.* to d*.*
  Modified: 05/03/98 HD  Check for include file on server if remote. 
  Modified: 07/13/98 HD  Moved from wizard to persistent procedure 
                         so it can be ucalled from adeuib/_dlgsrc.w  
  Modified: 07/17/98 HD  Don't throw away fields if query tables is not changed  
                         (You should not loose the fieldlist if sort is changed)  
  Modified: 03/24/99 HD  Simplified datasource changes by always publishing
                         ONE event, and removed direct calls to abunmapal   
                                                  
      Note: This program is used for SmartBrowsers and all Web-Objects 
            
            The procedure was originally written as wizard code
            
            The uniwidg include was introduced to solve treeview instance 
            properties. 
            
                    
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */
/*
DON'T CREATE WIDGET-POOL BECAUSE WIDGETS WILL DIE WITH IT 
(_U for the query )

*/

/* ***************************  Definitions  ************************** */
{ adeuib/uniwidg.i }

{adecomm/oeideservice.i}

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE gObjtype     AS CHARACTER NO-UNDO.
DEFINE VARIABLE gQueryId     AS INTEGER   NO-UNDO.
DEFINE VARIABLE gProcRecStr  AS CHARACTER NO-UNDO.
DEFINE Variable gParentHdl   AS HANDLE    NO-UNDO.
DEFINE Variable gFirstRun    AS LOG       NO-UNDO.
    
DEFINE VARIABLE gHTMLMapping AS LOG       NO-UNDO. 
DEFINE VARIABLE gWeb         AS LOG       NO-UNDO. 

DEFINE Variable gInitSDO    AS CHARACTER NO-UNDO.
DEFINE Variable gInitTables AS CHARACTER NO-UNDO.
DEFINE Variable gInitMode   AS CHARACTER NO-UNDO.

/* 
.cst entry to use when browsing for SmartDataObject.  
Current .cst implementation makes this hardcoding necessary 
*/ 
/* Constants */
DEFINE VARIABLE xSmartDataObject AS CHAR NO-UNDO INIT "SmartDataObject":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rectDataSrc rsDataSource fDataObject btnBrws ~
btnDefqry e4GLQuery fiDataSourceLabel 
&Scoped-Define DISPLAYED-OBJECTS rsDataSource fDataObject fiDataSourceLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD procQuery C-Win 
FUNCTION procQuery RETURNS INTEGER
  (prProc AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHTMLMapping C-Win 
FUNCTION setHTMLMapping RETURNS LOGICAL
  (pHTML AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SetIsFirst C-Win 
FUNCTION SetIsFirst RETURNS LOGICAL
  (pFirst As LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setParent C-Win 
FUNCTION setParent RETURNS LOGICAL
  (pFrame as HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SetRectTitle C-Win 
FUNCTION SetRectTitle RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnBrws 
     LABEL "B&rowse..." 
     SIZE 17 BY 1.14.

DEFINE BUTTON btnDefqry 
     LABEL "Define &Query..." 
     SIZE 17 BY 1.14.

DEFINE VARIABLE e4GLQuery AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 52 BY 4.43 NO-UNDO.

DEFINE VARIABLE fDataObject AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN NATIVE 
     SIZE 34.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiDataSourceLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Data source" 
      VIEW-AS TEXT 
     SIZE 24 BY .62 NO-UNDO.

DEFINE VARIABLE rsDataSource AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&SmartDataObject", "SDO",
"&Database", "DB"
     SIZE 22 BY 5.91 NO-UNDO.

DEFINE RECTANGLE rectDataSrc
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 54 BY 9.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     rsDataSource AT ROW 1 COL 3 NO-LABEL
     fDataObject AT ROW 3.62 COL 3 NO-LABEL
     btnBrws AT ROW 3.62 COL 38
     btnDefqry AT ROW 5.19 COL 38
     e4GLQuery AT ROW 6.57 COL 3 NO-LABEL
     fiDataSourceLabel AT ROW 1.24 COL 1 COLON-ALIGNED NO-LABEL
     "SmartDataObject filename:" VIEW-AS TEXT
          SIZE 26 BY .62 AT ROW 2.95 COL 3
     rectDataSrc AT ROW 1.52 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 55.2 BY 10.24
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
         HEIGHT             = 10.76
         WIDTH              = 55.6
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
   FRAME-NAME                                                           */
/* SETTINGS FOR EDITOR e4GLQuery IN FRAME DEFAULT-FRAME
   NO-DISPLAY                                                           */
ASSIGN 
       e4GLQuery:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN fDataObject IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
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


&Scoped-define SELF-NAME btnBrws
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnBrws C-Win
ON CHOOSE OF btnBrws IN FRAME DEFAULT-FRAME /* Browse... */
DO:
  run chooseSDOHandler.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnDefqry
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnDefqry C-Win
ON CHOOSE OF btnDefqry IN FRAME DEFAULT-FRAME /* Define Query... */
DO:
  DEFINE VARIABLE ok  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cId AS CHAR   NO-UNDO.
  
  RUN DBPrompt("to define a query", OUTPUT ok). 
  
  IF ok THEN
  DO:
    IF gQueryId = 0 THEN 
    DO:
        run addQueryHandler.
    END.
    ELSE DO:
        run queryBuilderHandler.  
    END. 
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsDataSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDataSource C-Win
ON VALUE-CHANGED OF rsDataSource IN FRAME DEFAULT-FRAME
DO:
  ASSIGN rsDataSource.
  RUN setMode(SELF:SCREEN-VALUE).
  APPLY "U10" TO gParentHdl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addQuery C-Win
procedure addQuery:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
      define variable cid as character no-undo.
      RUN adeuib/_drwqry.p.            
      RUN adeuib/_uibinfo.p (INT(gProcRecStr), "PROCEDURE ?":U, 
           "CONTAINS QUERY RETURN CONTEXT":U, OUTPUT cId).
      gQueryId = INT(cId).
      RUN DisplayObject.

end procedure.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addQueryHandler C-Win 
PROCEDURE addQueryHandler :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
   define variable ideevent as adeuib.iideeventservice no-undo.
   if OEIDEIsRunning then    
   do:
       ideevent = new adeuib._ideeventservice(). 
       ideevent:SetCurrentEvent(this-procedure,"addQuery").
       run runChildDialog in hOEIDEService (ideevent) .
   end.
   else do:
       run addQuery.
   end.  

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chooseSDO C-Win
procedure chooseSDO:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  RUN adecomm/_chossdo.p ("PREVIEW,BROWSE":U, 
                           gWeb, /*  remote */
                           INPUT-OUTPUT fDataObject).
                      
  DISPLAY fDataObject WITH FRAME {&FRAME-NAME}. 

end procedure.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chooseSDOHandler C-Win
procedure chooseSDOHandler:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
   define variable ideevent as adeuib.iideeventservice no-undo.
   if OEIDEIsRunning then    
   do:
       ideevent = new adeuib._ideeventservice(). 
       ideevent:SetCurrentEvent(this-procedure,"chooseSDO").
       run runChildDialog in hOEIDEService (ideevent) .
   end.
   else do:
       run chooseSDO.
   end.  


end procedure.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DBPrompt C-Win 
PROCEDURE DBPrompt :
/*------------------------------------------------------------------------------
  Purpose: Prompt for db     
  Parameters: input   - pReason: to definee a query , to use an SDO ... etc.
              output  - pOk      True if ok to continue.
  Notes:      Because this wizard page is used for different objects this question 
              may occur on different places.  
------------------------------------------------------------------------------*/
  DEF INPUT  PARAMETER pReason AS CHAR NO-UNDO INITIAL TRUE. 
  
  DEF OUTPUT PARAMETER pOk   AS LOG NO-UNDO INITIAL TRUE. 
  
  DEF VARIABLE cRemote     AS CHAR NO-UNDO. 
  DEF VARIABLE lRemote     AS LOG  NO-UNDO. 
  DEF VARIABLE lDb        AS LOG  NO-UNDO. 
  
  ASSIGN lDb = rsDataSource:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "DB":U.
  
  /* Check if we need to connect (Only necessary for local SDO) */
  IF NOT lDb THEN         
  DO:
    RUN adeuib/_uibinfo.p (?,"SESSION":U,"REMOTE":U, OUTPUT cRemote).
    lRemote = CAN-DO("YES,TRUE":U,cRemote).            
  END.
  
  IF NUM-DBS = 0 AND (lDb OR NOT lRemote) THEN 
    RUN adecomm/_dbcnnct.p (
        INPUT "You must have at least one connected database "
               + pReason 
               + "." + CHR(10),
        OUTPUT pOk).         

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject C-Win 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN disable_UI.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayObject C-Win 
PROCEDURE DisplayObject :
/*------------------------------------------------------------------------------
  Purpose:     Display 4GL query if any and sets button label.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE qSyntax    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE DataObject AS CHARACTER NO-UNDO.
  DEFINE VARIABLE IsFirst    AS LOGICAL   NO-UNDO.    
  DEFINE VARIABLE Initmode   AS LOGICAL   NO-UNDO.    
  DEFINE VARIABLE cLabel     AS CHARACTER NO-UNDO.    

   
  IF gQueryId <> 0 THEN 
    RUN adeuib/_uibinfo.p(gQueryId, ?, "4GL-QUERY":U, OUTPUT e4glQuery).
       
  DO WITH FRAME {&FRAME-NAME}:
    
    /* gFirstrun is used to default to SDO at the first attempt. 
      (If the user select DB -> BACK -> NEXT it is NOT first, but there's no way 
       to see that from the data, because there may be a default empty query)
       fdataObject is set to unknown if SDO is checked when pressing BACK 
         
      When called from _tview -> _dlgdsrc the isfirst is always true so the 
      e4glquery is checked to see if a DB should be default
      The check for <> DB is done to ensure that CANCEL from QB gets right value)
       */
    IF (gFirstRun AND (e4glQuery = "":U AND rsDataSource:screen-value <> "DB":U)) 
    OR (fDataObject <> "":U AND rsDataSource:screen-value = "SDO":U) THEN     
    DO:
      IF fDataObject = ? THEN fDataObject = "":U. 
      RUN setMODE("SDO":U).       
    END.
    ELSE 
    DO:
      RUN setMode("DB":U).
    END.
  END. /* DO WITH FRAME */
  btnDefqry:LABEL = IF e4glQuery = "":U 
                    THEN "Define &Query..."
                    ELSE "Modify &Query...".         
     
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
  DISPLAY rsDataSource fDataObject fiDataSourceLabel 
      WITH FRAME DEFAULT-FRAME.
  ENABLE rectDataSrc rsDataSource fDataObject btnBrws btnDefqry e4GLQuery 
         fiDataSourceLabel 
      WITH FRAME DEFAULT-FRAME.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject C-Win 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
ASSIGN FRAME {&FRAME-NAME}:FRAME = gParentHdl.

SetRectTitle().
    
/* Get context id of procedure */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT gProcRecStr).
  
/* Get procedure type (Web-Object, SmartBrowser) */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U, OUTPUT gObjType).


/* get the query/browser id */
gQueryId = procQuery(INT(gProcRecStr)).

/** Log old values to see if we can keep the field-list when 
    we are finished */
RUN adeuib/_uibinfo.p (INTEGER(gProcRecStr)," ":U,"DataObject":U,OUTPUT gInitSDO). 

IF gQueryId <> 0 THEN 
  RUN adeuib/_uibinfo.p(gQueryId, ?, "TABLES":U, OUTPUT gInitTables).

ASSIGN
  gWeb        = gObjType BEGINS "WEB":U 
  fDataObject = gInitSDO.  
     
RUN Enable_UI.
RUN DisplayObject.
FRAME {&FRAME-NAME}:HIDDEN   = NO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryBuilder C-Win 
PROCEDURE openQueryBuilder :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define variable arg as character no-undo. 
    ASSIGN arg = "QUERY-ONLY":U. /* Run QB on query only (no fields) */
    RUN adeuib/_uib_dlg.p (gQueryId, "QUERY BUILDER":U, INPUT-OUTPUT arg).
    RUN DisplayObject.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE queryBuilderHandler C-Win 
PROCEDURE queryBuilderHandler :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   define variable ideevent as adeuib.iideeventservice no-undo.
   if OEIDEIsRunning then    
   do:
       ideevent = new adeuib._ideeventservice(). 
       ideevent:SetCurrentEvent(this-procedure,"openQueryBuilder").
       run runChildDialog in hOEIDEService (ideevent) .
   end.
   else do:
       run openQueryBuilder.
   end.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveData C-Win 
PROCEDURE SaveData :
/*------------------------------------------------------------------------------
  Purpose:  Save the datasource
  Parameters:  pValidate - true if data needs to be validated
  Publish      ab_datasourceremoved -> _tview.w, _genwpg.p, _wizds.w                     
    Notes:     This is typically valled from a wizard

------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pValidate AS LOG NO-UNDO.
   
   DEFINE VARIABLE ok          AS LOG    NO-UNDO.
   DEFINE VARIABLE DOHdl       AS HANDLE NO-UNDO.    
   DEFINE VARIABLE QueryTables AS CHAR   NO-UNDO.      
   DEFINE VARIABLE DelTables   AS CHAR   NO-UNDO.      
   DEFINE VARIABLE cRelName    AS CHAR   NO-UNDO.
   DEFINE VARIABLE cTable      AS CHAR   NO-UNDO.
   DEFINE VARIABLE IncFileName AS CHAR   NO-UNDO.
   DEFINE VARIABLE IncMsg      AS CHAR   NO-UNDO.
   DEFINE VARIABLE pos         AS CHAR   NO-UNDO.
   DEFINE VARIABLE i           AS INT    NO-UNDO.
   
   RUN adecomm/_setcurs.p("WAIT":U).

   DO WITH FRAME {&FRAME-NAME}: 
     ASSIGN rsDataSource.     
    /* User has indicated that the data source is a data object */       
     IF rsDataSource = "SDO":U THEN 
     DO:  
       ASSIGN fDataObject.          
       IF pValidate THEN 
       DO: 
         IF fDataObject = "":U THEN 
         DO:
           MESSAGE 'You must enter a valid SmartDataObject file-name' 
           VIEW-AS ALERT-BOX INFORMATION.
           RETURN ERROR.    
         END.

         /* 
         Get the relative filename. 
         _relfile.p checks remote or local depending on preferences.
         VERBOSE:<file> --> Give error message and override "file" with text */         
         
         RUN adecomm/_relfile.p (fDataObject,                                                                  
                                 gWeb, /* check remote if preferences is set */
                                 "VERBOSE:SmartDataObject file:":U, 
                                 OUTPUT cRelName).
         
         IF RETURN-VALUE = "ERROR":U THEN 
           RETURN ERROR. 
         IF cRelName = ? OR cRelName = "":U THEN 
           RETURN ERROR.
        
         ASSIGN 
           fDataObject = cRelname         
           IncFileName = SUBSTRING(fDataObject,1,R-INDEX(fDataObject,"~."))
                                   + "i":U         
           /* Error message for mssing include */                        
           IncMsg      = 'The include file associated with the ' 
                       +  fDataObject
                       + ' SmartDataObject is missing&1.'  /*&1 = URL address*/                        +  CHR(10)
                       + 'Please select another SmartDataObject.':U     
           . 
            
         /* Check to see if there is a valid include file.
           _relfile.p checks remote or local depending on preferences.  
            Send in the error message to be displayed */
         RUN adecomm/_relfile.p (IncFileName,
                                 gWeb, /* check remote if preferences is set */
                                 "MESSAGE:" + IncMsg, 
                                 OUTPUT cRelName).
         
         IF cRelName = ? THEN 
           RETURN ERROR.         
         
         RUN DbPrompt("to use a local SmartDataObject", OUTPUT ok).
         
         IF NOT ok THEN RETURN ERROR.
                           
         DISPLAY fDataObject.   
       END. /* if validate */
       
       /* 
       We might go back in SDO mode without a value in the field.
       Because a blank value in dataobject means that DB mode is selected,
       The query never gets blanked)  
       we set it to ? if mode = SDO in order to set right mode if we come 
       back to this page. 
        */
               
       ELSE  /* ie: lastbutton = PREV */ 
       IF fDataObject = "":U THEN 
         ASSIGN
          fDataObject = ?.   
                          
       /* THIS MUST also happen on BACK, because the INIT data is read 
          from what is stored !! */
       IF gInitSDO = "":U OR fDataObject <> gInitSdo THEN                       
         PUBLISH "ab_dataSourceRemoved" (INT(gProcRecStr),"*").
              
     END. /* If togSdo:checked */      
     ELSE DO: 
       IF pValidate THEN 
       DO:
         IF e4GLQuery:SCREEN-VALUE = "":U
         AND NOT gHTMLMapping THEN
         DO:
           MESSAGE 
              "You need to define a query" 
           VIEW-AS ALERT-BOX INFORMATION.
      
           RETURN ERROR.               
         END. 
         /* ELSE is ok because the user will be prompted for DB when 
            he defines a query also */
         ELSE
         DO:
           RUN DbPrompt("":U,OUTPUT ok).
           IF NOT ok THEN RETURN ERROR.
         END.              
       END. /* if lastbutton = next */
       
       IF gQueryId <> 0 THEN 
         RUN adeuib/_uibinfo.p(gQueryId,
                               ?,          
                               "TABLES":U,
                               OUTPUT QueryTables).
                                           
        /* Cannot keep fieldlist or mapping if source is different */       
       IF gInitSDO <> "":U OR gInitTables <> QueryTables THEN
       DO: 

         IF gInitTables <> "" THEN
         DO:
             ASSIGN DelTables = gInitTables.
             /* make sure deltables does not contain the current tables */ 
             IF QueryTables <> DelTables THEN 
             DO i = 1 TO NUM-ENTRIES(QueryTables):
               ASSIGN       
                 cTable    = ENTRY(i,QueryTables)
                 DelTables = IF DelTables = CTable THEN "":U ELSE DelTables
                 
                 /* is the table is in the middle */               
                 DelTables = 
                    REPLACE(DelTables,",":U + cTable + ",":U,",":U)
                 /* is it first (insert blank to ensure we compare whole entry*/
                 DelTables = 
                    REPLACE(" ":U + DelTables," ":U + cTable + ",":U,"":U)
                 /* is it last (append blank to ensure we compare whole entry */
                 DelTables = 
                    REPLACE(DelTables + " ":U,",":U + cTable + " ":U,"":U).                
             END.      
         END. /* gInitTables <> '' */
         ELSE /* This may be the case were the source is changed from SDO
                   to query. Set deltables to "*" to delete all mappings */                            
           ASSIGN DelTables = "*":U. 
     
         IF delTables <> "":U THEN
           PUBLISH "ab_dataSourceRemoved" (INT(gProcRecStr),TRIM(deltables)).
                  
       END.          
       
       ASSIGN 
         fDataObject = "":U.                              
     END. /* else = database */      
     
     FIND _p WHERE RECID(_p) = INT(gProcRecStr).
     
     IF VALID-HANDLE(_p._tv-proc) AND gHTMLMapping THEN
     DO:
       /* fix several years after...  to ensure that BACK and NEXT 
          keeps default datasource... could probably just set it always
          the original logic probably never though the tv-proc was valid when 
          called from wizard */  
       
       IF fDataObject = ? THEN
         _P._DATA-OBJECT = fDataObject.
       IF fDataObject <> gInitSDO OR QueryTables <> "" THEN 
          RUN setDataObject IN _p._tv-proc  (fDataObject).
     END.
     ELSE  /* see above.. there is a chance that we never get here.. */   
        _P._DATA-OBJECT = fDataObject.
     
   END. /* do with frame */
  
   /*****    
   SaveData is not modal anymore, but may be called several times before
   the program is closed (instance properties button in the wizard), 
   so make sure that the logic doesn't think something has changed when it 
   hasn't. 
    
   (gInitSDO could be replaced with a _P._data-object now that 
    uniwidg.i is included ) */
       
   ASSIGN
     gInitSDO    = fDataObject
     gQueryId    = procQuery(INT(RECID(_P)))
     e4GLQuery   = IF gQueryId = 0 THEN "" ELSE e4GLQuery 
     gInitTables = IF gQueryId = 0 THEN "" ELSE QueryTables.

   RUN adecomm/_setcurs.p("":U).    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setMode C-Win 
PROCEDURE setMode :
/*------------------------------------------------------------------------------
  Purpose:     To establish modes - either DB or SDO.
  Parameters:  mode
  Notes:       The screen-values of fDataObject and E4glQuery is set to blank
               when the mode requires display of the other. 
               Their values are NOT assigned to blank because we want the values 
               to be redisplayed on change of mode.    
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pMode AS CHARACTER                   NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    rsDataSource:SCREEN-VALUE = pMode.
    IF pMode = "DB":U THEN DO: /* Selected DB as the dataSource */
      ASSIGN fDataObject:SCREEN-VALUE = ""                         
             fDataObject:SENSITIVE     = FALSE
             btnBrws:SENSITIVE        = FALSE
             btnDefqry:SENSITIVE      = TRUE.
      DISPLAY UNLESS-HIDDEN e4GLQuery.
    END. /* Selected DB as the Data Source */

    ELSE DO: /* Selected SDO as the DataSource */
      ASSIGN e4GLQuery:SCREEN-VALUE  = ""    
             fDataObject:SENSITIVE   = TRUE
             btnBrws:SENSITIVE       = TRUE
             btnDefqry:SENSITIVE     = FALSE.
      DISPLAY fDataObject.
    END. /* Selected SDO as the DataSource */
  END. /* Do with frame {&FRAME-NAME} */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION procQuery C-Win 
FUNCTION procQuery RETURNS INTEGER
  (prProc AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose: get the query identifier 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cInfo AS CHAR NO-UNDO.
  /* Get the Browser _U recid */
  RUN adeuib/_uibinfo.p (prProc, "PROCEDURE ?":U, 
    "CONTAINS BROWSE RETURN CONTEXT":U, OUTPUT cInfo).

  /* If no browser get the Query _U recid */
  IF cInfo = "":U THEN 
      RUN adeuib/_uibinfo.p (prProc, "PROCEDURE ?":U, 
        "CONTAINS QUERY RETURN CONTEXT":U, OUTPUT cInfo).

  RETURN INTEGER(cInfo). 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHTMLMapping C-Win 
FUNCTION setHTMLMapping RETURNS LOGICAL
  (pHTML AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gHTMLMapping = pHTML.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SetIsFirst C-Win 
FUNCTION SetIsFirst RETURNS LOGICAL
  (pFirst As LOG) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gFirstrun = pFirst.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setParent C-Win 
FUNCTION setParent RETURNS LOGICAL
  (pFrame as HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gParentHdl = pFrame.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SetRectTitle C-Win 
FUNCTION SetRectTitle RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose: Create a frame and rectangle to cover up the edges of the radio set.
           It also deals with the small/large font sizing problems of the 
           rectangle label/text.     
    Notes: Because the radio-set has a lot of empty space it actually 
           covers the rectangle. 
------------------------------------------------------------------------------*/
  DEF VAR FrameHdl AS HANDLE NO-UNDO.
  DEF VAR RectHdl  AS HANDLE NO-UNDO.
  
  /* Workaround for problems with size differences 
     with small fonts and large fonts */
  ASSIGN
    fiDataSourceLabel:WIDTH IN FRAME {&FRAME-NAME} =     
      FONT-TABLE:GET-TEXT-WIDTH-CHARS(fiDataSourceLabel,FRAME {&FRAME-NAME}:FONT)    
   .           
   
  CREATE FRAME FrameHdl
   ASSIGN 
     SCROLLABLE    = FALSE
     COL           = fiDataSourceLabel:COL + fiDataSourceLabel:WIDTH
     WIDTH-P       = rectDataSrc:WIDTH-P 
                     + rectDataSrc:X
                     - (FrameHdl:X + rectDataSrc:EDGE-PIXELS)
     BOX           = FALSE
     THREE-D       = TRUE
     PARENT        = FRAME {&FRAME-NAME}:FIRST-CHILD
     HEIGHT-PIXELS = rectDataSrc:Y + rectDataSrc:EDGE-PIXELS  /* It's actually bigger ??  */     
     Y             = 0.
  
  CREATE RECTANGLE RectHdl
   ASSIGN
     HEIGHT-P       = 2
     Y              = rectDataSrc:Y  
     COL            = 1
     EDGE-PIXELS    = 2
     GRAPHIC-EDGE   = TRUE
     WIDTH          = FrameHdl:WIDTH
     FRAME          = FrameHdl.
        
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

