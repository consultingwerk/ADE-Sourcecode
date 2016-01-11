&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/

/*------------------------------------------------------------------------
  File       : _brwsmap.w        
  Purpose    : HTML mapping browser  
  Description: Created from the Websped version 1 browser, but made persistent  
               The function getQueryHandle is used from automap to get the
               query handle.
                           
  Created by : Haavard Danielsen
               Feb 98
               
  Subscribe  : "ab_refresFields" anywhere run-procedure openQuery                
               This is published by _automap to signal when changes is done.
               
               "ab_UnmapField" in gSourceHdl -> UnMapField                  
               "ab_MapField"   in gSourceHdl -> MapField    
               "ab_AutoMap"    in gSourceHdl -> AutoMap 
               
               gSourcehdl is the SOURCE-PROCEDURE.
                   
  Publish    : "ab_FocusedRowIsMapped" (true or false) on value-changed.
                             
  Notes      : The browser could not be created with the Appbuilder so it 
               is created by regular 4GL code.                   
  Changed    : Mars 98 HD 
               Added logic and functions to make _automap.p able to 
               handle a query OR the treeview.
  Changed    : 4/5/98  HD 
               Added shutdown-sdo to kill SDO's started by _automap.p 
               or _dbfsel.p 
------------------------------------------------------------------------*/
/*       This .W file was created with the Progress AppBuilder.         */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{adeuib/uniwidg.i}
{adeuib/sharvars.i}
{adeuib/uibhlp.i}     /* Help pre-processor directives    */
{adeweb/htmwidg.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VAR gCurrentRecid AS RECID INITIAL ? NO-UNDO.
DEFINE VAR gWidgetList   LIKE _wid-list. /* from sharvars.i  */
DEFINE VAR gAllwindows   AS LOG    NO-UNDO.
DEFINE VAR gSortField    AS CHAR   NO-UNDO.
DEFINE VAR gDescending   AS LOG    NO-UNDO.
DEFINE VAR gSourceHdl    AS HANDLE NO-UNDO.

/* Used to display and check mapping */
DEFINE VAR xSDOSrc       AS CHAR INIT "SDO":U NO-UNDO. 
DEFINE VAR xDBSrc        AS CHAR INIT "DB":U NO-UNDO. 

/* Preprosessor parameters */

&SCOP BROWSE-NAME widgbrws

/* No need for p_U from version 1 ? */ 
&SCOP FOREACH FOR EACH _U WHERE (NOT (_U._NAME BEGINS '_LBL':U~
                                  OR ( _U._TYPE eq 'WINDOW':U~
                          AND _U._SUBTYPE eq 'Design-Window':U)))~
                   AND _U._STATUS EQ 'NORMAL':U~
                   AND CAN-DO(gWidgetList,_U._TYPE)~
                   AND _U._WINDOW-HANDLE eq _h_win,~
           EACH p_U WHERE RECID(p_U) = _U._PARENT-RECID,~
           EACH _HTM WHERE _HTM._U-RECID = RECID(_U)

&SCOP FOREACH FOR EACH _U WHERE (NOT (_U._NAME BEGINS '_LBL':U~
                                  OR ( _U._TYPE eq 'WINDOW':U~
                          AND _U._SUBTYPE eq 'Design-Window':U)))~
                   AND _U._STATUS EQ 'NORMAL':U~
                   AND CAN-DO(gWidgetList,_U._TYPE)~
                   AND _U._WINDOW-HANDLE eq _h_win,~
           EACH _HTM WHERE _HTM._U-RECID = RECID(_U)

&SCOP OPEN-QUERY  OPEN QUERY {&BROWSE-NAME} {&FOREACH}

&SCOP WebSpeed  (IF _U._TABLE <> ? ~
                 THEN _U._TABLE + ".":U~
                 ELSE "":U)~
                 + _U._Name  
&SCOP Source    (IF _U._TABLE = ? ~
                 THEN "":U~
                 ELSE IF _U._TABLE = "RowObject":U ~
                 THEN xSDOsrc~
                 ELSE xDBSrc)   
     
   
DEFINE BUFFER p_U   FOR _U.
DEFINE BUFFER w_U   FOR _U.
/*
DEFINE QUERY {&BROWSE-NAME} FOR _U, p_U, _HTM.
*/
DEFINE QUERY {&BROWSE-NAME} FOR _U,  _HTM.

/*
     {&Webspeed} 
      @
          {&Source}   
      @  */
/* Browser definitions                                                    */
DEFINE BROWSE {&BROWSE-NAME} QUERY {&BROWSE-NAME}
   DISPLAY 
     _HTM._i-order  LABEL "Seq.":U
                    WIDTH 5 
     _HTM._HTM-NAME FORMAT "X(132)":U 
                    WIDTH 24           
      {&Webspeed}   
       @
      _U._name      FORMAT "X(99)":U 
                    WIDTH 24
                    LABEL "WebSpeed":U
     {&Source}   
      @ 
     _U._TABLE      FORMAT "X(5)":U
                    WIDTH  6.20
                    LABEL "Source":U
             
   ENABLE    /* Enable Columns, Set to read-only in initializeOnbject */                                    
      _HTM._i-order 
      _HTM._HTM-NAME
  /*  _U._name 
      _U._TABLE  */
  WITH 
     SEPARATORS 
     12 DOWN            /* Using DOWN and not WIDTH ensures exact fit */
     NO-ROW-MARKERS
     BGCOLOR 15
     EXPANDABLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryHandle B-table-Win 
FUNCTION getQueryHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SetTitle B-table-Win 
FUNCTION SetTitle RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 66 BY 9.19
         BGCOLOR 8 FGCOLOR 0 .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 9.19
         WIDTH              = 66.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
ASSIGN gSourceHdl = SOURCE-PROCEDURE.

/* Anyone that has changed the _U info for fields shpould publish . */
 
SUBSCRIBE "AB_RefreshFields":U ANYWHERE   RUN-PROCEDURE "openQuery":U.

/* choose events on buttons in the caller */ 
SUBSCRIBE "AB_UnmapField":U    IN gSourceHdl RUN-PROCEDURE "UnmapField":U.
SUBSCRIBE "AB_MapField":U      IN gSourceHdl RUN-PROCEDURE "MapField":U.
SUBSCRIBE "AB_AutoMap":U       IN gSourceHdl RUN-PROCEDURE "AutoMap":U.
SUBSCRIBE "AB_UnmapAll":U      IN gSourceHdl RUN-PROCEDURE "UnmapAll":U.

ON CLOSE OF THIS-PROCEDURE 
  RUN DestroyObject.

DEFINE FRAME {&FRAME-NAME}
  {&BROWSE-NAME}.

ASSIGN
  {&BROWSE-NAME}:COLUMN-RESIZABLE IN FRAME {&FRAME-NAME} = TRUE.
  /* BUG 98-04-20-037   
  {&BROWSE-NAME}:COLUMN-MOVABLE   IN FRAME {&FRAME-NAME} = TRUE.
  */
ON VALUE-CHANGED OF BROWSE {&BROWSE-NAME} DO:    
  IF AVAILABLE _U THEN
  DO:
    ASSIGN _h_cur_widg   = _U._HANDLE
           _h_win        = _U._WINDOW-HANDLE
           gCurrentRecid = RECID(_U).
          
    FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
    IF AVAILABLE _F THEN _h_frame = _F._FRAME.
    
    PUBLISH "ab_FocusedRowIsMapped":U (_U._TABLE <> ?).
  END.
END.

ON START-SEARCH OF BROWSE {&BROWSE-NAME} DO:
  DEF VAR SortHandle AS HANDLE NO-UNDO. 
  
  ASSIGN 
    SortHandle = {&BROWSE-NAME}:CURRENT-COLUMN IN FRAME {&FRAME-NAME} 
    gDescending = gDescending = FALSE AND SortHandle:NAME = gSortField
    gSortField  = SortHandle:NAME.
 
  Run OpenQuery.
  APPLY "LEAVE" TO {&BROWSE-NAME}. 
  APPLY "ENTRY" TO {&BROWSE-NAME}. 

END.

ASSIGN    
  gWidgetList = "BROWSE,BUTTON,COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,"
              + "SLIDER,SmartObject,TOGGLE-BOX,TEXT,{&WT-CONTROL}":U              
  FRAME {&FRAME-NAME}:HEIGHT = {&BROWSE-NAME}:HEIGHT
  FRAME {&FRAME-NAME}:WIDTH  = {&BROWSE-NAME}:WIDTH.

   &IF DEFINED(AB_is_Running) NE 0 &THEN      
RUN initializeObject. 
   &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AutoMap B-table-Win 
PROCEDURE AutoMap :
/*------------------------------------------------------------------------------
  Purpose:     Database Field Map Wizard that maps HTML Fields to Database Fields.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   Run adeweb/_automap.p. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject B-table-Win 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION("shutdown-sdo":U in _h_func_lib, THIS-PROCEDURE).
  RUN disable_UI.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject B-table-Win 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose: InitializeObject 
           Should be called after beeing start persistent    
  Parameters:  
  Notes:  Set enabled column to read-only in browser because it is enabled just
          in order to enable column sort.    
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE DataObjectHdl AS HANDLE NO-UNDO.
  
  ASSIGN
    _HTM._i-order:READ-ONLY IN BROWSE {&BROWSE-NAME}  = TRUE
    _HTM._HTM-NAME:READ-ONLY IN BROWSE {&BROWSE-NAME} = TRUE
    
 /*   
    _U._name:READ-ONLY IN BROWSE {&BROWSE-NAME}    = TRUE
    _U._TABLE:READ-ONLY IN BROWSE {&BROWSE-NAME}    = TRUE
 */ .   
  
  {&BROWSE-NAME}:SET-REPOSITIONED-ROW(1,"CONDITIONAL":U) IN FRAME {&FRAME-NAME}.

  VIEW FRAME {&FRAME-NAME}. 
  RUN openQuery.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MapField B-table-Win 
PROCEDURE MapField :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE tmp-wh AS HANDLE NO-UNDO.
  
  /*
  IF NOT AVAILABLE _U THEN
       MESSAGE "There are no objects that satisfy the filter." SKIP
               "Please change the filter to include an object."
       VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   */
  IF NOT AVAILABLE _U THEN
    MESSAGE "Please select an object to map.":U
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  ELSE
  DO:
    ASSIGN gCurrentRecid = RECID(_U).
           
          /* cType   = _U._TYPE.  ?? */
     
    RUN adecomm/_setcurs.p ("WAIT"). /* Set the cursor pointer in all windows */
    
    RUN adeweb/_dbfsel.p (INPUT _U._HANDLE , INPUT "_SELECT":u).
    
    RUN openQuery.
    
    RUN adecomm/_setcurs.p ("").  /* Set the cursor pointer in all windows */
    
    /* APPLY "ENTRY" TO b_ok IN FRAME instruct.  */
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery B-table-Win 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR CurrentType AS CHARACTER NO-UNDO.
     
  IF gCurrentRecid NE ? THEN 
  DO:
    FIND _U WHERE RECID(_U) = gCurrentRecid.   
    IF (_U._TYPE eq "WINDOW" AND _U._SUBTYPE eq "Design-Window":U) 
       OR NOT CAN-DO(gWidgetList,_U._TYPE)
    THEN gCurrentRecid = ?.
    ELSE CurrentType = _U._TYPE.
  END.
   
  CASE gSortField:   
     WHEN "_i-order" THEN      
     DO:
       IF NOT gDescending THEN
         {&OPEN-QUERY}
          BY _HTM._i-order.
       ELSE
         {&OPEN-QUERY}
          BY _HTM._i-order DESCENDING.
     END.
     WHEN "_HTM-name" THEN      
     DO:
       IF NOT gDescending THEN
         {&OPEN-QUERY}
         BY _HTM._HTM-Name.
       ELSE
        {&OPEN-QUERY}
         BY _HTM._HTM-Name DESCENDING.
     END.
     WHEN "_name" THEN      
     DO:
       IF NOT gDescending THEN
         {&OPEN-QUERY}
         BY {&webspeed}.
       ELSE
         {&OPEN-QUERY}
         BY {&webspeed} DESCENDING.
     END.
     WHEN "_table" THEN      
     DO:
       IF NOT gDescending THEN
         {&OPEN-QUERY}
         BY {&source}.
       ELSE
         {&OPEN-QUERY}
         BY {&source} DESCENDING.
     END.
     OTHERWISE 
     DO: 
       {&OPEN-QUERY}
        BY _HTM._i-order.       
       
       ASSIGN 
         gSortField = "_i-order":U.
     END.
  END.
  
  DO WITH FRAMe {&FRAME-NAME}:
    IF gCurrentRecid NE ? THEN REPOSITION {&BROWSE-NAME} TO RECID gCurrentRecid.
    /*
    IF NUM-RESULTS("{&BROWSE-NAME}") > 0 
    AND {&BROWSE-NAME}:VISIBLE THEN
       {&BROWSE-NAME}:SELECT-FOCUSED-ROW().
  */
    IF AVAILABLE _U THEN 
    DO:
      ENABLE {&BROWSE-NAME}  WITH FRAME {&FRAME-NAME}.
      APPLY 'VALUE-CHANGED':U TO {&BROWSE-NAME}.
    /*  {&BROWSE-NAME}:REFRESH().   */
    END.  
    ELSE 
      DISABLE {&BROWSE-NAME} WITH FRAME {&FRAME-NAME}.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionObject B-table-Win 
PROCEDURE repositionObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pRow as DEC NO-UNDO.
  DEFINE INPUT PARAMETER pCOL as DEC NO-UNDO.
  ASSIGN 
   FRAME {&FRAME-NAME}:ROW = pRow 
   FRAME {&FRAME-NAME}:COL = pCOl. 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setParentFrame B-table-Win 
PROCEDURE setParentFrame :
/*------------------------------------------------------------------------------
  Purpose: Used to make this frame appear in the wizard frame.      
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pHdl AS HANDLE. 
  ASSIGN FRAME {&FRAME-NAME}:PARENT = pHdl. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetWidth B-table-Win 
PROCEDURE SetWidth :
/*------------------------------------------------------------------------------
  Purpose:    Set Width of browse and frame and change the fieldname fields 
              accordingly   
  Parameters: pWidth = New Width  
  Notes:      This is done in order to make the browse fit in a wizard  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pWidth AS DEC NO-UNDO.
  
  DEF VAR WidthDiff             AS DEC NO-UNDO.
  ASSIGN
    WidthDiff = {&BROWSE-NAME}:WIDTH IN FRAME {&FRAME-NAME} - pWidth 
   _HTM._HTM-NAME:WIDTH IN BROWSE {&BROWSE-NAME} = 
                 _HTM._HTM-NAME:WIDTH IN BROWSE {&BROWSE-NAME} 
                 
                 - (WidthDiff / 2) - 0.02 /* rounding problems may give scrollbar*/ 
  
    _U._name:WIDTH IN BROWSE {&BROWSE-NAME}       = 
                   _U._name:WIDTH IN BROWSE {&BROWSE-NAME} 
                  
                   - (WidthDiff / 2) - 0.02 /* rounding problems may give scrollbar*/
  
    {&BROWSE-NAME}:WIDTH IN FRAME {&FRAME-NAME}   = pWidth 
    FRAME {&FRAME-NAME}:WIDTH                     = pWidth
  .  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UnMapAll B-table-Win 
PROCEDURE UnMapAll :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    GET FIRST {&BROWSE-NAME}.  
    RUN adecomm/_setcurs.p("WAIT":U).   
    DO WHILE AVAILABLE  _U:     
      IF _U._TABLE <> ? THEN 
        RUN adeweb/_dbfsel.p (INPUT _U._HANDLE , INPUT "_DESELECT":u).
      GET NEXT {&BROWSE-NAME}.
    END. 
    RUN adecomm/_setcurs.p("":U).   
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UnMapField B-table-Win 
PROCEDURE UnMapField :
/*------------------------------------------------------------------------------
  Purpose: Unmap current field (_U)      
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE tmp-wh AS HANDLE NO-UNDO.
  
  IF NOT AVAILABLE _U THEN
       MESSAGE "There are no objects that satisfy the filter." SKIP
               "Please change the filter to include an object."
       VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  ELSE
  DO:
    ASSIGN gCurrentRecid = RECID(_U).
     /*    cType   = _U._TYPE. */
     
    RUN adecomm/_setcurs.p ("WAIT"). /* Set the cursor pointer in all windows */
    
    RUN adeweb/_dbfsel.p (INPUT _U._HANDLE , INPUT "_DESELECT":u).

    RUN openQuery.
 
    RUN adecomm/_setcurs.p ("").  /* Set the cursor pointer in all windows */

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryHandle B-table-Win 
FUNCTION getQueryHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN QUERY {&BROWSE-NAME}:HANDLE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SetTitle B-table-Win 
FUNCTION SetTitle RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Show which window we are working with.   
    Notes:  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE WindowCount AS INTEGER NO-UNDO. 
   
  FOR EACH w_U WHERE CAN-DO("WINDOW,DIALOG-BOX",w_U._TYPE) 
               AND   w_U._STATUS = "NORMAL":
    WindowCount = WindowCount + 1.
  END.
  
  IF WindowCount > 1 THEN
  DO:
    FIND w_U WHERE w_U._HANDLE = _h_win.    
    RETURN "Field Associations - " 
           + (IF w_U._SUBTYPE <> "Design-Window":U 
              THEN w_U._NAME 
              ELSE w_U._LABEL).  
  END.
  ELSE 
    RETURN "". 
                
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

