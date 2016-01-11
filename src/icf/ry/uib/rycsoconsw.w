&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          asdb             PROGRESS
          rydb             PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win

/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER instance_page FOR ryc_page.
DEFINE BUFFER lb_ryc_smartobject FOR ryc_smartobject.
DEFINE BUFFER source_object_instance FOR ryc_object_instance.
DEFINE BUFFER source_smartobject FOR ryc_smartobject.
DEFINE BUFFER target_object_instance FOR ryc_object_instance.
DEFINE BUFFER target_smartobject FOR ryc_smartobject.


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

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME brLink

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ryc_smartlink source_object_instance ~
source_smartobject target_object_instance target_smartobject ~
ryc_object_instance lb_ryc_smartobject ryc_page_object instance_page ~
gsc_object_type ryc_page ryc_smartobject

/* Definitions for BROWSE brLink                                        */
&Scoped-define FIELDS-IN-QUERY-brLink ryc_smartlink.link_name 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brLink 
&Scoped-define OPEN-QUERY-brLink OPEN QUERY brLink FOR EACH ryc_smartlink ~
      WHERE ryc_smartlink.container_smartobject_obj = ryc_smartobject.smartobject_obj NO-LOCK, ~
      FIRST source_object_instance WHERE TRUE /* Join to ryc_smartlink incomplete */ OUTER-JOIN NO-LOCK, ~
      FIRST source_smartobject OF source_object_instance OUTER-JOIN NO-LOCK, ~
      FIRST target_object_instance WHERE TRUE /* Join to ryc_smartlink incomplete */ OUTER-JOIN NO-LOCK, ~
      FIRST target_smartobject OF target_object_instance OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brLink ryc_smartlink source_object_instance ~
source_smartobject target_object_instance target_smartobject
&Scoped-define FIRST-TABLE-IN-QUERY-brLink ryc_smartlink
&Scoped-define SECOND-TABLE-IN-QUERY-brLink source_object_instance
&Scoped-define THIRD-TABLE-IN-QUERY-brLink source_smartobject
&Scoped-define FOURTH-TABLE-IN-QUERY-brLink target_object_instance
&Scoped-define FIFTH-TABLE-IN-QUERY-brLink target_smartobject


/* Definitions for BROWSE brObjectInstance                              */
&Scoped-define FIELDS-IN-QUERY-brObjectInstance ~
ryc_object_instance.object_instance_obj lb_ryc_smartobject.object_filename ~
ryc_object_instance.attribute_list instance_page.page_label 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brObjectInstance 
&Scoped-define OPEN-QUERY-brObjectInstance OPEN QUERY brObjectInstance FOR EACH ryc_object_instance ~
      WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj NO-LOCK, ~
      EACH lb_ryc_smartobject WHERE TRUE /* Join to ryc_object_instance incomplete */ ~
      AND lb_ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj NO-LOCK, ~
      EACH ryc_page_object OF ryc_object_instance OUTER-JOIN NO-LOCK, ~
      EACH instance_page WHERE TRUE /* Join to ryc_page_object incomplete */ OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brObjectInstance ryc_object_instance ~
lb_ryc_smartobject ryc_page_object instance_page
&Scoped-define FIRST-TABLE-IN-QUERY-brObjectInstance ryc_object_instance
&Scoped-define SECOND-TABLE-IN-QUERY-brObjectInstance lb_ryc_smartobject
&Scoped-define THIRD-TABLE-IN-QUERY-brObjectInstance ryc_page_object
&Scoped-define FOURTH-TABLE-IN-QUERY-brObjectInstance instance_page


/* Definitions for BROWSE brObjectType                                  */
&Scoped-define FIELDS-IN-QUERY-brObjectType ~
gsc_object_type.object_type_description 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brObjectType 
&Scoped-define OPEN-QUERY-brObjectType OPEN QUERY brObjectType FOR EACH gsc_object_type NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brObjectType gsc_object_type
&Scoped-define FIRST-TABLE-IN-QUERY-brObjectType gsc_object_type


/* Definitions for BROWSE brPage                                        */
&Scoped-define FIELDS-IN-QUERY-brPage ryc_page.page_sequence ~
ryc_page.page_label 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPage 
&Scoped-define OPEN-QUERY-brPage OPEN QUERY brPage FOR EACH ryc_page ~
      WHERE ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj NO-LOCK ~
    BY ryc_page.page_sequence INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brPage ryc_page
&Scoped-define FIRST-TABLE-IN-QUERY-brPage ryc_page


/* Definitions for BROWSE brSmartObject                                 */
&Scoped-define FIELDS-IN-QUERY-brSmartObject ~
ryc_smartobject.object_filename 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSmartObject 
&Scoped-define OPEN-QUERY-brSmartObject OPEN QUERY brSmartObject FOR EACH ryc_smartobject ~
      WHERE ryc_smartobject.object_type_obj = gsc_object_type.Object_Type_Obj NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSmartObject ryc_smartobject
&Scoped-define FIRST-TABLE-IN-QUERY-brSmartObject ryc_smartobject


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-brLink}~
    ~{&OPEN-QUERY-brObjectInstance}~
    ~{&OPEN-QUERY-brObjectType}~
    ~{&OPEN-QUERY-brPage}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brObjectType brSmartObject brObjectInstance ~
BuButton BuButton-2 buSetPage brLink BuButton-3 BuButton-4 brPage ~
BuButton-6 BuButton-7 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BuButton 
     LABEL "Add" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON BuButton-2 
     LABEL "Delete" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON BuButton-3 
     LABEL "Add" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON BuButton-4 
     LABEL "Delete" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON BuButton-6 
     LABEL "Add" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON BuButton-7 
     LABEL "Delete" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buSetPage 
     LABEL "Set Page" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brLink FOR 
      ryc_smartlink, 
      source_object_instance, 
      source_smartobject, 
      target_object_instance, 
      target_smartobject SCROLLING.

DEFINE QUERY brObjectInstance FOR 
      ryc_object_instance, 
      lb_ryc_smartobject, 
      ryc_page_object, 
      instance_page SCROLLING.

DEFINE QUERY brObjectType FOR 
      gsc_object_type SCROLLING.

DEFINE QUERY brPage FOR 
      ryc_page SCROLLING.

DEFINE QUERY brSmartObject FOR 
      ryc_smartobject SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brLink
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brLink C-Win _STRUCTURED
  QUERY brLink NO-LOCK DISPLAY
      ryc_smartlink.link_name FORMAT "x(20)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 4.52 EXPANDABLE.

DEFINE BROWSE brObjectInstance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brObjectInstance C-Win _STRUCTURED
  QUERY brObjectInstance NO-LOCK DISPLAY
      ryc_object_instance.object_instance_obj FORMAT ">>>>>>>>>>>>>>>>>9":U
      lb_ryc_smartobject.object_filename FORMAT "X(70)":U
      ryc_object_instance.attribute_list FORMAT "X(80)":U WIDTH 33.2
      instance_page.page_label FORMAT "X(28)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 5 EXPANDABLE.

DEFINE BROWSE brObjectType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brObjectType C-Win _STRUCTURED
  QUERY brObjectType NO-LOCK DISPLAY
      gsc_object_type.object_type_description FORMAT "X(35)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 30 BY 5 EXPANDABLE.

DEFINE BROWSE brPage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPage C-Win _STRUCTURED
  QUERY brPage NO-LOCK DISPLAY
      ryc_page.page_sequence FORMAT "->9":U
      ryc_page.page_label FORMAT "X(28)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 5 EXPANDABLE.

DEFINE BROWSE brSmartObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSmartObject C-Win _STRUCTURED
  QUERY brSmartObject NO-LOCK DISPLAY
      ryc_smartobject.object_filename FORMAT "X(70)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 23 BY 5 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     brObjectType AT ROW 1.24 COL 2
     brSmartObject AT ROW 1.24 COL 33
     brObjectInstance AT ROW 6.48 COL 2
     BuButton AT ROW 6.48 COL 81
     BuButton-2 AT ROW 7.91 COL 81
     buSetPage AT ROW 9.33 COL 81
     brLink AT ROW 11.71 COL 2
     BuButton-3 AT ROW 11.71 COL 81
     BuButton-4 AT ROW 13.14 COL 81
     brPage AT ROW 16.48 COL 2
     BuButton-6 AT ROW 16.48 COL 81
     BuButton-7 AT ROW 17.91 COL 81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96 BY 20.76.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: instance_page B "?" ? RYDB ryc_page
      TABLE: lb_ryc_smartobject B "?" ? RYDB ryc_smartobject
      TABLE: source_object_instance B "?" ? RYDB ryc_object_instance
      TABLE: source_smartobject B "?" ? RYDB ryc_smartobject
      TABLE: target_object_instance B "?" ? RYDB ryc_object_instance
      TABLE: target_smartobject B "?" ? RYDB ryc_smartobject
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Attributes of Object Instances"
         HEIGHT             = 20.76
         WIDTH              = 96
         MAX-HEIGHT         = 24.86
         MAX-WIDTH          = 118.8
         VIRTUAL-HEIGHT     = 24.86
         VIRTUAL-WIDTH      = 118.8
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* BROWSE-TAB brObjectType 1 DEFAULT-FRAME */
/* BROWSE-TAB brSmartObject brObjectType DEFAULT-FRAME */
/* BROWSE-TAB brObjectInstance brSmartObject DEFAULT-FRAME */
/* BROWSE-TAB brLink buSetPage DEFAULT-FRAME */
/* BROWSE-TAB brPage BuButton-4 DEFAULT-FRAME */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brLink
/* Query rebuild information for BROWSE brLink
     _TblList          = "RYDB.ryc_smartlink,source_object_instance WHERE RYDB.ryc_smartlink ...,source_smartobject OF source_object_instance,target_object_instance WHERE RYDB.ryc_smartlink ...,target_smartobject OF target_object_instance"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER, FIRST OUTER, FIRST OUTER, FIRST OUTER"
     _Where[1]         = "RYDB.ryc_smartlink.container_smartobject_obj = ryc_smartobject.smartobject_obj"
     _FldNameList[1]   > RYDB.ryc_smartlink.link_name
"ryc_smartlink.link_name" ? "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brLink */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brObjectInstance
/* Query rebuild information for BROWSE brObjectInstance
     _TblList          = "RYDB.ryc_object_instance,lb_ryc_smartobject WHERE RYDB.ryc_object_instance ...,RYDB.ryc_page_object OF RYDB.ryc_object_instance,instance_page WHERE RYDB.ryc_page_object ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ",, OUTER, OUTER"
     _Where[1]         = "RYDB.ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj"
     _Where[2]         = "lb_ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj"
     _FldNameList[1]   = RYDB.ryc_object_instance.object_instance_obj
     _FldNameList[2]   = Temp-Tables.lb_ryc_smartobject.object_filename
     _FldNameList[3]   > RYDB.ryc_object_instance.attribute_list
"ryc_object_instance.attribute_list" ? "X(80)" "character" ? ? ? ? ? ? no ? no no "33.2" yes no no "U" "" ""
     _FldNameList[4]   = Temp-Tables.instance_page.page_label
     _Query            is OPENED
*/  /* BROWSE brObjectInstance */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brObjectType
/* Query rebuild information for BROWSE brObjectType
     _TblList          = "asdb.gsc_object_type"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = asdb.gsc_object_type.object_type_description
     _Query            is OPENED
*/  /* BROWSE brObjectType */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPage
/* Query rebuild information for BROWSE brPage
     _TblList          = "RYDB.ryc_page"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "RYDB.ryc_page.page_sequence|yes"
     _Where[1]         = "RYDB.ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj"
     _FldNameList[1]   = RYDB.ryc_page.page_sequence
     _FldNameList[2]   = RYDB.ryc_page.page_label
     _Query            is OPENED
*/  /* BROWSE brPage */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSmartObject
/* Query rebuild information for BROWSE brSmartObject
     _TblList          = "RYDB.ryc_smartobject"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "RYDB.ryc_smartobject.object_type_obj = gsc_object_type.Object_Type_Obj"
     _FldNameList[1]   = RYDB.ryc_smartobject.object_filename
     _Query            is NOT OPENED
*/  /* BROWSE brSmartObject */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Attributes of Object Instances */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Attributes of Object Instances */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brObjectType
&Scoped-define SELF-NAME brObjectType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brObjectType C-Win
ON ITERATION-CHANGED OF brObjectType IN FRAME DEFAULT-FRAME
DO:
    RUN open-query-smartobject.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brPage
&Scoped-define SELF-NAME brPage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPage C-Win
ON ITERATION-CHANGED OF brPage IN FRAME DEFAULT-FRAME
DO:
    IF AVAILABLE ryc_page THEN ASSIGN  buSetPage:LABEL IN FRAME {&FRAME-NAME} = "Set Page " + STRING(ryc_page.PAGE_sequence) .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSmartObject
&Scoped-define SELF-NAME brSmartObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSmartObject C-Win
ON ITERATION-CHANGED OF brSmartObject IN FRAME DEFAULT-FRAME
DO:      
    RUN open-query-object-instance.
    RUN open-query-page.
    RUN open-query-link.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brLink
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

ON FIND OF ryc_attribute DO:
    IF CAN-FIND(FIRST ryc_attribute_value 
                    WHERE ryc_attribute_value.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj
                    AND   ryc_attribute_value.attribute_label = ryc_attribute.attribute_label) 
        THEN RETURN ERROR.
END.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  APPLY "ITERATION-CHANGED":U TO brObjectType.
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
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
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
  ENABLE brObjectType brSmartObject brObjectInstance BuButton BuButton-2 
         buSetPage brLink BuButton-3 BuButton-4 brPage BuButton-6 BuButton-7 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE open-query-link C-Win 
PROCEDURE open-query-link :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&OPEN-QUERY-brLink}
    APPLY "ITERATION-CHANGED":U TO brLink IN FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE open-query-object-instance C-Win 
PROCEDURE open-query-object-instance :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&OPEN-QUERY-brObjectInstance}
    APPLY "ITERATION-CHANGED":U TO brObjectInstance IN FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE open-query-page C-Win 
PROCEDURE open-query-page :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&OPEN-QUERY-brPage}
    APPLY "ITERATION-CHANGED":U TO brPage IN FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE open-query-smartobject C-Win 
PROCEDURE open-query-smartobject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&OPEN-QUERY-brSmartObject}
    APPLY "ITERATION-CHANGED":U TO brSmartObject IN FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

