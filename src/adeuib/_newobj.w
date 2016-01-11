&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
/* Procedure Description
"UIB's NEW dialog-box"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME d_newobj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS d_newobj 
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
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
{adeuib/custwidg.i} /* _custom & _palette_item temp-table defs */
{adeuib/sharvars.i} /* UIB shared variables                    */
{adeuib/uibhlp.i}   /* Help String Definitions                 */

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE OUTPUT PARAMETER selected AS CHARACTER NO-UNDO. /* file to use   */

DEFINE VAR Type_Container   AS CHARACTER INIT "Containers"      NO-UNDO.
DEFINE VAR Type_SmartObject AS CHARACTER INIT "SmartObjects"    NO-UNDO.
DEFINE VAR Type_Procedure   AS CHARACTER INIT "Procedures"      NO-UNDO.
DEFINE VAR Type_WebObject   AS CHARACTER INIT "WebObject"       NO-UNDO.
DEFINE VAR Type_All         AS CHARACTER INIT "All"             NO-UNDO.

DEFINE VAR c_lbl_list   AS CHARACTER NO-UNDO. /* container label list   */
DEFINE VAR c_tmp_list   AS CHARACTER NO-UNDO. /* container template list */
DEFINE VAR ext_tmp_list AS CHARACTER NO-UNDO. /* external template file list */
DEFINE VAR p_lbl_list   AS CHARACTER NO-UNDO. /* Procedure label list   */
DEFINE VAR p_tmp_list   AS CHARACTER NO-UNDO. /* Procedure template list */
DEFINE VAR ret_value    AS LOGICAL   NO-UNDO.
DEFINE VAR s_lbl_list   AS CHARACTER NO-UNDO. /* SO label list          */
DEFINE VAR s_tmp_list   AS CHARACTER NO-UNDO. /* SO template list       */
DEFINE VAR w_lbl_list   AS CHARACTER NO-UNDO. /* WebObject label list   */
DEFINE VAR w_tmp_list   AS CHARACTER NO-UNDO. /* WebObject template list */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME d_newobj

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b_Ok s_objects b_Cancel b_Template b_Help ~
e_descr2 e_descr1 RECT-3 RECT-4 RECT-5 
&Scoped-Define DISPLAYED-OBJECTS s_objects e_descr2 e_descr1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
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

DEFINE VARIABLE e_descr1 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 53 BY 4.52
     FONT 4 NO-UNDO.

DEFINE VARIABLE e_descr2 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 54 BY 4.52
     FONT 4 NO-UNDO.

DEFINE VARIABLE Show-text AS CHARACTER FORMAT "X(256)":U INITIAL " Show" 
      VIEW-AS TEXT 
     SIZE 7 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 56 BY 5.29.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 19 BY 4.43.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 36 BY 10.

DEFINE VARIABLE s_objects AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 34 BY 9.38 NO-UNDO.

DEFINE VARIABLE togContainer AS LOGICAL INITIAL no 
     LABEL "&Containers" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.6 BY .81 NO-UNDO.

DEFINE VARIABLE togProc AS LOGICAL INITIAL no 
     LABEL "&Procedures" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.6 BY .81 NO-UNDO.

DEFINE VARIABLE togSO AS LOGICAL INITIAL no 
     LABEL "&SmartObjects" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.6 BY .81 NO-UNDO.

DEFINE VARIABLE togWO AS LOGICAL INITIAL no 
     LABEL "&WebObjects" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.2 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME d_newobj
     b_Ok AT ROW 1.52 COL 41
     s_objects AT ROW 1.86 COL 3 NO-LABEL
     b_Cancel AT ROW 2.81 COL 41
     b_Template AT ROW 4.1 COL 41
     b_Help AT ROW 5.38 COL 41
     togContainer AT ROW 7.57 COL 39.8
     togSO AT ROW 8.52 COL 39.8
     togProc AT ROW 9.48 COL 39.8
     togWO AT ROW 10.43 COL 39.8
     e_descr2 AT ROW 12.24 COL 3 HELP
          "Description of object" NO-LABEL
     e_descr1 AT ROW 12.24 COL 3 HELP
          "Description of object" NO-LABEL
     Show-text AT ROW 6.76 COL 40 COLON-ALIGNED NO-LABEL
     RECT-3 AT ROW 11.86 COL 2
     RECT-4 AT ROW 7.1 COL 39
     RECT-5 AT ROW 1.52 COL 2
     " Objects" VIEW-AS TEXT
          SIZE 8.8 BY .76 AT ROW 1.1 COL 2.8
     " Description" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 11.52 COL 3
     SPACE(43.85) SKIP(5.31)
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
                                                                        */
ASSIGN 
       FRAME d_newobj:SCROLLABLE       = FALSE.

ASSIGN 
       e_descr1:READ-ONLY IN FRAME d_newobj        = TRUE.

ASSIGN 
       e_descr2:READ-ONLY IN FRAME d_newobj        = TRUE.

ASSIGN 
       RECT-4:HIDDEN IN FRAME d_newobj           = TRUE.

/* SETTINGS FOR FILL-IN Show-text IN FRAME d_newobj
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       Show-text:HIDDEN IN FRAME d_newobj           = TRUE.

ASSIGN 
       s_objects:HIDDEN IN FRAME d_newobj           = TRUE.

/* SETTINGS FOR TOGGLE-BOX togContainer IN FRAME d_newobj
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       togContainer:HIDDEN IN FRAME d_newobj           = TRUE.

/* SETTINGS FOR TOGGLE-BOX togProc IN FRAME d_newobj
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       togProc:HIDDEN IN FRAME d_newobj           = TRUE.

/* SETTINGS FOR TOGGLE-BOX togSO IN FRAME d_newobj
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       togSO:HIDDEN IN FRAME d_newobj           = TRUE.

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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d_newobj d_newobj
ON GO OF FRAME d_newobj /* New */
DO:  
  DEFINE VARIABLE l       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE i       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE so-type AS CHARACTER NO-UNDO.
  DEFINE VARIABLE fixname AS CHARACTER NO-UNDO.
  
  FIND _palette_item WHERE _palette_item._name = s_objects:SCREEN-VALUE NO-ERROR.
  IF AVAILABLE (_palette_item) THEN DO:
    IF NUM-DBS = 0 AND _palette_item._dbconnect THEN DO:
      RUN adecomm/_dbcnnct.p (
        INPUT "You must have at least one connected database to create a " +
               _palette_item._name 
              + (IF 
               SUBSTRING(_palette_item._name,
                         LENGTH(_palette_item._name) - LENGTH("Object":U) + 1) = "Object":U
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
              + (IF 
               SUBSTRING(_palette_item._name,
                         LENGTH(_palette_item._name) - LENGTH("Object":U) + 1) = "Object":U
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
END.

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
     ASSIGN s_objects:SCREEN-VALUE IN FRAME {&FRAME-NAME} = s_objects:ENTRY(1). 
     RUN Get_Descr.
  END.
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

  IF _AB_license = 2 THEN
    ASSIGN tmp-string =
           (IF ext_tmp_list NE "" THEN ext_tmp_list + CHR(10) ELSE "") +
           (IF c_lbl_list   NE "" THEN c_lbl_list   + CHR(10) ELSE "") + 
           (IF s_lbl_list   NE "" THEN s_lbl_list   + CHR(10) ELSE "") + 
           (IF p_lbl_list   NE "" THEN p_lbl_list   + CHR(10) ELSE "") + 
           (IF w_lbl_list   NE "" THEN w_lbl_list             ELSE "")
          s_objects:LIST-ITEMS = TRIM(tmp-string, CHR(10)).
  ELSE DO:
    IF togContainer:CHECKED AND togSO:CHECKED AND togProc:CHECKED AND 
       togWO:HIDDEN = FALSE and togWO:CHECKED THEN /* ALL - show everything */
      ASSIGN s_objects:LIST-ITEMS = 
           (IF ext_tmp_list NE "" THEN ext_tmp_list + CHR(10) ELSE "") +
           (IF c_lbl_list   NE "" THEN c_lbl_list   + CHR(10) ELSE "") + 
           (IF s_lbl_list   NE "" THEN s_lbl_list   + CHR(10) ELSE "") + 
           (IF p_lbl_list   NE "" THEN p_lbl_list   + CHR(10) ELSE "") + 
           (IF w_lbl_list   NE "" THEN w_lbl_list             ELSE "").
    ELSE DO:
      ASSIGN tmp-string = RIGHT-TRIM((IF ext_tmp_list NE "" THEN ext_tmp_list + CHR(10) ELSE "") +
                          (IF togContainer:CHECKED AND c_lbl_list NE "" THEN c_lbl_list + CHR(10) ELSE "") +
                          (IF togSO:CHECKED AND s_lbl_list NE ""        THEN s_lbl_list + CHR(10) ELSE "") +
                          (IF togProc:CHECKED AND p_lbl_list NE ""      THEN p_lbl_list + CHR(10) ELSE "") +
                          (IF togWO:CHECKED AND w_lbl_list NE ""        THEN w_lbl_list ELSE ""), CHR(10))
             s_objects:LIST-ITEMS = tmp-string.
    END.
    ASSIGN _file_new_config = 16 + /* 16 means that it has been changed */
                              (IF togContainer:CHECKED THEN 1 ELSE 0) +
                              (IF togSO:CHECKED        THEN 2 ELSE 0) +
                              (IF togProc:CHECKED      THEN 4 ELSE 0) +
                              (IF togWO:CHECKED        THEN 8 ELSE 0).
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
  DISPLAY s_objects e_descr2 e_descr1 
      WITH FRAME d_newobj.
  ENABLE b_Ok s_objects b_Cancel b_Template b_Help e_descr2 e_descr1 RECT-3 
         RECT-4 RECT-5 
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
  DEFINE VARIABLE pos      AS INTEGER   NO-UNDO. /* item's position in list */
  DEFINE VARIABLE tmp_list AS CHARACTER NO-UNDO. /* temp list of templates */
  
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

DO WITH FRAME {&FRAME-NAME}:
  /* Load up Containers */
  FOR EACH _custom WHERE _custom._type = "Container":
    FILE-INFO:FILE-NAME = TRIM(SUBSTRING(TRIM(_attr),13,-1,"CHARACTER")).
    IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
      RUN Fix_Custom_Name (INPUT _custom._name, OUTPUT custom_name).
      ASSIGN c_lbl_list = c_lbl_list + CHR(10) + custom_name
             c_tmp_list = c_tmp_list + "," + FILE-INFO:FULL-PATHNAME.
    END.
  END.
 
  /* Load up Procedures */
  FOR EACH _custom WHERE _custom._type = "Procedure" :
    FILE-INFO:FILE-NAME = TRIM(SUBSTRING(TRIM(_attr),13,-1,"CHARACTER")).
    IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
      RUN Fix_Custom_Name (INPUT _custom._name, OUTPUT custom_name).
      ASSIGN p_lbl_list = p_lbl_list + CHR(10) + custom_name
             p_tmp_list = p_tmp_list + "," + FILE-INFO:FULL-PATHNAME.
    END.
  END.

  /* Load up 'NEW-SMARTOBJECTS' */
  FOR EACH _custom WHERE _custom._type = "SmartObject" BY _custom._name:
    IF LOOKUP(_custom._name, s_lbl_list) > 0 THEN NEXT. /* already there */
    DO i = 1 TO NUM-ENTRIES(_custom._attr,CHR(10)):
      IF ENTRY(i,_custom._attr,CHR(10)) BEGINS "NEW-TEMPLATE" THEN DO:
        FILE-INFO:FILE-NAME = TRIM(SUBSTRING(TRIM(ENTRY(i,_custom._attr,CHR(10))),13,-1,"CHARACTER")).
        IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
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
          RUN Fix_Custom_Name (INPUT _custom._name, OUTPUT custom_name).
          ASSIGN w_lbl_list = w_lbl_list + CHR(10) + custom_name
                 w_tmp_list = w_tmp_list + ",":U + FILE-INFO:FULL-PATHNAME.
        END.
      END.
    END.      
  END.  /* FOR EACH _custom WHERE _type = "WebObject" */

  /* Remove leading delimiter from lists */
  ASSIGN c_lbl_list = LEFT-TRIM(c_lbl_list, CHR(10))
         c_tmp_list = LEFT-TRIM(c_tmp_list, ",":U)
         s_lbl_list = LEFT-TRIM(s_lbl_list, CHR(10))
         s_tmp_list = LEFT-TRIM(s_tmp_list, ",":U)
         p_lbl_list = LEFT-TRIM(p_lbl_list, CHR(10))
         p_tmp_list = LEFT-TRIM(p_tmp_list, ",":U)
         w_lbl_list = LEFT-TRIM(w_lbl_list, CHR(10))
         w_tmp_list = LEFT-TRIM(w_tmp_list, ",":U).

  /* Hide toggles and Show box if WebSpeed only is licensed */
  IF _AB_license EQ 2 THEN 
    ASSIGN togContainer:VISIBLE = FALSE
           togSO:VISIBLE        = FALSE
           togProc:VISIBLE      = FALSE
           togWO:VISIBLE        = FALSE
           rect-4:VISIBLE       = FALSE
           show-text:VISIBLE    = FALSE.
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
             show-text:VISIBLE      = TRUE.
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
    DISPLAY show-text.

    /* Initialize the toggles */
    ASSIGN togContainer:CHECKED = _file_new_config MOD 2 = 1
           togSO:CHECKED        = _file_new_config MOD 4 > 1
           togProc:CHECKED      = _file_new_config MOD 8 > 3
           togWO:CHECKED        = _file_new_config > 7.

    /* Desensitize toggles that have null lists */
    ASSIGN togContainer:SENSITIVE = c_lbl_list NE ""
           togSO:SENSITIVE        = s_lbl_list NE ""
           togProc:SENSITIVE      = p_lbl_list NE "".
    IF NOT togWO:HIDDEN THEN
      ASSIGN togWO:SENSITIVE      = w_lbl_list NE "".
         
  END. /* If the toggles are showing */
  /* Get the four values of the toggles from the registry here */  
  APPLY "VALUE-CHANGED" TO togContainer.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

