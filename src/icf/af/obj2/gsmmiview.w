&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"af/obj2/gsmmifullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
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
/*---------------------------------------------------------------------------------
  File: gsmmiview.w

  Description:  Item viewer

  Purpose:      Used in menu/toolbar maintenance to create items.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   22/08/2001  Author:     Don Bulua

  Update Notes: Created from Template rysttviewv.w

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gsmmiview.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE giRulePage AS INTEGER    NO-UNDO INIT 1.

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmmifullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.menu_item_reference ~
RowObject.menu_item_label RowObject.shortcut_key ~
RowObject.menu_item_description RowObject.item_control_type ~
RowObject.item_narration RowObject.under_development RowObject.system_owned ~
RowObject.disabled RowObject.hide_if_disabled RowObject.item_select_type ~
RowObject.item_select_action RowObject.item_select_parameter ~
RowObject.substitute_text_property RowObject.item_link ~
RowObject.item_toolbar_label RowObject.tooltip_text ~
RowObject.item_control_style RowObject.security_token ~
RowObject.on_create_publish_event RowObject.item_menu_drop ~
RowObject.enable_rule RowObject.hide_rule RowObject.image_alternate_rule 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS EdRuleHelp buKey buImage buImage2 RECT-2 ~
RECT-3 RECT-4 
&Scoped-Define DISPLAYED-FIELDS RowObject.menu_item_reference ~
RowObject.menu_item_label RowObject.shortcut_key ~
RowObject.menu_item_description RowObject.item_control_type ~
RowObject.item_narration RowObject.under_development RowObject.system_owned ~
RowObject.disabled RowObject.hide_if_disabled RowObject.item_select_type ~
RowObject.item_select_action RowObject.item_select_parameter ~
RowObject.substitute_text_property RowObject.item_link ~
RowObject.item_toolbar_label RowObject.tooltip_text ~
RowObject.item_control_style RowObject.security_token ~
RowObject.on_create_publish_event RowObject.image2_up_filename ~
RowObject.item_menu_drop RowObject.enable_rule RowObject.hide_rule ~
RowObject.image_alternate_rule RowObject.image2_down_filename ~
RowObject.image1_up_filename RowObject.image1_down_filename ~
RowObject.image2_insensitive_filename RowObject.image1_insensitive_filename ~
RowObject.menu_item_obj RowObject.product_module_obj 
&Scoped-Define DISPLAYED-OBJECTS fiProdMod 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setActionDisplay vTableWin 
FUNCTION setActionDisplay RETURNS LOGICAL
  ( pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setControlDisplay vTableWin 
FUNCTION setControlDisplay RETURNS LOGICAL
  ( pcControlType AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRuleDisplay vTableWin 
FUNCTION setRuleDisplay RETURNS LOGICAL
  ( piRule AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_afspfoldrw AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dyncombo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynlookup-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynlookup-4 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscicfullo AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buImage 
     LABEL "" 
     SIZE 5.2 BY 1.24
     BGCOLOR 8 .

DEFINE BUTTON buImage2 
     LABEL "" 
     SIZE 5.2 BY 1.24
     BGCOLOR 8 .

DEFINE BUTTON buKey 
     LABEL "Key" 
     SIZE 7 BY 1.05 TOOLTIP "Click to assign a shortcut Key"
     BGCOLOR 8 .

DEFINE VARIABLE EdRuleHelp AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 106 BY 2.76 NO-UNDO.

DEFINE VARIABLE fiAttr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE fiObject AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE fiProdMod AS CHARACTER FORMAT "X(256)":U 
     LABEL "Module" 
     VIEW-AS FILL-IN 
     SIZE 23 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 63 BY 5.57.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 109 BY 2.71.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45 BY 5.57.

DEFINE VARIABLE ToAutoGen AS LOGICAL INITIAL no 
     LABEL "Auto generate" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiProdMod AT ROW 3.48 COL 64 COLON-ALIGNED
     RowObject.menu_item_reference AT ROW 1 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25.6 BY 1
     ToAutoGen AT ROW 1.05 COL 47.6
     RowObject.menu_item_label AT ROW 2.29 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 34 BY 1
     EdRuleHelp AT ROW 16.76 COL 2 NO-LABEL NO-TAB-STOP 
     buKey AT ROW 2.29 COL 59
     RowObject.shortcut_key AT ROW 2.29 COL 64 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 23 BY 1 NO-TAB-STOP 
     RowObject.menu_item_description AT ROW 3.48 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 34 BY 1
     RowObject.item_control_type AT ROW 4.67 COL 9.6 FORMAT "X(15)"
          VIEW-AS COMBO-BOX SORT 
          LIST-ITEM-PAIRS "Action  (Button or Menu Item)","Action",
                     "Separator","Separator",
                     "Label","Label",
                     "Placeholder","Placeholder"
          DROP-DOWN-LIST
          SIZE 34 BY 1
     RowObject.item_narration AT ROW 4.67 COL 66 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 500 SCROLLBAR-VERTICAL
          SIZE 44 BY 1.67
     RowObject.under_development AT ROW 1.19 COL 91
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .81 TOOLTIP "Under development"
     RowObject.system_owned AT ROW 2.05 COL 91
          VIEW-AS TOGGLE-BOX
          SIZE 18.8 BY .81
     RowObject.disabled AT ROW 2.91 COL 91
          VIEW-AS TOGGLE-BOX
          SIZE 13.2 BY .81
     RowObject.hide_if_disabled AT ROW 3.76 COL 91
          VIEW-AS TOGGLE-BOX
          SIZE 19.4 BY .81
     RowObject.item_select_type AT ROW 6.86 COL 8.4
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "LAUNCH","PUBLISH","PROPERTY","RUN" 
          DROP-DOWN-LIST
          SIZE 21.2 BY 1
     RowObject.item_select_action AT ROW 8.05 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 42 BY 1
     RowObject.item_select_parameter AT ROW 9 COL 10.2
          VIEW-AS FILL-IN 
          SIZE 42 BY 1
     RowObject.substitute_text_property AT ROW 9.95 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 42 BY 1
     RowObject.item_link AT ROW 11 COL 11.2
          VIEW-AS FILL-IN 
          SIZE 42 BY 1
     RowObject.item_toolbar_label AT ROW 7.1 COL 72 COLON-ALIGNED
          LABEL "Label"
          VIEW-AS FILL-IN 
          SIZE 28 BY 1
     RowObject.tooltip_text AT ROW 8.14 COL 66.4
          VIEW-AS FILL-IN 
          SIZE 35 BY 1
     RowObject.item_control_style AT ROW 9.24 COL 68.2
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Icon only","Text only" 
          DROP-DOWN-LIST
          SIZE 19 BY 1
     buImage AT ROW 10.57 COL 78
     buImage2 AT ROW 10.57 COL 94
     RowObject.security_token AT ROW 14.05 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 23 BY 1
     RowObject.on_create_publish_event AT ROW 12.86 COL 72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 34.8 BY 1
     RowObject.image2_up_filename AT ROW 3.38 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY 1 NO-TAB-STOP 
     RowObject.item_menu_drop AT ROW 14.05 COL 53.4
          VIEW-AS FILL-IN 
          SIZE 35 BY 1
     RowObject.enable_rule AT ROW 16.76 COL 2 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-VERTICAL
          SIZE 106 BY 2.76
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME frMain
     RowObject.hide_rule AT ROW 16.76 COL 2 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-VERTICAL
          SIZE 106 BY 2.76
     RowObject.image_alternate_rule AT ROW 16.76 COL 2 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-VERTICAL
          SIZE 106 BY 2.76
     RowObject.image2_down_filename AT ROW 3.38 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY 1 NO-TAB-STOP 
     RowObject.image1_up_filename AT ROW 3.38 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY 1 NO-TAB-STOP 
     fiObject AT ROW 8.05 COL 41 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiAttr AT ROW 9 COL 41 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     RowObject.image1_down_filename AT ROW 3.38 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY 1 NO-TAB-STOP 
     RowObject.image2_insensitive_filename AT ROW 3.38 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY 1 NO-TAB-STOP 
     RowObject.image1_insensitive_filename AT ROW 3.38 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY 1 NO-TAB-STOP 
     RowObject.menu_item_obj AT ROW 3.38 COL 1 NO-LABEL
           VIEW-AS TEXT 
          SIZE 3 BY .62
     RowObject.product_module_obj AT ROW 3.86 COL 2 NO-LABEL
           VIEW-AS TEXT 
          SIZE 2 BY .62
     RECT-2 AT ROW 6.62 COL 1
     RECT-3 AT ROW 12.52 COL 1
     RECT-4 AT ROW 6.62 COL 65
     "Narration:" VIEW-AS TEXT
          SIZE 9.6 BY .62 AT ROW 4.81 COL 56.4
     "Image 2:" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 10.81 COL 85
     "Action" VIEW-AS TEXT
          SIZE 7 BY .62 AT ROW 6.38 COL 3
     "Other" VIEW-AS TEXT
          SIZE 6 BY .62 AT ROW 12.29 COL 3
     "Toolbar" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 6.38 COL 67
     "Image 1:" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 10.81 COL 69
     SPACE(33.00) SKIP(8.33)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gsmmifullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gsmmifullo.i}
      END-FIELDS.
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 19.29
         WIDTH              = 110.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR EDITOR EdRuleHelp IN FRAME frMain
   NO-DISPLAY                                                           */
ASSIGN 
       EdRuleHelp:HIDDEN IN FRAME frMain           = TRUE
       EdRuleHelp:RETURN-INSERTED IN FRAME frMain  = TRUE
       EdRuleHelp:READ-ONLY IN FRAME frMain        = TRUE.

ASSIGN 
       RowObject.enable_rule:RETURN-INSERTED IN FRAME frMain  = TRUE.

/* SETTINGS FOR FILL-IN fiAttr IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fiObject IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fiProdMod IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.hide_rule:RETURN-INSERTED IN FRAME frMain  = TRUE.

/* SETTINGS FOR FILL-IN RowObject.image1_down_filename IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       RowObject.image1_down_filename:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.image1_insensitive_filename IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       RowObject.image1_insensitive_filename:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.image1_up_filename IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       RowObject.image1_up_filename:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.image2_down_filename IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       RowObject.image2_down_filename:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.image2_insensitive_filename IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       RowObject.image2_insensitive_filename:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.image2_up_filename IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       RowObject.image2_up_filename:HIDDEN IN FRAME frMain           = TRUE.

ASSIGN 
       RowObject.image_alternate_rule:RETURN-INSERTED IN FRAME frMain  = TRUE.

/* SETTINGS FOR COMBO-BOX RowObject.item_control_style IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX RowObject.item_control_type IN FRAME frMain
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN RowObject.item_link IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN RowObject.item_menu_drop IN FRAME frMain
   ALIGN-L                                                              */
ASSIGN 
       RowObject.item_narration:RETURN-INSERTED IN FRAME frMain  = TRUE.

/* SETTINGS FOR FILL-IN RowObject.item_select_parameter IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX RowObject.item_select_type IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN RowObject.item_toolbar_label IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.menu_item_obj IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       RowObject.menu_item_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.menu_item_obj:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.product_module_obj IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       RowObject.product_module_obj:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.shortcut_key IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.shortcut_key:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR TOGGLE-BOX ToAutoGen IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       ToAutoGen:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.tooltip_text IN FRAME frMain
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buImage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buImage vTableWin
ON CHOOSE OF buImage IN FRAME frMain
DO:
  RUN getButtonImage (INPUT RowObject.image1_up_filename:HANDLE,
                      INPUT SELF).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buImage2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buImage2 vTableWin
ON CHOOSE OF buImage2 IN FRAME frMain
DO:
  RUN getButtonImage (INPUT RowObject.image2_up_filename:HANDLE,
                      INPUT SELF).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buKey
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buKey vTableWin
ON CHOOSE OF buKey IN FRAME frMain /* Key */
DO:
  DEFINE VARIABLE cOutput       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOutputBefore AS CHARACTER  NO-UNDO.
 
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN cOutput       = RowObject.shortcut_key:SCREEN-VALUE
           cOutputBefore = cOutput.
    RUN adecomm/_dlgrecm.p (RowObject.MENU_item_reference:SCREEN-VALUE,INPUT-OUTPUT cOutput).
    IF cOutput <> cOutputBefore THEN DO:
      ASSIGN RowObject.shortcut_key:SCREEN-VALUE = cOutput.
     {set DataModified YES}.
    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.item_control_style
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.item_control_style vTableWin
ON VALUE-CHANGED OF RowObject.item_control_style IN FRAME frMain /* Style */
DO:
  {set DataModified YES}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.item_control_type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.item_control_type vTableWin
ON VALUE-CHANGED OF RowObject.item_control_type IN FRAME frMain /* Item Type* */
DO:
  setControlDisplay(SELF:SCREEN-VALUE).
  {set DataModified YES}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.item_select_type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.item_select_type vTableWin
ON VALUE-CHANGED OF RowObject.item_select_type IN FRAME frMain /* Action Type */
DO:
  setActionDisplay(SELF:SCREEN-VALUE).
  {set DataModified YES}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.menu_item_label
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.menu_item_label vTableWin
ON LEAVE OF RowObject.menu_item_label IN FRAME frMain /* Menu Label* */
DO:
  IF SELF:MODIFIED AND rowObject.ITEM_toolbar_label:SCREEN-VALUE = "" THEN
     rowObject.ITEM_toolbar_label:SCREEN-VALUE = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.menu_item_reference
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.menu_item_reference vTableWin
ON LEAVE OF RowObject.menu_item_reference IN FRAME frMain /* Item Reference* */
DO:
  IF self:MODIFIED 
     AND RowObject.MENU_item_description:SCREEN-VALUE = "" THEN
    ASSIGN RowObject.MENU_item_description:SCREEN-VALUE = SELF:SCREEN-VALUE.
  
  IF self:MODIFIED 
     AND RowObject.MENU_item_label:SCREEN-VALUE = "" THEN
    ASSIGN RowObject.MENU_item_label:SCREEN-VALUE = SELF:SCREEN-VALUE.

  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToAutoGen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToAutoGen vTableWin
ON VALUE-CHANGED OF ToAutoGen IN FRAME frMain /* Auto generate */
DO:
  IF SELF:CHECKED THEN
    ASSIGN RowObject.MENU_item_reference:SCREEN-VALUE = "AutoGenerate":U
           RowObject.MENU_item_reference:SENSITIVE = FALSE.
  ELSE
    ASSIGN RowObject.MENU_item_reference:SENSITIVE    = TRUE
           RowObject.MENU_item_reference:SCREEN-VALUE = 
                 IF RowObject.MENU_item_reference:SCREEN-VALUE = "Autogenerate":U 
                 THEN ""
                 ELSE RowObject.MENU_item_reference:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hComboHandle   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cCols          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cControlType   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAction        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cKey           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDesc          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLink          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cComboValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboKey      AS CHARACTER  NO-UNDO.
 
  /* Code placed here will execute PRIOR to standard behavior. */
  
  ASSIGN hComboHandle = DYNAMIC-FUNCTION("getComboHandle":U IN h_dyncombo)
         cControlType = rowObject.ITEM_control_type:SCREEN-VALUE IN FRAME {&FRAME-NAME}
         cAction      = rowObject.ITEM_select_type:SCREEN-VALUE
         cComboValue  = hComboHandle:SCREEN-VALUE
         cComboKey   =  DYNAMIC-FUNC("getKeyFieldValue":U IN h_dyncombo)
         NO-ERROR.

  RUN SUPER.

  {get ContainerSource hSource}.
  DYNAMIC-FUNC("getCatgInfo":U IN hSource, OUTPUT cKey,  OUTPUT cLabel,
                                           OUTPUT cDesc, OUTPUT cLink).
  
/* Set the combo box to the value that is the same as it's parent*/
  IF cKey > "" THEN
  DO:
    DYNAMIC-FUNCTION("setKeyFieldValue":U IN h_dyncombo, ckey).
    List-Loop:
    DO i = 2 TO NUM-ENTRIES(hComboHandle:LIST-ITEM-PAIRS,hComboHandle:DELIMITER) BY 2:
        IF DECIMAL(ENTRY(i,hComboHandle:LIST-ITEM-PAIRS,hComboHandle:DELIMITER)) = DECIMAL(cKey) THEN
        DO:
           hComboHandle:SCREEN-VALUE = ENTRY(i,hComboHandle:LIST-ITEM-PAIRS,hComboHandle:DELIMITER).
           LEAVE List-Loop.
        END.
    END.
  END.
  ELSE DO:
    /* Reset the combo to the value it was previously before the add, if
       adding an item within a band */
    DYNAMIC-FUNCTION("setKeyFieldValue":U IN h_dyncombo, cCombokey).
    hComboHandle:SCREEN-VALUE = cComboValue.
  END.
  IF cControlType = "" OR cControlType = ? THEN
     cControlType = "Action":U.
  IF cControlType = "Action":U AND (cAction = "" OR cAction = ?) THEN
     cAction = "LAUNCH":U.
  ASSIGN rowObject.ITEM_control_type:SCREEN-VALUE = cControlType 
         rowObject.ITEM_select_type:SCREEN-VALUE  = cAction.
  
  setActionDisplay(rowObject.ITEM_select_type:SCREEN-VALUE).
  setControlDisplay(RowObject.Item_control_type:SCREEN-VALUE).

  ASSIGN toAutogen:HIDDEN IN FRAME {&FRAME-NAME}    = FALSE
         toAutogen:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE 
         rowObject.ITEM_link:SCREEN-VALUE = cLink
         NO-ERROR.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects vTableWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'af/obj2/gscicfullo.wDB-AWARE':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'AppServiceASUsePromptASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamegscicfulloUpdateFromSourceno':U ,
             OUTPUT h_gscicfullo ).
       RUN repositionObject IN h_gscicfullo ( 9.95 , 100.00 ) NO-ERROR.
       /* Size in AB:  ( 2.14 , 9.00 ) */

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object.object_filenameKeyFieldgsc_object.object_objFieldLabelObject FilenameFieldTooltipPress F4 for lookupKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object where container_object = true NO-LOCK,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = gsc_object.product_module_obj
                     BY gsc_object.object_filenameQueryTablesgsc_object,gsc_product_moduleBrowseFieldsgsc_object.object_filename,gsc_object.object_description,gsc_product_module.product_module_codeBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(35),X(35),X(10)RowsToBatch200BrowseTitleObject LookupViewerLinkedFieldsgsc_object.object_descriptionLinkedFieldDataTypescharacterLinkedFieldFormatsX(35)ViewerLinkedWidgetsfiObjectColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNameobject_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup-3 ).
       RUN repositionObject IN h_dynlookup-3 ( 8.05 , 21.00 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup-3 ( 1.00 , 22.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_instance_attribute.attribute_codeKeyFieldgsc_instance_attribute.instance_attribute_objFieldLabelRun with AttributeFieldTooltippress F4 for lookupKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_instance_attribute NO-LOCK
                     BY gsc_instance_attribute.attribute_codeQueryTablesgsc_instance_attributeBrowseFieldsgsc_instance_attribute.attribute_code,gsc_instance_attribute.attribute_description,gsc_instance_attribute.attribute_typeBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(35),X(500),X(3)RowsToBatch200BrowseTitleAttribute LookupViewerLinkedFieldsgsc_instance_attribute.attribute_descriptionLinkedFieldDataTypescharacterLinkedFieldFormatsX(500)ViewerLinkedWidgetsfiAttrColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNameinstance_attribute_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup-4 ).
       RUN repositionObject IN h_dynlookup-4 ( 9.00 , 21.00 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup-4 ( 1.00 , 22.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_item_category.item_category_labelKeyFieldgsc_item_category.item_category_objFieldLabelCategoryFieldTooltipSelect option from listKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_item_category no-lockQueryTablesgsc_item_categorySDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1CurrentKeyValueComboDelimiterListItemPairsCurrentDescValueInnerLines0ComboFlagNFlagValue0BuildSequence1SecurednoFieldNameitem_category_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyncombo ).
       RUN repositionObject IN h_dyncombo ( 12.86 , 21.00 ) NO-ERROR.
       RUN resizeObject IN h_dyncombo ( 1.00 , 32.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'afspfoldrw.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FolderLabels':U + ' Enable Rule| Hide Rule| Alternate Image Rule|Syntax Help' + 'TabFGcolor':U + 'Default|Default|Default|Default' + 'TabBGcolor':U + 'Default|Default|Default|Default' + 'TabINColor':U + 'GrayText|GrayText|GrayText|GrayText' + 'ImageEnabled':U + '' + 'ImageDisabled':U + '' + 'Hotkey':U + '' + 'Tooltip':U + '' + 'TabHidden':U + 'no|no|no|no' + 'EnableStates':U + 'All|All|All|All' + 'DisableStates':U + 'All|All|All|All' + 'VisibleRows':U + '10' + 'PanelOffset':U + '0' + 'FolderMenu':U + '' + 'TabsPerRow':U + '4' + 'TabHeight':U + '6' + 'TabFont':U + '4' + 'LabelOffset':U + '0' + 'ImageWidth':U + '0' + 'ImageHeight':U + '0' + 'ImageXOffset':U + '2' + 'ImageYOffset':U + '2' + 'TabSize':U + 'Justified' + 'SelectorFGcolor':U + 'Default' + 'SelectorBGcolor':U + 'Default' + 'SelectorFont':U + '4' + 'SelectorWidth':U + '2' + 'TabPosition':U + 'Upper' + 'MouseCursor':U + '' + 'InheritColor':U + 'no' + 'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_afspfoldrw ).
       RUN repositionObject IN h_afspfoldrw ( 15.52 , 1.00 ) NO-ERROR.
       RUN resizeObject IN h_afspfoldrw ( 4.24 , 109.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dynlookup-3 ,
             RowObject.item_select_type:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_dynlookup-4 ,
             h_dynlookup-3 , 'AFTER':U ).
       RUN adjustTabOrder ( h_dyncombo ,
             buImage2:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_afspfoldrw ,
             RowObject.item_menu_drop:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord vTableWin 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cNew    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE cKey    AS CHARACTER  NO-UNDO.


  /* Code placed here will execute PRIOR to standard behavior. */
 {get NewRecord cNew}.
  RUN SUPER.
  IF cNew = "Add":U OR cNew = "Copy":U THEN DO:
    {get ContainerSource hSource}.
    IF VALID-HANDLE(hSource) THEN
       RUN treeSynch IN hSource ("ITEM":U).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE comboValueChanged vTableWin 
PROCEDURE comboValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     Capture the value Changed event of the combobox and
               retrieve the category's default item-link.
  Parameters: pcKeyFieldValue   The selected combo's key value
              pcScreenValue     The screen value of the selected item
              phCombo           The handle of the dynamic combo
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pckeyFieldValue AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcScreenValue   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER phCombo         AS HANDLE     NO-UNDO.

DEFINE VARIABLE cCols AS CHARACTER  NO-UNDO.

IF phCombo = h_dyncombo AND rowObject.ITEM_link:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""  THEN
DO:
  DYNAMIC-FUNC('assignQuerySelection':U IN h_gscicfullo, 'item_category_obj':U, pckeyFieldValue, "EQ":U).
  {fn OpenQuery h_gscicfullo}.
  cCols = DYNAMIC-FUNC("colValues" IN h_gscicfullo,"item_link":U).
  IF cCols <> ? THEN
     ASSIGN rowObject.ITEM_link:SCREEN-VALUE  = ENTRY(2,cCols,CHR(1)).
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteComplete vTableWin 
PROCEDURE deleteComplete :
/*------------------------------------------------------------------------------
  Purpose:     Delete the node in the tree
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.

{get ContainerSource hSource}.

IF VALID-HANDLE(hSource) THEN
    RUN deleteNode IN hSource ("Item":U,NO).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields vTableWin 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.
 
  DEFINE VARIABLE hFrameField   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iValue        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cFieldHandles AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFrame        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNew          AS CHARACTER  NO-UNDO.
  

  RUN SUPER( INPUT pcColValues).

  {get NewRecord cNew}.
  /* set the autogenerate toggle field accordingly */
  IF cNew = "No":U THEN
    ASSIGN toAutogen:HIDDEN IN FRAME {&FRAME-NAME}    = TRUE
           RowObject.MENU_item_reference:SENSITIVE    = TRUE
           toAutogen:CHECKED                         = FALSE
           NO-ERROR.
  ELSE
    ASSIGN RowObject.MENU_item_reference:SCREEN-VALUE = IF  toAutogen:CHECKED 
                                                        THEN "AutoGenerate":U 
                                                        ELSE "".

  /* Set the fields hidden based on the item_select_type field */
  setActionDisplay(rowObject.ITEM_select_type:SCREEN-VALUE).
  setControlDisplay(RowObject.Item_control_type:SCREEN-VALUE).
  setRuleDisplay(giRulepage).
 
 /* Load the image accordingly */
  buImage:load-image(RowObject.image1_up_filename:SCREEN-VALUE) NO-ERROR.
  buImage:TOOLTIP = RowObject.image1_up_filename:SCREEN-VALUE.
  buImage2:load-image(RowObject.image2_up_filename:SCREEN-VALUE) NO-ERROR.
  buImage2:TOOLTIP = RowObject.image2_up_filename:SCREEN-VALUE.

  /* Set the product module Object (for filtering the lookups) and the product module code (for display only)*/
  {get ContainerSource hSource}.
  fiProdMod:SCREEN-VALUE = DYNAMIC-FUNC('getProductModuleCode':U IN hSource,RowObject.product_module_obj:SCREEN-VALUE) .
  
  {get ContainerHandle hSource h_afspfoldrw}.
  hSource:MOVE-TO-BOTTOM().
  ASSIGN fiObject:TOOLTIP = fiObject:SCREEN-VALUE
         fiAttr:TOOLTIP   = fiAttr:SCREEN-VALUE.
  
  
  
 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields vTableWin 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.
  
  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
  setActionDisplay(rowObject.ITEM_select_type:SCREEN-VALUE).
  setControlDisplay(RowObject.Item_control_type:SCREEN-VALUE).
  setRuleDisplay(girulepage).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getButtonImage vTableWin 
PROCEDURE getButtonImage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phImageUp  AS HANDLE    NO-UNDO.
 
  DEFINE INPUT  PARAMETER phButton   AS HANDLE    NO-UNDO.
 

  define variable cFileName     as character format "x(60)":U no-undo.
  define variable cDirectory    as character format "x(60)":U no-undo.
  define variable cAbsFilename  as character format "x(60)":U no-undo.
  define variable cExtension    as character no-undo.
  DEFINE VARIABLE lOK           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE image-formats AS CHARACTER  NO-UNDO.
  assign cFileName  = phImageUp:SCREEN-VALUE
         cFileName  = substring(cFileName, 1, r-index(cFileName , ".":u)- 1)
         cDirectory = "adeicon,af/bmp":U 
         image-formats = "All Picture Files|*.bmp,*.dib,*.ico,*.gif,*.jpg,*.cal,*.cut,*.dcx,*.eps,*.ica,*.iff,*.img," +
                         "*.lv,*.mac,*.msp,*.pcd,*.pct,*.pcx,*.psd,*.ras,*.im,*.im1,*.im8,*.tga,*.tif,*.xbm,*.bm,*.xpm,*.wmf,*.wpg" +
                        "|Bitmaps (*.bmp,*.dib)|*.bmp,*.dib|Icons (*.ico)|*.ico|GIF (*.gif)|*.gif|JPEG (*.jpg)|*.jpg" +
                        "|CALS (*.cal)|*.cal|Halo CUT (*.cut)|*.cut|Intel FAX (*.dcx)|*.dcx|EPS (*.eps)|*.eps|IOCA (*.ica)|*.ica" +
                        "|Amiga IFF (*.iff)|*.iff|GEM IMG (*.img)|*.img|LaserView (*.lv)|*.lv|MacPaint (*.mac)|*.mac" +
                        "|Microsoft Paint (*.msp)|*.msp|Photo CD (*.pcd)|*.pcd|PICT (*.pct)|*.pct|PC Paintbrush (*.pcx)|*.pcx" +
                        "|Adobe Photoshop (*.psd)|*.psd|Sun Raster (*.ras,*.im,*.im1,*.im8)|*.ras,*.im,*.im1,*.im8|TARGA (*.tga)|*.tga" +
                        "|TIFF (*.tif)|*.tif|Pixmap (*.xpm)|*.xpm|Metafiles (*.wmf)|*.wmf|WordPerfect graphics (*.wpg)|*.wpg|" +
                        "Xbitmap (*.xbm,*.bm)|*.xbm,*.bm|All Files|*.*":U
                        NO-ERROR.

  run adecomm/_fndfile.p   (input "Find Image",
                            input "IMAGE":u,
                            &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                              INPUT image-formats,
                            &ELSE
                              INPUT "*.xpm,*.xbm|*.*",
                            &ENDIF
                            input-output cDirectory,
                            input-output cFileName,
                            output cAbsFileName,
                            output lOk).

  IF lOK THEN DO:
     phButton:load-image(cFileName) NO-ERROR.    
     phImageUp:SCREEN-VALUE = cFileName.
    {set DataModified YES}.
  END.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
  SUBSCRIBE TO "lookupComplete":U IN THIS-PROCEDURE.
  SUBSCRIBE TO 'lookupDisplayComplete':U IN THIS-PROCEDURE.
  SUBSCRIBE TO "comboValueChanged":U in THIS-PROCEDURE.
 
  
  RUN SUPER.
  ASSIGN EDRuleHelp:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
    = " A rule contains a delimited list of either function references " +
      "or properties that return a logical result." + CHR(13) +
      "Syntax:  [ property | function ] = list [ AND | OR ] ..." + CHR(13) +
      "    property:  The name of a property (without the get) that is executed across the specified Item link" + CHR(13) +
      "    function:  A function that is executed across the specified Item link" + CHR(13) +
      "    list    :      A comma delimited list of values that is compared to the property or function result. An 'OR' comparison is performed'" + CHR(13) + 
      "Example:  " + CHR(13) + 
      '    RecordState=RecordAvailable,NoRecordAvailable' + ' and Editable' + ' and DataModified=no' + ' and CanNavigate()'.
 

 
  /* Code placed here will execute AFTER standard behavior.    */
  setRuleDisplay(1).
  
  /* Set the first tab of the folder to be selected */
  {set CurrentPage 1}.
  RUN changefolderpage IN h_afspfoldrw.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupDisplayComplete vTableWin 
PROCEDURE lookupDisplayComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcnames         AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcValues        AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcKeyFieldValue AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pHandle         AS HANDLE     NO-UNDO.


IF pHandle = h_dynlookup-3 AND pcKeyFieldValue = "" THEN
    {set keyFieldValue "0" h_dynlookup-3}.

IF pHandle = h_dynlookup-3 THEN
  ASSIGN fiObject:TOOLTIP IN FRAME {&FRAME-NAME} = fiObject:SCREEN-VALUE.
ELSE IF pHandle = h_dynlookup-4 THEN
  ASSIGN fiAttr:TOOLTIP = fiAttr:SCREEN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord vTableWin 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     Ensure delete remains insensitive when required (Item band node
               is selected )
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSource    AS HANDLE     NO-UNDO.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  {get ContainerSource hSource}.
  IF VALID-HANDLE(hSource) THEN
    RUN treeSynch IN hSource ("ITEM":U).

 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectPage vTableWin 
PROCEDURE selectPage :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER piPageNum AS INTEGER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN showCurrentPage IN h_afspfoldrw (piPageNum).
  giRulePage = piPageNum.
  setRuleDisplay(piPageNum).
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSensitive vTableWin 
PROCEDURE setSensitive :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER plSensitive AS LOGICAL    NO-UNDO.
 
 ASSIGN   
   buImage:SENSITIVE IN FRAME {&FRAME-NAME} = plSensitive
   buImage2:SENSITIVE = plSensitive
   buKey:SENSITIVE = plSensitive
   EdRuleHelp:READ-ONLY = NOT plSensitive 
  /* fiModule:SENSITIVE = plSensitive*/
   RowObject.disabled:SENSITIVE = plSensitive 
   RowObject.enable_rule:SENSITIVE = plSensitive
   RowObject.hide_if_disabled:SENSITIVE = plSensitive 
   RowObject.hide_rule:SENSITIVE = plSensitive
   RowObject.image_alternate_rule:SENSITIVE = plSensitive  
   RowObject.item_control_style:SENSITIVE = plSensitive 
   RowObject.item_control_type:SENSITIVE = plSensitive 
   RowObject.item_link:SENSITIVE = plSensitive 
   RowObject.item_menu_drop:SENSITIVE = plSensitive 
   RowObject.item_narration:SENSITIVE = plSensitive 
   RowObject.item_select_action:SENSITIVE = plSensitive 
   RowObject.item_select_parameter:SENSITIVE = plSensitive 
   RowObject.item_select_type:SENSITIVE = plSensitive 
   RowObject.item_toolbar_label:SENSITIVE = plSensitive 
   RowObject.menu_item_description:SENSITIVE = plSensitive 
   RowObject.menu_item_label:SENSITIVE = plSensitive 
   RowObject.menu_item_obj:SENSITIVE = plSensitive 
   RowObject.menu_item_reference:SENSITIVE = plSensitive 
   RowObject.on_create_publish_event:SENSITIVE = plSensitive 
   RowObject.product_module_obj:SENSITIVE = plSensitive 
   RowObject.security_token:SENSITIVE = plSensitive 
   RowObject.substitute_text_property:SENSITIVE = plSensitive 
   RowObject.system_owned:SENSITIVE = plSensitive 
   RowObject.tooltip_text:SENSITIVE = plSensitive 
   RowObject.under_development:SENSITIVE = plSensitive 
   ToAutoGen:SENSITIVE = plSensitive
   NO-ERROR.

   IF NOT plsensitive THEN 
   DO:
     RUN disableField IN  h_dyncombo .
     RUN disableField IN  h_dynlookup-3. 
     RUN disableField IN  h_dynlookup-4. 
   END.
   ELSE DO:
     RUN enableField IN  h_dyncombo .
     RUN enableField IN  h_dynlookup-3. 
     RUN enableField IN  h_dynlookup-4. 
   END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord vTableWin 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNew       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSource    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cKeyField  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRef       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAddRef    AS LOGICAL    NO-UNDO.

  {get ContainerSource hSource}.
  {get NewRecord cNew}.
  IF VALID-HANDLE(hSource) AND (cNew = "Add":U OR cNew = "Copy":U) THEN 
    RowObject.product_module_obj:SCREEN-VALUE IN FRAME {&FRAME-NAME} = DYNAMIC-FUNC('getModuleObj':U IN hSource) NO-ERROR.
  
  RUN SUPER.

  IF RETURN-VALUE <> "ADM-ERROR":U AND VALID-HANDLE(hSource) THEN 
  DO WITH FRAME {&FRAME-NAME}:
    {get  KeyFieldValue cKeyField h_dyncombo}.
    ASSIGN cLabel = DYNAMIC-FUNC("getItemLabel":U IN hSource,
                                  INPUT RowObject.menu_item_label:SCREEN-VALUE,
                                  INPUT RowObject.MENU_item_reference:SCREEN-VALUE,
                                  INPUT RowObject.menu_item_description:SCREEN-VALUE,
                                  INPUT RowObject.ITEM_control_type:SCREEN-VALUE).
    
     IF cNew = "Add":U OR cNew = "Copy":U THEN 
     DO:
       RUN addNode IN hSource 
            ("Item":U,
              cLabel ,
              RowObject.menu_ITEM_obj:SCREEN-VALUE + "|":U + cKeyField + "|" +  RowObject.ITEM_control_type:SCREEN-VALUE).
     END.
     ELSE DO:
       
       RUN updateNode IN hSource("item",ckeyField,cLabel).
     END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setActionDisplay vTableWin 
FUNCTION setActionDisplay RETURNS LOGICAL
  ( pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hSideLabel  AS HANDLE     NO-UNDO.

DO WITH FRAME {&FRAME-NAME}: 
  CASE pcAction:
      WHEN "PUBLISH":U THEN DO:
          ASSIGN rowObject.item_select_action:HIDDEN       = FALSE
                 rowObject.item_select_action:SENSITIVE    = TRUE
                 rowObject.item_select_parameter:HIDDEN    = FALSE
                 rowObject.item_select_parameter:SENSITIVE = TRUE
                 fiObject:HIDDEN                           = TRUE
                 fiObject:SENSITIVE                        = FALSE
                 fiAttr:HIDDEN                             = TRUE 
                 fiAttr:SENSITIVE                          = FALSE 
                 NO-ERROR.
                 
          RUN hideObject IN h_dynLookup-3.
          RUN hideObject IN h_dynLookup-4.
          hSideLabel = rowObject.item_select_action:SIDE-LABEL-HANDLE.
          hSidelabel:SCREEN-VALUE = "Action" .

      END.

      WHEN "RUN":U THEN DO:
          ASSIGN rowObject.item_select_action:HIDDEN       = FALSE
                 rowObject.item_select_action:SENSITIVE    = TRUE
                 rowObject.item_select_parameter:HIDDEN    = FALSE
                 rowObject.item_select_parameter:SENSITIVE = TRUE
                 fiObject:HIDDEN                           = TRUE
                 fiAttr:HIDDEN                             = TRUE   
                 fiObject:SENSITIVE                        = FALSE
                 fiAttr:SENSITIVE                          = FALSE
                 NO-ERROR.
          RUN hideObject IN h_dynLookup-3.
          RUN hideObject IN h_dynLookup-4.
          hSideLabel = rowObject.item_select_action:SIDE-LABEL-HANDLE.
          hSidelabel:SCREEN-VALUE = "Action" .
      END.
      
      WHEN "PROPERTY":U THEN DO:
          ASSIGN rowObject.item_select_action:HIDDEN       = FALSE
                 rowObject.item_select_action:SENSITIVE    = TRUE
                 rowObject.item_select_parameter:HIDDEN    = TRUE
                 rowObject.item_select_parameter:SENSITIVE = TRUE
                 fiObject:HIDDEN                           = TRUE
                 fiAttr:HIDDEN                             = TRUE
                 fiObject:SENSITIVE                        = FALSE
                 fiAttr:SENSITIVE                          = FALSE
                 NO-ERROR.
          RUN hideObject IN h_dynLookup-3.
          RUN hideObject IN h_dynLookup-4.
          hSideLabel = rowObject.item_select_action:SIDE-LABEL-HANDLE.
          hSidelabel:SCREEN-VALUE = "Toggle Property" .
                 
      END.
      WHEN "LAUNCH":U THEN DO:
          ASSIGN rowObject.item_select_action:HIDDEN       = TRUE
                 rowObject.item_select_parameter:HIDDEN    = TRUE
                 fiObject:HIDDEN                           = FALSE
                 fiAttr:HIDDEN                             = FALSE
                 fiObject:SENSITIVE                        = FALSE
                 fiAttr:SENSITIVE                          = FALSE.
          RUN viewObject IN h_dynLookup-3.
          RUN viewObject IN h_dynLookup-4.
              
      END.
      
  END CASE.
  RETURN FALSE.   /* Function return value. */
 END.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setControlDisplay vTableWin 
FUNCTION setControlDisplay RETURNS LOGICAL
  ( pcControlType AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 CASE pcControlType:
    WHEN "ACTION":U THEN
    DO WITH FRAME {&FRAME-NAME}:
     ASSIGN RowObject.Item_select_type:SENSITIVE         = TRUE
            RowObject.Item_select_action:SENSITIVE       = TRUE
            RowObject.Item_select_parameter:SENSITIVE    = TRUE
            RowObject.Substitute_text_property:SENSITIVE = TRUE
            RowObject.Item_link:SENSITIVE                = TRUE
            RowObject.item_toolbar_label:SENSITIVE       = TRUE
            RowObject.tooltip_text:SENSITIVE             = TRUE
            RowObject.item_control_style:SENSITIVE       = TRUE
            buImage:SENSITIVE                            = TRUE
            buImage2:SENSITIVE                           = TRUE
            RowObject.security_token:SENSITIVE           = TRUE
            RowObject.on_create_publish_event:SENSITIVE  = TRUE
            RowObject.item_menu_drop:SENSITIVE           = TRUE
            RowObject.enable_rule:SENSITIVE              = TRUE
            RowObject.hide_rule:SENSITIVE                = TRUE
            RowObject.image_alternate_rule:SENSITIVE     = TRUE
            NO-ERROR.
     RUN enableField IN h_dynLookup-3.
     RUN enableField IN h_dynLookup-4.
          
    END.
    WHEN "Separator":U THEN DO:
      ASSIGN RowObject.Item_select_type:SENSITIVE         = FALSE
             RowObject.Item_select_action:SENSITIVE       = FALSE
             RowObject.Item_select_parameter:SENSITIVE    = FALSE
             RowObject.Substitute_text_property:SENSITIVE = FALSE
             RowObject.Item_link:SENSITIVE                = FALSE
             RowObject.item_toolbar_label:SENSITIVE       = FALSE
             RowObject.tooltip_text:SENSITIVE             = FALSE
             RowObject.item_control_style:SENSITIVE       = FALSE
             buImage:SENSITIVE                            = FALSE
             buImage2:SENSITIVE                           = FALSE
             RowObject.security_token:SENSITIVE           = FALSE
             RowObject.on_create_publish_event:SENSITIVE  = FALSE
             RowObject.item_menu_drop:SENSITIVE           = FALSE
             RowObject.enable_rule:SENSITIVE              = FALSE
             RowObject.hide_rule:SENSITIVE                = FALSE
             RowObject.image_alternate_rule:SENSITIVE     = FALSE
             NO-ERROR.
     RUN disableField IN h_dynLookup-3.
     RUN disableField IN h_dynLookup-4.
    END.

    WHEN "Label":U OR WHEN "Placeholder":U THEN DO:
       ASSIGN RowObject.Item_select_type:SENSITIVE         = FALSE
              RowObject.Item_select_action:SENSITIVE       = FALSE
              RowObject.Item_select_parameter:SENSITIVE    = FALSE
              RowObject.Substitute_text_property:SENSITIVE = TRUE
              RowObject.Item_link:SENSITIVE                = TRUE
              RowObject.item_toolbar_label:SENSITIVE       = IF pcControlType = "PlaceHolder":U
                                                             THEN FALSE
                                                             ELSE TRUE
              RowObject.tooltip_text:SENSITIVE             = IF pcControlType = "PlaceHolder":U
                                                             THEN FALSE
                                                             ELSE TRUE
              RowObject.item_control_style:SENSITIVE       = FALSE 
              buImage:SENSITIVE                            = FALSE 
              buImage2:SENSITIVE                           = FALSE 
              RowObject.security_token:SENSITIVE           = TRUE
              RowObject.on_create_publish_event:SENSITIVE  = TRUE
              RowObject.item_menu_drop:SENSITIVE           = TRUE
              RowObject.enable_rule:SENSITIVE              = TRUE
              RowObject.hide_rule:SENSITIVE                = TRUE
              RowObject.image_alternate_rule:SENSITIVE     = TRUE
              NO-ERROR.
      RUN disableField IN h_dynLookup-3.
      RUN disableField IN h_dynLookup-4.

    END.

  END CASE.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRuleDisplay vTableWin 
FUNCTION setRuleDisplay RETURNS LOGICAL
  ( piRule AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}: 
  CASE piRule:
    WHEN 1 THEN DO:
        ASSIGN RowObject.image_alternate_rule:HIDDEN    = TRUE
              RowObject.Hide_rule:HIDDEN                = TRUE
              RowObject.enable_rule:HIDDEN              = FALSE
              RowObject.enable_rule:READ-ONLY           = FALSE
              EdRuleHelp:READ-ONLY                      = TRUE
              EdRuleHelp:HIDDEN                         = TRUE.
      
    END.
    
    WHEN 2 THEN DO:
       ASSIGN RowObject.image_alternate_rule:HIDDEN     = TRUE
              RowObject.Hide_rule:READ-ONLY             = FALSE
              RowObject.Hide_rule:HIDDEN                = FALSE
              RowObject.enable_rule:HIDDEN              = TRUE
              EdRuleHelp:READ-ONLY                      = TRUE
              EdRuleHelp:HIDDEN                         = TRUE.
      
    END.
    
    WHEN 3 THEN DO:
        ASSIGN RowObject.image_alternate_rule:HIDDEN     = FALSE
               RowObject.image_alternate_rule:READ-ONLY  = FALSE
               RowObject.Hide_rule:HIDDEN                = TRUE
               RowObject.enable_rule:HIDDEN              = TRUE
               EdRuleHelp:READ-ONLY                      = TRUE
               EdRuleHelp:HIDDEN                         = TRUE.
      
    END.
    
    WHEN 4 THEN DO:
       ASSIGN RowObject.image_alternate_rule:HIDDEN     = TRUE 
              RowObject.image_alternate_rule:READ-ONLY  = TRUE
              RowObject.Hide_rule:HIDDEN                = TRUE
              RowObject.enable_rule:HIDDEN              = TRUE
              EdRuleHelp:HIDDEN                         = FALSE
              EdRulehelp:SENSITIVE                      = TRUE
              EdRuleHelp:READ-ONLY                      = TRUE.
    
    END.

  END CASE.

END.
RETURN FALSE.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

