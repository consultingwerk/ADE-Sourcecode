&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/***********************************************************************
* Copyright (C) 2000-2012 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------

  File: _newobj.w
  
  Description: New object dialog for UIB
               non-modal version  NOT IN USE see notes
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

         Notes: non-modal version of adeuib/_newobj.w
                NOT IN USE
                Added during early prototype of ab pds integration
                Issues: Wrong size in Dynamics 
                        Does not show data in all cases on 3rd or 4th run 
               
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
{adecomm/oeideservice.i}
{adeuib/custwidg.i}   /* _custom & _palette_item temp-table defs */
{adeuib/sharvars.i}   /* UIB shared variables                    */
{adeuib/uibhlp.i}     /* Help String Definitions                 */
{adeuib/ttobject.i}   /* _ryobject temp-table definition for icf */
{src/adm2/globals.i}  /* Icf global vars                         */

 
DEFINE NEW GLOBAL SHARED VARIABLE OEIDE_NewWindow     AS HANDLE  NO-UNDO.

/* ***************************  Definitions  ************************** */

DEFINE VAR Type_Container   AS CHARACTER INIT "Containers"      NO-UNDO.
DEFINE VAR Type_SmartObject AS CHARACTER INIT "SmartObjects"    NO-UNDO.
DEFINE VAR Type_Procedure   AS CHARACTER INIT "Procedures"      NO-UNDO.
DEFINE VAR Type_WebObject   AS CHARACTER INIT "WebObject"       NO-UNDO.
DEFINE VAR Type_All         AS CHARACTER INIT "All"             NO-UNDO.

DEFINE VAR selected         AS CHARACTER NO-UNDO.
DEFINE VAR lWaitingForOpen  AS LOGICAL NO-UNDO.
DEFINE VAR currentWindow    as handle NO-UNDO.
DEFINE VAR OEIDEHwnd        as integer no-undo.

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
DEFINE VAR h_design     AS HANDLE NO-UNDO.
DEFINE TEMP-TABLE ttPM NO-UNDO
  FIELD PMCode          AS CHARACTER.

DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-4 RECT-5 RECT-7 RECTbutton ~
s_objects b_Template b_Help e_descr1 e_descr2 descr-text 
&Scoped-Define DISPLAYED-OBJECTS s_objects e_descr1 e_descr2 Show-text ~
descr-text 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRDMHandle C-Win 
FUNCTION getRDMHandle RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_Cancel 
     LABEL "Cancel" 
     SIZE 16.6 BY 1.14.

DEFINE BUTTON b_Help 
     LABEL "&Help" 
     SIZE 16.6 BY 1.14.

DEFINE BUTTON b_Ok AUTO-GO 
     LABEL "OK" 
     SIZE 16.6 BY 1.14.

DEFINE BUTTON b_Template 
     LABEL "&Template..." 
     SIZE 16.6 BY 1.14.

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

DEFINE RECTANGLE RECTbutton
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 19 BY 5.48.

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

DEFINE FRAME DEFAULT-FRAME
     s_objects AT ROW 1.71 COL 3 NO-LABEL WIDGET-ID 32
     b_Ok AT ROW 1.71 COL 56.2 WIDGET-ID 6
     productModule-Create AT ROW 1.76 COL 3.2 WIDGET-ID 18
     cb_productModule AT ROW 2.76 COL 3 NO-LABEL WIDGET-ID 10
     b_Cancel AT ROW 2.95 COL 56.2 WIDGET-ID 2
     b_Template AT ROW 4.24 COL 56.2 WIDGET-ID 8
     b_Help AT ROW 5.52 COL 56.2 WIDGET-ID 4
     togContainer AT ROW 7.71 COL 56.2 WIDGET-ID 34
     togSO AT ROW 8.67 COL 56.2 WIDGET-ID 40
     togProc AT ROW 9.62 COL 56.2 WIDGET-ID 38
     togWO AT ROW 10.57 COL 56.2 WIDGET-ID 44
     togDynamic AT ROW 11.71 COL 56.2 WIDGET-ID 36
     togStatic AT ROW 12.67 COL 56.2 WIDGET-ID 42
     e_descr1 AT ROW 14.52 COL 3 HELP
          "Description of object" NO-LABEL WIDGET-ID 14
     e_descr2 AT ROW 14.52 COL 3 HELP
          "Description of object" NO-LABEL WIDGET-ID 16
     Show-text AT ROW 6.95 COL 54.4 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     descr-text AT ROW 13.86 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     RECT-6 AT ROW 1.48 COL 2 WIDGET-ID 26
     RECT-3 AT ROW 14.14 COL 2 WIDGET-ID 20
     RECT-4 AT ROW 7.24 COL 55 WIDGET-ID 22
     RECT-5 AT ROW 1.43 COL 2 WIDGET-ID 24
     RECT-7 AT ROW 11.52 COL 55 WIDGET-ID 28
     RECTbutton AT ROW 1.43 COL 55 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 74.6 BY 18.81 WIDGET-ID 100.


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
         TITLE              = "New"
         HEIGHT             = 18.81
         WIDTH              = 75.2
         MAX-HEIGHT         = 18.81
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 18.81
         VIRTUAL-WIDTH      = 80
         MAX-BUTTON         = no
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON b_Cancel IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       b_Cancel:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR BUTTON b_Ok IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       b_Ok:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR COMBO-BOX cb_productModule IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       cb_productModule:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

ASSIGN 
       e_descr1:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       e_descr2:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR TOGGLE-BOX productModule-Create IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       productModule-Create:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

ASSIGN 
       RECT-4:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       RECT-6:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN Show-text IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       s_objects:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR TOGGLE-BOX togContainer IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       togContainer:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR TOGGLE-BOX togDynamic IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       togDynamic:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR TOGGLE-BOX togProc IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       togProc:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR TOGGLE-BOX togSO IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       togSO:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR TOGGLE-BOX togStatic IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       togStatic:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR TOGGLE-BOX togWO IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       togWO:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* New */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  ASSIGN selected = ?.
  IF _file_new_config > 15 THEN 
    ASSIGN _file_new_config = _file_new_config - 16.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* New */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Cancel C-Win
ON CHOOSE OF b_Cancel IN FRAME DEFAULT-FRAME /* Cancel */
DO:
    apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Help C-Win
ON CHOOSE OF b_Help IN FRAME DEFAULT-FRAME /* Help */
DO:
   RUN adecomm/_adehelp.p ( "AB":U, "CONTEXT":U, {&New_Template_Dlg_Box}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Ok C-Win
ON CHOOSE OF b_Ok IN FRAME DEFAULT-FRAME /* OK */
DO:
  run openObject.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Template
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Template C-Win
ON CHOOSE OF b_Template IN FRAME DEFAULT-FRAME /* Template... */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL productModule-Create C-Win
ON VALUE-CHANGED OF productModule-Create IN FRAME DEFAULT-FRAME /* Create in Product Module: */
DO:
    RUN changeProductModuleState (INPUT SELF:CHECKED).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME s_objects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s_objects C-Win
ON DEFAULT-ACTION OF s_objects IN FRAME DEFAULT-FRAME
DO:  
  RUN openObject.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s_objects C-Win
ON VALUE-CHANGED OF s_objects IN FRAME DEFAULT-FRAME
DO:  
  RUN Get_Descr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME togContainer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL togContainer C-Win
ON VALUE-CHANGED OF togContainer IN FRAME DEFAULT-FRAME /* Containers */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL togDynamic C-Win
ON VALUE-CHANGED OF togDynamic IN FRAME DEFAULT-FRAME /* Dynamic */
DO:
  APPLY "VALUE-CHANGED":U TO togContainer.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME togStatic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL togStatic C-Win
ON VALUE-CHANGED OF togStatic IN FRAME DEFAULT-FRAME /* Static */
DO:
   APPLY "VALUE-CHANGED":U TO togContainer.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
 
if OEIDEISrunning then 
    run getViewHwnd in hOEIDEService ("","NEWOBJECT",output OEIDEHwnd).  
    
if OEIDEHwnd > 0 then 
do:
   ASSIGN 
      {&WINDOW-NAME}:IDE-WINDOW-TYPE = 0 /* no window */ 
      {&WINDOW-NAME}:IDE-PARENT-HWND = OEIDEHwnd.
   OEIDE_NewWindow = this-procedure.     
   Assign b_Ok:hidden = true
          b_cancel:hidden = true      
          b_template:row = b_ok:row
          b_help:row = b_Cancel:row
          rectbutton:height = b_template:row - rectButton:row  
  .  

end.  
else
  assign 
     b_ok:hidden = false
     b_ok:sensitive = true
     b_Cancel:hidden = false
     b_Cancel:sensitive = true.
  


/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}
       CurrentWindow = _h_win
       {&WINDOW-NAME}:hidden = false.
       
/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN destroyObject.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.
ON HELP OF FRAME {&FRAME-NAME} APPLY "CHOOSE":U TO b_Help.

/* Assign delimiter of selection list */
ASSIGN s_objects:DELIMITER = CHR(10).

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  /* If we are RUNNING the ICF, show the ICF product module */
  RUN adeshar/_ablic.p (INPUT NO, OUTPUT licnum, OUTPUT licstr).
  ASSIGN enable-icf = CAN-DO(licstr,"ENABLE-ICF":U).
  
  IF enable-icf THEN
      RUN showProductModule.  
  
  RUN enable_UI.
       
  RUN Init. 
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeProductModuleState C-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject C-Win 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  OEIDEHwnd = ?.
  run disable_ui. 
   
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
  DISPLAY s_objects e_descr1 e_descr2 Show-text descr-text 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-3 RECT-4 RECT-5 RECT-7 RECTbutton s_objects b_Template b_Help 
         e_descr1 e_descr2 descr-text 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Fix_Custom_Name C-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Get_Descr C-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Get_FileName C-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Init C-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openObject C-Win 
PROCEDURE openObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE l          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE i          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE so-type    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE fixname    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE layoutID   AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE OK_Pressed AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cProductModuleCode AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cCustomName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel      AS CHARACTER  NO-UNDO.
 
  do with frame {&frame-name}:
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
  end.
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
    
    DEFINE VARIABLE cFileExt  AS CHARACTER NO-UNDO. 
    DEFINE VARIABLE cChoice   AS CHARACTER NO-UNDO. 
    DEFINE VARIABLE lHtmlFile AS LOGICAL NO-UNDO.
    
    if OEIDEHwnd = 0 then 
        hide {&window-name}.
    IF selected  NE "" AND selected NE ? THEN 
    DO:
      RUN adecomm/_osfext.p ( selected, OUTPUT cFileExt ).
      IF (cFileExt EQ ".htm":U OR cFileExt EQ ".html":U) AND _AB_license > 1 THEN 
      DO:

          lHtmlFile = TRUE.
          RUN adeweb/_trimdsc.p (selected, OUTPUT cChoice) NO-ERROR.
          IF NOT ERROR-STATUS:ERROR THEN
            selected = cChoice.
      END.
      if OEIDEIsRunning then                                             
      do:                                                                
          DEFINE VARIABLE lIdeIntegrated AS LOGICAL NO-UNDO.
          run getIsIDEIntegrated in hOEIDEService (output lIDEIntegrated).
      end.
      /* set "ide-untitled" to make _open-w.p call to ide to openunititled, 
         which then will call back here. we set lWaitingForOpen to ensure that 
         this second call is handled as standard AB call */  
      if lIDEIntegrated and not lWaitingForOpen then
      do:
         RUN adeuib/_open-w.p (selected, "","IDE-UNTITLED":U).
         lWaitingForOpen = true.
         return.
      end.
      else do:
         lWaitingForOpen = false.
         RUN Open_Untitled in _h_uib (selected).
      end.
       /* Delete temp file. */
      IF lHtmlFile THEN
        OS-DELETE VALUE(selected).

      RUN display_curwin in _h_uib.
    
      /* je-icf: Show the property sheet of new dynamic repository object. */
      IF (_h_win <> ?) AND (_h_win <> CurrentWindow) THEN
      DO:
        run startDynPropSheet in _h_uib.   
      END.
    END.  
    
    if OEIDEIsRunning = FALSE then 
       apply "close" to this-procedure.
    else  
      h_design = _h_win.   
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showProductModule C-Win 
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
    tmp-hdl         = FRAME {&frame-name}:HANDLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject C-Win 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   View frame {&frame-name}.
   {&window-name}:move-to-top(). 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRDMHandle C-Win 
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

