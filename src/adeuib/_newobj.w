&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
/* Procedure Description
"UIB's NEW dialog-box"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME d_newobj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS d_newobj 
/*********************************************************************
* Copyright (C) 2000-2001 by Progress Software Corporation ("PSC"),  *
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

  File: _newobj.w
  
  Description: New object dialog for UIB

  Input Parameters:
      <none>

  Output Parameters:
      selected (char) - file name to use.

  Author: Gerry Seidl

  Created: 01/20/95 -  5:38 pm

  Modified: GFS 03/17/98 - Reworked some of the code to deal with no
                           containers which is the case with Webspeed-only
            TSM 05/27/99 - Changed filters parameter in call to _fndfile.p
                           because it now needs list-item pairs rather
                           than list-items to support new image formats
            GFS 08/27/01 - Added Product Module field for ICF
            JEP 09/20/01 - Added "Create in Product Module" toggle
            JEP 10/12/01 - IZ 2381 - Set object_type_code to be conditional
                           on custom file data and container_object is set
                           to yes/no based on custom file as well.
            JEP 11/18/01 - IZ 2513 - Prevent Include file types from being
                           created in a product module.
            JEP 11/20/01 - IZ 3191 - Prevent creating an object if PM list is empty.
            JEP 11/20/01 - IZ 3195 - Description missing from PM list.
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
{adeuib/custwidg.i}   /* _custom & _palette_item temp-table defs */
{adeuib/sharvars.i}   /* UIB shared variables                    */
{adeuib/uibhlp.i}     /* Help String Definitions                 */
{adeuib/ttobject.i}   /* _ryobject temp-table definition for icf */
{src/adm2/globals.i}  /* Icf global vars                         */

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
/* DEFINE VAR SELECTED AS CHAR NO-UNDO. */
DEFINE OUTPUT PARAMETER selected AS CHARACTER NO-UNDO. /* file to use   */

DEFINE VAR Type_Container   AS CHARACTER INIT "Containers"      NO-UNDO.
DEFINE VAR Type_SmartObject AS CHARACTER INIT "SmartObjects"    NO-UNDO.
DEFINE VAR Type_Procedure   AS CHARACTER INIT "Procedures"      NO-UNDO.
DEFINE VAR Type_WebObject   AS CHARACTER INIT "WebObject"       NO-UNDO.
DEFINE VAR Type_All         AS CHARACTER INIT "All"             NO-UNDO.

DEFINE VAR c_lbl_list   AS CHARACTER NO-UNDO. /* container label list       */
DEFINE VAR c_lbl_listX  AS CHARACTER NO-UNDO. /* container label list without fix  */
DEFINE VAR c_lbl_listD  AS CHARACTER NO-UNDO. /* container label list Dtnamic  */
DEFINE VAR c_tmp_list   AS CHARACTER NO-UNDO. /* container template list    */
DEFINE VAR ext_tmp_list AS CHARACTER NO-UNDO. /* external template file list */
DEFINE VAR p_lbl_list   AS CHARACTER NO-UNDO. /* Procedure label list       */
DEFINE VAR p_lbl_listX  AS CHARACTER NO-UNDO. /* Procedure label list without fix  */
DEFINE VAR p_lbl_listD  AS CHARACTER NO-UNDO. /* Procedure label list Dynamic  */
DEFINE VAR p_tmp_list   AS CHARACTER NO-UNDO. /* Procedure template list    */
DEFINE VAR ret_value    AS LOGICAL   NO-UNDO. /* Function assign logical    */
DEFINE VAR s_lbl_list   AS CHARACTER NO-UNDO. /* SO label list              */
DEFINE VAR s_lbl_listX  AS CHARACTER NO-UNDO. /* SO label list without fix  */
DEFINE VAR s_tmp_list   AS CHARACTER NO-UNDO. /* SO template list           */
DEFINE VAR s_lbl_listD  AS CHARACTER NO-UNDO. /* SO label list Dynamic      */
DEFINE VAR w_lbl_list   AS CHARACTER NO-UNDO. /* WebObject label list       */
DEFINE VAR w_lbl_listX  AS CHARACTER NO-UNDO. /* WebObject label list without fix  */
DEFINE VAR w_tmp_list   AS CHARACTER NO-UNDO. /* WebObject template list    */
DEFINE VAR w_lbl_listD  AS CHARACTER NO-UNDO. /* WebObject label list Dynamic  */
DEFINE VAR licnum       AS INTEGER   NO-UNDO. /* ablic return value         */
DEFINE VAR licstr       AS CHARACTER NO-UNDO. /* ablic return string        */
DEFINE VAR enable-icf   AS LOGICAL   NO-UNDO. /* icf enabled logical        */

DEFINE TEMP-TABLE ttPM NO-UNDO
  FIELD PMCode          AS CHARACTER.

DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME d_newobj

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS s_objects e_descr2 e_descr1 b_Ok b_Cancel ~
b_Template b_Help Objects-text descr-text RECT-3 RECT-4 RECT-5 RECT-7 
&Scoped-Define DISPLAYED-OBJECTS s_objects e_descr2 e_descr1 Objects-text ~
descr-text Show-text 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRDMHandle d_newobj 
FUNCTION getRDMHandle RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_Ok AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_Template 
     LABEL "&Template..." 
     SIZE 15 BY 1.14.

DEFINE VARIABLE cb_productModule AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 15
     LIST-ITEM-PAIRS "item","item"
     DROP-DOWN-LIST
     SIZE 49.2 BY 1 TOOLTIP "Product module in which you want to create a new object." NO-UNDO.

DEFINE VARIABLE e_descr1 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 70 BY 4.52
     FONT 4 NO-UNDO.

DEFINE VARIABLE e_descr2 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 70 BY 4.52
     FONT 4 NO-UNDO.

DEFINE VARIABLE descr-text AS CHARACTER FORMAT "X(256)":U INITIAL " Description" 
      VIEW-AS TEXT 
     SIZE 12 BY .62 NO-UNDO.

DEFINE VARIABLE Objects-text AS CHARACTER FORMAT "X(256)":U INITIAL " Objects" 
      VIEW-AS TEXT 
     SIZE 8 BY .76 NO-UNDO.

DEFINE VARIABLE Show-text AS CHARACTER FORMAT "X(256)":U INITIAL " Show" 
      VIEW-AS TEXT 
     SIZE 6.4 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72.2 BY 5.29.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 19 BY 6.38.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 52 BY 12.19.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 52 BY 2.86.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 19 BY 2.1.

DEFINE VARIABLE s_objects AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 50 BY 11.62 NO-UNDO.

DEFINE VARIABLE productModule-Create AS LOGICAL INITIAL yes 
     LABEL "&Create in Product Module:" 
     VIEW-AS TOGGLE-BOX
     SIZE 31.6 BY .81 TOOLTIP "When selected, indicates the new object will be created in a product module." NO-UNDO.

DEFINE VARIABLE togContainer AS LOGICAL INITIAL no 
     LABEL "&Containers" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.6 BY .81 NO-UNDO.

DEFINE VARIABLE togDynamic AS LOGICAL INITIAL no 
     LABEL "Dynamic" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.

DEFINE VARIABLE togProc AS LOGICAL INITIAL no 
     LABEL "&Procedures" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.6 BY .81 NO-UNDO.

DEFINE VARIABLE togSO AS LOGICAL INITIAL no 
     LABEL "&SmartObjects" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.6 BY .81 NO-UNDO.

DEFINE VARIABLE togStatic AS LOGICAL INITIAL no 
     LABEL "Static" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.

DEFINE VARIABLE togWO AS LOGICAL INITIAL no 
     LABEL "&WebObjects" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.2 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME d_newobj
     togDynamic AT ROW 11.71 COL 56.2
     togStatic AT ROW 12.67 COL 56.2
     productModule-Create AT ROW 1.76 COL 3.2
     cb_productModule AT ROW 2.76 COL 3 NO-LABEL
     s_objects AT ROW 1.76 COL 3 NO-LABEL
     e_descr2 AT ROW 14.52 COL 3 HELP
          "Description of object" NO-LABEL
     e_descr1 AT ROW 14.52 COL 3 HELP
          "Description of object" NO-LABEL
     togContainer AT ROW 7.71 COL 56.2
     togSO AT ROW 8.67 COL 56.2
     togProc AT ROW 9.62 COL 56.2
     togWO AT ROW 10.57 COL 56.2
     b_Ok AT ROW 1.48 COL 58.6
     b_Cancel AT ROW 2.76 COL 58.6
     b_Template AT ROW 4.05 COL 58.6
     b_Help AT ROW 5.33 COL 58.6
     Objects-text AT ROW 1 COL 1 COLON-ALIGNED NO-LABEL
     descr-text AT ROW 13.86 COL 1 COLON-ALIGNED NO-LABEL
     Show-text AT ROW 6.95 COL 54.4 COLON-ALIGNED NO-LABEL
     RECT-6 AT ROW 1.48 COL 2
     RECT-3 AT ROW 14.14 COL 2
     RECT-4 AT ROW 7.24 COL 55
     RECT-5 AT ROW 1.43 COL 2
     RECT-7 AT ROW 11.52 COL 55
     SPACE(0.99) SKIP(5.81)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "New"
         DEFAULT-BUTTON b_Ok CANCEL-BUTTON b_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX d_newobj
   Custom                                                               */
ASSIGN 
       FRAME d_newobj:SCROLLABLE       = FALSE.

/* SETTINGS FOR COMBO-BOX cb_productModule IN FRAME d_newobj
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       cb_productModule:HIDDEN IN FRAME d_newobj           = TRUE.

ASSIGN 
       e_descr1:READ-ONLY IN FRAME d_newobj        = TRUE.

ASSIGN 
       e_descr2:READ-ONLY IN FRAME d_newobj        = TRUE.

/* SETTINGS FOR TOGGLE-BOX productModule-Create IN FRAME d_newobj
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       productModule-Create:HIDDEN IN FRAME d_newobj           = TRUE.

ASSIGN 
       RECT-4:HIDDEN IN FRAME d_newobj           = TRUE.

/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME d_newobj
   NO-ENABLE                                                            */
ASSIGN 
       RECT-6:HIDDEN IN FRAME d_newobj           = TRUE.

/* SETTINGS FOR FILL-IN Show-text IN FRAME d_newobj
   NO-ENABLE                                                            */
ASSIGN 
       s_objects:HIDDEN IN FRAME d_newobj           = TRUE.

/* SETTINGS FOR TOGGLE-BOX togContainer IN FRAME d_newobj
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       togContainer:HIDDEN IN FRAME d_newobj           = TRUE.

/* SETTINGS FOR TOGGLE-BOX togDynamic IN FRAME d_newobj
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       togDynamic:HIDDEN IN FRAME d_newobj           = TRUE.

/* SETTINGS FOR TOGGLE-BOX togProc IN FRAME d_newobj
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       togProc:HIDDEN IN FRAME d_newobj           = TRUE.

/* SETTINGS FOR TOGGLE-BOX togSO IN FRAME d_newobj
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       togSO:HIDDEN IN FRAME d_newobj           = TRUE.

/* SETTINGS FOR TOGGLE-BOX togStatic IN FRAME d_newobj
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       togStatic:HIDDEN IN FRAME d_newobj           = TRUE.

/* SETTINGS FOR TOGGLE-BOX togWO IN FRAME d_newobj
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       togWO:HIDDEN IN FRAME d_newobj           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX d_newobj
/* Query rebuild information for DIALOG-BOX d_newobj
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX d_newobj */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME d_newobj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d_newobj d_newobj
ON ENDKEY OF FRAME d_newobj /* New */
OR END-ERROR OF FRAME d_newobj
DO:
  ASSIGN selected = ?.
  IF _file_new_config > 15 THEN 
    ASSIGN _file_new_config = _file_new_config - 16.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d_newobj d_newobj
ON GO OF FRAME d_newobj /* New */
DO:  
  DEFINE VARIABLE l          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE i          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE so-type    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE fixname    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE layoutID   AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE OK_Pressed AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cProductModuleCode AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cCustomName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel      AS CHARACTER  NO-UNDO.


  FIND _palette_item WHERE _palette_item._name = s_objects:SCREEN-VALUE NO-ERROR.
  IF AVAILABLE (_palette_item) THEN DO:
    IF NUM-DBS = 0 AND _palette_item._dbconnect THEN DO:
      RUN adecomm/_dbcnnct.p (
        INPUT "You must have at least one connected database to create a " +
               _palette_item._name 
              + (IF SUBSTRING(_palette_item._name, LENGTH(_palette_item._name) - LENGTH("Object":U) + 1) = "Object":U
                 THEN ".":U ELSE " object.":U),
        OUTPUT l).
      IF l EQ NO THEN RETURN NO-APPLY.  
    END.
  END.
  ELSE DO: 
    /* chosen item was not found in the palette file, look for it in _custom, 
     * it may be a NEW-SmartObject with a "TYPE" 
     */
    FOR EACH _custom WHERE _custom._type = "SmartObject":
      RUN Fix_Custom_Name (_custom._name, OUTPUT fixname).
      IF fixname = s_objects:SCREEN-VALUE THEN 
        /* Look for "TYPE" in _attr */
      DO i = 1 TO NUM-ENTRIES(_custom._attr,CHR(10)):
        IF ENTRY(i,_custom._attr,CHR(10)) BEGINS "TYPE":U THEN DO:
          so-type = TRIM(SUBSTRING(TRIM(ENTRY(i,_custom._attr,CHR(10))),5,-1,"CHARACTER":U)).
          FIND _palette_item WHERE _palette_item._name = so-type NO-ERROR.
          IF AVAILABLE _palette_item THEN DO:
            IF _palette_item._dbconnect and NUM-DBS = 0 THEN DO:
              RUN adecomm/_dbcnnct.p (                
                INPUT "You must have at least one connected database to create a " +
                  _palette_item._name 
              + (IF SUBSTRING(_palette_item._name, LENGTH(_palette_item._name) - LENGTH("Object":U) + 1) = "Object":U
                 THEN ".":U ELSE " object.":U),
                OUTPUT l).
              IF l EQ NO THEN RETURN NO-APPLY.  
            END.  /* If the selection requires a db and none is connected */
          END.  /* We now have a palette item */
        END.  /* If the ith entry begins "TYPE" */
      END.  /* Do i to num-entries of _custom._attr */
    END.  /* FOR EACH _custom */
  END.  /* ELSE DO (couldn't find the _palette_item record) */
  RUN Get_FileName.
  IF _file_new_config > 15 THEN DO: /* The toggles have been tweaked - save them */
    ASSIGN _file_new_config = _file_new_config - 16.
    PUT-KEY-VALUE SECTION "ProAB" KEY "NewObjectToggles"
        VALUE(IF _file_new_config = 15 then ? ELSE STRING(_file_new_config)).
  
  END.
  IF selected = ? THEN DO:
    MESSAGE "Please select an object or press Cancel." VIEW-AS ALERT-BOX
      INFORMATION BUTTONS OK.
    RETURN NO-APPLY.
  END.

  IF enable-icf THEN DO:
      /* jep-icf: Process when the user is creating an object in a product module. */
      IF productModule-Create:CHECKED THEN
      DO:
        
        /* jep-icf: IZ 2513 - Prevent Include file types from being created in PM. */
        IF (s_objects:SCREEN-VALUE MATCHES "*Include*":U) THEN
        DO:
            MESSAGE "Cannot create the new object:" s_objects:SCREEN-VALUE SKIP(1)
                    "Include file types cannot be created in a repository."
                    "To create an Include file type, deselect the Create in Product Module option."
              VIEW-AS ALERT-BOX INFORMATION.
            RETURN NO-APPLY. /* Don't leave the dialog. */
        END.
        /* The private data stores a delimited list of the actual names stored in _Custom._name,
          wheras the List-items have the &s removed */
        ASSIGN cCustomName = ENTRY(s_objects:LOOKUP(s_objects:SCREEN-VALUE), s_objects:PRIVATE-DATA,CHR(10)) NO-ERROR.
        FIND _custom WHERE _custom._name =  cCustomName NO-ERROR.
        IF AVAILABLE (_custom) THEN
        DO:
          /* IZ 3195 Determine ProductModule Code from string "pmCode // pmDescription". */
          ASSIGN cProductModuleCode = cb_productModule:SCREEN-VALUE NO-ERROR.

          /* Fill in the _RyObject record for the AppBuilder. */
          FIND _RyObject WHERE _RyObject.object_filename = SELECTED NO-ERROR.
          IF NOT AVAILABLE _RyObject THEN
            CREATE _RyObject.
          ASSIGN _RyObject.object_type_code       = _custom._object_type_code
                 _RyObject.parent_classes         = DYNAMIC-FUNC("getClassParentsFromDB":U IN gshRepositoryManager, INPUT _RyObject.Object_type_code)
                 _RyObject.object_filename        = SELECTED
                 _RyObject.product_module_code    = cProductModuleCode
                 _RyObject.static_object          = _custom._static_object
                 _RyObject.container_object       = _custom._type = "Container":u
                 _RyObject.design_action          = "NEW":u
                 _RyObject.design_ryobject        = IF _custom._static_object THEN NO ELSE YES
                 _RyObject.design_template_file   = SELECTED
                 _RyObject.design_propsheet_file  = _custom._design_propsheet_file
                 _RyObject.design_image_file      = _custom._design_image_file.

        END. /* If AVAIL(_custom) */
      END. /* IF create in PM */
    
      /* jep-icf: Can't allow creation of a dynamic object outside of repository PM. */
      IF (NOT productModule-Create:CHECKED) THEN
      DO:
          ASSIGN cCustomName = ENTRY(s_objects:LOOKUP(s_objects:SCREEN-VALUE), s_objects:PRIVATE-DATA,CHR(10)) NO-ERROR.
          FIND _custom WHERE _custom._name = cCustomName NO-ERROR.
          IF AVAILABLE (_custom) AND (NOT _custom._static_object) THEN
          DO:
              MESSAGE "Cannot create the new object:" s_objects:SCREEN-VALUE SKIP(1)
                      "A dynamic object can only be created in a product module."
                      "Select the Create in Product Module option to create a dynamic object."
                VIEW-AS ALERT-BOX INFORMATION.
              RETURN NO-APPLY. /* Don't leave the dialog. */
          END.
      END.
        
      /* set current prod module */
      /* get Label */
      IF productModule-Create:CHECKED THEN
      LABEL-LOOP:
      DO i = 1 to NUM-ENTRIES(cb_productModule:LIST-ITEM-PAIRS,CHR(3)) BY 2:
         IF ENTRY(i + 1,cb_productModule:LIST-ITEM-PAIRS,CHR(3)) = cb_productModule:SCREEN-VALUE THEN
         DO:
           clabel = ENTRY(i,cb_productModule:LIST-ITEM-PAIRS,CHR(3)) .
           LEAVE LABEL-LOOP.
         END.  
      END.
      IF VALID-HANDLE(ghRepositoryDesignManager) THEN
        DYNAMIC-FUNC("setCurrentProductModule":U IN ghRepositoryDesignManager, 
                                       cLabel) NO-ERROR.

  END. /* IF enable-icf  */

END. /* ON GO */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Help d_newobj
ON CHOOSE OF b_Help IN FRAME d_newobj /* Help */
DO:
   RUN adecomm/_adehelp.p ( "AB":U, "CONTEXT":U, {&New_Template_Dlg_Box}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Template
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Template d_newobj
ON CHOOSE OF b_Template IN FRAME d_newobj /* Template... */
DO:
  DEFINE VARIABLE pFileName         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE pAbsoluteFileName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE pOK               AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE l                 AS LOGICAL   NO-UNDO.
  
  /* pFilters needs to be in format of list-items-pairs for the combo-box in
     _fndfile.p that displays the File Types */ 
  RUN adecomm/_fndfile.p (INPUT "Template",                          /* pTitle            */
                          INPUT "TEMPLATE":U,                        /* pMode             */
                          INPUT "Windows (*.w)|*.w|All Files|*.*":U, /* pFilters          */
                          INPUT-OUTPUT {&TEMPLATE-DIRS},             /* pDirList          */
                          INPUT-OUTPUT pFileName,                    /* pFileName         */
                          OUTPUT       pAbsoluteFileName,            /* pAbsoluteFileName */
                          OUTPUT       pOK).                         /* pOK               */
  IF pOK AND (pAbsoluteFileName <> "" AND pAbsoluteFileName <> ?) THEN DO:
     ASSIGN ext_tmp_list = LEFT-TRIM(ext_tmp_list + CHR(10) + "Template: ":U + pAbsoluteFileName, CHR(10)).
     l = s_objects:ADD-FIRST("Template: ":U + pAbsoluteFileName) IN FRAME {&FRAME-NAME}. 
     ASSIGN s_objects:PRIVATE-DATA = pAbsoluteFileName + (IF s_objects:PRIVATE-DATA = "" THEN "" ELSE CHR(10))
                                                       + s_objects:PRIVATE-DATA.
     ASSIGN s_objects:SCREEN-VALUE IN FRAME {&FRAME-NAME} = s_objects:ENTRY(1). 
     RUN Get_Descr.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME productModule-Create
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL productModule-Create d_newobj
ON VALUE-CHANGED OF productModule-Create IN FRAME d_newobj /* Create in Product Module: */
DO:
    RUN changeProductModuleState (INPUT SELF:CHECKED).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME s_objects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s_objects d_newobj
ON DEFAULT-ACTION OF s_objects IN FRAME d_newobj
DO:  
  APPLY "GO":U TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s_objects d_newobj
ON VALUE-CHANGED OF s_objects IN FRAME d_newobj
DO:  
  RUN Get_Descr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME togContainer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL togContainer d_newobj
ON VALUE-CHANGED OF togContainer IN FRAME d_newobj /* Containers */
, togSO, togProc, togWO
DO:
  DEFINE VARIABLE tmp-string AS CHARACTER                                 NO-UNDO.
  DEFINE VARIABLE tmp-stringX AS CHARACTER                                NO-UNDO.
  DEFINE VARIABLE tmp-clbl    AS CHARACTER                                NO-UNDO.
  DEFINE VARIABLE tmp-clblX   AS CHARACTER                                NO-UNDO.
  DEFINE VARIABLE tmp-slbl    AS CHARACTER                                NO-UNDO.
  DEFINE VARIABLE tmp-slblX   AS CHARACTER                                NO-UNDO.
  DEFINE VARIABLE i           AS INTEGER                                  NO-UNDO.
  
  IF _AB_license = 2 THEN
    ASSIGN tmp-string =
           (IF ext_tmp_list NE "" THEN ext_tmp_list + CHR(10) ELSE "") +
           (IF c_lbl_list   NE "" THEN c_lbl_list   + CHR(10) ELSE "") + 
           (IF s_lbl_list   NE "" THEN s_lbl_list   + CHR(10) ELSE "") + 
           (IF p_lbl_list   NE "" THEN p_lbl_list   + CHR(10) ELSE "") + 
           (IF w_lbl_list   NE "" THEN w_lbl_list             ELSE "")
           tmp-stringX =
           (IF ext_tmp_list NE "" THEN ext_tmp_list + CHR(10) ELSE "") +
           (IF c_lbl_listX   NE "" THEN c_lbl_listX   + CHR(10) ELSE "") + 
           (IF s_lbl_listX   NE "" THEN s_lbl_listX   + CHR(10) ELSE "") + 
           (IF p_lbl_listX   NE "" THEN p_lbl_listX   + CHR(10) ELSE "") + 
           (IF w_lbl_listX   NE "" THEN w_lbl_listX             ELSE "")
          s_objects:LIST-ITEMS = TRIM(tmp-string, CHR(10))
          s_objects:PRIVATE-DATA = TRIM(tmp-stringX, CHR(10)).
  ELSE DO:
     IF enable-icf AND NOT togDynamic:CHECKED AND NOT togStatic:CHECKED THEN
        assign tmp-String  = ""
               tmp-StringX = "".
     ELSE IF (enable-icf AND NOT togDynamic:CHECKED AND togStatic:CHECKED) 
              OR (enable-icf AND togDynamic:CHECKED AND NOT togStatic:CHECKED) THEN
     DO:
        /* Rebuild container and smartObject string to include only dynamic/static objects based
          on toglle settings */
       DO i = 1 to NUM-ENTRIES(c_lbl_list,CHR(10)):
         IF togStatic:CHECKED AND ENTRY(i,c_lbl_listD) = "S":U 
            OR togDynamic:CHECKED AND ENTRY(i,c_lbl_listD) = "D":U  THEN
            ASSIGN tmp-clbl  = tmp-clbl + (If tmp-clbl = "" then "" else CHR(10)) + ENTRY(i,c_lbl_list,CHR(10))
                   tmp-clblX = tmp-clblX + (If tmp-clblX = "" then "" else CHR(10)) + ENTRY(i,c_lbl_listX,CHR(10)).
       END.
       DO i = 1 to NUM-ENTRIES(s_lbl_list,CHR(10)):
         IF togStatic:CHECKED AND ENTRY(i,s_lbl_listD) = "S":U 
            OR togDynamic:CHECKED AND ENTRY(i,s_lbl_listD) = "D":U  THEN
            ASSIGN tmp-slbl = tmp-slbl + (If tmp-slbl = "" then "" else CHR(10)) + ENTRY(i,s_lbl_list,CHR(10))
                   tmp-slblX = tmp-slblX + (If tmp-slblX = "" then "" else CHR(10)) + ENTRY(i,s_lbl_listX,CHR(10)).
       END.
       
       ASSIGN tmp-string = RIGHT-TRIM((IF ext_tmp_list NE "" THEN ext_tmp_list + CHR(10) ELSE "") +
                          (IF togContainer:CHECKED AND c_lbl_list NE "" THEN tmp-clbl + CHR(10) ELSE "") +
                          (IF togSO:CHECKED AND s_lbl_list NE ""        THEN tmp-slbl + CHR(10) ELSE "") +
                          (IF togProc:CHECKED AND p_lbl_list NE "" 
                                              AND togStatic:CHECKED     THEN p_lbl_list + CHR(10) ELSE "") +
                          (IF togWO:CHECKED AND w_lbl_list NE ""   
                                            AND togStatic:CHECKED       THEN w_lbl_list ELSE ""), CHR(10))
            tmp-stringX = RIGHT-TRIM((IF ext_tmp_list NE "" THEN ext_tmp_list + CHR(10) ELSE "") +
                          (IF togContainer:CHECKED AND c_lbl_listX NE "" THEN tmp-clblX + CHR(10) ELSE "") +
                          (IF togSO:CHECKED AND s_lbl_listX NE ""        THEN tmp-slblX + CHR(10) ELSE "") +
                          (IF togProc:CHECKED AND p_lbl_listX NE ""
                                              AND togStatic:CHECKED      THEN p_lbl_listX + CHR(10) ELSE "") +
                          (IF togWO:CHECKED AND w_lbl_listX NE ""       
                                            AND togStatic:CHECKED        THEN w_lbl_listX ELSE ""), CHR(10)).
     END.

     ELSE
       ASSIGN tmp-string = RIGHT-TRIM((IF ext_tmp_list NE "" THEN ext_tmp_list + CHR(10) ELSE "") +
                            (IF togContainer:CHECKED AND c_lbl_list NE "" THEN c_lbl_list + CHR(10) ELSE "") +
                            (IF togSO:CHECKED AND s_lbl_list NE ""        THEN s_lbl_list + CHR(10) ELSE "") +
                            (IF togProc:CHECKED AND p_lbl_list NE ""      THEN p_lbl_list + CHR(10) ELSE "") +
                            (IF togWO:CHECKED AND w_lbl_list NE ""        THEN w_lbl_list ELSE ""), CHR(10))
              tmp-stringX = RIGHT-TRIM((IF ext_tmp_list NE "" THEN ext_tmp_list + CHR(10) ELSE "") +
                            (IF togContainer:CHECKED AND c_lbl_listX NE "" THEN c_lbl_listX + CHR(10) ELSE "") +
                            (IF togSO:CHECKED AND s_lbl_listX NE ""        THEN s_lbl_listX + CHR(10) ELSE "") +
                            (IF togProc:CHECKED AND p_lbl_listX NE ""      THEN p_lbl_listX + CHR(10) ELSE "") +
                            (IF togWO:CHECKED AND w_lbl_listX NE ""        THEN w_lbl_listX ELSE ""), CHR(10)).

   ASSIGN s_objects:LIST-ITEMS   = tmp-string
          s_objects:PRIVATE-DATA = tmp-stringX.
    
    ASSIGN _file_new_config = 16 + /* 16 means that it has been changed */
                              (IF togContainer:CHECKED THEN 1 ELSE 0) +
                              (IF togSO:CHECKED        THEN 2 ELSE 0) +
                              (IF togProc:CHECKED      THEN 4 ELSE 0) +
                              (IF togWO:CHECKED        THEN 8 ELSE 0) +
                              (IF togDynamic:CHECKED   THEN 16 ELSE 0) +
                              (IF togStatic:CHECKED    THEN 32 ELSE 0) .

  END. /* If not WebSpeed only */            

  IF s_objects:LIST-ITEMS <> ? THEN  DO:
    ASSIGN s_objects:SCREEN-VALUE = s_objects:ENTRY(1).
    RUN Get_Descr.
  END. 
  ELSE
    ASSIGN e_descr1:SCREEN-VALUE = ""
           e_descr2:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME togDynamic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL togDynamic d_newobj
ON VALUE-CHANGED OF togDynamic IN FRAME d_newobj /* Dynamic */
DO:
  APPLY "VALUE-CHANGED":U TO togContainer.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME togStatic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL togStatic d_newobj
ON VALUE-CHANGED OF togStatic IN FRAME d_newobj /* Static */
DO:
   APPLY "VALUE-CHANGED":U TO togContainer.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK d_newobj 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.
ON HELP OF FRAME {&FRAME-NAME} APPLY "CHOOSE":U TO b_Help.

/* Assign delimiter of selection list */
ASSIGN s_objects:DELIMITER = CHR(10).

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON STOP    UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN adecomm/_setcurs.p (INPUT "WAIT":U).
  
  DYNAMIC-FUNCTION("center-frame":U IN _h_func_lib, FRAME {&FRAME-NAME}:HANDLE).
  
  /* If we are RUNNING the ICF, show the ICF product module */
  RUN adeshar/_ablic.p (INPUT NO, OUTPUT licnum, OUTPUT licstr).
  ASSIGN enable-icf = CAN-DO(licstr,"ENABLE-ICF":U).
  
  IF enable-icf THEN
      RUN showProductModule.  
  
  RUN enable_UI.
  
       
  RUN Init.
  
  RUN adecomm/_setcurs.p (INPUT "":U).
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN adecomm/_setcurs.p (INPUT "":U).
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeProductModuleState d_newobj 
PROCEDURE changeProductModuleState :
/*------------------------------------------------------------------------------
  Purpose:     Updates the UI to reflect changes in "Create in PM" toggle.
  Parameters:  pChecked
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pChecked AS LOGICAL    NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

    /* IZ 3191 Helpful message if there are no PM's and the user is Checking on the 
       Create in PM option. */
    IF (pChecked = YES) AND (cb_productModule:NUM-ITEMS = 0) THEN
    DO ON ERROR UNDO, RETRY:
        MESSAGE "Cannot create an object in a product module." SKIP(1)
                "There are no product modules defined in which to create an object."
          VIEW-AS ALERT-BOX INFORMATION.
        ASSIGN productModule-Create:CHECKED = FALSE.
        RETURN.
    END.

    ASSIGN cb_productModule:SENSITIVE = pChecked.

END. /* FRAME */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI d_newobj  _DEFAULT-DISABLE
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
  HIDE FRAME d_newobj.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI d_newobj  _DEFAULT-ENABLE
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
  DISPLAY s_objects e_descr2 e_descr1 Objects-text descr-text Show-text 
      WITH FRAME d_newobj.
  ENABLE s_objects e_descr2 e_descr1 b_Ok b_Cancel b_Template b_Help 
         Objects-text descr-text RECT-3 RECT-4 RECT-5 RECT-7 
      WITH FRAME d_newobj.
  {&OPEN-BROWSERS-IN-QUERY-d_newobj}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Fix_Custom_Name d_newobj 
PROCEDURE Fix_Custom_Name :
/*------------------------------------------------------------------------------
  Purpose:     Create legitable name from the label. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER oldname AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER newname AS CHARACTER NO-UNDO.
  
  ASSIGN newname = REPLACE(oldname,"&&":U,CHR(13))
         newname = REPLACE(newname,"&":U,"")
         newname = REPLACE(newname,CHR(13),"&":U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Get_Descr d_newobj 
PROCEDURE Get_Descr :
/* -----------------------------------------------------------
  Purpose:     Stuff first 20 lines of the code into the editor.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VAR tline AS CHARACTER NO-UNDO.
  DEFINE VAR i     AS INTEGER   NO-UNDO.
  
  ASSIGN e_descr1 = ""
         e_descr2 = "".
  RUN Get_FileName.
  INPUT FROM VALUE(selected) NO-ECHO.
  IMPORT UNFORMATTED tline.
  IMPORT UNFORMATTED tline.
  IF tline = "/* Procedure Description" OR tline BEGINS "<!--":U THEN DO:
    IMPORT tline.
    ASSIGN e_descr2        = tline
           e_descr1:HIDDEN IN FRAME {&FRAME-NAME} = YES
           e_descr2:HIDDEN IN FRAME {&FRAME-NAME} = NO
           .
    DISPLAY e_descr2 WITH FRAME {&FRAME-NAME}.      
  END.
  ELSE DO:
    DO i = 1 to 20:
      IMPORT UNFORMATTED tline.
      IF tline <> "" THEN ASSIGN e_descr1 = e_descr1 + CHR(10) + tline.
    END.
    ASSIGN e_descr1 = SUBSTRING(e_descr1,2,-1,"CHARACTER")
           e_descr2:HIDDEN = YES
           e_descr1:HIDDEN = NO
           .
    DISPLAY e_descr1 WITH FRAME {&FRAME-NAME}.      
  END.
  INPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Get_FileName d_newobj 
PROCEDURE Get_FileName :
/* -----------------------------------------------------------
  Purpose:     Extracts selected filename to use from the list. 
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VARIABLE pos           AS INTEGER   NO-UNDO. /* item's position in list */
  DEFINE VARIABLE tmp_list      AS CHARACTER NO-UNDO. /* temp list of templates */
  DEFINE VARIABLE i             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE c_tmp_listNew AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE s_tmp_listNew AS CHARACTER  NO-UNDO.
  
  
  ASSIGN selected = s_objects:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  
  IF selected = ? THEN RETURN.
  ELSE DO:  
    IF selected BEGINS "Template:":U THEN 
      ASSIGN selected = SUBSTRING(selected,11,-1,"CHARACTER":U).
    ELSE DO:
      /* Assemble the list of templates */
      IF _AB_license = 2 THEN
        ASSIGN tmp_list = c_tmp_list + "," + s_tmp_list + "," +
                          p_tmp_list + "," + w_tmp_list
               tmp_list = TRIM(tmp_list,"~,").
      ELSE IF (enable-icf AND NOT togDynamic:CHECKED AND togStatic:CHECKED) 
              OR (enable-icf AND togDynamic:CHECKED AND NOT togStatic:CHECKED) THEN
      DO:
         /* Rebuild container and smartObject string to include only dynamic/static objects based
           on toglle settings */
        DO i = 1 to NUM-ENTRIES(c_lbl_list,CHR(10)):
          IF togStatic:CHECKED AND ENTRY(i,c_lbl_listD) = "S":U 
             OR  togDynamic:CHECKED AND ENTRY(i,c_lbl_listD) = "D":U  THEN
             ASSIGN c_tmp_listNew = c_tmp_listNew + (IF c_tmp_listNew = "" THEN "" ELSE ",") + ENTRY(i,c_tmp_list).
        END.
        DO i = 1 to NUM-ENTRIES(s_lbl_list,CHR(10)):
          IF togStatic:CHECKED AND ENTRY(i,s_lbl_listD) = "S":U 
             OR togDynamic:CHECKED AND ENTRY(i,s_lbl_listD) = "D":U  THEN
             ASSIGN s_tmp_listNew = s_tmp_listNew + (IF s_tmp_listNew = "" THEN "" ELSE ",") + ENTRY(i,s_tmp_list).
        END.
        IF togContainer:CHECKED AND c_tmp_listNew NE "" THEN 
           tmp_list = c_tmp_listNew.

        IF togSO:CHECKED AND s_tmp_listNew NE "" THEN 
          IF tmp_list NE "" THEN 
             tmp_list = tmp_list + ",":U + s_tmp_listNew. 
          ELSE 
             tmp_list = s_tmp_listNew.

        IF togProc:CHECKED AND p_tmp_list NE "" THEN 
          IF tmp_list NE "" THEN 
             tmp_list = tmp_list + ",":U + p_tmp_list. 
          ELSE 
             tmp_list = p_tmp_list.

        IF togWO:CHECKED AND w_tmp_list NE "" THEN 
          IF tmp_list NE "" THEN 
             tmp_list = tmp_list + ",":U + w_tmp_list. 
          ELSE 
             tmp_list = w_tmp_list.
        
      END.

      ELSE DO:
        IF togContainer:CHECKED AND c_tmp_list NE "" THEN tmp_list = c_tmp_list.
        IF togSO:CHECKED AND s_tmp_list NE "" THEN 
          IF tmp_list NE "" THEN tmp_list = tmp_list + ",":U + s_tmp_list. 
          ELSE tmp_list = s_tmp_list.
        IF togProc:CHECKED AND p_tmp_list NE "" THEN 
          IF tmp_list NE "" THEN tmp_list = tmp_list + ",":U + p_tmp_list. 
          ELSE tmp_list = p_tmp_list.
        IF togWO:CHECKED AND w_tmp_list NE "" THEN 
          IF tmp_list NE "" THEN tmp_list = tmp_list + ",":U + w_tmp_list. 
          ELSE tmp_list = w_tmp_list.
      END.


      ASSIGN pos      = s_objects:LOOKUP(selected)
             selected = ENTRY((pos - NUM-ENTRIES(ext_tmp_list,CHR(10))),tmp_list).                          
    END.  
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Init d_newobj 
PROCEDURE Init :
/* -----------------------------------------------------------
  Purpose:     Initialize dialog.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
DEFINE VARIABLE custom_name AS CHARACTER NO-UNDO.
DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
DEFINE VARIABLE tmp_attr    AS CHARACTER NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  /* Load up Containers */
  FOR EACH _custom WHERE _custom._type = "Container":
    ASSIGN tmp_attr = LEFT-TRIM(_attr,CHR(10)).
    IF NUM-ENTRIES(tmp_attr,CHR(10)) > 0 THEN
      ASSIGN tmp_attr = ENTRY(1,tmp_attr,CHR(10)).
    FILE-INFO:FILE-NAME = TRIM(SUBSTRING(TRIM(tmp_attr),13,-1,"CHARACTER")).
    IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
      /* Build list of _custom._name without ampersands removed */
      ASSIGN c_lbl_listX = c_lbl_listX + CHR(10) + _custom._name
             c_lbl_listD = c_lbl_listD + (IF c_lbl_listD = "" then "" else ",") + IF _custom._static_object then "S" ELSE "D".
      RUN Fix_Custom_Name (INPUT _custom._name, OUTPUT custom_name).

      ASSIGN c_lbl_list = c_lbl_list + CHR(10) + custom_name
             c_tmp_list = c_tmp_list + "," + FILE-INFO:FULL-PATHNAME.
             
    END.
  END.
  
 
  /* Load up Procedures */
  FOR EACH _custom WHERE _custom._type = "Procedure" :
    FILE-INFO:FILE-NAME = TRIM(SUBSTRING(TRIM(_attr),13,-1,"CHARACTER")).
    IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
      ASSIGN p_lbl_listX = p_lbl_listX + CHR(10) + _custom._name.
      RUN Fix_Custom_Name (INPUT _custom._name, OUTPUT custom_name).
      ASSIGN p_lbl_list = p_lbl_list + CHR(10) + custom_name
             p_tmp_list = p_tmp_list + "," + FILE-INFO:FULL-PATHNAME.
    END.
  END.

  /* Load up 'NEW-SMARTOBJECTS' */
  FOR EACH _custom WHERE _custom._type = "SmartObject":  /* BY _custom._name  - removed for Issue 2493 */ 
    IF LOOKUP(_custom._name, s_lbl_list) > 0 THEN NEXT. /* already there */
    DO i = 1 TO NUM-ENTRIES(_custom._attr,CHR(10)):
      IF ENTRY(i,_custom._attr,CHR(10)) BEGINS "NEW-TEMPLATE" THEN DO:
        FILE-INFO:FILE-NAME = TRIM(SUBSTRING(TRIM(ENTRY(i,_custom._attr,CHR(10))),13,-1,"CHARACTER")).
        IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
          ASSIGN s_lbl_listX = s_lbl_listX + CHR(10) + _custom._name.
                 s_lbl_listD = s_lbl_listD + (IF s_lbl_listD = "" then "" else ",") + IF _custom._static_object then "S" ELSE "D".
          RUN Fix_Custom_Name (INPUT _custom._name, OUTPUT custom_name).
          ASSIGN s_lbl_list = s_lbl_list + CHR(10) + custom_name
                 s_tmp_list = s_tmp_list + "," + FILE-INFO:FULL-PATHNAME.
        END.
      END.
    END.      
  END.
  
  /* Load up 'NEW-WEBOBJECTS' */
  FOR EACH _custom WHERE _custom._type = "WebObject" BY _custom._name:
    IF LOOKUP(_custom._name, w_lbl_list) > 0 THEN NEXT. /* already there */
    DO i = 1 TO NUM-ENTRIES(_custom._attr,CHR(10)):
      IF ENTRY(i,_custom._attr,CHR(10)) BEGINS "NEW-TEMPLATE" THEN DO:
        FILE-INFO:FILE-NAME = TRIM(SUBSTRING(TRIM(ENTRY(i,_custom._attr,CHR(10))),13,-1,"CHARACTER":U)).
        IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
          ASSIGN w_lbl_listX = w_lbl_listX + CHR(10) + _custom._name .
          RUN Fix_Custom_Name (INPUT _custom._name, OUTPUT custom_name).
          ASSIGN w_lbl_list = w_lbl_list + CHR(10) + custom_name
                 w_tmp_list = w_tmp_list + ",":U + FILE-INFO:FULL-PATHNAME.
        END.
      END.
    END.      
  END.  /* FOR EACH _custom WHERE _type = "WebObject" */

  /* Remove leading delimiter from lists */
  ASSIGN c_lbl_list = LEFT-TRIM(c_lbl_list, CHR(10))
         c_lbl_listX = LEFT-TRIM(c_lbl_listX, CHR(10))
         c_tmp_list = LEFT-TRIM(c_tmp_list, ",":U)
         s_lbl_list = LEFT-TRIM(s_lbl_list, CHR(10))
         s_lbl_listX = LEFT-TRIM(s_lbl_listX, CHR(10))
         s_tmp_list = LEFT-TRIM(s_tmp_list, ",":U)
         p_lbl_list = LEFT-TRIM(p_lbl_list, CHR(10))
         p_lbl_listX = LEFT-TRIM(p_lbl_listX, CHR(10))
         p_tmp_list = LEFT-TRIM(p_tmp_list, ",":U)
         w_lbl_list = LEFT-TRIM(w_lbl_list, CHR(10))
         w_lbl_listX = LEFT-TRIM(w_lbl_listX, CHR(10))
         w_tmp_list = LEFT-TRIM(w_tmp_list, ",":U).

  /* Hide toggles and Show box if WebSpeed only is licensed */
  IF _AB_license EQ 2 THEN 
    ASSIGN togContainer:VISIBLE = FALSE
           togSO:VISIBLE        = FALSE
           togProc:VISIBLE      = FALSE
           togWO:VISIBLE        = FALSE
           rect-4:VISIBLE       = FALSE
           show-text:VISIBLE    = FALSE
           togDynamic:VISIBLE   = FALSE
           togStatic:VISIBLE    = FALSE.
  ELSE DO:
    IF _AB_license EQ 1 THEN
      ASSIGN togContainer:ROW       = togContainer:ROW + .3
             togContainer:VISIBLE   = TRUE
             togContainer:SENSITIVE = TRUE
             togSO:ROW              = togSO:ROW + .6
             togSO:VISIBLE          = TRUE
             togSO:SENSITIVE        = TRUE
             togProc:ROW            = togProc:ROW + .9
             togProc:VISIBLE        = TRUE
             togProc:SENSITIVE      = TRUE
             togWO:VISIBLE          = FALSE
             rect-4:VISIBLE         = TRUE
             show-text:VISIBLE      = TRUE
             .
    ELSE
      ASSIGN togContainer:VISIBLE   = TRUE
             togContainer:SENSITIVE = TRUE
             togSO:VISIBLE          = TRUE
             togSO:SENSITIVE        = TRUE
             togProc:VISIBLE        = TRUE
             togProc:SENSITIVE      = TRUE
             togWO:VISIBLE          = TRUE
             togWO:SENSITIVE        = TRUE
             rect-4:VISIBLE         = TRUE
             show-text:VISIBLE      = TRUE.
  /*  DISPLAY show-text.*/

    IF NOT enable-icf THEN
       ASSIGN togStatic:VISIBLE    = FALSE
              togDynamic:VISIBLE   = FALSE
              togStatic:SENSITIVE  = FALSE
              togDynamic:SENSITIVE = FALSE.
    ELSE
      ASSIGN togStatic:VISIBLE    = TRUE
             togDynamic:VISIBLE   = TRUE
             togStatic:SENSITIVE  = TRUE
             togDynamic:SENSITIVE = TRUE.
    /* Initialize the toggles */
    ASSIGN togContainer:CHECKED = _file_new_config MOD 2 = 1
           togSO:CHECKED        = _file_new_config MOD 4 > 1
           togProc:CHECKED      = _file_new_config MOD 8 > 3
           togWO:CHECKED        = _file_new_config MOD 16 > 7
           togDynamic:CHECKED   = _file_new_config MOD 32 > 15
           togStatic:CHECKED    = _file_new_config MOD 64 > 31.
    
     IF  _file_new_config <= 15 THEN
        ASSIGN togDynamic:CHECKED = TRUE
               togStatic:CHECKED  = TRUE.

    /* Desensitize toggles that have null lists */
    ASSIGN togContainer:SENSITIVE = c_lbl_list NE ""
           togSO:SENSITIVE        = s_lbl_list NE ""
           togProc:SENSITIVE      = p_lbl_list NE "".
    IF NOT togWO:HIDDEN THEN
      ASSIGN togWO:SENSITIVE      = w_lbl_list NE "".
         
  END. /* If the toggles are showing */
  IF togDynamic:VISIBLE = FALSE THEN
     ASSIGN rect-7:VISIBLE         = FALSE
            togContainer:ROW       = togContainer:ROW + 1.9
            togSO:ROW              = togSO:ROW + 1.9
            togProc:ROW            = togProc:ROW + 1.9
            togWO:ROW              = togWO:ROW + 1.9
            togDynamic:ROW         = togDynamic:ROW + 1.9
            togStatic:ROW          = togStatic:ROW + 1.9
            rect-4:ROW             = rect-4:ROW + 1.9
            rect-4:HEIGHT          = rect-4:HEIGHT - 1.9
            show-text:ROW          = show-text:ROW + 1.9.

  APPLY "ENTRY":U TO s_objects.

  /* Get the four values of the toggles from the registry here */  
  
  APPLY "VALUE-CHANGED" TO togContainer.


END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showProductModule d_newobj 
PROCEDURE showProductModule :
/*------------------------------------------------------------------------------
  Purpose:     Show the Product Module area
  Parameters:  <none>
  Notes:       Need to move most of the widgets down to make room.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE tmp-hdl AS HANDLE           NO-UNDO. /* a temporary handle */
  DEFINE VARIABLE incr    AS DECIMAL INIT 3.5 NO-UNDO. /* amt to use to make room */
  DEFINE VARIABLE pm-list AS CHARACTER        NO-UNDO. /* list of prod mod's */
  DEFINE VARIABLE cCurrentPM AS CHARACTER     NO-UNDO. 

  /* Increase the size of the dialog, and move all but the buttons 
   * and product module related fields down to uncover it 
   */
  ASSIGN 
    tmp-hdl         = FRAME d_newobj:HANDLE
    tmp-hdl:HEIGHT  = tmp-hdl:HEIGHT + incr
    tmp-hdl         = tmp-hdl:FIRST-CHILD  /* FIELD-GROUP  */
    tmp-hdl         = tmp-hdl:FIRST-CHILD. /* FIRST WIDGET */
  DO WHILE tmp-hdl <> ?:
    IF tmp-hdl:TYPE <> "BUTTON":U AND 
        NOT CAN-DO("RECT-6,productModule-Create,cb_productModule":U,tmp-hdl:NAME) THEN
      ASSIGN tmp-hdl:ROW = tmp-hdl:ROW + incr.
    tmp-hdl = tmp-hdl:NEXT-SIBLING. /* get the next widget */
  END.
  
  /* IZ 3195 POPULATE cb_productModule HERE...Calls function defined by Repository Manager */
  getRDMHandle().
  IF VALID-HANDLE(ghRepositoryDesignManager) THEN
    ASSIGN pm-list = DYNAMIC-FUNCTION("getproductModuleList":U IN ghRepositoryDesignManager,
                                   INPUT "product_module_Code":U,
                                   INPUT "product_module_code,product_module_description":U,
                                   INPUT "&1 // &2":U,
                                   INPUT CHR(3))   NO-ERROR.

  ASSIGN cb_productModule:DELIMITER       = CHR(3)
         cb_productModule:LIST-ITEM-PAIRS = pm-list.
  IF VALID-HANDLE(ghRepositoryDesignManager) THEN
    ASSIGN cCurrentPM       = DYNAMIC-FUNC("getCurrentProductModule":U IN ghRepositoryDesignManager) 
           cCurrentPM       = IF INDEX(cCurrentPM,"//":U) > 0 THEN SUBSTRING(cCurrentPM,1,INDEX(cCurrentPM,"//":U) - 1)
                                                        ELSE cCurrentPM
           cb_productModule = TRIM(cCurrentPM)
                                 /* Use the first entry if module is invalid */
           cb_productModule = IF ((cb_productModule = "") OR (LOOKUP(cb_productModule, pm-list,CHR(3)) = 0)) AND NUM-ENTRIES(pm-list,CHR(3)) > 1 
                              THEN  ENTRY(2,pm-list,CHR(3)) ELSE  cb_productModule
           
           NO-ERROR. /* current prod module */

  /* Make the product module section visible and enabled */
  ASSIGN
    productModule-Create:HIDDEN = FALSE
    productModule-Create:SENSITIVE = TRUE
    cb_productModule:HIDDEN     = FALSE
    RECT-6:HIDDEN               = FALSE.
  DISPLAY RECT-6 productModule-Create cb_productModule WITH FRAME d_newobj.

  /* IZ 3191 Set the checked state of the Create in PM option based on the PM 
     list being empty or not. */
  ASSIGN productModule-Create:CHECKED = (cb_productModule:NUM-ITEMS > 0) NO-ERROR.

  /* Change UI and PM enable state based on "Create in PM" check box. */
  RUN changeProductModuleState (INPUT productModule-Create:CHECKED).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRDMHandle d_newobj 
FUNCTION getRDMHandle RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

