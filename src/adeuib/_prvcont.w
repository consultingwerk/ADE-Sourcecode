&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DLGCLOSE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DLGCLOSE 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _prvcont.w

  Description: General use dialog box 
    template with Close and Help buttons

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: David Lee

  Created: 03/08/94 -  9:14 pm

  Modified on 11/01/96 gfs - &IF'd CC code so this .W would compile on 32bit
                01/21/97 SLK - Modified for OCX. Use of core picker therefore no real need for preview, but we need it for add to palette etc.
  
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adeuib/sharvars.i}
{adeuib/custwidg.i}
{adeuib/uibhlp.i}
define variable s       as logical      no-undo.
define stream aStream.
DEFINE VARIABLE ocx     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE ocxdll      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE ocxClassId  AS CHARACTER    NO-UNDO. 
DEFINE VARIABLE ocxBaseName  AS CHARACTER    NO-UNDO. 
DEFINE VARIABLE ocxPrefix  AS CHARACTER    NO-UNDO. 
DEFINE VARIABLE ocxExt  AS CHARACTER    NO-UNDO. 
DEFINE VARIABLE ocxBaseName-Ext  AS CHARACTER    NO-UNDO. 
DEFINE VARIABLE _ocx_add AS COMPONENT-HANDLE NO-UNDO.

DEFINE VARIABLE ParentHWND	AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DLGCLOSE

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-6 ChooseOCX ocxFile RECT-5 PaletteList ~
MenuLabel CustomFile GetCstFile updateScreen 
&Scoped-Define DISPLAYED-OBJECTS ocxFile PaletteList MenuLabel CustomFile ~
updateScreen 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON ChooseOCX 
     LABEL "Choose OCX" 
     SIZE 15 BY 1.19.

DEFINE BUTTON GetCstFile 
     LABEL "&File ..." 
     SIZE 15 BY 1.14.

DEFINE VARIABLE PaletteList AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 27 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE CustomFile AS CHARACTER FORMAT "X(256)":U INITIAL "src/template/progress.cst" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE MenuLabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE ocxFile AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 34 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 53 BY 4.52.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 55 BY 7.38.

DEFINE VARIABLE updateScreen AS LOGICAL INITIAL yes 
     LABEL "&Repaint Palette" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .76 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DLGCLOSE
     ChooseOCX AT ROW 1.71 COL 40
     ocxFile AT ROW 1.95 COL 4 NO-LABEL
     PaletteList AT ROW 4.33 COL 2 COLON-ALIGNED NO-LABEL
     MenuLabel AT ROW 4.33 COL 30 COLON-ALIGNED NO-LABEL
     CustomFile AT ROW 6.24 COL 4 NO-LABEL
     GetCstFile AT ROW 6.24 COL 40
     updateScreen AT ROW 7.91 COL 4
     RECT-6 AT ROW 1.48 COL 2
     RECT-5 AT ROW 3.38 COL 3
     "&Palette Item:" VIEW-AS TEXT
          SIZE 21 BY .62 AT ROW 3.62 COL 4
     "&SubMenu Label:" VIEW-AS TEXT
          SIZE 16 BY .62 AT ROW 3.62 COL 32
     "&Custom File:" VIEW-AS TEXT
          SIZE 14 BY .62 AT ROW 5.52 COL 4
     SPACE(39.79) SKIP(2.99)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         BGCOLOR 8 
         TITLE "Add to Palette SubMenu":L.

 
/* ************************  Function References ********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DLGCLOSE
   UNDERLINE Default                                                    */
ASSIGN 
       FRAME DLGCLOSE:SCROLLABLE       = FALSE
       FRAME DLGCLOSE:HIDDEN           = TRUE
       FRAME DLGCLOSE:PRIVATE-DATA     = 
                "DLGCLOSE".

/* SETTINGS FOR FILL-IN CustomFile IN FRAME DLGCLOSE
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN ocxFile IN FRAME DLGCLOSE
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME DLGCLOSE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DLGCLOSE DLGCLOSE
ON ALT-C OF FRAME DLGCLOSE /* Add OCX to SubMenu */
DO:
    apply "entry" to customFile.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DLGCLOSE DLGCLOSE
ON ALT-M OF FRAME DLGCLOSE /* Add OCX to SubMenu */
DO:
    apply "entry" to menuLabel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DLGCLOSE DLGCLOSE
ON ALT-P OF FRAME DLGCLOSE /* Add OCX to SubMenu */
DO:
    apply "entry" to paletteList.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DLGCLOSE DLGCLOSE
ON GO OF FRAME DLGCLOSE /* Add OCX to SubMenu */
DO:
    
    IF NOT VALID-HANDLE(_ocx_add) THEN 
    DO:
	MESSAGE "You must choose an OCX to add to palette submenu."
	VIEW-AS ALERT-BOX INFORMATION.
	APPLY "ENTRY":U TO ChooseOCX.
	RETURN NO-APPLY.
    END.
    /*
     * Write out only if the user wants to add
     */
    run adecomm/_setcurs.p("WAIT").
    Run writePalette.
    IF RETURN-VALUE = "_ERRDIR" THEN
    DO:
	MESSAGE "The Custom Directory could not be created. Create it or specify a different directory."
	VIEW-AS ALERT-BOX ERROR.
	APPLY "ENTRY":U TO CustomFile.
	RETURN NO-APPLY.
    END.
    
    /*
     * Redisplay the palette
     */
    /*NEW*/ ASSIGN FRAME DLGCLOSE:HIDDEN = TRUE.
    if updateScreen then run update_palette in _h_uib.

    IF VALID-HANDLE(_ocx_add) THEN RELEASE OBJECT _ocx_add.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ChooseOCX
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ChooseOCX DLGCLOSE
ON CHOOSE OF ChooseOCX IN FRAME DLGCLOSE /* Choose OCX */
DO:
  RUN GetParent(INPUT _h_object_win:HWND, OUTPUT ParentHWND).
  _ocx_add = _h_Controls:GetControl(ParentHWND) NO-ERROR.
  RUN initControlUI.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CustomFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CustomFile DLGCLOSE
ON LEAVE OF CustomFile IN FRAME DLGCLOSE
DO:
    if customFile:SCREEN-VALUE = customFile then return.
    assign
        customFile = customFile:SCREEN-VALUE
    .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME GetCstFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL GetCstFile DLGCLOSE
ON CHOOSE OF GetCstFile IN FRAME DLGCLOSE /* File ... */
DO:
    DEFINE VARIABLE fname AS CHARACTER NO-UNDO.
    RUN GetFile (INPUT "Custom File", INPUT "cst", INPUT ".", OUTPUT fname).
    IF fname = ? THEN RETURN NO-APPLY.
    ELSE
    ASSIGN 
      customFile = fname
      customFile:SCREEN-VALUE = customFile.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME MenuLabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL MenuLabel DLGCLOSE
ON LEAVE OF MenuLabel IN FRAME DLGCLOSE
DO:

    if menuLabel:SCREEN-VALUE = menuLabel then return.
    
    assign
       menuLabel =  menuLabel:SCREEN-VALUE 
    .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PaletteList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PaletteList DLGCLOSE
ON VALUE-CHANGED OF PaletteList IN FRAME DLGCLOSE
DO:

    if paletteList:SCREEN-VALUE = paletteList then return.
    
    assign
        paletteList = paletteList:SCREEN-VALUE
    .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME updateScreen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL updateScreen DLGCLOSE
ON VALUE-CHANGED OF updateScreen IN FRAME DLGCLOSE /* Repaint Palette */
DO:
    updateScreen = (updateScreen:SCREEN-VALUE = "yes").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DLGCLOSE 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
   AND ACTIVE-WINDOW <> _h_object_win
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* ADE okbar.i places standard ADE OK-CANCEL-HELP buttons.              */
{adecomm/okbar.i &TOOL = "AB"
                 &CONTEXT = {&Add_OCX_SubMenu_Dlg_Box} }
                 
RUN initUI.
/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DLGCLOSE _DEFAULT-DISABLE
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
  HIDE FRAME DLGCLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DLGCLOSE _DEFAULT-ENABLE
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
  DISPLAY ocxFile PaletteList MenuLabel CustomFile updateScreen 
      WITH FRAME DLGCLOSE.
  ENABLE RECT-6 ChooseOCX ocxFile RECT-5 PaletteList MenuLabel CustomFile 
         GetCstFile updateScreen 
      WITH FRAME DLGCLOSE.
  VIEW FRAME DLGCLOSE.
  {&OPEN-BROWSERS-IN-QUERY-DLGCLOSE}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetFile DLGCLOSE 
PROCEDURE GetFile :
DEFINE INPUT PARAMETER FileType AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER FileExt AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER initDir AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER fName AS CHARACTER NO-UNDO.

    SYSTEM-DIALOG GET-FILE fName
        TITLE  "Choose " + FileType
        FILTERS FileType + " Files (*." + FileExt + ")"  "*." + FileExt,
                "All Files (*.*)"  "*.*"
        INITIAL-DIR initDir 
        DEFAULT-EXTENSION "." + FileExt
        USE-FILENAME
        RETURN-TO-START-DIR
        UPDATE s.    
                                            
    ASSIGN fName = IF s = no THEN ?
    ELSE replace(fName, "~/", "~\") .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initControlUI DLGCLOSE 
PROCEDURE initControlUI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define variable i as integer no-undo.
define variable ofPrefix as Character no-undo.
define variable ofSuffix as Character no-undo.
define variable sfOcxDll as Character no-undo.
define variable text-width as INTEGER no-undo.

do with frame {&FRAME-NAME}:
    IF VALID-HANDLE(_ocx_add) THEN 
    DO:
    ASSIGN
        ocx = _ocx_add:shortname
        ocxDll = _ocx_add:path
        ocxClassId = _ocx_add:classid
        oFPrefix = ocx + " (from "
        oFSuffix = ")"
        text-width = FONT-TABLE:GET-TEXT-WIDTH(ofPrefix, ocxFile:FONT)
        text-width = text-width + FONT-TABLE:GET-TEXT-WIDTH(ofSuffix, ocxFile:FONT)
    .
    RUN adecomm/_ossfnam.p (INPUT ocxDll, INPUT ocxFile:WIDTH - text-width, 
                INPUT ocxFile:FONT, OUTPUT sfOcxDll).
    RUN adecomm/_osprefx.p (INPUT ocxDll, OUTPUT ocxPrefix, OUTPUT ocxBaseName).
    RUN adecomm/_osprefx.p (INPUT ocxDll, OUTPUT ocxPrefix, OUTPUT ocxBaseName).
    RUN adecomm/_osfext.p (INPUT ocxBaseName, OUTPUT ocxExt).

    assign
        ocxBaseName-Ext = SUBSTRING(ocxBaseName,1,LENGTH(ocxBaseName) - LENGTH(ocxExt))
        ocxFile:SCREEN-VALUE      = ofPrefix + sfOcxDll + ofSuffix 
        ocxFile                   = ocxFile:SCREEN-VALUE
        menuLabel                 = ocx
        menuLabel:SCREEN-VALUE    = menuLabel
    .

    end. /* VALID OCX */
end. /* frame */
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initUI DLGCLOSE 
PROCEDURE initUI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define variable ocxEntry as INTEGER no-undo.

do with frame {&FRAME-NAME}:
    RUN initControlUI.
    paletteList:LIST-ITEMS = "". 
    for each _palette_item WHERE _palette_item._type eq {&P-XCONTROL}:
        s = paletteList:ADD-LAST(_palette_item._LABEL2).
    end.
    
    assign
        ocxEntry = paletteList:LOOKUP("ocx").
    IF ocxEntry <> ? THEN 
        ASSIGN
        paletteList:SCREEN-VALUE = paletteList:ENTRY(paletteList:LOOKUP("ocx"))
        paletteList              = paletteList:SCREEN-VALUE
    .
 end. /* frame */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writePalette DLGCLOSE 
PROCEDURE writePalette :
define variable fName as character no-undo.
define variable cstfName as character no-undo.
define variable junk  as character no-undo.
DEFINE VARIABLE fPrefix 	AS CHARACTER 	NO-UNDO.
DEFINE VARIABLE fBasename 	AS CHARACTER 	NO-UNDO.
DEFINE VARIABLE createIt 	AS LOGICAL 	NO-UNDO.
DEFINE VARIABLE ThisMessage 	AS CHARACTER 	NO-UNDO.
DEFINE VARIABLE errStatus 	AS LOGICAL 	NO-UNDO.
  
do with frame DLGCLOSE:
  IF NOT VALID-HANDLE(_ocx_add) THEN RETURN.
  
    /* CST FILES
     * If the file isn't found in the propath then just
     * use the name given by the user. This code isn't 
     * portable, but ocx's aren't either. None of the
     * existing 4GL or adecomm functions help out.
     */
    ASSIGN createIt = no.
    
    cstfName = search(customFile).
    if cstfName = ? then cstfName = customFile.
    else if cstfName begins ".~\" then cstfName = replace(cstfName, ".~\", "").
                                      
    /* The user can specify a pathed filename create it if not there */
    RUN adecomm/_osprefx.p(INPUT cstfName, OUTPUT fPreFix, OUTPUT fBasename).

    IF fPrefix <> "" THEN FILE-INFO:FILE-NAME = fPrefix.
    ELSE FILE-INFO:FILE-NAME = ".":U.

    IF FILE-INFO:FULL-PATHNAME = ? THEN
    DO:
       ASSIGN ThisMessage =
	"Directory " + fPrefix + " does not exist." + CHR(10)
	+ "Do you want to create it?"
	createIt = yes.
	RUN adecomm/_s-alert.p (INPUT-OUTPUT createIt, "Q":U,"yes-no", ThisMessage).
	IF createIt THEN
	DO:
	  RUN adecomm/_oscpath.p(INPUT fPrefix, OUTPUT errStatus).
	  IF errStatus THEN RETURN "_ERRDIR".
	END.
        ELSE RETURN "_ERRDIR".
    END.
    
    OUTPUT STREAM aStream TO VALUE(cstfName) APPEND NO-ECHO.

  /* Find the palette item listed in the combo-box. */
  FIND _palette_item WHERE _palette_item._LABEL2 eq paletteList NO-ERROR.
  IF NOT AVAILABLE _palette_item 
  THEN MESSAGE "Cannot find unique palette item with label" paletteList + "."
               VIEW-AS ALERT-BOX ERROR.
  ELSE DO:
    put stream aStream unformatted
        skip(1)
        "*" _palette_item._name " " menuLabel skip
        "CONTROL " ocxclassid " " ocx skip(2)
    .
    END.
  
    output stream aStream close.
    
    /*
     * Is the custom file in the list of custom files? If not, then
     * add it.
     */
    if (lookup(cstfName, {&CUSTOM-FILES}) = 0) then
       {&CUSTOM-FILES} = {&CUSTOM-FILES} + "," + cstfName.
         
END.
END PROCEDURE.


/* GetParent - Get the parent of a Progress window (real HWND) */
PROCEDURE GetParent EXTERNAL "USER32.DLL":
   DEFINE INPUT  PARAMETER in-hwn AS LONG.
   DEFINE RETURN PARAMETER hwnd   AS LONG.
END.          

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

