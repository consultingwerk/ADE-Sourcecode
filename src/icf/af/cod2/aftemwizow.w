&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
/* Procedure Description
"SDO Wizard"
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

  File: _wizdo.w

  Description: SDO wizard page 

  Input Parameters:
      hWizard (handle) - handle of Wizard dialog

  Output Parameters:
      <none>

  Author: Ross Hunter 

  Created: 4/4/95 
  Modified: 03/25/98 SLK Changed d-*.* to d*.*
  Modified: 04/08/98 HD   Validate Filename when NEXT

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
{ adm2/support/admhlp.i } /* ADM Help File Defs */

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER hWizard   AS WIDGET-HANDLE NO-UNDO.

/* Shared Variable Definitions ---                                      */
DEFINE SHARED VARIABLE fld-list         AS CHARACTER     NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE objtype    AS CHARACTER NO-UNDO.
DEFINE VARIABLE obj-recid  AS CHARACTER NO-UNDO.
DEFINE VARIABLE proc-recid AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-status   AS LOGICAL   NO-UNDO.

DEFINE Variable gWizardHdl AS HANDLE  NO-UNDO.
/* 
palette item to use when browsing for SmartDataObject.  
Current .cst implementation makes this hardcoding necessary 
*/ 
DEFINE VARIABLE xSmartDataObject AS CHAR NO-UNDO INIT "SmartDataObject":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS e_msg Data_Object b_brws b_Helpq RECT-3 
&Scoped-Define DISPLAYED-OBJECTS e_msg Data_Object 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_brws 
     LABEL "B&rowse..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_Helpq 
     LABEL "&Help on DataObject" 
     SIZE 26 BY 1.14.

DEFINE VARIABLE e_msg AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 26 BY 5
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE Data_Object AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 2.14.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     e_msg AT ROW 1.52 COL 57 NO-LABEL
     Data_Object AT ROW 2.1 COL 3 NO-LABEL
     b_brws AT ROW 2.1 COL 40
     b_Helpq AT ROW 9.81 COL 57
     RECT-3 AT ROW 1.52 COL 2
     "SmartDataObject filename" VIEW-AS TEXT
          SIZE 25 BY .62 AT ROW 1.24 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
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
         HEIGHT             = 10.62
         WIDTH              = 83.8
         MAX-HEIGHT         = 16.48
         MAX-WIDTH          = 107.2
         VIRTUAL-HEIGHT     = 16.48
         VIRTUAL-WIDTH      = 107.2
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
   UNDERLINE                                                            */
/* SETTINGS FOR FILL-IN Data_Object IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
ASSIGN 
       e_msg:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _Options          = ""
     _Query            is NOT OPENED
*/  /* FRAME DEFAULT-FRAME */
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


&Scoped-define SELF-NAME b_brws
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_brws C-Win
ON CHOOSE OF b_brws IN FRAME DEFAULT-FRAME /* Browse... */
DO:
  DEFINE VARIABLE lOk                     AS   LOGICAL                NO-UNDO.
  DEFINE VARIABLE cRoot                   AS   CHARACTER              NO-UNDO.
  DEFINE VARIABLE cFileName               AS   CHARACTER              NO-UNDO.
  DEFINE VARIABLE cFilterNameString       AS   CHARACTER EXTENT 5     NO-UNDO.
  DEFINE VARIABLE cFilterFileSpec         LIKE cFilterNameString      NO-UNDO.
  DEFINE VARIABLE cFile                   AS   CHARACTER              NO-UNDO.
  DEFINE VARIABLE cPath                   AS   CHARACTER              NO-UNDO.
  DEFINE VARIABLE cString                 AS   CHARACTER              NO-UNDO.
  DEFINE VARIABLE iLoop                   AS   INTEGER                NO-UNDO.
  DEFINE VARIABLE hHandle                 AS   HANDLE                 NO-UNDO.
  DEFINE VARIABLE oldData_Object          AS CHARACTER                NO-UNDO.  

  /* Initialize the file filters, for special cases. */
  ASSIGN  cFilterNameString[1] = "SDO Files(*o.w)"
          cFilterFileSpec[1] = "*o.w"
          cFilterNameString[2] = "All .w Files(*.w)"
          cFilterFileSpec[2] = "*.w"
          cFilterNameString[3] = "All Files(*.*)"
          cFilterFileSpec[3] = "*.*".

  /*  Ask for a file name */ 
  ASSIGN
    cFileName = Data_Object:SCREEN-VALUE
    oldData_Object = Data_Object:SCREEN-VALUE.

  SYSTEM-DIALOG GET-FILE cFileName
      TITLE    "Lookup SDO File"
      FILTERS  cFilterNameString[ 1 ]   cFilterFileSpec[ 1 ],
               cFilterNameString[ 2 ]   cFilterFileSpec[ 2 ],
               cFilterNameString[ 3 ]   cFilterFileSpec[ 3 ]
      MUST-EXIST
      UPDATE   lOk IN WINDOW {&WINDOW-NAME}.  

  cRoot = IF  REPLACE(cFileName,"\":U,"/":U) BEGINS REPLACE(ENTRY(2,PROPATH),"\":U,"/":U) THEN
            REPLACE(ENTRY(2,PROPATH),"\":U,"/":U)
            ELSE REPLACE(ENTRY(1,PROPATH),"\":U,"/":U).

  IF  lOk THEN DO:
      ASSIGN
          cFile                                 = REPLACE(REPLACE(TRIM(LC(cFileName)),"\":U,"/":U),cRoot + "/":U,"":U)
          Data_Object:SCREEN-VALUE = cFile
          cPath                                 = SUBSTRING(cFile,1,R-INDEX(cFile,"/":U))
          Data_Object:MODIFIED     = TRUE.

      IF oldData_Object <> Data_Object:SCREEN-VALUE THEN
      APPLY "VALUE-CHANGED" TO Data_Object.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Helpq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Helpq C-Win
ON CHOOSE OF b_Helpq IN FRAME DEFAULT-FRAME /* Help on DataObject */
DO:
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&Help_on_Data_Object}, ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Data_Object
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Data_Object C-Win
ON VALUE-CHANGED OF Data_Object IN FRAME DEFAULT-FRAME
DO: 
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fld-list = "":U.
    APPLY "U2":U TO hWizard. /* not ok to finish */
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
ASSIGN FRAME {&FRAME-NAME}:FRAME    = hwizard
       FRAME {&FRAME-NAME}:HIDDEN   = NO
       FRAME {&FRAME-NAME}:HEIGHT-P = FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P
       FRAME {&FRAME-NAME}:WIDTH-P  = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P
       gWizardHdl                   = SOURCE-PROCEDURE.      

/* Get context id of procedure */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT proc-recid).

/* Get procedure type (SmartViewer or SmartBrowser) */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U, OUTPUT objtype).

/* If this SmartViewer or SmartBrowser already has a DataObject defined  */
/* then preset Data_Object.                                              */
RUN adeuib/_uibinfo.p (INTEGER(proc-recid)," ","DataObject", OUTPUT Data_Object).

ASSIGN e_msg = 
      "You need to specify the DataObject that will be the data source for this " +
      objtype + ".".

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
   /* Store DataObject filename */
   DO WITH FRAME {&FRAME-NAME}:
     RUN ProcessPage NO-ERROR. 
     IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.  
   END.
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
  RUN Display-Query.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Display-Query C-Win 
PROCEDURE Display-Query :
/*------------------------------------------------------------------------------
  Purpose:     Display 4GL query if any and sets button label.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    DISPLAY Data_Object WITH FRAME {&FRAME-NAME}.
  END.    
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
  DISPLAY e_msg Data_Object 
      WITH FRAME DEFAULT-FRAME.
  ENABLE e_msg Data_Object b_brws b_Helpq RECT-3 
      WITH FRAME DEFAULT-FRAME.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
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
   DEFINE VARIABLE ok          AS LOG    NO-UNDO.
   DEFINE VARIABLE cRelName    AS CHAR   NO-UNDO.  

   DEFINE VARIABLE LastButton AS CHARACTER NO-UNDO.

   LastButton = DYNAMIC-FUNCTION ("GetLastButton" IN gWizardHdl).

   IF LastButton = "CANCEL" THEN RETURN.

   RUN adecomm/_setcurs.p("WAIT":U).

   ASSIGN FRAME {&FRAME-NAME} Data_Object.   

   IF LastButton = "NEXT":U THEN 
   DO: 
     IF Data_Object = "":U THEN
     DO:  
       MESSAGE 'You need to supply the name of a SmartDataObject.':U 
          VIEW-AS ALERT-BOX.

       RETURN ERROR.    
     END.

     RUN adecomm/_relfile.p (Data_Object,
                             NO, /* Never check remote */
                            "Verbose":U, 
                             OUTPUT cRelName).

     IF cRelname = ? THEN RETURN ERROR.

     ASSIGN 
        Data_Object = cRelname.                       
     DISPLAY Data_Object WITH FRAME {&FRAME-NAME}.   

  END. /* if lastbutton = next */

  /* 
  Store even if we are going back in order to have what we entered
  if we come back to this page
  */    
  RUN adeuib/_setwatr.w(INTEGER(proc-recid), "DataObject", Data_Object, OUTPUT ok).

  RUN adecomm/_setcurs.p("":U). 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

