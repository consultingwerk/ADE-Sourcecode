&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          asdb             PROGRESS
          rydb             PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win

/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER instance_page FOR ryc_page.
DEFINE BUFFER lb_object_type FOR gsc_object_type.
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

DEFINE VARIABLE hLauncher AS HANDLE NO-UNDO.

{af/sup2/afglobals.i}
{af/sup2/afcheckerr.i &DEFINE-ONLY=YES}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME brAttributeValue

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ryc_attribute_value ryc_smartlink ~
source_object_instance source_smartobject target_object_instance ~
target_smartobject ryc_object_instance lb_ryc_smartobject ryc_page_object ~
instance_page lb_object_type gsc_object_type ryc_page ryc_layout ~
ryc_smartobject

/* Definitions for BROWSE brAttributeValue                              */
&Scoped-define FIELDS-IN-QUERY-brAttributeValue ~
ryc_attribute_value.attribute_label ryc_attribute_value.constant_value ~
ryc_attribute_value.inheritted_value ryc_attribute_value.attribute_value 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brAttributeValue 
&Scoped-define OPEN-QUERY-brAttributeValue OPEN QUERY brAttributeValue FOR EACH ryc_attribute_value ~
      WHERE ryc_attribute_value.smartobject_obj = ryc_smartobject.smartobject_obj ~
and ryc_attribute_value.container_smartobject_obj = 0  ~
and ryc_attribute_value.object_instance_obj = 0 NO-LOCK ~
    BY ryc_attribute_value.attribute_label INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brAttributeValue ryc_attribute_value
&Scoped-define FIRST-TABLE-IN-QUERY-brAttributeValue ryc_attribute_value


/* Definitions for BROWSE brAttributeValue2                             */
&Scoped-define FIELDS-IN-QUERY-brAttributeValue2 ~
ryc_attribute_value.attribute_label ryc_attribute_value.constant_value ~
ryc_attribute_value.inheritted_value ryc_attribute_value.attribute_value 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brAttributeValue2 
&Scoped-define OPEN-QUERY-brAttributeValue2 OPEN QUERY brAttributeValue2 FOR EACH ryc_attribute_value ~
      WHERE ryc_attribute_value.object_instance_obj = ryc_object_instance.object_instance_obj ~
 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brAttributeValue2 ryc_attribute_value
&Scoped-define FIRST-TABLE-IN-QUERY-brAttributeValue2 ryc_attribute_value


/* Definitions for BROWSE brLink                                        */
&Scoped-define FIELDS-IN-QUERY-brLink ~
(IF AVAILABLE source_smartobject THEN source_smartobject.object_filename ELSE 'THIS-OBJECT') ~
ryc_smartlink.link_name ~
(IF AVAILABLE target_smartobject THEN target_smartobject.object_filename ELSE 'THIS-OBJECT') ~
ryc_object_instance.layout_position 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brLink 
&Scoped-define OPEN-QUERY-brLink OPEN QUERY brLink FOR EACH ryc_smartlink ~
      WHERE ryc_smartlink.container_smartobject_obj = ryc_smartobject.smartobject_obj NO-LOCK, ~
      FIRST source_object_instance WHERE source_object_instance.object_instance_obj = ryc_smartlink.source_object_instance_obj OUTER-JOIN NO-LOCK, ~
      FIRST source_smartobject OF source_object_instance OUTER-JOIN NO-LOCK, ~
      FIRST target_object_instance WHERE target_object_instance.object_instance_obj = ryc_smartlink.target_object_instance_obj OUTER-JOIN NO-LOCK, ~
      FIRST target_smartobject OF target_object_instance OUTER-JOIN NO-LOCK, ~
      FIRST ryc_object_instance OF source_object_instance OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brLink ryc_smartlink source_object_instance ~
source_smartobject target_object_instance target_smartobject ~
ryc_object_instance
&Scoped-define FIRST-TABLE-IN-QUERY-brLink ryc_smartlink
&Scoped-define SECOND-TABLE-IN-QUERY-brLink source_object_instance
&Scoped-define THIRD-TABLE-IN-QUERY-brLink source_smartobject
&Scoped-define FOURTH-TABLE-IN-QUERY-brLink target_object_instance
&Scoped-define FIFTH-TABLE-IN-QUERY-brLink target_smartobject
&Scoped-define SIXTH-TABLE-IN-QUERY-brLink ryc_object_instance


/* Definitions for BROWSE brObjectInstance                              */
&Scoped-define FIELDS-IN-QUERY-brObjectInstance ~
ryc_object_instance.object_instance_obj ~
lb_object_type.object_type_description lb_ryc_smartobject.object_filename ~
instance_page.page_label ryc_object_instance.attribute_list 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brObjectInstance 
&Scoped-define OPEN-QUERY-brObjectInstance OPEN QUERY brObjectInstance FOR EACH ryc_object_instance ~
      WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj NO-LOCK, ~
      FIRST lb_ryc_smartobject WHERE lb_ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj OUTER-JOIN NO-LOCK, ~
      FIRST ryc_page_object OF ryc_object_instance OUTER-JOIN NO-LOCK, ~
      FIRST instance_page WHERE instance_page.page_obj = ryc_page_object.page_obj OUTER-JOIN NO-LOCK, ~
      EACH lb_object_type OF lb_ryc_smartobject OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brObjectInstance ryc_object_instance ~
lb_ryc_smartobject ryc_page_object instance_page lb_object_type
&Scoped-define FIRST-TABLE-IN-QUERY-brObjectInstance ryc_object_instance
&Scoped-define SECOND-TABLE-IN-QUERY-brObjectInstance lb_ryc_smartobject
&Scoped-define THIRD-TABLE-IN-QUERY-brObjectInstance ryc_page_object
&Scoped-define FOURTH-TABLE-IN-QUERY-brObjectInstance instance_page
&Scoped-define FIFTH-TABLE-IN-QUERY-brObjectInstance lb_object_type


/* Definitions for BROWSE brObjectInstance2                             */
&Scoped-define FIELDS-IN-QUERY-brObjectInstance2 ~
ryc_object_instance.object_instance_obj lb_ryc_smartobject.object_filename ~
ryc_object_instance.attribute_list 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brObjectInstance2 
&Scoped-define OPEN-QUERY-brObjectInstance2 OPEN QUERY brObjectInstance2 FOR EACH ryc_object_instance ~
      WHERE ryc_object_instance.smartobject_obj = ryc_smartobject.smartobject_obj NO-LOCK, ~
      EACH lb_ryc_smartobject WHERE lb_ryc_smartobject.smartobject_obj = ryc_object_instance.container_smartobject_obj NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brObjectInstance2 ryc_object_instance ~
lb_ryc_smartobject
&Scoped-define FIRST-TABLE-IN-QUERY-brObjectInstance2 ryc_object_instance
&Scoped-define SECOND-TABLE-IN-QUERY-brObjectInstance2 lb_ryc_smartobject


/* Definitions for BROWSE brObjectType                                  */
&Scoped-define FIELDS-IN-QUERY-brObjectType ~
gsc_object_type.object_type_description 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brObjectType 
&Scoped-define OPEN-QUERY-brObjectType OPEN QUERY brObjectType FOR EACH gsc_object_type ~
      WHERE gsc_object_type.object_type_description BEGINS "Static"  ~
OR gsc_object_type.object_type_description BEGINS "Dynamic"  ~
OR NOT tbStaticDynamicOnly NO-LOCK ~
    BY gsc_object_type.object_type_description INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brObjectType gsc_object_type
&Scoped-define FIRST-TABLE-IN-QUERY-brObjectType gsc_object_type


/* Definitions for BROWSE brPage                                        */
&Scoped-define FIELDS-IN-QUERY-brPage ryc_page.page_sequence ~
ryc_page.page_label ryc_layout.layout_name 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPage 
&Scoped-define OPEN-QUERY-brPage OPEN QUERY brPage FOR EACH ryc_page ~
      WHERE ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj NO-LOCK, ~
      EACH ryc_layout WHERE ryc_layout.layout_obj = ryc_page.layout_obj NO-LOCK ~
    BY ryc_page.page_sequence INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brPage ryc_page ryc_layout
&Scoped-define FIRST-TABLE-IN-QUERY-brPage ryc_page
&Scoped-define SECOND-TABLE-IN-QUERY-brPage ryc_layout


/* Definitions for BROWSE brSmartObject                                 */
&Scoped-define FIELDS-IN-QUERY-brSmartObject ~
ryc_smartobject.object_filename 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSmartObject 
&Scoped-define OPEN-QUERY-brSmartObject OPEN QUERY brSmartObject FOR EACH ryc_smartobject ~
      WHERE ryc_smartobject.object_type_obj = gsc_object_type.Object_Type_Obj NO-LOCK ~
    BY ryc_smartobject.object_filename INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSmartObject ryc_smartobject
&Scoped-define FIRST-TABLE-IN-QUERY-brSmartObject ryc_smartobject


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Definitions for FRAME fr1                                            */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fr1 ~
    ~{&OPEN-QUERY-brObjectInstance}

/* Definitions for FRAME fr2                                            */

/* Definitions for FRAME fr3                                            */

/* Definitions for FRAME fr4                                            */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fr4 ~
    ~{&OPEN-QUERY-brObjectInstance2}

/* Definitions for FRAME fr5                                            */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fr5 ~
    ~{&OPEN-QUERY-brLink}~
    ~{&OPEN-QUERY-brPage}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbStaticDynamicOnly rsView brObjectType ~
brSmartObject buAddObject buModifyObject buFields buClearCache buRun 
&Scoped-Define DISPLAYED-OBJECTS tbStaticDynamicOnly rsView 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buAddObject 
     LABEL "Add" 
     SIZE 9 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buClearCache 
     LABEL "Clear Cache" 
     SIZE 17 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buFields 
     LABEL "Fields" 
     SIZE 10 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buModifyObject 
     LABEL "Modify" 
     SIZE 10 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buRun 
     LABEL "Run" 
     SIZE 13 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE rsView AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "SmartObject Attributes", "1",
"Usage", "4",
"Instances, Pages, Links", "3",
"Instance Attributes", "2"
     SIZE 96 BY .86 NO-UNDO.

DEFINE VARIABLE tbStaticDynamicOnly AS LOGICAL INITIAL no 
     LABEL "Static/Dynamic Types Only" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .81 NO-UNDO.

DEFINE BUTTON buAddInstance 
     LABEL "Add" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON BuDeleteInstance 
     LABEL "Delete" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buSetPage 
     LABEL "Set Page" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buSetPagex 
     LABEL "Set Page ?" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buSet  NO-FOCUS FLAT-BUTTON
     LABEL "Set" 
     SIZE 15 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE fiValue AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 78 BY 1 NO-UNDO.

DEFINE BUTTON buSet2  NO-FOCUS FLAT-BUTTON
     LABEL "Set" 
     SIZE 15 BY 1
     BGCOLOR 8 .

DEFINE BUTTON buAddLink 
     LABEL "Add" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buAddPage 
     LABEL "Add" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buDeleteLink 
     LABEL "Delete" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buDeletePage 
     LABEL "Delete" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brAttributeValue FOR 
      ryc_attribute_value SCROLLING.

DEFINE QUERY brAttributeValue2 FOR 
      ryc_attribute_value SCROLLING.

DEFINE QUERY brLink FOR 
      ryc_smartlink, 
      source_object_instance, 
      source_smartobject, 
      target_object_instance, 
      target_smartobject, 
      ryc_object_instance SCROLLING.

DEFINE QUERY brObjectInstance FOR 
      ryc_object_instance, 
      lb_ryc_smartobject, 
      ryc_page_object, 
      instance_page, 
      lb_object_type SCROLLING.

DEFINE QUERY brObjectInstance2 FOR 
      ryc_object_instance, 
      lb_ryc_smartobject SCROLLING.

DEFINE QUERY brObjectType FOR 
      gsc_object_type SCROLLING.

DEFINE QUERY brPage FOR 
      ryc_page, 
      ryc_layout SCROLLING.

DEFINE QUERY brSmartObject FOR 
      ryc_smartobject SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brAttributeValue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brAttributeValue C-Win _STRUCTURED
  QUERY brAttributeValue NO-LOCK DISPLAY
      ryc_attribute_value.attribute_label FORMAT "X(35)":U
      ryc_attribute_value.constant_value FORMAT "YES/NO":U
      ryc_attribute_value.inheritted_value FORMAT "YES/NO":U
      ryc_attribute_value.attribute_value FORMAT "X(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 94 BY 16.43 EXPANDABLE.

DEFINE BROWSE brAttributeValue2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brAttributeValue2 C-Win _STRUCTURED
  QUERY brAttributeValue2 NO-LOCK DISPLAY
      ryc_attribute_value.attribute_label FORMAT "X(35)":U
      ryc_attribute_value.constant_value FORMAT "YES/NO":U
      ryc_attribute_value.inheritted_value FORMAT "YES/NO":U
      ryc_attribute_value.attribute_value FORMAT "X(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 94 BY 10.48 ROW-HEIGHT-CHARS .57 EXPANDABLE.

DEFINE BROWSE brLink
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brLink C-Win _STRUCTURED
  QUERY brLink NO-LOCK DISPLAY
      (IF AVAILABLE source_smartobject THEN source_smartobject.object_filename ELSE 'THIS-OBJECT') COLUMN-LABEL "Source" FORMAT "X(20)":U
      ryc_smartlink.link_name FORMAT "x(20)":U
      (IF AVAILABLE target_smartobject THEN target_smartobject.object_filename ELSE 'THIS-OBJECT') COLUMN-LABEL "Target" FORMAT "X(20)":U
      ryc_object_instance.layout_position FORMAT "X(15)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 5.71 EXPANDABLE.

DEFINE BROWSE brObjectInstance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brObjectInstance C-Win _STRUCTURED
  QUERY brObjectInstance NO-LOCK DISPLAY
      ryc_object_instance.object_instance_obj FORMAT ">>>>>>>>>>>>>>>>>9":U
            WIDTH 22.2
      lb_object_type.object_type_description
      lb_ryc_smartobject.object_filename FORMAT "X(70)":U
      instance_page.page_label FORMAT "X(28)":U
      ryc_object_instance.attribute_list FORMAT "X(300)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 5.71 EXPANDABLE.

DEFINE BROWSE brObjectInstance2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brObjectInstance2 C-Win _STRUCTURED
  QUERY brObjectInstance2 NO-LOCK DISPLAY
      ryc_object_instance.object_instance_obj FORMAT ">>>>>>>>>>>>>>>>>9":U
      lb_ryc_smartobject.object_filename FORMAT "X(20)":U
      ryc_object_instance.attribute_list FORMAT "X(80)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 94 BY 17.62 EXPANDABLE.

DEFINE BROWSE brObjectType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brObjectType C-Win _STRUCTURED
  QUERY brObjectType NO-LOCK DISPLAY
      gsc_object_type.object_type_description FORMAT "X(35)":U
            WIDTH 30
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 31 BY 5 EXPANDABLE.

DEFINE BROWSE brPage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPage C-Win _STRUCTURED
  QUERY brPage NO-LOCK DISPLAY
      ryc_page.page_sequence FORMAT "->9":U
      ryc_page.page_label FORMAT "X(28)":U WIDTH 31
      ryc_layout.layout_name FORMAT "X(28)":U WIDTH 30
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 5.71 EXPANDABLE.

DEFINE BROWSE brSmartObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSmartObject C-Win _STRUCTURED
  QUERY brSmartObject NO-LOCK DISPLAY
      ryc_smartobject.object_filename FORMAT "X(70)":U WIDTH 30
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 31 BY 10.71 ROW-HEIGHT-CHARS .71 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     tbStaticDynamicOnly AT ROW 1.24 COL 2
     rsView AT ROW 1.24 COL 34 NO-LABEL
     brObjectType AT ROW 2.19 COL 2
     brSmartObject AT ROW 7.43 COL 2
     buAddObject AT ROW 18.38 COL 2
     buModifyObject AT ROW 18.38 COL 12
     buFields AT ROW 18.38 COL 23
     buClearCache AT ROW 19.81 COL 2
     buRun AT ROW 19.81 COL 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 130.8 BY 20.33.

DEFINE FRAME fr4
     brObjectInstance2 AT ROW 1.24 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 34 ROW 2.19
         SIZE 97 BY 19.05
         TITLE "Objects which contain Instances of this SmartObject".

DEFINE FRAME fr2
     brAttributeValue AT ROW 1.24 COL 2
     buSet AT ROW 17.91 COL 81
     fiValue AT ROW 17.91 COL 2 NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 34 ROW 2.19
         SIZE 97 BY 19.05
         TITLE "SmartObject Attributes".

DEFINE FRAME fr1
     brObjectInstance AT ROW 1.24 COL 2
     buAddInstance AT ROW 1.24 COL 81
     BuDeleteInstance AT ROW 2.67 COL 81
     buSetPage AT ROW 4.1 COL 81
     buSetPagex AT ROW 5.52 COL 81
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 34 ROW 2.19
         SIZE 97 BY 19.05
         TITLE "fr1".

DEFINE FRAME fr3
     brAttributeValue2 AT ROW 1 COL 1
     buSet2 AT ROW 11.71 COL 80
     fiValue AT ROW 11.71 COL 1 NO-LABEL FORMAT "X(256)":U
          VIEW-AS FILL-IN 
          SIZE 78 BY 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 7.19
         SIZE 95 BY 11.91.

DEFINE FRAME fr5
     brLink AT ROW 1 COL 1
     buAddLink AT ROW 1 COL 80
     buDeleteLink AT ROW 2.43 COL 80
     brPage AT ROW 6.95 COL 1
     buAddPage AT ROW 6.95 COL 80
     buDeletePage AT ROW 8.38 COL 80
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 7.19
         SIZE 95 BY 11.91.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: instance_page B "?" ? RYDB ryc_page
      TABLE: lb_object_type B "?" ? asdb gsc_object_type
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
         HEIGHT             = 20.33
         WIDTH              = 130.8
         MAX-HEIGHT         = 27.67
         MAX-WIDTH          = 160
         VIRTUAL-HEIGHT     = 27.67
         VIRTUAL-WIDTH      = 160
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
/* REPARENT FRAME */
ASSIGN FRAME fr1:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME fr2:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME fr3:FRAME = FRAME fr1:HANDLE
       FRAME fr4:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME fr5:FRAME = FRAME fr1:HANDLE.

/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fr4:MOVE-AFTER-TAB-ITEM (brObjectType:HANDLE IN FRAME DEFAULT-FRAME)
       XXTABVALXX = FRAME fr1:MOVE-BEFORE-TAB-ITEM (brSmartObject:HANDLE IN FRAME DEFAULT-FRAME)
       XXTABVALXX = FRAME fr2:MOVE-BEFORE-TAB-ITEM (FRAME fr1:HANDLE)
       XXTABVALXX = FRAME fr4:MOVE-BEFORE-TAB-ITEM (FRAME fr2:HANDLE)
/* END-ASSIGN-TABS */.

/* BROWSE-TAB brObjectType rsView DEFAULT-FRAME */
/* BROWSE-TAB brSmartObject fr1 DEFAULT-FRAME */
/* SETTINGS FOR FRAME fr1
                                                                        */
ASSIGN XXTABVALXX = FRAME fr5:MOVE-AFTER-TAB-ITEM (buSetPagex:HANDLE IN FRAME fr1)
       XXTABVALXX = FRAME fr5:MOVE-BEFORE-TAB-ITEM (FRAME fr3:HANDLE)
/* END-ASSIGN-TABS */.

/* BROWSE-TAB brObjectInstance 1 fr1 */
/* SETTINGS FOR FRAME fr2
                                                                        */
/* BROWSE-TAB brAttributeValue 1 fr2 */
/* SETTINGS FOR FILL-IN fiValue IN FRAME fr2
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fr3
                                                                        */
/* BROWSE-TAB brAttributeValue2 1 fr3 */
/* SETTINGS FOR FILL-IN fiValue IN FRAME fr3
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fr4
                                                                        */
/* BROWSE-TAB brObjectInstance2 1 fr4 */
/* SETTINGS FOR FRAME fr5
                                                                        */
/* BROWSE-TAB brLink 1 fr5 */
/* BROWSE-TAB brPage buDeleteLink fr5 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brAttributeValue
/* Query rebuild information for BROWSE brAttributeValue
     _TblList          = "RYDB.ryc_attribute_value"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "RYDB.ryc_attribute_value.attribute_label|yes"
     _Where[1]         = "ryc_attribute_value.smartobject_obj = ryc_smartobject.smartobject_obj
and ryc_attribute_value.container_smartobject_obj = 0 
and ryc_attribute_value.object_instance_obj = 0"
     _FldNameList[1]   = RYDB.ryc_attribute_value.attribute_label
     _FldNameList[2]   = RYDB.ryc_attribute_value.constant_value
     _FldNameList[3]   = RYDB.ryc_attribute_value.inheritted_value
     _FldNameList[4]   > RYDB.ryc_attribute_value.attribute_value
"ryc_attribute_value.attribute_value" ? "X(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is NOT OPENED
*/  /* BROWSE brAttributeValue */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brAttributeValue2
/* Query rebuild information for BROWSE brAttributeValue2
     _TblList          = "RYDB.ryc_attribute_value"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "ryc_attribute_value.object_instance_obj = ryc_object_instance.object_instance_obj
"
     _FldNameList[1]   = RYDB.ryc_attribute_value.attribute_label
     _FldNameList[2]   = RYDB.ryc_attribute_value.constant_value
     _FldNameList[3]   = RYDB.ryc_attribute_value.inheritted_value
     _FldNameList[4]   > RYDB.ryc_attribute_value.attribute_value
"ryc_attribute_value.attribute_value" ? "X(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is NOT OPENED
*/  /* BROWSE brAttributeValue2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brLink
/* Query rebuild information for BROWSE brLink
     _TblList          = "RYDB.ryc_smartlink,source_object_instance WHERE RYDB.ryc_smartlink ...,source_smartobject OF source_object_instance,target_object_instance WHERE RYDB.ryc_smartlink ...,target_smartobject OF target_object_instance,RYDB.ryc_object_instance OF source_object_instance"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER, FIRST OUTER, FIRST OUTER, FIRST OUTER, FIRST OUTER"
     _Where[1]         = "RYDB.ryc_smartlink.container_smartobject_obj = ryc_smartobject.smartobject_obj"
     _JoinCode[2]      = "source_object_instance.object_instance_obj = RYDB.ryc_smartlink.source_object_instance_obj"
     _JoinCode[4]      = "target_object_instance.object_instance_obj = RYDB.ryc_smartlink.target_object_instance_obj"
     _FldNameList[1]   > "_<CALC>"
"(IF AVAILABLE source_smartobject THEN source_smartobject.object_filename ELSE 'THIS-OBJECT')" "Source" "X(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[2]   > RYDB.ryc_smartlink.link_name
"ryc_smartlink.link_name" ? "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[3]   > "_<CALC>"
"(IF AVAILABLE target_smartobject THEN target_smartobject.object_filename ELSE 'THIS-OBJECT')" "Target" "X(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[4]   = RYDB.ryc_object_instance.layout_position
     _Query            is OPENED
*/  /* BROWSE brLink */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brObjectInstance
/* Query rebuild information for BROWSE brObjectInstance
     _TblList          = "RYDB.ryc_object_instance,lb_ryc_smartobject WHERE RYDB.ryc_object_instance ...,RYDB.ryc_page_object OF RYDB.ryc_object_instance,instance_page WHERE RYDB.ryc_page_object ...,lb_object_type OF lb_ryc_smartobject"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER, FIRST OUTER, FIRST OUTER, OUTER"
     _Where[1]         = "RYDB.ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj"
     _JoinCode[2]      = "lb_ryc_smartobject.smartobject_obj = RYDB.ryc_object_instance.smartobject_obj"
     _JoinCode[4]      = "instance_page.page_obj = RYDB.ryc_page_object.page_obj"
     _FldNameList[1]   > RYDB.ryc_object_instance.object_instance_obj
"ryc_object_instance.object_instance_obj" ? ? "decimal" ? ? ? ? ? ? no ? no no "22.2" yes no no "U" "" ""
     _FldNameList[2]   > "_<CALC>"
"lb_object_type.object_type_description" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[3]   = Temp-Tables.lb_ryc_smartobject.object_filename
     _FldNameList[4]   = Temp-Tables.instance_page.page_label
     _FldNameList[5]   > RYDB.ryc_object_instance.attribute_list
"ryc_object_instance.attribute_list" ? "X(300)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brObjectInstance */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brObjectInstance2
/* Query rebuild information for BROWSE brObjectInstance2
     _TblList          = "RYDB.ryc_object_instance,lb_ryc_smartobject WHERE RYDB.ryc_object_instance ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "RYDB.ryc_object_instance.smartobject_obj = ryc_smartobject.smartobject_obj"
     _JoinCode[2]      = "lb_ryc_smartobject.smartobject_obj = RYDB.ryc_object_instance.container_smartobject_obj"
     _FldNameList[1]   = RYDB.ryc_object_instance.object_instance_obj
     _FldNameList[2]   > Temp-Tables.lb_ryc_smartobject.object_filename
"lb_ryc_smartobject.object_filename" ? "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[3]   > RYDB.ryc_object_instance.attribute_list
"ryc_object_instance.attribute_list" ? "X(80)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brObjectInstance2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brObjectType
/* Query rebuild information for BROWSE brObjectType
     _TblList          = "asdb.gsc_object_type"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "asdb.gsc_object_type.object_type_description|yes"
     _Where[1]         = "asdb.gsc_object_type.object_type_description BEGINS ""Static"" 
OR asdb.gsc_object_type.object_type_description BEGINS ""Dynamic"" 
OR NOT tbStaticDynamicOnly"
     _FldNameList[1]   > asdb.gsc_object_type.object_type_description
"gsc_object_type.object_type_description" ? ? "character" ? ? ? ? ? ? no ? no no "30" yes no no "U" "" ""
     _Query            is NOT OPENED
*/  /* BROWSE brObjectType */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPage
/* Query rebuild information for BROWSE brPage
     _TblList          = "RYDB.ryc_page,RYDB.ryc_layout WHERE RYDB.ryc_page ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "RYDB.ryc_page.page_sequence|yes"
     _Where[1]         = "RYDB.ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj"
     _JoinCode[2]      = "RYDB.ryc_layout.layout_obj = RYDB.ryc_page.layout_obj"
     _FldNameList[1]   = RYDB.ryc_page.page_sequence
     _FldNameList[2]   > RYDB.ryc_page.page_label
"ryc_page.page_label" ? ? "character" ? ? ? ? ? ? no ? no no "31" yes no no "U" "" ""
     _FldNameList[3]   > RYDB.ryc_layout.layout_name
"ryc_layout.layout_name" ? ? "character" ? ? ? ? ? ? no ? no no "30" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brPage */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSmartObject
/* Query rebuild information for BROWSE brSmartObject
     _TblList          = "RYDB.ryc_smartobject"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "RYDB.ryc_smartobject.object_filename|yes"
     _Where[1]         = "RYDB.ryc_smartobject.object_type_obj = gsc_object_type.Object_Type_Obj"
     _FldNameList[1]   > RYDB.ryc_smartobject.object_filename
"ryc_smartobject.object_filename" ? ? "character" ? ? ? ? ? ? no ? no no "30" yes no no "U" "" ""
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


&Scoped-define BROWSE-NAME brAttributeValue
&Scoped-define FRAME-NAME fr2
&Scoped-define SELF-NAME brAttributeValue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brAttributeValue C-Win
ON F5 OF brAttributeValue IN FRAME fr2
DO:
  RUN open-query-attributevalue.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brAttributeValue C-Win
ON ITERATION-CHANGED OF brAttributeValue IN FRAME fr2
DO:
    IF AVAILABLE ryc_attribute_value THEN
        ASSIGN 

            fiValue    = ryc_attribute_value.attribute_value.
    ELSE 
        ASSIGN

            fiValue    = "".

    DISPLAY fiValue WITH FRAME {&FRAME-NAME}.


    buSet:SENSITIVE = AVAILABLE ryc_attribute_value AND NOT ryc_attribute_value.constant.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brAttributeValue2
&Scoped-define FRAME-NAME fr3
&Scoped-define SELF-NAME brAttributeValue2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brAttributeValue2 C-Win
ON F5 OF brAttributeValue2 IN FRAME fr3
DO:
  RUN open-query-attributevalue2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brAttributeValue2 C-Win
ON ITERATION-CHANGED OF brAttributeValue2 IN FRAME fr3
DO:
    IF AVAILABLE ryc_attribute_value THEN
        ASSIGN 

            fiValue    = ryc_attribute_value.attribute_value.
    ELSE 
        ASSIGN

            fiValue    = "".

    DISPLAY fiValue WITH FRAME fr3.


    buSet2:SENSITIVE = AVAILABLE ryc_attribute_value AND NOT ryc_attribute_value.constant.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brLink
&Scoped-define FRAME-NAME fr5
&Scoped-define SELF-NAME brLink
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLink C-Win
ON F5 OF brLink IN FRAME fr5
DO:
  RUN open-query-link.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLink C-Win
ON MOUSE-SELECT-DBLCLICK OF brLink IN FRAME fr5
DO:
    DEFINE VARIABLE dContainerSmartobjectObj    AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dSourceObjectInstanceObj    AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dSmartlinkTypeObj           AS DECIMAL NO-UNDO.
    DEFINE VARIABLE cLinkName                   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dTargetObjectInstanceObj    AS DECIMAL.
    DEFINE VARIABLE lProceed                    AS LOGICAL.
    DEFINE BUFFER new_smartlink FOR ryc_smartlink.

    IF AVAILABLE ryc_smartlink THEN
    DO:       
        ASSIGN
            dContainerSmartobjectObj    = ryc_smartobject.smartobject_obj
            dSourceObjectInstanceObj    = ryc_smartlink.source_object_instance_obj
            dSmartlinkTypeObj           = ryc_smartlink.smartlink_type_obj
            cLinkName                   = ryc_smartlink.link_name
            dTargetObjectInstanceObj    = ryc_smartlink.target_object_instance_obj.

        RUN ry/uib/rycsleditd.w (
            INPUT        dContainerSmartObjectObj, 
            INPUT-OUTPUT dSourceObjectInstanceObj,
            INPUT-OUTPUT dSmartlinkTypeObj,
            INPUT-OUTPUT cLinkName,
            INPUT-OUTPUT dTargetObjectInstanceObj,
            OUTPUT lProceed).

        DO TRANSACTION ON ERROR UNDO, LEAVE:
            FIND CURRENT ryc_smartlink EXCLUSIVE-LOCK.
            ASSIGN
                ryc_smartlink.container_smartobject_obj  = ryc_smartobject.smartobject_obj
                ryc_smartlink.SOURCE_object_instance_obj = dSourceObjectInstanceObj
                ryc_smartlink.smartlink_type_obj         = dSmartlinkTypeObj
                ryc_smartlink.link_name                  = cLinkName
                ryc_smartlink.TARGET_object_instance_obj = dTargetObjectInstanceObj.
            VALIDATE ryc_smartlink.
            FIND CURRENT ryc_smartlink NO-LOCK.
        END.

        {af/sup2/afcheckerr.i &NO-RETURN=YES &DISPLAY-ERROR=YES}

        BROWSE brLink:REFRESH() NO-ERROR.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brObjectInstance
&Scoped-define FRAME-NAME fr1
&Scoped-define SELF-NAME brObjectInstance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brObjectInstance C-Win
ON F5 OF brObjectInstance IN FRAME fr1
DO:
    RUN open-query-object-instance.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brObjectInstance C-Win
ON ITERATION-CHANGED OF brObjectInstance IN FRAME fr1
DO:

    RUN open-query-page.

    RUN open-query-link.

    RUN open-query-attributevalue2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brObjectInstance C-Win
ON MOUSE-SELECT-DBLCLICK OF brObjectInstance IN FRAME fr1
DO:
    DEFINE VARIABLE lProceed AS LOGICAL.
    DO TRANSACTION ON ERROR UNDO, LEAVE:
        FIND CURRENT ryc_object_instance EXCLUSIVE-LOCK.
        RUN ry/uib/rycsoseled.w (
            INPUT-OUTPUT ryc_object_instance.smartobject_obj,
            OUTPUT lProceed).
        IF NOT lProceed THEN UNDO, LEAVE.
        FIND CURRENT ryc_object_instance NO-LOCK.
    END.

    {af/sup2/afcheckerr.i &NO-RETURN=YES &DISPLAY-ERROR=YES}

    brObjectInstance:REFRESH() NO-ERROR.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brObjectInstance2
&Scoped-define FRAME-NAME fr4
&Scoped-define SELF-NAME brObjectInstance2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brObjectInstance2 C-Win
ON F5 OF brObjectInstance2 IN FRAME fr4
DO:
  RUN open-query-objectinstance2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brObjectType
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME brObjectType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brObjectType C-Win
ON F5 OF brObjectType IN FRAME DEFAULT-FRAME
DO:
  RUN open-query-objecttype.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brObjectType C-Win
ON ITERATION-CHANGED OF brObjectType IN FRAME DEFAULT-FRAME
DO:
    RUN open-query-smartobject.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brPage
&Scoped-define FRAME-NAME fr5
&Scoped-define SELF-NAME brPage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPage C-Win
ON F5 OF brPage IN FRAME fr5
DO:
  RUN open-query-page.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPage C-Win
ON ITERATION-CHANGED OF brPage IN FRAME fr5
DO:
    IF AVAILABLE ryc_page THEN ASSIGN  buSetPage:LABEL IN FRAME fr1 = "Set Page " + STRING(ryc_page.PAGE_sequence) .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPage C-Win
ON MOUSE-SELECT-DBLCLICK OF brPage IN FRAME fr5
DO:
      DEFINE VARIABLE lProceed AS LOGICAL.
    DO TRANSACTION ON ERROR UNDO, LEAVE:
        FIND CURRENT ryc_page EXCLUSIVE-LOCK.
        RUN ry/uib/rycpaeditd.w (INPUT-OUTPUT ryc_page.PAGE_sequence, INPUT-OUTPUT ryc_page.PAGE_label, INPUT-OUTPUT ryc_page.layout_obj, OUTPUT lProceed).
        IF NOT lProceed THEN UNDO, LEAVE.
        FIND CURRENT ryc_page NO-LOCK.
    END.

    {af/sup2/afcheckerr.i &NO-RETURN=YES &DISPLAY-ERROR=YES}

    brPage:REFRESH() NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSmartObject
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME brSmartObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSmartObject C-Win
ON F5 OF brSmartObject IN FRAME DEFAULT-FRAME
DO:
  RUN open-query-smartobject.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSmartObject C-Win
ON ITERATION-CHANGED OF brSmartObject IN FRAME DEFAULT-FRAME
DO:      

    RUN open-query-object-instance.
    RUN open-query-objectinstance2.
    RUN open-query-attributevalue.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSmartObject C-Win
ON MOUSE-SELECT-DBLCLICK OF brSmartObject IN FRAME DEFAULT-FRAME
DO:
    DEFINE VARIABLE dLayoutObj AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dObjectTypeObj AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dProductModuleObj AS DECIMAL NO-UNDO.
    DEFINE VARIABLE cObjectFilename AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCustomSuperProcedure AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lStaticObject AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lSystemOwned AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lTemplateSmartobject AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lLogicalObject AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cPhysicalObjectName AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cObjectPath AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dPhysicalObjectObj AS DECIMAL NO-UNDO.
    DEFINE VARIABLE lProceed AS LOGICAL.
    DEFINE VARIABLE cObjectDescription AS CHARACTER NO-UNDO.

    DEFINE BUFFER lb_gsc_object FOR gsc_object.

    FIND FIRST gsc_object NO-LOCK 
        WHERE gsc_object.OBJECT_filename = ryc_smartobject.OBJECT_filename.
    IF gsc_object.LOGICAL_object THEN
    DO:
        lLogicalObject = TRUE.
        FIND FIRST lb_gsc_object NO-LOCK
            WHERE lb_gsc_object.OBJECT_obj = gsc_object.physical_object_obj.
        cPhysicalObjectName = lb_gsc_object.OBJECT_filename.
    END.
    ELSE cObjectPath = gsc_object.OBJECT_path.

    cObjectDescription = gsc_object.OBJECT_description.                                             

    ASSIGN
        dLayoutObj              = ryc_smartobject.Layout_Obj
        dObjectTypeObj          = ryc_smartobject.Object_Type_Obj
        dProductModuleObj       = ryc_smartobject.Product_Module_Obj
        cObjectFilename         = ryc_smartobject.Object_Filename
        cCustomSuperProcedure   = ryc_smartobject.Custom_Super_Procedure
        lStaticObject           = ryc_smartobject.Static_Object
        lSystemOwned            = ryc_smartobject.System_Owned
        lTemplateSmartObject    = ryc_smartobject.Template_smartobject.

    RUN ry/uib/rycsoeditd.w (
            INPUT-OUTPUT dLayoutObj,
            INPUT-OUTPUT dObjectTypeObj,
            INPUT-OUTPUT dProductModuleObj,
            INPUT-OUTPUT cObjectFilename,
            INPUT-OUTPUT cCustomSuperProcedure,
            INPUT-OUTPUT lStaticObject,
            INPUT-OUTPUT lSystemOwned,
            INPUT-OUTPUT lTemplateSmartObject,
            INPUT-OUTPUT lLogicalObject,
            INPUT-OUTPUT cPhysicalObjectName,
            INPUT-OUTPUT cObjectPath,
            INPUT-OUTPUT cObjectDescription,
            OUTPUT lProceed).

    ERROR-STATUS:ERROR = NO.

    IF lProceed THEN
    DO TRANSACTION ON ERROR UNDO, LEAVE:

        IF lLogicalObject THEN
        DO:
            FIND lb_gsc_object NO-LOCK
                WHERE lb_gsc_object.OBJECT_filename = cPhysicalObjectName.
            IF NOT AVAILABLE lb_gsc_object THEN 
            DO:
                MESSAGE "No gsc_object record is available for the physical object " cPhysicalObjectName.
                RETURN.
            END.
            dPhysicalObjectObj = lb_gsc_object.OBJECT_obj.
            cObjectPath = "".
        END.
        ELSE dPhysicalObjectObj = 0.

        FIND gsc_object EXCLUSIVE-LOCK
            WHERE gsc_object.OBJECT_filename = cObjectFilename NO-ERROR.

        IF NOT AVAILABLE gsc_object THEN
        DO:
            CREATE gsc_object.
            ASSIGN
                gsc_object.object_filename          = cObjectFilename
                gsc_object.RUN_when                 = "ANY".

        END.

        ASSIGN
            gsc_object.logical_object           = lLogicalObject
            gsc_object.object_description       = cObjectDescription
            gsc_object.object_path              = cObjectPath
            gsc_object.object_type_obj          = dObjectTypeObj
            gsc_object.physical_object_obj      = dPhysicalObjectObj
            gsc_object.product_module_obj       = dProductModuleObj
            .


        FIND CURRENT ryc_smartobject EXCLUSIVE-LOCK.
        ASSIGN
            ryc_smartobject.OBJECT_obj                = gsc_object.OBJECT_obj
            ryc_smartobject.Layout_Obj                = dLayoutObj
            ryc_smartobject.Object_Type_Obj           = dObjectTypeObj
            ryc_smartobject.Product_Module_Obj        = dProductModuleObj
            ryc_smartobject.Object_Filename           = cObjectFilename
            ryc_smartobject.Custom_Super_Procedure    = cCustomSuperProcedure
            ryc_smartobject.Static_Object             = lStaticObject
            ryc_smartobject.System_Owned              = lSystemOwned
            ryc_smartobject.Template_smartobject      = lTemplateSmartObject.

        FIND CURRENT gsc_object NO-LOCK.
        FIND CURRENT ryc_smartobject NO-LOCK.       
    END.

    {af/sup2/afcheckerr.i &NO-RETURN=YES &DISPLAY-ERROR=YES}

    brSmartObject:REFRESH() NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fr1
&Scoped-define SELF-NAME buAddInstance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAddInstance C-Win
ON CHOOSE OF buAddInstance IN FRAME fr1 /* Add */
DO:
    DEFINE VARIABLE lProceed AS LOGICAL.
    DEFINE VARIABLE dSmartObjectObj AS DECIMAL.

    RUN ry/uib/rycsoseled.w (
        INPUT-OUTPUT dSmartObjectObj,
        OUTPUT lProceed).        

    IF lProceed THEN
    DO:

txn-blk:
        DO TRANSACTION ON ERROR UNDO txn-blk, LEAVE txn-blk:
            CREATE ryc_object_instance.        
            ASSIGN 
                ryc_object_instance.smartobject_obj             = dSmartObjectObj
                ryc_object_instance.container_smartobject_obj   = ryc_smartobject.smartobject_obj.
            VALIDATE ryc_object_instance.


            DEFINE BUFFER new_attribute_value FOR ryc_attribute_value.


            /* copy attribute values from the smartobject */

            FOR EACH ryc_attribute_value NO-LOCK
                WHERE ryc_attribute_value.smartobject_obj           = ryc_object_instance.smartobject_obj
                AND   ryc_attribute_value.OBJECT_instance_obj       = 0
                AND   ryc_attribute_value.container_smartobject_obj = 0:

                CREATE new_attribute_value.
                ASSIGN new_attribute_value.object_instance_obj = ryc_object_instance.object_instance_obj
                       new_attribute_value.container_smartobject_obj = ryc_object_instance.container_smartobject_obj
                       NEW_attribute_value.collect_attribute_value_obj = NEW_attribute_value.attribute_value_obj
                       NEW_attribute_value.inheritted_value = TRUE.

                BUFFER-COPY ryc_attribute_value EXCEPT inheritted_value attribute_value_obj object_instance_obj container_smartobject_obj collect_attribute_value_obj TO new_attribute_value.
            END.

        END.

        {af/sup2/afcheckerr.i &NO-RETURN=YES &DISPLAY-ERROR=YES}

        RUN open-query-object-instance.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fr5
&Scoped-define SELF-NAME buAddLink
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAddLink C-Win
ON CHOOSE OF buAddLink IN FRAME fr5 /* Add */
DO:
    DEFINE VARIABLE dContainerSmartobjectObj    AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dSourceObjectInstanceObj    AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dSmartlinkTypeObj           AS DECIMAL NO-UNDO.
    DEFINE VARIABLE cLinkName                   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dTargetObjectInstanceObj    AS DECIMAL.
    DEFINE VARIABLE lProceed                    AS LOGICAL.
    DEFINE BUFFER new_smartlink FOR ryc_smartlink.

    dContainerSmartobjectObj = ryc_smartobject.smartobject_obj.

    RUN ry/uib/rycsleditd.w (
        INPUT        dContainerSmartObjectObj, 
        INPUT-OUTPUT dSourceObjectInstanceObj,
        INPUT-OUTPUT dSmartlinkTypeObj,
        INPUT-OUTPUT cLinkName,
        INPUT-OUTPUT dTargetObjectInstanceObj,
        OUTPUT lProceed).

    IF lProceed THEN
    DO TRANSACTION ON ERROR UNDO, LEAVE:
        CREATE new_smartlink.
        ASSIGN
            new_smartlink.container_smartobject_obj = ryc_smartobject.smartobject_obj
            new_smartlink.SOURCE_object_instance_obj = dSourceObjectInstanceObj
            new_smartlink.smartlink_type_obj = dSmartlinkTypeObj
            new_smartlink.link_name = cLinkName
            new_smartlink.TARGET_object_instance_obj = dTargetObjectInstanceObj.
        VALIDATE new_smartlink.
    END.

    {af/sup2/afcheckerr.i &NO-RETURN=YES &DISPLAY-ERROR=YES}

    RUN open-query-link.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME buAddObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAddObject C-Win
ON CHOOSE OF buAddObject IN FRAME DEFAULT-FRAME /* Add */
DO:
    DEFINE VARIABLE dLayoutObj AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dObjectTypeObj AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dProductModuleObj AS DECIMAL NO-UNDO.
    DEFINE VARIABLE cObjectFilename AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCustomSuperProcedure AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lStaticObject AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lSystemOwned AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lTemplateSmartobject AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lLogicalObject AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cPhysicalObjectName AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cObjectPath AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dPhysicalObjectObj AS DECIMAL NO-UNDO.
    DEFINE VARIABLE lProceed AS LOGICAL.
    DEFINE VARIABLE cObjectDescription AS CHARACTER NO-UNDO.

    DEFINE BUFFER lb_gsc_object FOR gsc_object.

    ASSIGN
        dLayoutObj              = 0
        dObjectTypeObj          = gsc_object_type.OBJECT_type_obj
        dProductModuleObj       = 0
        cObjectFilename         = ""
        cCustomSuperProcedure   = ""
        lStaticObject           = FALSE
        lSystemOwned            = FALSE
        lTemplateSmartObject    = FALSE
        lLogicalObject          = TRUE
        cPhysicalObjectName     = ""
        cObjectPath             = ""
        cObjectDescription      = "".

    RUN ry/uib/rycsoeditd.w (
            INPUT-OUTPUT dLayoutObj,
            INPUT-OUTPUT dObjectTypeObj,
            INPUT-OUTPUT dProductModuleObj,
            INPUT-OUTPUT cObjectFilename,
            INPUT-OUTPUT cCustomSuperProcedure,
            INPUT-OUTPUT lStaticObject,
            INPUT-OUTPUT lSystemOwned,
            INPUT-OUTPUT lTemplateSmartObject,
            INPUT-OUTPUT lLogicalObject,
            INPUT-OUTPUT cPhysicalObjectName,
            INPUT-OUTPUT cObjectPath,
            INPUT-OUTPUT cObjectDescription,
            OUTPUT lProceed).

    IF lProceed THEN
    DO TRANSACTION ON ERROR UNDO, LEAVE:

        IF lLogicalObject THEN
        DO:
            FIND lb_gsc_object NO-LOCK
                WHERE lb_gsc_object.OBJECT_filename = cPhysicalObjectName.
            IF NOT AVAILABLE lb_gsc_object THEN 
            DO:
                MESSAGE "No gsc_object record is available for the physical object " cPhysicalObjectName.
                RETURN.
            END.
            dPhysicalObjectObj = lb_gsc_object.OBJECT_obj.
            cObjectPath = "".
        END.
        ELSE dPhysicalObjectObj = 0.

        FIND gsc_object EXCLUSIVE-LOCK
            WHERE gsc_object.OBJECT_filename = cObjectFilename NO-ERROR.

        IF NOT AVAILABLE gsc_object THEN
        DO:
            CREATE gsc_object.
            ASSIGN
                gsc_object.object_filename          = cObjectFilename
                gsc_object.RUN_when                 = "ANY".
        END.

        ASSIGN
            gsc_object.logical_object           = lLogicalObject
            gsc_object.object_description       = cObjectDescription
            gsc_object.object_path              = cObjectPath
            gsc_object.object_type_obj          = dObjectTypeObj
            gsc_object.physical_object_obj      = dPhysicalObjectObj
            gsc_object.product_module_obj       = dProductModuleObj
            .


        CREATE ryc_smartobject.
        ASSIGN
            ryc_smartobject.OBJECT_obj                = gsc_object.OBJECT_obj
            ryc_smartobject.Layout_Obj                = dLayoutObj
            ryc_smartobject.Object_Type_Obj           = dObjectTypeObj
            ryc_smartobject.Product_Module_Obj        = dProductModuleObj
            ryc_smartobject.Object_Filename           = cObjectFilename
            ryc_smartobject.Custom_Super_Procedure    = cCustomSuperProcedure
            ryc_smartobject.Static_Object             = lStaticObject
            ryc_smartobject.System_Owned              = lSystemOwned
            ryc_smartobject.Template_smartobject      = lTemplateSmartObject.

        VALIDATE ryc_smartobject.                               

        FIND CURRENT gsc_object NO-LOCK.
        FIND CURRENT ryc_smartobject NO-LOCK.       
    END.

    {af/sup2/afcheckerr.i &NO-RETURN=YES &DISPLAY-ERROR=YES}

    RUN open-query-smartobject.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fr5
&Scoped-define SELF-NAME buAddPage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAddPage C-Win
ON CHOOSE OF buAddPage IN FRAME fr5 /* Add */
DO:
    DEFINE VARIABLE iPageSequence   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cPageLabel      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lProceed        AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE dLayoutObj      AS DECIMAL   NO-UNDO.

    RUN ry/uib/rycpaeditd.w (
        INPUT-OUTPUT iPageSequence,
        INPUT-OUTPUT cPageLabel, 
        INPUT-OUTPUT dLayoutObj,
        OUTPUT lProceed).

    IF lProceed THEN 
    DO TRANSACTION ON ERROR UNDO, LEAVE:
        CREATE ryc_page.
        ASSIGN
            ryc_page.container_smartobject_obj  = ryc_smartobject.smartobject_obj
            ryc_page.enable_on_create           = TRUE
            ryc_page.enable_on_modify           = TRUE
            ryc_page.enable_on_view             = TRUE
            ryc_page.layout_obj                 = dLayoutObj
            ryc_page.page_label                 = cPageLabel
            ryc_page.page_sequence              = iPageSequence
            .
    END.

    {af/sup2/afcheckerr.i &NO-RETURN=YES &DISPLAY-ERROR=YES}

    RUN open-query-page.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME buClearCache
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buClearCache C-Win
ON CHOOSE OF buClearCache IN FRAME DEFAULT-FRAME /* Clear Cache */
DO:
    RUN clearClientCache IN gshRepositoryManager.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fr1
&Scoped-define SELF-NAME BuDeleteInstance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BuDeleteInstance C-Win
ON CHOOSE OF BuDeleteInstance IN FRAME fr1 /* Delete */
DO:
    DEFINE VARIABLE lDelete     AS LOGICAL      NO-UNDO.

    RUN delQuestion (INPUT  "Are you sure you want to delete this instance",
                     OUTPUT lDelete).

    ERROR-STATUS:ERROR = NO.

    IF lDelete THEN DO:
        DO TRANSACTION ON ERROR UNDO, LEAVE:

            IF ERROR-STATUS:ERROR THEN LEAVE.

            FIND CURRENT ryc_object_instance EXCLUSIVE-LOCK.
            DELETE ryc_object_instance.
        END.


        {af/sup2/afcheckerr.i &DISPLAY-ERROR=YES &NO-RETURN=YES }

        DO WITH FRAME fr1:
/*             IF cMessageList = "":U THEN              */
/*               brObjectInstance:DELETE-CURRENT-ROW(). */
            brObjectInstance:REFRESH() NO-ERROR.
        END.
        DO WITH FRAME fr5:
            brLink:REFRESH() NO-ERROR.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fr5
&Scoped-define SELF-NAME buDeleteLink
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeleteLink C-Win
ON CHOOSE OF buDeleteLink IN FRAME fr5 /* Delete */
DO:
    DEFINE VARIABLE lDelete     AS LOGICAL      NO-UNDO.

    RUN delQuestion (INPUT  "Are you sure you want to delete this link",
                     OUTPUT lDelete).

    IF lDelete THEN DO:
        DO TRANSACTION ON ERROR UNDO, LEAVE:
            FIND CURRENT ryc_smartlink EXCLUSIVE-LOCK.        
            DELETE ryc_smartlink.
        END.

        ASSIGN cMessageList = "":U.

        {af/sup2/afcheckerr.i &NO-RETURN=YES &DISPLAY-ERROR=YES}

        IF cMessageList = "":U THEN
          brLink:DELETE-CURRENT-ROW() NO-ERROR.

        brLink:REFRESH() NO-ERROR.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeletePage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeletePage C-Win
ON CHOOSE OF buDeletePage IN FRAME fr5 /* Delete */
DO:
    DEFINE VARIABLE lDelete     AS LOGICAL      NO-UNDO.

    RUN delQuestion (INPUT  "Are you sure you want to delete this page",
                     OUTPUT lDelete).

    IF lDelete THEN DO:
        DO TRANSACTION ON ERROR UNDO, LEAVE:
            FIND CURRENT ryc_page EXCLUSIVE-LOCK.        
            DELETE ryc_page.
        END.

        {af/sup2/afcheckerr.i &NO-RETURN=YES &DISPLAY-ERROR=YES}

        IF cMessageList = "":U THEN
          brPage:DELETE-CURRENT-ROW() NO-ERROR.
        brPage:REFRESH() NO-ERROR.     
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME buFields
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buFields C-Win
ON CHOOSE OF buFields IN FRAME DEFAULT-FRAME /* Fields */
DO:
/*     IF AVAILABLE (gsc_object_type) AND gsc_object_type.OBJECT_type_description = "Dynamic SmartDataViewer" */
    IF AVAILABLE (gsc_object_type) AND AVAILABLE (ryc_smartobject) THEN    
    DO:                             
        IF NOT VALID-HANDLE(hLauncher) THEN
        DO: 
            RUN ry/uib/rycsolnchw.w PERSISTENT SET hLauncher.
            RUN initializeObject IN hLauncher.
        END.

        DEFINE VARIABL hObject AS HANDLE NO-UNDO.

        RUN constructObject IN hLauncher (
         INPUT  'ry/uib/rycsofeldw.w':U,
         INPUT  {&WINDOW-NAME} ,
         INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U,
         OUTPUT hObject ).
        RUN initializeObject IN hObject.
        RUN setSmartobjectObj IN hObject(INPUT ryc_smartobject.smartobject_obj).


    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buModifyObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buModifyObject C-Win
ON CHOOSE OF buModifyObject IN FRAME DEFAULT-FRAME /* Modify */
DO:
    DEFINE VARIABLE dLayoutObj AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dObjectTypeObj AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dProductModuleObj AS DECIMAL NO-UNDO.
    DEFINE VARIABLE cObjectFilename AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCustomSuperProcedure AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lStaticObject AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lSystemOwned AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lTemplateSmartobject AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lLogicalObject AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cPhysicalObjectName AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cObjectPath AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dPhysicalObjectObj AS DECIMAL NO-UNDO.
    DEFINE VARIABLE lProceed AS LOGICAL.
    DEFINE VARIABLE cObjectDescription AS CHARACTER NO-UNDO.

    DEFINE BUFFER lb_gsc_object FOR gsc_object.

    FIND FIRST gsc_object NO-LOCK 
        WHERE gsc_object.OBJECT_filename = ryc_smartobject.OBJECT_filename.
    IF gsc_object.LOGICAL_object THEN
    DO:
        lLogicalObject = TRUE.
        FIND FIRST lb_gsc_object NO-LOCK
            WHERE lb_gsc_object.OBJECT_obj = gsc_object.physical_object_obj.
        cPhysicalObjectName = lb_gsc_object.OBJECT_filename.
    END.
    ELSE cObjectPath = gsc_object.OBJECT_path.

    cObjectDescription = gsc_object.OBJECT_description.                                             

    ASSIGN
        dLayoutObj              = ryc_smartobject.Layout_Obj
        dObjectTypeObj          = ryc_smartobject.Object_Type_Obj
        dProductModuleObj       = ryc_smartobject.Product_Module_Obj
        cObjectFilename         = ryc_smartobject.Object_Filename
        cCustomSuperProcedure   = ryc_smartobject.Custom_Super_Procedure
        lStaticObject           = ryc_smartobject.Static_Object
        lSystemOwned            = ryc_smartobject.System_Owned
        lTemplateSmartObject    = ryc_smartobject.Template_smartobject.

    RUN ry/uib/rycsoeditd.w (
            INPUT-OUTPUT dLayoutObj,
            INPUT-OUTPUT dObjectTypeObj,
            INPUT-OUTPUT dProductModuleObj,
            INPUT-OUTPUT cObjectFilename,
            INPUT-OUTPUT cCustomSuperProcedure,
            INPUT-OUTPUT lStaticObject,
            INPUT-OUTPUT lSystemOwned,
            INPUT-OUTPUT lTemplateSmartObject,
            INPUT-OUTPUT lLogicalObject,
            INPUT-OUTPUT cPhysicalObjectName,
            INPUT-OUTPUT cObjectPath,
            INPUT-OUTPUT cObjectDescription,
            OUTPUT lProceed).

    ERROR-STATUS:ERROR = NO.

    IF lProceed THEN
    DO TRANSACTION ON ERROR UNDO, LEAVE:

        IF lLogicalObject THEN
        DO:
            FIND lb_gsc_object NO-LOCK
                WHERE lb_gsc_object.OBJECT_filename = cPhysicalObjectName.
            IF NOT AVAILABLE lb_gsc_object THEN 
            DO:
                MESSAGE "No gsc_object record is available for the physical object " cPhysicalObjectName.
                RETURN.
            END.
            dPhysicalObjectObj = lb_gsc_object.OBJECT_obj.
            cObjectPath = "".
        END.
        ELSE dPhysicalObjectObj = 0.

        FIND gsc_object EXCLUSIVE-LOCK
            WHERE gsc_object.OBJECT_filename = cObjectFilename NO-ERROR.

        IF NOT AVAILABLE gsc_object THEN
        DO:
            CREATE gsc_object.
            ASSIGN
                gsc_object.object_filename          = cObjectFilename
                gsc_object.RUN_when                 = "ANY".

        END.

        ASSIGN
            gsc_object.logical_object           = lLogicalObject
            gsc_object.object_description       = cObjectDescription
            gsc_object.object_path              = cObjectPath
            gsc_object.object_type_obj          = dObjectTypeObj
            gsc_object.physical_object_obj      = dPhysicalObjectObj
            gsc_object.product_module_obj       = dProductModuleObj
            .


        FIND CURRENT ryc_smartobject EXCLUSIVE-LOCK.
        ASSIGN
            ryc_smartobject.OBJECT_obj                = gsc_object.OBJECT_obj
            ryc_smartobject.Layout_Obj                = dLayoutObj
            ryc_smartobject.Object_Type_Obj           = dObjectTypeObj
            ryc_smartobject.Product_Module_Obj        = dProductModuleObj
            ryc_smartobject.Object_Filename           = cObjectFilename
            ryc_smartobject.Custom_Super_Procedure    = cCustomSuperProcedure
            ryc_smartobject.Static_Object             = lStaticObject
            ryc_smartobject.System_Owned              = lSystemOwned
            ryc_smartobject.Template_smartobject      = lTemplateSmartObject.

        FIND CURRENT gsc_object NO-LOCK.
        FIND CURRENT ryc_smartobject NO-LOCK.       
    END.

    {af/sup2/afcheckerr.i &NO-RETURN=YES &DISPLAY-ERROR=YES}

    brSmartObject:REFRESH() NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRun C-Win
ON CHOOSE OF buRun IN FRAME DEFAULT-FRAME /* Run */
DO:
    IF NOT VALID-HANDLE(hLauncher) THEN
    DO: 
        RUN ry/uib/rycsolnchw.w PERSISTENT SET hLauncher.
        RUN initializeObject IN hLauncher.
    END.

    RUN runContainer IN hLauncher (INPUT ryc_smartobject.object_filename).

/*     RUN launchContainer IN hLauncher(                                                                                      */
/*         INPUT 'ry/uib/rydyncontw.w':U,                                                                                     */
/*         INPUT 'LogicalObjectName' + ryc_smartobject.object_filename + 'HideOnInitnoDisableOnInitnoObjectLayout':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fr2
&Scoped-define SELF-NAME buSet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSet C-Win
ON CHOOSE OF buSet IN FRAME fr2 /* Set */
DO:
    ASSIGN FRAME {&FRAME-NAME} fiValue.

    RELEASE ryc_attribute_value.
    IF brAttributeValue:NUM-SELECTED-ROWS > 0 THEN brAttributeValue:FETCH-SELECTED-ROW(1).

    IF AVAILABLE ryc_attribute_value THEN
    DO TRANSACTION ON ERROR UNDO, LEAVE.
        FIND CURRENT ryc_attribute_value EXCLUSIVE-LOCK.
        ASSIGN
            ryc_attribute_value.attribute_value = fiValue
            ryc_attribute_value.inheritted_value = FALSE.
        FIND CURRENT ryc_attribute_value NO-LOCK.
    END.

    {af/sup2/afcheckerr.i &NO-RETURN=YES &DISPLAY-ERROR=YES}
    BROWSE brAttributeValue:REFRESH() NO-ERROR.
    BROWSE brObjectInstance:REFRESH() NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fr3
&Scoped-define SELF-NAME buSet2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSet2 C-Win
ON CHOOSE OF buSet2 IN FRAME fr3 /* Set */
DO:
    ASSIGN FRAME {&FRAME-NAME} fiValue.

    RELEASE ryc_attribute_value.
    IF brAttributeValue2:NUM-SELECTED-ROWS > 0 THEN brAttributeValue2:FETCH-SELECTED-ROW(1).

    IF AVAILABLE ryc_attribute_value THEN
    DO TRANSACTION ON ERROR UNDO, LEAVE.
        FIND CURRENT ryc_attribute_value EXCLUSIVE-LOCK.
        ASSIGN
            ryc_attribute_value.attribute_value = fiValue
            ryc_attribute_value.inheritted_value = FALSE.
        FIND CURRENT ryc_attribute_value NO-LOCK.
    END.

    {af/sup2/afcheckerr.i &NO-RETURN=YES &DISPLAY-ERROR=YES}
    BROWSE brAttributeValue2:REFRESH() NO-ERROR.
    BROWSE brObjectInstance:REFRESH() NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fr1
&Scoped-define SELF-NAME buSetPage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSetPage C-Win
ON CHOOSE OF buSetPage IN FRAME fr1 /* Set Page */
DO:

    DEFINE VARIABLE iSequence AS INTEGER NO-UNDO.

    DO TRANSACTION ON ERROR UNDO, LEAVE:
       /* delete any pageobject records for this objectinstance */

        FOR EACH ryc_page_object EXCLUSIVE-LOCK
            WHERE ryc_page_object.OBJECT_instance_obj = ryc_object_instance.OBJECT_instance_obj:

            DELETE ryc_page_object.
        END.

        SELECT MAX(page_object_sequence) 
            INTO iSequence
            FROM ryc_page_object 
            WHERE ryc_page_object.OBJECT_instance_obj = ryc_object_instance.OBJECT_instance_obj
            AND   ryc_page_object.PAGE_obj = ryc_page.PAGE_obj
            AND   ryc_page_object.container_smartobject_obj = ryc_object_instance.container_smartobject_obj.

        /* create the new pageobject record */

        CREATE ryc_page_object.
        ASSIGN 
            ryc_page_object.OBJECT_instance_obj = ryc_object_instance.OBJECT_instance_obj
            ryc_page_object.PAGE_obj = ryc_page.PAGE_obj
            ryc_page_object.container_smartobject_obj = ryc_object_instance.container_smartobject_obj
            ryc_page_object.PAGE_object_sequence = iSequence.

    END.

    {af/sup2/afcheckerr.i &NO-RETURN=YES &DISPLAY-ERROR=YES}

    RUN open-query-object-instance.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSetPagex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSetPagex C-Win
ON CHOOSE OF buSetPagex IN FRAME fr1 /* Set Page ? */
DO:
    /* delete any pageobject records for this objectinstance */

    DO TRANSACTION ON ERROR UNDO, LEAVE:
        FOR EACH ryc_page_object EXCLUSIVE-LOCK
            WHERE ryc_page_object.OBJECT_instance_obj = ryc_object_instance.OBJECT_instance_obj:

            DELETE ryc_page_object.
        END.
    END.

    {af/sup2/afcheckerr.i &NO-RETURN=YES &DISPLAY-ERROR=YES}

    brObjectInstance:REFRESH() NO-ERROR.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME rsView
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsView C-Win
ON VALUE-CHANGED OF rsView IN FRAME DEFAULT-FRAME
DO:
    ASSIGN {&SELF-NAME}.

    FRAME fr1:HIDDEN = {&SELF-NAME} <> "3" AND {&SELF-NAME} <> "2".
    FRAME fr2:HIDDEN = {&SELF-NAME} <> "1".
    FRAME fr3:HIDDEN = {&SELF-NAME} <> "2".
    FRAME fr4:HIDDEN = {&SELF-NAME} <> "4".

    IF {&SELF-NAME} = "3" THEN FRAME fr1:TITLE = "Contained Instances, Pages & Links".
    IF {&SELF-NAME} = "2" THEN FRAME fr1:TITLE = "Attributes of Contained Instances".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tbStaticDynamicOnly
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tbStaticDynamicOnly C-Win
ON VALUE-CHANGED OF tbStaticDynamicOnly IN FRAME DEFAULT-FRAME /* Static/Dynamic Types Only */
DO:
    ASSIGN {&SELF-NAME}.
    RUN open-query-objecttype.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brAttributeValue
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
    ASSIGN
        brAttributeValue:COLUMN-RESIZABLE IN FRAME fr2 = TRUE
        brAttributeValue2:COLUMN-RESIZABLE IN FRAME fr3 = TRUE
        brLink:COLUMN-RESIZABLE IN FRAME fr5 = TRUE
        brObjectInstance:COLUMN-RESIZABLE IN FRAME fr1 = TRUE
        brObjectInstance2:COLUMN-RESIZABLE IN FRAME fr4 = TRUE
        brObjectType:COLUMN-RESIZABLE IN FRAME {&FRAME-NAME} = TRUE
        brPage:COLUMN-RESIZABLE IN FRAME fr5 = TRUE
        brSmartObject:COLUMN-RESIZABLE IN FRAME {&FRAME-NAME} = TRUE.

  RUN enable_UI.

  RUN open-query-objecttype.

  APPLY "VALUE-CHANGED":U TO rsView.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteObject C-Win 
PROCEDURE deleteObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE delQuestion C-Win 
PROCEDURE delQuestion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcQuestion  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER plButton    AS LOGICAL    NO-UNDO.

DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.

ASSIGN
    pcQuestion = IF pcQuestion = "":u OR pcQuestion = ? THEN "Are you sure you want to delete this record?" ELSE pcQuestion.

RUN askQuestion IN gshSessionManager (INPUT pcQuestion,     /* messages */
                                      INPUT "Yes,No":U,     /* button list */
                                      INPUT "Yes":U,        /* default */
                                      INPUT "No":U,         /* cancel */
                                      INPUT "Delete":U,     /* title */
                                      INPUT "":U,           /* datatype */
                                      INPUT "":U,           /* format */
                                      INPUT-OUTPUT cAnswer, /* answer */
                                          OUTPUT cButton            /* button pressed */
                                      ).

ASSIGN
    plButton = cButton BEGINS "Y".

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
  DISPLAY tbStaticDynamicOnly rsView 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbStaticDynamicOnly rsView brObjectType brSmartObject buAddObject 
         buModifyObject buFields buClearCache buRun 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  ENABLE brObjectInstance buAddInstance BuDeleteInstance buSetPage buSetPagex 
      WITH FRAME fr1 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fr1}
  DISPLAY fiValue 
      WITH FRAME fr2 IN WINDOW C-Win.
  ENABLE brAttributeValue buSet fiValue 
      WITH FRAME fr2 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fr2}
  ENABLE brObjectInstance2 
      WITH FRAME fr4 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fr4}
  DISPLAY fiValue 
      WITH FRAME fr3 IN WINDOW C-Win.
  ENABLE brAttributeValue2 buSet2 fiValue 
      WITH FRAME fr3 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fr3}
  ENABLE brLink buAddLink buDeleteLink brPage buAddPage buDeletePage 
      WITH FRAME fr5 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fr5}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE open-query-attributevalue C-Win 
PROCEDURE open-query-attributevalue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&OPEN-QUERY-brAttributeValue}
    APPLY "ITERATION-CHANGED":U TO brAttributeValue IN FRAME fr2.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE open-query-attributevalue2 C-Win 
PROCEDURE open-query-attributevalue2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {&OPEN-QUERY-brAttributeValue2}
    APPLY "ITERATION-CHANGED":U TO brAttributeValue2 IN FRAME fr3.
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
    APPLY "ITERATION-CHANGED":U TO brLink IN FRAME fr5.
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
    APPLY "ITERATION-CHANGED":U TO brObjectInstance IN FRAME fr1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE open-query-objectinstance2 C-Win 
PROCEDURE open-query-objectinstance2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {&OPEN-QUERY-brObjectInstance2}
    APPLY "ITERATION-CHANGED":U TO brObjectInstance2 IN FRAME fr4.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE open-query-objecttype C-Win 
PROCEDURE open-query-objecttype :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN FRAME {&FRAME-NAME} tbStaticDynamicOnly.

    {&OPEN-QUERY-brObjectType}
    APPLY "ITERATION-CHANGED":U TO brObjectType IN FRAME {&FRAME-NAME}.
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
    DEFINE VARIABLE hColumn     AS HANDLE       NO-UNDO.
    DEFINE VARIABLE iLoop       AS INTEGER      NO-UNDO.

    brPage:COLUMN-RESIZABLE IN FRAME fr5 = TRUE.

    {&OPEN-QUERY-brPage}
    APPLY "ITERATION-CHANGED":U TO brPage IN FRAME fr5.
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

