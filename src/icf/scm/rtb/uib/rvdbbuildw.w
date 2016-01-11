&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          rtb              PROGRESS
          icfdb             PROGRESS
          rvdb             PROGRESS
*/
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

  File: rvdbbuildw.w

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

DEFINE TEMP-TABLE ttSelectedObjects NO-UNDO
FIELD cRTBObjectName      AS CHARACTER
FIELD cRVObjectName       AS CHARACTER
FIELD cWorkspace          AS CHARACTER
FIELD cRTBProductModule   AS CHARACTER
FIELD cRVProductModule    AS CHARACTER
FIELD iObjectVersion      AS INTEGER
FIELD lFixExistingData    AS LOGICAL
FIELD lRVOnly             AS LOGICAL
FIELD cErrorText          AS CHARACTER
INDEX idxMain             IS PRIMARY UNIQUE cRTBObjectName
.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrBrowse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES rtb_object gsc_product_module ~
rvm_configuration_item rvt_item_version

/* Definitions for BROWSE BrBrowse                                      */
&Scoped-define FIELDS-IN-QUERY-BrBrowse rtb_object.pmod ~
rvt_item_version.scm_object_name rvt_item_version.item_version_number ~
gsc_product_module.product_module_code rvt_item_version.item_description 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrBrowse 
&Scoped-define OPEN-QUERY-BrBrowse OPEN QUERY BrBrowse FOR EACH rtb_object ~
      WHERE rtb_object.pmod BEGINS coProductModule ~
 AND rtb_object.obj-type = "PCODE":U ~
 AND rtb_object.wspace-id = coWorkSpace NO-LOCK, ~
      FIRST gsc_product_module WHERE gsc_product_module.product_module_code = rtb_object.pmod NO-LOCK, ~
      FIRST rvm_configuration_item WHERE rvm_configuration_item.scm_object_name BEGINS REPLACE(rtb_object.OBJECT,".ado":U,"":U) ~
  AND rvm_configuration_item.configuration_type = 'RYCSO' ~
  AND rvm_configuration_item.product_module_obj = gsc_product_module.product_module_obj ~
 NO-LOCK, ~
      FIRST rvt_item_version WHERE rvt_item_version.scm_object_name = rvm_configuration_item.scm_object_name ~
  AND rvt_item_version.item_version_number = rtb_object.version ~
  AND rvt_item_version.product_module_obj = rvm_configuration_item.product_module_obj NO-LOCK ~
    BY rtb_object.pmod ~
       BY rtb_object.obj-type ~
        BY rtb_object.object INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrBrowse rtb_object gsc_product_module ~
rvm_configuration_item rvt_item_version
&Scoped-define FIRST-TABLE-IN-QUERY-BrBrowse rtb_object
&Scoped-define SECOND-TABLE-IN-QUERY-BrBrowse gsc_product_module
&Scoped-define THIRD-TABLE-IN-QUERY-BrBrowse rvm_configuration_item
&Scoped-define FOURTH-TABLE-IN-QUERY-BrBrowse rvt_item_version


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coWorkspace buRefresh coProductModule ~
BrBrowse buAllSelect buAllDeselect toFixExistingData toRVOnly buOK buCancel 
&Scoped-Define DISPLAYED-OBJECTS coWorkspace coProductModule ~
toFixExistingData toRVOnly 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buAllDeselect DEFAULT 
     LABEL "&Deselect All" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buAllSelect DEFAULT 
     LABEL "Select &All" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buCancel AUTO-END-KEY DEFAULT 
     LABEL "&Exit" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buOK DEFAULT 
     LABEL "&Re-Assign Selected Objects" 
     SIZE 62.4 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buRefresh 
     LABEL "Refres&h" 
     SIZE 15 BY 1.14 TOOLTIP "Refresh list of objects"
     BGCOLOR 8 .

DEFINE VARIABLE coProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 8
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 40 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE coWorkspace AS CHARACTER FORMAT "X(256)":U 
     LABEL "Workspace" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 8
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 40 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE toFixExistingData AS LOGICAL INITIAL yes 
     LABEL "Also Re-build Existing Objects" 
     VIEW-AS TOGGLE-BOX
     SIZE 44.4 BY .81 TOOLTIP "Rebuild SmartObjects in ICFDB even if they already exist" NO-UNDO.

DEFINE VARIABLE toRVOnly AS LOGICAL INITIAL yes 
     LABEL "Only fix RV Data" 
     VIEW-AS TOGGLE-BOX
     SIZE 44.4 BY .81 TOOLTIP "Only fix RV workspace item records NOT repository data IN RVDB" NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrBrowse FOR 
      rtb_object, 
      gsc_product_module, 
      rvm_configuration_item, 
      rvt_item_version SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrBrowse C-Win _STRUCTURED
  QUERY BrBrowse NO-LOCK DISPLAY
      rtb_object.pmod COLUMN-LABEL "RTB Module" FORMAT "x(8)":U
            WIDTH 13
      rvt_item_version.scm_object_name FORMAT "X(30)":U
      rvt_item_version.item_version_number COLUMN-LABEL "Version" FORMAT ">>>>>9":U
            WIDTH 8
      gsc_product_module.product_module_code COLUMN-LABEL "RV Module" FORMAT "X(10)":U
      rvt_item_version.item_description COLUMN-LABEL "Object Description" FORMAT "X(35)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 80 BY 14.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     coWorkspace AT ROW 1.48 COL 10.8
     buRefresh AT ROW 2.71 COL 69.4
     coProductModule AT ROW 2.91 COL 6.8
     BrBrowse AT ROW 4.33 COL 5
     buAllSelect AT ROW 19.1 COL 5
     buAllDeselect AT ROW 19.1 COL 23
     toFixExistingData AT ROW 19.29 COL 41
     toRVOnly AT ROW 20.14 COL 41
     buOK AT ROW 21.76 COL 5
     buCancel AT ROW 21.76 COL 70.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.4 BY 22.33
         DEFAULT-BUTTON buOK CANCEL-BUTTON buCancel.


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
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert window title>"
         HEIGHT             = 22.33
         WIDTH              = 90.4
         MAX-HEIGHT         = 24.14
         MAX-WIDTH          = 141.8
         VIRTUAL-HEIGHT     = 24.14
         VIRTUAL-WIDTH      = 141.8
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
/* BROWSE-TAB BrBrowse coProductModule DEFAULT-FRAME */
ASSIGN 
       BrBrowse:NUM-LOCKED-COLUMNS IN FRAME DEFAULT-FRAME     = 2.

/* SETTINGS FOR COMBO-BOX coProductModule IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX coWorkspace IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrBrowse
/* Query rebuild information for BROWSE BrBrowse
     _TblList          = "rtb.rtb_object,icfdb.gsc_product_module WHERE rtb.rtb_object ...,RVDB.rvm_configuration_item WHERE rtb.rtb_object ...,RVDB.rvt_item_version WHERE RVDB.rvm_configuration_item ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, FIRST, FIRST"
     _OrdList          = "rtb.rtb_object.pmod|yes,rtb.rtb_object.obj-type|yes,rtb.rtb_object.object|yes"
     _Where[1]         = "rtb.rtb_object.pmod BEGINS coProductModule
 AND rtb.rtb_object.obj-type = ""PCODE"":U
 AND rtb.rtb_object.wspace-id = coWorkSpace"
     _JoinCode[2]      = "icfdb.gsc_product_module.product_module_code = rtb.rtb_object.pmod"
     _JoinCode[3]      = "RVDB.rvm_configuration_item.scm_object_name BEGINS REPLACE(rtb_object.OBJECT,"".ado"":U,"""":U)
  AND RVDB.rvm_configuration_item.configuration_type = 'RYCSO'
  AND RVDB.rvm_configuration_item.product_module_obj = gsc_product_module.product_module_obj
"
     _JoinCode[4]      = "RVDB.rvt_item_version.scm_object_name = RVDB.rvm_configuration_item.scm_object_name
  AND RVDB.rvt_item_version.item_version_number = rtb_object.version
  AND RVDB.rvt_item_version.product_module_obj = RVDB.rvm_configuration_item.product_module_obj"
     _FldNameList[1]   > rtb.rtb_object.pmod
"rtb_object.pmod" "RTB Module" ? "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" ""
     _FldNameList[2]   > RVDB.rvt_item_version.scm_object_name
"rvt_item_version.scm_object_name" ? "X(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[3]   > RVDB.rvt_item_version.item_version_number
"rvt_item_version.item_version_number" "Version" ">>>>>9" "integer" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" ""
     _FldNameList[4]   > icfdb.gsc_product_module.product_module_code
"gsc_product_module.product_module_code" "RV Module" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[5]   > RVDB.rvt_item_version.item_description
"rvt_item_version.item_description" "Object Description" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is NOT OPENED
*/  /* BROWSE BrBrowse */
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


&Scoped-define SELF-NAME buAllDeselect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAllDeselect C-Win
ON CHOOSE OF buAllDeselect IN FRAME DEFAULT-FRAME /* Deselect All */
DO:

    RUN rowsAllDeselect.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAllSelect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAllSelect C-Win
ON CHOOSE OF buAllSelect IN FRAME DEFAULT-FRAME /* Select All */
DO:

    RUN rowsAllSelect.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel C-Win
ON CHOOSE OF buCancel IN FRAME DEFAULT-FRAME /* Exit */
DO:

    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOK C-Win
ON CHOOSE OF buOK IN FRAME DEFAULT-FRAME /* Re-Assign Selected Objects */
DO:

    DEFINE VARIABLE lChoice AS LOGICAL NO-UNDO.

    ASSIGN
        coWorkspace
        coProductModule
        toFixExistingData
        toRVOnly
        lChoice = NO
        .

    IF toRVOnly THEN
    DO:
      MESSAGE "You have selected to only fix the workspace item records in the" SKIP
              "RVDB version database to match the current versions in Roundtable." SKIP
              "The utility will also ensure the product module for the selected" SKIP
              "objects match the product modules in Roundtable." SKIP(1)
              "This option is useful if you have copied an ICFDB Repository database" SKIP
              "from an existing workspace to a new empty workspace, following an" SKIP 
              "import - to fix the issue where importing an empty database does not" SKIP 
              "update the repository due to the repository database not being connected." SKIP 
              "In this case, the correct objects exist in Roundtable, but the Version" SKIP 
              "database RVDB does not have a record of the object versions in the workspace" SKIP(1)
              "Do you wish to process the data fix for the selected objects?" SKIP(1)
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
              UPDATE lChoice.
    END.
    ELSE
    DO:
      MESSAGE "Do you wish to rebuild the repository data in ICFDB database and" SKIP
              "update the RVDB version data for the selected objects." SKIP(1)
              "This will fix the product modules in the RVDB database to match" SKIP
              "the RTB product modules. It will update the workspace item table in" SKIP
              "the RVDB database to reflect the correct RTB object versions in the" SKIP
              "workspace. It will create any objects missing from the ICFDB database" SKIP
              "using the information from the RVDB version database." SKIP
              "Finally it will recreate any existing objects in the ICFDB database" SKIP
              "from the information in the RVDB database, if you specified to also" SKIP
              "rebuild existing objects" SKIP(1)
              "Before running this utility, you should be confident that the information" SKIP
              "in the RVDB version database is accurate and up-to-date." SKIP(1)
              "The effects of this on the selected objects are similar to doing" SKIP
              "an assignment of an object version into the workdpace. This is just" SKIP
              "a lot faster as it allows you do reassign many objects at once" SKIP(1)
              "Continue?" SKIP
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
              UPDATE lChoice.
    END.

    IF lChoice = YES
    THEN
        RUN fixData.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRefresh C-Win
ON CHOOSE OF buRefresh IN FRAME DEFAULT-FRAME /* Refresh */
DO:
  RUN buildObjectBrw.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coProductModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProductModule C-Win
ON VALUE-CHANGED OF coProductModule IN FRAME DEFAULT-FRAME /* Product Module */
DO:

    ASSIGN
        coProductModule.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coWorkspace
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coWorkspace C-Win
ON VALUE-CHANGED OF coWorkspace IN FRAME DEFAULT-FRAME /* Workspace */
DO:

    ASSIGN
        coWorkSpace.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toFixExistingData
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toFixExistingData C-Win
ON VALUE-CHANGED OF toFixExistingData IN FRAME DEFAULT-FRAME /* Also Re-build Existing Objects */
DO:

    ASSIGN
        toFixExistingData.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toRVOnly
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toRVOnly C-Win
ON VALUE-CHANGED OF toRVOnly IN FRAME DEFAULT-FRAME /* Only fix RV Data */
DO:

    ASSIGN
        toRVOnly.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrBrowse
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN
    CURRENT-WINDOW                = {&WINDOW-NAME} 
    THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

RUN mainSetup.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.

    IF NOT THIS-PROCEDURE:PERSISTENT
    THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildCoProductModule C-Win 
PROCEDURE buildCoProductModule :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
            coWorkSpace          = grtb-wspace-id
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN 
            coProductModule:LIST-ITEMS = "":U
            .

        FOR EACH gsc_product_module NO-LOCK BY gsc_product_module.product_module_code
            :
            coProductModule:ADD-LAST(LC(gsc_product_module.product_module_code)).
        END.

        coProductModule:ADD-FIRST(LC("":U)).

        IF  coProductModule:LIST-ITEMS <> "":U
        AND coProductModule:LIST-ITEMS <> ? 
        THEN
            ASSIGN
                coProductModule:SCREEN-VALUE = ENTRY(1,coProductModule:LIST-ITEMS)
                NO-ERROR
                .
        ASSIGN
          coProductModule.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildCoWorkspace C-Win 
PROCEDURE buildCoWorkspace :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
            coWorkSpace          = grtb-wspace-id
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN 
            coWorkspace:LIST-ITEMS = "":U
            .

        FOR EACH rvm_workspace NO-LOCK BY rvm_workspace.workspace_code
            :
            coWorkspace:ADD-LAST(LC(rvm_workspace.workspace_code)).
        END.

        IF  coWorkspace:LIST-ITEMS <> "":U
        AND coWorkspace:LIST-ITEMS <> ? 
        THEN
            ASSIGN
                coWorkspace:SCREEN-VALUE = ENTRY(1,coWorkspace:LIST-ITEMS)
                .
        ASSIGN
          coWorkspace.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildObjectBrw C-Win 
PROCEDURE buildObjectBrw :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    SESSION:SET-WAIT-STATE("general":U).

    {&OPEN-QUERY-{&BROWSE-NAME}}

    SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildObjectTT C-Win 
PROCEDURE buildObjectTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttSelectedObjects.

    DEFINE VARIABLE iLoopRows   AS INTEGER      NO-UNDO.
    DEFINE VARIABLE iLoopCols   AS INTEGER      NO-UNDO.
    DEFINE VARIABLE lBrwReturn  AS LOGICAL      NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN
          toFixExistingData
          coWorkspace
          coProductModule
          .

        DO iLoopRows = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:

            lBrwReturn = {&BROWSE-NAME}:FETCH-SELECTED-ROW(iLoopRows).

            GET CURRENT {&BROWSE-NAME} NO-LOCK.
            FIND FIRST ttSelectedObjects EXCLUSIVE-LOCK
                WHERE ttSelectedObjects.cRTBObjectName = rtb_object.OBJECT
                NO-ERROR.
            IF NOT AVAILABLE ttSelectedObjects
            THEN
                CREATE ttSelectedObjects.

            ASSIGN
              ttSelectedObjects.cRTBObjectName      = rtb_object.OBJECT
              ttSelectedObjects.cRVObjectName       = rvt_item_version.scm_object_name
              ttSelectedObjects.cWorkspace          = coWorkspace 
              ttSelectedObjects.cRTBProductModule   = rtb_object.pmod
              ttSelectedObjects.cRVProductModule    = gsc_product_module.product_module_code 
              ttSelectedObjects.iObjectVersion      = rvt_item_version.ITEM_version_number
              ttSelectedObjects.lFixExistingData    = toFixExistingData
              ttSelectedObjects.lRVOnly             = toRVOnly 
              ttSelectedObjects.cErrorText          = "":U
              .                

        END.

    END.

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
  DISPLAY coWorkspace coProductModule toFixExistingData toRVOnly 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE coWorkspace buRefresh coProductModule BrBrowse buAllSelect 
         buAllDeselect toFixExistingData toRVOnly buOK buCancel 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fixData C-Win 
PROCEDURE fixData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       

------------------------------------------------------------------------------*/

    DEFINE VARIABLE hRvBase     AS HANDLE       NO-UNDO.
    DEFINE VARIABLE cErrorValue AS CHARACTER    NO-UNDO.

    EMPTY TEMP-TABLE ttSelectedObjects.
    RUN buildObjectTT (INPUT-OUTPUT TABLE ttSelectedObjects).

    FIND FIRST ttSelectedObjects NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ttSelectedObjects
    THEN DO:
        MESSAGE
            "*** No Records were found to process ":U
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN.
    END.

    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN PROCESS EVENTS.

    RUN rv/prc/rvdbbuildp.p (INPUT-OUTPUT TABLE ttSelectedObjects,
                             OUTPUT cErrorValue).

    IF cErrorValue <> "":U THEN ASSIGN cErrorValue = cErrorValue + CHR(10). 
    FOR EACH ttSelectedObjects
       WHERE ttSelectedObjects.cErrorText <> "":U:
      ASSIGN
        cErrorValue = cErrorValue + ttSelectedObjects.cErrorText. 
    END.

    IF REPLACE(cErrorValue,"OK":U,"":U) <> "":U
    THEN
        MESSAGE
            "*** ERROR occured while fixing data : ":U + CHR(10) + cErrorValue
            VIEW-AS ALERT-BOX INFORMATION.

    IF  SESSION:SET-WAIT-STATE("":U) THEN PROCESS EVENTS.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mainSetup C-Win 
PROCEDURE mainSetup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN
            {&WINDOW-NAME}:TITLE = "Dynamics -  ICFDB / RVDB Data Fix":U
            .

        IF NOT CONNECTED("ICFDB")
        OR NOT CONNECTED("RVDB")
        THEN DO:

            IF NOT CONNECTED("ICFDB")
            THEN
                MESSAGE
                    "*** Failure : Repository Database (ICFDB) not connected ":U
                    VIEW-AS ALERT-BOX INFORMATION.
            IF NOT CONNECTED("RVDB")
            THEN
                MESSAGE
                    "*** Failure : Versioning Database (RVDB) not connected ":U
                    VIEW-AS ALERT-BOX INFORMATION.

            DISABLE
                buOK.

        END.
        ELSE DO:
            ENABLE
                buOK.
        END.

      ASSIGN
        toFixExistingData = YES
        toRVOnly = NO
        .
      DISPLAY
        toFixExistingData
        toRVOnly
        .

    END.

    RUN buildCoWorkspace.
    RUN buildCoProductModule.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowsAllDeselect C-Win 
PROCEDURE rowsAllDeselect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lBrwReturn  AS LOGICAL      NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        lBrwReturn = {&BROWSE-NAME}:DESELECT-ROWS().

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowsAllSelect C-Win 
PROCEDURE rowsAllSelect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lBrwReturn  AS LOGICAL      NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        lBrwReturn = {&BROWSE-NAME}:SELECT-ALL().

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

