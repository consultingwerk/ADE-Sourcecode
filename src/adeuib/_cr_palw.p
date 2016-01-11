/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _cr_palw.p

Description:
  Create object palette window.

Input Parameters:
  hmenubar       : handle to menubar to attach to the window

Output Parameters:
  <none>

Return-Value:

Author: Gerry Seidl

Date Created: 2/10/95

Modified: 10/18/96 - removed label support in favor of tooltips
          01/22/98 - added SMALL-TITLE to palette window
          01/23/98 - use TOP-ONLY on window
---------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER hmenubar AS WIDGET-HANDLE. /* menu bar to attach to window */

{adecomm/oeideservice.i}
{adeuib/sharvars.i}    /* Most common shared variables        */
{adeuib/windvars.i}    /* Window Creation Variables           */
{adeuib/custwidg.i}    /* Custom Widget Definitions           */
{adecomm/adestds.i}    /* ADE standards - defines adeicon/    */

&IF DEFINED(ADEICONDIR) = 0 &THEN
 {adecomm/icondir.i}
&ENDIF

DEFINE VARIABLE ldummy              AS LOGICAL NO-UNDO.
DEFINE VARIABLE init_palette_width  AS INTEGER NO-UNDO.
DEFINE VARIABLE init_palette_height AS INTEGER NO-UNDO.
DEFINE VARIABLE wx                  AS INTEGER NO-UNDO.
DEFINE VARIABLE wy                  AS INTEGER NO-UNDO.
DEFINE VARIABLE itemsrow            AS INTEGER NO-UNDO.

RUN Get_Saved_Settings.

/* defaults */
ASSIGN init_palette_height = {&ImageSize} * TRUNCATE((_palette_count / itemsrow),0)
       init_palette_width  = {&ImageSize} * itemsrow.

CREATE WINDOW _h_object_win
         ASSIGN PARENT             = _h_menu_win
                MENUBAR            = hmenubar
                SMALL-TITLE        = yes
                THREE-D            = yes  
                KEEP-FRAME-Z-ORDER = yes
                X                  = wx
                Y                  = wy
                RESIZE             = YES
                SCROLL-BARS        = FALSE
                WIDTH-PIXELS       = init_palette_width
                HEIGHT-PIXELS      = init_palette_height
                /* Allow resizing down to 1 palette element and up to 
                   everything in one line */
                MAX-WIDTH-PIXELS   = MIN((_palette_count *  ({&ImageSize})),SESSION:WIDTH-P)             
                VIRTUAL-WIDTH-P    = _palette_count *  {&ImageSize}
                /* 7.3A Limitation: Both Windows and Motif won't let Progress
                   windows get too narrow.  So set the maximum height based
                   on a minumum width of 2 columns (This is the initial 
                   layout, so use the initial sizes for this). */
                MIN-WIDTH-PIXELS   = 2 * {&ImageSize}
                MAX-HEIGHT-PIXELS  = init_palette_height
                VIRTUAL-HEIGHT-P   = init_palette_height
                MIN-HEIGHT-PIXELS  = {&ImageSize}
                TITLE              = "Palette"
                MESSAGE-AREA       = FALSE
                STATUS-AREA        = FALSE
                HIDDEN             = TRUE 
             TRIGGERS:
               /* UIB Group Triggers (simulate Main Menu Accelerators) */
               {adeuib/grptrig.i}   
               /* Minimized, and Restored triggers are bound in _uibmain.p. 
                  Handle resizing as a seperate .p. */
               ON WINDOW-RESIZED PERSISTENT RUN adeuib/_rsz_wp.p (INPUT no).                  
             END TRIGGERS.

IF OEIDEIsRunning THEN
DO:
    RUN displayWindow IN hOEIDEService ("com.openedge.pdt.oestudio.views.OEAppBuilderView", "DesignView_" + getProjectName(), _h_object_win).
END.
_h_object_win:LOAD-ICON( {&ADEICON-DIR} + "uib%" + "{&icon-ext}" ) NO-ERROR.

/* jep-icf: Override titlebar icon for ICF. */
IF CAN-DO(_AB_Tools,"Enable-ICF") THEN
    _h_object_win:LOAD-ICON("adeicon/icfdev.ico":U) NO-ERROR.

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
IF _palette_top THEN _h_object_win:TOP-ONLY = TRUE.
&ENDIF

RETURN.

PROCEDURE Get_Saved_Settings.
/* Reads any settings saved the INI/.Xdefaults file for the palette. */
  DEFINE VARIABLE v        AS CHAR    			           NO-UNDO.
  DEFINE VARIABLE sctn     AS CHAR INITIAL "Pro{&UIB_SHORT_NAME}" NO-UNDO.
  DEFINE VARIABLE i        AS INT                                 NO-UNDO.
  
  GET-KEY-VALUE SECTION sctn KEY "PaletteVisualization" VALUE v.
  IF v NE ? THEN
  DO i = 1 TO NUM-ENTRIES(v).
    CASE ENTRY(i,v):
      WHEN "Menu" THEN
        ASSIGN _palette_menu      = yes.
      WHEN "Top-Only" THEN
        ASSIGN _palette_top       = yes.
    END CASE.
  END.
  ELSE
    ASSIGN _palette_menu      = no. 
          
  GET-KEY-VALUE SECTION sctn KEY "PaletteLoc" VALUE v.
  ASSIGN wx = INT(ENTRY(1,v))
         wy = INT(ENTRY(2,v)).
  IF wx = 0 OR wx = ? THEN ASSIGN wx =
    &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN 1  &ELSE 0 &ENDIF.
  IF wy = 0 OR wy = ? THEN ASSIGN wy =
    &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN 30 &ELSE 0 &ENDIF.    
  
  GET-KEY-VALUE SECTION sctn KEY "PaletteItemsPerRow" VALUE v.
  ASSIGN itemsrow = INT(v).
  IF itemsrow = 0 OR itemsrow = ? THEN itemsrow = 1.
END.
                                

