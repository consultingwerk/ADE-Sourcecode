&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: rysetattrv.i

  Description:  Include to set hardcoded 4GL widget attributes

  Purpose:      Include to set hardcoded 4GL widget attributes.  Used in createObjects
                in the dynamic viewer.

  Parameters:

  History:
  --------
  (v:010000)    Task:          00   UserRef:    
                Date:   30/07/2003  Author:     Neil Bell

  Update Notes: Create include

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE hValidationHandle AS HANDLE NO-UNDO.

CASE {&widgetBeingProcessed}:TYPE:
    WHEN "FILL-IN":U 
    THEN DO:
        ASSIGN {&widgetBeingProcessed}:ATTR-SPACE = LOGICAL(ENTRY(LOOKUP("Attr-Space":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:AUTO-RESIZE = LOGICAL(ENTRY(LOOKUP("Auto-Resize":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:AUTO-RETURN = LOGICAL(ENTRY(LOOKUP("Auto-Return":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:AUTO-ZAP = LOGICAL(ENTRY(LOOKUP("Auto-Zap":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.        
        IF LOOKUP("BgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:BGCOLOR = INTEGER(ENTRY(LOOKUP("BgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.		            
        ASSIGN {&widgetBeingProcessed}:BLANK = LOGICAL(ENTRY(LOOKUP("Blank":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:COLUMNS = INTEGER(ENTRY(LOOKUP("Columns":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:CONTEXT-HELP-ID = INTEGER(ENTRY(LOOKUP("Context-Help-Id":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:CURSOR-OFFSET = INTEGER(ENTRY(LOOKUP("Cursor-Offset":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:DEBLANK = LOGICAL(ENTRY(LOOKUP("Deblank":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:DISABLE-AUTO-ZAP = LOGICAL(ENTRY(LOOKUP("Disable-Auto-Zap":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:DROP-TARGET = LOGICAL(ENTRY(LOOKUP("Drop-Target":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:EDIT-CAN-UNDO = LOGICAL(ENTRY(LOOKUP("Edit-Can-Undo":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("FgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:FGCOLOR = INTEGER(ENTRY(LOOKUP("FgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:HELP = ENTRY(LOOKUP("Help":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MANUAL-HIGHLIGHT = LOGICAL(ENTRY(LOOKUP("Manual-Highlight":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MENU-KEY = ENTRY(LOOKUP("Menu-Key":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MENU-MOUSE = INTEGER(ENTRY(LOOKUP("Menu-Mouse":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MOVABLE = LOGICAL(ENTRY(LOOKUP("Movable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:PARENT = WIDGET-HANDLE(ENTRY(LOOKUP("Parent":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:PASSWORD-FIELD = LOGICAL(ENTRY(LOOKUP("Password-Field":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:POPUP-MENU = WIDGET-HANDLE(ENTRY(LOOKUP("Popup-Menu":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:READ-ONLY = LOGICAL(ENTRY(LOOKUP("Read-Only":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:RESIZABLE = LOGICAL(ENTRY(LOOKUP("Resizable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTABLE = LOGICAL(ENTRY(LOOKUP("Selectable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTED = LOGICAL(ENTRY(LOOKUP("Selected":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("Subtype":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:SUBTYPE = ENTRY(LOOKUP("Subtype":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:TAB-STOP = LOGICAL(ENTRY(LOOKUP("Tab-Stop":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
    END.	/* fill in */
    WHEN "TEXT":U 
    THEN DO:
        ASSIGN {&widgetBeingProcessed}:ATTR-SPACE = LOGICAL(ENTRY(LOOKUP("Attr-Space":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:AUTO-RESIZE = LOGICAL(ENTRY(LOOKUP("Auto-Resize":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:AUTO-RETURN = LOGICAL(ENTRY(LOOKUP("Auto-Return":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:AUTO-ZAP = LOGICAL(ENTRY(LOOKUP("Auto-Zap":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("BgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:BGCOLOR = INTEGER(ENTRY(LOOKUP("BgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:BLANK = LOGICAL(ENTRY(LOOKUP("Blank":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:COLUMNS = INTEGER(ENTRY(LOOKUP("Columns":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:CONTEXT-HELP-ID = INTEGER(ENTRY(LOOKUP("Context-Help-Id":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:CURSOR-OFFSET = INTEGER(ENTRY(LOOKUP("Cursor-Offset":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:DEBLANK = LOGICAL(ENTRY(LOOKUP("Deblank":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:DISABLE-AUTO-ZAP = LOGICAL(ENTRY(LOOKUP("Disable-Auto_zap":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:EDIT-CAN-UNDO = LOGICAL(ENTRY(LOOKUP("Edit-Can-Undo":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("FgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:FGCOLOR = INTEGER(ENTRY(LOOKUP("FgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:HELP = ENTRY(LOOKUP("Help":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MANUAL-HIGHLIGHT = LOGICAL(ENTRY(LOOKUP("Manual-Highlight":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MOVABLE = LOGICAL(ENTRY(LOOKUP("Movable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:PARENT = WIDGET-HANDLE(ENTRY(LOOKUP("Parent":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:READ-ONLY = LOGICAL(ENTRY(LOOKUP("Read-Only":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:RESIZABLE = LOGICAL(ENTRY(LOOKUP("Resizable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTABLE = LOGICAL(ENTRY(LOOKUP("Selectable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTED = LOGICAL(ENTRY(LOOKUP("Selected":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:TAB-STOP = LOGICAL(ENTRY(LOOKUP("Tab-Stop":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
    END.	/* text */
    WHEN "TOGGLE-BOX":U 
    THEN DO:
        ASSIGN {&widgetBeingProcessed}:AUTO-RESIZE = LOGICAL(ENTRY(LOOKUP("Auto-Resize":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("BgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:BGCOLOR = INTEGER(ENTRY(LOOKUP("BgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("Checked":U, {&PropertyNames}) GT 0 AND
           LOGICAL(ENTRY(LOOKUP("Checked":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) EQ ? THEN
            ASSIGN {&widgetBeingProcessed}:CHECKED = NO.
        ELSE
            ASSIGN {&widgetBeingProcessed}:CHECKED = LOGICAL(ENTRY(LOOKUP("Checked":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:COLUMNS = INTEGER(ENTRY(LOOKUP("Columns":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.        
        ASSIGN {&widgetBeingProcessed}:CONTEXT-HELP-ID = INTEGER(ENTRY(LOOKUP("Context-Help-Id":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:DROP-TARGET = LOGICAL(ENTRY(LOOKUP("Drop-Target":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("FgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:FGCOLOR = INTEGER(ENTRY(LOOKUP("FgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:HELP = ENTRY(LOOKUP("Help":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MANUAL-HIGHLIGHT = LOGICAL(ENTRY(LOOKUP("Manual-Highlight":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MENU-KEY = ENTRY(LOOKUP("Menu-Key":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MENU-MOUSE = INTEGER(ENTRY(LOOKUP("Menu-Mouse":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MOVABLE = LOGICAL(ENTRY(LOOKUP("Movable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:PARENT = WIDGET-HANDLE(ENTRY(LOOKUP("Parent":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:POPUP-MENU = WIDGET-HANDLE(ENTRY(LOOKUP("Popup-Menu":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:RESIZABLE = LOGICAL(ENTRY(LOOKUP("Resizable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTABLE = LOGICAL(ENTRY(LOOKUP("Selectable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTED = LOGICAL(ENTRY(LOOKUP("Selected":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:TAB-STOP = LOGICAL(ENTRY(LOOKUP("Tab-Stop":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
    END.	/* toggle box */
    WHEN "EDITOR":U 
    THEN DO:
        ASSIGN {&widgetBeingProcessed}:AUTO-INDENT = LOGICAL(ENTRY(LOOKUP("Auto-Indent":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
		ASSIGN {&widgetBeingProcessed}:AUTO-RESIZE = LOGICAL(ENTRY(LOOKUP("Auto-Resize":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("BgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:BGCOLOR = INTEGER(ENTRY(LOOKUP("BgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:BOX = LOGICAL(ENTRY(LOOKUP("Box":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:BUFFER-CHARS = INTEGER(ENTRY(LOOKUP("Buffer-Chars":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:BUFFER-LINES = INTEGER(ENTRY(LOOKUP("Buffer-Lines":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:COLUMNS = INTEGER(ENTRY(LOOKUP("Columns":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:CONTEXT-HELP-ID = INTEGER(ENTRY(LOOKUP("Context-Help-Id":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:CURSOR-CHAR = INTEGER(ENTRY(LOOKUP("Cursor-Char":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:CURSOR-LINE = INTEGER(ENTRY(LOOKUP("Cursor-Line":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:CURSOR-OFFSET = INTEGER(ENTRY(LOOKUP("Cursor-Offset":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:DROP-TARGET = LOGICAL(ENTRY(LOOKUP("Drop-Target":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:EDIT-CAN-UNDO = LOGICAL(ENTRY(LOOKUP("Edit-Can-Undo":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("FgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:FGCOLOR = INTEGER(ENTRY(LOOKUP("FgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:HELP = ENTRY(LOOKUP("Help":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:INNER-CHARS = INTEGER(ENTRY(LOOKUP("Inner-Chars":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        
        /* Inner lines is a valid attribute in the datafield class, but not in the dynEditor class */
        IF LOOKUP("Inner-Lines":U, {&PropertyNames}) GT 0 AND
           NOT CAN-DO("?,0,":U, ENTRY(LOOKUP("Inner-Lines":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) THEN
            ASSIGN {&widgetBeingProcessed}:INNER-LINES = INTEGER(ENTRY(LOOKUP("Inner-Lines":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
            
        ASSIGN {&widgetBeingProcessed}:LARGE = LOGICAL(ENTRY(LOOKUP("Large":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MANUAL-HIGHLIGHT = LOGICAL(ENTRY(LOOKUP("Manual-Highlight":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MAX-CHARS = INTEGER(ENTRY(LOOKUP("Max-Chars":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MENU-KEY = ENTRY(LOOKUP("Menu-Key":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MENU-MOUSE = INTEGER(ENTRY(LOOKUP("Menu-Mouse":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MOVABLE = LOGICAL(ENTRY(LOOKUP("Movable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:PARENT = WIDGET-HANDLE(ENTRY(LOOKUP("Parent":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:POPUP-MENU = WIDGET-HANDLE(ENTRY(LOOKUP("Popup-Menu":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:PROGRESS-SOURCE = LOGICAL(ENTRY(LOOKUP("Progress-Source":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:READ-ONLY = LOGICAL(ENTRY(LOOKUP("Read-Only":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:RESIZABLE = LOGICAL(ENTRY(LOOKUP("Resizable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:RETURN-INSERTED = LOGICAL(ENTRY(LOOKUP("Return-Inserted":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SCROLLBAR-HORIZONTAL = LOGICAL(ENTRY(LOOKUP("Scrollbar-Horizontal":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SCROLLBAR-VERTICAL = LOGICAL(ENTRY(LOOKUP("Scrollbar-Vertical":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTABLE = LOGICAL(ENTRY(LOOKUP("Selectable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTED = LOGICAL(ENTRY(LOOKUP("Selected":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:TAB-STOP = LOGICAL(ENTRY(LOOKUP("Tab-Stop":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:WORD-WRAP = LOGICAL(ENTRY(LOOKUP("Word-Wrap":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
    END.	/* editor */
    WHEN "COMBO-BOX":U 
    THEN DO:
        ASSIGN {&widgetBeingProcessed}:AUTO-COMPLETION = LOGICAL(ENTRY(LOOKUP("Auto-Completion":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
		ASSIGN {&widgetBeingProcessed}:AUTO-RESIZE = LOGICAL(ENTRY(LOOKUP("Auto-Resize":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("BgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:BGCOLOR = INTEGER(ENTRY(LOOKUP("BgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:COLUMNS = INTEGER(ENTRY(LOOKUP("Columns":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:CONTEXT-HELP-ID = INTEGER(ENTRY(LOOKUP("Context-Help-Id":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:DELIMITER = ENTRY(LOOKUP("Delimiter":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:DROP-TARGET = LOGICAL(ENTRY(LOOKUP("Drop-Target":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:EDIT-CAN-UNDO = LOGICAL(ENTRY(LOOKUP("Edit-Can-Undo":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("FgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:FGCOLOR = INTEGER(ENTRY(LOOKUP("FgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:HELP = ENTRY(LOOKUP("Help":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:INNER-LINES = INTEGER(ENTRY(LOOKUP("Inner-Lines":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        
        IF LOOKUP("List-Item-Pairs":U, {&PropertyNames}) GT 0 AND
           ENTRY(LOOKUP("List-Item-Pairs":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NE ? AND
           ENTRY(LOOKUP("List-Item-Pairs":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NE "":U THEN
            ASSIGN {&widgetBeingProcessed}:LIST-ITEM-PAIRS = ENTRY(LOOKUP("List-Item-Pairs":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) .
        ELSE
        IF LOOKUP("List-Items":U, {&PropertyNames}) GT 0 AND
           ENTRY(LOOKUP("List-Items":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NE ? AND
           ENTRY(LOOKUP("List-Items":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NE "":U THEN
            ASSIGN {&widgetBeingProcessed}:LIST-ITEMS = ENTRY(LOOKUP("List-Items":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}).

        ASSIGN {&widgetBeingProcessed}:MANUAL-HIGHLIGHT = LOGICAL(ENTRY(LOOKUP("Manual-Highlight":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MAX-CHARS = INTEGER(ENTRY(LOOKUP("Max-Chars":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MENU-KEY = ENTRY(LOOKUP("Menu-Key":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MENU-MOUSE = INTEGER(ENTRY(LOOKUP("Menu-Mouse":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MOVABLE = LOGICAL(ENTRY(LOOKUP("Movable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:PARENT = WIDGET-HANDLE(ENTRY(LOOKUP("Parent":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:POPUP-MENU = WIDGET-HANDLE(ENTRY(LOOKUP("Popup-Menu":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:RESIZABLE = LOGICAL(ENTRY(LOOKUP("Resizable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTABLE = LOGICAL(ENTRY(LOOKUP("Selectable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTED = LOGICAL(ENTRY(LOOKUP("Selected":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SORT = LOGICAL(ENTRY(LOOKUP("Sort":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("Subtype":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:SUBTYPE = ENTRY(LOOKUP("Subtype":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:TAB-STOP = LOGICAL(ENTRY(LOOKUP("Tab-Stop":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:UNIQUE-MATCH = LOGICAL(ENTRY(LOOKUP("Unique-Match":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
    END.	/* combo box */
    WHEN "SELECTION-LIST":U 
    THEN DO:
		ASSIGN {&widgetBeingProcessed}:AUTO-RESIZE = LOGICAL(ENTRY(LOOKUP("Auto-Resize":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF INTEGER(ENTRY(LOOKUP("BgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) <> ? THEN
            ASSIGN {&widgetBeingProcessed}:BGCOLOR = INTEGER(ENTRY(LOOKUP("BgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:COLUMNS = INTEGER(ENTRY(LOOKUP("Columns":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:CONTEXT-HELP-ID = INTEGER(ENTRY(LOOKUP("Context-Help-Id":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:DELIMITER = ENTRY(LOOKUP("Delimiter":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:DRAG-ENABLED = LOGICAL(ENTRY(LOOKUP("Drag-Enabled":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:DROP-TARGET = LOGICAL(ENTRY(LOOKUP("Drop-Target":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("FgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:FGCOLOR = INTEGER(ENTRY(LOOKUP("FgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:HELP = ENTRY(LOOKUP("Help":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.

        ASSIGN {&widgetBeingProcessed}:INNER-CHARS = INTEGER(ENTRY(LOOKUP("Inner-Chars":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        
        /* Avoid setting inner-lines to 0 as it resizes the widget (possibly an ABL default to keep minimum 3 inner-lines?) 
           Inner lines is a valid attribute in the datafield class, but not in the dynSelection class */
        IF LOOKUP("Inner-Lines":U, {&PropertyNames}) GT 0 
        AND NOT CAN-DO("?,0,":U, ENTRY(LOOKUP("Inner-Lines":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) THEN
          ASSIGN {&widgetBeingProcessed}:INNER-LINES = INTEGER(ENTRY(LOOKUP("Inner-Lines":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        
        IF LOOKUP("List-Item-Pairs":U, {&PropertyNames}) GT 0 AND
           ENTRY(LOOKUP("List-Item-Pairs":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NE ? AND
           ENTRY(LOOKUP("List-Item-Pairs":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NE "":U THEN
            ASSIGN {&widgetBeingProcessed}:LIST-ITEM-PAIRS = ENTRY(LOOKUP("List-Item-Pairs":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) .
        ELSE
        IF LOOKUP("List-Items":U, {&PropertyNames}) GT 0 AND
           ENTRY(LOOKUP("List-Items":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NE ? AND
           ENTRY(LOOKUP("List-Items":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NE "":U THEN
            ASSIGN {&widgetBeingProcessed}:LIST-ITEMS = ENTRY(LOOKUP("List-Items":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}).

        ASSIGN {&widgetBeingProcessed}:MANUAL-HIGHLIGHT = LOGICAL(ENTRY(LOOKUP("Manual-Highlight":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MENU-KEY = ENTRY(LOOKUP("Menu-Key":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MENU-MOUSE = INTEGER(ENTRY(LOOKUP("Menu-Mouse":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MOVABLE = LOGICAL(ENTRY(LOOKUP("Movable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MULTIPLE = LOGICAL(ENTRY(LOOKUP("Multiple":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:PARENT = WIDGET-HANDLE(ENTRY(LOOKUP("Parent":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:POPUP-MENU = WIDGET-HANDLE(ENTRY(LOOKUP("Popup-Menu":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:RESIZABLE = LOGICAL(ENTRY(LOOKUP("Resizable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SCROLLBAR-HORIZONTAL = LOGICAL(ENTRY(LOOKUP("Scrollbar-Horizontal":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SCROLLBAR-VERTICAL = LOGICAL(ENTRY(LOOKUP("Scrollbar-Vertical":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTABLE = LOGICAL(ENTRY(LOOKUP("Selectable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTED = LOGICAL(ENTRY(LOOKUP("Selected":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SORT = LOGICAL(ENTRY(LOOKUP("Sort":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:TAB-STOP = LOGICAL(ENTRY(LOOKUP("Tab-Stop":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
    END.	/* selection list */
    WHEN "RADIO-SET":U 
    THEN DO:
        ASSIGN {&widgetBeingProcessed}:AUTO-RESIZE = LOGICAL(ENTRY(LOOKUP("Auto-Resize":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("BgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:BGCOLOR = INTEGER(ENTRY(LOOKUP("BgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:COLUMNS = INTEGER(ENTRY(LOOKUP("Columns":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:CONTEXT-HELP-ID = INTEGER(ENTRY(LOOKUP("Context-Help-Id":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:DELIMITER = ENTRY(LOOKUP("Delimiter":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:DROP-TARGET = LOGICAL(ENTRY(LOOKUP("Drop-Target":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.        
        ASSIGN {&widgetBeingProcessed}:EXPAND = LOGICAL(ENTRY(LOOKUP("Expand":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("FgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:FGCOLOR = INTEGER(ENTRY(LOOKUP("FgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:HELP = ENTRY(LOOKUP("Help":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:HORIZONTAL = LOGICAL(ENTRY(LOOKUP("Horizontal":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MANUAL-HIGHLIGHT = LOGICAL(ENTRY(LOOKUP("Manual-Highlight":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MENU-KEY = ENTRY(LOOKUP("Menu-Key":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MENU-MOUSE = INTEGER(ENTRY(LOOKUP("Menu-Mouse":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MOVABLE = LOGICAL(ENTRY(LOOKUP("Movable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:PARENT = WIDGET-HANDLE(ENTRY(LOOKUP("Parent":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:POPUP-MENU = WIDGET-HANDLE(ENTRY(LOOKUP("Popup-Menu":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:RADIO-BUTTONS = ENTRY(LOOKUP("Radio-Buttons":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:RESIZABLE = LOGICAL(ENTRY(LOOKUP("Resizable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTABLE = LOGICAL(ENTRY(LOOKUP("Selectable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTED = LOGICAL(ENTRY(LOOKUP("Selected":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:TAB-STOP = LOGICAL(ENTRY(LOOKUP("Tab-Stop":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
    END.	/* radio set */
    WHEN "BUTTON":U 
    THEN DO:
    	IF LOOKUP("Image-File":U, {&PropertyNames}) GT 0 THEN
    		{&widgetBeingProcessed}:LOAD-IMAGE(ENTRY(LOOKUP("Image-File":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:AUTO-END-KEY = LOGICAL(ENTRY(LOOKUP("Auto-End-Key":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:AUTO-GO = LOGICAL(ENTRY(LOOKUP("Auto-Go":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:AUTO-RESIZE = LOGICAL(ENTRY(LOOKUP("Auto-Resize":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("BgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:BGCOLOR = INTEGER(ENTRY(LOOKUP("BgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:COLUMNS = INTEGER(ENTRY(LOOKUP("Columns":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:CONTEXT-HELP-ID = INTEGER(ENTRY(LOOKUP("Context-Help-Id":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:CONVERT-3D-COLORS = LOGICAL(ENTRY(LOOKUP("Convert-3D-Colors":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:DEFAULT = LOGICAL(ENTRY(LOOKUP("Default":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:DROP-TARGET = LOGICAL(ENTRY(LOOKUP("Drop-Target":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("FgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:FGCOLOR = INTEGER(ENTRY(LOOKUP("FgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:FLAT-BUTTON = LOGICAL(ENTRY(LOOKUP("Flat-Button":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:HELP = ENTRY(LOOKUP("Help":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MANUAL-HIGHLIGHT = LOGICAL(ENTRY(LOOKUP("Manual-Highlight":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MENU-KEY = ENTRY(LOOKUP("Menu-Key":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MENU-MOUSE = INTEGER(ENTRY(LOOKUP("Menu-Mouse":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MOVABLE = LOGICAL(ENTRY(LOOKUP("Movable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:NO-FOCUS = LOGICAL(ENTRY(LOOKUP("No-Focus":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:PARENT = WIDGET-HANDLE(ENTRY(LOOKUP("Parent":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:POPUP-MENU = WIDGET-HANDLE(ENTRY(LOOKUP("Popup-Menu":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:RESIZABLE = LOGICAL(ENTRY(LOOKUP("Resizable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTABLE = LOGICAL(ENTRY(LOOKUP("Selectable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTED = LOGICAL(ENTRY(LOOKUP("Selected":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:TAB-STOP = LOGICAL(ENTRY(LOOKUP("Tab-Stop":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
    END.	/* button */
    WHEN "RECTANGLE":U 
    THEN DO:
        IF LOOKUP("BgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:BGCOLOR = INTEGER(ENTRY(LOOKUP("BgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:COLUMNS = INTEGER(ENTRY(LOOKUP("Columns":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:EDGE-CHARS = DECIMAL(ENTRY(LOOKUP("Edge-Chars":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:EDGE-PIXELS = INTEGER(ENTRY(LOOKUP("Edge-Pixels":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("FgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:FGCOLOR = INTEGER(ENTRY(LOOKUP("FgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:FILLED = LOGICAL(ENTRY(LOOKUP("Filled":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:GRAPHIC-EDGE = LOGICAL(ENTRY(LOOKUP("Graphic-Edge":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:HELP = ENTRY(LOOKUP("Help":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MANUAL-HIGHLIGHT = LOGICAL(ENTRY(LOOKUP("Manual-Highlight":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MOVABLE = LOGICAL(ENTRY(LOOKUP("Movable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:PARENT = WIDGET-HANDLE(ENTRY(LOOKUP("Parent":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:RESIZABLE = LOGICAL(ENTRY(LOOKUP("Resizable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTABLE = LOGICAL(ENTRY(LOOKUP("Selectable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTED = LOGICAL(ENTRY(LOOKUP("Selected":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.            
        {&widgetBeingProcessed}:group-box = LOGICAL(ENTRY(LOOKUP("Group-Box":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        {&widgetBeingProcessed}:rounded = LOGICAL(ENTRY(LOOKUP("Rounded":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
    END.	/* rectangle */
    WHEN "IMAGE":U 
    THEN DO:
    	IF LOOKUP("Image-File":U, {&PropertyNames}) GT 0 THEN
    		{&widgetBeingProcessed}:LOAD-IMAGE(ENTRY(LOOKUP("Image-File":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:AUTO-RESIZE = LOGICAL(ENTRY(LOOKUP("Auto-Resize":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("BgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:BGCOLOR = INTEGER(ENTRY(LOOKUP("BgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:COLUMNS = INTEGER(ENTRY(LOOKUP("Columns":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:CONVERT-3D-COLORS = LOGICAL(ENTRY(LOOKUP("Convert-3D-Colors":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("FgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:FGCOLOR = INTEGER(ENTRY(LOOKUP("FgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:HELP = ENTRY(LOOKUP("Help":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MANUAL-HIGHLIGHT = LOGICAL(ENTRY(LOOKUP("Manual-Highlight":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MOVABLE = LOGICAL(ENTRY(LOOKUP("Movable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:PARENT = WIDGET-HANDLE(ENTRY(LOOKUP("Parent":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:RESIZABLE = LOGICAL(ENTRY(LOOKUP("Resizable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:RETAIN-SHAPE = LOGICAL(ENTRY(LOOKUP("Retain-Shape":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTABLE = LOGICAL(ENTRY(LOOKUP("Selectable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTED = LOGICAL(ENTRY(LOOKUP("Selected":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:STRETCH-TO-FIT = LOGICAL(ENTRY(LOOKUP("Stretch-To-Fit":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:PARENT = WIDGET-HANDLE(ENTRY(LOOKUP("Parent":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
    END.	/* Image */
    WHEN "SLIDER":U 
    THEN DO:
        ASSIGN {&widgetBeingProcessed}:AUTO-RESIZE = LOGICAL(ENTRY(LOOKUP("Auto-Resize":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("BgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:BGCOLOR = INTEGER(ENTRY(LOOKUP("BgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:COLUMNS = INTEGER(ENTRY(LOOKUP("Columns":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:CONTEXT-HELP-ID = INTEGER(ENTRY(LOOKUP("Context-Help-Id":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:DROP-TARGET = LOGICAL(ENTRY(LOOKUP("Drop-Target":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        IF LOOKUP("FgColor":U, {&PropertyNames}) GT 0 THEN
            ASSIGN {&widgetBeingProcessed}:FGCOLOR = INTEGER(ENTRY(LOOKUP("FgColor":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:FREQUENCY = INTEGER(ENTRY(LOOKUP("Frequency":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:HELP = ENTRY(LOOKUP("Help":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:HORIZONTAL = LOGICAL(ENTRY(LOOKUP("Horizintal":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:LARGE-TO-SMALL = LOGICAL(ENTRY(LOOKUP("Large-To-Small":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MANUAL-HIGHLIGHT = LOGICAL(ENTRY(LOOKUP("Manual-Highlight":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MAX-VALUE = INTEGER(ENTRY(LOOKUP("Max-Value":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MENU-KEY = ENTRY(LOOKUP("Menu-Key":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MENU-MOUSE = INTEGER(ENTRY(LOOKUP("Menu-Mouse":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MIN-VALUE = INTEGER(ENTRY(LOOKUP("Min-Value":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:MOVABLE = LOGICAL(ENTRY(LOOKUP("Movable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:NO-CURRENT-VALUE = LOGICAL(ENTRY(LOOKUP("No-Current-Value":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:PARENT = WIDGET-HANDLE(ENTRY(LOOKUP("Parent":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:POPUP-MENU = WIDGET-HANDLE(ENTRY(LOOKUP("Popup-Menu":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:RESIZABLE = LOGICAL(ENTRY(LOOKUP("Resizable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTABLE = LOGICAL(ENTRY(LOOKUP("Selectable":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:SELECTED = LOGICAL(ENTRY(LOOKUP("Selected":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:TAB-STOP = LOGICAL(ENTRY(LOOKUP("Tab-Stop":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter})) NO-ERROR.
        ASSIGN {&widgetBeingProcessed}:TIC-MARKS = ENTRY(LOOKUP("Tic-marks":U, {&PropertyNames}), {&PropertyValues}, {&Value-Delimiter}) NO-ERROR.
    END.	/* slider */
END CASE.	/* widget type */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
