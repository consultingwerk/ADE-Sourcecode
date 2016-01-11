&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
/* Procedure Description
"Field Wizard"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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

  File: _wizdfld.w

  Description: Field wizard for SmartBrowser 

  Input Parameters:
      hWizard (handle) - handle of Wizard dialog

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: 4/5/95
  Updated: 12/28/98

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* NEVER NEVER Create an unnamed pool to store all the widgets created 
     by this procedure. This only assures that everything dynamic 
     that is created in this procedure will die as soon as this proecure dies  
 In this particular case the dynamic temp-table in the sdo  
 CREATE WIDGET-POOL.    
     */


/* ***************************  Definitions  ************************** */
{ src/adm2/support/admhlp.i} /* ADM Help File Defs */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER hWizard AS WIDGET-HANDLE                    NO-UNDO.

/* Handle of the AppBuilders Function Library                           */
DEFINE SHARED VARIABLE fld-list    AS CHARACTER                    NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE Data_Object    AS CHARACTER     NO-UNDO.
DEFINE VARIABLE h_do           AS HANDLE        NO-UNDO.
DEFINE VARIABLE objtype        AS CHARACTER     NO-UNDO.
DEFINE VARIABLE proc-recid     AS CHARACTER     NO-UNDO.
DEFINE VARIABLE qtbls          AS CHARACTER     NO-UNDO.
DEFINE VARIABLE br-recid       AS CHARACTER     NO-UNDO.
DEFINE VARIABLE hFuncLib       AS HANDLE        NO-UNDO.
DEFINE VARIABLE lWeb           AS LOG           NO-UNDO.
DEFINE VARIABLE hWizProc       AS HANDLE        NO-UNDO.
DEFINE VARIABLE valid-msg      AS CHARACTER     NO-UNDO.
DEFINE VARIABLE valid-sdo      AS LOGICAL       NO-UNDO INITIAL TRUE.
DEFINE VARIABLE cReposObject   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cReposType     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lIsRepos       AS LOGICAL    NO-UNDO.

FUNCTION is-sdo RETURNS LOGICAL
        (INPUT h_do AS HANDLE) IN hFuncLib.

FUNCTION is-sdo-proxy RETURNS LOGICAL
        (INPUT h_do AS HANDLE) IN hFuncLib.

FUNCTION shutdown-sdo RETURNS LOGICAL
        (INPUT procHandle AS HANDLE) IN hFuncLib.

FUNCTION getDataSourceNames   RETURNS CHARACTER IN hWizProc.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS e_msg s_fields b_Addf b_Helpb RECT-5 
&Scoped-Define DISPLAYED-OBJECTS e_msg s_fields 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_Addf 
     LABEL "&Add Fields..." 
     SIZE 26 BY 1.14.

DEFINE BUTTON b_Helpb 
     LABEL "&Help on Fields" 
     SIZE 26 BY 1.14.

DEFINE VARIABLE e_msg AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 26 BY 6.05
     BGCOLOR 8  NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 9.05.

DEFINE VARIABLE s_fields AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 52 BY 7.76 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     e_msg AT ROW 1.52 COL 57 NO-LABEL
     s_fields AT ROW 2.52 COL 3 NO-LABEL
     b_Addf AT ROW 8.04 COL 57
     b_Helpb AT ROW 9.52 COL 57
     RECT-5 AT ROW 1.52 COL 2
     "Fields to display:" VIEW-AS TEXT
          SIZE 17 BY .62 AT ROW 1.85 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         THREE-D 
         AT COL 1 ROW 1
         SIZE 83.57 BY 10.31
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
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
         HEIGHT             = 10.52
         WIDTH              = 84
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 95.2
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 95.2
         RESIZE             = no
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
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   UNDERLINE                                                            */
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


&Scoped-define SELF-NAME b_Addf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Addf C-Win
ON CHOOSE OF b_Addf IN FRAME DEFAULT-FRAME /* Add Fields... */
DO:
  DEFINE VARIABLE tbllist       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE tbl           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE fld           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSourceNames  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourceFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataObjects  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExclude      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumns      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColumn       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cColumnName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnObject AS CHARACTER  NO-UNDO.

  /* Run adecomm/_getdlst to allow the user to select fields */
  IF VALID-HANDLE(h_do) THEN 
  DO: /* Choosing from a SDO or SBO */
    cSourceNames = getDataSourceNames().
     
    /* A previous wizard page may have specified and stored DataObjectNames.
        (this is for support of SBOs) */
    IF cSourceNames <> ? AND cSourceNames <> '':U THEN
    DO:
      cDataObjects = {fn getDataObjectNames h_do} NO-ERROR. 
      IF NUM-ENTRIES(cSourceNames) < NUM-ENTRIES(cDataObjects) THEN
      DO:
        cColumns = {fn getDataColumns h_Do} NO-ERROR.
        DO iColumn = 1 TO NUM-ENTRIES(cColumns):
           ASSIGN 
             cColumnName   = ENTRY(iColumn,cColumns)
             cColumnObject = ENTRY(1,cColumnName,'.':U).
            IF LOOKUP(cColumnObject,cSourceNames) = 0 THEN
            DO:
              ASSIGN cExclude = cExclude
                              + (IF cExclude <> '':U THEN ',':U ELSE '':U)
                              + cColumnName.
            END.  /* lookup ccolumnObject,cSourcenamews = 0 */ 
        END. /* do icolumn = 1 to */
      END. /* num-entries <> num-entries */
    END. /* cSourcenames <> ? or blank */
   
    RUN adecomm/_mfldsel.p 
                 ("", 
                  h_do, 
                  ?, 
                  "1", 
                  ",", 
                  cExclude,
                  INPUT-OUTPUT fld-list).

    RUN adecomm/_setcurs.p ("":U).
  END.  /* IF valid h_do */
  ELSE DO:  /* Choosing from a database */
    tbllist = qtbls.
    /* Strip out "OF" syntax */
    DO i = 1 TO NUM-ENTRIES(tbllist):
      ENTRY(i,tbllist) = ENTRY(1, ENTRY(i,tbllist), " ":U).
    END.
    
    /* Run the column editor to maintain the field list */
    RUN adeuib/_uib_dlg.p
             (INT(br-recid), "COLUMN EDITOR":U, INPUT-OUTPUT tbllist).
    
    RUN adeuib/_uibinfo.p (INT(br-recid), ?, "FIELDS":U, OUTPUT fld-list).
      
    /* Remove dbname if settings require it */
    DO i = 1 to NUM-ENTRIES(fld-list):
      ASSIGN 
        fld = ENTRY(i,fld-list) 
        fld = ENTRY(NUM-ENTRIES(fld,".":U),fld,".":U)
        tbl = SUBSTR(ENTRY(i,fld-list),1,R-INDEX(ENTRY(i,fld-list),".":U) - 1)    
        ENTRY(i,fld-list) = DYNAMIC-FUNCTION('db-tbl-name' IN hFuncLib,tbl) 
                            + ".":U
                            + fld.
    END. /* do i = 1 to num-entries(fld-list) */
  END. /*else do (= database) */
  
  ASSIGN s_fields:LIST-ITEMS IN FRAME {&FRAME-NAME} = fld-list.
   
  IF s_fields:NUM-ITEMS IN FRAME {&FRAME-NAME} > 0 THEN DO:
    SELF:LABEL = "&Modify Fields...".
    APPLY "U1":U TO hWizard.  /* Ok to finish */
  END.
  ELSE DO:
    SELF:LABEL = "&Add Fields...".
    APPLY "U2":U TO hWizard.  /* NOT Ok to finish */
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Helpb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Helpb C-Win
ON CHOOSE OF b_Helpb IN FRAME DEFAULT-FRAME /* Help on Fields */
DO:
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&Help_on_Fields}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
ASSIGN 
  hWizProc                     = SOURCE-PROCEDURE
  FRAME {&FRAME-NAME}:FRAME    = hwizard 
  FRAME {&FRAME-NAME}:HIDDEN   = NO
  FRAME {&FRAME-NAME}:HEIGHT-P = FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P
  FRAME {&FRAME-NAME}:WIDTH-P  = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P.
ASSIGN hFuncLib            = DYNAMIC-FUNCTION("getFuncLibHandle":U IN hWizProc).

/* Get context id of procedure */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT proc-recid).

/* Get procedure type (SmartViewer or SmartBrowser) */
RUN adeuib/_uibinfo.p (INT(proc-recid),"":U, "TYPE":U, OUTPUT objtype).

ASSIGN lWeb =(ObjType BEGINS "WEB":U).

/* Get the name of the associated DataObject */
RUN adeuib/_uibinfo.p (INT(proc-recid), "":U, "DataObject":U, OUTPUT Data_Object).


/* Get the handle of the data object */
IF Data_object ne "" and Data_object ne ? THEN
DO:
  RUN getSDOhandle IN hWizProc(Data_Object, OUTPUT h_do).
  
  /* Ensure the chosen file is a SmartData object. If not, later we'll disable the
     Add fields button. */
  
  IF NOT VALID-HANDLE(h_do) THEN
    valid-msg = "Cannot add fields. Handle to object is invalid. The file may not be compiling correctly.".
  ELSE IF NOT is-sdo(h_do) THEN
    valid-msg = "Cannot add fields. The file is not a SmartDataObject.".
  ELSE IF is-sdo-proxy(h_do) THEN 
    valid-msg = "Cannot add fields. The file is a SmartDataObject Proxy.".
  ELSE IF objtype = "SmartDataBrowser":U AND DYNAMIC-FUNCTION("getObjectType":U IN h_DO) = "SmartBusinessObject":U THEN
    valid-msg = "Cannot add fields. A SmartDataBrowser may not be based on a SmartBusinessObject.".
  ASSIGN valid-sdo = (valid-msg = "").
  IF NOT valid-sdo THEN
  DO ON STOP UNDO, LEAVE:
    valid-msg = Data_Object + CHR(10) + CHR(10) + valid-msg.
    MESSAGE valid-msg VIEW-AS ALERT-BOX WARNING BUTTONS OK.
  END.
    
END.
ELSE DO:
  /* Assume that we are using a db and not sdo for the data source */
  /* Get context of the browse widget and then current table list  */
  
  RUN adeuib/_uibinfo.p (INT(proc-recid), "":U,
         "CONTAINS BROWSE RETURN CONTEXT":U, OUTPUT br-recid).
  
  /* If not a browse look for the query */
  IF br-recid = "":U THEN
    RUN adeuib/_uibinfo.p (INT(proc-recid), "":U,
         "CONTAINS QUERY RETURN CONTEXT":U, OUTPUT br-recid).
  
  RUN adeuib/_uibinfo.p (INT(br-recid), ?, "TABLES":U, OUTPUT qtbls).

END.

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.
       

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
DO:
  /* This must NOT happen here, The _wizard calls this when it dies  
  IF VALID-HANDLE(h_do) THEN DO:
    IF NOT shutdown-sdo(hWizProc) THEN
      MESSAGE "Unable to shutdown the SmartDataObject."
               VIEW-AS ALERT-BOX ERROR.
               
  END.
  */  
  
  RUN disable_UI.
END.
/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  /* Get any fields made in a previous visit. */
  IF fld-list NE "" THEN 
    b_Addf:LABEL IN FRAME {&FRAME-NAME} = "&Modify Fields...".

  ASSIGN 
    /* Get any fields made in a previous visit. */
    s_fields:LIST-ITEMS = fld-list 
    e_msg               =  "Your " + objtype + " object " +                 
                           IF objtype = "SmartBrowser" THEN
                           ("contains a browse object that requires " +
                            "a list of fields to display.")
                           ELSE /* A SmartViewer */
                           ("requires a list of fields from the " +
                             "DataObject to display.").                
  
  RUN enable_UI.
  ASSIGN b_Addf:SENSITIVE IN FRAME {&FRAME-NAME} = valid-sdo.
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
  DISPLAY e_msg s_fields 
      WITH FRAME DEFAULT-FRAME.
  ENABLE e_msg s_fields b_Addf b_Helpb RECT-5 
      WITH FRAME DEFAULT-FRAME.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

